//
//  CreatingFileView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 05.02.2023.
//

import SwiftUI
import Foundation

struct CreatingFileView: View {
    @Binding var currentContainer: VFSContainer?
    @State private var filename = ""
    @State private var isDirectory = false
    @ObservedObject var virtualFileSystem: VirtualFileSystem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            List([virtualFileSystem.rootDirectory.pack()],
                 children: \.component.storedDirectories) { item in
                let component = item.component
                if component is VFSDirectory {
                    Button(component.name) {
                        currentContainer = item
                    }.underline(currentContainer == item)
                }
            }
            HStack {
                TextField("filename", text: $filename).autocorrectionDisabled(false)
                Toggle("Directory", isOn: $isDirectory)
            }
            Button("Create in the \(currentContainer?.component.name ?? "")") {
                let component = currentContainer!.component as? VFSDirectory
                guard let directory = component else {
                    return
                }
                if isDirectory {
                    try? directory.appendComponent(VFSDirectory(filename, parentDirectory: directory).pack())
                } else {
                    try? directory.appendComponent(VFSFile(filename, parentDirectory: directory).pack())
                }
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
