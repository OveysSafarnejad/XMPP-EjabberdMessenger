//
//  ContactListTableViewController.swift
//  MessengerUIKitGeneral
//
//  Created by Safarnejad on 12/29/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit
import XMPPFramework

protocol ContactPickerDelegate {
    func didSelectContact(recipient: XMPPUserCoreDataStorageObject)
}


class ContactListTableViewController: UITableViewController, OneRosterDelegate {
   
    var delegate:ContactPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OneRoster.sharedInstance.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        OneRoster.sharedInstance.delegate = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return OneRoster.buddyList.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = OneRoster.buddyList.sections
        if section < sections!.count {
            let sectionInfo: AnyObject = sections![section]
            return sectionInfo.numberOfObjects
        }
        return 0;
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sections = OneRoster.sharedInstance.fetchedResultsController()!.sections
        
        if section < sections!.count {
            let sectionInfo: AnyObject = sections![section]
            let tmpSection: Int = Int(sectionInfo.name)!
            
            switch (tmpSection) {
            case 0 :
                return "Available"
                
            case 1 :
                return "Away"
                
            default :
                return "Offline"
                
            }
        }
        
        return ""
    }
  
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ContactListCell", for: indexPath)
        let user = OneRoster.userFromRosterAtIndexPath(indexPath: indexPath)
        
        cell!.textLabel!.text = user.displayName;
        
        if user.unreadMessages.intValue > 0 {
            cell!.backgroundColor = .orange
        } else {
            cell!.backgroundColor = .white
        }
        OneChat.sharedInstance.configurePhotoForCell(cell!, user: user)
        
        return cell!;
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //delegate?.didSelectContact(recipient: OneRoster.userFromRosterAtIndexPath(indexPath: indexPath))
        var chatViewController = UIStoryboard.init(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "SingleChatViewController") as! ChatViewController
        chatViewController.recipient = OneRoster.userFromRosterAtIndexPath(indexPath: indexPath)
        chatViewController.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(chatViewController, animated: true)
        
    }
   
    
    
    //MARK:- Actions
    @IBAction func close(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    
    //MARK :- OneRoosterDelegate
    func oneRosterContentChanged(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}
