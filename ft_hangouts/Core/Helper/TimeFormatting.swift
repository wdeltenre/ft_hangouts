//
//  TimeFormatting.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation

// The language displayed is based on the device's settings.
func previewTimeFormatter(date: Date) -> String {
    let now = Date()
    let calendar = Calendar.current
    
    let startOfSentDate = calendar.startOfDay(for: date)
    let startOfToday = calendar.startOfDay(for: now)
    let daysSinceSent = calendar.dateComponents([.day], from: startOfSentDate, to: startOfToday).day ?? 0
    
    // For "Today" (e.g., 9:06 PM)
    if calendar.isDateInToday(date) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        return timeFormatter.string(from: date)
    }
    
    // For "1 to 6 days ago" (e.g., Sunday)
    if daysSinceSent > 0 && daysSinceSent < 7 {
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        return weekdayFormatter.string(from: date)
    }
    
    let isCurrentYear = calendar.isDate(date, equalTo: now, toGranularity: .year)
    if isCurrentYear {
        // Sent this year, but more than 6 days ago (e.g., 10/7)
        let monthDayFormatter = DateFormatter()
        monthDayFormatter.dateFormat = "d/M"
        return monthDayFormatter.string(from: date)
    } else {
        // Sent in a previous year (e.g., 10/7/24)
        let monthDayYearFormatter = DateFormatter()
        monthDayYearFormatter.dateFormat = "d/M/yy"
        return monthDayYearFormatter.string(from: date)
    }
}
