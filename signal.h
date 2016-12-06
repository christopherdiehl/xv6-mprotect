#ifndef XV6_SIGNAL
#define XV6_SIGNAL

#define SIGKILL	0
#define SIGFPE	1
#define SIGSEV	2
typedef void (*sighandler_t)(int);
typedef struct siginfo_t_{
	uint addr; // Should be an address.
	uint type; // Should be a protection level
} siginfo_t;
#endif
