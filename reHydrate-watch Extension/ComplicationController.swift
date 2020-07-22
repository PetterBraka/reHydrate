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
    var today = Day()
    let delegate = WKExtension.shared().delegate as! ExtensionDelegate
    var days: [Day] = []
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let currentDate = Date()
        handler(currentDate)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        days = delegate.days
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd/MM/yy"
        if days.contains(where: {formatter.string(from: $0.date) == formatter.string(from: Date.init())}){
            today = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: Date.init())})!
        } else {
            today = Day.init()
        }
        let fillFraction = today.consumed.amount / today.goal.amount
        switch complication.family {
            case .circularSmall:
                let template = CLKComplicationTemplateCircularSmallRingImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .open
                template.fillFraction = fillFraction
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .extraLarge:
                let template = CLKComplicationTemplateExtraLargeRingImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 45) else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .closed
                template.fillFraction = fillFraction
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .modularSmall:
                let template = CLKComplicationTemplateModularSmallRingImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .open
                template.fillFraction = fillFraction
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .modularLarge:
                let template = CLKComplicationTemplateModularLargeStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "reHydrate")
                template.body1TextProvider = CLKSimpleTextProvider(text: "\(today.consumed.amount)/\(today.goal.amount)")
                var body2 = String()
                if today.consumed.amount < today.goal.amount {
                    let toGo = today.goal.amount - today.consumed.amount
                    body2 = "\(String(format: "%.1f", toGo))L to go"
                } else {
                    body2 = "good job"
                }
                template.body2TextProvider = CLKSimpleTextProvider(text: body2)
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .utilitarianSmall:
                let template = CLKComplicationTemplateUtilitarianSmallRingImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .open
                template.fillFraction = fillFraction
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .utilitarianSmallFlat:
                let template = CLKComplicationTemplateUtilitarianSmallFlat()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.textProvider = CLKSimpleTextProvider(text: "\(today.consumed.amount)/\(today.goal.amount)")
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .utilitarianLarge:
                let template = CLKComplicationTemplateUtilitarianLargeFlat()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.textProvider = CLKSimpleTextProvider(text: "reHydrate")
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .graphicCorner:
                let template = CLKComplicationTemplateGraphicCornerGaugeText()
                template.outerTextProvider = CLKSimpleTextProvider(text: "\(today.consumed.amount)")
                template.leadingTextProvider = CLKSimpleTextProvider(text: "0")
                template.trailingTextProvider = CLKSimpleTextProvider(text: "\(today.goal.amount)")
                template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColors: [.cyan, .blue],
                                                                gaugeColorLocations: [0.5, 1], fillFraction: fillFraction)
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .graphicCircular:
                let template = CLKComplicationTemplateGraphicCircularOpenGaugeImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 9) else { break }
                template.bottomImageProvider = CLKFullColorImageProvider(fullColorImage: image)
                template.centerTextProvider = CLKSimpleTextProvider(text: "\(String(format: "%.1f", today.consumed.amount))")
                template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .white, fillFraction: fillFraction)
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .graphicBezel:
                let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 22) else { break }
                circularTemplate.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
