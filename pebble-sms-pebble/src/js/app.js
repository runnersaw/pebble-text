Pebble.addEventListener('ready', function() {
  // PebbleKit JS is ready!
  console.log('PebbleKit JS reaaady!');
  
  var connectionTest = {
    'CONNECTION_TEST_KEY': 1
  };
  Pebble.sendAppMessage(
    connectionTest, 
    function(e) {
      console.log('sent');
    },
    function(e) {
      console.log('failed to send');
    });
});

// Listen for when an AppMessage is received
Pebble.addEventListener('appmessage',
  function(e) {
    console.log('AppMessage received!');
    console.log(e);
    console.log(JSON.stringify(e, null, 4));
    
    // Assemble dictionary using our keys
    var dictionary = e.payload;
    dictionary.IS_PEBBLE_SMS_KEY = 1;

    // Send to Pebble
    Pebble.sendAppMessage(
      dictionary,
      function(e) {
        console.log('Weather info sent to Pebble successfully!');
      },
      function(e) {
        console.log('Error sending weather info to Pebble!');
      }
    );
  }
);