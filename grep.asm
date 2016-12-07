
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 ab 00 00 00       	jmp    bd <grep+0xbd>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 4a                	jmp    6b <grep+0x6b>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 f0             	pushl  -0x10(%ebp)
  2d:	ff 75 08             	pushl  0x8(%ebp)
  30:	e8 9a 01 00 00       	call   1cf <match>
  35:	83 c4 10             	add    $0x10,%esp
  38:	85 c0                	test   %eax,%eax
  3a:	74 26                	je     62 <grep+0x62>
        *q = '\n';
  3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  3f:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  45:	83 c0 01             	add    $0x1,%eax
  48:	89 c2                	mov    %eax,%edx
  4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4d:	29 c2                	sub    %eax,%edx
  4f:	89 d0                	mov    %edx,%eax
  51:	83 ec 04             	sub    $0x4,%esp
  54:	50                   	push   %eax
  55:	ff 75 f0             	pushl  -0x10(%ebp)
  58:	6a 01                	push   $0x1
  5a:	e8 73 05 00 00       	call   5d2 <write>
  5f:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  65:	83 c0 01             	add    $0x1,%eax
  68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  6b:	83 ec 08             	sub    $0x8,%esp
  6e:	6a 0a                	push   $0xa
  70:	ff 75 f0             	pushl  -0x10(%ebp)
  73:	e8 89 03 00 00       	call   401 <strchr>
  78:	83 c4 10             	add    $0x10,%esp
  7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  7e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  82:	75 9d                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  84:	81 7d f0 60 0e 00 00 	cmpl   $0xe60,-0x10(%ebp)
  8b:	75 07                	jne    94 <grep+0x94>
      m = 0;
  8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  98:	7e 23                	jle    bd <grep+0xbd>
      m -= p - buf;
  9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  9d:	ba 60 0e 00 00       	mov    $0xe60,%edx
  a2:	29 d0                	sub    %edx,%eax
  a4:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  a7:	83 ec 04             	sub    $0x4,%esp
  aa:	ff 75 f4             	pushl  -0xc(%ebp)
  ad:	ff 75 f0             	pushl  -0x10(%ebp)
  b0:	68 60 0e 00 00       	push   $0xe60
  b5:	e8 83 04 00 00       	call   53d <memmove>
  ba:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c0:	ba 00 04 00 00       	mov    $0x400,%edx
  c5:	29 c2                	sub    %eax,%edx
  c7:	89 d0                	mov    %edx,%eax
  c9:	89 c2                	mov    %eax,%edx
  cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ce:	05 60 0e 00 00       	add    $0xe60,%eax
  d3:	83 ec 04             	sub    $0x4,%esp
  d6:	52                   	push   %edx
  d7:	50                   	push   %eax
  d8:	ff 75 0c             	pushl  0xc(%ebp)
  db:	e8 ea 04 00 00       	call   5ca <read>
  e0:	83 c4 10             	add    $0x10,%esp
  e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  ea:	0f 8f 22 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
  f0:	90                   	nop
  f1:	c9                   	leave  
  f2:	c3                   	ret    

000000f3 <main>:

int
main(int argc, char *argv[])
{
  f3:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f7:	83 e4 f0             	and    $0xfffffff0,%esp
  fa:	ff 71 fc             	pushl  -0x4(%ecx)
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	53                   	push   %ebx
 101:	51                   	push   %ecx
 102:	83 ec 10             	sub    $0x10,%esp
 105:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 107:	83 3b 01             	cmpl   $0x1,(%ebx)
 10a:	7f 17                	jg     123 <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 10c:	83 ec 08             	sub    $0x8,%esp
 10f:	68 00 0b 00 00       	push   $0xb00
 114:	6a 02                	push   $0x2
 116:	e8 2e 06 00 00       	call   749 <printf>
 11b:	83 c4 10             	add    $0x10,%esp
    exit();
 11e:	e8 8f 04 00 00       	call   5b2 <exit>
  }
  pattern = argv[1];
 123:	8b 43 04             	mov    0x4(%ebx),%eax
 126:	8b 40 04             	mov    0x4(%eax),%eax
 129:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 12c:	83 3b 02             	cmpl   $0x2,(%ebx)
 12f:	7f 15                	jg     146 <main+0x53>
    grep(pattern, 0);
 131:	83 ec 08             	sub    $0x8,%esp
 134:	6a 00                	push   $0x0
 136:	ff 75 f0             	pushl  -0x10(%ebp)
 139:	e8 c2 fe ff ff       	call   0 <grep>
 13e:	83 c4 10             	add    $0x10,%esp
    exit();
 141:	e8 6c 04 00 00       	call   5b2 <exit>
  }

  for(i = 2; i < argc; i++){
 146:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 14d:	eb 74                	jmp    1c3 <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 14f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 152:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 159:	8b 43 04             	mov    0x4(%ebx),%eax
 15c:	01 d0                	add    %edx,%eax
 15e:	8b 00                	mov    (%eax),%eax
 160:	83 ec 08             	sub    $0x8,%esp
 163:	6a 00                	push   $0x0
 165:	50                   	push   %eax
 166:	e8 87 04 00 00       	call   5f2 <open>
 16b:	83 c4 10             	add    $0x10,%esp
 16e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 171:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 175:	79 29                	jns    1a0 <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 177:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 181:	8b 43 04             	mov    0x4(%ebx),%eax
 184:	01 d0                	add    %edx,%eax
 186:	8b 00                	mov    (%eax),%eax
 188:	83 ec 04             	sub    $0x4,%esp
 18b:	50                   	push   %eax
 18c:	68 20 0b 00 00       	push   $0xb20
 191:	6a 01                	push   $0x1
 193:	e8 b1 05 00 00       	call   749 <printf>
 198:	83 c4 10             	add    $0x10,%esp
      exit();
 19b:	e8 12 04 00 00       	call   5b2 <exit>
    }
    grep(pattern, fd);
 1a0:	83 ec 08             	sub    $0x8,%esp
 1a3:	ff 75 ec             	pushl  -0x14(%ebp)
 1a6:	ff 75 f0             	pushl  -0x10(%ebp)
 1a9:	e8 52 fe ff ff       	call   0 <grep>
 1ae:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1b1:	83 ec 0c             	sub    $0xc,%esp
 1b4:	ff 75 ec             	pushl  -0x14(%ebp)
 1b7:	e8 1e 04 00 00       	call   5da <close>
 1bc:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c6:	3b 03                	cmp    (%ebx),%eax
 1c8:	7c 85                	jl     14f <main+0x5c>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1ca:	e8 e3 03 00 00       	call   5b2 <exit>

