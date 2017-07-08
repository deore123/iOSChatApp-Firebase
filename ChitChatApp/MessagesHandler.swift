//
//  MessagesHandler.swift
//  ChitChatApp
//
//  Created by Omkar Thorat on 6/10/17.
//  Copyright © 2017 Supriya Deore. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol  MessageReceivedDelegate : class
{
    func  messageReceived(senderID: String, senderName: String, text: String);
    func mediaReceived(senderID: String, senderName: String, url: String);
    
}

class MessagesHandler
{
    private static let _instance = MessagesHandler();
    private init ()
    { }
    
    weak var delegate: MessageReceivedDelegate?;
    
    static var Instance: MessagesHandler
    {
        return _instance;
    }
    
    func sendMessage(senderID: String, senderName: String, text: String)
    {
        let data: Dictionary<String, Any> = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.TEXT: text];
        
        DBProvider.Instance.messageRef.childByAutoId().setValue(data);
    }
    
    
    func  sendMediaMessages(senderID: String, senderName: String, url: String )
    {
        let data : Dictionary<String, Any> = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.URL: url];
        
        DBProvider.Instance.mediaMessageRef.childByAutoId().setValue(data);
    }
    
    
    func sendMedia(image: Data?, video: URL?, senderID: String, senderName: String)
    {
        if image != nil
        {
            DBProvider.Instance.imageStorageRef.child( senderID + "\(NSUUID().uuidString).jpg").putData(image!, metadata: nil)
            { (metadata: StorageMetadata?, err: Error?) in
                
                if err != nil
                {
                    //infrom the user that there was problem uploading the image
                } else
                {
                    self.sendMediaMessages(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!));
                }
                
            }
            
        } else
        {
            DBProvider.Instance.videoStorageRef.child(senderID +  "\(NSUUID().uuidString)").putFile(from: video!, metadata: nil)
            { (metadata: StorageMetadata?, err : Error? ) in
                
                if err != nil
                {
                    // inform the user that uploadind video has failed, using delegation
                }
                else
                {
                    self.sendMediaMessages(senderID: senderID, senderName: senderName, url: String(describing: metadata?.downloadURL()!));
                }
            }
            
        }
        
    }
    
    func observeMessages()
    {
        DBProvider.Instance.messageRef.observe(DataEventType.childAdded)
        { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary
            {
                if let senderID = data[Constants.SENDER_ID] as? String
                {
                     if let senderName = data[Constants.SENDER_NAME] as? String
                    {
                        if let text = data[Constants.TEXT] as? String
                        {
                            self.delegate?.messageReceived(senderID: senderID, senderName: senderName, text: text);
                        }
                    }
                }
            }
        }
    }
    
    
    func observeMediaMessages()
    {
        DBProvider.Instance.mediaMessageRef.observe(DataEventType.childAdded) {(snapshot: DataSnapshot) in
        
            if let data = snapshot.value as? NSDictionary
        {
                if let id = data[Constants.SENDER_ID] as? String
            {
                    if let name = data[Constants.SENDER_NAME] as? String
                {
                    if let fileURL = data[Constants.URL] as? String
                    {
                        self.delegate?.mediaReceived(senderID: id , senderName: name, url: fileURL)
                    }
                        
                }
            }
        }
    }
 }
    
}// class























































