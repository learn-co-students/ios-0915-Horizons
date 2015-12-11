//
//  imagesCustomCell.h
//  Fax-Machine
//
//  Created by Selma NB on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imagesCustomCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *myImage;

@property (strong, nonatomic) IBOutlet UILabel *mydiscriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentImageLabel;

@end
