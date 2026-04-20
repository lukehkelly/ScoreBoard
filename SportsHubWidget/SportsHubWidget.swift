//
//  SportsHubWidget.swift
//  SportsHubWidget
//

import WidgetKit
import SwiftUI

struct SportsHubWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: WidgetEntry

    var body: some View {
        switch family {
        case .systemSmall:  SmallWidgetView(entry: entry)
        case .systemMedium: MediumWidgetView(entry: entry)
        default:            SmallWidgetView(entry: entry)
        }
    }
}

struct SportsHubWidget: Widget {
    let kind: String = "SportsHubWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectTeamIntent.self,
            provider: WidgetTimelineProvider()
        ) { entry in
            SportsHubWidgetEntryView(entry: entry)
                .environment(\.colorScheme, .dark)
                .containerBackground(Theme.background, for: .widget)
        }
        .configurationDisplayName("Sports Hub")
        .description("Live, upcoming, or recent match for your team.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    SportsHubWidget()
} timeline: {
    WidgetEntry.placeholder()
}

#Preview(as: .systemMedium) {
    SportsHubWidget()
} timeline: {
    WidgetEntry.placeholder()
}
