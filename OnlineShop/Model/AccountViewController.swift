//
//  AccountViewController.swift
//  OnlineShop
//
//  Created by Камиль on 02.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountViewController: UITableViewController {

    //MARK: - IBOutlents
    @IBOutlet weak var authOutlet: UIButton!
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
//Проверяем залогинился ли пользователь
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
         checkLoginStatus()

    }
    
    //MARK: - IBActions
    @IBAction func authTapped() {
        
        if User.currentUser() != nil {
            do {
                try Auth.auth().signOut()
                authOutlet.setTitle("Войти в аккаунт", for: .normal)
            } catch {
                print ("error user auth")
            }
        } else {
            goToPhoneVC()
        }
        
      }

    @IBAction func exitButton(_ sender: UIButton) {
    }
    
    @IBAction func unwindToAccount(_ unwindSegue: UIStoryboardSegue) {
       
    }
    

    //MARK: - Helpers
    
    private func checkLoginStatus() {
        
//        if Auth.auth().currentUser?.uid != nil
        if User.currentUser() != nil {
            authOutlet.setTitle("Выйти", for: .normal)
        } else {
            authOutlet.setTitle("Войти в аккаунт", for: .normal) 
        }
    }

  private func goToPhoneVC() {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let dvc = storyboard.instantiateViewController(withIdentifier: "PhoneViewController") as! PhoneViewController
      dvc.modalPresentationStyle = .fullScreen
      self.present(dvc, animated: true, completion: nil)
      
  }
}
