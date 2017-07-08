//
//  AuthProvider.swift
//  ChitChatApp
//
//  Created by deore123 on 6/7/17.
//  Copyright © 2017 deore123. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void;

struct LoginErrorCode {
    
    static let INVALID_EMAIL = "Invalid Email Address, Please Provide Valid Email Address";
    static let WRONG_PASSWORD = "Wrong Pasword, Please enter the correct password";
    static let PROBLEM_COONECTING = "Problem connecting to database, Please try later";
    static let USER_NOT_FOUND = "User not found, Please register";
    static let EMAIL_ALREADY_IN_USE = "Email already in use, Please use another email";
    static let WEAK_PASSWORD = "Password should be atleast 6 characters long";
}

class AuthProvider {
    
    private static let  _instance = AuthProvider();
    
    static var Instance: AuthProvider {
        return _instance;
    }
    
    var userName = ""; 
        
    func  login(withEmail: String, password:String, loginHandler: LoginHandler?)
    {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, Error) in
        
            if Error != nil
            {
                self.handleErrors(err: Error as NSError!, loginHandler: loginHandler);
                
            }
            else
            {
                loginHandler?(nil); 
            }
        });
        
    } //login func
    
    
    func signUp(withEmail: String, password:String, loginHandler: LoginHandler?)
    {
        Auth.auth().createUser(withEmail: withEmail, password: password, completion: { (user, Error) in
            
            if Error != nil
            {
                self.handleErrors(err: Error! as NSError, loginHandler: loginHandler!);
            }
            else
            {
                if user?.uid != nil
                {
                    // store the user to the database
                    DBProvider.Instance.saveUser(withId: (user?.uid)!, email: withEmail, password: password);
                    
                    // login the user 
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler);
                }
            }
            
        });
        
    } // Sign Up func
    
    func isLoggedIn() -> Bool
    {
        if Auth.auth().currentUser != nil
        {
            return true;
        }
        
        return false;
    }
    
    func logOut() -> Bool
    {
        if Auth.auth().currentUser != nil
        {
            do {
                try Auth.auth().signOut();
                return true;
            }
            catch {
                return false;
            }
        }
        return true;
    }
    
    func  userID() -> String
    {
        return Auth.auth().currentUser!.uid;
    }
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?)
    {
        
        if let errCode = AuthErrorCode(rawValue: err.code)
        {
            switch errCode
            {
            case .wrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD);
                break;
            
            case .invalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL);
                break;
            
            case .userNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND);
                break;
            
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE);
                break;
                
            case .weakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD);
                break;
                
            default :
                loginHandler?(LoginErrorCode.PROBLEM_COONECTING);
                break;
                
            }
    }
}
    
} //class












































































