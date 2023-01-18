//
//  myWidget.swift
//  myWidget
//
//  Created by IPS-169 on 28/10/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),text:"", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),text: "", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let userdefault = UserDefaults(suiteName: "group.widgetcatch")
        let text = userdefault?.value(forKey: "text") as? String ?? "No Text"
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate,text: text, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text:String
    let configuration: ConfigurationIntent
}

struct myWidgetEntryView : View {
    var entry: Provider.Entry
    private static let deeplinkURL: URL = URL(string: "widget-deeplink://")!
    
    var body: some View {
        ZStack{
            Text("TEST").widgetURL(URL(string: "https://www.google.co.in/"))
            Image("background").resizable() .widgetURL(URL(string: "https://www.google.co.in/"))
//            Text(entry.text).foregroundColor(.red)
//            Link(destination: URL(string: "scheme://camera")!, label: {
//                           Text("Camera")
//                       })
            
        }.widgetURL(URL(string: "widget://CamaraViewController"))
       // Text(entry.date, style: .time)
    }
}

@main
struct myWidget: Widget {
    let kind: String = "myWidget"
    private static let deeplinkURL: URL = URL(string: "widget-deeplink://")!
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            myWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct myWidget_Previews: PreviewProvider {
    static var previews: some View {
        myWidgetEntryView(entry: SimpleEntry(date: Date(), text: "", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
