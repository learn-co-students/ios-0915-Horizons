//
//  FXMCity.m
//  Fax-Machine
//
//  Created by Matthew Chang on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "FXMCity.h"
#import "LocationData.h"

@implementation FXMCity

- (instancetype)initWithName:(NSString *)name
           andCurrentWeather:(FXMWeather *)weather {
    
    self = [super init];
    
    if (self) {
        
        _name = name;
        _currentWeather = weather;

    }
    
    return self;
}

@end
