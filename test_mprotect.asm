
_test_mprotect:     file format elf32-i386


Disassembly of section .text:

00000000 <handler>:
#include "user.h"
#include "signal.h"
int *p;

void handler(int signum, siginfo_t info)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
	printf(1,"Handler called, error address is 0x%x\n", info.addr);
   6:	8b 45 0c             	mov    0xc(%ebp),%eax
   9:	83 ec 04             	sub    $0x4,%esp
   c:	50                   	push   %eax
   d:	68 f0 08 00 00       	push   $0x8f0
  12:	6a 01                	push   $0x1
  14:	e8 21 05 00 00       	call   53a <printf>
  19:	83 c4 10             	add    $0x10,%esp
	printf(1,"error = 0x%x\n",info.type);
  1c:	8b 45 10             	mov    0x10(%ebp),%eax
  1f:	83 ec 04             	sub    $0x4,%esp
  22:	50                   	push   %eax
  23:	68 17 09 00 00       	push   $0x917
  28:	6a 01                	push   $0x1
  2a:	e8 0b 05 00 00       	call   53a <printf>
  2f:	83 c4 10             	add    $0x10,%esp
	if(info.type == PROT_NONE)
  32:	8b 45 10             	mov    0x10(%ebp),%eax
  35:	83 f8 01             	cmp    $0x1,%eax
  38:	75 27                	jne    61 <handler+0x61>
	{
		printf(1,"ERROR: Writing to a page with PROT_NONE permission.\n");
  3a:	83 ec 08             	sub    $0x8,%esp
  3d:	68 28 09 00 00       	push   $0x928
  42:	6a 01                	push   $0x1
  44:	e8 f1 04 00 00       	call   53a <printf>
  49:	83 c4 10             	add    $0x10,%esp
		mprotect((void *) info.addr, sizeof(int), PROT_READ | PROT_WRITE);
  4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  4f:	83 ec 04             	sub    $0x4,%esp
  52:	6a 07                	push   $0x7
  54:	6a 04                	push   $0x4
  56:	50                   	push   %eax
  57:	e8 ff 03 00 00       	call   45b <mprotect>
  5c:	83 c4 10             	add    $0x10,%esp
	else
	{
		printf(1, "ERROR: Didn't get proper exception, this should not happen.\n");
		exit();
	}
}
  5f:	eb 46                	jmp    a7 <handler+0xa7>
	printf(1,"error = 0x%x\n",info.type);
	if(info.type == PROT_NONE)
	{
		printf(1,"ERROR: Writing to a page with PROT_NONE permission.\n");
		mprotect((void *) info.addr, sizeof(int), PROT_READ | PROT_WRITE);
	} else if (info.type == PROT_READ)
  61:	8b 45 10             	mov    0x10(%ebp),%eax
  64:	83 f8 05             	cmp    $0x5,%eax
  67:	75 27                	jne    90 <handler+0x90>
	{
		printf(1,"ERROR: Writing to a page with PROT_READ permission.\n");
  69:	83 ec 08             	sub    $0x8,%esp
  6c:	68 60 09 00 00       	push   $0x960
  71:	6a 01                	push   $0x1
  73:	e8 c2 04 00 00       	call   53a <printf>
  78:	83 c4 10             	add    $0x10,%esp
		mprotect((void *) info.addr, sizeof(int), PROT_READ | PROT_WRITE);
  7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  7e:	83 ec 04             	sub    $0x4,%esp
  81:	6a 07                	push   $0x7
  83:	6a 04                	push   $0x4
  85:	50                   	push   %eax
  86:	e8 d0 03 00 00       	call   45b <mprotect>
  8b:	83 c4 10             	add    $0x10,%esp
	else
	{
		printf(1, "ERROR: Didn't get proper exception, this should not happen.\n");
		exit();
	}
}
  8e:	eb 17                	jmp    a7 <handler+0xa7>
		printf(1,"ERROR: Writing to a page with PROT_READ permission.\n");
		mprotect((void *) info.addr, sizeof(int), PROT_READ | PROT_WRITE);
	}
	else
	{
		printf(1, "ERROR: Didn't get proper exception, this should not happen.\n");
  90:	83 ec 08             	sub    $0x8,%esp
  93:	68 98 09 00 00       	push   $0x998
  98:	6a 01                	push   $0x1
  9a:	e8 9b 04 00 00       	call   53a <printf>
  9f:	83 c4 10             	add    $0x10,%esp
		exit();
  a2:	e8 fc 02 00 00       	call   3a3 <exit>
	}
}
  a7:	c9                   	leave  
  a8:	c3                   	ret    

