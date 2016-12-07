
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 c9 03 00 00       	call   3db <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	89 c2                	mov    %eax,%edx
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	01 d0                	add    %edx,%eax
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1f:	eb 04                	jmp    25 <fmtname+0x25>
  21:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28:	3b 45 08             	cmp    0x8(%ebp),%eax
  2b:	72 0a                	jb     37 <fmtname+0x37>
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	0f b6 00             	movzbl (%eax),%eax
  33:	3c 2f                	cmp    $0x2f,%al
  35:	75 ea                	jne    21 <fmtname+0x21>
    ;
  p++;
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 75 f4             	pushl  -0xc(%ebp)
  41:	e8 95 03 00 00       	call   3db <strlen>
  46:	83 c4 10             	add    $0x10,%esp
  49:	83 f8 0d             	cmp    $0xd,%eax
  4c:	76 05                	jbe    53 <fmtname+0x53>
    return p;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	eb 60                	jmp    b3 <fmtname+0xb3>
  memmove(buf, p, strlen(p));
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	ff 75 f4             	pushl  -0xc(%ebp)
  59:	e8 7d 03 00 00       	call   3db <strlen>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	ff 75 f4             	pushl  -0xc(%ebp)
  68:	68 40 0e 00 00       	push   $0xe40
  6d:	e8 e6 04 00 00       	call   558 <memmove>
  72:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	e8 5b 03 00 00       	call   3db <strlen>
  80:	83 c4 10             	add    $0x10,%esp
  83:	ba 0e 00 00 00       	mov    $0xe,%edx
  88:	89 d3                	mov    %edx,%ebx
  8a:	29 c3                	sub    %eax,%ebx
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f4             	pushl  -0xc(%ebp)
  92:	e8 44 03 00 00       	call   3db <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	05 40 0e 00 00       	add    $0xe40,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 57 03 00 00       	call   402 <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 40 0e 00 00       	mov    $0xe40,%eax
}
  b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <ls>:

