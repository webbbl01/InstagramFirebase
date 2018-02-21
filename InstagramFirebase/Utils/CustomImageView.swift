//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Blaine Webb on 2/20/18.
//  Copyright © 2018 Blaine. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
  
  var lastURLUsedToLoadImage: String?
  
  func loadImage(urlString: String) {
    
    lastURLUsedToLoadImage = urlString
    
    if let cachedImage = imageCache[urlString] {
      self.image = cachedImage
    }
    
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print(error)
        return
      }
      
      if url.absoluteString != self.lastURLUsedToLoadImage { return }
      
      guard let imageData = data else { return }
      let photoImage = UIImage(data: imageData)
      
      imageCache[url.absoluteString] = photoImage
      
      DispatchQueue.main.async {
        self.image = photoImage
      }
      }.resume()
  }
}
