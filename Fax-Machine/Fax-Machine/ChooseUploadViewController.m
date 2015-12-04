//
//  ChooseUploadViewController.m
//  Fax-Machine
//
//  Created by Claire Davis on 12/2/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "ChooseUploadViewController.h"
#import "ImageUploadViewController.h"
#import "LocationData.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
#import "APIConstants.h"
#import "DataStore.h"
#import <ImageIO/ImageIO.h>
#import <ParseUI/ParseUI.h>
#import "SignUpViewController.h"
#import <Photos/Photos.h>
#import <FCCurrentLocationGeocoder/FCCurrentLocationGeocoder.h>
#import <MBProgressHUD/MBProgressHUD.h>



@interface ChooseUploadViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *savedPhotosButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, strong) UIAlertController *sourcePicker;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic)BOOL isImageFromPicker;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong)Location *location;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *country;
@property (nonatomic, strong)NSString *mood;
@property (nonatomic)BOOL hasAllMetadata;
@property (nonatomic, strong) FCCurrentLocationGeocoder *geoCoder;


@end

@implementation ChooseUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.imagePickerController = [UIImagePickerController new];

  
  [[self.savedPhotosButton layer] setBorderWidth:1.0f];
//  [[self.savedPhotosButton layer]setBorderColor:[UIColor darkGrayColor].CGColor];

  
  [[self.takePhotoButton layer] setBorderWidth:1.0f];
//  [[self.takePhotoButton layer]setBorderColor:[UIColor darkGrayColor].CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)takePhotoButtonTapped:(id)sender {
  //Setting the pickerDelegate and allow editting.
  self.imagePickerController.delegate = self;
  self.imagePickerController.allowsEditing = NO;
  
  //Setting the source of the image as type Camera.-
  self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
  self.isImageFromPicker = NO;
  [self presentViewController:self.imagePickerController animated:YES completion:nil];
}
- (IBAction)uploadPhotoButtonTapped:(id)sender {
  self.imagePickerController.delegate = self;
  self.imagePickerController.allowsEditing = NO;
  self.isImageFromPicker = YES;
  //Setting the source type as Photo library
  self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [self presentViewController:self.imagePickerController animated:YES completion:nil];
}
- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
  [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier]isEqualToString:@"uploadSegue"]) {
    ImageUploadViewController *VC = [segue destinationViewController];
    VC.isImageFromPicker = self.isImageFromPicker;
    VC.selectedImage = self.selectedImage;
    VC.hasAllMetadata = self.hasAllMetadata;
    VC.city = self.city;
    VC.country = self.country;
    VC.mood = self.mood;
    VC.location = self.location;
  }
}
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//  self.selectedImage = info[UIImagePickerControllerOriginalImage];
//  
//  [self performSegueWithIdentifier:@"uploadSegue" sender:self];
//}
-(NSNumber *)getImageOrientationWithImage:(UIImage *)image{
  //Returning the orientation of the image for better detection.
  NSUInteger exifOrientation;
  switch (image.imageOrientation) {
    case UIImageOrientationUp:
      exifOrientation = 1;
      break;
    case UIImageOrientationDown:
      exifOrientation = 3;
      break;
    case UIImageOrientationLeft:
      exifOrientation = 8;
      break;
    case UIImageOrientationRight:
      exifOrientation = 6;
      break;
    case UIImageOrientationUpMirrored:
      exifOrientation = 2;
      break;
    case UIImageOrientationDownMirrored:
      exifOrientation = 4;
      break;
    case UIImageOrientationLeftMirrored:
      exifOrientation = 5;
      break;
    case UIImageOrientationRightMirrored:
      exifOrientation = 7;
      break;
    default:
      break;
  }
  
  return @(exifOrientation);
}