void
ls(char *path)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	57                   	push   %edi
  bc:	56                   	push   %esi
  bd:	53                   	push   %ebx
  be:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	6a 00                	push   $0x0
  c9:	ff 75 08             	pushl  0x8(%ebp)
  cc:	e8 3c 05 00 00       	call   60d <open>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  db:	79 1a                	jns    f7 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 75 08             	pushl  0x8(%ebp)
  e3:	68 1a 0b 00 00       	push   $0xb1a
  e8:	6a 02                	push   $0x2
  ea:	e8 75 06 00 00       	call   764 <printf>
  ef:	83 c4 10             	add    $0x10,%esp
    return;
  f2:	e9 e3 01 00 00       	jmp    2da <ls+0x222>
  }
  
  if(fstat(fd, &st) < 0){
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 100:	50                   	push   %eax
 101:	ff 75 e4             	pushl  -0x1c(%ebp)
 104:	e8 1c 05 00 00       	call   625 <fstat>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	79 28                	jns    138 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	ff 75 08             	pushl  0x8(%ebp)
 116:	68 2e 0b 00 00       	push   $0xb2e
 11b:	6a 02                	push   $0x2
 11d:	e8 42 06 00 00       	call   764 <printf>
 122:	83 c4 10             	add    $0x10,%esp
    close(fd);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 e4             	pushl  -0x1c(%ebp)
 12b:	e8 c5 04 00 00       	call   5f5 <close>
 130:	83 c4 10             	add    $0x10,%esp
    return;
 133:	e9 a2 01 00 00       	jmp    2da <ls+0x222>
  }
  
  switch(st.type){
 138:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 13f:	98                   	cwtl   
 140:	83 f8 01             	cmp    $0x1,%eax
 143:	74 48                	je     18d <ls+0xd5>
 145:	83 f8 02             	cmp    $0x2,%eax
 148:	0f 85 7e 01 00 00    	jne    2cc <ls+0x214>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 14e:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 154:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15a:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 161:	0f bf d8             	movswl %ax,%ebx
 164:	83 ec 0c             	sub    $0xc,%esp
 167:	ff 75 08             	pushl  0x8(%ebp)
 16a:	e8 91 fe ff ff       	call   0 <fmtname>
 16f:	83 c4 10             	add    $0x10,%esp
 172:	83 ec 08             	sub    $0x8,%esp
 175:	57                   	push   %edi
 176:	56                   	push   %esi
 177:	53                   	push   %ebx
 178:	50                   	push   %eax
 179:	68 42 0b 00 00       	push   $0xb42
 17e:	6a 01                	push   $0x1
 180:	e8 df 05 00 00       	call   764 <printf>
 185:	83 c4 20             	add    $0x20,%esp
    break;
 188:	e9 3f 01 00 00       	jmp    2cc <ls+0x214>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 18d:	83 ec 0c             	sub    $0xc,%esp
 190:	ff 75 08             	pushl  0x8(%ebp)
 193:	e8 43 02 00 00       	call   3db <strlen>
 198:	83 c4 10             	add    $0x10,%esp
 19b:	83 c0 10             	add    $0x10,%eax
 19e:	3d 00 02 00 00       	cmp    $0x200,%eax
 1a3:	76 17                	jbe    1bc <ls+0x104>
      printf(1, "ls: path too long\n");
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	68 4f 0b 00 00       	push   $0xb4f
 1ad:	6a 01                	push   $0x1
 1af:	e8 b0 05 00 00       	call   764 <printf>
 1b4:	83 c4 10             	add    $0x10,%esp
      break;
 1b7:	e9 10 01 00 00       	jmp    2cc <ls+0x214>
    }
    strcpy(buf, path);
 1bc:	83 ec 08             	sub    $0x8,%esp
 1bf:	ff 75 08             	pushl  0x8(%ebp)
 1c2:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1c8:	50                   	push   %eax
 1c9:	e8 9e 01 00 00       	call   36c <strcpy>
 1ce:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1d1:	83 ec 0c             	sub    $0xc,%esp
 1d4:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1da:	50                   	push   %eax
 1db:	e8 fb 01 00 00       	call   3db <strlen>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	89 c2                	mov    %eax,%edx
 1e5:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1eb:	01 d0                	add    %edx,%eax
 1ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1f9:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fc:	e9 aa 00 00 00       	jmp    2ab <ls+0x1f3>
      if(de.inum == 0)
 201:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 208:	66 85 c0             	test   %ax,%ax
 20b:	75 05                	jne    212 <ls+0x15a>
        continue;
 20d:	e9 99 00 00 00       	jmp    2ab <ls+0x1f3>
      memmove(p, de.name, DIRSIZ);
 212:	83 ec 04             	sub    $0x4,%esp
 215:	6a 0e                	push   $0xe
 217:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 21d:	83 c0 02             	add    $0x2,%eax
 220:	50                   	push   %eax
 221:	ff 75 e0             	pushl  -0x20(%ebp)
 224:	e8 2f 03 00 00       	call   558 <memmove>
 229:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 22c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22f:	83 c0 0e             	add    $0xe,%eax
 232:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 235:	83 ec 08             	sub    $0x8,%esp
 238:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 23e:	50                   	push   %eax
 23f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 245:	50                   	push   %eax
 246:	e8 73 02 00 00       	call   4be <stat>
 24b:	83 c4 10             	add    $0x10,%esp
 24e:	85 c0                	test   %eax,%eax
 250:	79 1b                	jns    26d <ls+0x1b5>
        printf(1, "ls: cannot stat %s\n", buf);
 252:	83 ec 04             	sub    $0x4,%esp
 255:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 25b:	50                   	push   %eax
 25c:	68 2e 0b 00 00       	push   $0xb2e
 261:	6a 01                	push   $0x1
 263:	e8 fc 04 00 00       	call   764 <printf>
 268:	83 c4 10             	add    $0x10,%esp
        continue;
 26b:	eb 3e                	jmp    2ab <ls+0x1f3>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 26d:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 273:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 279:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 280:	0f bf d8             	movswl %ax,%ebx
 283:	83 ec 0c             	sub    $0xc,%esp
 286:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 28c:	50                   	push   %eax
 28d:	e8 6e fd ff ff       	call   0 <fmtname>
 292:	83 c4 10             	add    $0x10,%esp
 295:	83 ec 08             	sub    $0x8,%esp
 298:	57                   	push   %edi
 299:	56                   	push   %esi
 29a:	53                   	push   %ebx
 29b:	50                   	push   %eax
 29c:	68 42 0b 00 00       	push   $0xb42
 2a1:	6a 01                	push   $0x1
 2a3:	e8 bc 04 00 00       	call   764 <printf>
 2a8:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2ab:	83 ec 04             	sub    $0x4,%esp
 2ae:	6a 10                	push   $0x10
 2b0:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2b6:	50                   	push   %eax
 2b7:	ff 75 e4             	pushl  -0x1c(%ebp)
 2ba:	e8 26 03 00 00       	call   5e5 <read>
 2bf:	83 c4 10             	add    $0x10,%esp
 2c2:	83 f8 10             	cmp    $0x10,%eax
 2c5:	0f 84 36 ff ff ff    	je     201 <ls+0x149>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2cb:	90                   	nop
  }
  close(fd);
 2cc:	83 ec 0c             	sub    $0xc,%esp
 2cf:	ff 75 e4             	pushl  -0x1c(%ebp)
 2d2:	e8 1e 03 00 00       	call   5f5 <close>
 2d7:	83 c4 10             	add    $0x10,%esp
}
 2da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2dd:	5b                   	pop    %ebx
 2de:	5e                   	pop    %esi
 2df:	5f                   	pop    %edi
 2e0:	5d                   	pop    %ebp
 2e1:	c3                   	ret    

000002e2 <main>:

int
main(int argc, char *argv[])
{
 2e2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2e6:	83 e4 f0             	and    $0xfffffff0,%esp
 2e9:	ff 71 fc             	pushl  -0x4(%ecx)
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	53                   	push   %ebx
 2f0:	51                   	push   %ecx
 2f1:	83 ec 10             	sub    $0x10,%esp
 2f4:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2f6:	83 3b 01             	cmpl   $0x1,(%ebx)
 2f9:	7f 15                	jg     310 <main+0x2e>
    ls(".");
 2fb:	83 ec 0c             	sub    $0xc,%esp
 2fe:	68 62 0b 00 00       	push   $0xb62
 303:	e8 b0 fd ff ff       	call   b8 <ls>
 308:	83 c4 10             	add    $0x10,%esp
    exit();
 30b:	e8 bd 02 00 00       	call   5cd <exit>
  }
  for(i=1; i<argc; i++)
 310:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 317:	eb 21                	jmp    33a <main+0x58>
    ls(argv[i]);
 319:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 323:	8b 43 04             	mov    0x4(%ebx),%eax
 326:	01 d0                	add    %edx,%eax
 328:	8b 00                	mov    (%eax),%eax
 32a:	83 ec 0c             	sub    $0xc,%esp
 32d:	50                   	push   %eax
 32e:	e8 85 fd ff ff       	call   b8 <ls>
 333:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 336:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 33a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33d:	3b 03                	cmp    (%ebx),%eax
 33f:	7c d8                	jl     319 <main+0x37>
    ls(argv[i]);
  exit();
 341:	e8 87 02 00 00       	call   5cd <exit>

