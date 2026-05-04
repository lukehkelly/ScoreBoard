//
//  FilterChip.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import SwiftUI

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(isSelected ? Theme.background : Color.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(isSelected ? Theme.accent : Theme.card, in: RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(isSelected ? Theme.accent : Theme.border, lineWidth: 0.5)
                }
        }
    }
}