#pragma mark - UIImage picker protocols
/**
 *  Handling the image after selection is performed.
 *
 *  @param picker The image picker
 *  @param info   Info of the selected image
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
  //Below section is for face detection in image with Core Image.
  CIImage *image = [CIImage imageWithCGImage: self.selectedImage.CGImage];
  NSDictionary *opts = @{CIDetectorAccuracy : CIDetectorAccuracyHigh};
  CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                            context:nil
                                            options:opts];
  
  NSNumber *orientation = [self getImageOrientationWithImage:self.selectedImage];
  opts = @{CIDetectorImageOrientation : orientation};
  NSArray *features = [detector featuresInImage:image options:opts];
  
  NSOperationQueue *bgQueue = [NSOperationQueue new];
  NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^
                            {
                              if (!features.count)
                              {
                                self.selectedImage = info[UIImagePickerControllerOriginalImage];
                                NSURL *imageUrl = info[UIImagePickerControllerReferenceURL];

                                [picker dismissViewControllerAnimated:YES completion:nil];
                                                                                 [self performSegueWithIdentifier:@"uploadSegue" sender:self];
                                
                                if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                                  PHAsset *asset = [LocationData logMetaDataFromImage:imageUrl];
                                  
                                  //If image asset contains geo data, fetch and display it on textfield.
                                  if (asset.location) {
                                    PFGeoPoint *newGeoPoint = [PFGeoPoint geoPointWithLocation:asset.location];
                                    NSMutableDictionary *dic = [@{@"location" : asset.location,
                                                                  @"date" : asset.creationDate} mutableCopy];
                                    self.creationDate = asset.creationDate;
                                    [LocationData getCityAndDateFromDictionary:dic withCompletion:^(NSString *city, NSString *country, NSDate *date, BOOL success)
                                     {
                                       self.location = [[Location alloc] initWithCity:city country:country geoPoint:newGeoPoint dateTaken:date];
                                       [LocationData getWeatherInfoFromDictionary:dic withCompletion:^(NSDictionary *weather)
                                        {
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^
                                           {
                                             NSString *weatherOfImage = weather[@"currently"][@"summary"];
                                             self.mood = weatherOfImage;
                                             self.country = self.location.country;
                                             self.city = self.location.city;
                                             self.hasAllMetadata = YES;
                                             [self performSegueWithIdentifier:@"uploadSegue" sender:self];
                                           }];
                                        }];
                                       
                                     }];
                                  }
                                  
                                } else if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
                                  //When image source equals to Camera
                                  self.creationDate = [NSDate date];
                                  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    self.geoCoder = [FCCurrentLocationGeocoder sharedGeocoder];
                                    self.geoCoder.canUseIPAddressAsFallback = YES;
                                    self.geoCoder.timeoutErrorDelay = 5;
                                    NSLog(@"GeoCode enable: %d", [self.geoCoder canGeocode]);
                                    [self.geoCoder geocode:^(BOOL success) {
                                      if (success) {
                                        PFGeoPoint *newGeoPoint = [PFGeoPoint geoPointWithLocation:self.geoCoder.location];
                                        NSMutableDictionary *newDictionary = [@{@"location": self.geoCoder.location,
                                                                                @"date":[NSDate date]} mutableCopy];
                                        [LocationData getCityAndDateFromDictionary:newDictionary withCompletion:^(NSString *city, NSString *country, NSDate *date, BOOL success)
                                         {
                                           self.location = [[Location alloc] initWithCity:city country:country geoPoint:newGeoPoint dateTaken:date];
                                           [LocationData getWeatherInfoFromDictionary:newDictionary withCompletion:^(NSDictionary *weather)
                                            {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^
                                               {
                                                 NSString *weatherOfImage = weather[@"currently"][@"summary"];
                                                 self.mood = weatherOfImage;
                                                 self.country = self.location.country;
                                                 self.city = self.location.city;
                                                 self.location.weather = weather;
                                                 self.hasAllMetadata = YES;
                                                 [self performSegueWithIdentifier:@"uploadSegue" sender:self];
                                               }];
                                            }];
                                         }];
                                      }else{
                                        NSLog(@"Time out fetch geo loadtion!");
                                      }
                                    }];
                                  }];
                                }
                              }

                            }];
  [bgQueue addOperation:operation];
  
  //Displaying the selected image in the image view holder.
}


@end
