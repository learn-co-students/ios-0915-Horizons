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

@interface ImageUploadViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageHolderView;
@property (nonatomic, strong) UIAlertController *sourcePicker;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic) BOOL firstTime;
@property (nonatomic, strong)NSMutableArray *countriesArray;
@property (nonatomic, strong)UITableView *autocompleteTableView;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (nonatomic, strong)NSMutableArray *autocompleteCountries;


@end

@implementation ImageUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Initiating the image picker controller.
    self.imagePickerController = [UIImagePickerController new];
    UIImage *placeholder = [UIImage imageNamed:@"cloud"];
    self.imageHolderView.image = placeholder;
    
    self.firstTime = YES;
  
  
  self.countriesArray = [[NSMutableArray alloc]init];
  NSString *filePath = [[NSBundle mainBundle]pathForResource:@"countryList" ofType:@"txt"];
  NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
  NSLog(@"filePath: %@", filePath);
  NSLog(@"filecontents: %@", fileContents);
  for (NSString *line  in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
    [self.countriesArray addObject:line];
  }
  NSLog(@"array: %@", self.countriesArray);
  
  
//  self.autocompleteTableView = [[UITableView alloc] initWithFrame:
//                           CGRectMake(0, 80, 320, 120) style:UITableViewStylePlain];
//  self.autocompleteTableView.delegate = self;
//  self.autocompleteTableView.dataSource = self;
//  self.autocompleteTableView.scrollEnabled = YES;
//  self.autocompleteTableView.hidden = NO;
//  [self.view addSubview:self.autocompleteTableView];
//  self.autocompleteCountries = [[NSMutableArray alloc]init];

}



-(void)viewDidAppear:(BOOL)animated{
  
  if (self.firstTime) {
        self.firstTime = NO;
      [self imageUpLoadSource];
  
    }
}

-(void)checkIfCountryIsValid
{
  NSString *countryInput = self.countryTextField.text;
  NSString *countryNoSpaces = [countryInput stringByReplacingOccurrencesOfString:@" " withString:@""];
  NSString *lowercase = [countryNoSpaces lowercaseString];
  NSUInteger i = 0;
  NSLog(@"lowercase: %@", lowercase);
  for (NSString *country in self.countriesArray) {
    NSString *validNoSpaces = [country stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *validLowercase = [validNoSpaces lowercaseString];
    if ([lowercase isEqualToString:validLowercase]) {
      i = i + 1;
    }
  }
    NSLog(@"i: %lu",i);
    
    if (i != 1) {
      UIAlertController *invalidLocation = [UIAlertController alertControllerWithTitle:@"Location Is Invalid" message:@"Please enter a valid location" preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
      [invalidLocation addAction:ok];
      [self presentViewController:invalidLocation animated:YES completion:^{
        self.countryTextField.text = @"";
      }];
    }
}
- (IBAction)countryEditingDidEnd:(id)sender {
  [self checkIfCountryIsValid];
}

/**
 *  If user want to change the selected image.
 *
 *  @param sender One tap gesture on the image view holder itself.
 */
- (IBAction)selectImageAndView:(id)sender {
    //Calling the UIAlertController when screen loaded.
    [self imageUpLoadSource];
}

/**
 *  When user done selecting the image
 *
 *  @param sender UINavigation right bar Done button.
 */
- (IBAction)finishedImageSelect:(id)sender {
//  [self dismissViewControllerAnimated:YES completion:^{
//    NSLog(@"done");
//  }];
  NSLog(@"done");
  UIImage *image = self.selectedImage;
  NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
  NSLog(@"filename: %@", fileName);
  

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
  
  [DataStore uploadPictureToAWS:uploadRequest WithCompletion:^(BOOL complete) {
    NSLog(@"upload completed!");
    [self dismissViewControllerAnimated:YES completion:nil];
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
- (IBAction)didEditCountryTextField:(id)sender {

}

//AUTOCOMPLETE CODE NOT QUITE WORKING

//- (BOOL)textField:(UITextField *)textField
//shouldChangeCharactersInRange:(NSRange)range
//replacementString:(NSString *)string {
//  self.autocompleteTableView.hidden = NO;
//  
//  NSString *substring = [NSString stringWithString:textField.text];
//  substring = [substring
//               stringByReplacingCharactersInRange:range withString:string];
//  [self searchAutocompleteEntriesWithSubstring:substring];
//  
//  NSLog(@"should change characters in range");
//  return YES;
//}
//
//- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
//  NSMutableArray *autocompleteCountries = [[NSMutableArray alloc]init];
//  // Put anything that starts with this substring into the autocompleteUrls array
//  // The items in this array is what will show up in the table view
//  [autocompleteCountries removeAllObjects];
//  for(NSString *curString in self.countriesArray) {
//    NSRange substringRange = [curString rangeOfString:substring];
//    if (substringRange.location == 0) {
//      [autocompleteCountries addObject:curString];
//    }
//  }
//  [self.autocompleteTableView reloadData];
//  NSLog(@"search autocomplete entries");
//
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
//  NSLog(@"table view count: %lu", self.autocompleteCountries.count);
//  NSLog(@"auto countries: %@", self.autocompleteCountries);
//  return self.autocompleteCountries.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//  
//  UITableViewCell *cell = nil;
//  static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
//  cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
//  if (cell == nil) {
//    cell = [[UITableViewCell alloc]
//             initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier] ;
//  }
//  
//  cell.textLabel.text = [self.autocompleteCountries objectAtIndex:indexPath.row];
//  return cell;
//}
//
//#pragma mark UITableViewDelegate methods
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  
//  UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//  self.countryTextField.text = selectedCell.textLabel.text;
//}



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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //The selected image
    self.selectedImage = info[UIImagePickerControllerOriginalImage];
    
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
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        if (!features.count) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.imageHolderView.image = self.selectedImage;
                [picker dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
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
