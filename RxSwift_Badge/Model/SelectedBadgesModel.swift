//
//  SelectedBadgesModel.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/28.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import RxCocoa

// Model層はProtocolにしておくとViewModelのテストがやりやすくなる.
// ViewModelのテストでは偽物のModelと差し替えると挙動が確認しやすくなるため.
protocol SelectedBadgesModel {
  
  // 選択されたバッジの一覧に変化があったら通知する Driver.
  var selectionDidChange: RxCocoa.Driver<[Badge]> { get }
  // 現在選択されているバッジ.
  var currentSelection: [Badge] { get }
  // 新たに選択されたバッジを通知するDriver.
  var badgeDidSelect: RxCocoa.Signal<Badge> { get }
  // 新たに選択解除されたバッジを通知するDriver.
  var badgeDidDeselect: RxCocoa.Signal<Badge> { get }
  // 与えられたバッジを選択する.
  func select(badge: Badge)
  // 与えられたバッジの選択を解除する.
  func deselect(badge: Badge)
}

// 上記のProtocolを実装した本体実装.
// バッジの選択/非選択に関わる状態管理処理
class DefaultSelectedBadgesModel: SelectedBadgesModel {
  
  private let selectedBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>
  private let badgeDidSelectRelay: RxCocoa.PublishRelay<Badge>
  private let badgeDidDeselectRelay: RxCocoa.PublishRelay<Badge>
  
  // View への出力: 選択されたバッジを通知するSignal.
  let badgeDidSelect: RxCocoa.Signal<Badge>
  // View への出力: 選択解除されたバッジを通知するSignal.
  let badgeDidDeselect: RxCocoa.Signal<Badge>
  // View への出力: 下部に表示するバッジの一覧のDriver.
  let selectionDidChange: RxCocoa.Driver<[Badge]>
  
  var currentSelection: [Badge] {
    get {
      return self.selectedBadgesRelay.value
    }
    set {
      self.selectedBadgesRelay.accept(newValue)
    }
  }
  
  init(selected initialSelection: [Badge]) {
    // ???
    self.stateMachine = StateMachine(
      startingWith: initialSelection
    )
    
    // バッジが選択されたことをUIViewへ通知するためのPublishRelay. (ViewModel層から移動)
    let badgeDidSelectRelay = RxCocoa.PublishRelay<Badge>()
    self.badgeDidSelectRelay = badgeDidSelectRelay
    self.badgeDidSelect = badgeDidSelectRelay.asSignal()
    
    // バッジの選択が解除されたことをUIViewへ通知するためのPublishRelay. (ViewModel層から移動)
    let badgeDidDeselectRelay = RxCocoa.PublishRelay<Badge>()
    self.badgeDidDeselectRelay = badgeDidDeselectRelay
    self.badgeDidDeselect = badgeDidDeselectRelay.asSignal()
    
    self.selectedBadgesRelay = stateMachine.stateDidChange
  }
  
  func select(badge: Badge) {
    // 選択されたBadgeが現在選択されているBadge一覧に含まれているかチェック -> 含まれていたらreturnを返す
    guard !self.currentSelection.contains(badge) else { return }
    var newSelection = self.currentSelection
    newSelection.append(badge)
    
    self.currentSelection = newSelection
    
    self.badgeDidSelectRelay.accept(badge)
  }
  
  func deselect(badge: Badge) {
    var newSelection = self.currentSelection
    
    // 選択されたbadgeの一覧を保持したBehaviorRelayにタップされたBadgeを削除
    guard let index = newSelection.index(of: badge) else {
      return
    }
    newSelection.remove(at: index)
    
    self.currentSelection = newSelection
    // イベントを流す
    self.badgeDidDeselectRelay.accept(badge)
  }
}
