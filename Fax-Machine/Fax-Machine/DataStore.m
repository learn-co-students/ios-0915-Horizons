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
#import "ParseAPIClient.h"


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
      _comments = [NSMutableArray new];
  }
  return self;
}

+(void)uploadPictureToAWS:(AWSS3TransferManagerUploadRequest*)uploadRequest WithCompletion:(void(^)(BOOL complete))completionBlock
{
  [AWSUploadManager upload:uploadRequest withCompletion:^(BOOL complete) {
    completionBlock(YES);
  }];
}

-(void)downloadPicturesToDisplay:(NSUInteger)imagesToDownloadFromParseQuery WithCompletion:(void(^)(BOOL complete))completionBlock
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"likes >= %@", @(10)];
    [ParseAPIClient fetchImagesWithPredicate:predicate numberOfImages:imagesToDownloadFromParseQuery completion:^(NSArray *data) {
        //  for (photoObject *photo in imagesToDownloadFromParseQuery) {
        //    [AWSDownloadManager downloadSinglePicture:photo.imageID];
        //  }
        
        //^this will pull down images with parse query from AWS.
    } failure:^(NSError *error) {
        NSLog(@"Download images error: %@", error.localizedDescription);
    }];
}

-(void)uploadImageWithImageObject:(ImageObject*)imageObject
                         location:(Location *)location
                   WithCompletion:(void(^)(BOOL complete))completionBlock{
    
    PFObject *parseLocation = [PFObject objectWithClassName:@"Location"];
    parseLocation[@"city"] = location.city;
    parseLocation[@"country"] = location.country;
    parseLocation[@"geoPoint"] = location.geoPoint;
    parseLocation[@"dateTaken"] = location.dateTaken;
    
    [ParseAPIClient saveLocationWithLocation:parseLocation success:^(BOOL success) {
        PFObject *image = [PFObject objectWithClassName:@"Image"];
        image[@"owner"] = [PFUser currentUser];
        image[@"title"] = imageObject.title;
        image[@"imageID"] = imageObject.imageID;
        image[@"likes"] = imageObject.likes;
        image[@"mood"] = imageObject.mood;
        image[@"location"] = parseLocation;
        
        [ParseAPIClient saveImageWithImageObject:image  success:^(BOOL success) {
            completionBlock(success);
        } failure:^(NSError *error) {
            NSLog(@"Save image error with location: %@", error.localizedDescription);
        }];
    } failure:^(NSError *error) {
        NSLog(@"Upload image error: %@", error.localizedDescription);
    }];
}

-(void)inputCommentWithComment:(NSString *)comment
                       imageID:(NSString *)imageID
                withCompletion:(void(^)(BOOL complete))completionBlock{
    [ParseAPIClient fetchImageWithImageID:imageID completion:^(PFObject *data) {
        PFObject *parseComment = [PFObject objectWithClassName:@"Comment"];
        parseComment[@"userComment"] = comment;
        parseComment[@"owner"] = [PFUser currentUser];
        parseComment[@"relatedImage"] = data;
        [ParseAPIClient saveCommentWithWithComment:parseComment imageObject:data success:^(BOOL success) {
            completionBlock(success);
        } failure:^(NSError *error) {
            NSLog(@"Save comment error: %@", error.localizedDescription);
        }];
    } failure:^(NSError *error) {
        NSLog(@"Fetch image error when entering comment: %@", error.localizedDescription);
    }];
}

-(void)likeImageWithImageID:(NSString *)imageID
             withCompletion:(void(^)(BOOL complete))completionBlock{
    
    [ParseAPIClient fetchImageWithImageID:imageID completion:^(PFObject *data) {
        [data incrementKey:@"likes"];
        [data saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [ParseAPIClient likeImageWithImageObject:data success:^(BOOL success) {
                    completionBlock(success);
                } failure:^(NSError *error) {
                    NSLog(@"User save like image with error: %@", error.localizedDescription);
                }];
            } else {
                NSLog(@"Image save like error: %@", error.localizedDescription);
            }
        }];
    } failure:^(NSError *error) {
        NSLog(@"Fetch image error when like: %@", error.localizedDescription);
    }];
}
@end
