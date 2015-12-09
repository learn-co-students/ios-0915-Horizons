//
//  ImagesDetailsViewController.m
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "ImagesDetailsViewController.h"
#import "DataStore.h"
#import <YYWebImage/YYWebImage.h>
#import "APIConstants.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "HelperMethods.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "CommentTableViewCell.h"
#import <Parse/Parse.h>

@interface ImagesDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIImageView *imageDetails;
@property (weak, nonatomic) IBOutlet UITableView *belowPictureTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *likeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *commentButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *commentCountLable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *socialSharing;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ownerFollow;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reportButton;

@property (weak, nonatomic) IBOutlet UIView *commentSectionView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commenSectionBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;

@property (nonatomic) NSUInteger photoLikesCounter;
@property (nonatomic, strong)DataStore *dataStore;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic) BOOL liked;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UITextView *imageDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;


@end

@implementation ImagesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [DataStore sharedDataStore];
  self.commentTextField.delegate = self;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mountains_hd"]];
  self.backgroundView.backgroundColor = [UIColor colorWithWhite:.15 alpha:.85];

    self.belowPictureTableView.backgroundColor = [UIColor colorWithWhite:0.15 alpha:.85];
    self.belowPictureTableView.estimatedRowHeight = 100;
    self.belowPictureTableView.rowHeight = UITableViewAutomaticDimension;
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

    PFUser *imageOwner = self.image.owner;
    NSString *displayName = [[imageOwner.username componentsSeparatedByString:@"@"] firstObject];
    self.imageDescriptionLabel.text = [NSString stringWithFormat:@"%@-%@",displayName, self.image.title];
    self.imageDescriptionLabel.editable = YES;
    self.imageDescriptionLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    self.imageDescriptionLabel.font = [UIFont systemFontOfSize:17];
    self.imageDescriptionLabel.textColor = [UIColor whiteColor];
    self.imageDescriptionLabel.editable = NO;

    NSString *urlString = [NSString stringWithFormat:@"%@%@", IMAGE_FILE_PATH, self.image.imageID];
    NSURL *url = [NSURL URLWithString:urlString];
    self.imageDetails.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageDetails yy_setImageWithURL:url options:YYWebImageOptionProgressive];
    self.navigationItem.title = [NSString stringWithFormat:@"%@, %@",self.image.location.city,self.image.location.country];

    PFUser *user = [PFUser currentUser];
    NSArray *savedImages = user[@"savedImages"];
    
    FAKFontAwesome *commentIcon = [FAKFontAwesome commentsIconWithSize:20];
    self.commentButton.image = [commentIcon imageWithSize:CGSizeMake(20, 20)];
    self.commentButton.tintColor = [UIColor whiteColor];
    FAKFontAwesome *download = [FAKFontAwesome downloadIconWithSize:20];
    self.socialSharing.image = [download imageWithSize:CGSizeMake(20, 20)];
    self.socialSharing.tintColor = [UIColor whiteColor];
    
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
    self.likeButton.tintColor = [UIColor whiteColor];
    self.likeCountLabel.enabled = NO;
    self.commentCountLable.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangePosition:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangePosition:) name:UIKeyboardWillHideNotification object:nil];
  

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.belowPictureTableView reloadData];
    self.commentCountLable.title = [NSString stringWithFormat:@"%lu", (unsigned long)self.image.comments.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)dismissKeyboard
{
  [self.commentTextField resignFirstResponder];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.image.comments.count;
}

