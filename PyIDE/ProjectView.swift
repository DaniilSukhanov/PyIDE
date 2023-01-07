//
//  ProjectView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import SwiftUI

struct ProjectView: View {
    @State private var text = ""
    @StateObject var project: Project
    
    var body: some View {
        NavigationSplitView {
            VirtualFileSystemView(virtualFileSystem: project.virtualFileSystem!)
        } detail: {
            CodeEditor(text: $text)
            Button("create file") {
                try! project.virtualFileSystem?.rootDirectory.appendComponent(VFSFile("test1.txt", parentDirectory: project.virtualFileSystem!.rootDirectory))
                try! project.virtualFileSystem?.rootDirectory.appendComponent(VFSFile("test2.txt", parentDirectory: project.virtualFileSystem!.rootDirectory))
                
                try! project.virtualFileSystem?.rootDirectory.appendComponent(VFSFile("test3.txt", parentDirectory: project.virtualFileSystem!.rootDirectory))
                try! project.virtualFileSystem?.rootDirectory.appendComponent(VFSFile("test4.txt", parentDirectory: project.virtualFileSystem!.rootDirectory))
            }
        }
        
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var project = try! Project(name: "test")
    
    static var previews: some View {
        ProjectView(project: project)
    }
}
