//
//  CodeEditor.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import SwiftUI
import Foundation

struct CodeEditor: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parentView: CodeEditor
        
        init(parentView: CodeEditor) {
            self.parentView = parentView
        }
        func textViewDidChange(_ textView: UITextView) {
            parentView.text = textView.text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parentView: self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print()
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UITextView()
        view.delegate = context.coordinator
        return view
    }
    
}

struct CodeEditor_Previews: PreviewProvider {
    @State static var text = ""
    
    static var previews: some View {
        CodeEditor(text: $text)
    }
}
