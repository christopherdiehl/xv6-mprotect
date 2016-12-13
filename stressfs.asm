
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  14:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
  1b:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
  22:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 2e 09 00 00       	push   $0x92e
  30:	6a 01                	push   $0x1
  32:	e8 41 05 00 00       	call   578 <printf>
  37:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 be 01 00 00       	call   20e <memset>
  50:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5a:	eb 0d                	jmp    69 <main+0x69>
    if(fork() > 0)
  5c:	e8 70 03 00 00       	call   3d1 <fork>
  61:	85 c0                	test   %eax,%eax
  63:	7f 0c                	jg     71 <main+0x71>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  69:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  6d:	7e ed                	jle    5c <main+0x5c>
  6f:	eb 01                	jmp    72 <main+0x72>
    if(fork() > 0)
      break;
  71:	90                   	nop

  printf(1, "write %d\n", i);
  72:	83 ec 04             	sub    $0x4,%esp
  75:	ff 75 f4             	pushl  -0xc(%ebp)
  78:	68 41 09 00 00       	push   $0x941
  7d:	6a 01                	push   $0x1
  7f:	e8 f4 04 00 00       	call   578 <printf>
  84:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  87:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  8b:	89 c2                	mov    %eax,%edx
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	01 d0                	add    %edx,%eax
  92:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 02 02 00 00       	push   $0x202
  9d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	e8 73 03 00 00       	call   419 <open>
  a6:	83 c4 10             	add    $0x10,%esp
  a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
  ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  b3:	eb 1e                	jmp    d3 <main+0xd3>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b5:	83 ec 04             	sub    $0x4,%esp
  b8:	68 00 02 00 00       	push   $0x200
  bd:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	ff 75 f0             	pushl  -0x10(%ebp)
  c7:	e8 2d 03 00 00       	call   3f9 <write>
  cc:	83 c4 10             	add    $0x10,%esp

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  d7:	7e dc                	jle    b5 <main+0xb5>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 f0             	pushl  -0x10(%ebp)
  df:	e8 1d 03 00 00       	call   401 <close>
  e4:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e7:	83 ec 08             	sub    $0x8,%esp
  ea:	68 4b 09 00 00       	push   $0x94b
  ef:	6a 01                	push   $0x1
  f1:	e8 82 04 00 00       	call   578 <printf>
  f6:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	6a 00                	push   $0x0
  fe:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 101:	50                   	push   %eax
 102:	e8 12 03 00 00       	call   419 <open>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
 10d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 114:	eb 1e                	jmp    134 <main+0x134>
    read(fd, data, sizeof(data));
 116:	83 ec 04             	sub    $0x4,%esp
 119:	68 00 02 00 00       	push   $0x200
 11e:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
 124:	50                   	push   %eax
 125:	ff 75 f0             	pushl  -0x10(%ebp)
 128:	e8 c4 02 00 00       	call   3f1 <read>
 12d:	83 c4 10             	add    $0x10,%esp
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 130:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 134:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 138:	7e dc                	jle    116 <main+0x116>
    read(fd, data, sizeof(data));
  close(fd);
 13a:	83 ec 0c             	sub    $0xc,%esp
 13d:	ff 75 f0             	pushl  -0x10(%ebp)
 140:	e8 bc 02 00 00       	call   401 <close>
 145:	83 c4 10             	add    $0x10,%esp

  wait();
 148:	e8 94 02 00 00       	call   3e1 <wait>
  
  exit();
 14d:	e8 87 02 00 00       	call   3d9 <exit>

00000152 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	57                   	push   %edi
 156:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 157:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15a:	8b 55 10             	mov    0x10(%ebp),%edx
 15d:	8b 45 0c             	mov    0xc(%ebp),%eax
 160:	89 cb                	mov    %ecx,%ebx
 162:	89 df                	mov    %ebx,%edi
 164:	89 d1                	mov    %edx,%ecx
 166:	fc                   	cld    
 167:	f3 aa                	rep stos %al,%es:(%edi)
 169:	89 ca                	mov    %ecx,%edx
 16b:	89 fb                	mov    %edi,%ebx
 16d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 170:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 173:	90                   	nop
 174:	5b                   	pop    %ebx
 175:	5f                   	pop    %edi
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    

