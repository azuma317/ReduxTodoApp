//
//  Todo.swift
//  ReduxRealmSample
//
//  Created by さとうあずま on 2019/05/18.
//  Copyright © 2019 Azuma Sato. All rights reserved.
//

import Foundation
import RealmSwift

struct Todo {
    var id: String
    // Todoの内容
    var title: String
    // 完了したかどうか
    var isComplete: Bool
}