000001cf <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1d5:	8b 45 08             	mov    0x8(%ebp),%eax
 1d8:	0f b6 00             	movzbl (%eax),%eax
 1db:	3c 5e                	cmp    $0x5e,%al
 1dd:	75 17                	jne    1f6 <match+0x27>
    return matchhere(re+1, text);
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	83 c0 01             	add    $0x1,%eax
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	ff 75 0c             	pushl  0xc(%ebp)
 1eb:	50                   	push   %eax
 1ec:	e8 38 00 00 00       	call   229 <matchhere>
 1f1:	83 c4 10             	add    $0x10,%esp
 1f4:	eb 31                	jmp    227 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 1f6:	83 ec 08             	sub    $0x8,%esp
 1f9:	ff 75 0c             	pushl  0xc(%ebp)
 1fc:	ff 75 08             	pushl  0x8(%ebp)
 1ff:	e8 25 00 00 00       	call   229 <matchhere>
 204:	83 c4 10             	add    $0x10,%esp
 207:	85 c0                	test   %eax,%eax
 209:	74 07                	je     212 <match+0x43>
      return 1;
 20b:	b8 01 00 00 00       	mov    $0x1,%eax
 210:	eb 15                	jmp    227 <match+0x58>
  }while(*text++ != '\0');
 212:	8b 45 0c             	mov    0xc(%ebp),%eax
 215:	8d 50 01             	lea    0x1(%eax),%edx
 218:	89 55 0c             	mov    %edx,0xc(%ebp)
 21b:	0f b6 00             	movzbl (%eax),%eax
 21e:	84 c0                	test   %al,%al
 220:	75 d4                	jne    1f6 <match+0x27>
  return 0;
 222:	b8 00 00 00 00       	mov    $0x0,%eax
}
 227:	c9                   	leave  
 228:	c3                   	ret    