//                circularTemplate.centerTextProvider = CLKSimpleTextProvider(text: "\(String(format: "%.1f", today.consumed.amount))")
                circularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .white, fillFraction: fillFraction)
                let template = CLKComplicationTemplateGraphicBezelCircularText()
                var body = String()
                if today.consumed.amount < today.goal.amount {
                    let toGo = today.goal.amount - today.consumed.amount
                    body = "\(String(format: "%.1f", toGo)) to go"
                } else {
                    body = "good job"
                }
                template.circularTemplate = circularTemplate
                template.textProvider = CLKSimpleTextProvider(text: body)
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .graphicRectangular:
                let template = CLKComplicationTemplateGraphicRectangularStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "reHydrate")
                template.body1TextProvider = CLKSimpleTextProvider(text: "\(today.consumed.amount)/\(today.goal.amount)")
                var body2 = String()
                if today.consumed.amount < today.goal.amount {
                    let toGo = today.goal.amount - today.consumed.amount
                    body2 = "\(String(format: "%.1f", toGo)) to go"
                } else {
                    body2 = "good job"
                }
                template.body2TextProvider = CLKSimpleTextProvider(text: body2)
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            default:
                handler(nil)
                return
        }
    }
    
    func getListOfEnteries(_ complication: CLKComplication) -> [CLKComplicationTimelineEntry] {
        days = delegate.days
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd/MM/yy"
        if days.contains(where: {formatter.string(from: $0.date) == formatter.string(from: Date.init())}){
            today = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: Date.init())})!
        } else {
            today = Day.init()
        }
        let fillFraction = today.consumed.amount / today.goal.amount
        
        var timelineEnteries = [CLKComplicationTimelineEntry]()
        var nextDate = Date(timeIntervalSinceNow: 60*60)
        
        for _ in 1...10 {
            switch complication.family {
                case .circularSmall:
                    let template = CLKComplicationTemplateCircularSmallRingImage()
                    guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { break }
                    template.imageProvider = CLKImageProvider(onePieceImage: image)
                    template.ringStyle = .closed
                    template.fillFraction = fillFraction
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .extraLarge:
                    let template = CLKComplicationTemplateExtraLargeRingImage()
                    guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 45) else { break }
                    template.imageProvider = CLKImageProvider(onePieceImage: image)
                    template.ringStyle = .closed
                    template.fillFraction = fillFraction
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .modularSmall:
                    let template = CLKComplicationTemplateModularSmallRingImage()
                    guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { break }
                    template.imageProvider = CLKImageProvider(onePieceImage: image)
                    template.ringStyle = .closed
                    template.fillFraction = fillFraction
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .modularLarge:
                    let template = CLKComplicationTemplateModularLargeStandardBody()
                    template.headerTextProvider = CLKSimpleTextProvider(text: "reHydrate")
                    template.body1TextProvider = CLKSimpleTextProvider(text: "\(today.consumed.amount)/\(today.goal.amount)")
                    var body2 = String()
                    if today.consumed.amount < today.goal.amount {
                        let toGo = today.goal.amount - today.consumed.amount
                        body2 = "\(String(format: "%.1f", toGo)) to go"
                    } else {
                        body2 = "good job"
                    }
                    template.body2TextProvider = CLKSimpleTextProvider(text: body2)
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .utilitarianSmall:
                    let template = CLKComplicationTemplateUtilitarianSmallRingImage()
                    guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { break}
                    template.imageProvider = CLKImageProvider(onePieceImage: image)
                    template.ringStyle = .closed
                    template.fillFraction = fillFraction
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .utilitarianSmallFlat:
                    let template = CLKComplicationTemplateUtilitarianSmallFlat()
                    guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { break }
                    template.imageProvider = CLKImageProvider(onePieceImage: image)
                    template.textProvider = CLKSimpleTextProvider(text:
                        "\(today.consumed.amount)/\(today.goal.amount)")
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .utilitarianLarge:
                    let template = CLKComplicationTemplateUtilitarianLargeFlat()
                    template.imageProvider = nil
                    template.textProvider = CLKSimpleTextProvider(text: "reHydrate")
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .graphicCorner:
                    let template = CLKComplicationTemplateGraphicCornerGaugeText()
                    template.outerTextProvider = CLKSimpleTextProvider(text: "\(today.consumed.amount)")
                    template.leadingTextProvider = CLKSimpleTextProvider(text: "0")
                    template.trailingTextProvider = CLKSimpleTextProvider(text: "\(today.goal.amount)")
                    template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColors: [.cyan, .blue],
                                                                    gaugeColorLocations: [0.5, 1], fillFraction: fillFraction)
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .graphicCircular:
                    let template = CLKComplicationTemplateGraphicCircularOpenGaugeImage()
                    guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 9) else { break }
                    template.bottomImageProvider = CLKFullColorImageProvider(fullColorImage: image.withTintColor(.white))
                    template.centerTextProvider = CLKSimpleTextProvider(text: "\(String(format: "%.1f", today.consumed.amount))")
                    template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .white, fillFraction: fillFraction)
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .graphicBezel:
                    let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeImage()
                    guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 22) else { break }
                    circularTemplate.imageProvider = CLKFullColorImageProvider(fullColorImage: image.withTintColor(.white))
                    circularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .white, fillFraction: fillFraction)
                    let template = CLKComplicationTemplateGraphicBezelCircularText()
                    var body = String()
                    if today.consumed.amount < today.goal.amount {
                        let toGo = today.goal.amount - today.consumed.amount
                        body = "\(String(format: "%.1f", toGo)) to go"
                    } else {
                        body = "good job"
                    }
                    template.circularTemplate = circularTemplate
                    template.textProvider = CLKSimpleTextProvider(text: body)
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .graphicRectangular:
                    let template = CLKComplicationTemplateGraphicRectangularStandardBody()
                    template.headerTextProvider = CLKSimpleTextProvider(text: "reHydrate")
                    template.body1TextProvider = CLKSimpleTextProvider(text: "\(today.consumed.amount)/\(today.goal.amount)")
                    var body2 = String()
                    if today.consumed.amount < today.goal.amount {
                        let toGo = today.goal.amount - today.consumed.amount
                        body2 = "\(String(format: "%.1f", toGo)) to go"
                    } else {
                        body2 = "good job"
                    }
                    template.body2TextProvider = CLKSimpleTextProvider(text: body2)
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                default:
                    break
            }
        }
        return timelineEnteries
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(getListOfEnteries(complication))
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(getListOfEnteries(complication))
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        switch complication.family {
            case .circularSmall:
                let template = CLKComplicationTemplateCircularSmallRingImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .open
                template.fillFraction = 0.2
                handler(template)
            case .extraLarge:
                let template = CLKComplicationTemplateExtraLargeRingImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 45) else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .closed
                template.fillFraction = 0.2
                handler(template)
            case .modularSmall:
                let template = CLKComplicationTemplateModularSmallRingImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .open
                template.fillFraction = 0.2
                handler(template)
            case .modularLarge:
                let template = CLKComplicationTemplateModularLargeStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "reHydrate")
                template.body1TextProvider = CLKSimpleTextProvider(text: "\(1)/\(3)")
                var body2 = String()
                body2 = "\(String(format: "%.1f", 2)) to go"
                template.body2TextProvider = CLKSimpleTextProvider(text: body2)
                handler(template)
            case .utilitarianSmall:
                let template = CLKComplicationTemplateUtilitarianSmallRingImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .open
                template.fillFraction = 0.2
                handler(template)
            case .utilitarianSmallFlat:
                let template = CLKComplicationTemplateUtilitarianSmallFlat()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.textProvider = CLKSimpleTextProvider(text:
                    "\(1)/\(3)")
                handler(template)
            case .utilitarianLarge:
                let template = CLKComplicationTemplateUtilitarianLargeFlat()
                template.imageProvider = nil
                template.textProvider = CLKSimpleTextProvider(text: "reHydrate")
                handler(template)
            case .graphicCorner:
                let template = CLKComplicationTemplateGraphicCornerGaugeText()
                template.outerTextProvider = CLKSimpleTextProvider(text: "\(0.6)")
                template.leadingTextProvider = CLKSimpleTextProvider(text: "0")
                template.trailingTextProvider = CLKSimpleTextProvider(text: "\(3)")
                template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColors: [.cyan, .blue],
                                                                gaugeColorLocations: [0.5, 1], fillFraction: 0.2)
                handler(template)
            case .graphicCircular:
                let template = CLKComplicationTemplateGraphicCircularOpenGaugeImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 9) else { break }
                template.bottomImageProvider = CLKFullColorImageProvider(fullColorImage: image.withTintColor(.white))
                template.centerTextProvider = CLKSimpleTextProvider(text: "0.6")
                template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .white, fillFraction: 0.2)
                handler(template)
            case .graphicBezel:
                let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 22) else { break }
                circularTemplate.imageProvider = CLKFullColorImageProvider(fullColorImage: image.withTintColor(.white))
                circularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .white, fillFraction: 0.2)
                let template = CLKComplicationTemplateGraphicBezelCircularText()
                template.circularTemplate = circularTemplate
                template.textProvider = CLKSimpleTextProvider(
                    text: "2.4 to go")
                handler(template)
            case .graphicRectangular:
                let template = CLKComplicationTemplateGraphicRectangularStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "reHydrate")
                template.body1TextProvider = CLKSimpleTextProvider(text: "\(0.6)/\(3)")
                var body2 = String()
                let toGo = 2.4
                body2 = "\(String(format: "%.1f", toGo)) to go"
                template.body2TextProvider = CLKSimpleTextProvider(text: body2)
                handler(template)
            default:
                handler(nil)
                return
        }
    }
}
