
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	pushl  -0xc(%ebp)
   e:	68 e0 0b 00 00       	push   $0xbe0
  13:	6a 01                	push   $0x1
  15:	e8 9c 03 00 00       	call   3b6 <write>
  1a:	83 c4 10             	add    $0x10,%esp
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 e0 0b 00 00       	push   $0xbe0
  2a:	ff 75 08             	pushl  0x8(%ebp)
  2d:	e8 7c 03 00 00       	call   3ae <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 eb 08 00 00       	push   $0x8eb
  4c:	6a 01                	push   $0x1
  4e:	e8 e2 04 00 00       	call   535 <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 3b 03 00 00       	call   396 <exit>
  }
}
  5b:	90                   	nop
  5c:	c9                   	leave  
  5d:	c3                   	ret    

0000005e <main>:

int
main(int argc, char *argv[])
{
  5e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  62:	83 e4 f0             	and    $0xfffffff0,%esp
  65:	ff 71 fc             	pushl  -0x4(%ecx)
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	53                   	push   %ebx
  6c:	51                   	push   %ecx
  6d:	83 ec 10             	sub    $0x10,%esp
  70:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  72:	83 3b 01             	cmpl   $0x1,(%ebx)
  75:	7f 12                	jg     89 <main+0x2b>
    cat(0);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	6a 00                	push   $0x0
  7c:	e8 7f ff ff ff       	call   0 <cat>
  81:	83 c4 10             	add    $0x10,%esp
    exit();
  84:	e8 0d 03 00 00       	call   396 <exit>
  }

  for(i = 1; i < argc; i++){
  89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  90:	eb 71                	jmp    103 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9c:	8b 43 04             	mov    0x4(%ebx),%eax
  9f:	01 d0                	add    %edx,%eax
  a1:	8b 00                	mov    (%eax),%eax
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	6a 00                	push   $0x0
  a8:	50                   	push   %eax
  a9:	e8 28 03 00 00       	call   3d6 <open>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b8:	79 29                	jns    e3 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c4:	8b 43 04             	mov    0x4(%ebx),%eax
  c7:	01 d0                	add    %edx,%eax
  c9:	8b 00                	mov    (%eax),%eax
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	50                   	push   %eax
  cf:	68 fc 08 00 00       	push   $0x8fc
  d4:	6a 01                	push   $0x1
  d6:	e8 5a 04 00 00       	call   535 <printf>
  db:	83 c4 10             	add    $0x10,%esp
      exit();
  de:	e8 b3 02 00 00       	call   396 <exit>
    }
    cat(fd);
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	ff 75 f0             	pushl  -0x10(%ebp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
  ee:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 f0             	pushl  -0x10(%ebp)
  f7:	e8 c2 02 00 00       	call   3be <close>
  fc:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 103:	8b 45 f4             	mov    -0xc(%ebp),%eax
 106:	3b 03                	cmp    (%ebx),%eax
 108:	7c 88                	jl     92 <main+0x34>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 10a:	e8 87 02 00 00       	call   396 <exit>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	90                   	nop
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 45 08             	mov    0x8(%ebp),%eax
 145:	8d 50 01             	lea    0x1(%eax),%edx
 148:	89 55 08             	mov    %edx,0x8(%ebp)
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
 14e:	8d 4a 01             	lea    0x1(%edx),%ecx
 151:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c0             	movzbl %al,%eax
 19e:	29 c2                	sub    %eax,%edx
 1a0:	89 d0                	mov    %edx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	ff 75 0c             	pushl  0xc(%ebp)
 1d5:	ff 75 08             	pushl  0x8(%ebp)
 1d8:	e8 32 ff ff ff       	call   10f <stosb>
 1dd:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <strchr>:

char*
strchr(const char *s, char c)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ee:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f1:	eb 14                	jmp    207 <strchr+0x22>
    if(*s == c)
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1fc:	75 05                	jne    203 <strchr+0x1e>
      return (char*)s;
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	eb 13                	jmp    216 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 e2                	jne    1f3 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 211:	b8 00 00 00 00       	mov    $0x0,%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 225:	eb 42                	jmp    269 <gets+0x51>
    cc = read(0, &c, 1);
 227:	83 ec 04             	sub    $0x4,%esp
 22a:	6a 01                	push   $0x1
 22c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22f:	50                   	push   %eax
 230:	6a 00                	push   $0x0
 232:	e8 77 01 00 00       	call   3ae <read>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 241:	7e 33                	jle    276 <gets+0x5e>
      break;
    buf[i++] = c;
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 f4             	mov    %edx,-0xc(%ebp)
 24c:	89 c2                	mov    %eax,%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 c2                	add    %eax,%edx
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 16                	je     277 <gets+0x5f>
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 0e                	je     277 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	83 c0 01             	add    $0x1,%eax
 26f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 272:	7c b3                	jl     227 <gets+0xf>
 274:	eb 01                	jmp    277 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 276:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 277:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <stat>:

int
stat(char *n, struct stat *st)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	6a 00                	push   $0x0
 292:	ff 75 08             	pushl  0x8(%ebp)
 295:	e8 3c 01 00 00       	call   3d6 <open>
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a4:	79 07                	jns    2ad <stat+0x26>
    return -1;
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 25                	jmp    2d2 <stat+0x4b>
  r = fstat(fd, st);
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	ff 75 0c             	pushl  0xc(%ebp)
 2b3:	ff 75 f4             	pushl  -0xc(%ebp)
 2b6:	e8 33 01 00 00       	call   3ee <fstat>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	ff 75 f4             	pushl  -0xc(%ebp)
 2c7:	e8 f2 00 00 00       	call   3be <close>
 2cc:	83 c4 10             	add    $0x10,%esp
  return r;
 2cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e1:	eb 25                	jmp    308 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	c1 e0 02             	shl    $0x2,%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	01 c0                	add    %eax,%eax
 2ef:	89 c1                	mov    %eax,%ecx
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 08             	mov    %edx,0x8(%ebp)
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	0f be c0             	movsbl %al,%eax
 300:	01 c8                	add    %ecx,%eax
 302:	83 e8 30             	sub    $0x30,%eax
 305:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	3c 2f                	cmp    $0x2f,%al
 310:	7e 0a                	jle    31c <atoi+0x48>
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	3c 39                	cmp    $0x39,%al
 31a:	7e c7                	jle    2e3 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 31c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 333:	eb 17                	jmp    34c <memmove+0x2b>
    *dst++ = *src++;
 335:	8b 45 fc             	mov    -0x4(%ebp),%eax
 338:	8d 50 01             	lea    0x1(%eax),%edx
 33b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 33e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 341:	8d 4a 01             	lea    0x1(%edx),%ecx
 344:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 347:	0f b6 12             	movzbl (%edx),%edx
 34a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 34c:	8b 45 10             	mov    0x10(%ebp),%eax
 34f:	8d 50 ff             	lea    -0x1(%eax),%edx
 352:	89 55 10             	mov    %edx,0x10(%ebp)
 355:	85 c0                	test   %eax,%eax
 357:	7f dc                	jg     335 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <restorer>:
 35e:	83 c4 0c             	add    $0xc,%esp
 361:	5a                   	pop    %edx
 362:	59                   	pop    %ecx
 363:	58                   	pop    %eax
 364:	c3                   	ret    

00000365 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 365:	55                   	push   %ebp
 366:	89 e5                	mov    %esp,%ebp
 368:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 36b:	83 ec 0c             	sub    $0xc,%esp
 36e:	68 5e 03 00 00       	push   $0x35e
 373:	e8 ce 00 00 00       	call   446 <signal_restorer>
 378:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 37b:	83 ec 08             	sub    $0x8,%esp
 37e:	ff 75 0c             	pushl  0xc(%ebp)
 381:	ff 75 08             	pushl  0x8(%ebp)
 384:	e8 b5 00 00 00       	call   43e <signal_register>
 389:	83 c4 10             	add    $0x10,%esp
}
 38c:	c9                   	leave  
 38d:	c3                   	ret    

