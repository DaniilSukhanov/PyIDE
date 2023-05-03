//
//  Timer+Init.swift
//  PyIDE
//
//  Created by Даниил Суханов on 02.05.2023.
//

import Foundation
import OSLog

extension Timer {
    var logger: Logger {
        StorageTimer.logger
    }
    
    fileprivate struct StorageTimer {
        static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "timer")
    }
    
    func start() {
        StorageTimer.logger.info("Запуск терминала \(self.hashValue)")
        self.fire()
    }
    
    func stop() {
        StorageTimer.logger.info("Завершение терминала \(self.hashValue)")
        self.invalidate()
    }
}

