#include <pebble.h>

// OUTGOING
#define DICTATED_NAME_KEY 0
#define IS_CONTACT_CORRECT_KEY 1
#define IS_NUMBER_CORRECT_KEY 2
#define FINAL_MESSAGE_KEY 3
#define STATE_KEY 4
#define CONTACT_NAME_KEY 5
#define CONTACT_NUMBER_KEY 6
#define MESSAGE_CONFIRMATION_KEY 7
#define ATTEMPT_NUMBER_KEY 8
#define CONNECTION_TEST_KEY 9

// define states
#define BEGINNING_STATE 0
#define DICTATED_NAME_STATE 1
#define CHECKING_CONTACT_STATE 2
#define CREATING_FINAL_MESSAGE_STATE 3
#define CONFIRMING_FINAL_MESSAGE_STATE 4
#define FINAL_MESSAGE_STATE 5

static Window *window;
static TextLayer *s_instruction_layer;
static TextLayer *s_primary_layer;
static TextLayer *s_secondary_layer;
static DictationSession *s_dictation_session;
static ActionBarLayer *s_actionbar;

// Declare a buffer for the DictationSession
static char s_last_text[512];
static int s_state = BEGINNING_STATE;
static char number[20];
static char contact_name[100];
static char dictated_name[100];
static char dictated_message[512];

static short has_contact = false;

static short contact_try = 1;

static void reset_all() {
  s_last_text[0] = '\0';
  s_state = BEGINNING_STATE;
  number[0] = '\0';
  contact_name[0] = '\0';
  dictated_name[0] = '\0';
  dictated_message[0] = '\0';
  has_contact = false;
  contact_try = 1;
}

static void get_contact() {
  DictionaryIterator *iter;
  app_message_outbox_begin(&iter);
  dict_write_cstring(iter, DICTATED_NAME_KEY, dictated_name);
  dict_write_int(iter, STATE_KEY, &s_state, 1, 0);
  dict_write_int(iter, ATTEMPT_NUMBER_KEY, &contact_try, 1, 0);
  app_message_outbox_send();
}

static void send_connection_test() {
  DictionaryIterator *iter;
  app_message_outbox_begin(&iter);
  dict_write_cstring(iter, CONNECTION_TEST_KEY, "AM_I_CONNECTED");
  app_message_outbox_send();
}

static void send_final_message() {
  DictionaryIterator *iter;
  app_message_outbox_begin(&iter);
  dict_write_cstring(iter, CONTACT_NAME_KEY, contact_name);
  dict_write_cstring(iter, CONTACT_NUMBER_KEY, number);
  DictionaryResult res = dict_write_cstring(iter, FINAL_MESSAGE_KEY, dictated_message);
  if (res == DICT_OK) {
    APP_LOG(APP_LOG_LEVEL_INFO, "added");
  }
  if (res == DICT_NOT_ENOUGH_STORAGE) {
    APP_LOG(APP_LOG_LEVEL_INFO, "not enough storage");
  }
  if (res == DICT_INVALID_ARGS) {
    APP_LOG(APP_LOG_LEVEL_INFO, "invalid args");
  }
  dict_write_int(iter, STATE_KEY, &s_state, 1, 0);
  app_message_outbox_send();
}

static void change_state(int state) {
  s_state = state;
}

static void select_click_handler(ClickRecognizerRef recognizer, void *context) {  
  // Start dictation UI
  if (s_state == BEGINNING_STATE) {
    dictation_session_start(s_dictation_session);
  }

  if (s_state == CREATING_FINAL_MESSAGE_STATE) {
    dictation_session_start(s_dictation_session);
  }
}

static void up_click_handler(ClickRecognizerRef recognizer, void *context) {
  if (s_state == CHECKING_CONTACT_STATE && has_contact) {
    change_state(CONFIRMING_FINAL_MESSAGE_STATE);
    get_contact();
  } else if (s_state == CONFIRMING_FINAL_MESSAGE_STATE) {
    send_final_message();
  }
}

static void down_click_handler(ClickRecognizerRef recognizer, void *context) {
  if (s_state == CHECKING_CONTACT_STATE && has_contact) {
    get_contact();
    has_contact = false;
    contact_try++;
  } else if (s_state == CONFIRMING_FINAL_MESSAGE_STATE) {
    dictated_message[0] = '\0';
    change_state(CREATING_FINAL_MESSAGE_STATE);
  }
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

    // just dictated name
    if (s_state == BEGINNING_STATE) {
      snprintf(dictated_name, sizeof(dictated_name), "%s", transcription);
      text_layer_set_text(s_instruction_layer, "Loading Contact...");
      text_layer_set_text(s_primary_layer, s_last_text);
      text_layer_set_text(s_secondary_layer, "");
      change_state(CHECKING_CONTACT_STATE);
      get_contact();
    }

    // just dictated message
    if (s_state == CREATING_FINAL_MESSAGE_STATE) {
      change_state(CONFIRMING_FINAL_MESSAGE_STATE);
      snprintf(dictated_message, sizeof(dictated_message), "%s", transcription);
      text_layer_set_text(s_instruction_layer, "Confirm message");
      text_layer_set_text(s_primary_layer, contact_name);
      text_layer_set_text(s_secondary_layer, dictated_message);
    }
  } else {
    // Display the reason for any error
    static char s_failed_buff[128];
    snprintf(s_failed_buff, sizeof(s_failed_buff), "Transcription failed. Reason: %d", 
             (int)status);
    text_layer_set_text(s_primary_layer, s_failed_buff);
  }
}

