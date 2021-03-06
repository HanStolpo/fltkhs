{-# LANGUAGE CPP, ExistentialQuantification, TypeSynonymInstances, FlexibleInstances, MultiParamTypeClasses, FlexibleContexts, UndecidableInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Graphics.UI.FLTK.LowLevel.Fl_Menu_Item
  (
   menuItemNew,
   MenuItemIndex(..),
   MenuItemName(..),
   MenuItemPointer(..),
   MenuItemReference(..),
   MenuItemLocator(..)
  )
where
#include "Fl_ExportMacros.h"
#include "Fl_Types.h"
#include "Fl_Menu_ItemC.h"
import C2HS hiding (cFromEnum, cFromBool, cToBool,cToEnum)
import Graphics.UI.FLTK.LowLevel.Fl_Enumerations
import Graphics.UI.FLTK.LowLevel.Fl_Types
import Graphics.UI.FLTK.LowLevel.Utils
import Graphics.UI.FLTK.LowLevel.Hierarchy
import Graphics.UI.FLTK.LowLevel.Dispatch
import Graphics.UI.FLTK.LowLevel.Fl_Widget

newtype MenuItemIndex = MenuItemIndex Int
data MenuItemPointer = forall a. (Parent a MenuItem) => MenuItemPointer (Ref a)
newtype MenuItemName = MenuItemName String
data MenuItemReference = MenuItemByIndex MenuItemIndex | MenuItemByPointer MenuItemPointer
data MenuItemLocator = MenuItemPointerLocator MenuItemPointer | MenuItemNameLocator MenuItemName

{# fun unsafe Fl_Menu_Item_New as new' { } -> `Ptr ()' id #}
menuItemNew :: IO (Ref MenuItem)
menuItemNew = new' >>= toRef

{# fun unsafe Fl_Menu_Item_Destroy as destroy' { id `Ptr ()' } -> `()' id #}
instance (impl ~ IO ()) => Op (Destroy ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> destroy' menu_itemPtr

{# fun unsafe Fl_Menu_Item_next_with_step as nextWithStep' { id `Ptr ()',`Int' } -> `Ptr ()' id #}
instance (Parent a MenuItem, impl ~ (Int -> IO (Ref a))) => Op (NextWithStep ()) MenuItem orig impl where
  runOp _ _ menu_item step =
    withRef menu_item $ \menu_itemPtr -> nextWithStep' menu_itemPtr step >>= toRef

{# fun unsafe Fl_Menu_Item_next as next' { id `Ptr ()' } -> `Ptr ()' id #}
instance (impl ~  IO (Ptr ())) => Op (Next ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> next' menu_itemPtr

{# fun unsafe Fl_Menu_Item_first as first' { id `Ptr ()' } -> `Ptr ()' id #}
instance (impl ~  IO (Ptr ())) => Op (GetFirst ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> first' menu_itemPtr

{# fun unsafe Fl_Menu_Item_label as label' { id `Ptr ()' } -> `String' #}
instance (impl ~  IO (String)) => Op (GetLabel ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> label' menu_itemPtr

{# fun unsafe Fl_Menu_Item_set_label as setLabel' { id `Ptr ()',`String' } -> `()' #}
instance (impl ~ (String ->  IO ())) => Op (SetLabel ()) MenuItem orig impl where
  runOp _ _ menu_item a = withRef menu_item $ \menu_itemPtr -> setLabel' menu_itemPtr a

{# fun unsafe Fl_Menu_Item_set_label_with_labeltype as setLabelWithLabeltype' { id `Ptr ()',cFromEnum `Labeltype',`String' } -> `()' #}
instance (impl ~ (Labeltype -> String ->  IO ())) => Op (SetLabelWithLabeltype ()) MenuItem orig impl where
  runOp _ _ menu_item labeltype b = withRef menu_item $ \menu_itemPtr -> setLabelWithLabeltype' menu_itemPtr labeltype b

{# fun unsafe Fl_Menu_Item_labeltype as labeltype' { id `Ptr ()' } -> `Labeltype' cToEnum #}
instance (impl ~  IO (Labeltype)) => Op (GetLabeltype ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> labeltype' menu_itemPtr

{# fun unsafe Fl_Menu_Item_set_labeltype as setLabeltype' { id `Ptr ()',cFromEnum `Labeltype' } -> `()' #}
instance (impl ~ (Labeltype ->  IO ())) => Op (SetLabeltype ()) MenuItem orig impl where
  runOp _ _ menu_item a = withRef menu_item $ \menu_itemPtr -> setLabeltype' menu_itemPtr a

{# fun unsafe Fl_Menu_Item_labelcolor as labelcolor' { id `Ptr ()' } -> `Color' cToColor #}
instance (impl ~  IO (Color)) => Op (GetLabelcolor ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> labelcolor' menu_itemPtr

{# fun unsafe Fl_Menu_Item_set_labelcolor as setLabelcolor' { id `Ptr ()',cFromColor `Color' } -> `()' #}
instance (impl ~ (Color ->  IO ())) => Op (SetLabelcolor ()) MenuItem orig impl where
  runOp _ _ menu_item a = withRef menu_item $ \menu_itemPtr -> setLabelcolor' menu_itemPtr a

{# fun unsafe Fl_Menu_Item_labelfont as labelfont' { id `Ptr ()' } -> `Font' cToFont #}
instance (impl ~  IO (Font)) => Op (GetLabelfont ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> labelfont' menu_itemPtr

{# fun unsafe Fl_Menu_Item_set_labelfont as setLabelfont' { id `Ptr ()',cFromFont `Font' } -> `()' #}
instance (impl ~ (Font ->  IO ())) => Op (SetLabelfont ()) MenuItem orig impl where
  runOp _ _ menu_item a = withRef menu_item $ \menu_itemPtr -> setLabelfont' menu_itemPtr a

{# fun unsafe Fl_Menu_Item_labelsize as labelsize' { id `Ptr ()' } -> `CInt' id #}
instance (impl ~  IO (FontSize)) => Op (GetLabelsize ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> labelsize' menu_itemPtr >>= return . FontSize

{# fun unsafe Fl_Menu_Item_set_labelsize as setLabelsize' { id `Ptr ()', id `CInt' } -> `()' #}
instance (impl ~ (FontSize ->  IO ())) => Op (SetLabelsize ()) MenuItem  orig impl where
  runOp _ _ menu_item (FontSize pix) = withRef menu_item $ \menu_itemPtr -> setLabelsize' menu_itemPtr pix

{# fun Fl_Menu_Item_set_callback as setCallback' { id `Ptr ()', id `FunPtr CallbackWithUserDataPrim'} -> `()' #}
instance (impl ~ ((Ref orig -> IO ()) -> IO ()) ) => Op (SetCallback ()) MenuItem orig impl where
  runOp _ _ menu_item c = withRef menu_item $ \menu_itemPtr -> do
                                    ptr <- toCallbackPrim c
                                    setCallback' menu_itemPtr (castFunPtr ptr)

{# fun unsafe Fl_Menu_Item_shortcut as shortcut' { id `Ptr ()' } -> `Int' #}
instance (impl ~  IO (Int)) => Op (GetShortcut ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> shortcut' menu_itemPtr

{# fun unsafe Fl_Menu_Item_set_shortcut as setShortcut' { id `Ptr ()',`Int' } -> `()' #}
instance (impl ~ (Int ->  IO ())) => Op (SetShortcut ()) MenuItem orig impl where
  runOp _ _ menu_item s = withRef menu_item $ \menu_itemPtr -> setShortcut' menu_itemPtr s

{# fun unsafe Fl_Menu_Item_submenu as submenu' { id `Ptr ()' } -> `Int' #}
instance (impl ~  IO (Int)) => Op (Submenu ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> submenu' menu_itemPtr

{# fun unsafe Fl_Menu_Item_checkbox as checkbox' { id `Ptr ()' } -> `Int' #}
instance (impl ~  IO (Int)) => Op (Checkbox ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> checkbox' menu_itemPtr

{# fun unsafe Fl_Menu_Item_radio as radio' { id `Ptr ()' } -> `Int' #}
instance (impl ~  IO (Int)) => Op (Radio ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> radio' menu_itemPtr

{# fun unsafe Fl_Menu_Item_value as value' { id `Ptr ()' } -> `Int' #}
instance (impl ~  IO (Int)) => Op (GetValue ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> value' menu_itemPtr

{# fun unsafe Fl_Menu_Item_set as set' { id `Ptr ()' } -> `()' #}
instance (impl ~  IO ()) => Op (Set ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> set' menu_itemPtr

{# fun unsafe Fl_Menu_Item_clear as clear' { id `Ptr ()' } -> `()' #}
instance (impl ~  IO ()) => Op (Clear ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> clear' menu_itemPtr

{# fun unsafe Fl_Menu_Item_setonly as setonly' { id `Ptr ()' } -> `()' #}
instance (impl ~  IO ()) => Op (Setonly ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> setonly' menu_itemPtr

{# fun unsafe Fl_Menu_Item_visible as visible' { id `Ptr ()' } -> `Int' #}
instance (impl ~  IO (Int)) => Op (Visible ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> visible' menu_itemPtr

{# fun unsafe Fl_Menu_Item_show as show' { id `Ptr ()' } -> `()' #}
instance (impl ~  IO ()) => Op (ShowWidget ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> show' menu_itemPtr

{# fun unsafe Fl_Menu_Item_hide as hide' { id `Ptr ()' } -> `()' #}
instance (impl ~  IO ()) => Op (Hide ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> hide' menu_itemPtr

{# fun unsafe Fl_Menu_Item_active as active' { id `Ptr ()' } -> `Int' #}
instance (impl ~  IO (Int)) => Op (Active ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> active' menu_itemPtr

{# fun unsafe Fl_Menu_Item_activate as activate' { id `Ptr ()' } -> `()' #}
instance (impl ~  IO ()) => Op (Activate ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> activate' menu_itemPtr

{# fun unsafe Fl_Menu_Item_deactivate as deactivate' { id `Ptr ()' } -> `()' #}
instance (impl ~  IO ()) => Op (Deactivate ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> deactivate' menu_itemPtr

{# fun unsafe Fl_Menu_Item_activevisible as activevisible' { id `Ptr ()' } -> `Int' #}
instance (impl ~  IO (Int)) => Op (Activevisible ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> activevisible' menu_itemPtr

{# fun unsafe Fl_Menu_Item_measure as measure' { id `Ptr ()',alloca- `Int' peekIntConv*,id `Ptr ()' } -> `Int' #}
instance (Parent a MenuPrim, impl ~ (Ref a ->  IO (Int,Int))) => Op (Measure ()) MenuItem orig impl where
  runOp _ _ menu_item menu' = withRef menu_item $ \menu_itemPtr -> withRef menu' $ \menuPtr -> measure' menu_itemPtr menuPtr

{# fun unsafe Fl_Menu_Item_draw_with_t as drawWithT' { id `Ptr ()',`Int',`Int',`Int',`Int',id `Ptr ()',`Int' } -> `()' #}
instance (Parent a MenuPrim, impl ~ (Rectangle -> Ref a -> Int ->  IO ())) => Op (DrawWithT ()) MenuItem orig impl where
  runOp _ _ menu_item rectangle menu' t =
    let (x_pos', y_pos', width', height') = fromRectangle rectangle in
    withRef menu_item $ \menu_itemPtr -> withRef menu' $ \menuPtr -> drawWithT' menu_itemPtr x_pos' y_pos' width' height' menuPtr t

{# fun unsafe Fl_Menu_Item_draw as draw' { id `Ptr ()',`Int',`Int',`Int',`Int',id `Ptr ()' } -> `()' #}
instance (Parent a MenuPrim, impl ~ (Rectangle -> Ref a ->  IO ())) => Op (Draw ()) MenuItem orig impl where
  runOp _ _ menu_item rectangle menu' =
    let (x_pos', y_pos', width', height') = fromRectangle rectangle in
    withRef menu_item $ \menu_itemPtr ->
    withRef menu' $ \menuPtr -> draw' menu_itemPtr x_pos' y_pos' width' height' menuPtr

{# fun unsafe Fl_Menu_Item_flags as flags' { id `Ptr ()' } -> `Int' #}
instance (impl ~  IO (Int)) => Op (GetFlags ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> flags' menu_itemPtr

{# fun unsafe Fl_Menu_Item_set_flags as setFlags' { id `Ptr ()',`Int' } -> `()' #}
instance (impl ~ (Int ->  IO ())) => Op (SetFlags ()) MenuItem orig impl where
  runOp _ _ menu_item flags = withRef menu_item $ \menu_itemPtr -> setFlags' menu_itemPtr flags

{# fun unsafe Fl_Menu_Item_text as text' { id `Ptr ()' } -> `String' #}
instance (impl ~ ( IO (String))) => Op (GetText ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> text' menu_itemPtr

{# fun unsafe Fl_Menu_Item_pulldown_with_args as pulldownWithArgs' { id `Ptr ()',`Int',`Int',`Int',`Int',id `Ptr ()', id `Ptr ()', id `Ptr ()', fromBool `Bool'} -> `Ptr ()' id #}
instance (Parent a MenuPrim, Parent b MenuItem, Parent c MenuItem, impl ~ (Rectangle -> Maybe (Ref a) -> Maybe (Ref b) -> Maybe (Ref c) -> Maybe Bool -> IO (Ref MenuItem))) => Op (Pulldown ()) MenuItem orig impl where
  runOp _ _ menu_item rectangle picked' template_menu title menu_barFlag =
    let (x_pos, y_pos, width, height) = fromRectangle rectangle
        menu_bar = maybe False id menu_barFlag
    in
     withRef menu_item $ \menu_itemPtr ->
     withMaybeRef picked' $ \pickedPtr ->
     withMaybeRef template_menu $ \template_menuPtr ->
     withMaybeRef title $ \titlePtr ->
     pulldownWithArgs' menu_itemPtr x_pos y_pos width height pickedPtr template_menuPtr titlePtr menu_bar >>= toRef

{# fun unsafe Fl_Menu_Item_popup_with_args as popupWithArgs' { id `Ptr ()',`Int',`Int', id `Ptr CChar' , id `Ptr ()', id `Ptr ()'} -> `Ptr ()' id #}
instance (Parent a MenuItem, Parent b MenuPrim, Parent c MenuItem, impl ~ (Position -> Maybe String -> Maybe (Ref a) -> Maybe (Ref b) -> IO (Ref c))) => Op (Popup ()) MenuItem orig impl where
  runOp _ _ menu_item (Position (X x_pos) (Y y_pos)) title picked' template_menu =
    withRef menu_item $ \menu_itemPtr ->
    withMaybeRef picked' $ \pickedPtr ->
    withMaybeRef template_menu $ \template_menuPtr ->
    maybeNew newCString title >>= \titlePtr ->
    popupWithArgs' menu_itemPtr x_pos y_pos titlePtr pickedPtr template_menuPtr >>= toRef

{# fun unsafe Fl_Menu_Item_test_shortcut as testShortcut' { id `Ptr ()' } -> `Ptr ()' id #}
instance (Parent a MenuItem, impl ~ ( IO (Ref a))) => Op (TestShortcut ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> testShortcut' menu_itemPtr >>= toRef

{# fun unsafe Fl_Menu_Item_find_shortcut_with_ip_require_alt as findShortcutWithIpRequireAlt' { id `Ptr ()',id `Ptr CInt',`Bool' } -> `Ptr ()' id #}
instance (Parent a MenuItem, impl ~ (Maybe Int -> Bool -> IO (Ref a))) => Op (FindShortcut ()) MenuItem orig impl where
  runOp _ _ menu_item index' require_alt =
    withRef menu_item $ \menu_itemPtr ->
        maybeNew (new . fromIntegral) index' >>= \index_Ptr ->
            findShortcutWithIpRequireAlt' menu_itemPtr index_Ptr require_alt >>= toRef

{# fun unsafe Fl_Menu_Item_do_callback as doCallback' { id `Ptr ()',id `Ptr ()' } -> `()' #}
instance (impl ~ (Ref Widget  ->  IO ())) => Op (DoCallback ()) MenuItem orig impl where
  runOp _ _ menu_item o = withRef menu_item $ \menu_itemPtr -> withRef o $ \oPtr -> doCallback' menu_itemPtr oPtr

{# fun Fl_Menu_Item_insert_with_flags as insertWithFlags' { id `Ptr ()',`Int',`String',id `CInt',id `FunPtr CallbackWithUserDataPrim',`Int'} -> `Int' #}
{# fun Fl_Menu_Item_add_with_flags as addWithFlags' { id `Ptr ()',`String',id `CInt',id `FunPtr CallbackWithUserDataPrim',`Int'} -> `Int' #}
{# fun Fl_Menu_Item_add_with_shortcutname_flags as addWithShortcutnameFlags' { id `Ptr ()',`String',`String',id `FunPtr CallbackWithUserDataPrim',`Int' } -> `Int' #}
instance (Parent a MenuItem, impl ~ (String -> Maybe Shortcut -> (Ref a -> IO ()) -> [MenuProps] -> IO (Int))) => Op (Add ()) MenuItem orig impl where
  runOp _ _ menu_item name shortcut cb flags =
    withRef menu_item $ \menu_itemPtr -> do
      let combinedFlags = foldl1WithDefault 0 (.|.) (map fromEnum flags)
      ptr <- toCallbackPrim cb
      case shortcut of
       Just s' -> case s' of
         KeySequence ks ->
           addWithFlags'
           menu_itemPtr
           name
           (keySequenceToCInt ks)
           (castFunPtr ptr)
           combinedFlags
         KeyFormat format' ->
           if (not $ null format') then
             addWithShortcutnameFlags'
             menu_itemPtr
             name
             format'
             (castFunPtr ptr)
             combinedFlags
           else error "menuItemAdd: shortcut format string cannot be empty"
       Nothing ->
          addWithFlags'
           menu_itemPtr
           name
           0
           (castFunPtr ptr)
           combinedFlags

instance (Parent a MenuItem, impl ~ (Int -> String -> Maybe ShortcutKeySequence -> (Ref a -> IO ()) -> [MenuProps] -> IO (Int))) => Op (Insert ()) MenuItem orig impl where
  runOp _ _ menu_item index' name ks cb flags =
    withRef menu_item $ \menu_itemPtr ->
                            let combinedFlags = foldl1WithDefault 0 (.|.) (map fromEnum flags)
                                shortcutCode = maybe 0 keySequenceToCInt ks
                            in do
                              ptr <- toCallbackPrim cb
                              insertWithFlags'
                                menu_itemPtr
                                index'
                                name
                                shortcutCode
                                (castFunPtr ptr)
                                combinedFlags

{# fun unsafe Fl_Menu_Item_size as size' { id `Ptr ()' } -> `Int' #}
instance (impl ~ ( IO (Int))) => Op (GetSize ()) MenuItem orig impl where
  runOp _ _ menu_item = withRef menu_item $ \menu_itemPtr -> size' menu_itemPtr