00000346 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	57                   	push   %edi
 34a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 34b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34e:	8b 55 10             	mov    0x10(%ebp),%edx
 351:	8b 45 0c             	mov    0xc(%ebp),%eax
 354:	89 cb                	mov    %ecx,%ebx
 356:	89 df                	mov    %ebx,%edi
 358:	89 d1                	mov    %edx,%ecx
 35a:	fc                   	cld    
 35b:	f3 aa                	rep stos %al,%es:(%edi)
 35d:	89 ca                	mov    %ecx,%edx
 35f:	89 fb                	mov    %edi,%ebx
 361:	89 5d 08             	mov    %ebx,0x8(%ebp)
 364:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 367:	90                   	nop
 368:	5b                   	pop    %ebx
 369:	5f                   	pop    %edi
 36a:	5d                   	pop    %ebp
 36b:	c3                   	ret    

0000036c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 378:	90                   	nop
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	8d 50 01             	lea    0x1(%eax),%edx
 37f:	89 55 08             	mov    %edx,0x8(%ebp)
 382:	8b 55 0c             	mov    0xc(%ebp),%edx
 385:	8d 4a 01             	lea    0x1(%edx),%ecx
 388:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 38b:	0f b6 12             	movzbl (%edx),%edx
 38e:	88 10                	mov    %dl,(%eax)
 390:	0f b6 00             	movzbl (%eax),%eax
 393:	84 c0                	test   %al,%al
 395:	75 e2                	jne    379 <strcpy+0xd>
    ;
  return os;
 397:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 39f:	eb 08                	jmp    3a9 <strcmp+0xd>
    p++, q++;
 3a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3a9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	84 c0                	test   %al,%al
 3b1:	74 10                	je     3c3 <strcmp+0x27>
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 10             	movzbl (%eax),%edx
 3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bc:	0f b6 00             	movzbl (%eax),%eax
 3bf:	38 c2                	cmp    %al,%dl
 3c1:	74 de                	je     3a1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 00             	movzbl (%eax),%eax
 3c9:	0f b6 d0             	movzbl %al,%edx
 3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cf:	0f b6 00             	movzbl (%eax),%eax
 3d2:	0f b6 c0             	movzbl %al,%eax
 3d5:	29 c2                	sub    %eax,%edx
 3d7:	89 d0                	mov    %edx,%eax
}
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret    

000003db <strlen>:

