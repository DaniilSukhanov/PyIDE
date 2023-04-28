//
//  Python.swift
//  PyIDE
//
//  Created by Даниил Суханов on 04.03.2023.
//

import Foundation
import OSLog
import Python

func settingsPython(urlLib: URL) {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "python-settings")
    logger.info("Настройка переменной среды")
    let stdLibPath = urlLib.appending(component: "python-stdlib")
    let libDynloadPath = stdLibPath.appending(component: "lib-dynload")
    setenv("PYTHONHOME", stdLibPath.path(), 1)
    logger.debug("Установка PYTHONHOME: \(stdLibPath.path())")
    setenv("PYTHONPATH", "\(stdLibPath.path()):\(libDynloadPath.path())", 1)
    logger.debug("Установка PYTHONHOME: \(stdLibPath.path()):\(libDynloadPath.path())")
    Py_Initialize()
}

func runPythonFile(url: URL, urlFileTerminal: URL) {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "python-run_file")
    let code = """
    import sys
    
    if '\(url.deletingLastPathComponent().path())' not in sys.path:
        sys.path.append('\(url.deletingLastPathComponent().path())')

    filename = "\(urlFileTerminal.path())"

    def write(msg):
        with open(filename, "a") as file:
            file.write(msg)


    #sys.stdout.write = write
    
    import \(url.lastPathComponent.components(separatedBy: ".")[0])
    """
    defer {
        
    }
    
    DispatchQueue.global().async {
        let uuid = UUID()
        logger.info("(\(uuid)) Запуск python-файла \(url.lastPathComponent)")
        PyRun_SimpleString(code)
        logger.info("(\(uuid)) Конец выполнения python-файла \(url.lastPathComponent)")
    }
}

func analysePythonCode(file: VFSFile) {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "python-ast")
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
    logger.info("Посторение AST в \(file.urlJSONAST) для \(file.url)")
    PyRun_SimpleString(code)
}
