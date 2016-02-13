#include <pebble.h>
#include "pebble-sms-pebble.h"
#include "tertiaryText.h"
  
static Window *s_tertiary_window;
static TextLayer *s_entered_text_layer;
static TextLayer *s_up_button_layer;
static TextLayer *s_select_button_layer;
static TextLayer *s_down_button_layer;
static TextLayer *s_tertiary_instruction_layer;
static ActionBarLayer *s_tertiary_actionbar;

static char ai[] = "a-i";
static char jr[] = "j-r";
static char sz[] = "s-_";
static char ac[] = "a-c";
static char df[] = "d-f";
static char gi[] = "g-i";
static char jl[] = "j-l";
static char mo[] = "m-o";
static char pr[] = "p-r";
static char su[] = "s-u";
static char vx[] = "v-x";
static char yz[] = "y-_";

static char AI[] = "A-I";
static char JR[] = "J-R";
static char SZ[] = "S-_";
static char AC[] = "A-C";
static char DF[] = "D-F";
static char GI[] = "G-I";
static char JL[] = "J-L";
static char MO[] = "M-O";
static char PR[] = "P-R";
static char SU[] = "S-U";
static char VX[] = "V-X";
static char YZ[] = "Y-_";

static char num1[] = "0-2";
static char num2[] = "3-5";
static char num3[] = "6-.";
static char num4[] = "6-8";
static char num5[] = "9,?";
static char num6[] = ".";

static int first_choice = 0;
static int second_choice = 0;
static int is_uppercase = true;
static int is_numbers = false;
static char entered_text[500] = "";
static const char lowercase[28] = "abcdefghijklmnopqrstuvwxyz ";
static const char uppercase[28] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ";
static const char numbers[] = "0123456789,?.";

static void set_no_choice_text() {
  if (is_numbers) {
    text_layer_set_text(s_up_button_layer, num1);
    text_layer_set_text(s_select_button_layer, num2);
    text_layer_set_text(s_down_button_layer, num3);
  } else if (is_uppercase) {
    text_layer_set_text(s_up_button_layer, AI);
    text_layer_set_text(s_select_button_layer, JR);
    text_layer_set_text(s_down_button_layer, SZ);
  } else {
    text_layer_set_text(s_up_button_layer, ai);
    text_layer_set_text(s_select_button_layer, jr);
    text_layer_set_text(s_down_button_layer, sz);
  }
}

static void reset_choices() {
  first_choice = 0;
  second_choice = 0;
  set_no_choice_text();
}

static void set_first_choice_text() {
  if (is_numbers) {
    if (first_choice == 1) {
      text_layer_set_text(s_up_button_layer, "0");
      text_layer_set_text(s_select_button_layer, "1");
      text_layer_set_text(s_down_button_layer, "2");
    } else if (first_choice == 2) {
      text_layer_set_text(s_up_button_layer, "3");
      text_layer_set_text(s_select_button_layer, "4");
      text_layer_set_text(s_down_button_layer, "5");    
    } else if (first_choice == 3) {
      text_layer_set_text(s_up_button_layer, num4);
      text_layer_set_text(s_select_button_layer, num5);
      text_layer_set_text(s_down_button_layer, num6);    
    }
  } else if (is_uppercase) {
    if (first_choice == 1) {
      text_layer_set_text(s_up_button_layer, AC);
      text_layer_set_text(s_select_button_layer, DF);
      text_layer_set_text(s_down_button_layer, GI);
    } else if (first_choice == 2) {
      text_layer_set_text(s_up_button_layer, JL);
      text_layer_set_text(s_select_button_layer, MO);
      text_layer_set_text(s_down_button_layer, PR);    
    } else if (first_choice == 3) {
      text_layer_set_text(s_up_button_layer, SU);
      text_layer_set_text(s_select_button_layer, VX);
      text_layer_set_text(s_down_button_layer, YZ);    
    }
  } else {
    if (first_choice == 1) {
      text_layer_set_text(s_up_button_layer, ac);
      text_layer_set_text(s_select_button_layer, df);
      text_layer_set_text(s_down_button_layer, gi);
    } else if (first_choice == 2) {
      text_layer_set_text(s_up_button_layer, jl);
      text_layer_set_text(s_select_button_layer, mo);
      text_layer_set_text(s_down_button_layer, pr);    
    } else if (first_choice == 3) {
      text_layer_set_text(s_up_button_layer, su);
      text_layer_set_text(s_select_button_layer, vx);
      text_layer_set_text(s_down_button_layer, yz);    
    }
  }
}

