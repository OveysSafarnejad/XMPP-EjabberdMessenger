//
//  Message.swift
//  AviationMessenger
//
//  Created by Safarnejad on 11/4/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import Foundation
import UIKit


class Message {
    
    enum Sender : String {
        case MessageSenderMyself = "Myself"
        case MessageSenderSomeone = "Someone"
    }
    
    enum MessageStatus : String {
        case MessageStatusSending = "Sending"
        case MessageStatusSent = "Sent"
        case MessageStatusReceived = "Received"
        case MessageStatusRead = "Read"
        case MessageStatusFailed = "Failed"
    }
    
    var messageSender : Sender!
    var messageStatus : MessageStatus!
    var messageIdentifier : String!
    var messageText : String!
    var messageDate : NSDate!
    
    init(sender : Sender , status : MessageStatus , identifier : String , text : String , date :NSDate ) {
        self.messageSender = sender
        self.messageStatus = status
        self.messageIdentifier = identifier
        self.messageText = text
        self.messageDate = date
    }
    
}
