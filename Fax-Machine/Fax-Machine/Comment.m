//
//  Comment.m
//  Fax-Machine
//
//  Created by Kevin Lin on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "Comment.h"

@implementation Comment

-(instancetype)init{
    self = [self initWithComment:@"" user:[PFUser currentUser] image:nil];
    return self;
}

-(instancetype)initWithComment:(NSString *)userComment image:(PFObject *)relatedImage{
    self = [self initWithComment:userComment user:[PFUser currentUser] image:relatedImage];
    return self;
}

-(instancetype)initWithComment:(NSString *)userComment user:(PFUser *)owner image:(PFObject *)relatedImage{
    self = [super init];
    if (self) {
        _userComment = userComment;
        _owner = owner;
        _relatedImage = relatedImage;
    }
    return self;
}

@end
