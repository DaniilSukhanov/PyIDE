//
//  ProjectSelectionView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 01.12.2022.
//

import SwiftUI

struct ProjectSelectionView: View {
    @Binding var collectionProjects: [Project]
    @EnvironmentObject var listViews: ListViews
    
    var body: some View {
        List(collectionProjects) { project in
            Button(project.name) {
                listViews.append(project)
            }
        }
    }
}

struct ProjectSelectionView_Previews: PreviewProvider {
    @State static private var collectionProjects = try! [Project(name: "Parser"), Project(name: "Calculator")]
    
    static var previews: some View {
        ProjectSelectionView(collectionProjects: $collectionProjects)
    }
}

