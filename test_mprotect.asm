
_test_mprotect:     file format elf32-i386


Disassembly of section .text:

00000000 <handler>:
#include "user.h"

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
   e:	68 d4 08 00 00       	push   $0x8d4
  13:	6a 01                	push   $0x1
  15:	e8 02 05 00 00       	call   51c <printf>
  1a:	83 c4 10             	add    $0x10,%esp
	if(info.type == PROT_READ)
  1d:	8b 45 10             	mov    0x10(%ebp),%eax
  20:	83 f8 01             	cmp    $0x1,%eax
  23:	75 39                	jne    5e <handler+0x5e>
	{
		printf(1,"ERROR: Writing to a page with insufficient permission.\n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 08 09 00 00       	push   $0x908
  2d:	6a 01                	push   $0x1
  2f:	e8 e8 04 00 00       	call   51c <printf>
  34:	83 c4 10             	add    $0x10,%esp
		mprotect((void *) info.addr, sizeof(int), PROT_READ | PROT_WRITE);
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	6a 03                	push   $0x3
  3f:	6a 04                	push   $0x4
  41:	50                   	push   %eax
  42:	e8 f6 03 00 00       	call   43d <mprotect>
  47:	83 c4 10             	add    $0x10,%esp
		printf(1,"MPROTECT call finished!\n");
  4a:	83 ec 08             	sub    $0x8,%esp
  4d:	68 40 09 00 00       	push   $0x940
  52:	6a 01                	push   $0x1
  54:	e8 c3 04 00 00       	call   51c <printf>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	eb 17                	jmp    75 <handler+0x75>
	}
	else
	{
		printf(1, "ERROR: Didn't get proper exception, this should not happen.\n");
  5e:	83 ec 08             	sub    $0x8,%esp
  61:	68 5c 09 00 00       	push   $0x95c
  66:	6a 01                	push   $0x1
  68:	e8 af 04 00 00       	call   51c <printf>
  6d:	83 c4 10             	add    $0x10,%esp
		exit();
  70:	e8 10 03 00 00       	call   385 <exit>
	}
	printf(1,"FINISHED IN HANDLER!\n");
  75:	83 ec 08             	sub    $0x8,%esp
  78:	68 99 09 00 00       	push   $0x999
  7d:	6a 01                	push   $0x1
  7f:	e8 98 04 00 00       	call   51c <printf>
  84:	83 c4 10             	add    $0x10,%esp
} 
  87:	90                   	nop
  88:	c9                   	leave  
  89:	c3                   	ret    

