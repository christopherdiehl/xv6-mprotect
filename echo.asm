
_echo:     file format elf32-i386


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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	3b 03                	cmp    (%ebx),%eax
  25:	7d 07                	jge    2e <main+0x2e>
  27:	ba 41 08 00 00       	mov    $0x841,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba 43 08 00 00       	mov    $0x843,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 45 08 00 00       	push   $0x845
  4b:	6a 01                	push   $0x1
  4d:	e8 39 04 00 00       	call   48b <printf>
  52:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  60:	e8 87 02 00 00       	call   2ec <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld    
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	90                   	nop
  87:	5b                   	pop    %ebx
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    

0000008b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  97:	90                   	nop
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	8d 50 01             	lea    0x1(%eax),%edx
  9e:	89 55 08             	mov    %edx,0x8(%ebp)
  a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	88 10                	mov    %dl,(%eax)
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	84 c0                	test   %al,%al
  b4:	75 e2                	jne    98 <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 08                	jmp    c8 <strcmp+0xd>
    p++, q++;
  c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	74 10                	je     e2 <strcmp+0x27>
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 10             	movzbl (%eax),%edx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	38 c2                	cmp    %al,%dl
  e0:	74 de                	je     c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	0f b6 c0             	movzbl %al,%eax
  f4:	29 c2                	sub    %eax,%edx
  f6:	89 d0                	mov    %edx,%eax
}
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    

000000fa <strlen>:

uint
strlen(char *s)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 107:	eb 04                	jmp    10d <strlen+0x13>
 109:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	75 ed                	jne    109 <strlen+0xf>
    ;
  return n;
 11c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <memset>:

void*
memset(void *dst, int c, uint n)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 124:	8b 45 10             	mov    0x10(%ebp),%eax
 127:	50                   	push   %eax
 128:	ff 75 0c             	pushl  0xc(%ebp)
 12b:	ff 75 08             	pushl  0x8(%ebp)
 12e:	e8 32 ff ff ff       	call   65 <stosb>
 133:	83 c4 0c             	add    $0xc,%esp
  return dst;
 136:	8b 45 08             	mov    0x8(%ebp),%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <strchr>:

char*
strchr(const char *s, char c)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 147:	eb 14                	jmp    15d <strchr+0x22>
    if(*s == c)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 152:	75 05                	jne    159 <strchr+0x1e>
      return (char*)s;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	eb 13                	jmp    16c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	84 c0                	test   %al,%al
 165:	75 e2                	jne    149 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 42                	jmp    1bf <gets+0x51>
    cc = read(0, &c, 1);
 17d:	83 ec 04             	sub    $0x4,%esp
 180:	6a 01                	push   $0x1
 182:	8d 45 ef             	lea    -0x11(%ebp),%eax
 185:	50                   	push   %eax
 186:	6a 00                	push   $0x0
 188:	e8 77 01 00 00       	call   304 <read>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 197:	7e 33                	jle    1cc <gets+0x5e>
      break;
    buf[i++] = c;
 199:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19c:	8d 50 01             	lea    0x1(%eax),%edx
 19f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a2:	89 c2                	mov    %eax,%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 c2                	add    %eax,%edx
 1a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b3:	3c 0a                	cmp    $0xa,%al
 1b5:	74 16                	je     1cd <gets+0x5f>
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	74 0e                	je     1cd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c2:	83 c0 01             	add    $0x1,%eax
 1c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c8:	7c b3                	jl     17d <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	6a 00                	push   $0x0
 1e8:	ff 75 08             	pushl  0x8(%ebp)
 1eb:	e8 3c 01 00 00       	call   32c <open>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fa:	79 07                	jns    203 <stat+0x26>
    return -1;
 1fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 201:	eb 25                	jmp    228 <stat+0x4b>
  r = fstat(fd, st);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	ff 75 0c             	pushl  0xc(%ebp)
 209:	ff 75 f4             	pushl  -0xc(%ebp)
 20c:	e8 33 01 00 00       	call   344 <fstat>
 211:	83 c4 10             	add    $0x10,%esp
 214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 217:	83 ec 0c             	sub    $0xc,%esp
 21a:	ff 75 f4             	pushl  -0xc(%ebp)
 21d:	e8 f2 00 00 00       	call   314 <close>
 222:	83 c4 10             	add    $0x10,%esp
  return r;
 225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <atoi>:

