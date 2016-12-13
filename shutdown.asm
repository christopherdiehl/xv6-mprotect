
_shutdown:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
	halt();
  11:	e8 2c 03 00 00       	call   342 <halt>
	exit();
  16:	e8 87 02 00 00       	call   2a2 <exit>

0000001b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  1b:	55                   	push   %ebp
  1c:	89 e5                	mov    %esp,%ebp
  1e:	57                   	push   %edi
  1f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  23:	8b 55 10             	mov    0x10(%ebp),%edx
  26:	8b 45 0c             	mov    0xc(%ebp),%eax
  29:	89 cb                	mov    %ecx,%ebx
  2b:	89 df                	mov    %ebx,%edi
  2d:	89 d1                	mov    %edx,%ecx
  2f:	fc                   	cld    
  30:	f3 aa                	rep stos %al,%es:(%edi)
  32:	89 ca                	mov    %ecx,%edx
  34:	89 fb                	mov    %edi,%ebx
  36:	89 5d 08             	mov    %ebx,0x8(%ebp)
  39:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  3c:	90                   	nop
  3d:	5b                   	pop    %ebx
  3e:	5f                   	pop    %edi
  3f:	5d                   	pop    %ebp
  40:	c3                   	ret    

00000041 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  41:	55                   	push   %ebp
  42:	89 e5                	mov    %esp,%ebp
  44:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  47:	8b 45 08             	mov    0x8(%ebp),%eax
  4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  4d:	90                   	nop
  4e:	8b 45 08             	mov    0x8(%ebp),%eax
  51:	8d 50 01             	lea    0x1(%eax),%edx
  54:	89 55 08             	mov    %edx,0x8(%ebp)
  57:	8b 55 0c             	mov    0xc(%ebp),%edx
  5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  5d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  60:	0f b6 12             	movzbl (%edx),%edx
  63:	88 10                	mov    %dl,(%eax)
  65:	0f b6 00             	movzbl (%eax),%eax
  68:	84 c0                	test   %al,%al
  6a:	75 e2                	jne    4e <strcpy+0xd>
    ;
  return os;
  6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  6f:	c9                   	leave  
  70:	c3                   	ret    

00000071 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  71:	55                   	push   %ebp
  72:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  74:	eb 08                	jmp    7e <strcmp+0xd>
    p++, q++;
  76:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  7a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  7e:	8b 45 08             	mov    0x8(%ebp),%eax
  81:	0f b6 00             	movzbl (%eax),%eax
  84:	84 c0                	test   %al,%al
  86:	74 10                	je     98 <strcmp+0x27>
  88:	8b 45 08             	mov    0x8(%ebp),%eax
  8b:	0f b6 10             	movzbl (%eax),%edx
  8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  91:	0f b6 00             	movzbl (%eax),%eax
  94:	38 c2                	cmp    %al,%dl
  96:	74 de                	je     76 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	0f b6 00             	movzbl (%eax),%eax
  9e:	0f b6 d0             	movzbl %al,%edx
  a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  a4:	0f b6 00             	movzbl (%eax),%eax
  a7:	0f b6 c0             	movzbl %al,%eax
  aa:	29 c2                	sub    %eax,%edx
  ac:	89 d0                	mov    %edx,%eax
}
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <strlen>:

uint
strlen(char *s)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  bd:	eb 04                	jmp    c3 <strlen+0x13>
  bf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  c6:	8b 45 08             	mov    0x8(%ebp),%eax
  c9:	01 d0                	add    %edx,%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	75 ed                	jne    bf <strlen+0xf>
    ;
  return n;
  d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d5:	c9                   	leave  
  d6:	c3                   	ret    

000000d7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d7:	55                   	push   %ebp
  d8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  da:	8b 45 10             	mov    0x10(%ebp),%eax
  dd:	50                   	push   %eax
  de:	ff 75 0c             	pushl  0xc(%ebp)
  e1:	ff 75 08             	pushl  0x8(%ebp)
  e4:	e8 32 ff ff ff       	call   1b <stosb>
  e9:	83 c4 0c             	add    $0xc,%esp
  return dst;
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  ef:	c9                   	leave  
  f0:	c3                   	ret    

000000f1 <strchr>:

