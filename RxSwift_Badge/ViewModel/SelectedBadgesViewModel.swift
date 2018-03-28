//
//  SelectedBadgesViewModel.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/29.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import RxSwift
import RxCocoa

// 選択されたバッジの表示UIに対応するViewModel.
class SelectedBadgesViewModel {
  
  // View への出力: 上部に表示するバッジの一覧のDriver.
  let seletedBadges: RxCocoa.Driver<[Badge]>
  // View への出力: 選択解除されたバッジを通知するSignal.
  let badgeDidDeselect: RxCocoa.Signal<Badge>
  
  private let selectedBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>
  private let badgeDidDeselectRelay: RxCocoa.PublishRelay<Badge>
  
  private let disposeBag = DisposeBag()
  
  init(
    // View からの入力: 上部バッジのタップイベントのSignal
      selectedTap: RxCocoa.Signal<Badge>,
      // 依存: 選択されたbadgeの一覧を保持したBehaviorRelay
      dependency selectedBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>
    ) {
    // 選択済みのバッジの出力を
    self.selectedBadgesRelay = selectedBadgesRelay
    self.seletedBadges = selectedBadgesRelay.asDriver()
    
    // バッジの選択が解除されたことをUIViewへ通知するためのPublishRelay
    let badgeDidDeselectRelay = RxCocoa.PublishRelay<Badge>()
    self.badgeDidDeselectRelay = badgeDidDeselectRelay
    self.badgeDidDeselect = badgeDidDeselectRelay.asSignal()
    
    // 上部バッジをタップで選択を解除する
    selectedTap
        .emit(onNext: { [weak self] badge in
          guard let `self` = self,
            let index = self.selectedBadgesRelay.value.index(of: badge) else { return }
          var newSelectedBadges = self.selectedBadgesRelay.value
          newSelectedBadges.remove(at: index)
          self.selectedBadgesRelay.accept(newSelectedBadges)
          
          self.badgeDidDeselectRelay.accept(badge)
          })
    .disposed(by: disposeBag)
  }
}
