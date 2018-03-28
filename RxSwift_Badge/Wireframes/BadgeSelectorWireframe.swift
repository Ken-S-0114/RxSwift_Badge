//
//  BadgeSelectorWireframe.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/29.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import UIKit

protocol BadgeSelectorWireframe {
  func goToResultScreen(with selectedBadgesModel: SelectedBadgesModel)
}

class DefaultBadgeSelectorWireframe: BadgeSelectorWireframe {
  private weak var viewController: UIViewController?
  
  
  init(on viewController: UIViewController) {
    self.viewController = viewController
  }
  
  
  func goToResultScreen(with selectedBadgesModel: SelectedBadgesModel) {
    let navigationController = UINavigationController(
      rootViewController: SelectedBadgesViewController(
        dependency: selectedBadgesModel
      )
    )
    
    self.viewController?.present(navigationController, animated: true)
  }
}

