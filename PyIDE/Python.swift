//
//  Python.swift
//  PyIDE
//
//  Created by Даниил Суханов on 04.03.2023.
//

import Foundation
import Python


func settingsPython(urlLib: URL) {
    let stdLibPath = urlLib.appending(component: "python-stdlib")
    let libDynloadPath = stdLibPath.appending(component: "lib-dynload")
    setenv("PYTHONHOME", stdLibPath.path(), 1)
    setenv("PYTHONPATH", "\(stdLibPath.path()):\(libDynloadPath.path())", 1)
    Py_Initialize()
}

func runPythonFile(url: URL, urlFileTerminal: URL) {
    let code = """
    import sys
    import os
    sys.path.append('\(url.deletingLastPathComponent().path())')
    with open('\(urlFileTerminal.path())', 'w') as sys.stdout:
        import \(url.lastPathComponent.components(separatedBy: ".")[0])
    """
    PyRun_SimpleString(code)
}

func analysePythonCode(file: VFSFile) {
    let code = """
    import ast
    import json


    def get_dict_by_obj(obj):
        res = {}
        type_element = type(obj)
        res["type"] = type_element.__name__
        for attr in obj.__dict__.keys():
            if attr not in object.__dict__:
                value = getattr(obj, attr)
                if type(value) is list:
                    res[attr] = list(map(get_dict_by_obj, value))
                elif isinstance(value, ast.AST):
                    res[attr] = get_dict_by_obj(value)
                else:
                    res[attr] = value
        return res


    def main():
        with open("\(file.url.path())") as f:
            data = f.read()
        tree = ast.parse(data)
        result = get_dict_by_obj(tree)
        with open("\(file.urlJSONAST.path())", "w") as f:
            json.dump(result, f, indent=4)


    main()
    """
    PyRun_SimpleString(code)
}