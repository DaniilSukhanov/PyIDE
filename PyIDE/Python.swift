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

func analysePythonCode(urlFile: URL, urlJSONFile: URL) {
    
}
