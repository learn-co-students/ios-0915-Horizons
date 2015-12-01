//
//  ImagesViewController.h
//  Fax-Machine
//
//  Created by Selma NB on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu/RESideMenu.h>

@interface ImagesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionViewController;
@property (strong, readonly, nonatomic) RESideMenu *sideMenuViewController;
@property (nonatomic)BOOL isUserImageVC;

@property (nonatomic) BOOL isFavorite;

@end
