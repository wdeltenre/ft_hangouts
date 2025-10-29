//
//  DateFormatter+Extensions.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation

// The language displayed is based on the device's settings.
extension DateFormatter {
    static let longTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}
