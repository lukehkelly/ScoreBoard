//
//  Match.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation

struct Match: Identifiable, Decodable {
    let id: Int
    let date: String
    let homeTeam: Team
    let awayTeam: Team
    let state: MatchState?
    let leagueName: String?

    enum CodingKeys: String, CodingKey {
        case id, date, homeTeam, awayTeam, state, league
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        date = try container.decode(String.self, forKey: .date)
        homeTeam = try container.decode(Team.self, forKey: .homeTeam)
        awayTeam = try container.decode(Team.self, forKey: .awayTeam)
        state = try container.decodeIfPresent(MatchState.self, forKey: .state)
        leagueName = try? container.decode(String.self, forKey: .league)
    }
}

struct MatchesResponse: Decodable {
    let data: [Match]
}
