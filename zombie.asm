
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 95 02 00 00       	call   2ab <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 1f 03 00 00       	call   343 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 87 02 00 00       	call   2b3 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret    

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8d 50 01             	lea    0x1(%eax),%edx
  65:	89 55 08             	mov    %edx,0x8(%ebp)
  68:	8b 55 0c             	mov    0xc(%ebp),%edx
  6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strlen>:

uint
strlen(char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	pushl  0xc(%ebp)
  f2:	ff 75 08             	pushl  0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 77 01 00 00       	call   2cb <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18f:	7c b3                	jl     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 193:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <stat>:

int
stat(char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	pushl  0x8(%ebp)
 1b2:	e8 3c 01 00 00       	call   2f3 <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	pushl  0xc(%ebp)
 1d0:	ff 75 f4             	pushl  -0xc(%ebp)
 1d3:	e8 33 01 00 00       	call   30b <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	pushl  -0xc(%ebp)
 1e4:	e8 f2 00 00 00       	call   2db <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fe:	eb 25                	jmp    225 <atoi+0x34>
    n = n*10 + *s++ - '0';
 200:	8b 55 fc             	mov    -0x4(%ebp),%edx
 203:	89 d0                	mov    %edx,%eax
 205:	c1 e0 02             	shl    $0x2,%eax
 208:	01 d0                	add    %edx,%eax
 20a:	01 c0                	add    %eax,%eax
 20c:	89 c1                	mov    %eax,%ecx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8d 50 01             	lea    0x1(%eax),%edx
 214:	89 55 08             	mov    %edx,0x8(%ebp)
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	0f be c0             	movsbl %al,%eax
 21d:	01 c8                	add    %ecx,%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	3c 2f                	cmp    $0x2f,%al
 22d:	7e 0a                	jle    239 <atoi+0x48>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3c 39                	cmp    $0x39,%al
 237:	7e c7                	jle    200 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 239:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 250:	eb 17                	jmp    269 <memmove+0x2b>
    *dst++ = *src++;
 252:	8b 45 fc             	mov    -0x4(%ebp),%eax
 255:	8d 50 01             	lea    0x1(%eax),%edx
 258:	89 55 fc             	mov    %edx,-0x4(%ebp)
 25b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 25e:	8d 4a 01             	lea    0x1(%edx),%ecx
 261:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 264:	0f b6 12             	movzbl (%edx),%edx
 267:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 269:	8b 45 10             	mov    0x10(%ebp),%eax
 26c:	8d 50 ff             	lea    -0x1(%eax),%edx
 26f:	89 55 10             	mov    %edx,0x10(%ebp)
 272:	85 c0                	test   %eax,%eax
 274:	7f dc                	jg     252 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 276:	8b 45 08             	mov    0x8(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <restorer>:
 27b:	83 c4 0c             	add    $0xc,%esp
 27e:	5a                   	pop    %edx
 27f:	59                   	pop    %ecx
 280:	58                   	pop    %eax
 281:	c3                   	ret    

00000282 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 288:	83 ec 0c             	sub    $0xc,%esp
 28b:	68 7b 02 00 00       	push   $0x27b
 290:	e8 ce 00 00 00       	call   363 <signal_restorer>
 295:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 298:	83 ec 08             	sub    $0x8,%esp
 29b:	ff 75 0c             	pushl  0xc(%ebp)
 29e:	ff 75 08             	pushl  0x8(%ebp)
 2a1:	e8 b5 00 00 00       	call   35b <signal_register>
 2a6:	83 c4 10             	add    $0x10,%esp
}
 2a9:	c9                   	leave  
 2aa:	c3                   	ret    

000002ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ab:	b8 01 00 00 00       	mov    $0x1,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <exit>:
SYSCALL(exit)
 2b3:	b8 02 00 00 00       	mov    $0x2,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <wait>:
SYSCALL(wait)
 2bb:	b8 03 00 00 00       	mov    $0x3,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <pipe>:
SYSCALL(pipe)
 2c3:	b8 04 00 00 00       	mov    $0x4,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <read>:
SYSCALL(read)
 2cb:	b8 05 00 00 00       	mov    $0x5,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <write>:
SYSCALL(write)
 2d3:	b8 10 00 00 00       	mov    $0x10,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <close>:
SYSCALL(close)
 2db:	b8 15 00 00 00       	mov    $0x15,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <kill>:
SYSCALL(kill)
 2e3:	b8 06 00 00 00       	mov    $0x6,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <exec>:
SYSCALL(exec)
 2eb:	b8 07 00 00 00       	mov    $0x7,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <open>:
SYSCALL(open)
 2f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <mknod>:
SYSCALL(mknod)
 2fb:	b8 11 00 00 00       	mov    $0x11,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <unlink>:
SYSCALL(unlink)
 303:	b8 12 00 00 00       	mov    $0x12,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <fstat>:
SYSCALL(fstat)
 30b:	b8 08 00 00 00       	mov    $0x8,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <link>:
SYSCALL(link)
 313:	b8 13 00 00 00       	mov    $0x13,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mkdir>:
SYSCALL(mkdir)
 31b:	b8 14 00 00 00       	mov    $0x14,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <chdir>:
SYSCALL(chdir)
 323:	b8 09 00 00 00       	mov    $0x9,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <dup>:
SYSCALL(dup)
 32b:	b8 0a 00 00 00       	mov    $0xa,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <getpid>:
SYSCALL(getpid)
 333:	b8 0b 00 00 00       	mov    $0xb,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <sbrk>:
SYSCALL(sbrk)
 33b:	b8 0c 00 00 00       	mov    $0xc,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <sleep>:
SYSCALL(sleep)
 343:	b8 0d 00 00 00       	mov    $0xd,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <uptime>:
SYSCALL(uptime)
 34b:	b8 0e 00 00 00       	mov    $0xe,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <halt>:
SYSCALL(halt)
 353:	b8 16 00 00 00       	mov    $0x16,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <signal_register>:
SYSCALL(signal_register)
 35b:	b8 17 00 00 00       	mov    $0x17,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <signal_restorer>:
SYSCALL(signal_restorer)
 363:	b8 18 00 00 00       	mov    $0x18,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <mprotect>:
SYSCALL(mprotect)
 36b:	b8 19 00 00 00       	mov    $0x19,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <cowfork>:
SYSCALL(cowfork)
 373:	b8 1a 00 00 00       	mov    $0x1a,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp
 37e:	83 ec 18             	sub    $0x18,%esp
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 387:	83 ec 04             	sub    $0x4,%esp
 38a:	6a 01                	push   $0x1
 38c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 38f:	50                   	push   %eax
 390:	ff 75 08             	pushl  0x8(%ebp)
 393:	e8 3b ff ff ff       	call   2d3 <write>
 398:	83 c4 10             	add    $0x10,%esp
}
 39b:	90                   	nop
 39c:	c9                   	leave  
 39d:	c3                   	ret    

0000039e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39e:	55                   	push   %ebp
 39f:	89 e5                	mov    %esp,%ebp
 3a1:	53                   	push   %ebx
 3a2:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ac:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b0:	74 17                	je     3c9 <printint+0x2b>
 3b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b6:	79 11                	jns    3c9 <printint+0x2b>
    neg = 1;
 3b8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c2:	f7 d8                	neg    %eax
 3c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c7:	eb 06                	jmp    3cf <printint+0x31>
  } else {
    x = xx;
 3c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3d9:	8d 41 01             	lea    0x1(%ecx),%eax
 3dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3df:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e5:	ba 00 00 00 00       	mov    $0x0,%edx
 3ea:	f7 f3                	div    %ebx
 3ec:	89 d0                	mov    %edx,%eax
 3ee:	0f b6 80 78 0a 00 00 	movzbl 0xa78(%eax),%eax
 3f5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ff:	ba 00 00 00 00       	mov    $0x0,%edx
 404:	f7 f3                	div    %ebx
 406:	89 45 ec             	mov    %eax,-0x14(%ebp)
 409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40d:	75 c7                	jne    3d6 <printint+0x38>
  if(neg)
 40f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 413:	74 2d                	je     442 <printint+0xa4>
    buf[i++] = '-';
 415:	8b 45 f4             	mov    -0xc(%ebp),%eax
 418:	8d 50 01             	lea    0x1(%eax),%edx
 41b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 41e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 423:	eb 1d                	jmp    442 <printint+0xa4>
    putc(fd, buf[i]);
 425:	8d 55 dc             	lea    -0x24(%ebp),%edx
 428:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42b:	01 d0                	add    %edx,%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	0f be c0             	movsbl %al,%eax
 433:	83 ec 08             	sub    $0x8,%esp
 436:	50                   	push   %eax
 437:	ff 75 08             	pushl  0x8(%ebp)
 43a:	e8 3c ff ff ff       	call   37b <putc>
 43f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 442:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 446:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 44a:	79 d9                	jns    425 <printint+0x87>
    putc(fd, buf[i]);
}
 44c:	90                   	nop
 44d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 450:	c9                   	leave  
 451:	c3                   	ret    

