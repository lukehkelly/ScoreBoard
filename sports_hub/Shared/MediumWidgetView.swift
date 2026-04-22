//
//  MediumWidgetView.swift
//

import SwiftUI

struct MediumWidgetView: View {
    let entry: WidgetEntry

    var body: some View {
        ZStack {
            Theme.background
            Group {
                switch entry.state {
                case .live(let m):
                    MediumLiveView(
                        team: entry.team, match: m,
                        homeLogoData: entry.homeLogoData,
                        awayLogoData: entry.awayLogoData
                    )
                case .upcoming(let m):
                    MediumUpcomingView(
                        team: entry.team, match: m,
                        homeLogoData: entry.homeLogoData,
                        awayLogoData: entry.awayLogoData
                    )
                case .recent(let m):
                    MediumRecentView(
                        team: entry.team, match: m,
                        homeLogoData: entry.homeLogoData,
                        awayLogoData: entry.awayLogoData
                    )
                case .noData:
                    MediumNoDataView(team: entry.team, teamLogoData: entry.teamLogoData)
                }
            }
            .padding(16)
        }
    }
}
