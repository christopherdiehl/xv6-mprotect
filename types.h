typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;
typedef uint pde_t;

#define PROT_NONE       0	// Present, not in user space
#define PROT_READ       1   // Read Only + User
#define PROT_WRITE      2  // Present + Write + USer (Read/Write)
