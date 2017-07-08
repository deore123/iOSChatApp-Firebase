//
//  ContactsVC.swift
//  ChitChatApp
//
//  Created by Omkar Thorat on 6/6/17.
//  Copyright © 2017 Supriya Deore. All rights reserved.
//

import UIKit

class ContactsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FetchData {

    @IBOutlet var myTable: UITableView!
    
    private let CHAT_SEGUE = "ChatSegue";
    
    private var contacts = [Contact]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DBProvider.Instance.delegate = self;
        DBProvider.Instance.getContacts();
}
    
    func dataRecieved(contacts: [Contact])
    {
        self.contacts = contacts;
        
        // get the name of the user  
        for contact in contacts
        {
            if contact.id == AuthProvider.Instance.userID()
            {
                AuthProvider.Instance.userName = contact.name;
            }
        }
        
        myTable.reloadData();
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath);
        
        cell.textLabel?.text = contacts[indexPath.row].name;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: CHAT_SEGUE, sender: nil);
    }
    
    @IBAction func logout(_ sender: Any) {
        
        if AuthProvider.Instance.logOut()
        {
        dismiss(animated: true, completion: nil);
        }
    }
    
} //class
