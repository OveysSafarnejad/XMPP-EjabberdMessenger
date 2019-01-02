//
//  SignUpViewController.swift
//  MessengerUIKitT
//
//  Created by Safarnejad on 12/4/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController , UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    let nextBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        setUp()
    }
    
    
    
    // MARK:- TextFields
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let text = textField.text {
            if textField == phoneNumberTextField {
                if validatePhoneNumber(text) {
                    nextBtn.isEnabled = true
                } else {
                    nextBtn.isEnabled = false
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 10
    }
    
    
    // MARK:- Keyboard effect
    @objc func viewTapped(sender: UITapGestureRecognizer? = nil) {
        phoneNumberTextField.resignFirstResponder()
    }
    
    // MARK:- Utility
    func validatePhoneNumber(_ phoneNumber : String) -> Bool {
        let PHONE_REGEX = "[9][0-9]{9}"
        let phone = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phone.evaluate(with: phoneNumber)
        return result
    }
    
    
    @objc func nextTapped() {
        print(phoneNumberTextField.text!)
        // MARK:- todo some code
        // send the PN to the server and get OTP via message...
        
            let confirmSignUpController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmSignUpController") as! ConfirmSignUpController
            confirmSignUpController.passedPhoneNumber = phoneNumberTextField.text!
            
            
           self.navigationController?.pushViewController(confirmSignUpController, animated: true)
    }
    
    func setUp() {
        
        nextBtn.isEnabled = false
        countryCodeLbl.layer.cornerRadius = 5
        countryCodeLbl.clipsToBounds = true
        navigationItem.rightBarButtonItem = nextBtn
        phoneNumberTextField.delegate = self
        phoneNumberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let gestuere = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        gestuere.delegate = self
        self.view.addGestureRecognizer(gestuere)
        phoneNumberTextField.keyboardType = .asciiCapableNumberPad
    }
    
}
