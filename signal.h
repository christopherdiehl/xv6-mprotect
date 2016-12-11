#ifndef XV6_SIGNAL
#define XV6_SIGNAL

#define SIGKILL	0
#define SIGFPE	1
#define SIGSEGV	2
typedef struct siginfo_t_{
	uint addr; // Should be an address.
	uint type; // Should be a protection level
} siginfo_t;
typedef void (*sighandler_t)(int);

#endif
