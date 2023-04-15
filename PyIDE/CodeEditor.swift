//
//  CodeEditor.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import SwiftUI
import Foundation

struct CodeEditor: UIViewRepresentable {
    class Coordinator: NSObject, UITextViewDelegate, ObservableObject {
        @Published var parentView: CodeEditor
        
        init(parentView: CodeEditor) {
            self.parentView = parentView
        }
        func textViewDidChange(_ textView: UITextView) {
            (parentView.container!.component as! VFSFile).data = textView.text
            parentView.updateHighlightingCode()
        }
    }
    @Binding var container: VFSContainer?
    private(set) var uiTextView: UITextView = UITextView()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parentView: self)
    }
    
    func pushDataCurrentFile() {
        (container!.component as! VFSFile).pushData(uiTextView.text)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiTextView.text = (container!.component as! VFSFile).data!
        updateHighlightingCode()
        uiTextView.delegate = context.coordinator
        uiTextView.font = .systemFont(ofSize: 24)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let file = container!.component as? VFSFile
        if file != nil {
            uiTextView.text = file!.data
        }
        updateHighlightingCode()
        uiTextView.delegate = context.coordinator
        uiTextView.font = .systemFont(ofSize: 24)
        return uiTextView
    }

    func updateHighlightingCode() {
        let file = container?.component as! VFSFile
        let string = file.data!
        let mutableString = NSMutableAttributedString(string: string)
        let highlightingWords = string.ranges(words: ["if", "elif", "else", "from", "import", "for", "def"])
        print(Array(string))
        print(highlightingWords)
        for (_, ranges) in highlightingWords {
            for range in ranges {
                mutableString.addAttribute(.foregroundColor, value: UIColor.orange, range: range)
            }
        }
        let font = uiTextView.font
        let cursorPosition = uiTextView.selectedTextRange?.start
        uiTextView.attributedText = mutableString
        uiTextView.font = font
        if let cursorPosition {
            uiTextView.selectedTextRange = uiTextView.textRange(from: cursorPosition, to: cursorPosition)
        }
    }
}

struct CodeEditor_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