00000178 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 184:	90                   	nop
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	8d 50 01             	lea    0x1(%eax),%edx
 18b:	89 55 08             	mov    %edx,0x8(%ebp)
 18e:	8b 55 0c             	mov    0xc(%ebp),%edx
 191:	8d 4a 01             	lea    0x1(%edx),%ecx
 194:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 197:	0f b6 12             	movzbl (%edx),%edx
 19a:	88 10                	mov    %dl,(%eax)
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	84 c0                	test   %al,%al
 1a1:	75 e2                	jne    185 <strcpy+0xd>
    ;
  return os;
 1a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ab:	eb 08                	jmp    1b5 <strcmp+0xd>
    p++, q++;
 1ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	0f b6 00             	movzbl (%eax),%eax
 1bb:	84 c0                	test   %al,%al
 1bd:	74 10                	je     1cf <strcmp+0x27>
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	0f b6 10             	movzbl (%eax),%edx
 1c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	38 c2                	cmp    %al,%dl
 1cd:	74 de                	je     1ad <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	0f b6 d0             	movzbl %al,%edx
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	0f b6 c0             	movzbl %al,%eax
 1e1:	29 c2                	sub    %eax,%edx
 1e3:	89 d0                	mov    %edx,%eax
}
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    

000001e7 <strlen>:

uint
strlen(char *s)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1f4:	eb 04                	jmp    1fa <strlen+0x13>
 1f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	01 d0                	add    %edx,%eax
 202:	0f b6 00             	movzbl (%eax),%eax
 205:	84 c0                	test   %al,%al
 207:	75 ed                	jne    1f6 <strlen+0xf>
    ;
  return n;
 209:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20c:	c9                   	leave  
 20d:	c3                   	ret    

0000020e <memset>:

void*
memset(void *dst, int c, uint n)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 211:	8b 45 10             	mov    0x10(%ebp),%eax
 214:	50                   	push   %eax
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 08             	pushl  0x8(%ebp)
 21b:	e8 32 ff ff ff       	call   152 <stosb>
 220:	83 c4 0c             	add    $0xc,%esp
  return dst;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <strchr>:

char*
strchr(const char *s, char c)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 234:	eb 14                	jmp    24a <strchr+0x22>
    if(*s == c)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	0f b6 00             	movzbl (%eax),%eax
 23c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 23f:	75 05                	jne    246 <strchr+0x1e>
      return (char*)s;
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	eb 13                	jmp    259 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 e2                	jne    236 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <gets>:

char*
gets(char *buf, int max)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 268:	eb 42                	jmp    2ac <gets+0x51>
    cc = read(0, &c, 1);
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	6a 01                	push   $0x1
 26f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 272:	50                   	push   %eax
 273:	6a 00                	push   $0x0
 275:	e8 77 01 00 00       	call   3f1 <read>
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 284:	7e 33                	jle    2b9 <gets+0x5e>
      break;
    buf[i++] = c;
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	8d 50 01             	lea    0x1(%eax),%edx
 28c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 c2                	add    %eax,%edx
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a0:	3c 0a                	cmp    $0xa,%al
 2a2:	74 16                	je     2ba <gets+0x5f>
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	3c 0d                	cmp    $0xd,%al
 2aa:	74 0e                	je     2ba <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2af:	83 c0 01             	add    $0x1,%eax
 2b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b5:	7c b3                	jl     26a <gets+0xf>
 2b7:	eb 01                	jmp    2ba <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2b9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	01 d0                	add    %edx,%eax
 2c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <stat>:

int
stat(char *n, struct stat *st)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	83 ec 08             	sub    $0x8,%esp
 2d3:	6a 00                	push   $0x0
 2d5:	ff 75 08             	pushl  0x8(%ebp)
 2d8:	e8 3c 01 00 00       	call   419 <open>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e7:	79 07                	jns    2f0 <stat+0x26>
    return -1;
 2e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ee:	eb 25                	jmp    315 <stat+0x4b>
  r = fstat(fd, st);
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	ff 75 0c             	pushl  0xc(%ebp)
 2f6:	ff 75 f4             	pushl  -0xc(%ebp)
 2f9:	e8 33 01 00 00       	call   431 <fstat>
 2fe:	83 c4 10             	add    $0x10,%esp
 301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 304:	83 ec 0c             	sub    $0xc,%esp
 307:	ff 75 f4             	pushl  -0xc(%ebp)
 30a:	e8 f2 00 00 00       	call   401 <close>
 30f:	83 c4 10             	add    $0x10,%esp
  return r;
 312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 315:	c9                   	leave  
 316:	c3                   	ret    

