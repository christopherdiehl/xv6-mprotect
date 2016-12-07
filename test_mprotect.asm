
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
   d:	68 f4 08 00 00       	push   $0x8f4
  12:	6a 01                	push   $0x1
  14:	e8 22 05 00 00       	call   53b <printf>
  19:	83 c4 10             	add    $0x10,%esp
	printf(1,"error = 0x%x",info.type);
  1c:	8b 45 10             	mov    0x10(%ebp),%eax
  1f:	83 ec 04             	sub    $0x4,%esp
  22:	50                   	push   %eax
  23:	68 1b 09 00 00       	push   $0x91b
  28:	6a 01                	push   $0x1
  2a:	e8 0c 05 00 00       	call   53b <printf>
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
  44:	e8 f2 04 00 00       	call   53b <printf>
  49:	83 c4 10             	add    $0x10,%esp
		mprotect((void *) info.addr, sizeof(int), PROT_READ);
  4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  4f:	83 ec 04             	sub    $0x4,%esp
  52:	6a 05                	push   $0x5
  54:	6a 04                	push   $0x4
  56:	50                   	push   %eax
  57:	e8 00 04 00 00       	call   45c <mprotect>
  5c:	83 c4 10             	add    $0x10,%esp
	else
	{
		printf(1, "ERROR: Didn't get proper exception, this should not happen.\n");
		exit();
	}
}
  5f:	eb 46                	jmp    a7 <handler+0xa7>
	printf(1,"error = 0x%x",info.type);
	if(info.type == PROT_NONE)
	{
		printf(1,"ERROR: Writing to a page with PROT_NONE permission.\n");
		mprotect((void *) info.addr, sizeof(int), PROT_READ);
	} else if (info.type == PROT_READ)
  61:	8b 45 10             	mov    0x10(%ebp),%eax
  64:	83 f8 05             	cmp    $0x5,%eax
  67:	75 27                	jne    90 <handler+0x90>
	{
		printf(1,"ERROR: Writing to a page with PROT_READ permission.\n");
  69:	83 ec 08             	sub    $0x8,%esp
  6c:	68 60 09 00 00       	push   $0x960
  71:	6a 01                	push   $0x1
  73:	e8 c3 04 00 00       	call   53b <printf>
  78:	83 c4 10             	add    $0x10,%esp
		mprotect((void *) info.addr, sizeof(int), PROT_READ | PROT_WRITE);
  7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  7e:	83 ec 04             	sub    $0x4,%esp
  81:	6a 07                	push   $0x7
  83:	6a 04                	push   $0x4
  85:	50                   	push   %eax
  86:	e8 d1 03 00 00       	call   45c <mprotect>
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
  9a:	e8 9c 04 00 00       	call   53b <printf>
  9f:	83 c4 10             	add    $0x10,%esp
		exit();
  a2:	e8 fd 02 00 00       	call   3a4 <exit>
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
  b7:	83 ec 04             	sub    $0x4,%esp
	signal(SIGSEGV, handler);
  ba:	83 ec 08             	sub    $0x8,%esp
  bd:	68 00 00 00 00       	push   $0x0
  c2:	6a 02                	push   $0x2
  c4:	e8 aa 02 00 00       	call   373 <signal>
  c9:	83 c4 10             	add    $0x10,%esp
 	p = (int *) sbrk(1);
  cc:	83 ec 0c             	sub    $0xc,%esp
  cf:	6a 01                	push   $0x1
  d1:	e8 56 03 00 00       	call   42c <sbrk>
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	a3 b0 0c 00 00       	mov    %eax,0xcb0
 	mprotect((void *)p, sizeof(int), PROT_NONE);
  de:	a1 b0 0c 00 00       	mov    0xcb0,%eax
  e3:	83 ec 04             	sub    $0x4,%esp
  e6:	6a 01                	push   $0x1
  e8:	6a 04                	push   $0x4
  ea:	50                   	push   %eax
  eb:	e8 6c 03 00 00       	call   45c <mprotect>
  f0:	83 c4 10             	add    $0x10,%esp
 	*p=100;
  f3:	a1 b0 0c 00 00       	mov    0xcb0,%eax
  f8:	c7 00 64 00 00 00    	movl   $0x64,(%eax)
 	printf(1, "COMPLETED: value is %d, expecting 100!\n", *p);
  fe:	a1 b0 0c 00 00       	mov    0xcb0,%eax
 103:	8b 00                	mov    (%eax),%eax
 105:	83 ec 04             	sub    $0x4,%esp
 108:	50                   	push   %eax
 109:	68 d8 09 00 00       	push   $0x9d8
 10e:	6a 01                	push   $0x1
 110:	e8 26 04 00 00       	call   53b <printf>
 115:	83 c4 10             	add    $0x10,%esp

 	exit();
 118:	e8 87 02 00 00       	call   3a4 <exit>

0000011d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	57                   	push   %edi
 121:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 122:	8b 4d 08             	mov    0x8(%ebp),%ecx
 125:	8b 55 10             	mov    0x10(%ebp),%edx
 128:	8b 45 0c             	mov    0xc(%ebp),%eax
 12b:	89 cb                	mov    %ecx,%ebx
 12d:	89 df                	mov    %ebx,%edi
 12f:	89 d1                	mov    %edx,%ecx
 131:	fc                   	cld    
 132:	f3 aa                	rep stos %al,%es:(%edi)
 134:	89 ca                	mov    %ecx,%edx
 136:	89 fb                	mov    %edi,%ebx
 138:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13e:	90                   	nop
 13f:	5b                   	pop    %ebx
 140:	5f                   	pop    %edi
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    

00000143 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
 146:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14f:	90                   	nop
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	8d 50 01             	lea    0x1(%eax),%edx
 156:	89 55 08             	mov    %edx,0x8(%ebp)
 159:	8b 55 0c             	mov    0xc(%ebp),%edx
 15c:	8d 4a 01             	lea    0x1(%edx),%ecx
 15f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 162:	0f b6 12             	movzbl (%edx),%edx
 165:	88 10                	mov    %dl,(%eax)
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	75 e2                	jne    150 <strcpy+0xd>
    ;
  return os;
 16e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 171:	c9                   	leave  
 172:	c3                   	ret    

00000173 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 173:	55                   	push   %ebp
 174:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 176:	eb 08                	jmp    180 <strcmp+0xd>
    p++, q++;
 178:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	0f b6 00             	movzbl (%eax),%eax
 186:	84 c0                	test   %al,%al
 188:	74 10                	je     19a <strcmp+0x27>
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 10             	movzbl (%eax),%edx
 190:	8b 45 0c             	mov    0xc(%ebp),%eax
 193:	0f b6 00             	movzbl (%eax),%eax
 196:	38 c2                	cmp    %al,%dl
 198:	74 de                	je     178 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	0f b6 00             	movzbl (%eax),%eax
 1a0:	0f b6 d0             	movzbl %al,%edx
 1a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a6:	0f b6 00             	movzbl (%eax),%eax
 1a9:	0f b6 c0             	movzbl %al,%eax
 1ac:	29 c2                	sub    %eax,%edx
 1ae:	89 d0                	mov    %edx,%eax
}
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret    