0000038e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 38e:	b8 01 00 00 00       	mov    $0x1,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <exit>:
SYSCALL(exit)
 396:	b8 02 00 00 00       	mov    $0x2,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <wait>:
SYSCALL(wait)
 39e:	b8 03 00 00 00       	mov    $0x3,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <pipe>:
SYSCALL(pipe)
 3a6:	b8 04 00 00 00       	mov    $0x4,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <read>:
SYSCALL(read)
 3ae:	b8 05 00 00 00       	mov    $0x5,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <write>:
SYSCALL(write)
 3b6:	b8 10 00 00 00       	mov    $0x10,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <close>:
SYSCALL(close)
 3be:	b8 15 00 00 00       	mov    $0x15,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <kill>:
SYSCALL(kill)
 3c6:	b8 06 00 00 00       	mov    $0x6,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <exec>:
SYSCALL(exec)
 3ce:	b8 07 00 00 00       	mov    $0x7,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <open>:
SYSCALL(open)
 3d6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <mknod>:
SYSCALL(mknod)
 3de:	b8 11 00 00 00       	mov    $0x11,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <unlink>:
SYSCALL(unlink)
 3e6:	b8 12 00 00 00       	mov    $0x12,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <fstat>:
SYSCALL(fstat)
 3ee:	b8 08 00 00 00       	mov    $0x8,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <link>:
