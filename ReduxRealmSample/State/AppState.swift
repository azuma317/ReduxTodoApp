//
//  AppStore.swift
//  ReduxRealmSample
//
//  Created by さとうあずま on 2019/05/18.
//  Copyright © 2019 Azuma Sato. All rights reserved.
//

import Foundation
import ReSwift

// アプリ全体のState
struct AppState: ReSwift.StateType {
    var todoState = TodoState()
}

// Reducer
func appReduce(action: ReSwift.Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    state.todoState = TodoState.reducer(action: action, state: state.todoState)
    return state
}
