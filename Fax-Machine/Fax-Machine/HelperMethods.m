//
//  HelperMethods.m
//  Fax-Machine
//
//  Created by Selma NB on 12/3/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "HelperMethods.h"

@implementation HelperMethods

+(void)verifyAlertWithMessage:(NSString *)message viewController:(UIViewController *)view
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defautAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //enter code here
    }];
    [alert addAction:defautAction];
    //Present action where needed
    [view presentViewController:alert animated:YES completion:nil];
    
    
}
-(void)parseVerifyEmailWithMessage:(NSString *)message viewController:(UIViewController *)view
{
    PFUser *user = [PFUser currentUser];
    if (![[user objectForKey:@"emailVerified"] boolValue] && user.email != nil) {
        [user fetch];
        if(![[user objectForKey:@"emailVerified"] boolValue])
        {
            [HelperMethods verifyAlertWithMessage:message viewController:view];        }
        
    }
}

@end
