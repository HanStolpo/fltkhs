import Data.Maybe(fromJust)
import Data.List(partition, isPrefixOf)
import Distribution.Simple.Compiler
import Distribution.Simple.Build
import Distribution.Simple.Configure
import Distribution.Simple.LocalBuildInfo
import Distribution.PackageDescription
import Distribution.Simple
import Distribution.System
import Distribution.Simple.Setup
import Distribution.Simple.Utils
import Distribution.Verbosity
import Distribution.Simple.Program(requireProgram, arProgram)
import Distribution.Simple.PreProcess
import System.IO.Unsafe (unsafePerformIO)
import qualified Distribution.Simple.Program.Ar    as Ar
import qualified Distribution.ModuleName as ModuleName
import Distribution.Simple.BuildPaths
import System.Directory(getCurrentDirectory, getDirectoryContents, copyFile, doesDirectoryExist)
import System.FilePath ( (</>), (<.>), takeExtension,
                         takeDirectory, replaceExtension, splitExtension, combine, takeBaseName)
import System.IO
import Debug.Trace
import Data.Graph
import qualified Distribution.Simple.GHC  as GHC
import qualified Distribution.Simple.JHC  as JHC
import qualified Distribution.Simple.LHC  as LHC
import qualified Distribution.Simple.UHC  as UHC
import System.Environment (getEnvironment)
import Distribution.Compat.Exception (catchIO)
import Control.Exception (throwIO)
import System.IO.Error (isDoesNotExistError)

main = defaultMainWithHooks autoconfUserHooks {
         preConf = myPreConf,
         buildHook = myBuildHook,
         cleanHook = myCleanHook,
         copyHook = copyCBindings
       }

handleNoWindowsSH :: IO a -> IO a
handleNoWindowsSH action
    | buildOS /= Windows
    = action

    | otherwise
    = action
        `catchIO` \ioe -> if isDoesNotExistError ioe
                            then die notFoundMsg
                            else throwIO ioe
    where notFoundMsg = "The package has a './configure' script. This requires a "
                        ++ "Unix compatibility toolchain such as MinGW+MSYS or Cygwin."
rawShellSystemExit :: Verbosity -> FilePath -> [String] -> IO ()
rawShellSystemExit v f as = do
    env <- getEnvironment
    rawSystemExitWithEnv v "sh" (f : as) env

myPreConf args flags = do
   putStrLn "Running autoheader ..."
   {-rawSystemExit normal "autoheader" []-}
   rawShellSystemExit normal "autoheader" []
   putStrLn "Running autoconf ..."
   {-rawSystemExit normal "autoconf" []-}
   rawShellSystemExit normal "autoconf" []
   preConf autoconfUserHooks args flags

fltkcdir = unsafePerformIO getCurrentDirectory ++ "/c-lib"
fltkclib = "fltkc"
headerdir = unsafePerformIO getCurrentDirectory ++ "/c-src"
currentdir = unsafePerformIO getCurrentDirectory
getHeaders = unsafePerformIO $ do
  contents <- getDirectoryContents headerdir
  let headerFiles = filter (\f -> takeExtension f == ".h" -- keep the headers
                                  &&
                                  not (takeBaseName f `isPrefixOf` "Derived") -- but not the extra classes
                           ) contents
  return headerFiles
objectFileDir = unsafePerformIO getCurrentDirectory ++ "/static_object_files"
getObjectFileDirContents = getDirectoryContents objectFileDir