uint
strlen(char *s)
{
 3db:	55                   	push   %ebp
 3dc:	89 e5                	mov    %esp,%ebp
 3de:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3e8:	eb 04                	jmp    3ee <strlen+0x13>
 3ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	01 d0                	add    %edx,%eax
 3f6:	0f b6 00             	movzbl (%eax),%eax
 3f9:	84 c0                	test   %al,%al
 3fb:	75 ed                	jne    3ea <strlen+0xf>
    ;
  return n;
 3fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 400:	c9                   	leave  
 401:	c3                   	ret    

00000402 <memset>:

void*
memset(void *dst, int c, uint n)
{
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 405:	8b 45 10             	mov    0x10(%ebp),%eax
 408:	50                   	push   %eax
 409:	ff 75 0c             	pushl  0xc(%ebp)
 40c:	ff 75 08             	pushl  0x8(%ebp)
 40f:	e8 32 ff ff ff       	call   346 <stosb>
 414:	83 c4 0c             	add    $0xc,%esp
  return dst;
 417:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41a:	c9                   	leave  
 41b:	c3                   	ret    

0000041c <strchr>:

char*
strchr(const char *s, char c)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	83 ec 04             	sub    $0x4,%esp
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 428:	eb 14                	jmp    43e <strchr+0x22>
    if(*s == c)
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	3a 45 fc             	cmp    -0x4(%ebp),%al
 433:	75 05                	jne    43a <strchr+0x1e>
      return (char*)s;
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	eb 13                	jmp    44d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 43a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	0f b6 00             	movzbl (%eax),%eax
 444:	84 c0                	test   %al,%al
 446:	75 e2                	jne    42a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 448:	b8 00 00 00 00       	mov    $0x0,%eax
}
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <gets>:

char*
gets(char *buf, int max)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 455:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45c:	eb 42                	jmp    4a0 <gets+0x51>
    cc = read(0, &c, 1);
 45e:	83 ec 04             	sub    $0x4,%esp
 461:	6a 01                	push   $0x1
 463:	8d 45 ef             	lea    -0x11(%ebp),%eax
 466:	50                   	push   %eax
 467:	6a 00                	push   $0x0
 469:	e8 77 01 00 00       	call   5e5 <read>
 46e:	83 c4 10             	add    $0x10,%esp
 471:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 478:	7e 33                	jle    4ad <gets+0x5e>
      break;
    buf[i++] = c;
 47a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47d:	8d 50 01             	lea    0x1(%eax),%edx
 480:	89 55 f4             	mov    %edx,-0xc(%ebp)
 483:	89 c2                	mov    %eax,%edx
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	01 c2                	add    %eax,%edx
 48a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 490:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 494:	3c 0a                	cmp    $0xa,%al
 496:	74 16                	je     4ae <gets+0x5f>
 498:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 49c:	3c 0d                	cmp    $0xd,%al
 49e:	74 0e                	je     4ae <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a3:	83 c0 01             	add    $0x1,%eax
 4a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4a9:	7c b3                	jl     45e <gets+0xf>
 4ab:	eb 01                	jmp    4ae <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4ad:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
 4b4:	01 d0                	add    %edx,%eax
 4b6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4bc:	c9                   	leave  
 4bd:	c3                   	ret    

000004be <stat>:

int
stat(char *n, struct stat *st)
{
 4be:	55                   	push   %ebp
 4bf:	89 e5                	mov    %esp,%ebp
 4c1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c4:	83 ec 08             	sub    $0x8,%esp
 4c7:	6a 00                	push   $0x0
 4c9:	ff 75 08             	pushl  0x8(%ebp)
 4cc:	e8 3c 01 00 00       	call   60d <open>
 4d1:	83 c4 10             	add    $0x10,%esp
 4d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4db:	79 07                	jns    4e4 <stat+0x26>
    return -1;
 4dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e2:	eb 25                	jmp    509 <stat+0x4b>
  r = fstat(fd, st);
 4e4:	83 ec 08             	sub    $0x8,%esp
 4e7:	ff 75 0c             	pushl  0xc(%ebp)
 4ea:	ff 75 f4             	pushl  -0xc(%ebp)
 4ed:	e8 33 01 00 00       	call   625 <fstat>
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4f8:	83 ec 0c             	sub    $0xc,%esp
 4fb:	ff 75 f4             	pushl  -0xc(%ebp)
 4fe:	e8 f2 00 00 00       	call   5f5 <close>
 503:	83 c4 10             	add    $0x10,%esp
  return r;
 506:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 509:	c9                   	leave  
 50a:	c3                   	ret    

0000050b <atoi>:

int
atoi(const char *s)
{
 50b:	55                   	push   %ebp
 50c:	89 e5                	mov    %esp,%ebp
 50e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 511:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 518:	eb 25                	jmp    53f <atoi+0x34>
    n = n*10 + *s++ - '0';
 51a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 51d:	89 d0                	mov    %edx,%eax
 51f:	c1 e0 02             	shl    $0x2,%eax
 522:	01 d0                	add    %edx,%eax
 524:	01 c0                	add    %eax,%eax
 526:	89 c1                	mov    %eax,%ecx
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	8d 50 01             	lea    0x1(%eax),%edx
 52e:	89 55 08             	mov    %edx,0x8(%ebp)
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	0f be c0             	movsbl %al,%eax
 537:	01 c8                	add    %ecx,%eax
 539:	83 e8 30             	sub    $0x30,%eax
 53c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 53f:	8b 45 08             	mov    0x8(%ebp),%eax
 542:	0f b6 00             	movzbl (%eax),%eax
 545:	3c 2f                	cmp    $0x2f,%al
 547:	7e 0a                	jle    553 <atoi+0x48>
 549:	8b 45 08             	mov    0x8(%ebp),%eax
 54c:	0f b6 00             	movzbl (%eax),%eax
 54f:	3c 39                	cmp    $0x39,%al
 551:	7e c7                	jle    51a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 553:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 556:	c9                   	leave  
 557:	c3                   	ret    

00000558 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 558:	55                   	push   %ebp
 559:	89 e5                	mov    %esp,%ebp
 55b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 55e:	8b 45 08             	mov    0x8(%ebp),%eax
 561:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 564:	8b 45 0c             	mov    0xc(%ebp),%eax
 567:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 56a:	eb 17                	jmp    583 <memmove+0x2b>
    *dst++ = *src++;
 56c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 56f:	8d 50 01             	lea    0x1(%eax),%edx
 572:	89 55 fc             	mov    %edx,-0x4(%ebp)
 575:	8b 55 f8             	mov    -0x8(%ebp),%edx
 578:	8d 4a 01             	lea    0x1(%edx),%ecx
 57b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 57e:	0f b6 12             	movzbl (%edx),%edx
 581:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 583:	8b 45 10             	mov    0x10(%ebp),%eax
 586:	8d 50 ff             	lea    -0x1(%eax),%edx
 589:	89 55 10             	mov    %edx,0x10(%ebp)
 58c:	85 c0                	test   %eax,%eax
 58e:	7f dc                	jg     56c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 590:	8b 45 08             	mov    0x8(%ebp),%eax
}
 593:	c9                   	leave  
 594:	c3                   	ret    

00000595 <restorer>:
 595:	83 c4 0c             	add    $0xc,%esp
 598:	5a                   	pop    %edx
 599:	59                   	pop    %ecx
 59a:	58                   	pop    %eax
 59b:	c3                   	ret    

0000059c <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int,siginfo_t))
{
 59c:	55                   	push   %ebp
 59d:	89 e5                	mov    %esp,%ebp
 59f:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 5a2:	83 ec 0c             	sub    $0xc,%esp
 5a5:	68 95 05 00 00       	push   $0x595
 5aa:	e8 ce 00 00 00       	call   67d <signal_restorer>
 5af:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 5b2:	83 ec 08             	sub    $0x8,%esp
 5b5:	ff 75 0c             	pushl  0xc(%ebp)
 5b8:	ff 75 08             	pushl  0x8(%ebp)
 5bb:	e8 b5 00 00 00       	call   675 <signal_register>
 5c0:	83 c4 10             	add    $0x10,%esp
}
 5c3:	c9                   	leave  
 5c4:	c3                   	ret    

