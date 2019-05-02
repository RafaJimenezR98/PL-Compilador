NAME = interpreter

FUENTE = sintactico
LEXICO = lexico
EJECUTABLE = ipe

# Compiler
CC = gcc

# Directives for the compiler
# -c: the output is an object file, the linking stage is not done.
# -g: debug
# -Wall: all warnings
# -ansi: standard language
# -02: optimization level
CFLAGS = -c -g -Wall -ansi
YFLAGS = -d         # Generar el fichero $(FUENTE).tab.h

# Directive for flex's library
LFLAGS = -lm -lfl

# Objects
OBJECTS= $(NAME).o
OBJECTS-PARSER = parser/*.o
OBJECTS-TABLE = table/*.o  # New in example 7
OBJECTS-CODE = code/*.o  # New in example 16

INCLUDES = ./parser/interpreter.tab.h \
			./code/code.h

#######################################################
# Predefined macros
#
# $@: name of the target
# $^: all the dependencies
# $<: first dependency
#
#######################################################


#Modified in examples 7, 16
$(NAME).exe :  parser-dir table-dir code-dir $(OBJECTS)
	@echo "Generating " $(NAME).exe
	@$(CC) $(OBJECTS) $(OBJECTS-PARSER)  $(OBJECTS-TABLE)  $(OBJECTS-CODE) \
	$(LFLAGS) -o $(NAME).exe


# Main program
$(NAME).o: $(NAME).cpp parser-dir code-dir $(INCLUDES)
	@echo "Compiling " $<
	@$(CC) $(CFLAGS) $<
	@echo

#
parser-dir:
	@echo "Accessing directory parser"
	@echo
	@make -C parser/
	@echo

# New in example 7
table-dir:
	@echo "Accessing directory table"
	@echo
	@make -C table/
	@echo

# New in example 16
code-dir:
	@echo "Accessing directory code"
	@echo
	@make -C code/
	@echo

#######################################################
$(NAME).output:
	@echo "Generating: " $@
	@make -C parser/ $@
	@echo
#######################################################
	# Generate the documentation
	doc: Doxyfile
		doxygen

#######################################################
	# Auxiliary files and html directory are deleted
	# Modified in examples 7, 16
	clean:
		@echo "Deleting html"
		@rm -rf html
		@echo "Deleting " $(OBJECTS)  $(NAME).exe  *~
		@rm -f $(OBJECTS) $(NAME).exe *~
		@echo
		@make -C parser/ clean
		@echo
		@make -C table/ clean
		@echo
		@make -C code/ clean
		@echo
