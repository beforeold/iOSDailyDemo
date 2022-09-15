//
//  ContentView.swift
//  TestSwiftHashableIdentifiable
//
//  Created by 席萍萍Brook.dinglan on 2021/10/18.
//

import SwiftUI

struct Person: Identifiable, Hashable {
    var id = UUID()
}

func foo() {
    let diffableDataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: UICollectionView()) { collectionView, indexPath, itemIdentifier in
        nil
    }
    
    print(diffableDataSource)
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
