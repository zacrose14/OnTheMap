//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Zachary Rose on 11/29/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
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
    }
    
    // MARK: Login Action
    @IBAction func loginPressed(_ sender: Any) {
        
        // Check to make sure fields aren't emply
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.showAlert("Username or Password Empty")
        } else {
            UdacityClient.sharedInstance().authenticateUser(emailTextField.text!, password: passwordTextField.text!) { (success, error) in
                performUIUpdatesOnMain {
                    if success {
                        
                        // Success sends to MapVC
                        self.activityIndicator.startAnimating()
                        
                        self.performSegue(withIdentifier: "loginSuccessSegue", sender: (Any).self)
                    } else {
                        // Otherwise, display error here
                        self.displayError(error?.localizedDescription)
                    }
                    
                }
            }
 
        }
    }
    
    // MARK: Signup Action
    @IBAction func signUpPressed(_ sender: Any) {
        
        // Open Udacity SignUp URL
        UIApplication.shared.openURL(URL(string: UdacityClient.Constants.SignupPath)!)
    }
    
    // MARK: Keyboard Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Error Functions and Alerts
    func displayError(_ errorString: String?) {
        
        self.activityIndicator.stopAnimating()
        if let errorString = errorString {
            self.showAlert(errorString)
        }
    }
    
    func showAlert(_ errorMessage: String?) {
        
        let alertController = UIAlertController(title: nil, message: errorMessage!, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) {(action) in
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true){
        }
        
    }
}
