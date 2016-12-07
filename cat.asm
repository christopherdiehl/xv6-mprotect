
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
  47:	68 e3 08 00 00       	push   $0x8e3
  4c:	6a 01                	push   $0x1
  4e:	e8 da 04 00 00       	call   52d <printf>
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
  cf:	68 f4 08 00 00       	push   $0x8f4
  d4:	6a 01                	push   $0x1
  d6:	e8 52 04 00 00       	call   52d <printf>
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

int signal(int signum, void(*handler)(int,siginfo_t))
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

00000456 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 456:	55                   	push   %ebp
 457:	89 e5                	mov    %esp,%ebp
 459:	83 ec 18             	sub    $0x18,%esp
 45c:	8b 45 0c             	mov    0xc(%ebp),%eax
 45f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 462:	83 ec 04             	sub    $0x4,%esp
 465:	6a 01                	push   $0x1
 467:	8d 45 f4             	lea    -0xc(%ebp),%eax
 46a:	50                   	push   %eax
 46b:	ff 75 08             	pushl  0x8(%ebp)
 46e:	e8 43 ff ff ff       	call   3b6 <write>
 473:	83 c4 10             	add    $0x10,%esp
}
 476:	90                   	nop
 477:	c9                   	leave  
 478:	c3                   	ret    

00000479 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 479:	55                   	push   %ebp
 47a:	89 e5                	mov    %esp,%ebp
 47c:	53                   	push   %ebx
 47d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 480:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 487:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 48b:	74 17                	je     4a4 <printint+0x2b>
 48d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 491:	79 11                	jns    4a4 <printint+0x2b>
    neg = 1;
 493:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 49a:	8b 45 0c             	mov    0xc(%ebp),%eax
 49d:	f7 d8                	neg    %eax
 49f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a2:	eb 06                	jmp    4aa <printint+0x31>
  } else {
    x = xx;
 4a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4b4:	8d 41 01             	lea    0x1(%ecx),%eax
 4b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c0:	ba 00 00 00 00       	mov    $0x0,%edx
 4c5:	f7 f3                	div    %ebx
 4c7:	89 d0                	mov    %edx,%eax
 4c9:	0f b6 80 9c 0b 00 00 	movzbl 0xb9c(%eax),%eax
 4d0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4da:	ba 00 00 00 00       	mov    $0x0,%edx
 4df:	f7 f3                	div    %ebx
 4e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e8:	75 c7                	jne    4b1 <printint+0x38>
  if(neg)
 4ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ee:	74 2d                	je     51d <printint+0xa4>
    buf[i++] = '-';
 4f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f3:	8d 50 01             	lea    0x1(%eax),%edx
 4f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4f9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4fe:	eb 1d                	jmp    51d <printint+0xa4>
    putc(fd, buf[i]);
 500:	8d 55 dc             	lea    -0x24(%ebp),%edx
 503:	8b 45 f4             	mov    -0xc(%ebp),%eax
 506:	01 d0                	add    %edx,%eax
 508:	0f b6 00             	movzbl (%eax),%eax
 50b:	0f be c0             	movsbl %al,%eax
 50e:	83 ec 08             	sub    $0x8,%esp
 511:	50                   	push   %eax
 512:	ff 75 08             	pushl  0x8(%ebp)
 515:	e8 3c ff ff ff       	call   456 <putc>
 51a:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 51d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 521:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 525:	79 d9                	jns    500 <printint+0x87>
    putc(fd, buf[i]);
}
 527:	90                   	nop
 528:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 52b:	c9                   	leave  
 52c:	c3                   	ret    

