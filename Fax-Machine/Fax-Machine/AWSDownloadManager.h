//
//  AWSDownloadManager.h
//  Fax-Machine
//
//  Created by Claire Davis on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWSDownloadManager : NSObject
+(void)downloadSinglePicture:(NSUInteger)imageID;

@end
