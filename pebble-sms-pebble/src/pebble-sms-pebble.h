// message keys
#define DICTATED_NAME_KEY 0
#define IS_CONTACT_CORRECT_KEY 1
#define FINAL_MESSAGE_KEY 3
#define STATE_KEY 4
#define CONTACT_NAME_KEY 5
#define CONTACT_NUMBER_KEY 6
#define MESSAGE_CONFIRMATION_KEY 7
#define ATTEMPT_NUMBER_KEY 8
#define CONNECTION_TEST_KEY 9
#define RECENT_CONTACTS_NAME_KEY 10
#define RECENT_CONTACTS_NUMBER_KEY 11
#define PRESETS_KEY 12

// define states
#define BEGINNING_STATE 0
#define DICTATED_NAME_STATE 1
#define CHECKING_CONTACT_STATE 2
#define CREATING_FINAL_MESSAGE_STATE 3
#define CONFIRMING_FINAL_MESSAGE_STATE 4
#define FINAL_MESSAGE_STATE 5
#define GETTING_RECENT_CONTACTS_STATE 6
#define GETTING_PRESETS_STATE 7

static GBitmap *check_icon;
static GBitmap *x_icon;
static GBitmap *recent_icon;
#if defined(PBL_MICROPHONE)
static GBitmap *microphone_icon;
#endif
static GBitmap *abc_icon;

void change_state(int state);
void contact_chosen_from_recent(char *name, char *number);
void tertiary_text_chosen(char *text);
void preset_chosen(char *text);