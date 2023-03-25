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
        updateHighlightingCode()
        uiTextView.delegate = context.coordinator
        uiTextView.font = .systemFont(ofSize: 24)
        return uiTextView
    }
    
    private func highlightComponent(component: ASTComponent, mAttrString: NSMutableAttributedString, startIndex: Int) -> NSMutableAttributedString {
        guard let colOffset = component.col_offset, let lineno = component.lineno, let color = component.color() else {
            return mAttrString
        }
        var rightWords: [String]
        switch component.type {
        case "Import":
            rightWords = ["from", "import"]
        default:
            return mAttrString
        }
        var ranges = [NSRange](), string: String, index: String.Index, endIndex: String.Index?,
            words: [String], word: String
        index = mAttrString.string.index(mAttrString.string.startIndex, offsetBy: startIndex)
        string = String(mAttrString.string[index..<mAttrString.string.endIndex])
        endIndex = string.firstIndex(of: "\n")
        if endIndex == nil {
            endIndex = mAttrString.string.endIndex
        }
        string = String(string[string.startIndex..<endIndex!])
        words = string.components(separatedBy: "")
        var sum = 0
        for i in 0..<words.count where !words[i].isEmpty{
            word = words[i]
            sum += word.count
            guard rightWords.contains(word) else {
                continue
            }
            print(word)
            ranges.append(NSRange(location: startIndex, length: startIndex + sum + i))
        }
        for range in ranges {
            mAttrString.addAttribute(.foregroundColor, value: color, range: range)
        }
        return mAttrString
    }
    

    func updateHighlightingCode() { // TODO: Не работет
        let file = container?.component as! VFSFile
        var stack = [file.getJSONData()], component: ASTComponent,
            mutableString = NSMutableAttributedString(string: file.data!),
            startIndex: Int
        let firstIndexesRowsCode = file.data!.components(separatedBy: "\n").map {
            $0.count
        }
        while !stack.isEmpty {
            component = stack.popLast()!
            startIndex = firstIndexesRowsCode.reduce(0, +)
            mutableString = highlightComponent(component: component, mAttrString: mutableString, startIndex: startIndex)
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
