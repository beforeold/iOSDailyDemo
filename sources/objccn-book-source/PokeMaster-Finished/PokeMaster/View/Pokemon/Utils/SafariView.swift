//
//  SafariView.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/08/25.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {

    let url: URL
    let onFinished: () -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>)
    {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        let parent: SafariView

        init(_ parent: SafariView) {
            self.parent = parent
        }

        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            parent.onFinished()
        }
    }
}
