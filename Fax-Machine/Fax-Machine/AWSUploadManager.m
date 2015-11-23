//
//  AWSUploadManager.m
//  Fax-Machine
//
//  Created by Claire Davis on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "AWSUploadManager.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>

@implementation AWSUploadManager

+(void)upload:(AWSS3TransferManagerUploadRequest*)uploadRequest withCompletion:(void(^)(BOOL complete))completionBlock
{
  AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
  
  
  
  [[transferManager upload:uploadRequest]continueWithBlock:^id(AWSTask *task) {
    if (task.error) {
      if (([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain])) {
        switch (task.error.code) {
          case AWSS3TransferManagerErrorCancelled:
          case AWSS3TransferManagerErrorPaused:
            break;
            
          default:
            NSLog(@"upload failed: %@", task.error);
            break;
        }
      } else {
        NSLog(@"upload failed else: %@", task.error);
      }
    }
    if (task.result) {
      AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
      NSLog(@"UPLOAD OUTPUT: %@",uploadOutput);
      completionBlock(YES);
    }
    return nil;
  }];
}



@end
