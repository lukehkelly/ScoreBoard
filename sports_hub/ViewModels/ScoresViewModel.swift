//
//  ScoresViewModel.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation
import Observation

@Observable
final class ScoresViewModel {
    var sportFilter: Sport = .nba
    var matches: [Match] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil

    let availableSports: [Sport] = Sport.allCases

    private let service: SportsService

    init(service: SportsService = .shared) {
        self.service = service
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let fetched = try await service.fetchMatches(for: sportFilter)
            matches = sortByDateDescending(fetched)
        } catch {
            matches = []
            errorMessage = "Couldn't load scores."
        }
    }

    private func sortByDateDescending(_ matches: [Match]) -> [Match] {
        matches.sorted { a, b in
            let da = DateParsing.parseISO8601(a.date) ?? .distantPast
            let db = DateParsing.parseISO8601(b.date) ?? .distantPast
            return da > db
        }
    }
}
