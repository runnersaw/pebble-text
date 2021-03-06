#include <pebble.h>
#include "recentContactChooser.h"
#include "pebble-sms-pebble.h"
#include "tertiaryText.h"
#include "presetChooser.h"
#include "searchChooser.h"

static Window *window;
static TextLayer *s_instruction_layer;
static TextLayer *s_primary_layer;
#if defined(PBL_MICROPHONE)
static DictationSession *s_dictation_session;
#endif
static ActionBarLayer *s_actionbar;

// Declare a buffer for the DictationSession
static int s_state = BEGINNING_STATE;
static char contact_number[20];
static char contact_name[64];
static char contact_id[8];
static char dictated_name[64];
static char dictated_message[256];

static char instruction_text[64];
static char primary_text[264];

static short has_contact = false;

static short contact_try = 0;
static short is_connected = false;

static void create_bitmaps() {
  check_icon = gbitmap_create_with_resource(RESOURCE_ID_CHECK_ICON);
  x_icon = gbitmap_create_with_resource(RESOURCE_ID_X_ICON);
  recent_icon = gbitmap_create_with_resource(RESOURCE_ID_RECENT_ICON);
  abc_icon = gbitmap_create_with_resource(RESOURCE_ID_ABC_ICON);
  send_icon = gbitmap_create_with_resource(RESOURCE_ID_SEND_ICON);
  #if defined(PBL_MICROPHONE)
  microphone_icon = gbitmap_create_with_resource(RESOURCE_ID_MICROPHONE_ICON);
  #endif
}

static void destroy_bitmaps() {
  gbitmap_destroy(check_icon);
  gbitmap_destroy(x_icon);
  gbitmap_destroy(recent_icon);
  gbitmap_destroy(abc_icon);
  gbitmap_destroy(send_icon);
  #if defined(PBL_MICROPHONE)
  gbitmap_destroy(microphone_icon);
  #endif
}

void change_state(int state) {
  s_state = state;

  if (s_state == BEGINNING_STATE || s_state == DICTATED_NAME_STATE || s_state == CREATING_FINAL_MESSAGE_STATE) {
    action_bar_layer_set_icon(s_actionbar, BUTTON_ID_UP, abc_icon);
    #if defined(PBL_MICROPHONE)
    action_bar_layer_set_icon(s_actionbar, BUTTON_ID_SELECT, microphone_icon);
    #endif
    action_bar_layer_set_icon(s_actionbar, BUTTON_ID_DOWN, recent_icon);
  } else if (s_state == CONFIRMING_FINAL_MESSAGE_STATE) {
    action_bar_layer_set_icon(s_actionbar, BUTTON_ID_UP, NULL);
    action_bar_layer_set_icon(s_actionbar, BUTTON_ID_SELECT, send_icon);
    action_bar_layer_set_icon(s_actionbar, BUTTON_ID_DOWN, NULL);
  }
}

static void reset_all() {
  change_state(BEGINNING_STATE);
  contact_number[0] = '\0';
  contact_name[0] = '\0';
  contact_id[0] = '\0';
  dictated_name[0] = '\0';
  dictated_message[0] = '\0';
  has_contact = false;
  contact_try = 0;
}

static void get_recent_contacts() {
  DictionaryIterator *iter;
  app_message_outbox_begin(&iter);
  dict_write_int(iter, STATE_KEY, &s_state, 1, 0);
  app_message_outbox_send();
}

static void get_presets() {
  DictionaryIterator *iter;
  app_message_outbox_begin(&iter);
  dict_write_int(iter, STATE_KEY, &s_state, 1, 0);
  app_message_outbox_send();
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
  dict_write_cstring(iter, CONNECTION_TEST_KEY, "C");
  app_message_outbox_send();
}

