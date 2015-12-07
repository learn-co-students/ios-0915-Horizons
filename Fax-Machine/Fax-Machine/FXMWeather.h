//
//  FXMWeather.h
//  Fax-Machine
//
//  Created by Matthew Chang on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXMWeather : NSObject

//@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *name;


+ (instancetype)createWeatherFromDictionary:(NSDictionary *)dictionary;


@end