0000052d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 52d:	55                   	push   %ebp
 52e:	89 e5                	mov    %esp,%ebp
 530:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 533:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 53a:	8d 45 0c             	lea    0xc(%ebp),%eax
 53d:	83 c0 04             	add    $0x4,%eax
 540:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 543:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 54a:	e9 59 01 00 00       	jmp    6a8 <printf+0x17b>
    c = fmt[i] & 0xff;
 54f:	8b 55 0c             	mov    0xc(%ebp),%edx
 552:	8b 45 f0             	mov    -0x10(%ebp),%eax
 555:	01 d0                	add    %edx,%eax
 557:	0f b6 00             	movzbl (%eax),%eax
 55a:	0f be c0             	movsbl %al,%eax
 55d:	25 ff 00 00 00       	and    $0xff,%eax
 562:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 565:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 569:	75 2c                	jne    597 <printf+0x6a>
      if(c == '%'){
 56b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56f:	75 0c                	jne    57d <printf+0x50>
        state = '%';
 571:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 578:	e9 27 01 00 00       	jmp    6a4 <printf+0x177>
      } else {
        putc(fd, c);
 57d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 580:	0f be c0             	movsbl %al,%eax
 583:	83 ec 08             	sub    $0x8,%esp
 586:	50                   	push   %eax
 587:	ff 75 08             	pushl  0x8(%ebp)
 58a:	e8 c7 fe ff ff       	call   456 <putc>
 58f:	83 c4 10             	add    $0x10,%esp
 592:	e9 0d 01 00 00       	jmp    6a4 <printf+0x177>
      }
    } else if(state == '%'){
 597:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 59b:	0f 85 03 01 00 00    	jne    6a4 <printf+0x177>
      if(c == 'd'){
 5a1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5a5:	75 1e                	jne    5c5 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5aa:	8b 00                	mov    (%eax),%eax
 5ac:	6a 01                	push   $0x1
 5ae:	6a 0a                	push   $0xa
 5b0:	50                   	push   %eax
 5b1:	ff 75 08             	pushl  0x8(%ebp)
 5b4:	e8 c0 fe ff ff       	call   479 <printint>
 5b9:	83 c4 10             	add    $0x10,%esp
        ap++;
 5bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c0:	e9 d8 00 00 00       	jmp    69d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5c5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5c9:	74 06                	je     5d1 <printf+0xa4>
 5cb:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5cf:	75 1e                	jne    5ef <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d4:	8b 00                	mov    (%eax),%eax
 5d6:	6a 00                	push   $0x0
 5d8:	6a 10                	push   $0x10
 5da:	50                   	push   %eax
 5db:	ff 75 08             	pushl  0x8(%ebp)
 5de:	e8 96 fe ff ff       	call   479 <printint>
 5e3:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ea:	e9 ae 00 00 00       	jmp    69d <printf+0x170>
      } else if(c == 's'){
 5ef:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5f3:	75 43                	jne    638 <printf+0x10b>
        s = (char*)*ap;
 5f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f8:	8b 00                	mov    (%eax),%eax
 5fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 605:	75 25                	jne    62c <printf+0xff>
          s = "(null)";
 607:	c7 45 f4 09 09 00 00 	movl   $0x909,-0xc(%ebp)
        while(*s != 0){
 60e:	eb 1c                	jmp    62c <printf+0xff>
          putc(fd, *s);
 610:	8b 45 f4             	mov    -0xc(%ebp),%eax
 613:	0f b6 00             	movzbl (%eax),%eax
 616:	0f be c0             	movsbl %al,%eax
 619:	83 ec 08             	sub    $0x8,%esp
 61c:	50                   	push   %eax
 61d:	ff 75 08             	pushl  0x8(%ebp)
 620:	e8 31 fe ff ff       	call   456 <putc>
 625:	83 c4 10             	add    $0x10,%esp
          s++;
 628:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 62c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62f:	0f b6 00             	movzbl (%eax),%eax
 632:	84 c0                	test   %al,%al
 634:	75 da                	jne    610 <printf+0xe3>
 636:	eb 65                	jmp    69d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 638:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 63c:	75 1d                	jne    65b <printf+0x12e>
        putc(fd, *ap);
 63e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 641:	8b 00                	mov    (%eax),%eax
 643:	0f be c0             	movsbl %al,%eax
 646:	83 ec 08             	sub    $0x8,%esp
 649:	50                   	push   %eax
 64a:	ff 75 08             	pushl  0x8(%ebp)
 64d:	e8 04 fe ff ff       	call   456 <putc>
 652:	83 c4 10             	add    $0x10,%esp
        ap++;
 655:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 659:	eb 42                	jmp    69d <printf+0x170>
      } else if(c == '%'){
 65b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 65f:	75 17                	jne    678 <printf+0x14b>
        putc(fd, c);
 661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 664:	0f be c0             	movsbl %al,%eax
 667:	83 ec 08             	sub    $0x8,%esp
 66a:	50                   	push   %eax
 66b:	ff 75 08             	pushl  0x8(%ebp)
 66e:	e8 e3 fd ff ff       	call   456 <putc>
 673:	83 c4 10             	add    $0x10,%esp
 676:	eb 25                	jmp    69d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 678:	83 ec 08             	sub    $0x8,%esp
 67b:	6a 25                	push   $0x25
 67d:	ff 75 08             	pushl  0x8(%ebp)
 680:	e8 d1 fd ff ff       	call   456 <putc>
 685:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68b:	0f be c0             	movsbl %al,%eax
 68e:	83 ec 08             	sub    $0x8,%esp
 691:	50                   	push   %eax
 692:	ff 75 08             	pushl  0x8(%ebp)
 695:	e8 bc fd ff ff       	call   456 <putc>
 69a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 69d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ae:	01 d0                	add    %edx,%eax
 6b0:	0f b6 00             	movzbl (%eax),%eax
 6b3:	84 c0                	test   %al,%al
 6b5:	0f 85 94 fe ff ff    	jne    54f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6bb:	90                   	nop
 6bc:	c9                   	leave  
 6bd:	c3                   	ret    

000006be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6be:	55                   	push   %ebp
 6bf:	89 e5                	mov    %esp,%ebp
 6c1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	83 e8 08             	sub    $0x8,%eax
 6ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6cd:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 6d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d5:	eb 24                	jmp    6fb <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6df:	77 12                	ja     6f3 <free+0x35>
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e7:	77 24                	ja     70d <free+0x4f>
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f1:	77 1a                	ja     70d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	8b 00                	mov    (%eax),%eax
 6f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 701:	76 d4                	jbe    6d7 <free+0x19>
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	8b 00                	mov    (%eax),%eax
 708:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70b:	76 ca                	jbe    6d7 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 70d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 710:	8b 40 04             	mov    0x4(%eax),%eax
 713:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	01 c2                	add    %eax,%edx
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	39 c2                	cmp    %eax,%edx
 726:	75 24                	jne    74c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	8b 50 04             	mov    0x4(%eax),%edx
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	8b 00                	mov    (%eax),%eax
 733:	8b 40 04             	mov    0x4(%eax),%eax
 736:	01 c2                	add    %eax,%edx
 738:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 00                	mov    (%eax),%eax
 743:	8b 10                	mov    (%eax),%edx
 745:	8b 45 f8             	mov    -0x8(%ebp),%eax
 748:	89 10                	mov    %edx,(%eax)
 74a:	eb 0a                	jmp    756 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 10                	mov    (%eax),%edx
 751:	8b 45 f8             	mov    -0x8(%ebp),%eax
 754:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 756:	8b 45 fc             	mov    -0x4(%ebp),%eax
 759:	8b 40 04             	mov    0x4(%eax),%eax
 75c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	01 d0                	add    %edx,%eax
 768:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76b:	75 20                	jne    78d <free+0xcf>
    p->s.size += bp->s.size;
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 50 04             	mov    0x4(%eax),%edx
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	8b 40 04             	mov    0x4(%eax),%eax
 779:	01 c2                	add    %eax,%edx
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	8b 10                	mov    (%eax),%edx
 786:	8b 45 fc             	mov    -0x4(%ebp),%eax
 789:	89 10                	mov    %edx,(%eax)
 78b:	eb 08                	jmp    795 <free+0xd7>
  } else
    p->s.ptr = bp;
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	8b 55 f8             	mov    -0x8(%ebp),%edx
 793:	89 10                	mov    %edx,(%eax)
  freep = p;
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	a3 c8 0b 00 00       	mov    %eax,0xbc8
}
 79d:	90                   	nop
 79e:	c9                   	leave  
 79f:	c3                   	ret    

000007a0 <morecore>:

static Header*
morecore(uint nu)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7a6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ad:	77 07                	ja     7b6 <morecore+0x16>
    nu = 4096;
 7af:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7b6:	8b 45 08             	mov    0x8(%ebp),%eax
 7b9:	c1 e0 03             	shl    $0x3,%eax
 7bc:	83 ec 0c             	sub    $0xc,%esp
 7bf:	50                   	push   %eax
 7c0:	e8 59 fc ff ff       	call   41e <sbrk>
 7c5:	83 c4 10             	add    $0x10,%esp
 7c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7cb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7cf:	75 07                	jne    7d8 <morecore+0x38>
    return 0;
 7d1:	b8 00 00 00 00       	mov    $0x0,%eax
 7d6:	eb 26                	jmp    7fe <morecore+0x5e>
  hp = (Header*)p;
 7d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e1:	8b 55 08             	mov    0x8(%ebp),%edx
 7e4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ea:	83 c0 08             	add    $0x8,%eax
 7ed:	83 ec 0c             	sub    $0xc,%esp
 7f0:	50                   	push   %eax
 7f1:	e8 c8 fe ff ff       	call   6be <free>
 7f6:	83 c4 10             	add    $0x10,%esp
  return freep;
 7f9:	a1 c8 0b 00 00       	mov    0xbc8,%eax
}
 7fe:	c9                   	leave  
 7ff:	c3                   	ret    

