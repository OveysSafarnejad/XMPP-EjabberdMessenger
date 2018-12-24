//
//  SignInViewController.swift
//  MessengerUIKitGeneral
//
//  Created by Safarnejad on 12/22/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit

import XMPPFramework
import MBProgressHUD


class SignInViewController: UIViewController , XMPPStreamDelegate {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = self.loginButton.frame.height/2
        loginButton.clipsToBounds = true
        OneChat.sharedInstance.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
    
            self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.hud.label.text = "Signing in..."
            
        OneChat.sharedInstance.connect(username: usernameTextfield.text!+Constants.LoginPostfix.USERNAME_POSTFIX, password: passwordTextfield.text!) { (stream, error) -> Void in
                
                if let _ = error {
                    let alertController = UIAlertController(title: "Oops", message: "Please set crendentials before trying to connect!", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) -> Void in
                        
                    }))
                    self.hud.hide(animated: true)
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    UserDefaults.standard.set(self.usernameTextfield.text!+Constants.LoginPostfix.USERNAME_POSTFIX, forKey: kXMPP.myJID)
                    UserDefaults.standard.set(self.passwordTextfield.text, forKey: kXMPP.myPassword)
                    //FIXME: else -> move to did authenticate
                }
            }
    }
    
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        self.hud.hide(animated: true)
        print("connected -> (SIGNIN)")
    }
    
    func xmppStreamDidDisconnect(_ sender: XMPPStream, withError error: Error?) {

        let alertController = UIAlertController(title: "Sorry", message: "An error occured: Invalid Username or Password!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) -> Void in
            
        }))
        self.hud.hide(animated: true)
        self.present(alertController, animated: true, completion: nil)
        print("disconnected -> (SIGNIN)")
       
    }
    
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement) {
        
        let alertController = UIAlertController(title: "Sorry", message: "An error occured: Wrong Password!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) -> Void in
            
        }))
        self.hud.hide(animated: true)
        self.present(alertController, animated: true, completion: nil)
        print("did not authenticate -> (SIGNIN)")
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        print("did authenticate -> (SIGNIN)")
        self.hud.hide(animated: true)
        let tabbarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewTabBar")
        self.present(tabbarViewController, animated: true, completion: nil)
    }
    
}
