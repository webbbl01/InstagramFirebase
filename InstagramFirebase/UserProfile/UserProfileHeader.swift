//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Blaine on 2/18/18.
//  Copyright © 2018 Blaine. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
  
  
  var user: User? {
    didSet {
      guard let profileImageUrl = user?.profileImageUrl else { return }
      profileImageView.loadImage(urlString: profileImageUrl)
      usernameLabel.text = user?.username
      
      setupEditFollowButton()
    }
  }
  
  fileprivate func setupEditFollowButton() {
    guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
    guard let userId = user?.uid else { return }
    
    if currentLoggedInUserId == userId {
      
    } else {
      //check if following
      Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
        if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
          self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        } else {
          self.setupFollowStyle()
        }
      }, withCancel: { (error) in
        print("Failed to check following:", error)
      })
      
    }
  }
  
  @objc func handleEditProfileOrFollow() {
    
    guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
    guard let userId = user?.uid else { return }
    
    if editProfileFollowButton.titleLabel?.text == "Unfollow" {
      Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue(completionBlock: { (error, reference) in
        if let error = error {
          print("Failed to unfollow user:", error)
          return
        }
        self.setupFollowStyle()
      })
    } else {
      let ref = Database.database().reference().child("following")
      let values = [userId: 1]
      ref.updateChildValues(values) { (error, reference) in
        if let error = error {
          print("Failed to follow user:", error)
          return
        }
        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .white
        self.editProfileFollowButton.setTitleColor(.black, for: .normal)
      }
    }
  }
  
  fileprivate func setupFollowStyle() {
    self.editProfileFollowButton.setTitle("Follow", for: .normal)
    self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
    self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    self.editProfileFollowButton.setTitleColor(.white, for: .normal)
  }
  
  let profileImageView: CustomImageView = {
    let iv = CustomImageView()
    return iv
  }()
  
  let gridButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
    button.tintColor = UIColor(white: 0,alpha: 0.2)
    return button
  }()
  
  let listButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
    button.tintColor = UIColor(white: 0,alpha: 0.2)
    return button
  }()
  
  let bookmarkButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
    button.tintColor = UIColor(white: 0,alpha: 0.2)
    return button
  }()
  
  let usernameLabel: UILabel = {
    let label = UILabel()
    label.text = "username"
    label.font = .boldSystemFont(ofSize: 14)
    return label
  }()
  
  let postsLabel: UILabel = {
    let label = UILabel()
    let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 14)]))
    label.attributedText = attributedText
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  let followersLabel: UILabel = {
    let label = UILabel()
    let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 14)]))
    label.attributedText = attributedText
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  let followingLabel: UILabel = {
    let label = UILabel()
    let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 14)]))
    label.attributedText = attributedText
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  lazy var editProfileFollowButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Edit Profile", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 14)
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.cornerRadius = 3
    button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(profileImageView)
    profileImageView.anchor(top: topAnchor, left: self.leftAnchor, right: nil, bottom: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
    profileImageView.layer.cornerRadius = 80 / 2
    profileImageView.clipsToBounds = true
    
    setupBottomToolBar()
    
    addSubview(usernameLabel)
    usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: gridButton.topAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
    
    setupUserStatsView()
    
    addSubview(editProfileFollowButton)
    editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, right: followingLabel.rightAnchor , bottom: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
    
  }
  
  fileprivate func setupUserStatsView() {
    let stackView = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
    stackView.distribution = .fillEqually
    addSubview(stackView)
    stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, bottom: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
  }
  
  fileprivate func setupBottomToolBar() {
    
    let topDividerView = UIView()
    topDividerView.backgroundColor = .lightGray
    
    let bottomDividerView = UIView()
    bottomDividerView.backgroundColor = .lightGray
    
    
    let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
    stackView.distribution = .fillEqually
    stackView.axis = .horizontal
    addSubview(stackView)
    addSubview(topDividerView)
    addSubview(bottomDividerView)
    
    stackView.anchor(top: nil, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

