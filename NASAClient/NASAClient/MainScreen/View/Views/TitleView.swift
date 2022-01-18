//
//  TitleView.swift
//  NASAClient
//
//  Created by Admin on 09.01.2022.
//

import UIKit


final class TitleView: UIView {
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var selectedLabel: UILabel!
  @IBOutlet private weak var viewForTitle: UIView!
  
  public struct State {
    let title: String?
    let selection: String?
    let image: UIImage?
    
    init(title: String?, selection: String?, image: UIImage?) {
      self.title = title
      self.selection = selection
      self.image = image
    }
  }
  
  // MARK: - Properties
  public var state: State? {
    didSet {
      configure()
    }
  }
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
}

// MARK: - Private methods
private extension TitleView {
  func setupUI() {
    viewForTitle.layer.cornerRadius = 10
    viewForTitle.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
  }
  
  func configure() {
    titleLabel.text = state?.title
    selectedLabel.text = state?.selection
    imageView.image = state?.image
  }
}
