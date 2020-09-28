//
//  ChatCell.swift
//  HiChat
//
//  Created by Ahmed Nasr on 9/28/20.
//  Copyright © 2020 Ahmed Nasr. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var senderMessegeLbl: UILabel!
    
    @IBOutlet weak var messgeTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