char*
strchr(const char *s, char c)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	83 ec 04             	sub    $0x4,%esp
  f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  fa:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
  fd:	eb 14                	jmp    113 <strchr+0x22>
    if(*s == c)
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	0f b6 00             	movzbl (%eax),%eax
 105:	3a 45 fc             	cmp    -0x4(%ebp),%al
 108:	75 05                	jne    10f <strchr+0x1e>
      return (char*)s;
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	eb 13                	jmp    122 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 10f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	0f b6 00             	movzbl (%eax),%eax
 119:	84 c0                	test   %al,%al
 11b:	75 e2                	jne    ff <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 11d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 122:	c9                   	leave  
 123:	c3                   	ret    

00000124 <gets>:

char*
gets(char *buf, int max)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 131:	eb 42                	jmp    175 <gets+0x51>
    cc = read(0, &c, 1);
 133:	83 ec 04             	sub    $0x4,%esp
 136:	6a 01                	push   $0x1
 138:	8d 45 ef             	lea    -0x11(%ebp),%eax
 13b:	50                   	push   %eax
 13c:	6a 00                	push   $0x0
 13e:	e8 77 01 00 00       	call   2ba <read>
 143:	83 c4 10             	add    $0x10,%esp
 146:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 149:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 14d:	7e 33                	jle    182 <gets+0x5e>
      break;
    buf[i++] = c;
 14f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 152:	8d 50 01             	lea    0x1(%eax),%edx
 155:	89 55 f4             	mov    %edx,-0xc(%ebp)
 158:	89 c2                	mov    %eax,%edx
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
 15d:	01 c2                	add    %eax,%edx
 15f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 163:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 165:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 169:	3c 0a                	cmp    $0xa,%al
 16b:	74 16                	je     183 <gets+0x5f>
 16d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 171:	3c 0d                	cmp    $0xd,%al
 173:	74 0e                	je     183 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 175:	8b 45 f4             	mov    -0xc(%ebp),%eax
 178:	83 c0 01             	add    $0x1,%eax
 17b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 17e:	7c b3                	jl     133 <gets+0xf>
 180:	eb 01                	jmp    183 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 182:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 183:	8b 55 f4             	mov    -0xc(%ebp),%edx
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	01 d0                	add    %edx,%eax
 18b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 191:	c9                   	leave  
 192:	c3                   	ret    

00000193 <stat>:

