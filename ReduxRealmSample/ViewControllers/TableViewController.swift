//
//  TableViewController.swift
//  ReduxRealmSample
//
//  Created by さとうあずま on 2019/05/18.
//  Copyright © 2019 Azuma Sato. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class TableViewController: UITableViewController {
    
    @IBOutlet private weak var addTodoButton: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()
    private let store = AppStore<AppState>(store: appStore)
    private var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "TodoCell")
        
        bind()
    }
    
    private func bind() {
        // StoreをTabelViewのDataSourceにbind
        store.state.asObservable().map({ $0.todoState.todos })
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "TodoCell", cellType: TodoCell.self)) { row, element, cell in
                cell.todoTextField.text = element.title
                cell.checkLabel.text = element.isComplete ? "✓" : "○"
                // Keyboardが閉じる時にtextがあるときは更新
                cell.todoTextField.rx.controlEvent(.editingDidEnd).subscribe ({ [unowned self] _ in
                    guard let text = cell.todoTextField.text else { return }
                    let todo = Todo(id: element.id, title: text, isComplete: element.isComplete)
                    let action = TodoState.Action.editTodo(todo: todo)
                    self.store.dispatch(action)
                })
                .disposed(by: self.disposeBag)
                // Return時にKeyboardを閉じる
                cell.todoTextField.rx.controlEvent(.editingDidEndOnExit).subscribe().disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        store.state.asObservable().map({ $0.todoState.todos })
            .subscribe({ [unowned self] in
                guard let todos = $0.element else { return }
                self.todos = todos
            })
            .disposed(by: disposeBag)
        
        // Todoの追加
        addTodoButton.rx.tap
            .subscribe({ [unowned self] _ in
                let action = TodoState.Action.addTodo
                self.store.dispatch(action)
            })
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TodoCell else { return }
        // textがない場合はKeyboardを出す
        guard cell.todoTextField.text != "" else {
            cell.todoTextField.becomeFirstResponder()
            return
        }
        // Todoを完了済みにする
        cell.checkLabel.text = todos[indexPath.item].isComplete ? "✓" : "○"
        let action = TodoState.Action.completeTodo(index: indexPath.item)
        self.store.dispatch(action)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // cellのスライド時にDelete
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (_, _) in
            let action = TodoState.Action.deleteTodo(index: indexPath.item)
            self.store.dispatch(action)
        }
        deleteAction.backgroundColor = .red
        return [deleteAction]
    }

}
