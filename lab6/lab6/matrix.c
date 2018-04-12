/***************  matrix.c *************************************
/* This file should not be altered *******************************/
#include<stdio.h>
#include<stdlib.h>

#define LOWER_CASE(x)	x | 0x20
#define MESSAGE_A	"\nEnter the first 3 dimensional vector below"
#define MESSAGE_B	"Enter the second 3 dimensional vector below"
#define CROSSM		"Cross Product:"
#define DOTM		"Dot Product:"

typedef struct {
	int x,y,z ;
} vector ;

typedef struct {
	long int x,y,z ;
} lvector ;

extern void crossP(vector* a, vector* b, lvector* result) ;
extern void dotP(vector*a, vector* b, long int* result) ;

void enter_vector(const char* message, vector* v) ; 
void display_lvector(const char* message, lvector* v) ;
void display_vector(const char* message, vector* v) ;

int main()
{
	vector a,b ;
	lvector result ;
	long int r ;
	char c ;
	
	do {
		enter_vector(MESSAGE_A, &a) ;
		enter_vector(MESSAGE_B, &b) ;
		
		crossP(&a, &b, &result) ;
		display_lvector(CROSSM, &result) ;
		
		dotP(&a, &b, &r) ;
		printf("%s : %ld\n", DOTM, r) ;
		
		printf("Continue y/n [n]: ") ;
		fflush(stdin) ;
		c = LOWER_CASE((char) getchar()) ;
		
	} while(c == 'y' ) ;
	
	return 0 ;
}

void enter_vector(const char* message, vector* v) {
	if(message) puts(message) ;
	printf("\nenter x component: ") ;
	fflush(stdin) ;
	scanf("%d", &(v->x)) ;
	printf("\nenter y component: ") ;
	fflush(stdin) ;
	scanf("%d", &(v->y)) ;
	printf("\nenter z component: ") ;
	fflush(stdin) ;
	scanf("%d", &(v->z)) ;
}

void display_lvector(const char* message, lvector* v) {
	if(message) puts(message) ;
	printf("x:%ld\ty:%ld\tz:%ld\t\n", v->x, v->y, v->z) ;
}
void display_vector(const char* message, vector* v) {
	if(message) puts(message) ;
	printf("x:%d\ty:%d\tz:%d\t\n", v->x, v->y, v->z) ;
}

