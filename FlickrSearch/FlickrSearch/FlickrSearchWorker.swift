//
//  FlickrSearchWorker.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import Foundation

class FlickrSearchWorker{
  lazy var flickrApi: ApiProtocol = FlickrApi()

  func search(with text: String, page: Int, coimpletionHandler: @escaping NetwrokCompletion) {
    flickrApi.search(with: text, page: page) { (response, error) in
      coimpletionHandler(response, error)
    }
  }

  func cancel() {
    flickrApi.cancel()
  }
}