static void set_second_choice_text() {
  if (is_numbers) {
    if (second_choice == 1) {
      text_layer_set_text(s_up_button_layer, "6");
      text_layer_set_text(s_select_button_layer, "7");
      text_layer_set_text(s_down_button_layer, "8");
    } else if (second_choice == 2) {
      text_layer_set_text(s_up_button_layer, "9");
      text_layer_set_text(s_select_button_layer, ",");
      text_layer_set_text(s_down_button_layer, "?");
    }
  } else if (is_uppercase) {
    if (second_choice == 1) {
      if (first_choice == 1) {
        text_layer_set_text(s_up_button_layer, "A");
        text_layer_set_text(s_select_button_layer, "B");
        text_layer_set_text(s_down_button_layer, "C");
      } else if (first_choice == 2) {
        text_layer_set_text(s_up_button_layer, "J");
        text_layer_set_text(s_select_button_layer, "K");
        text_layer_set_text(s_down_button_layer, "L");
      } else if (first_choice == 3) {
        text_layer_set_text(s_up_button_layer, "S");
        text_layer_set_text(s_select_button_layer, "T");
        text_layer_set_text(s_down_button_layer, "U");
      }
    } else if (second_choice == 2) {
      if (first_choice == 1) {
        text_layer_set_text(s_up_button_layer, "D");
        text_layer_set_text(s_select_button_layer, "E");
        text_layer_set_text(s_down_button_layer, "F");
      } else if (first_choice == 2) {
        text_layer_set_text(s_up_button_layer, "M");
        text_layer_set_text(s_select_button_layer, "N");
        text_layer_set_text(s_down_button_layer, "O");
      } else if (first_choice == 3) {
        text_layer_set_text(s_up_button_layer, "V");
        text_layer_set_text(s_select_button_layer, "W");
        text_layer_set_text(s_down_button_layer, "X");
      }    
    } else if (second_choice == 3) {
      if (first_choice == 1) {
        text_layer_set_text(s_up_button_layer, "G");
        text_layer_set_text(s_select_button_layer, "H");
        text_layer_set_text(s_down_button_layer, "I");
      } else if (first_choice == 2) {
        text_layer_set_text(s_up_button_layer, "P");
        text_layer_set_text(s_select_button_layer, "Q");
        text_layer_set_text(s_down_button_layer, "R");
      } else if (first_choice == 3) {
        text_layer_set_text(s_up_button_layer, "Y");
        text_layer_set_text(s_select_button_layer, "Z");
        text_layer_set_text(s_down_button_layer, "_");
      }    
    }  
  } else {
    if (second_choice == 1) {
      if (first_choice == 1) {
        text_layer_set_text(s_up_button_layer, "a");
        text_layer_set_text(s_select_button_layer, "b");
        text_layer_set_text(s_down_button_layer, "c");
      } else if (first_choice == 2) {
        text_layer_set_text(s_up_button_layer, "j");
        text_layer_set_text(s_select_button_layer, "k");
        text_layer_set_text(s_down_button_layer, "l");
      } else if (first_choice == 3) {
        text_layer_set_text(s_up_button_layer, "s");
        text_layer_set_text(s_select_button_layer, "t");
        text_layer_set_text(s_down_button_layer, "u");
      }
    } else if (second_choice == 2) {
      if (first_choice == 1) {
        text_layer_set_text(s_up_button_layer, "d");
        text_layer_set_text(s_select_button_layer, "e");
        text_layer_set_text(s_down_button_layer, "f");
      } else if (first_choice == 2) {
        text_layer_set_text(s_up_button_layer, "m");
        text_layer_set_text(s_select_button_layer, "n");
        text_layer_set_text(s_down_button_layer, "o");
      } else if (first_choice == 3) {
        text_layer_set_text(s_up_button_layer, "v");
        text_layer_set_text(s_select_button_layer, "w");
        text_layer_set_text(s_down_button_layer, "x");
      }    
    } else if (second_choice == 3) {
      if (first_choice == 1) {
        text_layer_set_text(s_up_button_layer, "g");
        text_layer_set_text(s_select_button_layer, "h");
        text_layer_set_text(s_down_button_layer, "i");
      } else if (first_choice == 2) {
        text_layer_set_text(s_up_button_layer, "p");
        text_layer_set_text(s_select_button_layer, "q");
        text_layer_set_text(s_down_button_layer, "r");
      } else if (first_choice == 3) {
        text_layer_set_text(s_up_button_layer, "y");
        text_layer_set_text(s_select_button_layer, "z");
        text_layer_set_text(s_down_button_layer, "_");
      }
    }
  }
  
}

