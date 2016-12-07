
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
   d:	68 ac 08 00 00       	push   $0x8ac
  12:	6a 01                	push   $0x1
  14:	e8 dd 04 00 00       	call   4f6 <printf>
  19:	83 c4 10             	add    $0x10,%esp
	if(info.type == PROT_READ)
  1c:	8b 45 10             	mov    0x10(%ebp),%eax
  1f:	83 f8 fd             	cmp    $0xfffffffd,%eax
  22:	75 27                	jne    4b <handler+0x4b>
	{
		printf(1,"ERROR: Writing to a page with insufficient permission.\n");
  24:	83 ec 08             	sub    $0x8,%esp
  27:	68 d4 08 00 00       	push   $0x8d4
  2c:	6a 01                	push   $0x1
  2e:	e8 c3 04 00 00       	call   4f6 <printf>
  33:	83 c4 10             	add    $0x10,%esp
		mprotect((void *) info.addr, sizeof(int), PROT_READ | PROT_WRITE);
  36:	8b 45 0c             	mov    0xc(%ebp),%eax
  39:	83 ec 04             	sub    $0x4,%esp
  3c:	6a ff                	push   $0xffffffff
  3e:	6a 04                	push   $0x4
  40:	50                   	push   %eax
  41:	e8 d1 03 00 00       	call   417 <mprotect>
  46:	83 c4 10             	add    $0x10,%esp
	else
	{
		printf(1, "ERROR: Didn't get proper exception, this should not happen.\n");
		exit();
	}
}
  49:	eb 17                	jmp    62 <handler+0x62>
		printf(1,"ERROR: Writing to a page with insufficient permission.\n");
		mprotect((void *) info.addr, sizeof(int), PROT_READ | PROT_WRITE);
	}
	else
	{
		printf(1, "ERROR: Didn't get proper exception, this should not happen.\n");
  4b:	83 ec 08             	sub    $0x8,%esp
  4e:	68 0c 09 00 00       	push   $0x90c
  53:	6a 01                	push   $0x1
  55:	e8 9c 04 00 00       	call   4f6 <printf>
  5a:	83 c4 10             	add    $0x10,%esp
		exit();
  5d:	e8 fd 02 00 00       	call   35f <exit>
	}
}
  62:	c9                   	leave  
  63:	c3                   	ret    

