//
//  WidgetEntry.swift
//  SportsHubWidget
//

import Foundation
import WidgetKit

enum WidgetMatchState {
    case live(match: Match)
    case upcoming(match: Match)
    case recent(match: Match)
    case noData
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let team: TeamEntity
    let state: WidgetMatchState
}

extension WidgetEntry {
    /// Placeholder entry used for the widget gallery and redacted previews.
    static func placeholder(team: TeamEntity? = nil) -> WidgetEntry {
        WidgetEntry(
            date: Date(),
            team: team ?? TeamEntity(
                name: "Your Team",
                sport: .football,
                teamId: 0,
                logoURL: nil
            ),
            state: .noData
        )
    }
}
