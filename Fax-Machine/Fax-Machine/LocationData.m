//
//  LocationData.m
//  Fax-Machine
//
//  Created by Matthew Chang on 11/17/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "LocationData.h"


@interface LocationData ()

@end

@implementation LocationData
NSString *const OPEN_WEATHER_API_URL = @"api.openweathermap.org";
NSString *const OPEN_WEATHER_API_KEY = @"66b9ac9165733a2335dd3e09acd29f5a";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//This method will log the current City
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
    {
        if (error)
        {
            NSLog(@"Error");
        }
        CLPlacemark *locationPlacemark = [placemarks objectAtIndex:0];
        NSString *currentCity = locationPlacemark.locality;
        NSLog(@"%@", currentCity);
        
        
    }];
}

-(void)getWeatherInfo:(NSString *)city WithCompletion:(void (^)(NSDictionary *))completionBlock
{
    NSURL *retrievalURL = [NSURL URLWithString:([NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@", city, OPEN_WEATHER_API_KEY])];
    NSURLSession *retrievalSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *retrievalDataTask = [retrievalSession dataTaskWithURL:retrievalURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSDictionary *retrievedWeatherDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        completionBlock(retrievedWeatherDictionary);
    }];
    [retrievalDataTask resume];
}
@end

