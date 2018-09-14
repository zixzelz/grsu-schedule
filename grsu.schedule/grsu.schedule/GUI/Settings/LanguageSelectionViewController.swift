//
//  LanguageSelectionViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/13/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ReactiveSwift

typealias LanguageSelectionCellViewModeling = String

protocol LanguageSelectionViewModeling {
    var listViewModel: ListViewModel<LanguageSelectionCellViewModeling> { get }
    func selectLanguage(at indexPath: IndexPath)
}

class LanguageSelectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: LanguageSelectionViewModeling? {
        didSet {
            if isViewLoaded {
                bind(with: viewModel)
            }
        }
    }

    private var scopedDisposable: ScopedDisposable<AnyDisposable>?
    private var contentDataSource: TableViewDataSource<LanguageSelectionCellViewModeling>? {
        didSet {
            tableView.dataSource = contentDataSource
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.languageNavigationBarTitle

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self

        bind(with: viewModel)
    }

    private func bind(with viewModel: LanguageSelectionViewModeling?) {
        let list = CompositeDisposable()
        scopedDisposable = ScopedDisposable(list)
        contentDataSource = nil

        guard let viewModel = viewModel else {
            return
        }

        let lvm = viewModel.listViewModel
        contentDataSource = TableViewDataSource(
            tableView: tableView,
            listViewModel: lvm,
            map: { [unowned lvm] (tableView, indexPath, cellVM) -> UITableViewCell in
                let cell: UITableViewCell = tableView.dequeueCell(for: indexPath)
                cell.textLabel?.text = cellVM
                cell.accessoryType = lvm.selectedCells.value.contains(indexPath) ? .checkmark : .none
                return cell
            })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParentViewController, let indexPath = viewModel?.listViewModel.selectedCells.value.first {
            viewModel?.selectLanguage(at: indexPath)
        }
    }

}

extension LanguageSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let oldSelection = viewModel?.listViewModel.selectedCells.value.first {
            let cell = tableView.cellForRow(at: oldSelection)
            cell?.accessoryType = .none
        }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

        viewModel?.listViewModel.selectRowAtIndexPath(indexPath)
    }
}
