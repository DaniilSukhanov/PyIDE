//
//  StartingView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 01.12.2022.
//

import SwiftUI


struct OptionsView: View {
    private enum DetailContentViews: String, Hashable, CaseIterable {
        case selectingProject = "Select a project"
        case creatingProject = "Create a new project"
    }
    
    @State private var text = ""
    @EnvironmentObject var listViews: ListViews
    @State private var selectedDetailView: DetailContentViews?
    @State private var projects = [Project]()
    
    var body: some View {
        NavigationStack(path: $listViews.data) {
            NavigationSplitView {
                List(DetailContentViews.allCases, id: \.self) { detailView in
                    HStack {
                        Text(detailView.rawValue)
                        Spacer()
                    }.contentShape(Rectangle()).onTapGesture {
                        selectedDetailView = detailView
                    }
                    
                }.listStyle(.insetGrouped).toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Welcome to PyIDE").font(.largeTitle).fixedSize()
                    }
                }
            } detail: {
                switch selectedDetailView {
                case .creatingProject:
                    ProjectCreatingView()
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Create a project").font(.largeTitle).fixedSize()
                            }
                        }
                case .selectingProject:
                    ProjectSelectionView()
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Projects").font(.largeTitle).fixedSize()
                            }
                        }
                case .none:
                    Text("None")
                }
                
            }.navigationDestination(for: Project.self) { project in
                ProjectView(project: project)
                    .navigationBarBackButtonHidden(true)
            }
        }.onAppear() {
            let manager = FileManager.default
            guard var url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            url.append(path: "PyIDEProjects")
            if !manager.fileExists(atPath: url.path()) {
                return
            }
            var files: [URL]
            do {
                files = try manager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            } catch {
                return
            }
            for file in files where file.lastPathComponent != ".DS_Store" {
                try! projects.append(Project(name: file.lastPathComponent))
            }
        }.environment(\.projects, $projects)
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
