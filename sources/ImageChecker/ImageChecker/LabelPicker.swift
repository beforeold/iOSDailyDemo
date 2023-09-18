//
//  LabelPicker.swift
//  ImageChecker
//
//  Created by Brook_Mobius on 9/15/23.
//

import SwiftUI
import Kingfisher

@MainActor struct LabelPicker: View {
  @ObservedObject var tester: FaceImageTester

  @State private var showsInfo = false

  private var countState: Int? {
    tester.selectedInfo.flatMap { tester.countFlags[$0.item.url] }
  }

  private var frontState: Bool? {
    tester.selectedInfo.flatMap { tester.frontFlags[$0.item.url] }
  }

  private var qualityState: Bool? {
    tester.selectedInfo.flatMap { tester.qualityFlags[$0.item.url] }
  }

  var action: (Bool) -> Void

  var item: DataLoader.Item? {
    tester.selectedInfo?.item
  }

  init(
    tester: FaceImageTester,
    action: @escaping (Bool) -> Void
  ) {
    self.tester = tester
    self.action = action
  }

  var body: some View {
    VStack(spacing: 4) {
      ImageViewer {
        KFImage((item?.url).flatMap(URL.init))
          .resizable()
          .scaledToFit()
      }

      VStack(alignment: .leading, spacing: 16) {
        HStack(spacing: 12) {
          Text("COUNT")
            .frame(width: 80)
          ForEach([nil, 0, 1, 2], id: \.self) { flag in
            Group {
              if flag == countState {
                Button {
                  onPickCount(flag: flag, type: "COUNT")
                } label: {
                  Text(flag?.description ?? "none")
                    .frame(width: 40)
                }
                .buttonStyle(.borderedProminent)
              } else {
                Button {
                  onPickCount(flag: flag, type: "COUNT")
                } label: {
                  Text(flag?.description ?? "none")
                    .frame(width: 40)
                }
                .buttonStyle(.bordered)
              }
            }
          }
          Spacer()
        }

        HStack(spacing: 12) {
          Text("FRONT")
            .frame(width: 80)
          ForEach([nil, false, true], id: \.self) { flag in
            if flag == frontState {
              Button {
                onPick(flag: flag, type: "FRONT")
              } label: {
                Text(flag?.description ?? "none")
                  .frame(width: 40)
              }
              .buttonStyle(.borderedProminent)
            } else {
              Button {
                onPick(flag: flag, type: "FRONT")
              } label: {
                Text(flag?.description ?? "none")
                  .frame(width: 40)
              }
              .buttonStyle(.bordered)
            }
          }
        }

        HStack(spacing: 12) {
          Text("QUALITY")
            .frame(width: 80)
          ForEach([nil, false, true], id: \.self) { flag in
            if flag == qualityState {
              Button {
                onPick(flag: flag, type: "QUALITY")
              } label: {
                Text(flag?.description ?? "none")
                  .frame(width: 40)
              }
              .buttonStyle(.borderedProminent)
            } else {
              Button {
                onPick(flag: flag, type: "QUALITY")
              } label: {
                Text(flag?.description ?? "none")
                  .frame(width: 40)
              }
              .buttonStyle(.bordered)
            }
          }
        }
      }
      .font(.footnote)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 24)

      HStack(spacing: 16) {
        Button(action: { action(false) }) {
          Image(systemName: "arrowshape.backward.fill")
        }

        Spacer()

        Text(indexString)

        Button("Info") {
          showsInfo = true
        }

        Spacer()

        Button(action: { action(true) }) {
          Image(systemName: "arrowshape.forward.fill")
        }
      }
      .padding(.horizontal, 48)
    }
    .onAppear {
      print("onAppear")
    }
    .sheet(isPresented: $showsInfo) {
      VStack(spacing: 20) {
        Text(item?.url ?? "null")
        Text(tester.resultDesc)
      }
    }
  }

  var indexString: String {
    let index = tester.selectedInfo?.index ?? 0
    return "\(index + 1)/\(tester.items.count)"
  }

  private func onPickCount(flag: Int?, type: String) {
    guard let selected = tester.selectedInfo else { return }

    tester.updateCount(flag: flag, url: selected.item.url)

    if flag == 0 || flag == 2 {
      tester.handle(isForward: true, selected: selected)
    }
  }

  private func onPick(flag: Bool?, type: String) {
    guard let selected = tester.selectedInfo else { return }

    let beginDate = Date()

    if type == "FRONT" {
      tester.updateFront(flag: flag, url: selected.item.url)
    } else {
      tester.updateQuality(flag: flag, url: selected.item.url)
    }

    if let _ = frontState, let _ = qualityState {
      // go to next one
      tester.handle(isForward: true, selected: selected)
    }

    debugPrint(#function, -beginDate.timeIntervalSinceNow)
  }
}

struct ImageViewer_Previews: PreviewProvider {
  static var previews: some View {
    LabelPicker(
      tester: FaceImageTester()
    ) { _ in

    }
  }
}


struct ImageViewer<Content: View>: View {
    var builder: () -> Content

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1

    @State private var offset: CGPoint = .zero
    @State private var lastTranslation: CGSize = .zero
    @State private var isGesturesEnabled = false

    public var body: some View {
      GeometryReader { proxy in
        ZStack {
          builder()
            .scaleEffect(scale)
            .offset(x: offset.x, y: offset.y)
            .gesture(makeDragGesture(size: proxy.size))
            .gesture(makeMagnificationGesture(size: proxy.size))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .edgesIgnoringSafeArea(.all)
      }
    }

    private func makeMagnificationGesture(size: CGSize) -> some Gesture {
      MagnificationGesture()
        .onChanged { value in
          let delta = value / lastScale
          lastScale = value

          // To minimize jittering
          if abs(1 - delta) > 0.01 {
            scale *= delta
          }
        }
        .onEnded { _ in
          lastScale = 1
          if scale < 1 {
            withAnimation {
              scale = 1
            }
          }
          adjustMaxOffset(size: size)
        }
    }

    private func makeDragGesture(size: CGSize) -> some Gesture {
      DragGesture()
        .onChanged { value in
          let diff = CGPoint(
            x: value.translation.width - lastTranslation.width,
            y: value.translation.height - lastTranslation.height
          )
          offset = .init(x: offset.x + diff.x, y: offset.y + diff.y)
          lastTranslation = value.translation
        }
        .onEnded { _ in
          adjustMaxOffset(size: size)
        }
    }

    private func adjustMaxOffset(size: CGSize) {
      let maxOffsetX = (size.width * (scale - 1)) / 2
      let maxOffsetY = (size.height * (scale - 1)) / 2

      var newOffsetX = offset.x
      var newOffsetY = offset.y

      if abs(newOffsetX) > maxOffsetX {
        newOffsetX = maxOffsetX * (abs(newOffsetX) / newOffsetX)
      }
      if abs(newOffsetY) > maxOffsetY {
        newOffsetY = maxOffsetY * (abs(newOffsetY) / newOffsetY)
      }

      let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
      if newOffset != offset {
        withAnimation {
          offset = newOffset
        }
      }
      self.lastTranslation = .zero
    }
  }
