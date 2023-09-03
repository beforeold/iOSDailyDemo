//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/09/02.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {
    var body: some View {
        NavigationView {
            PokemonList().navigationBarTitle("宝可梦列表")
        }
    }
}

struct PokemonListRoot_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRootView()
    }
}
