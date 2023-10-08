//
//  PythonRun.h
//  PyIDE
//
//  Created by Даниил Суханов on 17.09.2023.
//

#ifndef PythonRun_h
#define PythonRun_h

#include <Python.h>
#include <code.h>
#include <frameobject.h>
#include "WriteTerminal.h"
#include "ItemDictionary.h"

/// test gdhjasfojshdbi!!!
extern void runPython(const char *filepath, const ItemDictionary *breakpoints, const int amountBreakpoints);

#endif /* PythonRun_h */
