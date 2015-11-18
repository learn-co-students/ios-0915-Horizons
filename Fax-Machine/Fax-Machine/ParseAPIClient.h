//
//  ParseAPIClient.h
//  Fax-Machine
//
//  Created by Kevin Lin on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseAPIClient : NSObject

+(void)fetchUserProfileDataWithUserObject:(PFObject *)user andCompletion:(void (^)(PFObject *data))completionBlock;

@end
