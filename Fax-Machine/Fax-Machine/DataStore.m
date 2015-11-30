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
    _userPictures = [[NSMutableArray alloc]init];
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
                   WithCompletion:(void(^)(BOOL complete))completionBlock{
    
    PFObject *parseLocation = [PFObject objectWithClassName:@"Location"];
    parseLocation[@"city"] = imageObject.location.city;
    parseLocation[@"country"] = imageObject.location.country;
    parseLocation[@"geoPoint"] = imageObject.location.geoPoint;
    parseLocation[@"dateTaken"] = imageObject.location.dateTaken;
    parseLocation[@"weather"] = imageObject.location.weather;
    
    [ParseAPIClient saveLocationWithLocation:parseLocation success:^(BOOL success) {
        PFObject *image = [PFObject objectWithClassName:@"Image"];
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

-(void)fetchUserImagesWithCompletion:(void(^)(BOOL complete))completionBlock
{
  //[self.downloadedPictures removeAllObjects];
  
  PFUser *currentUser = [PFUser currentUser];
  PFQuery *photoQuery = [PFQuery queryWithClassName:@"Image"];
  [photoQuery whereKey:@"owner" equalTo:currentUser];
  [photoQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
    if (!error) {
      NSLog(@"object count: %lu",objects.count);
      for (PFObject *object in objects) {
        ImageObject *userImage = [[ImageObject alloc]initWithOwner:object[@"owner"] title:object[@"title"] imageID:object[@"imageID"] likes:object[@"likes"] mood:object[@"likes"] location:object[@"location"] comments:object[@"comments"]];
        [self.userPictures addObject:userImage];
      }
        completionBlock(YES);
      
    } else {
      NSLog(@"error: %@", error);
    }
  
  }];
}

@end
