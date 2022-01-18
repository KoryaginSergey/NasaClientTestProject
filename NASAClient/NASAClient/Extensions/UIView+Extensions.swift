//
//  UIView+Extensions.swift
//  NASAClient
//
//  Created by Admin on 09.01.2022.
//

import UIKit


extension UIView {
  func spaceToSaveArea() -> (top: CGFloat, bottom: CGFloat) {
    let guide = self.safeAreaLayoutGuide.layoutFrame
    let bottomSpace = self.frame.height - guide.height - guide.origin.y
    return (guide.origin.y, bottomSpace)
  }
  
  @discardableResult
  func fromNib<T : UIView>() -> T? {
    guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
      // xib not loaded, or its top view is of the wrong type
      return nil
    }
    contentView.frame = self.bounds
    self.addSubview(contentView)
    // contentView.layoutAttachAll(to: self)
    return contentView
  }
  
  public func layoutAttachAll(to childView: UIView) {
    var constraints = [NSLayoutConstraint]()
    
    childView.translatesAutoresizingMaskIntoConstraints = false
    constraints.append(NSLayoutConstraint(item: childView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
    constraints.append(NSLayoutConstraint(item: childView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
    constraints.append(NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
    constraints.append(NSLayoutConstraint(item: childView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
    
    childView.addConstraints(constraints)
  }
  
  /// The creation of view from nib file
  class func create<T>() -> T {
    let viewNibName = String(describing: self)
    let nibContent = Bundle(for: self).loadNibNamed(viewNibName, owner: nil, options: nil)
    guard let view = nibContent?.first, type(of:view) == self else {
      fatalError("Nib \(viewNibName) does not contain \(viewNibName) View as first object")
    }
    return view as! T
  }
}

extension UICollectionViewCell {
  class func register(for collectionView: UICollectionView) {
    let reuseId =  String(describing: self)
    let cellNib = UINib(nibName: reuseId, bundle: Bundle(for: self))
    collectionView.register(cellNib, forCellWithReuseIdentifier: reuseId)
  }
  
  class func supportedCellIdentifier() -> String {
    return String(describing:self)
  }
}

extension UITableViewCell {
  class func supportedCellIdentifier() -> String {
    return String(describing:self)
  }
  
  /// The registration of cell for the table view
  class func register(for tableView: UITableView) {
    let reuseId =  String(describing: self)
    let cellNib = UINib(nibName: reuseId, bundle: Bundle(for: self))
    tableView.register(cellNib, forCellReuseIdentifier: reuseId)
  }
  
  /// Returns a reusable table view cell
  class func deque(from tableView:UITableView) -> UITableViewCell {
    let reuseId =  String(describing:self)
    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId), type(of: cell) == self else {
      fatalError()
    }
    return cell
  }
}

extension UITableView {
  /// Returns a reusable table view cell
  func deque<T>(for indexPath: IndexPath) -> T {
    let reuseId = String(describing: T.self)
    guard let cell = dequeueReusableCell(withIdentifier: reuseId, for: indexPath as IndexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(reuseId)")
    }
    return cell
  }
}
