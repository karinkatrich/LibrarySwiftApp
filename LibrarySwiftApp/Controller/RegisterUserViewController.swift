//
//  RegisterUserViewController.swift
//  LibrarySwiftApp
//
//  Created by karyna on 7/30/19.
//  Copyright © 2019 karyna.com. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!

    @IBOutlet weak var lastNameTextField: UITextField!

    @IBOutlet weak var emailAdressTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var repeatPasswordTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("Cancel")
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func signupButtonTapped(_ sender: Any) {
        print("sign up")

        //Validation

        if(firstNameTextField.text?.isEmpty)! || (lastNameTextField.text?.isEmpty)! || (emailAdressTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!
        {
            displayMessage(userMessage: "All fields are required to fill in")
            return
        }

        if ((passwordTextField.text?.elementsEqual(repeatPasswordTextField.text!))! != true )
        {
            displayMessage(userMessage: "Please make sure that passwords match")
            return
        }

        //Activity indicator

        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.stopAnimating()
        view.addSubview(myActivityIndicator)

        //request

        let myUrl = URL(string: "http://localhost:8080/books")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let postString = ["firstName": firstNameTextField.text!,
                          "lastName": lastNameTextField.text!,
                          "userName": emailAdressTextField.text!,
        "userPassword":passwordTextField.text!] as [String: String]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

        self.removeActivityIndicator(activityIndicator: myActivityIndicator)

            if error != nil {
                self.displayMessage(userMessage: "Could not successfully perform the request. Please try again later")
                print("error =\(String(describing: error))")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                if let parseJSON = json {
                    let userId = parseJSON["userId"] as? String
                    print("User id: \(String(describing: userId!))")

                    if (userId?.isEmpty)! {
                        self.displayMessage(userMessage: "Could not successfully perform")
                        return
                    } else {
                        self.displayMessage(userMessage: "Successe")
                    }
                } else {
                    self.displayMessage(userMessage: "Could not successfully perform")
                }
            } catch {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.displayMessage(userMessage: "Could not successfully perform")
                print(error)
            }
        }
    }


    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }

    func displayMessage(userMessage: String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            let okAktion = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                print("Ok tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(okAktion)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
