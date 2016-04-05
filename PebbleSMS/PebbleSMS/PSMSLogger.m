//
//  Logger.m
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 3/2/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSMSLogger.h"

@implementation PSMSLogger : NSObject

-(void)log:(NSString *)text {
    NSLog(@"%@", text);
}

@end