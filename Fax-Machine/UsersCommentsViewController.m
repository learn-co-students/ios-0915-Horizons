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


@end

@implementation UsersCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataStore = [DataStore sharedDataStore];
    self.commentsTable.delegate = self;
    self.commentsTable.dataSource = self;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.66
                                                  green:0.66
                                                   blue:0.66
                                                  alpha:0.75]];
    [self.commentsTable setBackgroundColor:[UIColor  colorWithRed:0.66
                                                                     green:0.66
                                                                      blue:0.66
                                                                     alpha:0.75]];    [self.postButton setEnabled:YES];
    [self.postButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.commentTxtField.placeholder = @"Write a comment...";
    self.commentTxtField.layer.borderColor = [[UIColor grayColor]CGColor];
    self.commentTxtField.layer.borderWidth=2.0;
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
        
        cell.backgroundColor = [UIColor whiteColor];
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
