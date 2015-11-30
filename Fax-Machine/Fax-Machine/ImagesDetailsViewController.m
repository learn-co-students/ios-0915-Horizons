//
//  ImagesDetailsViewController.m
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "ImagesDetailsViewController.h"
#import "UsersCommentsViewController.h"
#import "DataStore.h"
#import <YYWebImage/YYWebImage.h>
#import "APIConstants.h"

@interface ImagesDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *likeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imageDetails;
//@property (nonatomic, strong) UIImage *img;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *likesCounter;
@property (weak, nonatomic) IBOutlet UITableView *belowPictureTableView;

@property (nonatomic) NSUInteger photoLikesCounter;
@property (nonatomic) UsersCommentsViewController *userCommentsVCObject;
@property (nonatomic, strong)DataStore *dataStore;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic) BOOL liked;

@end

@implementation ImagesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataStore = [DataStore sharedDataStore];
    //NSLog(@"Commets: %@", self.dataStore.comments[0]);
    self.belowPictureTableView.delegate = self;
    self.belowPictureTableView.dataSource = self;
    //self.imageDetails.image = self.img;
    self.likesCounter.tintColor= [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.66
                                                  green:0.66
                                                   blue:0.66
                                                  alpha:0.75]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", IMAGE_FILE_PATH, self.image.imageID];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.imageDetails yy_setImageWithURL:url options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur ];

    PFUser *user = [PFUser currentUser];
    NSArray *savedImages = user[@"savedImages"];
    
    if (savedImages.count) {
        for (PFObject *parImage in savedImages) {
            if ([parImage.objectId isEqualToString:self.image.objectID]) {
                self.liked = YES;
                NSLog(@"Liked!!!!!!!!!!");
            }
        }
    }else{
        NSLog(@"No saved images!!!");
        self.liked = NO;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.belowPictureTableView reloadData];
    NSLog(@"Commets: %lu", self.image.comments.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.image.comments.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 45.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:17.0];
        
    }
    PFUser *user = self.image.owner;
    cell.detailTextLabel.text = user[@"username"];
    PFObject *comment = self.image.comments[indexPath.row];
    cell.textLabel.text = comment[@"userComment"];
    
    return cell;
}

//- (IBAction)commentIcon:(UIBarButtonItem *)sender {
//    
//}
//

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[UsersCommentsViewController class]]) {
        UsersCommentsViewController *destinationVC = segue.destinationViewController;
        destinationVC.selectedImage = self.image;
    }
}

- (IBAction)likeButton:(UIBarButtonItem *)sender {
    if (!self.liked) {
        self.liked = YES;
        self.photoLikesCounter += 1;
        self.likesCounter.tintColor= [UIColor whiteColor];
        self.likesCounter.title = [NSString stringWithFormat:@"❤️ %ld", self.photoLikesCounter];
    }
}
@end
