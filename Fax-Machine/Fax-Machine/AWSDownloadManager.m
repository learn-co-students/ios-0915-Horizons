//
//  AWSDownloadManager.m
//  Fax-Machine
//
//  Created by Claire Davis on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "AWSDownloadManager.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>


@implementation AWSDownloadManager

+(void)downloadSinglePicture:(NSUInteger)imageID
{
  AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
  
//  NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"downloaded-puppyfloor.jpeg"];
  NSString *imageName = [NSString stringWithFormat:@"downloaded-%lu.png",imageID];
  NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:imageName];

  NSLog(@"downloading file pat: %@",downloadingFilePath);
  NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
  NSLog(@"downloading file URL: %@",downloadingFileURL);
  
  AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
  downloadRequest.bucket = @"fissamplebucket";
//  downloadRequest.key = @"puppyfloor.jpeg";
  downloadRequest.key = [NSString stringWithFormat:@"%lu.png",imageID];
  downloadRequest.downloadingFileURL = downloadingFileURL;
  
  
  [[transferManager download:downloadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
    if (task.error) {
      NSLog(@"taskerror: %@",task.error);
      if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
        switch (task.error.code) {
          case AWSS3TransferManagerErrorCancelled:
          case AWSS3TransferManagerErrorPaused:
            break;
          default:
            NSLog(@"Error: %@", task.error);
            break;
        }
      } else {
        NSLog(@"error: %@", task.error);
      }
    }
    if (task.result) {
      AWSS3TransferManagerDownloadOutput *downloadOutput = task.result;
      NSLog(@"download output: %@",downloadOutput);
//PLACE IMAGE IN VIEW HERE
      
    }
    return nil;
  }];
}



@end
