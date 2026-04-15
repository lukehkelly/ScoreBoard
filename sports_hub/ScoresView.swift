//
//  ScoresView.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import SwiftUI

struct ScoresView: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 4) {
                Text("SCORES")
                    .font(.caption2.weight(.semibold))
                    .kerning(3)
                    .foregroundStyle(.secondary)
                Text("Today")
                    .font(.title.weight(.black))
                    .foregroundStyle(.primary)

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 60)
        }
    }
}

#Preview {
    ScoresView()
}
