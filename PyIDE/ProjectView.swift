//
//  ProjectView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import SwiftUI
import PythonSupport

struct ProjectView: View {
    @StateObject var project: Project
    @State private var selectedVFSContainer: VFSContainer?
    @State private var isShowingSheet = false
    
    var body: some View {
        NavigationSplitView {
            VirtualFileSystemView(virtualFileSystem: project.virtualFileSystem!, selectedVFSContainer: $selectedVFSContainer)
        } detail: {
            if selectedVFSContainer != nil {
                CodeEditor(container: $selectedVFSContainer)
                    .toolbar {
                        Button {
                            let file = (selectedVFSContainer!.component as! VFSFile)
                            let str = """
                            import sys
                            sys.path.append('\(file.url.deletingLastPathComponent().path())')
                            with open('\(project.virtualFileSystem!.urlFileTerminal.path())', 'w') as sys.stdout:
                                \(file.data!)
                            """
                            initialize()
                            runSimpleString(str)
                            finalize()
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
