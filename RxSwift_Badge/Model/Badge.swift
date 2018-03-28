//
//  Badge.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/29.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import UIKit
import RxDataSources

struct Badge {
  let id: Int
  let title: String
  let color: UIColor
}

// idをもとにハッシュ値を計算可能にする
extension Badge: Hashable {
  var hashValue: Int {
    return self.id
  }
  
  // 同値性を確認するためのプロトコル
  static func ==(lhs: Badge, rhs: Badge) -> Bool {
    return lhs.id == rhs.id
  }
}

extension Badge: RxDataSources.IdentifiableType {
  typealias Identity = Int
  
  var identity: Identity {
    return self.id
  }
}
