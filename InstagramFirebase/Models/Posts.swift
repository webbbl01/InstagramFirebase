//
//  Posts.swift
//  InstagramFirebase
//
//  Created by Blaine Webb on 2/20/18.
//  Copyright © 2018 Blaine. All rights reserved.
//

import Foundation

struct Post {
  let imageUrl: String
  let user: User
  let caption: String
  
  init(user: User, dictionary: [String: Any]) {
    self.user = user
    self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    self.caption = dictionary["caption"] as? String ?? ""
  }
}
