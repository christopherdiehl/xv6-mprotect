
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 50 08 00 00       	push   $0x850
  1e:	6a 02                	push   $0x2
  20:	e8 75 04 00 00       	call   49a <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 ce 02 00 00       	call   2fb <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 14 03 00 00       	call   35b <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 63 08 00 00       	push   $0x863
  65:	6a 02                	push   $0x2
  67:	e8 2e 04 00 00       	call   49a <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 87 02 00 00       	call   2fb <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	90                   	nop
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	8d 50 01             	lea    0x1(%eax),%edx
  ad:	89 55 08             	mov    %edx,0x8(%ebp)
  b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	ff 75 0c             	pushl  0xc(%ebp)
 13a:	ff 75 08             	pushl  0x8(%ebp)
 13d:	e8 32 ff ff ff       	call   74 <stosb>
 142:	83 c4 0c             	add    $0xc,%esp
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18a:	eb 42                	jmp    1ce <gets+0x51>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	50                   	push   %eax
 195:	6a 00                	push   $0x0
 197:	e8 77 01 00 00       	call   313 <read>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	7e 33                	jle    1db <gets+0x5e>
      break;
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 16                	je     1dc <gets+0x5f>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0e                	je     1dc <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d7:	7c b3                	jl     18c <gets+0xf>
 1d9:	eb 01                	jmp    1dc <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1db:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:

int
stat(char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	6a 00                	push   $0x0
 1f7:	ff 75 08             	pushl  0x8(%ebp)
 1fa:	e8 3c 01 00 00       	call   33b <open>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x26>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 25                	jmp    237 <stat+0x4b>
  r = fstat(fd, st);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 f4             	pushl  -0xc(%ebp)
 21b:	e8 33 01 00 00       	call   353 <fstat>
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 226:	83 ec 0c             	sub    $0xc,%esp
 229:	ff 75 f4             	pushl  -0xc(%ebp)
 22c:	e8 f2 00 00 00       	call   323 <close>
 231:	83 c4 10             	add    $0x10,%esp
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 25                	jmp    26d <atoi+0x34>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	89 c1                	mov    %eax,%ecx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 08             	mov    %edx,0x8(%ebp)
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f be c0             	movsbl %al,%eax
 265:	01 c8                	add    %ecx,%eax
 267:	83 e8 30             	sub    $0x30,%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x48>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c7                	jle    248 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 298:	eb 17                	jmp    2b1 <memmove+0x2b>
    *dst++ = *src++;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29d:	8d 50 01             	lea    0x1(%eax),%edx
 2a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a6:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2ac:	0f b6 12             	movzbl (%edx),%edx
 2af:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b1:	8b 45 10             	mov    0x10(%ebp),%eax
 2b4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b7:	89 55 10             	mov    %edx,0x10(%ebp)
 2ba:	85 c0                	test   %eax,%eax
 2bc:	7f dc                	jg     29a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <restorer>:
 2c3:	83 c4 0c             	add    $0xc,%esp
 2c6:	5a                   	pop    %edx
 2c7:	59                   	pop    %ecx
 2c8:	58                   	pop    %eax
 2c9:	c3                   	ret    

000002ca <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 2d0:	83 ec 0c             	sub    $0xc,%esp
 2d3:	68 c3 02 00 00       	push   $0x2c3
 2d8:	e8 ce 00 00 00       	call   3ab <signal_restorer>
 2dd:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 2e0:	83 ec 08             	sub    $0x8,%esp
 2e3:	ff 75 0c             	pushl  0xc(%ebp)
 2e6:	ff 75 08             	pushl  0x8(%ebp)
 2e9:	e8 b5 00 00 00       	call   3a3 <signal_register>
 2ee:	83 c4 10             	add    $0x10,%esp
}
 2f1:	c9                   	leave  
 2f2:	c3                   	ret    

000002f3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f3:	b8 01 00 00 00       	mov    $0x1,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <exit>:
SYSCALL(exit)
 2fb:	b8 02 00 00 00       	mov    $0x2,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <wait>:
SYSCALL(wait)
 303:	b8 03 00 00 00       	mov    $0x3,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <pipe>:
SYSCALL(pipe)
 30b:	b8 04 00 00 00       	mov    $0x4,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <read>:
SYSCALL(read)
 313:	b8 05 00 00 00       	mov    $0x5,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <write>:
SYSCALL(write)
 31b:	b8 10 00 00 00       	mov    $0x10,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <close>:
SYSCALL(close)
 323:	b8 15 00 00 00       	mov    $0x15,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <kill>:
SYSCALL(kill)
 32b:	b8 06 00 00 00       	mov    $0x6,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <exec>:
