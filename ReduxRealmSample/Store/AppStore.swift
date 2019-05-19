//
//  TodoStore.swift
//  ReduxRealmSample
//
//  Created by さとうあずま on 2019/05/18.
//  Copyright © 2019 Azuma Sato. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift
import RxCocoa

// Store
var appStore = ReSwift.Store<AppState>(reducer: appReduce, state: nil)

class AppStore<AppStateType>: StoreSubscriber where AppStateType: StateType {
    typealias StoreSubscriberStateType = AppStateType

    let state: BehaviorRelay<AppStateType>
    private let store: Store<AppStateType>
    
    init(store: Store<AppStateType>) {
        self.store = store
        self.state = BehaviorRelay<AppStateType>(value: store.state)
        self.store.subscribe(self)
    }
    
    deinit {
        self.store.unsubscribe(self)
    }
    
    // Stateの更新
    func newState(state: AppStateType) {
        self.state.accept(state)
    }
    
    // Actionを受け取ってDipatch
    func dispatch(_ action: Action) {
        store.dispatch(action)
    }
}
