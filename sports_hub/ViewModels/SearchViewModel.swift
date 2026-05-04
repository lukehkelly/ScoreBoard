//
//  SearchViewModel.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation
import SwiftData
import Observation

@Observable
final class SearchViewModel {
    var query: String = ""
    var submittedQuery: String = ""
    var results: [TeamResult] = []
    var isSearching: Bool = false

    private let service: SportsService

    init(service: SportsService = .shared) {
        self.service = service
    }

    func submit() {
        submittedQuery = query.trimmingCharacters(in: .whitespaces)
    }

    func clear() {
        query = ""
        submittedQuery = ""
        results = []
    }

    func runSearch() async {
        guard !submittedQuery.isEmpty else {
            results = []
            isSearching = false
            return
        }
        isSearching = true
        results = await service.searchTeams(query: submittedQuery)
        isSearching = false
    }

    func isAlreadyFavorite(_ result: TeamResult, in favorites: [FavoriteTeam]) -> Bool {
        favorites.contains {
            $0.name == (result.team.displayName ?? result.team.name) && $0.sportRaw == result.sport.rawValue
        }
    }

    func addTeam(from result: TeamResult, into context: ModelContext) {
        let name = result.team.displayName ?? result.team.name
        let team = FavoriteTeam(
            name: name,
            sport: result.sport,
            teamId: result.team.id,
            apiName: nil,
            logoURL: result.team.logo
        )
        context.insert(team)
    }
}