00000229 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	84 c0                	test   %al,%al
 237:	75 0a                	jne    243 <matchhere+0x1a>
    return 1;
 239:	b8 01 00 00 00       	mov    $0x1,%eax
 23e:	e9 99 00 00 00       	jmp    2dc <matchhere+0xb3>
  if(re[1] == '*')
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	83 c0 01             	add    $0x1,%eax
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	3c 2a                	cmp    $0x2a,%al
 24e:	75 21                	jne    271 <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	8d 50 02             	lea    0x2(%eax),%edx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	0f be c0             	movsbl %al,%eax
 25f:	83 ec 04             	sub    $0x4,%esp
 262:	ff 75 0c             	pushl  0xc(%ebp)
 265:	52                   	push   %edx
 266:	50                   	push   %eax
 267:	e8 72 00 00 00       	call   2de <matchstar>
 26c:	83 c4 10             	add    $0x10,%esp
 26f:	eb 6b                	jmp    2dc <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	3c 24                	cmp    $0x24,%al
 279:	75 1d                	jne    298 <matchhere+0x6f>
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	83 c0 01             	add    $0x1,%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	84 c0                	test   %al,%al
 286:	75 10                	jne    298 <matchhere+0x6f>
    return *text == '\0';
 288:	8b 45 0c             	mov    0xc(%ebp),%eax
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	84 c0                	test   %al,%al
 290:	0f 94 c0             	sete   %al
 293:	0f b6 c0             	movzbl %al,%eax
 296:	eb 44                	jmp    2dc <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 298:	8b 45 0c             	mov    0xc(%ebp),%eax
 29b:	0f b6 00             	movzbl (%eax),%eax
 29e:	84 c0                	test   %al,%al
 2a0:	74 35                	je     2d7 <matchhere+0xae>
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	0f b6 00             	movzbl (%eax),%eax
 2a8:	3c 2e                	cmp    $0x2e,%al
 2aa:	74 10                	je     2bc <matchhere+0x93>
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	0f b6 10             	movzbl (%eax),%edx
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	0f b6 00             	movzbl (%eax),%eax
 2b8:	38 c2                	cmp    %al,%dl
 2ba:	75 1b                	jne    2d7 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bf:	8d 50 01             	lea    0x1(%eax),%edx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	83 c0 01             	add    $0x1,%eax
 2c8:	83 ec 08             	sub    $0x8,%esp
 2cb:	52                   	push   %edx
 2cc:	50                   	push   %eax
 2cd:	e8 57 ff ff ff       	call   229 <matchhere>
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	eb 05                	jmp    2dc <matchhere+0xb3>
  return 0;
 2d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2e4:	83 ec 08             	sub    $0x8,%esp
 2e7:	ff 75 10             	pushl  0x10(%ebp)
 2ea:	ff 75 0c             	pushl  0xc(%ebp)
 2ed:	e8 37 ff ff ff       	call   229 <matchhere>
 2f2:	83 c4 10             	add    $0x10,%esp
 2f5:	85 c0                	test   %eax,%eax
 2f7:	74 07                	je     300 <matchstar+0x22>
      return 1;
 2f9:	b8 01 00 00 00       	mov    $0x1,%eax
 2fe:	eb 29                	jmp    329 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 300:	8b 45 10             	mov    0x10(%ebp),%eax
 303:	0f b6 00             	movzbl (%eax),%eax
 306:	84 c0                	test   %al,%al
 308:	74 1a                	je     324 <matchstar+0x46>
 30a:	8b 45 10             	mov    0x10(%ebp),%eax
 30d:	8d 50 01             	lea    0x1(%eax),%edx
 310:	89 55 10             	mov    %edx,0x10(%ebp)
 313:	0f b6 00             	movzbl (%eax),%eax
 316:	0f be c0             	movsbl %al,%eax
 319:	3b 45 08             	cmp    0x8(%ebp),%eax
 31c:	74 c6                	je     2e4 <matchstar+0x6>
 31e:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 322:	74 c0                	je     2e4 <matchstar+0x6>
  return 0;
 324:	b8 00 00 00 00       	mov    $0x0,%eax
}
 329:	c9                   	leave  
 32a:	c3                   	ret    

0000032b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 32b:	55                   	push   %ebp
 32c:	89 e5                	mov    %esp,%ebp
 32e:	57                   	push   %edi
 32f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 330:	8b 4d 08             	mov    0x8(%ebp),%ecx
 333:	8b 55 10             	mov    0x10(%ebp),%edx
 336:	8b 45 0c             	mov    0xc(%ebp),%eax
 339:	89 cb                	mov    %ecx,%ebx
 33b:	89 df                	mov    %ebx,%edi
 33d:	89 d1                	mov    %edx,%ecx
 33f:	fc                   	cld    
 340:	f3 aa                	rep stos %al,%es:(%edi)
 342:	89 ca                	mov    %ecx,%edx
 344:	89 fb                	mov    %edi,%ebx
 346:	89 5d 08             	mov    %ebx,0x8(%ebp)
 349:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 34c:	90                   	nop
 34d:	5b                   	pop    %ebx
 34e:	5f                   	pop    %edi
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret    

00000351 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 351:	55                   	push   %ebp
 352:	89 e5                	mov    %esp,%ebp
 354:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 35d:	90                   	nop
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
 361:	8d 50 01             	lea    0x1(%eax),%edx
 364:	89 55 08             	mov    %edx,0x8(%ebp)
 367:	8b 55 0c             	mov    0xc(%ebp),%edx
 36a:	8d 4a 01             	lea    0x1(%edx),%ecx
 36d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 370:	0f b6 12             	movzbl (%edx),%edx
 373:	88 10                	mov    %dl,(%eax)
 375:	0f b6 00             	movzbl (%eax),%eax
 378:	84 c0                	test   %al,%al
 37a:	75 e2                	jne    35e <strcpy+0xd>
    ;
  return os;
 37c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 37f:	c9                   	leave  
 380:	c3                   	ret    

00000381 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 384:	eb 08                	jmp    38e <strcmp+0xd>
    p++, q++;
 386:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 38a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	0f b6 00             	movzbl (%eax),%eax
 394:	84 c0                	test   %al,%al
 396:	74 10                	je     3a8 <strcmp+0x27>
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	0f b6 10             	movzbl (%eax),%edx
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	38 c2                	cmp    %al,%dl
 3a6:	74 de                	je     386 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	0f b6 d0             	movzbl %al,%edx
 3b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b4:	0f b6 00             	movzbl (%eax),%eax
 3b7:	0f b6 c0             	movzbl %al,%eax
 3ba:	29 c2                	sub    %eax,%edx
 3bc:	89 d0                	mov    %edx,%eax
}
 3be:	5d                   	pop    %ebp
 3bf:	c3                   	ret    

000003c0 <strlen>:

