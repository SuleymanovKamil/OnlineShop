//
//  EditProfileViewController.swift
//  OnlineShop
//
//  Created by Камиль on 20.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - IBOutlets
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var saveButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
        setupUI ()
    }
    
    //MARK: - IBActions

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if textFieldsHaveText() {
            
            let withValues = [K.FireBase.name : nameTextField.text!, K.FireBase.userAdress : addressTextField.text!]
            
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                
                if error == nil {
                    self.hud.textLabel.text = "Данные обновлены!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    
                } else {
                    print("erro updating user ", error!.localizedDescription)
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
            
        } else {
            hud.textLabel.text = "Заполните все поля!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            
        }
    }
    
    //MARK: - SetupUI
    func setupUI() {
        nameTextField.delegate = self
        addressTextField.delegate = self
        saveButtonOutlet.isEnabled = false
        saveButtonOutlet.alpha = 0.5
    }
    
    //MARK: - UpdateUI
    
    private func loadUserInfo() {
        
        if User.currentUser() != nil {
            let currentUser = User.currentUser()!
            
            nameTextField.text = currentUser.name
            addressTextField.text = currentUser.adress
            
            
            }
        
        }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//MARK: - TextField Delegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButtonOutlet.isEnabled = true
        saveButtonOutlet.alpha = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: - Helper funcs
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }

    private func textFieldsHaveText() -> Bool {
        
        return (nameTextField.text != "" && addressTextField.text != "")
    }

}

