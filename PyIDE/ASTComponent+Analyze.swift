//
//  ASTComponent+Analyze.swift
//  PyIDE
//
//  Created by Даниил Суханов on 07.05.2023.
//

import Foundation

extension ASTComponent {
    func getMethods(_ component: ASTComponent? = nil) -> [ASTComponent: [ASTComponent]]? {
        var component = component
        if component == nil {
            component = self
        }
        guard let body = component!.body else {
            return nil
        }
        var components = [ASTComponent: [ASTComponent]]()
        for children in body {
            switch children.type {
            case "ClassDef":
                components.merge(getMethods(children)!) { (current, _) in
                    current
                }
            case "FunctionDef":
                guard components[component!]?.append(children) == nil else {
                    continue
                }
                components[component!] = [children]
            default:
                guard let result = getMethods(children) else {
                    continue
                }
                components.merge(result) { (current, _) in
                    current
                }
            }
        }
        return components
    }
    
    func getVariable(_ component: ASTComponent? = nil) -> [ASTComponent: ASTName]? {
        var component = component
        if component == nil {
            component = self
        }
        guard let body = component!.body else {
            return nil
        }
        var components = [ASTComponent: ASTName]()
        for children in body {
            switch children.type {
            case "Assign":
                guard let function = children.value?.function else {
                    continue
                }
                components[children.targets![0]] = function
            default:
                guard let result = getVariable(children) else {
                    continue
                }
                components.merge(result) { key, _ in
                    key
                }
            }
        }
        return components
    }
}
