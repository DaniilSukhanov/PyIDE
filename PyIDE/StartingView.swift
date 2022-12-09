//
//  StartingView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 01.12.2022.
//

import SwiftUI

struct StartingView: View {
    private enum DetailContentViews: String, Hashable, CaseIterable {
        case selectingProject = "Select a project"
        case creatingProject = "create a new project"
    }
    
    @State private var selectedDetailView: DetailContentViews?
    
    var body: some View {
        NavigationSplitView {
            List(DetailContentViews.allCases, id: \.self, selection: $selectedDetailView) { detailView in
                Text(detailView.rawValue)
            }
        } detail: {
            switch selectedDetailView {
            case .selectingProject: ProjectSelectionView()
            case .creatingProject: ProjectCreatingView()
            case .none: Text("nil")
            }
        }
    }
}

struct StartingView_Previews: PreviewProvider {
    static var previews: some View {
        StartingView()
    }
}