00000064 <main>:
int main(void)
{
  64:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  68:	83 e4 f0             	and    $0xfffffff0,%esp
  6b:	ff 71 fc             	pushl  -0x4(%ecx)
  6e:	55                   	push   %ebp
  6f:	89 e5                	mov    %esp,%ebp
  71:	51                   	push   %ecx
  72:	83 ec 04             	sub    $0x4,%esp
	signal(SIGSEGV, handler);
  75:	83 ec 08             	sub    $0x8,%esp
  78:	68 00 00 00 00       	push   $0x0
  7d:	6a 02                	push   $0x2
  7f:	e8 aa 02 00 00       	call   32e <signal>
  84:	83 c4 10             	add    $0x10,%esp
 	p = (int *) sbrk(1);
  87:	83 ec 0c             	sub    $0xc,%esp
  8a:	6a 01                	push   $0x1
  8c:	e8 56 03 00 00       	call   3e7 <sbrk>
  91:	83 c4 10             	add    $0x10,%esp
  94:	a3 24 0c 00 00       	mov    %eax,0xc24
 	mprotect((void *)p, sizeof(int), PROT_READ);
  99:	a1 24 0c 00 00       	mov    0xc24,%eax
  9e:	83 ec 04             	sub    $0x4,%esp
  a1:	6a fd                	push   $0xfffffffd
  a3:	6a 04                	push   $0x4
  a5:	50                   	push   %eax
  a6:	e8 6c 03 00 00       	call   417 <mprotect>
  ab:	83 c4 10             	add    $0x10,%esp
 	*p=100;
  ae:	a1 24 0c 00 00       	mov    0xc24,%eax
  b3:	c7 00 64 00 00 00    	movl   $0x64,(%eax)
 	printf(1, "COMPLETED: value is %d, expecting 100!\n", *p);
  b9:	a1 24 0c 00 00       	mov    0xc24,%eax
  be:	8b 00                	mov    (%eax),%eax
  c0:	83 ec 04             	sub    $0x4,%esp
  c3:	50                   	push   %eax
  c4:	68 4c 09 00 00       	push   $0x94c
  c9:	6a 01                	push   $0x1
  cb:	e8 26 04 00 00       	call   4f6 <printf>
  d0:	83 c4 10             	add    $0x10,%esp

 	exit();
  d3:	e8 87 02 00 00       	call   35f <exit>

000000d8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	57                   	push   %edi
  dc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e0:	8b 55 10             	mov    0x10(%ebp),%edx
  e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  e6:	89 cb                	mov    %ecx,%ebx
  e8:	89 df                	mov    %ebx,%edi
  ea:	89 d1                	mov    %edx,%ecx
  ec:	fc                   	cld    
  ed:	f3 aa                	rep stos %al,%es:(%edi)
  ef:	89 ca                	mov    %ecx,%edx
  f1:	89 fb                	mov    %edi,%ebx
  f3:	89 5d 08             	mov    %ebx,0x8(%ebp)
  f6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  f9:	90                   	nop
  fa:	5b                   	pop    %ebx
  fb:	5f                   	pop    %edi
  fc:	5d                   	pop    %ebp
  fd:	c3                   	ret    

000000fe <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 10a:	90                   	nop
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	8d 50 01             	lea    0x1(%eax),%edx
 111:	89 55 08             	mov    %edx,0x8(%ebp)
 114:	8b 55 0c             	mov    0xc(%ebp),%edx
 117:	8d 4a 01             	lea    0x1(%edx),%ecx
 11a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 11d:	0f b6 12             	movzbl (%edx),%edx
 120:	88 10                	mov    %dl,(%eax)
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 e2                	jne    10b <strcpy+0xd>
    ;
  return os;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 131:	eb 08                	jmp    13b <strcmp+0xd>
    p++, q++;
 133:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 137:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	0f b6 00             	movzbl (%eax),%eax
 141:	84 c0                	test   %al,%al
 143:	74 10                	je     155 <strcmp+0x27>
 145:	8b 45 08             	mov    0x8(%ebp),%eax
 148:	0f b6 10             	movzbl (%eax),%edx
 14b:	8b 45 0c             	mov    0xc(%ebp),%eax
 14e:	0f b6 00             	movzbl (%eax),%eax
 151:	38 c2                	cmp    %al,%dl
 153:	74 de                	je     133 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	0f b6 d0             	movzbl %al,%edx
 15e:	8b 45 0c             	mov    0xc(%ebp),%eax
 161:	0f b6 00             	movzbl (%eax),%eax
 164:	0f b6 c0             	movzbl %al,%eax
 167:	29 c2                	sub    %eax,%edx
 169:	89 d0                	mov    %edx,%eax
}
 16b:	5d                   	pop    %ebp
 16c:	c3                   	ret    

0000016d <strlen>:

