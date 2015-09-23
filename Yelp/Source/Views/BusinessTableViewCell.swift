//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Randy Ting on 9/22/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
  
  @IBOutlet weak var businessImage: UIImageView!
  @IBOutlet weak var businessNameLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var ratingImage: UIImageView!
  @IBOutlet weak var numberOfReviewsLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    layoutMargins = UIEdgeInsetsZero
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
