//
//  TableViewCell.swift
//  LibrarySwiftApp
//
//  Created by karyna on 7/29/19.
//  Copyright © 2019 karyna.com. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
