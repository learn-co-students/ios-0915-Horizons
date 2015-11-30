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

@property (weak, nonatomic) IBOutlet UITableView *commentsTable;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarIBOutlet;

@end

@implementation UsersCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataStore = [DataStore sharedDataStore];
    self.commentsTable.delegate = self;
    self.commentsTable.dataSource = self;
    self.txtField.delegate = self;
    self.view.backgroundColor = [UIColor grayColor];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"Whats up with this count : %ld", self.selectedImage.comments.count);
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:17.0];
        
        // [[cell mydiscriptionLabel]setText:[self.arrayWithDescriptions objectAtIndex:indexPath.item]];
        
    }
    //PFObject *user = [DataStore getUserWithObjectID:self.selectedImage.owner.objectId] ;
    //NSLog(@"User: %@", user[@"username"]);
    //cell.detailTextLabel.text = user[@"username"];
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
    if (self.txtField.text.length && ![self.txtField.text isEqualToString:@" "]) {
        
        NSLog(@"It's an OK message.");
        
        NSString *enteredText = [self.txtField.text copy];
        
        [self.dataStore inputCommentWithComment:enteredText imageID:self.selectedImage.imageID withCompletion:^(PFObject *comment) {
            [self.selectedImage.comments addObject:comment];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.commentsTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
//            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.selectedImage.comments.count inSection:0];
//            [self.commentsTable reloadRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
//            [self.commentsTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }else{
        NSLog(@"Invalid Comment");
    }
    self.txtField.text = @"";
}

- (IBAction)textFieldAction:(UITextField *)sender {
        self.txtField.autocorrectionType = UITextAutocorrectionTypeNo;
         [self.txtField setClearButtonMode:UITextFieldViewModeWhileEditing];

}


@end
