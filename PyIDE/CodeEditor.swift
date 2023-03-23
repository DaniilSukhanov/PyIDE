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
        // updateHighlightingCode()
        uiTextView.delegate = context.coordinator
        uiTextView.font = .systemFont(ofSize: 24)
        return uiTextView
    }

    func updateHighlightingCode() { // TODO: colOffset-endColOffset кол-во символов utf-8
        let file = container?.component as! VFSFile
        var stack = [file.getJSONData()], component: ASTComponent,
            range: NSRange, mutableString = NSMutableAttributedString(string: file.data!)
        let firstIndexesRowCode = file.data!.components(separatedBy: "\n").map {
            $0.count
        }
        while !stack.isEmpty {
            component = stack.popLast()!
            if let color = component.color(), let lineno = component.lineno,
               let colOffset = component.col_offset, let endColOffset = component.end_col_offset {
                let startIndex = firstIndexesRowCode[..<lineno].reduce(0, +)
                range = NSRange(location: startIndex + colOffset, length: startIndex + endColOffset)
                mutableString.addAttribute(.foregroundColor, value: color, range: range)
            }
            guard let body = component.body else {
                continue
            }
            for newComponent in body {
                stack.append(newComponent)
            }
        }
        uiTextView.attributedText = mutableString
    }
}

struct CodeEditor_Previews: PreviewProvider {
    
    static var previews: some View {
        Text("")
    }
}
