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
}

func runPythonFile(url: URL, urlFileTerminal: URL, urlStdin: URL) {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "python-run-file")
    let code = """
    import sys
    import traceback
    
    if '\(url.deletingLastPathComponent().path())' not in sys.path:
        sys.path.append('\(url.deletingLastPathComponent().path())')

    filename_terminal = "\(urlFileTerminal.path())"
    with open(filename_terminal, "w") as file:
        file.write("")
    sys.stdout = open(filename_terminal, "a")
    
    def decorator(self):
        def f():
            while True:
                try:
                    row = next(self)
                except StopIteration:
                    continue
                self.seek(0)
                if row:
                    with open("\(urlStdin.path())", "w") as file:
                        file.write("")
                    return row
        return f

    sys.stdin = open("\(urlStdin.path())")
    sys.stdin.readline = decorator(sys.stdin)
    
    try:
        import \(url.lastPathComponent.components(separatedBy: ".")[0])
    except:
        sys.stdout.write(traceback.format_exc())
    """
    DispatchQueue.global().async {
        Py_Initialize()
        let uuid = UUID()
        logger.info("(\(uuid)) Запуск python-файла \(url.lastPathComponent)")
        PyRun_SimpleString(code)
        logger.info("(\(uuid)) Конец выполнения python-файла \(url.lastPathComponent)")
        Py_Finalize()
    }
}

func buildAST(file: VFSFile) {
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
        with open("\(file.url.path())", encoding="utf-8") as f:
            data = f.read()
        tree = ast.parse(data)
        result = get_dict_by_obj(tree)
        with open("\(file.urlJSONAST.path())", "w") as f:
            json.dump(result, f, indent=4)


    main()
    """
    logger.info("Посторение AST в \(file.urlJSONAST) для \(file.url)")
    Py_Initialize()
    PyRun_SimpleString(code)
    Py_Finalize()
}
