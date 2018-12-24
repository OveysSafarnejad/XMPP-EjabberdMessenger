//
//  Contact.swift
//  AviationMessenger
//
//  Created by Safarnejad on 11/11/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import Foundation

class Contact {
    
    var fullName : String!
    var imageURL : NSURL!
    var identifier : String!
    
    init( _ name : String , _ image : NSURL , _ id : String) {
        
        self.identifier = id
        self.fullName = name
        self.imageURL = image
    }
}