SYSCALL(exec)
 333:	b8 07 00 00 00       	mov    $0x7,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <open>:
SYSCALL(open)
 33b:	b8 0f 00 00 00       	mov    $0xf,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <mknod>:
SYSCALL(mknod)
 343:	b8 11 00 00 00       	mov    $0x11,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <unlink>:
SYSCALL(unlink)
 34b:	b8 12 00 00 00       	mov    $0x12,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <fstat>:
SYSCALL(fstat)
 353:	b8 08 00 00 00       	mov    $0x8,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <link>:
SYSCALL(link)
 35b:	b8 13 00 00 00       	mov    $0x13,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <mkdir>:
SYSCALL(mkdir)
 363:	b8 14 00 00 00       	mov    $0x14,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <chdir>:
SYSCALL(chdir)
 36b:	b8 09 00 00 00       	mov    $0x9,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <dup>:
SYSCALL(dup)
 373:	b8 0a 00 00 00       	mov    $0xa,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <getpid>:
SYSCALL(getpid)
 37b:	b8 0b 00 00 00       	mov    $0xb,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <sbrk>:
SYSCALL(sbrk)
 383:	b8 0c 00 00 00       	mov    $0xc,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <sleep>:
SYSCALL(sleep)
 38b:	b8 0d 00 00 00       	mov    $0xd,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <uptime>:
SYSCALL(uptime)
 393:	b8 0e 00 00 00       	mov    $0xe,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <halt>:
SYSCALL(halt)
 39b:	b8 16 00 00 00       	mov    $0x16,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <signal_register>:
SYSCALL(signal_register)
 3a3:	b8 17 00 00 00       	mov    $0x17,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <signal_restorer>:
SYSCALL(signal_restorer)
 3ab:	b8 18 00 00 00       	mov    $0x18,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <mprotect>:
SYSCALL(mprotect)
 3b3:	b8 19 00 00 00       	mov    $0x19,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <cowfork>:
SYSCALL(cowfork)
 3bb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c3:	55                   	push   %ebp
 3c4:	89 e5                	mov    %esp,%ebp
 3c6:	83 ec 18             	sub    $0x18,%esp
 3c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cc:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3cf:	83 ec 04             	sub    $0x4,%esp
 3d2:	6a 01                	push   $0x1
 3d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3d7:	50                   	push   %eax
 3d8:	ff 75 08             	pushl  0x8(%ebp)
 3db:	e8 3b ff ff ff       	call   31b <write>
 3e0:	83 c4 10             	add    $0x10,%esp
}
 3e3:	90                   	nop
 3e4:	c9                   	leave  
 3e5:	c3                   	ret    

000003e6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	53                   	push   %ebx
 3ea:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3f4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f8:	74 17                	je     411 <printint+0x2b>
 3fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3fe:	79 11                	jns    411 <printint+0x2b>
    neg = 1;
 400:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	f7 d8                	neg    %eax
 40c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40f:	eb 06                	jmp    417 <printint+0x31>
  } else {
    x = xx;
 411:	8b 45 0c             	mov    0xc(%ebp),%eax
 414:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 41e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 421:	8d 41 01             	lea    0x1(%ecx),%eax
 424:	89 45 f4             	mov    %eax,-0xc(%ebp)
 427:	8b 5d 10             	mov    0x10(%ebp),%ebx
 42a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42d:	ba 00 00 00 00       	mov    $0x0,%edx
 432:	f7 f3                	div    %ebx
 434:	89 d0                	mov    %edx,%eax
 436:	0f b6 80 ec 0a 00 00 	movzbl 0xaec(%eax),%eax
 43d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 441:	8b 5d 10             	mov    0x10(%ebp),%ebx
 444:	8b 45 ec             	mov    -0x14(%ebp),%eax
 447:	ba 00 00 00 00       	mov    $0x0,%edx
 44c:	f7 f3                	div    %ebx
 44e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 451:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 455:	75 c7                	jne    41e <printint+0x38>
  if(neg)
 457:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45b:	74 2d                	je     48a <printint+0xa4>
    buf[i++] = '-';
 45d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 460:	8d 50 01             	lea    0x1(%eax),%edx
 463:	89 55 f4             	mov    %edx,-0xc(%ebp)
 466:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 46b:	eb 1d                	jmp    48a <printint+0xa4>
    putc(fd, buf[i]);
 46d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 470:	8b 45 f4             	mov    -0xc(%ebp),%eax
 473:	01 d0                	add    %edx,%eax
 475:	0f b6 00             	movzbl (%eax),%eax
 478:	0f be c0             	movsbl %al,%eax
 47b:	83 ec 08             	sub    $0x8,%esp
 47e:	50                   	push   %eax
 47f:	ff 75 08             	pushl  0x8(%ebp)
 482:	e8 3c ff ff ff       	call   3c3 <putc>
 487:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 48a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 48e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 492:	79 d9                	jns    46d <printint+0x87>
    putc(fd, buf[i]);
}
 494:	90                   	nop
 495:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 498:	c9                   	leave  
 499:	c3                   	ret    

