//
//  MainScreenView.swift
//  NASAClient
//
//  Created by Admin on 09.01.2022.
//  
//

import UIKit


// MARK: - MainScreenViewDelegate
protocol MainScreenViewDelegate: AnyObject {
  func viewDidTapButton(type: HeaderType, view: MainScreenViewProtocol)
  func viewDidSelectPicker(index: Int, type: HeaderType)
  func viewDidSelectPicker(date: Date)
}

// MARK: - MainScreenViewProtocol
protocol MainScreenViewProtocol: UIView {
  var delegate: MainScreenViewDelegate? { get set }
  var tableView: UITableView! { get }
  var state: MainScreenView.State? { get set }
  
  func showPicker(inputs: [String], type: HeaderType)
  func showPicker(date: Date)
}

// MARK: - MainScreenView
class MainScreenView: UIView, MainScreenViewProtocol{
  
  enum Defaults {
    enum PickerContentView {
      static let openBottomConstant: CGFloat = 0
      static let closeBottomConstant: CGFloat = -266
    }
  }
  
  var state: State? {
    didSet {
      stackView?.roverState = .init(title: state?.roverTitle)
      stackView?.cameraState = .init(title: state?.cameraTitle)
      stackView?.dateState = .init(title: state?.dateTitle)
    }
  }
  
  // MARK: - MainScreenView interface methods
  weak var delegate: MainScreenViewDelegate?
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var pickerContentView: UIView!
  @IBOutlet weak var headerView: UIView!
  
  @IBOutlet weak var pickerContentViewBottonConstraint: NSLayoutConstraint!
  
  func showPicker(inputs: [String], type: HeaderType) {
    initPickerView(inputs: inputs, type: type)
    showPickerContentView()
  }
  
  func showPicker(date: Date) {
    initPickerView(date: date)
    showPickerContentView()
  }
  
  private var activePickerView: UIView?
  private var stackView: HeaderStackView?
  
  // MARK: - IBActions
  
  // MARK: - Overrided methods
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
}

extension MainScreenView {
  struct State {
    let roverTitle: String?
    let cameraTitle: String?
    let dateTitle: String?
  }
}
// MARK: - Private extensions
private extension MainScreenView {
  func setup() {
    let stack = HeaderStackView(completion: { [weak self] type in
      guard let type = type, let self = self else { return }
      self.delegate?.viewDidTapButton(type: type, view: self)
    })
    stack.translatesAutoresizingMaskIntoConstraints = false
    headerView.addSubview(stack)
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: stack.topAnchor),
      headerView.bottomAnchor.constraint(equalTo: stack.bottomAnchor),
      headerView.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: -10),
      headerView.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: 10)
    ])
    stackView = stack
  }
  
  func initPickerView(inputs: [String], type: HeaderType) {
    let picker = PickerView(frame: .zero)
    picker.state = .init(titles: inputs, doneAction: { [weak self] row in
      self?.delegate?.viewDidSelectPicker(index: row, type: type)
      self?.hidePickerContentView()
    }, cancelAction: { [weak self] in
      self?.hidePickerContentView()
    })
    activePickerView = picker
  }
  
  func initPickerView(date: Date) {
    let picker = DatePickerView(frame: .zero)
    picker.state = .init(date: date, doneAction: { [weak self] date in
      self?.delegate?.viewDidSelectPicker(date: date)
      self?.hidePickerContentView()
    }, cancelAction: { [weak self] in
      self?.hidePickerContentView()
    })
    activePickerView = picker
  }
  
  func showPickerContentView() {
    stackView?.isUserInteractionEnabled = false
    guard let pickerView = activePickerView else { return }
    
    pickerView.translatesAutoresizingMaskIntoConstraints = false
    pickerContentView.addSubview(pickerView)
    
    NSLayoutConstraint.activate([
      pickerView.topAnchor.constraint(equalTo: pickerContentView.topAnchor),
      pickerView.leftAnchor.constraint(equalTo: pickerContentView.leftAnchor),
      pickerView.rightAnchor.constraint(equalTo: pickerContentView.rightAnchor),
      pickerView.bottomAnchor.constraint(equalTo: pickerContentView.bottomAnchor),
    ])
    
    self.pickerContentViewBottonConstraint.constant = Defaults.PickerContentView.openBottomConstant
    
    UIView.animate(withDuration: 0.25) {
      self.layoutIfNeeded()
    }
  }
  
  func hidePickerContentView() {
    stackView?.isUserInteractionEnabled = true
    self.pickerContentViewBottonConstraint.constant = Defaults.PickerContentView.closeBottomConstant
    
    UIView.animate(withDuration: 0.25) {
      self.layoutIfNeeded()
    } completion: { _ in
      self.activePickerView?.removeFromSuperview()
      self.activePickerView = nil
    }
  }
}
