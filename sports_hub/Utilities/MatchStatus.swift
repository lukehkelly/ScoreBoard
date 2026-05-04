//
//  MatchStatus.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation

enum MatchStatus {
    static func isInProgress(_ match: Match) -> Bool {
        (match.state?.description.lowercased().contains("progress")) ?? false
    }

    static func isScheduled(_ match: Match) -> Bool {
        let d = match.state?.description.lowercased() ?? ""
        return d.contains("not started") || d.contains("scheduled")
    }

    static func displayStatus(_ match: Match) -> String {
        let raw = match.state?.description ?? ""
        if raw.lowercased().contains("not started") { return "Scheduled" }
        return raw
    }
}
