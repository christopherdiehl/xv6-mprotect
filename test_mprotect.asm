
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
   e:	68 30 09 00 00       	push   $0x930
  13:	6a 01                	push   $0x1
  15:	e8 5f 05 00 00       	call   579 <printf>
  1a:	83 c4 10             	add    $0x10,%esp
	if(info.type == PROT_READ)
  1d:	8b 45 10             	mov    0x10(%ebp),%eax
  20:	83 f8 01             	cmp    $0x1,%eax
  23:	75 39                	jne    5e <handler+0x5e>
	{
		printf(1,"ERROR: Writing to a page with insufficient permission.\n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 64 09 00 00       	push   $0x964
  2d:	6a 01                	push   $0x1
  2f:	e8 45 05 00 00       	call   579 <printf>
  34:	83 c4 10             	add    $0x10,%esp
		mprotect((void *) info.addr, sizeof(int), PROT_READ | PROT_WRITE);
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	6a 03                	push   $0x3
  3f:	6a 04                	push   $0x4
  41:	50                   	push   %eax
  42:	e8 4b 04 00 00       	call   492 <mprotect>
  47:	83 c4 10             	add    $0x10,%esp
		printf(1,"MPROTECT call finished!\n");
  4a:	83 ec 08             	sub    $0x8,%esp
  4d:	68 9c 09 00 00       	push   $0x99c
  52:	6a 01                	push   $0x1
  54:	e8 20 05 00 00       	call   579 <printf>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	eb 40                	jmp    9e <handler+0x9e>
	} else 	if(info.type == PROT_NONE)
  5e:	8b 45 10             	mov    0x10(%ebp),%eax
  61:	85 c0                	test   %eax,%eax
  63:	75 27                	jne    8c <handler+0x8c>
	{
		printf(1,"ERROR: READING!.\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 b5 09 00 00       	push   $0x9b5
  6d:	6a 01                	push   $0x1
  6f:	e8 05 05 00 00       	call   579 <printf>
  74:	83 c4 10             	add    $0x10,%esp
		mprotect((void *) info.addr, sizeof(int), PROT_READ);
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	83 ec 04             	sub    $0x4,%esp
  7d:	6a 01                	push   $0x1
  7f:	6a 04                	push   $0x4
  81:	50                   	push   %eax
  82:	e8 0b 04 00 00       	call   492 <mprotect>
  87:	83 c4 10             	add    $0x10,%esp
  8a:	eb 12                	jmp    9e <handler+0x9e>
	}
	else
	{
		printf(1, "ERROR: Didn't get proper exception, this should not happen.\n");
  8c:	83 ec 08             	sub    $0x8,%esp
  8f:	68 c8 09 00 00       	push   $0x9c8
  94:	6a 01                	push   $0x1
  96:	e8 de 04 00 00       	call   579 <printf>
  9b:	83 c4 10             	add    $0x10,%esp
	}
	printf(1,"FINISHED IN HANDLER!\n");
  9e:	83 ec 08             	sub    $0x8,%esp
  a1:	68 05 0a 00 00       	push   $0xa05
  a6:	6a 01                	push   $0x1
  a8:	e8 cc 04 00 00       	call   579 <printf>
  ad:	83 c4 10             	add    $0x10,%esp
}
  b0:	90                   	nop
  b1:	c9                   	leave  
  b2:	c3                   	ret    

000000b3 <main>:
int main(void)
{
  b3:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  b7:	83 e4 f0             	and    $0xfffffff0,%esp
  ba:	ff 71 fc             	pushl  -0x4(%ecx)
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	51                   	push   %ecx
  c1:	83 ec 04             	sub    $0x4,%esp
	signal(SIGSEGV,(sighandler_t) handler);
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	68 00 00 00 00       	push   $0x0
  cc:	6a 0e                	push   $0xe
  ce:	e8 d6 02 00 00       	call   3a9 <signal>
  d3:	83 c4 10             	add    $0x10,%esp
 	p = (int *) sbrk(1);
  d6:	83 ec 0c             	sub    $0xc,%esp
  d9:	6a 01                	push   $0x1
  db:	e8 82 03 00 00       	call   462 <sbrk>
  e0:	83 c4 10             	add    $0x10,%esp
  e3:	a3 20 0d 00 00       	mov    %eax,0xd20
 	mprotect((void *)p, sizeof(int), PROT_READ);
  e8:	a1 20 0d 00 00       	mov    0xd20,%eax
  ed:	83 ec 04             	sub    $0x4,%esp
  f0:	6a 01                	push   $0x1
  f2:	6a 04                	push   $0x4
  f4:	50                   	push   %eax
  f5:	e8 98 03 00 00       	call   492 <mprotect>
  fa:	83 c4 10             	add    $0x10,%esp
	printf(1,"About to read. should get memfault\n");
  fd:	83 ec 08             	sub    $0x8,%esp
 100:	68 1c 0a 00 00       	push   $0xa1c
 105:	6a 01                	push   $0x1
 107:	e8 6d 04 00 00       	call   579 <printf>
 10c:	83 c4 10             	add    $0x10,%esp
	*p =100;
 10f:	a1 20 0d 00 00       	mov    0xd20,%eax
 114:	c7 00 64 00 00 00    	movl   $0x64,(%eax)
  printf(1,"p = %d",*p);
 11a:	a1 20 0d 00 00       	mov    0xd20,%eax
 11f:	8b 00                	mov    (%eax),%eax
 121:	83 ec 04             	sub    $0x4,%esp
 124:	50                   	push   %eax
 125:	68 40 0a 00 00       	push   $0xa40
 12a:	6a 01                	push   $0x1
 12c:	e8 48 04 00 00       	call   579 <printf>
 131:	83 c4 10             	add    $0x10,%esp
 	printf(1, "COMPLETED: value is %d, expecting 100!\n", *p);
 134:	a1 20 0d 00 00       	mov    0xd20,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 04             	sub    $0x4,%esp
 13e:	50                   	push   %eax
 13f:	68 48 0a 00 00       	push   $0xa48
 144:	6a 01                	push   $0x1
 146:	e8 2e 04 00 00       	call   579 <printf>
 14b:	83 c4 10             	add    $0x10,%esp

 	exit();
 14e:	e8 87 02 00 00       	call   3da <exit>

00000153 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 153:	55                   	push   %ebp
 154:	89 e5                	mov    %esp,%ebp
 156:	57                   	push   %edi
 157:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 158:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15b:	8b 55 10             	mov    0x10(%ebp),%edx
 15e:	8b 45 0c             	mov    0xc(%ebp),%eax
 161:	89 cb                	mov    %ecx,%ebx
 163:	89 df                	mov    %ebx,%edi
 165:	89 d1                	mov    %edx,%ecx
 167:	fc                   	cld    
 168:	f3 aa                	rep stos %al,%es:(%edi)
 16a:	89 ca                	mov    %ecx,%edx
 16c:	89 fb                	mov    %edi,%ebx
 16e:	89 5d 08             	mov    %ebx,0x8(%ebp)
 171:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 174:	90                   	nop
 175:	5b                   	pop    %ebx
 176:	5f                   	pop    %edi
 177:	5d                   	pop    %ebp
 178:	c3                   	ret    

00000179 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
 17c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 185:	90                   	nop
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	8d 50 01             	lea    0x1(%eax),%edx
 18c:	89 55 08             	mov    %edx,0x8(%ebp)
 18f:	8b 55 0c             	mov    0xc(%ebp),%edx
 192:	8d 4a 01             	lea    0x1(%edx),%ecx
 195:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 198:	0f b6 12             	movzbl (%edx),%edx
 19b:	88 10                	mov    %dl,(%eax)
 19d:	0f b6 00             	movzbl (%eax),%eax
 1a0:	84 c0                	test   %al,%al
 1a2:	75 e2                	jne    186 <strcpy+0xd>
    ;
  return os;
 1a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a7:	c9                   	leave  
 1a8:	c3                   	ret    

000001a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ac:	eb 08                	jmp    1b6 <strcmp+0xd>
    p++, q++;
 1ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	0f b6 00             	movzbl (%eax),%eax
 1bc:	84 c0                	test   %al,%al
 1be:	74 10                	je     1d0 <strcmp+0x27>
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	0f b6 10             	movzbl (%eax),%edx
 1c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c9:	0f b6 00             	movzbl (%eax),%eax
 1cc:	38 c2                	cmp    %al,%dl
 1ce:	74 de                	je     1ae <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	0f b6 d0             	movzbl %al,%edx
 1d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dc:	0f b6 00             	movzbl (%eax),%eax
 1df:	0f b6 c0             	movzbl %al,%eax
 1e2:	29 c2                	sub    %eax,%edx
 1e4:	89 d0                	mov    %edx,%eax
}
 1e6:	5d                   	pop    %ebp
 1e7:	c3                   	ret    

000001e8 <strlen>:

uint
strlen(char *s)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1f5:	eb 04                	jmp    1fb <strlen+0x13>
 1f7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	01 d0                	add    %edx,%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	84 c0                	test   %al,%al
 208:	75 ed                	jne    1f7 <strlen+0xf>
    ;
  return n;
 20a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20d:	c9                   	leave  
 20e:	c3                   	ret    

0000020f <memset>:

void*
memset(void *dst, int c, uint n)
{
 20f:	55                   	push   %ebp
 210:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 212:	8b 45 10             	mov    0x10(%ebp),%eax
 215:	50                   	push   %eax
 216:	ff 75 0c             	pushl  0xc(%ebp)
 219:	ff 75 08             	pushl  0x8(%ebp)
 21c:	e8 32 ff ff ff       	call   153 <stosb>
 221:	83 c4 0c             	add    $0xc,%esp
  return dst;
 224:	8b 45 08             	mov    0x8(%ebp),%eax
}
 227:	c9                   	leave  
 228:	c3                   	ret    

00000229 <strchr>:

char*
strchr(const char *s, char c)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	83 ec 04             	sub    $0x4,%esp
 22f:	8b 45 0c             	mov    0xc(%ebp),%eax
 232:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 235:	eb 14                	jmp    24b <strchr+0x22>
    if(*s == c)
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 240:	75 05                	jne    247 <strchr+0x1e>
      return (char*)s;
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	eb 13                	jmp    25a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 247:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	0f b6 00             	movzbl (%eax),%eax
 251:	84 c0                	test   %al,%al
 253:	75 e2                	jne    237 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 255:	b8 00 00 00 00       	mov    $0x0,%eax
}
 25a:	c9                   	leave  
 25b:	c3                   	ret    

