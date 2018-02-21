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

protocol Presenter: class {
    func dismiss()
}

class CreateMemeViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var navController: UINavigationBar!
    @IBOutlet weak var shareButton: UIButton!
    
    weak var delegate: Presenter?
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        share()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        if let vc = delegate {
            vc.dismiss()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeify(text: topTextField)
        memeify(text: bottomTextField)
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
    
    func memeify(text: UITextField) {
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -2.0]
        
        text.defaultTextAttributes = memeTextAttributes
        text.textAlignment = .center

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
       
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: image);
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func share() {
        guard imagePickerView.image != nil else {
            return
        }
            
        toggleBars(toState: .hidden)
        let memedImage = generateMemedImage()
        self.save(meme: memedImage)
        toggleBars(toState: .visible)
        
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        vc.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: Any?, error: Error?) in
            if !completed {
                // User canceled, so nada
                return
            }
            //  returned items is nil now, so not saving as a result
//            if let meme = returnedItems as? UIImage {
//                self.save(meme: memedImage)
//                return
//            }
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

extension CreateMemeViewController: UIImagePickerControllerDelegate {
    
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

extension CreateMemeViewController: UITextFieldDelegate {
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
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
        NotificationCenter.default.removeObserver(self)
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
