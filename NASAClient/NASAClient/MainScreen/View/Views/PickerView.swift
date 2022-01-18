//
//  PickerView.swift
//  NASAClient
//
//  Created by Admin on 16.01.2022.
//

import Foundation
import UIKit


class PickerView: UIView {
  struct State {
    var titles: [String]
    let doneAction: ((Int) -> ())?
    let cancelAction: (() -> ())?
    static let initial: State = .init(titles: [], doneAction: nil, cancelAction: nil)
  }
  
  enum Defaults {
    enum Button {
      static let width: CGFloat = 100
    }
    
    enum Header {
      static let height: CGFloat = 50
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
  
  private let picker: UIPickerView = UIPickerView()
  
  public var state: State = .initial {
    didSet {
      update()
    }
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

private extension PickerView {
  func setup() {
    header.addSubview(doneButton)
    header.addSubview(cancelButton)
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(header)
    addSubview(picker)
    
    picker.delegate = self
    picker.dataSource = self
    
    picker.translatesAutoresizingMaskIntoConstraints = false
    header.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate(makePickerConstraints() +
                                  makeHeaderConstraints() +
                                  makeCancelButtonConstraints() +
                                  makeDoneButtonConstraints()
    )
  }
  
  func update() {
    
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
    state.doneAction?(picker.selectedRow(inComponent: 0))
  }
  
  @objc
  func cancelAction() {
    state.cancelAction?()
  }
}

extension PickerView: UIPickerViewDelegate {
  //    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
  //        state.completion?(row)
  //    }
}

extension PickerView: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    state.titles.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    state.titles[row]
  }
}
