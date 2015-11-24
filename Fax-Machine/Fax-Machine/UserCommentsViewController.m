//
//  UserCommentsViewController.m
//  Fax-Machine
//
//  Created by Selma NB on 11/23/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "UserCommentsViewController.h"

@interface UserCommentsViewController ()

@end

@implementation UserCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usersCommentsArray = [[NSMutableArray alloc]init];
    [self.usersCommentsArray addObject:@"testing"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersCommentsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Comments Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSLog(@"Cell Customize");
        // Customize TableView Cells.b
        // Cell background.
        [cell setBackgroundColor:[UIColor grayColor]];
        // Selection style.
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        // Accessory type.
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        // Cell textlabel.
        [[cell textLabel] setFont:[UIFont fontWithName:@"Georgia" size:15.0]];
    }
    
    [[cell textLabel] setText:[self.usersCommentsArray objectAtIndex:[indexPath row]]];
    
    NSLog(@"I am here");
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
