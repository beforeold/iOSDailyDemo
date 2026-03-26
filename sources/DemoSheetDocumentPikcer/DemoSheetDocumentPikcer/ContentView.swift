//
//  ContentView.swift
//  DemoSheetDocumentPikcer
//
//  Created by beforeold on 3/25/26.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct DocumentPickerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}

struct DocumentBrowserView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIDocumentBrowserViewController {
        let browser = UIDocumentBrowserViewController(forOpening: [.item])
        browser.allowsDocumentCreation = false
        browser.allowsPickingMultipleItems = false
        return browser
    }

    func updateUIViewController(_ uiViewController: UIDocumentBrowserViewController, context: Context) {}
}

enum SheetType: Identifiable {
    case picker
    case browser

    var id: Self { self }
}

struct DocumentSheetVCWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DocumentSheetViewController {
        DocumentSheetViewController()
    }
    func updateUIViewController(_ uiViewController: DocumentSheetViewController, context: Context) {}
}

struct PickerHitTestVCWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PickerHitTestViewController {
        PickerHitTestViewController()
    }
    func updateUIViewController(_ uiViewController: PickerHitTestViewController, context: Context) {}
}

struct ContentView: View {
    @State private var activeSheet: SheetType?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button("Document Picker") {
                    activeSheet = .picker
                }

                Button("Document Browser") {
                    activeSheet = .browser
                }

                NavigationLink("UIKit ViewController →") {
                    DocumentSheetVCWrapper()
                        .navigationTitle("UIKit Sheet")
                        .navigationBarTitleDisplayMode(.inline)
                        .ignoresSafeArea()
                }

                NavigationLink("Picker HitTest →") {
                    PickerHitTestVCWrapper()
                        .navigationTitle("Picker HitTest")
                        .navigationBarTitleDisplayMode(.inline)
                        .ignoresSafeArea()
                }
            }
            .font(.title2)
            .padding()
            .navigationTitle("SwiftUI Sheet")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $activeSheet) { type in
            switch type {
            case .picker:
              // Text("hello")
              DocumentPickerView()
                // .environment(.userInterfaceLevel, .base)
                .presentationDetents([.medium, .large])
            case .browser:
                DocumentBrowserView()
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    ContentView()
}
