import Foundation

public extension Double {
    func convert(to newUnit: UnitVolume, from oldUnit: UnitVolume) -> Double {
        Measurement(value: self, unit: oldUnit).converted(to: newUnit).value
    }
}