addIncludeDirs pd =
  let lib = (fromJust . library) pd
      bi = libBuildInfo lib
      ids = includeDirs bi
      bi' = bi {includeDirs = ids ++ [headerdir, currentdir]}
      lib' = lib {libBuildInfo = bi'}
  in
  pd {library = Just lib'}

addHeaders pd =
  let lib = (fromJust . library) pd
      bi = libBuildInfo lib
      is = includes bi
      headers = getHeaders
      bi' = bi {includes = is ++ headers}
      lib' = lib {libBuildInfo = bi'}
  in
  pd {library = Just lib'}

withFltkc op pd =
  let lib = (fromJust . library) pd
      bi = libBuildInfo lib
      elds = extraLibDirs bi
      els = extraLibs bi
      bi' = bi {extraLibs = els `op` [fltkclib], extraLibDirs = elds `op` [fltkcdir]}
      lib' = lib {libBuildInfo = bi'}
  in
    pd {library = Just lib'}

removeExecutables pd = pd {executables = []}

getHaskellObjects :: Library -> LocalBuildInfo
                  -> FilePath -> String -> Bool -> IO [FilePath]
getHaskellObjects lib lbi pref wanted_obj_ext allow_split_objs
  | splitObjs lbi && allow_split_objs = do
        let splitSuffix = if compilerVersion (compiler lbi) <
                             Version [6, 11] []
                          then "_split"
                          else "_" ++ wanted_obj_ext ++ "_split"
            dirs = [ pref </> (ModuleName.toFilePath x ++ splitSuffix)
                   | x <- libModules lib ]
        objss <- mapM getDirectoryContents dirs
        let objs = [ dir </> obj
                   | (objs',dir) <- zip objss dirs, obj <- objs',
                     let obj_ext = takeExtension obj,
                     '.':wanted_obj_ext == obj_ext ]
        return objs
  | otherwise  =
        return [ pref </> ModuleName.toFilePath x <.> wanted_obj_ext
               | x <- libModules lib ]

-- This copy-pasta is required because Distribution.Simple.Build does
-- not export buildExe.
buildExe :: Verbosity -> Distribution.Simple.Setup.Flag (Maybe Int)
                      -> PackageDescription -> LocalBuildInfo
                      -> Executable         -> ComponentLocalBuildInfo -> IO ()
buildExe verbosity numJobs pkg_descr lbi exe clbi =
  case compilerFlavor (compiler lbi) of
    GHC  -> GHC.buildExe  verbosity numJobs pkg_descr lbi exe clbi
    JHC  -> JHC.buildExe  verbosity         pkg_descr lbi exe clbi
    LHC  -> LHC.buildExe  verbosity         pkg_descr lbi exe clbi
    UHC  -> UHC.buildExe  verbosity         pkg_descr lbi exe clbi
    _    -> die "Building is not supported with this compiler."

myBuildHook pkg_descr local_bld_info user_hooks bld_flags =
  do fltkcBuilt <- doesDirectoryExist fltkcdir
     if not fltkcBuilt then
       do putStrLn "==Compiling C bindings=="
          rawSystemExit normal "make" ["src"]
       else return ()
     -- (buildHook autoconfUserHooks) pkg_descr local_bld_info user_hooks bld_flags
     let new_pkg_descr
           = removeExecutables . addHeaders . addIncludeDirs . withFltkc (++) $ pkg_descr
         new_local_bld_info = local_bld_info{localPkgDescr = new_pkg_descr}
         (libs, nonlibs)
           = partition
               (\ c ->
                  case c of
                      (CLibName, _, _) -> True
                      _ -> False)
               (componentsConfigs new_local_bld_info)
         lib_lbi = new_local_bld_info{componentsConfigs = libs}
     buildHook autoconfUserHooks new_pkg_descr lib_lbi user_hooks bld_flags
     let distPref = fromFlag (buildDistPref bld_flags)
         dbFile = distPref </> "package.conf.inplace"
         verbosity = fromFlag (buildVerbosity bld_flags)
         with_in_place
           = local_bld_info{withPackageDB =
                              withPackageDB local_bld_info ++ [SpecificPackageDB dbFile]}
         pref = buildDir local_bld_info
     withAllComponentsInBuildOrder pkg_descr with_in_place $
       \ comp clbi ->
         case comp of
             (CLib lib) -> do cobjs <- getObjectFileDirContents >>=
                                         return .
                                           map (combine objectFileDir) .
                                             filter (\ f -> takeExtension f == ".o")
                              hobjs <- getHaskellObjects lib with_in_place pref objExtension True
                              let staticObjectFiles = hobjs ++ cobjs
                              (arProg, _ ) <- requireProgram verbosity arProgram
                                               (withPrograms with_in_place)
                              let vanillaLibFilePath
                                    = pref </> mkLibName (head $ componentLibraries clbi)
                              Ar.createArLibArchive verbosity with_in_place vanillaLibFilePath
                                staticObjectFiles
             (CExe exe) -> do preprocessComponent pkg_descr comp
                                with_in_place
                                False
                                verbosity
                                []
                              buildExe verbosity (buildNumJobs bld_flags) pkg_descr
                                with_in_place
                                exe
                                clbi
             _ -> return ()

copyCBindings :: PackageDescription -> LocalBuildInfo -> UserHooks -> CopyFlags -> IO ()
copyCBindings pkg_descr lbi uhs flags = do
    (copyHook autoconfUserHooks) pkg_descr lbi uhs flags
    let libPref = libdir . absoluteInstallDirs pkg_descr lbi
                . fromFlag . copyDest
                $ flags
    rawSystemExit (fromFlag $ copyVerbosity flags) "cp"
        ["c-lib/libfltkc.a", libPref]
    case buildOS of
     Linux -> rawSystemExit (fromFlag $ copyVerbosity flags) "cp"
              ["c-lib/libfltkc.so", libPref]
     _ -> return ()

myCleanHook pd x uh cf = do
  rawSystemExit normal "make" ["clean"]
  cleanHook autoconfUserHooks pd x uh cf
