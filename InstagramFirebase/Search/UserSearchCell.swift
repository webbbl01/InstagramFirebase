//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by Blaine Webb on 2/21/18.
//  Copyright © 2018 Blaine. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
  
  var user: User? {
    didSet {
      usernameLabel.text = user?.username
      guard let profileUrlString = user?.profileImageUrl else { return }
      profileImageView.loadImage(urlString: profileUrlString)
    }
  }
  
  let profileImageView: CustomImageView = {
    let iv = CustomImageView()
    iv.backgroundColor = .red
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  let usernameLabel: UILabel = {
    let label = UILabel()
    label.text = "Username"
    label.font = UIFont.boldSystemFont(ofSize: 14)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(profileImageView)
    addSubview(usernameLabel)
    
    profileImageView.anchor(top: nil, left: leftAnchor, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
    profileImageView.layer.cornerRadius = 50 / 2
    profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
    usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    let separatorView = UIView()
    addSubview(separatorView)
    separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    separatorView.anchor(top: nil, left: usernameLabel.leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
