Pebble.addEventListener('ready', function() {
  var connectionTest = {
    'CONNECTION_TEST_KEY': 1
  };
  Pebble.sendAppMessage(
    connectionTest, 
    function(e) {
      console.log('TextSender: Sent connection test');
    },
    function(e) {
      console.log('TextSender: Error sending');
    });
});

// Listen for when an AppMessage is received
Pebble.addEventListener('appmessage',
  function(e) {
    // Assemble dictionary using our keys
    var dictionary = e.payload;
    dictionary.IS_PEBBLE_SMS_KEY = 1;

    // Send to Pebble
    Pebble.sendAppMessage(
      dictionary,
      function(e) {
        console.log('TextSender: Forwarded to Pebble, will be processed by app');
      },
      function(e) {
        console.log('TextSender: Error sending!');
      }
    );
  }
);