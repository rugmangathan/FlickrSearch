//
//  ApiProtocol.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import Foundation

typealias NetwrokCompletion = (FlickrResponse?, Error?) -> Void

protocol ApiProtocol {
  func search(with text: String, page: Int, completionHandler: @escaping NetwrokCompletion)
  func cancel()
}
