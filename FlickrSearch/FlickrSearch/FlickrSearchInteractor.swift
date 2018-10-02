//
//  FlickrSearchInteractor.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import Foundation

protocol FlickrSearchBusinessLogic: class {
  func fetch(_ resquest: FlickrSearchModel.Request)
}

class FlickrSearchInteractor: FlickrSearchBusinessLogic {
  weak var presenter: FlickrSearchPresentationLogic?
  lazy var worker: FlickrSearchWorker = FlickrSearchWorker()

  func fetch(_ resquest: FlickrSearchModel.Request) {
    worker.search(with: resquest.searchTerm, page: resquest.page) { (response, errror) in
      self.presenter?.present(
        response: FlickrSearchModel.Response(photoContent: response!.content)
      )
    }
  }
}
