//
//  Location.m
//  Fax-Machine
//
//  Created by Kevin Lin on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "Location.h"

@implementation Location

-(instancetype)init{
    self = [self initWithCity:@"'" country:@"" geoPoint:nil dateTaken:nil];
    return self;
}

-(instancetype)initWithCity:(NSString *)city country:(NSString *)country geoPoint:(PFGeoPoint *)geoPoint dateTaken:(NSDate *)dateTaken{
    self = [super init];
    if (self) {
        _city = city;
        _country = country;
        _geoPoint = geoPoint;
        _dateTaken = dateTaken;
    }
    
    return self;
}

@end
