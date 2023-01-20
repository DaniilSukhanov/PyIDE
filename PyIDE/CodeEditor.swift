//
//  CodeEditor.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import SwiftUI
import Foundation

struct CodeEditor: UIViewRepresentable {
    class Coordinator: NSObject, UITextViewDelegate {
        var parentView: CodeEditor
        
        init(parentView: CodeEditor) {
            self.parentView = parentView
        }
        func textViewDidChange(_ textView: UITextView) {
            parentView.virtualFileSystem.currentFile!.data = textView.text
        }
    }
    
    var virtualFileSystem: VirtualFileSystem
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parentView: self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print()
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UITextView(), file: VFSFile? = virtualFileSystem.currentFile
        view.delegate = context.coordinator
        if file != nil {
            view.text = file!.data!
        }
        
        return view
    }
    
}

struct CodeEditor_Previews: PreviewProvider {
    @StateObject static var vfs = try! VirtualFileSystem(project: Project(name: "test"))
    
    static var previews: some View {
        CodeEditor(virtualFileSystem: vfs)
    }
}
