module llvmvisitor;

import std.stdio;

import ast;
import tokenmodule;
import visitor;

import llvm.c;

class LLVMVisitor : Visitor {
	import std.conv : to;
	LLVMValueRef value;
    LLVMBuilderRef builder;

	this() {
    	this.builder = LLVMCreateBuilder();
	}

	override void accept(PrimaryExpr obj) {
		this.accept(cast(const(PrimaryExpr))obj);
	}

	override void accept(const(PrimaryExpr) obj) {
		final switch(obj.ruleSelection) {
			case PrimaryExprEnum.Float:
				writefln("Primary double");
				this.value = LLVMConstReal(
						LLVMDoubleType(), to!double(obj.value.value)
					);
				break;
			case PrimaryExprEnum.Integer:
				writefln("Primary integer");
				this.value = LLVMConstInt(LLVMIntType(64),
						to!long(obj.value.value), 1
					);
				break;
			case PrimaryExprEnum.Parenthesis:
				obj.expr.visit(this);
				break;
		}
	}
	
	alias accept = Visitor.accept;
}
