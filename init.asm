
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 d8 08 00 00       	push   $0x8d8
  1b:	e8 a8 03 00 00       	call   3c8 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 d8 08 00 00       	push   $0x8d8
  33:	e8 98 03 00 00       	call   3d0 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 d8 08 00 00       	push   $0x8d8
  45:	e8 7e 03 00 00       	call   3c8 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 a9 03 00 00       	call   400 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 9c 03 00 00       	call   400 <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 e0 08 00 00       	push   $0x8e0
  6f:	6a 01                	push   $0x1
  71:	e8 a9 04 00 00       	call   51f <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 02 03 00 00       	call   380 <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 f3 08 00 00       	push   $0x8f3
  8f:	6a 01                	push   $0x1
  91:	e8 89 04 00 00       	call   51f <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 ea 02 00 00       	call   388 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 94 0b 00 00       	push   $0xb94
  ac:	68 d5 08 00 00       	push   $0x8d5
  b1:	e8 0a 03 00 00       	call   3c0 <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 06 09 00 00       	push   $0x906
  c1:	6a 01                	push   $0x1
  c3:	e8 57 04 00 00       	call   51f <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 b8 02 00 00       	call   388 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 1c 09 00 00       	push   $0x91c
  d8:	6a 01                	push   $0x1
  da:	e8 40 04 00 00       	call   51f <printf>
  df:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  e2:	e8 a9 02 00 00       	call   390 <wait>
  e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  ee:	0f 88 73 ff ff ff    	js     67 <main+0x67>
  f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  fa:	75 d4                	jne    d0 <main+0xd0>
      printf(1, "zombie!\n");
  }
  fc:	e9 66 ff ff ff       	jmp    67 <main+0x67>

00000101 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	57                   	push   %edi
 105:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 55 10             	mov    0x10(%ebp),%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	89 cb                	mov    %ecx,%ebx
 111:	89 df                	mov    %ebx,%edi
 113:	89 d1                	mov    %edx,%ecx
 115:	fc                   	cld    
 116:	f3 aa                	rep stos %al,%es:(%edi)
 118:	89 ca                	mov    %ecx,%edx
 11a:	89 fb                	mov    %edi,%ebx
 11c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 122:	90                   	nop
 123:	5b                   	pop    %ebx
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    

00000127 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 133:	90                   	nop
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	8d 50 01             	lea    0x1(%eax),%edx
 13a:	89 55 08             	mov    %edx,0x8(%ebp)
 13d:	8b 55 0c             	mov    0xc(%ebp),%edx
 140:	8d 4a 01             	lea    0x1(%edx),%ecx
 143:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 146:	0f b6 12             	movzbl (%edx),%edx
 149:	88 10                	mov    %dl,(%eax)
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	84 c0                	test   %al,%al
 150:	75 e2                	jne    134 <strcpy+0xd>
    ;
  return os;
 152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 155:	c9                   	leave  
 156:	c3                   	ret    

00000157 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 15a:	eb 08                	jmp    164 <strcmp+0xd>
    p++, q++;
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	74 10                	je     17e <strcmp+0x27>
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 10             	movzbl (%eax),%edx
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	38 c2                	cmp    %al,%dl
 17c:	74 de                	je     15c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	0f b6 d0             	movzbl %al,%edx
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	0f b6 c0             	movzbl %al,%eax
 190:	29 c2                	sub    %eax,%edx
 192:	89 d0                	mov    %edx,%eax
}
 194:	5d                   	pop    %ebp
 195:	c3                   	ret    

00000196 <strlen>:

uint
strlen(char *s)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a3:	eb 04                	jmp    1a9 <strlen+0x13>
 1a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 d0                	add    %edx,%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	84 c0                	test   %al,%al
 1b6:	75 ed                	jne    1a5 <strlen+0xf>
    ;
  return n;
 1b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c0:	8b 45 10             	mov    0x10(%ebp),%eax
 1c3:	50                   	push   %eax
 1c4:	ff 75 0c             	pushl  0xc(%ebp)
 1c7:	ff 75 08             	pushl  0x8(%ebp)
 1ca:	e8 32 ff ff ff       	call   101 <stosb>
 1cf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <strchr>:

