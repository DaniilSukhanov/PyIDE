//
//  write.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.09.2023.
//

import Foundation
import SwiftUI
import Combine
import Python

@objc class StreamingDataManager: NSObject, ObservableObject {
    @Published var textTerminal = ""
    var cancellables = Set<AnyCancellable>()
    @objc static let shared = StreamingDataManager()
    private(set) static var queueInput = [String]()
    @Published private(set) var positionBreakpoint: (filepath: String, numberLine: Int)?
    
    override init() {
        super.init()
        $textTerminal
            .sink { text in
                print("result (swift): ", text)
            }
            .store(in: &cancellables)
    }
    
    static func addInInput(data string: String) {
        // print("Eval: \(String(describing: PyEval_GetGlobals()))")
        StreamingDataManager.queueInput.insert(string, at: 0)
    }
    
    @objc static func popFromInput() -> String? {
        if StreamingDataManager.queueInput.isEmpty {
            return nil
        }
        return StreamingDataManager.queueInput.popLast()!
    }
    
    @objc static func writeTerminal(_ string: String) {
        // print("Eval: \(String(describing: PyEval_GetGlobals()))")
        StreamingDataManager.shared.textTerminal += string
    }
    
    @objc func setBreakpoint(filepath: String, numberLine: Int) {
        print("breakpoint", filepath, numberLine)
        positionBreakpoint = (filepath: filepath, numberLine: numberLine)
    }
}
