//
//  ViewController.swift
//  memeasy
//
//  Created by James Wolke on 4/11/17.
//  Copyright © 2017 James Wolke. All rights reserved.

//  excercise meme lesson 4: v1.0 mememe application.
//  programs runs, no errors. Runs on portrait iphone 6s.
//  suggested improvements: aspect ratio to iphone full screen.
//     keyboard return after text input.
//     share button location and hidden attributes

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    //view for images
    @IBOutlet weak var imagePickerView: UIImageView!
    
    //add text buttons
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!

    //Add outlets to control visability
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var toolBar2: UIToolbar!
    @IBOutlet weak var toolBar3: UIToolbar!
    
    //share button to capture memed image with text
    @IBOutlet weak var shareButton: UIButton!

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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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

        setTextStyle(textField: textTop)
        setTextStyle(textField: textBottom)

    }
    
    // view to appear and keyboard notification setup
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.subscribeToKeyboardNotifications()

    }
    
    // view disappears and closes keyboard notifications
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
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
                print("Bad user canceled sharing :(")
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
        
 //NOTE: I was interested in saving the meme to the document folder but error indicated cannot change image to UIImageview, please comment, or also cannot call value of non-function type viewcontroller.Meme
  
        
 //future consideration for saving image
        let imageData = meme.memedImage
        
        let fileManager = FileManager.default
      
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
        
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }
        else {
            print("Already dictionary created.")
        }
    
//future consideration for saving image
//        do {
////            //Save image to Root
//        try imageData(to: paths, options: .atomic)
//
//        print("Saved To Root")
//
//        } catch let error {
//
//            print(error)
//
//        }
    
        //restore toolbar buttons for photo album and camera
        self.toolBar.isHidden = false
        self.toolBar2.isHidden = false
        self.toolBar3.isHidden = false

        
    }
    
    //no camera currently for future defintion
    @IBAction func pickCameraImage(_ sender: Any) {
        let device = ("cam")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            present(imagePicker, animated:  true, completion: nil)
        }
        else {
            noCamera(optDev: device)
        }

    }
    // no album currently for future definition
    @IBAction func pickAnAlbumImage(_ sender: AnyObject) {
        let device = ("pho")
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        present(imagePicker, animated:  true, completion: nil)
//        }
//        else {
        noCamera(optDev: device)
//        }
    }
    
    // photo function for pick of simulator images, currently an error on the Moments selection, only shows Wednesday Thursday, Yesterday and Today, not sure how to reset
    @IBAction func PickAnimage(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
        self.toolBar.isHidden = true
        self.toolBar2.isHidden = true
        self.toolBar3.isHidden = true
        
        self.shareButton.isEnabled = true
       
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
    
    //message function to indicated missing album and camera functionality
    func noCamera(optDev: String){
        if optDev == "cam" {
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
    

    
    //next functions define keyboard displacement for access to text editing.  some errors is displacement and reinstatment.  Need to idenify locations and reset capability
    func keyboardWillShow(notification:  NSNotification){
        if textBottom.isFirstResponder {
            self.view.frame.origin.y = getKeyboardHeight(notification: notification)
                * -1
        }
        
        //self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if textBottom.isFirstResponder {
            self.view.frame.origin.y = 0
            
        }
        //self.view.frame.origin.y += getKeyboardHeight(notification: notification)
   
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as!NSValue
        return keyboardSize.cgRectValue.height
        
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil) }
    
}

