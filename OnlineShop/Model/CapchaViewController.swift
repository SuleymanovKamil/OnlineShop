////
////  CapchaViewController.swift
////  OnlineShop
////
////  Created by Камиль on 02.06.2020.
////  Copyright © 2020 Kamil. All rights reserved.
////
//
//import UIKit
//import FirebaseAuth
//import JGProgressHUD
//import NVActivityIndicatorView
//
//class CapchaViewController: UIViewController {
//
//    var verificationID: String!
//    let hud = JGProgressHUD(style: .dark)
//
//    @IBOutlet weak var codeTextView: UITextView!
//
//    @IBAction func checkCodeTapped(_ sender: UIButton) {
//        guard let code = codeTextView.text else { return }
//
//        let credetional = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
//
//        Auth.auth().signIn(with: credetional) { (authDataResult, error) in
//            if error != nil {
//                    let ac = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
//                    let cancel = UIAlertAction(title: "Отмена", style: .cancel)
//                    ac.addAction(cancel)
//                    self.present(ac, animated: true)
//            } else {
////                finishiOnboarding()
//                downloadUserFromFirestore(userId: authDataResult!.user.uid)
//                self.hud.textLabel.text = "Регистрация завершена"
//                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                self.hud.show(in: self.view)
//                self.hud.dismiss(afterDelay: 2.0)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
//                self.goToMRootVC()
//
//
//                }
//            }
//        }
//    }
//
//    //MARK: - View Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupConfig()
//
//    }
//
//    private func goToMRootVC() {
//        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//    }
//    private func setupConfig() {
//        checkCodeButton.alpha = 0.5
//        checkCodeButton.isEnabled = false
//
//        codeTextView.delegate = self
//    }
//
//    //MARK: - Finish user registration function
////    private func finishiOnboarding() {
////
////        let withValues = [K.FireBase.name : nameTextField.text!, kLASTNAME : surnameTextField.text!, kONBOARD : true, kFULLADDRESS : addressTextField.text!, kFULLNAME : (nameTextField.text! + " " + surnameTextField.text!)] as [String : Any]
////
////
////        updateCurrentUserInFirestore(withValues: withValues) { (error) in
////
////            if error == nil {
////                self.hud.textLabel.text = "Updated!"
////                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
////                self.hud.show(in: self.view)
////                self.hud.dismiss(afterDelay: 2.0)
////
////                self.dismiss(animated: true, completion: nil)
////            } else {
////
////                print("error updating user \(error!.localizedDescription)")
////
////                self.hud.textLabel.text = error!.localizedDescription
////                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
////                self.hud.show(in: self.view)
////                self.hud.dismiss(afterDelay: 2.0)
////            }
////        }
////    }
//
//}
//// check code length
//extension CapchaViewController: UITextViewDelegate {
//
//func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//    let currentCharacterCount = textView.text?.count ?? 0
//    if range.length + range.location > currentCharacterCount {
//        return false
//    }
//    let newLength = currentCharacterCount + text.count - range.length
//    return newLength <= 6
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.text?.count == 6 {
//            checkCodeButton.alpha = 1
//            checkCodeButton.isEnabled = true
//        } else {
//            checkCodeButton.alpha = 0.5
//            checkCodeButton.isEnabled = false
//        }
//
//    }
//}
