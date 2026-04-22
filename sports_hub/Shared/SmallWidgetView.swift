//
//  SmallWidgetView.swift
//

import SwiftUI

struct SmallWidgetView: View {
    let entry: WidgetEntry

    var body: some View {
        ZStack {
            Theme.background
            Group {
                switch entry.state {
                case .live(let m):
                    SmallLiveView(team: entry.team, match: m)
                case .upcoming(let m):
                    SmallUpcomingView(
                        team: entry.team, match: m,
                        homeLogoData: entry.homeLogoData,
                        awayLogoData: entry.awayLogoData
                    )
                case .recent(let m):
                    SmallRecentView(team: entry.team, match: m)
                case .noData:
                    SmallNoDataView(team: entry.team, teamLogoData: entry.teamLogoData)
                }
            }
            .padding(14)
        }
    }
}
