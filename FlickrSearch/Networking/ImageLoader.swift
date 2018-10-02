//
//  ImageLoader.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import UIKit

class ImageLoader {
  let imageCache: NSCache = NSCache<NSString, AnyObject>()
  private var task: URLSessionTask?

  func loadImage(url: URL, completion: @escaping (_ image: UIImage) -> Void) {
    // check cached image
    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
      DispatchQueue.main.async {
        completion(cachedImage)
      }
      return
    }

    // if not, download image from url
    task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      if error != nil {
        print(error!)
        return
      }

      guard let imageData = data else { return }
      DispatchQueue.main.async {
        if let image = UIImage(data: imageData) {
          self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
          completion(image)
        }
      }
    }

    task?.resume()
  }

  func cancel() {
    task?.cancel()
  }
}
