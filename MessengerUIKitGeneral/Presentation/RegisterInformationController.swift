//
//  RegisterInformationController.swift
//  MessengerUIKitT
//
//  Created by Safarnejad on 12/5/18.
//  Copyright © 2018 Borna. All rights reserved.
//

import UIKit
import XMPPFramework

class RegisterInformationController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var familyTextField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    let doneBtn = UIBarButtonItem(title: "Enjoy!", style: .plain, target: self, action: #selector(doneBtnTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    
    // MARK:- Keyboard effect
    @objc func viewTapped(sender: UITapGestureRecognizer? = nil) {
        nameTextField.resignFirstResponder()
        familyTextField.resignFirstResponder()
    }

    
    // MARK:- TextFields
    @objc func textFieldDidChange(_ textField: UITextField) {
        if !(nameTextField.text?.isEmpty)! || !(familyTextField.text?.isEmpty)! {
            doneBtn.isEnabled = true
        } else {
            doneBtn.isEnabled = false
        }
    }
    
    
    
    // MARK:- Image Upload
    
    @objc func pictureTapped(sender: UITapGestureRecognizer? = nil) {
        
        viewTapped()
        
        let alert:UIAlertController=UIAlertController(title: "Profile Picture Options", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let gallaryAction = UIAlertAction(title: "Open Gallary", style: UIAlertAction.Style.default){
            UIAlertAction in self.openGallary()
        }
        
        let deleteImageAction = UIAlertAction(title: "Remove", style: UIAlertAction.Style.destructive){
            UIAlertAction in self.removePic()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        let defaultProfileImage = UIImage(named: "default profile picture.png")
        
        if (!(profileImageView.image?.isEqual(defaultProfileImage))!){
            alert.addAction(deleteImageAction)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openGallary() {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func removePic() {
       profileImageView.image = UIImage(named: "default profile picture.png")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.contentMode = .scaleToFill
            profileImageView.image = pickedImage
            profileImageView.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- utility
    @objc func doneBtnTapped() {
        
        //navigate to main channels controller to view all chats and etc.
        //apply for create a new user to server
        //then user should navigate to his chat view
        //of course at first its empty with an start chat button
        
        let mainTabBar : UIViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewTabBar")
        let navigationController = UINavigationController(rootViewController: mainTabBar)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }

    
    
    func setUp() {
        doneBtn.isEnabled = false
        navigationItem.rightBarButtonItem = doneBtn
        nameTextField.delegate = self
        familyTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        familyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let gestuere = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        gestuere.delegate = self
        self.view.addGestureRecognizer(gestuere)
        
        profileImageView.layer.cornerRadius = self.view.frame.width * 0.3/2

        let pictureGesture = UITapGestureRecognizer(target: self, action: #selector(pictureTapped));        self.profileImageView.addGestureRecognizer(pictureGesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    
}
