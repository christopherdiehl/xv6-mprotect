
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
 26a:	83 c4 04             	add    $0x4,%esp
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

0000035a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp
 35d:	83 ec 18             	sub    $0x18,%esp
 360:	8b 45 0c             	mov    0xc(%ebp),%eax
 363:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 366:	83 ec 04             	sub    $0x4,%esp
 369:	6a 01                	push   $0x1
 36b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 36e:	50                   	push   %eax
 36f:	ff 75 08             	pushl  0x8(%ebp)
 372:	e8 4b ff ff ff       	call   2c2 <write>
 377:	83 c4 10             	add    $0x10,%esp
}
 37a:	90                   	nop
 37b:	c9                   	leave  
 37c:	c3                   	ret    

0000037d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37d:	55                   	push   %ebp
 37e:	89 e5                	mov    %esp,%ebp
 380:	53                   	push   %ebx
 381:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 384:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 38b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 38f:	74 17                	je     3a8 <printint+0x2b>
 391:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 395:	79 11                	jns    3a8 <printint+0x2b>
    neg = 1;
 397:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	f7 d8                	neg    %eax
 3a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a6:	eb 06                	jmp    3ae <printint+0x31>
  } else {
    x = xx;
 3a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3b8:	8d 41 01             	lea    0x1(%ecx),%eax
 3bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3be:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c4:	ba 00 00 00 00       	mov    $0x0,%edx
 3c9:	f7 f3                	div    %ebx
 3cb:	89 d0                	mov    %edx,%eax
 3cd:	0f b6 80 58 0a 00 00 	movzbl 0xa58(%eax),%eax
 3d4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3db:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3de:	ba 00 00 00 00       	mov    $0x0,%edx
 3e3:	f7 f3                	div    %ebx
 3e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3ec:	75 c7                	jne    3b5 <printint+0x38>
  if(neg)
 3ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f2:	74 2d                	je     421 <printint+0xa4>
    buf[i++] = '-';
 3f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f7:	8d 50 01             	lea    0x1(%eax),%edx
 3fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3fd:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 402:	eb 1d                	jmp    421 <printint+0xa4>
    putc(fd, buf[i]);
 404:	8d 55 dc             	lea    -0x24(%ebp),%edx
 407:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40a:	01 d0                	add    %edx,%eax
 40c:	0f b6 00             	movzbl (%eax),%eax
 40f:	0f be c0             	movsbl %al,%eax
 412:	83 ec 08             	sub    $0x8,%esp
 415:	50                   	push   %eax
 416:	ff 75 08             	pushl  0x8(%ebp)
 419:	e8 3c ff ff ff       	call   35a <putc>
 41e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 421:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 429:	79 d9                	jns    404 <printint+0x87>
    putc(fd, buf[i]);
}
 42b:	90                   	nop
 42c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 42f:	c9                   	leave  
 430:	c3                   	ret    