int
atoi(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 237:	eb 25                	jmp    25e <atoi+0x34>
    n = n*10 + *s++ - '0';
 239:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23c:	89 d0                	mov    %edx,%eax
 23e:	c1 e0 02             	shl    $0x2,%eax
 241:	01 d0                	add    %edx,%eax
 243:	01 c0                	add    %eax,%eax
 245:	89 c1                	mov    %eax,%ecx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 08             	mov    %edx,0x8(%ebp)
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f be c0             	movsbl %al,%eax
 256:	01 c8                	add    %ecx,%eax
 258:	83 e8 30             	sub    $0x30,%eax
 25b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 0a                	jle    272 <atoi+0x48>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 39                	cmp    $0x39,%al
 270:	7e c7                	jle    239 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 289:	eb 17                	jmp    2a2 <memmove+0x2b>
    *dst++ = *src++;
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28e:	8d 50 01             	lea    0x1(%eax),%edx
 291:	89 55 fc             	mov    %edx,-0x4(%ebp)
 294:	8b 55 f8             	mov    -0x8(%ebp),%edx
 297:	8d 4a 01             	lea    0x1(%edx),%ecx
 29a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 29d:	0f b6 12             	movzbl (%edx),%edx
 2a0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
 2a5:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a8:	89 55 10             	mov    %edx,0x10(%ebp)
 2ab:	85 c0                	test   %eax,%eax
 2ad:	7f dc                	jg     28b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <restorer>:
 2b4:	83 c4 0c             	add    $0xc,%esp
 2b7:	5a                   	pop    %edx
 2b8:	59                   	pop    %ecx
 2b9:	58                   	pop    %eax
 2ba:	c3                   	ret    

000002bb <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 2bb:	55                   	push   %ebp
 2bc:	89 e5                	mov    %esp,%ebp
 2be:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	68 b4 02 00 00       	push   $0x2b4
 2c9:	e8 ce 00 00 00       	call   39c <signal_restorer>
 2ce:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 2d1:	83 ec 08             	sub    $0x8,%esp
 2d4:	ff 75 0c             	pushl  0xc(%ebp)
 2d7:	ff 75 08             	pushl  0x8(%ebp)
 2da:	e8 b5 00 00 00       	call   394 <signal_register>
 2df:	83 c4 10             	add    $0x10,%esp
}
 2e2:	c9                   	leave  
 2e3:	c3                   	ret    

000002e4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e4:	b8 01 00 00 00       	mov    $0x1,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <exit>:
SYSCALL(exit)
 2ec:	b8 02 00 00 00       	mov    $0x2,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <wait>:
SYSCALL(wait)
 2f4:	b8 03 00 00 00       	mov    $0x3,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <pipe>:
SYSCALL(pipe)
 2fc:	b8 04 00 00 00       	mov    $0x4,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <read>:
SYSCALL(read)
 304:	b8 05 00 00 00       	mov    $0x5,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <write>:
SYSCALL(write)
 30c:	b8 10 00 00 00       	mov    $0x10,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <close>:
SYSCALL(close)
 314:	b8 15 00 00 00       	mov    $0x15,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <kill>:
SYSCALL(kill)
 31c:	b8 06 00 00 00       	mov    $0x6,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <exec>:
SYSCALL(exec)
 324:	b8 07 00 00 00       	mov    $0x7,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <open>:
SYSCALL(open)
 32c:	b8 0f 00 00 00       	mov    $0xf,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <mknod>:
SYSCALL(mknod)
 334:	b8 11 00 00 00       	mov    $0x11,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <unlink>:
SYSCALL(unlink)
 33c:	b8 12 00 00 00       	mov    $0x12,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <fstat>:
SYSCALL(fstat)
 344:	b8 08 00 00 00       	mov    $0x8,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <link>:
SYSCALL(link)
 34c:	b8 13 00 00 00       	mov    $0x13,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <mkdir>:
SYSCALL(mkdir)
 354:	b8 14 00 00 00       	mov    $0x14,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <chdir>:
SYSCALL(chdir)
 35c:	b8 09 00 00 00       	mov    $0x9,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <dup>:
