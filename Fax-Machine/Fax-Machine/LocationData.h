//
//  LocationData.h
//  Fax-Machine
//
//  Created by Matthew Chang on 11/17/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationData : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

+ (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations;

+ (void)getWeatherInfoFromCity:(NSString *)city onDate:(NSDate *)date withCompletion:(void (^)(NSDictionary *))completionBlock;

+ (void)getCityAndDateFromDictionary:(NSDictionary *)dictionary withCompletion:(void (^)(NSString *city,NSDate *date, BOOL success))completionBlock;


@end
