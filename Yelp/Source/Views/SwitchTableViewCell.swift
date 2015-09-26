//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by Randy Ting on 9/23/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

@objc protocol SwitchTableViewCellDelegate {
  optional func switchTableViewCell(switchTableViewCell: SwitchTableViewCell, switchValueChangedTo: Bool)
}

class SwitchTableViewCell: UITableViewCell {
  
  weak var delegate: AnyObject?
 
  @IBOutlet weak var switchLabel: UILabel!
  @IBOutlet weak var selectSwitch: UISwitch!
  
  
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
    self.textLabel!.text = ""
    self.switchLabel.text = ""
  }
  
  @IBAction func onSwitchValueChanged(sender: AnyObject) {
    delegate?.switchTableViewCell?(self, switchValueChangedTo: selectSwitch.on)
  }

  
  
}
