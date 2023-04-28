//
//  Terminal.swift
//  PyIDE
//
//  Created by Даниил Суханов on 20.04.2023.
//

import Foundation
import SwiftUI
import OSLog

class Terminal: ObservableObject {
    static private var timer: Timer?
    @Published var text = ""
    var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    deinit {
        Terminal.timer?.invalidate()
    }
    
    func initTimer() {
        if Terminal.timer == nil {
            Terminal.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateData),
                                         userInfo: nil, repeats: true)
        }
        start()
    }
    
    func start() {
        Terminal.timer?.fire()
    }
    
    func stop() {
        Terminal.timer?.invalidate()
    }
    
    @objc func updateData() {
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "terminal")
        text = try! String(contentsOf: url)
        logger.info("(Таймер: \(Terminal.timer!.hash)) Отправление в терминал данных:\n\(self.text)")
    }
}