static void send_final_message() {
  DictionaryIterator *iter;
  app_message_outbox_begin(&iter);
  dict_write_cstring(iter, CONTACT_NAME_KEY, contact_name);
  dict_write_cstring(iter, CONTACT_NUMBER_KEY, contact_number);
  // APP_LOG(APP_LOG_LEVEL_INFO, "contact id %s", contact_id);
  dict_write_cstring(iter, CONTACT_ID_KEY, contact_id);
  DictionaryResult res = dict_write_cstring(iter, FINAL_MESSAGE_KEY, dictated_message);
  if (res == DICT_OK) {
    // APP_LOG(APP_LOG_LEVEL_INFO, "added");
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

void contact_chosen_from_recent(char *name, char *number) {
  snprintf(contact_name, sizeof(contact_name), "%s", name);
  snprintf(contact_number, sizeof(contact_number), "%s", number);

  change_state(CREATING_FINAL_MESSAGE_STATE);
  snprintf(instruction_text, sizeof(instruction_text), "%s", "Create message");
  snprintf(primary_text, sizeof(primary_text), "%s", contact_name);
  text_layer_set_text(s_instruction_layer, instruction_text);
  text_layer_set_text(s_primary_layer, primary_text);
}

void search_chosen(char *name, char *number, char *id) {
  snprintf(contact_name, sizeof(contact_name), "%s", name);
  snprintf(contact_number, sizeof(contact_number), "%s", number);
  // APP_LOG(APP_LOG_LEVEL_INFO, "contact id %s", id);
  snprintf(contact_id, sizeof(contact_number), "%s", id);
  // APP_LOG(APP_LOG_LEVEL_INFO, contact_id);

  change_state(CREATING_FINAL_MESSAGE_STATE);
  snprintf(instruction_text, sizeof(instruction_text), "%s", "Create message");
  text_layer_set_text(s_instruction_layer, instruction_text);
  snprintf(primary_text, sizeof(primary_text), "%s", contact_name);
  text_layer_set_text(s_primary_layer, primary_text);
}

void search_not_chosen() {
  reset_all();

  snprintf(instruction_text, sizeof(instruction_text), "%s", "Choose recipient");
  text_layer_set_text(s_instruction_layer, instruction_text);

  primary_text[0] = '\0';
  text_layer_set_text(s_primary_layer, primary_text);
}

void tertiary_text_chosen(char *text) {
  if (s_state == BEGINNING_STATE) {
    snprintf(dictated_name, sizeof(dictated_name), "%s", text);

    snprintf(instruction_text, sizeof(instruction_text), "%s", "Loading Contact...");
    snprintf(primary_text, sizeof(primary_text), "%s", dictated_name);
    text_layer_set_text(s_instruction_layer, instruction_text);
    text_layer_set_text(s_primary_layer, primary_text);

    change_state(CHECKING_CONTACT_STATE);

    action_bar_layer_set_icon(s_actionbar, BUTTON_ID_UP, NULL);
    action_bar_layer_set_icon(s_actionbar, BUTTON_ID_SELECT, NULL);
    action_bar_layer_set_icon(s_actionbar, BUTTON_ID_DOWN, NULL);

    get_contact();
  }

  if (s_state == CREATING_FINAL_MESSAGE_STATE) {
    change_state(CONFIRMING_FINAL_MESSAGE_STATE);
    snprintf(dictated_message, sizeof(dictated_message), "%s", text);

    snprintf(instruction_text, sizeof(instruction_text), "%s", contact_name);
    snprintf(primary_text, sizeof(primary_text), "%s", dictated_message);
    text_layer_set_text(s_instruction_layer, instruction_text);
    text_layer_set_text(s_primary_layer, primary_text);
  }
}

void preset_chosen(char *text) {
  if (s_state == CREATING_FINAL_MESSAGE_STATE || s_state == GETTING_PRESETS_STATE) {
    change_state(CONFIRMING_FINAL_MESSAGE_STATE);
    snprintf(dictated_message, sizeof(dictated_message), "%s", text);

    snprintf(instruction_text, sizeof(instruction_text), "%s", contact_name);
    snprintf(primary_text, sizeof(primary_text), "%s", dictated_message);
    text_layer_set_text(s_instruction_layer, instruction_text);
    text_layer_set_text(s_primary_layer, primary_text);
  }
}

#if defined(PBL_MICROPHONE)
static void dictation_session_callback(DictationSession *session, DictationSessionStatus status, 
                                       char *transcription, void *context) {
  // Print the results of a transcription attempt                                     
  // APP_LOG(APP_LOG_LEVEL_INFO, "Dictation status: %d", (int)status);

  if(status == DictationSessionStatusSuccess) {
    // just dictated name
    if (s_state == BEGINNING_STATE) {
      snprintf(dictated_name, sizeof(dictated_name), "%s", transcription);

      snprintf(instruction_text, sizeof(instruction_text), "%s", "Loading Contact...");
      snprintf(primary_text, sizeof(primary_text), "%s", dictated_name);
      text_layer_set_text(s_instruction_layer, instruction_text);
      text_layer_set_text(s_primary_layer, primary_text);

      change_state(CHECKING_CONTACT_STATE);

      action_bar_layer_set_icon(s_actionbar, BUTTON_ID_UP, NULL);
      action_bar_layer_set_icon(s_actionbar, BUTTON_ID_SELECT, NULL);
      action_bar_layer_set_icon(s_actionbar, BUTTON_ID_DOWN, NULL);

      get_contact();
    }

    // just dictated message
    if (s_state == CREATING_FINAL_MESSAGE_STATE) {
      change_state(CONFIRMING_FINAL_MESSAGE_STATE);
      snprintf(dictated_message, sizeof(dictated_message), "%s", transcription);

      snprintf(instruction_text, sizeof(instruction_text), "%s", contact_name);
      snprintf(primary_text, sizeof(primary_text), "%s", dictated_message);
      text_layer_set_text(s_instruction_layer, instruction_text);
      text_layer_set_text(s_primary_layer, primary_text);
    }
  }
}
#endif

static void select_click_handler(ClickRecognizerRef recognizer, void *context) {  
  if (!is_connected) {
    return;
  }
  // Start dictation UI
  #if defined(PBL_MICROPHONE)
  if (s_dictation_session == NULL) {
    s_dictation_session = dictation_session_create(sizeof(dictated_message), dictation_session_callback, NULL);
    if (s_dictation_session != NULL) {
      dictation_session_enable_confirmation(s_dictation_session, false);
    }
  }
  if (s_state == BEGINNING_STATE) {
    dictation_session_start(s_dictation_session);
  }

  if (s_state == CREATING_FINAL_MESSAGE_STATE) {
    dictation_session_start(s_dictation_session);
  }
  #endif
  if (s_state == CONFIRMING_FINAL_MESSAGE_STATE) {
    change_state(SENDING_FINAL_MESSAGE_STATE);
    send_final_message();

    action_bar_layer_set_icon(s_actionbar, BUTTON_ID_UP, NULL);
    action_bar_layer_set_icon(s_actionbar, BUTTON_ID_SELECT, NULL);
    action_bar_layer_set_icon(s_actionbar, BUTTON_ID_DOWN, NULL);
  }
}

static void up_click_handler(ClickRecognizerRef recognizer, void *context) {
  if (!is_connected) {
    return;
  }
  if (s_state == BEGINNING_STATE || s_state == CREATING_FINAL_MESSAGE_STATE) {
    tertiary_init();
  }
}

static void down_click_handler(ClickRecognizerRef recognizer, void *context) {
  if (!is_connected) {
    return;
  }
  if (s_state == BEGINNING_STATE) {
    recent_contact_chooser_init();
    change_state(GETTING_RECENT_CONTACTS_STATE);
    get_recent_contacts();
  } else if (s_state == CREATING_FINAL_MESSAGE_STATE) {
    preset_init();
    change_state(GETTING_PRESETS_STATE);
    get_presets();
  }
}

static void back_click_handler(ClickRecognizerRef recognizer, void *context) {
  if (s_state == BEGINNING_STATE) {
    window_stack_pop(true);
  } else if (s_state == CHECKING_CONTACT_STATE && has_contact) {
    // contact_try++;
    // get_contact();
    // has_contact = false;
  } else if (s_state == CREATING_FINAL_MESSAGE_STATE) {
    reset_all();

    snprintf(instruction_text, sizeof(instruction_text), "%s", "Choose recipient");
    text_layer_set_text(s_instruction_layer, instruction_text);

    primary_text[0] = '\0';
    text_layer_set_text(s_primary_layer, primary_text);
  } else if (s_state == CONFIRMING_FINAL_MESSAGE_STATE) {
    change_state(CREATING_FINAL_MESSAGE_STATE);

    dictated_message[0] = '\0';

    snprintf(instruction_text, sizeof(instruction_text), "%s", "Create message");
    snprintf(primary_text, sizeof(primary_text), "%s", contact_name);
    text_layer_set_text(s_instruction_layer, instruction_text);
    text_layer_set_text(s_primary_layer, primary_text);
    // dictated_message[0] = '\0';
    // snprintf(primary_text, sizeof(primary_text), "%s", dictated_message);
    // text_layer_set_text(s_primary_layer, primary_text);
    // change_state(CREATING_FINAL_MESSAGE_STATE);
  }
}

static void click_config_provider(void *context) {
  window_single_click_subscribe(BUTTON_ID_SELECT, select_click_handler);
  window_single_click_subscribe(BUTTON_ID_UP, up_click_handler);
  window_single_click_subscribe(BUTTON_ID_DOWN, down_click_handler);
  window_single_click_subscribe(BUTTON_ID_BACK, back_click_handler);
}

static int are_strings_equal(char *str1, char *str2) {
  int i=0;
  while (1) {
    if (*(str1+i) != *(str2+i)) {
      return 0;
    }
    if (*(str1+i) == '\0') {
      return 1;
    }
    i++;
    if (i==1000) { // max size
      return 1;
    }
  }
}

static void inbox_received_callback(DictionaryIterator *iterator, void *context) {
  // APP_LOG(APP_LOG_LEVEL_INFO, "recieved message");
  Tuple *connectionTestDict = dict_find(iterator, CONNECTION_TEST_KEY);
  if (s_state == BEGINNING_STATE && connectionTestDict) {
    is_connected = true;
    snprintf(primary_text, sizeof(primary_text), "%s", "Connected");
    text_layer_set_text(s_primary_layer, primary_text);
  }

  if (s_state == CHECKING_CONTACT_STATE) {
    Tuple *contactNamesDict = dict_find(iterator, CONTACT_NAMES_KEY);
    Tuple *contactNumbersDict = dict_find(iterator, CONTACT_NUMBERS_KEY);
    Tuple *contactIdsDict = dict_find(iterator, CONTACT_IDS_KEY);

    Tuple *contactNameDict = dict_find(iterator, CONTACT_NAME_KEY);
    Tuple *contactNumberDict = dict_find(iterator, CONTACT_NUMBER_KEY);

    if (contactNamesDict && contactNumbersDict && contactIdsDict) {
      // action_bar_layer_set_icon(s_actionbar, BUTTON_ID_UP, check_icon);
      // action_bar_layer_set_icon(s_actionbar, BUTTON_ID_DOWN, x_icon);

      search_contact_chooser_init();
      set_search_response((char *)contactNamesDict->value->cstring, (char *)contactNumbersDict->value->cstring, (char *)contactIdsDict->value->cstring);
    } else if (contactNameDict && contactNumberDict) {
      action_bar_layer_set_icon(s_actionbar, BUTTON_ID_UP, check_icon);
      action_bar_layer_set_icon(s_actionbar, BUTTON_ID_DOWN, x_icon);

      has_contact = true;
      snprintf(contact_name, sizeof(contact_name), "%s", (char *)contactNameDict->value->cstring);
      snprintf(contact_number, sizeof(contact_number), "%s", (char *)contactNumberDict->value->cstring);

      snprintf(instruction_text, sizeof(instruction_text), "%s", contact_name);
      snprintf(primary_text, sizeof(primary_text), "%s", contact_number);
      text_layer_set_text(s_instruction_layer, instruction_text);
      text_layer_set_text(s_primary_layer, primary_text);
    }
  }

  Tuple *recievedDict = dict_find(iterator, RECIEVED_FINAL_MESSAGE_KEY);
  if (s_state == SENDING_FINAL_MESSAGE_STATE && recievedDict) {
    change_state(FINAL_MESSAGE_STATE);
    
    snprintf(instruction_text, sizeof(instruction_text), "%s", recievedDict->value->cstring);
    snprintf(primary_text, sizeof(primary_text), "%s", "");
    text_layer_set_text(s_instruction_layer, instruction_text);
    text_layer_set_text(s_primary_layer, primary_text);
  }

  Tuple *messageConfirmationDict = dict_find(iterator, MESSAGE_CONFIRMATION_KEY);
  if (s_state == FINAL_MESSAGE_STATE && messageConfirmationDict) {
    reset_all();
    
    snprintf(instruction_text, sizeof(instruction_text), "%s", messageConfirmationDict->value->cstring);
    snprintf(primary_text, sizeof(primary_text), "%s", "Choose another recipient");
    text_layer_set_text(s_instruction_layer, instruction_text);
    text_layer_set_text(s_primary_layer, primary_text);

    if (are_strings_equal(messageConfirmationDict->value->cstring, "Sent")) {
      vibes_short_pulse();
    } else {
      static const uint32_t const segments[] = { 300, 200, 300 };
      VibePattern pat = {
        .durations = segments,
        .num_segments = ARRAY_LENGTH(segments),
      };
      vibes_enqueue_custom_pattern(pat);
    }
  }

  Tuple *recentContactsName = dict_find(iterator, RECENT_CONTACTS_NAME_KEY);
  Tuple *recentContactsNumber = dict_find(iterator, RECENT_CONTACTS_NUMBER_KEY);
  if (s_state == GETTING_RECENT_CONTACTS_STATE && recentContactsName && recentContactsNumber) {
    set_recent_contacts(recentContactsName->value->cstring, recentContactsNumber->value->cstring);
  }

  Tuple *presets = dict_find(iterator, PRESETS_KEY);
  if (s_state == GETTING_PRESETS_STATE && presets) {
    set_presets(presets->value->cstring);
  }
}

static void inbox_dropped_callback(AppMessageResult reason, void *context) {
  APP_LOG(APP_LOG_LEVEL_ERROR, "Message dropped! %d", reason);
}

static void outbox_failed_callback(DictionaryIterator *iterator, AppMessageResult reason, void *context) {
  APP_LOG(APP_LOG_LEVEL_ERROR, "Outbox send failed! %d", reason);
}

static void outbox_sent_callback(DictionaryIterator *iterator, void *context) {
  // APP_LOG(APP_LOG_LEVEL_INFO, "Outbox send success!");
}

static void window_load(Window *window) {
  create_bitmaps();

  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

  #if defined(PBL_ROUND)
  s_instruction_layer = text_layer_create((GRect) { .origin = { 0, 5 }, .size = { bounds.size.w - ACTION_BAR_WIDTH, 60 }});
  #else
  s_instruction_layer = text_layer_create((GRect) { .origin = { 0, 5 }, .size = { bounds.size.w - ACTION_BAR_WIDTH, 55 }});
  #endif
    
  snprintf(instruction_text, sizeof(instruction_text), "%s", "Choose recipient");
  text_layer_set_text(s_instruction_layer, instruction_text);
  text_layer_set_text_alignment(s_instruction_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(s_instruction_layer));
  text_layer_set_font(s_instruction_layer, fonts_get_system_font(FONT_KEY_GOTHIC_24_BOLD));
  text_layer_set_overflow_mode(s_instruction_layer, GTextOverflowModeWordWrap);
  #if defined(PBL_ROUND)
  text_layer_enable_screen_text_flow_and_paging(s_instruction_layer, 2);
  #endif

  #if defined(PBL_ROUND)
  s_primary_layer = text_layer_create((GRect) { .origin = { 0, 70 }, .size = { bounds.size.w - ACTION_BAR_WIDTH, 100 }});
  #else
  s_primary_layer = text_layer_create((GRect) { .origin = { 0, 65 }, .size = { bounds.size.w - ACTION_BAR_WIDTH, 100 }});
  #endif

  snprintf(primary_text, sizeof(primary_text), "%s", "Not connected");
  text_layer_set_text(s_primary_layer, primary_text);
  text_layer_set_text_alignment(s_primary_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(s_primary_layer));
  text_layer_set_font(s_primary_layer, fonts_get_system_font(FONT_KEY_GOTHIC_24));
  text_layer_set_overflow_mode(s_primary_layer, GTextOverflowModeWordWrap);
  #if defined(PBL_ROUND)
  text_layer_enable_screen_text_flow_and_paging(s_primary_layer, 2);
  #endif

  s_actionbar = action_bar_layer_create();
  action_bar_layer_add_to_window(s_actionbar, window);
  
  action_bar_layer_set_icon(s_actionbar, BUTTON_ID_UP, abc_icon);
  #if defined(PBL_MICROPHONE)
  action_bar_layer_set_icon(s_actionbar, BUTTON_ID_SELECT, microphone_icon);
  #endif
  action_bar_layer_set_icon(s_actionbar, BUTTON_ID_DOWN, recent_icon);

  #if defined(PBL_MICROPHONE)
  s_dictation_session = dictation_session_create(sizeof(dictated_message), dictation_session_callback, NULL);
  if (s_dictation_session != NULL) {
    dictation_session_enable_confirmation(s_dictation_session, false);
  }
  #endif

  window_set_click_config_provider(window, click_config_provider);

  send_connection_test();
}

static void window_unload(Window *window) {
  destroy_bitmaps();
  text_layer_destroy(s_instruction_layer);
  text_layer_destroy(s_primary_layer);
  action_bar_layer_destroy(s_actionbar);
  #if defined(PBL_MICROPHONE)
  dictation_session_destroy(s_dictation_session);
  #endif
}

static void init(void) {
  // Register callbacks
  app_message_register_inbox_received(inbox_received_callback);
  app_message_register_inbox_dropped(inbox_dropped_callback);
  app_message_register_outbox_failed(outbox_failed_callback);
  app_message_register_outbox_sent(outbox_sent_callback);

  // Open AppMessage with sensible buffer sizes
  app_message_open(1024, 1024);

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

  // APP_LOG(APP_LOG_LEVEL_DEBUG, "Done initializing, pushed window: %p", window);

  app_event_loop();
  deinit();
}
