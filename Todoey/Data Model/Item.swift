//
//  Item.swift
//  Todoey
//
//  Created by Sam  on 5/5/19.
//  Copyright © 2019 Sam. All rights reserved.
//

import Foundation
import RealmSwift



class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dataCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}