0000008a <main>:
int main(void)
{
  8a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  8e:	83 e4 f0             	and    $0xfffffff0,%esp
  91:	ff 71 fc             	pushl  -0x4(%ecx)
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	51                   	push   %ecx
  98:	83 ec 04             	sub    $0x4,%esp
	signal(SIGSEGV, handler);
  9b:	83 ec 08             	sub    $0x8,%esp
  9e:	68 00 00 00 00       	push   $0x0
  a3:	6a 02                	push   $0x2
  a5:	e8 aa 02 00 00       	call   354 <signal>
  aa:	83 c4 10             	add    $0x10,%esp
 	p = (int *) sbrk(1);
  ad:	83 ec 0c             	sub    $0xc,%esp
  b0:	6a 01                	push   $0x1
  b2:	e8 56 03 00 00       	call   40d <sbrk>
  b7:	83 c4 10             	add    $0x10,%esp
  ba:	a3 88 0c 00 00       	mov    %eax,0xc88
 	mprotect((void *)p, sizeof(int), PROT_READ);
  bf:	a1 88 0c 00 00       	mov    0xc88,%eax
  c4:	83 ec 04             	sub    $0x4,%esp
  c7:	6a 01                	push   $0x1
  c9:	6a 04                	push   $0x4
  cb:	50                   	push   %eax
  cc:	e8 6c 03 00 00       	call   43d <mprotect>
  d1:	83 c4 10             	add    $0x10,%esp
 	*p=100;
  d4:	a1 88 0c 00 00       	mov    0xc88,%eax
  d9:	c7 00 64 00 00 00    	movl   $0x64,(%eax)
 	printf(1, "COMPLETED: value is %d, expecting 100!\n", *p);
  df:	a1 88 0c 00 00       	mov    0xc88,%eax
  e4:	8b 00                	mov    (%eax),%eax
  e6:	83 ec 04             	sub    $0x4,%esp
  e9:	50                   	push   %eax
  ea:	68 b0 09 00 00       	push   $0x9b0
  ef:	6a 01                	push   $0x1
  f1:	e8 26 04 00 00       	call   51c <printf>
  f6:	83 c4 10             	add    $0x10,%esp
 	
 	exit();
  f9:	e8 87 02 00 00       	call   385 <exit>

000000fe <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	57                   	push   %edi
 102:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 103:	8b 4d 08             	mov    0x8(%ebp),%ecx
 106:	8b 55 10             	mov    0x10(%ebp),%edx
 109:	8b 45 0c             	mov    0xc(%ebp),%eax
 10c:	89 cb                	mov    %ecx,%ebx
 10e:	89 df                	mov    %ebx,%edi
 110:	89 d1                	mov    %edx,%ecx
 112:	fc                   	cld    
 113:	f3 aa                	rep stos %al,%es:(%edi)
 115:	89 ca                	mov    %ecx,%edx
 117:	89 fb                	mov    %edi,%ebx
 119:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 11f:	90                   	nop
 120:	5b                   	pop    %ebx
 121:	5f                   	pop    %edi
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
 12d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 130:	90                   	nop
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	8d 50 01             	lea    0x1(%eax),%edx
 137:	89 55 08             	mov    %edx,0x8(%ebp)
 13a:	8b 55 0c             	mov    0xc(%ebp),%edx
 13d:	8d 4a 01             	lea    0x1(%edx),%ecx
 140:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 143:	0f b6 12             	movzbl (%edx),%edx
 146:	88 10                	mov    %dl,(%eax)
 148:	0f b6 00             	movzbl (%eax),%eax
 14b:	84 c0                	test   %al,%al
 14d:	75 e2                	jne    131 <strcpy+0xd>
    ;
  return os;
 14f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 157:	eb 08                	jmp    161 <strcmp+0xd>
    p++, q++;
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	0f b6 00             	movzbl (%eax),%eax
 167:	84 c0                	test   %al,%al
 169:	74 10                	je     17b <strcmp+0x27>
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 10             	movzbl (%eax),%edx
 171:	8b 45 0c             	mov    0xc(%ebp),%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	38 c2                	cmp    %al,%dl
 179:	74 de                	je     159 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	0f b6 00             	movzbl (%eax),%eax
 181:	0f b6 d0             	movzbl %al,%edx
 184:	8b 45 0c             	mov    0xc(%ebp),%eax
 187:	0f b6 00             	movzbl (%eax),%eax
 18a:	0f b6 c0             	movzbl %al,%eax
 18d:	29 c2                	sub    %eax,%edx
 18f:	89 d0                	mov    %edx,%eax
}
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    

00000193 <strlen>:

uint
strlen(char *s)
{
 193:	55                   	push   %ebp
 194:	89 e5                	mov    %esp,%ebp
 196:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 199:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a0:	eb 04                	jmp    1a6 <strlen+0x13>
 1a2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	01 d0                	add    %edx,%eax
 1ae:	0f b6 00             	movzbl (%eax),%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	75 ed                	jne    1a2 <strlen+0xf>
    ;
  return n;
 1b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    

000001ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1bd:	8b 45 10             	mov    0x10(%ebp),%eax
 1c0:	50                   	push   %eax
 1c1:	ff 75 0c             	pushl  0xc(%ebp)
 1c4:	ff 75 08             	pushl  0x8(%ebp)
 1c7:	e8 32 ff ff ff       	call   fe <stosb>
 1cc:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d2:	c9                   	leave  
 1d3:	c3                   	ret    

000001d4 <strchr>:

char*
strchr(const char *s, char c)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	83 ec 04             	sub    $0x4,%esp
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e0:	eb 14                	jmp    1f6 <strchr+0x22>
    if(*s == c)
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	0f b6 00             	movzbl (%eax),%eax
 1e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1eb:	75 05                	jne    1f2 <strchr+0x1e>
      return (char*)s;
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
 1f0:	eb 13                	jmp    205 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	0f b6 00             	movzbl (%eax),%eax
 1fc:	84 c0                	test   %al,%al
 1fe:	75 e2                	jne    1e2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 200:	b8 00 00 00 00       	mov    $0x0,%eax
}
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <gets>:

