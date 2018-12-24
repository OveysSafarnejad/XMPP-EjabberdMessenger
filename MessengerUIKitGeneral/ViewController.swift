//
//  ViewController.swift
//  MessengerUIKitT
//
//  Created by Safarnejad on 12/4/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit
import XMPPFramework
import MBProgressHUD



class ViewController: UIViewController , XMPPStreamDelegate {
    
    
    var hud: MBProgressHUD!
    
    var username: String = ""
    var password2: String = ""
    var elements: NSMutableArray = []
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OneChat.sharedInstance.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func setUp(){
        
        startBtn.layer.cornerRadius = self.startBtn.frame.height/2
        startBtn.clipsToBounds = true
        attempToConnect()
    }
    
    func attempToConnect() {
        if UserDefaults.standard.string(forKey: kXMPP.myJID) == nil || UserDefaults.standard.string(forKey: kXMPP.myPassword) == nil {
            print("must redirect to login")
        } else {
            print("attemp to connect")
            OneChat.sharedInstance.connect(username: UserDefaults.standard.string(forKey: kXMPP.myJID)!, password: UserDefaults.standard.string(forKey: kXMPP.myPassword)!) { (stream, error) -> Void in
                if let _ = error {
                    print("first connectiong attemps in initializer controller returns error")
                } else {
                    print("view WillApear no error in main chat")
                }
            }
        }
    }
    
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        print("connected -> (START UP)")
        
        print("support: \(OneChat.sharedInstance.xmppStream!.supportsInBandRegistration)")
        if OneChat.sharedInstance.xmppStream!.supportsInBandRegistration {
            do {
                try OneChat.sharedInstance.xmppStream!.register(with: elements as! [DDXMLElement])
            } catch let error {
                print(error)
            }
        }
    }
    
    func xmppStreamDidDisconnect(_ sender: XMPPStream, withError error: Error?) {
        print("disconnected -> (START UP)")
    }
    
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement) {
        print("did not authenticate -> (START UP)")
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        print("did authenticate -> (START UP)")
        let tabbarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewTabBar")
        self.present(tabbarViewController, animated: true, completion: nil)
    }
    
    func xmppStreamDidRegister(_ sender: XMPPStream) {
        do {
            try OneChat.sharedInstance.xmppStream!.authenticate(withPassword: password2)
        } catch _ {
            //Handle error
        }
    }
    
    func xmppStream(_ sender: XMPPStream, didNotRegister error: DDXMLElement) {
    
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        
        username = "jamshid"
        password2 = "123"
        elements.add(XMLElement(name: "username", stringValue: username))
        elements.add(XMLElement(name: "password", stringValue: password2))
        
        
        OneChat.sharedInstance.connect(username: username+Constants.LoginPostfix.USERNAME_POSTFIX, password: password2) { (stream, error) -> Void in
            
            if let _ = error {
                let alertController = UIAlertController(title: "Oops", message: "Please set crendentials before trying to connect!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) -> Void in
                    
                }))
                
            } else {
            //FIXME: else -> move to did authenticate
            }
        }
        
        
        
        
    }
}

