//
//  ImageUploadViewController.h
//  Fax-Machine
//
//  Created by Kevin Lin on 11/17/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Location;
@class FCCurrentLocationGeocoder;


@interface ImageUploadViewController : UIViewController
@property (nonatomic) BOOL isImageFromPicker;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic)BOOL hasAllMetadata;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *country;
@property (nonatomic, strong)NSString *mood;
@property (nonatomic, strong)Location *location;
@property (nonatomic, strong) FCCurrentLocationGeocoder *geoCoder;

@end
