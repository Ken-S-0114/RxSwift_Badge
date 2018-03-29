
//
//  BadgesRepository.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/30.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

protocol BadgesRepository: EntityModelRepository {
  associatedtype V = [Badge]
  associatedtype E = Never
  associatedtype P = Void
}
