//
//  MyTeamsViewModel.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation
import SwiftData
import Observation

enum SortOrder {
    case mostRecent, alphabetical

    var label: String {
        switch self {
        case .mostRecent:   return "Most Recent"
        case .alphabetical: return "Alphabetical"
        }
    }
}

enum MatchView: String, CaseIterable, Identifiable {
    case recent, upcoming
    var id: String { rawValue }
    var label: String {
        switch self {
        case .recent:   return "Recent"
        case .upcoming: return "Upcoming"
        }
    }
}

@Observable
final class MyTeamsViewModel {
    var results: [PersistentIdentifier: [Match]] = [:]
    var sortOrder: SortOrder = .mostRecent
    var sportFilter: Sport? = nil
    var matchView: MatchView = .recent
    var isManaging = false

    private let service: SportsService

    init(service: SportsService = .shared) {
        self.service = service
    }

    func uniqueSports(from favorites: [FavoriteTeam]) -> [Sport] {
        var seen = Set<Sport>()
        return favorites.compactMap { team in
            seen.insert(team.sport).inserted ? team.sport : nil
        }
    }

    func displayedTeams(from favorites: [FavoriteTeam]) -> [FavoriteTeam] {
        var filtered = favorites
        if let filter = sportFilter {
            filtered = filtered.filter { $0.sport == filter }
        }
        switch sortOrder {
        case .alphabetical:
            return filtered.sorted { $0.name < $1.name }
        case .mostRecent:
            return filtered.sorted { a, b in
                let dateA = matchFor(a)?.date ?? ""
                let dateB = matchFor(b)?.date ?? ""
                return dateA > dateB
            }
        }
    }

    func matchFor(_ team: FavoriteTeam) -> Match? {
        let matches = results[team.id] ?? []
        if let live = matches.first(where: { MatchStatus.isInProgress($0) }) {
            return live
        }
        let now = Date()
        let dated = matches.compactMap { m -> (Match, Date)? in
            guard let d = DateParsing.parseISO8601(m.date) else { return nil }
            return (m, d)
        }
        switch matchView {
        case .recent:
            return dated.filter { $0.1 <= now }.max { $0.1 < $1.1 }?.0
        case .upcoming:
            return dated.filter { $0.1 > now }.min { $0.1 < $1.1 }?.0
        }
    }

    func fetchAll(for favorites: [FavoriteTeam]) async {
        results = [:]
        await withTaskGroup(of: (PersistentIdentifier, [Match]).self) { group in
            for team in favorites {
                let teamID = team.id
                group.addTask { [service] in
                    do {
                        let matches = try await service.fetchMatches(for: team)
                        return (teamID, matches)
                    } catch {
                        return (teamID, [])
                    }
                }
            }
            for await (teamID, matches) in group {
                results[teamID] = matches
            }
        }
    }
}
