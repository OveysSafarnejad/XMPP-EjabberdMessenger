//
//  Chat.swift
//  AviationMessenger
//
//  Created by Safarnejad on 11/4/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import Foundation

class Chat {
    
    var identifier : String!
    var lastMessage : Message!
    var contact : Contact!
    var numberOfUnread : NSInteger!
    
    init(id : String , last : Message , contact : Contact , numberOfUnread : NSInteger) {
        
        self.identifier = id
        self.lastMessage = last
        self.contact = contact
        self.numberOfUnread = numberOfUnread
    }
    
}
