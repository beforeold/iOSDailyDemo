//
//  PokemonInfoPanel.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/08/06.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonInfoPanel: View {

    @EnvironmentObject var store: Store

    @Environment(\.colorScheme) var colorScheme

    let model: PokemonViewModel
    var abilities: [AbilityViewModel]? {
        store.appState.pokemonList.abilityViewModels(for: model.pokemon)
    }

    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }

    var pokemonDescription: some View {
        Text(model.descriptionText)
        .font(.callout)
        .foregroundColor(
            colorScheme == .light ? Color(hex: 0x666666) : Color(hex: 0xAAAAAA)
        )
        .fixedSize(horizontal: false, vertical: true)
    }

    var body: some View {
        VStack(spacing: 20) {
            topIndicator
            Group {
                Header(model: model)
                pokemonDescription
            }.animation(nil) // Fix for text animation which causes it round cornered...
            Divider()
            HStack(spacing: 20) {
                AbilityList(
                    model: model,
                    abilityModels: abilities
                )
                RadarView(
                    values: model.pokemon.stats.map { $0.baseStat },
                    color: model.color,
                    max: 120,
                    progress: CGFloat(store.appState.pokemonList.selectionState.radarProgress),
                    shouldAnimate: store.appState.pokemonList.selectionState.radarShouldAnimate
                )
                    .frame(width: 100, height: 100)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 30)
        .padding(.horizontal, 30)
        .blurBackground(style: .systemMaterial)
        .cornerRadius(20)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#if DEBUG
struct PokemonInfoPanel_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoPanel(model: .sample(id: 1)).environmentObject(Store.sample)
    }
}
#endif
