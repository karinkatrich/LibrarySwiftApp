//
//  SignInViewController.swift
//  LibrarySwiftApp
//
//  Created by karyna on 7/29/19.
//  Copyright © 2019 karyna.com. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SignInViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!

    @IBOutlet weak var userPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("Sign in")

        let userName = userNameTextField.text
        let userPassword = userPasswordTextField.text

        if (userName?.isEmpty)! || (userPassword?.isEmpty)! {

            //Display alert
            print("User name \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
            displayMessage(userMessage: "One of the required fields is missing")
            return
        }


        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.stopAnimating()
        view.addSubview(myActivityIndicator)

        let myUrl = URL(string: "http://localhost:8080/books/authentication")
        var request = URLRequest(url: myUrl!)

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let postString = ["userName": userName!, "userPassword": userPassword!] as [String: String]

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
                    let accessToken = parseJSON["token"] as? String
                    let userId = parseJSON["id"] as? String
                    print("AccessToken:\(String(describing: accessToken!))")

                    let saveAccessToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "myKey")
                    let saveUserId: Bool = KeychainWrapper.standard.set(userId!, forKey: "myKey")

                    print("The access token save result: \(saveAccessToken)")
                    print("The user id \(saveUserId)")

                    if (accessToken?.isEmpty)!
                    {
                        self.displayMessage(userMessage: "Could not successfully perform the request. Please try again later")
                    }

                    DispatchQueue.main.async {
                        let homePage = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = homePage
                    }
                }
            } catch {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.displayMessage(userMessage: "Could not successfully perform")
                print(error)
            }
        }

        task.resume()
        
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        print("Register")

        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterUserViewController") as! RegisterUserViewController

        self.present(registerViewController, animated: true)
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

    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }

}
