//
//  TintImageView.swift
//  Intuition
//
//  Created by Ruslan Maslouski on 4/29/15.
//  Copyright (c) 2015 Intuition inc. All rights reserved.
//

import UIKit

@IBDesignable
class TintImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let image = self.image
        self.image = nil
        self.image = image?.tintImage(tintColor)
    }
    
//    override var image: UIImage? {
//        didSet {
//            let image = self.image
//            super.image = nil
//            super.image = image
//        }
//    }
    
}
