
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
  68:	68 48 0e 00 00       	push   $0xe48
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
  9a:	05 48 0e 00 00       	add    $0xe48,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 57 03 00 00       	call   402 <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 48 0e 00 00       	mov    $0xe48,%eax
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
  e3:	68 22 0b 00 00       	push   $0xb22
  e8:	6a 02                	push   $0x2
  ea:	e8 7d 06 00 00       	call   76c <printf>
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
 116:	68 36 0b 00 00       	push   $0xb36
 11b:	6a 02                	push   $0x2
 11d:	e8 4a 06 00 00       	call   76c <printf>
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
 179:	68 4a 0b 00 00       	push   $0xb4a
 17e:	6a 01                	push   $0x1
 180:	e8 e7 05 00 00       	call   76c <printf>
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
 1a8:	68 57 0b 00 00       	push   $0xb57
 1ad:	6a 01                	push   $0x1
 1af:	e8 b8 05 00 00       	call   76c <printf>
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
 25c:	68 36 0b 00 00       	push   $0xb36
 261:	6a 01                	push   $0x1
 263:	e8 04 05 00 00       	call   76c <printf>
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
 29c:	68 4a 0b 00 00       	push   $0xb4a
 2a1:	6a 01                	push   $0x1
 2a3:	e8 c4 04 00 00       	call   76c <printf>
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
 2fe:	68 6a 0b 00 00       	push   $0xb6a
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

int signal(int signum, void(*handler)(int))
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

0000068d <cowfork>:
SYSCALL(cowfork)
 68d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 692:	cd 40                	int    $0x40
 694:	c3                   	ret    

00000695 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 695:	55                   	push   %ebp
 696:	89 e5                	mov    %esp,%ebp
 698:	83 ec 18             	sub    $0x18,%esp
 69b:	8b 45 0c             	mov    0xc(%ebp),%eax
 69e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6a1:	83 ec 04             	sub    $0x4,%esp
 6a4:	6a 01                	push   $0x1
 6a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6a9:	50                   	push   %eax
 6aa:	ff 75 08             	pushl  0x8(%ebp)
 6ad:	e8 3b ff ff ff       	call   5ed <write>
 6b2:	83 c4 10             	add    $0x10,%esp
}
 6b5:	90                   	nop
 6b6:	c9                   	leave  
 6b7:	c3                   	ret    

000006b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	53                   	push   %ebx
 6bc:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6c6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6ca:	74 17                	je     6e3 <printint+0x2b>
 6cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6d0:	79 11                	jns    6e3 <printint+0x2b>
    neg = 1;
 6d2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 6dc:	f7 d8                	neg    %eax
 6de:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6e1:	eb 06                	jmp    6e9 <printint+0x31>
  } else {
    x = xx;
 6e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6f0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6f3:	8d 41 01             	lea    0x1(%ecx),%eax
 6f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ff:	ba 00 00 00 00       	mov    $0x0,%edx
 704:	f7 f3                	div    %ebx
 706:	89 d0                	mov    %edx,%eax
 708:	0f b6 80 34 0e 00 00 	movzbl 0xe34(%eax),%eax
 70f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 713:	8b 5d 10             	mov    0x10(%ebp),%ebx
 716:	8b 45 ec             	mov    -0x14(%ebp),%eax
 719:	ba 00 00 00 00       	mov    $0x0,%edx
 71e:	f7 f3                	div    %ebx
 720:	89 45 ec             	mov    %eax,-0x14(%ebp)
 723:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 727:	75 c7                	jne    6f0 <printint+0x38>
  if(neg)
 729:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 72d:	74 2d                	je     75c <printint+0xa4>
    buf[i++] = '-';
 72f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 732:	8d 50 01             	lea    0x1(%eax),%edx
 735:	89 55 f4             	mov    %edx,-0xc(%ebp)
 738:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 73d:	eb 1d                	jmp    75c <printint+0xa4>
    putc(fd, buf[i]);
 73f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 742:	8b 45 f4             	mov    -0xc(%ebp),%eax
 745:	01 d0                	add    %edx,%eax
 747:	0f b6 00             	movzbl (%eax),%eax
 74a:	0f be c0             	movsbl %al,%eax
 74d:	83 ec 08             	sub    $0x8,%esp
 750:	50                   	push   %eax
 751:	ff 75 08             	pushl  0x8(%ebp)
 754:	e8 3c ff ff ff       	call   695 <putc>
 759:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 75c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 760:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 764:	79 d9                	jns    73f <printint+0x87>
    putc(fd, buf[i]);
}
 766:	90                   	nop
 767:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 76a:	c9                   	leave  
 76b:	c3                   	ret    

