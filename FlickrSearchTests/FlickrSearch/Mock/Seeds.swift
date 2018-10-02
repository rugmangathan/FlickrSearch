//
//  Seeds.swift
//  FlickrSearchTests
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

@testable import FlickrSearch

struct Seeds {
  struct Flickr {
    static let photos = [
      Photo(
        id: "1",
        owner: "Oliver",
        secret: "skdg9843y98dsfjk",
        server: "900",
        farm: 1,
        title: "Dog",
        isPublic: 0,
        isFriend: 1,
        isFamily: 1
      ),
      Photo(
        id: "2",
        owner: "Jane",
        secret: "skdsjdghksjdhk",
        server: "580",
        farm: 1,
        title: "Dog",
        isPublic: 0,
        isFriend: 1,
        isFamily: 2
      )
    ]

    static let content: Content = Content(
      page: 1,
      pages: 1,
      perPage: 2,
      total: "1",
      photos: photos
    )

    static let flickrResponse: FlickrResponse = FlickrResponse(
      content: content,
      stat: "ok"
    )

    static let viewModel = FlickrSearchModel.ViewModel(
      displayInfo: FlickrSearchModel.ViewModel.DisplayInfo(
        page: content.page,
        urls: photos.map { $0.getImageUrl() }
      )
    )

    static let resetViewModel = FlickrSearchModel.ViewModel(
      displayInfo: FlickrSearchModel.ViewModel.DisplayInfo.init(
        page: 1,
        urls: []
      )
    )
  }
}
