//
//  SelectedBadgesModel.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/28.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

// Model 層は Protocol にしておくと ViewModel のテストがやりやすくなる。
// ViewModel のテストでは偽物の Model と差し替えると挙動が確認しやすくなるため
import RxCocoa

protocol SelectedBadgesModel {
  // 選択されたバッジの一覧に変化があったら通知する Driver
  var selectionDidChange: Driver<[Badge]>
  // 現在選択されているバッジ
  var currentSelection: []
}
class SelectedBadgesModel{}