000001b2 <strlen>:

uint
strlen(char *s)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1bf:	eb 04                	jmp    1c5 <strlen+0x13>
 1c1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	01 d0                	add    %edx,%eax
 1cd:	0f b6 00             	movzbl (%eax),%eax
 1d0:	84 c0                	test   %al,%al
 1d2:	75 ed                	jne    1c1 <strlen+0xf>
    ;
  return n;
 1d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d7:	c9                   	leave  
 1d8:	c3                   	ret    

000001d9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1dc:	8b 45 10             	mov    0x10(%ebp),%eax
 1df:	50                   	push   %eax
 1e0:	ff 75 0c             	pushl  0xc(%ebp)
 1e3:	ff 75 08             	pushl  0x8(%ebp)
 1e6:	e8 32 ff ff ff       	call   11d <stosb>
 1eb:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f1:	c9                   	leave  
 1f2:	c3                   	ret    

000001f3 <strchr>:

char*
strchr(const char *s, char c)
{
 1f3:	55                   	push   %ebp
 1f4:	89 e5                	mov    %esp,%ebp
 1f6:	83 ec 04             	sub    $0x4,%esp
 1f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ff:	eb 14                	jmp    215 <strchr+0x22>
    if(*s == c)
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	0f b6 00             	movzbl (%eax),%eax
 207:	3a 45 fc             	cmp    -0x4(%ebp),%al
 20a:	75 05                	jne    211 <strchr+0x1e>
      return (char*)s;
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	eb 13                	jmp    224 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 211:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	0f b6 00             	movzbl (%eax),%eax
 21b:	84 c0                	test   %al,%al
 21d:	75 e2                	jne    201 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 224:	c9                   	leave  
 225:	c3                   	ret    

00000226 <gets>:

char*
gets(char *buf, int max)
{
 226:	55                   	push   %ebp
 227:	89 e5                	mov    %esp,%ebp
 229:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 233:	eb 42                	jmp    277 <gets+0x51>
    cc = read(0, &c, 1);
 235:	83 ec 04             	sub    $0x4,%esp
 238:	6a 01                	push   $0x1
 23a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23d:	50                   	push   %eax
 23e:	6a 00                	push   $0x0
 240:	e8 77 01 00 00       	call   3bc <read>
 245:	83 c4 10             	add    $0x10,%esp
 248:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24f:	7e 33                	jle    284 <gets+0x5e>
      break;
    buf[i++] = c;
 251:	8b 45 f4             	mov    -0xc(%ebp),%eax
 254:	8d 50 01             	lea    0x1(%eax),%edx
 257:	89 55 f4             	mov    %edx,-0xc(%ebp)
 25a:	89 c2                	mov    %eax,%edx
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	01 c2                	add    %eax,%edx
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 267:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26b:	3c 0a                	cmp    $0xa,%al
 26d:	74 16                	je     285 <gets+0x5f>
 26f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 273:	3c 0d                	cmp    $0xd,%al
 275:	74 0e                	je     285 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 277:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27a:	83 c0 01             	add    $0x1,%eax
 27d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 280:	7c b3                	jl     235 <gets+0xf>
 282:	eb 01                	jmp    285 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 284:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 285:	8b 55 f4             	mov    -0xc(%ebp),%edx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	01 d0                	add    %edx,%eax
 28d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
}
 293:	c9                   	leave  
 294:	c3                   	ret    

00000295 <stat>:

int
stat(char *n, struct stat *st)
{
 295:	55                   	push   %ebp
 296:	89 e5                	mov    %esp,%ebp
 298:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29b:	83 ec 08             	sub    $0x8,%esp
 29e:	6a 00                	push   $0x0
 2a0:	ff 75 08             	pushl  0x8(%ebp)
 2a3:	e8 3c 01 00 00       	call   3e4 <open>
 2a8:	83 c4 10             	add    $0x10,%esp
 2ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b2:	79 07                	jns    2bb <stat+0x26>
    return -1;
 2b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b9:	eb 25                	jmp    2e0 <stat+0x4b>
  r = fstat(fd, st);
 2bb:	83 ec 08             	sub    $0x8,%esp
 2be:	ff 75 0c             	pushl  0xc(%ebp)
 2c1:	ff 75 f4             	pushl  -0xc(%ebp)
 2c4:	e8 33 01 00 00       	call   3fc <fstat>
 2c9:	83 c4 10             	add    $0x10,%esp
 2cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2cf:	83 ec 0c             	sub    $0xc,%esp
 2d2:	ff 75 f4             	pushl  -0xc(%ebp)
 2d5:	e8 f2 00 00 00       	call   3cc <close>
 2da:	83 c4 10             	add    $0x10,%esp
  return r;
 2dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <atoi>:

int
atoi(const char *s)
{
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ef:	eb 25                	jmp    316 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f4:	89 d0                	mov    %edx,%eax
 2f6:	c1 e0 02             	shl    $0x2,%eax
 2f9:	01 d0                	add    %edx,%eax
 2fb:	01 c0                	add    %eax,%eax
 2fd:	89 c1                	mov    %eax,%ecx
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	8d 50 01             	lea    0x1(%eax),%edx
 305:	89 55 08             	mov    %edx,0x8(%ebp)
 308:	0f b6 00             	movzbl (%eax),%eax
 30b:	0f be c0             	movsbl %al,%eax
 30e:	01 c8                	add    %ecx,%eax
 310:	83 e8 30             	sub    $0x30,%eax
 313:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	3c 2f                	cmp    $0x2f,%al
 31e:	7e 0a                	jle    32a <atoi+0x48>
 320:	8b 45 08             	mov    0x8(%ebp),%eax
 323:	0f b6 00             	movzbl (%eax),%eax
 326:	3c 39                	cmp    $0x39,%al
 328:	7e c7                	jle    2f1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 32a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 32d:	c9                   	leave  
 32e:	c3                   	ret    

0000032f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 32f:	55                   	push   %ebp
 330:	89 e5                	mov    %esp,%ebp
 332:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 33b:	8b 45 0c             	mov    0xc(%ebp),%eax
 33e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 341:	eb 17                	jmp    35a <memmove+0x2b>
    *dst++ = *src++;
 343:	8b 45 fc             	mov    -0x4(%ebp),%eax
 346:	8d 50 01             	lea    0x1(%eax),%edx
 349:	89 55 fc             	mov    %edx,-0x4(%ebp)
 34c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 34f:	8d 4a 01             	lea    0x1(%edx),%ecx
 352:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 355:	0f b6 12             	movzbl (%edx),%edx
 358:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35a:	8b 45 10             	mov    0x10(%ebp),%eax
 35d:	8d 50 ff             	lea    -0x1(%eax),%edx
 360:	89 55 10             	mov    %edx,0x10(%ebp)
 363:	85 c0                	test   %eax,%eax
 365:	7f dc                	jg     343 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 367:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36a:	c9                   	leave  
 36b:	c3                   	ret    

0000036c <restorer>:
 36c:	83 c4 0c             	add    $0xc,%esp
 36f:	5a                   	pop    %edx
 370:	59                   	pop    %ecx
 371:	58                   	pop    %eax
 372:	c3                   	ret    

00000373 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int,siginfo_t))
{
 373:	55                   	push   %ebp
 374:	89 e5                	mov    %esp,%ebp
 376:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 379:	83 ec 0c             	sub    $0xc,%esp
 37c:	68 6c 03 00 00       	push   $0x36c
 381:	e8 ce 00 00 00       	call   454 <signal_restorer>
 386:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 389:	83 ec 08             	sub    $0x8,%esp
 38c:	ff 75 0c             	pushl  0xc(%ebp)
 38f:	ff 75 08             	pushl  0x8(%ebp)
 392:	e8 b5 00 00 00       	call   44c <signal_register>
 397:	83 c4 10             	add    $0x10,%esp
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39c:	b8 01 00 00 00       	mov    $0x1,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <exit>:
SYSCALL(exit)
 3a4:	b8 02 00 00 00       	mov    $0x2,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <wait>:
SYSCALL(wait)
 3ac:	b8 03 00 00 00       	mov    $0x3,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <pipe>:
SYSCALL(pipe)
 3b4:	b8 04 00 00 00       	mov    $0x4,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <read>:
SYSCALL(read)
 3bc:	b8 05 00 00 00       	mov    $0x5,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <write>:
SYSCALL(write)
 3c4:	b8 10 00 00 00       	mov    $0x10,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <close>:
SYSCALL(close)
 3cc:	b8 15 00 00 00       	mov    $0x15,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <kill>:
SYSCALL(kill)
 3d4:	b8 06 00 00 00       	mov    $0x6,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <exec>:
SYSCALL(exec)
 3dc:	b8 07 00 00 00       	mov    $0x7,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <open>:
SYSCALL(open)
 3e4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <mknod>:
SYSCALL(mknod)
 3ec:	b8 11 00 00 00       	mov    $0x11,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <unlink>:
SYSCALL(unlink)
 3f4:	b8 12 00 00 00       	mov    $0x12,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <fstat>:
SYSCALL(fstat)
 3fc:	b8 08 00 00 00       	mov    $0x8,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <link>:
SYSCALL(link)
 404:	b8 13 00 00 00       	mov    $0x13,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <mkdir>:
SYSCALL(mkdir)
 40c:	b8 14 00 00 00       	mov    $0x14,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <chdir>:
SYSCALL(chdir)
 414:	b8 09 00 00 00       	mov    $0x9,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <dup>:
SYSCALL(dup)
 41c:	b8 0a 00 00 00       	mov    $0xa,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <getpid>:
SYSCALL(getpid)
 424:	b8 0b 00 00 00       	mov    $0xb,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <sbrk>:
SYSCALL(sbrk)
 42c:	b8 0c 00 00 00       	mov    $0xc,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <sleep>:
SYSCALL(sleep)
 434:	b8 0d 00 00 00       	mov    $0xd,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <uptime>:
SYSCALL(uptime)
 43c:	b8 0e 00 00 00       	mov    $0xe,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <halt>:
SYSCALL(halt)
 444:	b8 16 00 00 00       	mov    $0x16,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <signal_register>:
SYSCALL(signal_register)
 44c:	b8 17 00 00 00       	mov    $0x17,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <signal_restorer>:
SYSCALL(signal_restorer)
 454:	b8 18 00 00 00       	mov    $0x18,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <mprotect>:
SYSCALL(mprotect)
 45c:	b8 19 00 00 00       	mov    $0x19,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 ec 18             	sub    $0x18,%esp
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 470:	83 ec 04             	sub    $0x4,%esp
 473:	6a 01                	push   $0x1
 475:	8d 45 f4             	lea    -0xc(%ebp),%eax
 478:	50                   	push   %eax
 479:	ff 75 08             	pushl  0x8(%ebp)
 47c:	e8 43 ff ff ff       	call   3c4 <write>
 481:	83 c4 10             	add    $0x10,%esp
}
 484:	90                   	nop
 485:	c9                   	leave  
 486:	c3                   	ret    

00000487 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 487:	55                   	push   %ebp
 488:	89 e5                	mov    %esp,%ebp
 48a:	53                   	push   %ebx
 48b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 48e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 495:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 499:	74 17                	je     4b2 <printint+0x2b>
 49b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 49f:	79 11                	jns    4b2 <printint+0x2b>
    neg = 1;
 4a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ab:	f7 d8                	neg    %eax
 4ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b0:	eb 06                	jmp    4b8 <printint+0x31>
  } else {
    x = xx;
 4b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4bf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4c2:	8d 41 01             	lea    0x1(%ecx),%eax
 4c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ce:	ba 00 00 00 00       	mov    $0x0,%edx
 4d3:	f7 f3                	div    %ebx
 4d5:	89 d0                	mov    %edx,%eax
 4d7:	0f b6 80 90 0c 00 00 	movzbl 0xc90(%eax),%eax
 4de:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e8:	ba 00 00 00 00       	mov    $0x0,%edx
 4ed:	f7 f3                	div    %ebx
 4ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f6:	75 c7                	jne    4bf <printint+0x38>
  if(neg)
 4f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fc:	74 2d                	je     52b <printint+0xa4>
    buf[i++] = '-';
 4fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 501:	8d 50 01             	lea    0x1(%eax),%edx
 504:	89 55 f4             	mov    %edx,-0xc(%ebp)
 507:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 50c:	eb 1d                	jmp    52b <printint+0xa4>
    putc(fd, buf[i]);
 50e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 511:	8b 45 f4             	mov    -0xc(%ebp),%eax
 514:	01 d0                	add    %edx,%eax
 516:	0f b6 00             	movzbl (%eax),%eax
 519:	0f be c0             	movsbl %al,%eax
 51c:	83 ec 08             	sub    $0x8,%esp
 51f:	50                   	push   %eax
 520:	ff 75 08             	pushl  0x8(%ebp)
 523:	e8 3c ff ff ff       	call   464 <putc>
 528:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 52b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 52f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 533:	79 d9                	jns    50e <printint+0x87>
    putc(fd, buf[i]);
}
 535:	90                   	nop
 536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 539:	c9                   	leave  
 53a:	c3                   	ret    

