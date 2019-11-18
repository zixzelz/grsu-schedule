//
//  Array+Group.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 07/11/2019.
//  Copyright © 2019 Ruslan Maslouski. All rights reserved.
//

extension Array {
    func grouped<Key : Hashable>(groupId: (Int, Element) -> Key) -> [[Element]] {
        var map: [Key: Int] = [:]
        var groups: [[Element]] = []

        for (index, item) in enumerated() {
            let _groupId = groupId(index, item)
            if let index = map[_groupId] {
                groups[index].append(item)
            } else {
                map[_groupId] = groups.count
                groups.append([item])
            }
        }

        return groups
    }
}
