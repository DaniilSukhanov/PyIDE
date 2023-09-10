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
    @State private var isShowingTerminal = false
    @State private var cursorPosition: Int?
    @EnvironmentObject var listViews: ListViews
    
    
    var body: some View {
        NavigationSplitView {
            VirtualFileSystemView(virtualFileSystem: project.virtualFileSystem!,
                                  selectedVFSContainer: $selectedVFSContainer)
        } detail: {
            VStack {
                if selectedVFSContainer != nil {
                    let codeEditor = CodeEditor(container: $selectedVFSContainer, cursorPosition: $cursorPosition)
                    let terminalView = TerminalView(project.virtualFileSystem!)
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
                            isShowingTerminal.toggle()
                        } label: {
                            Image(systemName: "terminal")
                        }.keyboardShortcut("T", modifiers: .command)
                    }
                    TipsView(selectedVFSContainer: $selectedVFSContainer,
                             cursorPosition: $cursorPosition)
                    if isShowingTerminal {
                        let _ = terminalView.model.timer!.start()
                        terminalView
                    } else {
                        let _ = terminalView.model.timer!.stop()
                    }
                }
            }.toolbar {
                Menu {
                    Button("Welcome window") {
                        listViews.removeLast(listViews.count)
                    }
                    Button("Projects") {
                        isShowingSheet = true
                    }
                    Button("Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                }.keyboardShortcut("M", modifiers: .command)
            }
        }.sheet(isPresented: $isShowingSheet) {
            ProjectSelectionView()
        }
    }
}


struct ProjectView_Previews: PreviewProvider {
    static var project = try! Project(name: "test")
    
    static var previews: some View {
        ProjectView(project: project)
    }
}
