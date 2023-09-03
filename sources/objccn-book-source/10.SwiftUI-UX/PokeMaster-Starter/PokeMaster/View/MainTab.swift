//
//  MainTab.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/09/02.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct MainTab: View {

    @EnvironmentObject var store: Store

    private var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    private var pokemonListBinding: Binding<AppState.PokemonList> {
        $store.appState.pokemonList
    }

    private var selectedPanelIndex: Int? {
        pokemonList.selectionState.panelIndex
    }

    var body: some View {
        TabView {
            PokemonRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("列表")
            }
            SettingRootView().tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
        }
        .edgesIgnoringSafeArea(.top)
        .overlay(panel)
    }

    var panel: some View {
        Group {
            if pokemonList.selectionState.panelPresented {
                if selectedPanelIndex != nil && pokemonList.pokemons != nil {
                    PokemonInfoPanelOverlay(model: pokemonList.pokemons![selectedPanelIndex!]!)
                } else {
                    EmptyView()
                }
            } else {
                EmptyView()
            }
        }
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
