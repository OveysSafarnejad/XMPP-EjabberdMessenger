//
//  TableViewCell.swift
//  AviationMessenger
//
//  Created by Safarnejad on 11/13/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit

class SettingMenuCell: UITableViewCell {
    

    @IBOutlet weak var settingMenuButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(menuText : String) {
        self.selectionStyle = .none
        settingMenuButton.setImage(UIImage.init(named: menuText), for: .normal)
        settingMenuButton.setTitle(menuText, for: .normal)
        settingMenuButton.imageEdgeInsets.right = 20
        settingMenuButton.titleEdgeInsets.left = 20
        settingMenuButton.setTitleColor(.black , for: .normal)
    }

}
