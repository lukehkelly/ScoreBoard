//
//  TeamResult.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation

struct TeamResult: Identifiable {
    let id = UUID()
    let team: Team
    let sport: Sport
}
