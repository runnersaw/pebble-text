//
//  SMSSender.h
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/4/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SMSSender_h
#define SMSSender_h


#endif /* SMSSender_h */

@interface PSMSSender : NSObject

- (void)sendSMS:(NSString *)number withText:(NSString *)text;

@end
