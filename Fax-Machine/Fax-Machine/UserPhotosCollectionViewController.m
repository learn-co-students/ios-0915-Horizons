//
//  UserPhotosCollectionViewController.m
//  
//
//  Created by Claire Davis on 11/30/15.
//
//

#import "UserPhotosCollectionViewController.h"
#import <Parse/Parse.h>


@interface UserPhotosCollectionViewController ()

@end

@implementation UserPhotosCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
  [self getUserPhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getUserPhotos
{
  PFUser *currentUser = [PFUser currentUser];
  NSMutableArray *images = [[NSMutableArray alloc]init];
  PFQuery *photoQuery = [PFQuery queryWithClassName:@"Image"];
  [photoQuery whereKey:@"owner" equalTo:currentUser];
  [photoQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
    if (!error) {
      NSLog(@"object count: %lu",objects.count);
      for (PFObject *object in objects) {
        NSLog(@"%@", object.objectId);
        NSString *imageID = [object valueForKey:@"imageID"];
        [images addObject:imageID];
      }
      NSLog(@"images: %@",images);

    } else {
      NSLog(@"error: %@", error);
    }
  }];
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


@end
