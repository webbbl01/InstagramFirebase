//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by Blaine Webb on 2/20/18.
//  Copyright © 2018 Blaine. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
  
  var post: Post? {
    didSet {
      guard let postImageUrl = post?.imageUrl else { return }
      photoImageView.loadImage(urlString: postImageUrl)
      usernameLabel.text = post?.user.username
      guard let profileImageUrl = post?.user.profileImageUrl else { return }
      userProfileImageView.loadImage(urlString: profileImageUrl)
      setupAttributedCaption()
    }
  }
  
  fileprivate func setupAttributedCaption() {
    guard let post = self.post else { return }
    
    
    let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
    attributedText.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.systemFont(ofSize: 4)]))
    attributedText.append(NSAttributedString(string: "1 week ago", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.gray]))
    captionLabel.attributedText = attributedText
  }
  
  let photoImageView: CustomImageView = {
    let iv = CustomImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  let userProfileImageView: CustomImageView = {
    let iv = CustomImageView()
    iv.contentMode = .scaleAspectFill
    iv.backgroundColor = .blue
    iv.clipsToBounds = true
    return iv
  }()
  
  let usernameLabel: UILabel = {
    let label = UILabel()
    label.text = "Username"
    label.font = UIFont.boldSystemFont(ofSize: 14)
    return label
  }()
  
  let optionsButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("•••", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  let likeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let commentButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let sendMessageButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let bookmarkButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let captionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(photoImageView)
    addSubview(userProfileImageView)
    addSubview(usernameLabel)
    addSubview(optionsButton)
    optionsButton.anchor(top: topAnchor, left: nil, right: rightAnchor, bottom: photoImageView.topAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 0)
    userProfileImageView.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
    userProfileImageView.layer.cornerRadius = 40 / 2
    
    usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, right: optionsButton.leftAnchor, bottom: photoImageView.topAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    
    setupActionButtons()
    addSubview(captionLabel)
    captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
  }
  
  fileprivate func setupActionButtons() {
    let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton, sendMessageButton])
    stackView.distribution = .fillEqually
    addSubview(stackView)
    stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
    
    addSubview(bookmarkButton)
    bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 50)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) not implemented")
  }
  
}
