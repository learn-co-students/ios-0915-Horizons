//
//  DataStore.h
//  Fax-Machine
//
//  Created by Claire Davis on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSS3/AWSS3.h>

@interface DataStore : NSObject

@property (nonatomic, strong)NSArray *downloadedPictures;

+ (instancetype)sharedDataStore;
+(void)uploadPictureToAWS:(AWSS3TransferManagerUploadRequest*)uploadRequest WithCompletion:(void(^)(BOOL complete))completionBlock;


@end
