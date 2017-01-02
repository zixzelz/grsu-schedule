//
//  SchedulesPageViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/20/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class BaseSchedulesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBInspectable var backgroundColor: UIColor = UIColor.whiteColor()

    @IBOutlet private var navigationTitle: UILabel!
    @IBOutlet private var pageControl: UIPageControl!

    var possibleWeeks: [GSWeekItem]?
    var dateScheduleQuery: DateScheduleQuery?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.dataSource = self
        self.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundColor
        setupPageController()

        navigationController?.hidesBarsOnSwipe = true

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseSchedulesPageViewController.favoritWillRemoveNotification(_:)), name: GSFavoriteManagerFavoritWillRemoveNotificationKey, object: nil)
    }

    func setupPageController() {
        guard let possibleWeeks = possibleWeeks,
            dateScheduleQuery = dateScheduleQuery else {
                pageControl.numberOfPages = 0
                updateNavigationTitle()
                return
        }
        let weeks = possibleWeeks.map { $0.startDate }
        let currentPage: Int = weeks.indexOf(dateScheduleQuery.startWeekDate!) ?? 0

        pageControl.numberOfPages = possibleWeeks.count
        pageControl.currentPage = currentPage
        updateNavigationTitle()

        let vc = weekScheduleController()
        self.setViewControllers([vc], direction: .Forward, animated: false, completion: nil)
    }

    func updateNavigationTitle() {
        guard let possibleWeeks = possibleWeeks else { return }

        let index = pageControl.currentPage
        let text: String? = (possibleWeeks.count > 0) ? possibleWeeks[index].value : nil

        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.navigationTitle.alpha = 0.0
            self.navigationTitle.text = text
            self.navigationTitle.alpha = 1.0
        })
    }

    func weekScheduleController(weekIndex: Int? = nil) -> UIViewController {
        fatalError("You must override !!!")
    }

    func favoritWillRemoveNotification(notification: NSNotification) {
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var vc: UIViewController?
        if (pageControl.currentPage > 0) {
            let index = pageControl.currentPage - 1
            vc = weekScheduleController(index)
        }
        return vc
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var vc: UIViewController?
        if (pageControl.currentPage < pageControl.numberOfPages - 1) {
            let index = pageControl.currentPage + 1
            vc = weekScheduleController(index)
        }
        return vc
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if (completed) {

            if let vc = pageViewController.viewControllers?.last as? WeekSchedulesViewController {
                let index = indexOfViewController(vc)
                pageControl.currentPage = index
                updateNavigationTitle()
            }
        }
    }

    // MARK: - Utils

    func indexOfViewController(vc: WeekSchedulesViewController) -> Int {
        guard let possibleWeeks = possibleWeeks else { return 0 }

        let weeks = possibleWeeks.map { $0.startDate } as [NSDate]
        return weeks.indexOf(vc.dateScheduleQuery.startWeekDate!)!
    }

}
