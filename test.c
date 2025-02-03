#include <stdio.h>
int main(void) {
	int SMALLER;
	int BIGGER;
	int TEMP;
	int TEMP1;
	scanf("%d", &BIGGER);
	scanf("%d", &SMALLER);
	if (BIGGER > SMALLER) {
		TEMP = SMALLER;
	TEMP1 = -2147483648;
	SMALLER = BIGGER;
	BIGGER = TEMP;
	}
	while(SMALLER > 0) {
		BIGGER = BIGGER - SMALLER;
	if (SMALLER > BIGGER) {
		TEMP = SMALLER;
	SMALLER = BIGGER;
	BIGGER = TEMP;
	}
	}
	printf("%d", BIGGER);
}