static void append_letter(const int first, const int second, const int third) {
  if (is_numbers) {
    if (first != 3) {
      strncat(entered_text, numbers+(first*3+second*1-4), 1);
    } else {
      if (second != 3) {
        strncat(entered_text, numbers+(first*3+second*3+third-7), 1);
      } else {
        strncat(entered_text, numbers+(first*3+second*3-6), 1);
      }
    }
  } else if (is_uppercase) {
    strncat(entered_text, uppercase+(first*9+second*3+third-13), 1);
  } else {
    strncat(entered_text, lowercase+(first*9+second*3+third-13), 1);
  }
}

static void delete_letter() {
  int len = strlen(entered_text);
  entered_text[len-1] = '\0';
}

static void up_click_handler(ClickRecognizerRef recognizer, void *context) {
  if (first_choice == 0) {
    first_choice = 1;
    set_first_choice_text();
  } else if (second_choice == 0) {
    second_choice = 1;
    if (is_numbers && (first_choice != 3 || (second_choice == 3 && second_choice == 3))) {
      append_letter(first_choice, second_choice, 1);
      reset_choices();
      text_layer_set_text(s_entered_text_layer, entered_text);
    }
    set_second_choice_text();
  } else {
    append_letter(first_choice, second_choice, 1);
    reset_choices();
    text_layer_set_text(s_entered_text_layer, entered_text);
  }
}

static void select_click_handler(ClickRecognizerRef recognizer, void *context) {
  if (first_choice == 0) {
    first_choice = 2;
    set_first_choice_text();
  } else if (second_choice == 0) {
    second_choice = 2;
    if (is_numbers && (first_choice != 3 || (second_choice == 3 && second_choice == 3))) {
      append_letter(first_choice, second_choice, 1);
      reset_choices();
      text_layer_set_text(s_entered_text_layer, entered_text);
    }
    set_second_choice_text();
  } else {
    append_letter(first_choice, second_choice, 2);
    reset_choices();
    text_layer_set_text(s_entered_text_layer, entered_text);
  }
}

static void down_click_handler(ClickRecognizerRef recognizer, void *context) {
  if (first_choice == 0) {
    first_choice = 3;
    set_first_choice_text();
  } else if (second_choice == 0) {
    second_choice = 3;
    if (is_numbers && (first_choice != 3 || (second_choice == 3 && second_choice == 3))) {
      append_letter(first_choice, second_choice, 1);
      reset_choices();
      text_layer_set_text(s_entered_text_layer, entered_text);
    }
    set_second_choice_text();
  } else {
    append_letter(first_choice, second_choice, 3);
    reset_choices();
    text_layer_set_text(s_entered_text_layer, entered_text);
  }
}

static void back_click_handler(ClickRecognizerRef recognizer, void *context) {
  if (first_choice == 0) {
    if (strlen(entered_text)>0) {
      delete_letter();
      text_layer_set_text(s_entered_text_layer, entered_text);
    } else {      
      window_stack_pop(true);
    }
  } else if (second_choice == 0) {
    reset_choices();
  } else {
    second_choice = 0;
    set_first_choice_text();
  }
}

void select_long_click_handler(ClickRecognizerRef recognizer, void *context) {
  tertiary_text_chosen(entered_text);
  window_stack_pop(true);
}

void up_long_click_handler(ClickRecognizerRef recognizer, void *context) {
  if (is_numbers) {
    is_numbers = false;
  } else {
    is_numbers = true;
  }
  reset_choices();
  set_no_choice_text();
  text_layer_set_text(s_entered_text_layer, entered_text);
}

void down_long_click_handler(ClickRecognizerRef recognizer, void *context) {
  if (is_uppercase) {
    is_uppercase = false;
  } else {
    is_uppercase = true;
  }
  if (second_choice != 0) {
    set_second_choice_text();
  } else if (first_choice != 0) {
    set_first_choice_text();
  } else {
    set_no_choice_text();
  }
}

void config_provider(Window *window) {
  // set click listeners
  window_single_click_subscribe(BUTTON_ID_UP, up_click_handler);
  window_single_click_subscribe(BUTTON_ID_SELECT, select_click_handler);
  window_single_click_subscribe(BUTTON_ID_DOWN, down_click_handler);
  window_single_click_subscribe(BUTTON_ID_BACK, back_click_handler);
  
  // long click config:
  window_long_click_subscribe(BUTTON_ID_UP, 300, up_long_click_handler, NULL);
  window_long_click_subscribe(BUTTON_ID_SELECT, 300, select_long_click_handler, NULL);
  window_long_click_subscribe(BUTTON_ID_DOWN, 300, down_long_click_handler, NULL);
}

