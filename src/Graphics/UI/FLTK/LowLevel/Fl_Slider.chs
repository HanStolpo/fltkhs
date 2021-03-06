{-# LANGUAGE CPP, TypeSynonymInstances, FlexibleInstances, MultiParamTypeClasses, FlexibleContexts #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Graphics.UI.FLTK.LowLevel.Fl_Slider
    (
     sliderNew
    )
where
#include "Fl_ExportMacros.h"
#include "Fl_Types.h"
#include "Fl_SliderC.h"
import C2HS hiding (cFromEnum, cFromBool, cToBool,cToEnum)
import Foreign.C.Types
import Graphics.UI.FLTK.LowLevel.Fl_Enumerations
import Graphics.UI.FLTK.LowLevel.Fl_Types
import Graphics.UI.FLTK.LowLevel.Utils
import Graphics.UI.FLTK.LowLevel.Dispatch
import Graphics.UI.FLTK.LowLevel.Hierarchy

{# fun Fl_Slider_New as sliderNew' { `Int',`Int',`Int',`Int' } -> `Ptr ()' id #}
{# fun Fl_Slider_New_WithLabel as sliderNewWithLabel' { `Int',`Int',`Int',`Int',`String'} -> `Ptr ()' id #}
sliderNew :: Rectangle -> Maybe String -> IO (Ref Slider)
sliderNew rectangle l' =
    let (x_pos, y_pos, width, height) = fromRectangle rectangle
    in case l' of
        Nothing -> sliderNew' x_pos y_pos width height >>=
                             toRef
        Just l -> sliderNewWithLabel' x_pos y_pos width height l >>=
                             toRef

{# fun Fl_Slider_Destroy as sliderDestroy' { id `Ptr ()' } -> `()' supressWarningAboutRes #}
instance (impl ~ (IO ())) => Op (Destroy ()) Slider orig impl where
  runOp _ _ win = swapRef win $ \winPtr -> do
                                        sliderDestroy' winPtr
                                        return nullPtr
{#fun Fl_Slider_handle as sliderHandle' { id `Ptr ()', id `CInt' } -> `Int' #}
instance (impl ~ (Event -> IO Int)) => Op (Handle ()) Slider orig impl where
  runOp _ _ slider event = withRef slider (\p -> sliderHandle' p (fromIntegral . fromEnum $ event))
{# fun unsafe Fl_Slider_bounds as bounds' { id `Ptr ()',`Double',`Double' } -> `()' supressWarningAboutRes #}
instance (impl ~ (Double -> Double ->  IO ())) => Op (GetBounds ()) Slider orig impl where
  runOp _ _ slider a b = withRef slider $ \sliderPtr -> bounds' sliderPtr a b
{# fun unsafe Fl_Slider_scrollvalue as scrollvalue' { id `Ptr ()',`Int',`Int',`Int',`Int' } -> `Int' #}
instance (impl ~ (Int -> Int -> Int -> Int ->  IO (Int))) => Op (Scrollvalue ()) Slider orig impl where
  runOp _ _ slider pos slider_size first total = withRef slider $ \sliderPtr -> scrollvalue' sliderPtr pos slider_size first total
{# fun unsafe Fl_Slider_set_slider_size as setSliderSize' { id `Ptr ()' } -> `Float' #}
instance (impl ~ ( IO (Float))) => Op (SetSliderSize ()) Slider orig impl where
  runOp _ _ slider = withRef slider $ \sliderPtr -> setSliderSize' sliderPtr
{# fun unsafe Fl_Slider_slider_size as sliderSize' { id `Ptr ()',`Double' } -> `()' supressWarningAboutRes #}
instance (impl ~ (Double ->  IO ())) => Op (GetSliderSize ()) Slider orig impl where
  runOp _ _ slider v = withRef slider $ \sliderPtr -> sliderSize' sliderPtr v
{# fun unsafe Fl_Slider_slider as slider' { id `Ptr ()' } -> `Boxtype' cToEnum #}
instance (impl ~ ( IO (Boxtype))) => Op (GetSlider ()) Slider orig impl where
  runOp _ _ slider = withRef slider $ \sliderPtr -> slider' sliderPtr
{# fun unsafe Fl_Slider_set_slider as setSlider' { id `Ptr ()',cFromEnum `Boxtype' } -> `()' supressWarningAboutRes #}
instance (impl ~ (Boxtype ->  IO ())) => Op (SetSlider ()) Slider orig impl where
  runOp _ _ slider c = withRef slider $ \sliderPtr -> setSlider' sliderPtr c
