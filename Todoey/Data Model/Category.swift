//
//  Category.swift
//  Todoey
//
//  Created by Connie He on 8/14/19.
//  Copyright © 2019 Connie He. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
