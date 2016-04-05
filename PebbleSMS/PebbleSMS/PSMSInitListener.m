//
//  PSMSInitListener.m
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/22/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSMSInitListener.h"

@implementation PSMSInitListener : NSObject 

- (void)applicationLaunched {
    NSLog(@"PEBBLESMS: Initted, Function should be overriden by tweak");
}

@end