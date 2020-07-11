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
        switch complication.family {
            case .modularSmall:
                let template = CLKComplicationTemplateModularSmallRingImage()
                guard let image = UIImage(named: "Water-drop") else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .open
                template.fillFraction = 1
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .modularLarge:
                let template = CLKComplicationTemplateModularLargeStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "header")
                template.body1TextProvider = CLKSimpleTextProvider(text: "body1")
                template.body2TextProvider = CLKSimpleTextProvider(text: "body2")
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .utilitarianSmall:
                let template = CLKComplicationTemplateUtilitarianSmallRingImage()
                guard let image = UIImage(named: "Water-drop") else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .open
                template.fillFraction = 1
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .utilitarianSmallFlat:
                let template = CLKComplicationTemplateUtilitarianSmallFlat()
                guard let image = UIImage(named: "Water-drop") else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.textProvider = CLKSimpleTextProvider(text: "reHydrate")
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .utilitarianLarge:
                let template = CLKComplicationTemplateUtilitarianLargeFlat()
                guard let image = UIImage(named: "Water-drop") else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.textProvider = CLKSimpleTextProvider(text: "reHydrate")
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .graphicBezel:
                let template = CLKComplicationTemplateGraphicBezelCircularText()
                template.circularTemplate = CLKComplicationTemplateGraphicCircularStackImage()
                template.textProvider = CLKSimpleTextProvider(text: "reHydrate")
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .graphicCorner:
                let template = CLKComplicationTemplateGraphicCornerGaugeImage()
                guard let image = UIImage(named: "AppIcon") else { handler(nil); return}
                template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .blue, fillFraction: 0)
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .graphicCircular:
                let template = CLKComplicationTemplateGraphicCircularImage()
                guard let image = UIImage(named: "Water-drop") else { handler(nil); return}
                template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .graphicRectangular:
                let template = CLKComplicationTemplateGraphicRectangularStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "header")
                template.body1TextProvider = CLKSimpleTextProvider(text: "body1")
                template.body2TextProvider = CLKSimpleTextProvider(text: "body2")
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            case .circularSmall:
                let template = CLKComplicationTemplateCircularSmallRingImage()
                guard let image = UIImage(named: "Water-drop") else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .open
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            default:
                handler(nil)
                return
        }
    }
    
    func getListOfEnteries(_ complication: CLKComplication) -> [CLKComplicationTimelineEntry] {
        
        var timelineEnteries = [CLKComplicationTimelineEntry]()
        var nextDate = Date(timeIntervalSinceNow: 60*60)
        
        for _ in 1...12 {
            switch complication.family {
                case .modularSmall:
                    let template = CLKComplicationTemplateModularSmallRingImage()
                    guard let image = UIImage(named: "Water-drop") else { break }
                    template.imageProvider = CLKImageProvider(onePieceImage: image)
                    template.ringStyle = .open
                    template.fillFraction = 1
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .modularLarge:
                    let template = CLKComplicationTemplateModularLargeStandardBody()
                    template.headerTextProvider = CLKSimpleTextProvider(text: "header")
                    template.body1TextProvider = CLKSimpleTextProvider(text: "body1")
                    template.body2TextProvider = CLKSimpleTextProvider(text: "body2")
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .utilitarianSmall:
                    let template = CLKComplicationTemplateUtilitarianSmallRingImage()
                    guard let image = UIImage(named: "Water-drop") else { break}
                    template.imageProvider = CLKImageProvider(onePieceImage: image)
                    template.ringStyle = .open
                    template.fillFraction = 1
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .utilitarianSmallFlat:
                    let template = CLKComplicationTemplateUtilitarianSmallFlat()
                    guard let image = UIImage(named: "Water-drop") else { break }
                    template.imageProvider = CLKImageProvider(onePieceImage: image)
                    template.textProvider = CLKSimpleTextProvider(text: "reHydrate")
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .utilitarianLarge:
                    let template = CLKComplicationTemplateUtilitarianLargeFlat()
                    guard let image = UIImage(named: "Water-drop") else { break }
                    template.imageProvider = CLKImageProvider(onePieceImage: image)
                    template.textProvider = CLKSimpleTextProvider(text: "reHydrate")
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .graphicBezel:
                    let template = CLKComplicationTemplateGraphicBezelCircularText()
                    template.circularTemplate = CLKComplicationTemplateGraphicCircularStackImage()
                    template.textProvider = CLKSimpleTextProvider(text: "reHydrate")
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .graphicCorner:
                    let template = CLKComplicationTemplateGraphicCornerGaugeImage()
                    guard let image = UIImage(named: "AppIcon") else { break }
                    template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                    template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .blue, fillFraction: 0)
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .graphicCircular:
                    let template = CLKComplicationTemplateGraphicCircularImage()
                    guard let image = UIImage(named: "Water-drop") else { break }
                    template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .graphicRectangular:
                    let template = CLKComplicationTemplateGraphicRectangularStandardBody()
                    template.headerTextProvider = CLKSimpleTextProvider(text: "header")
                    template.body1TextProvider = CLKSimpleTextProvider(text: "body1")
                    template.body2TextProvider = CLKSimpleTextProvider(text: "body2")
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    timelineEnteries.append(timelineEntry)
                    nextDate = nextDate.addingTimeInterval(60 * 60)
                case .circularSmall:
                    let template = CLKComplicationTemplateCircularSmallRingImage()
                    guard let image = UIImage(named: "Water-drop") else { break }
                    template.imageProvider = CLKImageProvider(onePieceImage: image)
                    template.ringStyle = .open
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
        switch complication.family {
            case .modularLarge:
                handler(getListOfEnteries(complication))
            default:
                handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(getListOfEnteries(complication))
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        switch complication.family {
            case .modularSmall:
                let template = CLKComplicationTemplateModularSmallRingImage()
                guard let image = UIImage(named: "Water-drop") else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .open
                template.fillFraction = 2
                handler(template)
            case .modularLarge:
                let template = CLKComplicationTemplateModularLargeStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "header")
                template.body1TextProvider = CLKSimpleTextProvider(text: "body1")
                template.body2TextProvider = CLKSimpleTextProvider(text: "body2")
                handler(template)
            case .utilitarianSmall:
                let template = CLKComplicationTemplateUtilitarianSmallRingImage()
                guard let image = UIImage(named: "Water-drop") else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .open
                template.fillFraction = 2
                handler(template)
            case .utilitarianSmallFlat:
                let template = CLKComplicationTemplateUtilitarianSmallFlat()
                guard let image = UIImage(named: "Water-drop") else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.textProvider = CLKSimpleTextProvider(text: "reHydrate")
                handler(template)
            case .utilitarianLarge:
                let template = CLKComplicationTemplateUtilitarianLargeFlat()
                guard let image = UIImage(named: "Water-drop") else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.textProvider = CLKSimpleTextProvider(text: "reHydrate")
                handler(template)
            case .graphicBezel:
                let template = CLKComplicationTemplateGraphicBezelCircularText()
                template.circularTemplate = CLKComplicationTemplateGraphicCircularStackImage()
                template.textProvider = CLKSimpleTextProvider(text: "reHydrate")
            case .graphicCorner:
                let template = CLKComplicationTemplateGraphicCornerGaugeImage()
                guard let image = UIImage(named: "AppIcon") else { handler(nil); return}
                template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .blue, fillFraction: 0)
                handler(template)
            case .graphicCircular:
                let template = CLKComplicationTemplateGraphicCircularImage()
                guard let image = UIImage(named: "Water-drop") else { handler(nil); return}
                template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                handler(template)
            case .graphicRectangular:
                let template = CLKComplicationTemplateGraphicRectangularStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "header")
                template.body1TextProvider = CLKSimpleTextProvider(text: "body1")
                template.body2TextProvider = CLKSimpleTextProvider(text: "body2")
                handler(template)
            case .circularSmall:
                let template = CLKComplicationTemplateCircularSmallRingImage()
                guard let image = UIImage(named: "Water-drop") else { handler(nil); return}
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                template.ringStyle = .open
                handler(template)
            default:
                handler(nil)
                return
        }
    }
}
