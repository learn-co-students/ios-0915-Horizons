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

+(void)downloadSinglePicture:(NSString*)imageID
                  completion:(void(^)(NSString *filePath))completionBlock;
{
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    NSString *imageName = [NSString stringWithFormat:@"downloaded-%@",imageID];
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:imageName];
    
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    downloadRequest.bucket = @"fissamplebucket";
    downloadRequest.key = [NSString stringWithFormat:@"%@",imageID];
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

            completionBlock(downloadingFilePath);
            
        }
        return nil;
    }];
}



@end
