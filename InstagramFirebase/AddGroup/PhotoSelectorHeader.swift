//
//  PhotoSelectorHeader.swift
//  InstagramFirebase
//
//  Created by Blaine Webb on 2/20/18.
//  Copyright © 2018 Blaine. All rights reserved.
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
  let photoImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(photoImageView)
    photoImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
