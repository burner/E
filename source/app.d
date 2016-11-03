import std.stdio;

import parser;
import lexer;
import ast;

void main() {
	string s = "hello[]";
	auto l = Lexer(s);
	auto p = new Parser(l);

	Expr e = p.parseExpr();
	assert(e.ruleSelection == ExprEnum.PostfixExpr);
}
