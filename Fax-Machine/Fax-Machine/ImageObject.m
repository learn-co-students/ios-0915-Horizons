//
//  ImageObject.m
//  Fax-Machine
//
//  Created by Kevin Lin on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "ImageObject.h"

@implementation ImageObject

-(instancetype)init{
    self = [self initWithOwner:[PFUser currentUser] title:@"" imageID:@"" likes:@0 mood:@"" location:nil comments:[@[] mutableCopy]];
    return self;
}

-(instancetype)initWithTitle:(NSString *)title imageID:(NSString *)imageID mood:(NSString *)mood location:(Location *)location{
    self = [self initWithOwner:[PFUser currentUser] title:title imageID:imageID likes:@0 mood:mood location:location comments:[@[] mutableCopy]];
    return self;
}

-(instancetype)initWithOwner:(PFUser *)owner title:(NSString *)title imageID:(NSString *)imageID likes:(NSNumber *)likes mood:(NSString *)mood location:(Location *)location comments:(NSMutableArray *)comments{
    self = [super init];
    if (self) {
        _owner = owner;
        _title = title;
        _imageID = imageID;
        _likes = likes;
        _mood = mood;
        _location = location;
        _comments = comments;
    }
    return self;
}

@end
