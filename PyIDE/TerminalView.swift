//
//  TerminalView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import SwiftUI

struct TerminalView: View {
    @State private var textInput = ""
    @ObservedObject var virtualFileSystem: VirtualFileSystem
    @ObservedObject var terminal: Terminal
    
    init (virtualFileSystem: VirtualFileSystem) {
        self.virtualFileSystem = virtualFileSystem
        terminal = Terminal(url: virtualFileSystem.urlFileTerminal)
        terminal.initTimer()
    }
    
    var body: some View {
        VStack {
            Text(terminal.text)
            TextField("input", text: $textInput)

        }.padding()
    }
}

struct TerminalView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
