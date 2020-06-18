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

class PhoneViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Vars
    var phoneNumber: String?
    var listController: FPNCountryListViewController!
    static var address = ""
    
    //MARK: - IBOutlets
    @IBOutlet weak var phoneNumberTextField: FPNTextField!
    @IBOutlet weak var fetchCodeButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var adressTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        self.nameTextField.delegate = self
        self.adressTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        adressTextField.placeholder = "Укажите адрес доставки"
        adressTextField.text = PhoneViewController.address
 
    }
    
    //MARK: - IBActions
    @IBAction func adressButtonPressed(_ sender: UIButton) {
        goToMapVC()
    }
    @IBAction func fetchCodeTapped(_ sender: UIButton) {
        
        
        guard phoneNumber != nil else { return }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "is empty")
            } else {
                self.showCodeValidVC(verificationID: verificationID!)
            }
        }
    }
    
    
    //MARK: - Navigation
    
  private func showCodeValidVC(verificationID: String) {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let dvc = storyboard.instantiateViewController(withIdentifier: "CapchaViewController") as! CapchaViewController
      dvc.verificationID = verificationID
      self.present(dvc, animated: true, completion: nil)
  }
    
    private func goToMapVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        dvc.modalPresentationStyle = .fullScreen
        self.present(dvc, animated: true, completion: nil)
    }
    
    
    //MARK: - Setup confi function
    private func setupConfig() {
        fetchCodeButton.alpha = 0.5
        fetchCodeButton.isEnabled = false
        
        phoneNumberTextField.displayMode = .list
        phoneNumberTextField.delegate = self
        
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
    
}
