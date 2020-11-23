//
//  ChatCell.swift
//  HiChat
//
//  Created by Ahmed Nasr on 9/28/20.
//  Copyright © 2020 Ahmed Nasr. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    enum bubbelType {
        case incoming
        case outgoing
    }
    
    @IBOutlet weak var senderMessegeLbl: UILabel!
    @IBOutlet weak var messgeTextView: UITextView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var View: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        View.layer.cornerRadius = 6
    }
    func bubbleType(type: bubbelType){
        if type == .incoming {
            stackView.alignment = .leading
            View.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            messgeTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else if type == .outgoing{
            stackView.alignment = .trailing
            View.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            messgeTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
