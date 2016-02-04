#include <pebble.h>

static Window *window;
static TextLayer *text_layer;
static DictationSession *s_dictation_session;

// Declare a buffer for the DictationSession
static char s_last_text[512];

static void select_click_handler(ClickRecognizerRef recognizer, void *context) {
  text_layer_set_text(text_layer, "Select");
  
  // Start dictation UI
  dictation_session_start(s_dictation_session);
}

static void up_click_handler(ClickRecognizerRef recognizer, void *context) {
  text_layer_set_text(text_layer, "Up");
}

static void down_click_handler(ClickRecognizerRef recognizer, void *context) {
  text_layer_set_text(text_layer, "Down");
}

static void click_config_provider(void *context) {
  window_single_click_subscribe(BUTTON_ID_SELECT, select_click_handler);
  window_single_click_subscribe(BUTTON_ID_UP, up_click_handler);
  window_single_click_subscribe(BUTTON_ID_DOWN, down_click_handler);
}

static void dictation_session_callback(DictationSession *session, DictationSessionStatus status, 
                                       char *transcription, void *context) {
  // Print the results of a transcription attempt                                     
  APP_LOG(APP_LOG_LEVEL_INFO, "Dictation status: %d", (int)status);

  if(status == DictationSessionStatusSuccess) {
    // Display the dictated text
    snprintf(s_last_text, sizeof(s_last_text), "%s", transcription);
    text_layer_set_text(text_layer, s_last_text);
  } else {
    // Display the reason for any error
    static char s_failed_buff[128];
    snprintf(s_failed_buff, sizeof(s_failed_buff), "Transcription failed.\n\nReason:\n%d", 
             (int)status);
    text_layer_set_text(text_layer, s_failed_buff);
  }
}

static void window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

  text_layer = text_layer_create((GRect) { .origin = { 0, 72 }, .size = { bounds.size.w, 20 } });
  text_layer_set_text(text_layer, "Press a button");
  text_layer_set_text_alignment(text_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(text_layer));

  s_dictation_session = dictation_session_create(sizeof(s_last_text), dictation_session_callback, NULL);
}

static void window_unload(Window *window) {
  text_layer_destroy(text_layer);
}

static void init(void) {
  window = window_create();
  window_set_click_config_provider(window, click_config_provider);
  window_set_window_handlers(window, (WindowHandlers) {
    .load = window_load,
    .unload = window_unload,
  });
  const bool animated = true;
  window_stack_push(window, animated);
}

static void deinit(void) {
  window_destroy(window);
}

int main(void) {
  init();

  APP_LOG(APP_LOG_LEVEL_DEBUG, "Done initializing, pushed window: %p", window);

  app_event_loop();
  deinit();
}
