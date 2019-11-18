//
//  TodayViewController.swift
//  grsu.today
//
//  Created by Ruslan Maslouski on 31/10/2019.
//  Copyright © 2019 Ruslan Maslouski. All rights reserved.
//

import UIKit
import NotificationCenter
import ServiceLayerSDK
import ReactiveSwift

protocol StudentLessonCellViewModeling {
    var name: String? { get }
    var type: String? { get }
    var startTime: String { get }
    var stopTime: String { get }
}

protocol TodayViewControllerViewModeling {
    var listViewModel: ListViewModel<StudentLessonCellViewModeling> { get }
    func refresh()
}

class TodayViewController: UIViewController, NCWidgetProviding {

    var dateScheduleQuery: DateScheduleQuery!
    var schedules: Array<DaySchedule>?

    var menuCellIndexPath: IndexPath?

    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!

    let viewModel: TodayViewControllerViewModeling = TodayViewControllerViewModel()

    private var contentDataSource: TableViewDataSource<StudentLessonCellViewModeling>? {
        didSet {
            tableView.dataSource = contentDataSource
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        extensionContext?.widgetLargestAvailableDisplayMode = .expanded

        bindViewModel(viewModel)
    }

    private var bindDisposable: Disposable?
    private func bindViewModel(_ viewModel: TodayViewControllerViewModeling?) {

        let list = CompositeDisposable()
        bindDisposable = ScopedDisposable(list)

        guard let viewModel = viewModel else {
            return
        }

        contentDataSource = TableViewDataSource(
            tableView: tableView,
            listViewModel: viewModel.listViewModel,
            map: { (tableView, indexPath, viewModel) -> UITableViewCell in
                let cell: StudentLessonTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(with: viewModel)
                return cell
            })

        list += viewModel.listViewModel.state.producer.skipRepeats().startWithValues { [weak self] state in
            switch state {
            case .loaded, .none:
                self?.tableView.isHidden = false
                self?.activityIndicatorView.stopAnimating()
                self?.updateSize()
            case .loading:
                self?.tableView.isHidden = true
                self?.activityIndicatorView.startAnimating()
                self?.updateSize()
            }
        }
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        viewModel.refresh()
        completionHandler(.newData)
    }

    func updateSize() {
        guard
            let mode = extensionContext?.widgetLargestAvailableDisplayMode,
            let maxSize = extensionContext?.widgetMaximumSize(for: mode) else {
                return
        }
        widgetActiveDisplayModeDidChange(mode, withMaximumSize: maxSize)
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let height = tableView.contentSize.height
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: min(height, maxSize.height)) : maxSize
    }
}

extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = contentDataSource?.tableView(tableView, titleForHeaderInSection: section)

        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        view.addSubviewWithStretchingConstraints(label, inset: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))

        return view
    }
}
