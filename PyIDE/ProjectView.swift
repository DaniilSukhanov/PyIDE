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
                let terminalView = TerminalView(project.virtualFileSystem!)
                VStack {
                    codeEditor.toolbar {
                        Button {
                            let file = (selectedVFSContainer!.component as! VFSFile)
                            runPythonFile(url: file.url,
                                          urlFileTerminal: project.virtualFileSystem!.urlFileTerminal,
                                          urlStdin: project.virtualFileSystem!.urlFileStdin)
                        } label: {
                            Image(systemName: "arrowtriangle.forward.fill")
                        }.keyboardShortcut("R", modifiers: .command)
                    }
                    .toolbar {
                        Button {
                            isShowingSheet.toggle()
                        } label: {
                            Image(systemName: "terminal")
                        }.keyboardShortcut("T", modifiers: .command)
                    }
                    .toolbar {
                        Button("Analyze") {
                            let file = (selectedVFSContainer!.component as! VFSFile)
                            analysePythonCode(file: file)
                        }.keyboardShortcut("A", modifiers: .command)
                    }
                    if isShowingSheet {
                        let _ = terminalView.model.timer!.start()
                        terminalView
                    } else {
                        let _ = terminalView.model.timer!.stop()
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
