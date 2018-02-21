//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Blaine Webb on 2/20/18.
//  Copyright © 2018 Blaine. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
  
  var selectedImage: UIImage? {
    didSet {
      self.imageView.image = selectedImage
    }
  }
  
  override func viewDidLoad() {
    view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    setupImageAndTextViews()
  }
  
  let imageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  let textView: UITextView = {
    let tv = UITextView()
    tv.font = .systemFont(ofSize: 14)
    return tv
  }()
  
  fileprivate func setupImageAndTextViews() {
    let containerView = UIView()
    containerView.backgroundColor = .white
    
    view.addSubview(containerView)
    containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    
    containerView.addSubview(imageView)
    imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: nil, bottom: containerView.bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
    
    containerView.addSubview(textView)
    textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, right: containerView.rightAnchor, bottom: containerView.bottomAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }
  
  @objc func handleShare() {
    guard let caption = textView.text, textView.hasText else {
      self.navigationItem.rightBarButtonItem?.isEnabled = true
      return
      
    }
    guard let image = selectedImage else { return }
    guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
    navigationItem.rightBarButtonItem?.isEnabled = false
    
    let filename = NSUUID().uuidString
    Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metaData, error) in
      if let error = error {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        print("Error uploading post image:", error)
        return
      }
      guard let imageUrl = metaData?.downloadURL()?.absoluteString else { return }
      self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
    }
  }
  
  fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
    guard let postImage = selectedImage else { return }
    guard let caption = textView.text else { return }
    guard let uid = Auth.auth().currentUser?.uid else { return }
    let userPostRef = Database.database().reference().child("posts").child(uid)
    let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String: Any]
    let ref = userPostRef.childByAutoId()
    
    ref.updateChildValues(values) { (error, reference) in
      if let error = error {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        print("Error saving to DB:", error)
        return
      }
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