char*
gets(char *buf, int max)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 214:	eb 42                	jmp    258 <gets+0x51>
    cc = read(0, &c, 1);
 216:	83 ec 04             	sub    $0x4,%esp
 219:	6a 01                	push   $0x1
 21b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 21e:	50                   	push   %eax
 21f:	6a 00                	push   $0x0
 221:	e8 77 01 00 00       	call   39d <read>
 226:	83 c4 10             	add    $0x10,%esp
 229:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 230:	7e 33                	jle    265 <gets+0x5e>
      break;
    buf[i++] = c;
 232:	8b 45 f4             	mov    -0xc(%ebp),%eax
 235:	8d 50 01             	lea    0x1(%eax),%edx
 238:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23b:	89 c2                	mov    %eax,%edx
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	01 c2                	add    %eax,%edx
 242:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 246:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 248:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24c:	3c 0a                	cmp    $0xa,%al
 24e:	74 16                	je     266 <gets+0x5f>
 250:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 254:	3c 0d                	cmp    $0xd,%al
 256:	74 0e                	je     266 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 258:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25b:	83 c0 01             	add    $0x1,%eax
 25e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 261:	7c b3                	jl     216 <gets+0xf>
 263:	eb 01                	jmp    266 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 265:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 266:	8b 55 f4             	mov    -0xc(%ebp),%edx
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	01 d0                	add    %edx,%eax
 26e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 271:	8b 45 08             	mov    0x8(%ebp),%eax
}
 274:	c9                   	leave  
 275:	c3                   	ret    

00000276 <stat>:

int
stat(char *n, struct stat *st)
{
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27c:	83 ec 08             	sub    $0x8,%esp
 27f:	6a 00                	push   $0x0
 281:	ff 75 08             	pushl  0x8(%ebp)
 284:	e8 3c 01 00 00       	call   3c5 <open>
 289:	83 c4 10             	add    $0x10,%esp
 28c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 28f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 293:	79 07                	jns    29c <stat+0x26>
    return -1;
 295:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29a:	eb 25                	jmp    2c1 <stat+0x4b>
  r = fstat(fd, st);
 29c:	83 ec 08             	sub    $0x8,%esp
 29f:	ff 75 0c             	pushl  0xc(%ebp)
 2a2:	ff 75 f4             	pushl  -0xc(%ebp)
 2a5:	e8 33 01 00 00       	call   3dd <fstat>
 2aa:	83 c4 10             	add    $0x10,%esp
 2ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b0:	83 ec 0c             	sub    $0xc,%esp
 2b3:	ff 75 f4             	pushl  -0xc(%ebp)
 2b6:	e8 f2 00 00 00       	call   3ad <close>
 2bb:	83 c4 10             	add    $0x10,%esp
  return r;
 2be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <atoi>:

int
atoi(const char *s)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2d0:	eb 25                	jmp    2f7 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d5:	89 d0                	mov    %edx,%eax
 2d7:	c1 e0 02             	shl    $0x2,%eax
 2da:	01 d0                	add    %edx,%eax
 2dc:	01 c0                	add    %eax,%eax
 2de:	89 c1                	mov    %eax,%ecx
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	8d 50 01             	lea    0x1(%eax),%edx
 2e6:	89 55 08             	mov    %edx,0x8(%ebp)
 2e9:	0f b6 00             	movzbl (%eax),%eax
 2ec:	0f be c0             	movsbl %al,%eax
 2ef:	01 c8                	add    %ecx,%eax
 2f1:	83 e8 30             	sub    $0x30,%eax
 2f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	3c 2f                	cmp    $0x2f,%al
 2ff:	7e 0a                	jle    30b <atoi+0x48>
 301:	8b 45 08             	mov    0x8(%ebp),%eax
 304:	0f b6 00             	movzbl (%eax),%eax
 307:	3c 39                	cmp    $0x39,%al
 309:	7e c7                	jle    2d2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 30b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 30e:	c9                   	leave  
 30f:	c3                   	ret    

00000310 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31c:	8b 45 0c             	mov    0xc(%ebp),%eax
 31f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 322:	eb 17                	jmp    33b <memmove+0x2b>
    *dst++ = *src++;
 324:	8b 45 fc             	mov    -0x4(%ebp),%eax
 327:	8d 50 01             	lea    0x1(%eax),%edx
 32a:	89 55 fc             	mov    %edx,-0x4(%ebp)
 32d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 330:	8d 4a 01             	lea    0x1(%edx),%ecx
 333:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 336:	0f b6 12             	movzbl (%edx),%edx
 339:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33b:	8b 45 10             	mov    0x10(%ebp),%eax
 33e:	8d 50 ff             	lea    -0x1(%eax),%edx
 341:	89 55 10             	mov    %edx,0x10(%ebp)
 344:	85 c0                	test   %eax,%eax
 346:	7f dc                	jg     324 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 348:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34b:	c9                   	leave  
 34c:	c3                   	ret    

0000034d <restorer>:
 34d:	83 c4 0c             	add    $0xc,%esp
 350:	5a                   	pop    %edx
 351:	59                   	pop    %ecx
 352:	58                   	pop    %eax
 353:	c3                   	ret    

00000354 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int,siginfo_t))
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 35a:	83 ec 0c             	sub    $0xc,%esp
 35d:	68 4d 03 00 00       	push   $0x34d
 362:	e8 ce 00 00 00       	call   435 <signal_restorer>
 367:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 36a:	83 ec 08             	sub    $0x8,%esp
 36d:	ff 75 0c             	pushl  0xc(%ebp)
 370:	ff 75 08             	pushl  0x8(%ebp)
 373:	e8 b5 00 00 00       	call   42d <signal_register>
 378:	83 c4 10             	add    $0x10,%esp
}
 37b:	c9                   	leave  
 37c:	c3                   	ret    

