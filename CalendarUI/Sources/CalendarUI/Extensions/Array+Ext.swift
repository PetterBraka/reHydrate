//
//  Array+Ext.swift
//
//
//  Created by Petter vang Brakalsvålet on 06/12/2023.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Array where Element: Equatable {
    func rotate(toStartAt index: Index) -> [Element] {
        let index = self.index(startIndex, offsetBy: index, limitedBy: endIndex) ?? startIndex
        return Array(self[index ..< endIndex] + self[startIndex ..< index])
    }
}
