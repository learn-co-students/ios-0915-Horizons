//
//  UserCommentsViewController.h
//  Fax-Machine
//
//  Created by Selma NB on 11/23/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCommentsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIToolbarDelegate>

@property (nonatomic, strong) NSMutableArray *usersCommentsArray;



@end
