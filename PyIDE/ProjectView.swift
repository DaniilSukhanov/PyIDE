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
        } detail: {
            CodeEditor(virtualFileSystem: project.virtualFileSystem!)
        }
        
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var project = try! Project(name: "test")
    
    static var previews: some View {
        ProjectView(project: project)
    }
}
