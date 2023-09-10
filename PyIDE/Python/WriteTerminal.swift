//
//  write.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.09.2023.
//

import Foundation
import SwiftUI
import Combine

class StreamingDataManager: ObservableObject {
    @Published var string = ""
    var cancellables = Set<AnyCancellable>()
    static fileprivate var instances = [String: StreamingDataManager]()
    static let shared = StreamingDataManager()
    
    init() {
        $string
        .sink { text in
            StreamingDataManager.shared.string += text
        }
        .store(in: &cancellables)
    }
}

@objc public class ProgramMediator: NSObject {
    
    @objc static func writeSwift(_ string: String) {
        StreamingDataManager.shared.string += string
    }
}
