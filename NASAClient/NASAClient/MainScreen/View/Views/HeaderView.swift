//
//  HeaderView.swift
//  NASAClient
//
//  Created by Admin on 16.01.2022.
//

import Foundation
import UIKit


class HeaderView: UIView {
  struct State {
    let type: HeaderType
    var title: String?
    var tapCompletion: ((HeaderType?) -> ())?
  }
  
  enum Defaults {
    enum Button {
      static let top: CGFloat = 5
      static let height: CGFloat = 50
    }
    
    enum Title {
      static let top: CGFloat = 5
      static let bottom: CGFloat = 5
    }
  }
  
  public var state: State? {
    didSet {
      update()
    }
  }
  
  private let button: UIButton = {
    $0.backgroundColor = .blue
    $0.titleLabel?.textColor = .black
    $0.layer.cornerRadius = Defaults.Button.height / 2
    $0.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    return $0
  }(UIButton())
  
  private let title: UILabel = {
    $0.textColor = .black
    $0.textAlignment = .center
    return $0
  }(UILabel())
  
  init(state: State?) {
    super.init(frame: .zero)
    setup()
    self.state = state
    update()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
}

private extension HeaderView {
  @objc
  func didTap() {
    state?.tapCompletion?(state?.type)
  }
  
  func update() {
    button.setTitle(state?.type.buttonTitle, for: .normal)
    title.text = state?.title
  }
  
  func setup() {
    [button, title].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate(
      makeButtonConstraints() +
        makeTitleConstraints()
    )
  }
  
  func makeButtonConstraints() -> [NSLayoutConstraint] {[
    button.topAnchor.constraint(equalTo: topAnchor, constant: Defaults.Button.top),
    button.heightAnchor.constraint(equalToConstant: Defaults.Button.height),
    button.leadingAnchor.constraint(equalTo: leadingAnchor),
    button.trailingAnchor.constraint(equalTo: trailingAnchor)
  ]}
  
  func makeTitleConstraints() -> [NSLayoutConstraint] {[
    title.leadingAnchor.constraint(equalTo: leadingAnchor),
    title.trailingAnchor.constraint(equalTo: trailingAnchor),
    title.topAnchor.constraint(equalTo: button.bottomAnchor, constant: Defaults.Title.top),
    bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: Defaults.Title.bottom)
  ]}
}
