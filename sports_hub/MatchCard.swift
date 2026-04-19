//
//  MatchCard.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import SwiftUI

struct MatchCard: View {
    let team: FavoriteTeam
    let match: Match?

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 18)
                .fill(Theme.card)
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(Theme.border, lineWidth: 0.5)
                }

            if let match {
                filledCard(match)
            } else {
                emptyCard
            }
        }
    }

    private func filledCard(_ match: Match) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                SportBadge(sport: team.sport)
                Spacer()
                Text(match.date.matchDate)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)

            HStack(alignment: .center, spacing: 0) {
                HStack(spacing: 9) {
                    TeamLogo(url: match.homeTeam.logo, size: 30)
                    Text(match.homeTeam.name)
                        .font(.title3.weight(.black))
                        .kerning(-0.3)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 48)

                HStack(spacing: 9) {
                    Text(match.awayTeam.name)
                        .font(.title3.weight(.black))
                        .kerning(-0.3)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    TeamLogo(url: match.awayTeam.logo, size: 30)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.leading, 48)
            }
            .overlay {
                if let score = match.state?.score?.displayString {
                    Text(score)
                        .font(.title2.weight(.heavy).monospacedDigit())
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                } else {
                    Text("vs")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)

            HStack(spacing: 5) {
                let isLive = match.state?.description.lowercased().contains("progress") ?? false
                Circle()
                    .fill(isLive ? Theme.live : Theme.secondary.opacity(0.4))
                    .frame(width: 5, height: 5)
                Text(match.state?.description ?? "")
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 18)
            .padding(.top, 10)
            .padding(.bottom, 16)
        }
    }

    private var emptyCard: some View {
        HStack(spacing: 12) {
            TeamLogo(url: team.logoURL, size: 36)
            VStack(alignment: .leading, spacing: 8) {
                Text(team.name)
                    .font(.title3.weight(.black))
                    .foregroundStyle(.primary)
                SportBadge(sport: team.sport)
            }
            Spacer()
            Text("No matches")
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary.opacity(0.5))
        }
        .padding(18)
    }
}

struct TeamLogo: View {
    let url: String?
    let size: CGFloat

    var body: some View {
        AsyncImage(url: url.flatMap { URL(string: $0) }) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            default:
                Color.clear
            }
        }
        .frame(width: size, height: size)
    }
}

struct SportBadge: View {
    let sport: Sport

    var body: some View {
        Text(sport.displayName.uppercased())
            .font(.caption2.weight(.bold))
            .kerning(1.5)
            .foregroundStyle(Theme.accent)
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
            .background(Theme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 4))
    }
}

private extension String {
    var matchDate: String {
        let withFrac = ISO8601DateFormatter()
        withFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let withoutFrac = ISO8601DateFormatter()
        withoutFrac.formatOptions = [.withInternetDateTime]

        for parser in [withFrac, withoutFrac] {
            if let date = parser.date(from: self) {
                let f = DateFormatter()
                f.dateFormat = "MMM d, yyyy"
                return f.string(from: date)
            }
        }
        return self
    }
}