int
stat(char *n, struct stat *st)
{
 193:	55                   	push   %ebp
 194:	89 e5                	mov    %esp,%ebp
 196:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 199:	83 ec 08             	sub    $0x8,%esp
 19c:	6a 00                	push   $0x0
 19e:	ff 75 08             	pushl  0x8(%ebp)
 1a1:	e8 3c 01 00 00       	call   2e2 <open>
 1a6:	83 c4 10             	add    $0x10,%esp
 1a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b0:	79 07                	jns    1b9 <stat+0x26>
    return -1;
 1b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1b7:	eb 25                	jmp    1de <stat+0x4b>
  r = fstat(fd, st);
 1b9:	83 ec 08             	sub    $0x8,%esp
 1bc:	ff 75 0c             	pushl  0xc(%ebp)
 1bf:	ff 75 f4             	pushl  -0xc(%ebp)
 1c2:	e8 33 01 00 00       	call   2fa <fstat>
 1c7:	83 c4 10             	add    $0x10,%esp
 1ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1cd:	83 ec 0c             	sub    $0xc,%esp
 1d0:	ff 75 f4             	pushl  -0xc(%ebp)
 1d3:	e8 f2 00 00 00       	call   2ca <close>
 1d8:	83 c4 10             	add    $0x10,%esp
  return r;
 1db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1de:	c9                   	leave  
 1df:	c3                   	ret    

000001e0 <atoi>:

int
atoi(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1ed:	eb 25                	jmp    214 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f2:	89 d0                	mov    %edx,%eax
 1f4:	c1 e0 02             	shl    $0x2,%eax
 1f7:	01 d0                	add    %edx,%eax
 1f9:	01 c0                	add    %eax,%eax
 1fb:	89 c1                	mov    %eax,%ecx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	8d 50 01             	lea    0x1(%eax),%edx
 203:	89 55 08             	mov    %edx,0x8(%ebp)
 206:	0f b6 00             	movzbl (%eax),%eax
 209:	0f be c0             	movsbl %al,%eax
 20c:	01 c8                	add    %ecx,%eax
 20e:	83 e8 30             	sub    $0x30,%eax
 211:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	3c 2f                	cmp    $0x2f,%al
 21c:	7e 0a                	jle    228 <atoi+0x48>
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	0f b6 00             	movzbl (%eax),%eax
 224:	3c 39                	cmp    $0x39,%al
 226:	7e c7                	jle    1ef <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 228:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22b:	c9                   	leave  
 22c:	c3                   	ret    

0000022d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 22d:	55                   	push   %ebp
 22e:	89 e5                	mov    %esp,%ebp
 230:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 23f:	eb 17                	jmp    258 <memmove+0x2b>
    *dst++ = *src++;
 241:	8b 45 fc             	mov    -0x4(%ebp),%eax
 244:	8d 50 01             	lea    0x1(%eax),%edx
 247:	89 55 fc             	mov    %edx,-0x4(%ebp)
 24a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 24d:	8d 4a 01             	lea    0x1(%edx),%ecx
 250:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 253:	0f b6 12             	movzbl (%edx),%edx
 256:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 258:	8b 45 10             	mov    0x10(%ebp),%eax
 25b:	8d 50 ff             	lea    -0x1(%eax),%edx
 25e:	89 55 10             	mov    %edx,0x10(%ebp)
 261:	85 c0                	test   %eax,%eax
 263:	7f dc                	jg     241 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 265:	8b 45 08             	mov    0x8(%ebp),%eax
}
 268:	c9                   	leave  
 269:	c3                   	ret    

0000026a <restorer>:
 26a:	83 c4 0c             	add    $0xc,%esp
 26d:	5a                   	pop    %edx
 26e:	59                   	pop    %ecx
 26f:	58                   	pop    %eax
 270:	c3                   	ret    

00000271 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 271:	55                   	push   %ebp
 272:	89 e5                	mov    %esp,%ebp
 274:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 277:	83 ec 0c             	sub    $0xc,%esp
 27a:	68 6a 02 00 00       	push   $0x26a
 27f:	e8 ce 00 00 00       	call   352 <signal_restorer>
 284:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 287:	83 ec 08             	sub    $0x8,%esp
 28a:	ff 75 0c             	pushl  0xc(%ebp)
 28d:	ff 75 08             	pushl  0x8(%ebp)
 290:	e8 b5 00 00 00       	call   34a <signal_register>
 295:	83 c4 10             	add    $0x10,%esp
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 29a:	b8 01 00 00 00       	mov    $0x1,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <exit>:
SYSCALL(exit)
 2a2:	b8 02 00 00 00       	mov    $0x2,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <wait>:
SYSCALL(wait)
 2aa:	b8 03 00 00 00       	mov    $0x3,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <pipe>:
SYSCALL(pipe)
 2b2:	b8 04 00 00 00       	mov    $0x4,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <read>:
SYSCALL(read)
 2ba:	b8 05 00 00 00       	mov    $0x5,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <write>:
SYSCALL(write)
 2c2:	b8 10 00 00 00       	mov    $0x10,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <close>:
SYSCALL(close)
 2ca:	b8 15 00 00 00       	mov    $0x15,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <kill>:
SYSCALL(kill)
 2d2:	b8 06 00 00 00       	mov    $0x6,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <exec>:
SYSCALL(exec)
 2da:	b8 07 00 00 00       	mov    $0x7,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <open>:
SYSCALL(open)
 2e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <mknod>:
SYSCALL(mknod)
 2ea:	b8 11 00 00 00       	mov    $0x11,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <unlink>:
SYSCALL(unlink)
 2f2:	b8 12 00 00 00       	mov    $0x12,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <fstat>:
SYSCALL(fstat)
 2fa:	b8 08 00 00 00       	mov    $0x8,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <link>:
SYSCALL(link)
 302:	b8 13 00 00 00       	mov    $0x13,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <mkdir>:
SYSCALL(mkdir)
 30a:	b8 14 00 00 00       	mov    $0x14,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <chdir>:
SYSCALL(chdir)
 312:	b8 09 00 00 00       	mov    $0x9,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <dup>:
SYSCALL(dup)
 31a:	b8 0a 00 00 00       	mov    $0xa,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <getpid>:
SYSCALL(getpid)
 322:	b8 0b 00 00 00       	mov    $0xb,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <sbrk>:
SYSCALL(sbrk)
 32a:	b8 0c 00 00 00       	mov    $0xc,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <sleep>:
SYSCALL(sleep)
 332:	b8 0d 00 00 00       	mov    $0xd,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <uptime>:
SYSCALL(uptime)
 33a:	b8 0e 00 00 00       	mov    $0xe,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <halt>:
SYSCALL(halt)
 342:	b8 16 00 00 00       	mov    $0x16,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <signal_register>:
SYSCALL(signal_register)
 34a:	b8 17 00 00 00       	mov    $0x17,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <signal_restorer>:
SYSCALL(signal_restorer)
 352:	b8 18 00 00 00       	mov    $0x18,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <mprotect>:
SYSCALL(mprotect)
 35a:	b8 19 00 00 00       	mov    $0x19,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <cowfork>:
SYSCALL(cowfork)
 362:	b8 1a 00 00 00       	mov    $0x1a,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36a:	55                   	push   %ebp
 36b:	89 e5                	mov    %esp,%ebp
 36d:	83 ec 18             	sub    $0x18,%esp
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 376:	83 ec 04             	sub    $0x4,%esp
 379:	6a 01                	push   $0x1
 37b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37e:	50                   	push   %eax
 37f:	ff 75 08             	pushl  0x8(%ebp)
 382:	e8 3b ff ff ff       	call   2c2 <write>
 387:	83 c4 10             	add    $0x10,%esp
}
 38a:	90                   	nop
 38b:	c9                   	leave  
 38c:	c3                   	ret    

