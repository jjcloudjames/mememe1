//
//  ViewController.swift
//  memeasy
//
//  Created by James Wolke on 4/11/17.
//  Copyright © 2017 James Wolke. All rights reserved.

//  excercise meme lesson 4: v1.0 mememe application.
//  programs runs, no errors. Runs on portrait or landscape iphone 6s.
//  xcode 8.0 Swift 3.0

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    //view for images
    @IBOutlet weak var imagePickerView: UIImageView!
    
    //add text buttons
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!

    @IBOutlet weak var cameraButton: UIBarButtonItem!

    @IBOutlet weak var toolbarBottom: UIToolbar!

    //Add outlets to control visability

    //share button to capture memed image with text
    @IBOutlet weak var shareButton: UIBarButtonItem!
    

    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    //define attibutes for text fields
    let multipleAttributes: [String:Any]! = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 28)!,
        NSStrokeWidthAttributeName: -4.0
                                    
    ]
    
    
   // set text styles, locate image, and disable share button on view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextStyle(textField: textTop)
        setTextStyle(textField: textBottom)
        imagePickerView.frame.origin.y = 0
        self.shareButton.isEnabled = false
        
    }
    
    
    // define text fields alignment, style, and attributes
    func setTextStyle(textField:UITextField) {
        
        textTop.text = (" Add Text ")
        textBottom.text = (" Add Text ")
        textTop.textAlignment = .center
        textBottom.textAlignment = .center
        textTop.borderStyle = UITextBorderStyle.none
        textBottom.borderStyle = UITextBorderStyle.none
        textTop.defaultTextAttributes = multipleAttributes
        textBottom.defaultTextAttributes = multipleAttributes
        textTop.delegate = self
        textBottom.delegate = self
        self.shareButton.isEnabled = false
        
    }

    
    // view to appear and keyboard notification setup
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.subscribeToKeyboardNotifications()
    
    }
    
    // view disappears and closes keyboard notifications
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.subscribeToKeyboardWillHideNotifications()
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Share meme button to define an instance of the activityview controller, present the activityviewcontroller
     @IBAction func shareMemeButton(_ sender: AnyObject) {

        let memedImage = self.generateMemedImage()

        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        self.present(activityVC, animated: true, completion: nil)
        
        //activityviewcontroller to handle completion and call save function
        activityVC.completionWithItemsHandler = { UIActivity, completed, items, error in
            
            if completed {
                NSLog("The Activity: %@ was completed", activityVC);
                self.save(memedImage: memedImage)
                self.dismiss(animated: true, completion: nil)
                print("show and tell")
            }
            else {
                print("user canceled sharing :(")
            }
        }
        
    }
    
    // generate meme image and return to share function
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.draw(self.view.frame)
        //self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    // save meme image with text
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: textTop.text!, bottomText: textBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
    }
    
     // button press for photo or camera, added message note for inoperable camera
    @IBAction func pickAnimage(_ sender: UIBarButtonItem) {

        if (sender.tag == 0) {
            configureImagePicker(Type: .camera)
        }
        else {
            configureImagePicker(Type: .photoLibrary)
        }
       

    }
    
    //define source
    func configureImagePicker(Type: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        //imagePicker.sourceType = Type

        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
        self.shareButton.isEnabled = true
        self.toolbarBottom.isHidden = false
    }
    
    
    //message function to indicated missing camera functionality
    func noCamera(optDev: String){
        if optDev == "camera" {
            let alertVC = UIAlertController(
                title: "No Camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: true,
                completion: nil)
        }
        else {
            let alertVC = UIAlertController(
                title: "No Album",
                message: "Future application",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: true,
                completion: nil)
        }
    }

     // defines the image for selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let jimage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePickerView.contentMode = .scaleAspectFit
        imagePickerView.image = jimage
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //next functions define keyboard displacement for access to text editing.
    func keyboardWillShow(notification:  NSNotification){
        if textBottom.isFirstResponder {
            self.view.frame.origin.y = getKeyboardHeight(notification: notification) * -1
        }
          }
 
    // shift the view back to original position
    func keyboardWillHide(_ notification: NSNotification) {
        if textBottom.isFirstResponder {
            self.view.frame.origin.y = 0
        }
    }
 
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as!NSValue
        return keyboardSize.cgRectValue.height
        
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
}

