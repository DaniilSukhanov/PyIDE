//
//  ASTComponents.swift
//  PyIDE
//
//  Created by Даниил Суханов on 21.03.2023.
//

import Foundation
import UIKit

struct ASTComponent: Decodable {
    let type: String
    let lineno: Int?
    let col_offset: Int?
    let end_lineno: Int?
    let end_col_offset: Int?
    let body: [ASTComponent]?
    let orelse: [ASTComponent]?

    func color() -> UIColor? {
        var color: UIColor?
        switch type {
        case "Import", "FunctionDef", "For", "While", "If", "Return", "AsyncFunctionDef", "ImportFrom", "With":
            color = UIColor.orange
        default:
            return nil
        }
        return color
    }
}
