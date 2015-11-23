//
//  AWSUploadManager.h
//  Fax-Machine
//
//  Created by Claire Davis on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSS3/AWSS3.h>

@interface AWSUploadManager : NSObject
+(void)upload:(AWSS3TransferManagerUploadRequest*)uploadRequest withCompletion:(void(^)(BOOL complete))completionBlock;
@end
