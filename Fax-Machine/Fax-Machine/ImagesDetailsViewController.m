//
//  ImagesDetailsViewController.m
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "ImagesDetailsViewController.h"
#import "UsersCommentsViewController.h"


@interface ImagesDetailsViewController ()
@property (nonatomic) NSUInteger photoLikesCounter;
@property (nonatomic) UsersCommentsViewController *commentsArray;
@end

@implementation ImagesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageDetails.image = self.img;
    self.likesCounter.tintColor= [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.66
                                                  green:0.66
                                                   blue:0.66
                                                  alpha:0.75]];
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
    
    return self.commentsArray.usersCommentsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 45.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:17.0];
        
    }
    
    cell.detailTextLabel.text = @"User1";
    cell.textLabel.text = self.commentsArray.usersCommentsArray[indexPath.row];
    
    [self.commentsArray.commentsTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    return cell;
}

//- (IBAction)commentIcon:(UIBarButtonItem *)sender {
//    
//}
//

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.destinationViewController isKindOfClass:[UsersCommentsViewController class]]) {
//        //UsersCommentsViewController *destinationVC = segue.destinationViewController;
//
//    }
//}

- (IBAction)likeButton:(UIBarButtonItem *)sender {
      
    self.photoLikesCounter += 1;
    self.likesCounter.tintColor= [UIColor whiteColor];
    self.likesCounter.title = [NSString stringWithFormat:@"❤️ %ld", self.photoLikesCounter];
}
@end
