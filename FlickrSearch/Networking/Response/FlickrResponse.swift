//
//  FlickrResponse.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import Foundation

struct FlickrResponse: Decodable, Equatable {
  let content: Content
  let stat: String

  private enum CodingKeys: String, CodingKey {
    case content = "photo"
    case stat
  }
}
