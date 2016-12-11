
_test_mprotect:     file format elf32-i386


Disassembly of section .text:

00000000 <handler>:
#include "signal.h"

int *p;

void handler(int signum, siginfo_t info)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
	printf(1,"Handler called, error address is 0x%x error: 0x%x\n", info.addr,info.type);
   6:	8b 55 10             	mov    0x10(%ebp),%edx
   9:	8b 45 0c             	mov    0xc(%ebp),%eax
   c:	52                   	push   %edx
   d:	50                   	push   %eax
   e:	68 d8 08 00 00       	push   $0x8d8
  13:	6a 01                	push   $0x1
  15:	e8 05 05 00 00       	call   51f <printf>
  1a:	83 c4 10             	add    $0x10,%esp
	if(info.type == PROT_READ)
  1d:	8b 45 10             	mov    0x10(%ebp),%eax
  20:	83 f8 01             	cmp    $0x1,%eax
  23:	75 39                	jne    5e <handler+0x5e>
	{
		printf(1,"ERROR: Writing to a page with insufficient permission.\n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 0c 09 00 00       	push   $0x90c
  2d:	6a 01                	push   $0x1
  2f:	e8 eb 04 00 00       	call   51f <printf>
  34:	83 c4 10             	add    $0x10,%esp
		mprotect((void *) info.addr, sizeof(int), PROT_READ | PROT_WRITE);
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	6a 03                	push   $0x3
  3f:	6a 04                	push   $0x4
  41:	50                   	push   %eax
  42:	e8 f1 03 00 00       	call   438 <mprotect>
  47:	83 c4 10             	add    $0x10,%esp
		printf(1,"MPROTECT call finished!\n");
  4a:	83 ec 08             	sub    $0x8,%esp
  4d:	68 44 09 00 00       	push   $0x944
  52:	6a 01                	push   $0x1
  54:	e8 c6 04 00 00       	call   51f <printf>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	eb 12                	jmp    70 <handler+0x70>
	}
	else
	{
		printf(1, "ERROR: Didn't get proper exception, this should not happen.\n");
  5e:	83 ec 08             	sub    $0x8,%esp
  61:	68 60 09 00 00       	push   $0x960
  66:	6a 01                	push   $0x1
  68:	e8 b2 04 00 00       	call   51f <printf>
  6d:	83 c4 10             	add    $0x10,%esp
	}
	printf(1,"FINISHED IN HANDLER!\n");
  70:	83 ec 08             	sub    $0x8,%esp
  73:	68 9d 09 00 00       	push   $0x99d
  78:	6a 01                	push   $0x1
  7a:	e8 a0 04 00 00       	call   51f <printf>
  7f:	83 c4 10             	add    $0x10,%esp
}
  82:	90                   	nop
  83:	c9                   	leave  
  84:	c3                   	ret    

