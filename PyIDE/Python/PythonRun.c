//
//  PythonRun.c
//  PyIDE
//
//  Created by Даниил Суханов on 17.09.2023.
//

#include "PythonRun.h"

static PyObject* flushStdout(PyObject* self, PyObject* args) {
    Py_RETURN_NONE;
};
static PyObject* writeStdout(PyObject* self, PyObject* args) {
    PyObject* string = PyTuple_GetItem(args, 0);
    if (!PyUnicode_Check(string)) {
        printf("Error1\n");
        Py_RETURN_NONE;
    }
    const char* utf8Str = PyUnicode_AsUTF8(string);
    if (utf8Str == NULL) {
        printf("Error2\n");
        Py_RETURN_NONE;
    }
    writeTerminal(utf8Str);
    Py_RETURN_NONE;
};

static PyMethodDef methodsStdout[] = {
    {"write", writeStdout, 1, "Method 1 docstring"},
    {"flush", flushStdout, METH_NOARGS, "Method 2 docstring"},
    {NULL, NULL, 0, NULL}  // Sentinel to indicate end of methods
};

static struct PyModuleDef moduleStdout = {
    PyModuleDef_HEAD_INIT,
    "stdout_module",  // Имя модуля
    "Module docstring",
    -1,
    methodsStdout
};

PyMODINIT_FUNC PyInit_stdout(void) {
    return PyModule_Create(&moduleStdout);
}

static PyObject* flushStdin(PyObject* self, PyObject* args) {
    Py_RETURN_NONE;
} ;
static PyObject* writeStdin(PyObject* self, PyObject* args) {
    Py_RETURN_NONE;
};

static PyObject* readlineStdin(PyObject* self, PyObject* args) {
    const char* data = readLineInput();
    PyObject* pythonString = PyUnicode_DecodeFSDefault(data);
    return pythonString;
}

static PyMethodDef methodsStdin[] = {
    {"write", writeStdin, 1, "Method 1 docstring"},
    {"flush", flushStdin, METH_NOARGS, "Method 2 docstring"},
    {"readline", readlineStdin, METH_NOARGS, "Method 2 docstring"},
    {NULL, NULL, 0, NULL}  // Sentinel to indicate end of methods
};

static struct PyModuleDef moduleStdin = {
    PyModuleDef_HEAD_INIT,
    "stdin_module",  // Имя модуля
    "Module docstring",
    -1,
    methodsStdin
};

PyMODINIT_FUNC PyInit_stdin(void) {
    return PyModule_Create(&moduleStdin);
}

static int traceFunction(PyObject *obj, PyFrameObject *frame, int event, PyObject *arg) {
    if (event == PyTrace_LINE) {
        const int current_line = PyFrame_GetLineNumber(frame);
        PyObject *pythonFilename = frame->f_code->co_filename;
        const char *filename = PyUnicode_AsUTF8(pythonFilename);
        setBreakpoint(filename, current_line);
        if (current_line == 2) {
            while (0) {
                
            }
        }
    }
    return 0;
}



extern void runPython(const char *filepath, const ItemDictionary *breakpoints, const int amountBreakpoints) {
    Py_Initialize();
    PyObject *pythonBreakpoints = PyDict_New();
    ItemDictionary item;
    for (int i = 0; i < amountBreakpoints; i++) {
        item = breakpoints[i];
        PyObject *list = PyList_New(item.amountBreakpoint);
        for (int j = 0; j < item.amountBreakpoint; j++) {
            PyObject *element = PyLong_FromLong(item.value[j]);
            PyList_Append(list, element);
            Py_DECREF(element);
        }
        PyDict_SetItem(pythonBreakpoints, PyUnicode_FromString(item.key), list);
    }
    PyEval_SetTrace(traceFunction, pythonBreakpoints);
    PySys_SetObject("stdout", PyInit_stdout());
    PySys_SetObject("stdin", PyInit_stdin());
    FILE *file = fopen(filepath, "r");
    PyRun_SimpleFile(file, filepath);
    fclose(file);
    Py_DECREF(pythonBreakpoints);
    Py_Finalize();
}
