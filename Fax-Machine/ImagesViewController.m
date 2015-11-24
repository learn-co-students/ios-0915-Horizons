////
//  ImagesViewController.m
//  Fax-Machine
//
//  Created by Selma NB on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "ImagesViewController.h"
#import "imagesCustomCell.h"
#import "ImagesDetailsViewController.h"
#import "DataStore.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import "APIConstants.h"

@interface ImagesViewController ()

@property (strong, nonatomic) NSArray *arrayWithImages;
@property (strong, nonatomic) NSArray *arrayWithDescriptions;
@property (nonatomic, strong) RESideMenu *sideMenuViewController;
@property (nonatomic, strong) NSMutableArray *downloadedImages;

@property (nonatomic, strong) DataStore *dataStore;

@end

@implementation ImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self imagesCollectionViewController]setDataSource:self];
    [[self imagesCollectionViewController]setDelegate:self];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.66
                                                  green:0.66
                                                   blue:0.66
                                                  alpha:0.75]];
    
    self.arrayWithImages =[[NSArray alloc]initWithObjects:@"img5.jpg",@"img2.jpg",@"img3.jpg",@"img4.jpg",@"img5.jpg",@"img6.jpg",@"img6.jpg",@"img7.jpg",@"img8.jpg",@"img9.jpg",@"img10.jpg",@"img1.JPG",@"img5.jpg",@"img2.jpg",@"img3.jpg",@"img4.jpg",@"img5.jpg",@"img6.jpg",@"img6.jpg",@"img7.jpg",@"img8.jpg",@"img9.jpg",@"img10.jpg",@"img1.JPG",nil];
    self.arrayWithDescriptions =[[NSArray alloc]initWithObjects:@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",@"♡",nil];
    self.dataStore = [DataStore sharedDataStore];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"Belore API call!");
    
//    [self.dataStore downloadPicturesToDisplay:20 WithCompletion:^(BOOL complete) {
//        if (complete) {
//            
//            
//            
//            [self.imagesCollectionViewController reloadData];
//        }
//    }];
//    
//    NSLog(@"\n\nTHIS SHOULD GET CALLED FAST... this is after self.datastore downloadpicturesToDisplay\n\n");
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadViewWithImage) name:@"reload" object:nil];
}

-(void)reloadViewWithImage{
    [self.imagesCollectionViewController reloadData];
}

- (RESideMenu *)sideMenuViewController
{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[RESideMenu class]]) {
            return (RESideMenu *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}


- (IBAction)presentLeftMenu:(id)sender {
    
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma Collection view protocal methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return self.arrayWithImages.count;
    NSLog(@"View Count number!!!! : %lu", self.dataStore.downloadedPictures.count);
    return self.dataStore.downloadedPictures.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Before creating a cell!!!!!\n\n");
   imagesCustomCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    NSLog(@"\n\n cellForItemAtIndexPath: is GETTING CALLED!!!");
    
    //cell.myImage.image = [UIImage imageNamed:self.arrayWithImages[indexPath.item]];
    
//    [[NSBundle mainBundle] bundlewith]
    NSString *imageFilePath = self.dataStore.downloadedPictures[indexPath.row];
    
//    NSString *urlString = [NSString stringWithFormat:@"%@%@", IMAGE_FILE_PATH,imageObject[@"imageID"]];
    NSURL *url = [NSURL URLWithString:imageFilePath];
    
    //[cell.myImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cloud"]];
    cell.myImage.image = [UIImage imageWithContentsOfFile:imageFilePath];
    cell.mydiscriptionLabel.textColor= [UIColor whiteColor];
    cell.mydiscriptionLabel.font=[UIFont boldSystemFontOfSize:16.0];

    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.view.frame.size.width/2;
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"photoDetails"])
    {
    
        ImagesViewController *cell = (ImagesViewController*)sender;
        NSIndexPath *indexPath = [self.imagesCollectionViewController indexPathForCell:cell];
        ImagesDetailsViewController *imageVC = (ImagesDetailsViewController *)[segue destinationViewController];
        imageVC.img = [UIImage imageNamed:self.arrayWithImages[indexPath.item]];
        
    }
    
}

@end
