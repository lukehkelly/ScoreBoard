//
//  Sport.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation

enum Sport: String, Codable, Hashable, CaseIterable {
    case football
    case nfl
    case ncaaFootball
    case nhl
    case nba
    case ncaaBasketball
    case mlb
    case ncaaBaseball

    var matchesURL: String {
        switch self {
        case .football:       return "https://soccer.highlightly.net/matches"
        case .nfl:            return "https://american-football.highlightly.net/matches"
        case .ncaaFootball:   return "https://american-football.highlightly.net/matches"
        case .nhl:            return "https://nhl.highlightly.net/matches"
        case .nba:            return "https://nba.highlightly.net/matches"
        case .ncaaBasketball: return "https://nba.highlightly.net/matches"
        case .mlb:            return "https://baseball.highlightly.net/matches"
        case .ncaaBaseball:   return "https://baseball.highlightly.net/matches"
        }
    }

    /// Some endpoints serve more than one league (NFL + NCAA football share one host,
    /// MLB + NCAA baseball share one, NBA + NCAA basketball share one). Use this to
    /// filter a response down to a specific sport based on the match's `leagueName`.
    func matches(leagueName: String?) -> Bool {
        let name = leagueName?.uppercased() ?? ""
        switch self {
        case .nfl:            return name == "NFL"
        case .ncaaFootball:   return name != "NFL"
        case .mlb:            return name == "MLB"
        case .ncaaBaseball:   return name != "MLB"
        case .nba:            return name == "NBA"
        case .ncaaBasketball: return name != "NBA"
        case .football, .nhl: return true
        }
    }

    var displayName: String {
        switch self {
        case .football:       return "Soccer"
        case .nfl:            return "NFL"
        case .ncaaFootball:   return "NCAA Football"
        case .nhl:            return "NHL"
        case .nba:            return "NBA"
        case .ncaaBasketball: return "NCAA Basketball"
        case .mlb:            return "MLB"
        case .ncaaBaseball:   return "NCAA Baseball"
        }
    }
}
