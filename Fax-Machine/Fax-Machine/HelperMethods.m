//
//  HelperMethods.m
//  Fax-Machine
//
//  Created by Selma NB on 12/3/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "HelperMethods.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>

@implementation HelperMethods

+(void)verifyAlertWithMessage:(NSString *)message{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showNotice:@"Notice!" subTitle:message closeButtonTitle:@"Okay" duration:0];
}

-(void)parseVerifyEmailWithMessage:(NSString *)message
{
    PFUser *user = [PFUser currentUser];
    if (![[user objectForKey:@"emailVerified"] boolValue] && user.email != nil) {
        [user fetch];
        if(![[user objectForKey:@"emailVerified"] boolValue])
        {
            [HelperMethods verifyAlertWithMessage:message];
        }
    }
}

@end
