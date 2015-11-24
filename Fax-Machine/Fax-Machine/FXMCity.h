//
//  FXMCity.h
//  Fax-Machine
//
//  Created by Matthew Chang on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXMWeather.h"

@interface FXMCity : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FXMWeather *currentWeather;

- (instancetype)initWithName:(NSString *)name
           andCurrentWeather:(FXMWeather *)weather;

@end
