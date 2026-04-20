//
//  SharedViews.swift
//  sports_hub
//
//  

import SwiftUI

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
