//
//  PokemonInfoRow.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/08/05.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct PokemonInfoRow: View {

    @EnvironmentObject var store: Store

    let model: PokemonViewModel
    let expanded: Bool

    var body: some View {
        VStack {
            HStack {
                KFImage(model.iconImageURL)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .shadow(radius: 4)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(model.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    if store.appState.settings.showEnglishName {
                        Text(model.nameEN)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }.layoutPriority(1)
            }
            .padding(.top, 12)
            Spacer()
            HStack(spacing: expanded ? 20 : -30) {
                Spacer()
                Button(action: {
                    self.store.dispatch(.toggleFavorite(index: self.model.id))
                }) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .modifier(ToolButtonModifier())
                }.alert(item: self.$store.appState.pokemonList.favoriteError) { error in
                    Alert(
                        title: Text(error.localizedDescription),
                        primaryButton: .cancel(),
                        secondaryButton: .default(Text("登录")) {
                            self.store.dispatch(.switchTab(index: .settings))
                        }
                    )
                }
                Button(action: {
                    let target = !self.store.appState.pokemonList.selectionState.panelPresented
                    self.store.dispatch(.togglePanelPresenting(presenting: target))
                }) {
                    Image(systemName: "chart.bar")
                        .modifier(ToolButtonModifier())
                }

                NavigationLink(
                    destination:
                        SafariView(
                            url: model.detailPageURL,
                            onFinished: { self.store.dispatch(.closeSafariView) }
                        )
                        .navigationBarTitle(Text(model.name), displayMode: .inline)
                        .onAppear { self.store.dispatch(.togglePanelPresenting(presenting: false)) },
                    isActive: expanded ? $store.appState.pokemonList.isSFViewActive : .constant(false),
                    label: {
                        Image(systemName: "info.circle")
                            .modifier(ToolButtonModifier())
                    }
                )
            }
            .padding(.bottom, 12)
            .opacity(self.expanded ? 1.0 : 0.0)
            .frame(maxHeight: self.expanded ? .infinity : 0)
        }
        .frame(height: expanded ? 120 : 80)
        .padding(.leading, 23)
        .padding(.trailing, 15)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(model.color, style: StrokeStyle(lineWidth: 4))
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, model.color]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        )
        .padding(.horizontal)
    }

    var isFavorite: Bool {
        if let user = store.appState.settings.loginUser {
            return user.favoritePokemonIDs.contains(model.id)
        } else {
            return false
        }
    }
}

struct ToolButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}

#if DEBUG
struct PokemonInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PokemonInfoRow(model: .sample(id: 1), expanded: false)
            PokemonInfoRow(model: .sample(id: 21), expanded: true)
            PokemonInfoRow(model: .sample(id: 25), expanded: false)
        }.environmentObject(Store())
    }
}
#endif