char*
strchr(const char *s, char c)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e3:	eb 14                	jmp    1f9 <strchr+0x22>
    if(*s == c)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ee:	75 05                	jne    1f5 <strchr+0x1e>
      return (char*)s;
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	eb 13                	jmp    208 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 203:	b8 00 00 00 00       	mov    $0x0,%eax
}
 208:	c9                   	leave  
 209:	c3                   	ret    

0000020a <gets>:

char*
gets(char *buf, int max)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 217:	eb 42                	jmp    25b <gets+0x51>
    cc = read(0, &c, 1);
 219:	83 ec 04             	sub    $0x4,%esp
 21c:	6a 01                	push   $0x1
 21e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 221:	50                   	push   %eax
 222:	6a 00                	push   $0x0
 224:	e8 77 01 00 00       	call   3a0 <read>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 233:	7e 33                	jle    268 <gets+0x5e>
      break;
    buf[i++] = c;
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	8d 50 01             	lea    0x1(%eax),%edx
 23b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23e:	89 c2                	mov    %eax,%edx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	01 c2                	add    %eax,%edx
 245:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 249:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24f:	3c 0a                	cmp    $0xa,%al
 251:	74 16                	je     269 <gets+0x5f>
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	3c 0d                	cmp    $0xd,%al
 259:	74 0e                	je     269 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25e:	83 c0 01             	add    $0x1,%eax
 261:	3b 45 0c             	cmp    0xc(%ebp),%eax
 264:	7c b3                	jl     219 <gets+0xf>
 266:	eb 01                	jmp    269 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 268:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 269:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	01 d0                	add    %edx,%eax
 271:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <stat>:

int
stat(char *n, struct stat *st)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	6a 00                	push   $0x0
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 3c 01 00 00       	call   3c8 <open>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 296:	79 07                	jns    29f <stat+0x26>
    return -1;
 298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29d:	eb 25                	jmp    2c4 <stat+0x4b>
  r = fstat(fd, st);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	ff 75 0c             	pushl  0xc(%ebp)
 2a5:	ff 75 f4             	pushl  -0xc(%ebp)
 2a8:	e8 33 01 00 00       	call   3e0 <fstat>
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b3:	83 ec 0c             	sub    $0xc,%esp
 2b6:	ff 75 f4             	pushl  -0xc(%ebp)
 2b9:	e8 f2 00 00 00       	call   3b0 <close>
 2be:	83 c4 10             	add    $0x10,%esp
  return r;
 2c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <atoi>:

int
atoi(const char *s)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2d3:	eb 25                	jmp    2fa <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d8:	89 d0                	mov    %edx,%eax
 2da:	c1 e0 02             	shl    $0x2,%eax
 2dd:	01 d0                	add    %edx,%eax
 2df:	01 c0                	add    %eax,%eax
 2e1:	89 c1                	mov    %eax,%ecx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	8d 50 01             	lea    0x1(%eax),%edx
 2e9:	89 55 08             	mov    %edx,0x8(%ebp)
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	0f be c0             	movsbl %al,%eax
 2f2:	01 c8                	add    %ecx,%eax
 2f4:	83 e8 30             	sub    $0x30,%eax
 2f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	3c 2f                	cmp    $0x2f,%al
 302:	7e 0a                	jle    30e <atoi+0x48>
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	3c 39                	cmp    $0x39,%al
 30c:	7e c7                	jle    2d5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 30e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 311:	c9                   	leave  
 312:	c3                   	ret    