00000317 <atoi>:

int
atoi(const char *s)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 324:	eb 25                	jmp    34b <atoi+0x34>
    n = n*10 + *s++ - '0';
 326:	8b 55 fc             	mov    -0x4(%ebp),%edx
 329:	89 d0                	mov    %edx,%eax
 32b:	c1 e0 02             	shl    $0x2,%eax
 32e:	01 d0                	add    %edx,%eax
 330:	01 c0                	add    %eax,%eax
 332:	89 c1                	mov    %eax,%ecx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8d 50 01             	lea    0x1(%eax),%edx
 33a:	89 55 08             	mov    %edx,0x8(%ebp)
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	0f be c0             	movsbl %al,%eax
 343:	01 c8                	add    %ecx,%eax
 345:	83 e8 30             	sub    $0x30,%eax
 348:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	3c 2f                	cmp    $0x2f,%al
 353:	7e 0a                	jle    35f <atoi+0x48>
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	0f b6 00             	movzbl (%eax),%eax
 35b:	3c 39                	cmp    $0x39,%al
 35d:	7e c7                	jle    326 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 35f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 362:	c9                   	leave  
 363:	c3                   	ret    

00000364 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 376:	eb 17                	jmp    38f <memmove+0x2b>
    *dst++ = *src++;
 378:	8b 45 fc             	mov    -0x4(%ebp),%eax
 37b:	8d 50 01             	lea    0x1(%eax),%edx
 37e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 381:	8b 55 f8             	mov    -0x8(%ebp),%edx
 384:	8d 4a 01             	lea    0x1(%edx),%ecx
 387:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 38a:	0f b6 12             	movzbl (%edx),%edx
 38d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38f:	8b 45 10             	mov    0x10(%ebp),%eax
 392:	8d 50 ff             	lea    -0x1(%eax),%edx
 395:	89 55 10             	mov    %edx,0x10(%ebp)
 398:	85 c0                	test   %eax,%eax
 39a:	7f dc                	jg     378 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39f:	c9                   	leave  
 3a0:	c3                   	ret    

000003a1 <restorer>:
 3a1:	83 c4 0c             	add    $0xc,%esp
 3a4:	5a                   	pop    %edx
 3a5:	59                   	pop    %ecx
 3a6:	58                   	pop    %eax
 3a7:	c3                   	ret    

000003a8 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 3ae:	83 ec 0c             	sub    $0xc,%esp
 3b1:	68 a1 03 00 00       	push   $0x3a1
 3b6:	e8 ce 00 00 00       	call   489 <signal_restorer>
 3bb:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 3be:	83 ec 08             	sub    $0x8,%esp
 3c1:	ff 75 0c             	pushl  0xc(%ebp)
 3c4:	ff 75 08             	pushl  0x8(%ebp)
 3c7:	e8 b5 00 00 00       	call   481 <signal_register>
 3cc:	83 c4 10             	add    $0x10,%esp
}
 3cf:	c9                   	leave  
 3d0:	c3                   	ret    

000003d1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3d1:	b8 01 00 00 00       	mov    $0x1,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <exit>:
SYSCALL(exit)
 3d9:	b8 02 00 00 00       	mov    $0x2,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <wait>:
SYSCALL(wait)
 3e1:	b8 03 00 00 00       	mov    $0x3,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <pipe>:
SYSCALL(pipe)
 3e9:	b8 04 00 00 00       	mov    $0x4,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <read>:
SYSCALL(read)
 3f1:	b8 05 00 00 00       	mov    $0x5,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <write>:
SYSCALL(write)
 3f9:	b8 10 00 00 00       	mov    $0x10,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <close>:
SYSCALL(close)
 401:	b8 15 00 00 00       	mov    $0x15,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <kill>:
SYSCALL(kill)
 409:	b8 06 00 00 00       	mov    $0x6,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <exec>:
SYSCALL(exec)
 411:	b8 07 00 00 00       	mov    $0x7,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <open>:
SYSCALL(open)
 419:	b8 0f 00 00 00       	mov    $0xf,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <mknod>:
SYSCALL(mknod)
 421:	b8 11 00 00 00       	mov    $0x11,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <unlink>:
