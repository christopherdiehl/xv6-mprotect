
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

int signal(int signum, void(*handler)(int,siginfo_t))
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
 29a:	b8 01 00 00 00       	mov    $0x1,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <exit>:
 2a2:	b8 02 00 00 00       	mov    $0x2,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <wait>:
 2aa:	b8 03 00 00 00       	mov    $0x3,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <pipe>:
 2b2:	b8 04 00 00 00       	mov    $0x4,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <read>:
 2ba:	b8 05 00 00 00       	mov    $0x5,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <write>:
 2c2:	b8 10 00 00 00       	mov    $0x10,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <close>:
 2ca:	b8 15 00 00 00       	mov    $0x15,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <kill>:
 2d2:	b8 06 00 00 00       	mov    $0x6,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <exec>:
 2da:	b8 07 00 00 00       	mov    $0x7,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <open>:
 2e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <mknod>:
 2ea:	b8 11 00 00 00       	mov    $0x11,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <unlink>:
 2f2:	b8 12 00 00 00       	mov    $0x12,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <fstat>:
 2fa:	b8 08 00 00 00       	mov    $0x8,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <link>:
 302:	b8 13 00 00 00       	mov    $0x13,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <mkdir>:
 30a:	b8 14 00 00 00       	mov    $0x14,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <chdir>:
 312:	b8 09 00 00 00       	mov    $0x9,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <dup>:
 31a:	b8 0a 00 00 00       	mov    $0xa,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <getpid>:
 322:	b8 0b 00 00 00       	mov    $0xb,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <sbrk>:
 32a:	b8 0c 00 00 00       	mov    $0xc,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <sleep>:
 332:	b8 0d 00 00 00       	mov    $0xd,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <uptime>:
 33a:	b8 0e 00 00 00       	mov    $0xe,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <halt>:
 342:	b8 16 00 00 00       	mov    $0x16,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <signal_register>:
 34a:	b8 17 00 00 00       	mov    $0x17,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <signal_restorer>:
 352:	b8 18 00 00 00       	mov    $0x18,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <mprotect>:
 35a:	b8 19 00 00 00       	mov    $0x19,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
 365:	83 ec 18             	sub    $0x18,%esp
 368:	8b 45 0c             	mov    0xc(%ebp),%eax
 36b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 36e:	83 ec 04             	sub    $0x4,%esp
 371:	6a 01                	push   $0x1
 373:	8d 45 f4             	lea    -0xc(%ebp),%eax
 376:	50                   	push   %eax
 377:	ff 75 08             	pushl  0x8(%ebp)
 37a:	e8 43 ff ff ff       	call   2c2 <write>
 37f:	83 c4 10             	add    $0x10,%esp
}
 382:	90                   	nop
 383:	c9                   	leave  
 384:	c3                   	ret    

00000385 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 385:	55                   	push   %ebp
 386:	89 e5                	mov    %esp,%ebp
 388:	53                   	push   %ebx
 389:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 38c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 393:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 397:	74 17                	je     3b0 <printint+0x2b>
 399:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 39d:	79 11                	jns    3b0 <printint+0x2b>
    neg = 1;
 39f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a9:	f7 d8                	neg    %eax
 3ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ae:	eb 06                	jmp    3b6 <printint+0x31>
  } else {
    x = xx;
 3b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3bd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c0:	8d 41 01             	lea    0x1(%ecx),%eax
 3c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cc:	ba 00 00 00 00       	mov    $0x0,%edx
 3d1:	f7 f3                	div    %ebx
 3d3:	89 d0                	mov    %edx,%eax
 3d5:	0f b6 80 60 0a 00 00 	movzbl 0xa60(%eax),%eax
 3dc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e6:	ba 00 00 00 00       	mov    $0x0,%edx
 3eb:	f7 f3                	div    %ebx
 3ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f4:	75 c7                	jne    3bd <printint+0x38>
  if(neg)
 3f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3fa:	74 2d                	je     429 <printint+0xa4>
    buf[i++] = '-';
 3fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ff:	8d 50 01             	lea    0x1(%eax),%edx
 402:	89 55 f4             	mov    %edx,-0xc(%ebp)
 405:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 40a:	eb 1d                	jmp    429 <printint+0xa4>
    putc(fd, buf[i]);
 40c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 40f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 412:	01 d0                	add    %edx,%eax
 414:	0f b6 00             	movzbl (%eax),%eax
 417:	0f be c0             	movsbl %al,%eax
 41a:	83 ec 08             	sub    $0x8,%esp
 41d:	50                   	push   %eax
 41e:	ff 75 08             	pushl  0x8(%ebp)
 421:	e8 3c ff ff ff       	call   362 <putc>
 426:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 429:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 42d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 431:	79 d9                	jns    40c <printint+0x87>
    putc(fd, buf[i]);
}
 433:	90                   	nop
 434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 437:	c9                   	leave  
 438:	c3                   	ret    

