//
//  HealthKitManager.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 20/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitManager {
    
    let healtStore = HKHealthStore()
    
    
    func authorizeHealtKit()-> Bool{
        var isEnabled = true
        
        if HKHealthStore.isHealthDataAvailable() {
            let waterCount = NSSet(object: HKQuantityType.quantityType(forIdentifier: .dietaryWater)!)
            
            healtStore.requestAuthorization(toShare: (waterCount as! Set<HKSampleType>), read: (waterCount as! Set<HKObjectType>)) {
                (success, error) -> Void in
                isEnabled = success
            }
        } else {
            isEnabled = false
        }
        return isEnabled
    }
    
    
}
