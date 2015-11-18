//
//  FXMWeather.m
//  Fax-Machine
//
//  Created by Matthew Chang on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "FXMWeather.h"

@implementation FXMWeather

+ (instancetype)createWeatherFromDictionary:(NSDictionary *)dictionary {
    
    FXMWeather *newWeather = [[FXMWeather alloc] init];
    
//    newWeather.name = dictionary[@"name"]; <-- implement this
    
    
    
    
    //IMPLEMENT THIS WEATHER OBJECT FROM THE DICTIONARY PASSED IN
    
    
    
    
    
    
    
    
    return newWeather;
}

//{"coord":{"lon":-74.01,"lat":40.71},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}],"base":"cmc stations","main":{"temp":289.241,"pressure":1029.44,"humidity":56,"temp_min":289.241,"temp_max":289.241,"sea_level":1043.52,"grnd_level":1029.44},"wind":{"speed":3.32,"deg":145.002},"clouds":{"all":48},"dt":1447874051,"sys":{"message":0.0027,"country":"US","sunrise":1447847218,"sunset":1447882520},"id":5128581,"name":"New York","cod":200}


@end
