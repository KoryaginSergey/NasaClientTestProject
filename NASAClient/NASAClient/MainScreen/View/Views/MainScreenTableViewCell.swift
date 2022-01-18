//
//  MainScreenTableViewCell.swift
//  NASAClient
//
//  Created by Admin on 09.01.2022.
//  
//

import UIKit


// MARK: - MainScreenTableViewCell
class MainScreenTableViewCell: UITableViewCell {
  weak var delegate: MainScreenCellDelegate?
  
  @IBOutlet weak var roverLabel: UILabel!
  @IBOutlet weak var cameraLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var photoImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  // MARK: - IBAction
}

// MARK: - MainScreenCellDelegate
protocol MainScreenCellDelegate: NSObjectProtocol {
  
}