SYSCALL(link)
 3f6:	b8 13 00 00 00       	mov    $0x13,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <mkdir>:
SYSCALL(mkdir)
 3fe:	b8 14 00 00 00       	mov    $0x14,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <chdir>:
SYSCALL(chdir)
 406:	b8 09 00 00 00       	mov    $0x9,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <dup>:
SYSCALL(dup)
 40e:	b8 0a 00 00 00       	mov    $0xa,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <getpid>:
SYSCALL(getpid)
 416:	b8 0b 00 00 00       	mov    $0xb,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <sbrk>:
SYSCALL(sbrk)
 41e:	b8 0c 00 00 00       	mov    $0xc,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <sleep>:
SYSCALL(sleep)
 426:	b8 0d 00 00 00       	mov    $0xd,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <uptime>:
SYSCALL(uptime)
 42e:	b8 0e 00 00 00       	mov    $0xe,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <halt>:
SYSCALL(halt)
 436:	b8 16 00 00 00       	mov    $0x16,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <signal_register>:
SYSCALL(signal_register)
 43e:	b8 17 00 00 00       	mov    $0x17,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <signal_restorer>:
SYSCALL(signal_restorer)
 446:	b8 18 00 00 00       	mov    $0x18,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <mprotect>:
SYSCALL(mprotect)
 44e:	b8 19 00 00 00       	mov    $0x19,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <cowfork>:
SYSCALL(cowfork)
 456:	b8 1a 00 00 00       	mov    $0x1a,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 45e:	55                   	push   %ebp
 45f:	89 e5                	mov    %esp,%ebp
 461:	83 ec 18             	sub    $0x18,%esp
 464:	8b 45 0c             	mov    0xc(%ebp),%eax
 467:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 46a:	83 ec 04             	sub    $0x4,%esp
 46d:	6a 01                	push   $0x1
 46f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 472:	50                   	push   %eax
 473:	ff 75 08             	pushl  0x8(%ebp)
 476:	e8 3b ff ff ff       	call   3b6 <write>
 47b:	83 c4 10             	add    $0x10,%esp
}
 47e:	90                   	nop
 47f:	c9                   	leave  
 480:	c3                   	ret    

