//
//  roomCell.swift
//  HiChat
//
//  Created by Ahmed Nasr on 1/10/21.
//  Copyright © 2021 Ahmed Nasr. All rights reserved.
//
import UIKit

class roomCell: UITableViewCell {

    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomOwnerLabel: UILabel!
    @IBOutlet weak var roomStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
