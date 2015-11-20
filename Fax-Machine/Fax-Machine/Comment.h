//
//  Comment.h
//  Fax-Machine
//
//  Created by Kevin Lin on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "ImageObject.h"

@interface Comment : NSObject

@property (nonatomic, strong) NSString *userComment;
@property (nonatomic, strong) PFUser *owner;
@property (nonatomic, strong) ImageObject *relatedImage;

-(instancetype)initWithComment:(NSString *)userComment
                          user:(PFUser *)owner
                         image:(ImageObject *)relatedImage;

-(instancetype)initWithComment:(NSString *)userComment
                         image:(ImageObject *)relatedImage;

@end
