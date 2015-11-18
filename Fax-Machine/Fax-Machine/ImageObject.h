//
//  ImageObject.h
//  Fax-Machine
//
//  Created by Kevin Lin on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Location.h"

@interface ImageObject : NSObject

@property (nonatomic, strong) PFUser *owner;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *photoID;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSString *mood;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSArray  *comments;

-(instancetype)initWithTitle:(NSString *)title
                     photoID:(NSString *)photoID
                        mood:(NSString *)mood
                    location:(Location *)location;

-(instancetype)initWithOwner:(PFUser *)owner
                       title:(NSString *)title
                     photoID:(NSString *)photoID
                       likes:(NSNumber *)likes
                        mood:(NSString *)mood
                    location:(Location *)location
                    comments:(NSArray *)comments;

@end
