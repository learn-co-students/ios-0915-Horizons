//
//  imagesCustomCell.m
//  Fax-Machine
//
//  Created by Selma NB on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "imagesCustomCell.h"

@implementation imagesCustomCell




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self){
        [self commonInit];
    }
    return self;
}

-(void)commonInit{

    CGFloat customCellHeight = self.contentView.bounds.size.height;
    CGFloat customCellWidth = self.contentView.bounds.size.width;
   
    self.myImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, customCellWidth, customCellHeight)];
    [self.myImage setClipsToBounds:NO];
    
    self.myImage.translatesAutoresizingMaskIntoConstraints = YES;
    [self.contentView addSubview:self.myImage];
}


@end
