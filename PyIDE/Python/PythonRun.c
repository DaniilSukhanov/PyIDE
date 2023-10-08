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

int foundNumber(PyObject *list, const int number) {
    Py_ssize_t list_size = PyList_Size(list);
    for (Py_ssize_t i = 0; i < list_size; i++) {
        PyObject *item = PyList_GetItem(list, i);

        if (item != NULL) {
            long item_value = PyLong_AsLong(item);

            if (item_value == number) {
                return 1;
            }
        }
    }
    return 0;
}

/// Функция, которая будет вызываться при выполнение кода
static int traceFunction(PyObject *obj, PyFrameObject *frame, int event, PyObject *args) {
    if (event == PyTrace_LINE) {
        const int currentLine = PyFrame_GetLineNumber(frame);
        PyObject *pythonFilename = frame->f_code->co_filename;
        const char *filename = PyUnicode_AsUTF8(pythonFilename);
        PyObject *listBreakpoints = PyDict_GetItemString(obj, PyUnicode_AsUTF8(pythonFilename));
        printf("%s \n", PyUnicode_AsUTF8(pythonFilename));
        if (listBreakpoints == NULL) {
            Py_XDECREF(listBreakpoints);
            return 0;
        }
        PyObject *locals = PyEval_GetGlobals();
        PyObject *key, *value;
        Py_ssize_t pos = 0;
        while (PyDict_Next(locals, &pos, &key, &value)) {
            PyObject *variableName = PyObject_Str(key);
            PyObject *variableValue = PyObject_Repr(value);
            printf("Local Variable: %s, Value: %s\n", PyUnicode_AsUTF8(variableName), PyUnicode_AsUTF8(variableValue));
            Py_XDECREF(variableName);
            Py_XDECREF(variableValue);
        }
        
        if (foundNumber(listBreakpoints, currentLine)) {
            setBreakpoint(filename, currentLine);
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
        
        PyDict_SetItemString(pythonBreakpoints, item.key, list);
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

// создаем структуру. И пердедаем ее в класс objective-c. включаем <Pyhton.h>. Напишем интерфейс для него.
