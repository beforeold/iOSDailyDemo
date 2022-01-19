//
//  DynamicWidget.swift
//  DynamicWidget
//
//  Created by 席萍萍Brook.dinglan on 2021/10/13.
//  Copyright © 2021 DynamicWidget. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

/*
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

struct DynamicWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct DynamicWidget: Widget {
    let kind: String = "DynamicWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            DynamicWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct DynamicWidget_Previews: PreviewProvider {
    static var previews: some View {
        DynamicWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
*/

import WidgetKit
import SwiftUI
import Intents
import Combine

typealias ScriptIntent = ConfigurationIntent

struct Provider: IntentTimelineProvider {
        
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(isPreview: true, date: Date(), configuration: ScriptIntent())
    }

    func getSnapshot(for configuration: ScriptIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(isPreview: context.isPreview, date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ScriptIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(isPreview: context.isPreview,
                                    date: entryDate,
                                    configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    func _getTimeline(for configuration: ScriptIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        /*
        var entries: [SimpleEntry] = []


        if configuration.Frequency == .miniutes_10 {
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
            let entry = SimpleEntry(isPreview: false, date: entryDate, configuration: configuration)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } else if configuration.Frequency == .miniutes_30 {
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
            let entry = SimpleEntry(isPreview: false, date: entryDate, configuration: configuration)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } else if configuration.Frequency == .hours_1 {
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            let entry = SimpleEntry(isPreview: false, date: entryDate, configuration: configuration)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } else if configuration.Frequency == .hours_3 {
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .hour, value: 3, to: currentDate)!
            let entry = SimpleEntry(isPreview: false, date: entryDate, configuration: configuration)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } else if configuration.Frequency == .hours_6 {
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .hour, value: 6, to: currentDate)!
            let entry = SimpleEntry(isPreview: false, date: entryDate, configuration: configuration)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } else if configuration.Frequency == .hours_12 {
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .hour, value: 12, to: currentDate)!
            let entry = SimpleEntry(isPreview: false, date: entryDate, configuration: configuration)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } else if configuration.Frequency == .day_1 {
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            let entry = SimpleEntry(isPreview: false, date: entryDate, configuration: configuration)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } else {
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            let entry = SimpleEntry(isPreview: false, date: entryDate, configuration: configuration)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
        */
    }
}

struct SimpleEntry: TimelineEntry {
    let isPreview: Bool
    let date: Date
    let configuration: ScriptIntent
}


class ScriptWidgetDataObject : ObservableObject {
    let scriptName: String
    let widgetFamily: WidgetFamily
    
    @Published var rootElement : ScriptWidgetRuntimeElement
    
    var cancellables: [AnyCancellable] = []
    
    init(scriptName: String, widgetFamily: WidgetFamily) {
        self.scriptName = scriptName
        self.widgetFamily = widgetFamily
        
        self.rootElement = ScriptWidgetRuntimeElement(tag: "text", props: nil, children: ["."])
    }
    
    deinit {
        for item in cancellables {
            item.cancel()
        }
    }
    
    func createTextElement(info: String) -> ScriptWidgetRuntimeElement {
        return ScriptWidgetRuntimeElement(tag: "text", props: nil, children: [info])
    }
    
    func runScriptSync() {
        if self.scriptName.count == 0 {
            self.rootElement = createTextElement(info: "No script selected")
            return
        }
        
        self.systemLog("[START]")
        
        let script = sharedScriptManager.getScript(scriptId: self.scriptName)
        
        guard let JSX = script.file.readFile() else {
            self.rootElement = createTextElement(info: "Failed open script")
            return
        }
        
        var widgetSizeString = ""
        switch self.widgetFamily {
        case .systemLarge: widgetSizeString = "large"
        case .systemMedium: widgetSizeString = "medium"
        case .systemSmall: widgetSizeString = "small"
        default: widgetSizeString = "small"
        }
        let runtime = ScriptWidgetRuntime(environments: [
            "widget-size" : widgetSizeString
        ])
        
        let result = runtime.executeJSXSync(JSX)
        
        if let element = result.0 {
            // succeed
            self.rootElement = element
        } else {
            // error
            if let error = result.1 {
                switch error {
                case .undefinedRender(let msg):
                    self.systemLog(msg)
                case .internalError(let msg):
                    self.systemLog(msg)
                case .scriptError(let msg):
                    self.systemLog(msg)
                case .scriptException(let msg):
                    self.systemLog(msg)
                case .transformError(let msg):
                    self.systemLog(msg)
                }
            }
        }
        
        self.systemLog("[FINISH]")
    }
    
    func systemLog(_ str: String) {
        print("system log: \(str)")
    }
}

func saveScript(id: String) {
    let script =
"""

// https://www.weatherapi.com/
// please register account for your api key
const apikey = "8883e2c78d854356bc813207212502";
const city = "Shenzhen";
const url = `https://api.weatherapi.com/v1/current.json?key=${apikey}&q=${city}&aqi=no`;

const result = await fetch(url);
console.log(result);
const data = JSON.parse(result);

$render(
  <vstack frame="max" background="#3a86ff">
    <text font="title3" color="white">
      Weather
    </text>
    <text font="caption" color="white">
      City: {data.location.name}
    </text>
    <text font="caption" color="white">
      Temp: {data.current.temp_c} - {data.current.temp_f}
    </text>
    <text font="caption" color="white">
      Condition: {data.current.condition.text}
    </text>
    <text font="caption2" color="white">
      Updated At: {data.current.last_updated}
    </text>
  </vstack>
);
"""
    let ret = sharedScriptManager.createScript(content: script, recommendScriptId: id)
    print(ret)
}

// data.api
// data.data.resultValue.9215754.msgInfo
// data.locatin.name

/*
const url = ``;
 **/

struct ScriptWidgetWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    @ObservedObject var data = ScriptWidgetDataObject(scriptName: "", widgetFamily: .systemSmall)

    var entry: Provider.Entry
    
    init(entry: Provider.Entry) {
        self.entry = entry
        // let scriptName = entry.configuration.Script ?? ""
        
        let scriptId = UUID().uuidString
        saveScript(id: scriptId)
        self.data = ScriptWidgetDataObject(scriptName: scriptId, widgetFamily: self.family)
        self.data.runScriptSync()
    }

    @ViewBuilder
    var body: some View {
        if self.entry.isPreview {
            ScriptWidgetPlaceholderView()
        } else {
            ScriptWidgetElementView(element: data.rootElement,
                                    context: ScriptWidgetElementContext(debugMode: false))
        }
    }
}


struct DynamicWidget: Widget {
    let kind: String = "ScriptWidgetWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ScriptIntent.self, provider: Provider()) { entry in
            ScriptWidgetWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ScriptWidget")
        .description("Build your own widgets")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
    
    init() {
        let _ = globalState
    }
}

typealias ScriptWidgetWidget = DynamicWidget

struct DynamicWidget_Previews: PreviewProvider {
    static var previews: some View {
        let entry = SimpleEntry(isPreview:false ,date: Date(), configuration: ScriptIntent())
        
//        ScriptWidgetWidgetEntryView(entry: entry)
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//        ScriptWidgetWidgetEntryView(entry: entry)
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
        ScriptWidgetWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

@main
struct DynamicWidgetList: WidgetBundle {
    var body: some Widget {
        ScriptWidgetWidget()
    }
}