00000313 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 325:	eb 17                	jmp    33e <memmove+0x2b>
    *dst++ = *src++;
 327:	8b 45 fc             	mov    -0x4(%ebp),%eax
 32a:	8d 50 01             	lea    0x1(%eax),%edx
 32d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 330:	8b 55 f8             	mov    -0x8(%ebp),%edx
 333:	8d 4a 01             	lea    0x1(%edx),%ecx
 336:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 339:	0f b6 12             	movzbl (%edx),%edx
 33c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33e:	8b 45 10             	mov    0x10(%ebp),%eax
 341:	8d 50 ff             	lea    -0x1(%eax),%edx
 344:	89 55 10             	mov    %edx,0x10(%ebp)
 347:	85 c0                	test   %eax,%eax
 349:	7f dc                	jg     327 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34e:	c9                   	leave  
 34f:	c3                   	ret    

00000350 <restorer>:
 350:	83 c4 0c             	add    $0xc,%esp
 353:	5a                   	pop    %edx
 354:	59                   	pop    %ecx
 355:	58                   	pop    %eax
 356:	c3                   	ret    

00000357 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int,siginfo_t))
{
 357:	55                   	push   %ebp
 358:	89 e5                	mov    %esp,%ebp
 35a:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 35d:	83 ec 0c             	sub    $0xc,%esp
 360:	68 50 03 00 00       	push   $0x350
 365:	e8 ce 00 00 00       	call   438 <signal_restorer>
 36a:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 36d:	83 ec 08             	sub    $0x8,%esp
 370:	ff 75 0c             	pushl  0xc(%ebp)
 373:	ff 75 08             	pushl  0x8(%ebp)
 376:	e8 b5 00 00 00       	call   430 <signal_register>
 37b:	83 c4 10             	add    $0x10,%esp
}
 37e:	c9                   	leave  
 37f:	c3                   	ret    

00000380 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 380:	b8 01 00 00 00       	mov    $0x1,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <exit>:
SYSCALL(exit)
 388:	b8 02 00 00 00       	mov    $0x2,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <wait>:
SYSCALL(wait)
 390:	b8 03 00 00 00       	mov    $0x3,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <pipe>:
SYSCALL(pipe)
 398:	b8 04 00 00 00       	mov    $0x4,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <read>:
SYSCALL(read)
 3a0:	b8 05 00 00 00       	mov    $0x5,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <write>:
SYSCALL(write)
 3a8:	b8 10 00 00 00       	mov    $0x10,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <close>:
SYSCALL(close)
 3b0:	b8 15 00 00 00       	mov    $0x15,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <kill>:
SYSCALL(kill)
 3b8:	b8 06 00 00 00       	mov    $0x6,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <exec>:
SYSCALL(exec)
 3c0:	b8 07 00 00 00       	mov    $0x7,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <open>:
SYSCALL(open)
 3c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <mknod>:
SYSCALL(mknod)
 3d0:	b8 11 00 00 00       	mov    $0x11,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <unlink>:
SYSCALL(unlink)
 3d8:	b8 12 00 00 00       	mov    $0x12,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <fstat>:
SYSCALL(fstat)
 3e0:	b8 08 00 00 00       	mov    $0x8,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <link>:
SYSCALL(link)
 3e8:	b8 13 00 00 00       	mov    $0x13,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <mkdir>:
SYSCALL(mkdir)
 3f0:	b8 14 00 00 00       	mov    $0x14,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <chdir>:
SYSCALL(chdir)
 3f8:	b8 09 00 00 00       	mov    $0x9,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <dup>:
SYSCALL(dup)
 400:	b8 0a 00 00 00       	mov    $0xa,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <getpid>:
SYSCALL(getpid)
 408:	b8 0b 00 00 00       	mov    $0xb,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <sbrk>:
SYSCALL(sbrk)
 410:	b8 0c 00 00 00       	mov    $0xc,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <sleep>:
SYSCALL(sleep)
 418:	b8 0d 00 00 00       	mov    $0xd,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <uptime>:
SYSCALL(uptime)
 420:	b8 0e 00 00 00       	mov    $0xe,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <halt>:
SYSCALL(halt)
 428:	b8 16 00 00 00       	mov    $0x16,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <signal_register>:
