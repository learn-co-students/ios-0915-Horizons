//
//  LocationData.m
//  Fax-Machine
//
//  Created by Matthew Chang on 11/17/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//
#import "LocationData.h"
#import "APIConstants.h"
#import "FXMCity.h"
#import "FXMWeather.h"
#import <ImageIO/CGImageProperties.h>
#import <ImageIO/CGImageSource.h>


@interface LocationData ()

@property (strong, nonatomic) UIImage *image;

@end

@implementation LocationData


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



+ (void)getWeatherInfoFromDictionary:(NSDictionary *)retrievedDictionary
                      withCompletion:(void (^)(NSDictionary *))completionBlock
{
    CLLocation *retrievedLocation = retrievedDictionary[@"location"];
    NSDate *retrievedDate = retrievedDictionary[@"date"];
    
    //date from dictionary formatted for api use
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *dateWithFormatting = [dateFormatter stringFromDate:retrievedDate];
    NSString *timeWithFormatting = [timeFormatter stringFromDate:retrievedDate];
    //[YYYY]-[MM]-[DD]T[HH]:[MM]:[SS]
    
    //latitude and longitude taken from dictionary for api use
    CGFloat latitude = retrievedLocation.coordinate.latitude;
    CGFloat longitude = retrievedLocation.coordinate.longitude;
    
    
    
    NSURL *retrievalURL = [NSURL URLWithString:([NSString stringWithFormat:@"%@%@/%f,%f,%@T%@", FORECASTIO_API_URL, FORECASTIO_API_KEY, latitude, longitude, dateWithFormatting, timeWithFormatting])];
    NSURLSession *retrievalSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *retrievalDataTask = [retrievalSession dataTaskWithURL:retrievalURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                               {
                                                   NSDictionary *retrievedWeatherDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                   completionBlock(retrievedWeatherDictionary);
                                               }];
    [retrievalDataTask resume];
    
    
}


+(PHAsset *) logMetaDataFromImage:(NSURL *)imageURL {
    
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageURL] options:nil];
    

    return result.firstObject;
}
//Block that gives back the city's name in a string and date image was taken in NSDate

+ (void)getCityAndDateFromDictionary:(NSDictionary *)dictionary withCompletion:(void (^)(NSString *city,NSString *country, NSDate *date, BOOL success))completionBlock {
    
    CLLocation *location = dictionary[@"location"];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Get Location error: %@", error.localizedDescription);
        }
        
        CLPlacemark *locationPlacemark = [placemarks objectAtIndex:0];
        NSString *cityTaken = locationPlacemark.locality;
        NSString *countryTaken = locationPlacemark.country;
        NSDate *dateTaken = dictionary[@"date"];
        
        completionBlock(cityTaken, countryTaken, dateTaken, YES);


    }];
    
    
    
}

@end


