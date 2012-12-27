//
//  Assembler.m
//  AssemblerO-C
//
//  Created by Kapil Garg on 12/3/12.
//  Copyright (c) 2012 KapilAndrew. All rights reserved.
//

#import "Assembler.h"
#import <Foundation/Foundation.h>

@implementation Assembler
-(id) init
{
    self = [super init];
    if (self)
    {
        comp = [[NSMutableDictionary alloc] init];
        //a=0
        [comp setObject:@"0101010" forKey:@"0"];
        [comp setObject:@"0111111" forKey:@"1"];
        [comp setObject:@"0111010" forKey:@"-1"];
        [comp setObject:@"0001100" forKey:@"D"];
        [comp setObject:@"0110000" forKey:@"A"];
        [comp setObject:@"0001101" forKey:@"!D"];
        [comp setObject:@"0110011" forKey:@"!A"];
        [comp setObject:@"0001111" forKey:@"-D"];
        [comp setObject:@"0110011" forKey:@"-A"];
        [comp setObject:@"0011111" forKey:@"D+1"];
        [comp setObject:@"0110010" forKey:@"A+1"];
        [comp setObject:@"0001110" forKey:@"D-1"];
        [comp setObject:@"0110010" forKey:@"A-1"];
        [comp setObject:@"0000010" forKey:@"D+A"];
        [comp setObject:@"0010011" forKey:@"D-A"];
        [comp setObject:@"0000111" forKey:@"A-D"];
        [comp setObject:@"0000000" forKey:@"D&A"];
        [comp setObject:@"0010101" forKey:@"D|A"];
        //a=1
        [comp setObject:@"1110000" forKey:@"M"];
        [comp setObject:@"1110001" forKey:@"!M"];
        [comp setObject:@"1110011" forKey:@"-M"];
        [comp setObject:@"1110111" forKey:@"M+1"];
        [comp setObject:@"1110010" forKey:@"M-1"];
        [comp setObject:@"1000010" forKey:@"D+M"];
        [comp setObject:@"1010011" forKey:@"D-M"];
        [comp setObject:@"1000111" forKey:@"M-D"];
        [comp setObject:@"1000000" forKey:@"D&M"];
        [comp setObject:@"1010101" forKey:@"D|M"];
        
        dest = [[NSMutableDictionary alloc] init];
        [dest setObject:@"000" forKey:@""];
        [dest setObject:@"001" forKey:@"M"];
        [dest setObject:@"010" forKey:@"D"];
        [dest setObject:@"011" forKey:@"MD"];
        [dest setObject:@"100" forKey:@"A"];
        [dest setObject:@"101" forKey:@"AM"];
        [dest setObject:@"110" forKey:@"AD"];
        [dest setObject:@"111" forKey:@"AMD"];
        
        jmp = [[NSMutableDictionary alloc] init];
        [jmp setObject:@"000" forKey:@""];
        [jmp setObject:@"001" forKey:@"JGT"];
        [jmp setObject:@"010" forKey:@"JEQ"];
        [jmp setObject:@"011" forKey:@"JGE"];
        [jmp setObject:@"100" forKey:@"JLT"];
        [jmp setObject:@"101" forKey:@"JNE"];
        [jmp setObject:@"110" forKey:@"JLE"];
        [jmp setObject:@"111" forKey:@"JMP"];
        
        vars = [[NSMutableDictionary alloc] init];
        [vars setObject: @"0"     forKey:@"SP"];
        [vars setObject: @"1"     forKey:@"LCL"];
        [vars setObject: @"2"     forKey:@"ARG"];
        [vars setObject: @"3"     forKey:@"THIS"];
        [vars setObject: @"4"     forKey:@"THAT"];
        [vars setObject: @"0"     forKey:@"R0"];
        [vars setObject: @"1"     forKey:@"R1"];
        [vars setObject: @"2"     forKey:@"R2"];
        [vars setObject: @"3"     forKey:@"R3"];
        [vars setObject: @"4"     forKey:@"R4"];
        [vars setObject: @"5"     forKey:@"R5"];
        [vars setObject: @"6"     forKey:@"R6"];
        [vars setObject: @"7"     forKey:@"R7"];
        [vars setObject: @"8"     forKey:@"R8"];
        [vars setObject: @"9"     forKey:@"R9"];
        [vars setObject: @"10"    forKey:@"R10"];
        [vars setObject: @"11"    forKey:@"R11"];
        [vars setObject: @"12"    forKey:@"R12"];
        [vars setObject: @"13"    forKey:@"R13"];
        [vars setObject: @"14"    forKey:@"R14"];
        [vars setObject: @"15"    forKey:@"R15"];
        [vars setObject: @"16384" forKey:@"SCREEN"];
        [vars setObject: @"24576" forKey:@"KBD"];
        [vars setObject: @"4"     forKey:@"LOOP"];
        
        read = [[NSMutableArray alloc] init];
        binary = [[NSMutableArray alloc] init];
        variables = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void) readFile
{
    NSString *fileString = [NSString stringWithContentsOfFile: @"/Users/Kapil_Garg/Desktop/AssemblerO-C/AssemblerO-C/test.txt" encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [fileString componentsSeparatedByString:@"\n"];
    for(NSString* objects in lines)
    {
        [read addObject:objects];
    }
}

-(void) writeFile
{
    NSString *out = [[NSString alloc]init];
    for (int i = 0; i < [binary count]; i++) {
        out = [out stringByAppendingFormat:@"%@",[binary objectAtIndex:i]];
        if(i != [binary count]-1)
        {
            out = [out stringByAppendingFormat:@"\n"];
        }
    }
    [out writeToFile:@"/Users/Kapil_Garg/Desktop/AssemblerO-C/AssemblerO-C/output.txt" atomically:YES encoding:NSASCIIStringEncoding error:NULL];
}

-(void) cleanFile
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 0; i < [read count]; i++)
    {
        if(([[read objectAtIndex:i] rangeOfString:@"("].location == NSNotFound) && ([[read objectAtIndex:i] rangeOfString:@"/"].location == NSNotFound))
        {
            [temp addObject:[read objectAtIndex:i]];
        }
    }
    read = temp;
    [self cleanArray];
}

