//
//  ImageUploadViewController.m
//  Fax-Machine
//
//  Created by Kevin Lin on 11/17/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

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

@interface ImageUploadViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageHolderView;
@property (nonatomic, strong) UIAlertController *sourcePicker;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic) BOOL firstTime;

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *moodTextField;

@property (nonatomic, strong)Location *location;

@property (nonatomic, strong) DataStore *dataStore;
@property (nonatomic, strong) ImageObject *parseImageObject;

@end

@implementation ImageUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataStore = [DataStore sharedDataStore];
    //Initiating the image picker controller.
    self.imagePickerController = [UIImagePickerController new];
    UIImage *placeholder = [UIImage imageNamed:@"cloud"];
    self.imageHolderView.image = placeholder;
    
    self.firstTime = YES;
}

-(void)viewDidAppear:(BOOL)animated{
  
  if (self.firstTime) {
        self.firstTime = NO;
      [self imageUpLoadSource];
  
    }
}

/**
 *  If user want to change the selected image.
 *
 *  @param sender One tap gesture on the image view holder itself.
 */
- (IBAction)selectImageAndView:(id)sender {
    //Calling the UIAlertController when screen loaded.
    //NSLog(@"City: %@",[FCCurrentLocationGeocoder sharedGeocoder].locationCity);
    //[[FCCurrentLocationGeocoder sharedGeocoder] cancelGeocode];
    [self imageUpLoadSource];
}

/**
 *  When user done selecting the image
 *
 *  @param sender UINavigation right bar Done button.
 */
- (IBAction)finishedImageSelect:(id)sender {

    NSLog(@"done");
    UIImage *image = self.selectedImage;
    NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
    NSLog(@"filename: %@", fileName);
    
    //For creating image object for Parse
    if (self.location.city.length) {
        self.parseImageObject = [[ImageObject alloc] initWithTitle:@"Some title" imageID:fileName mood:self.moodTextField.text location:self.location];
        NSLog(@"With location info!");
    }
    else{
        self.parseImageObject = [[ImageObject alloc]initWithTitle:@"Default Title" imageID:fileName mood:@"Default Mood" location:[Location new]];
        NSLog(@"With no location info!");
    }
    [self.dataStore uploadImageWithImageObject:self.parseImageObject WithCompletion:^(BOOL complete) {
        if (complete) {
            NSLog(@"Parse upload completed!");
            //  NSString *filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"upload"] stringByAppendingPathComponent:fileName];
            NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"upload-image.tmp"];
            NSLog(@"filepath %@", filePath);
            
            NSData * imageData = UIImagePNGRepresentation(image);
            
            [imageData writeToFile:filePath atomically:YES];
            
            AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
            uploadRequest.body = [NSURL fileURLWithPath:filePath];
            uploadRequest.key = fileName;
            NSLog(@"poolID: %@",POOL_ID);
            uploadRequest.bucket = @"fissamplebucket";
            NSLog(@"uploadRequest: %@", uploadRequest);
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [DataStore uploadPictureToAWS:uploadRequest WithCompletion:^(BOOL complete) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"upload completed!");
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }else{
            NSLog(@"Issue with upload");
        }
    }];
    
}

/**
 *  When user cancel the image select view.
 *
 *  @param sender UINavigation left bar Cancel button.
 */
- (IBAction)cancelImageSelect:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  Creating an alert view to ask for user's input on the image source
 */
- (void)imageUpLoadSource{
    
    //UIAlertController to fetch user input
    self.sourcePicker = [UIAlertController alertControllerWithTitle:@"Image Source" message:@"Please choose where you want to pull your image" preferredStyle:UIAlertControllerStyleAlert];
    
    //Setting the Camera source option
    //***Reminder*** camera source does not work in simulator.
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"📷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //Setting the pickerDelegate and allow editting.
        self.imagePickerController.delegate = self;
        self.imagePickerController.allowsEditing = NO;
        
        //Setting the source of the image as type Camera.
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }];
    
    //Setting the Photo library as the source of the image
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"🖼" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        self.imagePickerController.delegate = self;
        self.imagePickerController.allowsEditing = NO;
        
        //Setting the source type as Photo library
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    //Adding all the actions to the UIAlerController.
    [self.sourcePicker addAction:camera];
    [self.sourcePicker addAction:photo];
    [self.sourcePicker addAction:cancel];
    
    [self presentViewController:self.sourcePicker animated:YES completion:nil];

}

