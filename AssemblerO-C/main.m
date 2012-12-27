//
//  main.m
//  AssemblerO-C
//
//  Created by Kapil Garg on 12/3/12.
//  Copyright (c) 2012 KapilAndrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Assembler.h"


int main(int argc, const char * argv[])
{
    @autoreleasepool{
        Assembler *temp = [[Assembler alloc] init];
        [temp readFile];
        [temp cleanFile];
        [temp convert];
        [temp writeFile];
    }
    return 0;
}

