#include "types.h"
#include "user.h"
#include "signal.h"
int *p;

void handler(int signum, siginfo_t info)
{
	printf(1,"Handler called, error address is 0x%x\n", info.addr);

}
int main(void)
{
	signal(SIGSEGV, handler);
 	p = (int *) sbrk(1);
 	*p=100;
 	printf(1, "COMPLETED: value is %d, expecting 100!\n", *p);

 	exit();
}
