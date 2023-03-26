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
        case "Import":
            color = UIColor.orange
        case "FunctionDef":
            color = UIColor.orange
        case "For":
            color = UIColor.orange
        case "While":
            color = UIColor.orange
        case "If":
            color = UIColor.orange
            
        default:
            break
        }
        return color
    }
}
