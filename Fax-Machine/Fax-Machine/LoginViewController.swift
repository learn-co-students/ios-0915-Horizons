//
//  LoginViewController.swift
//  Fax-Machine
//
//  Created by Claire Davis on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

import UIKit


class LoginViewController : PFLogInViewController {
  
  var viewsToAnimate: [UIView!]!;
  var viewsFinalYPosition : [CGFloat]!;

  var backgroundImage : UIImageView!;
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set our custom background image
    backgroundImage = UIImageView(image: UIImage(named: "mountains_hd"))
    backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
    self.logInView!.insertSubview(backgroundImage, atIndex: 0)
    
    
    
    let logo = UILabel()
    logo.text = "Horizons"
    logo.textColor = UIColor.whiteColor()
    logo.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 70)
    logo.shadowColor = UIColor.lightGrayColor()
    logo.shadowOffset = CGSizeMake(2, 2)
    logInView?.logo = logo
    
    logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)

    self.signUpController = SignUpViewController()

//    logInView?.logInButton?.setBackgroundImage(nil, forState: .Normal)
//    logInView?.logInButton?.backgroundColor = UIColor.blueColor()
//    logInView?.signUpButton?.alpha = 0.9
    
    
    
//    customizeButton(logInView?.facebookButton!)
//    customizeButton(logInView?.twitterButton!)
//    customizeButton(logInView?.signUpButton!)
    
    viewsToAnimate = [self.logInView?.usernameField, self.logInView?.passwordField, self.logInView?.logInButton, self.logInView?.passwordForgottenButton, self.logInView?.facebookButton, self.logInView?.twitterButton, self.logInView?.signUpButton, self.logInView?.logo]

  }
  
  func customizeButton(button: UIButton!) {
    button.setBackgroundImage(nil, forState: .Normal)
    button.backgroundColor = UIColor.clearColor()
    button.layer.cornerRadius = 5
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.whiteColor().CGColor
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // stretch background image to fill screen
    backgroundImage.frame = CGRectMake( 0,  0,  self.logInView!.frame.width,  self.logInView!.frame.height)
    logInView!.logo!.sizeToFit()
    let logoFrame = logInView!.logo!.frame
    logInView!.logo!.frame = CGRectMake(logoFrame.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, logInView!.frame.width,  logoFrame.height)
    
//    logInView!.signUpButton?.backgroundColor = UIColor.grayColor();
    
    
    
//    viewsFinalYPosition = [CGFloat]();
//    for viewToAnimate in viewsToAnimate {
//      let currentFrame = viewToAnimate.frame
//      viewsFinalYPosition.append(currentFrame.origin.y)
//      viewToAnimate.frame = CGRectMake(currentFrame.origin.x, self.view.frame.height + currentFrame.origin.y, currentFrame.width, currentFrame.height)
//    }
  }

 
  
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//    
//    // Now we'll animate all our views back into view
//    // and, using the final position we stored, we'll
//    // reset them to where they should be
//    if viewsFinalYPosition.count == self.viewsToAnimate.count {
//      UIView.animateWithDuration(1, delay: 0.0, options: .CurveEaseInOut,  animations: { () -> Void in
//        for viewToAnimate in self.viewsToAnimate {
//          let currentFrame = viewToAnimate.frame
//          viewToAnimate.frame = CGRectMake(currentFrame.origin.x, self.viewsFinalYPosition.removeAtIndex(0), currentFrame.width, currentFrame.height)
//        }
//        }, completion: nil)
//    }
//  }
//  
  
  
  
}



