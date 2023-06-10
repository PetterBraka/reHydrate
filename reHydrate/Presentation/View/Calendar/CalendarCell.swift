//
//  CalendarCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 25/05/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import FSCalendar
import UIKit

enum SelectionType: Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class CalendarCell: FSCalendarCell {
    weak var todayHighlighter: UIImageView!
    weak var selectionLayer: UIImageView!

    var selectionType: SelectionType = .none {
        didSet { setNeedsLayout() }
    }

    required init!(coder _: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

//        let selectionLayer = UIImageView(image: UIImage.circle)
//        contentView.insertSubview(selectionLayer, at: 1)
//        self.selectionLayer = selectionLayer

//        let circleImageView = UIImageView(image: UIImage.circle.withRenderingMode(.alwaysTemplate))
//        circleImageView.tintColor = .systemBlue
//        contentView.insertSubview(circleImageView, at: 0)
//        todayHighlighter = circleImageView

        shapeLayer.isHidden = true

        let view = UIView(frame: bounds)
        backgroundView = view
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundView?.frame = bounds.insetBy(dx: 1, dy: 1)
        todayHighlighter.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width,
                                        height: contentView.bounds.height + 5)
        selectionLayer.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width,
                                      height: contentView.bounds.height + 5)
//        if selectionType == .middle {
//            selectionLayer.image = UIImage.midSelected
//        } else if selectionType == .leftBorder {
//            selectionLayer.image = UIImage.leftSelected
//        } else if selectionType == .rightBorder {
//            selectionLayer.image = UIImage.rightSelected
//        } else if selectionType == .single {
//            selectionLayer.image = UIImage.circle
//        }
    }

    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if isPlaceholder {
            eventIndicator.isHidden = true
            titleLabel.textColor = UIColor.lightGray
        }
    }
}
