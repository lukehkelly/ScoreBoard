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
