//
//  HomeView.swift
//  TestWriteFile
//
//  Created by Brook_Mobius on 2023/3/28.
//

import SwiftUI

struct HomeView: View {
  @StateObject var viewModel: HomeViewModel = .init()
  
  var body: some View {
    if let progress = viewModel.isLoading {
      VStack(spacing: 20) {
        ProgressView()
        Text("Loading... \(progress)")
      }
    } else {
      makeButtons()
    }
  }
  
  func makeButtons() -> some View {
    VStack(spacing: 40) {
      Text("(slow at first time)")
        .foregroundColor(.gray)
        .padding(.bottom, 50)
      
      Button("Add 100 MB") {
        viewModel.add(count: 1)
      }
      
      Button("Add 500 MB") {
        viewModel.add(count: 5)
      }
      
      Button("Add 1 GB") {
        viewModel.add(count: 10)
      }
      
      Button("Add 5 GB") {
        viewModel.add(count: 50)
      }
    }.font(.subheadline)
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
