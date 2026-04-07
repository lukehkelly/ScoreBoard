//
//  Sport.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation

enum Sport: Hashable {
    case football
    case nfl
    case nhl
    case nba
    case ncaaBasketball

    var matchesURL: String {
        switch self {
        case .football:       return "https://sports.highlightly.net/football/matches"
        case .nfl:            return "https://american-football.highlightly.net/matches"
        case .nhl:            return "https://nhl.highlightly.net/matches"
        case .nba:            return "https://nba.highlightly.net/matches"
        case .ncaaBasketball: return "https://nba.highlightly.net/matches"
        }
    }

    var displayName: String {
        switch self {
        case .football:       return "Football"
        case .nfl:            return "NFL"
        case .nhl:            return "NHL"
        case .nba:            return "NBA"
        case .ncaaBasketball: return "NCAA Basketball"
        }
    }
}
