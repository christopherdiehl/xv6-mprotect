
_signal_test:     file format elf32-i386


Disassembly of section .text:

00000000 <handle_signal>:
#include "types.h"
#include "user.h"
#include "signal.h"

void handle_signal(int signum)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    unsigned addr_signum = (unsigned) &signum;
   6:	8d 45 08             	lea    0x8(%ebp),%eax
   9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    unsigned addr_retaddr = addr_signum + 16;
   c:	8b 45 f4             	mov    -0xc(%ebp),%eax
   f:	83 c0 10             	add    $0x10,%eax
  12:	89 45 f0             	mov    %eax,-0x10(%ebp)
    unsigned *retaddr = (unsigned*) addr_retaddr;
  15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  18:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1, "addr_signum = %d\n", addr_signum);
  1b:	83 ec 04             	sub    $0x4,%esp
  1e:	ff 75 f4             	pushl  -0xc(%ebp)
  21:	68 b8 08 00 00       	push   $0x8b8
  26:	6a 01                	push   $0x1
  28:	e8 d3 04 00 00       	call   500 <printf>
  2d:	83 c4 10             	add    $0x10,%esp
    printf(1, "addr_retaddr = %d\n", addr_retaddr);
  30:	83 ec 04             	sub    $0x4,%esp
  33:	ff 75 f0             	pushl  -0x10(%ebp)
  36:	68 ca 08 00 00       	push   $0x8ca
  3b:	6a 01                	push   $0x1
  3d:	e8 be 04 00 00       	call   500 <printf>
  42:	83 c4 10             	add    $0x10,%esp
    printf(1, "retaddr = %d\n", *retaddr);
  45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 04             	sub    $0x4,%esp
  4d:	50                   	push   %eax
  4e:	68 dd 08 00 00       	push   $0x8dd
  53:	6a 01                	push   $0x1
  55:	e8 a6 04 00 00       	call   500 <printf>
  5a:	83 c4 10             	add    $0x10,%esp
    *retaddr += 4;
  5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	8d 50 04             	lea    0x4(%eax),%edx
  65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  68:	89 10                	mov    %edx,(%eax)

    __asm__ ("movl $0x0,%ecx\n\t");
  6a:	b9 00 00 00 00       	mov    $0x0,%ecx
} 
  6f:	90                   	nop
  70:	c9                   	leave  
  71:	c3                   	ret    

00000072 <main>:

