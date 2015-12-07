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
    
    //    self.locationManager = [[CLLocationManager alloc] init];
    //
    //    self.locationManager.delegate = self;
    //    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //    [self.locationManager requestWhenInUseAuthorization];
    //    [self.locationManager startUpdatingLocation];
    
    
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


// ***This method was written for getting current location data.  No longer relevant if we're getting location data from photos meta***

//This method will log the current City
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
//
//    CLLocation *currentLocation = [locations lastObject];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//
//    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//
//        if (error) {
//            NSLog(@"Error");
//        }
//
//        CLPlacemark *locationPlacemark = [placemarks objectAtIndex:0];
//        NSString *currentCity = locationPlacemark.locality;
//
//        __block NSString *name = [currentCity copy];
//
//        [LocationData getWeatherInfoFromCity:currentCity
//                              withCompletion:^(NSDictionary *weatherInfo) {
//
//
//                                  NSLog(@"This is a dictionary with stuff in int: %@", weatherInfo);
//
//
//
//
//
////                                  FXMWeather *weatherOfCurrentCity = [FXMWeather createWeatherFromDictionary:weatherInfo];
////
////                                  FXMCity *currentCity = [[FXMCity alloc] initWithName:name
////                                                                     andCurrentWeather:weatherOfCurrentCity];
//
//                              }];
//
//        NSLog(@"%@", currentCity);
//    }];
//
//}
//this method needs the currentCity to be passed to it to get the city's current weather

+ (void)getWeatherInfoFromDictionary:(NSDictionary *)retrievedDictionary
                      withCompletion:(void (^)(NSDictionary *))completionBlock
{
    CLLocation *retrievedLocation = retrievedDictionary[@"location"];
    NSDate *retrievedDate = retrievedDictionary[@"date"];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //block gets city name...how do i use the string cityTaken in the main method body?
    
//    [geocoder reverseGeocodeLocation:retrievedLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        
//        if (error)
//        {
//            NSLog(@"Error");
//        }
//        
//        CLPlacemark *locationPlacemark = [placemarks objectAtIndex:0];
//        NSString *cityTaken = locationPlacemark.locality;
//        completionBlock(cityTaken);
//        
//    }];
    
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

//This method returns a CLLocation.
//+(NSDictionary *)gettingImageData:(UIImage *)image
//{
//    [self logMetaDataFromImage:image];
////    NSData *pngData = UIImageJPEGRepresentation(image, 1);
////    //    UIImage *theActualImage = [UIImage imageWithData:jpegData];
////    CGImageSourceRef imageData= CGImageSourceCreateWithData((CFDataRef)pngData, NULL);
////    NSDictionary *metadata = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(imageData, 0, NULL);
////    NSDictionary *exifGPSDictionary = [metadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
////    
////    if(exifGPSDictionary)
////    {
////        NSLog(@"WOO! %@", exifGPSDictionary);
////    }
////    
////    
////    
////    
//////    CGFloat latitude = [[exifGPSDictionary objectForKey:(NSString *)kCGImagePropertyGPSLatitude] floatValue];
//////    CGFloat longitutde = [[exifGPSDictionary objectForKey:(NSString *)kCGImagePropertyGPSLongitude] floatValue];
//////    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitutde];
//////    NSDate *dateOfOriginal = [metadata objectForKey:(NSString *)kCGImagePropertyExifDateTimeOriginal];
//////    NSDictionary *retrievedData = @{@"location":newLocation,
//////                                       @"date":dateOfOriginal};
//    return retrievedData;
//    
//}

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

        
        //            __block NSString *name = [currentCity copy];
        //
        //            [LocationData getWeatherInfoFromCity:currentCity
        //                                  withCompletion:^(NSDictionary *weatherInfo) {
        //
        //
        //                                      NSLog(@"This is a dictionary with stuff in int: %@", weatherInfo);
        //
        //
        //
        //
        //
        //                                  FXMWeather *weatherOfCurrentCity = [FXMWeather createWeatherFromDictionary:weatherInfo];
        //
        //                                  FXMCity *currentCity = [[FXMCity alloc] initWithName:name
        //                                                                     andCurrentWeather:weatherOfCurrentCity];
        
    }];
    
    
    
}

@end


