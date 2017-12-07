//
//  AddStudentLocationVC.swift
//  OnTheMap
//
//  Created by Zachary Rose on 12/1/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit

class AddStudentLocationVC: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func findLocationPressed(_ sender: Any) {
        // Auto find location using iphone GPS (if equipped and authorized by user), allow manual entry otherwise.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
