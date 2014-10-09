//
//  FlexibleLabel.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/30/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit

class FlexibleLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        if numberOfLines == 0 && preferredMaxLayoutWidth != frame.size.width {
            preferredMaxLayoutWidth = frame.size.width
            setNeedsUpdateConstraints()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        var size = super.intrinsicContentSize()
        if numberOfLines == 0 {
            size.height += 1
        }
        return size;
    }
}