SYSCALL(signal_register)
 430:	b8 17 00 00 00       	mov    $0x17,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <signal_restorer>:
SYSCALL(signal_restorer)
 438:	b8 18 00 00 00       	mov    $0x18,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <mprotect>:
SYSCALL(mprotect)
 440:	b8 19 00 00 00       	mov    $0x19,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 448:	55                   	push   %ebp
 449:	89 e5                	mov    %esp,%ebp
 44b:	83 ec 18             	sub    $0x18,%esp
 44e:	8b 45 0c             	mov    0xc(%ebp),%eax
 451:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 454:	83 ec 04             	sub    $0x4,%esp
 457:	6a 01                	push   $0x1
 459:	8d 45 f4             	lea    -0xc(%ebp),%eax
 45c:	50                   	push   %eax
 45d:	ff 75 08             	pushl  0x8(%ebp)
 460:	e8 43 ff ff ff       	call   3a8 <write>
 465:	83 c4 10             	add    $0x10,%esp
}
 468:	90                   	nop
 469:	c9                   	leave  
 46a:	c3                   	ret    

0000046b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46b:	55                   	push   %ebp
 46c:	89 e5                	mov    %esp,%ebp
 46e:	53                   	push   %ebx
 46f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 479:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 47d:	74 17                	je     496 <printint+0x2b>
 47f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 483:	79 11                	jns    496 <printint+0x2b>
    neg = 1;
 485:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 48c:	8b 45 0c             	mov    0xc(%ebp),%eax
 48f:	f7 d8                	neg    %eax
 491:	89 45 ec             	mov    %eax,-0x14(%ebp)
 494:	eb 06                	jmp    49c <printint+0x31>
  } else {
    x = xx;
 496:	8b 45 0c             	mov    0xc(%ebp),%eax
 499:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 49c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4a6:	8d 41 01             	lea    0x1(%ecx),%eax
 4a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b2:	ba 00 00 00 00       	mov    $0x0,%edx
 4b7:	f7 f3                	div    %ebx
 4b9:	89 d0                	mov    %edx,%eax
 4bb:	0f b6 80 9c 0b 00 00 	movzbl 0xb9c(%eax),%eax
 4c2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4cc:	ba 00 00 00 00       	mov    $0x0,%edx
 4d1:	f7 f3                	div    %ebx
 4d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4da:	75 c7                	jne    4a3 <printint+0x38>
  if(neg)
 4dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e0:	74 2d                	je     50f <printint+0xa4>
    buf[i++] = '-';
 4e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e5:	8d 50 01             	lea    0x1(%eax),%edx
 4e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4eb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4f0:	eb 1d                	jmp    50f <printint+0xa4>
    putc(fd, buf[i]);
 4f2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f8:	01 d0                	add    %edx,%eax
 4fa:	0f b6 00             	movzbl (%eax),%eax
 4fd:	0f be c0             	movsbl %al,%eax
 500:	83 ec 08             	sub    $0x8,%esp
 503:	50                   	push   %eax
 504:	ff 75 08             	pushl  0x8(%ebp)
 507:	e8 3c ff ff ff       	call   448 <putc>
 50c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 50f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 517:	79 d9                	jns    4f2 <printint+0x87>
    putc(fd, buf[i]);
}
 519:	90                   	nop
 51a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 51d:	c9                   	leave  
 51e:	c3                   	ret    

