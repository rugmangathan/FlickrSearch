//
//  FlickrSearchCell.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import UIKit

class FlickrSearchCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!

  override func prepareForReuse() {
    imageView.image = UIImage()
    super.prepareForReuse()
  }
}
