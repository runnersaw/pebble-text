//
//  PSMSRecentContactHandler.m
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/8/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSMSRecentContactHandler.h"

@implementation PSMSRecentContactHandler

- (NSMutableArray *)getRecentNames {
    
    NSLog(@"PEBBLESMS: Function should be overriden by tweak");
    return [[NSMutableArray alloc] init];
    
}

- (NSMutableArray *)getRecentPhones {
    
    NSLog(@"PEBBLESMS: Function should be overriden by tweak");
    return [[NSMutableArray alloc] init];
    
}

@end
