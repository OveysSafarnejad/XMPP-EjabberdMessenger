//
//  MainConversationsViewController.swift
//  MessengerUIKitGeneral
//
//  Created by Safarnejad on 12/11/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit
import XMPPFramework


class MainConversationsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
   
    var chatList = NSArray()

    
    @IBOutlet weak var mainConversationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainConversationsTableView.delegate = self
        mainConversationsTableView.dataSource = self
        mainConversationsTableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    // MARK:- Table view stubs
    
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
    
    
    
    
    @IBAction func actionClicked(_ sender: Any) {
    }
}
