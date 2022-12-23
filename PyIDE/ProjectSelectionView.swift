//
//  ProjectSelectionView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 01.12.2022.
//

import SwiftUI

struct ProjectSelectionView: View {
    @Binding var collectionProjects: [Project]
    @Environment(\.stackViews) var stackViews
    
    var body: some View {
        List(collectionProjects) { project in
            Button(project.name) {
                stackViews.wrappedValue.append(project)
            }
        }
    }
}

struct ProjectSelectionView_Previews: PreviewProvider {
    @State static private var collectionProjects = [Project(name: "Parser"), Project(name: "Calculator")]
    
    static var previews: some View {
        ProjectSelectionView(collectionProjects: $collectionProjects)
    }
}
