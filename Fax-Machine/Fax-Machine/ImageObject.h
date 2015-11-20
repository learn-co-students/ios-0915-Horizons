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
@property (nonatomic, strong) NSString *imageID;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSString *mood;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSMutableArray  *comments;

-(instancetype)initWithTitle:(NSString *)title
                     imageID:(NSString *)imageID
                        mood:(NSString *)mood
                    location:(Location *)location;

-(instancetype)initWithOwner:(PFUser *)owner
                       title:(NSString *)title
                     imageID:(NSString *)imageID
                       likes:(NSNumber *)likes
                        mood:(NSString *)mood
                    location:(Location *)location
                    comments:(NSMutableArray *)comments;

@end
