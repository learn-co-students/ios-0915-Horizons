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
    self.txtField.delegate = self;
    //self.usersCommentsArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor grayColor];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataStore.comments.count;
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
    
        cell.detailTextLabel.text = @"User1";
        //cell.textLabel.text = self.usersCommentsArray[indexPath.row];
        cell.textLabel.text = self.dataStore.comments[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addCommentButton:(UIBarButtonItem *)sender {
    
//    Comment *commentObject = [Comment alloc]initWithComment:self.txtField.text image:<#(ImageObject *)#>
    [self.dataStore.comments addObject:self.txtField.text];
    [self.commentsTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (IBAction)textFieldAction:(UITextField *)sender {
        self.txtField.autocorrectionType = UITextAutocorrectionTypeNo;
         [self.txtField setClearButtonMode:UITextFieldViewModeWhileEditing];

}


@end