000000a9 <main>:
int main(void)
{
  a9:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  ad:	83 e4 f0             	and    $0xfffffff0,%esp
  b0:	ff 71 fc             	pushl  -0x4(%ecx)
  b3:	55                   	push   %ebp
  b4:	89 e5                	mov    %esp,%ebp
  b6:	51                   	push   %ecx
  b7:	83 ec 14             	sub    $0x14,%esp
	signal(SIGSEGV, handler);
  ba:	83 ec 08             	sub    $0x8,%esp
  bd:	68 00 00 00 00       	push   $0x0
  c2:	6a 02                	push   $0x2
  c4:	e8 a9 02 00 00       	call   372 <signal>
  c9:	83 c4 10             	add    $0x10,%esp
 	p = (int *) sbrk(1);
  cc:	83 ec 0c             	sub    $0xc,%esp
  cf:	6a 01                	push   $0x1
  d1:	e8 55 03 00 00       	call   42b <sbrk>
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	a3 b4 0c 00 00       	mov    %eax,0xcb4
 	mprotect((void *)p, sizeof(int), PROT_NONE);
  de:	a1 b4 0c 00 00       	mov    0xcb4,%eax
  e3:	83 ec 04             	sub    $0x4,%esp
  e6:	6a 01                	push   $0x1
  e8:	6a 04                	push   $0x4
  ea:	50                   	push   %eax
  eb:	e8 6b 03 00 00       	call   45b <mprotect>
  f0:	83 c4 10             	add    $0x10,%esp
 	int k = *p;
  f3:	a1 b4 0c 00 00       	mov    0xcb4,%eax
  f8:	8b 00                	mov    (%eax),%eax
  fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
 	printf(1, "COMPLETED: value is %d, %d expecting 100!\n", *p,k);
  fd:	a1 b4 0c 00 00       	mov    0xcb4,%eax
 102:	8b 00                	mov    (%eax),%eax
 104:	ff 75 f4             	pushl  -0xc(%ebp)
 107:	50                   	push   %eax
 108:	68 d8 09 00 00       	push   $0x9d8
 10d:	6a 01                	push   $0x1
 10f:	e8 26 04 00 00       	call   53a <printf>
 114:	83 c4 10             	add    $0x10,%esp

 	exit();
 117:	e8 87 02 00 00       	call   3a3 <exit>

0000011c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	57                   	push   %edi
 120:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 121:	8b 4d 08             	mov    0x8(%ebp),%ecx
 124:	8b 55 10             	mov    0x10(%ebp),%edx
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	89 cb                	mov    %ecx,%ebx
 12c:	89 df                	mov    %ebx,%edi
 12e:	89 d1                	mov    %edx,%ecx
 130:	fc                   	cld    
 131:	f3 aa                	rep stos %al,%es:(%edi)
 133:	89 ca                	mov    %ecx,%edx
 135:	89 fb                	mov    %edi,%ebx
 137:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13d:	90                   	nop
 13e:	5b                   	pop    %ebx
 13f:	5f                   	pop    %edi
 140:	5d                   	pop    %ebp
 141:	c3                   	ret    

00000142 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14e:	90                   	nop
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	8d 50 01             	lea    0x1(%eax),%edx
 155:	89 55 08             	mov    %edx,0x8(%ebp)
 158:	8b 55 0c             	mov    0xc(%ebp),%edx
 15b:	8d 4a 01             	lea    0x1(%edx),%ecx
 15e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 161:	0f b6 12             	movzbl (%edx),%edx
 164:	88 10                	mov    %dl,(%eax)
 166:	0f b6 00             	movzbl (%eax),%eax
 169:	84 c0                	test   %al,%al
 16b:	75 e2                	jne    14f <strcpy+0xd>
    ;
  return os;
 16d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 170:	c9                   	leave  
 171:	c3                   	ret    

00000172 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 175:	eb 08                	jmp    17f <strcmp+0xd>
    p++, q++;
 177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	84 c0                	test   %al,%al
 187:	74 10                	je     199 <strcmp+0x27>
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	0f b6 10             	movzbl (%eax),%edx
 18f:	8b 45 0c             	mov    0xc(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	38 c2                	cmp    %al,%dl
 197:	74 de                	je     177 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	0f b6 d0             	movzbl %al,%edx
 1a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a5:	0f b6 00             	movzbl (%eax),%eax
 1a8:	0f b6 c0             	movzbl %al,%eax
 1ab:	29 c2                	sub    %eax,%edx
 1ad:	89 d0                	mov    %edx,%eax
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <strlen>:

uint
strlen(char *s)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1be:	eb 04                	jmp    1c4 <strlen+0x13>
 1c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	01 d0                	add    %edx,%eax
 1cc:	0f b6 00             	movzbl (%eax),%eax
 1cf:	84 c0                	test   %al,%al
 1d1:	75 ed                	jne    1c0 <strlen+0xf>
    ;
  return n;
 1d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d6:	c9                   	leave  
 1d7:	c3                   	ret    

000001d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1db:	8b 45 10             	mov    0x10(%ebp),%eax
 1de:	50                   	push   %eax
 1df:	ff 75 0c             	pushl  0xc(%ebp)
 1e2:	ff 75 08             	pushl  0x8(%ebp)
 1e5:	e8 32 ff ff ff       	call   11c <stosb>
 1ea:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f0:	c9                   	leave  
 1f1:	c3                   	ret    

000001f2 <strchr>:

char*
strchr(const char *s, char c)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	83 ec 04             	sub    $0x4,%esp
 1f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fe:	eb 14                	jmp    214 <strchr+0x22>
    if(*s == c)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	3a 45 fc             	cmp    -0x4(%ebp),%al
 209:	75 05                	jne    210 <strchr+0x1e>
      return (char*)s;
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	eb 13                	jmp    223 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 210:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	84 c0                	test   %al,%al
 21c:	75 e2                	jne    200 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 223:	c9                   	leave  
 224:	c3                   	ret    

00000225 <gets>:

char*
gets(char *buf, int max)
{
 225:	55                   	push   %ebp
 226:	89 e5                	mov    %esp,%ebp
 228:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 232:	eb 42                	jmp    276 <gets+0x51>
    cc = read(0, &c, 1);
 234:	83 ec 04             	sub    $0x4,%esp
 237:	6a 01                	push   $0x1
 239:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23c:	50                   	push   %eax
 23d:	6a 00                	push   $0x0
 23f:	e8 77 01 00 00       	call   3bb <read>
 244:	83 c4 10             	add    $0x10,%esp
 247:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24e:	7e 33                	jle    283 <gets+0x5e>
      break;
    buf[i++] = c;
 250:	8b 45 f4             	mov    -0xc(%ebp),%eax
 253:	8d 50 01             	lea    0x1(%eax),%edx
 256:	89 55 f4             	mov    %edx,-0xc(%ebp)
 259:	89 c2                	mov    %eax,%edx
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	01 c2                	add    %eax,%edx
 260:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 264:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 266:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26a:	3c 0a                	cmp    $0xa,%al
 26c:	74 16                	je     284 <gets+0x5f>
 26e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 272:	3c 0d                	cmp    $0xd,%al
 274:	74 0e                	je     284 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 276:	8b 45 f4             	mov    -0xc(%ebp),%eax
 279:	83 c0 01             	add    $0x1,%eax
 27c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 27f:	7c b3                	jl     234 <gets+0xf>
 281:	eb 01                	jmp    284 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 283:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 284:	8b 55 f4             	mov    -0xc(%ebp),%edx
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	01 d0                	add    %edx,%eax
 28c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 292:	c9                   	leave  
 293:	c3                   	ret    

00000294 <stat>:

int
stat(char *n, struct stat *st)
{
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29a:	83 ec 08             	sub    $0x8,%esp
 29d:	6a 00                	push   $0x0
 29f:	ff 75 08             	pushl  0x8(%ebp)
 2a2:	e8 3c 01 00 00       	call   3e3 <open>
 2a7:	83 c4 10             	add    $0x10,%esp
 2aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b1:	79 07                	jns    2ba <stat+0x26>
    return -1;
 2b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b8:	eb 25                	jmp    2df <stat+0x4b>
  r = fstat(fd, st);
 2ba:	83 ec 08             	sub    $0x8,%esp
 2bd:	ff 75 0c             	pushl  0xc(%ebp)
 2c0:	ff 75 f4             	pushl  -0xc(%ebp)
 2c3:	e8 33 01 00 00       	call   3fb <fstat>
 2c8:	83 c4 10             	add    $0x10,%esp
 2cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2ce:	83 ec 0c             	sub    $0xc,%esp
 2d1:	ff 75 f4             	pushl  -0xc(%ebp)
 2d4:	e8 f2 00 00 00       	call   3cb <close>
 2d9:	83 c4 10             	add    $0x10,%esp
  return r;
 2dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2df:	c9                   	leave  
 2e0:	c3                   	ret    

000002e1 <atoi>:

int
atoi(const char *s)
{
 2e1:	55                   	push   %ebp
 2e2:	89 e5                	mov    %esp,%ebp
 2e4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ee:	eb 25                	jmp    315 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f3:	89 d0                	mov    %edx,%eax
 2f5:	c1 e0 02             	shl    $0x2,%eax
 2f8:	01 d0                	add    %edx,%eax
 2fa:	01 c0                	add    %eax,%eax
 2fc:	89 c1                	mov    %eax,%ecx
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
 301:	8d 50 01             	lea    0x1(%eax),%edx
 304:	89 55 08             	mov    %edx,0x8(%ebp)
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	0f be c0             	movsbl %al,%eax
 30d:	01 c8                	add    %ecx,%eax
 30f:	83 e8 30             	sub    $0x30,%eax
 312:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	0f b6 00             	movzbl (%eax),%eax
 31b:	3c 2f                	cmp    $0x2f,%al
 31d:	7e 0a                	jle    329 <atoi+0x48>
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	0f b6 00             	movzbl (%eax),%eax
 325:	3c 39                	cmp    $0x39,%al
 327:	7e c7                	jle    2f0 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 329:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 32c:	c9                   	leave  
 32d:	c3                   	ret    

0000032e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 32e:	55                   	push   %ebp
 32f:	89 e5                	mov    %esp,%ebp
 331:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 33a:	8b 45 0c             	mov    0xc(%ebp),%eax
 33d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 340:	eb 17                	jmp    359 <memmove+0x2b>
    *dst++ = *src++;
 342:	8b 45 fc             	mov    -0x4(%ebp),%eax
 345:	8d 50 01             	lea    0x1(%eax),%edx
 348:	89 55 fc             	mov    %edx,-0x4(%ebp)
 34b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 34e:	8d 4a 01             	lea    0x1(%edx),%ecx
 351:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 354:	0f b6 12             	movzbl (%edx),%edx
 357:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 359:	8b 45 10             	mov    0x10(%ebp),%eax
 35c:	8d 50 ff             	lea    -0x1(%eax),%edx
 35f:	89 55 10             	mov    %edx,0x10(%ebp)
 362:	85 c0                	test   %eax,%eax
 364:	7f dc                	jg     342 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 366:	8b 45 08             	mov    0x8(%ebp),%eax
}
 369:	c9                   	leave  
 36a:	c3                   	ret    

0000036b <restorer>:
 36b:	83 c4 0c             	add    $0xc,%esp
 36e:	5a                   	pop    %edx
 36f:	59                   	pop    %ecx
 370:	58                   	pop    %eax
 371:	c3                   	ret    

00000372 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int,siginfo_t))
{
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 378:	83 ec 0c             	sub    $0xc,%esp
 37b:	68 6b 03 00 00       	push   $0x36b
 380:	e8 ce 00 00 00       	call   453 <signal_restorer>
 385:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 388:	83 ec 08             	sub    $0x8,%esp
 38b:	ff 75 0c             	pushl  0xc(%ebp)
 38e:	ff 75 08             	pushl  0x8(%ebp)
 391:	e8 b5 00 00 00       	call   44b <signal_register>
 396:	83 c4 10             	add    $0x10,%esp
}
 399:	c9                   	leave  
 39a:	c3                   	ret    

0000039b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39b:	b8 01 00 00 00       	mov    $0x1,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <exit>:
SYSCALL(exit)
 3a3:	b8 02 00 00 00       	mov    $0x2,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <wait>:
SYSCALL(wait)
 3ab:	b8 03 00 00 00       	mov    $0x3,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <pipe>:
SYSCALL(pipe)
 3b3:	b8 04 00 00 00       	mov    $0x4,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <read>:
SYSCALL(read)
 3bb:	b8 05 00 00 00       	mov    $0x5,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <write>:
SYSCALL(write)
 3c3:	b8 10 00 00 00       	mov    $0x10,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <close>:
SYSCALL(close)
 3cb:	b8 15 00 00 00       	mov    $0x15,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <kill>:
SYSCALL(kill)
 3d3:	b8 06 00 00 00       	mov    $0x6,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <exec>:
SYSCALL(exec)
 3db:	b8 07 00 00 00       	mov    $0x7,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <open>:
SYSCALL(open)
 3e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <mknod>:
SYSCALL(mknod)
 3eb:	b8 11 00 00 00       	mov    $0x11,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <unlink>:
SYSCALL(unlink)
 3f3:	b8 12 00 00 00       	mov    $0x12,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <fstat>:
SYSCALL(fstat)
 3fb:	b8 08 00 00 00       	mov    $0x8,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <link>:
SYSCALL(link)
 403:	b8 13 00 00 00       	mov    $0x13,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <mkdir>:
SYSCALL(mkdir)
 40b:	b8 14 00 00 00       	mov    $0x14,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <chdir>:
SYSCALL(chdir)
 413:	b8 09 00 00 00       	mov    $0x9,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <dup>:
SYSCALL(dup)
 41b:	b8 0a 00 00 00       	mov    $0xa,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <getpid>:
SYSCALL(getpid)
 423:	b8 0b 00 00 00       	mov    $0xb,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <sbrk>:
SYSCALL(sbrk)
 42b:	b8 0c 00 00 00       	mov    $0xc,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <sleep>:
SYSCALL(sleep)
 433:	b8 0d 00 00 00       	mov    $0xd,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <uptime>:
SYSCALL(uptime)
 43b:	b8 0e 00 00 00       	mov    $0xe,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <halt>:
SYSCALL(halt)
 443:	b8 16 00 00 00       	mov    $0x16,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <signal_register>:
SYSCALL(signal_register)
 44b:	b8 17 00 00 00       	mov    $0x17,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <signal_restorer>:
SYSCALL(signal_restorer)
 453:	b8 18 00 00 00       	mov    $0x18,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <mprotect>:
SYSCALL(mprotect)
 45b:	b8 19 00 00 00       	mov    $0x19,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 463:	55                   	push   %ebp
 464:	89 e5                	mov    %esp,%ebp
 466:	83 ec 18             	sub    $0x18,%esp
 469:	8b 45 0c             	mov    0xc(%ebp),%eax
 46c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 46f:	83 ec 04             	sub    $0x4,%esp
 472:	6a 01                	push   $0x1
 474:	8d 45 f4             	lea    -0xc(%ebp),%eax
 477:	50                   	push   %eax
 478:	ff 75 08             	pushl  0x8(%ebp)
 47b:	e8 43 ff ff ff       	call   3c3 <write>
 480:	83 c4 10             	add    $0x10,%esp
}
 483:	90                   	nop
 484:	c9                   	leave  
 485:	c3                   	ret    

00000486 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 486:	55                   	push   %ebp
 487:	89 e5                	mov    %esp,%ebp
 489:	53                   	push   %ebx
 48a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 48d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 494:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 498:	74 17                	je     4b1 <printint+0x2b>
 49a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 49e:	79 11                	jns    4b1 <printint+0x2b>
    neg = 1;
 4a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4aa:	f7 d8                	neg    %eax
 4ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4af:	eb 06                	jmp    4b7 <printint+0x31>
  } else {
    x = xx;
 4b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4c1:	8d 41 01             	lea    0x1(%ecx),%eax
 4c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4cd:	ba 00 00 00 00       	mov    $0x0,%edx
 4d2:	f7 f3                	div    %ebx
 4d4:	89 d0                	mov    %edx,%eax
 4d6:	0f b6 80 94 0c 00 00 	movzbl 0xc94(%eax),%eax
 4dd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e7:	ba 00 00 00 00       	mov    $0x0,%edx
 4ec:	f7 f3                	div    %ebx
 4ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f5:	75 c7                	jne    4be <printint+0x38>
  if(neg)
 4f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fb:	74 2d                	je     52a <printint+0xa4>
    buf[i++] = '-';
 4fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 500:	8d 50 01             	lea    0x1(%eax),%edx
 503:	89 55 f4             	mov    %edx,-0xc(%ebp)
 506:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 50b:	eb 1d                	jmp    52a <printint+0xa4>
    putc(fd, buf[i]);
 50d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 510:	8b 45 f4             	mov    -0xc(%ebp),%eax
 513:	01 d0                	add    %edx,%eax
 515:	0f b6 00             	movzbl (%eax),%eax
 518:	0f be c0             	movsbl %al,%eax
 51b:	83 ec 08             	sub    $0x8,%esp
 51e:	50                   	push   %eax
 51f:	ff 75 08             	pushl  0x8(%ebp)
 522:	e8 3c ff ff ff       	call   463 <putc>
 527:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 52a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 52e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 532:	79 d9                	jns    50d <printint+0x87>
    putc(fd, buf[i]);
}
 534:	90                   	nop
 535:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 538:	c9                   	leave  
 539:	c3                   	ret    

