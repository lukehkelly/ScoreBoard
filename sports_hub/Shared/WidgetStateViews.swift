//
//  WidgetStateViews.swift
//  Shared between sports_hub and SportsHubWidget.
//

import SwiftUI

// MARK: - Small views

struct SmallLiveView: View {
    let team: TeamEntity
    let match: Match

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                SportBadge(sport: team.sport)
                Spacer()
                Circle().fill(Theme.live).frame(width: 6, height: 6)
            }
            Spacer(minLength: 0)
            Text(match.state?.score?.displayString ?? "–")
                .font(.title.weight(.heavy).monospacedDigit())
                .foregroundStyle(.primary)
            Text("\(abbrev(match.homeTeam.name)) vs \(abbrev(match.awayTeam.name))")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(match.state?.description ?? "")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }
}

struct SmallUpcomingView: View {
    let team: TeamEntity
    let match: Match

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                SportBadge(sport: team.sport)
                Spacer()
                Text(WidgetDateFormat.shortDate(match.date))
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            HStack(spacing: 10) {
                TeamLogo(url: match.homeTeam.logo, size: 28)
                Text("vs")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                TeamLogo(url: match.awayTeam.logo, size: 28)
            }
            Text(WidgetDateFormat.shortTime(match.date))
                .font(.callout.weight(.bold))
                .foregroundStyle(Theme.accent)
        }
    }
}

struct SmallRecentView: View {
    let team: TeamEntity
    let match: Match

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                SportBadge(sport: team.sport)
                Spacer()
                Text("FINAL")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            Text(match.state?.score?.displayString ?? "–")
                .font(.title2.weight(.heavy).monospacedDigit())
                .foregroundStyle(.secondary)
            Text("\(abbrev(match.homeTeam.name)) – \(abbrev(match.awayTeam.name))")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(WidgetDateFormat.shortDate(match.date))
                .font(.caption2)
                .foregroundStyle(.secondary.opacity(0.7))
        }
    }
}

struct SmallNoDataView: View {
    let team: TeamEntity

    var body: some View {
        VStack(spacing: 8) {
            TeamLogo(url: team.logoURL, size: 44)
            Text(team.name)
                .font(.callout.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text("No matches scheduled")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Medium views

struct MediumLiveView: View {
    let team: TeamEntity
    let match: Match

    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .center, spacing: 0) {
                teamColumn(name: match.homeTeam.name, logo: match.homeTeam.logo, alignment: .leading)
                Spacer(minLength: 8)
                Text(match.state?.score?.displayString ?? "–")
                    .font(.title.weight(.heavy).monospacedDigit())
                    .foregroundStyle(.primary)
                Spacer(minLength: 8)
                teamColumn(name: match.awayTeam.name, logo: match.awayTeam.logo, alignment: .trailing)
            }
            HStack(spacing: 6) {
                Circle().fill(Theme.live).frame(width: 5, height: 5)
                Text(match.state?.description ?? "")
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Spacer()
                SportBadge(sport: team.sport)
            }
        }
    }

    private func teamColumn(name: String, logo: String?, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 4) {
            TeamLogo(url: logo, size: 32)
            Text(name)
                .font(.caption.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(maxWidth: 100,
               alignment: alignment == .leading ? .leading : .trailing)
    }
}

struct MediumUpcomingView: View {
    let team: TeamEntity
    let match: Match

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center, spacing: 0) {
                teamColumn(name: match.homeTeam.name, logo: match.homeTeam.logo, alignment: .leading)
                VStack(spacing: 2) {
                    Text("vs")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                    Text(WidgetDateFormat.shortDate(match.date))
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(WidgetDateFormat.shortTime(match.date))
                        .font(.callout.weight(.bold))
                        .foregroundStyle(Theme.accent)
                }
                .frame(maxWidth: 120)
                teamColumn(name: match.awayTeam.name, logo: match.awayTeam.logo, alignment: .trailing)
            }
            HStack {
                Spacer()
                SportBadge(sport: team.sport)
            }
        }
    }

    private func teamColumn(name: String, logo: String?, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 4) {
            TeamLogo(url: logo, size: 36)
            Text(name)
                .font(.callout.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(maxWidth: 100,
               alignment: alignment == .leading ? .leading : .trailing)
    }
}

struct MediumRecentView: View {
    let team: TeamEntity
    let match: Match

    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .center, spacing: 0) {
                teamColumn(name: match.homeTeam.name, logo: match.homeTeam.logo, alignment: .leading)
                Spacer(minLength: 8)
                Text(match.state?.score?.displayString ?? "–")
                    .font(.title.weight(.heavy).monospacedDigit())
                    .foregroundStyle(.secondary)
                Spacer(minLength: 8)
                teamColumn(name: match.awayTeam.name, logo: match.awayTeam.logo, alignment: .trailing)
            }
            HStack {
                Text("FINAL")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(WidgetDateFormat.shortDate(match.date))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                SportBadge(sport: team.sport)
            }
        }
    }

    private func teamColumn(name: String, logo: String?, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 4) {
            TeamLogo(url: logo, size: 32)
            Text(name)
                .font(.caption.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(maxWidth: 100,
               alignment: alignment == .leading ? .leading : .trailing)
    }
}

struct MediumNoDataView: View {
    let team: TeamEntity

    var body: some View {
        HStack(spacing: 14) {
            TeamLogo(url: team.logoURL, size: 44)
            VStack(alignment: .leading, spacing: 4) {
                Text(team.name)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                SportBadge(sport: team.sport)
            }
            Spacer()
            Text("No upcoming matches")
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}

// MARK: - Helpers

private func abbrev(_ name: String) -> String {
    let parts = name.split(separator: " ")
    if let last = parts.last, last.count >= 3 {
        return String(last).uppercased()
    }
    return String(name.prefix(4)).uppercased()
}

enum WidgetDateFormat {
    static func shortDate(_ iso: String) -> String {
        guard let d = parse(iso) else { return iso }
        let f = DateFormatter()
        f.dateFormat = "EEE MMM d"
        return f.string(from: d).uppercased()
    }

    static func shortTime(_ iso: String) -> String {
        guard let d = parse(iso) else { return "" }
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f.string(from: d)
    }

    private static func parse(_ s: String) -> Date? {
        let withFrac = ISO8601DateFormatter()
        withFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = withFrac.date(from: s) { return d }
        let plain = ISO8601DateFormatter()
        plain.formatOptions = [.withInternetDateTime]
        return plain.date(from: s)
    }
}
