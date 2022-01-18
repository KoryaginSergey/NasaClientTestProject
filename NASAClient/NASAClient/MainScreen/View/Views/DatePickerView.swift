//
//  DatePickerView.swift
//  NASAClient
//
//  Created by Admin on 16.01.2022.
//


import Foundation
import UIKit


class DatePickerView: UIView {
  struct State {
    let date: Date
    let doneAction: ((Date) -> ())?
    let cancelAction: (() -> ())?
    static let initial: State = .init(date: Date(), doneAction: nil, cancelAction: nil)
  }
  
  enum Defaults {
    enum Button {
      static let width: CGFloat = 100
    }
    
    enum Header {
      static let height: CGFloat = 50
    }
  }
  
  public var state: State = .initial {
    didSet {
      update()
    }
  }
  
  private let cancelButton: UIButton = {
    $0.backgroundColor = .clear
    $0.setTitle("Cancel", for: .normal)
    $0.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    return $0
  }(UIButton())
  
  private let doneButton: UIButton = {
    $0.backgroundColor = .clear
    $0.setTitle("Done", for: .normal)
    $0.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
    return $0
  }(UIButton())
  
  private let header: UIView = {
    $0.backgroundColor = .gray
    return $0
  }(UIView())
  
  private let picker: UIDatePicker = UIDatePicker()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
}

private extension DatePickerView {
  func setup() {
    picker.datePickerMode = .date
    if #available(iOS 13.4, *) {
      picker.preferredDatePickerStyle = .wheels
    }
    
    header.addSubview(doneButton)
    header.addSubview(cancelButton)
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(header)
    addSubview(picker)
    
    picker.translatesAutoresizingMaskIntoConstraints = false
    header.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate(makePickerConstraints() +
                                  makeHeaderConstraints() +
                                  makeCancelButtonConstraints() +
                                  makeDoneButtonConstraints()
    )
  }
  
  func update() {
    picker.date = state.date
  }
  
  func makePickerConstraints() -> [NSLayoutConstraint] {[
    picker.leadingAnchor.constraint(equalTo: leadingAnchor),
    picker.trailingAnchor.constraint(equalTo: trailingAnchor),
    picker.bottomAnchor.constraint(equalTo: bottomAnchor)
  ]}
  
  func makeHeaderConstraints() -> [NSLayoutConstraint] {[
    header.bottomAnchor.constraint(equalTo: picker.topAnchor),
    header.leadingAnchor.constraint(equalTo: leadingAnchor),
    header.trailingAnchor.constraint(equalTo: trailingAnchor),
    header.topAnchor.constraint(equalTo: topAnchor),
    header.heightAnchor.constraint(equalToConstant: Defaults.Header.height)
  ]}
  
  func makeCancelButtonConstraints() -> [NSLayoutConstraint] {[
    cancelButton.bottomAnchor.constraint(equalTo: header.bottomAnchor),
    cancelButton.trailingAnchor.constraint(equalTo: header.trailingAnchor),
    cancelButton.topAnchor.constraint(equalTo: header.topAnchor),
    cancelButton.widthAnchor.constraint(equalToConstant: Defaults.Button.width)
  ]}
  
  func makeDoneButtonConstraints() -> [NSLayoutConstraint] {[
    doneButton.bottomAnchor.constraint(equalTo: header.bottomAnchor),
    doneButton.leadingAnchor.constraint(equalTo: header.leadingAnchor),
    doneButton.topAnchor.constraint(equalTo: header.topAnchor),
    doneButton.widthAnchor.constraint(equalToConstant: Defaults.Button.width)
  ]}
  
  @objc
  func doneAction() {
    state.doneAction?(picker.date)
  }
  
  @objc
  func cancelAction() {
    state.cancelAction?()
  }
}

