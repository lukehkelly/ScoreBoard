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
                Text(DateParsing.matchDateString(match.date))
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
                if !MatchStatus.isScheduled(match), let score = match.state?.score?.displayString {
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
                let isLive = MatchStatus.isInProgress(match)
                Circle()
                    .fill(isLive ? Theme.live : Theme.secondary.opacity(0.4))
                    .frame(width: 5, height: 5)
                Text(MatchStatus.displayStatus(match))
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
