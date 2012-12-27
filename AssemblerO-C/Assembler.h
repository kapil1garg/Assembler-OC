//
//  Assembler.h
//  AssemblerO-C
//
//  Created by Kapil Garg on 12/3/12.
//  Copyright (c) 2012 KapilAndrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Assembler : NSObject
{
@private
    NSMutableArray *read;
    NSMutableArray *binary;
    NSMutableArray *variables;
    NSMutableDictionary *comp;
    NSMutableDictionary *dest;
    NSMutableDictionary *jmp;
    NSMutableDictionary *vars;
}
-(void) readFile;
-(void) writeFile;

-(void) cleanFile;
-(void) cleanArray;

-(NSString*) cInstruction: (NSInteger) index;
-(NSString*) aInstruction: (NSInteger) index;
-(NSString*) jumpInstruction: (NSInteger) index;
-(void) convert;
-(NSString*) binary: (NSInteger) theNumber;

@end
