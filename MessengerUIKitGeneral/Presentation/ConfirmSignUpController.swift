//
//  ConfirmSignUpController.swift
//  MessengerUIKitT
//
//  Created by Safarnejad on 12/4/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit

class ConfirmSignUpController: UIViewController , UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var confirmationCodeTextField: UITextField!
    public var passedPhoneNumber : String = ""
    let sendBtn = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(sendBtnTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK:- TextFields
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let text = textField.text {
            if textField == confirmationCodeTextField {
                if validateOTP(text) {
                    sendBtn.isEnabled = true
                } else {
                    sendBtn.isEnabled = false
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 4
    }
    
    
    // MARK:- Keyboard effect
    @objc func viewTapped(sender: UITapGestureRecognizer? = nil) {
        confirmationCodeTextField.resignFirstResponder()
    }

    
    // MARK:- utility
    
    @objc func sendBtnTapped() {
        print(confirmationCodeTextField.text!)
        // MARK:- todo some code
        // send the OTP to the server and get ack or token...
        
        let registerInformationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterInformationController") as! RegisterInformationController
        self.navigationController?.pushViewController(registerInformationController, animated: true)
    }
    
    func validateOTP(_ otpCode : String) -> Bool {
        let OTP_REGEX = "[0-9]{4}"
        let otp = NSPredicate(format: "SELF MATCHES %@", OTP_REGEX)
        let result =  otp.evaluate(with: otpCode)
        return result
    }
    
    func setUp() {
        sendBtn.isEnabled = false
        confirmationLabel.text = "OTP has been sent to the\n +98 \(passedPhoneNumber), Type it below and Enjoy"
        confirmationCodeTextField.keyboardType = .asciiCapableNumberPad
        navigationItem.rightBarButtonItem = sendBtn
        confirmationCodeTextField.delegate = self
        confirmationCodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let gestuere = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        gestuere.delegate = self
        self.view.addGestureRecognizer(gestuere)
        
    }

}
