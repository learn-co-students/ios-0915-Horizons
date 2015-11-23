//
//  UsersCommentsViewController.m
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "UsersCommentsViewController.h"

@interface UsersCommentsViewController ()

@end

@implementation UsersCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentsTable.delegate = self;
    self.commentsTable.dataSource = self;
    self.txtField.delegate = self;
   // self.txtField.inputAccessoryView = self.toolbarIBOutlet;
    
    //could use this inside a method instead
    self.usersCommentsArray = [[NSMutableArray alloc]init];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.66
                                                  green:0.66
                                                   blue:0.66
                                                  alpha:0.75]];
    
//    // Add self as observer to the NSNotificationCenter so we know when the keyboard is about to be shown up.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];
//
}

-(void)keyboardWillShowWithNotification:(NSNotification *)notification
{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersCommentsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //Row height
    return 45.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSLog(@"Cell Customize");
        // Customize TableView Cells.
        // Cell background.
        [cell setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        
        // Selection style.
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        // Accessory type.
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        // Cell textlabel.
        [[cell textLabel] setFont:[UIFont fontWithName:@"Georgia" size:15.0]];
    }
    
    [[cell textLabel] setText:[self.usersCommentsArray objectAtIndex:[indexPath row]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)addCommentButton:(UIBarButtonItem *)sender {
}

- (IBAction)addComment:(UIButton *)sender {
}
@end
