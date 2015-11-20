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

+ (void)getWeatherInfoFromDictionary:(NSDictionary *)retrievedDictionary withCompletion:(void (^)(NSDictionary *))completionBlock;

+(NSDictionary *)gettingImageData:(UIImage *)image;

+ (void)getCityAndDateFromDictionary:(NSDictionary *)dictionary withCompletion:(void (^)(NSString *city,NSString *country, NSDate *date, BOOL success))completionBlock;
@end
