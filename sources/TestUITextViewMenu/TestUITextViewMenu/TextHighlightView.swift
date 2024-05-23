//
//  TextHighlightView.swift
//  TestUITextViewMenu
//
//  Created by beforeold on 5/1/24.
//

import UIKit
import SwiftUI

struct TextHighlightView: View {
  @State private var text = "这是一段长文本，你可以通过长按来选择任意内容，然后弹出操作框，提供高亮和评论的功能。 \n Hello world!"
  
  @State private var selectedText = ""
  
  var body: some View {
    VStack {
      TextView1(text: self.text, selectedText: self.$selectedText)
        .frame(minWidth: 10, maxWidth: .infinity, minHeight: 10, maxHeight: .infinity)
        .padding()
      Text("Selected Text: \(selectedText)")
        .padding()
    }
  }
}

struct TextView1: UIViewRepresentable {
  var text: String
  @Binding var selectedText: String
  
  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.isEditable = false
    textView.isUserInteractionEnabled = true
    textView.delegate = context.coordinator
    
    // let interaction = UIEditMenuInteraction(delegate: context.coordinator)
    // textView.addInteraction(interaction)
    
    return textView
  }
  
  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self, selectedText: self.$selectedText)
  }
  
  class Coordinator: NSObject, UITextViewDelegate {
    var parent: TextView1
    @Binding var selectedText: String
    
    init(parent: TextView1, selectedText: Binding<String>) {
      self.parent = parent
      self._selectedText = selectedText
    }
    
    func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
      print(#function)
      
      // suggestedActions.forEach { print($0) }
      print("suggestedActions count", suggestedActions.count)
      
      let highlightAction = UIAction(title: "Highlight") { action in
        // 在这里实现高亮功能
        print("Highlight")
      }
      
      let commentAction = UIAction(title: "Comment") { action in
        // 在这里实现评论功能
        print("Comment")
      }
      
      let textMenu = UIMenu(title: "Text...", children: suggestedActions)
      
      let menu = UIMenu(
        title: "1111",
        children: [highlightAction, commentAction, textMenu]
      )
      return menu
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
      print(#function)
      
      if textView.window == nil {
        // fix runtime warning: Modifying state during view update, this will cause undefined behavior.
        return
      }
      
      let selectedText = textView.selectedTextRange.flatMap { textView.text(in: $0) }
      self.selectedText = selectedText ?? ""
    }
  }
}

extension TextView1.Coordinator: UIEditMenuInteractionDelegate {
  func editMenuInteraction(
    _ interaction: UIEditMenuInteraction,
    configurationForMenuAtLocation location: CGPoint
  ) -> UIMenu? {
    let highlightAction = UIAction(title: "Highlight") { action in
      // 在这里实现高亮功能
      print("Highlight")
    }
    
    let commentAction = UIAction(title: "Comment") { action in
      // 在这里实现评论功能
      print("Comment")
    }
    
    let menu = UIMenu(title: "1111", children: [highlightAction, commentAction])
    return menu
  }
}

#Preview {
  TextHighlightView()
}

