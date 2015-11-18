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

@interface ImageUploadViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageHolderView;
@property (nonatomic, strong) UIAlertController *sourcePicker;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic) BOOL firstTime;

@end

@implementation ImageUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self imageUpLoadSource];
    
//    UIViewController *imageVC = [UIViewController new];
//    
//    CGFloat imageOriginalWidth = self.selectedImage.size.width;
//    CGFloat imageOriginalHeight = self.selectedImage.size.height;
//    CGFloat ratio = imageOriginalHeight/imageOriginalWidth;
//    
//    CGFloat width = imageOriginalWidth;
//    if (imageOriginalWidth > 1000) {
//        width = 1000;
//    }
//    CGFloat height = width * ratio;
//    
//    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1200, 1200)];
//    scroll.contentSize = CGSizeMake(500, 500);
//    
//    scroll.showsVerticalScrollIndicator = YES;
//    scroll.showsHorizontalScrollIndicator = YES;
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
//    imageView.image = self.selectedImage;
//    
//    
//    
//    [scroll addSubview:imageView];
//    [imageVC setView:scroll];
    
//    [self presentViewController:imageVC animated:YES completion:nil];
}

/**
 *  When user done selecting the image
 *
 *  @param sender UINavigation right bar Done button.
 */
- (IBAction)finishedImageSelect:(id)sender {
  [self dismissViewControllerAnimated:YES completion:^{
    NSLog(@"done");
  }];
  NSLog(@"done");
  UIImage *image = self.selectedImage;
  NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
//  NSLog(@"filename: %@", fileName);

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
  
  [self upload:uploadRequest];
//    [self dismissViewControllerAnimated:YES completion:nil];
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
        
//        if ([UIImagePickerController isSourceTypeAvailable:
//             UIImagePickerControllerSourceTypeCamera]) {
//            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        }
        
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

-(void)pickImageToUpload
{
  
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
    
    //Displaying the selected image in the image view holder.
    self.imageHolderView.image = self.selectedImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
