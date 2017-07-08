//
//   DBProvider.swift
//  ChitChatApp
//
//  Created by deore123 on 6/8/17.
//  Copyright © 2017 deore123. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol  FetchData : class {
    
    func dataRecieved(contacts: [Contact]);
}
    


class  DBProvider
{
 
    private static let _instance = DBProvider();
    
    weak var delegate: FetchData?;
    
    private init() {}
    
    static var Instance : DBProvider
    {
        return _instance;
    }
    
    
    var dbRef : DatabaseReference
    {
        return Database.database().reference(); // This will return app refrance from firebase database
    }
    
    var contactsRef : DatabaseReference
    {
        return  dbRef.child(Constants.CONTACTS);
    }
    
    var messageRef : DatabaseReference
    {
        return  dbRef.child(Constants.MESSAGES);
    }
    
    var mediaMessageRef : DatabaseReference
    {
        return  dbRef.child(Constants.MEDIA_MESSAGES);
    }
    
    var storageRef : StorageReference
    {
        return Storage.storage().reference(forURL: "gs://chitchat-a2664.appspot.com");
    }
    
    var imageStorageRef: StorageReference
    {
        return  storageRef.child(Constants.IMAGE_STORAGE);
    }
    
    var videoStorageRef: StorageReference
    {
        return  storageRef.child(Constants.VIDEO_STORAGE);
    }
    
    func  saveUser(withId: String, email: String, password: String)
    {
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password];
        
        contactsRef.child(withId).setValue(data);
        
    }
    
    func getContacts()
    {
        
        contactsRef.observeSingleEvent(of: DataEventType.value)
        { (snapshot: DataSnapshot) in
            
            var contacts = [Contact]();
            if let myContacts  =  snapshot.value as? NSDictionary
            {
                for(key, value) in myContacts {
                    
                    if let contactData = value as? NSDictionary {
                        
                        if let email = contactData[Constants.EMAIL] as? String
                        {
                            let id = key as! String;
                            let newContact =  Contact(id: id, name: email);
                            contacts .append(newContact)
                            
                        }
                    }
                }
            }
            
            self.delegate?.dataRecieved(contacts: contacts); 
         }
        
    }
    
}// class









































