SYSCALL(dup)
 364:	b8 0a 00 00 00       	mov    $0xa,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <getpid>:
SYSCALL(getpid)
 36c:	b8 0b 00 00 00       	mov    $0xb,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <sbrk>:
SYSCALL(sbrk)
 374:	b8 0c 00 00 00       	mov    $0xc,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <sleep>:
SYSCALL(sleep)
 37c:	b8 0d 00 00 00       	mov    $0xd,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <uptime>:
SYSCALL(uptime)
 384:	b8 0e 00 00 00       	mov    $0xe,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <halt>:
SYSCALL(halt)
 38c:	b8 16 00 00 00       	mov    $0x16,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <signal_register>:
SYSCALL(signal_register)
 394:	b8 17 00 00 00       	mov    $0x17,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <signal_restorer>:
SYSCALL(signal_restorer)
 39c:	b8 18 00 00 00       	mov    $0x18,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <mprotect>:
SYSCALL(mprotect)
 3a4:	b8 19 00 00 00       	mov    $0x19,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <cowfork>:
SYSCALL(cowfork)
 3ac:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	83 ec 18             	sub    $0x18,%esp
 3ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c0:	83 ec 04             	sub    $0x4,%esp
 3c3:	6a 01                	push   $0x1
 3c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3c8:	50                   	push   %eax
 3c9:	ff 75 08             	pushl  0x8(%ebp)
 3cc:	e8 3b ff ff ff       	call   30c <write>
 3d1:	83 c4 10             	add    $0x10,%esp
}
 3d4:	90                   	nop
 3d5:	c9                   	leave  
 3d6:	c3                   	ret    

000003d7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp
 3da:	53                   	push   %ebx
 3db:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e9:	74 17                	je     402 <printint+0x2b>
 3eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ef:	79 11                	jns    402 <printint+0x2b>
    neg = 1;
 3f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fb:	f7 d8                	neg    %eax
 3fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 400:	eb 06                	jmp    408 <printint+0x31>
  } else {
    x = xx;
 402:	8b 45 0c             	mov    0xc(%ebp),%eax
 405:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 408:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 40f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 412:	8d 41 01             	lea    0x1(%ecx),%eax
 415:	89 45 f4             	mov    %eax,-0xc(%ebp)
 418:	8b 5d 10             	mov    0x10(%ebp),%ebx
 41b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41e:	ba 00 00 00 00       	mov    $0x0,%edx
 423:	f7 f3                	div    %ebx
 425:	89 d0                	mov    %edx,%eax
 427:	0f b6 80 c0 0a 00 00 	movzbl 0xac0(%eax),%eax
 42e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 432:	8b 5d 10             	mov    0x10(%ebp),%ebx
 435:	8b 45 ec             	mov    -0x14(%ebp),%eax
 438:	ba 00 00 00 00       	mov    $0x0,%edx
 43d:	f7 f3                	div    %ebx
 43f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 442:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 446:	75 c7                	jne    40f <printint+0x38>
  if(neg)
 448:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44c:	74 2d                	je     47b <printint+0xa4>
    buf[i++] = '-';
 44e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 451:	8d 50 01             	lea    0x1(%eax),%edx
 454:	89 55 f4             	mov    %edx,-0xc(%ebp)
 457:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 45c:	eb 1d                	jmp    47b <printint+0xa4>
    putc(fd, buf[i]);
 45e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 461:	8b 45 f4             	mov    -0xc(%ebp),%eax
 464:	01 d0                	add    %edx,%eax
 466:	0f b6 00             	movzbl (%eax),%eax
 469:	0f be c0             	movsbl %al,%eax
 46c:	83 ec 08             	sub    $0x8,%esp
 46f:	50                   	push   %eax
 470:	ff 75 08             	pushl  0x8(%ebp)
 473:	e8 3c ff ff ff       	call   3b4 <putc>
 478:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 47b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 47f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 483:	79 d9                	jns    45e <printint+0x87>
    putc(fd, buf[i]);
}
 485:	90                   	nop
 486:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 489:	c9                   	leave  
 48a:	c3                   	ret    

