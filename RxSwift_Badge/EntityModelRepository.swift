//
//  EntityModelRepository.swift
//  RxSwift_Badge
//
//  Created by 佐藤賢 on 2018/03/30.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import RxSwift



protocol EntityModelRepository {
  associatedtype V
  associatedtype E
  associatedtype P
  
  func get(by parameters: P) -> RxSwift.Single<Result<V, E>>
}



extension EntityModelRepository {
  func asAny() -> AnyEntityModelRepository<P, V, E> {
    return AnyEntityModelRepository(self)
  }
}



class AnyEntityModelRepository<Parameters, Entity, Reason>: EntityModelRepository {
  typealias V = Entity
  typealias E = Reason
  typealias P = Parameters
  
  
  private let _get: (Parameters) -> RxSwift.Single<Result<V, E>>
  
  
  init<Repository: EntityModelRepository>(
    _ repository: Repository
    ) where Repository.V == Entity, Repository.E == Reason, Repository.P == Parameters {
    self._get = { parameters in
      repository.get(by: parameters)
    }
  }
  
  
  func get(by parameters: P) -> RxSwift.Single<Result<V, E>> {
    return self._get(parameters)
  }
}

