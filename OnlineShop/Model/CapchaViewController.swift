//
//  CapchaViewController.swift
//  OnlineShop
//
//  Created by Камиль on 02.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
import FirebaseAuth

class CapchaViewController: UIViewController {
    
    var verificationID: String!
    
    @IBOutlet weak var codeTextView: UITextView!
    @IBOutlet weak var checkCodeButton: UIButton!
       
    @IBAction func checkCodeTapped(_ sender: UIButton) {
        guard let code = codeTextView.text else { return }
        
        let credetional = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        Auth.auth().signIn(with: credetional) { (authDataResult, error) in
            if error != nil {
                    let ac = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Отмена", style: .cancel)
                    ac.addAction(cancel)
                    self.present(ac, animated: true)
            } else {
                self.goToMainScreen()
                downloadUserFromFirestore(userId: authDataResult!.user.uid)
            }
        }
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfig()
        
    }
    
    private func goToMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        dvc.modalPresentationStyle = .fullScreen
        self.present(dvc, animated: false, completion: nil)
        
    }
    private func setupConfig() {
        checkCodeButton.alpha = 0.5
        checkCodeButton.isEnabled = false
        
        codeTextView.delegate = self
    }

}
// check code length
extension CapchaViewController: UITextViewDelegate {

func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
    let currentCharacterCount = textView.text?.count ?? 0
    if range.length + range.location > currentCharacterCount {
        return false
    }
    let newLength = currentCharacterCount + text.count - range.length
    return newLength <= 6
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text?.count == 6 {
            checkCodeButton.alpha = 1
            checkCodeButton.isEnabled = true
        } else {
            checkCodeButton.alpha = 0.5
            checkCodeButton.isEnabled = false
        }
        
    }
}
