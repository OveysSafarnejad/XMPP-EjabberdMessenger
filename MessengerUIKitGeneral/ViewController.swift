//
//  ViewController.swift
//  MessengerUIKitT
//
//  Created by Safarnejad on 12/4/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit
import MBProgressHUD
import XMPPFramework

class ViewController: UIViewController , XMPPStreamDelegate {
    
    
    var hud: MBProgressHUD!
    
    //    var username: String = ""
    //    var password2: String = ""
    //    var elements: NSMutableArray = []
    //    var newAccountRegistration : Bool = false
    
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
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
        
        startButton.layer.cornerRadius = self.startButton.frame.height/2
        startButton.clipsToBounds = true
        signUpButton.layer.cornerRadius = self.signUpButton.frame.height/2
        signUpButton.clipsToBounds = true
        attempToConnect()
    }
    
    func attempToConnect() {
        
        if UserDefaults.standard.string(forKey: kXMPP.myJID) != nil && UserDefaults.standard.string(forKey: kXMPP.myPassword) != nil {
            
            OneChat.sharedInstance.connect(username: UserDefaults.standard.string(forKey: kXMPP.myJID)!, password: UserDefaults.standard.string(forKey: kXMPP.myPassword)!) { (stream, error) -> Void in
                
                if let _ = error {
                    print("first connectiong attemps in initializer controller returns error")
                } else {
                    print("view WillApear no error in main chat")
                }
            }
        }
    }
    
    //MARK:- Delegate Method
    
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        print("connected -> (START UP)")
        if UserDefaults.standard.string(forKey: kXMPP.myJID) != nil && UserDefaults.standard.string(forKey: kXMPP.myPassword) != nil {
            do {
                try OneChat.sharedInstance.xmppStream!.authenticate(withPassword: UserDefaults.standard.string(forKey: kXMPP.myPassword)! )
            } catch _ {
                //Handle error
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
}

