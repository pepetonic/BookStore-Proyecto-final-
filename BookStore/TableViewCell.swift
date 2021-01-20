//
//  TableViewCell.swift
//  BookStore
//
//  Created by Mac5 on 19/01/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imgImageView: UIImageView!
    @IBOutlet weak var autorLabel: UILabel!
    
    @IBOutlet weak var libroLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
