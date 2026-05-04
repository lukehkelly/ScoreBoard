//
//  ScoresView.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import SwiftUI

struct ScoresView: View {
    @State private var vm = ScoresViewModel()

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SCORES")
                        .font(.caption2.weight(.semibold))
                        .kerning(3)
                        .foregroundStyle(.secondary)
                    Text("Today")
                        .font(.title.weight(.black))
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(vm.availableSports, id: \.self) { sport in
                            FilterChip(
                                label: sport.displayName,
                                isSelected: vm.sportFilter == sport
                            ) {
                                vm.sportFilter = sport
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 12)

                content
            }
        }
        .task(id: vm.sportFilter) {
            await vm.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        if vm.isLoading {
            Spacer()
            HStack {
                Spacer()
                ProgressView().tint(Theme.secondary)
                Spacer()
            }
            Spacer()
        } else if let err = vm.errorMessage {
            Spacer()
            Text(err)
                .font(.callout.weight(.medium))
                .foregroundStyle(.secondary.opacity(0.6))
                .frame(maxWidth: .infinity)
            Spacer()
        } else if vm.matches.isEmpty {
            Spacer()
            Text("No games today")
                .font(.callout.weight(.medium))
                .foregroundStyle(.secondary.opacity(0.6))
                .frame(maxWidth: .infinity)
            Spacer()
        } else {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(vm.matches) { match in
                        ScoreCard(match: match, sport: vm.sportFilter)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
    }
}

#Preview {
    ScoresView()
}
