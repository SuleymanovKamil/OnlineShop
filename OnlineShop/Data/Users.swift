//
//  Users.swift
//  OnlineShop
//
//  Created by Камиль on 16.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    
    var objectID: String
    var name: String
    var itemsInBasket: [String]
    
    var adress: String
    
    //MARK: - Inits
    init(_userId: String, _name: String) {
        
        objectID = _userId
        name = _name
        itemsInBasket = []
        adress = ""
    }
    
    init(_dictionary: NSDictionary) {
        
        objectID = _dictionary[K.FireBase.objectID] as! String
        
        if let fname = _dictionary[K.FireBase.userName] {
            name = fname as! String
        } else {
            name = ""
        }
        
        if let purchaseIds = _dictionary[K.FireBase.itemsInBaket] {
            itemsInBasket = purchaseIds as! [String]
        } else {
            itemsInBasket = []
        }
        if let faddress = _dictionary[K.FireBase.userAdress] {
            adress = faddress as! String
        } else {
            adress = ""
        }
    }
    
    
    //MARK: - Return current user
    
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> User? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: K.FireBase.currentUser) {
                return User.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        
        return nil
    }
    
}

//MARK: - Helper function

func userDictionaryFrom(user: User) -> NSDictionary {
    
    return NSDictionary(objects: [user.objectID, user.name, user.adress, user.itemsInBasket], forKeys: [K.FireBase.objectID as NSCopying, K.FireBase.userName as NSCopying,  K.FireBase.userAdress as NSCopying, K.FireBase.itemsInBaket as NSCopying])
}


//MARK: - Save user to firebase

    func saveUserToFirestore(User: User) {
        
        FirebaseReference(.User).document(User.objectID).setData(userDictionaryFrom(user: User) as! [String : Any]) { (error) in
            
            if error != nil {
                print("error saving user \(error!.localizedDescription)")
            }
        }
    }


    func saveUserLocally(userDictionary: NSDictionary) {
        
        UserDefaults.standard.set(userDictionary, forKey: K.FireBase.currentUser)
        UserDefaults.standard.synchronize()
    }


//MARK: - DownloadUser

func downloadUserFromFirestore(userId: String) {
    
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else { return }
        
        if snapshot.exists {
            print("download current user from firestore")
            saveUserLocally(userDictionary: snapshot.data()! as NSDictionary)
        } else {
            //there is no user, save new in firestore
            
            let user = User(_userId: userId, _name: "")
            saveUserLocally(userDictionary: userDictionaryFrom(user: user))
            saveUserToFirestore(User: user)
        }
    }

}

//MARK: - Update user

func updateCurrentUserInFirestore(withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    if let dictionary = UserDefaults.standard.object(forKey: K.FireBase.currentUser) {
        
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        
        FirebaseReference(.User).document(User.currentId()).updateData(withValues) { (error) in
            
            completion(error)
            
            if error == nil {
                saveUserLocally(userDictionary: userObject)
            }
        }
    }
}