uint
strlen(char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3cd:	eb 04                	jmp    3d3 <strlen+0x13>
 3cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	01 d0                	add    %edx,%eax
 3db:	0f b6 00             	movzbl (%eax),%eax
 3de:	84 c0                	test   %al,%al
 3e0:	75 ed                	jne    3cf <strlen+0xf>
    ;
  return n;
 3e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e5:	c9                   	leave  
 3e6:	c3                   	ret    

000003e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e7:	55                   	push   %ebp
 3e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3ea:	8b 45 10             	mov    0x10(%ebp),%eax
 3ed:	50                   	push   %eax
 3ee:	ff 75 0c             	pushl  0xc(%ebp)
 3f1:	ff 75 08             	pushl  0x8(%ebp)
 3f4:	e8 32 ff ff ff       	call   32b <stosb>
 3f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ff:	c9                   	leave  
 400:	c3                   	ret    

00000401 <strchr>:

char*
strchr(const char *s, char c)
{
 401:	55                   	push   %ebp
 402:	89 e5                	mov    %esp,%ebp
 404:	83 ec 04             	sub    $0x4,%esp
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 40d:	eb 14                	jmp    423 <strchr+0x22>
    if(*s == c)
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	0f b6 00             	movzbl (%eax),%eax
 415:	3a 45 fc             	cmp    -0x4(%ebp),%al
 418:	75 05                	jne    41f <strchr+0x1e>
      return (char*)s;
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	eb 13                	jmp    432 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 41f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	0f b6 00             	movzbl (%eax),%eax
 429:	84 c0                	test   %al,%al
 42b:	75 e2                	jne    40f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 42d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <gets>:

char*
gets(char *buf, int max)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 43a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 441:	eb 42                	jmp    485 <gets+0x51>
    cc = read(0, &c, 1);
 443:	83 ec 04             	sub    $0x4,%esp
 446:	6a 01                	push   $0x1
 448:	8d 45 ef             	lea    -0x11(%ebp),%eax
 44b:	50                   	push   %eax
 44c:	6a 00                	push   $0x0
 44e:	e8 77 01 00 00       	call   5ca <read>
 453:	83 c4 10             	add    $0x10,%esp
 456:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 459:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45d:	7e 33                	jle    492 <gets+0x5e>
      break;
    buf[i++] = c;
 45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 462:	8d 50 01             	lea    0x1(%eax),%edx
 465:	89 55 f4             	mov    %edx,-0xc(%ebp)
 468:	89 c2                	mov    %eax,%edx
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	01 c2                	add    %eax,%edx
 46f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 473:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 475:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 479:	3c 0a                	cmp    $0xa,%al
 47b:	74 16                	je     493 <gets+0x5f>
 47d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 481:	3c 0d                	cmp    $0xd,%al
 483:	74 0e                	je     493 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 485:	8b 45 f4             	mov    -0xc(%ebp),%eax
 488:	83 c0 01             	add    $0x1,%eax
 48b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 48e:	7c b3                	jl     443 <gets+0xf>
 490:	eb 01                	jmp    493 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 492:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 493:	8b 55 f4             	mov    -0xc(%ebp),%edx
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	01 d0                	add    %edx,%eax
 49b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a1:	c9                   	leave  
 4a2:	c3                   	ret    

000004a3 <stat>:

int
stat(char *n, struct stat *st)
{
 4a3:	55                   	push   %ebp
 4a4:	89 e5                	mov    %esp,%ebp
 4a6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a9:	83 ec 08             	sub    $0x8,%esp
 4ac:	6a 00                	push   $0x0
 4ae:	ff 75 08             	pushl  0x8(%ebp)
 4b1:	e8 3c 01 00 00       	call   5f2 <open>
 4b6:	83 c4 10             	add    $0x10,%esp
 4b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c0:	79 07                	jns    4c9 <stat+0x26>
    return -1;
 4c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4c7:	eb 25                	jmp    4ee <stat+0x4b>
  r = fstat(fd, st);
 4c9:	83 ec 08             	sub    $0x8,%esp
 4cc:	ff 75 0c             	pushl  0xc(%ebp)
 4cf:	ff 75 f4             	pushl  -0xc(%ebp)
 4d2:	e8 33 01 00 00       	call   60a <fstat>
 4d7:	83 c4 10             	add    $0x10,%esp
 4da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4dd:	83 ec 0c             	sub    $0xc,%esp
 4e0:	ff 75 f4             	pushl  -0xc(%ebp)
 4e3:	e8 f2 00 00 00       	call   5da <close>
 4e8:	83 c4 10             	add    $0x10,%esp
  return r;
 4eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4ee:	c9                   	leave  
 4ef:	c3                   	ret    

000004f0 <atoi>:

int
atoi(const char *s)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4fd:	eb 25                	jmp    524 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 502:	89 d0                	mov    %edx,%eax
 504:	c1 e0 02             	shl    $0x2,%eax
 507:	01 d0                	add    %edx,%eax
 509:	01 c0                	add    %eax,%eax
 50b:	89 c1                	mov    %eax,%ecx
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	8d 50 01             	lea    0x1(%eax),%edx
 513:	89 55 08             	mov    %edx,0x8(%ebp)
 516:	0f b6 00             	movzbl (%eax),%eax
 519:	0f be c0             	movsbl %al,%eax
 51c:	01 c8                	add    %ecx,%eax
 51e:	83 e8 30             	sub    $0x30,%eax
 521:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	0f b6 00             	movzbl (%eax),%eax
 52a:	3c 2f                	cmp    $0x2f,%al
 52c:	7e 0a                	jle    538 <atoi+0x48>
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	3c 39                	cmp    $0x39,%al
 536:	7e c7                	jle    4ff <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 538:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 53b:	c9                   	leave  
 53c:	c3                   	ret    

0000053d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 53d:	55                   	push   %ebp
 53e:	89 e5                	mov    %esp,%ebp
 540:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 549:	8b 45 0c             	mov    0xc(%ebp),%eax
 54c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 54f:	eb 17                	jmp    568 <memmove+0x2b>
    *dst++ = *src++;
 551:	8b 45 fc             	mov    -0x4(%ebp),%eax
 554:	8d 50 01             	lea    0x1(%eax),%edx
 557:	89 55 fc             	mov    %edx,-0x4(%ebp)
 55a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 55d:	8d 4a 01             	lea    0x1(%edx),%ecx
 560:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 563:	0f b6 12             	movzbl (%edx),%edx
 566:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 568:	8b 45 10             	mov    0x10(%ebp),%eax
 56b:	8d 50 ff             	lea    -0x1(%eax),%edx
 56e:	89 55 10             	mov    %edx,0x10(%ebp)
 571:	85 c0                	test   %eax,%eax
 573:	7f dc                	jg     551 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 575:	8b 45 08             	mov    0x8(%ebp),%eax
}
 578:	c9                   	leave  
 579:	c3                   	ret    

0000057a <restorer>:
 57a:	83 c4 0c             	add    $0xc,%esp
 57d:	5a                   	pop    %edx
 57e:	59                   	pop    %ecx
 57f:	58                   	pop    %eax
 580:	c3                   	ret    

00000581 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int,siginfo_t))
{
 581:	55                   	push   %ebp
 582:	89 e5                	mov    %esp,%ebp
 584:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 587:	83 ec 0c             	sub    $0xc,%esp
 58a:	68 7a 05 00 00       	push   $0x57a
 58f:	e8 ce 00 00 00       	call   662 <signal_restorer>
 594:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 597:	83 ec 08             	sub    $0x8,%esp
 59a:	ff 75 0c             	pushl  0xc(%ebp)
 59d:	ff 75 08             	pushl  0x8(%ebp)
 5a0:	e8 b5 00 00 00       	call   65a <signal_register>
 5a5:	83 c4 10             	add    $0x10,%esp
}
 5a8:	c9                   	leave  
 5a9:	c3                   	ret    

