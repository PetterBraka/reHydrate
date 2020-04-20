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
    
    init() {
        authorizeHealtKit()
    }
    
    func authorizeHealtKit()-> Bool{
        var isEnabled = true
        
        if HKHealthStore.isHealthDataAvailable() {
            let waterCount = NSSet(object: HKQuantityType.quantityType(forIdentifier: .dietaryWater)!)
            
            healtStore.requestAuthorization(toShare: (waterCount as! Set<HKSampleType>),
                                            read: (waterCount as! Set<HKObjectType>)) {
                                                (success, error) -> Void in
                                                isEnabled = success
                                                print(error ?? "no errors")
            }
        } else {
            isEnabled = false
        }
        return isEnabled
    }
    
    func saveConsumed(){
        
    }
    
}
