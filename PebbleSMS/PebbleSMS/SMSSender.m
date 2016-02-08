//
//  SMSSender.m
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/4/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSSender.h"
#import <notify.h>

@implementation SMSSender

- (void)sendSMS:(NSString *)number withText:(NSString *)text {
    NSLog(@"SENT SMS to %@ with text %@", number, text);
    
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDistributedNotificationCenter *center = [NSDistributedMessagingCenter defaultCenter];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:@"messageWithInfo" userInfo:dict]; //send an NSDictionary here to pass data
        NSLog(@"PEBBLESMS: Sent message 3");
    });*/
}

@end