0000037d <fork>:
 37d:	b8 01 00 00 00       	mov    $0x1,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <exit>:
 385:	b8 02 00 00 00       	mov    $0x2,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <wait>:
 38d:	b8 03 00 00 00       	mov    $0x3,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <pipe>:
 395:	b8 04 00 00 00       	mov    $0x4,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <read>:
 39d:	b8 05 00 00 00       	mov    $0x5,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <write>:
 3a5:	b8 10 00 00 00       	mov    $0x10,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <close>:
 3ad:	b8 15 00 00 00       	mov    $0x15,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <kill>:
 3b5:	b8 06 00 00 00       	mov    $0x6,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <exec>:
 3bd:	b8 07 00 00 00       	mov    $0x7,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <open>:
 3c5:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <mknod>:
 3cd:	b8 11 00 00 00       	mov    $0x11,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <unlink>:
 3d5:	b8 12 00 00 00       	mov    $0x12,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <fstat>:
 3dd:	b8 08 00 00 00       	mov    $0x8,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <link>:
 3e5:	b8 13 00 00 00       	mov    $0x13,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <mkdir>:
 3ed:	b8 14 00 00 00       	mov    $0x14,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <chdir>:
 3f5:	b8 09 00 00 00       	mov    $0x9,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <dup>:
 3fd:	b8 0a 00 00 00       	mov    $0xa,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <getpid>:
 405:	b8 0b 00 00 00       	mov    $0xb,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <sbrk>:
 40d:	b8 0c 00 00 00       	mov    $0xc,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <sleep>:
 415:	b8 0d 00 00 00       	mov    $0xd,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <uptime>:
 41d:	b8 0e 00 00 00       	mov    $0xe,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <halt>:
 425:	b8 16 00 00 00       	mov    $0x16,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <signal_register>:
 42d:	b8 17 00 00 00       	mov    $0x17,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <signal_restorer>:
 435:	b8 18 00 00 00       	mov    $0x18,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <mprotect>:
 43d:	b8 19 00 00 00       	mov    $0x19,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 445:	55                   	push   %ebp
 446:	89 e5                	mov    %esp,%ebp
 448:	83 ec 18             	sub    $0x18,%esp
 44b:	8b 45 0c             	mov    0xc(%ebp),%eax
 44e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 451:	83 ec 04             	sub    $0x4,%esp
 454:	6a 01                	push   $0x1
 456:	8d 45 f4             	lea    -0xc(%ebp),%eax
 459:	50                   	push   %eax
 45a:	ff 75 08             	pushl  0x8(%ebp)
 45d:	e8 43 ff ff ff       	call   3a5 <write>
 462:	83 c4 10             	add    $0x10,%esp
}
 465:	90                   	nop
 466:	c9                   	leave  
 467:	c3                   	ret    

