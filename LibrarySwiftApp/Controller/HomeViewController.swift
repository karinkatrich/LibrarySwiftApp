//
//  HomeViewController.swift
//  LibrarySwiftApp
//
//  Created by karyna on 7/30/19.
//  Copyright © 2019 karyna.com. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var userFullNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func signOutButtonTapped(_ sender: Any) {
        print("sign out")
    }

    @IBAction func loadMemberProfileButtonTapped(_ sender: Any) {
        print("load")
    }

}