static void inbox_received_callback(DictionaryIterator *iterator, void *context) {
  APP_LOG(APP_LOG_LEVEL_INFO, "Message received!");
  Tuple *contactNameDict = dict_find(iterator, CONTACT_NAME_KEY);
  Tuple *contactNumberDict = dict_find(iterator, CONTACT_NUMBER_KEY);
  Tuple *messageConfirmationDict = dict_find(iterator, MESSAGE_CONFIRMATION_KEY);
  Tuple *connectionTestDict = dict_find(iterator, CONNECTION_TEST_KEY);

  if ((s_state == BEGINNING_STATE || s_state == DICTATED_NAME_STATE || (s_state == CHECKING_CONTACT_STATE && !has_contact)) && connectionTestDict) {
    text_layer_set_text(s_secondary_layer, connectionTestDict->value->cstring);
  }

  if (s_state == CHECKING_CONTACT_STATE && contactNameDict && contactNumberDict) {
    has_contact = true;
    snprintf(contact_name, sizeof(contact_name), "%s", (char *)contactNameDict->value->cstring);
    snprintf(number, sizeof(number), "%s", (char *)contactNumberDict->value->cstring);
    text_layer_set_text(s_instruction_layer, "Confirm contact");
    text_layer_set_text(s_primary_layer, contact_name);
    text_layer_set_text(s_secondary_layer, number);
  }

  if (s_state == FINAL_MESSAGE_STATE && messageConfirmationDict) {
    reset_all();
    text_layer_set_text(s_instruction_layer, "Sent");
    text_layer_set_text(s_primary_layer, "");
    text_layer_set_text(s_secondary_layer, "");
  }
}

static void inbox_dropped_callback(AppMessageResult reason, void *context) {
  APP_LOG(APP_LOG_LEVEL_ERROR, "Message dropped!");
}

static void outbox_failed_callback(DictionaryIterator *iterator, AppMessageResult reason, void *context) {
  APP_LOG(APP_LOG_LEVEL_ERROR, "Outbox send failed!");
}

static void outbox_sent_callback(DictionaryIterator *iterator, void *context) {
  APP_LOG(APP_LOG_LEVEL_INFO, "Outbox send success!");
}

static void window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

  s_instruction_layer = text_layer_create((GRect) { .origin = { 0, 10 }, .size = { bounds.size.w - ACTION_BAR_WIDTH, 50 }});
  text_layer_set_text(s_instruction_layer, "Choose recipient");
  text_layer_set_text_alignment(s_instruction_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(s_instruction_layer));
  text_layer_set_font(s_instruction_layer, fonts_get_system_font(FONT_KEY_GOTHIC_24_BOLD));

  s_primary_layer = text_layer_create((GRect) { .origin = { 0, 64 }, .size = { bounds.size.w - ACTION_BAR_WIDTH, 45 }});
  text_layer_set_text(s_primary_layer, "");
  text_layer_set_text_alignment(s_primary_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(s_primary_layer));
  text_layer_set_font(s_primary_layer, fonts_get_system_font(FONT_KEY_GOTHIC_18_BOLD));

  s_secondary_layer = text_layer_create((GRect) { .origin = { 0, 113 }, .size = { bounds.size.w - ACTION_BAR_WIDTH, 45 }});
  text_layer_set_text(s_secondary_layer, "Not connected");
  text_layer_set_text_alignment(s_secondary_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(s_secondary_layer));
  text_layer_set_font(s_primary_layer, fonts_get_system_font(FONT_KEY_GOTHIC_18_BOLD));

  s_actionbar = action_bar_layer_create();
  action_bar_layer_add_to_window(s_actionbar, window);
  
  // todo
  //action_bar_layer_set_icon(s_actionbar, BUTTON_ID_UP, hit_icon);
  //action_bar_layer_set_icon(s_actionbar, BUTTON_ID_DOWN, done_icon);

  s_dictation_session = dictation_session_create(sizeof(s_last_text), dictation_session_callback, NULL);

  window_set_click_config_provider(window, click_config_provider);

  send_connection_test();
}

static void window_unload(Window *window) {
  text_layer_destroy(s_instruction_layer);
  text_layer_destroy(s_primary_layer);
  text_layer_destroy(s_secondary_layer);
  action_bar_layer_destroy(s_actionbar);
  dictation_session_destroy(s_dictation_session);
}

static void init(void) {
  // Register callbacks
  app_message_register_inbox_received(inbox_received_callback);
  app_message_register_inbox_dropped(inbox_dropped_callback);
  app_message_register_outbox_failed(outbox_failed_callback);
  app_message_register_outbox_sent(outbox_sent_callback);

  // Open AppMessage with sensible buffer sizes
  app_message_open(app_message_inbox_size_maximum(), app_message_outbox_size_maximum());

  window = window_create();
  window_set_window_handlers(window, (WindowHandlers) {
    .load = window_load,
    .unload = window_unload,
  });

  window_stack_push(window, true);
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