0000049a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 49a:	55                   	push   %ebp
 49b:	89 e5                	mov    %esp,%ebp
 49d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4a7:	8d 45 0c             	lea    0xc(%ebp),%eax
 4aa:	83 c0 04             	add    $0x4,%eax
 4ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4b7:	e9 59 01 00 00       	jmp    615 <printf+0x17b>
    c = fmt[i] & 0xff;
 4bc:	8b 55 0c             	mov    0xc(%ebp),%edx
 4bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4c2:	01 d0                	add    %edx,%eax
 4c4:	0f b6 00             	movzbl (%eax),%eax
 4c7:	0f be c0             	movsbl %al,%eax
 4ca:	25 ff 00 00 00       	and    $0xff,%eax
 4cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d6:	75 2c                	jne    504 <printf+0x6a>
      if(c == '%'){
 4d8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4dc:	75 0c                	jne    4ea <printf+0x50>
        state = '%';
 4de:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4e5:	e9 27 01 00 00       	jmp    611 <printf+0x177>
      } else {
        putc(fd, c);
 4ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ed:	0f be c0             	movsbl %al,%eax
 4f0:	83 ec 08             	sub    $0x8,%esp
 4f3:	50                   	push   %eax
 4f4:	ff 75 08             	pushl  0x8(%ebp)
 4f7:	e8 c7 fe ff ff       	call   3c3 <putc>
 4fc:	83 c4 10             	add    $0x10,%esp
 4ff:	e9 0d 01 00 00       	jmp    611 <printf+0x177>
      }
    } else if(state == '%'){
 504:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 508:	0f 85 03 01 00 00    	jne    611 <printf+0x177>
      if(c == 'd'){
 50e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 512:	75 1e                	jne    532 <printf+0x98>
        printint(fd, *ap, 10, 1);
 514:	8b 45 e8             	mov    -0x18(%ebp),%eax
 517:	8b 00                	mov    (%eax),%eax
 519:	6a 01                	push   $0x1
 51b:	6a 0a                	push   $0xa
 51d:	50                   	push   %eax
 51e:	ff 75 08             	pushl  0x8(%ebp)
 521:	e8 c0 fe ff ff       	call   3e6 <printint>
 526:	83 c4 10             	add    $0x10,%esp
        ap++;
 529:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52d:	e9 d8 00 00 00       	jmp    60a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 532:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 536:	74 06                	je     53e <printf+0xa4>
 538:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 53c:	75 1e                	jne    55c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 53e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 541:	8b 00                	mov    (%eax),%eax
 543:	6a 00                	push   $0x0
 545:	6a 10                	push   $0x10
 547:	50                   	push   %eax
 548:	ff 75 08             	pushl  0x8(%ebp)
 54b:	e8 96 fe ff ff       	call   3e6 <printint>
 550:	83 c4 10             	add    $0x10,%esp
        ap++;
 553:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 557:	e9 ae 00 00 00       	jmp    60a <printf+0x170>
      } else if(c == 's'){
 55c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 560:	75 43                	jne    5a5 <printf+0x10b>
        s = (char*)*ap;
 562:	8b 45 e8             	mov    -0x18(%ebp),%eax
 565:	8b 00                	mov    (%eax),%eax
 567:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 56a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 56e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 572:	75 25                	jne    599 <printf+0xff>
          s = "(null)";
 574:	c7 45 f4 77 08 00 00 	movl   $0x877,-0xc(%ebp)
        while(*s != 0){
 57b:	eb 1c                	jmp    599 <printf+0xff>
          putc(fd, *s);
 57d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 580:	0f b6 00             	movzbl (%eax),%eax
 583:	0f be c0             	movsbl %al,%eax
 586:	83 ec 08             	sub    $0x8,%esp
 589:	50                   	push   %eax
 58a:	ff 75 08             	pushl  0x8(%ebp)
 58d:	e8 31 fe ff ff       	call   3c3 <putc>
 592:	83 c4 10             	add    $0x10,%esp
          s++;
 595:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 599:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59c:	0f b6 00             	movzbl (%eax),%eax
 59f:	84 c0                	test   %al,%al
 5a1:	75 da                	jne    57d <printf+0xe3>
 5a3:	eb 65                	jmp    60a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a9:	75 1d                	jne    5c8 <printf+0x12e>
        putc(fd, *ap);
 5ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ae:	8b 00                	mov    (%eax),%eax
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	83 ec 08             	sub    $0x8,%esp
 5b6:	50                   	push   %eax
 5b7:	ff 75 08             	pushl  0x8(%ebp)
 5ba:	e8 04 fe ff ff       	call   3c3 <putc>
 5bf:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c6:	eb 42                	jmp    60a <printf+0x170>
      } else if(c == '%'){
 5c8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5cc:	75 17                	jne    5e5 <printf+0x14b>
        putc(fd, c);
 5ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d1:	0f be c0             	movsbl %al,%eax
 5d4:	83 ec 08             	sub    $0x8,%esp
 5d7:	50                   	push   %eax
 5d8:	ff 75 08             	pushl  0x8(%ebp)
 5db:	e8 e3 fd ff ff       	call   3c3 <putc>
 5e0:	83 c4 10             	add    $0x10,%esp
 5e3:	eb 25                	jmp    60a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e5:	83 ec 08             	sub    $0x8,%esp
 5e8:	6a 25                	push   $0x25
 5ea:	ff 75 08             	pushl  0x8(%ebp)
 5ed:	e8 d1 fd ff ff       	call   3c3 <putc>
 5f2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f8:	0f be c0             	movsbl %al,%eax
 5fb:	83 ec 08             	sub    $0x8,%esp
 5fe:	50                   	push   %eax
 5ff:	ff 75 08             	pushl  0x8(%ebp)
 602:	e8 bc fd ff ff       	call   3c3 <putc>
 607:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 60a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 611:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 615:	8b 55 0c             	mov    0xc(%ebp),%edx
 618:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61b:	01 d0                	add    %edx,%eax
 61d:	0f b6 00             	movzbl (%eax),%eax
 620:	84 c0                	test   %al,%al
 622:	0f 85 94 fe ff ff    	jne    4bc <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 628:	90                   	nop
 629:	c9                   	leave  
 62a:	c3                   	ret    

0000062b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62b:	55                   	push   %ebp
 62c:	89 e5                	mov    %esp,%ebp
 62e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 631:	8b 45 08             	mov    0x8(%ebp),%eax
 634:	83 e8 08             	sub    $0x8,%eax
 637:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63a:	a1 08 0b 00 00       	mov    0xb08,%eax
 63f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 642:	eb 24                	jmp    668 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 00                	mov    (%eax),%eax
 649:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64c:	77 12                	ja     660 <free+0x35>
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 654:	77 24                	ja     67a <free+0x4f>
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65e:	77 1a                	ja     67a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	8b 00                	mov    (%eax),%eax
 665:	89 45 fc             	mov    %eax,-0x4(%ebp)
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66e:	76 d4                	jbe    644 <free+0x19>
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	8b 00                	mov    (%eax),%eax
 675:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 678:	76 ca                	jbe    644 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	8b 40 04             	mov    0x4(%eax),%eax
 680:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	01 c2                	add    %eax,%edx
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	39 c2                	cmp    %eax,%edx
 693:	75 24                	jne    6b9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 695:	8b 45 f8             	mov    -0x8(%ebp),%eax
 698:	8b 50 04             	mov    0x4(%eax),%edx
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 00                	mov    (%eax),%eax
 6a0:	8b 40 04             	mov    0x4(%eax),%eax
 6a3:	01 c2                	add    %eax,%edx
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	8b 10                	mov    (%eax),%edx
 6b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b5:	89 10                	mov    %edx,(%eax)
 6b7:	eb 0a                	jmp    6c3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 10                	mov    (%eax),%edx
 6be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	8b 40 04             	mov    0x4(%eax),%eax
 6c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	01 d0                	add    %edx,%eax
 6d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d8:	75 20                	jne    6fa <free+0xcf>
    p->s.size += bp->s.size;
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	8b 50 04             	mov    0x4(%eax),%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	8b 40 04             	mov    0x4(%eax),%eax
 6e6:	01 c2                	add    %eax,%edx
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	8b 10                	mov    (%eax),%edx
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	89 10                	mov    %edx,(%eax)
 6f8:	eb 08                	jmp    702 <free+0xd7>
  } else
    p->s.ptr = bp;
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 700:	89 10                	mov    %edx,(%eax)
  freep = p;
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	a3 08 0b 00 00       	mov    %eax,0xb08
}
 70a:	90                   	nop
 70b:	c9                   	leave  
 70c:	c3                   	ret    

0000070d <morecore>:

static Header*
morecore(uint nu)
{
 70d:	55                   	push   %ebp
 70e:	89 e5                	mov    %esp,%ebp
 710:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 713:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 71a:	77 07                	ja     723 <morecore+0x16>
    nu = 4096;
 71c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 723:	8b 45 08             	mov    0x8(%ebp),%eax
 726:	c1 e0 03             	shl    $0x3,%eax
 729:	83 ec 0c             	sub    $0xc,%esp
 72c:	50                   	push   %eax
 72d:	e8 51 fc ff ff       	call   383 <sbrk>
 732:	83 c4 10             	add    $0x10,%esp
 735:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 738:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 73c:	75 07                	jne    745 <morecore+0x38>
    return 0;
 73e:	b8 00 00 00 00       	mov    $0x0,%eax
 743:	eb 26                	jmp    76b <morecore+0x5e>
  hp = (Header*)p;
 745:	8b 45 f4             	mov    -0xc(%ebp),%eax
 748:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 74b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74e:	8b 55 08             	mov    0x8(%ebp),%edx
 751:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 754:	8b 45 f0             	mov    -0x10(%ebp),%eax
 757:	83 c0 08             	add    $0x8,%eax
 75a:	83 ec 0c             	sub    $0xc,%esp
 75d:	50                   	push   %eax
 75e:	e8 c8 fe ff ff       	call   62b <free>
 763:	83 c4 10             	add    $0x10,%esp
  return freep;
 766:	a1 08 0b 00 00       	mov    0xb08,%eax
}
 76b:	c9                   	leave  
 76c:	c3                   	ret    

0000076d <malloc>:

void*
malloc(uint nbytes)
{
 76d:	55                   	push   %ebp
 76e:	89 e5                	mov    %esp,%ebp
 770:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 773:	8b 45 08             	mov    0x8(%ebp),%eax
 776:	83 c0 07             	add    $0x7,%eax
 779:	c1 e8 03             	shr    $0x3,%eax
 77c:	83 c0 01             	add    $0x1,%eax
 77f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 782:	a1 08 0b 00 00       	mov    0xb08,%eax
 787:	89 45 f0             	mov    %eax,-0x10(%ebp)
 78a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 78e:	75 23                	jne    7b3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 790:	c7 45 f0 00 0b 00 00 	movl   $0xb00,-0x10(%ebp)
 797:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79a:	a3 08 0b 00 00       	mov    %eax,0xb08
 79f:	a1 08 0b 00 00       	mov    0xb08,%eax
 7a4:	a3 00 0b 00 00       	mov    %eax,0xb00
    base.s.size = 0;
 7a9:	c7 05 04 0b 00 00 00 	movl   $0x0,0xb04
 7b0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	8b 40 04             	mov    0x4(%eax),%eax
 7c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c4:	72 4d                	jb     813 <malloc+0xa6>
      if(p->s.size == nunits)
 7c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7cf:	75 0c                	jne    7dd <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 10                	mov    (%eax),%edx
 7d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d9:	89 10                	mov    %edx,(%eax)
 7db:	eb 26                	jmp    803 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	8b 40 04             	mov    0x4(%eax),%eax
 7e3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7e6:	89 c2                	mov    %eax,%edx
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	8b 40 04             	mov    0x4(%eax),%eax
 7f4:	c1 e0 03             	shl    $0x3,%eax
 7f7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 800:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 803:	8b 45 f0             	mov    -0x10(%ebp),%eax
 806:	a3 08 0b 00 00       	mov    %eax,0xb08
      return (void*)(p + 1);
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	83 c0 08             	add    $0x8,%eax
 811:	eb 3b                	jmp    84e <malloc+0xe1>
    }
    if(p == freep)
 813:	a1 08 0b 00 00       	mov    0xb08,%eax
 818:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 81b:	75 1e                	jne    83b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 81d:	83 ec 0c             	sub    $0xc,%esp
 820:	ff 75 ec             	pushl  -0x14(%ebp)
 823:	e8 e5 fe ff ff       	call   70d <morecore>
 828:	83 c4 10             	add    $0x10,%esp
 82b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 82e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 832:	75 07                	jne    83b <malloc+0xce>
        return 0;
 834:	b8 00 00 00 00       	mov    $0x0,%eax
 839:	eb 13                	jmp    84e <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	8b 00                	mov    (%eax),%eax
 846:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 849:	e9 6d ff ff ff       	jmp    7bb <malloc+0x4e>
}
 84e:	c9                   	leave  
 84f:	c3                   	ret    
