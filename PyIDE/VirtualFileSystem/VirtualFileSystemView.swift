//
//  VirtualFileSystemView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 04.01.2023.
//

import SwiftUI

struct VirtualFileSystemView: View {
    @ObservedObject var virtualFileSystem: VirtualFileSystem
    @StateObject var rootDirectory: VFSDirectory
    @Binding private var selectedVFSContainer: VFSContainer?
    @State private var isShowingSheet = false
    @State private var selectedDirectory: VFSContainer
    
    init (virtualFileSystem: VirtualFileSystem, selectedVFSContainer: Binding<VFSContainer?>) {
        self.virtualFileSystem = virtualFileSystem
        self._rootDirectory = StateObject(wrappedValue: virtualFileSystem.rootDirectory)
        self._selectedVFSContainer = selectedVFSContainer
        self.selectedDirectory = virtualFileSystem.rootDirectory.pack()
    }
    
    var body: some View {
        VStack {
            List(rootDirectory.storedComponents!, children: \.component.storedComponents, selection: $selectedVFSContainer) { item in
                let component = item.component
                Group {
                    if component is VFSDirectory {
                        Text(component.name)
                            .swipeActions {
                                Button {
                                    selectedDirectory = item
                                } label: {
                                    Text("new file")
                                }
                            }
                    } else {
                        Button(component.name) {
                            selectedVFSContainer = item
                        }
                    }
                }.swipeActions {
                    Button("delete") {
                        item.component.kill()
                        virtualFileSystem.updateStoredComponents()
                    }
                }
            }.listStyle(.insetGrouped)
        }.toolbar {
            Button {
                isShowingSheet.toggle()
            } label: {
                Image(systemName: "doc.fill.badge.plus")
            }
        }.sheet(isPresented: $isShowingSheet) {
            CreatingFileView(currentContainer: $selectedDirectory, virtualFileSystem: virtualFileSystem)
        }.toolbar {
            Button {
                virtualFileSystem.updateStoredComponents()
            } label: {
                Image(systemName: "goforward")
            }
        }
    }
}

struct VirtualFileSystemView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}


