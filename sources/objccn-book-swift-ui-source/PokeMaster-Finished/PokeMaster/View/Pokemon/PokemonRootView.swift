//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/08/05.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {

    @EnvironmentObject var store: Store

    var body: some View {
        NavigationView {
            if store.appState.pokemonList.pokemons == nil {
                if store.appState.pokemonList.pokemonsLoadingError != nil {
                    RetryButton {
                        self.store.dispatch(.loadPokemons)
                    }.offset(y: -40)
                } else {
                    LoadingView()
                        .offset(y: -40)
                        .onAppear {
                            self.store.dispatch(.loadPokemons)
                        }
                }
            } else {
                PokemonList()
                    .navigationBarTitle("宝可梦列表")
            }
        }
    }

    struct RetryButton: View {

        let block: () -> Void

        var body: some View {
            Button(action: {
                self.block()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.gray)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray)
                )
            }
        }
    }


}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRootView().environmentObject(Store.sample)
    }
}
#endif
