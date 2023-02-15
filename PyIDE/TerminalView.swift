//
//  TerminalView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import SwiftUI

struct TerminalView: View {
    @State private var textTerminal = ""
    @State private var textInput = ""
    @ObservedObject var virtualFileSystem: VirtualFileSystem
    
    var body: some View {
        VStack {
            Text(textTerminal)
            TextField("input", text: $textInput)
            Button("Reset") {
                update()
            }

        }.padding()
        
    }
    
    func update() {
        try! textTerminal = String(contentsOf: virtualFileSystem.urlFileTerminal)
    }
}

struct TerminalView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
