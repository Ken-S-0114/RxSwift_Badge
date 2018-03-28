//
//  BadgeSelectorViewModel.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/26.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import RxSwift
import RxCocoa

class BadgeSelectorViewModel {
  typealias Dependency = (
  // 依存: 選択された badge 数の変化がわかる BehaviorRelay。
    selectedBadgesRelay: BehaviorRelay<[]>
  )
}
