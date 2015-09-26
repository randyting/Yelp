//
//  ButtonTableViewCell.swift
//  Yelp
//
//  Created by Randy Ting on 9/24/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

@objc protocol ButtonTableViewCellDelegate {
  optional func buttonTableViewCell(buttonTableViewCell: ButtonTableViewCell, buttonPressed: Bool)
}

class ButtonTableViewCell: UITableViewCell {
  
  weak var delegate: AnyObject?
  
  @IBOutlet weak var buttonLabel: UILabel!
  @IBOutlet weak var buttonButton: UIButton!
  
  @IBAction func buttonPressed(sender: AnyObject) {
    delegate?.buttonTableViewCell?(self, buttonPressed: true)
  }
  
  var on: Bool! {
    didSet {
      if (on != nil) && on == true {
        buttonButton.tintColor = UIColor.blueColor()
      } else {
        buttonButton.tintColor = UIColor.lightGrayColor()
        
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    layoutMargins = UIEdgeInsetsZero
    separatorInset = UIEdgeInsetsZero
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    self.buttonLabel.text = ""
  }
  
}
