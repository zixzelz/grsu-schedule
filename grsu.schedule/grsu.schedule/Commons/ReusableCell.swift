//
//  ReusableCell.swift
//  BuddyHOPP
//
//  Created by pradeep burugu on 3/1/17.
//  Copyright © 2017 Buddyhopp Inc. All rights reserved.
//

import UIKit

protocol ReusableCell: AnyObject {

    static var identifier: String { get }

    static var staticHeight: CGFloat? { get }
}

extension ReusableCell {

    static var identifier: String {
        return String(describing: self)
    }

    static var staticHeight: CGFloat? {
        return nil
    }
}

extension UITableView {

    func register<Cell: UITableViewCell & ReusableCell>(cell: Cell.Type) {
        register(Cell.loadNibForClass(), forCellReuseIdentifier: Cell.identifier)
    }

    func register<Cell: UITableViewCell & ReusableCell>(cellClass: Cell.Type) {
        register(Cell.self, forCellReuseIdentifier: Cell.identifier)
    }

    func register<Cell: UITableViewHeaderFooterView & ReusableCell>(headerFooterView: Cell.Type) {
        register(Cell.loadNibForClass(), forHeaderFooterViewReuseIdentifier: Cell.identifier)
    }
}

extension UICollectionView {

    func register<Cell: UICollectionViewCell & ReusableCell>(cell: Cell.Type) {
        register(Cell.loadNibForClass(), forCellWithReuseIdentifier: Cell.identifier)
    }

    func register<Cell: UICollectionViewCell & ReusableCell>(cellClass: Cell.Type) {
        register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
    }

    func register<SupplementaryView: UICollectionReusableView & ReusableCell>(supplementaryView: SupplementaryView.Type, of kind: String) {
        register(SupplementaryView.loadNibForClass(), forSupplementaryViewOfKind: kind, withReuseIdentifier: SupplementaryView.identifier)
    }

    func register<SupplementaryView: UICollectionReusableView & ReusableCell>(supplementaryViewClass: SupplementaryView.Type, of kind: String) {
        register(SupplementaryView.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: SupplementaryView.identifier)
    }
}

extension UITableView {
    func dequeueCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell where Cell: ReusableCell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(Cell.identifier)")
        }

        return cell
    }

    func dequeueCell<Cell: UITableViewCell>(with identifier: String, for indexPath: IndexPath) -> Cell where Cell: ReusableCell {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(Cell.identifier)")
        }

        return cell
    }

    func dequeueReusableHeaderFooterView<Cell: UITableViewHeaderFooterView & ReusableCell>() -> Cell {
        return dequeueReusableHeaderFooterView(withIdentifier: Cell.identifier) as! Cell
    }
}
