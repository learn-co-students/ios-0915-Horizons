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
    self = [self initWithOwner:[PFUser currentUser] title:@"" photoID:@"" likes:@0 mood:@"" location:nil comments:@[]];
    return self;
}

-(instancetype)initWithTitle:(NSString *)title photoID:(NSString *)photoID mood:(NSString *)mood location:(Location *)location{
    self = [self initWithOwner:[PFUser currentUser] title:title photoID:photoID likes:@0 mood:mood location:location comments:@[]];
    return self;
}

-(instancetype)initWithOwner:(PFUser *)owner title:(NSString *)title photoID:(NSString *)photoID likes:(NSNumber *)likes mood:(NSString *)mood location:(Location *)location comments:(NSArray *)comments{
    self = [super init];
    if (self) {
        _owner = owner;
        _title = title;
        _photoID = photoID;
        _likes = likes;
        _mood = mood;
        _location = location;
        _comments = comments;
    }
    return self;
}

@end
