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
        _comments = [NSMutableArray new];
        _userPictures = [[NSMutableArray alloc]init];
        _downloadedPictures = [NSMutableArray new];
        _controllers = [NSMutableArray new];
        _favoriteImages = [NSMutableArray new];
        _followingOwnerImageList = [NSMutableArray new];
        _filteredImageList = [NSMutableArray new];
        _isUserVC = NO;
        _followerCount = 0;
        _followerList = [NSMutableArray new];
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
    NSUInteger page =ceil(self.downloadedPictures.count / (imagesToDownloadFromParseQuery * 1.00f));
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"likes >= %@ AND report < %@ OR report = %@", @(0), @5, nil];
    [ParseAPIClient fetchImagesWithPredicate:predicate numberOfImages:imagesToDownloadFromParseQuery page:page completion:^(NSArray *data) {
      for (PFObject *parseImageObject in data) {
            PFObject *parseLocation = parseImageObject[@"location"];
            Location *locationObject = [[Location alloc] initWithCity:parseLocation[@"city"] country:parseLocation[@"country"] geoPoint:parseLocation[@"geoPoint"] dateTaken:parseLocation[@"dateTaken"]];
            if (parseImageObject[@"comments"]) {
                [ParseAPIClient fetchAllCommentsWithRelatedImage:parseImageObject[@"imageID"] completion:^(NSArray *data) {
                    ImageObject *parseImage = [[ImageObject alloc] initWithOwner:parseImageObject[@"owner"] title:parseImageObject[@"title"] imageID:parseImageObject[@"imageID"] likes:parseImageObject[@"likes"] mood:parseImageObject[@"mood"] location:locationObject comments:[data mutableCopy]
                                                                        objectID:parseImageObject.objectId];
                    
                    [self.downloadedPictures addObject:parseImage];
                    completionBlock(YES);
                    
                } failure:^(NSError *error) {
                    NSLog(@"Fetch Comments error: %@", error.localizedDescription);
                }];
            }else{
                NSMutableArray *commentsForItem = [NSMutableArray new];
                ImageObject *parseImage = [[ImageObject alloc] initWithOwner:parseImageObject[@"owner"] title:parseImageObject[@"title"] imageID:parseImageObject[@"imageID"] likes:parseImageObject[@"likes"] mood:parseImageObject[@"mood"] location:locationObject comments:commentsForItem
                                                                    objectID:parseImageObject.objectId];
                
                [self.downloadedPictures addObject:parseImage];
                completionBlock(YES);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"Download images error: %@ code: %ld", error.localizedDescription, (long)error.code);
    }];
}


-(void)downloadPicturesToDisplayWithMood:(NSString *)mood
                                  andLocation:(Location *)location
                               numberOfImages:(NSUInteger)number
                               WithCompletion:(void(^)(BOOL complete))completionBlock
{

    NSUInteger page =ceil(self.filteredImageList.count / ( number * 1.00f));

    //NSLog(@"Page number: %lu", page);
    
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [query whereKey:@"city" equalTo:location.city];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location IN %@", objects];
        if (mood.length) {
            predicate = [NSPredicate predicateWithFormat:@"location IN %@ AND mood = %@", objects, mood];
        }
        
        [ParseAPIClient fetchImagesWithPredicate:predicate numberOfImages:number page:page completion:^(NSArray *data) {
            for (PFObject *parseImageObject in data)
            {
                PFObject *parseLocation = parseImageObject[@"location"];
                Location *locationObject = [[Location alloc] initWithCity:parseLocation[@"city"] country:parseLocation[@"country"] geoPoint:parseLocation[@"geoPoint"] dateTaken:parseLocation[@"dateTaken"]];

                if (parseImageObject[@"comments"])
                {
                    [ParseAPIClient fetchAllCommentsWithRelatedImage:parseImageObject[@"imageID"] completion:^(NSArray *data)
                     {
                         ImageObject *parseImage = [[ImageObject alloc] initWithOwner:parseImageObject[@"owner"] title:parseImageObject[@"title"] imageID:parseImageObject[@"imageID"] likes:parseImageObject[@"likes"] mood:parseImageObject[@"mood"] location:locationObject comments:[data mutableCopy] objectID:parseImageObject.objectId];
                         [self.filteredImageList addObject:parseImage];
                         completionBlock(YES);
                     } failure:^(NSError *error) {
                         NSLog(@"Fetch Comments error: %@", error.localizedDescription);
                         completionBlock(NO);
                     }];

                }else{
                    NSMutableArray *commentsForItem = [NSMutableArray new];
                    ImageObject *parseImage = [[ImageObject alloc] initWithOwner:parseImageObject[@"owner"]
                                                                           title:parseImageObject[@"title"]
                                                                         imageID:parseImageObject[@"imageID"]
                                                                           likes:parseImageObject[@"likes"]
                                                                            mood:parseImageObject[@"mood"]
                                                                        location:locationObject
                                                                        comments:commentsForItem
                                                                        objectID:parseImageObject.objectId];
                    [self.filteredImageList addObject:parseImage];
                }
                completionBlock(YES);
            }
        } failure:^(NSError *error) {
            NSLog(@"Download images error: %@", error.localizedDescription);
        }];
        
    }];
}

