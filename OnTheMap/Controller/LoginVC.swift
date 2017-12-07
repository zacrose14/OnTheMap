//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Zachary Rose on 11/29/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    
    var session: URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        session = URLSession.shared
    }
    @IBAction func loginPressed(_ sender: Any) {
        
        // Check to make sure fields aren't emply
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            print("Fill in all fields!")
            let uiAlertController = UIAlertController(title: "Username or Password Missing", message: nil, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            uiAlertController.addAction(action)
            self.present(uiAlertController, animated: true, completion: nil)
        } else {
            UdacityClient.sharedInstance().authenticateUser(emailTextField.text!, password: passwordTextField.text!) { (success, error) in
                performUIUpdatesOnMain {
                    if success {
                        self.performSegue(withIdentifier: "loginSuccessSegue", sender: (Any).self)
                    } else {
                        print(error)
                    }
                    
                }
            }
 
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        // Open Udacity SignUp URL
        print("Sign up pressed")
        UIApplication.shared.openURL(URL(string: UdacityClient.Constants.SignupPath)!)
    }
    
    
}