00000468 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 468:	55                   	push   %ebp
 469:	89 e5                	mov    %esp,%ebp
 46b:	53                   	push   %ebx
 46c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 46f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 476:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 47a:	74 17                	je     493 <printint+0x2b>
 47c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 480:	79 11                	jns    493 <printint+0x2b>
    neg = 1;
 482:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 489:	8b 45 0c             	mov    0xc(%ebp),%eax
 48c:	f7 d8                	neg    %eax
 48e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 491:	eb 06                	jmp    499 <printint+0x31>
  } else {
    x = xx;
 493:	8b 45 0c             	mov    0xc(%ebp),%eax
 496:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 499:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4a3:	8d 41 01             	lea    0x1(%ecx),%eax
 4a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4af:	ba 00 00 00 00       	mov    $0x0,%edx
 4b4:	f7 f3                	div    %ebx
 4b6:	89 d0                	mov    %edx,%eax
 4b8:	0f b6 80 68 0c 00 00 	movzbl 0xc68(%eax),%eax
 4bf:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c9:	ba 00 00 00 00       	mov    $0x0,%edx
 4ce:	f7 f3                	div    %ebx
 4d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d7:	75 c7                	jne    4a0 <printint+0x38>
  if(neg)
 4d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4dd:	74 2d                	je     50c <printint+0xa4>
    buf[i++] = '-';
 4df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e2:	8d 50 01             	lea    0x1(%eax),%edx
 4e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ed:	eb 1d                	jmp    50c <printint+0xa4>
    putc(fd, buf[i]);
 4ef:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f5:	01 d0                	add    %edx,%eax
 4f7:	0f b6 00             	movzbl (%eax),%eax
 4fa:	0f be c0             	movsbl %al,%eax
 4fd:	83 ec 08             	sub    $0x8,%esp
 500:	50                   	push   %eax
 501:	ff 75 08             	pushl  0x8(%ebp)
 504:	e8 3c ff ff ff       	call   445 <putc>
 509:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 50c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 510:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 514:	79 d9                	jns    4ef <printint+0x87>
    putc(fd, buf[i]);
}
 516:	90                   	nop
 517:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 51a:	c9                   	leave  
 51b:	c3                   	ret    

