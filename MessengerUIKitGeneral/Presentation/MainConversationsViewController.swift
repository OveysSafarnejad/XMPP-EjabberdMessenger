//
//  MainConversationsViewController.swift
//  MessengerUIKitGeneral
//
//  Created by Safarnejad on 12/11/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit
import XMPPFramework
import JSQMessagesViewController

class MainConversationsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate, OneRosterDelegate {
    
    
   
    var chatList = NSArray()
    @IBOutlet weak var mainConversationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainConversationsTableView.delegate = self
        mainConversationsTableView.dataSource = self
        mainConversationsTableView.separatorStyle = .none
        OneRoster.sharedInstance.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1.0/255.0, green: 255.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        OneRoster.sharedInstance.delegate = nil
        //navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    // MARK:- Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OneChats.getChatsList().count //chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as? ConversationCell {
            
            let user = OneChats.getChatsList().object(at: indexPath.row) as! XMPPUserCoreDataStorageObject
            cell.nameLabel.text = user.displayName
            OneChat.sharedInstance.configurePhotoForCell(cell, user: user)
            return cell
            
        } else {
            return ConversationCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func oneRosterContentChanged(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainConversationsTableView.reloadData()
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "chat.to.add" {
            if !OneChat.sharedInstance.isConnected() {
                let alert = UIAlertController(title: "Attention", message: "You have to be connected to start a chat", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chats.to.chat" {
            if let controller = segue.destination as? ChatViewController {
                if let cell: UITableViewCell = sender as? UITableViewCell {
                    let user = OneChats.getChatsList().object(at: mainConversationsTableView.indexPath(for: cell)!.row) as! XMPPUserCoreDataStorageObject
                    controller.recipient = user
                }
            }
        }
    }
//    
//    
//    //MARK:- Actions    
//    @IBAction func outClicked(_ sender: Any) {
//        OneChat.sharedInstance.xmppStream?.disconnect()
//        
//        UserDefaults.standard.set(nil, forKey: kXMPP.myJID)
//        UserDefaults.standard.set(nil, forKey: kXMPP.myPassword)
//        let startUp = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppStartUpPage")
//        self.tabBarController?.present(startUp, animated: true, completion: nil)
//        
//    }
}