0000048b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 48b:	55                   	push   %ebp
 48c:	89 e5                	mov    %esp,%ebp
 48e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 491:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 498:	8d 45 0c             	lea    0xc(%ebp),%eax
 49b:	83 c0 04             	add    $0x4,%eax
 49e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a8:	e9 59 01 00 00       	jmp    606 <printf+0x17b>
    c = fmt[i] & 0xff;
 4ad:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b3:	01 d0                	add    %edx,%eax
 4b5:	0f b6 00             	movzbl (%eax),%eax
 4b8:	0f be c0             	movsbl %al,%eax
 4bb:	25 ff 00 00 00       	and    $0xff,%eax
 4c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c7:	75 2c                	jne    4f5 <printf+0x6a>
      if(c == '%'){
 4c9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4cd:	75 0c                	jne    4db <printf+0x50>
        state = '%';
 4cf:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d6:	e9 27 01 00 00       	jmp    602 <printf+0x177>
      } else {
        putc(fd, c);
 4db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4de:	0f be c0             	movsbl %al,%eax
 4e1:	83 ec 08             	sub    $0x8,%esp
 4e4:	50                   	push   %eax
 4e5:	ff 75 08             	pushl  0x8(%ebp)
 4e8:	e8 c7 fe ff ff       	call   3b4 <putc>
 4ed:	83 c4 10             	add    $0x10,%esp
 4f0:	e9 0d 01 00 00       	jmp    602 <printf+0x177>
      }
    } else if(state == '%'){
 4f5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f9:	0f 85 03 01 00 00    	jne    602 <printf+0x177>
      if(c == 'd'){
 4ff:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 503:	75 1e                	jne    523 <printf+0x98>
        printint(fd, *ap, 10, 1);
 505:	8b 45 e8             	mov    -0x18(%ebp),%eax
 508:	8b 00                	mov    (%eax),%eax
 50a:	6a 01                	push   $0x1
 50c:	6a 0a                	push   $0xa
 50e:	50                   	push   %eax
 50f:	ff 75 08             	pushl  0x8(%ebp)
 512:	e8 c0 fe ff ff       	call   3d7 <printint>
 517:	83 c4 10             	add    $0x10,%esp
        ap++;
 51a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51e:	e9 d8 00 00 00       	jmp    5fb <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 523:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 527:	74 06                	je     52f <printf+0xa4>
 529:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 52d:	75 1e                	jne    54d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 52f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 532:	8b 00                	mov    (%eax),%eax
 534:	6a 00                	push   $0x0
 536:	6a 10                	push   $0x10
 538:	50                   	push   %eax
 539:	ff 75 08             	pushl  0x8(%ebp)
 53c:	e8 96 fe ff ff       	call   3d7 <printint>
 541:	83 c4 10             	add    $0x10,%esp
        ap++;
 544:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 548:	e9 ae 00 00 00       	jmp    5fb <printf+0x170>
      } else if(c == 's'){
 54d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 551:	75 43                	jne    596 <printf+0x10b>
        s = (char*)*ap;
 553:	8b 45 e8             	mov    -0x18(%ebp),%eax
 556:	8b 00                	mov    (%eax),%eax
 558:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 55f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 563:	75 25                	jne    58a <printf+0xff>
          s = "(null)";
 565:	c7 45 f4 4a 08 00 00 	movl   $0x84a,-0xc(%ebp)
        while(*s != 0){
 56c:	eb 1c                	jmp    58a <printf+0xff>
          putc(fd, *s);
 56e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 571:	0f b6 00             	movzbl (%eax),%eax
 574:	0f be c0             	movsbl %al,%eax
 577:	83 ec 08             	sub    $0x8,%esp
 57a:	50                   	push   %eax
 57b:	ff 75 08             	pushl  0x8(%ebp)
 57e:	e8 31 fe ff ff       	call   3b4 <putc>
 583:	83 c4 10             	add    $0x10,%esp
          s++;
 586:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58d:	0f b6 00             	movzbl (%eax),%eax
 590:	84 c0                	test   %al,%al
 592:	75 da                	jne    56e <printf+0xe3>
 594:	eb 65                	jmp    5fb <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 596:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59a:	75 1d                	jne    5b9 <printf+0x12e>
        putc(fd, *ap);
 59c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59f:	8b 00                	mov    (%eax),%eax
 5a1:	0f be c0             	movsbl %al,%eax
 5a4:	83 ec 08             	sub    $0x8,%esp
 5a7:	50                   	push   %eax
 5a8:	ff 75 08             	pushl  0x8(%ebp)
 5ab:	e8 04 fe ff ff       	call   3b4 <putc>
 5b0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b7:	eb 42                	jmp    5fb <printf+0x170>
      } else if(c == '%'){
 5b9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5bd:	75 17                	jne    5d6 <printf+0x14b>
        putc(fd, c);
 5bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c2:	0f be c0             	movsbl %al,%eax
 5c5:	83 ec 08             	sub    $0x8,%esp
 5c8:	50                   	push   %eax
 5c9:	ff 75 08             	pushl  0x8(%ebp)
 5cc:	e8 e3 fd ff ff       	call   3b4 <putc>
 5d1:	83 c4 10             	add    $0x10,%esp
 5d4:	eb 25                	jmp    5fb <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d6:	83 ec 08             	sub    $0x8,%esp
 5d9:	6a 25                	push   $0x25
 5db:	ff 75 08             	pushl  0x8(%ebp)
 5de:	e8 d1 fd ff ff       	call   3b4 <putc>
 5e3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e9:	0f be c0             	movsbl %al,%eax
 5ec:	83 ec 08             	sub    $0x8,%esp
 5ef:	50                   	push   %eax
 5f0:	ff 75 08             	pushl  0x8(%ebp)
 5f3:	e8 bc fd ff ff       	call   3b4 <putc>
 5f8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 602:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 606:	8b 55 0c             	mov    0xc(%ebp),%edx
 609:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60c:	01 d0                	add    %edx,%eax
 60e:	0f b6 00             	movzbl (%eax),%eax
 611:	84 c0                	test   %al,%al
 613:	0f 85 94 fe ff ff    	jne    4ad <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 619:	90                   	nop
 61a:	c9                   	leave  
 61b:	c3                   	ret    

0000061c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61c:	55                   	push   %ebp
 61d:	89 e5                	mov    %esp,%ebp
 61f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 622:	8b 45 08             	mov    0x8(%ebp),%eax
 625:	83 e8 08             	sub    $0x8,%eax
 628:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62b:	a1 dc 0a 00 00       	mov    0xadc,%eax
 630:	89 45 fc             	mov    %eax,-0x4(%ebp)
 633:	eb 24                	jmp    659 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63d:	77 12                	ja     651 <free+0x35>
 63f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 642:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 645:	77 24                	ja     66b <free+0x4f>
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64f:	77 1a                	ja     66b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	89 45 fc             	mov    %eax,-0x4(%ebp)
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65f:	76 d4                	jbe    635 <free+0x19>
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 669:	76 ca                	jbe    635 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	8b 40 04             	mov    0x4(%eax),%eax
 671:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 678:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67b:	01 c2                	add    %eax,%edx
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 00                	mov    (%eax),%eax
 682:	39 c2                	cmp    %eax,%edx
 684:	75 24                	jne    6aa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	8b 50 04             	mov    0x4(%eax),%edx
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	8b 40 04             	mov    0x4(%eax),%eax
 694:	01 c2                	add    %eax,%edx
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	8b 10                	mov    (%eax),%edx
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	89 10                	mov    %edx,(%eax)
 6a8:	eb 0a                	jmp    6b4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	8b 10                	mov    (%eax),%edx
 6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	8b 40 04             	mov    0x4(%eax),%eax
 6ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	01 d0                	add    %edx,%eax
 6c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c9:	75 20                	jne    6eb <free+0xcf>
    p->s.size += bp->s.size;
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 50 04             	mov    0x4(%eax),%edx
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	8b 40 04             	mov    0x4(%eax),%eax
 6d7:	01 c2                	add    %eax,%edx
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	8b 10                	mov    (%eax),%edx
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	89 10                	mov    %edx,(%eax)
 6e9:	eb 08                	jmp    6f3 <free+0xd7>
  } else
    p->s.ptr = bp;
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f1:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	a3 dc 0a 00 00       	mov    %eax,0xadc
}
 6fb:	90                   	nop
 6fc:	c9                   	leave  
 6fd:	c3                   	ret    

000006fe <morecore>:

static Header*
morecore(uint nu)
{
 6fe:	55                   	push   %ebp
 6ff:	89 e5                	mov    %esp,%ebp
 701:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 704:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70b:	77 07                	ja     714 <morecore+0x16>
    nu = 4096;
 70d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	c1 e0 03             	shl    $0x3,%eax
 71a:	83 ec 0c             	sub    $0xc,%esp
 71d:	50                   	push   %eax
 71e:	e8 51 fc ff ff       	call   374 <sbrk>
 723:	83 c4 10             	add    $0x10,%esp
 726:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 729:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72d:	75 07                	jne    736 <morecore+0x38>
    return 0;
 72f:	b8 00 00 00 00       	mov    $0x0,%eax
 734:	eb 26                	jmp    75c <morecore+0x5e>
  hp = (Header*)p;
 736:	8b 45 f4             	mov    -0xc(%ebp),%eax
 739:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73f:	8b 55 08             	mov    0x8(%ebp),%edx
 742:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 745:	8b 45 f0             	mov    -0x10(%ebp),%eax
 748:	83 c0 08             	add    $0x8,%eax
 74b:	83 ec 0c             	sub    $0xc,%esp
 74e:	50                   	push   %eax
 74f:	e8 c8 fe ff ff       	call   61c <free>
 754:	83 c4 10             	add    $0x10,%esp
  return freep;
 757:	a1 dc 0a 00 00       	mov    0xadc,%eax
}
 75c:	c9                   	leave  
 75d:	c3                   	ret    

0000075e <malloc>:

void*
malloc(uint nbytes)
{
 75e:	55                   	push   %ebp
 75f:	89 e5                	mov    %esp,%ebp
 761:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 764:	8b 45 08             	mov    0x8(%ebp),%eax
 767:	83 c0 07             	add    $0x7,%eax
 76a:	c1 e8 03             	shr    $0x3,%eax
 76d:	83 c0 01             	add    $0x1,%eax
 770:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 773:	a1 dc 0a 00 00       	mov    0xadc,%eax
 778:	89 45 f0             	mov    %eax,-0x10(%ebp)
 77b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77f:	75 23                	jne    7a4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 781:	c7 45 f0 d4 0a 00 00 	movl   $0xad4,-0x10(%ebp)
 788:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78b:	a3 dc 0a 00 00       	mov    %eax,0xadc
 790:	a1 dc 0a 00 00       	mov    0xadc,%eax
 795:	a3 d4 0a 00 00       	mov    %eax,0xad4
    base.s.size = 0;
 79a:	c7 05 d8 0a 00 00 00 	movl   $0x0,0xad8
 7a1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b5:	72 4d                	jb     804 <malloc+0xa6>
      if(p->s.size == nunits)
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	8b 40 04             	mov    0x4(%eax),%eax
 7bd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c0:	75 0c                	jne    7ce <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	8b 10                	mov    (%eax),%edx
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	89 10                	mov    %edx,(%eax)
 7cc:	eb 26                	jmp    7f4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d7:	89 c2                	mov    %eax,%edx
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	8b 40 04             	mov    0x4(%eax),%eax
 7e5:	c1 e0 03             	shl    $0x3,%eax
 7e8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	a3 dc 0a 00 00       	mov    %eax,0xadc
      return (void*)(p + 1);
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	83 c0 08             	add    $0x8,%eax
 802:	eb 3b                	jmp    83f <malloc+0xe1>
    }
    if(p == freep)
 804:	a1 dc 0a 00 00       	mov    0xadc,%eax
 809:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80c:	75 1e                	jne    82c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 80e:	83 ec 0c             	sub    $0xc,%esp
 811:	ff 75 ec             	pushl  -0x14(%ebp)
 814:	e8 e5 fe ff ff       	call   6fe <morecore>
 819:	83 c4 10             	add    $0x10,%esp
 81c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 823:	75 07                	jne    82c <malloc+0xce>
        return 0;
 825:	b8 00 00 00 00       	mov    $0x0,%eax
 82a:	eb 13                	jmp    83f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 832:	8b 45 f4             	mov    -0xc(%ebp),%eax
 835:	8b 00                	mov    (%eax),%eax
 837:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 83a:	e9 6d ff ff ff       	jmp    7ac <malloc+0x4e>
}
 83f:	c9                   	leave  
 840:	c3                   	ret    
