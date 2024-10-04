//
//  Helpers.swift
//  RoomMates
//
//  Created by callum on 2023-11-18.
//

import Foundation

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}


extension NumberFormatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // Customize the formatter as needed
        return formatter
    }()

    static let percentage: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        // Customize the formatter as needed
        return formatter
    }()
}


