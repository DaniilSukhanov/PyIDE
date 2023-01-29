//
//  VirtualFileSystemView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 04.01.2023.
//

import SwiftUI

struct VirtualFileSystemView: View {
    @ObservedObject var virtualFileSystem: VirtualFileSystem
    @ObservedObject var rootDirectory: VFSDirectory
    
    init (virtualFileSystem: VirtualFileSystem) {
        self.virtualFileSystem = virtualFileSystem
        self.rootDirectory = virtualFileSystem.rootDirectory
    }
    
    var body: some View {
        VStack {
            List(rootDirectory.storedComponents!, children: \.storedComponents) { item in
                Group {
                    if item is VFSDirectory {
                        Text(item.name)
                    } else {
                        Button(item.name) {
                            virtualFileSystem.setCurrentFile(item as! VFSFile)
                        }
                    }
                }.swipeActions {
                    Button {
                        item
                    } label: {
                        Text("delete")
                    }
                }
                
            }
        }
    }
}

struct VirtualFileSystemView_Previews: PreviewProvider {
    static var previews: some View {
        let project = try! Project(name: "qwerty")
        let vfs = try! VirtualFileSystem(project: project)
        return VirtualFileSystemView(virtualFileSystem: vfs)
    }
}


