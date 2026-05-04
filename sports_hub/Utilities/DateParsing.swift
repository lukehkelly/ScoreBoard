//
//  DateParsing.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation

enum DateParsing {
    static func parseISO8601(_ s: String) -> Date? {
        let withFrac = ISO8601DateFormatter()
        withFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = withFrac.date(from: s) { return d }
        let plain = ISO8601DateFormatter()
        plain.formatOptions = [.withInternetDateTime]
        return plain.date(from: s)
    }

    static func matchDateString(_ iso: String) -> String {
        guard let date = parseISO8601(iso) else { return iso }
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return f.string(from: date)
    }
}
