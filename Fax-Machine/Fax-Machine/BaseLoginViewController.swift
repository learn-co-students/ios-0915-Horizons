//
//  BaseLoginViewController.swift
//  Fax-Machine
//
//  Created by Claire Davis on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

import UIKit

class BaseLoginViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    
    
    if (PFUser.currentUser() == nil) {
      let loginViewController = LoginViewController()
      loginViewController.delegate = self
      loginViewController.fields = [.UsernameAndPassword, .LogInButton, .PasswordForgotten, .SignUpButton, .Facebook, .Twitter]
      loginViewController.emailAsUsername = true
      loginViewController.signUpController?.delegate = self
      loginViewController.emailAsUsername = true
      loginViewController.signUpController?.emailAsUsername = true
      loginViewController.signUpController?.delegate = self
      self.presentViewController(loginViewController, animated: false, completion: nil)
    } else {
      self.dismissViewControllerAnimated(true, completion:nil)
      self.performSegueWithIdentifier("imageUploadSegue", sender: self)

    }
    
  }
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  


}
