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
    @IBOutlet var historyOutlet: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var favorite: UIButton!
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(true, animated: true)
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
                tableView.reloadData()
                checkLoginStatus()
                UserDefaults.standard.removeObject(forKey: K.FireBase.currentUser)
                UserDefaults.standard.synchronize()

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

        if User.currentUser() != nil {
            authOutlet.setTitle("Выйти", for: .normal)
            historyOutlet.alpha = 1
            historyOutlet.isEnabled = true
            editButton.alpha = 1
            editButton.isEnabled = true
            favorite.alpha = 1
            favorite.isEnabled = true
        } else {
            authOutlet.setTitle("Войти в аккаунт", for: .normal)
            historyOutlet.alpha = 0.5
            historyOutlet.isEnabled = false
            editButton.alpha = 0.5
            editButton.isEnabled = false
            favorite.alpha = 0.5
            favorite.isEnabled = false
        }
    }

  private func goToPhoneVC() {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let dvc = storyboard.instantiateViewController(withIdentifier: "PhoneViewController") as! PhoneViewController
      dvc.modalPresentationStyle = .fullScreen
      self.present(dvc, animated: true, completion: nil)
      
  }
    
    //MARK: - TableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

