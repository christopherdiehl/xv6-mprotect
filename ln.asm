
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
  19:	68 48 08 00 00       	push   $0x848
  1e:	6a 02                	push   $0x2
  20:	e8 6d 04 00 00       	call   492 <printf>
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
  60:	68 5b 08 00 00       	push   $0x85b
  65:	6a 02                	push   $0x2
  67:	e8 26 04 00 00       	call   492 <printf>
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

int signal(int signum, void(*handler)(int,siginfo_t))
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
 2f3:	b8 01 00 00 00       	mov    $0x1,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <exit>:
 2fb:	b8 02 00 00 00       	mov    $0x2,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <wait>:
 303:	b8 03 00 00 00       	mov    $0x3,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <pipe>:
 30b:	b8 04 00 00 00       	mov    $0x4,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <read>:
 313:	b8 05 00 00 00       	mov    $0x5,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <write>:
 31b:	b8 10 00 00 00       	mov    $0x10,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <close>:
 323:	b8 15 00 00 00       	mov    $0x15,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <kill>:
 32b:	b8 06 00 00 00       	mov    $0x6,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <exec>:
 333:	b8 07 00 00 00       	mov    $0x7,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <open>:
 33b:	b8 0f 00 00 00       	mov    $0xf,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <mknod>:
 343:	b8 11 00 00 00       	mov    $0x11,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <unlink>:
 34b:	b8 12 00 00 00       	mov    $0x12,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <fstat>:
 353:	b8 08 00 00 00       	mov    $0x8,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <link>:
 35b:	b8 13 00 00 00       	mov    $0x13,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <mkdir>:
 363:	b8 14 00 00 00       	mov    $0x14,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <chdir>:
 36b:	b8 09 00 00 00       	mov    $0x9,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <dup>:
 373:	b8 0a 00 00 00       	mov    $0xa,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <getpid>:
 37b:	b8 0b 00 00 00       	mov    $0xb,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <sbrk>:
 383:	b8 0c 00 00 00       	mov    $0xc,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <sleep>:
 38b:	b8 0d 00 00 00       	mov    $0xd,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <uptime>:
 393:	b8 0e 00 00 00       	mov    $0xe,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <halt>:
 39b:	b8 16 00 00 00       	mov    $0x16,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <signal_register>:
 3a3:	b8 17 00 00 00       	mov    $0x17,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <signal_restorer>:
 3ab:	b8 18 00 00 00       	mov    $0x18,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <mprotect>:
 3b3:	b8 19 00 00 00       	mov    $0x19,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3bb:	55                   	push   %ebp
 3bc:	89 e5                	mov    %esp,%ebp
 3be:	83 ec 18             	sub    $0x18,%esp
 3c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c7:	83 ec 04             	sub    $0x4,%esp
 3ca:	6a 01                	push   $0x1
 3cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3cf:	50                   	push   %eax
 3d0:	ff 75 08             	pushl  0x8(%ebp)
 3d3:	e8 43 ff ff ff       	call   31b <write>
 3d8:	83 c4 10             	add    $0x10,%esp
}
 3db:	90                   	nop
 3dc:	c9                   	leave  
 3dd:	c3                   	ret    

000003de <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3de:	55                   	push   %ebp
 3df:	89 e5                	mov    %esp,%ebp
 3e1:	53                   	push   %ebx
 3e2:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ec:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f0:	74 17                	je     409 <printint+0x2b>
 3f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f6:	79 11                	jns    409 <printint+0x2b>
    neg = 1;
 3f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 402:	f7 d8                	neg    %eax
 404:	89 45 ec             	mov    %eax,-0x14(%ebp)
 407:	eb 06                	jmp    40f <printint+0x31>
  } else {
    x = xx;
 409:	8b 45 0c             	mov    0xc(%ebp),%eax
 40c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 40f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 416:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 419:	8d 41 01             	lea    0x1(%ecx),%eax
 41c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 41f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 422:	8b 45 ec             	mov    -0x14(%ebp),%eax
 425:	ba 00 00 00 00       	mov    $0x0,%edx
 42a:	f7 f3                	div    %ebx
 42c:	89 d0                	mov    %edx,%eax
 42e:	0f b6 80 e4 0a 00 00 	movzbl 0xae4(%eax),%eax
 435:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 439:	8b 5d 10             	mov    0x10(%ebp),%ebx
 43c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43f:	ba 00 00 00 00       	mov    $0x0,%edx
 444:	f7 f3                	div    %ebx
 446:	89 45 ec             	mov    %eax,-0x14(%ebp)
 449:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 44d:	75 c7                	jne    416 <printint+0x38>
  if(neg)
 44f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 453:	74 2d                	je     482 <printint+0xa4>
    buf[i++] = '-';
 455:	8b 45 f4             	mov    -0xc(%ebp),%eax
 458:	8d 50 01             	lea    0x1(%eax),%edx
 45b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 463:	eb 1d                	jmp    482 <printint+0xa4>
    putc(fd, buf[i]);
 465:	8d 55 dc             	lea    -0x24(%ebp),%edx
 468:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46b:	01 d0                	add    %edx,%eax
 46d:	0f b6 00             	movzbl (%eax),%eax
 470:	0f be c0             	movsbl %al,%eax
 473:	83 ec 08             	sub    $0x8,%esp
 476:	50                   	push   %eax
 477:	ff 75 08             	pushl  0x8(%ebp)
 47a:	e8 3c ff ff ff       	call   3bb <putc>
 47f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 482:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 486:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 48a:	79 d9                	jns    465 <printint+0x87>
    putc(fd, buf[i]);
}
 48c:	90                   	nop
 48d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 490:	c9                   	leave  
 491:	c3                   	ret    

