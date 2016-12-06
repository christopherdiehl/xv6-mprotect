typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;
typedef uint pde_t;

#define PROT_NONE       0x001 |~0x004| ~0x002	// Present, not in user space
#define PROT_READ       0x001 |0x004| ~0x002   // Read Only
#define PROT_WRITE      0x001 |0x004| 0x002   // Present + Write (Read/Write)