static void tertiary_window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

  s_tertiary_instruction_layer = text_layer_create(GRect(0, 0, bounds.size.w - ACTION_BAR_WIDTH, 80));
  text_layer_set_text_color(s_tertiary_instruction_layer, GColorBlack);
  text_layer_set_text(s_tertiary_instruction_layer, "Hold select to confirm, up for numbers, and down for caps.");

  #if defined(PBL_ROUND)
  s_entered_text_layer = text_layer_create(GRect(0, 80, bounds.size.w - ACTION_BAR_WIDTH, 100));
  #else
  s_entered_text_layer = text_layer_create(GRect(0, 80, bounds.size.w - ACTION_BAR_WIDTH, 80));
  #endif
  text_layer_set_background_color(s_entered_text_layer, GColorClear);
  text_layer_set_text_color(s_entered_text_layer, GColorBlack);
  text_layer_set_text(s_entered_text_layer, "");
  
  #if defined(PBL_ROUND)
  s_up_button_layer = text_layer_create(GRect(146, 54, 24, 20));
  #else
  s_up_button_layer = text_layer_create(GRect(117, 22, 24, 20));
  #endif
  text_layer_set_background_color(s_up_button_layer, GColorClear);
  text_layer_set_text_color(s_up_button_layer, GColorWhite);
  text_layer_set_text(s_up_button_layer, "A-I");
  
  #if defined(PBL_ROUND)
  s_select_button_layer = text_layer_create(GRect(144, 80, 24, 20));
  #else
  s_select_button_layer = text_layer_create(GRect(117, 74, 24, 20));
  #endif
  text_layer_set_background_color(s_select_button_layer, GColorClear);
  text_layer_set_text_color(s_select_button_layer, GColorWhite);
  text_layer_set_text(s_select_button_layer, "J-R");
  
  #if defined(PBL_ROUND)
  s_down_button_layer = text_layer_create(GRect(146, 106, 24, 20));
  #else
  s_down_button_layer = text_layer_create(GRect(117, 124, 24, 20));
  #endif
  text_layer_set_background_color(s_down_button_layer, GColorClear);
  text_layer_set_text_color(s_down_button_layer, GColorWhite);
  text_layer_set_text(s_down_button_layer, "S-_");

  s_tertiary_actionbar = action_bar_layer_create();
  action_bar_layer_add_to_window(s_tertiary_actionbar, window);

  // Improve the layout to be more like a watchface
  text_layer_set_text_alignment(s_tertiary_instruction_layer, GTextAlignmentCenter);
  text_layer_set_text_alignment(s_entered_text_layer, GTextAlignmentCenter);
  text_layer_set_text_alignment(s_up_button_layer, GTextAlignmentCenter);
  text_layer_set_text_alignment(s_down_button_layer, GTextAlignmentCenter);
  text_layer_set_text_alignment(s_select_button_layer, GTextAlignmentCenter);

  // Add it as a child layer to the Window's root layer
  layer_add_child(window_get_root_layer(window), text_layer_get_layer(s_tertiary_instruction_layer));
  layer_add_child(window_get_root_layer(window), text_layer_get_layer(s_entered_text_layer));
  layer_add_child(window_get_root_layer(window), text_layer_get_layer(s_up_button_layer));
  layer_add_child(window_get_root_layer(window), text_layer_get_layer(s_select_button_layer));
  layer_add_child(window_get_root_layer(window), text_layer_get_layer(s_down_button_layer));
  #if defined(PBL_ROUND)
  text_layer_enable_screen_text_flow_and_paging(s_tertiary_instruction_layer, 2);
  text_layer_enable_screen_text_flow_and_paging(s_entered_text_layer, 2);
  #endif
  
  window_set_click_config_provider(window, (ClickConfigProvider) config_provider);
}

static void tertiary_window_unload(Window *window) {
  text_layer_destroy(s_entered_text_layer);
  text_layer_destroy(s_tertiary_instruction_layer);
  text_layer_destroy(s_select_button_layer);
  text_layer_destroy(s_up_button_layer);
  text_layer_destroy(s_down_button_layer);
  action_bar_layer_destroy(s_tertiary_actionbar);
  // Destroy Window
  window_destroy(s_tertiary_window);
}

void tertiary_init() {
  entered_text[0] = '\0';

  // Create main Window element and assign to pointer
  s_tertiary_window = window_create();

  // Set handlers to manage the elements inside the Window
  window_set_window_handlers(s_tertiary_window, (WindowHandlers) {
    .load = tertiary_window_load,
    .unload = tertiary_window_unload
  });

  // Show the Window on the watch, with animated=true
  window_stack_push(s_tertiary_window, true);
}