00000481 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 481:	55                   	push   %ebp
 482:	89 e5                	mov    %esp,%ebp
 484:	53                   	push   %ebx
 485:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 488:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 48f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 493:	74 17                	je     4ac <printint+0x2b>
 495:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 499:	79 11                	jns    4ac <printint+0x2b>
    neg = 1;
 49b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a5:	f7 d8                	neg    %eax
 4a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4aa:	eb 06                	jmp    4b2 <printint+0x31>
  } else {
    x = xx;
 4ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 4af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4bc:	8d 41 01             	lea    0x1(%ecx),%eax
 4bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c8:	ba 00 00 00 00       	mov    $0x0,%edx
 4cd:	f7 f3                	div    %ebx
 4cf:	89 d0                	mov    %edx,%eax
 4d1:	0f b6 80 a4 0b 00 00 	movzbl 0xba4(%eax),%eax
 4d8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e2:	ba 00 00 00 00       	mov    $0x0,%edx
 4e7:	f7 f3                	div    %ebx
 4e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f0:	75 c7                	jne    4b9 <printint+0x38>
  if(neg)
 4f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f6:	74 2d                	je     525 <printint+0xa4>
    buf[i++] = '-';
 4f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fb:	8d 50 01             	lea    0x1(%eax),%edx
 4fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
 501:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 506:	eb 1d                	jmp    525 <printint+0xa4>
    putc(fd, buf[i]);
 508:	8d 55 dc             	lea    -0x24(%ebp),%edx
 50b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50e:	01 d0                	add    %edx,%eax
 510:	0f b6 00             	movzbl (%eax),%eax
 513:	0f be c0             	movsbl %al,%eax
 516:	83 ec 08             	sub    $0x8,%esp
 519:	50                   	push   %eax
 51a:	ff 75 08             	pushl  0x8(%ebp)
 51d:	e8 3c ff ff ff       	call   45e <putc>
 522:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 525:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 529:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52d:	79 d9                	jns    508 <printint+0x87>
    putc(fd, buf[i]);
}
 52f:	90                   	nop
 530:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 533:	c9                   	leave  
 534:	c3                   	ret    

