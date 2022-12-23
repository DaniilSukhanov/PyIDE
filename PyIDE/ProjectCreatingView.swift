//
//  ProjectCreatingView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 01.12.2022.
//

import SwiftUI


struct ProjectCreatingView: View {
    @Binding var collectionProjects: [Project]
    @State private var nameProject = ""
    
    var body: some View {
        TextField("", text: $nameProject)
        Button("Create a new Project") {
            collectionProjects.append(Project(name: nameProject))
        }
    }
}

struct ProjectCreatingView_Previews: PreviewProvider {
    @State private static var projects = [
        Project(name: "Test"),
        Project(name: "Raw")
    ]
    
    static var previews: some View {
        ProjectCreatingView(collectionProjects: $projects)
    }
}
