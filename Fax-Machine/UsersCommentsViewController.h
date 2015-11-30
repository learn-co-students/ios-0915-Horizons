//
//  UsersCommentsViewController.h
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageObject.h"

@interface UsersCommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIToolbarDelegate>

@property (nonatomic, strong)ImageObject *selectedImage;

@end
