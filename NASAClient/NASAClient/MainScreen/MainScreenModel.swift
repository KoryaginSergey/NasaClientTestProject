//
//  MainScreenModel.swift
//  NASAClient
//
//  Created by Admin on 09.01.2022.
//  
//

import UIKit


enum Rovers: String {
  case curiosity
  case opportunity
  case spirit
  
  var title: String {
    return self.rawValue.capitalized
  }
  
  var cameras: [Cameras] {
    switch self {
    case .curiosity:
      return [.fhaz, .rhaz, .mast, .chemcam, .mahli, .mardi, .navcam]
    case .opportunity, .spirit:
      return [.fhaz, .rhaz, .navcam, .pancam, .minites]
    }
  }
  
  static var rovers: [Rovers] {
    return [.curiosity, .opportunity, .spirit]
  }
}

enum Cameras: String {
  case all
  case fhaz
  case rhaz
  case mast
  case chemcam
  case mahli
  case mardi
  case navcam
  case pancam
  case minites
  
  var title: String {
    switch self {
    case .all:
      return "All"
    case .fhaz:
      return "Front Hazard Avoidance Camera"
    case .rhaz:
      return "Rear Hazard Avoidance Camera"
    case .mast:
      return "Mast Camera"
    case .chemcam:
      return "Chemistry and Camera Complex"
    case .mahli:
      return "Mars Hand Lens Imager"
    case .mardi:
      return "Mars Descent Imager"
    case .navcam:
      return "Navigation Camera"
    case .pancam:
      return "Panoramic Camera"
    case .minites:
      return "Miniature Thermal Emission Spectrometer (Mini-TES)"
    }
  }
}

// MARK: - MainScreenModelDelegate
protocol MainScreenModelDelegate: AnyObject {
  func modelDidUpdate(model: MainScreenModelProtocol)
  func stateDidUpdate(model: MainScreenModelProtocol)
}

// MARK: - MainScreenModelProtocol
protocol MainScreenModelProtocol: AnyObject {
  var delegate: MainScreenModelDelegate? { get set }
  var photos: [Photo] { get }
  var state: MainScreenModel.State { get }
  
  func roverInputs() -> [String]
  func cameraInputs() -> [String]
  func update()
  
  func setDate(date: Date)
  func setRover(at index: Int)
  func setCamera(at index: Int)
}

// MARK: - MainScreenModel
class MainScreenModel: MainScreenModelProtocol {
  var state: State = .init()
  
  // MARK: - MainScreenModel methods
  weak var delegate: MainScreenModelDelegate?
  private(set) var photos: [Photo] = []
  
  func roverInputs() -> [String] {
    Rovers.rovers.map { $0.title }
  }
  
  func cameraInputs() -> [String] {
    state.rover.cameras.map { $0.title }
  }
  
  func setDate(date: Date) {
    state.date = date
    self.update()
  }
  
  func setRover(at index: Int) {
    state.rover = Rovers.rovers[index]
    if !state.rover.cameras.contains(state.camera) {
      state.camera = .all
    }
    self.update()
  }
  
  func setCamera(at index: Int) {
    state.camera = state.rover.cameras[index]
    self.update()
  }
  
  /** Implement MainScreenModel methods here */
  
  func update() {
    delegate?.stateDidUpdate(model: self)
    PostServices.fetchRequest(by: state.rover, model: .init(earth_date: state.date.toApiString(), camera: state.camera == .all ? nil : state.camera.title)) { [weak self] photos in
      guard let self = self else { return }
      self.photos = photos
      self.delegate?.modelDidUpdate(model: self)
    }
  }
  
  // MARK: - Private methods
}

// MARK: - Extensions
extension MainScreenModel {
  struct State {
    var rover: Rovers = .curiosity
    var camera: Cameras = .all
    var date: Date = Date()
  }
}

// MARK: - Date
private extension Date {
  func toApiString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-DD"
    return dateFormatter.string(from: self)
  }
}
