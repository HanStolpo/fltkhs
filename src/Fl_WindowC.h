#ifndef __FL_WINDOW_C__
#define __FL_WINDOW_C__
#include "FL/Fl.H"
#include "FL/Fl_Window.H" // always include the FL/*.H headers before local headers
                          // Fl_Widget is included transitively and needed for
                          // the callback mechanism included below to work.
#include "Fl_CallbackC.h"
#ifdef __cplusplus
EXPORT {
#endif
  /* Inherited from Fl_Widget */
  FL_EXPORT_C(fl_Group,     Fl_Window_parent)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_parent)(fl_Window win, fl_Group grp);
  FL_EXPORT_C(uchar,        Fl_Window_type)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_type)(fl_Window win, uchar t);
  FL_EXPORT_C(int,          Fl_Window_x)(fl_Window win);
  FL_EXPORT_C(int,          Fl_Window_y)(fl_Window win);
  FL_EXPORT_C(int,          Fl_Window_w)(fl_Window win);
  FL_EXPORT_C(int,          Fl_Window_h)(fl_Window win);
  FL_EXPORT_C(Fl_Align,     Fl_Window_align)(fl_Window win);
  FL_EXPORT_C(Fl_Boxtype,   Fl_Window_box)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_box)(fl_Window win, Fl_Boxtype new_box);
  FL_EXPORT_C(Fl_Color,     Fl_Window_color)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_color)(fl_Window win, Fl_Color bg);
  FL_EXPORT_C(void,         Fl_Window_set_background_and_selection_color)(fl_Window win,Fl_Color bg, Fl_Color a);
  FL_EXPORT_C(Fl_Color,     Fl_Window_selection_color)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_selection_color)(fl_Window win, Fl_Color a);
  FL_EXPORT_C(const char*,  Fl_Window_label)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_copy_label)(fl_Window win, const char* new_label);
  FL_EXPORT_C(void,         Fl_Window_set_label)(fl_Window win, const char* text);
  FL_EXPORT_C(Fl_Labeltype, Fl_Window_labeltype)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_labeltype)(fl_Window win, Fl_Labeltype a);
  FL_EXPORT_C(Fl_Color,     Fl_Window_labelcolor)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_labelcolor)(fl_Window win, Fl_Color c);
  FL_EXPORT_C(Fl_Font,      Fl_Window_labelfont)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_labelfont)(fl_Window win, Fl_Font c);
  FL_EXPORT_C(Fl_Fontsize,  Fl_Window_labelsize)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_labelsize)(fl_Window win, Fl_Fontsize pix);
  FL_EXPORT_C(fl_Image,     Fl_Window_image)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_image)(fl_Window win, fl_Image pix);
  FL_EXPORT_C(fl_Image,     Fl_Window_deimage)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_deimage)(fl_Window win, fl_Image pix);
  FL_EXPORT_C(const char*,  Fl_Window_tooltip)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_copy_tooltip)(fl_Window win, const char* text);
  FL_EXPORT_C(void,         Fl_Window_set_tooltip)(fl_Window win, const char* text);
  FL_EXPORT_C(void,         Fl_Window_set_callback_and_user_data)(fl_Window win, fl_Callback* cb, void* p);
  FL_EXPORT_C(void,         Fl_Window_set_callback)(fl_Window win, fl_Callback* cb);
  FL_EXPORT_C(void*,        Fl_Window_user_data)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_user_data)(fl_Window win, void* v);
  FL_EXPORT_C(long,         Fl_Window_argument)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_argument)(fl_Window win, long v);
  FL_EXPORT_C(Fl_When,      Fl_Window_when)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_when)(fl_Window win, uchar i);
  FL_EXPORT_C(unsigned int, Fl_Window_visible)(fl_Window win);
  FL_EXPORT_C(int,          Fl_Window_visible_r)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_visible)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_clear_visible)(fl_Window win);
  FL_EXPORT_C(unsigned int, Fl_Window_active)(fl_Window win);
  FL_EXPORT_C(int,          Fl_Window_active_r)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_activate)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_deactivate)(fl_Window win);
  FL_EXPORT_C(unsigned int, Fl_Window_output)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_output)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_clear_output)(fl_Window win);
  FL_EXPORT_C(unsigned int, Fl_Window_takesevents)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_changed)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_clear_changed)(fl_Window win);
  FL_EXPORT_C(int,          Fl_Window_take_focus)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_visible_focus)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_clear_visible_focus)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_modify_visible_focus)(fl_Window win, int v);
  FL_EXPORT_C(unsigned int, Fl_Window_visible_focus)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_do_callback)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_do_callback_with_widget_and_user_data)(fl_Window win, fl_Widget w, long arg);
  FL_EXPORT_C(void,         Fl_Window_do_callback_with_widget_and_default_user_data)(fl_Window win, fl_Widget w);
  FL_EXPORT_C(int,          Fl_Window_contains)(fl_Window win, fl_Widget w);
  FL_EXPORT_C(int,          Fl_Window_inside)(fl_Window win, fl_Widget w);
  FL_EXPORT_C(void,         Fl_Window_redraw)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_redraw_label)(fl_Window win);
  FL_EXPORT_C(uchar,        Fl_Window_damage)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_clear_damage_with_bitmask)(fl_Window win, uchar c);
  FL_EXPORT_C(void,         Fl_Window_clear_damage)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_damage_with_text)(fl_Window win, uchar c);
  FL_EXPORT_C(void,         Fl_Window_damage_inside_widget)(fl_Window win, uchar c, int x , int y , int w, int h);
  FL_EXPORT_C(void,         Fl_Window_draw_label)(fl_Window win, int x , int y , int w, int h, Fl_Align alignment);
  FL_EXPORT_C(void,         Fl_Window_measure_label)(fl_Window win, int& ww , int& hh);
  FL_EXPORT_C(fl_Group,     Fl_Window_as_group)(fl_Window win);
  FL_EXPORT_C(fl_Gl_Window, Fl_Window_as_gl_window)(fl_Window win);

  /* Inherited from Fl_Group */
  FL_EXPORT_C(void,         Fl_Window_begin)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_end)(fl_Window win);
  FL_EXPORT_C(int,          Fl_Window_find)(fl_Window win, fl_Widget w);
  FL_EXPORT_C(void,         Fl_Window_add)(fl_Window win, fl_Widget w);
  FL_EXPORT_C(void,         Fl_Window_insert)(fl_Window win, fl_Widget w, int i);
  FL_EXPORT_C(void,         Fl_Window_remove_index)(fl_Window win, int index);
  FL_EXPORT_C(void,         Fl_Window_remove_widget)(fl_Window win, fl_Widget w);
  FL_EXPORT_C(void,         Fl_Window_clear)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_resizable_by_reference)(fl_Window win,fl_Widget o);
  FL_EXPORT_C(void,         Fl_Window_set_resizable)(fl_Window win,fl_Widget o);
  FL_EXPORT_C(fl_Widget,    Fl_Window_resizable)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_add_resizable)(fl_Window win,fl_Widget o);
  FL_EXPORT_C(void,         Fl_Window_init_sizes)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_set_clip_children)(fl_Window win,int c);
  FL_EXPORT_C(unsigned int, Fl_Window_clip_children)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_focus)(fl_Window win,fl_Widget W);
  FL_EXPORT_C(fl_Widget,    Fl_Window__ddfdesign_kludge)(fl_Window win);
  /* FL_EXPORT_C(void,         Fl_Window_forms_end)(fl_Window win); */
  /* Fl_Window specific */
  FL_EXPORT_C(unsigned int, Fl_Window_changed)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_fullscreen)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_fullscreen_off)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_fullscreen_off_with_resize)(fl_Window win,int X,int Y,int W,int H);
  FL_EXPORT_C(fl_Window,    Fl_Window_New_WithLabel)(int x, int y, const char* title);
  FL_EXPORT_C(fl_Window,    Fl_Window_New)(int x, int y);
  FL_EXPORT_C(fl_Window,    Fl_Window_NewWH_WithTitle)(int x, int y, int w, int h, const char* title);
  FL_EXPORT_C(fl_Window,    Fl_Window_NewWH)(int x, int y, int w, int h);
  FL_EXPORT_C(void,         Fl_Window_hide)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_show)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_show_with_args)(fl_Window win, int argc, char** argv);
  FL_EXPORT_C(void,         Fl_Window_destroy)(fl_Window win);
  FL_EXPORT_C(void,         Fl_Window_resize)(fl_Window win, int X, int Y, int W, int H);
  FL_EXPORT_C(void,         Fl_Window_iconize)(fl_Window win);
  FL_EXPORT_C(int ,Fl_Window_handle)(fl_Window win, int event);
  FL_EXPORT_C(void ,Fl_Window_set_border)(fl_Window win, int b);
  FL_EXPORT_C(void ,Fl_Window_clear_border)(fl_Window win);
  FL_EXPORT_C(unsigned int ,Fl_Window_border)(fl_Window win);
  FL_EXPORT_C(void ,Fl_Window_set_override)(fl_Window win);
  FL_EXPORT_C(unsigned int,Fl_Window_override)(fl_Window win);
  FL_EXPORT_C(void ,Fl_Window_set_modal)(fl_Window win);
  FL_EXPORT_C(unsigned int,Fl_Window_modal)(fl_Window win);
  FL_EXPORT_C(void ,Fl_Window_set_non_modal)(fl_Window win);
  FL_EXPORT_C(unsigned int ,Fl_Window_non_modal)(fl_Window win);
  FL_EXPORT_C(void ,Fl_Window_set_menu_window)(fl_Window win);
  FL_EXPORT_C(unsigned int,Fl_Window_menu_window)(fl_Window win);
  FL_EXPORT_C(void ,Fl_Window_set_tooltip_window)(fl_Window win);
  FL_EXPORT_C(unsigned int,Fl_Window_tooltip_window)(fl_Window win);
  FL_EXPORT_C(void ,Fl_Window_hotspot_with_x_y)(fl_Window win, int x, int y);
  FL_EXPORT_C(void ,Fl_Window_hotspot_with_x_y_with_offscreen)(fl_Window win, int x, int y, int offscreen);
  FL_EXPORT_C(void ,Fl_Window_hotspot_with_widget)(fl_Window win, fl_Widget w);//, int offscreen = 0);
  FL_EXPORT_C(void ,Fl_Window_hotspot_with_widget_with_offscreen)(fl_Window win, fl_Widget w, int offscreen);
  FL_EXPORT_C(void ,Fl_Window_free_position)(fl_Window win);
  FL_EXPORT_C(fl_Window_size_range_args* ,Fl_Window_size_range_default_args)();
  FL_EXPORT_C(void ,Fl_Window_size_range)(fl_Window win, int minw, int minh);
  FL_EXPORT_C(void ,Fl_Window_size_range_with_args)(fl_Window win, int minw, int minh, fl_Window_size_range_args* args);//int maxw=0, int maxh=0, int dw=0, int dh=0, int aspect=0);
  FL_EXPORT_C(const char*, Fl_Window_label)(fl_Window win);
  FL_EXPORT_C(const char*, Fl_Window_iconlabel)(fl_Window win);
  FL_EXPORT_C(void, Fl_Window_set_label)(fl_Window win,const char*);
  FL_EXPORT_C(void, Fl_Window_set_iconlabel)(fl_Window win,const char*);
  FL_EXPORT_C(void, Fl_Window_set_label_with_iconlabel)(fl_Window win,const char* label, const char* iconlabel);
  FL_EXPORT_C(void, Fl_Window_copy_label)(fl_Window win,const char* a);
  FL_EXPORT_C(void, Fl_Window_set_default_xclass)(const char* label);
  FL_EXPORT_C(const char*, Fl_Window_default_xclass)();
  FL_EXPORT_C(const char*, Fl_Window_xclass)(fl_Window win);
  FL_EXPORT_C(void, Fl_Window_set_xclass)(fl_Window win,const char* c);
  FL_EXPORT_C(const void*, Fl_Window_icon)(fl_Window win);
  FL_EXPORT_C(void, Fl_Window_set_icon)(fl_Window win,const void * ic);
  FL_EXPORT_C(int, Fl_Window_shown)(fl_Window win);
  FL_EXPORT_C(void, Fl_Window_iconize)(fl_Window win);
  FL_EXPORT_C(int, Fl_Window_x_root)(fl_Window win);
  FL_EXPORT_C(int, Fl_Window_y_root)(fl_Window win);
  FL_EXPORT_C(fl_Window, Fl_Window_current)();
  FL_EXPORT_C(void, Fl_Window_make_current)(fl_Window win);
  FL_EXPORT_C(void, Fl_Window_set_cursor_with_bg)(fl_Window win, Fl_Cursor cursor, Fl_Color bg);
  FL_EXPORT_C(void, Fl_Window_set_cursor_with_fg)(fl_Window win,Fl_Cursor cursor, Fl_Color fg);
  FL_EXPORT_C(void, Fl_Window_set_cursor_with_fg_bg)(fl_Window win,Fl_Cursor cursor, Fl_Color fg , Fl_Color bg );/* =FL_BLACK *//*=FL_WHITE*/
  FL_EXPORT_C(void, Fl_Window_set_cursor)(fl_Window win,Fl_Cursor cursor);
  FL_EXPORT_C(void, Fl_Window_set_default_cursor_with_bg)(fl_Window win,Fl_Cursor cursor, Fl_Color bg);
  FL_EXPORT_C(void, Fl_Window_set_default_cursor_with_fg)(fl_Window win, Fl_Cursor cursor, Fl_Color fg);
  FL_EXPORT_C(void, Fl_Window_set_default_cursor_with_fg_bg)(fl_Window win,Fl_Cursor cursor, Fl_Color fg , Fl_Color bg );
  FL_EXPORT_C(void, Fl_Window_set_default_cursor)(fl_Window win,Fl_Cursor cursor);
  FL_EXPORT_C(void, Fl_Window_default_callback)(fl_Window win, void* v);
  FL_EXPORT_C(int, Fl_Window_decorated_w)(fl_Window win);
  FL_EXPORT_C(int, Fl_Window_decorated_h)(fl_Window win);
#ifdef __cplusplus
}
#endif

#endif /* __FL_WINDOW_C__ */
