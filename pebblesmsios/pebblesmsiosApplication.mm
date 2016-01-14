#import "RootViewController.h"
#import "PebbleKit.h"

@interface pebblesmsiosApplication: UIApplication <UIApplicationDelegate> {
	UIWindow *_window;
	RootViewController *_viewController;
}
@property (nonatomic, retain) UIWindow *window;
@end

@implementation pebblesmsiosApplication
@synthesize window = _window;
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_viewController = [[RootViewController alloc] init];
	[_window addSubview:_viewController.view];
	[_window makeKeyAndVisible];

  	[PBPebbleCentral defaultCentral].delegate = self;

  	[[PBPebbleCentral defaultCentral] run];
}

- (void)dealloc {
	[_viewController release];
	[_window release];
	[super dealloc];
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
  NSLog(@"Pebble connected: %@", [watch name]);
  self.connectedWatch = watch;
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
  NSLog(@"Pebble disconnected: %@", [watch name]);

  if ([watch isEqual:self.connectedWatch]) {
    self.connectedWatch = nil;
  }
}

@end

// vim:ft=objc