00000800 <malloc>:

void*
malloc(uint nbytes)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 806:	8b 45 08             	mov    0x8(%ebp),%eax
 809:	83 c0 07             	add    $0x7,%eax
 80c:	c1 e8 03             	shr    $0x3,%eax
 80f:	83 c0 01             	add    $0x1,%eax
 812:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 815:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 81a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 81d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 821:	75 23                	jne    846 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 823:	c7 45 f0 c0 0b 00 00 	movl   $0xbc0,-0x10(%ebp)
 82a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82d:	a3 c8 0b 00 00       	mov    %eax,0xbc8
 832:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 837:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    base.s.size = 0;
 83c:	c7 05 c4 0b 00 00 00 	movl   $0x0,0xbc4
 843:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 846:	8b 45 f0             	mov    -0x10(%ebp),%eax
 849:	8b 00                	mov    (%eax),%eax
 84b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	8b 40 04             	mov    0x4(%eax),%eax
 854:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 857:	72 4d                	jb     8a6 <malloc+0xa6>
      if(p->s.size == nunits)
 859:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85c:	8b 40 04             	mov    0x4(%eax),%eax
 85f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 862:	75 0c                	jne    870 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	8b 10                	mov    (%eax),%edx
 869:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86c:	89 10                	mov    %edx,(%eax)
 86e:	eb 26                	jmp    896 <malloc+0x96>
      else {
        p->s.size -= nunits;
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	8b 40 04             	mov    0x4(%eax),%eax
 876:	2b 45 ec             	sub    -0x14(%ebp),%eax
 879:	89 c2                	mov    %eax,%edx
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 881:	8b 45 f4             	mov    -0xc(%ebp),%eax
 884:	8b 40 04             	mov    0x4(%eax),%eax
 887:	c1 e0 03             	shl    $0x3,%eax
 88a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	8b 55 ec             	mov    -0x14(%ebp),%edx
 893:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 896:	8b 45 f0             	mov    -0x10(%ebp),%eax
 899:	a3 c8 0b 00 00       	mov    %eax,0xbc8
      return (void*)(p + 1);
 89e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a1:	83 c0 08             	add    $0x8,%eax
 8a4:	eb 3b                	jmp    8e1 <malloc+0xe1>
    }
    if(p == freep)
 8a6:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 8ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8ae:	75 1e                	jne    8ce <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8b0:	83 ec 0c             	sub    $0xc,%esp
 8b3:	ff 75 ec             	pushl  -0x14(%ebp)
 8b6:	e8 e5 fe ff ff       	call   7a0 <morecore>
 8bb:	83 c4 10             	add    $0x10,%esp
 8be:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8c5:	75 07                	jne    8ce <malloc+0xce>
        return 0;
 8c7:	b8 00 00 00 00       	mov    $0x0,%eax
 8cc:	eb 13                	jmp    8e1 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	8b 00                	mov    (%eax),%eax
 8d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8dc:	e9 6d ff ff ff       	jmp    84e <malloc+0x4e>
}
 8e1:	c9                   	leave  
 8e2:	c3                   	ret    
