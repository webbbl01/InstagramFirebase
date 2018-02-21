//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Blaine Webb on 2/20/18.
//  Copyright © 2018 Blaine. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  let cellId = "cellId"
  var posts = [Post]()
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = .white
    
    collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
    
    setupNavigationItems()
    fetchPosts()
  }
  
  fileprivate func fetchPosts() {
    guard let uid = Auth.auth().currentUser?.uid else {
      return
    }
    Database.fetchUserWithUID(uid: uid) { (user) in
      self.fetchPostsWithUser(user: user)
    }
  }
  
  fileprivate func fetchPostsWithUser(user: User) {
    let ref = Database.database().reference().child("posts").child(user.uid)
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
      guard let dictionaries = snapshot.value as? [String: Any] else { return }
      dictionaries.forEach({ (key, value) in
        
        guard let dictionary = value as? [String: Any] else { return }
        let post = Post(user: user, dictionary: dictionary)
        self.posts.append(post)
      })
      self.collectionView?.reloadData()
    }) { (error) in
      print("Failed to fetch posts:", error)
    }
  }
  
  func setupNavigationItems() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var height: CGFloat = 40 + 8 + 8 //username + userprofile view
    height += view.frame.width
    height += 50
    height += 60
    
    return CGSize(width: view.frame.width, height: height)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
    
    cell.post = posts[indexPath.item]
    return cell
  }
  
}
