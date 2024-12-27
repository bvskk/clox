#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "common.h"
#include "chunk.h"
#include "debug.h"
#include "vm.h"

#ifdef _WIN32
#include "dirent.h"
#else
#include <dirent.h>
#endif

static void repl() {
	char line[1024];
	for (;;) {
		printf("> ");
		
		if (!fgets(line, sizeof(line), stdin)) {
			printf("\n");
			break;
		}
		
		interpret(line);
	}
}

static char *readFile(const char *path) {
	FILE *file = fopen(path, "rb");
	if (file == NULL) {
		fprintf(stderr, "Could not open the file \"%s\".\n", path);
		exit(74);
	}
	
	fseek(file, 0L, SEEK_END);
	size_t fileSize = ftell(file);
	rewind(file);
	
	char *buffer = (char *)malloc(fileSize + 1);
	if (buffer == NULL) {
		fprintf(stderr, "Not enough memory to read \"%s\".\n", path);
		exit(74);
	}
	
	size_t bytesRead = fread(buffer, sizeof(char), fileSize, file);
	if (bytesRead < fileSize) {
		fprintf(stderr, "Could not read file \"%s\".\n", path);
		exit(74);
	}
	
	buffer[bytesRead] = '\0';
	
	fclose(file);
	return buffer;
}

static void runFile(const char *path) {
	char *source = readFile(path);
	InterpretResult result = interpret(source);
	free(source);
	
	if (result == INTERPRET_COMPILE_ERROR) exit(65);
	if (result == INTERPRET_RUNTIME_ERROR) exit(70);
}

static void runBenchmarks(const char *dirname) {
	DIR *d;
	struct dirent *dir;
	d = opendir(dirname);
	if (d == NULL) {
		fprintf(stderr, "Could not open the directory \"%s\".\n", dirname);
		exit(74);
	}
	char buffer[1024];
	while ((dir = readdir(d)) != NULL) {
		if (dir->d_type == DT_REG) {
			size_t len = strlen(dir->d_name);
			if (len < 5 || strcmp(dir->d_name + (len - 4), ".lox")) continue;
			printf("Running %s\n", dir->d_name);
			if (len > 1023) {
				fprintf(stderr, "Do not support path longer than 1023 bytes and no unicode atm");
				exit(74);
			}
			snprintf(buffer, 1024, "%s\\%s", dirname, dir->d_name);
			runFile(buffer);
			printf("\n\n\n\n");
		}
	}
}

int main(int argc, const char* argv[]) {
	initVM();
	
	if (argc == 1) {
		repl();
	} else if (argc == 2) {
		if (!strcmp(argv[1], "-bench")) {
			fprintf(stderr, "Usage:\nclox [path]\nclox -bench [benchmarkdirname]\n");
			exit(64);
		}
		runFile(argv[1]);
	} else if (argc == 3) {
		if (strcmp(argv[1], "-bench")) {
			fprintf(stderr, "Usage:\nclox [path]\nclox -bench [benchmarkdirname]\n");
		}
		runBenchmarks(argv[2]);
	} else {
		fprintf(stderr, "Usage:\nclox [path]\nclox -bench [benchmarkdirname]\n");
		exit(64);
	}
	
	freeVM();
	return 0;
}
