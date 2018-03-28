//
//  BadgeSelectorViewModel.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/26.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import RxSwift
import RxCocoa

// Doneボタンに対応するViewModel.
class BadgeSelectorViewModel {
  
  typealias Dependency = (
    // 選択されたbadge数の変化がわかるBehaviorRelay.
    selectedBadgesRelay: BehaviorRelay<[Badge]>,
    // 別の画面へ遷移するためのクラス. このクラスのメソッドを叩くと新しい画面へ遷移できる.
    wireframe: BadgeSelectorWireframe
  )
  
  // View への出力: Doneボタンの有効/無効フラグのDriver.
  let canComplete: RxCocoa.Driver<Bool>
  
  private let dependency: Dependency
  private let disposeBag = DisposeBag()
  
  init(
    // View からの入力: DoneボタンのタップイベントのSignal.
    input doneTap: RxCocoa.Signal<Void>,
    dependency: Dependency
    ) {
    self.dependency = dependency
    
    // バッジが一つも選択されていなければ, UINavigationBar上のDoneボタンを無効にする.
    self.canComplete = dependency.selectedBadgesRelay
      .map { selection in !selection.isEmpty }
      // エラーが発生時に指定した Driver のイベントを通知する
      .asDriver(
        // エラーを無視
        onErrorDriveWith: .empty()
    )
    
    // Doneボタンタップ時に画面を遷移させる.
    doneTap
      .emit(onNext: { [weak self] _ in
        guard let `self` = self else { return }
        self.dependency.wireframe.goToResultScreen(
          with: self.dependency.selectedBadgesRelay.value
        )
      })
      .disposed(by: disposeBag)
  }
}
