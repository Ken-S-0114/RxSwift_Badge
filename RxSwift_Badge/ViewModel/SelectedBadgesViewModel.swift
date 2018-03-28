//
//  SelectedBadgesViewModel.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/29.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

/*
 View から ViewModel への入力:
  -> 上部バッジのタップイベントの Signal
 ViewModel から View への出力:
  -> 上部に表示するバッジの一覧の Driver
  -> 選択解除されたバッジを通知する Signal
 ViewModel の依存:
  -> 選択された badge の一覧を保持した BehaviorRelay
 */

import RxSwift
import RxCocoa

// 選択されたバッジの表示UIに対応するViewModel.
class SelectedBadgesViewModel {
  
  // View への出力: 上部に表示するバッジの一覧のDriver.
  let seletedBadges: RxCocoa.Driver<[Badge]>
  // View への出力: 選択されたバッジを通知するSignal.
  let badgeDidSelect: RxCocoa.Signal<Badge>
  // View への出力: 選択解除されたバッジを通知するSignal.
  let badgeDidDeselect: RxCocoa.Signal<Badge>
  
  private let selectedBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>
  private let badgeDidDeselectRelay: RxCocoa.PublishRelay<Badge>
  
  private let selectedModel: SelectedBadgesModel
  private let disposeBag = RxSwift.DisposeBag()
  
  init(
    // View からの入力: 上部バッジのタップイベントのSignal
    input selectedTap: RxCocoa.Signal<Badge>,
    // init 関数の引数から, SelectedBadgesModelを注入する
    dependency selectedModel: SelectedBadgesModel
    ) {
    
    self.selectedModel = selectedModel
    self.seletedBadges = selectedModel.selectionDidChange
    self.badgeDidSelect = selectedModel.badgeDidSelect
    self.badgeDidDeselect = selectedModel.badgeDidDeselect
    
    // 上部バッジをタップで選択を解除する
    selectedTap
      .emit(onNext: { [weak self] badge in
        guard let `self` = self else { return }
        
        self.selectedModel.deselect(badge: badge)
        
      })
      .disposed(by: disposeBag)
  }
}
