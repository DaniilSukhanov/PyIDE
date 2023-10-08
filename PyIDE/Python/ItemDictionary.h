//
//  ItemDictionary.h
//  PyIDE
//
//  Created by Даниил Суханов on 07.10.2023.
//

#ifndef ItemDictionary_h
#define ItemDictionary_h

typedef struct _ItemDictionary {
    const char *key;
    const int *value;
    int amountBreakpoint;
} ItemDictionary;

#endif /* ItemDictionary_h */
