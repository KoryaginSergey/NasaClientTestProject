//
//  MainScreenDataSource.swift
//  NASAClient
//
//  Created by Admin on 09.01.2022.
//  
//

import UIKit
import SDWebImage


// MARK: - MainScreenDataSource
class MainScreenDataSource: NSObject, UITableViewDataSource {
  weak var cellDelegate: MainScreenCellDelegate?
  private let model: MainScreenModelProtocol
  
  init(withModel model: MainScreenModelProtocol) {
    self.model = model
  }
  
  func registerNibsForTableView(tableView: UITableView) {
    MainScreenTableViewCell.register(for:tableView)
  }
  
  // MARK: - Private methods
  func configure(cell: MainScreenTableViewCell, forItem item: Photo) {
    cell.roverLabel.text = "Rover: " + item.rover.name
    cell.cameraLabel.text = "Camera: " +  item.camera.fullName
    cell.dateLabel.text = "Date: " + item.earthDate
    cell.photoImageView.sd_setImage(with: URL(string: item.imgSrc))
  }
  
  // MARK: - UITableViewDataSource
  internal func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.model.photos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.deque(for: indexPath) as MainScreenTableViewCell
    cell.delegate = cellDelegate
    
    let testItem = self.model.photos[indexPath.row];
    self.configure(cell: cell, forItem: testItem)
    
    return cell
  }
}

