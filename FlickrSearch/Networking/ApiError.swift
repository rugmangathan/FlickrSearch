//
//  ApiError.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import Foundation

enum ApiError: String, Error {
  case urlIsNil = "Url is nil"
  case dataNotFound = "Response is nil"
  case timedOut = "Session timed out"
  case decodingError = "Json decode failed"
}