uint
strlen(char *s)
{
 16d:	55                   	push   %ebp
 16e:	89 e5                	mov    %esp,%ebp
 170:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 173:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 17a:	eb 04                	jmp    180 <strlen+0x13>
 17c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 180:	8b 55 fc             	mov    -0x4(%ebp),%edx
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	01 d0                	add    %edx,%eax
 188:	0f b6 00             	movzbl (%eax),%eax
 18b:	84 c0                	test   %al,%al
 18d:	75 ed                	jne    17c <strlen+0xf>
    ;
  return n;
 18f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 192:	c9                   	leave  
 193:	c3                   	ret    

00000194 <memset>:

void*
memset(void *dst, int c, uint n)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 197:	8b 45 10             	mov    0x10(%ebp),%eax
 19a:	50                   	push   %eax
 19b:	ff 75 0c             	pushl  0xc(%ebp)
 19e:	ff 75 08             	pushl  0x8(%ebp)
 1a1:	e8 32 ff ff ff       	call   d8 <stosb>
 1a6:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ac:	c9                   	leave  
 1ad:	c3                   	ret    

000001ae <strchr>:

char*
strchr(const char *s, char c)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	83 ec 04             	sub    $0x4,%esp
 1b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ba:	eb 14                	jmp    1d0 <strchr+0x22>
    if(*s == c)
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1c5:	75 05                	jne    1cc <strchr+0x1e>
      return (char*)s;
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	eb 13                	jmp    1df <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	84 c0                	test   %al,%al
 1d8:	75 e2                	jne    1bc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1da:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1df:	c9                   	leave  
 1e0:	c3                   	ret    

000001e1 <gets>:

char*
gets(char *buf, int max)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ee:	eb 42                	jmp    232 <gets+0x51>
    cc = read(0, &c, 1);
 1f0:	83 ec 04             	sub    $0x4,%esp
 1f3:	6a 01                	push   $0x1
 1f5:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f8:	50                   	push   %eax
 1f9:	6a 00                	push   $0x0
 1fb:	e8 77 01 00 00       	call   377 <read>
 200:	83 c4 10             	add    $0x10,%esp
 203:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 206:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 20a:	7e 33                	jle    23f <gets+0x5e>
      break;
    buf[i++] = c;
 20c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20f:	8d 50 01             	lea    0x1(%eax),%edx
 212:	89 55 f4             	mov    %edx,-0xc(%ebp)
 215:	89 c2                	mov    %eax,%edx
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	01 c2                	add    %eax,%edx
 21c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 220:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 222:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 226:	3c 0a                	cmp    $0xa,%al
 228:	74 16                	je     240 <gets+0x5f>
 22a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22e:	3c 0d                	cmp    $0xd,%al
 230:	74 0e                	je     240 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 232:	8b 45 f4             	mov    -0xc(%ebp),%eax
 235:	83 c0 01             	add    $0x1,%eax
 238:	3b 45 0c             	cmp    0xc(%ebp),%eax
 23b:	7c b3                	jl     1f0 <gets+0xf>
 23d:	eb 01                	jmp    240 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 23f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 240:	8b 55 f4             	mov    -0xc(%ebp),%edx
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	01 d0                	add    %edx,%eax
 248:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <stat>:

int
stat(char *n, struct stat *st)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 256:	83 ec 08             	sub    $0x8,%esp
 259:	6a 00                	push   $0x0
 25b:	ff 75 08             	pushl  0x8(%ebp)
 25e:	e8 3c 01 00 00       	call   39f <open>
 263:	83 c4 10             	add    $0x10,%esp
 266:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 269:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 26d:	79 07                	jns    276 <stat+0x26>
    return -1;
 26f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 274:	eb 25                	jmp    29b <stat+0x4b>
  r = fstat(fd, st);
 276:	83 ec 08             	sub    $0x8,%esp
 279:	ff 75 0c             	pushl  0xc(%ebp)
 27c:	ff 75 f4             	pushl  -0xc(%ebp)
 27f:	e8 33 01 00 00       	call   3b7 <fstat>
 284:	83 c4 10             	add    $0x10,%esp
 287:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 28a:	83 ec 0c             	sub    $0xc,%esp
 28d:	ff 75 f4             	pushl  -0xc(%ebp)
 290:	e8 f2 00 00 00       	call   387 <close>
 295:	83 c4 10             	add    $0x10,%esp
  return r;
 298:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 29b:	c9                   	leave  
 29c:	c3                   	ret    

0000029d <atoi>:

int
atoi(const char *s)
{
 29d:	55                   	push   %ebp
 29e:	89 e5                	mov    %esp,%ebp
 2a0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2aa:	eb 25                	jmp    2d1 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2af:	89 d0                	mov    %edx,%eax
 2b1:	c1 e0 02             	shl    $0x2,%eax
 2b4:	01 d0                	add    %edx,%eax
 2b6:	01 c0                	add    %eax,%eax
 2b8:	89 c1                	mov    %eax,%ecx
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	8d 50 01             	lea    0x1(%eax),%edx
 2c0:	89 55 08             	mov    %edx,0x8(%ebp)
 2c3:	0f b6 00             	movzbl (%eax),%eax
 2c6:	0f be c0             	movsbl %al,%eax
 2c9:	01 c8                	add    %ecx,%eax
 2cb:	83 e8 30             	sub    $0x30,%eax
 2ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	0f b6 00             	movzbl (%eax),%eax
 2d7:	3c 2f                	cmp    $0x2f,%al
 2d9:	7e 0a                	jle    2e5 <atoi+0x48>
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	0f b6 00             	movzbl (%eax),%eax
 2e1:	3c 39                	cmp    $0x39,%al
 2e3:	7e c7                	jle    2ac <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e8:	c9                   	leave  
 2e9:	c3                   	ret    

000002ea <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2fc:	eb 17                	jmp    315 <memmove+0x2b>
    *dst++ = *src++;
 2fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 301:	8d 50 01             	lea    0x1(%eax),%edx
 304:	89 55 fc             	mov    %edx,-0x4(%ebp)
 307:	8b 55 f8             	mov    -0x8(%ebp),%edx
 30a:	8d 4a 01             	lea    0x1(%edx),%ecx
 30d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 310:	0f b6 12             	movzbl (%edx),%edx
 313:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 315:	8b 45 10             	mov    0x10(%ebp),%eax
 318:	8d 50 ff             	lea    -0x1(%eax),%edx
 31b:	89 55 10             	mov    %edx,0x10(%ebp)
 31e:	85 c0                	test   %eax,%eax
 320:	7f dc                	jg     2fe <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 322:	8b 45 08             	mov    0x8(%ebp),%eax
}
 325:	c9                   	leave  
 326:	c3                   	ret    

00000327 <restorer>:
 327:	83 c4 0c             	add    $0xc,%esp
 32a:	5a                   	pop    %edx
 32b:	59                   	pop    %ecx
 32c:	58                   	pop    %eax
 32d:	c3                   	ret    

0000032e <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int,siginfo_t))
{
 32e:	55                   	push   %ebp
 32f:	89 e5                	mov    %esp,%ebp
 331:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 334:	83 ec 0c             	sub    $0xc,%esp
 337:	68 27 03 00 00       	push   $0x327
 33c:	e8 ce 00 00 00       	call   40f <signal_restorer>
 341:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 344:	83 ec 08             	sub    $0x8,%esp
 347:	ff 75 0c             	pushl  0xc(%ebp)
 34a:	ff 75 08             	pushl  0x8(%ebp)
 34d:	e8 b5 00 00 00       	call   407 <signal_register>
 352:	83 c4 10             	add    $0x10,%esp
}
 355:	c9                   	leave  
 356:	c3                   	ret    

