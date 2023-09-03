//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/09/02.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        NavigationView {
            if store.appState.pokemonList.pokemons == nil {
                Text("Loading...").onAppear {
                    self.store.dispatch(.loadPokemons)
                }
            } else {
                PokemonList()
                    .navigationBarTitle("宝可梦列表")
            }
        }
    }
}

struct PokemonListRoot_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRootView()
    }
}
