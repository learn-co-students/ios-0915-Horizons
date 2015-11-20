//
//  SearchViewController.h
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UISearchBarDelegate , UISearchDisplayDelegate>
@property (strong, nonatomic) IBOutlet UITableView *SearchResultsTableViewController;

@end
