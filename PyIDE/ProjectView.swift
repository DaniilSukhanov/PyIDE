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
    @State private var isShowingSheet = false
    
    var body: some View {
        NavigationSplitView {
            VirtualFileSystemView(virtualFileSystem: project.virtualFileSystem!, selectedVFSContainer: $selectedVFSContainer)
        } detail: {
            if selectedVFSContainer != nil {
                let codeEditor = CodeEditor(container: $selectedVFSContainer)
                codeEditor.toolbar {
                    Button {
                        let file = (selectedVFSContainer!.component as! VFSFile)
                        codeEditor.pushDataCurrentFile()
                        runPythonFile(url: file.url, urlFileTerminal: project.virtualFileSystem!.urlFileTerminal)
                    } label: {
                        Image(systemName: "arrowtriangle.forward.fill")
                    }
                }
                .toolbar {
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        Image(systemName: "terminal")
                    }
                }
                .toolbar {
                    Button("Analyze") {
                        let file = (selectedVFSContainer!.component as! VFSFile)
                        analysePythonCode(file: file)
                    }
                }
                .sheet(isPresented: $isShowingSheet) {
                    TerminalView(virtualFileSystem: project.virtualFileSystem!)
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
