//
//  MatchState.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation

struct MatchState: Decodable {
    let description: String
    let clock: Int?
    let score: Score?
}

struct Score: Decodable {
    let current: String?
    let homeTeamPeriods: [Int]?
    let awayTeamPeriods: [Int]?

    var displayString: String? {
        if let current { return current }
        if let home = homeTeamPeriods, let away = awayTeamPeriods {
            return "\(home.reduce(0, +)) - \(away.reduce(0, +))"
        }
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case current
        case homeTeam
        case awayTeam
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        current = try container.decodeIfPresent(String.self, forKey: .current)
        homeTeamPeriods = try container.decodeIfPresent([Int].self, forKey: .homeTeam)
        awayTeamPeriods = try container.decodeIfPresent([Int].self, forKey: .awayTeam)
    }
}
