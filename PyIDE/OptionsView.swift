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
    
    @Environment(\.stackViews) var stackViews
    @State private var selectedDetailView: DetailContentViews?
    @State private var projects: [Project] = [Project(name: "123")]
    
    var body: some View {
        NavigationStack(path: stackViews) {
            NavigationSplitView {
                List(DetailContentViews.allCases, id: \.self, selection: $selectedDetailView) { detailView in
                    Text(detailView.rawValue)
                }
            } detail: {
                switch selectedDetailView {
                case .selectingProject: ProjectSelectionView(collectionProjects: $projects)
                case .creatingProject: ProjectCreatingView(collectionProjects: $projects)
                case .none: Text("nil")
                }
            }.navigationDestination(for: Project.self) { project in
                Text(project.name)
            }
        }
        
    }
}


struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