int main(void)
{
  72:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  76:	83 e4 f0             	and    $0xfffffff0,%esp
  79:	ff 71 fc             	pushl  -0x4(%ecx)
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	51                   	push   %ecx
  80:	83 ec 14             	sub    $0x14,%esp
    register int ecx asm ("%ecx");
    
    signal(SIGFPE, handle_signal);         // register the actual signal for divide by zero.
  83:	83 ec 08             	sub    $0x8,%esp
  86:	68 00 00 00 00       	push   $0x0
  8b:	6a 01                	push   $0x1
  8d:	e8 ae 02 00 00       	call   340 <signal>
  92:	83 c4 10             	add    $0x10,%esp

    int x = 5;
  95:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
    int y = 0;
  9c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    ecx = 5;
  a3:	b9 05 00 00 00       	mov    $0x5,%ecx
    x = x / y;
  a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ab:	99                   	cltd   
  ac:	f7 7d f0             	idivl  -0x10(%ebp)
  af:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (ecx == 5)
  b2:	89 c8                	mov    %ecx,%eax
  b4:	83 f8 05             	cmp    $0x5,%eax
  b7:	75 17                	jne    d0 <main+0x5e>
        printf(1, "TEST PASSED: Final value of ecx is %d...\n", ecx);
  b9:	89 c8                	mov    %ecx,%eax
  bb:	83 ec 04             	sub    $0x4,%esp
  be:	50                   	push   %eax
  bf:	68 ec 08 00 00       	push   $0x8ec
  c4:	6a 01                	push   $0x1
  c6:	e8 35 04 00 00       	call   500 <printf>
  cb:	83 c4 10             	add    $0x10,%esp
  ce:	eb 15                	jmp    e5 <main+0x73>
    else
        printf(1, "TEST FAILED: Final value of ecx is %d...\n", ecx);
  d0:	89 c8                	mov    %ecx,%eax
  d2:	83 ec 04             	sub    $0x4,%esp
  d5:	50                   	push   %eax
  d6:	68 18 09 00 00       	push   $0x918
  db:	6a 01                	push   $0x1
  dd:	e8 1e 04 00 00       	call   500 <printf>
  e2:	83 c4 10             	add    $0x10,%esp

    exit();
  e5:	e8 87 02 00 00       	call   371 <exit>

000000ea <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ea:	55                   	push   %ebp
  eb:	89 e5                	mov    %esp,%ebp
  ed:	57                   	push   %edi
  ee:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f2:	8b 55 10             	mov    0x10(%ebp),%edx
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	89 cb                	mov    %ecx,%ebx
  fa:	89 df                	mov    %ebx,%edi
  fc:	89 d1                	mov    %edx,%ecx
  fe:	fc                   	cld    
  ff:	f3 aa                	rep stos %al,%es:(%edi)
 101:	89 ca                	mov    %ecx,%edx
 103:	89 fb                	mov    %edi,%ebx
 105:	89 5d 08             	mov    %ebx,0x8(%ebp)
 108:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 10b:	90                   	nop
 10c:	5b                   	pop    %ebx
 10d:	5f                   	pop    %edi
 10e:	5d                   	pop    %ebp
 10f:	c3                   	ret    

00000110 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 11c:	90                   	nop
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	8d 50 01             	lea    0x1(%eax),%edx
 123:	89 55 08             	mov    %edx,0x8(%ebp)
 126:	8b 55 0c             	mov    0xc(%ebp),%edx
 129:	8d 4a 01             	lea    0x1(%edx),%ecx
 12c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 12f:	0f b6 12             	movzbl (%edx),%edx
 132:	88 10                	mov    %dl,(%eax)
 134:	0f b6 00             	movzbl (%eax),%eax
 137:	84 c0                	test   %al,%al
 139:	75 e2                	jne    11d <strcpy+0xd>
    ;
  return os;
 13b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13e:	c9                   	leave  
 13f:	c3                   	ret    

00000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 143:	eb 08                	jmp    14d <strcmp+0xd>
    p++, q++;
 145:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 149:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 14d:	8b 45 08             	mov    0x8(%ebp),%eax
 150:	0f b6 00             	movzbl (%eax),%eax
 153:	84 c0                	test   %al,%al
 155:	74 10                	je     167 <strcmp+0x27>
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	0f b6 10             	movzbl (%eax),%edx
 15d:	8b 45 0c             	mov    0xc(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	38 c2                	cmp    %al,%dl
 165:	74 de                	je     145 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	0f b6 00             	movzbl (%eax),%eax
 16d:	0f b6 d0             	movzbl %al,%edx
 170:	8b 45 0c             	mov    0xc(%ebp),%eax
 173:	0f b6 00             	movzbl (%eax),%eax
 176:	0f b6 c0             	movzbl %al,%eax
 179:	29 c2                	sub    %eax,%edx
 17b:	89 d0                	mov    %edx,%eax
}
 17d:	5d                   	pop    %ebp
 17e:	c3                   	ret    

0000017f <strlen>:

uint
strlen(char *s)
{
 17f:	55                   	push   %ebp
 180:	89 e5                	mov    %esp,%ebp
 182:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 185:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 18c:	eb 04                	jmp    192 <strlen+0x13>
 18e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 192:	8b 55 fc             	mov    -0x4(%ebp),%edx
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	01 d0                	add    %edx,%eax
 19a:	0f b6 00             	movzbl (%eax),%eax
 19d:	84 c0                	test   %al,%al
 19f:	75 ed                	jne    18e <strlen+0xf>
    ;
  return n;
 1a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a4:	c9                   	leave  
 1a5:	c3                   	ret    

000001a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1a9:	8b 45 10             	mov    0x10(%ebp),%eax
 1ac:	50                   	push   %eax
 1ad:	ff 75 0c             	pushl  0xc(%ebp)
 1b0:	ff 75 08             	pushl  0x8(%ebp)
 1b3:	e8 32 ff ff ff       	call   ea <stosb>
 1b8:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1be:	c9                   	leave  
 1bf:	c3                   	ret    

000001c0 <strchr>:

char*
strchr(const char *s, char c)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 04             	sub    $0x4,%esp
 1c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1cc:	eb 14                	jmp    1e2 <strchr+0x22>
    if(*s == c)
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	0f b6 00             	movzbl (%eax),%eax
 1d4:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1d7:	75 05                	jne    1de <strchr+0x1e>
      return (char*)s;
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
 1dc:	eb 13                	jmp    1f1 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1de:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	0f b6 00             	movzbl (%eax),%eax
 1e8:	84 c0                	test   %al,%al
 1ea:	75 e2                	jne    1ce <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1f1:	c9                   	leave  
 1f2:	c3                   	ret    

000001f3 <gets>:

char*
gets(char *buf, int max)
{
 1f3:	55                   	push   %ebp
 1f4:	89 e5                	mov    %esp,%ebp
 1f6:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 200:	eb 42                	jmp    244 <gets+0x51>
    cc = read(0, &c, 1);
 202:	83 ec 04             	sub    $0x4,%esp
 205:	6a 01                	push   $0x1
 207:	8d 45 ef             	lea    -0x11(%ebp),%eax
 20a:	50                   	push   %eax
 20b:	6a 00                	push   $0x0
 20d:	e8 77 01 00 00       	call   389 <read>
 212:	83 c4 10             	add    $0x10,%esp
 215:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 218:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 21c:	7e 33                	jle    251 <gets+0x5e>
      break;
    buf[i++] = c;
 21e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 221:	8d 50 01             	lea    0x1(%eax),%edx
 224:	89 55 f4             	mov    %edx,-0xc(%ebp)
 227:	89 c2                	mov    %eax,%edx
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	01 c2                	add    %eax,%edx
 22e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 232:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 234:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 238:	3c 0a                	cmp    $0xa,%al
 23a:	74 16                	je     252 <gets+0x5f>
 23c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 240:	3c 0d                	cmp    $0xd,%al
 242:	74 0e                	je     252 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 244:	8b 45 f4             	mov    -0xc(%ebp),%eax
 247:	83 c0 01             	add    $0x1,%eax
 24a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 24d:	7c b3                	jl     202 <gets+0xf>
 24f:	eb 01                	jmp    252 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 251:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 252:	8b 55 f4             	mov    -0xc(%ebp),%edx
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	01 d0                	add    %edx,%eax
 25a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 260:	c9                   	leave  
 261:	c3                   	ret    

00000262 <stat>:

int
stat(char *n, struct stat *st)
{
 262:	55                   	push   %ebp
 263:	89 e5                	mov    %esp,%ebp
 265:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 268:	83 ec 08             	sub    $0x8,%esp
 26b:	6a 00                	push   $0x0
 26d:	ff 75 08             	pushl  0x8(%ebp)
 270:	e8 3c 01 00 00       	call   3b1 <open>
 275:	83 c4 10             	add    $0x10,%esp
 278:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 27b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 27f:	79 07                	jns    288 <stat+0x26>
    return -1;
 281:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 286:	eb 25                	jmp    2ad <stat+0x4b>
  r = fstat(fd, st);
 288:	83 ec 08             	sub    $0x8,%esp
 28b:	ff 75 0c             	pushl  0xc(%ebp)
 28e:	ff 75 f4             	pushl  -0xc(%ebp)
 291:	e8 33 01 00 00       	call   3c9 <fstat>
 296:	83 c4 10             	add    $0x10,%esp
 299:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 29c:	83 ec 0c             	sub    $0xc,%esp
 29f:	ff 75 f4             	pushl  -0xc(%ebp)
 2a2:	e8 f2 00 00 00       	call   399 <close>
 2a7:	83 c4 10             	add    $0x10,%esp
  return r;
 2aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ad:	c9                   	leave  
 2ae:	c3                   	ret    

000002af <atoi>:

int
atoi(const char *s)
{
 2af:	55                   	push   %ebp
 2b0:	89 e5                	mov    %esp,%ebp
 2b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2bc:	eb 25                	jmp    2e3 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2be:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c1:	89 d0                	mov    %edx,%eax
 2c3:	c1 e0 02             	shl    $0x2,%eax
 2c6:	01 d0                	add    %edx,%eax
 2c8:	01 c0                	add    %eax,%eax
 2ca:	89 c1                	mov    %eax,%ecx
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	8d 50 01             	lea    0x1(%eax),%edx
 2d2:	89 55 08             	mov    %edx,0x8(%ebp)
 2d5:	0f b6 00             	movzbl (%eax),%eax
 2d8:	0f be c0             	movsbl %al,%eax
 2db:	01 c8                	add    %ecx,%eax
 2dd:	83 e8 30             	sub    $0x30,%eax
 2e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	3c 2f                	cmp    $0x2f,%al
 2eb:	7e 0a                	jle    2f7 <atoi+0x48>
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
 2f0:	0f b6 00             	movzbl (%eax),%eax
 2f3:	3c 39                	cmp    $0x39,%al
 2f5:	7e c7                	jle    2be <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2fa:	c9                   	leave  
 2fb:	c3                   	ret    

000002fc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 308:	8b 45 0c             	mov    0xc(%ebp),%eax
 30b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 30e:	eb 17                	jmp    327 <memmove+0x2b>
    *dst++ = *src++;
 310:	8b 45 fc             	mov    -0x4(%ebp),%eax
 313:	8d 50 01             	lea    0x1(%eax),%edx
 316:	89 55 fc             	mov    %edx,-0x4(%ebp)
 319:	8b 55 f8             	mov    -0x8(%ebp),%edx
 31c:	8d 4a 01             	lea    0x1(%edx),%ecx
 31f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 322:	0f b6 12             	movzbl (%edx),%edx
 325:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 327:	8b 45 10             	mov    0x10(%ebp),%eax
 32a:	8d 50 ff             	lea    -0x1(%eax),%edx
 32d:	89 55 10             	mov    %edx,0x10(%ebp)
 330:	85 c0                	test   %eax,%eax
 332:	7f dc                	jg     310 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
}
 337:	c9                   	leave  
 338:	c3                   	ret    

00000339 <restorer>:
 339:	83 c4 0c             	add    $0xc,%esp
 33c:	5a                   	pop    %edx
 33d:	59                   	pop    %ecx
 33e:	58                   	pop    %eax
 33f:	c3                   	ret    

00000340 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 346:	83 ec 0c             	sub    $0xc,%esp
 349:	68 39 03 00 00       	push   $0x339
 34e:	e8 ce 00 00 00       	call   421 <signal_restorer>
 353:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 356:	83 ec 08             	sub    $0x8,%esp
 359:	ff 75 0c             	pushl  0xc(%ebp)
 35c:	ff 75 08             	pushl  0x8(%ebp)
 35f:	e8 b5 00 00 00       	call   419 <signal_register>
 364:	83 c4 10             	add    $0x10,%esp
}
 367:	c9                   	leave  
 368:	c3                   	ret    

00000369 <fork>:
 369:	b8 01 00 00 00       	mov    $0x1,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <exit>:
 371:	b8 02 00 00 00       	mov    $0x2,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <wait>:
 379:	b8 03 00 00 00       	mov    $0x3,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <pipe>:
 381:	b8 04 00 00 00       	mov    $0x4,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <read>:
 389:	b8 05 00 00 00       	mov    $0x5,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <write>:
 391:	b8 10 00 00 00       	mov    $0x10,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <close>:
 399:	b8 15 00 00 00       	mov    $0x15,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <kill>:
 3a1:	b8 06 00 00 00       	mov    $0x6,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <exec>:
 3a9:	b8 07 00 00 00       	mov    $0x7,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <open>:
 3b1:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <mknod>:
 3b9:	b8 11 00 00 00       	mov    $0x11,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <unlink>:
 3c1:	b8 12 00 00 00       	mov    $0x12,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <fstat>:
 3c9:	b8 08 00 00 00       	mov    $0x8,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <link>:
 3d1:	b8 13 00 00 00       	mov    $0x13,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <mkdir>:
 3d9:	b8 14 00 00 00       	mov    $0x14,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <chdir>:
 3e1:	b8 09 00 00 00       	mov    $0x9,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <dup>:
 3e9:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <getpid>:
 3f1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <sbrk>:
 3f9:	b8 0c 00 00 00       	mov    $0xc,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <sleep>:
 401:	b8 0d 00 00 00       	mov    $0xd,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <uptime>:
 409:	b8 0e 00 00 00       	mov    $0xe,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <halt>:
 411:	b8 16 00 00 00       	mov    $0x16,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <signal_register>:
 419:	b8 17 00 00 00       	mov    $0x17,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <signal_restorer>:
 421:	b8 18 00 00 00       	mov    $0x18,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 429:	55                   	push   %ebp
 42a:	89 e5                	mov    %esp,%ebp
 42c:	83 ec 18             	sub    $0x18,%esp
 42f:	8b 45 0c             	mov    0xc(%ebp),%eax
 432:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 435:	83 ec 04             	sub    $0x4,%esp
 438:	6a 01                	push   $0x1
 43a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 43d:	50                   	push   %eax
 43e:	ff 75 08             	pushl  0x8(%ebp)
 441:	e8 4b ff ff ff       	call   391 <write>
 446:	83 c4 10             	add    $0x10,%esp
}
 449:	90                   	nop
 44a:	c9                   	leave  
 44b:	c3                   	ret    

0000044c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	53                   	push   %ebx
 450:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 453:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 45a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 45e:	74 17                	je     477 <printint+0x2b>
 460:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 464:	79 11                	jns    477 <printint+0x2b>
    neg = 1;
 466:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 46d:	8b 45 0c             	mov    0xc(%ebp),%eax
 470:	f7 d8                	neg    %eax
 472:	89 45 ec             	mov    %eax,-0x14(%ebp)
 475:	eb 06                	jmp    47d <printint+0x31>
  } else {
    x = xx;
 477:	8b 45 0c             	mov    0xc(%ebp),%eax
 47a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 47d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 484:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 487:	8d 41 01             	lea    0x1(%ecx),%eax
 48a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 48d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 490:	8b 45 ec             	mov    -0x14(%ebp),%eax
 493:	ba 00 00 00 00       	mov    $0x0,%edx
 498:	f7 f3                	div    %ebx
 49a:	89 d0                	mov    %edx,%eax
 49c:	0f b6 80 d4 0b 00 00 	movzbl 0xbd4(%eax),%eax
 4a3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ad:	ba 00 00 00 00       	mov    $0x0,%edx
 4b2:	f7 f3                	div    %ebx
 4b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4bb:	75 c7                	jne    484 <printint+0x38>
  if(neg)
 4bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c1:	74 2d                	je     4f0 <printint+0xa4>
    buf[i++] = '-';
 4c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c6:	8d 50 01             	lea    0x1(%eax),%edx
 4c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4cc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4d1:	eb 1d                	jmp    4f0 <printint+0xa4>
    putc(fd, buf[i]);
 4d3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d9:	01 d0                	add    %edx,%eax
 4db:	0f b6 00             	movzbl (%eax),%eax
 4de:	0f be c0             	movsbl %al,%eax
 4e1:	83 ec 08             	sub    $0x8,%esp
 4e4:	50                   	push   %eax
 4e5:	ff 75 08             	pushl  0x8(%ebp)
 4e8:	e8 3c ff ff ff       	call   429 <putc>
 4ed:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4f0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f8:	79 d9                	jns    4d3 <printint+0x87>
    putc(fd, buf[i]);
}
 4fa:	90                   	nop
 4fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4fe:	c9                   	leave  
 4ff:	c3                   	ret    

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 506:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 50d:	8d 45 0c             	lea    0xc(%ebp),%eax
 510:	83 c0 04             	add    $0x4,%eax
 513:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 516:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 51d:	e9 59 01 00 00       	jmp    67b <printf+0x17b>
    c = fmt[i] & 0xff;
 522:	8b 55 0c             	mov    0xc(%ebp),%edx
 525:	8b 45 f0             	mov    -0x10(%ebp),%eax
 528:	01 d0                	add    %edx,%eax
 52a:	0f b6 00             	movzbl (%eax),%eax
 52d:	0f be c0             	movsbl %al,%eax
 530:	25 ff 00 00 00       	and    $0xff,%eax
 535:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 538:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53c:	75 2c                	jne    56a <printf+0x6a>
      if(c == '%'){
 53e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 542:	75 0c                	jne    550 <printf+0x50>
        state = '%';
 544:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 54b:	e9 27 01 00 00       	jmp    677 <printf+0x177>
      } else {
        putc(fd, c);
 550:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 553:	0f be c0             	movsbl %al,%eax
 556:	83 ec 08             	sub    $0x8,%esp
 559:	50                   	push   %eax
 55a:	ff 75 08             	pushl  0x8(%ebp)
 55d:	e8 c7 fe ff ff       	call   429 <putc>
 562:	83 c4 10             	add    $0x10,%esp
 565:	e9 0d 01 00 00       	jmp    677 <printf+0x177>
      }
    } else if(state == '%'){
 56a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 56e:	0f 85 03 01 00 00    	jne    677 <printf+0x177>
      if(c == 'd'){
 574:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 578:	75 1e                	jne    598 <printf+0x98>
        printint(fd, *ap, 10, 1);
 57a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57d:	8b 00                	mov    (%eax),%eax
 57f:	6a 01                	push   $0x1
 581:	6a 0a                	push   $0xa
 583:	50                   	push   %eax
 584:	ff 75 08             	pushl  0x8(%ebp)
 587:	e8 c0 fe ff ff       	call   44c <printint>
 58c:	83 c4 10             	add    $0x10,%esp
        ap++;
 58f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 593:	e9 d8 00 00 00       	jmp    670 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 598:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 59c:	74 06                	je     5a4 <printf+0xa4>
 59e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5a2:	75 1e                	jne    5c2 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a7:	8b 00                	mov    (%eax),%eax
 5a9:	6a 00                	push   $0x0
 5ab:	6a 10                	push   $0x10
 5ad:	50                   	push   %eax
 5ae:	ff 75 08             	pushl  0x8(%ebp)
 5b1:	e8 96 fe ff ff       	call   44c <printint>
 5b6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bd:	e9 ae 00 00 00       	jmp    670 <printf+0x170>
      } else if(c == 's'){
 5c2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5c6:	75 43                	jne    60b <printf+0x10b>
        s = (char*)*ap;
 5c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cb:	8b 00                	mov    (%eax),%eax
 5cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d8:	75 25                	jne    5ff <printf+0xff>
          s = "(null)";
 5da:	c7 45 f4 42 09 00 00 	movl   $0x942,-0xc(%ebp)
        while(*s != 0){
 5e1:	eb 1c                	jmp    5ff <printf+0xff>
          putc(fd, *s);
 5e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e6:	0f b6 00             	movzbl (%eax),%eax
 5e9:	0f be c0             	movsbl %al,%eax
 5ec:	83 ec 08             	sub    $0x8,%esp
 5ef:	50                   	push   %eax
 5f0:	ff 75 08             	pushl  0x8(%ebp)
 5f3:	e8 31 fe ff ff       	call   429 <putc>
 5f8:	83 c4 10             	add    $0x10,%esp
          s++;
 5fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 602:	0f b6 00             	movzbl (%eax),%eax
 605:	84 c0                	test   %al,%al
 607:	75 da                	jne    5e3 <printf+0xe3>
 609:	eb 65                	jmp    670 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 60b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 60f:	75 1d                	jne    62e <printf+0x12e>
        putc(fd, *ap);
 611:	8b 45 e8             	mov    -0x18(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	0f be c0             	movsbl %al,%eax
 619:	83 ec 08             	sub    $0x8,%esp
 61c:	50                   	push   %eax
 61d:	ff 75 08             	pushl  0x8(%ebp)
 620:	e8 04 fe ff ff       	call   429 <putc>
 625:	83 c4 10             	add    $0x10,%esp
        ap++;
 628:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62c:	eb 42                	jmp    670 <printf+0x170>
      } else if(c == '%'){
 62e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 632:	75 17                	jne    64b <printf+0x14b>
        putc(fd, c);
 634:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 637:	0f be c0             	movsbl %al,%eax
 63a:	83 ec 08             	sub    $0x8,%esp
 63d:	50                   	push   %eax
 63e:	ff 75 08             	pushl  0x8(%ebp)
 641:	e8 e3 fd ff ff       	call   429 <putc>
 646:	83 c4 10             	add    $0x10,%esp
 649:	eb 25                	jmp    670 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 64b:	83 ec 08             	sub    $0x8,%esp
 64e:	6a 25                	push   $0x25
 650:	ff 75 08             	pushl  0x8(%ebp)
 653:	e8 d1 fd ff ff       	call   429 <putc>
 658:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 65b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65e:	0f be c0             	movsbl %al,%eax
 661:	83 ec 08             	sub    $0x8,%esp
 664:	50                   	push   %eax
 665:	ff 75 08             	pushl  0x8(%ebp)
 668:	e8 bc fd ff ff       	call   429 <putc>
 66d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 670:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 677:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 67b:	8b 55 0c             	mov    0xc(%ebp),%edx
 67e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 681:	01 d0                	add    %edx,%eax
 683:	0f b6 00             	movzbl (%eax),%eax
 686:	84 c0                	test   %al,%al
 688:	0f 85 94 fe ff ff    	jne    522 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 68e:	90                   	nop
 68f:	c9                   	leave  
 690:	c3                   	ret    

00000691 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 691:	55                   	push   %ebp
 692:	89 e5                	mov    %esp,%ebp
 694:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 697:	8b 45 08             	mov    0x8(%ebp),%eax
 69a:	83 e8 08             	sub    $0x8,%eax
 69d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a0:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 6a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a8:	eb 24                	jmp    6ce <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	8b 00                	mov    (%eax),%eax
 6af:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b2:	77 12                	ja     6c6 <free+0x35>
 6b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ba:	77 24                	ja     6e0 <free+0x4f>
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 00                	mov    (%eax),%eax
 6c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c4:	77 1a                	ja     6e0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 00                	mov    (%eax),%eax
 6cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d4:	76 d4                	jbe    6aa <free+0x19>
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6de:	76 ca                	jbe    6aa <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	8b 40 04             	mov    0x4(%eax),%eax
 6e6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	01 c2                	add    %eax,%edx
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 00                	mov    (%eax),%eax
 6f7:	39 c2                	cmp    %eax,%edx
 6f9:	75 24                	jne    71f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	8b 50 04             	mov    0x4(%eax),%edx
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	8b 40 04             	mov    0x4(%eax),%eax
 709:	01 c2                	add    %eax,%edx
 70b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	8b 10                	mov    (%eax),%edx
 718:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71b:	89 10                	mov    %edx,(%eax)
 71d:	eb 0a                	jmp    729 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 10                	mov    (%eax),%edx
 724:	8b 45 f8             	mov    -0x8(%ebp),%eax
 727:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 40 04             	mov    0x4(%eax),%eax
 72f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	01 d0                	add    %edx,%eax
 73b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73e:	75 20                	jne    760 <free+0xcf>
    p->s.size += bp->s.size;
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 50 04             	mov    0x4(%eax),%edx
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	8b 40 04             	mov    0x4(%eax),%eax
 74c:	01 c2                	add    %eax,%edx
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 754:	8b 45 f8             	mov    -0x8(%ebp),%eax
 757:	8b 10                	mov    (%eax),%edx
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	89 10                	mov    %edx,(%eax)
 75e:	eb 08                	jmp    768 <free+0xd7>
  } else
    p->s.ptr = bp;
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	8b 55 f8             	mov    -0x8(%ebp),%edx
 766:	89 10                	mov    %edx,(%eax)
  freep = p;
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	a3 f0 0b 00 00       	mov    %eax,0xbf0
}
 770:	90                   	nop
 771:	c9                   	leave  
 772:	c3                   	ret    

00000773 <morecore>:

static Header*
morecore(uint nu)
{
 773:	55                   	push   %ebp
 774:	89 e5                	mov    %esp,%ebp
 776:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 779:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 780:	77 07                	ja     789 <morecore+0x16>
    nu = 4096;
 782:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 789:	8b 45 08             	mov    0x8(%ebp),%eax
 78c:	c1 e0 03             	shl    $0x3,%eax
 78f:	83 ec 0c             	sub    $0xc,%esp
 792:	50                   	push   %eax
 793:	e8 61 fc ff ff       	call   3f9 <sbrk>
 798:	83 c4 10             	add    $0x10,%esp
 79b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 79e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7a2:	75 07                	jne    7ab <morecore+0x38>
    return 0;
 7a4:	b8 00 00 00 00       	mov    $0x0,%eax
 7a9:	eb 26                	jmp    7d1 <morecore+0x5e>
  hp = (Header*)p;
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	8b 55 08             	mov    0x8(%ebp),%edx
 7b7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bd:	83 c0 08             	add    $0x8,%eax
 7c0:	83 ec 0c             	sub    $0xc,%esp
 7c3:	50                   	push   %eax
 7c4:	e8 c8 fe ff ff       	call   691 <free>
 7c9:	83 c4 10             	add    $0x10,%esp
  return freep;
 7cc:	a1 f0 0b 00 00       	mov    0xbf0,%eax
}
 7d1:	c9                   	leave  
 7d2:	c3                   	ret    

000007d3 <malloc>:

void*
malloc(uint nbytes)
{
 7d3:	55                   	push   %ebp
 7d4:	89 e5                	mov    %esp,%ebp
 7d6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
 7dc:	83 c0 07             	add    $0x7,%eax
 7df:	c1 e8 03             	shr    $0x3,%eax
 7e2:	83 c0 01             	add    $0x1,%eax
 7e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7e8:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 7ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f4:	75 23                	jne    819 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7f6:	c7 45 f0 e8 0b 00 00 	movl   $0xbe8,-0x10(%ebp)
 7fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 800:	a3 f0 0b 00 00       	mov    %eax,0xbf0
 805:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 80a:	a3 e8 0b 00 00       	mov    %eax,0xbe8
    base.s.size = 0;
 80f:	c7 05 ec 0b 00 00 00 	movl   $0x0,0xbec
 816:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 819:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 82a:	72 4d                	jb     879 <malloc+0xa6>
      if(p->s.size == nunits)
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	8b 40 04             	mov    0x4(%eax),%eax
 832:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 835:	75 0c                	jne    843 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 837:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83a:	8b 10                	mov    (%eax),%edx
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	89 10                	mov    %edx,(%eax)
 841:	eb 26                	jmp    869 <malloc+0x96>
      else {
        p->s.size -= nunits;
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	8b 40 04             	mov    0x4(%eax),%eax
 849:	2b 45 ec             	sub    -0x14(%ebp),%eax
 84c:	89 c2                	mov    %eax,%edx
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 854:	8b 45 f4             	mov    -0xc(%ebp),%eax
 857:	8b 40 04             	mov    0x4(%eax),%eax
 85a:	c1 e0 03             	shl    $0x3,%eax
 85d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	8b 55 ec             	mov    -0x14(%ebp),%edx
 866:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 869:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86c:	a3 f0 0b 00 00       	mov    %eax,0xbf0
      return (void*)(p + 1);
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	83 c0 08             	add    $0x8,%eax
 877:	eb 3b                	jmp    8b4 <malloc+0xe1>
    }
    if(p == freep)
 879:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 87e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 881:	75 1e                	jne    8a1 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 883:	83 ec 0c             	sub    $0xc,%esp
 886:	ff 75 ec             	pushl  -0x14(%ebp)
 889:	e8 e5 fe ff ff       	call   773 <morecore>
 88e:	83 c4 10             	add    $0x10,%esp
 891:	89 45 f4             	mov    %eax,-0xc(%ebp)
 894:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 898:	75 07                	jne    8a1 <malloc+0xce>
        return 0;
 89a:	b8 00 00 00 00       	mov    $0x0,%eax
 89f:	eb 13                	jmp    8b4 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	8b 00                	mov    (%eax),%eax
 8ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8af:	e9 6d ff ff ff       	jmp    821 <malloc+0x4e>
}
 8b4:	c9                   	leave  
 8b5:	c3                   	ret    