0000051c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 51c:	55                   	push   %ebp
 51d:	89 e5                	mov    %esp,%ebp
 51f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 522:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 529:	8d 45 0c             	lea    0xc(%ebp),%eax
 52c:	83 c0 04             	add    $0x4,%eax
 52f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 532:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 539:	e9 59 01 00 00       	jmp    697 <printf+0x17b>
    c = fmt[i] & 0xff;
 53e:	8b 55 0c             	mov    0xc(%ebp),%edx
 541:	8b 45 f0             	mov    -0x10(%ebp),%eax
 544:	01 d0                	add    %edx,%eax
 546:	0f b6 00             	movzbl (%eax),%eax
 549:	0f be c0             	movsbl %al,%eax
 54c:	25 ff 00 00 00       	and    $0xff,%eax
 551:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 554:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 558:	75 2c                	jne    586 <printf+0x6a>
      if(c == '%'){
 55a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55e:	75 0c                	jne    56c <printf+0x50>
        state = '%';
 560:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 567:	e9 27 01 00 00       	jmp    693 <printf+0x177>
      } else {
        putc(fd, c);
 56c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56f:	0f be c0             	movsbl %al,%eax
 572:	83 ec 08             	sub    $0x8,%esp
 575:	50                   	push   %eax
 576:	ff 75 08             	pushl  0x8(%ebp)
 579:	e8 c7 fe ff ff       	call   445 <putc>
 57e:	83 c4 10             	add    $0x10,%esp
 581:	e9 0d 01 00 00       	jmp    693 <printf+0x177>
      }
    } else if(state == '%'){
 586:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 58a:	0f 85 03 01 00 00    	jne    693 <printf+0x177>
      if(c == 'd'){
 590:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 594:	75 1e                	jne    5b4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 596:	8b 45 e8             	mov    -0x18(%ebp),%eax
 599:	8b 00                	mov    (%eax),%eax
 59b:	6a 01                	push   $0x1
 59d:	6a 0a                	push   $0xa
 59f:	50                   	push   %eax
 5a0:	ff 75 08             	pushl  0x8(%ebp)
 5a3:	e8 c0 fe ff ff       	call   468 <printint>
 5a8:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5af:	e9 d8 00 00 00       	jmp    68c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5b4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5b8:	74 06                	je     5c0 <printf+0xa4>
 5ba:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5be:	75 1e                	jne    5de <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	6a 00                	push   $0x0
 5c7:	6a 10                	push   $0x10
 5c9:	50                   	push   %eax
 5ca:	ff 75 08             	pushl  0x8(%ebp)
 5cd:	e8 96 fe ff ff       	call   468 <printint>
 5d2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d9:	e9 ae 00 00 00       	jmp    68c <printf+0x170>
      } else if(c == 's'){
 5de:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e2:	75 43                	jne    627 <printf+0x10b>
        s = (char*)*ap;
 5e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e7:	8b 00                	mov    (%eax),%eax
 5e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f4:	75 25                	jne    61b <printf+0xff>
          s = "(null)";
 5f6:	c7 45 f4 d8 09 00 00 	movl   $0x9d8,-0xc(%ebp)
        while(*s != 0){
 5fd:	eb 1c                	jmp    61b <printf+0xff>
          putc(fd, *s);
 5ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 602:	0f b6 00             	movzbl (%eax),%eax
 605:	0f be c0             	movsbl %al,%eax
 608:	83 ec 08             	sub    $0x8,%esp
 60b:	50                   	push   %eax
 60c:	ff 75 08             	pushl  0x8(%ebp)
 60f:	e8 31 fe ff ff       	call   445 <putc>
 614:	83 c4 10             	add    $0x10,%esp
          s++;
 617:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 61b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61e:	0f b6 00             	movzbl (%eax),%eax
 621:	84 c0                	test   %al,%al
 623:	75 da                	jne    5ff <printf+0xe3>
 625:	eb 65                	jmp    68c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 627:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 62b:	75 1d                	jne    64a <printf+0x12e>
        putc(fd, *ap);
 62d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 630:	8b 00                	mov    (%eax),%eax
 632:	0f be c0             	movsbl %al,%eax
 635:	83 ec 08             	sub    $0x8,%esp
 638:	50                   	push   %eax
 639:	ff 75 08             	pushl  0x8(%ebp)
 63c:	e8 04 fe ff ff       	call   445 <putc>
 641:	83 c4 10             	add    $0x10,%esp
        ap++;
 644:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 648:	eb 42                	jmp    68c <printf+0x170>
      } else if(c == '%'){
 64a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64e:	75 17                	jne    667 <printf+0x14b>
        putc(fd, c);
 650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 653:	0f be c0             	movsbl %al,%eax
 656:	83 ec 08             	sub    $0x8,%esp
 659:	50                   	push   %eax
 65a:	ff 75 08             	pushl  0x8(%ebp)
 65d:	e8 e3 fd ff ff       	call   445 <putc>
 662:	83 c4 10             	add    $0x10,%esp
 665:	eb 25                	jmp    68c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 667:	83 ec 08             	sub    $0x8,%esp
 66a:	6a 25                	push   $0x25
 66c:	ff 75 08             	pushl  0x8(%ebp)
 66f:	e8 d1 fd ff ff       	call   445 <putc>
 674:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 677:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67a:	0f be c0             	movsbl %al,%eax
 67d:	83 ec 08             	sub    $0x8,%esp
 680:	50                   	push   %eax
 681:	ff 75 08             	pushl  0x8(%ebp)
 684:	e8 bc fd ff ff       	call   445 <putc>
 689:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 68c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 693:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 697:	8b 55 0c             	mov    0xc(%ebp),%edx
 69a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 69d:	01 d0                	add    %edx,%eax
 69f:	0f b6 00             	movzbl (%eax),%eax
 6a2:	84 c0                	test   %al,%al
 6a4:	0f 85 94 fe ff ff    	jne    53e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6aa:	90                   	nop
 6ab:	c9                   	leave  
 6ac:	c3                   	ret    

000006ad <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ad:	55                   	push   %ebp
 6ae:	89 e5                	mov    %esp,%ebp
 6b0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b3:	8b 45 08             	mov    0x8(%ebp),%eax
 6b6:	83 e8 08             	sub    $0x8,%eax
 6b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bc:	a1 84 0c 00 00       	mov    0xc84,%eax
 6c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c4:	eb 24                	jmp    6ea <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 00                	mov    (%eax),%eax
 6cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ce:	77 12                	ja     6e2 <free+0x35>
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d6:	77 24                	ja     6fc <free+0x4f>
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	8b 00                	mov    (%eax),%eax
 6dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e0:	77 1a                	ja     6fc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	8b 00                	mov    (%eax),%eax
 6e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f0:	76 d4                	jbe    6c6 <free+0x19>
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 00                	mov    (%eax),%eax
 6f7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fa:	76 ca                	jbe    6c6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ff:	8b 40 04             	mov    0x4(%eax),%eax
 702:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	01 c2                	add    %eax,%edx
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 00                	mov    (%eax),%eax
 713:	39 c2                	cmp    %eax,%edx
 715:	75 24                	jne    73b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	8b 50 04             	mov    0x4(%eax),%edx
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	8b 40 04             	mov    0x4(%eax),%eax
 725:	01 c2                	add    %eax,%edx
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	8b 10                	mov    (%eax),%edx
 734:	8b 45 f8             	mov    -0x8(%ebp),%eax
 737:	89 10                	mov    %edx,(%eax)
 739:	eb 0a                	jmp    745 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 10                	mov    (%eax),%edx
 740:	8b 45 f8             	mov    -0x8(%ebp),%eax
 743:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 40 04             	mov    0x4(%eax),%eax
 74b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 752:	8b 45 fc             	mov    -0x4(%ebp),%eax
 755:	01 d0                	add    %edx,%eax
 757:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75a:	75 20                	jne    77c <free+0xcf>
    p->s.size += bp->s.size;
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	8b 50 04             	mov    0x4(%eax),%edx
 762:	8b 45 f8             	mov    -0x8(%ebp),%eax
 765:	8b 40 04             	mov    0x4(%eax),%eax
 768:	01 c2                	add    %eax,%edx
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 770:	8b 45 f8             	mov    -0x8(%ebp),%eax
 773:	8b 10                	mov    (%eax),%edx
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	89 10                	mov    %edx,(%eax)
 77a:	eb 08                	jmp    784 <free+0xd7>
  } else
    p->s.ptr = bp;
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 782:	89 10                	mov    %edx,(%eax)
  freep = p;
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	a3 84 0c 00 00       	mov    %eax,0xc84
}
 78c:	90                   	nop
 78d:	c9                   	leave  
 78e:	c3                   	ret    

0000078f <morecore>:

static Header*
morecore(uint nu)
{
 78f:	55                   	push   %ebp
 790:	89 e5                	mov    %esp,%ebp
 792:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 795:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 79c:	77 07                	ja     7a5 <morecore+0x16>
    nu = 4096;
 79e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a5:	8b 45 08             	mov    0x8(%ebp),%eax
 7a8:	c1 e0 03             	shl    $0x3,%eax
 7ab:	83 ec 0c             	sub    $0xc,%esp
 7ae:	50                   	push   %eax
 7af:	e8 59 fc ff ff       	call   40d <sbrk>
 7b4:	83 c4 10             	add    $0x10,%esp
 7b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ba:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7be:	75 07                	jne    7c7 <morecore+0x38>
    return 0;
 7c0:	b8 00 00 00 00       	mov    $0x0,%eax
 7c5:	eb 26                	jmp    7ed <morecore+0x5e>
  hp = (Header*)p;
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d0:	8b 55 08             	mov    0x8(%ebp),%edx
 7d3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d9:	83 c0 08             	add    $0x8,%eax
 7dc:	83 ec 0c             	sub    $0xc,%esp
 7df:	50                   	push   %eax
 7e0:	e8 c8 fe ff ff       	call   6ad <free>
 7e5:	83 c4 10             	add    $0x10,%esp
  return freep;
 7e8:	a1 84 0c 00 00       	mov    0xc84,%eax
}
 7ed:	c9                   	leave  
 7ee:	c3                   	ret    

000007ef <malloc>:

void*
malloc(uint nbytes)
{
 7ef:	55                   	push   %ebp
 7f0:	89 e5                	mov    %esp,%ebp
 7f2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f5:	8b 45 08             	mov    0x8(%ebp),%eax
 7f8:	83 c0 07             	add    $0x7,%eax
 7fb:	c1 e8 03             	shr    $0x3,%eax
 7fe:	83 c0 01             	add    $0x1,%eax
 801:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 804:	a1 84 0c 00 00       	mov    0xc84,%eax
 809:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 810:	75 23                	jne    835 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 812:	c7 45 f0 7c 0c 00 00 	movl   $0xc7c,-0x10(%ebp)
 819:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81c:	a3 84 0c 00 00       	mov    %eax,0xc84
 821:	a1 84 0c 00 00       	mov    0xc84,%eax
 826:	a3 7c 0c 00 00       	mov    %eax,0xc7c
    base.s.size = 0;
 82b:	c7 05 80 0c 00 00 00 	movl   $0x0,0xc80
 832:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 835:	8b 45 f0             	mov    -0x10(%ebp),%eax
 838:	8b 00                	mov    (%eax),%eax
 83a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	8b 40 04             	mov    0x4(%eax),%eax
 843:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 846:	72 4d                	jb     895 <malloc+0xa6>
      if(p->s.size == nunits)
 848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84b:	8b 40 04             	mov    0x4(%eax),%eax
 84e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 851:	75 0c                	jne    85f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 10                	mov    (%eax),%edx
 858:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85b:	89 10                	mov    %edx,(%eax)
 85d:	eb 26                	jmp    885 <malloc+0x96>
      else {
        p->s.size -= nunits;
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	8b 40 04             	mov    0x4(%eax),%eax
 865:	2b 45 ec             	sub    -0x14(%ebp),%eax
 868:	89 c2                	mov    %eax,%edx
 86a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	8b 40 04             	mov    0x4(%eax),%eax
 876:	c1 e0 03             	shl    $0x3,%eax
 879:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 882:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 885:	8b 45 f0             	mov    -0x10(%ebp),%eax
 888:	a3 84 0c 00 00       	mov    %eax,0xc84
      return (void*)(p + 1);
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	83 c0 08             	add    $0x8,%eax
 893:	eb 3b                	jmp    8d0 <malloc+0xe1>
    }
    if(p == freep)
 895:	a1 84 0c 00 00       	mov    0xc84,%eax
 89a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 89d:	75 1e                	jne    8bd <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 89f:	83 ec 0c             	sub    $0xc,%esp
 8a2:	ff 75 ec             	pushl  -0x14(%ebp)
 8a5:	e8 e5 fe ff ff       	call   78f <morecore>
 8aa:	83 c4 10             	add    $0x10,%esp
 8ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b4:	75 07                	jne    8bd <malloc+0xce>
        return 0;
 8b6:	b8 00 00 00 00       	mov    $0x0,%eax
 8bb:	eb 13                	jmp    8d0 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	8b 00                	mov    (%eax),%eax
 8c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8cb:	e9 6d ff ff ff       	jmp    83d <malloc+0x4e>
}
 8d0:	c9                   	leave  
 8d1:	c3                   	ret    
