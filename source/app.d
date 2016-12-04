import std.stdio;

import parser;
import lexer;
import ast;
import llvmvisitor;
import llvm.c;
import std.string : fromStringz, toStringz;

import std.experimental.logger;

void main(string[] args) {
	LLVM.load();
	LLVMInitializeNativeTarget();
	LLVMInitializeNativeAsmPrinter();
	LLVMInitializeNativeAsmParser();
    LLVMModuleRef mod = LLVMModuleCreateWithName("ELANG".toStringz());
    LLVMExecutionEngineRef engine;
    
	string s = "1337";
	auto l = Lexer(s);
	auto p = new Parser(l);
	PrimaryExpr e = p.parsePrimaryExpr();

	auto llvmVis = new LLVMVisitor();
	writeln("eighteen");
	e.visit(llvmVis);
	writeln("nineteen");
	char* str = LLVMPrintValueToString(llvmVis.value);
	assert(str !is null);
	writeln("foo ", fromStringz(str));
}
