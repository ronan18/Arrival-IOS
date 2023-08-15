//
//  TimeDisplayText.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/10/23.
//

import Foundation
import SwiftUI
public struct TimeDisplayText: View {
    let font: Font
    let timeText: String
    let timeUnit: String
    public init(_ date: Date, mode: TimeDisplayType, font: Font = .headline) {
        self.font = font
        let timeInterval = date.timeIntervalSinceNow
        
        switch (mode) {
        case .timeTill:
            if (timeInterval < 30) {
                self.timeText = "now"
                self.timeUnit = ""
                return
            } else {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.minute]
                formatter.unitsStyle = .abbreviated
                formatter.maximumUnitCount = 1
                var time = formatter.string(from: timeInterval)!
                time = String(time.dropLast())
                self.timeText = time
                self.timeUnit = "min"
                return
            }
        case .etd:
            if (timeInterval < 30) {
                self.timeText = "now"
                self.timeUnit = ""
                return
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US")
                
                dateFormatter.timeZone = TimeZone(abbreviation: "PST")
                dateFormatter.timeStyle = .short
                dateFormatter.dateStyle = .none
                let time: String = dateFormatter.string(from: date)
                self.timeText = String(time.dropLast(3))
                self.timeUnit = String(time.suffix(2).lowercased())
                return
            }
        }
        
    }
    public var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Text(timeText).font(font)
            Text(timeUnit).font(.caption)
        }
    }
}

public enum TimeDisplayType {
    case timeTill
    case etd
}
