//
//  CodeEditor.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import Foundation
import SwiftUI
import OSLog

struct CodeEditor: UIViewRepresentable {
    class Coordinator: NSObject, UITextViewDelegate, ObservableObject {
        @Published var parentView: CodeEditor
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "code-editor-coordinator")
        
        init(parentView: CodeEditor) {
            self.parentView = parentView
        }

        func textViewDidChange(_ textView: UITextView) {
            let file = parentView.container!.component as! VFSFile
            logger.info("Сохранение в \(file.url.lastPathComponent)")
            file.pushData(textView.text)
            file.pullData()
            parentView.updateHighlightingCode(parentView.uiTextView)
        }
    }

    @Binding var container: VFSContainer?
    private(set) var uiTextView: UITextView = .init()
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "code-editor")
    let words = [
        "if", "elif", "else", "from", "import", "for", "def", "async", "await", "try", "while", "class"
    ]

    func makeCoordinator() -> Coordinator {
        Coordinator(parentView: self)
    }

    func pushDataCurrentFile() {
        (container!.component as! VFSFile).pushData(uiTextView.text)
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = (container!.component as! VFSFile).data!
        updateHighlightingCode(uiView)
        uiView.autocapitalizationType = .none
        uiView.delegate = context.coordinator
        uiView.backgroundColor = .white
        uiView.font = .systemFont(ofSize: 24)
    }

    func makeUIView(context: Context) -> UITextView {
        let file = container!.component as? VFSFile
        if file != nil {
            uiTextView.text = file!.data
        }
        updateHighlightingCode(uiTextView)
        uiTextView.delegate = context.coordinator
        uiTextView.autocapitalizationType = .none
        uiTextView.backgroundColor = .white
        uiTextView.font = .systemFont(ofSize: 24)
        return uiTextView
    }

    func updateHighlightingCode(_ uiView: UITextView) {
        let file = container?.component as! VFSFile
        let string = file.data!
        let mutableString = NSMutableAttributedString(string: string)
        let highlightingWords = string.ranges(words: words)
        for (_, ranges) in highlightingWords {
            for range in ranges {
                mutableString.addAttribute(.foregroundColor, value: UIColor.orange, range: range)
            }
        }
        let font = uiTextView.font
        let cursorPosition = uiTextView.selectedTextRange?.start
        uiView.attributedText = mutableString
        uiView.autocapitalizationType = .none
        uiView.backgroundColor = .white
        uiView.font = font
        if let cursorPosition {
            uiView.selectedTextRange = uiView.textRange(from: cursorPosition, to: cursorPosition)
        }
    }
}

struct CodeEditor_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
