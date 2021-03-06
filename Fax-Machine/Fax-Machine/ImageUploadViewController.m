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
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "ImagesViewController.h"

@interface ImageUploadViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *viewTapped;
@property (weak, nonatomic) IBOutlet UIImageView *imageHolderView;
@property (nonatomic, strong) UIAlertController *sourcePicker;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic) BOOL firstTime;
@property (nonatomic, strong)NSMutableArray *countriesArray;
@property (nonatomic, strong)UITableView *autocompleteTableView;
@property (nonatomic, strong)NSMutableArray *autocompleteCountries;
@property (nonatomic, strong)NSArray *moods;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;


@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *moodTextField;

@property (nonatomic)BOOL isValid;
@property (nonatomic, strong) DataStore *dataStore;
@property (nonatomic, strong) ImageObject *parseImageObject;


@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong)NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerVerticallyConstraint;
@property (nonatomic)CGFloat initialConstraintConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageAspectRatio;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITextField *captionTextBox;
@property (nonatomic, strong)NSString *caption;

@end

@implementation ImageUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [DataStore sharedDataStore];
    //Initiating the image picker controller.
    self.imagePickerController = [UIImagePickerController new];
    UIImage *placeholder = [UIImage imageNamed:@"cloud"];
    self.imageHolderView.image = placeholder;
    
    self.doneButton.tintColor = [UIColor whiteColor];
    self.cancelButton.tintColor = [UIColor whiteColor];
    self.firstTime = YES;
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:.15 alpha:.85];
    self.countryTextField.delegate = self;
    self.cityTextField.delegate = self;
    self.moodTextField.delegate = self;
    self.captionTextBox.delegate = self;
    self.countryTextField.text = self.country;
    self.cityTextField.text = self.city;
    self.moodTextField.text = self.mood;
    self.imageHolderView.image = self.selectedImage;
    self.captionTextBox.text = self.caption;
    self.moods = @[@"happy", @"sleepy", @"jubilant", @"tumultuous", @"sad"];
    
    if (!self.country || !self.city || !self.mood || !self.caption) {
        self.doneButton.enabled = NO;
    } else {
        self.doneButton.enabled = YES;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardControl:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardControl:) name:UIKeyboardWillHideNotification object:nil];
    
    
    self.bottomConstraint = [self.stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0];
    self.bottomConstraint.active = NO;
    
    self.initialConstraintConstant = self.centerVerticallyConstraint.constant;
    
    self.viewTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.viewTapped];
}

- (IBAction)selectMoodsPicker:(UITextField *)sender {
    UIPickerView *moodPicker = [UIPickerView new];
    moodPicker.delegate = self;
    moodPicker.dataSource = self;
    sender.inputView = moodPicker;
    [moodPicker becomeFirstResponder];
}

#pragma UIPickerView protocols
#pragma data source methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.moods.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.moods[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.moodTextField.text = self.moods[row];
}

-(void)dismissKeyboard
{
  [self.cityTextField resignFirstResponder];
  [self.countryTextField resignFirstResponder];
  [self.captionTextBox resignFirstResponder];
  [self.moodTextField resignFirstResponder];
}

-(void)keyboardControl:(NSNotification*)notification
{
    CGSize keyboardSize = [[[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    NSDictionary *userInfo = notification.userInfo;
    NSInteger length = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]integerValue];
    NSInteger option = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]integerValue];
    
    CGFloat smallerSize = keyboardSize.height ;
    
    [UIView animateWithDuration:length delay:0 options:option animations:^{
        if ([notification.name isEqualToString:@"UIKeyboardWillShowNotification"]) {
            [self.view bringSubviewToFront:self.navigationBar];
            self.centerVerticallyConstraint.constant = self.initialConstraintConstant - smallerSize;
            [self.view layoutIfNeeded];
        }
        else {
            self.imageHolderView.hidden = NO;
            self.centerVerticallyConstraint.constant = self.initialConstraintConstant;
            [self.view layoutIfNeeded];
        }
    } completion:^(BOOL finished) {
        nil;
    }];
}

-(void)presentInvalidLocationAlert
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showWarning:@"Location Is Invalid!" subTitle:@"Please enter a valid location" closeButtonTitle:@"Okay" duration:0];
    self.countryTextField.text = @"";
    self.cityTextField.text = @"";
    self.doneButton.enabled = NO;
}