-(void) cleanArray
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i =0; i < [read count]; i++)
    {
        if(!(([[read objectAtIndex:i] length] == 1)) || ([[read objectAtIndex:i] length] == 0))
        {
            [temp addObject:[read objectAtIndex:i]];
        }
    }
    for (int i = 0; i < [temp count]; i++) {
        [temp replaceObjectAtIndex:i withObject:[[temp objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    read = temp;
}

-(NSMutableString*) binary: (NSInteger) theNumber;
{
    NSMutableString *str = [NSMutableString stringWithString: @""];
    for(NSInteger numberCopy = theNumber; numberCopy > 0; numberCopy >>= 1)
    {
        // Prepend "0" or "1", depending on the bit
        [str insertString:((numberCopy & 1) ? @"1" : @"0") atIndex:0];
    }
    return str;
}

-(NSString*) cInstruction:(NSInteger)index
{
    NSString *r = [read objectAtIndex:index];
    NSString *rc = [[NSString alloc] init];
    NSString *rd = [[NSString alloc] init];
    
    if ([r rangeOfString:@";"].location != NSNotFound) {
        return [self jumpInstruction: index];
    } else {
        NSMutableString *cInstr = [[NSMutableString alloc] init];
        NSMutableString *front = [NSMutableString stringWithFormat:@"111"]; 
        NSMutableString *computation = [[NSMutableString alloc] init];
        NSMutableString *destination = [[NSMutableString alloc] init];
        NSMutableString *jump = [NSMutableString stringWithFormat:@"000"]; 
        
        //computation
        rc = [[r substringFromIndex:[r rangeOfString:@"="].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];       
        computation = [comp objectForKey:rc];
        
        //destination
        rd = [r substringToIndex:[r rangeOfString:@"="].location];
        destination = [dest objectForKey:rd];
        
        //formatting the C-Instruction
        [cInstr appendFormat: @"%@", front];
        [cInstr appendFormat: @"%@", computation];
        [cInstr appendFormat: @"%@", destination];
        [cInstr appendFormat: @"%@", jump];
        return cInstr;
    }
}

-(NSString*) aInstruction:(NSInteger)index
{
    NSString *r = [NSString stringWithFormat:@"%@",[read objectAtIndex:index]];
    NSString *ra = [NSString stringWithFormat:@"%@", [r substringFromIndex:1]];
    
    NSMutableString *aInstr = [[NSMutableString alloc] init];
    NSMutableString *trailing = [NSMutableString stringWithFormat:@"0"];
    NSMutableString *a = [[NSMutableString alloc] init]; 
    
    @try {
        if([ra integerValue] ==0)
        {
            [NSException raise:@"Exception" format:@"Exception"];
        }
        [a appendFormat: @"%@", [self binary: [ra integerValue]]];
        int i = 14 - (int)[a length];
        while (i >= 0) {
            [trailing appendFormat:@"0"];
            i--;
        }
        [aInstr appendFormat:@"%@", trailing];
        [aInstr appendFormat:@"%@", a];
    }
    @catch (NSException *e) {
        if([vars objectForKey:ra])
        {
            [a appendFormat: @"%@", [self binary: [[vars objectForKey:ra] integerValue]]];
        }
        else if([variables containsObject:ra])
        {
            int index = (int)[variables indexOfObject:ra] + 16;
            [a appendFormat: @"%@", [self binary: index]];
        }
        else
        {
            [variables addObject:ra];
            int index = (int)[variables indexOfObject:ra] + 16;
            [a appendFormat: @"%@", [self binary: index]];
        }
        int i = 14 - (int)[a length];
        while (i >= 0) {
            [trailing appendFormat:@"0"];
            i--;
        }
        [aInstr appendFormat:@"%@", trailing];
        [aInstr appendFormat:@"%@", a];
        
    }
    @finally { 
        return aInstr; 
    }
}

-(NSString*) jumpInstruction:(NSInteger)index
{
    NSString *r = [read objectAtIndex:index];
    NSString *rc = [[NSString alloc] init];
    NSString *rj = [[NSString alloc] init];
    
    NSMutableString *jInstr = [[NSMutableString alloc] init];
    NSMutableString *front = [NSMutableString stringWithFormat:@"111"];
    NSMutableString *computation = [[NSMutableString alloc] init];
    NSMutableString *destination = [NSMutableString stringWithFormat:@"000"];
    NSMutableString *jump = [[NSMutableString alloc] init];
    
    //computation
    rc = [[r substringToIndex:[r rangeOfString:@";"].location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    computation = [comp objectForKey:rc];
    
    //jump
    rj = [[r substringFromIndex:[r rangeOfString:@";"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jump = [jmp objectForKey:rj];
    
    //formatting the J-Instruction
    [jInstr appendFormat: @"%@", front];
    [jInstr appendFormat: @"%@", computation];
    [jInstr appendFormat: @"%@", destination];
    [jInstr appendFormat: @"%@", jump];
    return jInstr;
}

-(void) convert
{
    int index = 0;
    for (NSString *s in read) {
        if ([s hasPrefix:@"@"]) {
            [binary addObject:[self aInstruction:index]];
        } else {
            [binary addObject:[self cInstruction:index]];
        }
        index++;
    }
}

@end