00000535 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 535:	55                   	push   %ebp
 536:	89 e5                	mov    %esp,%ebp
 538:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 53b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 542:	8d 45 0c             	lea    0xc(%ebp),%eax
 545:	83 c0 04             	add    $0x4,%eax
 548:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 54b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 552:	e9 59 01 00 00       	jmp    6b0 <printf+0x17b>
    c = fmt[i] & 0xff;
 557:	8b 55 0c             	mov    0xc(%ebp),%edx
 55a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 55d:	01 d0                	add    %edx,%eax
 55f:	0f b6 00             	movzbl (%eax),%eax
 562:	0f be c0             	movsbl %al,%eax
 565:	25 ff 00 00 00       	and    $0xff,%eax
 56a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 56d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 571:	75 2c                	jne    59f <printf+0x6a>
      if(c == '%'){
 573:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 577:	75 0c                	jne    585 <printf+0x50>
        state = '%';
 579:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 580:	e9 27 01 00 00       	jmp    6ac <printf+0x177>
      } else {
        putc(fd, c);
 585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 588:	0f be c0             	movsbl %al,%eax
 58b:	83 ec 08             	sub    $0x8,%esp
 58e:	50                   	push   %eax
 58f:	ff 75 08             	pushl  0x8(%ebp)
 592:	e8 c7 fe ff ff       	call   45e <putc>
 597:	83 c4 10             	add    $0x10,%esp
 59a:	e9 0d 01 00 00       	jmp    6ac <printf+0x177>
      }
    } else if(state == '%'){
 59f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5a3:	0f 85 03 01 00 00    	jne    6ac <printf+0x177>
      if(c == 'd'){
 5a9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ad:	75 1e                	jne    5cd <printf+0x98>
        printint(fd, *ap, 10, 1);
 5af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b2:	8b 00                	mov    (%eax),%eax
 5b4:	6a 01                	push   $0x1
 5b6:	6a 0a                	push   $0xa
 5b8:	50                   	push   %eax
 5b9:	ff 75 08             	pushl  0x8(%ebp)
 5bc:	e8 c0 fe ff ff       	call   481 <printint>
 5c1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c8:	e9 d8 00 00 00       	jmp    6a5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5cd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5d1:	74 06                	je     5d9 <printf+0xa4>
 5d3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5d7:	75 1e                	jne    5f7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5dc:	8b 00                	mov    (%eax),%eax
 5de:	6a 00                	push   $0x0
 5e0:	6a 10                	push   $0x10
 5e2:	50                   	push   %eax
 5e3:	ff 75 08             	pushl  0x8(%ebp)
 5e6:	e8 96 fe ff ff       	call   481 <printint>
 5eb:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f2:	e9 ae 00 00 00       	jmp    6a5 <printf+0x170>
      } else if(c == 's'){
 5f7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5fb:	75 43                	jne    640 <printf+0x10b>
        s = (char*)*ap;
 5fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 600:	8b 00                	mov    (%eax),%eax
 602:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 605:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60d:	75 25                	jne    634 <printf+0xff>
          s = "(null)";
 60f:	c7 45 f4 11 09 00 00 	movl   $0x911,-0xc(%ebp)
        while(*s != 0){
 616:	eb 1c                	jmp    634 <printf+0xff>
          putc(fd, *s);
 618:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61b:	0f b6 00             	movzbl (%eax),%eax
 61e:	0f be c0             	movsbl %al,%eax
 621:	83 ec 08             	sub    $0x8,%esp
 624:	50                   	push   %eax
 625:	ff 75 08             	pushl  0x8(%ebp)
 628:	e8 31 fe ff ff       	call   45e <putc>
 62d:	83 c4 10             	add    $0x10,%esp
          s++;
 630:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 634:	8b 45 f4             	mov    -0xc(%ebp),%eax
 637:	0f b6 00             	movzbl (%eax),%eax
 63a:	84 c0                	test   %al,%al
 63c:	75 da                	jne    618 <printf+0xe3>
 63e:	eb 65                	jmp    6a5 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 640:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 644:	75 1d                	jne    663 <printf+0x12e>
        putc(fd, *ap);
 646:	8b 45 e8             	mov    -0x18(%ebp),%eax
 649:	8b 00                	mov    (%eax),%eax
 64b:	0f be c0             	movsbl %al,%eax
 64e:	83 ec 08             	sub    $0x8,%esp
 651:	50                   	push   %eax
 652:	ff 75 08             	pushl  0x8(%ebp)
 655:	e8 04 fe ff ff       	call   45e <putc>
 65a:	83 c4 10             	add    $0x10,%esp
        ap++;
 65d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 661:	eb 42                	jmp    6a5 <printf+0x170>
      } else if(c == '%'){
 663:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 667:	75 17                	jne    680 <printf+0x14b>
        putc(fd, c);
 669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66c:	0f be c0             	movsbl %al,%eax
 66f:	83 ec 08             	sub    $0x8,%esp
 672:	50                   	push   %eax
 673:	ff 75 08             	pushl  0x8(%ebp)
 676:	e8 e3 fd ff ff       	call   45e <putc>
 67b:	83 c4 10             	add    $0x10,%esp
 67e:	eb 25                	jmp    6a5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 680:	83 ec 08             	sub    $0x8,%esp
 683:	6a 25                	push   $0x25
 685:	ff 75 08             	pushl  0x8(%ebp)
 688:	e8 d1 fd ff ff       	call   45e <putc>
 68d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 690:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 693:	0f be c0             	movsbl %al,%eax
 696:	83 ec 08             	sub    $0x8,%esp
 699:	50                   	push   %eax
 69a:	ff 75 08             	pushl  0x8(%ebp)
 69d:	e8 bc fd ff ff       	call   45e <putc>
 6a2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ac:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6b0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b6:	01 d0                	add    %edx,%eax
 6b8:	0f b6 00             	movzbl (%eax),%eax
 6bb:	84 c0                	test   %al,%al
 6bd:	0f 85 94 fe ff ff    	jne    557 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c3:	90                   	nop
 6c4:	c9                   	leave  
 6c5:	c3                   	ret    

000006c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c6:	55                   	push   %ebp
 6c7:	89 e5                	mov    %esp,%ebp
 6c9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6cc:	8b 45 08             	mov    0x8(%ebp),%eax
 6cf:	83 e8 08             	sub    $0x8,%eax
 6d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d5:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 6da:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6dd:	eb 24                	jmp    703 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	8b 00                	mov    (%eax),%eax
 6e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e7:	77 12                	ja     6fb <free+0x35>
 6e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ef:	77 24                	ja     715 <free+0x4f>
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f9:	77 1a                	ja     715 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	89 45 fc             	mov    %eax,-0x4(%ebp)
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 709:	76 d4                	jbe    6df <free+0x19>
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	8b 00                	mov    (%eax),%eax
 710:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 713:	76 ca                	jbe    6df <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 715:	8b 45 f8             	mov    -0x8(%ebp),%eax
 718:	8b 40 04             	mov    0x4(%eax),%eax
 71b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	01 c2                	add    %eax,%edx
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	8b 00                	mov    (%eax),%eax
 72c:	39 c2                	cmp    %eax,%edx
 72e:	75 24                	jne    754 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 730:	8b 45 f8             	mov    -0x8(%ebp),%eax
 733:	8b 50 04             	mov    0x4(%eax),%edx
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 00                	mov    (%eax),%eax
 73b:	8b 40 04             	mov    0x4(%eax),%eax
 73e:	01 c2                	add    %eax,%edx
 740:	8b 45 f8             	mov    -0x8(%ebp),%eax
 743:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	8b 00                	mov    (%eax),%eax
 74b:	8b 10                	mov    (%eax),%edx
 74d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 750:	89 10                	mov    %edx,(%eax)
 752:	eb 0a                	jmp    75e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 10                	mov    (%eax),%edx
 759:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	8b 40 04             	mov    0x4(%eax),%eax
 764:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	01 d0                	add    %edx,%eax
 770:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 773:	75 20                	jne    795 <free+0xcf>
    p->s.size += bp->s.size;
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 50 04             	mov    0x4(%eax),%edx
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	8b 40 04             	mov    0x4(%eax),%eax
 781:	01 c2                	add    %eax,%edx
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 789:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78c:	8b 10                	mov    (%eax),%edx
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	89 10                	mov    %edx,(%eax)
 793:	eb 08                	jmp    79d <free+0xd7>
  } else
    p->s.ptr = bp;
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 55 f8             	mov    -0x8(%ebp),%edx
 79b:	89 10                	mov    %edx,(%eax)
  freep = p;
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	a3 c8 0b 00 00       	mov    %eax,0xbc8
}
 7a5:	90                   	nop
 7a6:	c9                   	leave  
 7a7:	c3                   	ret    

000007a8 <morecore>:

static Header*
morecore(uint nu)
{
 7a8:	55                   	push   %ebp
 7a9:	89 e5                	mov    %esp,%ebp
 7ab:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ae:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7b5:	77 07                	ja     7be <morecore+0x16>
    nu = 4096;
 7b7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7be:	8b 45 08             	mov    0x8(%ebp),%eax
 7c1:	c1 e0 03             	shl    $0x3,%eax
 7c4:	83 ec 0c             	sub    $0xc,%esp
 7c7:	50                   	push   %eax
 7c8:	e8 51 fc ff ff       	call   41e <sbrk>
 7cd:	83 c4 10             	add    $0x10,%esp
 7d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7d7:	75 07                	jne    7e0 <morecore+0x38>
    return 0;
 7d9:	b8 00 00 00 00       	mov    $0x0,%eax
 7de:	eb 26                	jmp    806 <morecore+0x5e>
  hp = (Header*)p;
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e9:	8b 55 08             	mov    0x8(%ebp),%edx
 7ec:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f2:	83 c0 08             	add    $0x8,%eax
 7f5:	83 ec 0c             	sub    $0xc,%esp
 7f8:	50                   	push   %eax
 7f9:	e8 c8 fe ff ff       	call   6c6 <free>
 7fe:	83 c4 10             	add    $0x10,%esp
  return freep;
 801:	a1 c8 0b 00 00       	mov    0xbc8,%eax
}
 806:	c9                   	leave  
 807:	c3                   	ret    

00000808 <malloc>:

void*
malloc(uint nbytes)
{
 808:	55                   	push   %ebp
 809:	89 e5                	mov    %esp,%ebp
 80b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80e:	8b 45 08             	mov    0x8(%ebp),%eax
 811:	83 c0 07             	add    $0x7,%eax
 814:	c1 e8 03             	shr    $0x3,%eax
 817:	83 c0 01             	add    $0x1,%eax
 81a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 81d:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 822:	89 45 f0             	mov    %eax,-0x10(%ebp)
 825:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 829:	75 23                	jne    84e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 82b:	c7 45 f0 c0 0b 00 00 	movl   $0xbc0,-0x10(%ebp)
 832:	8b 45 f0             	mov    -0x10(%ebp),%eax
 835:	a3 c8 0b 00 00       	mov    %eax,0xbc8
 83a:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 83f:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    base.s.size = 0;
 844:	c7 05 c4 0b 00 00 00 	movl   $0x0,0xbc4
 84b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 851:	8b 00                	mov    (%eax),%eax
 853:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 856:	8b 45 f4             	mov    -0xc(%ebp),%eax
 859:	8b 40 04             	mov    0x4(%eax),%eax
 85c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85f:	72 4d                	jb     8ae <malloc+0xa6>
      if(p->s.size == nunits)
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	8b 40 04             	mov    0x4(%eax),%eax
 867:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86a:	75 0c                	jne    878 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	8b 10                	mov    (%eax),%edx
 871:	8b 45 f0             	mov    -0x10(%ebp),%eax
 874:	89 10                	mov    %edx,(%eax)
 876:	eb 26                	jmp    89e <malloc+0x96>
      else {
        p->s.size -= nunits;
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	8b 40 04             	mov    0x4(%eax),%eax
 87e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 881:	89 c2                	mov    %eax,%edx
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	8b 40 04             	mov    0x4(%eax),%eax
 88f:	c1 e0 03             	shl    $0x3,%eax
 892:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 895:	8b 45 f4             	mov    -0xc(%ebp),%eax
 898:	8b 55 ec             	mov    -0x14(%ebp),%edx
 89b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 89e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a1:	a3 c8 0b 00 00       	mov    %eax,0xbc8
      return (void*)(p + 1);
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	83 c0 08             	add    $0x8,%eax
 8ac:	eb 3b                	jmp    8e9 <malloc+0xe1>
    }
    if(p == freep)
 8ae:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 8b3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b6:	75 1e                	jne    8d6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8b8:	83 ec 0c             	sub    $0xc,%esp
 8bb:	ff 75 ec             	pushl  -0x14(%ebp)
 8be:	e8 e5 fe ff ff       	call   7a8 <morecore>
 8c3:	83 c4 10             	add    $0x10,%esp
 8c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8cd:	75 07                	jne    8d6 <malloc+0xce>
        return 0;
 8cf:	b8 00 00 00 00       	mov    $0x0,%eax
 8d4:	eb 13                	jmp    8e9 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	8b 00                	mov    (%eax),%eax
 8e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e4:	e9 6d ff ff ff       	jmp    856 <malloc+0x4e>
}
 8e9:	c9                   	leave  
 8ea:	c3                   	ret    