000005c5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5c5:	b8 01 00 00 00       	mov    $0x1,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <exit>:
SYSCALL(exit)
 5cd:	b8 02 00 00 00       	mov    $0x2,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <wait>:
SYSCALL(wait)
 5d5:	b8 03 00 00 00       	mov    $0x3,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <pipe>:
SYSCALL(pipe)
 5dd:	b8 04 00 00 00       	mov    $0x4,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <read>:
SYSCALL(read)
 5e5:	b8 05 00 00 00       	mov    $0x5,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <write>:
SYSCALL(write)
 5ed:	b8 10 00 00 00       	mov    $0x10,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <close>:
SYSCALL(close)
 5f5:	b8 15 00 00 00       	mov    $0x15,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <kill>:
SYSCALL(kill)
 5fd:	b8 06 00 00 00       	mov    $0x6,%eax
 602:	cd 40                	int    $0x40
 604:	c3                   	ret    

00000605 <exec>:
SYSCALL(exec)
 605:	b8 07 00 00 00       	mov    $0x7,%eax
 60a:	cd 40                	int    $0x40
 60c:	c3                   	ret    

0000060d <open>:
SYSCALL(open)
 60d:	b8 0f 00 00 00       	mov    $0xf,%eax
 612:	cd 40                	int    $0x40
 614:	c3                   	ret    

00000615 <mknod>:
SYSCALL(mknod)
 615:	b8 11 00 00 00       	mov    $0x11,%eax
 61a:	cd 40                	int    $0x40
 61c:	c3                   	ret    

0000061d <unlink>:
SYSCALL(unlink)
 61d:	b8 12 00 00 00       	mov    $0x12,%eax
 622:	cd 40                	int    $0x40
 624:	c3                   	ret    

00000625 <fstat>:
SYSCALL(fstat)
 625:	b8 08 00 00 00       	mov    $0x8,%eax
 62a:	cd 40                	int    $0x40
 62c:	c3                   	ret    

0000062d <link>:
SYSCALL(link)
 62d:	b8 13 00 00 00       	mov    $0x13,%eax
 632:	cd 40                	int    $0x40
 634:	c3                   	ret    

00000635 <mkdir>:
SYSCALL(mkdir)
 635:	b8 14 00 00 00       	mov    $0x14,%eax
 63a:	cd 40                	int    $0x40
 63c:	c3                   	ret    

0000063d <chdir>:
SYSCALL(chdir)
 63d:	b8 09 00 00 00       	mov    $0x9,%eax
 642:	cd 40                	int    $0x40
 644:	c3                   	ret    

00000645 <dup>:
SYSCALL(dup)
 645:	b8 0a 00 00 00       	mov    $0xa,%eax
 64a:	cd 40                	int    $0x40
 64c:	c3                   	ret    

0000064d <getpid>:
SYSCALL(getpid)
 64d:	b8 0b 00 00 00       	mov    $0xb,%eax
 652:	cd 40                	int    $0x40
 654:	c3                   	ret    

00000655 <sbrk>:
SYSCALL(sbrk)
 655:	b8 0c 00 00 00       	mov    $0xc,%eax
 65a:	cd 40                	int    $0x40
 65c:	c3                   	ret    

0000065d <sleep>:
SYSCALL(sleep)
 65d:	b8 0d 00 00 00       	mov    $0xd,%eax
 662:	cd 40                	int    $0x40
 664:	c3                   	ret    

00000665 <uptime>:
SYSCALL(uptime)
 665:	b8 0e 00 00 00       	mov    $0xe,%eax
 66a:	cd 40                	int    $0x40
 66c:	c3                   	ret    

0000066d <halt>:
SYSCALL(halt)
 66d:	b8 16 00 00 00       	mov    $0x16,%eax
 672:	cd 40                	int    $0x40
 674:	c3                   	ret    

00000675 <signal_register>:
SYSCALL(signal_register)
 675:	b8 17 00 00 00       	mov    $0x17,%eax
 67a:	cd 40                	int    $0x40
 67c:	c3                   	ret    

0000067d <signal_restorer>:
SYSCALL(signal_restorer)
 67d:	b8 18 00 00 00       	mov    $0x18,%eax
 682:	cd 40                	int    $0x40
 684:	c3                   	ret    

00000685 <mprotect>:
SYSCALL(mprotect)
 685:	b8 19 00 00 00       	mov    $0x19,%eax
 68a:	cd 40                	int    $0x40
 68c:	c3                   	ret    

0000068d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 68d:	55                   	push   %ebp
 68e:	89 e5                	mov    %esp,%ebp
 690:	83 ec 18             	sub    $0x18,%esp
 693:	8b 45 0c             	mov    0xc(%ebp),%eax
 696:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 699:	83 ec 04             	sub    $0x4,%esp
 69c:	6a 01                	push   $0x1
 69e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6a1:	50                   	push   %eax
 6a2:	ff 75 08             	pushl  0x8(%ebp)
 6a5:	e8 43 ff ff ff       	call   5ed <write>
 6aa:	83 c4 10             	add    $0x10,%esp
}
 6ad:	90                   	nop
 6ae:	c9                   	leave  
 6af:	c3                   	ret    

