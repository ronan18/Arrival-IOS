//
//  TimeDisplayText.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI
import ArrivalCore
public enum TimeDisplayType {
    case timeTill
    case etd
}
public struct TimeDisplayText: View {
    let font: Font
    let timeText: String
    let timeUnit: String
    public init(_ date: Date, mode: TimeDisplayType, font: Font = .headline) {
        self.font = font
        let timeInterval = date.timeIntervalSinceNow
        if (timeInterval < 60) {
            self.timeText = "now"
            self.timeUnit = ""
        } else {
        switch (mode) {
        case .timeTill:
           
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute]
            formatter.unitsStyle = .abbreviated
            formatter.maximumUnitCount = 1
            var time = formatter.string(from: timeInterval)!
           time = String(time.dropLast())
            self.timeText = time
            self.timeUnit = "min"
            return
        case .etd:
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
public struct TimeIntervalDisplayText: View {
    let font: Font
    let timeText: String
    let timeUnit: String
    public init(_ interval: TimeInterval,  font: Font = .headline) {
        self.font = font
    
    
           
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute]
            formatter.unitsStyle = .abbreviated
            formatter.maximumUnitCount = 1
            var time = formatter.string(from: interval)!
           time = String(time.dropLast())
            self.timeText = time
            self.timeUnit = "min"
     
    }
    public var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Text(timeText).font(font)
            Text(timeUnit).font(.caption)
        }
    }
}

struct TimeDisplayText_Previews: PreviewProvider {
    static var previews: some View {
        TimeDisplayText(Date(), mode: .etd).previewLayout(.sizeThatFits)
    }
}