0000025c <gets>:

char*
gets(char *buf, int max)
{
 25c:	55                   	push   %ebp
 25d:	89 e5                	mov    %esp,%ebp
 25f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 262:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 269:	eb 42                	jmp    2ad <gets+0x51>
    cc = read(0, &c, 1);
 26b:	83 ec 04             	sub    $0x4,%esp
 26e:	6a 01                	push   $0x1
 270:	8d 45 ef             	lea    -0x11(%ebp),%eax
 273:	50                   	push   %eax
 274:	6a 00                	push   $0x0
 276:	e8 77 01 00 00       	call   3f2 <read>
 27b:	83 c4 10             	add    $0x10,%esp
 27e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 281:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 285:	7e 33                	jle    2ba <gets+0x5e>
      break;
    buf[i++] = c;
 287:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28a:	8d 50 01             	lea    0x1(%eax),%edx
 28d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 290:	89 c2                	mov    %eax,%edx
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	01 c2                	add    %eax,%edx
 297:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a1:	3c 0a                	cmp    $0xa,%al
 2a3:	74 16                	je     2bb <gets+0x5f>
 2a5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a9:	3c 0d                	cmp    $0xd,%al
 2ab:	74 0e                	je     2bb <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b0:	83 c0 01             	add    $0x1,%eax
 2b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b6:	7c b3                	jl     26b <gets+0xf>
 2b8:	eb 01                	jmp    2bb <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2ba:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
 2c1:	01 d0                	add    %edx,%eax
 2c3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c9:	c9                   	leave  
 2ca:	c3                   	ret    

000002cb <stat>:

int
stat(char *n, struct stat *st)
{
 2cb:	55                   	push   %ebp
 2cc:	89 e5                	mov    %esp,%ebp
 2ce:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d1:	83 ec 08             	sub    $0x8,%esp
 2d4:	6a 00                	push   $0x0
 2d6:	ff 75 08             	pushl  0x8(%ebp)
 2d9:	e8 3c 01 00 00       	call   41a <open>
 2de:	83 c4 10             	add    $0x10,%esp
 2e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e8:	79 07                	jns    2f1 <stat+0x26>
    return -1;
 2ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ef:	eb 25                	jmp    316 <stat+0x4b>
  r = fstat(fd, st);
 2f1:	83 ec 08             	sub    $0x8,%esp
 2f4:	ff 75 0c             	pushl  0xc(%ebp)
 2f7:	ff 75 f4             	pushl  -0xc(%ebp)
 2fa:	e8 33 01 00 00       	call   432 <fstat>
 2ff:	83 c4 10             	add    $0x10,%esp
 302:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 305:	83 ec 0c             	sub    $0xc,%esp
 308:	ff 75 f4             	pushl  -0xc(%ebp)
 30b:	e8 f2 00 00 00       	call   402 <close>
 310:	83 c4 10             	add    $0x10,%esp
  return r;
 313:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 316:	c9                   	leave  
 317:	c3                   	ret    

00000318 <atoi>:

int
atoi(const char *s)
{
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 325:	eb 25                	jmp    34c <atoi+0x34>
    n = n*10 + *s++ - '0';
 327:	8b 55 fc             	mov    -0x4(%ebp),%edx
 32a:	89 d0                	mov    %edx,%eax
 32c:	c1 e0 02             	shl    $0x2,%eax
 32f:	01 d0                	add    %edx,%eax
 331:	01 c0                	add    %eax,%eax
 333:	89 c1                	mov    %eax,%ecx
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	8d 50 01             	lea    0x1(%eax),%edx
 33b:	89 55 08             	mov    %edx,0x8(%ebp)
 33e:	0f b6 00             	movzbl (%eax),%eax
 341:	0f be c0             	movsbl %al,%eax
 344:	01 c8                	add    %ecx,%eax
 346:	83 e8 30             	sub    $0x30,%eax
 349:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	0f b6 00             	movzbl (%eax),%eax
 352:	3c 2f                	cmp    $0x2f,%al
 354:	7e 0a                	jle    360 <atoi+0x48>
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	0f b6 00             	movzbl (%eax),%eax
 35c:	3c 39                	cmp    $0x39,%al
 35e:	7e c7                	jle    327 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 360:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 363:	c9                   	leave  
 364:	c3                   	ret    

00000365 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 365:	55                   	push   %ebp
 366:	89 e5                	mov    %esp,%ebp
 368:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
 36e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 371:	8b 45 0c             	mov    0xc(%ebp),%eax
 374:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 377:	eb 17                	jmp    390 <memmove+0x2b>
    *dst++ = *src++;
 379:	8b 45 fc             	mov    -0x4(%ebp),%eax
 37c:	8d 50 01             	lea    0x1(%eax),%edx
 37f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 382:	8b 55 f8             	mov    -0x8(%ebp),%edx
 385:	8d 4a 01             	lea    0x1(%edx),%ecx
 388:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 38b:	0f b6 12             	movzbl (%edx),%edx
 38e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 390:	8b 45 10             	mov    0x10(%ebp),%eax
 393:	8d 50 ff             	lea    -0x1(%eax),%edx
 396:	89 55 10             	mov    %edx,0x10(%ebp)
 399:	85 c0                	test   %eax,%eax
 39b:	7f dc                	jg     379 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 39d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a0:	c9                   	leave  
 3a1:	c3                   	ret    

000003a2 <restorer>:
 3a2:	83 c4 0c             	add    $0xc,%esp
 3a5:	5a                   	pop    %edx
 3a6:	59                   	pop    %ecx
 3a7:	58                   	pop    %eax
 3a8:	c3                   	ret    

000003a9 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 3a9:	55                   	push   %ebp
 3aa:	89 e5                	mov    %esp,%ebp
 3ac:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 3af:	83 ec 0c             	sub    $0xc,%esp
 3b2:	68 a2 03 00 00       	push   $0x3a2
 3b7:	e8 ce 00 00 00       	call   48a <signal_restorer>
 3bc:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 3bf:	83 ec 08             	sub    $0x8,%esp
 3c2:	ff 75 0c             	pushl  0xc(%ebp)
 3c5:	ff 75 08             	pushl  0x8(%ebp)
 3c8:	e8 b5 00 00 00       	call   482 <signal_register>
 3cd:	83 c4 10             	add    $0x10,%esp
}
 3d0:	c9                   	leave  
 3d1:	c3                   	ret    

000003d2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3d2:	b8 01 00 00 00       	mov    $0x1,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <exit>:
SYSCALL(exit)
 3da:	b8 02 00 00 00       	mov    $0x2,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <wait>:
SYSCALL(wait)
 3e2:	b8 03 00 00 00       	mov    $0x3,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <pipe>:
SYSCALL(pipe)
 3ea:	b8 04 00 00 00       	mov    $0x4,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <read>:
SYSCALL(read)
 3f2:	b8 05 00 00 00       	mov    $0x5,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <write>:
SYSCALL(write)
 3fa:	b8 10 00 00 00       	mov    $0x10,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <close>:
SYSCALL(close)
 402:	b8 15 00 00 00       	mov    $0x15,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <kill>:
SYSCALL(kill)
 40a:	b8 06 00 00 00       	mov    $0x6,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <exec>:
SYSCALL(exec)
 412:	b8 07 00 00 00       	mov    $0x7,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <open>:
SYSCALL(open)
 41a:	b8 0f 00 00 00       	mov    $0xf,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <mknod>:
SYSCALL(mknod)
 422:	b8 11 00 00 00       	mov    $0x11,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <unlink>:
SYSCALL(unlink)
 42a:	b8 12 00 00 00       	mov    $0x12,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <fstat>:
SYSCALL(fstat)
 432:	b8 08 00 00 00       	mov    $0x8,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <link>:
SYSCALL(link)
 43a:	b8 13 00 00 00       	mov    $0x13,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <mkdir>:
SYSCALL(mkdir)
 442:	b8 14 00 00 00       	mov    $0x14,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <chdir>:
SYSCALL(chdir)
 44a:	b8 09 00 00 00       	mov    $0x9,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <dup>:
SYSCALL(dup)
 452:	b8 0a 00 00 00       	mov    $0xa,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <getpid>:
SYSCALL(getpid)
 45a:	b8 0b 00 00 00       	mov    $0xb,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <sbrk>:
SYSCALL(sbrk)
 462:	b8 0c 00 00 00       	mov    $0xc,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <sleep>:
SYSCALL(sleep)
 46a:	b8 0d 00 00 00       	mov    $0xd,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <uptime>:
SYSCALL(uptime)
 472:	b8 0e 00 00 00       	mov    $0xe,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <halt>:
SYSCALL(halt)
 47a:	b8 16 00 00 00       	mov    $0x16,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <signal_register>:
SYSCALL(signal_register)
 482:	b8 17 00 00 00       	mov    $0x17,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <signal_restorer>:
SYSCALL(signal_restorer)
 48a:	b8 18 00 00 00       	mov    $0x18,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <mprotect>:
SYSCALL(mprotect)
 492:	b8 19 00 00 00       	mov    $0x19,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <cowfork>:
SYSCALL(cowfork)
 49a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a2:	55                   	push   %ebp
 4a3:	89 e5                	mov    %esp,%ebp
 4a5:	83 ec 18             	sub    $0x18,%esp
 4a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ab:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ae:	83 ec 04             	sub    $0x4,%esp
 4b1:	6a 01                	push   $0x1
 4b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b6:	50                   	push   %eax
 4b7:	ff 75 08             	pushl  0x8(%ebp)
 4ba:	e8 3b ff ff ff       	call   3fa <write>
 4bf:	83 c4 10             	add    $0x10,%esp
}
 4c2:	90                   	nop
 4c3:	c9                   	leave  
 4c4:	c3                   	ret    

000004c5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c5:	55                   	push   %ebp
 4c6:	89 e5                	mov    %esp,%ebp
 4c8:	53                   	push   %ebx
 4c9:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4d3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4d7:	74 17                	je     4f0 <printint+0x2b>
 4d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4dd:	79 11                	jns    4f0 <printint+0x2b>
    neg = 1;
 4df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e9:	f7 d8                	neg    %eax
 4eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ee:	eb 06                	jmp    4f6 <printint+0x31>
  } else {
    x = xx;
 4f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4fd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 500:	8d 41 01             	lea    0x1(%ecx),%eax
 503:	89 45 f4             	mov    %eax,-0xc(%ebp)
 506:	8b 5d 10             	mov    0x10(%ebp),%ebx
 509:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50c:	ba 00 00 00 00       	mov    $0x0,%edx
 511:	f7 f3                	div    %ebx
 513:	89 d0                	mov    %edx,%eax
 515:	0f b6 80 00 0d 00 00 	movzbl 0xd00(%eax),%eax
 51c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 520:	8b 5d 10             	mov    0x10(%ebp),%ebx
 523:	8b 45 ec             	mov    -0x14(%ebp),%eax
 526:	ba 00 00 00 00       	mov    $0x0,%edx
 52b:	f7 f3                	div    %ebx
 52d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 530:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 534:	75 c7                	jne    4fd <printint+0x38>
  if(neg)
 536:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 53a:	74 2d                	je     569 <printint+0xa4>
    buf[i++] = '-';
 53c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53f:	8d 50 01             	lea    0x1(%eax),%edx
 542:	89 55 f4             	mov    %edx,-0xc(%ebp)
 545:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 54a:	eb 1d                	jmp    569 <printint+0xa4>
    putc(fd, buf[i]);
 54c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 54f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 552:	01 d0                	add    %edx,%eax
 554:	0f b6 00             	movzbl (%eax),%eax
 557:	0f be c0             	movsbl %al,%eax
 55a:	83 ec 08             	sub    $0x8,%esp
 55d:	50                   	push   %eax
 55e:	ff 75 08             	pushl  0x8(%ebp)
 561:	e8 3c ff ff ff       	call   4a2 <putc>
 566:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 569:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 56d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 571:	79 d9                	jns    54c <printint+0x87>
    putc(fd, buf[i]);
}
 573:	90                   	nop
 574:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 577:	c9                   	leave  
 578:	c3                   	ret    

