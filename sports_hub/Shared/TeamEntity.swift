//
//  TeamEntity.swift
//  SportsHubWidget
//


import AppIntents
import Foundation

struct TeamEntity: AppEntity, Identifiable {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Team")
    static var defaultQuery = TeamEntityQuery()

    var id: String
    var name: String
    var sportRaw: String
    var teamId: Int
    var logoURL: String?

    var sport: Sport {
        Sport(rawValue: sportRaw) ?? .football
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)",
            subtitle: "\(sport.displayName)"
        )
    }

    init(name: String, sport: Sport, teamId: Int, logoURL: String?) {
        self.name = name
        self.sportRaw = sport.rawValue
        self.teamId = teamId
        self.logoURL = logoURL
        self.id = "\(sport.rawValue):\(teamId)"
    }
}

struct TeamEntityQuery: EntityStringQuery {
    func entities(for identifiers: [TeamEntity.ID]) async throws -> [TeamEntity] {
        // WidgetKit calls this to re-resolve saved entities across timeline
        // refreshes. Reconstruct a minimal entity from the ID ("<sport>:<teamId>")
        // so the configuration is preserved. Name/logo are placeholders — the
        // actual match data comes from SportsService.fetchMatches.
        identifiers.compactMap { id in
            let parts = id.split(separator: ":", maxSplits: 1)
            guard parts.count == 2,
                  let sport = Sport(rawValue: String(parts[0])),
                  let teamId = Int(parts[1]) else { return nil }
            return TeamEntity(
                name: "Team",
                sport: sport,
                teamId: teamId,
                logoURL: nil
            )
        }
    }

    func entities(matching string: String) async throws -> [TeamEntity] {
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return [] }
        let results = await SportsService.shared.searchTeams(query: trimmed)
        return results.map { result in
            TeamEntity(
                name: result.team.displayName ?? result.team.name,
                sport: result.sport,
                teamId: result.team.id,
                logoURL: result.team.logo
            )
        }
    }

    func suggestedEntities() async throws -> [TeamEntity] {
        []
    }
}
