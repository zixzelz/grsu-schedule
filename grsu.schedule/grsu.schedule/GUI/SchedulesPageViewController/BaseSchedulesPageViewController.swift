//
//  SchedulesPageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class BaseSchedulesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBInspectable var backgroundColor: UIColor = UIColor.white

    @IBOutlet fileprivate var navigationTitle: UILabel!
    @IBOutlet fileprivate var pageControl: UIPageControl!

    var possibleWeeks: [GSWeekItem]?
    var dateScheduleQuery: DateScheduleQuery?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.dataSource = self
        self.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        view.backgroundColor = backgroundColor
        setupPageController()

        NotificationCenter.default.addObserver(self, selector: #selector(BaseSchedulesPageViewController.favoritWillRemoveNotification(_:)), name: NSNotification.Name(rawValue: GSFavoriteManagerFavoritWillRemoveNotificationKey), object: nil)
    }

    func setupPageController() {
        guard let possibleWeeks = possibleWeeks,
            let dateScheduleQuery = dateScheduleQuery else {
                pageControl.numberOfPages = 0
                updateNavigationTitle()
                return
        }
        let weeks = possibleWeeks.map { $0.startDate }
        let currentPage: Int = weeks.index(of: dateScheduleQuery.startWeekDate!) ?? 0

        pageControl.numberOfPages = possibleWeeks.count
        pageControl.currentPage = currentPage
        updateNavigationTitle()

        let vc = weekScheduleController()
        self.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
    }

    func updateNavigationTitle() {
        guard let possibleWeeks = possibleWeeks else { return }

        let index = pageControl.currentPage
        let text: String? = (possibleWeeks.count > 0) ? possibleWeeks[index].value : nil

        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.navigationTitle.alpha = 0.0
            self.navigationTitle.text = text
            self.navigationTitle.alpha = 1.0
        })
    }

    func weekScheduleController(_ weekIndex: Int? = nil) -> UIViewController {
        fatalError("You must override !!!")
    }

    @objc func favoritWillRemoveNotification(_ notification: Foundation.Notification) {
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var vc: UIViewController?
        if (pageControl.currentPage > 0) {
            let index = pageControl.currentPage - 1
            vc = weekScheduleController(index)
        }
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var vc: UIViewController?
        if (pageControl.currentPage < pageControl.numberOfPages - 1) {
            let index = pageControl.currentPage + 1
            vc = weekScheduleController(index)
        }
        return vc
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if (completed) {

            if let vc = pageViewController.viewControllers?.last as? WeekSchedulesViewController {
                let index = indexOfViewController(vc)
                pageControl.currentPage = index
                updateNavigationTitle()
            }
        }
    }

    // MARK: - Utils

    func indexOfViewController(_ vc: WeekSchedulesViewController) -> Int {
        guard let possibleWeeks = possibleWeeks, let startWeekDate = vc.dateScheduleQuery.startWeekDate else {
            return 0
        }

        let weeks = possibleWeeks.map { $0.startDate }
        return weeks.index(of: startWeekDate) ?? 0
    }

}
