#include <pebble.h>
#include "pebble-sms-pebble.h"

#define PRESET_CHAR_NUM 160

static short is_preset_initialized;
static char *all_presets;
static char current_preset[PRESET_CHAR_NUM] = "";

static ClickConfigProvider previous_click_config_provider;

#define NUM_PRESET_SECTIONS 1

#if defined(PBL_ROUND)
  #define CELL_HEIGHT 60
  #define LOADING_CELL_HEIGHT 120
#else
  #define CELL_HEIGHT 45
  #define LOADING_CELL_HEIGHT 120
#endif

static Window *s_preset_menu_window;
static MenuLayer *s_preset_menu;

static void save_preset(int index) {
  int i=0;
  int newline_count = 0;
  int start_index = 0;
  int end_index = -1;
  while (*(all_presets+i) != 0 && i<1000) { // just in case not null terminated
    if ((char)all_presets[i] == '\n') {
      newline_count++;
      if (newline_count == index) {
        start_index = i+1;
      }
      if (newline_count == index+1) {
        end_index = i;
      }
    }
    i++;
  }
  if (end_index == -1) {
    end_index = i;
  }
  if (end_index - start_index > PRESET_CHAR_NUM) {
    end_index = start_index+PRESET_CHAR_NUM-1;
  }
  strncpy(current_preset, all_presets + start_index, end_index - start_index);
  current_preset[end_index - start_index] = '\0';
}

static int get_num_presets() {
  int i=0;
  int newline_count = 1;
  while (*(all_presets+i) != 0 && i<1000) { // just in case not null terminated
    if ((char)all_presets[i] == '\n') {
      newline_count++;
    }
    i++;
  }
  return newline_count;
}

// A simple menu layer can have multiple sections
static uint16_t menu_get_num_sections_callback(MenuLayer *menu_layer, void *data) {
  return NUM_PRESET_SECTIONS;
}

// Each section is composed of a number of menu items
static uint16_t menu_get_num_rows_callback(MenuLayer *menu_layer, uint16_t section_index, void *data) {
  if (is_preset_initialized) {
    return get_num_presets();
  } else {
    return 1;
  }
}

static int16_t menu_get_header_height_callback(MenuLayer *menu_layer, uint16_t section_index, void *data) {
  return 0;
}

static int16_t menu_get_cell_height_callback(MenuLayer *menu_layer, MenuIndex *cell_index, void *callback_context) {
  if (is_preset_initialized) {
    return CELL_HEIGHT;
  } else {
    return LOADING_CELL_HEIGHT;
  }
}

static void draw_menu(GContext *ctx, const Layer *layer, char *title, char* subtitle) {
  menu_cell_basic_draw(ctx, layer, title, subtitle, NULL);
}

static void menu_draw_row_callback(GContext *ctx, const Layer *cell_layer, MenuIndex *cell_index, void *data) {
  if (is_preset_initialized) {
    save_preset(cell_index->row);
    draw_menu(ctx, cell_layer, current_preset, NULL);
  } else {
    draw_menu(ctx, cell_layer, "Loading...", "Edit these presets in the app.");
  }
}

static void menu_select_callback(MenuLayer *menu_layer, MenuIndex *cell_index, void *data) {
  if (is_preset_initialized) {
    save_preset(cell_index->row);
    preset_chosen(current_preset);
    window_stack_pop(true);
  }
}

static void back_button_handler(ClickRecognizerRef recognizer, void *context) {
  window_stack_pop(true);
  change_state(CREATING_FINAL_MESSAGE_STATE);
}

static void new_click_config_provider(void *context) {
  previous_click_config_provider(context);
  window_single_click_subscribe(BUTTON_ID_BACK, back_button_handler);
}

static void force_back_button(Window *window, MenuLayer *menu_layer) {
  previous_click_config_provider = window_get_click_config_provider(window);
  window_set_click_config_provider_with_context(window, new_click_config_provider, menu_layer);
}

static void preset_menu_window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_frame(window_layer);

  s_preset_menu = menu_layer_create(bounds);
  #if defined(PBL_ROUND)
    menu_layer_set_center_focused((MenuLayer *)s_preset_menu, true);
  #endif

  menu_layer_set_callbacks(s_preset_menu, NULL, (MenuLayerCallbacks){
    .get_num_sections = menu_get_num_sections_callback,
    .get_num_rows = menu_get_num_rows_callback,
    .get_header_height = menu_get_header_height_callback,
    .get_cell_height = menu_get_cell_height_callback,
    .draw_header = NULL,
    .draw_row = menu_draw_row_callback,
    .select_click = menu_select_callback,
  });

  menu_layer_set_click_config_onto_window(s_preset_menu, window);
  force_back_button(window, s_preset_menu);

  layer_add_child(window_layer, menu_layer_get_layer(s_preset_menu));
}

static void preset_menu_window_unload(Window *window) {
  is_preset_initialized = false;
  menu_layer_destroy(s_preset_menu);
  window_destroy(window);
  s_preset_menu_window = NULL;
}

void set_presets(char *presets) {
  is_preset_initialized = true;
  all_presets = presets;

  if (window_stack_contains_window(s_preset_menu_window)) {
    menu_layer_reload_data(s_preset_menu);
  }
}

void preset_init() {
  // Create main Window element and assign to pointer
  s_preset_menu_window = window_create();

  // Set handlers to manage the elements inside the Window
  window_set_window_handlers(s_preset_menu_window, (WindowHandlers) {
    .load = preset_menu_window_load,
    .unload = preset_menu_window_unload
  });

  // Show the Window on the watch, with animated=true
  window_stack_push(s_preset_menu_window, true);
}