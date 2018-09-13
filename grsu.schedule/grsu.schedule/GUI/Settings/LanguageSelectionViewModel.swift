//
//  LanguageSelectionViewModel.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/13/18.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import Foundation

class LanguageSelectionViewModel: LanguageSelectionViewModeling {

    lazy var fetchResult: ReactiveFetchResult<LanguageItem> = {
        let languages = Locale.languages
        return ReactiveFetchResult(items: languages)
    }()

    lazy var listViewModel: ListViewModel<LanguageSelectionCellViewModeling> = {
        let lvm = ListViewModel.model(fetchResult: fetchResult, cellViewModel: { item -> LanguageSelectionCellViewModeling in
            return item.title
        })

        lvm.selectedCells.producer.startWithValues { [unowned self] selectedItems in
            if let item = selectedItems.first.map ({ self.fetchResult.object(at: $0) }) {
                UserDefaults.selectedLanguage = item
            }
        }

        return lvm
    }()

    init(defaultLanguage: LanguageItem? = nil) {
        let item = defaultLanguage ?? .defaultValue
        if let indexPath = fetchResult.indexPathForObject(item) {
            listViewModel.selectRowAtIndexPath(indexPath)
        }
    }

}
