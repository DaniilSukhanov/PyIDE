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
        uiTextView.delegate = context.coordinator
        if file != nil {
            uiTextView.text = file!.data
        }
        return uiTextView
    }

    
}

struct CodeEditor_Previews: PreviewProvider {
    
    static var previews: some View {
        Text("")
    }
}
