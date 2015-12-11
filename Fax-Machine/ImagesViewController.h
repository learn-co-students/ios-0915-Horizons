//
//  ImagesViewController.h
//  Fax-Machine
//
//  Created by Selma NB on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu/RESideMenu.h>
#import "HelperMethods.h"

@class Location;

@interface ImagesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionViewController;
@property (weak, nonatomic) IBOutlet UILabel *viewTitle;
@property (strong, readonly, nonatomic) RESideMenu *sideMenuViewController;
@property (nonatomic, strong) NSMutableDictionary *filterParameters;
@property(nonatomic)BOOL isFiltered;
@property (nonatomic)BOOL isUserImageVC;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic) BOOL isFollowing;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)NSUInteger imagesCount;
@property (nonatomic, readonly) NSInteger isConnected;


-(void)filteringImagesCountryLevel:(NSDictionary *)filterParameters;


@end
