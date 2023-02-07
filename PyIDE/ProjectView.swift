//
//  ProjectView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import SwiftUI

struct ProjectView: View {
    @StateObject var project: Project
    @State private var selectedVFSContainer: VFSContainer?
    
    var body: some View {
        NavigationSplitView {
            VirtualFileSystemView(virtualFileSystem: project.virtualFileSystem!, selectedVFSContainer: $selectedVFSContainer)
        } detail: {
            let _ = print(selectedVFSContainer)
            if selectedVFSContainer != nil {
                CodeEditor(container: $selectedVFSContainer)
                    .toolbar {
                        Button {
                            
                        } label: {
                            Image(systemName: "arrowtriangle.forward.fill")
                        }
                    }
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
