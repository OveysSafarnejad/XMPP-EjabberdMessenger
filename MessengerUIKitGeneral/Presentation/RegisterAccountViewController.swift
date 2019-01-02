//
//  RegisterAccountViewController.swift
//  MessengerUIKitGeneral
//
//  Created by Safarnejad on 12/25/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit
import XMPPFramework

class RegisterAccountViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, XMPPStreamDelegate  {
    
    
    var elements: NSMutableArray = []
    
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passcodeTextfield: UITextField!
    @IBOutlet weak var re_passcodeTextfield: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OneChat.sharedInstance.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        setup()
    }
    
    
    //MARK:- Utility
    func setup() {
        
        registerButton.layer.cornerRadius = registerButton.frame.height/2
        registerButton.clipsToBounds = true
        usernameTextfield.delegate = self
        passcodeTextfield.delegate = self
        re_passcodeTextfield.delegate = self
        let gestuere = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        gestuere.delegate = self
        self.view.addGestureRecognizer(gestuere)
        self.view.addGestureRecognizer(gestuere)
    }
    
    func validateRegistration() -> Bool {
        
        if usernameTextfield.text?.count == 0 || passcodeTextfield.text?.count == 0 || re_passcodeTextfield.text?.count == 0 {
            let alertController = UIAlertController(title: "Sorry", message: "An error occured: Neccessary fields are empty !", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) -> Void in
                
            }))
            self.present(alertController, animated: true, completion: nil)
            return false
        } else if passcodeTextfield.text != re_passcodeTextfield.text {
            let alertController = UIAlertController(title: "Sorry", message: "An error occured: Passcodes doesn't match !", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) -> Void in
                
            }))
            self.present(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
        
    }
    
    //MARK:- Selectors
    @objc func viewTapped(sender: UITapGestureRecognizer? = nil) {
        usernameTextfield.resignFirstResponder()
        passcodeTextfield.resignFirstResponder()
        re_passcodeTextfield.resignFirstResponder()
    }
    
    
    
    //MARK:- Actions
    @IBAction func registerButtonTouchUpInside(_ sender: Any) {
        
        if validateRegistration() {
            print("trying")
            elements.add(XMLElement(name: "username", stringValue: usernameTextfield.text!))
            elements.add(XMLElement(name: "password", stringValue: passcodeTextfield.text!))
            OneChat.sharedInstance.connect(username: usernameTextfield.text!+Constants.LoginPostfix.USERNAME_POSTFIX, password:passcodeTextfield.text!) { (stream, error) -> Void in
                if let _ = error {
                    print("\(error)")
                } else {
                    print("no error")
                }
            }
        }
    }
    
    
    //MARK:- Delegate Methods
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        print("connected -> (Registration)")
        
        if OneChat.sharedInstance.xmppStream!.supportsInBandRegistration {
            do {
                try OneChat.sharedInstance.xmppStream!.register(with: elements as! [DDXMLElement])
            } catch let error {
                print(error)
            }
        }
    }
    
    func xmppStreamDidRegister(_ sender: XMPPStream) {
        
        print("registered -> (Registration)")
        do {
            try OneChat.sharedInstance.xmppStream!.authenticate(withPassword: passcodeTextfield.text!)
        } catch _ {
            //Handle error
        }
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        UserDefaults.standard.set(self.usernameTextfield.text!+Constants.LoginPostfix.USERNAME_POSTFIX, forKey: kXMPP.myJID)
        UserDefaults.standard.set(self.passcodeTextfield.text, forKey: kXMPP.myPassword)
    }
    
    func xmppStream(_ sender: XMPPStream, didNotRegister error: DDXMLElement) {
        print("\(error)")
    }
    
}
