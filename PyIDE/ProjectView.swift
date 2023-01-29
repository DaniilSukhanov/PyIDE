//
//  ProjectView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import SwiftUI

struct ProjectView: View {
    @StateObject var project: Project
    
    var body: some View {
        NavigationSplitView {
            VirtualFileSystemView(virtualFileSystem: project.virtualFileSystem!)
                .toolbar {
                    Button {
                        let directory = project.virtualFileSystem?.rootDirectory
                        let filename = "test.py"
                        try? directory?.appendComponent(VFSFile(filename, parentDirectory: directory!))
                        project.virtualFileSystem?.updateStoredComponents()
                    } label: {
                        Image(systemName: "doc.fill.badge.plus")
                    }
                }
        } detail: {
            CodeEditor(virtualFileSystem: project.virtualFileSystem!)
        }.toolbar {
            Button {
                print("trestjsdos")
            } label: {
                Image(systemName: "arrowtriangle.forward.fill")
            }
        }.environmentObject(self.project.virtualFileSystem!)
    }
}

    struct ProjectView_Previews: PreviewProvider {
        static var project = try! Project(name: "test")
        
        static var previews: some View {
            ProjectView(project: project)
        }
}