00000085 <main>:
int main(void)
{
  85:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  89:	83 e4 f0             	and    $0xfffffff0,%esp
  8c:	ff 71 fc             	pushl  -0x4(%ecx)
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	51                   	push   %ecx
  93:	83 ec 04             	sub    $0x4,%esp
	signal(SIGSEGV,(sighandler_t) handler);
  96:	83 ec 08             	sub    $0x8,%esp
  99:	68 00 00 00 00       	push   $0x0
  9e:	6a 02                	push   $0x2
  a0:	e8 aa 02 00 00       	call   34f <signal>
  a5:	83 c4 10             	add    $0x10,%esp
 	p = (int *) sbrk(1);
  a8:	83 ec 0c             	sub    $0xc,%esp
  ab:	6a 01                	push   $0x1
  ad:	e8 56 03 00 00       	call   408 <sbrk>
  b2:	83 c4 10             	add    $0x10,%esp
  b5:	a3 8c 0c 00 00       	mov    %eax,0xc8c
 	mprotect((void *)p, sizeof(int), PROT_READ);
  ba:	a1 8c 0c 00 00       	mov    0xc8c,%eax
  bf:	83 ec 04             	sub    $0x4,%esp
  c2:	6a 01                	push   $0x1
  c4:	6a 04                	push   $0x4
  c6:	50                   	push   %eax
  c7:	e8 6c 03 00 00       	call   438 <mprotect>
  cc:	83 c4 10             	add    $0x10,%esp
 	*p=100;
  cf:	a1 8c 0c 00 00       	mov    0xc8c,%eax
  d4:	c7 00 64 00 00 00    	movl   $0x64,(%eax)
 	printf(1, "COMPLETED: value is %d, expecting 100!\n", *p);
  da:	a1 8c 0c 00 00       	mov    0xc8c,%eax
  df:	8b 00                	mov    (%eax),%eax
  e1:	83 ec 04             	sub    $0x4,%esp
  e4:	50                   	push   %eax
  e5:	68 b4 09 00 00       	push   $0x9b4
  ea:	6a 01                	push   $0x1
  ec:	e8 2e 04 00 00       	call   51f <printf>
  f1:	83 c4 10             	add    $0x10,%esp

 	exit();
  f4:	e8 87 02 00 00       	call   380 <exit>

000000f9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  f9:	55                   	push   %ebp
  fa:	89 e5                	mov    %esp,%ebp
  fc:	57                   	push   %edi
  fd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
 101:	8b 55 10             	mov    0x10(%ebp),%edx
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	89 cb                	mov    %ecx,%ebx
 109:	89 df                	mov    %ebx,%edi
 10b:	89 d1                	mov    %edx,%ecx
 10d:	fc                   	cld    
 10e:	f3 aa                	rep stos %al,%es:(%edi)
 110:	89 ca                	mov    %ecx,%edx
 112:	89 fb                	mov    %edi,%ebx
 114:	89 5d 08             	mov    %ebx,0x8(%ebp)
 117:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 11a:	90                   	nop
 11b:	5b                   	pop    %ebx
 11c:	5f                   	pop    %edi
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    

0000011f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
 122:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 125:	8b 45 08             	mov    0x8(%ebp),%eax
 128:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 12b:	90                   	nop
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	8d 50 01             	lea    0x1(%eax),%edx
 132:	89 55 08             	mov    %edx,0x8(%ebp)
 135:	8b 55 0c             	mov    0xc(%ebp),%edx
 138:	8d 4a 01             	lea    0x1(%edx),%ecx
 13b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 13e:	0f b6 12             	movzbl (%edx),%edx
 141:	88 10                	mov    %dl,(%eax)
 143:	0f b6 00             	movzbl (%eax),%eax
 146:	84 c0                	test   %al,%al
 148:	75 e2                	jne    12c <strcpy+0xd>
    ;
  return os;
 14a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14d:	c9                   	leave  
 14e:	c3                   	ret    

0000014f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14f:	55                   	push   %ebp
 150:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 152:	eb 08                	jmp    15c <strcmp+0xd>
    p++, q++;
 154:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 158:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	0f b6 00             	movzbl (%eax),%eax
 162:	84 c0                	test   %al,%al
 164:	74 10                	je     176 <strcmp+0x27>
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	0f b6 10             	movzbl (%eax),%edx
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	38 c2                	cmp    %al,%dl
 174:	74 de                	je     154 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	0f b6 00             	movzbl (%eax),%eax
 17c:	0f b6 d0             	movzbl %al,%edx
 17f:	8b 45 0c             	mov    0xc(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	0f b6 c0             	movzbl %al,%eax
 188:	29 c2                	sub    %eax,%edx
 18a:	89 d0                	mov    %edx,%eax
}
 18c:	5d                   	pop    %ebp
 18d:	c3                   	ret    

0000018e <strlen>:

uint
strlen(char *s)
{
 18e:	55                   	push   %ebp
 18f:	89 e5                	mov    %esp,%ebp
 191:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 194:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 19b:	eb 04                	jmp    1a1 <strlen+0x13>
 19d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 d0                	add    %edx,%eax
 1a9:	0f b6 00             	movzbl (%eax),%eax
 1ac:	84 c0                	test   %al,%al
 1ae:	75 ed                	jne    19d <strlen+0xf>
    ;
  return n;
 1b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b3:	c9                   	leave  
 1b4:	c3                   	ret    

000001b5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1b8:	8b 45 10             	mov    0x10(%ebp),%eax
 1bb:	50                   	push   %eax
 1bc:	ff 75 0c             	pushl  0xc(%ebp)
 1bf:	ff 75 08             	pushl  0x8(%ebp)
 1c2:	e8 32 ff ff ff       	call   f9 <stosb>
 1c7:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1cd:	c9                   	leave  
 1ce:	c3                   	ret    

000001cf <strchr>:

char*
strchr(const char *s, char c)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	83 ec 04             	sub    $0x4,%esp
 1d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1db:	eb 14                	jmp    1f1 <strchr+0x22>
    if(*s == c)
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	0f b6 00             	movzbl (%eax),%eax
 1e3:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1e6:	75 05                	jne    1ed <strchr+0x1e>
      return (char*)s;
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	eb 13                	jmp    200 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ed:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	0f b6 00             	movzbl (%eax),%eax
 1f7:	84 c0                	test   %al,%al
 1f9:	75 e2                	jne    1dd <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 200:	c9                   	leave  
 201:	c3                   	ret    

00000202 <gets>:

char*
gets(char *buf, int max)
{
 202:	55                   	push   %ebp
 203:	89 e5                	mov    %esp,%ebp
 205:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 208:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 20f:	eb 42                	jmp    253 <gets+0x51>
    cc = read(0, &c, 1);
 211:	83 ec 04             	sub    $0x4,%esp
 214:	6a 01                	push   $0x1
 216:	8d 45 ef             	lea    -0x11(%ebp),%eax
 219:	50                   	push   %eax
 21a:	6a 00                	push   $0x0
 21c:	e8 77 01 00 00       	call   398 <read>
 221:	83 c4 10             	add    $0x10,%esp
 224:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 227:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 22b:	7e 33                	jle    260 <gets+0x5e>
      break;
    buf[i++] = c;
 22d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 230:	8d 50 01             	lea    0x1(%eax),%edx
 233:	89 55 f4             	mov    %edx,-0xc(%ebp)
 236:	89 c2                	mov    %eax,%edx
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	01 c2                	add    %eax,%edx
 23d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 241:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 243:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 247:	3c 0a                	cmp    $0xa,%al
 249:	74 16                	je     261 <gets+0x5f>
 24b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24f:	3c 0d                	cmp    $0xd,%al
 251:	74 0e                	je     261 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 253:	8b 45 f4             	mov    -0xc(%ebp),%eax
 256:	83 c0 01             	add    $0x1,%eax
 259:	3b 45 0c             	cmp    0xc(%ebp),%eax
 25c:	7c b3                	jl     211 <gets+0xf>
 25e:	eb 01                	jmp    261 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 260:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 261:	8b 55 f4             	mov    -0xc(%ebp),%edx
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	01 d0                	add    %edx,%eax
 269:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26f:	c9                   	leave  
 270:	c3                   	ret    

00000271 <stat>:

int
stat(char *n, struct stat *st)
{
 271:	55                   	push   %ebp
 272:	89 e5                	mov    %esp,%ebp
 274:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 277:	83 ec 08             	sub    $0x8,%esp
 27a:	6a 00                	push   $0x0
 27c:	ff 75 08             	pushl  0x8(%ebp)
 27f:	e8 3c 01 00 00       	call   3c0 <open>
 284:	83 c4 10             	add    $0x10,%esp
 287:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 28a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 28e:	79 07                	jns    297 <stat+0x26>
    return -1;
 290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 295:	eb 25                	jmp    2bc <stat+0x4b>
  r = fstat(fd, st);
 297:	83 ec 08             	sub    $0x8,%esp
 29a:	ff 75 0c             	pushl  0xc(%ebp)
 29d:	ff 75 f4             	pushl  -0xc(%ebp)
 2a0:	e8 33 01 00 00       	call   3d8 <fstat>
 2a5:	83 c4 10             	add    $0x10,%esp
 2a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2ab:	83 ec 0c             	sub    $0xc,%esp
 2ae:	ff 75 f4             	pushl  -0xc(%ebp)
 2b1:	e8 f2 00 00 00       	call   3a8 <close>
 2b6:	83 c4 10             	add    $0x10,%esp
  return r;
 2b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2bc:	c9                   	leave  
 2bd:	c3                   	ret    

000002be <atoi>:

int
atoi(const char *s)
{
 2be:	55                   	push   %ebp
 2bf:	89 e5                	mov    %esp,%ebp
 2c1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2cb:	eb 25                	jmp    2f2 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d0:	89 d0                	mov    %edx,%eax
 2d2:	c1 e0 02             	shl    $0x2,%eax
 2d5:	01 d0                	add    %edx,%eax
 2d7:	01 c0                	add    %eax,%eax
 2d9:	89 c1                	mov    %eax,%ecx
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	8d 50 01             	lea    0x1(%eax),%edx
 2e1:	89 55 08             	mov    %edx,0x8(%ebp)
 2e4:	0f b6 00             	movzbl (%eax),%eax
 2e7:	0f be c0             	movsbl %al,%eax
 2ea:	01 c8                	add    %ecx,%eax
 2ec:	83 e8 30             	sub    $0x30,%eax
 2ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	0f b6 00             	movzbl (%eax),%eax
 2f8:	3c 2f                	cmp    $0x2f,%al
 2fa:	7e 0a                	jle    306 <atoi+0x48>
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 00             	movzbl (%eax),%eax
 302:	3c 39                	cmp    $0x39,%al
 304:	7e c7                	jle    2cd <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 309:	c9                   	leave  
 30a:	c3                   	ret    

0000030b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 30b:	55                   	push   %ebp
 30c:	89 e5                	mov    %esp,%ebp
 30e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 317:	8b 45 0c             	mov    0xc(%ebp),%eax
 31a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 31d:	eb 17                	jmp    336 <memmove+0x2b>
    *dst++ = *src++;
 31f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 322:	8d 50 01             	lea    0x1(%eax),%edx
 325:	89 55 fc             	mov    %edx,-0x4(%ebp)
 328:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32b:	8d 4a 01             	lea    0x1(%edx),%ecx
 32e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 331:	0f b6 12             	movzbl (%edx),%edx
 334:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 336:	8b 45 10             	mov    0x10(%ebp),%eax
 339:	8d 50 ff             	lea    -0x1(%eax),%edx
 33c:	89 55 10             	mov    %edx,0x10(%ebp)
 33f:	85 c0                	test   %eax,%eax
 341:	7f dc                	jg     31f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 343:	8b 45 08             	mov    0x8(%ebp),%eax
}
 346:	c9                   	leave  
 347:	c3                   	ret    

00000348 <restorer>:
 348:	83 c4 0c             	add    $0xc,%esp
 34b:	5a                   	pop    %edx
 34c:	59                   	pop    %ecx
 34d:	58                   	pop    %eax
 34e:	c3                   	ret    

0000034f <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 34f:	55                   	push   %ebp
 350:	89 e5                	mov    %esp,%ebp
 352:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 355:	83 ec 0c             	sub    $0xc,%esp
 358:	68 48 03 00 00       	push   $0x348
 35d:	e8 ce 00 00 00       	call   430 <signal_restorer>
 362:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 365:	83 ec 08             	sub    $0x8,%esp
 368:	ff 75 0c             	pushl  0xc(%ebp)
 36b:	ff 75 08             	pushl  0x8(%ebp)
 36e:	e8 b5 00 00 00       	call   428 <signal_register>
 373:	83 c4 10             	add    $0x10,%esp
}
 376:	c9                   	leave  
 377:	c3                   	ret    

00000378 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 378:	b8 01 00 00 00       	mov    $0x1,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <exit>:
SYSCALL(exit)
 380:	b8 02 00 00 00       	mov    $0x2,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <wait>:
SYSCALL(wait)
 388:	b8 03 00 00 00       	mov    $0x3,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <pipe>:
SYSCALL(pipe)
 390:	b8 04 00 00 00       	mov    $0x4,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <read>:
SYSCALL(read)
 398:	b8 05 00 00 00       	mov    $0x5,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <write>:
SYSCALL(write)
 3a0:	b8 10 00 00 00       	mov    $0x10,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <close>:
SYSCALL(close)
 3a8:	b8 15 00 00 00       	mov    $0x15,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <kill>:
SYSCALL(kill)
 3b0:	b8 06 00 00 00       	mov    $0x6,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <exec>:
SYSCALL(exec)
 3b8:	b8 07 00 00 00       	mov    $0x7,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <open>:
SYSCALL(open)
 3c0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <mknod>:
SYSCALL(mknod)
 3c8:	b8 11 00 00 00       	mov    $0x11,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <unlink>:
SYSCALL(unlink)
 3d0:	b8 12 00 00 00       	mov    $0x12,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <fstat>:
SYSCALL(fstat)
 3d8:	b8 08 00 00 00       	mov    $0x8,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <link>:
SYSCALL(link)
 3e0:	b8 13 00 00 00       	mov    $0x13,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <mkdir>:
SYSCALL(mkdir)
 3e8:	b8 14 00 00 00       	mov    $0x14,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <chdir>:
SYSCALL(chdir)
 3f0:	b8 09 00 00 00       	mov    $0x9,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <dup>:
SYSCALL(dup)
 3f8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <getpid>:
SYSCALL(getpid)
 400:	b8 0b 00 00 00       	mov    $0xb,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <sbrk>:
SYSCALL(sbrk)
 408:	b8 0c 00 00 00       	mov    $0xc,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <sleep>:
SYSCALL(sleep)
 410:	b8 0d 00 00 00       	mov    $0xd,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <uptime>:
SYSCALL(uptime)
 418:	b8 0e 00 00 00       	mov    $0xe,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <halt>:
SYSCALL(halt)
 420:	b8 16 00 00 00       	mov    $0x16,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <signal_register>:
SYSCALL(signal_register)
 428:	b8 17 00 00 00       	mov    $0x17,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <signal_restorer>:
SYSCALL(signal_restorer)
 430:	b8 18 00 00 00       	mov    $0x18,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <mprotect>:
SYSCALL(mprotect)
 438:	b8 19 00 00 00       	mov    $0x19,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <cowfork>:
SYSCALL(cowfork)
 440:	b8 1a 00 00 00       	mov    $0x1a,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 448:	55                   	push   %ebp
 449:	89 e5                	mov    %esp,%ebp
 44b:	83 ec 18             	sub    $0x18,%esp
 44e:	8b 45 0c             	mov    0xc(%ebp),%eax
 451:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 454:	83 ec 04             	sub    $0x4,%esp
 457:	6a 01                	push   $0x1
 459:	8d 45 f4             	lea    -0xc(%ebp),%eax
 45c:	50                   	push   %eax
 45d:	ff 75 08             	pushl  0x8(%ebp)
 460:	e8 3b ff ff ff       	call   3a0 <write>
 465:	83 c4 10             	add    $0x10,%esp
}
 468:	90                   	nop
 469:	c9                   	leave  
 46a:	c3                   	ret    

0000046b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46b:	55                   	push   %ebp
 46c:	89 e5                	mov    %esp,%ebp
 46e:	53                   	push   %ebx
 46f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 479:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 47d:	74 17                	je     496 <printint+0x2b>
 47f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 483:	79 11                	jns    496 <printint+0x2b>
    neg = 1;
 485:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 48c:	8b 45 0c             	mov    0xc(%ebp),%eax
 48f:	f7 d8                	neg    %eax
 491:	89 45 ec             	mov    %eax,-0x14(%ebp)
 494:	eb 06                	jmp    49c <printint+0x31>
  } else {
    x = xx;
 496:	8b 45 0c             	mov    0xc(%ebp),%eax
 499:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 49c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4a6:	8d 41 01             	lea    0x1(%ecx),%eax
 4a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b2:	ba 00 00 00 00       	mov    $0x0,%edx
 4b7:	f7 f3                	div    %ebx
 4b9:	89 d0                	mov    %edx,%eax
 4bb:	0f b6 80 6c 0c 00 00 	movzbl 0xc6c(%eax),%eax
 4c2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4cc:	ba 00 00 00 00       	mov    $0x0,%edx
 4d1:	f7 f3                	div    %ebx
 4d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4da:	75 c7                	jne    4a3 <printint+0x38>
  if(neg)
 4dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e0:	74 2d                	je     50f <printint+0xa4>
    buf[i++] = '-';
 4e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e5:	8d 50 01             	lea    0x1(%eax),%edx
 4e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4eb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4f0:	eb 1d                	jmp    50f <printint+0xa4>
    putc(fd, buf[i]);
 4f2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f8:	01 d0                	add    %edx,%eax
 4fa:	0f b6 00             	movzbl (%eax),%eax
 4fd:	0f be c0             	movsbl %al,%eax
 500:	83 ec 08             	sub    $0x8,%esp
 503:	50                   	push   %eax
 504:	ff 75 08             	pushl  0x8(%ebp)
 507:	e8 3c ff ff ff       	call   448 <putc>
 50c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 50f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 517:	79 d9                	jns    4f2 <printint+0x87>
    putc(fd, buf[i]);
}
 519:	90                   	nop
 51a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 51d:	c9                   	leave  
 51e:	c3                   	ret    

0000051f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 51f:	55                   	push   %ebp
 520:	89 e5                	mov    %esp,%ebp
 522:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 525:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 52c:	8d 45 0c             	lea    0xc(%ebp),%eax
 52f:	83 c0 04             	add    $0x4,%eax
 532:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 53c:	e9 59 01 00 00       	jmp    69a <printf+0x17b>
    c = fmt[i] & 0xff;
 541:	8b 55 0c             	mov    0xc(%ebp),%edx
 544:	8b 45 f0             	mov    -0x10(%ebp),%eax
 547:	01 d0                	add    %edx,%eax
 549:	0f b6 00             	movzbl (%eax),%eax
 54c:	0f be c0             	movsbl %al,%eax
 54f:	25 ff 00 00 00       	and    $0xff,%eax
 554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 557:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55b:	75 2c                	jne    589 <printf+0x6a>
      if(c == '%'){
 55d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 561:	75 0c                	jne    56f <printf+0x50>
        state = '%';
 563:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56a:	e9 27 01 00 00       	jmp    696 <printf+0x177>
      } else {
        putc(fd, c);
 56f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	83 ec 08             	sub    $0x8,%esp
 578:	50                   	push   %eax
 579:	ff 75 08             	pushl  0x8(%ebp)
 57c:	e8 c7 fe ff ff       	call   448 <putc>
 581:	83 c4 10             	add    $0x10,%esp
 584:	e9 0d 01 00 00       	jmp    696 <printf+0x177>
      }
    } else if(state == '%'){
 589:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 58d:	0f 85 03 01 00 00    	jne    696 <printf+0x177>
      if(c == 'd'){
 593:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 597:	75 1e                	jne    5b7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	6a 01                	push   $0x1
 5a0:	6a 0a                	push   $0xa
 5a2:	50                   	push   %eax
 5a3:	ff 75 08             	pushl  0x8(%ebp)
 5a6:	e8 c0 fe ff ff       	call   46b <printint>
 5ab:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b2:	e9 d8 00 00 00       	jmp    68f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5b7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5bb:	74 06                	je     5c3 <printf+0xa4>
 5bd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c1:	75 1e                	jne    5e1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c6:	8b 00                	mov    (%eax),%eax
 5c8:	6a 00                	push   $0x0
 5ca:	6a 10                	push   $0x10
 5cc:	50                   	push   %eax
 5cd:	ff 75 08             	pushl  0x8(%ebp)
 5d0:	e8 96 fe ff ff       	call   46b <printint>
 5d5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5dc:	e9 ae 00 00 00       	jmp    68f <printf+0x170>
      } else if(c == 's'){
 5e1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e5:	75 43                	jne    62a <printf+0x10b>
        s = (char*)*ap;
 5e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f7:	75 25                	jne    61e <printf+0xff>
          s = "(null)";
 5f9:	c7 45 f4 dc 09 00 00 	movl   $0x9dc,-0xc(%ebp)
        while(*s != 0){
 600:	eb 1c                	jmp    61e <printf+0xff>
          putc(fd, *s);
 602:	8b 45 f4             	mov    -0xc(%ebp),%eax
 605:	0f b6 00             	movzbl (%eax),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	83 ec 08             	sub    $0x8,%esp
 60e:	50                   	push   %eax
 60f:	ff 75 08             	pushl  0x8(%ebp)
 612:	e8 31 fe ff ff       	call   448 <putc>
 617:	83 c4 10             	add    $0x10,%esp
          s++;
 61a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 61e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 621:	0f b6 00             	movzbl (%eax),%eax
 624:	84 c0                	test   %al,%al
 626:	75 da                	jne    602 <printf+0xe3>
 628:	eb 65                	jmp    68f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 62e:	75 1d                	jne    64d <printf+0x12e>
        putc(fd, *ap);
 630:	8b 45 e8             	mov    -0x18(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	0f be c0             	movsbl %al,%eax
 638:	83 ec 08             	sub    $0x8,%esp
 63b:	50                   	push   %eax
 63c:	ff 75 08             	pushl  0x8(%ebp)
 63f:	e8 04 fe ff ff       	call   448 <putc>
 644:	83 c4 10             	add    $0x10,%esp
        ap++;
 647:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64b:	eb 42                	jmp    68f <printf+0x170>
      } else if(c == '%'){
 64d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 651:	75 17                	jne    66a <printf+0x14b>
        putc(fd, c);
 653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 656:	0f be c0             	movsbl %al,%eax
 659:	83 ec 08             	sub    $0x8,%esp
 65c:	50                   	push   %eax
 65d:	ff 75 08             	pushl  0x8(%ebp)
 660:	e8 e3 fd ff ff       	call   448 <putc>
 665:	83 c4 10             	add    $0x10,%esp
 668:	eb 25                	jmp    68f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66a:	83 ec 08             	sub    $0x8,%esp
 66d:	6a 25                	push   $0x25
 66f:	ff 75 08             	pushl  0x8(%ebp)
 672:	e8 d1 fd ff ff       	call   448 <putc>
 677:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 67a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67d:	0f be c0             	movsbl %al,%eax
 680:	83 ec 08             	sub    $0x8,%esp
 683:	50                   	push   %eax
 684:	ff 75 08             	pushl  0x8(%ebp)
 687:	e8 bc fd ff ff       	call   448 <putc>
 68c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 68f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 696:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 69a:	8b 55 0c             	mov    0xc(%ebp),%edx
 69d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a0:	01 d0                	add    %edx,%eax
 6a2:	0f b6 00             	movzbl (%eax),%eax
 6a5:	84 c0                	test   %al,%al
 6a7:	0f 85 94 fe ff ff    	jne    541 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6ad:	90                   	nop
 6ae:	c9                   	leave  
 6af:	c3                   	ret    

000006b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	83 e8 08             	sub    $0x8,%eax
 6bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bf:	a1 88 0c 00 00       	mov    0xc88,%eax
 6c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c7:	eb 24                	jmp    6ed <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d1:	77 12                	ja     6e5 <free+0x35>
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d9:	77 24                	ja     6ff <free+0x4f>
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e3:	77 1a                	ja     6ff <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f3:	76 d4                	jbe    6c9 <free+0x19>
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fd:	76 ca                	jbe    6c9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	8b 40 04             	mov    0x4(%eax),%eax
 705:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	01 c2                	add    %eax,%edx
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	39 c2                	cmp    %eax,%edx
 718:	75 24                	jne    73e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	8b 50 04             	mov    0x4(%eax),%edx
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	8b 40 04             	mov    0x4(%eax),%eax
 728:	01 c2                	add    %eax,%edx
 72a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 00                	mov    (%eax),%eax
 735:	8b 10                	mov    (%eax),%edx
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	89 10                	mov    %edx,(%eax)
 73c:	eb 0a                	jmp    748 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 10                	mov    (%eax),%edx
 743:	8b 45 f8             	mov    -0x8(%ebp),%eax
 746:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 40 04             	mov    0x4(%eax),%eax
 74e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	01 d0                	add    %edx,%eax
 75a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75d:	75 20                	jne    77f <free+0xcf>
    p->s.size += bp->s.size;
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 50 04             	mov    0x4(%eax),%edx
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	8b 40 04             	mov    0x4(%eax),%eax
 76b:	01 c2                	add    %eax,%edx
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	8b 10                	mov    (%eax),%edx
 778:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77b:	89 10                	mov    %edx,(%eax)
 77d:	eb 08                	jmp    787 <free+0xd7>
  } else
    p->s.ptr = bp;
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 55 f8             	mov    -0x8(%ebp),%edx
 785:	89 10                	mov    %edx,(%eax)
  freep = p;
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	a3 88 0c 00 00       	mov    %eax,0xc88
}
 78f:	90                   	nop
 790:	c9                   	leave  
 791:	c3                   	ret    

00000792 <morecore>:

static Header*
morecore(uint nu)
{
 792:	55                   	push   %ebp
 793:	89 e5                	mov    %esp,%ebp
 795:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 798:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 79f:	77 07                	ja     7a8 <morecore+0x16>
    nu = 4096;
 7a1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a8:	8b 45 08             	mov    0x8(%ebp),%eax
 7ab:	c1 e0 03             	shl    $0x3,%eax
 7ae:	83 ec 0c             	sub    $0xc,%esp
 7b1:	50                   	push   %eax
 7b2:	e8 51 fc ff ff       	call   408 <sbrk>
 7b7:	83 c4 10             	add    $0x10,%esp
 7ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7bd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c1:	75 07                	jne    7ca <morecore+0x38>
    return 0;
 7c3:	b8 00 00 00 00       	mov    $0x0,%eax
 7c8:	eb 26                	jmp    7f0 <morecore+0x5e>
  hp = (Header*)p;
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d3:	8b 55 08             	mov    0x8(%ebp),%edx
 7d6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dc:	83 c0 08             	add    $0x8,%eax
 7df:	83 ec 0c             	sub    $0xc,%esp
 7e2:	50                   	push   %eax
 7e3:	e8 c8 fe ff ff       	call   6b0 <free>
 7e8:	83 c4 10             	add    $0x10,%esp
  return freep;
 7eb:	a1 88 0c 00 00       	mov    0xc88,%eax
}
 7f0:	c9                   	leave  
 7f1:	c3                   	ret    

000007f2 <malloc>:

void*
malloc(uint nbytes)
{
 7f2:	55                   	push   %ebp
 7f3:	89 e5                	mov    %esp,%ebp
 7f5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f8:	8b 45 08             	mov    0x8(%ebp),%eax
 7fb:	83 c0 07             	add    $0x7,%eax
 7fe:	c1 e8 03             	shr    $0x3,%eax
 801:	83 c0 01             	add    $0x1,%eax
 804:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 807:	a1 88 0c 00 00       	mov    0xc88,%eax
 80c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 813:	75 23                	jne    838 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 815:	c7 45 f0 80 0c 00 00 	movl   $0xc80,-0x10(%ebp)
 81c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81f:	a3 88 0c 00 00       	mov    %eax,0xc88
 824:	a1 88 0c 00 00       	mov    0xc88,%eax
 829:	a3 80 0c 00 00       	mov    %eax,0xc80
    base.s.size = 0;
 82e:	c7 05 84 0c 00 00 00 	movl   $0x0,0xc84
 835:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	8b 40 04             	mov    0x4(%eax),%eax
 846:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 849:	72 4d                	jb     898 <malloc+0xa6>
      if(p->s.size == nunits)
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 40 04             	mov    0x4(%eax),%eax
 851:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 854:	75 0c                	jne    862 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 856:	8b 45 f4             	mov    -0xc(%ebp),%eax
 859:	8b 10                	mov    (%eax),%edx
 85b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85e:	89 10                	mov    %edx,(%eax)
 860:	eb 26                	jmp    888 <malloc+0x96>
      else {
        p->s.size -= nunits;
 862:	8b 45 f4             	mov    -0xc(%ebp),%eax
 865:	8b 40 04             	mov    0x4(%eax),%eax
 868:	2b 45 ec             	sub    -0x14(%ebp),%eax
 86b:	89 c2                	mov    %eax,%edx
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 873:	8b 45 f4             	mov    -0xc(%ebp),%eax
 876:	8b 40 04             	mov    0x4(%eax),%eax
 879:	c1 e0 03             	shl    $0x3,%eax
 87c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	8b 55 ec             	mov    -0x14(%ebp),%edx
 885:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 888:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88b:	a3 88 0c 00 00       	mov    %eax,0xc88
      return (void*)(p + 1);
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	83 c0 08             	add    $0x8,%eax
 896:	eb 3b                	jmp    8d3 <malloc+0xe1>
    }
    if(p == freep)
 898:	a1 88 0c 00 00       	mov    0xc88,%eax
 89d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a0:	75 1e                	jne    8c0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8a2:	83 ec 0c             	sub    $0xc,%esp
 8a5:	ff 75 ec             	pushl  -0x14(%ebp)
 8a8:	e8 e5 fe ff ff       	call   792 <morecore>
 8ad:	83 c4 10             	add    $0x10,%esp
 8b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b7:	75 07                	jne    8c0 <malloc+0xce>
        return 0;
 8b9:	b8 00 00 00 00       	mov    $0x0,%eax
 8be:	eb 13                	jmp    8d3 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	8b 00                	mov    (%eax),%eax
 8cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8ce:	e9 6d ff ff ff       	jmp    840 <malloc+0x4e>
}
 8d3:	c9                   	leave  
 8d4:	c3                   	ret    
