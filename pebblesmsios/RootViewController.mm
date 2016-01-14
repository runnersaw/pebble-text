#import "RootViewController.h"
#import <PebbleKit/PebbleKit.h>

@implementation RootViewController
- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor redColor];
}
@end