000006b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	53                   	push   %ebx
 6b4:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6be:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6c2:	74 17                	je     6db <printint+0x2b>
 6c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6c8:	79 11                	jns    6db <printint+0x2b>
    neg = 1;
 6ca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d4:	f7 d8                	neg    %eax
 6d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6d9:	eb 06                	jmp    6e1 <printint+0x31>
  } else {
    x = xx;
 6db:	8b 45 0c             	mov    0xc(%ebp),%eax
 6de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6e8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6eb:	8d 41 01             	lea    0x1(%ecx),%eax
 6ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6f7:	ba 00 00 00 00       	mov    $0x0,%edx
 6fc:	f7 f3                	div    %ebx
 6fe:	89 d0                	mov    %edx,%eax
 700:	0f b6 80 2c 0e 00 00 	movzbl 0xe2c(%eax),%eax
 707:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 70b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 70e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 711:	ba 00 00 00 00       	mov    $0x0,%edx
 716:	f7 f3                	div    %ebx
 718:	89 45 ec             	mov    %eax,-0x14(%ebp)
 71b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 71f:	75 c7                	jne    6e8 <printint+0x38>
  if(neg)
 721:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 725:	74 2d                	je     754 <printint+0xa4>
    buf[i++] = '-';
 727:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72a:	8d 50 01             	lea    0x1(%eax),%edx
 72d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 730:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 735:	eb 1d                	jmp    754 <printint+0xa4>
    putc(fd, buf[i]);
 737:	8d 55 dc             	lea    -0x24(%ebp),%edx
 73a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73d:	01 d0                	add    %edx,%eax
 73f:	0f b6 00             	movzbl (%eax),%eax
 742:	0f be c0             	movsbl %al,%eax
 745:	83 ec 08             	sub    $0x8,%esp
 748:	50                   	push   %eax
 749:	ff 75 08             	pushl  0x8(%ebp)
 74c:	e8 3c ff ff ff       	call   68d <putc>
 751:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 754:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 75c:	79 d9                	jns    737 <printint+0x87>
    putc(fd, buf[i]);
}
 75e:	90                   	nop
 75f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 762:	c9                   	leave  
 763:	c3                   	ret    

