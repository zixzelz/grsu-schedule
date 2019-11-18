//
//  TodayViewControllerViewModel.swift
//  grsu.today
//
//  Created by Ruslan Maslouski on 06/11/2019.
//  Copyright © 2019 Ruslan Maslouski. All rights reserved.
//

import Foundation
import ServiceLayerSDK
import ReactiveSwift
import Result

class TodayViewControllerViewModel: TodayViewControllerViewModeling {

    private let allLessons: MutableProperty<[LessonScheduleEntity]> = MutableProperty([])
    private var fetchResult: FetchResult<LessonScheduleEntity>
    var listViewModel: ListViewModel<StudentLessonCellViewModeling>

    init() {

        let loadDataAction = Action<(ScheduleDataSource, Bool), [LessonScheduleEntity], ServiceError> { dataSource, useCache -> SignalProducer<[LessonScheduleEntity], ServiceError> in
            let cache: CachePolicy = useCache ? .cachedElseLoad : .reloadIgnoringCache
            return dataSource.fetchData(cache: cache)
        }

        let groupedItemsSignal = loadDataAction.values.map { items -> [[LessonScheduleEntity]] in

            let date = Date()
            let result = items.filter { lesson -> Bool in
                lesson.endLessonDate > date
            }.prefix(12)

            return Array(result).grouped { _, item in
                return item.date
            }
        }
        let groupedItemsProperty = Property(initial: [], then: groupedItemsSignal)

        fetchResult = FetchResult<LessonScheduleEntity>.reactiveCustomResult(property: groupedItemsProperty, load: { _ in
            let beginDate = Date.startOfDay
            let endDate = Calendar.current.date(byAdding: .day, value: 4, to: beginDate)!
            let dataSource: ScheduleDataSource = .student(id: "152934", beginDate: beginDate, endDate: endDate)

            return loadDataAction.apply((dataSource, true))
                .map { _ in nil }
                .mapError { NSError.error(from: $0) }
        })

        listViewModel = ListViewModel.model(fetchResult: fetchResult,
                                            mapSectionTitle: { [unowned fetchResult] section -> String? in
                                                guard fetchResult.numberOfRows(inSection: section) > 0 else {
                                                    return nil
                                                }
                                                let item = fetchResult.object(at: IndexPath(row: 0, section: section))
                                                return item.date.dayOfWeekAndMonthAndDayFormatter
                                            },
                                            cellViewModel: { lesson -> StudentLessonCellViewModeling in
                                                return StudentLessonCellViewModel(lesson: lesson)
                                            })
    }

    func refresh() {
        fetchResult.refresh()
    }

//    private func reloadData(dataSource: ScheduleDataSource, useCache: Bool = true, complited: @escaping (_ success: Bool) -> Void) {
//        let cache: CachePolicy = useCache ? .cachedElseLoad : .reloadIgnoringCacheы
//                self?.allLessons.value = items
//                complited(true)
//            case .failure(let error):
//                print("error: \(error)")
//                complited(false)
////                Flurry.logError(error, errId: "StudentWeekSchedulesViewController")
////                strongSelf.showMessage(L10n.loadingFailedMessage)
//                break
//            }
//        }
//    }

}

class StudentLessonCellViewModel: StudentLessonCellViewModeling {

    private var lesson: LessonScheduleEntity

    var name: String? {
        return lesson.studyName
    }
    var type: String? {
        return lesson.type
    }
    var startTime: String {
        return timeTextWithTimeInterval(Int(lesson.startTime))
    }
    var stopTime: String {
        return timeTextWithTimeInterval(Int(lesson.stopTime))
    }

    init(lesson: LessonScheduleEntity) {
        self.lesson = lesson
    }

    private func timeTextWithTimeInterval(_ interval: Int) -> String {
        let h: Int = interval / 60
        let m: Int = interval % 60

        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2

        return formatter.string(from: NSNumber(value: h))! + ":" + formatter.string(from: NSNumber(value: m))!
    }
}
