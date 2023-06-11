//
//  ProjectSelectionView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 01.12.2022.
//

import SwiftUI

struct ProjectSelectionView: View {
    @EnvironmentObject var listViews: ListViews
    @Environment(\.dismiss) var dismiss
    @Environment(\.projects) var projects
    
    var body: some View {
        List(projects.wrappedValue) { project in
            Button(project.name) {
                listViews.append(project)
                dismiss()
            }.swipeActions {
                Button() {
                    let manager = FileManager.default
                    projects.wrappedValue.removeAll {
                        $0 == project
                    }
                    try! manager.removeItem(at: project.virtualFileSystem!.rootDirectory.url)
                } label: {
                    Text("delete")
                }
            }
        }.toolbar {
            ToolbarItem(placement: .secondaryAction) {
                Button() {
                    
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct ProjectSelectionView_Previews: PreviewProvider {
    @State static private var collectionProjects = try! [Project(name: "Parser"), Project(name: "Calculator")]
    
    static var previews: some View {
        ProjectSelectionView()
    }
}

