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
  
  @IBOutlet weak var selectSwitch: UISwitch!
  @IBOutlet weak var switchLabel: UILabel!
  @IBOutlet weak var switchHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var switchBottomToContentViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var switchTopToContentViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var seeAllLabel: UILabel!
  
  
  var shouldCollapse: Bool = true{
    didSet {
      if shouldCollapse {
        collapse()
      } else {
        expand()
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    layoutMargins = UIEdgeInsetsZero
    separatorInset = UIEdgeInsetsZero
  }
  
  
  func collapse() {
    switchTopToContentViewConstraint.constant = 0
    switchBottomToContentViewConstraint.constant = 0
    switchHeightConstraint.constant = 0
  }
  
  func expand() {
    switchTopToContentViewConstraint.constant = 10
    switchBottomToContentViewConstraint.constant = 10
    switchHeightConstraint.constant = 31
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
