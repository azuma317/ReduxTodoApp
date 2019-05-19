//
//  TodoState.swift
//  ReduxRealmSample
//
//  Created by さとうあずま on 2019/05/18.
//  Copyright © 2019 Azuma Sato. All rights reserved.
//

import Foundation
import ReSwift

// State
struct TodoState: ReSwift.StateType {
    var todos: [Todo] = [Todo(id: UUID().uuidString, title: "", isComplete: false)]
}

// Action
extension TodoState {
    enum Action: ReSwift.Action {
        case addTodo
        case deleteTodo(index: Int)
        case editTodo(todo: Todo)
        case completeTodo(index: Int)
    }
}

// Reducer
extension TodoState {
    static func reducer(action: ReSwift.Action, state: TodoState?) -> TodoState {
        var state = state ?? TodoState()
        guard let action = action as? TodoState.Action else { return state }
        switch action {
        case .addTodo: // 配列の末尾にTodoを挿入
            let todo = Todo(id: UUID().uuidString, title: "", isComplete: false)
            state.todos.append(todo)
            return state
        case .deleteTodo(let index): // Todoを削除
            state.todos.remove(at: index)
            return state
        case .editTodo(let todo): // textが入力されたときにTodoを編集
            guard let index = state.todos.index(where: { return $0.id == todo.id }) else { return state }
            state.todos[index] = todo
            return state
        case .completeTodo(let index):
            state.todos[index].isComplete = !state.todos[index].isComplete
            return state
        }
    }
}
