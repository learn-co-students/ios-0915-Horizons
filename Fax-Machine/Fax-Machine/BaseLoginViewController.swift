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
//      loginViewController.fields = .UsernameAndPassword | .LogInButton | .PasswordForgotten | .SignUpButton | .Facebook | .Twitter
      loginViewController.emailAsUsername = true
      loginViewController.signUpController?.delegate = self
      loginViewController.emailAsUsername = true
      loginViewController.signUpController?.emailAsUsername = true
      loginViewController.signUpController?.delegate = self
      self.presentViewController(loginViewController, animated: false, completion: nil)
    } else {
      let alertController = UIAlertController(title: "You're logged in", message: "Welcome to ourApp!", preferredStyle: .Alert)
      let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        self.dismissViewControllerAnimated(true, completion:nil)
        self.performSegueWithIdentifier("imageUploadSegue", sender: self)

      }
      alertController.addAction(OKAction)
      self.presentViewController(alertController, animated: true, completion: nil)
      self.performSegueWithIdentifier("imageUploadSegue", sender: self)

    }
    
  }
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
      self.dismissViewControllerAnimated(true, completion: nil)
      presentLoggedInAlert()
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
      self.dismissViewControllerAnimated(true, completion: nil)
      presentLoggedInAlert()
    }
    
    func presentLoggedInAlert() {
      let alertController = UIAlertController(title: "You're logged in", message: "Welcome to ourApp!", preferredStyle: .Alert)
      let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        self.dismissViewControllerAnimated(true, completion:nil)
        self.performSegueWithIdentifier("imageUploadSegue", sender: self)

      }
      alertController.addAction(OKAction)
    }
  
//  override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//    if (segue.identifier == "Load View") {
//      // pass data to next view
//    }
//  }
  
//    let loginViewController = LoginViewController()

//
//    let viewControllerForLogin = LoginViewController()
//    presentViewController(viewControllerForLogin, animated:true , completion: nil)
    

//    if (PFUser.currentUser() == nil) {
//      let loginViewController = LoginViewController()
//    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
