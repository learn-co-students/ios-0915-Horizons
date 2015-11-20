//
//  Location.h
//  Fax-Machine
//
//  Created by Kevin Lin on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Location : NSObject

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) PFGeoPoint *geoPoint;
@property (nonatomic, strong) NSDate *dateTaken;

-(instancetype)initWithCity:(NSString *)city
                    country:(NSString *)country
                   geoPoint:(PFGeoPoint *)geoPoint
                  dateTaken:(NSDate *)dateTaken;

@end
