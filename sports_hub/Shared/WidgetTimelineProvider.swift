//
//  WidgetTimelineProvider.swift
//  SportsHubWidget
//

import Foundation
import WidgetKit
import AppIntents

struct WidgetTimelineProvider: AppIntentTimelineProvider {
    typealias Entry = WidgetEntry
    typealias Intent = SelectTeamIntent

    func placeholder(in context: Context) -> WidgetEntry {
        .placeholder()
    }

    func snapshot(for configuration: SelectTeamIntent, in context: Context) async -> WidgetEntry {
        guard let team = configuration.team else {
            return .placeholder()
        }
        let state = await fetchState(for: team)
        return WidgetEntry(date: Date(), team: team, state: state)
    }

    func timeline(for configuration: SelectTeamIntent, in context: Context) async -> Timeline<WidgetEntry> {
        guard let team = configuration.team else {
            let entry = WidgetEntry.placeholder()
            let next = Date().addingTimeInterval(60 * 60) // 1 hour
            return Timeline(entries: [entry], policy: .after(next))
        }

        let state = await fetchState(for: team)
        let now = Date()
        let entry = WidgetEntry(date: now, team: team, state: state)
        let next = nextRefreshDate(for: state, now: now)
        return Timeline(entries: [entry], policy: .after(next))
    }

    /// Refresh cadence per spec.
    func nextRefreshDate(for state: WidgetMatchState, now: Date) -> Date {
        switch state {
        case .live:
            return now.addingTimeInterval(5 * 60)            // 5 min
        case .upcoming(let match):
            if let kickoff = parseDate(match.date) {
                let delta = kickoff.timeIntervalSince(now)
                if delta < 2 * 60 * 60 {
                    return now.addingTimeInterval(15 * 60)   // <2h → 15 min
                } else {
                    return now.addingTimeInterval(2 * 60 * 60) // ≥2h → 2h
                }
            }
            return now.addingTimeInterval(2 * 60 * 60)
        case .recent:
            return now.addingTimeInterval(6 * 60 * 60)       // 6 h
        case .noData:
            return now.addingTimeInterval(60 * 60)           // 1 h
        }
    }

    // MARK: - Classification

    /// Fetches matches for the team and picks the most relevant one.
    func fetchState(for team: TeamEntity) async -> WidgetMatchState {
        do {
            let queryable = FavoriteTeamStub(team: team)
            let matches = try await SportsService.shared.fetchMatches(for: queryable)
            return classify(matches: matches)
        } catch {
            return .noData
        }
    }

    /// Chooses live > upcoming > recent > noData from a list of matches.
    func classify(matches: [Match]) -> WidgetMatchState {
        if let live = matches.first(where: { isInProgress($0) }) {
            return .live(match: live)
        }
        let now = Date()
        let future = matches
            .compactMap { m -> (Match, Date)? in
                guard let d = parseDate(m.date), d > now else { return nil }
                return (m, d)
            }
            .sorted { $0.1 < $1.1 }
        if let (upcoming, _) = future.first {
            return .upcoming(match: upcoming)
        }
        let past = matches
            .compactMap { m -> (Match, Date)? in
                guard let d = parseDate(m.date), d <= now else { return nil }
                return (m, d)
            }
            .sorted { $0.1 > $1.1 }
        if let (recent, _) = past.first {
            return .recent(match: recent)
        }
        return .noData
    }

    private func isInProgress(_ match: Match) -> Bool {
        (match.state?.description.lowercased().contains("progress")) ?? false
    }

    func parseDate(_ s: String) -> Date? {
        let withFrac = ISO8601DateFormatter()
        withFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = withFrac.date(from: s) { return d }
        let plain = ISO8601DateFormatter()
        plain.formatOptions = [.withInternetDateTime]
        return plain.date(from: s)
    }
}

/// Bridge: the widget doesn't have access to the SwiftData `FavoriteTeam`,
/// so construct a minimal `TeamQueryable` from the AppIntent's selected team.
private struct FavoriteTeamStub: TeamQueryable {
    let name: String
    let sport: Sport
    let teamId: Int?
    let apiName: String?

    init(team: TeamEntity) {
        self.name = team.name
        self.sport = team.sport
        self.teamId = team.teamId
        self.apiName = nil
    }
}
