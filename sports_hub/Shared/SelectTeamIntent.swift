//
//  SelectTeamIntent.swift
//  SportsHubWidget
//

import AppIntents
import WidgetKit

struct SelectTeamIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Team"
    static var description = IntentDescription("Choose the team to display in this widget.")

    @Parameter(title: "Team")
    var team: TeamEntity?

    init() {}

    init(team: TeamEntity?) {
        self.team = team
    }
}
