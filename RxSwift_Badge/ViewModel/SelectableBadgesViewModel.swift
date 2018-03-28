//
//  SelectableBadgesViewModel.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/29.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

/*
 View から ViewModel への入力:
 -> 下部バッジのタップイベントの Signal
 ViewModel から View への出力:
 -> 下部に表示するバッジの一覧の Driver
 -> 選択されたバッジを通知する Signal
 ViewModel の依存:
 -> 選択された badge の一覧を保持した BehaviorRelay
 -> 選択されていない badge の一覧を保持した BehaviorRelay
 */

import RxSwift
import RxCocoa

// まだ選択されていないバッジの表示UIに対応するViewModel.
class SelectableBadgesViewModel {
  
  typealias Dependency = (
    // 依存: 選択されたbadgeの一覧を保持したBehaviorRelay.
    selectedBadgeRelay: RxCocoa.BehaviorRelay<[Badge]>,
    // 依存: 選択されていないbadgeの一覧を保持したBehaviorRelay.
    selectableBadgesRelay: BehaviorRelay<[Badge]>
  )
  
  // View への出力: 下部に表示するバッジの一覧のDriver
  let selectableBadges: RxCocoa.Driver<[Badge]>
  // View への出力: 選択されたバッジを通知するSignal（上部画面のスクロールに使われる）.
  let badgeDidSelect: RxCocoa.Signal<Badge>
  
  private let badgeDidSelectRelay: RxCocoa.PublishRelay<Badge>
  private let dependency: Dependency
  private let disposeBag = RxSwift.DisposeBag()
  
  init(
    // View からの入力: 下部バッジのタップイベントのSignal.
    input selectableTap: RxCocoa.Signal<Badge>,
    dependency: Dependency
    ) {
    self.dependency = dependency
    
    // バッジが選択されたことをUIViewへ通知するためのPublishRelay,
    let badgeDidSelectRelay = RxCocoa.PublishRelay<Badge>()
    self.badgeDidSelectRelay = badgeDidSelectRelay
    self.badgeDidSelect = badgeDidSelectRelay.asSignal()
    
    // 選択可能なバッジの出力.
    self.selectableBadges = dependency.selectableBadgesRelay.asDriver()
    
    // 下部バッジをタップで選択する.
    selectableTap
        .emit(onNext: { [weak self] badge in
          guard let `self` = self else { return }
          
          // 選択されたbadgeの一覧を保持したBehaviorRelayにタップされたBadgeを追加
          var newSelectedBadges = self.dependency.selectedBadgeRelay.value
          newSelectedBadges.append(badge)
          
          // イベントを流す
          self.dependency.selectedBadgeRelay.accept(newSelectedBadges)
          self.badgeDidSelectRelay.accept(badge)
          
          })
    .disposed(by: disposeBag)
  }
}
