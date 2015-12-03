//
//  UsersCommentsViewController.m
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "UsersCommentsViewController.h"
#import "DataStore.h"
#import "Comment.h"

@interface UsersCommentsViewController ()

@property (nonatomic, strong)DataStore *dataStore;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewBottomConstraint;

- (void)keyboardWillChangePosition:(NSNotification *)notifcatiion;

@end

@implementation UsersCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataStore = [DataStore sharedDataStore];
    
    //self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mountains_hd"]];
    
    self.commentsTable.backgroundColor = [UIColor colorWithWhite:0.15 alpha:.85];
    self.commentsTable.opaque = NO;
    self.commentsTable.separatorColor = [UIColor clearColor];
    self.commentsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentsTable.separatorInset = UIEdgeInsetsZero;
    self.commentsTable.delegate = self;
    self.commentsTable.dataSource = self;

    [self.postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.postButton.opaque = NO;
    self.postButton.backgroundColor = [UIColor clearColor];
    
//    self.commentTxtField.borderStyle = UITextBorderStyleRoundedRect;
//    self.commentTxtField.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.commentTxtField.backgroundColor = [UIColor whiteColor];
    self.commentTxtField.layer.borderWidth = 1;
    self.commentTxtField.placeholder = @"Write a comment...";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangePosition:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangePosition:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
}

- (void)keyboardWillChangePosition:(NSNotification *)notifcatiion {
    
    
    NSLog(@"GETTING CALLED!!!");
    
    // Each notification includes a nil object and a userInfo dictionary containing the
    // begining and ending keyboard frame in screen coordinates. Use the various UIView and
    // UIWindow convertRect facilities to get the frame in the desired coordinate system.
    // Animation key/value pairs are only available for the "will" family of notification.
    
    CGRect keyboardFrame;
    if ([notifcatiion.name isEqualToString:UIKeyboardWillHideNotification]) {
        
        NSLog(@"KEYBOARD WILL HDIE!!");
        keyboardFrame = CGRectZero;
    } else {
        
        NSLog(@"Keybaord NOT hiding")   ;
        
        keyboardFrame = [notifcatiion.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    }
    
    UIViewAnimationCurve curve = [notifcatiion.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    NSTimeInterval duration = [notifcatiion.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    
    [UIView animateWithDuration:duration
                     animations:^{
                         
                         NSLog(@"animation getting called?");
                         [UIView setAnimationCurve:curve];
                         
                         self.stackViewBottomConstraint.constant = (keyboardFrame.size.height) * -1;
                         
                         [self.view layoutIfNeeded];
                     }];

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectedImage.comments.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        cell.opaque = NO;
        cell.backgroundColor = [UIColor colorWithWhite:0.55 alpha:0.85];
        if (indexPath.row % 2 == 1) {
            cell.backgroundColor = [UIColor colorWithWhite:0.45 alpha:0.85];
        }
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:17.0];
    }
  
    PFObject *comment = self.selectedImage.comments[indexPath.row];
    cell.textLabel.text = comment[@"userComment"];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addCommentButton:(UIBarButtonItem *)sender {
    
    //Comment *commentObject = [[Comment alloc]initWithComment:self.txtField.text image:self.selectedImage];
    //PFObject *
    //[self.selectedImage.comments addObject:commentObject];
    //[self.usersCommentsArray addObject:commentObject];
    if (self.commentTxtField.text.length && ![self.commentTxtField.text isEqualToString:@" "]) {
        
        NSLog(@"It's an OK message.");
        
        NSString *enteredText = [self.commentTxtField.text copy];
        
        [self.dataStore inputCommentWithComment:enteredText imageID:self.selectedImage.imageID withCompletion:^(PFObject *comment) {
            [self.selectedImage.comments addObject:comment];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.commentsTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
    }];
    }else
    {
        NSLog(@"Invalid Comment");
    }
    self.commentTxtField.text = @"";
}

- (IBAction)textFieldAction:(UITextField *)sender
{
        self.commentTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.commentTxtField setClearButtonMode:UITextFieldViewModeWhileEditing];

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self.ScrollView setContentOffset:(CGPointMake(0, 230)) animated:YES];
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.ScrollView setContentOffset:(CGPointMake(0, 0)) animated:YES];
    [self.commentTxtField resignFirstResponder];
    return TRUE;
}




@end
