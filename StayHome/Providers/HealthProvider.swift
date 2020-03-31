//
//  HealthProvider.swift
//  StayHome
//
//  Created by Enrico Castelli on 22/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import Foundation
import HealthKit

class Health {
    
    static let shared = Health()
    var store = HKHealthStore()
    let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    let distanceCount = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
    lazy var types: Set<HKSampleType> = [stepCount, distanceCount]
}

protocol HealthProvider: StoreProvider {}

extension HealthProvider {
    
    func askAuthorization() {
        Health.shared.store.requestAuthorization(toShare: Health.shared.types, read: Health.shared.types) { (success, error) in
            if !success {
                // Handle the error here.
            }
        }
    }
    
    func getSteps(_ completion: @escaping(Double) ->()) {
        let stepQuery = HKStatisticsQuery(quantityType: Health.shared.stepCount, quantitySamplePredicate: predicate(date: getStartDate()), options: .cumulativeSum) { (query, stats, error) in
            guard let stats = stats, let sum = stats.sumQuantity() else {
                DispatchQueue.main.async {
                    completion(0.0)
                }
                return
            }
            DispatchQueue.main.async {
                completion(sum.doubleValue(for: HKUnit.count()))
            }
        }
        
        Health.shared.store.execute(stepQuery)
    }
    
    func getDistance(_ completion: @escaping(Double) ->()) {
        let distanceQuery = HKStatisticsQuery(quantityType: Health.shared.distanceCount, quantitySamplePredicate: predicate(date: getStartDate()), options: .cumulativeSum) { (query, stats, error) in
            guard let stats = stats, let sum = stats.sumQuantity() else {
                DispatchQueue.main.async {
                    completion(0.0)
                }
                return
            }
            DispatchQueue.main.async {
                completion(sum.doubleValue(for: HKUnit(from: LengthFormatter.Unit.meter)))
            }
        }
        Health.shared.store.execute(distanceQuery)
    }
    
    func getAll(_ completion: @escaping(_ steps: Double, _ distance: Double) ->()) {
        getSteps { (steps) in
            self.getDistance { (distance) in
                DispatchQueue.main.async {
                    completion(steps, distance)
                }
            }
        }
    }
    
    func predicate(date: Date) -> NSPredicate {
        let start = Calendar.current.startOfDay(for: date)
        return HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)
    }
    
    
}