000005aa <fork>:
 5aa:	b8 01 00 00 00       	mov    $0x1,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <exit>:
 5b2:	b8 02 00 00 00       	mov    $0x2,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <wait>:
 5ba:	b8 03 00 00 00       	mov    $0x3,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <pipe>:
 5c2:	b8 04 00 00 00       	mov    $0x4,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <read>:
 5ca:	b8 05 00 00 00       	mov    $0x5,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <write>:
 5d2:	b8 10 00 00 00       	mov    $0x10,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <close>:
 5da:	b8 15 00 00 00       	mov    $0x15,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <kill>:
 5e2:	b8 06 00 00 00       	mov    $0x6,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <exec>:
 5ea:	b8 07 00 00 00       	mov    $0x7,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <open>:
 5f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <mknod>:
 5fa:	b8 11 00 00 00       	mov    $0x11,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <unlink>:
 602:	b8 12 00 00 00       	mov    $0x12,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <fstat>:
 60a:	b8 08 00 00 00       	mov    $0x8,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <link>:
 612:	b8 13 00 00 00       	mov    $0x13,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <mkdir>:
 61a:	b8 14 00 00 00       	mov    $0x14,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <chdir>:
 622:	b8 09 00 00 00       	mov    $0x9,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <dup>:
 62a:	b8 0a 00 00 00       	mov    $0xa,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <getpid>:
 632:	b8 0b 00 00 00       	mov    $0xb,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <sbrk>:
 63a:	b8 0c 00 00 00       	mov    $0xc,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <sleep>:
 642:	b8 0d 00 00 00       	mov    $0xd,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <uptime>:
 64a:	b8 0e 00 00 00       	mov    $0xe,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <halt>:
 652:	b8 16 00 00 00       	mov    $0x16,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <signal_register>:
 65a:	b8 17 00 00 00       	mov    $0x17,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <signal_restorer>:
 662:	b8 18 00 00 00       	mov    $0x18,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <mprotect>:
 66a:	b8 19 00 00 00       	mov    $0x19,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 672:	55                   	push   %ebp
 673:	89 e5                	mov    %esp,%ebp
 675:	83 ec 18             	sub    $0x18,%esp
 678:	8b 45 0c             	mov    0xc(%ebp),%eax
 67b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 67e:	83 ec 04             	sub    $0x4,%esp
 681:	6a 01                	push   $0x1
 683:	8d 45 f4             	lea    -0xc(%ebp),%eax
 686:	50                   	push   %eax
 687:	ff 75 08             	pushl  0x8(%ebp)
 68a:	e8 43 ff ff ff       	call   5d2 <write>
 68f:	83 c4 10             	add    $0x10,%esp
}
 692:	90                   	nop
 693:	c9                   	leave  
 694:	c3                   	ret    

