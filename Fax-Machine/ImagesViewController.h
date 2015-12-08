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
@property (strong, readonly, nonatomic) RESideMenu *sideMenuViewController;
@property (nonatomic, strong) NSMutableDictionary *filterParameters;
@property(nonatomic)BOOL isFiltered;
@property (nonatomic)BOOL isUserImageVC;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic) BOOL isFollowing;

-(void)filteringImagesCountryLevel:(NSDictionary *)filterParameters;


@end
