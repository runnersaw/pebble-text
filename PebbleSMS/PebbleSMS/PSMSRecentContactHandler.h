//
//  PSMSRecentContactHandler.h
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/8/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

#ifndef PSMSRecentContactHandler_h
#define PSMSRecentContactHandler_h

@interface PSMSRecentContactHandler : NSObject

- (NSMutableArray *)getRecentNames;
- (NSMutableArray *)getRecentPhones;

@end

#endif /* PSMSRecentContactHandler_h */
