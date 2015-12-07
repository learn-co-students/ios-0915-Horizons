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
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "HelperMethods.h"

@interface ImagesDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIImageView *imageDetails;
@property (weak, nonatomic) IBOutlet UITableView *belowPictureTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *likeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *commentButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *commentCountLable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downloadButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ownerFollow;

@property (weak, nonatomic) IBOutlet UIView *commentSectionView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commenSectionBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;

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
    
    //self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mountains_hd"]];

    self.belowPictureTableView.backgroundColor = [UIColor colorWithWhite:0.15 alpha:.85];
    //self.belowPictureTableView.backgroundColor = [UIColor colorWithRed:0.627 green:0.627 blue:0.627 alpha:0.95];
    self.belowPictureTableView.opaque = NO;
    self.belowPictureTableView.separatorColor = [UIColor clearColor];
    self.belowPictureTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.belowPictureTableView.separatorInset = UIEdgeInsetsZero;
    self.belowPictureTableView.delegate = self;
    self.belowPictureTableView.dataSource = self;

    self.toolBar.barTintColor = [UIColor colorWithWhite:0 alpha:0.25];
    
    self.commentTextField.delegate = self;
    self.commentTextField.placeholder = @"Enter a comment to post";
    self.commentSectionView.backgroundColor = [UIColor blackColor];
    self.commentButton.enabled = NO;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", IMAGE_FILE_PATH, self.image.imageID];
    NSURL *url = [NSURL URLWithString:urlString];
    self.imageDetails.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageDetails yy_setImageWithURL:url options:YYWebImageOptionProgressive];

    PFUser *user = [PFUser currentUser];
    NSArray *savedImages = user[@"savedImages"];
    
    FAKFontAwesome *commentIcon = [FAKFontAwesome commentIconWithSize:20];
    self.commentButton.image = [commentIcon imageWithSize:CGSizeMake(20, 20)];
    FAKFontAwesome *download = [FAKFontAwesome downloadIconWithSize:20];
    self.downloadButton.image = [download imageWithSize:CGSizeMake(20, 20)];
    
    //Displaying the owner of the image.
    PFUser *imageOwner = self.image.owner;
    NSString *displayName = [[imageOwner.email componentsSeparatedByString:@"@"] firstObject];
    self.ownerFollow.title = [NSString stringWithFormat:@"follow %@", displayName];
    //NSLog(@"My objectNameAndId: %@ %@", user.email, user.objectId);
    //NSLog(@"My ownerNameAndId: %@ %@", imageOwner.email, imageOwner.objectId);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId MATCHES %@", self.image.objectID];
    NSArray *filteredResult = [savedImages filteredArrayUsingPredicate:predicate];
    
    if (filteredResult.count) {
        self.liked = YES;
        //NSLog(@"Liked!!!!!!!!!!: %@", self.image.likes);
        FAKFontAwesome *heart = [FAKFontAwesome heartIconWithSize:20];
        self.likeButton.image = [heart imageWithSize:CGSizeMake(20, 20)];
        self.likeCountLabel.title = [NSString stringWithFormat:@"%@", self.image.likes];
    }else{
        self.liked = NO;
        //NSLog(@"Not liked!!!!!!!!!!: %@", self.image.likes);
        FAKFontAwesome *heart = [FAKFontAwesome heartOIconWithSize:20];
        self.likeButton.image = [heart imageWithSize:CGSizeMake(20, 20)];
        self.likeCountLabel.title = [NSString stringWithFormat:@"%@", self.image.likes];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangePosition:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangePosition:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.belowPictureTableView reloadData];
    self.commentCountLable.title = [NSString stringWithFormat:@"%lu", self.image.comments.count];
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
        
        cell.opaque = NO;
        cell.backgroundColor = [UIColor colorWithWhite:0.55 alpha:0.85];
        if (indexPath.row % 2 == 1) {
            cell.backgroundColor = [UIColor colorWithWhite:0.45 alpha:0.85];
        }
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.15 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:17.0];
        
    }
    //cell.detailTextLabel.text = user[@"username"];
    PFObject *comment = self.image.comments[indexPath.row];
    PFUser *user = comment[@"owner"];
    NSString *username = [user.email componentsSeparatedByString:@"@"][0];
    cell.detailTextLabel.text = username;
    cell.textLabel.text = comment[@"userComment"];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[UsersCommentsViewController class]]) {
        UsersCommentsViewController *destinationVC = segue.destinationViewController;
        destinationVC.selectedImage = self.image;
    }
}

