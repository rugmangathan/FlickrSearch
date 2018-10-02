//
//  Photo.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import Foundation

struct Photo: Decodable {
  let id: String
  let owner: String
  let secret: String
  let server: String
  let farm: Int
  let title: String
  let isPublic: Int
  let isFriend: Int
  let isFamily: Int

  private enum CodingKeys: String, CodingKey {
    case id
    case owner
    case secret
    case server
    case farm
    case title
    case isPublic = "ispublic"
    case isFriend = "isfriend"
    case isFamily = "isfamily"
  }
}
