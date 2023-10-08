//
//  write.h
//  PyIDE
//
//  Created by Даниил Суханов on 24.09.2023.
//

#ifndef write_h
#define write_h

void writeTerminal(const char *string);
const char* readLineInput(void);
void setBreakpoint(const char *filepath, const int numberLine);

#endif /* write_h */