00000431 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 431:	55                   	push   %ebp
 432:	89 e5                	mov    %esp,%ebp
 434:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 437:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 43e:	8d 45 0c             	lea    0xc(%ebp),%eax
 441:	83 c0 04             	add    $0x4,%eax
 444:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 447:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 44e:	e9 59 01 00 00       	jmp    5ac <printf+0x17b>
    c = fmt[i] & 0xff;
 453:	8b 55 0c             	mov    0xc(%ebp),%edx
 456:	8b 45 f0             	mov    -0x10(%ebp),%eax
 459:	01 d0                	add    %edx,%eax
 45b:	0f b6 00             	movzbl (%eax),%eax
 45e:	0f be c0             	movsbl %al,%eax
 461:	25 ff 00 00 00       	and    $0xff,%eax
 466:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 469:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46d:	75 2c                	jne    49b <printf+0x6a>
      if(c == '%'){
 46f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 473:	75 0c                	jne    481 <printf+0x50>
        state = '%';
 475:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 47c:	e9 27 01 00 00       	jmp    5a8 <printf+0x177>
      } else {
        putc(fd, c);
 481:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 484:	0f be c0             	movsbl %al,%eax
 487:	83 ec 08             	sub    $0x8,%esp
 48a:	50                   	push   %eax
 48b:	ff 75 08             	pushl  0x8(%ebp)
 48e:	e8 c7 fe ff ff       	call   35a <putc>
 493:	83 c4 10             	add    $0x10,%esp
 496:	e9 0d 01 00 00       	jmp    5a8 <printf+0x177>
      }
    } else if(state == '%'){
 49b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 49f:	0f 85 03 01 00 00    	jne    5a8 <printf+0x177>
      if(c == 'd'){
 4a5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a9:	75 1e                	jne    4c9 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ae:	8b 00                	mov    (%eax),%eax
 4b0:	6a 01                	push   $0x1
 4b2:	6a 0a                	push   $0xa
 4b4:	50                   	push   %eax
 4b5:	ff 75 08             	pushl  0x8(%ebp)
 4b8:	e8 c0 fe ff ff       	call   37d <printint>
 4bd:	83 c4 10             	add    $0x10,%esp
        ap++;
 4c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c4:	e9 d8 00 00 00       	jmp    5a1 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4c9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4cd:	74 06                	je     4d5 <printf+0xa4>
 4cf:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4d3:	75 1e                	jne    4f3 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d8:	8b 00                	mov    (%eax),%eax
 4da:	6a 00                	push   $0x0
 4dc:	6a 10                	push   $0x10
 4de:	50                   	push   %eax
 4df:	ff 75 08             	pushl  0x8(%ebp)
 4e2:	e8 96 fe ff ff       	call   37d <printint>
 4e7:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ee:	e9 ae 00 00 00       	jmp    5a1 <printf+0x170>
      } else if(c == 's'){
 4f3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4f7:	75 43                	jne    53c <printf+0x10b>
        s = (char*)*ap;
 4f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fc:	8b 00                	mov    (%eax),%eax
 4fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 501:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 509:	75 25                	jne    530 <printf+0xff>
          s = "(null)";
 50b:	c7 45 f4 e7 07 00 00 	movl   $0x7e7,-0xc(%ebp)
        while(*s != 0){
 512:	eb 1c                	jmp    530 <printf+0xff>
          putc(fd, *s);
 514:	8b 45 f4             	mov    -0xc(%ebp),%eax
 517:	0f b6 00             	movzbl (%eax),%eax
 51a:	0f be c0             	movsbl %al,%eax
 51d:	83 ec 08             	sub    $0x8,%esp
 520:	50                   	push   %eax
 521:	ff 75 08             	pushl  0x8(%ebp)
 524:	e8 31 fe ff ff       	call   35a <putc>
 529:	83 c4 10             	add    $0x10,%esp
          s++;
 52c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 530:	8b 45 f4             	mov    -0xc(%ebp),%eax
 533:	0f b6 00             	movzbl (%eax),%eax
 536:	84 c0                	test   %al,%al
 538:	75 da                	jne    514 <printf+0xe3>
 53a:	eb 65                	jmp    5a1 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 53c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 540:	75 1d                	jne    55f <printf+0x12e>
        putc(fd, *ap);
 542:	8b 45 e8             	mov    -0x18(%ebp),%eax
 545:	8b 00                	mov    (%eax),%eax
 547:	0f be c0             	movsbl %al,%eax
 54a:	83 ec 08             	sub    $0x8,%esp
 54d:	50                   	push   %eax
 54e:	ff 75 08             	pushl  0x8(%ebp)
 551:	e8 04 fe ff ff       	call   35a <putc>
 556:	83 c4 10             	add    $0x10,%esp
        ap++;
 559:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55d:	eb 42                	jmp    5a1 <printf+0x170>
      } else if(c == '%'){
 55f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 563:	75 17                	jne    57c <printf+0x14b>
        putc(fd, c);
 565:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 568:	0f be c0             	movsbl %al,%eax
 56b:	83 ec 08             	sub    $0x8,%esp
 56e:	50                   	push   %eax
 56f:	ff 75 08             	pushl  0x8(%ebp)
 572:	e8 e3 fd ff ff       	call   35a <putc>
 577:	83 c4 10             	add    $0x10,%esp
 57a:	eb 25                	jmp    5a1 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 57c:	83 ec 08             	sub    $0x8,%esp
 57f:	6a 25                	push   $0x25
 581:	ff 75 08             	pushl  0x8(%ebp)
 584:	e8 d1 fd ff ff       	call   35a <putc>
 589:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 58c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58f:	0f be c0             	movsbl %al,%eax
 592:	83 ec 08             	sub    $0x8,%esp
 595:	50                   	push   %eax
 596:	ff 75 08             	pushl  0x8(%ebp)
 599:	e8 bc fd ff ff       	call   35a <putc>
 59e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ac:	8b 55 0c             	mov    0xc(%ebp),%edx
 5af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b2:	01 d0                	add    %edx,%eax
 5b4:	0f b6 00             	movzbl (%eax),%eax
 5b7:	84 c0                	test   %al,%al
 5b9:	0f 85 94 fe ff ff    	jne    453 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5bf:	90                   	nop
 5c0:	c9                   	leave  
 5c1:	c3                   	ret    

000005c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c2:	55                   	push   %ebp
 5c3:	89 e5                	mov    %esp,%ebp
 5c5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c8:	8b 45 08             	mov    0x8(%ebp),%eax
 5cb:	83 e8 08             	sub    $0x8,%eax
 5ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	a1 74 0a 00 00       	mov    0xa74,%eax
 5d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d9:	eb 24                	jmp    5ff <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5de:	8b 00                	mov    (%eax),%eax
 5e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e3:	77 12                	ja     5f7 <free+0x35>
 5e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5eb:	77 24                	ja     611 <free+0x4f>
 5ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f5:	77 1a                	ja     611 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 605:	76 d4                	jbe    5db <free+0x19>
 607:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 60f:	76 ca                	jbe    5db <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 611:	8b 45 f8             	mov    -0x8(%ebp),%eax
 614:	8b 40 04             	mov    0x4(%eax),%eax
 617:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 61e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 621:	01 c2                	add    %eax,%edx
 623:	8b 45 fc             	mov    -0x4(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	39 c2                	cmp    %eax,%edx
 62a:	75 24                	jne    650 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 62c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62f:	8b 50 04             	mov    0x4(%eax),%edx
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	8b 40 04             	mov    0x4(%eax),%eax
 63a:	01 c2                	add    %eax,%edx
 63c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 642:	8b 45 fc             	mov    -0x4(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	8b 10                	mov    (%eax),%edx
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	89 10                	mov    %edx,(%eax)
 64e:	eb 0a                	jmp    65a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 10                	mov    (%eax),%edx
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 40 04             	mov    0x4(%eax),%eax
 660:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	01 d0                	add    %edx,%eax
 66c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66f:	75 20                	jne    691 <free+0xcf>
    p->s.size += bp->s.size;
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	8b 50 04             	mov    0x4(%eax),%edx
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	8b 40 04             	mov    0x4(%eax),%eax
 67d:	01 c2                	add    %eax,%edx
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 685:	8b 45 f8             	mov    -0x8(%ebp),%eax
 688:	8b 10                	mov    (%eax),%edx
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	89 10                	mov    %edx,(%eax)
 68f:	eb 08                	jmp    699 <free+0xd7>
  } else
    p->s.ptr = bp;
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 55 f8             	mov    -0x8(%ebp),%edx
 697:	89 10                	mov    %edx,(%eax)
  freep = p;
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	a3 74 0a 00 00       	mov    %eax,0xa74
}
 6a1:	90                   	nop
 6a2:	c9                   	leave  
 6a3:	c3                   	ret    

000006a4 <morecore>:

static Header*
morecore(uint nu)
{
 6a4:	55                   	push   %ebp
 6a5:	89 e5                	mov    %esp,%ebp
 6a7:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6aa:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6b1:	77 07                	ja     6ba <morecore+0x16>
    nu = 4096;
 6b3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ba:	8b 45 08             	mov    0x8(%ebp),%eax
 6bd:	c1 e0 03             	shl    $0x3,%eax
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	50                   	push   %eax
 6c4:	e8 61 fc ff ff       	call   32a <sbrk>
 6c9:	83 c4 10             	add    $0x10,%esp
 6cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6cf:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6d3:	75 07                	jne    6dc <morecore+0x38>
    return 0;
 6d5:	b8 00 00 00 00       	mov    $0x0,%eax
 6da:	eb 26                	jmp    702 <morecore+0x5e>
  hp = (Header*)p;
 6dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e5:	8b 55 08             	mov    0x8(%ebp),%edx
 6e8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ee:	83 c0 08             	add    $0x8,%eax
 6f1:	83 ec 0c             	sub    $0xc,%esp
 6f4:	50                   	push   %eax
 6f5:	e8 c8 fe ff ff       	call   5c2 <free>
 6fa:	83 c4 10             	add    $0x10,%esp
  return freep;
 6fd:	a1 74 0a 00 00       	mov    0xa74,%eax
}
 702:	c9                   	leave  
 703:	c3                   	ret    

00000704 <malloc>:

void*
malloc(uint nbytes)
{
 704:	55                   	push   %ebp
 705:	89 e5                	mov    %esp,%ebp
 707:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70a:	8b 45 08             	mov    0x8(%ebp),%eax
 70d:	83 c0 07             	add    $0x7,%eax
 710:	c1 e8 03             	shr    $0x3,%eax
 713:	83 c0 01             	add    $0x1,%eax
 716:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 719:	a1 74 0a 00 00       	mov    0xa74,%eax
 71e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 721:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 725:	75 23                	jne    74a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 727:	c7 45 f0 6c 0a 00 00 	movl   $0xa6c,-0x10(%ebp)
 72e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 731:	a3 74 0a 00 00       	mov    %eax,0xa74
 736:	a1 74 0a 00 00       	mov    0xa74,%eax
 73b:	a3 6c 0a 00 00       	mov    %eax,0xa6c
    base.s.size = 0;
 740:	c7 05 70 0a 00 00 00 	movl   $0x0,0xa70
 747:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	8b 40 04             	mov    0x4(%eax),%eax
 758:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 75b:	72 4d                	jb     7aa <malloc+0xa6>
      if(p->s.size == nunits)
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	8b 40 04             	mov    0x4(%eax),%eax
 763:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 766:	75 0c                	jne    774 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	8b 10                	mov    (%eax),%edx
 76d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 770:	89 10                	mov    %edx,(%eax)
 772:	eb 26                	jmp    79a <malloc+0x96>
      else {
        p->s.size -= nunits;
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	8b 40 04             	mov    0x4(%eax),%eax
 77a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 77d:	89 c2                	mov    %eax,%edx
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	c1 e0 03             	shl    $0x3,%eax
 78e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	8b 55 ec             	mov    -0x14(%ebp),%edx
 797:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	a3 74 0a 00 00       	mov    %eax,0xa74
      return (void*)(p + 1);
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	83 c0 08             	add    $0x8,%eax
 7a8:	eb 3b                	jmp    7e5 <malloc+0xe1>
    }
    if(p == freep)
 7aa:	a1 74 0a 00 00       	mov    0xa74,%eax
 7af:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7b2:	75 1e                	jne    7d2 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7b4:	83 ec 0c             	sub    $0xc,%esp
 7b7:	ff 75 ec             	pushl  -0x14(%ebp)
 7ba:	e8 e5 fe ff ff       	call   6a4 <morecore>
 7bf:	83 c4 10             	add    $0x10,%esp
 7c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c9:	75 07                	jne    7d2 <malloc+0xce>
        return 0;
 7cb:	b8 00 00 00 00       	mov    $0x0,%eax
 7d0:	eb 13                	jmp    7e5 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7e0:	e9 6d ff ff ff       	jmp    752 <malloc+0x4e>
}
 7e5:	c9                   	leave  
 7e6:	c3                   	ret    
