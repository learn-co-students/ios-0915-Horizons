//
//  ImagesDetailsViewController.h
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersCommentsViewController.h"

@interface ImagesDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ImageObject *image;
@property (nonatomic, strong) NSMutableArray *owners;

@end
