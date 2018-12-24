//
//  SettingViewController.swift
//  MessengerUIKitGeneral
//
//  Created by Safarnejad on 12/19/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController , UITableViewDataSource ,
UITableViewDelegate  {

    @IBOutlet weak var settingTable: UITableView!
    var menus = ["Account" , "Conversation" , "Notification" , "Data and Storage" , "Help"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.separatorStyle = .none
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingMenuCell", for: indexPath) as? SettingMenuCell {
            cell.configureCell(menuText: menus[indexPath.row])
            cell.selectionStyle = .none
            return cell
        } else {
            
            return SettingMenuCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //tableView.register(UINib(nibName: "yourNib", bundle: nil), forCellReuseIdentifier: "SettingMenuCell")
}
