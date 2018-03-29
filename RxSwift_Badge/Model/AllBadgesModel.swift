//
//  AllBadgesModel.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/30.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

/*
 すべてのバッジを取得する Model
 */

import RxSwift
import RxCocoa

// ViewModelのテストを容易にするためにProtocolにする.
protocol AllBadgesModel: class {
  // バッジの取得状態が変化したら通知するDriver
  var stateDidChange: RxCocoa.Driver<[AllBadgesModelState]> { get }
  // 現在のバッジの取得状態
  var currentState: AllBadgesModelState { get }
}

// バッジの取得状態の型
enum AllBadgesModelState {
  // まだ取得されていない状態
  case notFetchYet
  // 取得中の状態
  case fetching
  // 取得が完了した状態
  case fetched(result: Result<[Badge], FailureReason>)
  
  var badge: [Badge] {
    switch self {
    case .fetched(result: .success(let badges)):
      return badges
    case .notFetchYet, .fetching, .fetched(result: .failure):
      return []
    }
  }
  
  var isFetching: Bool {
    switch self {
    case .fetching:
      return true
    case .notFetchYet, .fetched:
      return false
    }
  }
  
  enum FailureReason: Error {
    case unspecified(debugInfi: String)
  }
}

class DefaultAllBadgesModel: AllBadgesModel {
  let stateDidChange: RxCocoa.Driver<[AllBadgesModelState]>
  
  var currentState: AllBadgesModelState {
    get {
      return self.stateRelay.value
    }
    set {
      self.stateRelay.accept(newValue)
    }
  }
  
  private let stateRelay: RxCocoa.BehaviorRelay<AllBadgesModelState>
  private let repository: BadgesRepository
  private let disposeBag = RxSwift.DisposeBag()
  
  init(gettingBadgesVia repository: BadgesRepository) {
    self.repository = repository
    self.stateRelay = RxCocoa.BehaviorRelay<AllBadgesModelState>(value: .notFetchYet)
    self.stateDidChange = stateRelay.asDriver()
  }
  
  // バッジの一覧を更新する。もし、バッジの一覧の更新の仕様追加があっても、
  // このメソッドを public にするだけでよい。
  private func fetch() {
    // すでに更新中だったらfetchしない.
    guard !self.currentState.isFetching else { return }
    self.currentState = .fetching
    
    // リポジトリからすべてのバッジを取得する.
    self.repository.get(by: 100).s
  }
}
