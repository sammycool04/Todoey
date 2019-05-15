//
//  Category.swift
//  Todoey
//
//  Created by Sam  on 5/5/19.
//  Copyright © 2019 Sam. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
