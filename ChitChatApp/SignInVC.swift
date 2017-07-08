//
//  SignInVC.swift
//  ChitChatApp
//
//  Created by Omkar Thorat on 6/6/17.
//  Copyright © 2017 Supriya Deore. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInVC: UIViewController {

    private let CONTACTS_SEGUE = "ContactsSegue";
    
    @IBOutlet var emailTextfield: UITextField!
    
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        if AuthProvider.Instance.isLoggedIn()
        {
            performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil); 
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    
    @IBAction func login(_ sender: Any) {
        
        // performSegue(withIdentifier: CONTACTS_SEGUE, sender: nil);
        
        if emailTextfield.text != "" && passwordTextfield.text != ""
        {
            AuthProvider.Instance.login(withEmail:  emailTextfield.text!, password: passwordTextfield.text!, loginHandler: { (message) in
                
                if message != nil
                {
                    self.alertTheUser(title: "Problem with Authentication", message: message!);
                }
                else
                {
                    self.emailTextfield.text = "";
                    self.passwordTextfield.text = "";
                    
                    self.performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil);
                    
                }
                
            });
        }
        else
        {
            alertTheUser(title: "Email And Password Are Required", message: "Please Enter The Email And Password In the text field");
        }
        
    }

    @IBAction func signUp(_ sender: Any)
    {
        if emailTextfield.text != "" && passwordTextfield.text != ""
        {
           AuthProvider.Instance.signUp(withEmail: emailTextfield.text!, password: passwordTextfield.text!, loginHandler: { (message) in
        
              if message != nil
              {
                self.alertTheUser(title: "Problem with Creating a New User", message: message!);
                
              }
               else
              {
                self.emailTextfield.text = "";
                self.passwordTextfield.text = "";
                
                self.performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil);
              }
            
           })
        }
        else
        {
            alertTheUser(title: "Email And Password Are Required", message: "Please Enter The Email And Password In the text field");
        }

        
    }
    
    private func alertTheUser(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction (title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
    
    
    
} //class
