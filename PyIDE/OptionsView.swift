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
    @State private var projects: [Project] = [try! Project(name: "123")]
    
    var body: some View {
        NavigationStack(path: $listViews.data) {
            NavigationSplitView {
                Text("Welcome to PyIDE").font(.largeTitle)
                List(DetailContentViews.allCases, id: \.self, selection: $selectedDetailView) { detailView in
                    Text(detailView.rawValue)
                }.listStyle(.insetGrouped)
            } detail: {
                switch selectedDetailView {
                case .selectingProject: ProjectSelectionView(collectionProjects: $projects)
                case .creatingProject: ProjectCreatingView(collectionProjects: $projects)
                case .none: Text("")
                }
            }.navigationDestination(for: Project.self) { project in
                ProjectView(project: project)
            }
        }
        
    }
}


struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
