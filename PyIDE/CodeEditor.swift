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

    func updateHighlightingCode() { // TODO: не работает.
        let file = container?.component as! VFSFile
        var stack = [file.getJSONData()], component: ASTComponent
        var code = file.data! as NSString
        var mutableString = NSMutableAttributedString(string: file.data!)
        mutableString.addAttribute(.foregroundColor, value: UIColor.red, range: code.range(of: "def"))
        while !stack.isEmpty {
            component = stack.popLast()!
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
