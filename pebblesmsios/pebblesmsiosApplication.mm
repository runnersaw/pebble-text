#import "RootViewController.h"
//#import <PebbleKit/PebbleKit.h>

@interface pebblesmsiosApplication: UIApplication <UIApplicationDelegate, PBPebbleCentralDelegate> {
	UIWindow *_window;
	RootViewController *_viewController;
	//PBWatch *_connectedWatch;
}
@property (nonatomic, retain) UIWindow *window;
//@property (nonatomic, retain) PBWatch *connectedWatch;
@end

@implementation pebblesmsiosApplication
@synthesize window = _window;
@synthesize connectedWatch = _connectedWatch;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_viewController = [[RootViewController alloc] init];
	[_window addSubview:_viewController.view];
	[_window makeKeyAndVisible];

  	//[PBPebbleCentral defaultCentral].delegate = self;

  	//[[PBPebbleCentral defaultCentral] run];
}

- (void)dealloc {
	[_viewController release];
	[_window release];
	[super dealloc];
}

/*- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
	NSLog(@"Pebble connected: %@", [watch name]);
	self.connectedWatch = watch;

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pebble connected"
	                                            message:[watch name]
	                                           delegate:self
	                                  cancelButtonTitle:@"Cancel"
	                                  otherButtonTitles:@"Say Hello",nil];
	[alert show];
	[alert release];
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
	NSLog(@"Pebble disconnected: %@", [watch name]);

	if ([watch isEqual:self.connectedWatch]) {
		self.connectedWatch = nil;
	}

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pebble disconnected"
	                                            message:@"OOPS"
	                                           delegate:self
	                                  cancelButtonTitle:@"Cancel"
	                                  otherButtonTitles:@"Say Hello",nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        NSLog(@"OK Tapped. Hello World!");
    }
}*/

@end

// vim:ft=objc
