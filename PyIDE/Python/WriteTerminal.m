//
//  write.m
//  PyIDE
//
//  Created by Даниил Суханов on 24.09.2023.
//

#import "WriteTerminal.h"
#import <Foundation/Foundation.h>
#import <PyIDE-Swift.h>

void writeTerminal(const char *string) {
    @autoreleasepool {
        [StreamingDataManager writeTerminal : [NSString stringWithFormat: @"%s", string]];
    }
}

const char* readLineInput(void) {
    @autoreleasepool {
        NSString *string = [StreamingDataManager popFromInput];
        while (string == nil) {
            string = [StreamingDataManager popFromInput];
        }
        const char *chars = [string UTF8String];
        return chars;
    }
}

void setBreakpoint(const char *filepath, const int numberLine) {
    @autoreleasepool {
        StreamingDataManager *manager = [StreamingDataManager shared];
        [manager setBreakpointWithFilepath: [NSString stringWithFormat: @"%s", filepath] numberLine: numberLine];
    }
}
