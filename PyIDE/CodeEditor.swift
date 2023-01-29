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
            parentView.virtualFileSystem.currentFile!.data = textView.text
        }
    }
    
    
    @ObservedObject var virtualFileSystem: VirtualFileSystem
    private(set) var uiTextView: UITextView = UITextView()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parentView: self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let currentFile = virtualFileSystem.currentFile else {
            print("Не удалось обновить файл.")
            return
        }
        uiTextView.text = currentFile.data!
    }
    
    func makeUIView(context: Context) -> some UIView {
        let file: VFSFile? = virtualFileSystem.currentFile
        uiTextView.delegate = context.coordinator
        if file != nil {
            uiTextView.text = file!.data
        }
        return uiTextView
    }

    
}

struct CodeEditor_Previews: PreviewProvider {
    @StateObject static var vfs = try! VirtualFileSystem(project: Project(name: "test"))
    
    static var previews: some View {
        CodeEditor(virtualFileSystem: vfs)
    }
}
