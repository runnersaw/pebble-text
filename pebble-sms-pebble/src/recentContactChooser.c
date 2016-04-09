#include <pebble.h>
#include "pebble-sms-pebble.h"

#define CONTACT_CHAR_NUM 30
#define CONTACT_NUMBER_CHAR_NUM 20

static char *recent_contacts;
static char *recent_contacts_number;
static short is_recent_initialized;
static char current_contact[CONTACT_CHAR_NUM] = "";
static char current_number[CONTACT_NUMBER_CHAR_NUM] = "";

static ClickConfigProvider previous_click_config_provider;

#define NUM_RECENT_SECTIONS 1

#if defined(PBL_ROUND)
  #define CELL_HEIGHT 60
  #define LOADING_CELL_HEIGHT 180
#else
  #define CELL_HEIGHT 45
  #define LOADING_CELL_HEIGHT 168
#endif

static Window *s_recent_menu_window;
static MenuLayer *s_recent_menu;

static void save_contact_name(int index) {
  int i=0;
  int newline_count = 0;
  int start_index = 0;
  int end_index = -1;
  while (*(recent_contacts+i) != 0 && i<1000) { // just in case not null terminated
    if ((char)recent_contacts[i] == '\n') {
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
  if (end_index - start_index > CONTACT_CHAR_NUM) {
    end_index = start_index+CONTACT_CHAR_NUM-1;
  }
  strncpy(current_contact, recent_contacts + start_index, end_index - start_index);
  current_contact[end_index - start_index] = '\0';
}

static void save_contact_number(int index) {
  int i=0;
  int newline_count = 0;
  int start_index = 0;
  int end_index = -1;
  while (*(recent_contacts_number+i) != 0 && i<1000) { // just in case not null terminated
    if ((char)recent_contacts_number[i] == '\n') {
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
  if (end_index - start_index > CONTACT_NUMBER_CHAR_NUM) {
    end_index = start_index+CONTACT_NUMBER_CHAR_NUM-1;
  }
  strncpy(current_number, recent_contacts_number + start_index, end_index - start_index);
  current_number[end_index - start_index] = '\0';
}

static int get_num_contacts() {
  int i=0;
  int newline_count = 1;
  while (*(recent_contacts+i) != 0 && i<1000) { // just in case not null terminated
    if ((char)recent_contacts[i] == '\n') {
      newline_count++;
    }
    i++;
  }
  return newline_count;
}

// A simple menu layer can have multiple sections
static uint16_t menu_get_num_sections_callback(MenuLayer *menu_layer, void *data) {
  return NUM_RECENT_SECTIONS;
}

// Each section is composed of a number of menu items
static uint16_t menu_get_num_rows_callback(MenuLayer *menu_layer, uint16_t section_index, void *data) {
  if (is_recent_initialized) {
    return get_num_contacts();
  } else {
    return 1;
  }
}

static int16_t menu_get_header_height_callback(MenuLayer *menu_layer, uint16_t section_index, void *data) {
  return 0;
}

static int16_t menu_get_cell_height_callback(MenuLayer *menu_layer, MenuIndex *cell_index, void *callback_context) {
  if (is_recent_initialized) {
    return CELL_HEIGHT;
  } else {
    return LOADING_CELL_HEIGHT;
  }
}

static void draw_loading(GContext *ctx, const Layer *layer, char *title, char* subtitle) {
  GRect bounds = layer_get_bounds(layer);
  GRect title_bounds = GRect(10,10,bounds.size.w-20,30);
  GRect text_bounds = GRect(20,50,bounds.size.w-40,bounds.size.h-60);
  graphics_draw_text(ctx, title, fonts_get_system_font(FONT_KEY_GOTHIC_24_BOLD), title_bounds, GTextOverflowModeWordWrap, GTextAlignmentCenter, NULL);
  graphics_draw_text(ctx, subtitle, fonts_get_system_font(FONT_KEY_GOTHIC_18_BOLD), text_bounds, GTextOverflowModeWordWrap, GTextAlignmentCenter, NULL);
}

static void draw_menu(GContext *ctx, const Layer *layer, char *title, char* subtitle) {
  menu_cell_basic_draw(ctx, layer, title, subtitle, NULL);
}

static void menu_draw_row_callback(GContext *ctx, const Layer *cell_layer, MenuIndex *cell_index, void *data) {
  if (is_recent_initialized) {
    save_contact_name(cell_index->row);
    save_contact_number(cell_index->row);
    draw_menu(ctx, cell_layer, current_contact, current_number);
  } else {
    draw_loading(ctx, cell_layer, "Loading...", "If you just installed, this menu will populate as you send texts");
  }
}

static void menu_select_callback(MenuLayer *menu_layer, MenuIndex *cell_index, void *data) {
  if (is_recent_initialized) {
    save_contact_name(cell_index->row);
    save_contact_number(cell_index->row);
    contact_chosen_from_recent(current_contact, current_number);
    window_stack_pop(s_recent_menu_window);
  }
}

static void back_button_handler(ClickRecognizerRef recognizer, void *context) {
  window_stack_pop(true);
  change_state(BEGINNING_STATE);
}

static void new_click_config_provider(void *context) {
  previous_click_config_provider(context);
  window_single_click_subscribe(BUTTON_ID_BACK, back_button_handler);
}

static void force_back_button(Window *window, MenuLayer *menu_layer) {
  previous_click_config_provider = window_get_click_config_provider(window);
  window_set_click_config_provider_with_context(window, new_click_config_provider, menu_layer);
}

static void recent_menu_window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_frame(window_layer);

  s_recent_menu = menu_layer_create(bounds);
  #if defined(PBL_ROUND)
    menu_layer_set_center_focused((MenuLayer *)s_recent_menu, true);
  #endif

  menu_layer_set_callbacks(s_recent_menu, NULL, (MenuLayerCallbacks){
    .get_num_sections = menu_get_num_sections_callback,
    .get_num_rows = menu_get_num_rows_callback,
    .get_header_height = menu_get_header_height_callback,
    .get_cell_height = menu_get_cell_height_callback,
    .draw_header = NULL,
    .draw_row = menu_draw_row_callback,
    .select_click = menu_select_callback,
  });

  menu_layer_set_click_config_onto_window(s_recent_menu, window);
  force_back_button(window, s_recent_menu);

  layer_add_child(window_layer, menu_layer_get_layer(s_recent_menu));
}

static void recent_menu_window_unload(Window *window) {
  is_recent_initialized = false;
  menu_layer_destroy(s_recent_menu);
  window_destroy(window);
  s_recent_menu_window = NULL;
}

void set_recent_contacts(char *contacts, char *numbers) {
  is_recent_initialized = true;
  recent_contacts = contacts;
  recent_contacts_number = numbers;

  if (window_stack_contains_window(s_recent_menu_window)) {
    menu_layer_reload_data(s_recent_menu);
  }
}

void recent_contact_chooser_init() {
  // Create main Window element and assign to pointer
  s_recent_menu_window = window_create();

  // Set handlers to manage the elements inside the Window
  window_set_window_handlers(s_recent_menu_window, (WindowHandlers) {
    .load = recent_menu_window_load,
    .unload = recent_menu_window_unload
  });

  // Show the Window on the watch, with animated=true
  window_stack_push(s_recent_menu_window, true);
}