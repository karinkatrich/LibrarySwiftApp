//
//  HomeViewController.swift
//  LibrarySwiftApp
//
//  Created by karyna on 7/30/19.
//  Copyright © 2019 karyna.com. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class HomeViewController: UIViewController {

    @IBOutlet weak var userFullNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func signOutButtonTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "userId")

        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
    }

    @IBAction func loadMemberProfileButtonTapped(_ sender: Any) {

    }

    func loadMemberProfile() {

        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let userId: String? = KeychainWrapper.standard.string(forKey: "userId")

        let myUrl = URL(string: "http://localhost:8080/books/users/\(userId!)")
        var request = URLRequest(url: myUrl!)

        request.httpMethod = "GET"
        request.addValue("Bearer\(accessToken!)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

            if error != nil {
                self.displayMessage(userMessage: "Could not successfully perform the request. Please try again later")
                print("error =\(String(describing: error))")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                if let parseJSON = json {
                    
                    DispatchQueue.main.async {
                    let firstName: String? = parseJSON["firstName"] as? String
                    let lastName: String? = parseJSON["lastName"] as? String

                    if firstName?.isEmpty != true && lastName?.isEmpty != true {
                        self.userFullNameLabel.text = firstName! + " " + lastName!
                    }
                }
            }

        } catch {
            self.displayMessage(userMessage: "Could not successfully perform")
            print(error)
        }

    }

    task.resume()
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
