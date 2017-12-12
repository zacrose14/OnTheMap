//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Zachary Rose on 11/29/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var loginFaceBook: FBSDKLoginButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var session: URLSession!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        session = URLSession.shared
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: Login Action
    @IBAction func loginPressed(_ sender: Any) {
        
        let validEmail = validateEmail(email: emailTextField.text!)
        
        if validEmail == true {
            self.activityIndicator.startAnimating()
            
            UdacityClient.sharedInstance().authenticateUser(emailTextField.text!, password: passwordTextField.text!) { (success, error) in
                
                
                if success {
                    performUIUpdatesOnMain {
                       
                    self.activityIndicator.startAnimating()
                    self.performSegue(withIdentifier: "loginSuccessSegue", sender: (Any).self)
                    }
                    
                } else {
                    self.displayError(error?.localizedDescription)
                }
            }
        } else if validEmail == false {
            displayError("The email you entered was not valid.")
            
        } else if emailTextField.text == "" || passwordTextField.text == "" {
            displayError("Please fill out all fields!")
        }
    }
    
    // Function to validate email
    // Credit: https://stackoverflow.com/questions/27998409/email-phone-validation-in-swift
    func validateEmail(email: String) -> Bool {
        
        var returnValue = false
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count > 0
            {
                returnValue = true
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    // Facebook Login
    func performFBLogin(_ FBToken: String) {
        UdacityClient.sharedInstance().performFacebookLogin(FBToken, completionHandlerFBLogin: {(success, error) in
            if success {
                performUIUpdatesOnMain {
                    self.activityIndicator.startAnimating()
                    self.performSegue(withIdentifier: "loginSuccessSegue", sender: (Any).self)
                }
            } else {
                self.displayError("Unable To Log In With Facebook")
                
            }
            })
    }
    
    // MARK: Signup Action
    @IBAction func signUpPressed(_ sender: Any) {
        
        // Open Udacity SignUp URL
        let url = URL(string: UdacityClient.Constants.SignupPath)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: Keyboard Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true;
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Error Functions and Alerts
    func displayError(_ errorString: String?) {
        performUIUpdatesOnMain {
        self.activityIndicator.stopAnimating()
        if let errorString = errorString {
            self.showAlert(errorString)
            
            }
        }
    }
    
    func showAlert(_ errorMessage: String?) {
        
        let alertController = UIAlertController(title: nil, message: errorMessage!, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) {(action) in
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true){
        }
        
    }
}

// Extension to handle Facebook Login
extension LoginVC: FBSDKLoginButtonDelegate {
    func loginButtonDidLogOut(_ loginFaceBook: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginFaceBook: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            showAlert("Failed to login using facebook")
            return
        }
        
        self.performFBLogin(result.token.tokenString)
    }
}
