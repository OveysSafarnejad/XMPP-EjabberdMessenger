//
//  ChatViewController.swift
//  MessengerUIKitGeneral
//
//  Created by Safarnejad on 12/29/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import XMPPFramework


class ChatViewController : JSQMessagesViewController, OneMessageDelegate /*, ContactPickerDelegate*/ {
    
    var recipient: XMPPUserCoreDataStorageObject?
    var firstTime = true
    var messages = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        OneMessage.sharedInstance.delegate = self
        
        if OneChat.sharedInstance.isConnected() {
            self.senderId = OneChat.sharedInstance.xmppStream?.myJID?.bare
            self.senderDisplayName = OneChat.sharedInstance.xmppStream?.myJID?.bare
        }
        self.inputToolbar!.contentView!.leftBarButtonItem!.isHidden = true
        self.collectionView!.collectionViewLayout.springinessEnabled = true
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let recipient = recipient {
            
            navigationItem.title = recipient.displayName
            
            if !OneChats.knownUserForJid(jidStr: recipient.jidStr) {
                OneChats.addUserToChatList(jidStr: recipient.jidStr)
            }
            //else {
//                messages = OneMessage.sharedInstance.loadArchivedMessagesFrom(jid: recipient.jidStr, thread: "")
//                finishReceivingMessage(animated: true)
//            }
            
            navigationItem.rightBarButtonItems = []
            navigationItem.title = recipient.displayName
            
            self.messages = OneMessage.sharedInstance.loadArchivedMessagesFrom(jid: recipient.jidStr, thread: "")
            self.collectionView?.reloadData()
        } else {
            
            navigationItem.title = "New message"
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: Selector(("addRecipient"))), animated: true)
            if firstTime {
                firstTime = false
                addRecipient()
            }
        }
        
        
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        _ = JSQMessage(senderId: OneChat.sharedInstance.xmppStream?.myJID?.bare, senderDisplayName: OneChat.sharedInstance.xmppStream?.myJID?.bare, date: NSDate() as Date, text: text)
        //        messages.addObject(fullMessage)
        
        if let recipient = recipient {
            OneMessage.sendMessage(text, thread: "", to: recipient.jidStr, completionHandler: { (stream, message) -> Void in
                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                self.finishSendingMessage(animated: true)
            })
        }
    }
    
    
    func addRecipient() {
        let navController = storyboard?.instantiateViewController(withIdentifier: "contactListNav") as? UINavigationController
        let contactController: ContactListTableViewController? = navController?.viewControllers[0] as? ContactListTableViewController
        //contactController?.delegate = self
        present(navController!, animated: true, completion: nil)
    }
    
    
    //MARK:- OneMessageDelegate
    func oneStream(_ sender: XMPPStream, didReceiveMessage message: XMPPMessage, from user: XMPPUserCoreDataStorageObject) {
        if message.isChatMessageWithBody {
            JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
            
            if let msg: String = message.forName("body")?.stringValue {
                if let from: String = message.attribute(forName: "from")?.stringValue {
                    let message = JSQMessage(senderId: from, senderDisplayName: from, date: NSDate() as Date, text: msg)
                    messages.add(message!)
                    self.finishReceivingMessage(animated: true)
                }
            }
        }
    }
    
    func oneStream(_ sender: XMPPStream, userIsComposing user: XMPPUserCoreDataStorageObject) {
        self.showTypingIndicator = !self.showTypingIndicator
        self.scrollToBottom(animated: true)
    }

    
    //MARK:- JSQMessageViewController delegates
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        let message: JSQMessage = self.messages[indexPath.item] as! JSQMessage
        
        return message
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {

        let message: JSQMessage = self.messages[indexPath.item] as! JSQMessage
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        let outgoingBubbleImageData = bubbleFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        let incomingBubbleImageData = bubbleFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        
        if message.senderId == self.senderId {
            return outgoingBubbleImageData
        }
        
        return incomingBubbleImageData
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message: JSQMessage = self.messages[indexPath.item] as! JSQMessage
        
        if message.senderId == self.senderId {
            if let photoData = OneChat.sharedInstance.xmppvCardAvatarModule?.photoData(for: (OneChat.sharedInstance.xmppStream?.myJID)!) {
                let senderAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(data: photoData), diameter: 30)
                return senderAvatar
            } else {
                let senderAvatar = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "SR", backgroundColor: UIColor(white: 0.85, alpha: 1.0), textColor: UIColor(white: 0.60, alpha: 1.0), font: UIFont(name: "Helvetica Neue", size: 14.0), diameter: 30)
                return senderAvatar
            }
        } else {
            if let photoData = OneChat.sharedInstance.xmppvCardAvatarModule?.photoData(for: recipient!.jid!) {
                let recipientAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(data: photoData), diameter: 30)
                return recipientAvatar
            } else {
                let recipientAvatar = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "SR", backgroundColor: UIColor(white: 0.85, alpha: 1.0), textColor: UIColor(white: 0.60, alpha: 1.0), font: UIFont(name: "Helvetica Neue", size: 14.0)!, diameter: 30)
                return recipientAvatar
            }
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let message: JSQMessage = self.messages[indexPath.item] as! JSQMessage
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        
        return nil;
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message: JSQMessage = self.messages[indexPath.item] as! JSQMessage
        
        if message.senderId == self.senderId {
            return nil
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage: JSQMessage = self.messages[indexPath.item - 1] as! JSQMessage
            if previousMessage.senderId == message.senderId {
                return nil
            }
        }
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        return nil
    }
    
    
    
    // MARK:- UICollectionView DataSource
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: JSQMessagesCollectionViewCell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let msg: JSQMessage = self.messages[indexPath.item] as! JSQMessage
        
        if !msg.isMediaMessage {
            if msg.senderId == self.senderId {
                cell.textView!.textColor = UIColor.black
                cell.textView!.linkTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            } else {
                cell.textView!.textColor = UIColor.white
                cell.textView!.linkTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            }
        }
        
        return cell
    }
    
    // Mark: JSQMessages collection view flow layout delegate
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let currentMessage: JSQMessage = self.messages[indexPath.item] as! JSQMessage
        if currentMessage.senderId == self.senderId {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage: JSQMessage = self.messages[indexPath.item - 1] as! JSQMessage
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 0.0
    }

}
