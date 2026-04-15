//
//  SportsService.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation
import Observation

@Observable
class SportsService {
    static let shared = SportsService()

    private let apiKey = Secrets.apiKey

    private init() {}

    func searchTeams(query: String) async -> [TeamResult] {
        let sports: [Sport] = [.football, .nfl, .nhl, .ncaaBasketball, .mlb]
        var results: [TeamResult] = []

        await withTaskGroup(of: [TeamResult].self) { group in
            for sport in sports {
                group.addTask {
                    var components = URLComponents(string: sport.matchesURL)
                    components?.queryItems = [URLQueryItem(name: "homeTeamName", value: query)]
                    guard let url = components?.url else { return [] }
                    var request = URLRequest(url: url)
                    request.setValue(self.apiKey, forHTTPHeaderField: "x-rapidapi-key")
                    do {
                        let (data, response) = try await URLSession.shared.data(for: request)
                        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else { return [] }
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decoded = try decoder.decode(MatchesResponse.self, from: data)
                        var seen = Set<Int>()
                        var teams: [TeamResult] = []
                        for match in decoded.data {
                            if seen.insert(match.homeTeam.id).inserted {
                                let resolvedSport: Sport
                                if sport == .nfl {
                                    resolvedSport = match.leagueName?.uppercased() == "NFL" ? .nfl : .ncaaFootball
                                } else if sport == .mlb {
                                    resolvedSport = match.leagueName?.uppercased() == "MLB" ? .mlb : .ncaaBaseball
                                } else {
                                    resolvedSport = sport
                                }
                                teams.append(TeamResult(team: match.homeTeam, sport: resolvedSport))
                            }
                        }
                        return teams
                    } catch {
                        return []
                    }
                }
            }
            for await sportResults in group {
                results.append(contentsOf: sportResults)
            }
        }
        return results
    }

    func fetchMatches(for team: FavoriteTeam) async throws -> [Match] {
        var components = URLComponents(string: team.sport.matchesURL)
        var queryItems: [URLQueryItem] = []

        if let teamId = team.teamId {
            queryItems.append(URLQueryItem(name: "homeTeamId", value: String(teamId)))
        } else {
            let searchName = team.apiName ?? team.name
            queryItems.append(URLQueryItem(name: "homeTeamName", value: searchName))
        }

        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw SportsServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw SportsServiceError.networkError
            }

            guard httpResponse.statusCode == 200 else {
                throw SportsServiceError.networkError
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoded = try decoder.decode(MatchesResponse.self, from: data)
                return decoded.data
            } catch {
                throw SportsServiceError.codingError
            }

        } catch is URLError {
            throw SportsServiceError.networkError
        } catch let error as SportsServiceError {
            throw error
        } catch {
            throw SportsServiceError.unknown
        }
    }
}
