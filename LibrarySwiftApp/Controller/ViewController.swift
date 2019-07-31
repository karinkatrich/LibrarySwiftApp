//
//  ViewController.swift
//  LibrarySwiftApp
//
//  Created by karyna on 7/29/19.
//  Copyright © 2019 karyna.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var books = [Book]()
    let decoder = JSONDecoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
    }

    func downloadJson() {
        let url = NSURL(string: "http://localhost:8080/books")
        let login = "user"
        let password = "password"

        let request = NSMutableURLRequest(url: url! as URL)

        let config = URLSessionConfiguration.default
        let userPasswordString = "\(login):\(password)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString()
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]

        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data, error == nil, response != nil else {
                print("something is wrong")
                return
            }
            print("downloaded")
            do
            {
                self.books = try! self.decoder.decode([Book].self, from: data)
                print(self.books)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("something wrong after downloaded")
            }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell") as? BookCell else { return UITableViewCell() }

        let book = books[indexPath.row]
        let stringId = "\(String(describing: book.id))"
        let stringYear = "\(String(describing: book.bookYear))"

        cell.idLabel?.text = stringId
        cell.titleLabel?.text = book.bookTitle
        cell.yearLabel?.text = stringYear

        return cell
    }
}