0000038d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38d:	55                   	push   %ebp
 38e:	89 e5                	mov    %esp,%ebp
 390:	53                   	push   %ebx
 391:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 394:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 39b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 39f:	74 17                	je     3b8 <printint+0x2b>
 3a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a5:	79 11                	jns    3b8 <printint+0x2b>
    neg = 1;
 3a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b1:	f7 d8                	neg    %eax
 3b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b6:	eb 06                	jmp    3be <printint+0x31>
  } else {
    x = xx;
 3b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c8:	8d 41 01             	lea    0x1(%ecx),%eax
 3cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d4:	ba 00 00 00 00       	mov    $0x0,%edx
 3d9:	f7 f3                	div    %ebx
 3db:	89 d0                	mov    %edx,%eax
 3dd:	0f b6 80 68 0a 00 00 	movzbl 0xa68(%eax),%eax
 3e4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ee:	ba 00 00 00 00       	mov    $0x0,%edx
 3f3:	f7 f3                	div    %ebx
 3f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fc:	75 c7                	jne    3c5 <printint+0x38>
  if(neg)
 3fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 402:	74 2d                	je     431 <printint+0xa4>
    buf[i++] = '-';
 404:	8b 45 f4             	mov    -0xc(%ebp),%eax
 407:	8d 50 01             	lea    0x1(%eax),%edx
 40a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 40d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 412:	eb 1d                	jmp    431 <printint+0xa4>
    putc(fd, buf[i]);
 414:	8d 55 dc             	lea    -0x24(%ebp),%edx
 417:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41a:	01 d0                	add    %edx,%eax
 41c:	0f b6 00             	movzbl (%eax),%eax
 41f:	0f be c0             	movsbl %al,%eax
 422:	83 ec 08             	sub    $0x8,%esp
 425:	50                   	push   %eax
 426:	ff 75 08             	pushl  0x8(%ebp)
 429:	e8 3c ff ff ff       	call   36a <putc>
 42e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 431:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 435:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 439:	79 d9                	jns    414 <printint+0x87>
    putc(fd, buf[i]);
}
 43b:	90                   	nop
 43c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 43f:	c9                   	leave  
 440:	c3                   	ret    

