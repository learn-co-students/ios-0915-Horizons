//
//  CommentTableViewCell.h
//  Fax-Machine
//
//  Created by Selma NB on 12/8/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end
