//
//  UsersCommentsViewController.h
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersCommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *commentsTable;
@property (nonatomic, strong) NSMutableArray *usersCommentsArray;


- (IBAction)addComment:(UIButton *)sender;

@end