00000579 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 579:	55                   	push   %ebp
 57a:	89 e5                	mov    %esp,%ebp
 57c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 57f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 586:	8d 45 0c             	lea    0xc(%ebp),%eax
 589:	83 c0 04             	add    $0x4,%eax
 58c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 58f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 596:	e9 59 01 00 00       	jmp    6f4 <printf+0x17b>
    c = fmt[i] & 0xff;
 59b:	8b 55 0c             	mov    0xc(%ebp),%edx
 59e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a1:	01 d0                	add    %edx,%eax
 5a3:	0f b6 00             	movzbl (%eax),%eax
 5a6:	0f be c0             	movsbl %al,%eax
 5a9:	25 ff 00 00 00       	and    $0xff,%eax
 5ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b5:	75 2c                	jne    5e3 <printf+0x6a>
      if(c == '%'){
 5b7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5bb:	75 0c                	jne    5c9 <printf+0x50>
        state = '%';
 5bd:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5c4:	e9 27 01 00 00       	jmp    6f0 <printf+0x177>
      } else {
        putc(fd, c);
 5c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cc:	0f be c0             	movsbl %al,%eax
 5cf:	83 ec 08             	sub    $0x8,%esp
 5d2:	50                   	push   %eax
 5d3:	ff 75 08             	pushl  0x8(%ebp)
 5d6:	e8 c7 fe ff ff       	call   4a2 <putc>
 5db:	83 c4 10             	add    $0x10,%esp
 5de:	e9 0d 01 00 00       	jmp    6f0 <printf+0x177>
      }
    } else if(state == '%'){
 5e3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5e7:	0f 85 03 01 00 00    	jne    6f0 <printf+0x177>
      if(c == 'd'){
 5ed:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f1:	75 1e                	jne    611 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f6:	8b 00                	mov    (%eax),%eax
 5f8:	6a 01                	push   $0x1
 5fa:	6a 0a                	push   $0xa
 5fc:	50                   	push   %eax
 5fd:	ff 75 08             	pushl  0x8(%ebp)
 600:	e8 c0 fe ff ff       	call   4c5 <printint>
 605:	83 c4 10             	add    $0x10,%esp
        ap++;
 608:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60c:	e9 d8 00 00 00       	jmp    6e9 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 611:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 615:	74 06                	je     61d <printf+0xa4>
 617:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 61b:	75 1e                	jne    63b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 61d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	6a 00                	push   $0x0
 624:	6a 10                	push   $0x10
 626:	50                   	push   %eax
 627:	ff 75 08             	pushl  0x8(%ebp)
 62a:	e8 96 fe ff ff       	call   4c5 <printint>
 62f:	83 c4 10             	add    $0x10,%esp
        ap++;
 632:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 636:	e9 ae 00 00 00       	jmp    6e9 <printf+0x170>
      } else if(c == 's'){
 63b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 63f:	75 43                	jne    684 <printf+0x10b>
        s = (char*)*ap;
 641:	8b 45 e8             	mov    -0x18(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 649:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 64d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 651:	75 25                	jne    678 <printf+0xff>
          s = "(null)";
 653:	c7 45 f4 70 0a 00 00 	movl   $0xa70,-0xc(%ebp)
        while(*s != 0){
 65a:	eb 1c                	jmp    678 <printf+0xff>
          putc(fd, *s);
 65c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65f:	0f b6 00             	movzbl (%eax),%eax
 662:	0f be c0             	movsbl %al,%eax
 665:	83 ec 08             	sub    $0x8,%esp
 668:	50                   	push   %eax
 669:	ff 75 08             	pushl  0x8(%ebp)
 66c:	e8 31 fe ff ff       	call   4a2 <putc>
 671:	83 c4 10             	add    $0x10,%esp
          s++;
 674:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 678:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67b:	0f b6 00             	movzbl (%eax),%eax
 67e:	84 c0                	test   %al,%al
 680:	75 da                	jne    65c <printf+0xe3>
 682:	eb 65                	jmp    6e9 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 684:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 688:	75 1d                	jne    6a7 <printf+0x12e>
        putc(fd, *ap);
 68a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	0f be c0             	movsbl %al,%eax
 692:	83 ec 08             	sub    $0x8,%esp
 695:	50                   	push   %eax
 696:	ff 75 08             	pushl  0x8(%ebp)
 699:	e8 04 fe ff ff       	call   4a2 <putc>
 69e:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a5:	eb 42                	jmp    6e9 <printf+0x170>
      } else if(c == '%'){
 6a7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ab:	75 17                	jne    6c4 <printf+0x14b>
        putc(fd, c);
 6ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b0:	0f be c0             	movsbl %al,%eax
 6b3:	83 ec 08             	sub    $0x8,%esp
 6b6:	50                   	push   %eax
 6b7:	ff 75 08             	pushl  0x8(%ebp)
 6ba:	e8 e3 fd ff ff       	call   4a2 <putc>
 6bf:	83 c4 10             	add    $0x10,%esp
 6c2:	eb 25                	jmp    6e9 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c4:	83 ec 08             	sub    $0x8,%esp
 6c7:	6a 25                	push   $0x25
 6c9:	ff 75 08             	pushl  0x8(%ebp)
 6cc:	e8 d1 fd ff ff       	call   4a2 <putc>
 6d1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d7:	0f be c0             	movsbl %al,%eax
 6da:	83 ec 08             	sub    $0x8,%esp
 6dd:	50                   	push   %eax
 6de:	ff 75 08             	pushl  0x8(%ebp)
 6e1:	e8 bc fd ff ff       	call   4a2 <putc>
 6e6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6f4:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fa:	01 d0                	add    %edx,%eax
 6fc:	0f b6 00             	movzbl (%eax),%eax
 6ff:	84 c0                	test   %al,%al
 701:	0f 85 94 fe ff ff    	jne    59b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 707:	90                   	nop
 708:	c9                   	leave  
 709:	c3                   	ret    

0000070a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70a:	55                   	push   %ebp
 70b:	89 e5                	mov    %esp,%ebp
 70d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 710:	8b 45 08             	mov    0x8(%ebp),%eax
 713:	83 e8 08             	sub    $0x8,%eax
 716:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 719:	a1 1c 0d 00 00       	mov    0xd1c,%eax
 71e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 721:	eb 24                	jmp    747 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 00                	mov    (%eax),%eax
 728:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72b:	77 12                	ja     73f <free+0x35>
 72d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 730:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 733:	77 24                	ja     759 <free+0x4f>
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	8b 00                	mov    (%eax),%eax
 73a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73d:	77 1a                	ja     759 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	8b 00                	mov    (%eax),%eax
 744:	89 45 fc             	mov    %eax,-0x4(%ebp)
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74d:	76 d4                	jbe    723 <free+0x19>
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	8b 00                	mov    (%eax),%eax
 754:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 757:	76 ca                	jbe    723 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 759:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75c:	8b 40 04             	mov    0x4(%eax),%eax
 75f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 766:	8b 45 f8             	mov    -0x8(%ebp),%eax
 769:	01 c2                	add    %eax,%edx
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	8b 00                	mov    (%eax),%eax
 770:	39 c2                	cmp    %eax,%edx
 772:	75 24                	jne    798 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 774:	8b 45 f8             	mov    -0x8(%ebp),%eax
 777:	8b 50 04             	mov    0x4(%eax),%edx
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	8b 00                	mov    (%eax),%eax
 77f:	8b 40 04             	mov    0x4(%eax),%eax
 782:	01 c2                	add    %eax,%edx
 784:	8b 45 f8             	mov    -0x8(%ebp),%eax
 787:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	8b 00                	mov    (%eax),%eax
 78f:	8b 10                	mov    (%eax),%edx
 791:	8b 45 f8             	mov    -0x8(%ebp),%eax
 794:	89 10                	mov    %edx,(%eax)
 796:	eb 0a                	jmp    7a2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 798:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79b:	8b 10                	mov    (%eax),%edx
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	8b 40 04             	mov    0x4(%eax),%eax
 7a8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b2:	01 d0                	add    %edx,%eax
 7b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b7:	75 20                	jne    7d9 <free+0xcf>
    p->s.size += bp->s.size;
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	8b 50 04             	mov    0x4(%eax),%edx
 7bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c2:	8b 40 04             	mov    0x4(%eax),%eax
 7c5:	01 c2                	add    %eax,%edx
 7c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ca:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d0:	8b 10                	mov    (%eax),%edx
 7d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d5:	89 10                	mov    %edx,(%eax)
 7d7:	eb 08                	jmp    7e1 <free+0xd7>
  } else
    p->s.ptr = bp;
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7df:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	a3 1c 0d 00 00       	mov    %eax,0xd1c
}
 7e9:	90                   	nop
 7ea:	c9                   	leave  
 7eb:	c3                   	ret    

000007ec <morecore>:

static Header*
morecore(uint nu)
{
 7ec:	55                   	push   %ebp
 7ed:	89 e5                	mov    %esp,%ebp
 7ef:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7f2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7f9:	77 07                	ja     802 <morecore+0x16>
    nu = 4096;
 7fb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 802:	8b 45 08             	mov    0x8(%ebp),%eax
 805:	c1 e0 03             	shl    $0x3,%eax
 808:	83 ec 0c             	sub    $0xc,%esp
 80b:	50                   	push   %eax
 80c:	e8 51 fc ff ff       	call   462 <sbrk>
 811:	83 c4 10             	add    $0x10,%esp
 814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 817:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 81b:	75 07                	jne    824 <morecore+0x38>
    return 0;
 81d:	b8 00 00 00 00       	mov    $0x0,%eax
 822:	eb 26                	jmp    84a <morecore+0x5e>
  hp = (Header*)p;
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 82a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82d:	8b 55 08             	mov    0x8(%ebp),%edx
 830:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 833:	8b 45 f0             	mov    -0x10(%ebp),%eax
 836:	83 c0 08             	add    $0x8,%eax
 839:	83 ec 0c             	sub    $0xc,%esp
 83c:	50                   	push   %eax
 83d:	e8 c8 fe ff ff       	call   70a <free>
 842:	83 c4 10             	add    $0x10,%esp
  return freep;
 845:	a1 1c 0d 00 00       	mov    0xd1c,%eax
}
 84a:	c9                   	leave  
 84b:	c3                   	ret    

0000084c <malloc>:

void*
malloc(uint nbytes)
{
 84c:	55                   	push   %ebp
 84d:	89 e5                	mov    %esp,%ebp
 84f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 852:	8b 45 08             	mov    0x8(%ebp),%eax
 855:	83 c0 07             	add    $0x7,%eax
 858:	c1 e8 03             	shr    $0x3,%eax
 85b:	83 c0 01             	add    $0x1,%eax
 85e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 861:	a1 1c 0d 00 00       	mov    0xd1c,%eax
 866:	89 45 f0             	mov    %eax,-0x10(%ebp)
 869:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 86d:	75 23                	jne    892 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 86f:	c7 45 f0 14 0d 00 00 	movl   $0xd14,-0x10(%ebp)
 876:	8b 45 f0             	mov    -0x10(%ebp),%eax
 879:	a3 1c 0d 00 00       	mov    %eax,0xd1c
 87e:	a1 1c 0d 00 00       	mov    0xd1c,%eax
 883:	a3 14 0d 00 00       	mov    %eax,0xd14
    base.s.size = 0;
 888:	c7 05 18 0d 00 00 00 	movl   $0x0,0xd18
 88f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	8b 45 f0             	mov    -0x10(%ebp),%eax
 895:	8b 00                	mov    (%eax),%eax
 897:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	8b 40 04             	mov    0x4(%eax),%eax
 8a0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a3:	72 4d                	jb     8f2 <malloc+0xa6>
      if(p->s.size == nunits)
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	8b 40 04             	mov    0x4(%eax),%eax
 8ab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ae:	75 0c                	jne    8bc <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	8b 10                	mov    (%eax),%edx
 8b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b8:	89 10                	mov    %edx,(%eax)
 8ba:	eb 26                	jmp    8e2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bf:	8b 40 04             	mov    0x4(%eax),%eax
 8c2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8c5:	89 c2                	mov    %eax,%edx
 8c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ca:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d0:	8b 40 04             	mov    0x4(%eax),%eax
 8d3:	c1 e0 03             	shl    $0x3,%eax
 8d6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8df:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e5:	a3 1c 0d 00 00       	mov    %eax,0xd1c
      return (void*)(p + 1);
 8ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ed:	83 c0 08             	add    $0x8,%eax
 8f0:	eb 3b                	jmp    92d <malloc+0xe1>
    }
    if(p == freep)
 8f2:	a1 1c 0d 00 00       	mov    0xd1c,%eax
 8f7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8fa:	75 1e                	jne    91a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8fc:	83 ec 0c             	sub    $0xc,%esp
 8ff:	ff 75 ec             	pushl  -0x14(%ebp)
 902:	e8 e5 fe ff ff       	call   7ec <morecore>
 907:	83 c4 10             	add    $0x10,%esp
 90a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 90d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 911:	75 07                	jne    91a <malloc+0xce>
        return 0;
 913:	b8 00 00 00 00       	mov    $0x0,%eax
 918:	eb 13                	jmp    92d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 920:	8b 45 f4             	mov    -0xc(%ebp),%eax
 923:	8b 00                	mov    (%eax),%eax
 925:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 928:	e9 6d ff ff ff       	jmp    89a <malloc+0x4e>
}
 92d:	c9                   	leave  
 92e:	c3                   	ret    