0000053a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 53a:	55                   	push   %ebp
 53b:	89 e5                	mov    %esp,%ebp
 53d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 540:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 547:	8d 45 0c             	lea    0xc(%ebp),%eax
 54a:	83 c0 04             	add    $0x4,%eax
 54d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 550:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 557:	e9 59 01 00 00       	jmp    6b5 <printf+0x17b>
    c = fmt[i] & 0xff;
 55c:	8b 55 0c             	mov    0xc(%ebp),%edx
 55f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 562:	01 d0                	add    %edx,%eax
 564:	0f b6 00             	movzbl (%eax),%eax
 567:	0f be c0             	movsbl %al,%eax
 56a:	25 ff 00 00 00       	and    $0xff,%eax
 56f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 572:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 576:	75 2c                	jne    5a4 <printf+0x6a>
      if(c == '%'){
 578:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57c:	75 0c                	jne    58a <printf+0x50>
        state = '%';
 57e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 585:	e9 27 01 00 00       	jmp    6b1 <printf+0x177>
      } else {
        putc(fd, c);
 58a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	83 ec 08             	sub    $0x8,%esp
 593:	50                   	push   %eax
 594:	ff 75 08             	pushl  0x8(%ebp)
 597:	e8 c7 fe ff ff       	call   463 <putc>
 59c:	83 c4 10             	add    $0x10,%esp
 59f:	e9 0d 01 00 00       	jmp    6b1 <printf+0x177>
      }
    } else if(state == '%'){
 5a4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5a8:	0f 85 03 01 00 00    	jne    6b1 <printf+0x177>
      if(c == 'd'){
 5ae:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b2:	75 1e                	jne    5d2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b7:	8b 00                	mov    (%eax),%eax
 5b9:	6a 01                	push   $0x1
 5bb:	6a 0a                	push   $0xa
 5bd:	50                   	push   %eax
 5be:	ff 75 08             	pushl  0x8(%ebp)
 5c1:	e8 c0 fe ff ff       	call   486 <printint>
 5c6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5cd:	e9 d8 00 00 00       	jmp    6aa <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5d2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5d6:	74 06                	je     5de <printf+0xa4>
 5d8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5dc:	75 1e                	jne    5fc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e1:	8b 00                	mov    (%eax),%eax
 5e3:	6a 00                	push   $0x0
 5e5:	6a 10                	push   $0x10
 5e7:	50                   	push   %eax
 5e8:	ff 75 08             	pushl  0x8(%ebp)
 5eb:	e8 96 fe ff ff       	call   486 <printint>
 5f0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f7:	e9 ae 00 00 00       	jmp    6aa <printf+0x170>
      } else if(c == 's'){
 5fc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 600:	75 43                	jne    645 <printf+0x10b>
        s = (char*)*ap;
 602:	8b 45 e8             	mov    -0x18(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 60a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 60e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 612:	75 25                	jne    639 <printf+0xff>
          s = "(null)";
 614:	c7 45 f4 03 0a 00 00 	movl   $0xa03,-0xc(%ebp)
        while(*s != 0){
 61b:	eb 1c                	jmp    639 <printf+0xff>
          putc(fd, *s);
 61d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 620:	0f b6 00             	movzbl (%eax),%eax
 623:	0f be c0             	movsbl %al,%eax
 626:	83 ec 08             	sub    $0x8,%esp
 629:	50                   	push   %eax
 62a:	ff 75 08             	pushl  0x8(%ebp)
 62d:	e8 31 fe ff ff       	call   463 <putc>
 632:	83 c4 10             	add    $0x10,%esp
          s++;
 635:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 639:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63c:	0f b6 00             	movzbl (%eax),%eax
 63f:	84 c0                	test   %al,%al
 641:	75 da                	jne    61d <printf+0xe3>
 643:	eb 65                	jmp    6aa <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 645:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 649:	75 1d                	jne    668 <printf+0x12e>
        putc(fd, *ap);
 64b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	0f be c0             	movsbl %al,%eax
 653:	83 ec 08             	sub    $0x8,%esp
 656:	50                   	push   %eax
 657:	ff 75 08             	pushl  0x8(%ebp)
 65a:	e8 04 fe ff ff       	call   463 <putc>
 65f:	83 c4 10             	add    $0x10,%esp
        ap++;
 662:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 666:	eb 42                	jmp    6aa <printf+0x170>
      } else if(c == '%'){
 668:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66c:	75 17                	jne    685 <printf+0x14b>
        putc(fd, c);
 66e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 671:	0f be c0             	movsbl %al,%eax
 674:	83 ec 08             	sub    $0x8,%esp
 677:	50                   	push   %eax
 678:	ff 75 08             	pushl  0x8(%ebp)
 67b:	e8 e3 fd ff ff       	call   463 <putc>
 680:	83 c4 10             	add    $0x10,%esp
 683:	eb 25                	jmp    6aa <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 685:	83 ec 08             	sub    $0x8,%esp
 688:	6a 25                	push   $0x25
 68a:	ff 75 08             	pushl  0x8(%ebp)
 68d:	e8 d1 fd ff ff       	call   463 <putc>
 692:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 698:	0f be c0             	movsbl %al,%eax
 69b:	83 ec 08             	sub    $0x8,%esp
 69e:	50                   	push   %eax
 69f:	ff 75 08             	pushl  0x8(%ebp)
 6a2:	e8 bc fd ff ff       	call   463 <putc>
 6a7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6b5:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bb:	01 d0                	add    %edx,%eax
 6bd:	0f b6 00             	movzbl (%eax),%eax
 6c0:	84 c0                	test   %al,%al
 6c2:	0f 85 94 fe ff ff    	jne    55c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c8:	90                   	nop
 6c9:	c9                   	leave  
 6ca:	c3                   	ret    

000006cb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cb:	55                   	push   %ebp
 6cc:	89 e5                	mov    %esp,%ebp
 6ce:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d1:	8b 45 08             	mov    0x8(%ebp),%eax
 6d4:	83 e8 08             	sub    $0x8,%eax
 6d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6da:	a1 b0 0c 00 00       	mov    0xcb0,%eax
 6df:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e2:	eb 24                	jmp    708 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ec:	77 12                	ja     700 <free+0x35>
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f4:	77 24                	ja     71a <free+0x4f>
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 00                	mov    (%eax),%eax
 6fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fe:	77 1a                	ja     71a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 00                	mov    (%eax),%eax
 705:	89 45 fc             	mov    %eax,-0x4(%ebp)
 708:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70e:	76 d4                	jbe    6e4 <free+0x19>
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 718:	76 ca                	jbe    6e4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	8b 40 04             	mov    0x4(%eax),%eax
 720:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	01 c2                	add    %eax,%edx
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	39 c2                	cmp    %eax,%edx
 733:	75 24                	jne    759 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 735:	8b 45 f8             	mov    -0x8(%ebp),%eax
 738:	8b 50 04             	mov    0x4(%eax),%edx
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 00                	mov    (%eax),%eax
 740:	8b 40 04             	mov    0x4(%eax),%eax
 743:	01 c2                	add    %eax,%edx
 745:	8b 45 f8             	mov    -0x8(%ebp),%eax
 748:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 00                	mov    (%eax),%eax
 750:	8b 10                	mov    (%eax),%edx
 752:	8b 45 f8             	mov    -0x8(%ebp),%eax
 755:	89 10                	mov    %edx,(%eax)
 757:	eb 0a                	jmp    763 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 10                	mov    (%eax),%edx
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	01 d0                	add    %edx,%eax
 775:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 778:	75 20                	jne    79a <free+0xcf>
    p->s.size += bp->s.size;
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	8b 50 04             	mov    0x4(%eax),%edx
 780:	8b 45 f8             	mov    -0x8(%ebp),%eax
 783:	8b 40 04             	mov    0x4(%eax),%eax
 786:	01 c2                	add    %eax,%edx
 788:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	8b 10                	mov    (%eax),%edx
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	89 10                	mov    %edx,(%eax)
 798:	eb 08                	jmp    7a2 <free+0xd7>
  } else
    p->s.ptr = bp;
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a0:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	a3 b0 0c 00 00       	mov    %eax,0xcb0
}
 7aa:	90                   	nop
 7ab:	c9                   	leave  
 7ac:	c3                   	ret    

000007ad <morecore>:

static Header*
morecore(uint nu)
{
 7ad:	55                   	push   %ebp
 7ae:	89 e5                	mov    %esp,%ebp
 7b0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ba:	77 07                	ja     7c3 <morecore+0x16>
    nu = 4096;
 7bc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c3:	8b 45 08             	mov    0x8(%ebp),%eax
 7c6:	c1 e0 03             	shl    $0x3,%eax
 7c9:	83 ec 0c             	sub    $0xc,%esp
 7cc:	50                   	push   %eax
 7cd:	e8 59 fc ff ff       	call   42b <sbrk>
 7d2:	83 c4 10             	add    $0x10,%esp
 7d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7dc:	75 07                	jne    7e5 <morecore+0x38>
    return 0;
 7de:	b8 00 00 00 00       	mov    $0x0,%eax
 7e3:	eb 26                	jmp    80b <morecore+0x5e>
  hp = (Header*)p;
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ee:	8b 55 08             	mov    0x8(%ebp),%edx
 7f1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	83 c0 08             	add    $0x8,%eax
 7fa:	83 ec 0c             	sub    $0xc,%esp
 7fd:	50                   	push   %eax
 7fe:	e8 c8 fe ff ff       	call   6cb <free>
 803:	83 c4 10             	add    $0x10,%esp
  return freep;
 806:	a1 b0 0c 00 00       	mov    0xcb0,%eax
}
 80b:	c9                   	leave  
 80c:	c3                   	ret    

0000080d <malloc>:

void*
malloc(uint nbytes)
{
 80d:	55                   	push   %ebp
 80e:	89 e5                	mov    %esp,%ebp
 810:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 813:	8b 45 08             	mov    0x8(%ebp),%eax
 816:	83 c0 07             	add    $0x7,%eax
 819:	c1 e8 03             	shr    $0x3,%eax
 81c:	83 c0 01             	add    $0x1,%eax
 81f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 822:	a1 b0 0c 00 00       	mov    0xcb0,%eax
 827:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82e:	75 23                	jne    853 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 830:	c7 45 f0 a8 0c 00 00 	movl   $0xca8,-0x10(%ebp)
 837:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83a:	a3 b0 0c 00 00       	mov    %eax,0xcb0
 83f:	a1 b0 0c 00 00       	mov    0xcb0,%eax
 844:	a3 a8 0c 00 00       	mov    %eax,0xca8
    base.s.size = 0;
 849:	c7 05 ac 0c 00 00 00 	movl   $0x0,0xcac
 850:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 853:	8b 45 f0             	mov    -0x10(%ebp),%eax
 856:	8b 00                	mov    (%eax),%eax
 858:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	8b 40 04             	mov    0x4(%eax),%eax
 861:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 864:	72 4d                	jb     8b3 <malloc+0xa6>
      if(p->s.size == nunits)
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	8b 40 04             	mov    0x4(%eax),%eax
 86c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86f:	75 0c                	jne    87d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	8b 10                	mov    (%eax),%edx
 876:	8b 45 f0             	mov    -0x10(%ebp),%eax
 879:	89 10                	mov    %edx,(%eax)
 87b:	eb 26                	jmp    8a3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	8b 40 04             	mov    0x4(%eax),%eax
 883:	2b 45 ec             	sub    -0x14(%ebp),%eax
 886:	89 c2                	mov    %eax,%edx
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 88e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 891:	8b 40 04             	mov    0x4(%eax),%eax
 894:	c1 e0 03             	shl    $0x3,%eax
 897:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8a0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a6:	a3 b0 0c 00 00       	mov    %eax,0xcb0
      return (void*)(p + 1);
 8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ae:	83 c0 08             	add    $0x8,%eax
 8b1:	eb 3b                	jmp    8ee <malloc+0xe1>
    }
    if(p == freep)
 8b3:	a1 b0 0c 00 00       	mov    0xcb0,%eax
 8b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8bb:	75 1e                	jne    8db <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8bd:	83 ec 0c             	sub    $0xc,%esp
 8c0:	ff 75 ec             	pushl  -0x14(%ebp)
 8c3:	e8 e5 fe ff ff       	call   7ad <morecore>
 8c8:	83 c4 10             	add    $0x10,%esp
 8cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d2:	75 07                	jne    8db <malloc+0xce>
        return 0;
 8d4:	b8 00 00 00 00       	mov    $0x0,%eax
 8d9:	eb 13                	jmp    8ee <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8de:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e4:	8b 00                	mov    (%eax),%eax
 8e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e9:	e9 6d ff ff ff       	jmp    85b <malloc+0x4e>
}
 8ee:	c9                   	leave  
 8ef:	c3                   	ret    
