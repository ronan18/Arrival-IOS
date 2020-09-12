//
//  widget.swift
//  widget
//
//  Created by Ronan Furuta on 9/10/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import WidgetKit
import SwiftUI
import NotificationCenter
import CoreLocation

struct Provider: TimelineProvider {
    let apiService = ApiService()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), station: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        apiService.auth = "test"
      
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
           
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var station: Station? = nil
}

struct widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            /*if (entry.station == nil) {
                StationCard(station: MockData().stations[0]).redacted(reason: .placeholder)
            } else {
                StationCard(station: entry.station)
            }*/
            Text(displayTime(entry.date).time)
        }.padding()
       
    }
}

@main
struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("Next Trains")
        .description("View realtime train predictions for closest BART station")
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        widgetEntryView(entry: SimpleEntry(date: Date(), station: MockData().stations[0]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
