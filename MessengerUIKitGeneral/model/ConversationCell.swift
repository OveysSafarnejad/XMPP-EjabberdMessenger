//
//  ConversationCell.swift
//  AviationMessenger
//
//  Created by Safarnejad on 11/11/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var lastMessageText : UILabel!
    @IBOutlet weak var numberOfUnreadMessagesLabel: UILabel!
    @IBOutlet weak var LastSeenLabel: UILabel!
    
    var profiles = ["https://images.pexels.com/photos/36753/flower-purple-lical-blosso.jpg",
                    "https://c.pxhere.com/photos/a0/ff/smoking_cigarette_lung_cancer_unhealthy_smoke_tobacco_cigar_smoking_ban-1158201.jpg!d"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.width/1.75
        profileImage.layer.masksToBounds = true
        numberOfUnreadMessagesLabel.layer.cornerRadius = numberOfUnreadMessagesLabel.frame.width/2
        numberOfUnreadMessagesLabel.layer.masksToBounds = true
    }
    
    func configureCell (chat:Chat) {
        let image : UIImage!
    
        if let data = NSData(contentsOf: chat.contact.imageURL as URL){
            image = UIImage(data: data as Data)
        } else {
            image = UIImage(named: "user")
        }
        
        profileImage.image = image
        nameLabel.text = chat.contact.fullName
        lastMessageText.text = chat.lastMessage.messageText
        numberOfUnreadMessagesLabel.text = String(chat.numberOfUnread)
        
    }

}
