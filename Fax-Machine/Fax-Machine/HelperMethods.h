//
//  HelperMethods.h
//  Fax-Machine
//
//  Created by Selma NB on 12/3/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface HelperMethods : NSObject

+(void)verifyAlertWithMessage:(NSString *)message;

-(void)parseVerifyEmailWithMessage:(NSString *)message;

@end
