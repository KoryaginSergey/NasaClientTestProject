//
//  MainScreenViewController.swift
//  NASAClient
//
//  Created by Admin on 09.01.2022.
//  
//

import UIKit


// MARK: - MainScreenViewController
class MainScreenViewController: UIViewController, UITableViewDelegate {
  var model: MainScreenModelProtocol
  private var dataSource: MainScreenDataSource
  fileprivate var tempView: MainScreenViewProtocol?
  var customView: MainScreenViewProtocol! {
    return self.view as? MainScreenViewProtocol
  }
  
  // MARK: - Initializers
  init(withView view: MainScreenViewProtocol, model: MainScreenModelProtocol, dataSource: MainScreenDataSource) {
    self.model = model
    self.dataSource = dataSource
    self.tempView = view
    
    super.init(nibName: nil, bundle: nil)
    
    self.model.delegate = self
    self.dataSource.cellDelegate = self
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("This class needs to be initialized with init(withView:model:) method")
  }
  
  // MARK: - View life cycle
  override func loadView() {
    super.loadView()
    self.view = self.tempView
    self.tempView = nil
    self.model.update()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.customView.delegate = self
    self.connectTableViewDependencies()
  }
  
  private func connectTableViewDependencies() {
    self.customView.tableView.delegate = self
    self.dataSource.registerNibsForTableView(tableView: self.customView.tableView)
    self.customView.tableView.dataSource = self.dataSource
    self.customView.tableView.estimatedRowHeight = 100
    self.customView.tableView.rowHeight = UITableView.automaticDimension
  }
  
  // MARK: - Table view delegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - MainScreenViewDelegate
extension MainScreenViewController: MainScreenViewDelegate {
  func viewDidSelectPicker(index: Int, type: HeaderType) {
    if type == .rover {
      self.model.setRover(at: index)
    }
    
    if type == .camera {
      self.model.setCamera(at: index)
    }
  }
  
  func viewDidSelectPicker(date: Date) {
    self.model.setDate(date: date)
  }
  
  func viewDidTapButton(type: HeaderType, view: MainScreenViewProtocol) {
    let state = self.model.state
    
    switch type {
    case .rover:
      customView.showPicker(inputs: self.model.roverInputs(), type: type)
    case .camera:
      customView.showPicker(inputs: self.model.cameraInputs(), type: type)
    case .date:
      customView.showPicker(date: state.date)
    }
  }
}

// MARK: - MainScreenModelDelegate
extension MainScreenViewController: MainScreenModelDelegate {
  func modelDidUpdate(model: MainScreenModelProtocol) {
    customView.tableView.reloadData()
  }
  
  func stateDidUpdate(model: MainScreenModelProtocol) {
    customView.state = .init(roverTitle: model.state.rover.title,
                             cameraTitle: model.state.camera.title,
                             dateTitle: model.state.date.toDisplayString())
  }
}

// MARK: - MainScreenCellDelegate
extension MainScreenViewController: MainScreenCellDelegate {
  func cellDidTapSomeButton(cell: MainScreenTableViewCell) {
  }
}

// MARK: - Date
private extension Date {
  func toDisplayString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    return dateFormatter.string(from: self)
  }
}

