//
//  write.m
//  PyIDE
//
//  Created by Даниил Суханов on 24.09.2023.
//

#import "write.h"
#import <PyIDE-Swift.h>
#import <Foundation/Foundation.h>


void writeTerminal(char *string) {
    @autoreleasepool {
        [ProgramMediator writeSwift : [NSString stringWithFormat: @"%s", string]];
    }
}
