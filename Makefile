all:
	../Darser/darser -i e.yaml -a source/ast.d \
		-p source/parser.d \
		-v source/visitor.d \
		-e source/exception.d
