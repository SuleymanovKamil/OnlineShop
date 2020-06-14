//
//  AccountViewController.swift
//  OnlineShop
//
//  Created by Камиль on 02.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountViewController: UIViewController {

    @IBOutlet weak var authOutlet: UIButton!
    @IBOutlet weak var exitOutlet: UIButton!
    
    
    
    @IBAction func authTapped() {
        self.performSegue(withIdentifier: K.Segues.segueToPhoneVCSegue , sender: self)
      }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToAccount(_ unwindSegue: UIStoryboardSegue) {
       
    }
    
    //Проверяем залогинился ли пользователь
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            if Auth.auth().currentUser?.uid != nil {
//                self.authOutlet.isHidden = true
            }
        }
    }

  //  логаут
    
//    @IBAction func logOut(_ sender: UIButton) {
//
//        do {
//            try Auth.auth().signOut()
//            performSegue(withIdentifier: "closeSegue", sender: self)
//        } catch {
//
//        }
//    }

}