SYSCALL(unlink)
 429:	b8 12 00 00 00       	mov    $0x12,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <fstat>:
SYSCALL(fstat)
 431:	b8 08 00 00 00       	mov    $0x8,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <link>:
SYSCALL(link)
 439:	b8 13 00 00 00       	mov    $0x13,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <mkdir>:
SYSCALL(mkdir)
 441:	b8 14 00 00 00       	mov    $0x14,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <chdir>:
SYSCALL(chdir)
 449:	b8 09 00 00 00       	mov    $0x9,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <dup>:
SYSCALL(dup)
 451:	b8 0a 00 00 00       	mov    $0xa,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <getpid>:
SYSCALL(getpid)
 459:	b8 0b 00 00 00       	mov    $0xb,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <sbrk>:
SYSCALL(sbrk)
 461:	b8 0c 00 00 00       	mov    $0xc,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <sleep>:
SYSCALL(sleep)
 469:	b8 0d 00 00 00       	mov    $0xd,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <uptime>:
SYSCALL(uptime)
 471:	b8 0e 00 00 00       	mov    $0xe,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <halt>:
SYSCALL(halt)
 479:	b8 16 00 00 00       	mov    $0x16,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <signal_register>:
SYSCALL(signal_register)
 481:	b8 17 00 00 00       	mov    $0x17,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <signal_restorer>:
SYSCALL(signal_restorer)
 489:	b8 18 00 00 00       	mov    $0x18,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <mprotect>:
SYSCALL(mprotect)
 491:	b8 19 00 00 00       	mov    $0x19,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <cowfork>:
SYSCALL(cowfork)
 499:	b8 1a 00 00 00       	mov    $0x1a,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a1:	55                   	push   %ebp
 4a2:	89 e5                	mov    %esp,%ebp
 4a4:	83 ec 18             	sub    $0x18,%esp
 4a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4aa:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ad:	83 ec 04             	sub    $0x4,%esp
 4b0:	6a 01                	push   $0x1
 4b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b5:	50                   	push   %eax
 4b6:	ff 75 08             	pushl  0x8(%ebp)
 4b9:	e8 3b ff ff ff       	call   3f9 <write>
 4be:	83 c4 10             	add    $0x10,%esp
}
 4c1:	90                   	nop
 4c2:	c9                   	leave  
 4c3:	c3                   	ret    

000004c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	53                   	push   %ebx
 4c8:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4d2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4d6:	74 17                	je     4ef <printint+0x2b>
 4d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4dc:	79 11                	jns    4ef <printint+0x2b>
    neg = 1;
 4de:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e8:	f7 d8                	neg    %eax
 4ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ed:	eb 06                	jmp    4f5 <printint+0x31>
  } else {
    x = xx;
 4ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4fc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4ff:	8d 41 01             	lea    0x1(%ecx),%eax
 502:	89 45 f4             	mov    %eax,-0xc(%ebp)
 505:	8b 5d 10             	mov    0x10(%ebp),%ebx
 508:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50b:	ba 00 00 00 00       	mov    $0x0,%edx
 510:	f7 f3                	div    %ebx
 512:	89 d0                	mov    %edx,%eax
 514:	0f b6 80 c0 0b 00 00 	movzbl 0xbc0(%eax),%eax
 51b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 51f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 522:	8b 45 ec             	mov    -0x14(%ebp),%eax
 525:	ba 00 00 00 00       	mov    $0x0,%edx
 52a:	f7 f3                	div    %ebx
 52c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 52f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 533:	75 c7                	jne    4fc <printint+0x38>
  if(neg)
 535:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 539:	74 2d                	je     568 <printint+0xa4>
    buf[i++] = '-';
 53b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53e:	8d 50 01             	lea    0x1(%eax),%edx
 541:	89 55 f4             	mov    %edx,-0xc(%ebp)
 544:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 549:	eb 1d                	jmp    568 <printint+0xa4>
    putc(fd, buf[i]);
 54b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 551:	01 d0                	add    %edx,%eax
 553:	0f b6 00             	movzbl (%eax),%eax
 556:	0f be c0             	movsbl %al,%eax
 559:	83 ec 08             	sub    $0x8,%esp
 55c:	50                   	push   %eax
 55d:	ff 75 08             	pushl  0x8(%ebp)
 560:	e8 3c ff ff ff       	call   4a1 <putc>
 565:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 568:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 56c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 570:	79 d9                	jns    54b <printint+0x87>
    putc(fd, buf[i]);
}
 572:	90                   	nop
 573:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 576:	c9                   	leave  
 577:	c3                   	ret    