00000439 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 439:	55                   	push   %ebp
 43a:	89 e5                	mov    %esp,%ebp
 43c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 43f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 446:	8d 45 0c             	lea    0xc(%ebp),%eax
 449:	83 c0 04             	add    $0x4,%eax
 44c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 44f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 456:	e9 59 01 00 00       	jmp    5b4 <printf+0x17b>
    c = fmt[i] & 0xff;
 45b:	8b 55 0c             	mov    0xc(%ebp),%edx
 45e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 461:	01 d0                	add    %edx,%eax
 463:	0f b6 00             	movzbl (%eax),%eax
 466:	0f be c0             	movsbl %al,%eax
 469:	25 ff 00 00 00       	and    $0xff,%eax
 46e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 471:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 475:	75 2c                	jne    4a3 <printf+0x6a>
      if(c == '%'){
 477:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 47b:	75 0c                	jne    489 <printf+0x50>
        state = '%';
 47d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 484:	e9 27 01 00 00       	jmp    5b0 <printf+0x177>
      } else {
        putc(fd, c);
 489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 48c:	0f be c0             	movsbl %al,%eax
 48f:	83 ec 08             	sub    $0x8,%esp
 492:	50                   	push   %eax
 493:	ff 75 08             	pushl  0x8(%ebp)
 496:	e8 c7 fe ff ff       	call   362 <putc>
 49b:	83 c4 10             	add    $0x10,%esp
 49e:	e9 0d 01 00 00       	jmp    5b0 <printf+0x177>
      }
    } else if(state == '%'){
 4a3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a7:	0f 85 03 01 00 00    	jne    5b0 <printf+0x177>
      if(c == 'd'){
 4ad:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b1:	75 1e                	jne    4d1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b6:	8b 00                	mov    (%eax),%eax
 4b8:	6a 01                	push   $0x1
 4ba:	6a 0a                	push   $0xa
 4bc:	50                   	push   %eax
 4bd:	ff 75 08             	pushl  0x8(%ebp)
 4c0:	e8 c0 fe ff ff       	call   385 <printint>
 4c5:	83 c4 10             	add    $0x10,%esp
        ap++;
 4c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4cc:	e9 d8 00 00 00       	jmp    5a9 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4d1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4d5:	74 06                	je     4dd <printf+0xa4>
 4d7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4db:	75 1e                	jne    4fb <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e0:	8b 00                	mov    (%eax),%eax
 4e2:	6a 00                	push   $0x0
 4e4:	6a 10                	push   $0x10
 4e6:	50                   	push   %eax
 4e7:	ff 75 08             	pushl  0x8(%ebp)
 4ea:	e8 96 fe ff ff       	call   385 <printint>
 4ef:	83 c4 10             	add    $0x10,%esp
        ap++;
 4f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f6:	e9 ae 00 00 00       	jmp    5a9 <printf+0x170>
      } else if(c == 's'){
 4fb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4ff:	75 43                	jne    544 <printf+0x10b>
        s = (char*)*ap;
 501:	8b 45 e8             	mov    -0x18(%ebp),%eax
 504:	8b 00                	mov    (%eax),%eax
 506:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 509:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 50d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 511:	75 25                	jne    538 <printf+0xff>
          s = "(null)";
 513:	c7 45 f4 ef 07 00 00 	movl   $0x7ef,-0xc(%ebp)
        while(*s != 0){
 51a:	eb 1c                	jmp    538 <printf+0xff>
          putc(fd, *s);
 51c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51f:	0f b6 00             	movzbl (%eax),%eax
 522:	0f be c0             	movsbl %al,%eax
 525:	83 ec 08             	sub    $0x8,%esp
 528:	50                   	push   %eax
 529:	ff 75 08             	pushl  0x8(%ebp)
 52c:	e8 31 fe ff ff       	call   362 <putc>
 531:	83 c4 10             	add    $0x10,%esp
          s++;
 534:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 538:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53b:	0f b6 00             	movzbl (%eax),%eax
 53e:	84 c0                	test   %al,%al
 540:	75 da                	jne    51c <printf+0xe3>
 542:	eb 65                	jmp    5a9 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 544:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 548:	75 1d                	jne    567 <printf+0x12e>
        putc(fd, *ap);
 54a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54d:	8b 00                	mov    (%eax),%eax
 54f:	0f be c0             	movsbl %al,%eax
 552:	83 ec 08             	sub    $0x8,%esp
 555:	50                   	push   %eax
 556:	ff 75 08             	pushl  0x8(%ebp)
 559:	e8 04 fe ff ff       	call   362 <putc>
 55e:	83 c4 10             	add    $0x10,%esp
        ap++;
 561:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 565:	eb 42                	jmp    5a9 <printf+0x170>
      } else if(c == '%'){
 567:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56b:	75 17                	jne    584 <printf+0x14b>
        putc(fd, c);
 56d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 570:	0f be c0             	movsbl %al,%eax
 573:	83 ec 08             	sub    $0x8,%esp
 576:	50                   	push   %eax
 577:	ff 75 08             	pushl  0x8(%ebp)
 57a:	e8 e3 fd ff ff       	call   362 <putc>
 57f:	83 c4 10             	add    $0x10,%esp
 582:	eb 25                	jmp    5a9 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 584:	83 ec 08             	sub    $0x8,%esp
 587:	6a 25                	push   $0x25
 589:	ff 75 08             	pushl  0x8(%ebp)
 58c:	e8 d1 fd ff ff       	call   362 <putc>
 591:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 597:	0f be c0             	movsbl %al,%eax
 59a:	83 ec 08             	sub    $0x8,%esp
 59d:	50                   	push   %eax
 59e:	ff 75 08             	pushl  0x8(%ebp)
 5a1:	e8 bc fd ff ff       	call   362 <putc>
 5a6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5b4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ba:	01 d0                	add    %edx,%eax
 5bc:	0f b6 00             	movzbl (%eax),%eax
 5bf:	84 c0                	test   %al,%al
 5c1:	0f 85 94 fe ff ff    	jne    45b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5c7:	90                   	nop
 5c8:	c9                   	leave  
 5c9:	c3                   	ret    

000005ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ca:	55                   	push   %ebp
 5cb:	89 e5                	mov    %esp,%ebp
 5cd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d0:	8b 45 08             	mov    0x8(%ebp),%eax
 5d3:	83 e8 08             	sub    $0x8,%eax
 5d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d9:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 5de:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e1:	eb 24                	jmp    607 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e6:	8b 00                	mov    (%eax),%eax
 5e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5eb:	77 12                	ja     5ff <free+0x35>
 5ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f3:	77 24                	ja     619 <free+0x4f>
 5f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f8:	8b 00                	mov    (%eax),%eax
 5fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5fd:	77 1a                	ja     619 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 602:	8b 00                	mov    (%eax),%eax
 604:	89 45 fc             	mov    %eax,-0x4(%ebp)
 607:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60d:	76 d4                	jbe    5e3 <free+0x19>
 60f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 612:	8b 00                	mov    (%eax),%eax
 614:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 617:	76 ca                	jbe    5e3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 619:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61c:	8b 40 04             	mov    0x4(%eax),%eax
 61f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 626:	8b 45 f8             	mov    -0x8(%ebp),%eax
 629:	01 c2                	add    %eax,%edx
 62b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	39 c2                	cmp    %eax,%edx
 632:	75 24                	jne    658 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 634:	8b 45 f8             	mov    -0x8(%ebp),%eax
 637:	8b 50 04             	mov    0x4(%eax),%edx
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	8b 40 04             	mov    0x4(%eax),%eax
 642:	01 c2                	add    %eax,%edx
 644:	8b 45 f8             	mov    -0x8(%ebp),%eax
 647:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	8b 10                	mov    (%eax),%edx
 651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 654:	89 10                	mov    %edx,(%eax)
 656:	eb 0a                	jmp    662 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 10                	mov    (%eax),%edx
 65d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 660:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	8b 40 04             	mov    0x4(%eax),%eax
 668:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	01 d0                	add    %edx,%eax
 674:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 677:	75 20                	jne    699 <free+0xcf>
    p->s.size += bp->s.size;
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	8b 50 04             	mov    0x4(%eax),%edx
 67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 682:	8b 40 04             	mov    0x4(%eax),%eax
 685:	01 c2                	add    %eax,%edx
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 68d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 690:	8b 10                	mov    (%eax),%edx
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	89 10                	mov    %edx,(%eax)
 697:	eb 08                	jmp    6a1 <free+0xd7>
  } else
    p->s.ptr = bp;
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 69f:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	a3 7c 0a 00 00       	mov    %eax,0xa7c
}
 6a9:	90                   	nop
 6aa:	c9                   	leave  
 6ab:	c3                   	ret    

000006ac <morecore>:

static Header*
morecore(uint nu)
{
 6ac:	55                   	push   %ebp
 6ad:	89 e5                	mov    %esp,%ebp
 6af:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6b9:	77 07                	ja     6c2 <morecore+0x16>
    nu = 4096;
 6bb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c2:	8b 45 08             	mov    0x8(%ebp),%eax
 6c5:	c1 e0 03             	shl    $0x3,%eax
 6c8:	83 ec 0c             	sub    $0xc,%esp
 6cb:	50                   	push   %eax
 6cc:	e8 59 fc ff ff       	call   32a <sbrk>
 6d1:	83 c4 10             	add    $0x10,%esp
 6d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6d7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6db:	75 07                	jne    6e4 <morecore+0x38>
    return 0;
 6dd:	b8 00 00 00 00       	mov    $0x0,%eax
 6e2:	eb 26                	jmp    70a <morecore+0x5e>
  hp = (Header*)p;
 6e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ed:	8b 55 08             	mov    0x8(%ebp),%edx
 6f0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f6:	83 c0 08             	add    $0x8,%eax
 6f9:	83 ec 0c             	sub    $0xc,%esp
 6fc:	50                   	push   %eax
 6fd:	e8 c8 fe ff ff       	call   5ca <free>
 702:	83 c4 10             	add    $0x10,%esp
  return freep;
 705:	a1 7c 0a 00 00       	mov    0xa7c,%eax
}
 70a:	c9                   	leave  
 70b:	c3                   	ret    

0000070c <malloc>:

void*
malloc(uint nbytes)
{
 70c:	55                   	push   %ebp
 70d:	89 e5                	mov    %esp,%ebp
 70f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 712:	8b 45 08             	mov    0x8(%ebp),%eax
 715:	83 c0 07             	add    $0x7,%eax
 718:	c1 e8 03             	shr    $0x3,%eax
 71b:	83 c0 01             	add    $0x1,%eax
 71e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 721:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 726:	89 45 f0             	mov    %eax,-0x10(%ebp)
 729:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 72d:	75 23                	jne    752 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 72f:	c7 45 f0 74 0a 00 00 	movl   $0xa74,-0x10(%ebp)
 736:	8b 45 f0             	mov    -0x10(%ebp),%eax
 739:	a3 7c 0a 00 00       	mov    %eax,0xa7c
 73e:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 743:	a3 74 0a 00 00       	mov    %eax,0xa74
    base.s.size = 0;
 748:	c7 05 78 0a 00 00 00 	movl   $0x0,0xa78
 74f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 752:	8b 45 f0             	mov    -0x10(%ebp),%eax
 755:	8b 00                	mov    (%eax),%eax
 757:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 75a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75d:	8b 40 04             	mov    0x4(%eax),%eax
 760:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 763:	72 4d                	jb     7b2 <malloc+0xa6>
      if(p->s.size == nunits)
 765:	8b 45 f4             	mov    -0xc(%ebp),%eax
 768:	8b 40 04             	mov    0x4(%eax),%eax
 76b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76e:	75 0c                	jne    77c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 770:	8b 45 f4             	mov    -0xc(%ebp),%eax
 773:	8b 10                	mov    (%eax),%edx
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	89 10                	mov    %edx,(%eax)
 77a:	eb 26                	jmp    7a2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 77c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77f:	8b 40 04             	mov    0x4(%eax),%eax
 782:	2b 45 ec             	sub    -0x14(%ebp),%eax
 785:	89 c2                	mov    %eax,%edx
 787:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	8b 40 04             	mov    0x4(%eax),%eax
 793:	c1 e0 03             	shl    $0x3,%eax
 796:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 79f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a5:	a3 7c 0a 00 00       	mov    %eax,0xa7c
      return (void*)(p + 1);
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	83 c0 08             	add    $0x8,%eax
 7b0:	eb 3b                	jmp    7ed <malloc+0xe1>
    }
    if(p == freep)
 7b2:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 7b7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ba:	75 1e                	jne    7da <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7bc:	83 ec 0c             	sub    $0xc,%esp
 7bf:	ff 75 ec             	pushl  -0x14(%ebp)
 7c2:	e8 e5 fe ff ff       	call   6ac <morecore>
 7c7:	83 c4 10             	add    $0x10,%esp
 7ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d1:	75 07                	jne    7da <malloc+0xce>
        return 0;
 7d3:	b8 00 00 00 00       	mov    $0x0,%eax
 7d8:	eb 13                	jmp    7ed <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7e8:	e9 6d ff ff ff       	jmp    75a <malloc+0x4e>
}
 7ed:	c9                   	leave  
 7ee:	c3                   	ret    
