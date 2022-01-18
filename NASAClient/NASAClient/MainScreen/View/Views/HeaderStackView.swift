//
//  HeaderStackView.swift
//  NASAClient
//
//  Created by Admin on 16.01.2022.
//

import Foundation
import UIKit


enum HeaderType {
  case rover
  case camera
  case date
  
  var buttonTitle: String {
    switch self {
    case .rover:
      return "Rover"
    case .camera:
      return "Camera"
    case .date:
      return "Date"
    }
  }
}

class HeaderStackView: UIStackView {
  struct State {
    let title: String?
  }
  
  var views: [HeaderView] = []
  var tapCompletion: ((HeaderType?) -> ())?
  var roverState: State? {
    didSet {
      let rover = view(by: .rover)
      rover?.state?.title = roverState?.title
    }
  }
  
  var cameraState: State? {
    didSet {
      let camera = view(by: .camera)
      camera?.state?.title = cameraState?.title
    }
  }
  
  var dateState: State? {
    didSet {
      let date = view(by: .date)
      date?.state?.title = dateState?.title
    }
  }
  
  init(completion: ((HeaderType?) -> ())?) {
    super.init(frame: .zero)
    tapCompletion = completion
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
}

private extension HeaderStackView {
  func setup() {
    views = [HeaderView(state: .init(type: .rover, title: nil, tapCompletion: tapCompletion)),
             HeaderView(state: .init(type: .camera, title: nil, tapCompletion: tapCompletion)),
             HeaderView(state: .init(type: .date, title: nil, tapCompletion: tapCompletion))
    ]
    
    axis = .horizontal
    distribution = .fillEqually
    spacing = 10
    
    views.forEach {
      addArrangedSubview($0)
    }
  }
  
  func view(by type: HeaderType) -> HeaderView? {
    return views.first {
      $0.state?.type == type
    }
  }
}