00000357 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 357:	b8 01 00 00 00       	mov    $0x1,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <exit>:
SYSCALL(exit)
 35f:	b8 02 00 00 00       	mov    $0x2,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <wait>:
SYSCALL(wait)
 367:	b8 03 00 00 00       	mov    $0x3,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <pipe>:
SYSCALL(pipe)
 36f:	b8 04 00 00 00       	mov    $0x4,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <read>:
SYSCALL(read)
 377:	b8 05 00 00 00       	mov    $0x5,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <write>:
SYSCALL(write)
 37f:	b8 10 00 00 00       	mov    $0x10,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <close>:
SYSCALL(close)
 387:	b8 15 00 00 00       	mov    $0x15,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <kill>:
SYSCALL(kill)
 38f:	b8 06 00 00 00       	mov    $0x6,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <exec>:
SYSCALL(exec)
 397:	b8 07 00 00 00       	mov    $0x7,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <open>:
SYSCALL(open)
 39f:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <mknod>:
SYSCALL(mknod)
 3a7:	b8 11 00 00 00       	mov    $0x11,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <unlink>:
SYSCALL(unlink)
 3af:	b8 12 00 00 00       	mov    $0x12,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <fstat>:
SYSCALL(fstat)
 3b7:	b8 08 00 00 00       	mov    $0x8,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <link>:
SYSCALL(link)
 3bf:	b8 13 00 00 00       	mov    $0x13,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <mkdir>:
SYSCALL(mkdir)
 3c7:	b8 14 00 00 00       	mov    $0x14,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <chdir>:
SYSCALL(chdir)
 3cf:	b8 09 00 00 00       	mov    $0x9,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <dup>:
SYSCALL(dup)
 3d7:	b8 0a 00 00 00       	mov    $0xa,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <getpid>:
SYSCALL(getpid)
 3df:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <sbrk>:
SYSCALL(sbrk)
 3e7:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <sleep>:
SYSCALL(sleep)
 3ef:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <uptime>:
SYSCALL(uptime)
 3f7:	b8 0e 00 00 00       	mov    $0xe,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <halt>:
SYSCALL(halt)
 3ff:	b8 16 00 00 00       	mov    $0x16,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <signal_register>:
