//
//  FormattedBelgianPhoneNumber.swift
//  ft_hangouts
//
//  Created by William Deltenre on 17/10/2025.
//

import Foundation

extension String {
    func formattedBelgianPhoneNumber() -> String {
        var cleanInput = self.filter { $0.isNumber || $0 == "+" }
        
        let maxCleanLength = 12
        if cleanInput.count > maxCleanLength {
            cleanInput = String(cleanInput.prefix(maxCleanLength))
        }
        
        let prefix = cleanInput.prefix(3)
        let remainingDigits = cleanInput.dropFirst(3)
        
        guard !remainingDigits.isEmpty else {
            return String(prefix)
        }
        
        var formattedParts: [String] = [String(prefix)]
        var currentDigits = Array(remainingDigits)
        var offset = 0
        
        let firstChunkSize = 3
        if currentDigits.count > offset {
            let chunk = String(currentDigits[offset..<min(offset + firstChunkSize, currentDigits.count)])
            formattedParts.append(chunk)
            offset += chunk.count
        }
        
        let subsequentChunkSize = 2
        while offset < currentDigits.count {
            let chunkEndIndex = min(offset + subsequentChunkSize, currentDigits.count)
            let chunk = String(currentDigits[offset..<chunkEndIndex])
            formattedParts.append(chunk)
            offset = chunkEndIndex
        }
        
        return formattedParts.joined(separator: " ")
    }
}