- (IBAction)reportTapped:(id)sender {
    PFUser *user = [PFUser currentUser];
    NSArray *savedImages = user[@"reportedImages"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId MATCHES %@", self.image.objectID];
    NSArray *filteredResult = [savedImages filteredArrayUsingPredicate:predicate];
    if (filteredResult.count) {
        [HelperMethods verifyAlertWithMessage:@"You already reported this image"];
    }else{
        [self.dataStore reportImage:self.image success:^(BOOL success) {
            if (success) {
                SCLAlertView *alert = [SCLAlertView new];
                [alert showSuccess:self title:@"Reported!" subTitle:@"Our team will review this image as soon as possible. If there are other reports, we will hide this image for display." closeButtonTitle:@"Okay" duration:0];
            }
        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];

    cell.opaque = NO;
    cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.85];
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.85];
    }
    cell.usernameLabel.textColor = [UIColor whiteColor];
    cell.commentLabel.textColor = [UIColor colorWithWhite:0.15 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.usernameLabel.font = [UIFont fontWithName:@"Arial" size:17.0];

    //cell.detailTextLabel.text = user[@"username"];
    PFObject *comment = self.image.comments[indexPath.row];

    PFUser *user = comment[@"owner"];
    NSString *username = [user.username componentsSeparatedByString:@"@"][0];

    cell.usernameLabel.text = [NSString stringWithFormat:@"%@:",username];
    cell.commentLabel.text = comment[@"userComment"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.commentLabel.numberOfLines = 0;
    
    [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)likeButton:(UIBarButtonItem *)sender {
    PFUser *user = [PFUser currentUser];
    if(![[user objectForKey:@"emailVerified"] boolValue])
    {
        [[HelperMethods new] parseVerifyEmailWithMessage:@"You must Verify your email before you can like!"];
    }else{
        if (!self.liked) {
            self.liked = YES;
            [self.dataStore likeImageWithImageID:self.image.imageID withCompletion:^(BOOL complete) {
                NSLog(@"Testing!!!");
                FAKFontAwesome *heart = [FAKFontAwesome heartIconWithSize:20];
                self.likeButton.image = [heart imageWithSize:CGSizeMake(20, 20)];
                
                self.image.likes = @([self.image.likes integerValue] + 1);
                self.likeCountLabel.title = [NSString stringWithFormat:@"%@", self.image.likes];
            }];
        }
    }
}

- (IBAction)socialSharing:(id)sender {
    PFUser *user = [PFUser currentUser];
    if(![[user objectForKey:@"emailVerified"] boolValue])
    {
        [[HelperMethods new] parseVerifyEmailWithMessage:@"You must Verify your email before you can share!"];
    }else{
        UIImage * image = self.imageDetails.image;
        
        NSArray * shareItems = @[image];
        
        UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
        
        [self presentViewController:avc animated:YES completion:nil];
    }
}

- (IBAction)followUser:(id)sender {
    PFUser *user = [PFUser currentUser];
    if(![[user objectForKey:@"emailVerified"] boolValue])
    {
        [[HelperMethods new] parseVerifyEmailWithMessage:@"You must Verify your email before you can follow!"];
    }else{
        PFUser *user = self.image.owner;
        
        BOOL isFollowed = NO;
        for (PFUser *followingUser in [PFUser currentUser][@"following"]) {
            if ([followingUser.objectId isEqualToString:self.image.owner.objectId]) {
                isFollowed = YES;
            }
        }
        
        if (isFollowed){
            [self followingAlertWithMessage:@"You already followed this user!"];
        }else if (![[PFUser currentUser].objectId isEqualToString:user.objectId]) {
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
}

-(void)followingAlertWithMessage:(NSString *)message
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showNotice:@"Notice!" subTitle:message closeButtonTitle:@"Dimiss" duration:0];
}

#pragma text field protocols

- (IBAction)postCommentButton:(UIButton *)sender {
    PFObject *user = PFUser.currentUser;
  PFUser *current = [PFUser currentUser];
    
    if(![[user objectForKey:@"emailVerified"] boolValue] && current.email != nil)
    {
        [[HelperMethods new] parseVerifyEmailWithMessage:@"You must Verify your email before you can post!"];
    }else{
        if (self.commentTextField.text.length && ![self.commentTextField.text isEqualToString:@" "]) {
            NSString *enteredText = [self.commentTextField.text copy];
            
            [self.dataStore inputCommentWithComment:enteredText imageID:self.image.imageID withCompletion:^(PFObject *comment) {
                [self.image.comments addObject:comment];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.belowPictureTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                    self.commentCountLable.title = [NSString stringWithFormat:@"%lu", (unsigned long)self.image.comments.count];
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
