//
//  Parsable.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/6/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

protocol Parsable: class {

    associatedtype QueryInfo: QueryInfoType
    associatedtype ParsableContext: Any

    static func keyForIdentifier() -> String? // should use nil as identifier when items of response doesn't have identifier
    static func objects(_ json: [String: AnyObject]) -> [[String: AnyObject]]?
    static func parsableContext(_ context: ManagedObjectContextType) -> ParsableContext

    func fill(_ json: [String: AnyObject], queryInfo: QueryInfo, context: ParsableContext)
    func update(_ json: [String: AnyObject], queryInfo: QueryInfo)
}

extension Parsable {

    static func parsableContext(_ context: ManagedObjectContextType) -> Void {

    }

}
