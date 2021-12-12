//
//  ComplicationController.swift
//  reHydrate-watch Extension
//
//  Created by Petter vang Brakalsvålet on 07/07/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    var todayConsumed = Double()
    var todayGoal = Double()
    var todayDate = Date()
    let delegate = WKExtension.shared().delegate as! ExtensionDelegate
    
    func complicationDescriptors() async -> [CLKComplicationDescriptor] {
        let descriptor = CLKComplicationDescriptor(identifier: "reHydrate",
                                                   displayName: "reHydrate - Water tracker",
                                                   supportedFamilies: CLKComplicationFamily.allCases)
        return [descriptor]
    }
    
    func currentTimelineEntry(for complication: CLKComplication) async -> CLKComplicationTimelineEntry? {
        // Call the handler with the current timeline entry
        todayConsumed = delegate.todayConsumed
        todayGoal = delegate.todayGoal
        todayDate = delegate.todayDate
        if let template = getComplication(for: complication.family) {
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            return timelineEntry
        }
        return nil
    }
    
    func privacyBehavior(for complication: CLKComplication) async -> CLKComplicationPrivacyBehavior { .showOnLockScreen }
    
    func timelineEndDate(for complication: CLKComplication) async -> Date? { return nil }
    
    func timelineEntries(for complication: CLKComplication, after date: Date, limit: Int) async -> [CLKComplicationTimelineEntry]? {
        todayConsumed = delegate.todayConsumed
        todayGoal = delegate.todayGoal
        todayDate = delegate.todayDate
        todayDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: todayDate)!
        
        if let template = getComplication(for: complication.family) {
            let timelineEntry = CLKComplicationTimelineEntry(date: todayDate, complicationTemplate: template)
            return [timelineEntry]
        }
        
        return nil
    }
    
    func localizableSampleTemplate(for complication: CLKComplication) async -> CLKComplicationTemplate? {
        todayConsumed = delegate.todayConsumed
        todayGoal = delegate.todayGoal
        todayDate = delegate.todayDate
        todayDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: todayDate)!
        
        return getComplication(for: complication.family)
    }
    
    func getComplication(for family: CLKComplicationFamily) -> CLKComplicationTemplate? {
        let waterDrop = UIImage.waterDrop.withTintColor(.white)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd/MM/yy"
        todayConsumed = delegate.todayConsumed
        todayGoal = delegate.todayGoal
        todayDate = delegate.todayDate
        var fillFraction = Float()
        if todayConsumed / todayGoal < 1 {
            fillFraction = Float(todayConsumed / todayGoal)
        } else {
            fillFraction = 1
        }
        switch family {
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallRingImage(
                imageProvider: .init(onePieceImage: waterDrop),
                fillFraction: fillFraction,
                ringStyle: .open)
            return template
        case .extraLarge:
            let image = waterDrop.resized(toWidth: 45)!
            let template = CLKComplicationTemplateExtraLargeRingImage(
                imageProvider: .init(onePieceImage: image),
                fillFraction: fillFraction,
                ringStyle: .closed)
            return template
        case .graphicExtraLarge:
            let image = waterDrop.resized(toWidth: 45)!
            let guage = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
            let template = CLKComplicationTemplateGraphicExtraLargeCircularOpenGaugeImage(
                gaugeProvider: guage,
                bottomImageProvider: .init(fullColorImage: image),
                centerTextProvider: CLKSimpleTextProvider(text: todayConsumed.clean))
            return template
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallRingImage(
                imageProvider: .init(onePieceImage: waterDrop),
                fillFraction: fillFraction,
                ringStyle: .open)
            return template
        case .modularLarge:
            var body2 = String()
            if todayConsumed  < todayGoal  {
                let toGo = todayGoal  - todayConsumed
                body2 = "\(toGo.clean) \(NSLocalizedString("toGo", comment: ""))"
            } else { body2 = "\(NSLocalizedString("goodJob", comment: ""))" }
            let template = CLKComplicationTemplateModularLargeStandardBody(
                headerTextProvider: CLKSimpleTextProvider(text: "reHydrate"),
                body1TextProvider: CLKSimpleTextProvider(text: "\(todayConsumed .clean)/\(todayGoal .clean)"),
                body2TextProvider: CLKSimpleTextProvider(text: body2))
            return template
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallRingImage(
                imageProvider: .init(onePieceImage: waterDrop),
                fillFraction: fillFraction,
                ringStyle: .open)
            return template
        case .utilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat(
                textProvider: CLKSimpleTextProvider(text: "\(todayConsumed .clean)/\(todayGoal .clean)"),
                imageProvider: .init(onePieceImage: waterDrop))
            return template
        case .utilitarianLarge:
            var body = String()
            if todayConsumed  < todayGoal  {
                let toGo = todayGoal  - todayConsumed
                body = "\(toGo.clean) \(NSLocalizedString("toGo", comment: ""))"
            } else { body = "\(NSLocalizedString("goodJob", comment: ""))" }
            let template = CLKComplicationTemplateUtilitarianLargeFlat(
                textProvider: CLKSimpleTextProvider(text: body),
                imageProvider: .init(onePieceImage: waterDrop))
            return template
        case .graphicCorner:
            let guage = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
            let template = CLKComplicationTemplateGraphicCornerGaugeText(
                gaugeProvider: guage,
                leadingTextProvider: CLKSimpleTextProvider(text: "0"),
                trailingTextProvider: CLKSimpleTextProvider(text: "\(todayGoal .clean)"),
                outerTextProvider: CLKSimpleTextProvider(text: "\(todayConsumed .clean)"))
            return template
        case .graphicCircular:
            let image = waterDrop.resized(toWidth: 10)!
            let guage = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
            let template = CLKComplicationTemplateGraphicCircularOpenGaugeImage(
                gaugeProvider: guage,
                bottomImageProvider: .init(fullColorImage: image),
                centerTextProvider: CLKSimpleTextProvider(text: "\(todayConsumed .clean)"))
            return template
        case .graphicBezel:
            let image = waterDrop.resized(toWidth: 20)!
            let guage = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
            let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeImage(
                gaugeProvider: guage,
                imageProvider: CLKFullColorImageProvider(fullColorImage: image))
            var body = String()
            if todayConsumed  < todayGoal  {
                let toGo = todayGoal  - todayConsumed
                body = "\(toGo.clean) \(NSLocalizedString("toGo", comment: ""))"
            } else { body = "\(NSLocalizedString("goodJob", comment: ""))" }
            let template = CLKComplicationTemplateGraphicBezelCircularText(
                circularTemplate: circularTemplate,
                textProvider: CLKSimpleTextProvider(text: body))
            return template
        case .graphicRectangular:
            var body1 = String()
            if todayConsumed  < todayGoal  {
                let toGo = todayGoal  - todayConsumed
                body1 = "\(toGo.clean) \(NSLocalizedString("toGo", comment: ""))"
            } else { body1 = "\(NSLocalizedString("goodJob", comment: ""))" }
            let guage = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
            let template = CLKComplicationTemplateGraphicRectangularTextGauge(
                headerTextProvider: CLKSimpleTextProvider(text: "reHydrate"),
                body1TextProvider: CLKSimpleTextProvider(text: body1),
                gaugeProvider: guage)
            return template
        default:
            return nil
        }
    }
}