0000053b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 53b:	55                   	push   %ebp
 53c:	89 e5                	mov    %esp,%ebp
 53e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 541:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 548:	8d 45 0c             	lea    0xc(%ebp),%eax
 54b:	83 c0 04             	add    $0x4,%eax
 54e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 551:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 558:	e9 59 01 00 00       	jmp    6b6 <printf+0x17b>
    c = fmt[i] & 0xff;
 55d:	8b 55 0c             	mov    0xc(%ebp),%edx
 560:	8b 45 f0             	mov    -0x10(%ebp),%eax
 563:	01 d0                	add    %edx,%eax
 565:	0f b6 00             	movzbl (%eax),%eax
 568:	0f be c0             	movsbl %al,%eax
 56b:	25 ff 00 00 00       	and    $0xff,%eax
 570:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 573:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 577:	75 2c                	jne    5a5 <printf+0x6a>
      if(c == '%'){
 579:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57d:	75 0c                	jne    58b <printf+0x50>
        state = '%';
 57f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 586:	e9 27 01 00 00       	jmp    6b2 <printf+0x177>
      } else {
        putc(fd, c);
 58b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58e:	0f be c0             	movsbl %al,%eax
 591:	83 ec 08             	sub    $0x8,%esp
 594:	50                   	push   %eax
 595:	ff 75 08             	pushl  0x8(%ebp)
 598:	e8 c7 fe ff ff       	call   464 <putc>
 59d:	83 c4 10             	add    $0x10,%esp
 5a0:	e9 0d 01 00 00       	jmp    6b2 <printf+0x177>
      }
    } else if(state == '%'){
 5a5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5a9:	0f 85 03 01 00 00    	jne    6b2 <printf+0x177>
      if(c == 'd'){
 5af:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b3:	75 1e                	jne    5d3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b8:	8b 00                	mov    (%eax),%eax
 5ba:	6a 01                	push   $0x1
 5bc:	6a 0a                	push   $0xa
 5be:	50                   	push   %eax
 5bf:	ff 75 08             	pushl  0x8(%ebp)
 5c2:	e8 c0 fe ff ff       	call   487 <printint>
 5c7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ce:	e9 d8 00 00 00       	jmp    6ab <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5d3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5d7:	74 06                	je     5df <printf+0xa4>
 5d9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5dd:	75 1e                	jne    5fd <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e2:	8b 00                	mov    (%eax),%eax
 5e4:	6a 00                	push   $0x0
 5e6:	6a 10                	push   $0x10
 5e8:	50                   	push   %eax
 5e9:	ff 75 08             	pushl  0x8(%ebp)
 5ec:	e8 96 fe ff ff       	call   487 <printint>
 5f1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f8:	e9 ae 00 00 00       	jmp    6ab <printf+0x170>
      } else if(c == 's'){
 5fd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 601:	75 43                	jne    646 <printf+0x10b>
        s = (char*)*ap;
 603:	8b 45 e8             	mov    -0x18(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 60b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 60f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 613:	75 25                	jne    63a <printf+0xff>
          s = "(null)";
 615:	c7 45 f4 00 0a 00 00 	movl   $0xa00,-0xc(%ebp)
        while(*s != 0){
 61c:	eb 1c                	jmp    63a <printf+0xff>
          putc(fd, *s);
 61e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 621:	0f b6 00             	movzbl (%eax),%eax
 624:	0f be c0             	movsbl %al,%eax
 627:	83 ec 08             	sub    $0x8,%esp
 62a:	50                   	push   %eax
 62b:	ff 75 08             	pushl  0x8(%ebp)
 62e:	e8 31 fe ff ff       	call   464 <putc>
 633:	83 c4 10             	add    $0x10,%esp
          s++;
 636:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 63a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63d:	0f b6 00             	movzbl (%eax),%eax
 640:	84 c0                	test   %al,%al
 642:	75 da                	jne    61e <printf+0xe3>
 644:	eb 65                	jmp    6ab <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 646:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 64a:	75 1d                	jne    669 <printf+0x12e>
        putc(fd, *ap);
 64c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	0f be c0             	movsbl %al,%eax
 654:	83 ec 08             	sub    $0x8,%esp
 657:	50                   	push   %eax
 658:	ff 75 08             	pushl  0x8(%ebp)
 65b:	e8 04 fe ff ff       	call   464 <putc>
 660:	83 c4 10             	add    $0x10,%esp
        ap++;
 663:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 667:	eb 42                	jmp    6ab <printf+0x170>
      } else if(c == '%'){
 669:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66d:	75 17                	jne    686 <printf+0x14b>
        putc(fd, c);
 66f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 672:	0f be c0             	movsbl %al,%eax
 675:	83 ec 08             	sub    $0x8,%esp
 678:	50                   	push   %eax
 679:	ff 75 08             	pushl  0x8(%ebp)
 67c:	e8 e3 fd ff ff       	call   464 <putc>
 681:	83 c4 10             	add    $0x10,%esp
 684:	eb 25                	jmp    6ab <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 686:	83 ec 08             	sub    $0x8,%esp
 689:	6a 25                	push   $0x25
 68b:	ff 75 08             	pushl  0x8(%ebp)
 68e:	e8 d1 fd ff ff       	call   464 <putc>
 693:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 699:	0f be c0             	movsbl %al,%eax
 69c:	83 ec 08             	sub    $0x8,%esp
 69f:	50                   	push   %eax
 6a0:	ff 75 08             	pushl  0x8(%ebp)
 6a3:	e8 bc fd ff ff       	call   464 <putc>
 6a8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6b6:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bc:	01 d0                	add    %edx,%eax
 6be:	0f b6 00             	movzbl (%eax),%eax
 6c1:	84 c0                	test   %al,%al
 6c3:	0f 85 94 fe ff ff    	jne    55d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c9:	90                   	nop
 6ca:	c9                   	leave  
 6cb:	c3                   	ret    

000006cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cc:	55                   	push   %ebp
 6cd:	89 e5                	mov    %esp,%ebp
 6cf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d2:	8b 45 08             	mov    0x8(%ebp),%eax
 6d5:	83 e8 08             	sub    $0x8,%eax
 6d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6db:	a1 ac 0c 00 00       	mov    0xcac,%eax
 6e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e3:	eb 24                	jmp    709 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ed:	77 12                	ja     701 <free+0x35>
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f5:	77 24                	ja     71b <free+0x4f>
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ff:	77 1a                	ja     71b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	89 45 fc             	mov    %eax,-0x4(%ebp)
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70f:	76 d4                	jbe    6e5 <free+0x19>
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 719:	76 ca                	jbe    6e5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	8b 40 04             	mov    0x4(%eax),%eax
 721:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	01 c2                	add    %eax,%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	39 c2                	cmp    %eax,%edx
 734:	75 24                	jne    75a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	8b 50 04             	mov    0x4(%eax),%edx
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	8b 40 04             	mov    0x4(%eax),%eax
 744:	01 c2                	add    %eax,%edx
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	8b 10                	mov    (%eax),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	89 10                	mov    %edx,(%eax)
 758:	eb 0a                	jmp    764 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 10                	mov    (%eax),%edx
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 40 04             	mov    0x4(%eax),%eax
 76a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	01 d0                	add    %edx,%eax
 776:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 779:	75 20                	jne    79b <free+0xcf>
    p->s.size += bp->s.size;
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 50 04             	mov    0x4(%eax),%edx
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	01 c2                	add    %eax,%edx
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
 799:	eb 08                	jmp    7a3 <free+0xd7>
  } else
    p->s.ptr = bp;
 79b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a1:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	a3 ac 0c 00 00       	mov    %eax,0xcac
}
 7ab:	90                   	nop
 7ac:	c9                   	leave  
 7ad:	c3                   	ret    

000007ae <morecore>:

static Header*
morecore(uint nu)
{
 7ae:	55                   	push   %ebp
 7af:	89 e5                	mov    %esp,%ebp
 7b1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7bb:	77 07                	ja     7c4 <morecore+0x16>
    nu = 4096;
 7bd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c4:	8b 45 08             	mov    0x8(%ebp),%eax
 7c7:	c1 e0 03             	shl    $0x3,%eax
 7ca:	83 ec 0c             	sub    $0xc,%esp
 7cd:	50                   	push   %eax
 7ce:	e8 59 fc ff ff       	call   42c <sbrk>
 7d3:	83 c4 10             	add    $0x10,%esp
 7d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7dd:	75 07                	jne    7e6 <morecore+0x38>
    return 0;
 7df:	b8 00 00 00 00       	mov    $0x0,%eax
 7e4:	eb 26                	jmp    80c <morecore+0x5e>
  hp = (Header*)p;
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ef:	8b 55 08             	mov    0x8(%ebp),%edx
 7f2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f8:	83 c0 08             	add    $0x8,%eax
 7fb:	83 ec 0c             	sub    $0xc,%esp
 7fe:	50                   	push   %eax
 7ff:	e8 c8 fe ff ff       	call   6cc <free>
 804:	83 c4 10             	add    $0x10,%esp
  return freep;
 807:	a1 ac 0c 00 00       	mov    0xcac,%eax
}
 80c:	c9                   	leave  
 80d:	c3                   	ret    

0000080e <malloc>:

void*
malloc(uint nbytes)
{
 80e:	55                   	push   %ebp
 80f:	89 e5                	mov    %esp,%ebp
 811:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	83 c0 07             	add    $0x7,%eax
 81a:	c1 e8 03             	shr    $0x3,%eax
 81d:	83 c0 01             	add    $0x1,%eax
 820:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 823:	a1 ac 0c 00 00       	mov    0xcac,%eax
 828:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82f:	75 23                	jne    854 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 831:	c7 45 f0 a4 0c 00 00 	movl   $0xca4,-0x10(%ebp)
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	a3 ac 0c 00 00       	mov    %eax,0xcac
 840:	a1 ac 0c 00 00       	mov    0xcac,%eax
 845:	a3 a4 0c 00 00       	mov    %eax,0xca4
    base.s.size = 0;
 84a:	c7 05 a8 0c 00 00 00 	movl   $0x0,0xca8
 851:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	8b 40 04             	mov    0x4(%eax),%eax
 862:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 865:	72 4d                	jb     8b4 <malloc+0xa6>
      if(p->s.size == nunits)
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	8b 40 04             	mov    0x4(%eax),%eax
 86d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 870:	75 0c                	jne    87e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	8b 10                	mov    (%eax),%edx
 877:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87a:	89 10                	mov    %edx,(%eax)
 87c:	eb 26                	jmp    8a4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	8b 40 04             	mov    0x4(%eax),%eax
 884:	2b 45 ec             	sub    -0x14(%ebp),%eax
 887:	89 c2                	mov    %eax,%edx
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 40 04             	mov    0x4(%eax),%eax
 895:	c1 e0 03             	shl    $0x3,%eax
 898:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8a1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a7:	a3 ac 0c 00 00       	mov    %eax,0xcac
      return (void*)(p + 1);
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	83 c0 08             	add    $0x8,%eax
 8b2:	eb 3b                	jmp    8ef <malloc+0xe1>
    }
    if(p == freep)
 8b4:	a1 ac 0c 00 00       	mov    0xcac,%eax
 8b9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8bc:	75 1e                	jne    8dc <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8be:	83 ec 0c             	sub    $0xc,%esp
 8c1:	ff 75 ec             	pushl  -0x14(%ebp)
 8c4:	e8 e5 fe ff ff       	call   7ae <morecore>
 8c9:	83 c4 10             	add    $0x10,%esp
 8cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d3:	75 07                	jne    8dc <malloc+0xce>
        return 0;
 8d5:	b8 00 00 00 00       	mov    $0x0,%eax
 8da:	eb 13                	jmp    8ef <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e5:	8b 00                	mov    (%eax),%eax
 8e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8ea:	e9 6d ff ff ff       	jmp    85c <malloc+0x4e>
}
 8ef:	c9                   	leave  
 8f0:	c3                   	ret    
