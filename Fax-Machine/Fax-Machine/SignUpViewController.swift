//
//  SignUpViewController.swift
//  Fax-Machine
//
//  Created by Claire Davis on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

import UIKit

class SignUpViewController: PFSignUpViewController {

  var backgroundImage : UIImageView!;
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set our custom background image
    backgroundImage = UIImageView(image: UIImage(named: "mountains_hd"))
    backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
    signUpView!.insertSubview(backgroundImage, atIndex: 0)
    
    // remove the parse Logo
    let logo = UILabel()
    logo.text = "Horizons"
    logo.textColor = UIColor.whiteColor()
    logo.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 70)
    logo.shadowColor = UIColor.lightGrayColor()
    logo.shadowOffset = CGSizeMake(2, 2)
    signUpView?.logo = logo
    
    self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    
    signUpView?.dismissButton!.setTitle("Already signed up?", forState: .Normal)
    signUpView?.dismissButton!.setImage(nil, forState: .Normal)

  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // stretch background image to fill screen
    backgroundImage.frame = CGRectMake( 0,  0,  signUpView!.frame.width,  signUpView!.frame.height)
    
    // position logo at top with larger frame
    signUpView!.logo!.sizeToFit()
    let logoFrame = signUpView!.logo!.frame
    signUpView!.logo!.frame = CGRectMake(logoFrame.origin.x, signUpView!.usernameField!.frame.origin.y - logoFrame.height - 16, signUpView!.frame.width,  logoFrame.height)
    
    let dismissButtonFrame = signUpView!.dismissButton!.frame
    signUpView?.dismissButton!.frame = CGRectMake(0, signUpView!.signUpButton!.frame.origin.y + signUpView!.signUpButton!.frame.height + 16.0,  signUpView!.frame.width,  dismissButtonFrame.height)
  }

}
