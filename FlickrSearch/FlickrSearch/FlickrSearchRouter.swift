//
//  FlickrSearchRouter.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import UIKit

@objc protocol FlickrSearchRoutingLogic {}

protocol FlickrSearchDataPassing {
  var dataStore: FlickrSearchDataStore? { get }
}

class FlickrSearchRouter: NSObject, FlickrSearchRoutingLogic, FlickrSearchDataPassing {
  weak var viewController: FlickrSearchViewController?
  var dataStore: FlickrSearchDataStore?
}
