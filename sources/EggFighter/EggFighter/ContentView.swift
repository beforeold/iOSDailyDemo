import SwiftUI

struct Power: Hashable, Identifiable {
  var sarah: Int
  var brook: Int

  var id: Power {
    self
  }
}

struct ContentView: View {
  @AppStorage("sarahScore") var sarahScore = 0
  @AppStorage("brookScore") var brookScore = 0

  @State var randomPower: Power?
  @State var showsRollPanel = false

  @State var showsGo = false

  @State var hit = false

  @State var goReady: String? = nil

  @State var offset: CGSize = .zero

  var body: some View {
    VStack(spacing: 30) {
      Text("蛋蛋大作战")
        .font(.largeTitle)

      score
        .font(.headline)

      Spacer()

      field
        .overlay {
          if let goReady {
            Text(goReady)
              .font(.system(size: 80))
              .fontDesign(.rounded)
              .foregroundColor(.purple)
          }
        }

      Spacer()

      if showsGo {
        goButton
      } else {
        roll
      }
    }
    .sheet(
      isPresented: $showsRollPanel,
      content: {
        RollPanel(
          completion: { sarah, brook in
            randomPower = .init(sarah: sarah, brook: brook)
            showsGo = true
          }
        )
      }
    )
    .padding()
  }

  var score: some View {
    HStack(spacing: 32) {
      Text("Sarah")
      Text("\(sarahScore)")
        .font(.title2)
        .fontWeight(.bold)

      Text("vs")

      Text("\(brookScore)")
        .font(.title2)
        .fontWeight(.bold)

      Text("Brook")
    }
  }

  var roll: some View {
    Button("开始摇点") {
      withAnimation {
        hit = false
        offset = .zero
        showsGo = false
      } completion: {
        showsRollPanel = true
      }
    }
    .buttonStyle(.borderedProminent)
    .tint(.red)
  }

  var goButton: some View {
    Button("开始撞击") {
      showsGo = false
      Task {
        let strings = ["Ready", "Steady", "Go!"]
        for string in strings {
          goReady = string
          try await Task.sleep(for: .seconds(1))
        }
        goReady = nil

        withAnimation {
          hit = true
        } completion: {
          withAnimation {
            offset = .init(
              width: (-500...500).randomElement()!,
              height: (-500...500).randomElement()!,
            )
          } completion: {
            guard let randomPower else { return }
            withAnimation(.easeIn(duration: 1)) {
              if randomPower.brook > randomPower.sarah {
                brookScore += 1
              } else if randomPower.sarah > randomPower.brook {
                sarahScore += 1
              } else {
                // same power
              }
            }
          }

        }
      }
    }
    .buttonStyle(.borderedProminent)
    .tint(.green)
  }

  var field: some View {
    HStack(spacing: 0) {
      Image(systemName: "capsule.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 80)
        .foregroundStyle(.blue)
        .overlay {
          Text("S")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.white)
        }
        .offset(sarahOffset)

      if hit == false {
        Spacer()
      }

      Image(systemName: "capsule.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 80)
        .foregroundStyle(.orange)
        .overlay {
          Text("B")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.white)
        }
        .offset(brookOffset)
    }
  }

  private var brookOffset: CGSize {
    guard let randomPower else { return .zero }

    if offset == .zero { return .zero }

    if randomPower.brook >= randomPower.sarah {
      return .zero
    }
    return offset
  }

  private var sarahOffset: CGSize {
    guard let randomPower else { return .zero }

    if offset == .zero { return .zero }

    if randomPower.sarah >= randomPower.brook {
      return .zero
    }
    return offset
  }
}

#Preview {
  ContentView()
}
