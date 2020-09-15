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
        switch complication.family {
        case .circularSmall:
            let template    = CLKComplicationTemplateCircularSmallRingImage()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.fillFraction  = fillFraction
            template.ringStyle     = .open
            let timelineEntry      = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .extraLarge:
            let template    = CLKComplicationTemplateExtraLargeRingImage()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 45) else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.fillFraction  = fillFraction
            template.ringStyle     = .closed
            let timelineEntry      = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .modularSmall:
            let template    = CLKComplicationTemplateModularSmallRingImage()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.fillFraction  = fillFraction
            template.ringStyle     = .open
            let timelineEntry      = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "reHydrate")
            template.body1TextProvider  = CLKSimpleTextProvider(text: "\(todayConsumed .clean)/\(todayGoal .clean)")
            var body2 = String()
            if todayConsumed  < todayGoal  {
                let toGo = todayGoal  - todayConsumed
                body2 = "\(toGo.clean) \(NSLocalizedString("toGo", comment: ""))"
            } else { body2 = "\(NSLocalizedString("goodJob", comment: ""))" }
            template.body2TextProvider = CLKSimpleTextProvider(text: body2)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .utilitarianSmall:
            let template    = CLKComplicationTemplateUtilitarianSmallRingImage()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.fillFraction  = fillFraction
            template.ringStyle     = .open
            let timelineEntry      = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .utilitarianSmallFlat:
            let template    = CLKComplicationTemplateUtilitarianSmallFlat()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.textProvider  = CLKSimpleTextProvider(text: "\(todayConsumed .clean)/\(todayGoal .clean)")
            let timelineEntry      = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .utilitarianLarge:
            let template    = CLKComplicationTemplateUtilitarianLargeFlat()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            var body = String()
            if todayConsumed  < todayGoal  {
                let toGo = todayGoal  - todayConsumed
                body = "\(toGo.clean) \(NSLocalizedString("toGo", comment: ""))"
            } else { body = "\(NSLocalizedString("goodJob", comment: ""))" }
            template.textProvider  = CLKSimpleTextProvider(text: body)
            let timelineEntry      = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCornerGaugeText()
            template.outerTextProvider    = CLKSimpleTextProvider(text: "\(todayConsumed .clean)")
            template.leadingTextProvider  = CLKSimpleTextProvider(text: "0")
            template.trailingTextProvider = CLKSimpleTextProvider(text: "\(todayGoal .clean)")
            template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .graphicCircular:
            let template    = CLKComplicationTemplateGraphicCircularOpenGaugeImage()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 9) else { break }
            template.bottomImageProvider = CLKFullColorImageProvider(fullColorImage: image)
            template.centerTextProvider  = CLKSimpleTextProvider(text: "\(todayConsumed .clean)")
            template.gaugeProvider       = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .graphicBezel:
            let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeImage()
            guard let image      = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 22) else { break }
            circularTemplate.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
            circularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            var body = String()
            if todayConsumed  < todayGoal  {
                let toGo = todayGoal  - todayConsumed
                body = "\(toGo.clean) \(NSLocalizedString("toGo", comment: ""))"
            } else { body = "\(NSLocalizedString("goodJob", comment: ""))" }
            template.circularTemplate = circularTemplate
            template.textProvider     = CLKSimpleTextProvider(text: body)
            let timelineEntry         = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .graphicRectangular:
            let template = CLKComplicationTemplateGraphicRectangularTextGauge()
            template.headerTextProvider = CLKSimpleTextProvider(text: "reHydrate")
            var body1 = String()
            if todayConsumed  < todayGoal  {
                let toGo = todayGoal  - todayConsumed
                body1 = "\(toGo.clean) \(NSLocalizedString("toGo", comment: ""))"
            } else { body1 = "\(NSLocalizedString("goodJob", comment: ""))" }
            template.body1TextProvider = CLKSimpleTextProvider(text: body1)
            template.gaugeProvider     = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
            let timelineEntry          = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        default:
            handler(nil)
            return
        }
    }
    
    func getListOfEnteries(_ complication: CLKComplication) -> [CLKComplicationTimelineEntry] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd/MM/yy"
        todayConsumed = delegate.todayConsumed
        todayGoal = delegate.todayGoal
        todayDate = delegate.todayDate
        todayDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: todayDate)!
        var fillFraction = Float()
        var timelineEnteries = [CLKComplicationTimelineEntry]()
        
        for _ in 0...1 {
            if todayConsumed  / todayGoal  < 1 {
                fillFraction = Float(todayConsumed  / todayGoal )
            } else {
                fillFraction = 1
            }
            
            switch complication.family {
            case .circularSmall:
                let template    = CLKComplicationTemplateCircularSmallRingImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.fillFraction  = fillFraction
                template.ringStyle     = .closed
                let timelineEntry      = CLKComplicationTimelineEntry(date: todayDate, complicationTemplate: template)
                timelineEnteries.append(timelineEntry)
            case .extraLarge:
                let template    = CLKComplicationTemplateExtraLargeRingImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 45) else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.fillFraction  = fillFraction
                template.ringStyle     = .closed
                let timelineEntry      = CLKComplicationTimelineEntry(date: todayDate, complicationTemplate: template)
                timelineEnteries.append(timelineEntry)
            case .modularSmall:
                let template    = CLKComplicationTemplateModularSmallRingImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.fillFraction  = fillFraction
                template.ringStyle     = .closed
                let timelineEntry      = CLKComplicationTimelineEntry(date: todayDate, complicationTemplate: template)
                timelineEnteries.append(timelineEntry)
            case .modularLarge:
                let template = CLKComplicationTemplateModularLargeStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "reHydrate")
                template.body1TextProvider = CLKSimpleTextProvider(text: "\(todayConsumed .clean)/\(todayGoal .clean)")
                var body2 = String()
                if todayConsumed  < todayGoal  {
                    let toGo = todayGoal  - todayConsumed
                    body2 = "\(toGo.clean) \(NSLocalizedString("toGo", comment: ""))"
                } else { body2 = "\(NSLocalizedString("goodJob", comment: ""))" }
                template.body2TextProvider = CLKSimpleTextProvider(text: body2)
                let timelineEntry = CLKComplicationTimelineEntry(date: todayDate, complicationTemplate: template)
                timelineEnteries.append(timelineEntry)
            case .utilitarianSmall:
                let template    = CLKComplicationTemplateUtilitarianSmallRingImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { break}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.fillFraction  = fillFraction
                template.ringStyle     = .closed
                let timelineEntry      = CLKComplicationTimelineEntry(date: todayDate, complicationTemplate: template)
                timelineEnteries.append(timelineEntry)
            case .utilitarianSmallFlat:
                let template    = CLKComplicationTemplateUtilitarianSmallFlat()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.textProvider  = CLKSimpleTextProvider(text: "\(todayConsumed .clean)/\(todayGoal .clean)")
                let timelineEntry      = CLKComplicationTimelineEntry(date: todayDate, complicationTemplate: template)
                timelineEnteries.append(timelineEntry)
            case .utilitarianLarge:
                let template = CLKComplicationTemplateUtilitarianLargeFlat()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                var body = String()
                if todayConsumed  < todayGoal  {
                    let toGo = todayGoal  - todayConsumed
                    body = "\(toGo.clean) \(NSLocalizedString("toGo", comment: ""))"
                } else { body = "\(NSLocalizedString("goodJob", comment: ""))" }
                template.textProvider  = CLKSimpleTextProvider(text: body)
                let timelineEntry = CLKComplicationTimelineEntry(date: todayDate, complicationTemplate: template)
                timelineEnteries.append(timelineEntry)
            case .graphicCorner:
                let template = CLKComplicationTemplateGraphicCornerGaugeText()
                template.outerTextProvider    = CLKSimpleTextProvider(text: "\(todayConsumed .clean)")
                template.leadingTextProvider  = CLKSimpleTextProvider(text: "0")
                template.trailingTextProvider = CLKSimpleTextProvider(text: "\(todayGoal .clean)")
                template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
                let timelineEntry = CLKComplicationTimelineEntry(date: todayDate, complicationTemplate: template)
                timelineEnteries.append(timelineEntry)
            case .graphicCircular:
                let template    = CLKComplicationTemplateGraphicCircularOpenGaugeImage()
                guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 9) else { break }
                template.bottomImageProvider = CLKFullColorImageProvider(fullColorImage: image.withTintColor(.white))
                template.centerTextProvider  = CLKSimpleTextProvider(text: "\(todayConsumed .clean)")
                template.gaugeProvider       = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
                let timelineEntry = CLKComplicationTimelineEntry(date: todayDate, complicationTemplate: template)
                timelineEnteries.append(timelineEntry)
            case .graphicBezel:
                let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeImage()
                guard let image      = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 22) else { break }
                circularTemplate.imageProvider = CLKFullColorImageProvider(fullColorImage: image.withTintColor(.white))
                circularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
                let template = CLKComplicationTemplateGraphicBezelCircularText()
                var body = String()
                if todayConsumed  < todayGoal  {
                    let toGo = todayGoal  - todayConsumed
                    body = "\(toGo.clean) \(NSLocalizedString("toGo", comment: ""))"
                } else { body = "\(NSLocalizedString("goodJob", comment: ""))" }
                template.circularTemplate = circularTemplate
                template.textProvider     = CLKSimpleTextProvider(text: body)
                let timelineEntry = CLKComplicationTimelineEntry(date: todayDate, complicationTemplate: template)
                timelineEnteries.append(timelineEntry)
            case .graphicRectangular:
                let template = CLKComplicationTemplateGraphicRectangularTextGauge()
                template.headerTextProvider = CLKSimpleTextProvider(text: "reHydrate")
                var body1 = String()
                if todayConsumed  <= todayGoal  {
                    let toGo = todayGoal  - todayConsumed
                    body1 = "\(toGo.clean) \(NSLocalizedString("toGo", comment: ""))"
                } else {
                    body1 = "\(NSLocalizedString("goodJob", comment: ""))"
                }
                template.body1TextProvider = CLKSimpleTextProvider(text: body1)
                template.gaugeProvider     = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: fillFraction)
                let timelineEntry = CLKComplicationTimelineEntry(date: todayDate, complicationTemplate: template)
                timelineEnteries.append(timelineEntry)
            default:
                break
            }
            self.todayConsumed = 0
            let tomorrowsDate = Calendar.current.date(byAdding: .day, value: 1, to: todayDate)!
            let tomorrow = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: tomorrowsDate)!
            self.todayDate = tomorrow
        }
        
        
        return timelineEnteries
    }
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        switch complication.family {
        case .circularSmall:
            let template    = CLKComplicationTemplateCircularSmallRingImage()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.fillFraction  = 0.2
            template.ringStyle     = .open
            handler(template)
        case .extraLarge:
            let template    = CLKComplicationTemplateExtraLargeRingImage()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 45) else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.fillFraction  = 0.2
            template.ringStyle     = .closed
            handler(template)
        case .modularSmall:
            let template    = CLKComplicationTemplateModularSmallRingImage()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.fillFraction  = 0.2
            template.ringStyle     = .open
            handler(template)
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "reHydrate")
            template.body1TextProvider  = CLKSimpleTextProvider(text: "1/3")
            template.body2TextProvider  = CLKSimpleTextProvider(text: "2 \(NSLocalizedString("toGo", comment: ""))")
            handler(template)
        case .utilitarianSmall:
            let template    = CLKComplicationTemplateUtilitarianSmallRingImage()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.fillFraction  = 0.2
            template.ringStyle     = .open
            handler(template)
        case .utilitarianSmallFlat:
            let template    = CLKComplicationTemplateUtilitarianSmallFlat()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.textProvider  = CLKSimpleTextProvider(text:"1/3")
            handler(template)
        case .utilitarianLarge:
            let template    = CLKComplicationTemplateUtilitarianLargeFlat()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white) else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.textProvider  = CLKSimpleTextProvider(text: "2.4 \(NSLocalizedString("toGo", comment: ""))")
            handler(template)
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCornerGaugeText()
            template.outerTextProvider    = CLKSimpleTextProvider(text: "0.6")
            template.leadingTextProvider  = CLKSimpleTextProvider(text: "0")
            template.trailingTextProvider = CLKSimpleTextProvider(text: "3")
            template.gaugeProvider        = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: 0.2)
            handler(template)
        case .graphicCircular:
            let template    = CLKComplicationTemplateGraphicCircularOpenGaugeImage()
            guard let image = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 9) else { break }
            template.bottomImageProvider = CLKFullColorImageProvider(fullColorImage: image.withTintColor(.white))
            template.centerTextProvider  = CLKSimpleTextProvider(text: "0.6")
            template.gaugeProvider       = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: 0.2)
            handler(template)
        case .graphicBezel:
            let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeImage()
            guard let image      = UIImage(named: "waterDrop")?.withTintColor(.white).resized(toWidth: 22) else { break }
            circularTemplate.imageProvider = CLKFullColorImageProvider(fullColorImage: image.withTintColor(.white))
            circularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: 0.2)
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            template.circularTemplate = circularTemplate
            template.textProvider     = CLKSimpleTextProvider(text: "2.4 \(NSLocalizedString("toGo", comment: ""))")
            handler(template)
        case .graphicRectangular:
            let template = CLKComplicationTemplateGraphicRectangularTextGauge()
            template.headerImageProvider = nil
            template.headerTextProvider  = CLKSimpleTextProvider(text: "reHydrate")
            template.body1TextProvider   = CLKSimpleTextProvider(text: "2.4 \(NSLocalizedString("toGo", comment: ""))")
            template.gaugeProvider       = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor().hexStringToUIColor("4a90e2"), fillFraction: 0.2)
            handler(template)
        default:
            handler(nil)
            return
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(getListOfEnteries(complication))
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(getListOfEnteries(complication))
    }
}
