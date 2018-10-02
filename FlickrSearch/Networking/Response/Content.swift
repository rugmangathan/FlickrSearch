//
//  Content.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import Foundation

struct Content: Decodable, Equatable {
  let page: Int
  let pages: Int
  let perPage: Int
  let total: String
  let photos: [Photo]

  private enum CodingKeys: String, CodingKey {
    case page
    case pages
    case perPage = "perpage"
    case total
    case photos = "photo"
  }
}
