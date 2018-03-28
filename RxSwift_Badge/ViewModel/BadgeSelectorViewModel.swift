//
//  BadgeSelectorViewModel.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/26.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import RxSwift
import RxCocoa

class BadgesSelectorViewModel {
  
  typealias Dependency = (
    // 依存: すべてのバッジの一覧を取得するためのリポジトリ.
    selectedModel: SelectedBadgesModel,
    selectableModel: SelectableBadgesModel,
    wireframe: BadgeSelectorWireframe
  )
  typealias Input = (
    // View からの入力: Done ボタンのタップイベントの Signal
    doneTap: RxCocoa.Signal<Void>,
    // View からの入力: 上部バッジのタップイベントの Signal
    selectedTap: RxCocoa.Signal<Badge>,
    // View からの入力: 下部バッジのタップイベントの Signal。
    selectableTap: RxCocoa.Signal<Badge>
  )
  
  // View への出力: 子のViewModelのプロパティを介して各コンポーネントへの出力を公開する
  let selectedViewModel: SelectedBadgesViewModel
  let selectableViewModel: SelectableBadgesViewModel
  let completionViewModel: BadgeSelectorCompletionViewModel
  
  private let disposeBag = RxSwift.DisposeBag()
  
  init(input: Input, dependency: Dependency) {
    
    let selectedModel = dependency.selectModel
    
    // 子のViewModel を内部的に作成する.
    self.selectedViewModel = SelectedBadgesViewModel(
      input: input.selectedTap,
      dependency: selectedModel
    )
    
    
    self.selectableViewModel = SelectableBadgesViewModel(
      input: input.selectableTap,
      dependency: (
        selectedModel: selectedModel,
        selectableModel: dependency.selectableModel
      )
    )
    
    self.completionViewModel = BadgeSelectorCompletionViewModel(
      input: input.doneTap,
      dependency: (
        selectedModel: selectedModel,
        wireframe: dependency.wireframe
      )
    )
    
  }
  
}
