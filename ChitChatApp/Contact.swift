//
//  Contact.swift
//  ChitChatApp
//
//  Created by deore123 on 6/9/17.
//  Copyright © 2017 deore123. All rights reserved.
//

import Foundation

class Contact
{
    private var _name = "";
    private var _id = "";
    
    
    init(id: String, name: String)
    {
        _id = id;
        _name = name;
    }
    var name: String
    {
        get {
            
            return _name;
        }
    }
    
    var id : String
    {
         return _id;
   
    }
    
    
    
    
}// class


































































