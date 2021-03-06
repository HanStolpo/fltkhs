{-# LANGUAGE CPP, ExistentialQuantification, TypeSynonymInstances, FlexibleInstances, MultiParamTypeClasses, FlexibleContexts, ScopedTypeVariables #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Graphics.UI.FLTK.LowLevel.Fl_Scrollbar
    (
     -- * Constructor
     scrollbarNew,
    )
where
#include "Fl_ExportMacros.h"
#include "Fl_Types.h"
#include "Fl_ScrollbarC.h"
import C2HS hiding (cFromEnum, cFromBool, cToBool,cToEnum)
import Foreign.C.Types
import Graphics.UI.FLTK.LowLevel.Fl_Enumerations
import Graphics.UI.FLTK.LowLevel.Fl_Types
import Graphics.UI.FLTK.LowLevel.Utils
import Graphics.UI.FLTK.LowLevel.Hierarchy
import Graphics.UI.FLTK.LowLevel.Dispatch

{# fun Fl_Scrollbar_New as scrollbarNew' { `Int',`Int',`Int',`Int' } -> `Ptr ()' id #}
{# fun Fl_Scrollbar_New_WithLabel as scrollbarNewWithLabel' { `Int',`Int',`Int',`Int',`String'} -> `Ptr ()' id #}
scrollbarNew :: Rectangle -> Maybe String -> IO (Ref Scrollbar)
scrollbarNew rectangle l'=
    let (x_pos, y_pos, width, height) = fromRectangle rectangle
    in case l' of
        Nothing -> scrollbarNew' x_pos y_pos width height >>=
                             toRef
        Just l -> scrollbarNewWithLabel' x_pos y_pos width height l >>=
                               toRef

{# fun Fl_Scrollbar_Destroy as scrollbarDestroy' { id `Ptr ()' } -> `()' supressWarningAboutRes #}
instance (impl ~ (IO ())) => Op (Destroy ()) Scrollbar orig impl where
  runOp _ _ win = swapRef win $ \winPtr -> do
    scrollbarDestroy' winPtr
    return nullPtr

{# fun unsafe Fl_Scrollbar_scrollvalue as scrollvalue' { id `Ptr ()',`Int',`Int',`Int',`Int' } -> `Int' #}
instance (impl ~ (Int -> Int -> Int -> Int ->  IO (Int))) => Op (SetValue ()) Scrollbar orig impl where
  runOp _ _ slider pos size first total = withRef slider $ \sliderPtr -> scrollvalue' sliderPtr pos size first total

{# fun unsafe Fl_Scrollbar_set_linesize as setLinesize' { id `Ptr ()',`Int' } -> `()' #}
instance (impl ~ (LineSize ->  IO ())) => Op (SetLinesize ()) Scrollbar orig impl where
  runOp _ _ slider (LineSize i) = withRef slider $ \sliderPtr -> setLinesize' sliderPtr i

{# fun unsafe Fl_Scrollbar_linesize as linesize' { id `Ptr ()' } -> `Int' #}
instance (impl ~ ( IO LineSize)) => Op (GetLinesize ()) Scrollbar orig impl where
  runOp _ _ slider = withRef slider $ \sliderPtr -> linesize' sliderPtr >>= return . LineSize

{#fun Fl_Scrollbar_handle as scrollbarHandle'
      { id `Ptr ()', id `CInt' } -> `Int' #}
instance (impl ~ (Event -> IO Int)) => Op (Handle ()) Scrollbar orig impl where
  runOp _ _ scrollbar event = withRef scrollbar (\p -> scrollbarHandle' p (fromIntegral . fromEnum $ event))
