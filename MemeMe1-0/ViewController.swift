//
//  ViewController.swift
//  MemeMe1-0
//
//  Created by Derek Justus on 8/24/17.
//  Copyright © 2017 Derek Justus. All rights reserved.
//

import UIKit
import Foundation

struct Meme {
    let topText: String?
    let bottomText: String?
    let image: UIImage?
    let memedImage: UIImage?
}

enum BarVisibility {
    case hidden, visible
}

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var navController: UINavigationBar!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        share()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: 2.0]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    func save(meme image: UIImage) {        
       
       // let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: image);
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
    
    func share() {
        toggleBars(toState: .hidden)
        let memedImage = generateMemedImage()

        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        vc.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: Any?, error: Error?) in
            if !completed {
                // User canceled
                return
            }
            if let meme = returnedItems as? UIImage, let activity = activityType {
                if activity != .saveToCameraRoll {
                    self.save(meme: meme)
                }
                 self.toggleBars(toState: .visible)
            }
          
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    func toggleBars(toState state:BarVisibility) {
        switch state {
        case .hidden:
            bottomToolbar.isHidden = true
            navController.isHidden = true;
        case .visible:
            bottomToolbar.isHidden = false
            navController.isHidden = false
        }
    }
    
    
    
   
}

extension ViewController: UIImagePickerControllerDelegate {
    
    private enum PickerType: Int {
        case gallery = 1, camera
    }
    
    @IBAction func pickAnImage(_ sender:AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        let type = PickerType(rawValue: sender.tag)!
        
        switch type {
        case PickerType.camera:
            pickerController.sourceType = .camera
        default:
            pickerController.sourceType = .photoLibrary
        }
        
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePickerView.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = 0
        view.frame.origin.y -= getKeyboardHeight(notification)/2
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
         NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField.tag == 0 {
            bottomTextField.resignFirstResponder()
        } else {
            topTextField.resignFirstResponder()
        }
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = textField.tag == 0 ? "TOP" : "BOTTOM"
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
}
