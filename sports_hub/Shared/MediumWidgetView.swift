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
                case .live(let m):     MediumLiveView(team: entry.team, match: m)
                case .upcoming(let m): MediumUpcomingView(team: entry.team, match: m)
                case .recent(let m):   MediumRecentView(team: entry.team, match: m)
                case .noData:          MediumNoDataView(team: entry.team)
                }
            }
            .padding(16)
        }
    }
}