0000076c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 76c:	55                   	push   %ebp
 76d:	89 e5                	mov    %esp,%ebp
 76f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 772:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 779:	8d 45 0c             	lea    0xc(%ebp),%eax
 77c:	83 c0 04             	add    $0x4,%eax
 77f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 782:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 789:	e9 59 01 00 00       	jmp    8e7 <printf+0x17b>
    c = fmt[i] & 0xff;
 78e:	8b 55 0c             	mov    0xc(%ebp),%edx
 791:	8b 45 f0             	mov    -0x10(%ebp),%eax
 794:	01 d0                	add    %edx,%eax
 796:	0f b6 00             	movzbl (%eax),%eax
 799:	0f be c0             	movsbl %al,%eax
 79c:	25 ff 00 00 00       	and    $0xff,%eax
 7a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7a8:	75 2c                	jne    7d6 <printf+0x6a>
      if(c == '%'){
 7aa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ae:	75 0c                	jne    7bc <printf+0x50>
        state = '%';
 7b0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7b7:	e9 27 01 00 00       	jmp    8e3 <printf+0x177>
      } else {
        putc(fd, c);
 7bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7bf:	0f be c0             	movsbl %al,%eax
 7c2:	83 ec 08             	sub    $0x8,%esp
 7c5:	50                   	push   %eax
 7c6:	ff 75 08             	pushl  0x8(%ebp)
 7c9:	e8 c7 fe ff ff       	call   695 <putc>
 7ce:	83 c4 10             	add    $0x10,%esp
 7d1:	e9 0d 01 00 00       	jmp    8e3 <printf+0x177>
      }
    } else if(state == '%'){
 7d6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7da:	0f 85 03 01 00 00    	jne    8e3 <printf+0x177>
      if(c == 'd'){
 7e0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7e4:	75 1e                	jne    804 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e9:	8b 00                	mov    (%eax),%eax
 7eb:	6a 01                	push   $0x1
 7ed:	6a 0a                	push   $0xa
 7ef:	50                   	push   %eax
 7f0:	ff 75 08             	pushl  0x8(%ebp)
 7f3:	e8 c0 fe ff ff       	call   6b8 <printint>
 7f8:	83 c4 10             	add    $0x10,%esp
        ap++;
 7fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ff:	e9 d8 00 00 00       	jmp    8dc <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 804:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 808:	74 06                	je     810 <printf+0xa4>
 80a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 80e:	75 1e                	jne    82e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 810:	8b 45 e8             	mov    -0x18(%ebp),%eax
 813:	8b 00                	mov    (%eax),%eax
 815:	6a 00                	push   $0x0
 817:	6a 10                	push   $0x10
 819:	50                   	push   %eax
 81a:	ff 75 08             	pushl  0x8(%ebp)
 81d:	e8 96 fe ff ff       	call   6b8 <printint>
 822:	83 c4 10             	add    $0x10,%esp
        ap++;
 825:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 829:	e9 ae 00 00 00       	jmp    8dc <printf+0x170>
      } else if(c == 's'){
 82e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 832:	75 43                	jne    877 <printf+0x10b>
        s = (char*)*ap;
 834:	8b 45 e8             	mov    -0x18(%ebp),%eax
 837:	8b 00                	mov    (%eax),%eax
 839:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 83c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 840:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 844:	75 25                	jne    86b <printf+0xff>
          s = "(null)";
 846:	c7 45 f4 6c 0b 00 00 	movl   $0xb6c,-0xc(%ebp)
        while(*s != 0){
 84d:	eb 1c                	jmp    86b <printf+0xff>
          putc(fd, *s);
 84f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 852:	0f b6 00             	movzbl (%eax),%eax
 855:	0f be c0             	movsbl %al,%eax
 858:	83 ec 08             	sub    $0x8,%esp
 85b:	50                   	push   %eax
 85c:	ff 75 08             	pushl  0x8(%ebp)
 85f:	e8 31 fe ff ff       	call   695 <putc>
 864:	83 c4 10             	add    $0x10,%esp
          s++;
 867:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	0f b6 00             	movzbl (%eax),%eax
 871:	84 c0                	test   %al,%al
 873:	75 da                	jne    84f <printf+0xe3>
 875:	eb 65                	jmp    8dc <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 877:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 87b:	75 1d                	jne    89a <printf+0x12e>
        putc(fd, *ap);
 87d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 880:	8b 00                	mov    (%eax),%eax
 882:	0f be c0             	movsbl %al,%eax
 885:	83 ec 08             	sub    $0x8,%esp
 888:	50                   	push   %eax
 889:	ff 75 08             	pushl  0x8(%ebp)
 88c:	e8 04 fe ff ff       	call   695 <putc>
 891:	83 c4 10             	add    $0x10,%esp
        ap++;
 894:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 898:	eb 42                	jmp    8dc <printf+0x170>
      } else if(c == '%'){
 89a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 89e:	75 17                	jne    8b7 <printf+0x14b>
        putc(fd, c);
 8a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a3:	0f be c0             	movsbl %al,%eax
 8a6:	83 ec 08             	sub    $0x8,%esp
 8a9:	50                   	push   %eax
 8aa:	ff 75 08             	pushl  0x8(%ebp)
 8ad:	e8 e3 fd ff ff       	call   695 <putc>
 8b2:	83 c4 10             	add    $0x10,%esp
 8b5:	eb 25                	jmp    8dc <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8b7:	83 ec 08             	sub    $0x8,%esp
 8ba:	6a 25                	push   $0x25
 8bc:	ff 75 08             	pushl  0x8(%ebp)
 8bf:	e8 d1 fd ff ff       	call   695 <putc>
 8c4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8ca:	0f be c0             	movsbl %al,%eax
 8cd:	83 ec 08             	sub    $0x8,%esp
 8d0:	50                   	push   %eax
 8d1:	ff 75 08             	pushl  0x8(%ebp)
 8d4:	e8 bc fd ff ff       	call   695 <putc>
 8d9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8e3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8e7:	8b 55 0c             	mov    0xc(%ebp),%edx
 8ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ed:	01 d0                	add    %edx,%eax
 8ef:	0f b6 00             	movzbl (%eax),%eax
 8f2:	84 c0                	test   %al,%al
 8f4:	0f 85 94 fe ff ff    	jne    78e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8fa:	90                   	nop
 8fb:	c9                   	leave  
 8fc:	c3                   	ret    

000008fd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fd:	55                   	push   %ebp
 8fe:	89 e5                	mov    %esp,%ebp
 900:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 903:	8b 45 08             	mov    0x8(%ebp),%eax
 906:	83 e8 08             	sub    $0x8,%eax
 909:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90c:	a1 60 0e 00 00       	mov    0xe60,%eax
 911:	89 45 fc             	mov    %eax,-0x4(%ebp)
 914:	eb 24                	jmp    93a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 916:	8b 45 fc             	mov    -0x4(%ebp),%eax
 919:	8b 00                	mov    (%eax),%eax
 91b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 91e:	77 12                	ja     932 <free+0x35>
 920:	8b 45 f8             	mov    -0x8(%ebp),%eax
 923:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 926:	77 24                	ja     94c <free+0x4f>
 928:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92b:	8b 00                	mov    (%eax),%eax
 92d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 930:	77 1a                	ja     94c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 932:	8b 45 fc             	mov    -0x4(%ebp),%eax
 935:	8b 00                	mov    (%eax),%eax
 937:	89 45 fc             	mov    %eax,-0x4(%ebp)
 93a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 940:	76 d4                	jbe    916 <free+0x19>
 942:	8b 45 fc             	mov    -0x4(%ebp),%eax
 945:	8b 00                	mov    (%eax),%eax
 947:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 94a:	76 ca                	jbe    916 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 94c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94f:	8b 40 04             	mov    0x4(%eax),%eax
 952:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 959:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95c:	01 c2                	add    %eax,%edx
 95e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 961:	8b 00                	mov    (%eax),%eax
 963:	39 c2                	cmp    %eax,%edx
 965:	75 24                	jne    98b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 967:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96a:	8b 50 04             	mov    0x4(%eax),%edx
 96d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 970:	8b 00                	mov    (%eax),%eax
 972:	8b 40 04             	mov    0x4(%eax),%eax
 975:	01 c2                	add    %eax,%edx
 977:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 97d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 980:	8b 00                	mov    (%eax),%eax
 982:	8b 10                	mov    (%eax),%edx
 984:	8b 45 f8             	mov    -0x8(%ebp),%eax
 987:	89 10                	mov    %edx,(%eax)
 989:	eb 0a                	jmp    995 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 98b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98e:	8b 10                	mov    (%eax),%edx
 990:	8b 45 f8             	mov    -0x8(%ebp),%eax
 993:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 995:	8b 45 fc             	mov    -0x4(%ebp),%eax
 998:	8b 40 04             	mov    0x4(%eax),%eax
 99b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a5:	01 d0                	add    %edx,%eax
 9a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9aa:	75 20                	jne    9cc <free+0xcf>
    p->s.size += bp->s.size;
 9ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9af:	8b 50 04             	mov    0x4(%eax),%edx
 9b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b5:	8b 40 04             	mov    0x4(%eax),%eax
 9b8:	01 c2                	add    %eax,%edx
 9ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c3:	8b 10                	mov    (%eax),%edx
 9c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c8:	89 10                	mov    %edx,(%eax)
 9ca:	eb 08                	jmp    9d4 <free+0xd7>
  } else
    p->s.ptr = bp;
 9cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9d2:	89 10                	mov    %edx,(%eax)
  freep = p;
 9d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d7:	a3 60 0e 00 00       	mov    %eax,0xe60
}
 9dc:	90                   	nop
 9dd:	c9                   	leave  
 9de:	c3                   	ret    

000009df <morecore>:

static Header*
morecore(uint nu)
{
 9df:	55                   	push   %ebp
 9e0:	89 e5                	mov    %esp,%ebp
 9e2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9e5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9ec:	77 07                	ja     9f5 <morecore+0x16>
    nu = 4096;
 9ee:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9f5:	8b 45 08             	mov    0x8(%ebp),%eax
 9f8:	c1 e0 03             	shl    $0x3,%eax
 9fb:	83 ec 0c             	sub    $0xc,%esp
 9fe:	50                   	push   %eax
 9ff:	e8 51 fc ff ff       	call   655 <sbrk>
 a04:	83 c4 10             	add    $0x10,%esp
 a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a0a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a0e:	75 07                	jne    a17 <morecore+0x38>
    return 0;
 a10:	b8 00 00 00 00       	mov    $0x0,%eax
 a15:	eb 26                	jmp    a3d <morecore+0x5e>
  hp = (Header*)p;
 a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a20:	8b 55 08             	mov    0x8(%ebp),%edx
 a23:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a29:	83 c0 08             	add    $0x8,%eax
 a2c:	83 ec 0c             	sub    $0xc,%esp
 a2f:	50                   	push   %eax
 a30:	e8 c8 fe ff ff       	call   8fd <free>
 a35:	83 c4 10             	add    $0x10,%esp
  return freep;
 a38:	a1 60 0e 00 00       	mov    0xe60,%eax
}
 a3d:	c9                   	leave  
 a3e:	c3                   	ret    

00000a3f <malloc>:

void*
malloc(uint nbytes)
{
 a3f:	55                   	push   %ebp
 a40:	89 e5                	mov    %esp,%ebp
 a42:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a45:	8b 45 08             	mov    0x8(%ebp),%eax
 a48:	83 c0 07             	add    $0x7,%eax
 a4b:	c1 e8 03             	shr    $0x3,%eax
 a4e:	83 c0 01             	add    $0x1,%eax
 a51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a54:	a1 60 0e 00 00       	mov    0xe60,%eax
 a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a60:	75 23                	jne    a85 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a62:	c7 45 f0 58 0e 00 00 	movl   $0xe58,-0x10(%ebp)
 a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6c:	a3 60 0e 00 00       	mov    %eax,0xe60
 a71:	a1 60 0e 00 00       	mov    0xe60,%eax
 a76:	a3 58 0e 00 00       	mov    %eax,0xe58
    base.s.size = 0;
 a7b:	c7 05 5c 0e 00 00 00 	movl   $0x0,0xe5c
 a82:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a88:	8b 00                	mov    (%eax),%eax
 a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a90:	8b 40 04             	mov    0x4(%eax),%eax
 a93:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a96:	72 4d                	jb     ae5 <malloc+0xa6>
      if(p->s.size == nunits)
 a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9b:	8b 40 04             	mov    0x4(%eax),%eax
 a9e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aa1:	75 0c                	jne    aaf <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa6:	8b 10                	mov    (%eax),%edx
 aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aab:	89 10                	mov    %edx,(%eax)
 aad:	eb 26                	jmp    ad5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab2:	8b 40 04             	mov    0x4(%eax),%eax
 ab5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ab8:	89 c2                	mov    %eax,%edx
 aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac3:	8b 40 04             	mov    0x4(%eax),%eax
 ac6:	c1 e0 03             	shl    $0x3,%eax
 ac9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acf:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ad2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad8:	a3 60 0e 00 00       	mov    %eax,0xe60
      return (void*)(p + 1);
 add:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae0:	83 c0 08             	add    $0x8,%eax
 ae3:	eb 3b                	jmp    b20 <malloc+0xe1>
    }
    if(p == freep)
 ae5:	a1 60 0e 00 00       	mov    0xe60,%eax
 aea:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aed:	75 1e                	jne    b0d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 aef:	83 ec 0c             	sub    $0xc,%esp
 af2:	ff 75 ec             	pushl  -0x14(%ebp)
 af5:	e8 e5 fe ff ff       	call   9df <morecore>
 afa:	83 c4 10             	add    $0x10,%esp
 afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b04:	75 07                	jne    b0d <malloc+0xce>
        return 0;
 b06:	b8 00 00 00 00       	mov    $0x0,%eax
 b0b:	eb 13                	jmp    b20 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b10:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b16:	8b 00                	mov    (%eax),%eax
 b18:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b1b:	e9 6d ff ff ff       	jmp    a8d <malloc+0x4e>
}
 b20:	c9                   	leave  
 b21:	c3                   	ret    
