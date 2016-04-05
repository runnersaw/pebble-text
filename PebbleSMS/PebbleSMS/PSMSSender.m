//
//  SMSSender.m
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/4/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSMSSender.h"

@implementation PSMSSender

- (void)sendSMS:(NSString *)number withText:(NSString *)text {
    NSLog(@"SENT SMS to %@ with text %@", number, text);
}

@end