00000764 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 764:	55                   	push   %ebp
 765:	89 e5                	mov    %esp,%ebp
 767:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 76a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 771:	8d 45 0c             	lea    0xc(%ebp),%eax
 774:	83 c0 04             	add    $0x4,%eax
 777:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 77a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 781:	e9 59 01 00 00       	jmp    8df <printf+0x17b>
    c = fmt[i] & 0xff;
 786:	8b 55 0c             	mov    0xc(%ebp),%edx
 789:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78c:	01 d0                	add    %edx,%eax
 78e:	0f b6 00             	movzbl (%eax),%eax
 791:	0f be c0             	movsbl %al,%eax
 794:	25 ff 00 00 00       	and    $0xff,%eax
 799:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 79c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7a0:	75 2c                	jne    7ce <printf+0x6a>
      if(c == '%'){
 7a2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7a6:	75 0c                	jne    7b4 <printf+0x50>
        state = '%';
 7a8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7af:	e9 27 01 00 00       	jmp    8db <printf+0x177>
      } else {
        putc(fd, c);
 7b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b7:	0f be c0             	movsbl %al,%eax
 7ba:	83 ec 08             	sub    $0x8,%esp
 7bd:	50                   	push   %eax
 7be:	ff 75 08             	pushl  0x8(%ebp)
 7c1:	e8 c7 fe ff ff       	call   68d <putc>
 7c6:	83 c4 10             	add    $0x10,%esp
 7c9:	e9 0d 01 00 00       	jmp    8db <printf+0x177>
      }
    } else if(state == '%'){
 7ce:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7d2:	0f 85 03 01 00 00    	jne    8db <printf+0x177>
      if(c == 'd'){
 7d8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7dc:	75 1e                	jne    7fc <printf+0x98>
        printint(fd, *ap, 10, 1);
 7de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e1:	8b 00                	mov    (%eax),%eax
 7e3:	6a 01                	push   $0x1
 7e5:	6a 0a                	push   $0xa
 7e7:	50                   	push   %eax
 7e8:	ff 75 08             	pushl  0x8(%ebp)
 7eb:	e8 c0 fe ff ff       	call   6b0 <printint>
 7f0:	83 c4 10             	add    $0x10,%esp
        ap++;
 7f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7f7:	e9 d8 00 00 00       	jmp    8d4 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7fc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 800:	74 06                	je     808 <printf+0xa4>
 802:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 806:	75 1e                	jne    826 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 808:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80b:	8b 00                	mov    (%eax),%eax
 80d:	6a 00                	push   $0x0
 80f:	6a 10                	push   $0x10
 811:	50                   	push   %eax
 812:	ff 75 08             	pushl  0x8(%ebp)
 815:	e8 96 fe ff ff       	call   6b0 <printint>
 81a:	83 c4 10             	add    $0x10,%esp
        ap++;
 81d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 821:	e9 ae 00 00 00       	jmp    8d4 <printf+0x170>
      } else if(c == 's'){
 826:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 82a:	75 43                	jne    86f <printf+0x10b>
        s = (char*)*ap;
 82c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 82f:	8b 00                	mov    (%eax),%eax
 831:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 834:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 838:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83c:	75 25                	jne    863 <printf+0xff>
          s = "(null)";
 83e:	c7 45 f4 64 0b 00 00 	movl   $0xb64,-0xc(%ebp)
        while(*s != 0){
 845:	eb 1c                	jmp    863 <printf+0xff>
          putc(fd, *s);
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	0f b6 00             	movzbl (%eax),%eax
 84d:	0f be c0             	movsbl %al,%eax
 850:	83 ec 08             	sub    $0x8,%esp
 853:	50                   	push   %eax
 854:	ff 75 08             	pushl  0x8(%ebp)
 857:	e8 31 fe ff ff       	call   68d <putc>
 85c:	83 c4 10             	add    $0x10,%esp
          s++;
 85f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	0f b6 00             	movzbl (%eax),%eax
 869:	84 c0                	test   %al,%al
 86b:	75 da                	jne    847 <printf+0xe3>
 86d:	eb 65                	jmp    8d4 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 86f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 873:	75 1d                	jne    892 <printf+0x12e>
        putc(fd, *ap);
 875:	8b 45 e8             	mov    -0x18(%ebp),%eax
 878:	8b 00                	mov    (%eax),%eax
 87a:	0f be c0             	movsbl %al,%eax
 87d:	83 ec 08             	sub    $0x8,%esp
 880:	50                   	push   %eax
 881:	ff 75 08             	pushl  0x8(%ebp)
 884:	e8 04 fe ff ff       	call   68d <putc>
 889:	83 c4 10             	add    $0x10,%esp
        ap++;
 88c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 890:	eb 42                	jmp    8d4 <printf+0x170>
      } else if(c == '%'){
 892:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 896:	75 17                	jne    8af <printf+0x14b>
        putc(fd, c);
 898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 89b:	0f be c0             	movsbl %al,%eax
 89e:	83 ec 08             	sub    $0x8,%esp
 8a1:	50                   	push   %eax
 8a2:	ff 75 08             	pushl  0x8(%ebp)
 8a5:	e8 e3 fd ff ff       	call   68d <putc>
 8aa:	83 c4 10             	add    $0x10,%esp
 8ad:	eb 25                	jmp    8d4 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8af:	83 ec 08             	sub    $0x8,%esp
 8b2:	6a 25                	push   $0x25
 8b4:	ff 75 08             	pushl  0x8(%ebp)
 8b7:	e8 d1 fd ff ff       	call   68d <putc>
 8bc:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c2:	0f be c0             	movsbl %al,%eax
 8c5:	83 ec 08             	sub    $0x8,%esp
 8c8:	50                   	push   %eax
 8c9:	ff 75 08             	pushl  0x8(%ebp)
 8cc:	e8 bc fd ff ff       	call   68d <putc>
 8d1:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8db:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8df:	8b 55 0c             	mov    0xc(%ebp),%edx
 8e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e5:	01 d0                	add    %edx,%eax
 8e7:	0f b6 00             	movzbl (%eax),%eax
 8ea:	84 c0                	test   %al,%al
 8ec:	0f 85 94 fe ff ff    	jne    786 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8f2:	90                   	nop
 8f3:	c9                   	leave  
 8f4:	c3                   	ret    

000008f5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f5:	55                   	push   %ebp
 8f6:	89 e5                	mov    %esp,%ebp
 8f8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8fb:	8b 45 08             	mov    0x8(%ebp),%eax
 8fe:	83 e8 08             	sub    $0x8,%eax
 901:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 904:	a1 58 0e 00 00       	mov    0xe58,%eax
 909:	89 45 fc             	mov    %eax,-0x4(%ebp)
 90c:	eb 24                	jmp    932 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 911:	8b 00                	mov    (%eax),%eax
 913:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 916:	77 12                	ja     92a <free+0x35>
 918:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 91e:	77 24                	ja     944 <free+0x4f>
 920:	8b 45 fc             	mov    -0x4(%ebp),%eax
 923:	8b 00                	mov    (%eax),%eax
 925:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 928:	77 1a                	ja     944 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92d:	8b 00                	mov    (%eax),%eax
 92f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 932:	8b 45 f8             	mov    -0x8(%ebp),%eax
 935:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 938:	76 d4                	jbe    90e <free+0x19>
 93a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93d:	8b 00                	mov    (%eax),%eax
 93f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 942:	76 ca                	jbe    90e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 944:	8b 45 f8             	mov    -0x8(%ebp),%eax
 947:	8b 40 04             	mov    0x4(%eax),%eax
 94a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 951:	8b 45 f8             	mov    -0x8(%ebp),%eax
 954:	01 c2                	add    %eax,%edx
 956:	8b 45 fc             	mov    -0x4(%ebp),%eax
 959:	8b 00                	mov    (%eax),%eax
 95b:	39 c2                	cmp    %eax,%edx
 95d:	75 24                	jne    983 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 95f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 962:	8b 50 04             	mov    0x4(%eax),%edx
 965:	8b 45 fc             	mov    -0x4(%ebp),%eax
 968:	8b 00                	mov    (%eax),%eax
 96a:	8b 40 04             	mov    0x4(%eax),%eax
 96d:	01 c2                	add    %eax,%edx
 96f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 972:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 975:	8b 45 fc             	mov    -0x4(%ebp),%eax
 978:	8b 00                	mov    (%eax),%eax
 97a:	8b 10                	mov    (%eax),%edx
 97c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97f:	89 10                	mov    %edx,(%eax)
 981:	eb 0a                	jmp    98d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 983:	8b 45 fc             	mov    -0x4(%ebp),%eax
 986:	8b 10                	mov    (%eax),%edx
 988:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 98d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 990:	8b 40 04             	mov    0x4(%eax),%eax
 993:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 99a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99d:	01 d0                	add    %edx,%eax
 99f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9a2:	75 20                	jne    9c4 <free+0xcf>
    p->s.size += bp->s.size;
 9a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a7:	8b 50 04             	mov    0x4(%eax),%edx
 9aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ad:	8b 40 04             	mov    0x4(%eax),%eax
 9b0:	01 c2                	add    %eax,%edx
 9b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9bb:	8b 10                	mov    (%eax),%edx
 9bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c0:	89 10                	mov    %edx,(%eax)
 9c2:	eb 08                	jmp    9cc <free+0xd7>
  } else
    p->s.ptr = bp;
 9c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9ca:	89 10                	mov    %edx,(%eax)
  freep = p;
 9cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cf:	a3 58 0e 00 00       	mov    %eax,0xe58
}
 9d4:	90                   	nop
 9d5:	c9                   	leave  
 9d6:	c3                   	ret    

000009d7 <morecore>:

static Header*
morecore(uint nu)
{
 9d7:	55                   	push   %ebp
 9d8:	89 e5                	mov    %esp,%ebp
 9da:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9dd:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9e4:	77 07                	ja     9ed <morecore+0x16>
    nu = 4096;
 9e6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9ed:	8b 45 08             	mov    0x8(%ebp),%eax
 9f0:	c1 e0 03             	shl    $0x3,%eax
 9f3:	83 ec 0c             	sub    $0xc,%esp
 9f6:	50                   	push   %eax
 9f7:	e8 59 fc ff ff       	call   655 <sbrk>
 9fc:	83 c4 10             	add    $0x10,%esp
 9ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a02:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a06:	75 07                	jne    a0f <morecore+0x38>
    return 0;
 a08:	b8 00 00 00 00       	mov    $0x0,%eax
 a0d:	eb 26                	jmp    a35 <morecore+0x5e>
  hp = (Header*)p;
 a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a18:	8b 55 08             	mov    0x8(%ebp),%edx
 a1b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a21:	83 c0 08             	add    $0x8,%eax
 a24:	83 ec 0c             	sub    $0xc,%esp
 a27:	50                   	push   %eax
 a28:	e8 c8 fe ff ff       	call   8f5 <free>
 a2d:	83 c4 10             	add    $0x10,%esp
  return freep;
 a30:	a1 58 0e 00 00       	mov    0xe58,%eax
}
 a35:	c9                   	leave  
 a36:	c3                   	ret    

00000a37 <malloc>:

void*
malloc(uint nbytes)
{
 a37:	55                   	push   %ebp
 a38:	89 e5                	mov    %esp,%ebp
 a3a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a3d:	8b 45 08             	mov    0x8(%ebp),%eax
 a40:	83 c0 07             	add    $0x7,%eax
 a43:	c1 e8 03             	shr    $0x3,%eax
 a46:	83 c0 01             	add    $0x1,%eax
 a49:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a4c:	a1 58 0e 00 00       	mov    0xe58,%eax
 a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a58:	75 23                	jne    a7d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a5a:	c7 45 f0 50 0e 00 00 	movl   $0xe50,-0x10(%ebp)
 a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a64:	a3 58 0e 00 00       	mov    %eax,0xe58
 a69:	a1 58 0e 00 00       	mov    0xe58,%eax
 a6e:	a3 50 0e 00 00       	mov    %eax,0xe50
    base.s.size = 0;
 a73:	c7 05 54 0e 00 00 00 	movl   $0x0,0xe54
 a7a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a80:	8b 00                	mov    (%eax),%eax
 a82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a88:	8b 40 04             	mov    0x4(%eax),%eax
 a8b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a8e:	72 4d                	jb     add <malloc+0xa6>
      if(p->s.size == nunits)
 a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a93:	8b 40 04             	mov    0x4(%eax),%eax
 a96:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a99:	75 0c                	jne    aa7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9e:	8b 10                	mov    (%eax),%edx
 aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa3:	89 10                	mov    %edx,(%eax)
 aa5:	eb 26                	jmp    acd <malloc+0x96>
      else {
        p->s.size -= nunits;
 aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aaa:	8b 40 04             	mov    0x4(%eax),%eax
 aad:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ab0:	89 c2                	mov    %eax,%edx
 ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abb:	8b 40 04             	mov    0x4(%eax),%eax
 abe:	c1 e0 03             	shl    $0x3,%eax
 ac1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aca:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad0:	a3 58 0e 00 00       	mov    %eax,0xe58
      return (void*)(p + 1);
 ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad8:	83 c0 08             	add    $0x8,%eax
 adb:	eb 3b                	jmp    b18 <malloc+0xe1>
    }
    if(p == freep)
 add:	a1 58 0e 00 00       	mov    0xe58,%eax
 ae2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ae5:	75 1e                	jne    b05 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 ae7:	83 ec 0c             	sub    $0xc,%esp
 aea:	ff 75 ec             	pushl  -0x14(%ebp)
 aed:	e8 e5 fe ff ff       	call   9d7 <morecore>
 af2:	83 c4 10             	add    $0x10,%esp
 af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 af8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 afc:	75 07                	jne    b05 <malloc+0xce>
        return 0;
 afe:	b8 00 00 00 00       	mov    $0x0,%eax
 b03:	eb 13                	jmp    b18 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b08:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0e:	8b 00                	mov    (%eax),%eax
 b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b13:	e9 6d ff ff ff       	jmp    a85 <malloc+0x4e>
}
 b18:	c9                   	leave  
 b19:	c3                   	ret    
