//
//  MainScreenBuilder.swift
//  NASAClient
//
//  Created by Admin on 09.01.2022.
//  
//

import UIKit


class MainScreenBuilder: NSObject {
  class func viewController() -> MainScreenViewController {
    let view = MainScreenView.create() as MainScreenViewProtocol
    let model: MainScreenModelProtocol = MainScreenModel()
    let dataSource = MainScreenDataSource(withModel: model)
    let viewController = MainScreenViewController(withView: view, model: model, dataSource: dataSource)
    return viewController
  }
}

