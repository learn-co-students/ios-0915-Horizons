//
//  DataStore.m
//  Fax-Machine
//
//  Created by Claire Davis on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "DataStore.h"
#import "AWSDownloadManager.h"
#import "AWSUploadManager.h"
#import <AWSS3/AWSS3.h>

@implementation DataStore
+ (instancetype)sharedDataStore {
  static DataStore *_sharedDataStore = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedDataStore = [[DataStore alloc] init];
  });
  
  return _sharedDataStore;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    //initialize properties
  }
  return self;
}

+(void)downloadPicturesToDisplay:(NSArray*)imagesToDownloadFromParseQuery WithCompletion:(void(^)(BOOL complete))completionBlock
{
//  for (photoObject *photo in imagesToDownloadFromParseQuery) {
//    [AWSDownloadManager downloadSinglePicture:photo.imageID];
//  }

  //^this will pull down images with parse query from AWS.
}

+(void)uploadPictureToAWS:(AWSS3TransferManagerUploadRequest*)uploadRequest WithCompletion:(void(^)(BOOL complete))completionBlock
{
  [AWSUploadManager upload:uploadRequest withCompletion:^(BOOL complete) {
    completionBlock(YES);
  }];
}



@end
