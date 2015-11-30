//
//  APIConstants.h
//  Fax-Machine
//
//  Created by Kevin Lin on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIConstants : NSObject

//Parse API connection keys
extern NSString *const PARSE_APPLICATION_KEY;
extern NSString *const PARSE_CLIENT_KEY;

//Amazon S3 pool id
extern NSString *const POOL_ID;
extern NSString *const IMAGE_FILE_PATH;

//Twitter Oauth keys
extern NSString *const TWITTER_CONSUMER_KEY;
extern NSString *const TWITTER_CONSUMER_SECRET;

//Forecast.io API URL and Key
extern NSString *const FORECASTIO_API_URL;
extern NSString *const FORECASTIO_API_KEY;
@end