00000492 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 492:	55                   	push   %ebp
 493:	89 e5                	mov    %esp,%ebp
 495:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 498:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 49f:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a2:	83 c0 04             	add    $0x4,%eax
 4a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4af:	e9 59 01 00 00       	jmp    60d <printf+0x17b>
    c = fmt[i] & 0xff;
 4b4:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ba:	01 d0                	add    %edx,%eax
 4bc:	0f b6 00             	movzbl (%eax),%eax
 4bf:	0f be c0             	movsbl %al,%eax
 4c2:	25 ff 00 00 00       	and    $0xff,%eax
 4c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ce:	75 2c                	jne    4fc <printf+0x6a>
      if(c == '%'){
 4d0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d4:	75 0c                	jne    4e2 <printf+0x50>
        state = '%';
 4d6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4dd:	e9 27 01 00 00       	jmp    609 <printf+0x177>
      } else {
        putc(fd, c);
 4e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e5:	0f be c0             	movsbl %al,%eax
 4e8:	83 ec 08             	sub    $0x8,%esp
 4eb:	50                   	push   %eax
 4ec:	ff 75 08             	pushl  0x8(%ebp)
 4ef:	e8 c7 fe ff ff       	call   3bb <putc>
 4f4:	83 c4 10             	add    $0x10,%esp
 4f7:	e9 0d 01 00 00       	jmp    609 <printf+0x177>
      }
    } else if(state == '%'){
 4fc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 500:	0f 85 03 01 00 00    	jne    609 <printf+0x177>
      if(c == 'd'){
 506:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 50a:	75 1e                	jne    52a <printf+0x98>
        printint(fd, *ap, 10, 1);
 50c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50f:	8b 00                	mov    (%eax),%eax
 511:	6a 01                	push   $0x1
 513:	6a 0a                	push   $0xa
 515:	50                   	push   %eax
 516:	ff 75 08             	pushl  0x8(%ebp)
 519:	e8 c0 fe ff ff       	call   3de <printint>
 51e:	83 c4 10             	add    $0x10,%esp
        ap++;
 521:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 525:	e9 d8 00 00 00       	jmp    602 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 52a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 52e:	74 06                	je     536 <printf+0xa4>
 530:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 534:	75 1e                	jne    554 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 536:	8b 45 e8             	mov    -0x18(%ebp),%eax
 539:	8b 00                	mov    (%eax),%eax
 53b:	6a 00                	push   $0x0
 53d:	6a 10                	push   $0x10
 53f:	50                   	push   %eax
 540:	ff 75 08             	pushl  0x8(%ebp)
 543:	e8 96 fe ff ff       	call   3de <printint>
 548:	83 c4 10             	add    $0x10,%esp
        ap++;
 54b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54f:	e9 ae 00 00 00       	jmp    602 <printf+0x170>
      } else if(c == 's'){
 554:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 558:	75 43                	jne    59d <printf+0x10b>
        s = (char*)*ap;
 55a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55d:	8b 00                	mov    (%eax),%eax
 55f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 562:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 566:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56a:	75 25                	jne    591 <printf+0xff>
          s = "(null)";
 56c:	c7 45 f4 6f 08 00 00 	movl   $0x86f,-0xc(%ebp)
        while(*s != 0){
 573:	eb 1c                	jmp    591 <printf+0xff>
          putc(fd, *s);
 575:	8b 45 f4             	mov    -0xc(%ebp),%eax
 578:	0f b6 00             	movzbl (%eax),%eax
 57b:	0f be c0             	movsbl %al,%eax
 57e:	83 ec 08             	sub    $0x8,%esp
 581:	50                   	push   %eax
 582:	ff 75 08             	pushl  0x8(%ebp)
 585:	e8 31 fe ff ff       	call   3bb <putc>
 58a:	83 c4 10             	add    $0x10,%esp
          s++;
 58d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 591:	8b 45 f4             	mov    -0xc(%ebp),%eax
 594:	0f b6 00             	movzbl (%eax),%eax
 597:	84 c0                	test   %al,%al
 599:	75 da                	jne    575 <printf+0xe3>
 59b:	eb 65                	jmp    602 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a1:	75 1d                	jne    5c0 <printf+0x12e>
        putc(fd, *ap);
 5a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a6:	8b 00                	mov    (%eax),%eax
 5a8:	0f be c0             	movsbl %al,%eax
 5ab:	83 ec 08             	sub    $0x8,%esp
 5ae:	50                   	push   %eax
 5af:	ff 75 08             	pushl  0x8(%ebp)
 5b2:	e8 04 fe ff ff       	call   3bb <putc>
 5b7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5be:	eb 42                	jmp    602 <printf+0x170>
      } else if(c == '%'){
 5c0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c4:	75 17                	jne    5dd <printf+0x14b>
        putc(fd, c);
 5c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	83 ec 08             	sub    $0x8,%esp
 5cf:	50                   	push   %eax
 5d0:	ff 75 08             	pushl  0x8(%ebp)
 5d3:	e8 e3 fd ff ff       	call   3bb <putc>
 5d8:	83 c4 10             	add    $0x10,%esp
 5db:	eb 25                	jmp    602 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5dd:	83 ec 08             	sub    $0x8,%esp
 5e0:	6a 25                	push   $0x25
 5e2:	ff 75 08             	pushl  0x8(%ebp)
 5e5:	e8 d1 fd ff ff       	call   3bb <putc>
 5ea:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f0:	0f be c0             	movsbl %al,%eax
 5f3:	83 ec 08             	sub    $0x8,%esp
 5f6:	50                   	push   %eax
 5f7:	ff 75 08             	pushl  0x8(%ebp)
 5fa:	e8 bc fd ff ff       	call   3bb <putc>
 5ff:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 602:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 609:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 60d:	8b 55 0c             	mov    0xc(%ebp),%edx
 610:	8b 45 f0             	mov    -0x10(%ebp),%eax
 613:	01 d0                	add    %edx,%eax
 615:	0f b6 00             	movzbl (%eax),%eax
 618:	84 c0                	test   %al,%al
 61a:	0f 85 94 fe ff ff    	jne    4b4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 620:	90                   	nop
 621:	c9                   	leave  
 622:	c3                   	ret    

00000623 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 623:	55                   	push   %ebp
 624:	89 e5                	mov    %esp,%ebp
 626:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 629:	8b 45 08             	mov    0x8(%ebp),%eax
 62c:	83 e8 08             	sub    $0x8,%eax
 62f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 632:	a1 00 0b 00 00       	mov    0xb00,%eax
 637:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63a:	eb 24                	jmp    660 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 644:	77 12                	ja     658 <free+0x35>
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64c:	77 24                	ja     672 <free+0x4f>
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	8b 00                	mov    (%eax),%eax
 653:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 656:	77 1a                	ja     672 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 666:	76 d4                	jbe    63c <free+0x19>
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 670:	76 ca                	jbe    63c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	8b 40 04             	mov    0x4(%eax),%eax
 678:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 682:	01 c2                	add    %eax,%edx
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	39 c2                	cmp    %eax,%edx
 68b:	75 24                	jne    6b1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 68d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 690:	8b 50 04             	mov    0x4(%eax),%edx
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	8b 40 04             	mov    0x4(%eax),%eax
 69b:	01 c2                	add    %eax,%edx
 69d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	8b 00                	mov    (%eax),%eax
 6a8:	8b 10                	mov    (%eax),%edx
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	89 10                	mov    %edx,(%eax)
 6af:	eb 0a                	jmp    6bb <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 10                	mov    (%eax),%edx
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 40 04             	mov    0x4(%eax),%eax
 6c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	01 d0                	add    %edx,%eax
 6cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d0:	75 20                	jne    6f2 <free+0xcf>
    p->s.size += bp->s.size;
 6d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d5:	8b 50 04             	mov    0x4(%eax),%edx
 6d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6db:	8b 40 04             	mov    0x4(%eax),%eax
 6de:	01 c2                	add    %eax,%edx
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e9:	8b 10                	mov    (%eax),%edx
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	89 10                	mov    %edx,(%eax)
 6f0:	eb 08                	jmp    6fa <free+0xd7>
  } else
    p->s.ptr = bp;
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f8:	89 10                	mov    %edx,(%eax)
  freep = p;
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	a3 00 0b 00 00       	mov    %eax,0xb00
}
 702:	90                   	nop
 703:	c9                   	leave  
 704:	c3                   	ret    

00000705 <morecore>:

static Header*
morecore(uint nu)
{
 705:	55                   	push   %ebp
 706:	89 e5                	mov    %esp,%ebp
 708:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 70b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 712:	77 07                	ja     71b <morecore+0x16>
    nu = 4096;
 714:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	c1 e0 03             	shl    $0x3,%eax
 721:	83 ec 0c             	sub    $0xc,%esp
 724:	50                   	push   %eax
 725:	e8 59 fc ff ff       	call   383 <sbrk>
 72a:	83 c4 10             	add    $0x10,%esp
 72d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 730:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 734:	75 07                	jne    73d <morecore+0x38>
    return 0;
 736:	b8 00 00 00 00       	mov    $0x0,%eax
 73b:	eb 26                	jmp    763 <morecore+0x5e>
  hp = (Header*)p;
 73d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 740:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 743:	8b 45 f0             	mov    -0x10(%ebp),%eax
 746:	8b 55 08             	mov    0x8(%ebp),%edx
 749:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 74c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74f:	83 c0 08             	add    $0x8,%eax
 752:	83 ec 0c             	sub    $0xc,%esp
 755:	50                   	push   %eax
 756:	e8 c8 fe ff ff       	call   623 <free>
 75b:	83 c4 10             	add    $0x10,%esp
  return freep;
 75e:	a1 00 0b 00 00       	mov    0xb00,%eax
}
 763:	c9                   	leave  
 764:	c3                   	ret    

00000765 <malloc>:

void*
malloc(uint nbytes)
{
 765:	55                   	push   %ebp
 766:	89 e5                	mov    %esp,%ebp
 768:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76b:	8b 45 08             	mov    0x8(%ebp),%eax
 76e:	83 c0 07             	add    $0x7,%eax
 771:	c1 e8 03             	shr    $0x3,%eax
 774:	83 c0 01             	add    $0x1,%eax
 777:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 77a:	a1 00 0b 00 00       	mov    0xb00,%eax
 77f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 782:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 786:	75 23                	jne    7ab <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 788:	c7 45 f0 f8 0a 00 00 	movl   $0xaf8,-0x10(%ebp)
 78f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 792:	a3 00 0b 00 00       	mov    %eax,0xb00
 797:	a1 00 0b 00 00       	mov    0xb00,%eax
 79c:	a3 f8 0a 00 00       	mov    %eax,0xaf8
    base.s.size = 0;
 7a1:	c7 05 fc 0a 00 00 00 	movl   $0x0,0xafc
 7a8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	8b 00                	mov    (%eax),%eax
 7b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	8b 40 04             	mov    0x4(%eax),%eax
 7b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7bc:	72 4d                	jb     80b <malloc+0xa6>
      if(p->s.size == nunits)
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c7:	75 0c                	jne    7d5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 10                	mov    (%eax),%edx
 7ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d1:	89 10                	mov    %edx,(%eax)
 7d3:	eb 26                	jmp    7fb <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7de:	89 c2                	mov    %eax,%edx
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	8b 40 04             	mov    0x4(%eax),%eax
 7ec:	c1 e0 03             	shl    $0x3,%eax
 7ef:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fe:	a3 00 0b 00 00       	mov    %eax,0xb00
      return (void*)(p + 1);
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	83 c0 08             	add    $0x8,%eax
 809:	eb 3b                	jmp    846 <malloc+0xe1>
    }
    if(p == freep)
 80b:	a1 00 0b 00 00       	mov    0xb00,%eax
 810:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 813:	75 1e                	jne    833 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 815:	83 ec 0c             	sub    $0xc,%esp
 818:	ff 75 ec             	pushl  -0x14(%ebp)
 81b:	e8 e5 fe ff ff       	call   705 <morecore>
 820:	83 c4 10             	add    $0x10,%esp
 823:	89 45 f4             	mov    %eax,-0xc(%ebp)
 826:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 82a:	75 07                	jne    833 <malloc+0xce>
        return 0;
 82c:	b8 00 00 00 00       	mov    $0x0,%eax
 831:	eb 13                	jmp    846 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	89 45 f0             	mov    %eax,-0x10(%ebp)
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	8b 00                	mov    (%eax),%eax
 83e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 841:	e9 6d ff ff ff       	jmp    7b3 <malloc+0x4e>
}
 846:	c9                   	leave  
 847:	c3                   	ret    
