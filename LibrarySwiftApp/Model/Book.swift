//
//  Book.swift
//  LibrarySwiftApp
//
//  Created by karyna on 7/29/19.
//  Copyright © 2019 karyna.com. All rights reserved.
//

import UIKit

class Book: Decodable {
    var id: Int
    var bookTitle: String?
    var bookYear: Int

    init(id: Int, bookTitle: String?, bookYear: Int) {
        self.id = id
        self.bookTitle = bookTitle
        self.bookYear = bookYear

    }

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case bookTitle = "title"
        case bookYear = "year"
    }
}
