#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

typedef struct structure_asm_test 	{
	int value;
	bool truth;
	char first_initial;
	char FamilyName[32];
} structure_asm;

int main() {
	structure_asm d;
	d.value=42;
	d.truth=true;
	d.first_initial='G';
	d.FamilyName[0]='L';
	d.FamilyName[1]='a';
	structure_asm s;
	s.value=43;
	d.truth=false;
	if (d.truth != s.truth) {
		s.truth = d.truth;
	}
	return 0;
}
