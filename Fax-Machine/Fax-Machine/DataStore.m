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
      _downloadedPictures = [NSMutableArray new];
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
    NSLog(@"\n\ndownloadPicturesToDisplay called\n\n");
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"likes >= %@", @(0)];
    [ParseAPIClient fetchImagesWithPredicate:predicate numberOfImages:imagesToDownloadFromParseQuery completion:^(NSArray *data) {
        
        NSLog(@"\n\fetchImagesWithPredciate  called\n\n");

        
        for (PFObject *parseImageObject in data) {
            NSString *imageID = parseImageObject[@"imageID"];
            [AWSDownloadManager downloadSinglePicture:imageID completion:^(NSString *filePath) {
                
                NSLog(@"\n\ndownloadSinglePicture called\n\n");

                
                [self.downloadedPictures addObject:filePath];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];

                }];
                
                
                NSLog(@"Downloaded picture count: %lu", self.downloadedPictures.count);
                if (10 == self.downloadedPictures.count) {
                    
                    NSLog(@"\n\n completionBlock is about to be passed YES\n\n");
                    
                    completionBlock(YES);
                }
            }];
        }
        
        //self.downloadedPictures = [data mutableCopy];
        
    } failure:^(NSError *error) {
        NSLog(@"Download images error: %@", error.localizedDescription);
    }];
}

-(void)uploadImageWithImageObject:(ImageObject*)imageObject
                   WithCompletion:(void(^)(BOOL complete))completionBlock{
    
    PFObject *parseLocation = [PFObject objectWithClassName:@"Location"];
    parseLocation[@"city"] = imageObject.location.city;
    parseLocation[@"country"] = imageObject.location.country;
    parseLocation[@"geoPoint"] = imageObject.location.geoPoint;
    parseLocation[@"dateTaken"] = imageObject.location.dateTaken;
    parseLocation[@"weather"] = imageObject.location.weather;
    
    [ParseAPIClient saveLocationWithLocation:parseLocation success:^(BOOL success) {
        if (success) {
            PFObject *image = [PFObject objectWithClassName:@"Image"];
            NSLog(@"Current User: %@", [PFUser currentUser]);
            image[@"owner"] = [PFUser currentUser];
            image[@"title"] = imageObject.title;
            image[@"imageID"] = imageObject.imageID;
            image[@"likes"] = imageObject.likes;
            image[@"mood"] = imageObject.mood;
            image[@"location"] = parseLocation;
            
            [ParseAPIClient saveImageWithImageObject:image success:^(BOOL success) {
                completionBlock(success);
            } failure:^(NSError *error) {
                NSLog(@"Save image error with location: %@", error.localizedDescription);
            }];
        }else{
            NSLog(@"Failed saving location!!");
        }
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

-(void)logoutWithSuccess:(void (^)(BOOL))success{
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    [currentUser saveInBackground];
    success(YES);
}

@end
