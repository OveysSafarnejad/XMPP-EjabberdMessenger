//
//  MessageCell.swift
//  AviationMessenger
//
//  Created by Safarnejad on 11/20/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageTextContent: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell (message : Message) {
//        var calendar = NSCalendar.current
//        let hour = calendar.component(.hour, from: message.messageDate as Date)
//        let minutes = calendar.component(.minute, from: message.messageDate as Date)
//        let seconds = calendar.component(.second, from: message.messageDate as Date)
//
        messageTextContent.text = message.messageText
        //messageTime.text =
    }

}