00000452 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 452:	55                   	push   %ebp
 453:	89 e5                	mov    %esp,%ebp
 455:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 458:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 45f:	8d 45 0c             	lea    0xc(%ebp),%eax
 462:	83 c0 04             	add    $0x4,%eax
 465:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 468:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 46f:	e9 59 01 00 00       	jmp    5cd <printf+0x17b>
    c = fmt[i] & 0xff;
 474:	8b 55 0c             	mov    0xc(%ebp),%edx
 477:	8b 45 f0             	mov    -0x10(%ebp),%eax
 47a:	01 d0                	add    %edx,%eax
 47c:	0f b6 00             	movzbl (%eax),%eax
 47f:	0f be c0             	movsbl %al,%eax
 482:	25 ff 00 00 00       	and    $0xff,%eax
 487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 48a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48e:	75 2c                	jne    4bc <printf+0x6a>
      if(c == '%'){
 490:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 494:	75 0c                	jne    4a2 <printf+0x50>
        state = '%';
 496:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 49d:	e9 27 01 00 00       	jmp    5c9 <printf+0x177>
      } else {
        putc(fd, c);
 4a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a5:	0f be c0             	movsbl %al,%eax
 4a8:	83 ec 08             	sub    $0x8,%esp
 4ab:	50                   	push   %eax
 4ac:	ff 75 08             	pushl  0x8(%ebp)
 4af:	e8 c7 fe ff ff       	call   37b <putc>
 4b4:	83 c4 10             	add    $0x10,%esp
 4b7:	e9 0d 01 00 00       	jmp    5c9 <printf+0x177>
      }
    } else if(state == '%'){
 4bc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c0:	0f 85 03 01 00 00    	jne    5c9 <printf+0x177>
      if(c == 'd'){
 4c6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ca:	75 1e                	jne    4ea <printf+0x98>
        printint(fd, *ap, 10, 1);
 4cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4cf:	8b 00                	mov    (%eax),%eax
 4d1:	6a 01                	push   $0x1
 4d3:	6a 0a                	push   $0xa
 4d5:	50                   	push   %eax
 4d6:	ff 75 08             	pushl  0x8(%ebp)
 4d9:	e8 c0 fe ff ff       	call   39e <printint>
 4de:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e5:	e9 d8 00 00 00       	jmp    5c2 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4ea:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4ee:	74 06                	je     4f6 <printf+0xa4>
 4f0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f4:	75 1e                	jne    514 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f9:	8b 00                	mov    (%eax),%eax
 4fb:	6a 00                	push   $0x0
 4fd:	6a 10                	push   $0x10
 4ff:	50                   	push   %eax
 500:	ff 75 08             	pushl  0x8(%ebp)
 503:	e8 96 fe ff ff       	call   39e <printint>
 508:	83 c4 10             	add    $0x10,%esp
        ap++;
 50b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50f:	e9 ae 00 00 00       	jmp    5c2 <printf+0x170>
      } else if(c == 's'){
 514:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 518:	75 43                	jne    55d <printf+0x10b>
        s = (char*)*ap;
 51a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51d:	8b 00                	mov    (%eax),%eax
 51f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 522:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52a:	75 25                	jne    551 <printf+0xff>
          s = "(null)";
 52c:	c7 45 f4 08 08 00 00 	movl   $0x808,-0xc(%ebp)
        while(*s != 0){
 533:	eb 1c                	jmp    551 <printf+0xff>
          putc(fd, *s);
 535:	8b 45 f4             	mov    -0xc(%ebp),%eax
 538:	0f b6 00             	movzbl (%eax),%eax
 53b:	0f be c0             	movsbl %al,%eax
 53e:	83 ec 08             	sub    $0x8,%esp
 541:	50                   	push   %eax
 542:	ff 75 08             	pushl  0x8(%ebp)
 545:	e8 31 fe ff ff       	call   37b <putc>
 54a:	83 c4 10             	add    $0x10,%esp
          s++;
 54d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 551:	8b 45 f4             	mov    -0xc(%ebp),%eax
 554:	0f b6 00             	movzbl (%eax),%eax
 557:	84 c0                	test   %al,%al
 559:	75 da                	jne    535 <printf+0xe3>
 55b:	eb 65                	jmp    5c2 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 55d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 561:	75 1d                	jne    580 <printf+0x12e>
        putc(fd, *ap);
 563:	8b 45 e8             	mov    -0x18(%ebp),%eax
 566:	8b 00                	mov    (%eax),%eax
 568:	0f be c0             	movsbl %al,%eax
 56b:	83 ec 08             	sub    $0x8,%esp
 56e:	50                   	push   %eax
 56f:	ff 75 08             	pushl  0x8(%ebp)
 572:	e8 04 fe ff ff       	call   37b <putc>
 577:	83 c4 10             	add    $0x10,%esp
        ap++;
 57a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57e:	eb 42                	jmp    5c2 <printf+0x170>
      } else if(c == '%'){
 580:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 584:	75 17                	jne    59d <printf+0x14b>
        putc(fd, c);
 586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 589:	0f be c0             	movsbl %al,%eax
 58c:	83 ec 08             	sub    $0x8,%esp
 58f:	50                   	push   %eax
 590:	ff 75 08             	pushl  0x8(%ebp)
 593:	e8 e3 fd ff ff       	call   37b <putc>
 598:	83 c4 10             	add    $0x10,%esp
 59b:	eb 25                	jmp    5c2 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 59d:	83 ec 08             	sub    $0x8,%esp
 5a0:	6a 25                	push   $0x25
 5a2:	ff 75 08             	pushl  0x8(%ebp)
 5a5:	e8 d1 fd ff ff       	call   37b <putc>
 5aa:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	83 ec 08             	sub    $0x8,%esp
 5b6:	50                   	push   %eax
 5b7:	ff 75 08             	pushl  0x8(%ebp)
 5ba:	e8 bc fd ff ff       	call   37b <putc>
 5bf:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5cd:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d3:	01 d0                	add    %edx,%eax
 5d5:	0f b6 00             	movzbl (%eax),%eax
 5d8:	84 c0                	test   %al,%al
 5da:	0f 85 94 fe ff ff    	jne    474 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e0:	90                   	nop
 5e1:	c9                   	leave  
 5e2:	c3                   	ret    

000005e3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e3:	55                   	push   %ebp
 5e4:	89 e5                	mov    %esp,%ebp
 5e6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ec:	83 e8 08             	sub    $0x8,%eax
 5ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f2:	a1 94 0a 00 00       	mov    0xa94,%eax
 5f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5fa:	eb 24                	jmp    620 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ff:	8b 00                	mov    (%eax),%eax
 601:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 604:	77 12                	ja     618 <free+0x35>
 606:	8b 45 f8             	mov    -0x8(%ebp),%eax
 609:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60c:	77 24                	ja     632 <free+0x4f>
 60e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 611:	8b 00                	mov    (%eax),%eax
 613:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 616:	77 1a                	ja     632 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 618:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61b:	8b 00                	mov    (%eax),%eax
 61d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 620:	8b 45 f8             	mov    -0x8(%ebp),%eax
 623:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 626:	76 d4                	jbe    5fc <free+0x19>
 628:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 630:	76 ca                	jbe    5fc <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 632:	8b 45 f8             	mov    -0x8(%ebp),%eax
 635:	8b 40 04             	mov    0x4(%eax),%eax
 638:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 63f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 642:	01 c2                	add    %eax,%edx
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 00                	mov    (%eax),%eax
 649:	39 c2                	cmp    %eax,%edx
 64b:	75 24                	jne    671 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 64d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 650:	8b 50 04             	mov    0x4(%eax),%edx
 653:	8b 45 fc             	mov    -0x4(%ebp),%eax
 656:	8b 00                	mov    (%eax),%eax
 658:	8b 40 04             	mov    0x4(%eax),%eax
 65b:	01 c2                	add    %eax,%edx
 65d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 660:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	8b 10                	mov    (%eax),%edx
 66a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66d:	89 10                	mov    %edx,(%eax)
 66f:	eb 0a                	jmp    67b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	8b 10                	mov    (%eax),%edx
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 40 04             	mov    0x4(%eax),%eax
 681:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	01 d0                	add    %edx,%eax
 68d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 690:	75 20                	jne    6b2 <free+0xcf>
    p->s.size += bp->s.size;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 50 04             	mov    0x4(%eax),%edx
 698:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69b:	8b 40 04             	mov    0x4(%eax),%eax
 69e:	01 c2                	add    %eax,%edx
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	8b 10                	mov    (%eax),%edx
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	89 10                	mov    %edx,(%eax)
 6b0:	eb 08                	jmp    6ba <free+0xd7>
  } else
    p->s.ptr = bp;
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b8:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	a3 94 0a 00 00       	mov    %eax,0xa94
}
 6c2:	90                   	nop
 6c3:	c9                   	leave  
 6c4:	c3                   	ret    

000006c5 <morecore>:

static Header*
morecore(uint nu)
{
 6c5:	55                   	push   %ebp
 6c6:	89 e5                	mov    %esp,%ebp
 6c8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6cb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d2:	77 07                	ja     6db <morecore+0x16>
    nu = 4096;
 6d4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
 6de:	c1 e0 03             	shl    $0x3,%eax
 6e1:	83 ec 0c             	sub    $0xc,%esp
 6e4:	50                   	push   %eax
 6e5:	e8 51 fc ff ff       	call   33b <sbrk>
 6ea:	83 c4 10             	add    $0x10,%esp
 6ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f4:	75 07                	jne    6fd <morecore+0x38>
    return 0;
 6f6:	b8 00 00 00 00       	mov    $0x0,%eax
 6fb:	eb 26                	jmp    723 <morecore+0x5e>
  hp = (Header*)p;
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 703:	8b 45 f0             	mov    -0x10(%ebp),%eax
 706:	8b 55 08             	mov    0x8(%ebp),%edx
 709:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 70c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70f:	83 c0 08             	add    $0x8,%eax
 712:	83 ec 0c             	sub    $0xc,%esp
 715:	50                   	push   %eax
 716:	e8 c8 fe ff ff       	call   5e3 <free>
 71b:	83 c4 10             	add    $0x10,%esp
  return freep;
 71e:	a1 94 0a 00 00       	mov    0xa94,%eax
}
 723:	c9                   	leave  
 724:	c3                   	ret    

00000725 <malloc>:

void*
malloc(uint nbytes)
{
 725:	55                   	push   %ebp
 726:	89 e5                	mov    %esp,%ebp
 728:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 72b:	8b 45 08             	mov    0x8(%ebp),%eax
 72e:	83 c0 07             	add    $0x7,%eax
 731:	c1 e8 03             	shr    $0x3,%eax
 734:	83 c0 01             	add    $0x1,%eax
 737:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 73a:	a1 94 0a 00 00       	mov    0xa94,%eax
 73f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 742:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 746:	75 23                	jne    76b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 748:	c7 45 f0 8c 0a 00 00 	movl   $0xa8c,-0x10(%ebp)
 74f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 752:	a3 94 0a 00 00       	mov    %eax,0xa94
 757:	a1 94 0a 00 00       	mov    0xa94,%eax
 75c:	a3 8c 0a 00 00       	mov    %eax,0xa8c
    base.s.size = 0;
 761:	c7 05 90 0a 00 00 00 	movl   $0x0,0xa90
 768:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76e:	8b 00                	mov    (%eax),%eax
 770:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 773:	8b 45 f4             	mov    -0xc(%ebp),%eax
 776:	8b 40 04             	mov    0x4(%eax),%eax
 779:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 77c:	72 4d                	jb     7cb <malloc+0xa6>
      if(p->s.size == nunits)
 77e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 781:	8b 40 04             	mov    0x4(%eax),%eax
 784:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 787:	75 0c                	jne    795 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	8b 10                	mov    (%eax),%edx
 78e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 791:	89 10                	mov    %edx,(%eax)
 793:	eb 26                	jmp    7bb <malloc+0x96>
      else {
        p->s.size -= nunits;
 795:	8b 45 f4             	mov    -0xc(%ebp),%eax
 798:	8b 40 04             	mov    0x4(%eax),%eax
 79b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 79e:	89 c2                	mov    %eax,%edx
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	c1 e0 03             	shl    $0x3,%eax
 7af:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7b8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7be:	a3 94 0a 00 00       	mov    %eax,0xa94
      return (void*)(p + 1);
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	83 c0 08             	add    $0x8,%eax
 7c9:	eb 3b                	jmp    806 <malloc+0xe1>
    }
    if(p == freep)
 7cb:	a1 94 0a 00 00       	mov    0xa94,%eax
 7d0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d3:	75 1e                	jne    7f3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7d5:	83 ec 0c             	sub    $0xc,%esp
 7d8:	ff 75 ec             	pushl  -0x14(%ebp)
 7db:	e8 e5 fe ff ff       	call   6c5 <morecore>
 7e0:	83 c4 10             	add    $0x10,%esp
 7e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ea:	75 07                	jne    7f3 <malloc+0xce>
        return 0;
 7ec:	b8 00 00 00 00       	mov    $0x0,%eax
 7f1:	eb 13                	jmp    806 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 801:	e9 6d ff ff ff       	jmp    773 <malloc+0x4e>
}
 806:	c9                   	leave  
 807:	c3                   	ret    
