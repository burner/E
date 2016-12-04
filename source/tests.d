module tests;

import parser;
import lexer;
import ast;
import visitor;

unittest {
	for(int i = 0; i < 1000; ++i) {
	foreach(s; ["hello[]", "hello", "hello[][]", "hello.world"
		"hello[10].hello()[]", "hello[10].hello()[(13.37)]"
		"hello[10].hello()[][10]", "hello[10].hello().args[(13.37)][foo]"
			]) 
	{
		auto l = Lexer(s);
		auto p = new Parser(l);
		auto e = p.parseExpr();
		auto v = new Visitor();
		v.accept(e);
	}
	}
}

unittest {
	string s = "{ var i64 a; var f64 b = 13.37; var c = 1337; foo(); }";
	auto l = Lexer(s);
	auto p = new Parser(l);
	auto e = p.parseBlockStmt();
	auto v = new Visitor();
	v.accept(e);
}

unittest {
	string s = "fun i64 name() { var i64 a; var f64 b = 13.37; var c = 1337; foo(); }";
	auto l = Lexer(s);
	auto p = new Parser(l);
	auto e = p.parseFun();
	auto v = new Visitor();
	v.accept(e);
}
