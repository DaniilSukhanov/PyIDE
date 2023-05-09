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
        VStack(alignment: .leading, spacing: 3) {
            TextField("Name project", text: $nameProject).font(.title3).border(.black)
            Spacer()
            Button("Create a new project") {
                collectionProjects.append(try! Project(name: nameProject))
            }.keyboardShortcut("N", modifiers: .command)
        }.padding(5)
    }
}

struct ProjectCreatingView_Previews: PreviewProvider {
    @State private static var projects = [
        try! Project(name: "Test"),
        try! Project(name: "Raw")
    ]
    
    static var previews: some View {
        ProjectCreatingView(collectionProjects: $projects)
    }
}