SYSCALL(signal_register)
 407:	b8 17 00 00 00       	mov    $0x17,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <signal_restorer>:
SYSCALL(signal_restorer)
 40f:	b8 18 00 00 00       	mov    $0x18,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <mprotect>:
SYSCALL(mprotect)
 417:	b8 19 00 00 00       	mov    $0x19,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 41f:	55                   	push   %ebp
 420:	89 e5                	mov    %esp,%ebp
 422:	83 ec 18             	sub    $0x18,%esp
 425:	8b 45 0c             	mov    0xc(%ebp),%eax
 428:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 42b:	83 ec 04             	sub    $0x4,%esp
 42e:	6a 01                	push   $0x1
 430:	8d 45 f4             	lea    -0xc(%ebp),%eax
 433:	50                   	push   %eax
 434:	ff 75 08             	pushl  0x8(%ebp)
 437:	e8 43 ff ff ff       	call   37f <write>
 43c:	83 c4 10             	add    $0x10,%esp
}
 43f:	90                   	nop
 440:	c9                   	leave  
 441:	c3                   	ret    

00000442 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 442:	55                   	push   %ebp
 443:	89 e5                	mov    %esp,%ebp
 445:	53                   	push   %ebx
 446:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 449:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 450:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 454:	74 17                	je     46d <printint+0x2b>
 456:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 45a:	79 11                	jns    46d <printint+0x2b>
    neg = 1;
 45c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 463:	8b 45 0c             	mov    0xc(%ebp),%eax
 466:	f7 d8                	neg    %eax
 468:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46b:	eb 06                	jmp    473 <printint+0x31>
  } else {
    x = xx;
 46d:	8b 45 0c             	mov    0xc(%ebp),%eax
 470:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 473:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 47a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 47d:	8d 41 01             	lea    0x1(%ecx),%eax
 480:	89 45 f4             	mov    %eax,-0xc(%ebp)
 483:	8b 5d 10             	mov    0x10(%ebp),%ebx
 486:	8b 45 ec             	mov    -0x14(%ebp),%eax
 489:	ba 00 00 00 00       	mov    $0x0,%edx
 48e:	f7 f3                	div    %ebx
 490:	89 d0                	mov    %edx,%eax
 492:	0f b6 80 04 0c 00 00 	movzbl 0xc04(%eax),%eax
 499:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 49d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a3:	ba 00 00 00 00       	mov    $0x0,%edx
 4a8:	f7 f3                	div    %ebx
 4aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b1:	75 c7                	jne    47a <printint+0x38>
  if(neg)
 4b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b7:	74 2d                	je     4e6 <printint+0xa4>
    buf[i++] = '-';
 4b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bc:	8d 50 01             	lea    0x1(%eax),%edx
 4bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4c7:	eb 1d                	jmp    4e6 <printint+0xa4>
    putc(fd, buf[i]);
 4c9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cf:	01 d0                	add    %edx,%eax
 4d1:	0f b6 00             	movzbl (%eax),%eax
 4d4:	0f be c0             	movsbl %al,%eax
 4d7:	83 ec 08             	sub    $0x8,%esp
 4da:	50                   	push   %eax
 4db:	ff 75 08             	pushl  0x8(%ebp)
 4de:	e8 3c ff ff ff       	call   41f <putc>
 4e3:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4e6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ee:	79 d9                	jns    4c9 <printint+0x87>
    putc(fd, buf[i]);
}
 4f0:	90                   	nop
 4f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4f4:	c9                   	leave  
 4f5:	c3                   	ret    