-(void)upload:(AWSS3TransferManagerUploadRequest*)uploadRequest
{
  AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];

  [[transferManager upload:uploadRequest]continueWithBlock:^id(AWSTask *task) {
    if (task.error) {
      if (([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain])) {
        switch (task.error.code) {
          case AWSS3TransferManagerErrorCancelled:
          case AWSS3TransferManagerErrorPaused:
            break;
            
          default:
            NSLog(@"upload failed: %@", task.error);
            break;
        }
      } else {
        NSLog(@"upload failed else: %@", task.error);
        }
    }
    if (task.result) {
      AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
      NSLog(@"UPLOAD OUTPUT: %@",uploadOutput);
    }
    return nil;
  }];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)invalidImageAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invliad Image"
                                                                   message:@"Sorry, but selfies are prohibited!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okay = [UIAlertAction actionWithTitle:@"okay" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okay];
    [self presentViewController:alert animated:YES completion:nil];
}

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
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 self.imageHolderView.image = self.selectedImage;
             }];
            [picker dismissViewControllerAnimated:YES completion:nil];
            
            if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                PHAsset *asset = [LocationData logMetaDataFromImage:imageUrl];
                
                //If image asset contains geo data, fetch and display it on textfield.
                if (asset.location) {
                    PFGeoPoint *newGeoPoint = [PFGeoPoint geoPointWithLocation:asset.location];
                    NSMutableDictionary *dic = [@{@"location" : asset.location,
                                                  @"date" : asset.creationDate} mutableCopy];
                    [LocationData getCityAndDateFromDictionary:dic withCompletion:^(NSString *city, NSString *country, NSDate *date, BOOL success)
                     {
                         self.location = [[Location alloc] initWithCity:city country:country geoPoint:newGeoPoint dateTaken:date];
                         [LocationData getWeatherInfoFromDictionary:dic withCompletion:^(NSDictionary *weather)
                          {
                              NSLog(@"Weather Info: %@", weather);
                              [[NSOperationQueue mainQueue] addOperationWithBlock:^
                               {
                                   NSString *weatherOfImage = weather[@"currently"][@"summary"];
                                   self.moodTextField.text = weatherOfImage;
                                   self.countryTextField.text = self.location.country;
                                   self.cityTextField.text = self.location.city;
                               }];
                          }];
                         
                     }];
                }
                
            } else if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
                NSLog(@"Camera!!!!!!!!!!!");
                //When image source equals to Camera
                FCCurrentLocationGeocoder *geoCoder = [FCCurrentLocationGeocoder sharedGeocoder];
                geoCoder.canUseIPAddressAsFallback = YES;
                geoCoder.timeoutErrorDelay = 5;
                NSLog(@"GeoCode enable: %d", [geoCoder canGeocode]);
                [geoCoder geocode:^(BOOL success) {
                    NSLog(@"Location: %@", geoCoder.location);
                    if (success) {
                        PFGeoPoint *newGeoPoint = [PFGeoPoint geoPointWithLocation:geoCoder.location];
                        NSMutableDictionary *newDictionary = [@{@"location": geoCoder.location,
                                                                @"date":[NSDate date]} mutableCopy];
                        [LocationData getCityAndDateFromDictionary:newDictionary withCompletion:^(NSString *city, NSString *country, NSDate *date, BOOL success)
                         {
                             self.location = [[Location alloc] initWithCity:city country:country geoPoint:newGeoPoint dateTaken:date];
                             [LocationData getWeatherInfoFromDictionary:newDictionary withCompletion:^(NSDictionary *weather)
                              {
                                  [[NSOperationQueue mainQueue] addOperationWithBlock:^
                                   {
                                       NSString *weatherOfImage = weather[@"currently"][@"summary"];
                                       self.moodTextField.text = weatherOfImage;
                                       self.countryTextField.text = self.location.country;
                                       self.cityTextField.text = self.location.city;
                                   }];
                              }];
                         }];
                    }else{
                        NSLog(@"Time out fetch geo loadtion!");
                    }
                }];
            }
        }
        else
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self invalidImageAlert];
                [picker dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
    [bgQueue addOperation:operation];
    
    //Displaying the selected image in the image view holder.
}

/**
 *  Dimissing picker view if user cancels image select.
 *
 *  @param picker UIImagePickerCcontroller
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
