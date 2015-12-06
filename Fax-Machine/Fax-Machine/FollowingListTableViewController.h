//
//  FollowingListTableViewController.h
//  Fax-Machine
//
//  Created by Kevin Lin on 12/5/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"
#import "FollowingListTableViewCell.h"
#import <YYWebImage/YYWebImage.h>
#import "APIConstants.h"

@interface FollowingListTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *followingList;
@property (nonatomic, strong) DataStore *dataStore;

@end