000004f6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f6:	55                   	push   %ebp
 4f7:	89 e5                	mov    %esp,%ebp
 4f9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 503:	8d 45 0c             	lea    0xc(%ebp),%eax
 506:	83 c0 04             	add    $0x4,%eax
 509:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 50c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 513:	e9 59 01 00 00       	jmp    671 <printf+0x17b>
    c = fmt[i] & 0xff;
 518:	8b 55 0c             	mov    0xc(%ebp),%edx
 51b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 51e:	01 d0                	add    %edx,%eax
 520:	0f b6 00             	movzbl (%eax),%eax
 523:	0f be c0             	movsbl %al,%eax
 526:	25 ff 00 00 00       	and    $0xff,%eax
 52b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 52e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 532:	75 2c                	jne    560 <printf+0x6a>
      if(c == '%'){
 534:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 538:	75 0c                	jne    546 <printf+0x50>
        state = '%';
 53a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 541:	e9 27 01 00 00       	jmp    66d <printf+0x177>
      } else {
        putc(fd, c);
 546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 549:	0f be c0             	movsbl %al,%eax
 54c:	83 ec 08             	sub    $0x8,%esp
 54f:	50                   	push   %eax
 550:	ff 75 08             	pushl  0x8(%ebp)
 553:	e8 c7 fe ff ff       	call   41f <putc>
 558:	83 c4 10             	add    $0x10,%esp
 55b:	e9 0d 01 00 00       	jmp    66d <printf+0x177>
      }
    } else if(state == '%'){
 560:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 564:	0f 85 03 01 00 00    	jne    66d <printf+0x177>
      if(c == 'd'){
 56a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 56e:	75 1e                	jne    58e <printf+0x98>
        printint(fd, *ap, 10, 1);
 570:	8b 45 e8             	mov    -0x18(%ebp),%eax
 573:	8b 00                	mov    (%eax),%eax
 575:	6a 01                	push   $0x1
 577:	6a 0a                	push   $0xa
 579:	50                   	push   %eax
 57a:	ff 75 08             	pushl  0x8(%ebp)
 57d:	e8 c0 fe ff ff       	call   442 <printint>
 582:	83 c4 10             	add    $0x10,%esp
        ap++;
 585:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 589:	e9 d8 00 00 00       	jmp    666 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 58e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 592:	74 06                	je     59a <printf+0xa4>
 594:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 598:	75 1e                	jne    5b8 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 59a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59d:	8b 00                	mov    (%eax),%eax
 59f:	6a 00                	push   $0x0
 5a1:	6a 10                	push   $0x10
 5a3:	50                   	push   %eax
 5a4:	ff 75 08             	pushl  0x8(%ebp)
 5a7:	e8 96 fe ff ff       	call   442 <printint>
 5ac:	83 c4 10             	add    $0x10,%esp
        ap++;
 5af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b3:	e9 ae 00 00 00       	jmp    666 <printf+0x170>
      } else if(c == 's'){
 5b8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5bc:	75 43                	jne    601 <printf+0x10b>
        s = (char*)*ap;
 5be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c1:	8b 00                	mov    (%eax),%eax
 5c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ce:	75 25                	jne    5f5 <printf+0xff>
          s = "(null)";
 5d0:	c7 45 f4 74 09 00 00 	movl   $0x974,-0xc(%ebp)
        while(*s != 0){
 5d7:	eb 1c                	jmp    5f5 <printf+0xff>
          putc(fd, *s);
 5d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5dc:	0f b6 00             	movzbl (%eax),%eax
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	83 ec 08             	sub    $0x8,%esp
 5e5:	50                   	push   %eax
 5e6:	ff 75 08             	pushl  0x8(%ebp)
 5e9:	e8 31 fe ff ff       	call   41f <putc>
 5ee:	83 c4 10             	add    $0x10,%esp
          s++;
 5f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f8:	0f b6 00             	movzbl (%eax),%eax
 5fb:	84 c0                	test   %al,%al
 5fd:	75 da                	jne    5d9 <printf+0xe3>
 5ff:	eb 65                	jmp    666 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 601:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 605:	75 1d                	jne    624 <printf+0x12e>
        putc(fd, *ap);
 607:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	0f be c0             	movsbl %al,%eax
 60f:	83 ec 08             	sub    $0x8,%esp
 612:	50                   	push   %eax
 613:	ff 75 08             	pushl  0x8(%ebp)
 616:	e8 04 fe ff ff       	call   41f <putc>
 61b:	83 c4 10             	add    $0x10,%esp
        ap++;
 61e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 622:	eb 42                	jmp    666 <printf+0x170>
      } else if(c == '%'){
 624:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 628:	75 17                	jne    641 <printf+0x14b>
        putc(fd, c);
 62a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62d:	0f be c0             	movsbl %al,%eax
 630:	83 ec 08             	sub    $0x8,%esp
 633:	50                   	push   %eax
 634:	ff 75 08             	pushl  0x8(%ebp)
 637:	e8 e3 fd ff ff       	call   41f <putc>
 63c:	83 c4 10             	add    $0x10,%esp
 63f:	eb 25                	jmp    666 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 641:	83 ec 08             	sub    $0x8,%esp
 644:	6a 25                	push   $0x25
 646:	ff 75 08             	pushl  0x8(%ebp)
 649:	e8 d1 fd ff ff       	call   41f <putc>
 64e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 651:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 654:	0f be c0             	movsbl %al,%eax
 657:	83 ec 08             	sub    $0x8,%esp
 65a:	50                   	push   %eax
 65b:	ff 75 08             	pushl  0x8(%ebp)
 65e:	e8 bc fd ff ff       	call   41f <putc>
 663:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 666:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 66d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 671:	8b 55 0c             	mov    0xc(%ebp),%edx
 674:	8b 45 f0             	mov    -0x10(%ebp),%eax
 677:	01 d0                	add    %edx,%eax
 679:	0f b6 00             	movzbl (%eax),%eax
 67c:	84 c0                	test   %al,%al
 67e:	0f 85 94 fe ff ff    	jne    518 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 684:	90                   	nop
 685:	c9                   	leave  
 686:	c3                   	ret    

00000687 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 687:	55                   	push   %ebp
 688:	89 e5                	mov    %esp,%ebp
 68a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68d:	8b 45 08             	mov    0x8(%ebp),%eax
 690:	83 e8 08             	sub    $0x8,%eax
 693:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 696:	a1 20 0c 00 00       	mov    0xc20,%eax
 69b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69e:	eb 24                	jmp    6c4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 00                	mov    (%eax),%eax
 6a5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a8:	77 12                	ja     6bc <free+0x35>
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b0:	77 24                	ja     6d6 <free+0x4f>
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ba:	77 1a                	ja     6d6 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 00                	mov    (%eax),%eax
 6c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ca:	76 d4                	jbe    6a0 <free+0x19>
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 00                	mov    (%eax),%eax
 6d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d4:	76 ca                	jbe    6a0 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	8b 40 04             	mov    0x4(%eax),%eax
 6dc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	01 c2                	add    %eax,%edx
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 00                	mov    (%eax),%eax
 6ed:	39 c2                	cmp    %eax,%edx
 6ef:	75 24                	jne    715 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	8b 50 04             	mov    0x4(%eax),%edx
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	8b 40 04             	mov    0x4(%eax),%eax
 6ff:	01 c2                	add    %eax,%edx
 701:	8b 45 f8             	mov    -0x8(%ebp),%eax
 704:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	8b 10                	mov    (%eax),%edx
 70e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 711:	89 10                	mov    %edx,(%eax)
 713:	eb 0a                	jmp    71f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 10                	mov    (%eax),%edx
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 40 04             	mov    0x4(%eax),%eax
 725:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	01 d0                	add    %edx,%eax
 731:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 734:	75 20                	jne    756 <free+0xcf>
    p->s.size += bp->s.size;
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 50 04             	mov    0x4(%eax),%edx
 73c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73f:	8b 40 04             	mov    0x4(%eax),%eax
 742:	01 c2                	add    %eax,%edx
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 74a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74d:	8b 10                	mov    (%eax),%edx
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	89 10                	mov    %edx,(%eax)
 754:	eb 08                	jmp    75e <free+0xd7>
  } else
    p->s.ptr = bp;
 756:	8b 45 fc             	mov    -0x4(%ebp),%eax
 759:	8b 55 f8             	mov    -0x8(%ebp),%edx
 75c:	89 10                	mov    %edx,(%eax)
  freep = p;
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	a3 20 0c 00 00       	mov    %eax,0xc20
}
 766:	90                   	nop
 767:	c9                   	leave  
 768:	c3                   	ret    

00000769 <morecore>:

static Header*
morecore(uint nu)
{
 769:	55                   	push   %ebp
 76a:	89 e5                	mov    %esp,%ebp
 76c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 76f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 776:	77 07                	ja     77f <morecore+0x16>
    nu = 4096;
 778:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 77f:	8b 45 08             	mov    0x8(%ebp),%eax
 782:	c1 e0 03             	shl    $0x3,%eax
 785:	83 ec 0c             	sub    $0xc,%esp
 788:	50                   	push   %eax
 789:	e8 59 fc ff ff       	call   3e7 <sbrk>
 78e:	83 c4 10             	add    $0x10,%esp
 791:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 794:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 798:	75 07                	jne    7a1 <morecore+0x38>
    return 0;
 79a:	b8 00 00 00 00       	mov    $0x0,%eax
 79f:	eb 26                	jmp    7c7 <morecore+0x5e>
  hp = (Header*)p;
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7aa:	8b 55 08             	mov    0x8(%ebp),%edx
 7ad:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b3:	83 c0 08             	add    $0x8,%eax
 7b6:	83 ec 0c             	sub    $0xc,%esp
 7b9:	50                   	push   %eax
 7ba:	e8 c8 fe ff ff       	call   687 <free>
 7bf:	83 c4 10             	add    $0x10,%esp
  return freep;
 7c2:	a1 20 0c 00 00       	mov    0xc20,%eax
}
 7c7:	c9                   	leave  
 7c8:	c3                   	ret    

000007c9 <malloc>:

void*
malloc(uint nbytes)
{
 7c9:	55                   	push   %ebp
 7ca:	89 e5                	mov    %esp,%ebp
 7cc:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7cf:	8b 45 08             	mov    0x8(%ebp),%eax
 7d2:	83 c0 07             	add    $0x7,%eax
 7d5:	c1 e8 03             	shr    $0x3,%eax
 7d8:	83 c0 01             	add    $0x1,%eax
 7db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7de:	a1 20 0c 00 00       	mov    0xc20,%eax
 7e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ea:	75 23                	jne    80f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7ec:	c7 45 f0 18 0c 00 00 	movl   $0xc18,-0x10(%ebp)
 7f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f6:	a3 20 0c 00 00       	mov    %eax,0xc20
 7fb:	a1 20 0c 00 00       	mov    0xc20,%eax
 800:	a3 18 0c 00 00       	mov    %eax,0xc18
    base.s.size = 0;
 805:	c7 05 1c 0c 00 00 00 	movl   $0x0,0xc1c
 80c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 812:	8b 00                	mov    (%eax),%eax
 814:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 820:	72 4d                	jb     86f <malloc+0xa6>
      if(p->s.size == nunits)
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	8b 40 04             	mov    0x4(%eax),%eax
 828:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 82b:	75 0c                	jne    839 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	8b 10                	mov    (%eax),%edx
 832:	8b 45 f0             	mov    -0x10(%ebp),%eax
 835:	89 10                	mov    %edx,(%eax)
 837:	eb 26                	jmp    85f <malloc+0x96>
      else {
        p->s.size -= nunits;
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	8b 40 04             	mov    0x4(%eax),%eax
 83f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 842:	89 c2                	mov    %eax,%edx
 844:	8b 45 f4             	mov    -0xc(%ebp),%eax
 847:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	8b 40 04             	mov    0x4(%eax),%eax
 850:	c1 e0 03             	shl    $0x3,%eax
 853:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 856:	8b 45 f4             	mov    -0xc(%ebp),%eax
 859:	8b 55 ec             	mov    -0x14(%ebp),%edx
 85c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 85f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 862:	a3 20 0c 00 00       	mov    %eax,0xc20
      return (void*)(p + 1);
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	83 c0 08             	add    $0x8,%eax
 86d:	eb 3b                	jmp    8aa <malloc+0xe1>
    }
    if(p == freep)
 86f:	a1 20 0c 00 00       	mov    0xc20,%eax
 874:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 877:	75 1e                	jne    897 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 879:	83 ec 0c             	sub    $0xc,%esp
 87c:	ff 75 ec             	pushl  -0x14(%ebp)
 87f:	e8 e5 fe ff ff       	call   769 <morecore>
 884:	83 c4 10             	add    $0x10,%esp
 887:	89 45 f4             	mov    %eax,-0xc(%ebp)
 88a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 88e:	75 07                	jne    897 <malloc+0xce>
        return 0;
 890:	b8 00 00 00 00       	mov    $0x0,%eax
 895:	eb 13                	jmp    8aa <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a0:	8b 00                	mov    (%eax),%eax
 8a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8a5:	e9 6d ff ff ff       	jmp    817 <malloc+0x4e>
}
 8aa:	c9                   	leave  
 8ab:	c3                   	ret    