-(void)downloadPicturesToDisplay:(NSUInteger)numberOfImages
                       predicate:(NSPredicate *)predicate
                  WithCompletion:(void(^)(BOOL complete))completionBlock
{
    NSUInteger page =ceil(self.followingOwnerImageList.count / (numberOfImages * 1.00f));
    [ParseAPIClient fetchImagesWithPredicate:predicate numberOfImages:numberOfImages page:page completion:^(NSArray *data) {
        if (data.count) {
            for (PFObject *parseImageObject in data) {
                PFObject *parseLocation = parseImageObject[@"location"];
                Location *locationObject = [[Location alloc] initWithCity:parseLocation[@"city"] country:parseLocation[@"country"] geoPoint:parseLocation[@"geoPoint"] dateTaken:parseLocation[@"dateTaken"]];
                if (parseImageObject[@"comments"]) {
                    [ParseAPIClient fetchAllCommentsWithRelatedImage:parseImageObject[@"imageID"] completion:^(NSArray *data) {
                        ImageObject *parseImage = [[ImageObject alloc] initWithOwner:parseImageObject[@"owner"] title:parseImageObject[@"title"] imageID:parseImageObject[@"imageID"] likes:parseImageObject[@"likes"] mood:parseImageObject[@"mood"] location:locationObject comments:[data mutableCopy]
                                                                            objectID:parseImageObject.objectId];
                        
                        [self.followingOwnerImageList addObject:parseImage];
                        completionBlock(YES);
                        
                    } failure:^(NSError *error) {
                        NSLog(@"Fetch Comments error: %@", error.localizedDescription);
                    }];
                }else{
                    NSMutableArray *commentsForItem = [NSMutableArray new];
                    ImageObject *parseImage = [[ImageObject alloc] initWithOwner:parseImageObject[@"owner"] title:parseImageObject[@"title"] imageID:parseImageObject[@"imageID"] likes:parseImageObject[@"likes"] mood:parseImageObject[@"mood"] location:locationObject comments:commentsForItem
                                                                        objectID:parseImageObject.objectId];
                    
                    [self.followingOwnerImageList addObject:parseImage];
                    completionBlock(YES);
                }
            }
        }else{
            completionBlock(YES);
        }
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
    parseLocation[@"weather"] = @{};
    if (imageObject.location.weather) {
        parseLocation[@"weather"] = imageObject.location.weather;
    }
    [ParseAPIClient saveLocationWithLocation:parseLocation success:^(BOOL success) {
        if (success) {
            PFObject *image = [PFObject objectWithClassName:@"Image"];
//            NSLog(@"Current User: %@", [PFUser currentUser]);
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
                withCompletion:(void(^)(PFObject *comment))completionBlock{
    [ParseAPIClient fetchImageWithImageID:imageID completion:^(PFObject *data) {
        PFObject *parseComment = [PFObject objectWithClassName:@"Comment"];
        parseComment[@"userComment"] = comment;
        parseComment[@"owner"] = [PFUser currentUser];
        parseComment[@"relatedImage"] = data;
        [ParseAPIClient saveCommentWithWithComment:parseComment imageObject:data success:^(BOOL success) {
            completionBlock(parseComment);
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
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *photoQuery = [PFQuery queryWithClassName:@"Image"];
    [photoQuery whereKey:@"owner" equalTo:currentUser];
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (PFObject *parseImageObject in objects) {

                [parseImageObject[@"owner"] fetchInBackgroundWithBlock:nil];
                [parseImageObject[@"location"] fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    PFObject *parseLocation = parseImageObject[@"location"];
                    Location *locationObject = [[Location alloc] initWithCity:parseLocation[@"city"] country:parseLocation[@"country"] geoPoint:parseLocation[@"geoPoint"] dateTaken:parseLocation[@"dateTaken"]];
                    if (parseImageObject[@"comments"]) {
                        [ParseAPIClient fetchAllCommentsWithRelatedImage:parseImageObject[@"imageID"] completion:^(NSArray *data) {
                            ImageObject *parseImage = [[ImageObject alloc] initWithOwner:parseImageObject[@"owner"] title:parseImageObject[@"title"] imageID:parseImageObject[@"imageID"] likes:parseImageObject[@"likes"] mood:parseImageObject[@"mood"] location:locationObject comments:[data mutableCopy]
                                                                                objectID:parseImageObject.objectId];
                            
                            [self.userPictures addObject:parseImage];;
                            completionBlock(YES);
                            
                        } failure:^(NSError *error) {
                            NSLog(@"Fetch Comments error: %@", error.localizedDescription);
                        }];
                    }else{
                        NSMutableArray *commentsForItem = [NSMutableArray new];
                        ImageObject *parseImage = [[ImageObject alloc] initWithOwner:parseImageObject[@"owner"] title:parseImageObject[@"title"] imageID:parseImageObject[@"imageID"] likes:parseImageObject[@"likes"] mood:parseImageObject[@"mood"] location:locationObject comments:commentsForItem
                                                                            objectID:parseImageObject.objectId];
                        
                        [self.userPictures addObject:parseImage];;
                        completionBlock(YES);

                    }
                }];
            }
            completionBlock(YES);
            
        } else {
            NSLog(@"error: %@", error);
        }
  }];
}

-(void)getAllCommentsWithImageID:(NSString *)imageID withCompletion:(void (^)(BOOL))completionBlock{
    [ParseAPIClient fetchAllCommentsWithRelatedImage:imageID completion:^(NSArray *data) {
        for (PFObject *parseComment in data) {
            Comment *comment = [[Comment alloc]initWithComment:parseComment[@"userComment"] user:parseComment[@"owner"] image:parseComment[@"relatedImage"]];
            [self.comments addObject:comment];
        }
        completionBlock(YES);
    } failure:^(NSError *error) {
        NSLog(@"Fetch Comments error: %@", error.localizedDescription);
    }];
}

-(void)getFavoriteImagesWithSuccess:(void (^)(BOOL))success{
    [ParseAPIClient getFavoriteImagesWithCompletion:^(NSArray *images) {
        for (PFObject *parseImageObject in images) {

            [parseImageObject[@"owner"] fetchInBackgroundWithBlock:nil];
            [parseImageObject[@"location"] fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                Location *locationObject = [[Location alloc] initWithCity:object[@"city"] country:object[@"country"] geoPoint:object[@"geoPoint"] dateTaken:object[@"dateTaken"]];
                if (parseImageObject[@"comments"]) {
                    [ParseAPIClient fetchAllCommentsWithRelatedImage:parseImageObject[@"imageID"] completion:^(NSArray *data) {
                        ImageObject *parseImage = [[ImageObject alloc] initWithOwner:parseImageObject[@"owner"] title:parseImageObject[@"title"] imageID:parseImageObject[@"imageID"] likes:parseImageObject[@"likes"] mood:parseImageObject[@"mood"] location:locationObject comments:[data mutableCopy]
                                                                            objectID:parseImageObject.objectId];
                        
                        [self.favoriteImages addObject:parseImage];
                        success(YES);
                        
                    } failure:^(NSError *error) {
                        NSLog(@"Fetch Comments error: %@", error.localizedDescription);
                    }];
                }else{
                    NSMutableArray *commentsForItem = [NSMutableArray new];
                    ImageObject *parseImage = [[ImageObject alloc] initWithOwner:parseImageObject[@"owner"] title:parseImageObject[@"title"] imageID:parseImageObject[@"imageID"] likes:parseImageObject[@"likes"] mood:parseImageObject[@"mood"] location:locationObject comments:commentsForItem
                                                                        objectID:parseImageObject.objectId];
                    
                    [self.favoriteImages addObject:parseImage];
                    success(YES);

                }
            }];
        }
    }];
}

-(void)getOwnerWithObjectID:(NSString *)objectId success:(void (^)(PFUser *))success{
    
    PFQuery *ownerQuery = [PFUser query];
    [ownerQuery getObjectInBackgroundWithId:objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            success((PFUser *)object);
        }
    }];
}

-(void)followImageOwner:(PFUser *)owner completion:(void (^)(BOOL))completion{
    [ParseAPIClient followUserWithUser:owner success:^(BOOL success) {
        completion(success);
    } failure:^(NSError *error) {
        NSLog(@"Following user with error: %@", error.localizedDescription);
    }];
}

-(void)getFollowingUsersWithSuccess:(void (^)(BOOL success))success{
    [ParseAPIClient getFollowingUsersWithCompletion:^(NSArray *owners) {
        self.followingList = [owners mutableCopy];
        success(YES);
    }];
}

-(void)getFollowersWithUserId:(NSString *)userId success:(void (^)(BOOL))success{
    [ParseAPIClient getFollowersWithUserId:userId withCompletion:^(NSArray *owners) {
        if (userId != [PFUser currentUser].objectId) {
            self.followerCount = owners.count;
        }else{
            self.followerList = [owners mutableCopy];
        }
        success(YES);
    }];
}

+(void)checkUserFollow{
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error.code == 101) {
            PFObject *follow = [PFObject objectWithClassName:@"Follow"];
            follow[@"userId"] = [PFUser currentUser].objectId;
            [follow saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Initiating follow error: %@", error.localizedDescription);
                }
            }];
        }else if (!error){
            return;
        }else{
            NSLog(@"Get follow error: %@", error.localizedDescription);
        }
    }];
}

-(void)reportImage:(ImageObject *)reportedImage success:(void (^)(BOOL))success{
    [ParseAPIClient fetchImageWithImageID:reportedImage.imageID completion:^(PFObject *data) {
        [data incrementKey:@"report" byAmount:@1];
        [data saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                PFUser *user = [PFUser currentUser];
                [user addObject:data forKey:@"reportedImages"];
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        success(succeeded);
                    }
                }];
            }else{
                NSLog(@"Report image error: %@", error.localizedDescription);
            }
        }];
    } failure:^(NSError *error) {
        NSLog(@"Report image fetch error: %@", error.localizedDescription);
    }];
    
    
}

@end
