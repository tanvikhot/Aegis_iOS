//
//  ProfileViewController.swift
//  Aegis
//
//  Created by Gaurav Khot on 6/2/19.
//  Copyright © 2019 Tanvi Khot. All rights reserved.
//

import UIKit
import YPImagePicker
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController, UITextFieldDelegate {
    @IBAction func signOffButtonPressed(_ sender: UIButton) {
        do{
        try Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
        }catch{
            print(error)
        }
        
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    var image:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        
        guard let selectedFont = UIFont(name: "Verdana", size: 25) else {
            return
        }
        genderSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : selectedFont,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        genderSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : selectedFont,
            NSAttributedString.Key.foregroundColor: UIColor.orange
            ], for: .selected)
        
    }
    
    @IBAction func imageUpdateButtonPressed(_ sender: UIButton) {
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = true
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library, .photo]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        
        config.library.options = nil
        config.library.onlySquare = true
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                sender.setImage(photo.image, for: .normal)
                self.image = photo.image
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        var ref: DatabaseReference = Database.database().reference()
        guard let image = self.image,
            let imageData = image.pngData() else {
                return
        }
        if let user = Auth.auth().currentUser {
            ref.child("users").child(user.uid).setValue(["name" : nameTextField.text,
                                                         "image" : imageData.base64EncodedString(),
                                                         "gender" : self.genderSegmentedControl.selectedSegmentIndex])
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
