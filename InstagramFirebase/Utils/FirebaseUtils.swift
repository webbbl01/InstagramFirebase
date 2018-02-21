//
//  FirebaseUtils.swift
//  InstagramFirebase
//
//  Created by Blaine Webb on 2/21/18.
//  Copyright © 2018 Blaine. All rights reserved.
//

import Foundation
import Firebase

extension Database {
  static func fetchUserWithUID(uid: String, completion: @escaping(User) -> Void) {
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      guard let userDictionary = snapshot.value as? [String: Any] else {
        return
      }
      let user = User(uid: uid, dictionary: userDictionary)
      completion(user)
    }) { (error) in
      print(error)
    }
  }
}
