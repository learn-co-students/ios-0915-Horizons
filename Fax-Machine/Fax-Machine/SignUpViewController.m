//
//  SignUpViewController.m
//  Pods
//
//  Created by Claire Davis on 11/19/15.
//
//

#import "SignUpViewController.h"

@implementation SignUpViewController

-(void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mountains_hd"]]];
//  [self.signUpView.dismissButton removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
//  [self.signUpView.dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
  
  
}

-(void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  
  
}


//-(void)dismiss
//{
//  [self dismissViewControllerAnimated:YES completion:nil];
//}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
