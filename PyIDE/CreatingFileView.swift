//
//  CreatingFileView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 05.02.2023.
//

import SwiftUI

struct CreatingFileView: View {
    @Binding var currentContainer: VFSContainer
    @State private var filename = ""
    @ObservedObject var virtualFileSystem: VirtualFileSystem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            List([virtualFileSystem.rootDirectory.pack()], children: \.component.storedComponents) { item in
                let component = item.component
                if component is VFSDirectory {
                    Button(component.name) {
                        currentContainer = item
                        print("Выбор")
                    }
                }
                
            }
            TextField("filename", text: $filename)
            Button("create a new file") {
                let component = currentContainer.component as? VFSDirectory
                guard let directory = component else {
                    print("Component nil")
                    return
                }
                try! directory.appendComponent(VFSFile(filename, parentDirectory: directory).pack())
                virtualFileSystem.updateStoredComponents()
                dismiss()
            }
        }
    }
}

struct CreatingFileView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
