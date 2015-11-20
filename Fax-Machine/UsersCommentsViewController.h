//
//  UsersCommentsViewController.h
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersCommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIToolbarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *commentsTable;
@property (nonatomic, strong) NSMutableArray *usersCommentsArray;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarIBOutlet;

- (IBAction)addCommentButton:(UIBarButtonItem *)sender;





@end