- (IBAction)likeButton:(UIBarButtonItem *)sender {
    if (!self.liked) {
        [self.dataStore likeImageWithImageID:self.image.imageID withCompletion:^(BOOL complete) {
            self.liked = YES;
            NSLog(@"Testing!!!");
            FAKFontAwesome *heart = [FAKFontAwesome heartIconWithSize:20];
            self.likeButton.image = [heart imageWithSize:CGSizeMake(20, 20)];
            
            self.image.likes = @([self.image.likes integerValue] + 1);
            self.likeCountLabel.title = [NSString stringWithFormat:@"%@", self.image.likes];
        }];
    }
}

- (IBAction)downloadImage:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.imageDetails.image yy_saveToAlbumWithCompletionBlock:^(NSURL *assetURL, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Saved image url: %@, error: %@", assetURL, error.localizedDescription);
    }];
}

- (IBAction)followUser:(id)sender {
    PFUser *user = self.image.owner;
    if (![[PFUser currentUser].objectId isEqualToString:user.objectId]) {
        [self.dataStore followImageOwner:user completion:^(BOOL success) {
            if (success) {
                NSString *message = [NSString stringWithFormat:@"You are now following %@", self.image.owner.email];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self followingAlertWithMessage:message];
                }];
            }
        }];
    }else{
        [self followingAlertWithMessage:@"Sorry, but you cannot follow yourself!"];
    }
}

-(void)followingAlertWithMessage:(NSString *)message
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Following" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defautAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //enter code here
    }];
    [alert addAction:defautAction];
    //Present action where needed
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma text field protocols

- (IBAction)postCommentButton:(UIButton *)sender {
    PFObject *user = PFUser.currentUser;
    
    if(![[user objectForKey:@"emailVerified"] boolValue])
    {
        [[HelperMethods new] parseVerifyEmailWithMessage:@"You must Verify your email before you can post!" viewController:self];
        //[imageViewVC parseVerifyEmailWithMessage:@"You must Verify your email before you can upload!"];
        //NSLog(@"It is not verified!");
    }else{
        if (self.commentTextField.text.length && ![self.commentTextField.text isEqualToString:@" "]) {
            
            //NSLog(@"It's an OK message.");
            
            NSString *enteredText = [self.commentTextField.text copy];
            
            [self.dataStore inputCommentWithComment:enteredText imageID:self.image.imageID withCompletion:^(PFObject *comment) {
                [self.image.comments addObject:comment];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.belowPictureTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                    self.commentCountLable.title = [NSString stringWithFormat:@"%lu", self.image.comments.count];
                }];
            }];
            self.commentTextField.text = @"";
            [self.commentTextField resignFirstResponder];
        }else
        {
            NSLog(@"Invalid Comment");
        }

    }

}

- (IBAction)textFieldAction:(UITextField *)sender
{
    [sender setClearButtonMode:UITextFieldViewModeWhileEditing];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

- (void)keyboardWillChangePosition:(NSNotification *)notifcatiion {
    CGRect keyboardFrame;
    CGFloat imageTopConstant = 0;
    if ([notifcatiion.name isEqualToString:UIKeyboardWillHideNotification]) {
        NSLog(@"KEYBOARD WILL HDIE!!");
        keyboardFrame = CGRectZero;
    } else {
        NSLog(@"Keybaord NOT hiding")   ;
        imageTopConstant = -(self.view.frame.size.height/2);
        keyboardFrame = [notifcatiion.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    }
    
    UIViewAnimationCurve curve = [notifcatiion.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    NSTimeInterval duration = [notifcatiion.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        self.commenSectionBottomConstraint.constant = (keyboardFrame.size.height);
        self.imageViewTopConstraint.constant = imageTopConstant;
        [self.view layoutIfNeeded];
    }];
}

@end
