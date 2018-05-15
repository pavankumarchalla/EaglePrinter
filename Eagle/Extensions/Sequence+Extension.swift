//
//  Sequence+Extension.swift
//  Eagle
//
//  Created by Ramprasad A on 24/01/18.
//  Copyright © 2018 Hardwin Software Solutions. All rights reserved.
//

import Foundation

extension Sequence {
  func group<GroupingType: Hashable>(by key: (Iterator.Element) -> GroupingType) -> [[Iterator.Element]] {
    var groups: [GroupingType: [Iterator.Element]] = [:]
    var groupsOrder: [GroupingType] = []
    forEach { element in
      let key = key(element)
      if case nil = groups[key]?.append(element) {
        groups[key] = [element]
        groupsOrder.append(key)
      }
    }
    return groupsOrder.map { groups[$0]! }
  }
}