00000441 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 441:	55                   	push   %ebp
 442:	89 e5                	mov    %esp,%ebp
 444:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 447:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 44e:	8d 45 0c             	lea    0xc(%ebp),%eax
 451:	83 c0 04             	add    $0x4,%eax
 454:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 457:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 45e:	e9 59 01 00 00       	jmp    5bc <printf+0x17b>
    c = fmt[i] & 0xff;
 463:	8b 55 0c             	mov    0xc(%ebp),%edx
 466:	8b 45 f0             	mov    -0x10(%ebp),%eax
 469:	01 d0                	add    %edx,%eax
 46b:	0f b6 00             	movzbl (%eax),%eax
 46e:	0f be c0             	movsbl %al,%eax
 471:	25 ff 00 00 00       	and    $0xff,%eax
 476:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 479:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47d:	75 2c                	jne    4ab <printf+0x6a>
      if(c == '%'){
 47f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 483:	75 0c                	jne    491 <printf+0x50>
        state = '%';
 485:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 48c:	e9 27 01 00 00       	jmp    5b8 <printf+0x177>
      } else {
        putc(fd, c);
 491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 494:	0f be c0             	movsbl %al,%eax
 497:	83 ec 08             	sub    $0x8,%esp
 49a:	50                   	push   %eax
 49b:	ff 75 08             	pushl  0x8(%ebp)
 49e:	e8 c7 fe ff ff       	call   36a <putc>
 4a3:	83 c4 10             	add    $0x10,%esp
 4a6:	e9 0d 01 00 00       	jmp    5b8 <printf+0x177>
      }
    } else if(state == '%'){
 4ab:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4af:	0f 85 03 01 00 00    	jne    5b8 <printf+0x177>
      if(c == 'd'){
 4b5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b9:	75 1e                	jne    4d9 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4be:	8b 00                	mov    (%eax),%eax
 4c0:	6a 01                	push   $0x1
 4c2:	6a 0a                	push   $0xa
 4c4:	50                   	push   %eax
 4c5:	ff 75 08             	pushl  0x8(%ebp)
 4c8:	e8 c0 fe ff ff       	call   38d <printint>
 4cd:	83 c4 10             	add    $0x10,%esp
        ap++;
 4d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d4:	e9 d8 00 00 00       	jmp    5b1 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4d9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4dd:	74 06                	je     4e5 <printf+0xa4>
 4df:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e3:	75 1e                	jne    503 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e8:	8b 00                	mov    (%eax),%eax
 4ea:	6a 00                	push   $0x0
 4ec:	6a 10                	push   $0x10
 4ee:	50                   	push   %eax
 4ef:	ff 75 08             	pushl  0x8(%ebp)
 4f2:	e8 96 fe ff ff       	call   38d <printint>
 4f7:	83 c4 10             	add    $0x10,%esp
        ap++;
 4fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4fe:	e9 ae 00 00 00       	jmp    5b1 <printf+0x170>
      } else if(c == 's'){
 503:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 507:	75 43                	jne    54c <printf+0x10b>
        s = (char*)*ap;
 509:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50c:	8b 00                	mov    (%eax),%eax
 50e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 511:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 519:	75 25                	jne    540 <printf+0xff>
          s = "(null)";
 51b:	c7 45 f4 f7 07 00 00 	movl   $0x7f7,-0xc(%ebp)
        while(*s != 0){
 522:	eb 1c                	jmp    540 <printf+0xff>
          putc(fd, *s);
 524:	8b 45 f4             	mov    -0xc(%ebp),%eax
 527:	0f b6 00             	movzbl (%eax),%eax
 52a:	0f be c0             	movsbl %al,%eax
 52d:	83 ec 08             	sub    $0x8,%esp
 530:	50                   	push   %eax
 531:	ff 75 08             	pushl  0x8(%ebp)
 534:	e8 31 fe ff ff       	call   36a <putc>
 539:	83 c4 10             	add    $0x10,%esp
          s++;
 53c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 540:	8b 45 f4             	mov    -0xc(%ebp),%eax
 543:	0f b6 00             	movzbl (%eax),%eax
 546:	84 c0                	test   %al,%al
 548:	75 da                	jne    524 <printf+0xe3>
 54a:	eb 65                	jmp    5b1 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 54c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 550:	75 1d                	jne    56f <printf+0x12e>
        putc(fd, *ap);
 552:	8b 45 e8             	mov    -0x18(%ebp),%eax
 555:	8b 00                	mov    (%eax),%eax
 557:	0f be c0             	movsbl %al,%eax
 55a:	83 ec 08             	sub    $0x8,%esp
 55d:	50                   	push   %eax
 55e:	ff 75 08             	pushl  0x8(%ebp)
 561:	e8 04 fe ff ff       	call   36a <putc>
 566:	83 c4 10             	add    $0x10,%esp
        ap++;
 569:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56d:	eb 42                	jmp    5b1 <printf+0x170>
      } else if(c == '%'){
 56f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 573:	75 17                	jne    58c <printf+0x14b>
        putc(fd, c);
 575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 578:	0f be c0             	movsbl %al,%eax
 57b:	83 ec 08             	sub    $0x8,%esp
 57e:	50                   	push   %eax
 57f:	ff 75 08             	pushl  0x8(%ebp)
 582:	e8 e3 fd ff ff       	call   36a <putc>
 587:	83 c4 10             	add    $0x10,%esp
 58a:	eb 25                	jmp    5b1 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 58c:	83 ec 08             	sub    $0x8,%esp
 58f:	6a 25                	push   $0x25
 591:	ff 75 08             	pushl  0x8(%ebp)
 594:	e8 d1 fd ff ff       	call   36a <putc>
 599:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 59c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59f:	0f be c0             	movsbl %al,%eax
 5a2:	83 ec 08             	sub    $0x8,%esp
 5a5:	50                   	push   %eax
 5a6:	ff 75 08             	pushl  0x8(%ebp)
 5a9:	e8 bc fd ff ff       	call   36a <putc>
 5ae:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5bc:	8b 55 0c             	mov    0xc(%ebp),%edx
 5bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c2:	01 d0                	add    %edx,%eax
 5c4:	0f b6 00             	movzbl (%eax),%eax
 5c7:	84 c0                	test   %al,%al
 5c9:	0f 85 94 fe ff ff    	jne    463 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5cf:	90                   	nop
 5d0:	c9                   	leave  
 5d1:	c3                   	ret    

000005d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d2:	55                   	push   %ebp
 5d3:	89 e5                	mov    %esp,%ebp
 5d5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
 5db:	83 e8 08             	sub    $0x8,%eax
 5de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	a1 84 0a 00 00       	mov    0xa84,%eax
 5e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e9:	eb 24                	jmp    60f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ee:	8b 00                	mov    (%eax),%eax
 5f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f3:	77 12                	ja     607 <free+0x35>
 5f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5fb:	77 24                	ja     621 <free+0x4f>
 5fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 600:	8b 00                	mov    (%eax),%eax
 602:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 605:	77 1a                	ja     621 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 607:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 612:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 615:	76 d4                	jbe    5eb <free+0x19>
 617:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61a:	8b 00                	mov    (%eax),%eax
 61c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61f:	76 ca                	jbe    5eb <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 621:	8b 45 f8             	mov    -0x8(%ebp),%eax
 624:	8b 40 04             	mov    0x4(%eax),%eax
 627:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 62e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 631:	01 c2                	add    %eax,%edx
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	39 c2                	cmp    %eax,%edx
 63a:	75 24                	jne    660 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 63c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63f:	8b 50 04             	mov    0x4(%eax),%edx
 642:	8b 45 fc             	mov    -0x4(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	8b 40 04             	mov    0x4(%eax),%eax
 64a:	01 c2                	add    %eax,%edx
 64c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	8b 10                	mov    (%eax),%edx
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	89 10                	mov    %edx,(%eax)
 65e:	eb 0a                	jmp    66a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	8b 10                	mov    (%eax),%edx
 665:	8b 45 f8             	mov    -0x8(%ebp),%eax
 668:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 40 04             	mov    0x4(%eax),%eax
 670:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	01 d0                	add    %edx,%eax
 67c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67f:	75 20                	jne    6a1 <free+0xcf>
    p->s.size += bp->s.size;
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 50 04             	mov    0x4(%eax),%edx
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	8b 40 04             	mov    0x4(%eax),%eax
 68d:	01 c2                	add    %eax,%edx
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 695:	8b 45 f8             	mov    -0x8(%ebp),%eax
 698:	8b 10                	mov    (%eax),%edx
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	89 10                	mov    %edx,(%eax)
 69f:	eb 08                	jmp    6a9 <free+0xd7>
  } else
    p->s.ptr = bp;
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	a3 84 0a 00 00       	mov    %eax,0xa84
}
 6b1:	90                   	nop
 6b2:	c9                   	leave  
 6b3:	c3                   	ret    

000006b4 <morecore>:

static Header*
morecore(uint nu)
{
 6b4:	55                   	push   %ebp
 6b5:	89 e5                	mov    %esp,%ebp
 6b7:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ba:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6c1:	77 07                	ja     6ca <morecore+0x16>
    nu = 4096;
 6c3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ca:	8b 45 08             	mov    0x8(%ebp),%eax
 6cd:	c1 e0 03             	shl    $0x3,%eax
 6d0:	83 ec 0c             	sub    $0xc,%esp
 6d3:	50                   	push   %eax
 6d4:	e8 51 fc ff ff       	call   32a <sbrk>
 6d9:	83 c4 10             	add    $0x10,%esp
 6dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6df:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6e3:	75 07                	jne    6ec <morecore+0x38>
    return 0;
 6e5:	b8 00 00 00 00       	mov    $0x0,%eax
 6ea:	eb 26                	jmp    712 <morecore+0x5e>
  hp = (Header*)p;
 6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f5:	8b 55 08             	mov    0x8(%ebp),%edx
 6f8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fe:	83 c0 08             	add    $0x8,%eax
 701:	83 ec 0c             	sub    $0xc,%esp
 704:	50                   	push   %eax
 705:	e8 c8 fe ff ff       	call   5d2 <free>
 70a:	83 c4 10             	add    $0x10,%esp
  return freep;
 70d:	a1 84 0a 00 00       	mov    0xa84,%eax
}
 712:	c9                   	leave  
 713:	c3                   	ret    

00000714 <malloc>:

void*
malloc(uint nbytes)
{
 714:	55                   	push   %ebp
 715:	89 e5                	mov    %esp,%ebp
 717:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71a:	8b 45 08             	mov    0x8(%ebp),%eax
 71d:	83 c0 07             	add    $0x7,%eax
 720:	c1 e8 03             	shr    $0x3,%eax
 723:	83 c0 01             	add    $0x1,%eax
 726:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 729:	a1 84 0a 00 00       	mov    0xa84,%eax
 72e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 731:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 735:	75 23                	jne    75a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 737:	c7 45 f0 7c 0a 00 00 	movl   $0xa7c,-0x10(%ebp)
 73e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 741:	a3 84 0a 00 00       	mov    %eax,0xa84
 746:	a1 84 0a 00 00       	mov    0xa84,%eax
 74b:	a3 7c 0a 00 00       	mov    %eax,0xa7c
    base.s.size = 0;
 750:	c7 05 80 0a 00 00 00 	movl   $0x0,0xa80
 757:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75d:	8b 00                	mov    (%eax),%eax
 75f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 765:	8b 40 04             	mov    0x4(%eax),%eax
 768:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76b:	72 4d                	jb     7ba <malloc+0xa6>
      if(p->s.size == nunits)
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	8b 40 04             	mov    0x4(%eax),%eax
 773:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 776:	75 0c                	jne    784 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	8b 10                	mov    (%eax),%edx
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	89 10                	mov    %edx,(%eax)
 782:	eb 26                	jmp    7aa <malloc+0x96>
      else {
        p->s.size -= nunits;
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	8b 40 04             	mov    0x4(%eax),%eax
 78a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 78d:	89 c2                	mov    %eax,%edx
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 795:	8b 45 f4             	mov    -0xc(%ebp),%eax
 798:	8b 40 04             	mov    0x4(%eax),%eax
 79b:	c1 e0 03             	shl    $0x3,%eax
 79e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ad:	a3 84 0a 00 00       	mov    %eax,0xa84
      return (void*)(p + 1);
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	83 c0 08             	add    $0x8,%eax
 7b8:	eb 3b                	jmp    7f5 <malloc+0xe1>
    }
    if(p == freep)
 7ba:	a1 84 0a 00 00       	mov    0xa84,%eax
 7bf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c2:	75 1e                	jne    7e2 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7c4:	83 ec 0c             	sub    $0xc,%esp
 7c7:	ff 75 ec             	pushl  -0x14(%ebp)
 7ca:	e8 e5 fe ff ff       	call   6b4 <morecore>
 7cf:	83 c4 10             	add    $0x10,%esp
 7d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d9:	75 07                	jne    7e2 <malloc+0xce>
        return 0;
 7db:	b8 00 00 00 00       	mov    $0x0,%eax
 7e0:	eb 13                	jmp    7f5 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7f0:	e9 6d ff ff ff       	jmp    762 <malloc+0x4e>
}
 7f5:	c9                   	leave  
 7f6:	c3                   	ret    
