//
//  SignInViewController.swift
//  LibrarySwiftApp
//
//  Created by karyna on 7/29/19.
//  Copyright © 2019 karyna.com. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!

    @IBOutlet weak var userProfileTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("Sign in")
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        print("Register")

        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterUserViewController") as! RegisterUserViewController

        self.present(registerViewController, animated: true)
    }
}
