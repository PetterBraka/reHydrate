//
//  CalendarCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 25/05/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import FSCalendar

enum SelectionType : Int {
    case none
    case single
}

class CalendarCell: FSCalendarCell {
    
    weak var todayHighlighter: UIImageView!
    weak var selectionLayer: UIImageView!
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let selectionLayer = UIImageView(image: UIImage(named: "circle"))
        self.contentView.insertSubview(selectionLayer, at: 1)
        self.selectionLayer = selectionLayer
        
        let circleImageView = UIImageView(image: UIImage(named: "circle")?.withRenderingMode(.alwaysTemplate))
        circleImageView.tintColor = .systemBlue
        self.contentView.insertSubview(circleImageView, at: 0)
        todayHighlighter = circleImageView
        
        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
        self.backgroundView = view;
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.todayHighlighter.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height + 5)
        self.selectionLayer.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height + 5)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
}
