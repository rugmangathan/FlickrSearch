//
//  FlickrSearchModel.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import Foundation

enum FlickrSearchModel {
  struct Request {
    let searchTerm: String
    let page: Int
  }
  struct Response {
    var photoContent: Content
  }

  struct ViewModel: Equatable {
    struct DisplayInfo: Equatable {
      let page: Int
      let urls: [URL]
    }

    let displayInfo: DisplayInfo
  }
}
