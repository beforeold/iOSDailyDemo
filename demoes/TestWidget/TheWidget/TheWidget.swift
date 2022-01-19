//
//  TheWidget.swift
//  TheWidget
//
//  Created by dinglan on 2021/5/21.
//

import WidgetKit
import SwiftUI
import Intents
import TheFramework

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct TheWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct TheWidget: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        TheWidget1()
        TheWidget2()
    }
    
    func foo() {
        Model.foo()
    }
}

struct TheWidget1: Widget {
    let kind: String = "TheWidget1"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TheWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget1")
        .description("This is an example widget.")
    }
}

struct TheWidget2: Widget {
    let kind: String = "TheWidget2"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TheWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget2")
        .description("This is an example widget.")
    }
}

struct TheWidget_Previews: PreviewProvider {
    static var previews: some View {
        TheWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