00000695 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 695:	55                   	push   %ebp
 696:	89 e5                	mov    %esp,%ebp
 698:	53                   	push   %ebx
 699:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 69c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6a3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6a7:	74 17                	je     6c0 <printint+0x2b>
 6a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6ad:	79 11                	jns    6c0 <printint+0x2b>
    neg = 1;
 6af:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b9:	f7 d8                	neg    %eax
 6bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6be:	eb 06                	jmp    6c6 <printint+0x31>
  } else {
    x = xx;
 6c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6cd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6d0:	8d 41 01             	lea    0x1(%ecx),%eax
 6d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6dc:	ba 00 00 00 00       	mov    $0x0,%edx
 6e1:	f7 f3                	div    %ebx
 6e3:	89 d0                	mov    %edx,%eax
 6e5:	0f b6 80 2c 0e 00 00 	movzbl 0xe2c(%eax),%eax
 6ec:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6f6:	ba 00 00 00 00       	mov    $0x0,%edx
 6fb:	f7 f3                	div    %ebx
 6fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 700:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 704:	75 c7                	jne    6cd <printint+0x38>
  if(neg)
 706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70a:	74 2d                	je     739 <printint+0xa4>
    buf[i++] = '-';
 70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70f:	8d 50 01             	lea    0x1(%eax),%edx
 712:	89 55 f4             	mov    %edx,-0xc(%ebp)
 715:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 71a:	eb 1d                	jmp    739 <printint+0xa4>
    putc(fd, buf[i]);
 71c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 71f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 722:	01 d0                	add    %edx,%eax
 724:	0f b6 00             	movzbl (%eax),%eax
 727:	0f be c0             	movsbl %al,%eax
 72a:	83 ec 08             	sub    $0x8,%esp
 72d:	50                   	push   %eax
 72e:	ff 75 08             	pushl  0x8(%ebp)
 731:	e8 3c ff ff ff       	call   672 <putc>
 736:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 739:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 73d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 741:	79 d9                	jns    71c <printint+0x87>
    putc(fd, buf[i]);
}
 743:	90                   	nop
 744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 747:	c9                   	leave  
 748:	c3                   	ret    