00000578 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 57e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 585:	8d 45 0c             	lea    0xc(%ebp),%eax
 588:	83 c0 04             	add    $0x4,%eax
 58b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 58e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 595:	e9 59 01 00 00       	jmp    6f3 <printf+0x17b>
    c = fmt[i] & 0xff;
 59a:	8b 55 0c             	mov    0xc(%ebp),%edx
 59d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a0:	01 d0                	add    %edx,%eax
 5a2:	0f b6 00             	movzbl (%eax),%eax
 5a5:	0f be c0             	movsbl %al,%eax
 5a8:	25 ff 00 00 00       	and    $0xff,%eax
 5ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b4:	75 2c                	jne    5e2 <printf+0x6a>
      if(c == '%'){
 5b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ba:	75 0c                	jne    5c8 <printf+0x50>
        state = '%';
 5bc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5c3:	e9 27 01 00 00       	jmp    6ef <printf+0x177>
      } else {
        putc(fd, c);
 5c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cb:	0f be c0             	movsbl %al,%eax
 5ce:	83 ec 08             	sub    $0x8,%esp
 5d1:	50                   	push   %eax
 5d2:	ff 75 08             	pushl  0x8(%ebp)
 5d5:	e8 c7 fe ff ff       	call   4a1 <putc>
 5da:	83 c4 10             	add    $0x10,%esp
 5dd:	e9 0d 01 00 00       	jmp    6ef <printf+0x177>
      }
    } else if(state == '%'){
 5e2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5e6:	0f 85 03 01 00 00    	jne    6ef <printf+0x177>
      if(c == 'd'){
 5ec:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f0:	75 1e                	jne    610 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f5:	8b 00                	mov    (%eax),%eax
 5f7:	6a 01                	push   $0x1
 5f9:	6a 0a                	push   $0xa
 5fb:	50                   	push   %eax
 5fc:	ff 75 08             	pushl  0x8(%ebp)
 5ff:	e8 c0 fe ff ff       	call   4c4 <printint>
 604:	83 c4 10             	add    $0x10,%esp
        ap++;
 607:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60b:	e9 d8 00 00 00       	jmp    6e8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 610:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 614:	74 06                	je     61c <printf+0xa4>
 616:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 61a:	75 1e                	jne    63a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 61c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	6a 00                	push   $0x0
 623:	6a 10                	push   $0x10
 625:	50                   	push   %eax
 626:	ff 75 08             	pushl  0x8(%ebp)
 629:	e8 96 fe ff ff       	call   4c4 <printint>
 62e:	83 c4 10             	add    $0x10,%esp
        ap++;
 631:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 635:	e9 ae 00 00 00       	jmp    6e8 <printf+0x170>
      } else if(c == 's'){
 63a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 63e:	75 43                	jne    683 <printf+0x10b>
        s = (char*)*ap;
 640:	8b 45 e8             	mov    -0x18(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 648:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 64c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 650:	75 25                	jne    677 <printf+0xff>
          s = "(null)";
 652:	c7 45 f4 51 09 00 00 	movl   $0x951,-0xc(%ebp)
        while(*s != 0){
 659:	eb 1c                	jmp    677 <printf+0xff>
          putc(fd, *s);
 65b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65e:	0f b6 00             	movzbl (%eax),%eax
 661:	0f be c0             	movsbl %al,%eax
 664:	83 ec 08             	sub    $0x8,%esp
 667:	50                   	push   %eax
 668:	ff 75 08             	pushl  0x8(%ebp)
 66b:	e8 31 fe ff ff       	call   4a1 <putc>
 670:	83 c4 10             	add    $0x10,%esp
          s++;
 673:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 677:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67a:	0f b6 00             	movzbl (%eax),%eax
 67d:	84 c0                	test   %al,%al
 67f:	75 da                	jne    65b <printf+0xe3>
 681:	eb 65                	jmp    6e8 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 683:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 687:	75 1d                	jne    6a6 <printf+0x12e>
        putc(fd, *ap);
 689:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	0f be c0             	movsbl %al,%eax
 691:	83 ec 08             	sub    $0x8,%esp
 694:	50                   	push   %eax
 695:	ff 75 08             	pushl  0x8(%ebp)
 698:	e8 04 fe ff ff       	call   4a1 <putc>
 69d:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a4:	eb 42                	jmp    6e8 <printf+0x170>
      } else if(c == '%'){
 6a6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6aa:	75 17                	jne    6c3 <printf+0x14b>
        putc(fd, c);
 6ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6af:	0f be c0             	movsbl %al,%eax
 6b2:	83 ec 08             	sub    $0x8,%esp
 6b5:	50                   	push   %eax
 6b6:	ff 75 08             	pushl  0x8(%ebp)
 6b9:	e8 e3 fd ff ff       	call   4a1 <putc>
 6be:	83 c4 10             	add    $0x10,%esp
 6c1:	eb 25                	jmp    6e8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c3:	83 ec 08             	sub    $0x8,%esp
 6c6:	6a 25                	push   $0x25
 6c8:	ff 75 08             	pushl  0x8(%ebp)
 6cb:	e8 d1 fd ff ff       	call   4a1 <putc>
 6d0:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d6:	0f be c0             	movsbl %al,%eax
 6d9:	83 ec 08             	sub    $0x8,%esp
 6dc:	50                   	push   %eax
 6dd:	ff 75 08             	pushl  0x8(%ebp)
 6e0:	e8 bc fd ff ff       	call   4a1 <putc>
 6e5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ef:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6f3:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f9:	01 d0                	add    %edx,%eax
 6fb:	0f b6 00             	movzbl (%eax),%eax
 6fe:	84 c0                	test   %al,%al
 700:	0f 85 94 fe ff ff    	jne    59a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 706:	90                   	nop
 707:	c9                   	leave  
 708:	c3                   	ret    

00000709 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	83 e8 08             	sub    $0x8,%eax
 715:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 718:	a1 dc 0b 00 00       	mov    0xbdc,%eax
 71d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 720:	eb 24                	jmp    746 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	8b 00                	mov    (%eax),%eax
 727:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72a:	77 12                	ja     73e <free+0x35>
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 732:	77 24                	ja     758 <free+0x4f>
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73c:	77 1a                	ja     758 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 00                	mov    (%eax),%eax
 743:	89 45 fc             	mov    %eax,-0x4(%ebp)
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74c:	76 d4                	jbe    722 <free+0x19>
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	8b 00                	mov    (%eax),%eax
 753:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 756:	76 ca                	jbe    722 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 758:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75b:	8b 40 04             	mov    0x4(%eax),%eax
 75e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	01 c2                	add    %eax,%edx
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	8b 00                	mov    (%eax),%eax
 76f:	39 c2                	cmp    %eax,%edx
 771:	75 24                	jne    797 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	8b 50 04             	mov    0x4(%eax),%edx
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	8b 40 04             	mov    0x4(%eax),%eax
 781:	01 c2                	add    %eax,%edx
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 00                	mov    (%eax),%eax
 78e:	8b 10                	mov    (%eax),%edx
 790:	8b 45 f8             	mov    -0x8(%ebp),%eax
 793:	89 10                	mov    %edx,(%eax)
 795:	eb 0a                	jmp    7a1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	8b 10                	mov    (%eax),%edx
 79c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	01 d0                	add    %edx,%eax
 7b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b6:	75 20                	jne    7d8 <free+0xcf>
    p->s.size += bp->s.size;
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 50 04             	mov    0x4(%eax),%edx
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	01 c2                	add    %eax,%edx
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cf:	8b 10                	mov    (%eax),%edx
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	89 10                	mov    %edx,(%eax)
 7d6:	eb 08                	jmp    7e0 <free+0xd7>
  } else
    p->s.ptr = bp;
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7de:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	a3 dc 0b 00 00       	mov    %eax,0xbdc
}
 7e8:	90                   	nop
 7e9:	c9                   	leave  
 7ea:	c3                   	ret    

000007eb <morecore>:

static Header*
morecore(uint nu)
{
 7eb:	55                   	push   %ebp
 7ec:	89 e5                	mov    %esp,%ebp
 7ee:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7f1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7f8:	77 07                	ja     801 <morecore+0x16>
    nu = 4096;
 7fa:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 801:	8b 45 08             	mov    0x8(%ebp),%eax
 804:	c1 e0 03             	shl    $0x3,%eax
 807:	83 ec 0c             	sub    $0xc,%esp
 80a:	50                   	push   %eax
 80b:	e8 51 fc ff ff       	call   461 <sbrk>
 810:	83 c4 10             	add    $0x10,%esp
 813:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 816:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 81a:	75 07                	jne    823 <morecore+0x38>
    return 0;
 81c:	b8 00 00 00 00       	mov    $0x0,%eax
 821:	eb 26                	jmp    849 <morecore+0x5e>
  hp = (Header*)p;
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 829:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82c:	8b 55 08             	mov    0x8(%ebp),%edx
 82f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 832:	8b 45 f0             	mov    -0x10(%ebp),%eax
 835:	83 c0 08             	add    $0x8,%eax
 838:	83 ec 0c             	sub    $0xc,%esp
 83b:	50                   	push   %eax
 83c:	e8 c8 fe ff ff       	call   709 <free>
 841:	83 c4 10             	add    $0x10,%esp
  return freep;
 844:	a1 dc 0b 00 00       	mov    0xbdc,%eax
}
 849:	c9                   	leave  
 84a:	c3                   	ret    

0000084b <malloc>:

void*
malloc(uint nbytes)
{
 84b:	55                   	push   %ebp
 84c:	89 e5                	mov    %esp,%ebp
 84e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 851:	8b 45 08             	mov    0x8(%ebp),%eax
 854:	83 c0 07             	add    $0x7,%eax
 857:	c1 e8 03             	shr    $0x3,%eax
 85a:	83 c0 01             	add    $0x1,%eax
 85d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 860:	a1 dc 0b 00 00       	mov    0xbdc,%eax
 865:	89 45 f0             	mov    %eax,-0x10(%ebp)
 868:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 86c:	75 23                	jne    891 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 86e:	c7 45 f0 d4 0b 00 00 	movl   $0xbd4,-0x10(%ebp)
 875:	8b 45 f0             	mov    -0x10(%ebp),%eax
 878:	a3 dc 0b 00 00       	mov    %eax,0xbdc
 87d:	a1 dc 0b 00 00       	mov    0xbdc,%eax
 882:	a3 d4 0b 00 00       	mov    %eax,0xbd4
    base.s.size = 0;
 887:	c7 05 d8 0b 00 00 00 	movl   $0x0,0xbd8
 88e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 891:	8b 45 f0             	mov    -0x10(%ebp),%eax
 894:	8b 00                	mov    (%eax),%eax
 896:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	8b 40 04             	mov    0x4(%eax),%eax
 89f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a2:	72 4d                	jb     8f1 <malloc+0xa6>
      if(p->s.size == nunits)
 8a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a7:	8b 40 04             	mov    0x4(%eax),%eax
 8aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ad:	75 0c                	jne    8bb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b2:	8b 10                	mov    (%eax),%edx
 8b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b7:	89 10                	mov    %edx,(%eax)
 8b9:	eb 26                	jmp    8e1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	8b 40 04             	mov    0x4(%eax),%eax
 8c1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8c4:	89 c2                	mov    %eax,%edx
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cf:	8b 40 04             	mov    0x4(%eax),%eax
 8d2:	c1 e0 03             	shl    $0x3,%eax
 8d5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8de:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e4:	a3 dc 0b 00 00       	mov    %eax,0xbdc
      return (void*)(p + 1);
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	83 c0 08             	add    $0x8,%eax
 8ef:	eb 3b                	jmp    92c <malloc+0xe1>
    }
    if(p == freep)
 8f1:	a1 dc 0b 00 00       	mov    0xbdc,%eax
 8f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f9:	75 1e                	jne    919 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8fb:	83 ec 0c             	sub    $0xc,%esp
 8fe:	ff 75 ec             	pushl  -0x14(%ebp)
 901:	e8 e5 fe ff ff       	call   7eb <morecore>
 906:	83 c4 10             	add    $0x10,%esp
 909:	89 45 f4             	mov    %eax,-0xc(%ebp)
 90c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 910:	75 07                	jne    919 <malloc+0xce>
        return 0;
 912:	b8 00 00 00 00       	mov    $0x0,%eax
 917:	eb 13                	jmp    92c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 919:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	8b 00                	mov    (%eax),%eax
 924:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 927:	e9 6d ff ff ff       	jmp    899 <malloc+0x4e>
}
 92c:	c9                   	leave  
 92d:	c3                   	ret    
