//
//  PhoneViewController.swift
//  OnlineShop
//
//  Created by Камиль on 02.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
import FirebaseAuth
import FlagPhoneNumber
import JGProgressHUD
import NVActivityIndicatorView

class PhoneViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Vars
    var phoneNumber: String?
    var listController: FPNCountryListViewController!
    static var address = ""
    var verificationID: String!
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - IBOutlets
    @IBOutlet weak var phoneNumberTextField: FPNTextField!
    @IBOutlet weak var fetchCodeButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var adressTextField: UITextField!
    @IBOutlet weak var codeTextView: UITextView!
    @IBOutlet var chechButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
    }

    override func viewWillAppear(_ animated: Bool) {
        adressTextField.placeholder = "Укажите адрес доставки"
        adressTextField.text = PhoneViewController.address
        nameTextField.text = UserDefaults.standard.string(forKey: "name")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       PhoneViewController.address = ""
    }
    
    //MARK: - IBActions
    @IBAction func adressButtonPressed(_ sender: UIButton) {
        goToMapVC()
        UserDefaults.standard.set(nameTextField.text!, forKey: "name")
   
    }
    
    @IBAction func fetchCodeTapped(_ sender: UIButton) {
        
        guard phoneNumber != nil else { return }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "is empty")
            } else {
                self.verificationID = verificationID!
                self.chechButtonOutlet.isHidden = false
                self.fetchCodeButton.isEnabled = false
                self.fetchCodeButton.isHidden = true
                self.codeTextView.isHidden = false
            }
        }
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        guard let code = codeTextView.text else { return }
        
        let credetional = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        Auth.auth().signIn(with: credetional) { (authDataResult, error) in
            if error != nil {
                    let ac = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Отмена", style: .cancel)
                    ac.addAction(cancel)
                    self.present(ac, animated: true)
            } else {
                
                downloadUserFromFirestore(userId: authDataResult!.user.uid)
                self.hud.textLabel.text = "Регистрация завершена"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                self.goToMRootVC()
                }
            }
        }
    }
    //MARK: - Navigation
    
private func goToMRootVC() {
    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
}
    
    private func goToMapVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//        dvc.modalPresentationStyle = .fullScreen
        self.present(dvc, animated: true, completion: nil)
    }
    
    //MARK: - Setup config function
    private func setupConfig() {
        fetchCodeButton.alpha = 0.5
        fetchCodeButton.isEnabled = false
        
        phoneNumberTextField.displayMode = .list
        phoneNumberTextField.delegate = self
        nameTextField.delegate = self
        adressTextField.delegate = self
        codeTextView.delegate = self
        codeTextView.text = "Введите код из СМС"
        codeTextView.textColor = UIColor.white
        chechButtonOutlet.isHidden = true
            
        codeTextView.isHidden = true
        
        listController = FPNCountryListViewController(style: .grouped)
        listController?.setup(repository: phoneNumberTextField.countryRepository)
        listController.didSelect = { country in
            self.phoneNumberTextField.setFlag(countryCode: country.code)
        }
    }
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return false
   }
}
//MARK: - TextView Delegate methods
extension PhoneViewController: UITextViewDelegate {
//
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.text?.count == 6 && fetchCodeButton.currentTitle == "Проверить"{
//            fetchCodeButton.alpha = 1
//            fetchCodeButton.isEnabled = true
//        } else {
//            fetchCodeButton.alpha = 0.5
//            fetchCodeButton.isEnabled = false
//        }
//
//    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if codeTextView.textColor == UIColor.white {
            codeTextView.text = nil
            codeTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if codeTextView.text.isEmpty {
            codeTextView.text = "Введите код из СМС"
            codeTextView.textColor = UIColor.white
        }
    }
}
//MARK: - FlagPhoneNumber extensions
extension PhoneViewController: FPNTextFieldDelegate {
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        ///
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            fetchCodeButton.alpha = 1
            fetchCodeButton.isEnabled = true
            
            phoneNumber = textField.getFormattedPhoneNumber(format: .International)
        } else {
            fetchCodeButton.alpha = 0.5
            fetchCodeButton.isEnabled = false
        }
    }
    
    func fpnDisplayCountryList() {
        let navigationController = UINavigationController(rootViewController: listController)
        listController.title = "Страны"
        phoneNumberTextField.text = ""
        self.present(navigationController, animated: true)
    }
        //MARK: - Finish user registration function
        private func finishiOnboarding() {
    
            let withValues = [K.FireBase.name : nameTextField.text!, K.FireBase.userAdress : adressTextField.text!] as [String : Any]
    
    
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
    
                if error == nil {
                    self.hud.textLabel.text = "Updated!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
    
                    self.dismiss(animated: true, completion: nil)
                } else {
    
                    print("error updating user \(error!.localizedDescription)")
    
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
        }
}