0000051f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 51f:	55                   	push   %ebp
 520:	89 e5                	mov    %esp,%ebp
 522:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 525:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 52c:	8d 45 0c             	lea    0xc(%ebp),%eax
 52f:	83 c0 04             	add    $0x4,%eax
 532:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 53c:	e9 59 01 00 00       	jmp    69a <printf+0x17b>
    c = fmt[i] & 0xff;
 541:	8b 55 0c             	mov    0xc(%ebp),%edx
 544:	8b 45 f0             	mov    -0x10(%ebp),%eax
 547:	01 d0                	add    %edx,%eax
 549:	0f b6 00             	movzbl (%eax),%eax
 54c:	0f be c0             	movsbl %al,%eax
 54f:	25 ff 00 00 00       	and    $0xff,%eax
 554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 557:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55b:	75 2c                	jne    589 <printf+0x6a>
      if(c == '%'){
 55d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 561:	75 0c                	jne    56f <printf+0x50>
        state = '%';
 563:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56a:	e9 27 01 00 00       	jmp    696 <printf+0x177>
      } else {
        putc(fd, c);
 56f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	83 ec 08             	sub    $0x8,%esp
 578:	50                   	push   %eax
 579:	ff 75 08             	pushl  0x8(%ebp)
 57c:	e8 c7 fe ff ff       	call   448 <putc>
 581:	83 c4 10             	add    $0x10,%esp
 584:	e9 0d 01 00 00       	jmp    696 <printf+0x177>
      }
    } else if(state == '%'){
 589:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 58d:	0f 85 03 01 00 00    	jne    696 <printf+0x177>
      if(c == 'd'){
 593:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 597:	75 1e                	jne    5b7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	6a 01                	push   $0x1
 5a0:	6a 0a                	push   $0xa
 5a2:	50                   	push   %eax
 5a3:	ff 75 08             	pushl  0x8(%ebp)
 5a6:	e8 c0 fe ff ff       	call   46b <printint>
 5ab:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b2:	e9 d8 00 00 00       	jmp    68f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5b7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5bb:	74 06                	je     5c3 <printf+0xa4>
 5bd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c1:	75 1e                	jne    5e1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c6:	8b 00                	mov    (%eax),%eax
 5c8:	6a 00                	push   $0x0
 5ca:	6a 10                	push   $0x10
 5cc:	50                   	push   %eax
 5cd:	ff 75 08             	pushl  0x8(%ebp)
 5d0:	e8 96 fe ff ff       	call   46b <printint>
 5d5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5dc:	e9 ae 00 00 00       	jmp    68f <printf+0x170>
      } else if(c == 's'){
 5e1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e5:	75 43                	jne    62a <printf+0x10b>
        s = (char*)*ap;
 5e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f7:	75 25                	jne    61e <printf+0xff>
          s = "(null)";
 5f9:	c7 45 f4 25 09 00 00 	movl   $0x925,-0xc(%ebp)
        while(*s != 0){
 600:	eb 1c                	jmp    61e <printf+0xff>
          putc(fd, *s);
 602:	8b 45 f4             	mov    -0xc(%ebp),%eax
 605:	0f b6 00             	movzbl (%eax),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	83 ec 08             	sub    $0x8,%esp
 60e:	50                   	push   %eax
 60f:	ff 75 08             	pushl  0x8(%ebp)
 612:	e8 31 fe ff ff       	call   448 <putc>
 617:	83 c4 10             	add    $0x10,%esp
          s++;
 61a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 61e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 621:	0f b6 00             	movzbl (%eax),%eax
 624:	84 c0                	test   %al,%al
 626:	75 da                	jne    602 <printf+0xe3>
 628:	eb 65                	jmp    68f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 62e:	75 1d                	jne    64d <printf+0x12e>
        putc(fd, *ap);
 630:	8b 45 e8             	mov    -0x18(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	0f be c0             	movsbl %al,%eax
 638:	83 ec 08             	sub    $0x8,%esp
 63b:	50                   	push   %eax
 63c:	ff 75 08             	pushl  0x8(%ebp)
 63f:	e8 04 fe ff ff       	call   448 <putc>
 644:	83 c4 10             	add    $0x10,%esp
        ap++;
 647:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64b:	eb 42                	jmp    68f <printf+0x170>
      } else if(c == '%'){
 64d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 651:	75 17                	jne    66a <printf+0x14b>
        putc(fd, c);
 653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 656:	0f be c0             	movsbl %al,%eax
 659:	83 ec 08             	sub    $0x8,%esp
 65c:	50                   	push   %eax
 65d:	ff 75 08             	pushl  0x8(%ebp)
 660:	e8 e3 fd ff ff       	call   448 <putc>
 665:	83 c4 10             	add    $0x10,%esp
 668:	eb 25                	jmp    68f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66a:	83 ec 08             	sub    $0x8,%esp
 66d:	6a 25                	push   $0x25
 66f:	ff 75 08             	pushl  0x8(%ebp)
 672:	e8 d1 fd ff ff       	call   448 <putc>
 677:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 67a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67d:	0f be c0             	movsbl %al,%eax
 680:	83 ec 08             	sub    $0x8,%esp
 683:	50                   	push   %eax
 684:	ff 75 08             	pushl  0x8(%ebp)
 687:	e8 bc fd ff ff       	call   448 <putc>
 68c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 68f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 696:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 69a:	8b 55 0c             	mov    0xc(%ebp),%edx
 69d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a0:	01 d0                	add    %edx,%eax
 6a2:	0f b6 00             	movzbl (%eax),%eax
 6a5:	84 c0                	test   %al,%al
 6a7:	0f 85 94 fe ff ff    	jne    541 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6ad:	90                   	nop
 6ae:	c9                   	leave  
 6af:	c3                   	ret    

000006b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	83 e8 08             	sub    $0x8,%eax
 6bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bf:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 6c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c7:	eb 24                	jmp    6ed <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d1:	77 12                	ja     6e5 <free+0x35>
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d9:	77 24                	ja     6ff <free+0x4f>
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e3:	77 1a                	ja     6ff <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f3:	76 d4                	jbe    6c9 <free+0x19>
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fd:	76 ca                	jbe    6c9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	8b 40 04             	mov    0x4(%eax),%eax
 705:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	01 c2                	add    %eax,%edx
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	39 c2                	cmp    %eax,%edx
 718:	75 24                	jne    73e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	8b 50 04             	mov    0x4(%eax),%edx
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	8b 40 04             	mov    0x4(%eax),%eax
 728:	01 c2                	add    %eax,%edx
 72a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 00                	mov    (%eax),%eax
 735:	8b 10                	mov    (%eax),%edx
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	89 10                	mov    %edx,(%eax)
 73c:	eb 0a                	jmp    748 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 10                	mov    (%eax),%edx
 743:	8b 45 f8             	mov    -0x8(%ebp),%eax
 746:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 40 04             	mov    0x4(%eax),%eax
 74e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	01 d0                	add    %edx,%eax
 75a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75d:	75 20                	jne    77f <free+0xcf>
    p->s.size += bp->s.size;
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 50 04             	mov    0x4(%eax),%edx
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	8b 40 04             	mov    0x4(%eax),%eax
 76b:	01 c2                	add    %eax,%edx
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	8b 10                	mov    (%eax),%edx
 778:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77b:	89 10                	mov    %edx,(%eax)
 77d:	eb 08                	jmp    787 <free+0xd7>
  } else
    p->s.ptr = bp;
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 55 f8             	mov    -0x8(%ebp),%edx
 785:	89 10                	mov    %edx,(%eax)
  freep = p;
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	a3 b8 0b 00 00       	mov    %eax,0xbb8
}
 78f:	90                   	nop
 790:	c9                   	leave  
 791:	c3                   	ret    

00000792 <morecore>:

static Header*
morecore(uint nu)
{
 792:	55                   	push   %ebp
 793:	89 e5                	mov    %esp,%ebp
 795:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 798:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 79f:	77 07                	ja     7a8 <morecore+0x16>
    nu = 4096;
 7a1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a8:	8b 45 08             	mov    0x8(%ebp),%eax
 7ab:	c1 e0 03             	shl    $0x3,%eax
 7ae:	83 ec 0c             	sub    $0xc,%esp
 7b1:	50                   	push   %eax
 7b2:	e8 59 fc ff ff       	call   410 <sbrk>
 7b7:	83 c4 10             	add    $0x10,%esp
 7ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7bd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c1:	75 07                	jne    7ca <morecore+0x38>
    return 0;
 7c3:	b8 00 00 00 00       	mov    $0x0,%eax
 7c8:	eb 26                	jmp    7f0 <morecore+0x5e>
  hp = (Header*)p;
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d3:	8b 55 08             	mov    0x8(%ebp),%edx
 7d6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dc:	83 c0 08             	add    $0x8,%eax
 7df:	83 ec 0c             	sub    $0xc,%esp
 7e2:	50                   	push   %eax
 7e3:	e8 c8 fe ff ff       	call   6b0 <free>
 7e8:	83 c4 10             	add    $0x10,%esp
  return freep;
 7eb:	a1 b8 0b 00 00       	mov    0xbb8,%eax
}
 7f0:	c9                   	leave  
 7f1:	c3                   	ret    

000007f2 <malloc>:

void*
malloc(uint nbytes)
{
 7f2:	55                   	push   %ebp
 7f3:	89 e5                	mov    %esp,%ebp
 7f5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f8:	8b 45 08             	mov    0x8(%ebp),%eax
 7fb:	83 c0 07             	add    $0x7,%eax
 7fe:	c1 e8 03             	shr    $0x3,%eax
 801:	83 c0 01             	add    $0x1,%eax
 804:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 807:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 80c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 813:	75 23                	jne    838 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 815:	c7 45 f0 b0 0b 00 00 	movl   $0xbb0,-0x10(%ebp)
 81c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81f:	a3 b8 0b 00 00       	mov    %eax,0xbb8
 824:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 829:	a3 b0 0b 00 00       	mov    %eax,0xbb0
    base.s.size = 0;
 82e:	c7 05 b4 0b 00 00 00 	movl   $0x0,0xbb4
 835:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	8b 40 04             	mov    0x4(%eax),%eax
 846:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 849:	72 4d                	jb     898 <malloc+0xa6>
      if(p->s.size == nunits)
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 40 04             	mov    0x4(%eax),%eax
 851:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 854:	75 0c                	jne    862 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 856:	8b 45 f4             	mov    -0xc(%ebp),%eax
 859:	8b 10                	mov    (%eax),%edx
 85b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85e:	89 10                	mov    %edx,(%eax)
 860:	eb 26                	jmp    888 <malloc+0x96>
      else {
        p->s.size -= nunits;
 862:	8b 45 f4             	mov    -0xc(%ebp),%eax
 865:	8b 40 04             	mov    0x4(%eax),%eax
 868:	2b 45 ec             	sub    -0x14(%ebp),%eax
 86b:	89 c2                	mov    %eax,%edx
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 873:	8b 45 f4             	mov    -0xc(%ebp),%eax
 876:	8b 40 04             	mov    0x4(%eax),%eax
 879:	c1 e0 03             	shl    $0x3,%eax
 87c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	8b 55 ec             	mov    -0x14(%ebp),%edx
 885:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 888:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88b:	a3 b8 0b 00 00       	mov    %eax,0xbb8
      return (void*)(p + 1);
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	83 c0 08             	add    $0x8,%eax
 896:	eb 3b                	jmp    8d3 <malloc+0xe1>
    }
    if(p == freep)
 898:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 89d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a0:	75 1e                	jne    8c0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8a2:	83 ec 0c             	sub    $0xc,%esp
 8a5:	ff 75 ec             	pushl  -0x14(%ebp)
 8a8:	e8 e5 fe ff ff       	call   792 <morecore>
 8ad:	83 c4 10             	add    $0x10,%esp
 8b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b7:	75 07                	jne    8c0 <malloc+0xce>
        return 0;
 8b9:	b8 00 00 00 00       	mov    $0x0,%eax
 8be:	eb 13                	jmp    8d3 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	8b 00                	mov    (%eax),%eax
 8cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8ce:	e9 6d ff ff ff       	jmp    840 <malloc+0x4e>
}
 8d3:	c9                   	leave  
 8d4:	c3                   	ret    
