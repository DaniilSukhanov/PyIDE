//
//  TerminalView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import SwiftUI
import OSLog
import Foundation

struct TerminalView: View {
    @State private var textInput = ""
    @ObservedObject var model: Model
    private var virtualFileSystem: VirtualFileSystem
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "terminal")
    
    class Model: ObservableObject {
        @Published var textOutput = ""
        var timer: Timer?
        var url: URL
        
        init(_ url: URL) {
            self.url = url
            timer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateData),
                                    userInfo: nil, repeats: true)
            
        }
        
        @objc func updateData() {
            guard timer != nil else {
                return
            }
            textOutput = try! String(contentsOf: url)
        }
        
    }
    
    init (_ virtualFileSystem: VirtualFileSystem) {
        self.virtualFileSystem = virtualFileSystem
        self.model = Model(virtualFileSystem.urlFileTerminal)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(model.textOutput).multilineTextAlignment(.leading)
            HStack {
                TextField("input", text: $textInput)
                Button("Enter") {
                    try? textInput.write(to: virtualFileSystem.urlFileStdin, atomically: false, encoding: .utf8)
                }
            }
        }.padding()
            .border(.black)
    }
}

struct TerminalView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