00000749 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 749:	55                   	push   %ebp
 74a:	89 e5                	mov    %esp,%ebp
 74c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 74f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 756:	8d 45 0c             	lea    0xc(%ebp),%eax
 759:	83 c0 04             	add    $0x4,%eax
 75c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 75f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 766:	e9 59 01 00 00       	jmp    8c4 <printf+0x17b>
    c = fmt[i] & 0xff;
 76b:	8b 55 0c             	mov    0xc(%ebp),%edx
 76e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 771:	01 d0                	add    %edx,%eax
 773:	0f b6 00             	movzbl (%eax),%eax
 776:	0f be c0             	movsbl %al,%eax
 779:	25 ff 00 00 00       	and    $0xff,%eax
 77e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 781:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 785:	75 2c                	jne    7b3 <printf+0x6a>
      if(c == '%'){
 787:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 78b:	75 0c                	jne    799 <printf+0x50>
        state = '%';
 78d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 794:	e9 27 01 00 00       	jmp    8c0 <printf+0x177>
      } else {
        putc(fd, c);
 799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 79c:	0f be c0             	movsbl %al,%eax
 79f:	83 ec 08             	sub    $0x8,%esp
 7a2:	50                   	push   %eax
 7a3:	ff 75 08             	pushl  0x8(%ebp)
 7a6:	e8 c7 fe ff ff       	call   672 <putc>
 7ab:	83 c4 10             	add    $0x10,%esp
 7ae:	e9 0d 01 00 00       	jmp    8c0 <printf+0x177>
      }
    } else if(state == '%'){
 7b3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7b7:	0f 85 03 01 00 00    	jne    8c0 <printf+0x177>
      if(c == 'd'){
 7bd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7c1:	75 1e                	jne    7e1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c6:	8b 00                	mov    (%eax),%eax
 7c8:	6a 01                	push   $0x1
 7ca:	6a 0a                	push   $0xa
 7cc:	50                   	push   %eax
 7cd:	ff 75 08             	pushl  0x8(%ebp)
 7d0:	e8 c0 fe ff ff       	call   695 <printint>
 7d5:	83 c4 10             	add    $0x10,%esp
        ap++;
 7d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7dc:	e9 d8 00 00 00       	jmp    8b9 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7e1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7e5:	74 06                	je     7ed <printf+0xa4>
 7e7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7eb:	75 1e                	jne    80b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	6a 00                	push   $0x0
 7f4:	6a 10                	push   $0x10
 7f6:	50                   	push   %eax
 7f7:	ff 75 08             	pushl  0x8(%ebp)
 7fa:	e8 96 fe ff ff       	call   695 <printint>
 7ff:	83 c4 10             	add    $0x10,%esp
        ap++;
 802:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 806:	e9 ae 00 00 00       	jmp    8b9 <printf+0x170>
      } else if(c == 's'){
 80b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 80f:	75 43                	jne    854 <printf+0x10b>
        s = (char*)*ap;
 811:	8b 45 e8             	mov    -0x18(%ebp),%eax
 814:	8b 00                	mov    (%eax),%eax
 816:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 819:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 81d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 821:	75 25                	jne    848 <printf+0xff>
          s = "(null)";
 823:	c7 45 f4 36 0b 00 00 	movl   $0xb36,-0xc(%ebp)
        while(*s != 0){
 82a:	eb 1c                	jmp    848 <printf+0xff>
          putc(fd, *s);
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	0f b6 00             	movzbl (%eax),%eax
 832:	0f be c0             	movsbl %al,%eax
 835:	83 ec 08             	sub    $0x8,%esp
 838:	50                   	push   %eax
 839:	ff 75 08             	pushl  0x8(%ebp)
 83c:	e8 31 fe ff ff       	call   672 <putc>
 841:	83 c4 10             	add    $0x10,%esp
          s++;
 844:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84b:	0f b6 00             	movzbl (%eax),%eax
 84e:	84 c0                	test   %al,%al
 850:	75 da                	jne    82c <printf+0xe3>
 852:	eb 65                	jmp    8b9 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 854:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 858:	75 1d                	jne    877 <printf+0x12e>
        putc(fd, *ap);
 85a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 85d:	8b 00                	mov    (%eax),%eax
 85f:	0f be c0             	movsbl %al,%eax
 862:	83 ec 08             	sub    $0x8,%esp
 865:	50                   	push   %eax
 866:	ff 75 08             	pushl  0x8(%ebp)
 869:	e8 04 fe ff ff       	call   672 <putc>
 86e:	83 c4 10             	add    $0x10,%esp
        ap++;
 871:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 875:	eb 42                	jmp    8b9 <printf+0x170>
      } else if(c == '%'){
 877:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 87b:	75 17                	jne    894 <printf+0x14b>
        putc(fd, c);
 87d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 880:	0f be c0             	movsbl %al,%eax
 883:	83 ec 08             	sub    $0x8,%esp
 886:	50                   	push   %eax
 887:	ff 75 08             	pushl  0x8(%ebp)
 88a:	e8 e3 fd ff ff       	call   672 <putc>
 88f:	83 c4 10             	add    $0x10,%esp
 892:	eb 25                	jmp    8b9 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 894:	83 ec 08             	sub    $0x8,%esp
 897:	6a 25                	push   $0x25
 899:	ff 75 08             	pushl  0x8(%ebp)
 89c:	e8 d1 fd ff ff       	call   672 <putc>
 8a1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a7:	0f be c0             	movsbl %al,%eax
 8aa:	83 ec 08             	sub    $0x8,%esp
 8ad:	50                   	push   %eax
 8ae:	ff 75 08             	pushl  0x8(%ebp)
 8b1:	e8 bc fd ff ff       	call   672 <putc>
 8b6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8c0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8c4:	8b 55 0c             	mov    0xc(%ebp),%edx
 8c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ca:	01 d0                	add    %edx,%eax
 8cc:	0f b6 00             	movzbl (%eax),%eax
 8cf:	84 c0                	test   %al,%al
 8d1:	0f 85 94 fe ff ff    	jne    76b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8d7:	90                   	nop
 8d8:	c9                   	leave  
 8d9:	c3                   	ret    

000008da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8da:	55                   	push   %ebp
 8db:	89 e5                	mov    %esp,%ebp
 8dd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e0:	8b 45 08             	mov    0x8(%ebp),%eax
 8e3:	83 e8 08             	sub    $0x8,%eax
 8e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e9:	a1 48 0e 00 00       	mov    0xe48,%eax
 8ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8f1:	eb 24                	jmp    917 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f6:	8b 00                	mov    (%eax),%eax
 8f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8fb:	77 12                	ja     90f <free+0x35>
 8fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 900:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 903:	77 24                	ja     929 <free+0x4f>
 905:	8b 45 fc             	mov    -0x4(%ebp),%eax
 908:	8b 00                	mov    (%eax),%eax
 90a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 90d:	77 1a                	ja     929 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 912:	8b 00                	mov    (%eax),%eax
 914:	89 45 fc             	mov    %eax,-0x4(%ebp)
 917:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 91d:	76 d4                	jbe    8f3 <free+0x19>
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	8b 00                	mov    (%eax),%eax
 924:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 927:	76 ca                	jbe    8f3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 929:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92c:	8b 40 04             	mov    0x4(%eax),%eax
 92f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 936:	8b 45 f8             	mov    -0x8(%ebp),%eax
 939:	01 c2                	add    %eax,%edx
 93b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93e:	8b 00                	mov    (%eax),%eax
 940:	39 c2                	cmp    %eax,%edx
 942:	75 24                	jne    968 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 944:	8b 45 f8             	mov    -0x8(%ebp),%eax
 947:	8b 50 04             	mov    0x4(%eax),%edx
 94a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94d:	8b 00                	mov    (%eax),%eax
 94f:	8b 40 04             	mov    0x4(%eax),%eax
 952:	01 c2                	add    %eax,%edx
 954:	8b 45 f8             	mov    -0x8(%ebp),%eax
 957:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 95a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95d:	8b 00                	mov    (%eax),%eax
 95f:	8b 10                	mov    (%eax),%edx
 961:	8b 45 f8             	mov    -0x8(%ebp),%eax
 964:	89 10                	mov    %edx,(%eax)
 966:	eb 0a                	jmp    972 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 968:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96b:	8b 10                	mov    (%eax),%edx
 96d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 970:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 972:	8b 45 fc             	mov    -0x4(%ebp),%eax
 975:	8b 40 04             	mov    0x4(%eax),%eax
 978:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 97f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 982:	01 d0                	add    %edx,%eax
 984:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 987:	75 20                	jne    9a9 <free+0xcf>
    p->s.size += bp->s.size;
 989:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98c:	8b 50 04             	mov    0x4(%eax),%edx
 98f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 992:	8b 40 04             	mov    0x4(%eax),%eax
 995:	01 c2                	add    %eax,%edx
 997:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 99d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a0:	8b 10                	mov    (%eax),%edx
 9a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a5:	89 10                	mov    %edx,(%eax)
 9a7:	eb 08                	jmp    9b1 <free+0xd7>
  } else
    p->s.ptr = bp;
 9a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9af:	89 10                	mov    %edx,(%eax)
  freep = p;
 9b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b4:	a3 48 0e 00 00       	mov    %eax,0xe48
}
 9b9:	90                   	nop
 9ba:	c9                   	leave  
 9bb:	c3                   	ret    

000009bc <morecore>:

static Header*
morecore(uint nu)
{
 9bc:	55                   	push   %ebp
 9bd:	89 e5                	mov    %esp,%ebp
 9bf:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9c2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9c9:	77 07                	ja     9d2 <morecore+0x16>
    nu = 4096;
 9cb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9d2:	8b 45 08             	mov    0x8(%ebp),%eax
 9d5:	c1 e0 03             	shl    $0x3,%eax
 9d8:	83 ec 0c             	sub    $0xc,%esp
 9db:	50                   	push   %eax
 9dc:	e8 59 fc ff ff       	call   63a <sbrk>
 9e1:	83 c4 10             	add    $0x10,%esp
 9e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9e7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9eb:	75 07                	jne    9f4 <morecore+0x38>
    return 0;
 9ed:	b8 00 00 00 00       	mov    $0x0,%eax
 9f2:	eb 26                	jmp    a1a <morecore+0x5e>
  hp = (Header*)p;
 9f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fd:	8b 55 08             	mov    0x8(%ebp),%edx
 a00:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a06:	83 c0 08             	add    $0x8,%eax
 a09:	83 ec 0c             	sub    $0xc,%esp
 a0c:	50                   	push   %eax
 a0d:	e8 c8 fe ff ff       	call   8da <free>
 a12:	83 c4 10             	add    $0x10,%esp
  return freep;
 a15:	a1 48 0e 00 00       	mov    0xe48,%eax
}
 a1a:	c9                   	leave  
 a1b:	c3                   	ret    

00000a1c <malloc>:

void*
malloc(uint nbytes)
{
 a1c:	55                   	push   %ebp
 a1d:	89 e5                	mov    %esp,%ebp
 a1f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a22:	8b 45 08             	mov    0x8(%ebp),%eax
 a25:	83 c0 07             	add    $0x7,%eax
 a28:	c1 e8 03             	shr    $0x3,%eax
 a2b:	83 c0 01             	add    $0x1,%eax
 a2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a31:	a1 48 0e 00 00       	mov    0xe48,%eax
 a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a3d:	75 23                	jne    a62 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a3f:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
 a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a49:	a3 48 0e 00 00       	mov    %eax,0xe48
 a4e:	a1 48 0e 00 00       	mov    0xe48,%eax
 a53:	a3 40 0e 00 00       	mov    %eax,0xe40
    base.s.size = 0;
 a58:	c7 05 44 0e 00 00 00 	movl   $0x0,0xe44
 a5f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a65:	8b 00                	mov    (%eax),%eax
 a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6d:	8b 40 04             	mov    0x4(%eax),%eax
 a70:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a73:	72 4d                	jb     ac2 <malloc+0xa6>
      if(p->s.size == nunits)
 a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a78:	8b 40 04             	mov    0x4(%eax),%eax
 a7b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a7e:	75 0c                	jne    a8c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a83:	8b 10                	mov    (%eax),%edx
 a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a88:	89 10                	mov    %edx,(%eax)
 a8a:	eb 26                	jmp    ab2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8f:	8b 40 04             	mov    0x4(%eax),%eax
 a92:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a95:	89 c2                	mov    %eax,%edx
 a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa0:	8b 40 04             	mov    0x4(%eax),%eax
 aa3:	c1 e0 03             	shl    $0x3,%eax
 aa6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aac:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aaf:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab5:	a3 48 0e 00 00       	mov    %eax,0xe48
      return (void*)(p + 1);
 aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abd:	83 c0 08             	add    $0x8,%eax
 ac0:	eb 3b                	jmp    afd <malloc+0xe1>
    }
    if(p == freep)
 ac2:	a1 48 0e 00 00       	mov    0xe48,%eax
 ac7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aca:	75 1e                	jne    aea <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 acc:	83 ec 0c             	sub    $0xc,%esp
 acf:	ff 75 ec             	pushl  -0x14(%ebp)
 ad2:	e8 e5 fe ff ff       	call   9bc <morecore>
 ad7:	83 c4 10             	add    $0x10,%esp
 ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
 add:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ae1:	75 07                	jne    aea <malloc+0xce>
        return 0;
 ae3:	b8 00 00 00 00       	mov    $0x0,%eax
 ae8:	eb 13                	jmp    afd <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
 af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af3:	8b 00                	mov    (%eax),%eax
 af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 af8:	e9 6d ff ff ff       	jmp    a6a <malloc+0x4e>
}
 afd:	c9                   	leave  
 afe:	c3                   	ret    
