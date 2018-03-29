//
//  Result.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/30.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

enum Result<V, E> {
  case success(V)
  case failure(E)
  
  var value: V? {
    switch self {
    case let .success(value):
      return value
    case .failure:
      return nil
    }
  }
  
  
  var error: E? {
    switch self {
    case let .failure(error):
      return error
    case .success:
      return nil
    }
  }
}