-(void)presentMissingFieldAlert {
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showWarning:@"Uho!" subTitle:@"Please fill in empty fields" closeButtonTitle:@"Okay" duration:0];
    self.doneButton.enabled = NO;
}
-(void)presentInvalidCityAlert {
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showWarning:@"City Is Invalid!" subTitle:@"Please enter a valid city name"closeButtonTitle:@"Okay" duration:0];
    self.cityTextField.text = @"";
    self.doneButton.enabled = NO;
}


-(void)presentInvalidCountryAlert {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showWarning:@"Country Is Invalid!" subTitle:@"Please enter a valid country name"closeButtonTitle:@"Okay" duration:0];
    self.countryTextField.text = @"";
    self.cityTextField.text = @"";
    self.doneButton.enabled = NO;
}
-(void)presentInvalidCaptionAlert
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showWarning:@"Caption Needed!" subTitle:@"Please add a caption to your image" closeButtonTitle:@"Okay" duration:0];
    self.doneButton.enabled = NO;
}

-(void)presentInvalidMoodAlert
{

    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showWarning:@"Mood Needed!" subTitle:@"Please enter 'happy', 'sleepy' , 'jubilant', or 'tumultuous'"closeButtonTitle:@"Okay" duration:0];
    self.doneButton.enabled = NO;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
  
    if ([textField isEqual:self.cityTextField]) {
        [self.countryTextField becomeFirstResponder];
    } else if ([textField isEqual:self.countryTextField]) {
        [self.moodTextField becomeFirstResponder];
    } else if ([textField isEqual:self.captionTextBox]) {
      [self.cityTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    
    return YES;
}

- (IBAction)uploadTextFieldDetection:(UITextField *)sender {
    if (!sender.text.length || [sender.text isEqualToString:@" "]) {
        self.doneButton.enabled = NO;
    }else{
        if ([self.cityTextField.text isEqualToString:@""] && ![self.countryTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && ![self.moodTextField.text isEqualToString:@""]) {
            self.doneButton.enabled = NO;
            self.isValid = NO;
        } else if ([self.countryTextField.text isEqualToString:@""] && ![self.cityTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && ![self.moodTextField.text isEqualToString:@""]) {
            self.doneButton.enabled = NO;
            self.isValid = NO;
        } else if ([self.cityTextField.text isEqualToString:@""] && [self.countryTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && ![self.moodTextField.text isEqualToString:@""]) {
            self.doneButton.enabled = NO;
            self.isValid = NO;
            
        } else if (![self.cityTextField.text isEqualToString:@""] && ![self.countryTextField.text isEqualToString:@""] && [self.captionTextBox.text isEqualToString:@""] && ![self.moodTextField.text isEqualToString:@""]) {
            self.doneButton.enabled = NO;
            self.isValid = NO;
        }  else if (![self.cityTextField.text isEqualToString:@""] && ![self.countryTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && [self.moodTextField.text isEqualToString:@""]) {
            self.doneButton.enabled = NO;
            self.isValid = NO;
        }  else if ([self.cityTextField.text isEqualToString:@""] || [self.countryTextField.text isEqualToString:@""] || [self.captionTextBox.text isEqualToString:@""] || [self.moodTextField.text isEqualToString:@""]) {
            self.doneButton.enabled = NO;
            self.isValid = NO;
        } else if ([self.cityTextField.text isEqualToString:@""] || [self.countryTextField.text isEqualToString:@""] || [self.captionTextBox.text isEqualToString:@""] || ![self.moods containsObject:self.moodTextField.text]) {
            self.doneButton.enabled = NO;
            self.isValid = NO;
        }else {
            self.doneButton.enabled = NO;
        }
    }
}

- (IBAction)countryEditingDidEnd:(id)sender {
    NSString *address = [NSString stringWithFormat:@"%@,%@",self.cityTextField.text,self.countryTextField.text];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
            [self presentInvalidLocationAlert];
            return;
        }
        else if ([self.cityTextField.text isEqualToString:@""] && ![self.countryTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && ![self.moodTextField.text isEqualToString:@""])
        {
            self.doneButton.enabled = NO;
          self.isValid = NO;
            [self presentInvalidCityAlert];
        }
        else if ([self.countryTextField.text isEqualToString:@""] && ![self.cityTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && ![self.moodTextField.text isEqualToString:@""])
        {
            self.doneButton.enabled = NO;
          self.isValid = NO;
            [self presentInvalidCountryAlert];
        }
        else if ([self.cityTextField.text isEqualToString:@""] && [self.countryTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && ![self.moodTextField.text isEqualToString:@""])
        {
            self.doneButton.enabled = NO;
          self.isValid = NO;
            [self presentInvalidLocationAlert];
        }
        else if (![self.cityTextField.text isEqualToString:@""] && ![self.countryTextField.text isEqualToString:@""] && [self.captionTextBox.text isEqualToString:@""] && ![self.moodTextField.text isEqualToString:@""])
        {
          self.doneButton.enabled = NO;
          self.isValid = NO;
          [self presentInvalidCaptionAlert];
        }
        else if (![self.cityTextField.text isEqualToString:@""] && ![self.countryTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && [self.moodTextField.text isEqualToString:@""]) {
          self.doneButton.enabled = NO;
          self.isValid = NO;
          [self presentInvalidMoodAlert];
        }
        else if (![self.cityTextField.text isEqualToString:@""] && ![self.countryTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && ![self.moods containsObject:self.moodTextField.text])
        {
            self.doneButton.enabled = NO;
            [self presentInvalidMoodAlert];
        
        }
        else if ([self.cityTextField.text isEqualToString:@""] || [self.countryTextField.text isEqualToString:@""] || [self.captionTextBox.text isEqualToString:@""] || [self.moodTextField.text isEqualToString:@""])
        {
          self.doneButton.enabled = NO;
          self.isValid = NO;
          [self presentMissingFieldAlert];
        }
        
        if ([placemarks count] > 0 ) {
            CLPlacemark *placemark = [placemarks lastObject];
            NSLog(@"Location is: %@", placemark.location);
            PFGeoPoint *newGeopPoint = [PFGeoPoint geoPointWithLocation:placemark.location];
            NSMutableDictionary *dictionary = [@{@"location":placemark.location, @"date":[NSDate date]}mutableCopy];
            [LocationData getCityAndDateFromDictionary:dictionary withCompletion:^(NSString *city, NSString *country, NSDate *date, BOOL success) {
                self.location = [[Location alloc]initWithCity:city country:country geoPoint:newGeopPoint dateTaken:date];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^
                 {
                     self.cityTextField.text = city;
                     self.countryTextField.text = country;
                 }];
            }];
        }
    }];
}

/**
 *  When user done selecting the image
 *
 *  @param sender UINavigation right bar Done button.
 */
- (IBAction)textDidEndEditing:(id)sender {
    [self checkIfEverythingValid:sender];
}

-(void)checkIfEverythingValid:(UITextField *)currentTextField
{
  NSString *address = [NSString stringWithFormat:@"%@,%@",self.cityTextField.text,self.countryTextField.text];
  CLGeocoder *geocoder = [[CLGeocoder alloc]init];
  [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
    self.isValid = YES;
    if (error) {
      NSLog(@"Error: %@", [error localizedDescription]);
        if ([currentTextField isEqual: self.countryTextField]) {
            SCLAlertView *alert = [SCLAlertView new];
            [alert showError:self title:@"Invalid Location!" subTitle:@"The city and country combination is incorrect" closeButtonTitle:@"Okay" duration:0];
        }
      self.doneButton.enabled = NO;
      return;
    } else if ([self.cityTextField.text isEqualToString:@""] && ![self.countryTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && ![self.moodTextField.text isEqualToString:@""]) {
      self.doneButton.enabled = NO;
      self.isValid = NO;
    } else if ([self.countryTextField.text isEqualToString:@""] && ![self.cityTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && ![self.moodTextField.text isEqualToString:@""]) {
      self.doneButton.enabled = NO;
      self.isValid = NO;
    } else if ([self.cityTextField.text isEqualToString:@""] && [self.countryTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && ![self.moodTextField.text isEqualToString:@""]) {
      self.doneButton.enabled = NO;
      self.isValid = NO;

    } else if (![self.cityTextField.text isEqualToString:@""] && ![self.countryTextField.text isEqualToString:@""] && [self.captionTextBox.text isEqualToString:@""] && ![self.moodTextField.text isEqualToString:@""]) {
      self.doneButton.enabled = NO;
      self.isValid = NO;
    }  else if (![self.cityTextField.text isEqualToString:@""] && ![self.countryTextField.text isEqualToString:@""] && ![self.captionTextBox.text isEqualToString:@""] && [self.moodTextField.text isEqualToString:@""]) {
      self.doneButton.enabled = NO;
      self.isValid = NO;
    }  else if ([self.cityTextField.text isEqualToString:@""] || [self.countryTextField.text isEqualToString:@""] || [self.captionTextBox.text isEqualToString:@""] || [self.moodTextField.text isEqualToString:@""]) {
      self.doneButton.enabled = NO;
      self.isValid = NO;
    } else if ([self.cityTextField.text isEqualToString:@""] || [self.countryTextField.text isEqualToString:@""] || [self.captionTextBox.text isEqualToString:@""] || ![self.moods containsObject:self.moodTextField.text]) {
      self.doneButton.enabled = NO;
      self.isValid = NO;
    } else {
      self.doneButton.enabled = NO;
    }
  
  if ([placemarks count] > 0 && self.isValid) {
    CLPlacemark *placemark = [placemarks lastObject];
    NSLog(@"Location is: %@", placemark.location);
    PFGeoPoint *newGeopPoint = [PFGeoPoint geoPointWithLocation:placemark.location];
    NSMutableDictionary *dictionary = [@{@"location":placemark.location, @"date":[NSDate date]}mutableCopy];
    [LocationData getCityAndDateFromDictionary:dictionary withCompletion:^(NSString *city, NSString *country, NSDate *date, BOOL success) {
      self.location = [[Location alloc]initWithCity:city country:country geoPoint:newGeopPoint dateTaken:date];
      [[NSOperationQueue mainQueue] addOperationWithBlock:^
       {
         self.cityTextField.text = city;
         self.countryTextField.text = country;
         self.doneButton.enabled = YES;
       }];
    }];
  }
}];
}



- (IBAction)finishedImageSelect:(id)sender {
    ImagesViewController *imageVC = [DataStore sharedDataStore].controllers[0];
    if (imageVC.isConnected == -1) {
        SCLAlertView *disconnectionAlert = [[SCLAlertView alloc] initWithNewWindow];
        [disconnectionAlert showError:@"Network Failure" subTitle:@"Sorry you have disconnected from the internet." closeButtonTitle:@"Okay" duration:0];
    }else{
        
        NSLog(@"done");
        UIImage *image = self.selectedImage;
        NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
        NSLog(@"filename: %@", fileName);
        
        [self resignFirstResponder];
        //For creating image object for Parse
        
        self.parseImageObject = [[ImageObject alloc] initWithTitle:self.captionTextBox.text imageID:fileName mood:self.moodTextField.text location:self.location];
        [self.dataStore uploadImageWithImageObject:self.parseImageObject WithCompletion:^(BOOL complete) {
            if (complete) {
                NSLog(@"Parse upload completed!");

                NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"upload-image.tmp"];
                NSLog(@"filepath %@", filePath);
                
                NSData * imageData = UIImagePNGRepresentation(image);
                
                [imageData writeToFile:filePath atomically:YES];
                
                AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
                uploadRequest.body = [NSURL fileURLWithPath:filePath];
                uploadRequest.key = fileName;
                uploadRequest.contentType = @"image/png";
                //          [uploadRequest setValue:@"image/png" forKey:@"Content-Type"];
                NSLog(@"poolID: %@",POOL_ID);
                uploadRequest.bucket = @"fissamplebucket";
                NSLog(@"uploadRequest: %@", uploadRequest);
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                }];
                [self uploadThumbnail:image fileName:fileName];
                
                [DataStore uploadPictureToAWS:uploadRequest WithCompletion:^(BOOL complete) {
                    NSLog(@"upload completed!");
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }];
            }else{
                NSLog(@"Issue with upload");
            }
        }];
    }
}

-(void)uploadThumbnail:(UIImage *)image fileName:(NSString *)fileName{
    UIImage *originalImage = image;
  
    fileName = [NSString stringWithFormat:@"thumbnail%@", fileName];
  
    CGFloat ratio = originalImage.size.height / originalImage.size.width;
    CGSize destinationSize;
    if (originalImage.size.width <= originalImage.size.height) {
        destinationSize = CGSizeMake(300, 300*ratio);
    }else{
        destinationSize = CGSizeMake(300 / ratio, 300);
    }
    
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Upload thumbnail image to Amazon

    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"upload-thumbnail.tmp"];
  
    NSData * imageData = UIImagePNGRepresentation(newImage);
    
    [imageData writeToFile:filePath atomically:YES];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    uploadRequest.key = fileName;
    uploadRequest.contentType = @"image/png";
    uploadRequest.bucket = @"fissamplebucket";
  
    [DataStore uploadPictureToAWS:uploadRequest WithCompletion:^(BOOL complete) {
        NSLog(@"Thumbnail upload completed!");
    }];
}


- (IBAction)cancelImageSelect:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

//AutoFill to encourage user types in OUR Moods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
@end
