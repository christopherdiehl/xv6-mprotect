
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d6 37 10 80       	mov    $0x801037d6,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 cc 87 10 80       	push   $0x801087cc
80100042:	68 80 c6 10 80       	push   $0x8010c680
80100047:	e8 3f 50 00 00       	call   8010508b <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 05 11 80 84 	movl   $0x80110584,0x80110590
80100056:	05 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 05 11 80 84 	movl   $0x80110584,0x80110594
80100060:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 05 11 80    	mov    0x80110594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 05 11 80 	movl   $0x80110584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 05 11 80       	mov    0x80110594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 05 11 80       	mov    %eax,0x80110594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 05 11 80       	mov    $0x80110584,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 80 c6 10 80       	push   $0x8010c680
801000c1:	e8 e7 4f 00 00       	call   801050ad <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 05 11 80       	mov    0x80110594,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->sector == sector){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 80 c6 10 80       	push   $0x8010c680
8010010c:	e8 03 50 00 00       	call   80105114 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 c6 10 80       	push   $0x8010c680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 44 4b 00 00       	call   80104c70 <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 05 11 80       	mov    0x80110590,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 80 c6 10 80       	push   $0x8010c680
80100188:	e8 87 4f 00 00       	call   80105114 <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 d3 87 10 80       	push   $0x801087d3
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, sector);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 85 26 00 00       	call   8010286c <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 e4 87 10 80       	push   $0x801087e4
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 44 26 00 00       	call   8010286c <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 eb 87 10 80       	push   $0x801087eb
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 c6 10 80       	push   $0x8010c680
80100255:	e8 53 4e 00 00       	call   801050ad <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 94 05 11 80    	mov    0x80110594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 05 11 80 	movl   $0x80110584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 05 11 80       	mov    0x80110594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 05 11 80       	mov    %eax,0x80110594

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 a0 4a 00 00       	call   80104d5e <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 c6 10 80       	push   $0x8010c680
801002c9:	e8 46 4e 00 00       	call   80105114 <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 c3 03 00 00       	call   80100776 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 b5 10 80       	push   $0x8010b5e0
801003e2:	e8 c6 4c 00 00       	call   801050ad <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 f2 87 10 80       	push   $0x801087f2
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 55 03 00 00       	call   80100776 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec fb 87 10 80 	movl   $0x801087fb,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 8e 02 00 00       	call   80100776 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 71 02 00 00       	call   80100776 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 62 02 00 00       	call   80100776 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 54 02 00 00       	call   80100776 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 e0 b5 10 80       	push   $0x8010b5e0
8010055b:	e8 b4 4b 00 00       	call   80105114 <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 02 88 10 80       	push   $0x80108802
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 11 88 10 80       	push   $0x80108811
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 9f 4b 00 00       	call   80105166 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 13 88 10 80       	push   $0x80108813
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)
  
  if((pos/80) >= 24){  // Scroll up.
801006b8:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006bf:	7e 4c                	jle    8010070d <cgaputc+0x10c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006c1:	a1 00 90 10 80       	mov    0x80109000,%eax
801006c6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006cc:	a1 00 90 10 80       	mov    0x80109000,%eax
801006d1:	83 ec 04             	sub    $0x4,%esp
801006d4:	68 60 0e 00 00       	push   $0xe60
801006d9:	52                   	push   %edx
801006da:	50                   	push   %eax
801006db:	e8 ef 4c 00 00       	call   801053cf <memmove>
801006e0:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006e3:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006e7:	b8 80 07 00 00       	mov    $0x780,%eax
801006ec:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006ef:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006f2:	a1 00 90 10 80       	mov    0x80109000,%eax
801006f7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006fa:	01 c9                	add    %ecx,%ecx
801006fc:	01 c8                	add    %ecx,%eax
801006fe:	83 ec 04             	sub    $0x4,%esp
80100701:	52                   	push   %edx
80100702:	6a 00                	push   $0x0
80100704:	50                   	push   %eax
80100705:	e8 06 4c 00 00       	call   80105310 <memset>
8010070a:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
8010070d:	83 ec 08             	sub    $0x8,%esp
80100710:	6a 0e                	push   $0xe
80100712:	68 d4 03 00 00       	push   $0x3d4
80100717:	e8 d5 fb ff ff       	call   801002f1 <outb>
8010071c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010071f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100722:	c1 f8 08             	sar    $0x8,%eax
80100725:	0f b6 c0             	movzbl %al,%eax
80100728:	83 ec 08             	sub    $0x8,%esp
8010072b:	50                   	push   %eax
8010072c:	68 d5 03 00 00       	push   $0x3d5
80100731:	e8 bb fb ff ff       	call   801002f1 <outb>
80100736:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100739:	83 ec 08             	sub    $0x8,%esp
8010073c:	6a 0f                	push   $0xf
8010073e:	68 d4 03 00 00       	push   $0x3d4
80100743:	e8 a9 fb ff ff       	call   801002f1 <outb>
80100748:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010074e:	0f b6 c0             	movzbl %al,%eax
80100751:	83 ec 08             	sub    $0x8,%esp
80100754:	50                   	push   %eax
80100755:	68 d5 03 00 00       	push   $0x3d5
8010075a:	e8 92 fb ff ff       	call   801002f1 <outb>
8010075f:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100762:	a1 00 90 10 80       	mov    0x80109000,%eax
80100767:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010076a:	01 d2                	add    %edx,%edx
8010076c:	01 d0                	add    %edx,%eax
8010076e:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100773:	90                   	nop
80100774:	c9                   	leave  
80100775:	c3                   	ret    

80100776 <consputc>:

void
consputc(int c)
{
80100776:	55                   	push   %ebp
80100777:	89 e5                	mov    %esp,%ebp
80100779:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
8010077c:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80100781:	85 c0                	test   %eax,%eax
80100783:	74 07                	je     8010078c <consputc+0x16>
    cli();
80100785:	e8 86 fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
8010078a:	eb fe                	jmp    8010078a <consputc+0x14>
  }

  if(c == BACKSPACE){
8010078c:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100793:	75 29                	jne    801007be <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100795:	83 ec 0c             	sub    $0xc,%esp
80100798:	6a 08                	push   $0x8
8010079a:	e8 3f 66 00 00       	call   80106dde <uartputc>
8010079f:	83 c4 10             	add    $0x10,%esp
801007a2:	83 ec 0c             	sub    $0xc,%esp
801007a5:	6a 20                	push   $0x20
801007a7:	e8 32 66 00 00       	call   80106dde <uartputc>
801007ac:	83 c4 10             	add    $0x10,%esp
801007af:	83 ec 0c             	sub    $0xc,%esp
801007b2:	6a 08                	push   $0x8
801007b4:	e8 25 66 00 00       	call   80106dde <uartputc>
801007b9:	83 c4 10             	add    $0x10,%esp
801007bc:	eb 0e                	jmp    801007cc <consputc+0x56>
  } else
    uartputc(c);
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	ff 75 08             	pushl  0x8(%ebp)
801007c4:	e8 15 66 00 00       	call   80106dde <uartputc>
801007c9:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007cc:	83 ec 0c             	sub    $0xc,%esp
801007cf:	ff 75 08             	pushl  0x8(%ebp)
801007d2:	e8 2a fe ff ff       	call   80100601 <cgaputc>
801007d7:	83 c4 10             	add    $0x10,%esp
}
801007da:	90                   	nop
801007db:	c9                   	leave  
801007dc:	c3                   	ret    

801007dd <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007dd:	55                   	push   %ebp
801007de:	89 e5                	mov    %esp,%ebp
801007e0:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
801007e3:	83 ec 0c             	sub    $0xc,%esp
801007e6:	68 a0 07 11 80       	push   $0x801107a0
801007eb:	e8 bd 48 00 00       	call   801050ad <acquire>
801007f0:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007f3:	e9 42 01 00 00       	jmp    8010093a <consoleintr+0x15d>
    switch(c){
801007f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007fb:	83 f8 10             	cmp    $0x10,%eax
801007fe:	74 1e                	je     8010081e <consoleintr+0x41>
80100800:	83 f8 10             	cmp    $0x10,%eax
80100803:	7f 0a                	jg     8010080f <consoleintr+0x32>
80100805:	83 f8 08             	cmp    $0x8,%eax
80100808:	74 69                	je     80100873 <consoleintr+0x96>
8010080a:	e9 99 00 00 00       	jmp    801008a8 <consoleintr+0xcb>
8010080f:	83 f8 15             	cmp    $0x15,%eax
80100812:	74 31                	je     80100845 <consoleintr+0x68>
80100814:	83 f8 7f             	cmp    $0x7f,%eax
80100817:	74 5a                	je     80100873 <consoleintr+0x96>
80100819:	e9 8a 00 00 00       	jmp    801008a8 <consoleintr+0xcb>
    case C('P'):  // Process listing.
      procdump();
8010081e:	e8 f9 45 00 00       	call   80104e1c <procdump>
      break;
80100823:	e9 12 01 00 00       	jmp    8010093a <consoleintr+0x15d>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100828:	a1 5c 08 11 80       	mov    0x8011085c,%eax
8010082d:	83 e8 01             	sub    $0x1,%eax
80100830:	a3 5c 08 11 80       	mov    %eax,0x8011085c
        consputc(BACKSPACE);
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 00 01 00 00       	push   $0x100
8010083d:	e8 34 ff ff ff       	call   80100776 <consputc>
80100842:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100845:	8b 15 5c 08 11 80    	mov    0x8011085c,%edx
8010084b:	a1 58 08 11 80       	mov    0x80110858,%eax
80100850:	39 c2                	cmp    %eax,%edx
80100852:	0f 84 e2 00 00 00    	je     8010093a <consoleintr+0x15d>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100858:	a1 5c 08 11 80       	mov    0x8011085c,%eax
8010085d:	83 e8 01             	sub    $0x1,%eax
80100860:	83 e0 7f             	and    $0x7f,%eax
80100863:	0f b6 80 d4 07 11 80 	movzbl -0x7feef82c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010086a:	3c 0a                	cmp    $0xa,%al
8010086c:	75 ba                	jne    80100828 <consoleintr+0x4b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010086e:	e9 c7 00 00 00       	jmp    8010093a <consoleintr+0x15d>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100873:	8b 15 5c 08 11 80    	mov    0x8011085c,%edx
80100879:	a1 58 08 11 80       	mov    0x80110858,%eax
8010087e:	39 c2                	cmp    %eax,%edx
80100880:	0f 84 b4 00 00 00    	je     8010093a <consoleintr+0x15d>
        input.e--;
80100886:	a1 5c 08 11 80       	mov    0x8011085c,%eax
8010088b:	83 e8 01             	sub    $0x1,%eax
8010088e:	a3 5c 08 11 80       	mov    %eax,0x8011085c
        consputc(BACKSPACE);
80100893:	83 ec 0c             	sub    $0xc,%esp
80100896:	68 00 01 00 00       	push   $0x100
8010089b:	e8 d6 fe ff ff       	call   80100776 <consputc>
801008a0:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008a3:	e9 92 00 00 00       	jmp    8010093a <consoleintr+0x15d>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801008ac:	0f 84 87 00 00 00    	je     80100939 <consoleintr+0x15c>
801008b2:	8b 15 5c 08 11 80    	mov    0x8011085c,%edx
801008b8:	a1 54 08 11 80       	mov    0x80110854,%eax
801008bd:	29 c2                	sub    %eax,%edx
801008bf:	89 d0                	mov    %edx,%eax
801008c1:	83 f8 7f             	cmp    $0x7f,%eax
801008c4:	77 73                	ja     80100939 <consoleintr+0x15c>
        c = (c == '\r') ? '\n' : c;
801008c6:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008ca:	74 05                	je     801008d1 <consoleintr+0xf4>
801008cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008cf:	eb 05                	jmp    801008d6 <consoleintr+0xf9>
801008d1:	b8 0a 00 00 00       	mov    $0xa,%eax
801008d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008d9:	a1 5c 08 11 80       	mov    0x8011085c,%eax
801008de:	8d 50 01             	lea    0x1(%eax),%edx
801008e1:	89 15 5c 08 11 80    	mov    %edx,0x8011085c
801008e7:	83 e0 7f             	and    $0x7f,%eax
801008ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008ed:	88 90 d4 07 11 80    	mov    %dl,-0x7feef82c(%eax)
        consputc(c);
801008f3:	83 ec 0c             	sub    $0xc,%esp
801008f6:	ff 75 f4             	pushl  -0xc(%ebp)
801008f9:	e8 78 fe ff ff       	call   80100776 <consputc>
801008fe:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100901:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80100905:	74 18                	je     8010091f <consoleintr+0x142>
80100907:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
8010090b:	74 12                	je     8010091f <consoleintr+0x142>
8010090d:	a1 5c 08 11 80       	mov    0x8011085c,%eax
80100912:	8b 15 54 08 11 80    	mov    0x80110854,%edx
80100918:	83 ea 80             	sub    $0xffffff80,%edx
8010091b:	39 d0                	cmp    %edx,%eax
8010091d:	75 1a                	jne    80100939 <consoleintr+0x15c>
          input.w = input.e;
8010091f:	a1 5c 08 11 80       	mov    0x8011085c,%eax
80100924:	a3 58 08 11 80       	mov    %eax,0x80110858
          wakeup(&input.r);
80100929:	83 ec 0c             	sub    $0xc,%esp
8010092c:	68 54 08 11 80       	push   $0x80110854
80100931:	e8 28 44 00 00       	call   80104d5e <wakeup>
80100936:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100939:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
8010093a:	8b 45 08             	mov    0x8(%ebp),%eax
8010093d:	ff d0                	call   *%eax
8010093f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100946:	0f 89 ac fe ff ff    	jns    801007f8 <consoleintr+0x1b>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010094c:	83 ec 0c             	sub    $0xc,%esp
8010094f:	68 a0 07 11 80       	push   $0x801107a0
80100954:	e8 bb 47 00 00       	call   80105114 <release>
80100959:	83 c4 10             	add    $0x10,%esp
}
8010095c:	90                   	nop
8010095d:	c9                   	leave  
8010095e:	c3                   	ret    

8010095f <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010095f:	55                   	push   %ebp
80100960:	89 e5                	mov    %esp,%ebp
80100962:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100965:	83 ec 0c             	sub    $0xc,%esp
80100968:	ff 75 08             	pushl  0x8(%ebp)
8010096b:	e8 f3 10 00 00       	call   80101a63 <iunlock>
80100970:	83 c4 10             	add    $0x10,%esp
  target = n;
80100973:	8b 45 10             	mov    0x10(%ebp),%eax
80100976:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100979:	83 ec 0c             	sub    $0xc,%esp
8010097c:	68 a0 07 11 80       	push   $0x801107a0
80100981:	e8 27 47 00 00       	call   801050ad <acquire>
80100986:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100989:	e9 ac 00 00 00       	jmp    80100a3a <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
8010098e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100994:	8b 40 24             	mov    0x24(%eax),%eax
80100997:	85 c0                	test   %eax,%eax
80100999:	74 28                	je     801009c3 <consoleread+0x64>
        release(&input.lock);
8010099b:	83 ec 0c             	sub    $0xc,%esp
8010099e:	68 a0 07 11 80       	push   $0x801107a0
801009a3:	e8 6c 47 00 00       	call   80105114 <release>
801009a8:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009ab:	83 ec 0c             	sub    $0xc,%esp
801009ae:	ff 75 08             	pushl  0x8(%ebp)
801009b1:	e8 55 0f 00 00       	call   8010190b <ilock>
801009b6:	83 c4 10             	add    $0x10,%esp
        return -1;
801009b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009be:	e9 ab 00 00 00       	jmp    80100a6e <consoleread+0x10f>
      }
      sleep(&input.r, &input.lock);
801009c3:	83 ec 08             	sub    $0x8,%esp
801009c6:	68 a0 07 11 80       	push   $0x801107a0
801009cb:	68 54 08 11 80       	push   $0x80110854
801009d0:	e8 9b 42 00 00       	call   80104c70 <sleep>
801009d5:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
801009d8:	8b 15 54 08 11 80    	mov    0x80110854,%edx
801009de:	a1 58 08 11 80       	mov    0x80110858,%eax
801009e3:	39 c2                	cmp    %eax,%edx
801009e5:	74 a7                	je     8010098e <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009e7:	a1 54 08 11 80       	mov    0x80110854,%eax
801009ec:	8d 50 01             	lea    0x1(%eax),%edx
801009ef:	89 15 54 08 11 80    	mov    %edx,0x80110854
801009f5:	83 e0 7f             	and    $0x7f,%eax
801009f8:	0f b6 80 d4 07 11 80 	movzbl -0x7feef82c(%eax),%eax
801009ff:	0f be c0             	movsbl %al,%eax
80100a02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a05:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a09:	75 17                	jne    80100a22 <consoleread+0xc3>
      if(n < target){
80100a0b:	8b 45 10             	mov    0x10(%ebp),%eax
80100a0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a11:	73 2f                	jae    80100a42 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a13:	a1 54 08 11 80       	mov    0x80110854,%eax
80100a18:	83 e8 01             	sub    $0x1,%eax
80100a1b:	a3 54 08 11 80       	mov    %eax,0x80110854
      }
      break;
80100a20:	eb 20                	jmp    80100a42 <consoleread+0xe3>
    }
    *dst++ = c;
80100a22:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a25:	8d 50 01             	lea    0x1(%eax),%edx
80100a28:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a2e:	88 10                	mov    %dl,(%eax)
    --n;
80100a30:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a34:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a38:	74 0b                	je     80100a45 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100a3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a3e:	7f 98                	jg     801009d8 <consoleread+0x79>
80100a40:	eb 04                	jmp    80100a46 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a42:	90                   	nop
80100a43:	eb 01                	jmp    80100a46 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a45:	90                   	nop
  }
  release(&input.lock);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	68 a0 07 11 80       	push   $0x801107a0
80100a4e:	e8 c1 46 00 00       	call   80105114 <release>
80100a53:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a56:	83 ec 0c             	sub    $0xc,%esp
80100a59:	ff 75 08             	pushl  0x8(%ebp)
80100a5c:	e8 aa 0e 00 00       	call   8010190b <ilock>
80100a61:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a64:	8b 45 10             	mov    0x10(%ebp),%eax
80100a67:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a6a:	29 c2                	sub    %eax,%edx
80100a6c:	89 d0                	mov    %edx,%eax
}
80100a6e:	c9                   	leave  
80100a6f:	c3                   	ret    

80100a70 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a70:	55                   	push   %ebp
80100a71:	89 e5                	mov    %esp,%ebp
80100a73:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	ff 75 08             	pushl  0x8(%ebp)
80100a7c:	e8 e2 0f 00 00       	call   80101a63 <iunlock>
80100a81:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a84:	83 ec 0c             	sub    $0xc,%esp
80100a87:	68 e0 b5 10 80       	push   $0x8010b5e0
80100a8c:	e8 1c 46 00 00       	call   801050ad <acquire>
80100a91:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100a94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a9b:	eb 21                	jmp    80100abe <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100aa3:	01 d0                	add    %edx,%eax
80100aa5:	0f b6 00             	movzbl (%eax),%eax
80100aa8:	0f be c0             	movsbl %al,%eax
80100aab:	0f b6 c0             	movzbl %al,%eax
80100aae:	83 ec 0c             	sub    $0xc,%esp
80100ab1:	50                   	push   %eax
80100ab2:	e8 bf fc ff ff       	call   80100776 <consputc>
80100ab7:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100aba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ac1:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ac4:	7c d7                	jl     80100a9d <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ac6:	83 ec 0c             	sub    $0xc,%esp
80100ac9:	68 e0 b5 10 80       	push   $0x8010b5e0
80100ace:	e8 41 46 00 00       	call   80105114 <release>
80100ad3:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	ff 75 08             	pushl  0x8(%ebp)
80100adc:	e8 2a 0e 00 00       	call   8010190b <ilock>
80100ae1:	83 c4 10             	add    $0x10,%esp

  return n;
80100ae4:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ae7:	c9                   	leave  
80100ae8:	c3                   	ret    

80100ae9 <consoleinit>:

void
consoleinit(void)
{
80100ae9:	55                   	push   %ebp
80100aea:	89 e5                	mov    %esp,%ebp
80100aec:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100aef:	83 ec 08             	sub    $0x8,%esp
80100af2:	68 17 88 10 80       	push   $0x80108817
80100af7:	68 e0 b5 10 80       	push   $0x8010b5e0
80100afc:	e8 8a 45 00 00       	call   8010508b <initlock>
80100b01:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b04:	83 ec 08             	sub    $0x8,%esp
80100b07:	68 1f 88 10 80       	push   $0x8010881f
80100b0c:	68 a0 07 11 80       	push   $0x801107a0
80100b11:	e8 75 45 00 00       	call   8010508b <initlock>
80100b16:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b19:	c7 05 0c 12 11 80 70 	movl   $0x80100a70,0x8011120c
80100b20:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b23:	c7 05 08 12 11 80 5f 	movl   $0x8010095f,0x80111208
80100b2a:	09 10 80 
  cons.locking = 1;
80100b2d:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
80100b34:	00 00 00 

  picenable(IRQ_KBD);
80100b37:	83 ec 0c             	sub    $0xc,%esp
80100b3a:	6a 01                	push   $0x1
80100b3c:	e8 36 33 00 00       	call   80103e77 <picenable>
80100b41:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b44:	83 ec 08             	sub    $0x8,%esp
80100b47:	6a 00                	push   $0x0
80100b49:	6a 01                	push   $0x1
80100b4b:	e8 e9 1e 00 00       	call   80102a39 <ioapicenable>
80100b50:	83 c4 10             	add    $0x10,%esp
}
80100b53:	90                   	nop
80100b54:	c9                   	leave  
80100b55:	c3                   	ret    

80100b56 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b56:	55                   	push   %ebp
80100b57:	89 e5                	mov    %esp,%ebp
80100b59:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b5f:	e8 50 29 00 00       	call   801034b4 <begin_op>
  if((ip = namei(path)) == 0){
80100b64:	83 ec 0c             	sub    $0xc,%esp
80100b67:	ff 75 08             	pushl  0x8(%ebp)
80100b6a:	e8 54 19 00 00       	call   801024c3 <namei>
80100b6f:	83 c4 10             	add    $0x10,%esp
80100b72:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b75:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b79:	75 0f                	jne    80100b8a <exec+0x34>
    end_op();
80100b7b:	e8 c0 29 00 00       	call   80103540 <end_op>
    return -1;
80100b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b85:	e9 ce 03 00 00       	jmp    80100f58 <exec+0x402>
  }
  ilock(ip);
80100b8a:	83 ec 0c             	sub    $0xc,%esp
80100b8d:	ff 75 d8             	pushl  -0x28(%ebp)
80100b90:	e8 76 0d 00 00       	call   8010190b <ilock>
80100b95:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100b98:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b9f:	6a 34                	push   $0x34
80100ba1:	6a 00                	push   $0x0
80100ba3:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100ba9:	50                   	push   %eax
80100baa:	ff 75 d8             	pushl  -0x28(%ebp)
80100bad:	e8 c1 12 00 00       	call   80101e73 <readi>
80100bb2:	83 c4 10             	add    $0x10,%esp
80100bb5:	83 f8 33             	cmp    $0x33,%eax
80100bb8:	0f 86 49 03 00 00    	jbe    80100f07 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100bbe:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bc4:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bc9:	0f 85 3b 03 00 00    	jne    80100f0a <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100bcf:	e8 6b 73 00 00       	call   80107f3f <setupkvm>
80100bd4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bd7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bdb:	0f 84 2c 03 00 00    	je     80100f0d <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100be1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bef:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bf5:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bf8:	e9 ab 00 00 00       	jmp    80100ca8 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c00:	6a 20                	push   $0x20
80100c02:	50                   	push   %eax
80100c03:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c09:	50                   	push   %eax
80100c0a:	ff 75 d8             	pushl  -0x28(%ebp)
80100c0d:	e8 61 12 00 00       	call   80101e73 <readi>
80100c12:	83 c4 10             	add    $0x10,%esp
80100c15:	83 f8 20             	cmp    $0x20,%eax
80100c18:	0f 85 f2 02 00 00    	jne    80100f10 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c1e:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c24:	83 f8 01             	cmp    $0x1,%eax
80100c27:	75 71                	jne    80100c9a <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100c29:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c2f:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c35:	39 c2                	cmp    %eax,%edx
80100c37:	0f 82 d6 02 00 00    	jb     80100f13 <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c3d:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c43:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c49:	01 d0                	add    %edx,%eax
80100c4b:	83 ec 04             	sub    $0x4,%esp
80100c4e:	50                   	push   %eax
80100c4f:	ff 75 e0             	pushl  -0x20(%ebp)
80100c52:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c55:	e8 f5 76 00 00       	call   8010834f <allocuvm>
80100c5a:	83 c4 10             	add    $0x10,%esp
80100c5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c64:	0f 84 ac 02 00 00    	je     80100f16 <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c6a:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c70:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c7c:	83 ec 0c             	sub    $0xc,%esp
80100c7f:	52                   	push   %edx
80100c80:	50                   	push   %eax
80100c81:	ff 75 d8             	pushl  -0x28(%ebp)
80100c84:	51                   	push   %ecx
80100c85:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c88:	e8 82 75 00 00       	call   8010820f <loaduvm>
80100c8d:	83 c4 20             	add    $0x20,%esp
80100c90:	85 c0                	test   %eax,%eax
80100c92:	0f 88 81 02 00 00    	js     80100f19 <exec+0x3c3>
80100c98:	eb 01                	jmp    80100c9b <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c9a:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c9b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ca2:	83 c0 20             	add    $0x20,%eax
80100ca5:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ca8:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100caf:	0f b7 c0             	movzwl %ax,%eax
80100cb2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cb5:	0f 8f 42 ff ff ff    	jg     80100bfd <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cbb:	83 ec 0c             	sub    $0xc,%esp
80100cbe:	ff 75 d8             	pushl  -0x28(%ebp)
80100cc1:	e8 ff 0e 00 00       	call   80101bc5 <iunlockput>
80100cc6:	83 c4 10             	add    $0x10,%esp
  end_op();
80100cc9:	e8 72 28 00 00       	call   80103540 <end_op>
  ip = 0;
80100cce:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd8:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cdd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce8:	05 00 20 00 00       	add    $0x2000,%eax
80100ced:	83 ec 04             	sub    $0x4,%esp
80100cf0:	50                   	push   %eax
80100cf1:	ff 75 e0             	pushl  -0x20(%ebp)
80100cf4:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cf7:	e8 53 76 00 00       	call   8010834f <allocuvm>
80100cfc:	83 c4 10             	add    $0x10,%esp
80100cff:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d06:	0f 84 10 02 00 00    	je     80100f1c <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0f:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d14:	83 ec 08             	sub    $0x8,%esp
80100d17:	50                   	push   %eax
80100d18:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d1b:	e8 55 78 00 00       	call   80108575 <clearpteu>
80100d20:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d26:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d30:	e9 96 00 00 00       	jmp    80100dcb <exec+0x275>
    if(argc >= MAXARG)
80100d35:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d39:	0f 87 e0 01 00 00    	ja     80100f1f <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d4c:	01 d0                	add    %edx,%eax
80100d4e:	8b 00                	mov    (%eax),%eax
80100d50:	83 ec 0c             	sub    $0xc,%esp
80100d53:	50                   	push   %eax
80100d54:	e8 04 48 00 00       	call   8010555d <strlen>
80100d59:	83 c4 10             	add    $0x10,%esp
80100d5c:	89 c2                	mov    %eax,%edx
80100d5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d61:	29 d0                	sub    %edx,%eax
80100d63:	83 e8 01             	sub    $0x1,%eax
80100d66:	83 e0 fc             	and    $0xfffffffc,%eax
80100d69:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d76:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d79:	01 d0                	add    %edx,%eax
80100d7b:	8b 00                	mov    (%eax),%eax
80100d7d:	83 ec 0c             	sub    $0xc,%esp
80100d80:	50                   	push   %eax
80100d81:	e8 d7 47 00 00       	call   8010555d <strlen>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	83 c0 01             	add    $0x1,%eax
80100d8c:	89 c1                	mov    %eax,%ecx
80100d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d91:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d98:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d9b:	01 d0                	add    %edx,%eax
80100d9d:	8b 00                	mov    (%eax),%eax
80100d9f:	51                   	push   %ecx
80100da0:	50                   	push   %eax
80100da1:	ff 75 dc             	pushl  -0x24(%ebp)
80100da4:	ff 75 d4             	pushl  -0x2c(%ebp)
80100da7:	e8 80 79 00 00       	call   8010872c <copyout>
80100dac:	83 c4 10             	add    $0x10,%esp
80100daf:	85 c0                	test   %eax,%eax
80100db1:	0f 88 6b 01 00 00    	js     80100f22 <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dba:	8d 50 03             	lea    0x3(%eax),%edx
80100dbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dc0:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dc7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dd8:	01 d0                	add    %edx,%eax
80100dda:	8b 00                	mov    (%eax),%eax
80100ddc:	85 c0                	test   %eax,%eax
80100dde:	0f 85 51 ff ff ff    	jne    80100d35 <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100de4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de7:	83 c0 03             	add    $0x3,%eax
80100dea:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100df1:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100df5:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dfc:	ff ff ff 
  ustack[1] = argc;
80100dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e02:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0b:	83 c0 01             	add    $0x1,%eax
80100e0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e15:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e18:	29 d0                	sub    %edx,%eax
80100e1a:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e23:	83 c0 04             	add    $0x4,%eax
80100e26:	c1 e0 02             	shl    $0x2,%eax
80100e29:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2f:	83 c0 04             	add    $0x4,%eax
80100e32:	c1 e0 02             	shl    $0x2,%eax
80100e35:	50                   	push   %eax
80100e36:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e3c:	50                   	push   %eax
80100e3d:	ff 75 dc             	pushl  -0x24(%ebp)
80100e40:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e43:	e8 e4 78 00 00       	call   8010872c <copyout>
80100e48:	83 c4 10             	add    $0x10,%esp
80100e4b:	85 c0                	test   %eax,%eax
80100e4d:	0f 88 d2 00 00 00    	js     80100f25 <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e53:	8b 45 08             	mov    0x8(%ebp),%eax
80100e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e5f:	eb 17                	jmp    80100e78 <exec+0x322>
    if(*s == '/')
80100e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e64:	0f b6 00             	movzbl (%eax),%eax
80100e67:	3c 2f                	cmp    $0x2f,%al
80100e69:	75 09                	jne    80100e74 <exec+0x31e>
      last = s+1;
80100e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e6e:	83 c0 01             	add    $0x1,%eax
80100e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7b:	0f b6 00             	movzbl (%eax),%eax
80100e7e:	84 c0                	test   %al,%al
80100e80:	75 df                	jne    80100e61 <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e88:	83 c0 6c             	add    $0x6c,%eax
80100e8b:	83 ec 04             	sub    $0x4,%esp
80100e8e:	6a 10                	push   $0x10
80100e90:	ff 75 f0             	pushl  -0x10(%ebp)
80100e93:	50                   	push   %eax
80100e94:	e8 7a 46 00 00       	call   80105513 <safestrcpy>
80100e99:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea2:	8b 40 04             	mov    0x4(%eax),%eax
80100ea5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ea8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eb1:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100eb4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ebd:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ebf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec5:	8b 40 18             	mov    0x18(%eax),%eax
80100ec8:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ece:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ed1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed7:	8b 40 18             	mov    0x18(%eax),%eax
80100eda:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100edd:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ee0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee6:	83 ec 0c             	sub    $0xc,%esp
80100ee9:	50                   	push   %eax
80100eea:	e8 37 71 00 00       	call   80108026 <switchuvm>
80100eef:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
80100ef5:	ff 75 d0             	pushl  -0x30(%ebp)
80100ef8:	e8 d8 75 00 00       	call   801084d5 <freevm>
80100efd:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f00:	b8 00 00 00 00       	mov    $0x0,%eax
80100f05:	eb 51                	jmp    80100f58 <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100f07:	90                   	nop
80100f08:	eb 1c                	jmp    80100f26 <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f0a:	90                   	nop
80100f0b:	eb 19                	jmp    80100f26 <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100f0d:	90                   	nop
80100f0e:	eb 16                	jmp    80100f26 <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100f10:	90                   	nop
80100f11:	eb 13                	jmp    80100f26 <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100f13:	90                   	nop
80100f14:	eb 10                	jmp    80100f26 <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100f16:	90                   	nop
80100f17:	eb 0d                	jmp    80100f26 <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100f19:	90                   	nop
80100f1a:	eb 0a                	jmp    80100f26 <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100f1c:	90                   	nop
80100f1d:	eb 07                	jmp    80100f26 <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100f1f:	90                   	nop
80100f20:	eb 04                	jmp    80100f26 <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f22:	90                   	nop
80100f23:	eb 01                	jmp    80100f26 <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f25:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f26:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f2a:	74 0e                	je     80100f3a <exec+0x3e4>
    freevm(pgdir);
80100f2c:	83 ec 0c             	sub    $0xc,%esp
80100f2f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f32:	e8 9e 75 00 00       	call   801084d5 <freevm>
80100f37:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f3e:	74 13                	je     80100f53 <exec+0x3fd>
    iunlockput(ip);
80100f40:	83 ec 0c             	sub    $0xc,%esp
80100f43:	ff 75 d8             	pushl  -0x28(%ebp)
80100f46:	e8 7a 0c 00 00       	call   80101bc5 <iunlockput>
80100f4b:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f4e:	e8 ed 25 00 00       	call   80103540 <end_op>
  }
  return -1;
80100f53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f58:	c9                   	leave  
80100f59:	c3                   	ret    

80100f5a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f5a:	55                   	push   %ebp
80100f5b:	89 e5                	mov    %esp,%ebp
80100f5d:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f60:	83 ec 08             	sub    $0x8,%esp
80100f63:	68 25 88 10 80       	push   $0x80108825
80100f68:	68 60 08 11 80       	push   $0x80110860
80100f6d:	e8 19 41 00 00       	call   8010508b <initlock>
80100f72:	83 c4 10             	add    $0x10,%esp
}
80100f75:	90                   	nop
80100f76:	c9                   	leave  
80100f77:	c3                   	ret    

80100f78 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f78:	55                   	push   %ebp
80100f79:	89 e5                	mov    %esp,%ebp
80100f7b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f7e:	83 ec 0c             	sub    $0xc,%esp
80100f81:	68 60 08 11 80       	push   $0x80110860
80100f86:	e8 22 41 00 00       	call   801050ad <acquire>
80100f8b:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f8e:	c7 45 f4 94 08 11 80 	movl   $0x80110894,-0xc(%ebp)
80100f95:	eb 2d                	jmp    80100fc4 <filealloc+0x4c>
    if(f->ref == 0){
80100f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f9a:	8b 40 04             	mov    0x4(%eax),%eax
80100f9d:	85 c0                	test   %eax,%eax
80100f9f:	75 1f                	jne    80100fc0 <filealloc+0x48>
      f->ref = 1;
80100fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa4:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fab:	83 ec 0c             	sub    $0xc,%esp
80100fae:	68 60 08 11 80       	push   $0x80110860
80100fb3:	e8 5c 41 00 00       	call   80105114 <release>
80100fb8:	83 c4 10             	add    $0x10,%esp
      return f;
80100fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fbe:	eb 23                	jmp    80100fe3 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fc0:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fc4:	b8 f4 11 11 80       	mov    $0x801111f4,%eax
80100fc9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100fcc:	72 c9                	jb     80100f97 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fce:	83 ec 0c             	sub    $0xc,%esp
80100fd1:	68 60 08 11 80       	push   $0x80110860
80100fd6:	e8 39 41 00 00       	call   80105114 <release>
80100fdb:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fde:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fe3:	c9                   	leave  
80100fe4:	c3                   	ret    

80100fe5 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fe5:	55                   	push   %ebp
80100fe6:	89 e5                	mov    %esp,%ebp
80100fe8:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80100feb:	83 ec 0c             	sub    $0xc,%esp
80100fee:	68 60 08 11 80       	push   $0x80110860
80100ff3:	e8 b5 40 00 00       	call   801050ad <acquire>
80100ff8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffe:	8b 40 04             	mov    0x4(%eax),%eax
80101001:	85 c0                	test   %eax,%eax
80101003:	7f 0d                	jg     80101012 <filedup+0x2d>
    panic("filedup");
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	68 2c 88 10 80       	push   $0x8010882c
8010100d:	e8 54 f5 ff ff       	call   80100566 <panic>
  f->ref++;
80101012:	8b 45 08             	mov    0x8(%ebp),%eax
80101015:	8b 40 04             	mov    0x4(%eax),%eax
80101018:	8d 50 01             	lea    0x1(%eax),%edx
8010101b:	8b 45 08             	mov    0x8(%ebp),%eax
8010101e:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101021:	83 ec 0c             	sub    $0xc,%esp
80101024:	68 60 08 11 80       	push   $0x80110860
80101029:	e8 e6 40 00 00       	call   80105114 <release>
8010102e:	83 c4 10             	add    $0x10,%esp
  return f;
80101031:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101034:	c9                   	leave  
80101035:	c3                   	ret    

80101036 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101036:	55                   	push   %ebp
80101037:	89 e5                	mov    %esp,%ebp
80101039:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	68 60 08 11 80       	push   $0x80110860
80101044:	e8 64 40 00 00       	call   801050ad <acquire>
80101049:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
8010104f:	8b 40 04             	mov    0x4(%eax),%eax
80101052:	85 c0                	test   %eax,%eax
80101054:	7f 0d                	jg     80101063 <fileclose+0x2d>
    panic("fileclose");
80101056:	83 ec 0c             	sub    $0xc,%esp
80101059:	68 34 88 10 80       	push   $0x80108834
8010105e:	e8 03 f5 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
80101063:	8b 45 08             	mov    0x8(%ebp),%eax
80101066:	8b 40 04             	mov    0x4(%eax),%eax
80101069:	8d 50 ff             	lea    -0x1(%eax),%edx
8010106c:	8b 45 08             	mov    0x8(%ebp),%eax
8010106f:	89 50 04             	mov    %edx,0x4(%eax)
80101072:	8b 45 08             	mov    0x8(%ebp),%eax
80101075:	8b 40 04             	mov    0x4(%eax),%eax
80101078:	85 c0                	test   %eax,%eax
8010107a:	7e 15                	jle    80101091 <fileclose+0x5b>
    release(&ftable.lock);
8010107c:	83 ec 0c             	sub    $0xc,%esp
8010107f:	68 60 08 11 80       	push   $0x80110860
80101084:	e8 8b 40 00 00       	call   80105114 <release>
80101089:	83 c4 10             	add    $0x10,%esp
8010108c:	e9 8b 00 00 00       	jmp    8010111c <fileclose+0xe6>
    return;
  }
  ff = *f;
80101091:	8b 45 08             	mov    0x8(%ebp),%eax
80101094:	8b 10                	mov    (%eax),%edx
80101096:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101099:	8b 50 04             	mov    0x4(%eax),%edx
8010109c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010109f:	8b 50 08             	mov    0x8(%eax),%edx
801010a2:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010a5:	8b 50 0c             	mov    0xc(%eax),%edx
801010a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010ab:	8b 50 10             	mov    0x10(%eax),%edx
801010ae:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010b1:	8b 40 14             	mov    0x14(%eax),%eax
801010b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010b7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010c1:	8b 45 08             	mov    0x8(%ebp),%eax
801010c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010ca:	83 ec 0c             	sub    $0xc,%esp
801010cd:	68 60 08 11 80       	push   $0x80110860
801010d2:	e8 3d 40 00 00       	call   80105114 <release>
801010d7:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010dd:	83 f8 01             	cmp    $0x1,%eax
801010e0:	75 19                	jne    801010fb <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801010e2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010e6:	0f be d0             	movsbl %al,%edx
801010e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010ec:	83 ec 08             	sub    $0x8,%esp
801010ef:	52                   	push   %edx
801010f0:	50                   	push   %eax
801010f1:	e8 ea 2f 00 00       	call   801040e0 <pipeclose>
801010f6:	83 c4 10             	add    $0x10,%esp
801010f9:	eb 21                	jmp    8010111c <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801010fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010fe:	83 f8 02             	cmp    $0x2,%eax
80101101:	75 19                	jne    8010111c <fileclose+0xe6>
    begin_op();
80101103:	e8 ac 23 00 00       	call   801034b4 <begin_op>
    iput(ff.ip);
80101108:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	50                   	push   %eax
8010110f:	e8 c1 09 00 00       	call   80101ad5 <iput>
80101114:	83 c4 10             	add    $0x10,%esp
    end_op();
80101117:	e8 24 24 00 00       	call   80103540 <end_op>
  }
}
8010111c:	c9                   	leave  
8010111d:	c3                   	ret    

8010111e <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010111e:	55                   	push   %ebp
8010111f:	89 e5                	mov    %esp,%ebp
80101121:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101124:	8b 45 08             	mov    0x8(%ebp),%eax
80101127:	8b 00                	mov    (%eax),%eax
80101129:	83 f8 02             	cmp    $0x2,%eax
8010112c:	75 40                	jne    8010116e <filestat+0x50>
    ilock(f->ip);
8010112e:	8b 45 08             	mov    0x8(%ebp),%eax
80101131:	8b 40 10             	mov    0x10(%eax),%eax
80101134:	83 ec 0c             	sub    $0xc,%esp
80101137:	50                   	push   %eax
80101138:	e8 ce 07 00 00       	call   8010190b <ilock>
8010113d:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	8b 40 10             	mov    0x10(%eax),%eax
80101146:	83 ec 08             	sub    $0x8,%esp
80101149:	ff 75 0c             	pushl  0xc(%ebp)
8010114c:	50                   	push   %eax
8010114d:	e8 db 0c 00 00       	call   80101e2d <stati>
80101152:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101155:	8b 45 08             	mov    0x8(%ebp),%eax
80101158:	8b 40 10             	mov    0x10(%eax),%eax
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	50                   	push   %eax
8010115f:	e8 ff 08 00 00       	call   80101a63 <iunlock>
80101164:	83 c4 10             	add    $0x10,%esp
    return 0;
80101167:	b8 00 00 00 00       	mov    $0x0,%eax
8010116c:	eb 05                	jmp    80101173 <filestat+0x55>
  }
  return -1;
8010116e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101173:	c9                   	leave  
80101174:	c3                   	ret    

80101175 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101175:	55                   	push   %ebp
80101176:	89 e5                	mov    %esp,%ebp
80101178:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010117b:	8b 45 08             	mov    0x8(%ebp),%eax
8010117e:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101182:	84 c0                	test   %al,%al
80101184:	75 0a                	jne    80101190 <fileread+0x1b>
    return -1;
80101186:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010118b:	e9 9b 00 00 00       	jmp    8010122b <fileread+0xb6>
  if(f->type == FD_PIPE)
80101190:	8b 45 08             	mov    0x8(%ebp),%eax
80101193:	8b 00                	mov    (%eax),%eax
80101195:	83 f8 01             	cmp    $0x1,%eax
80101198:	75 1a                	jne    801011b4 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
8010119a:	8b 45 08             	mov    0x8(%ebp),%eax
8010119d:	8b 40 0c             	mov    0xc(%eax),%eax
801011a0:	83 ec 04             	sub    $0x4,%esp
801011a3:	ff 75 10             	pushl  0x10(%ebp)
801011a6:	ff 75 0c             	pushl  0xc(%ebp)
801011a9:	50                   	push   %eax
801011aa:	e8 d9 30 00 00       	call   80104288 <piperead>
801011af:	83 c4 10             	add    $0x10,%esp
801011b2:	eb 77                	jmp    8010122b <fileread+0xb6>
  if(f->type == FD_INODE){
801011b4:	8b 45 08             	mov    0x8(%ebp),%eax
801011b7:	8b 00                	mov    (%eax),%eax
801011b9:	83 f8 02             	cmp    $0x2,%eax
801011bc:	75 60                	jne    8010121e <fileread+0xa9>
    ilock(f->ip);
801011be:	8b 45 08             	mov    0x8(%ebp),%eax
801011c1:	8b 40 10             	mov    0x10(%eax),%eax
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	50                   	push   %eax
801011c8:	e8 3e 07 00 00       	call   8010190b <ilock>
801011cd:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011d3:	8b 45 08             	mov    0x8(%ebp),%eax
801011d6:	8b 50 14             	mov    0x14(%eax),%edx
801011d9:	8b 45 08             	mov    0x8(%ebp),%eax
801011dc:	8b 40 10             	mov    0x10(%eax),%eax
801011df:	51                   	push   %ecx
801011e0:	52                   	push   %edx
801011e1:	ff 75 0c             	pushl  0xc(%ebp)
801011e4:	50                   	push   %eax
801011e5:	e8 89 0c 00 00       	call   80101e73 <readi>
801011ea:	83 c4 10             	add    $0x10,%esp
801011ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011f4:	7e 11                	jle    80101207 <fileread+0x92>
      f->off += r;
801011f6:	8b 45 08             	mov    0x8(%ebp),%eax
801011f9:	8b 50 14             	mov    0x14(%eax),%edx
801011fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ff:	01 c2                	add    %eax,%edx
80101201:	8b 45 08             	mov    0x8(%ebp),%eax
80101204:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101207:	8b 45 08             	mov    0x8(%ebp),%eax
8010120a:	8b 40 10             	mov    0x10(%eax),%eax
8010120d:	83 ec 0c             	sub    $0xc,%esp
80101210:	50                   	push   %eax
80101211:	e8 4d 08 00 00       	call   80101a63 <iunlock>
80101216:	83 c4 10             	add    $0x10,%esp
    return r;
80101219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010121c:	eb 0d                	jmp    8010122b <fileread+0xb6>
  }
  panic("fileread");
8010121e:	83 ec 0c             	sub    $0xc,%esp
80101221:	68 3e 88 10 80       	push   $0x8010883e
80101226:	e8 3b f3 ff ff       	call   80100566 <panic>
}
8010122b:	c9                   	leave  
8010122c:	c3                   	ret    

8010122d <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010122d:	55                   	push   %ebp
8010122e:	89 e5                	mov    %esp,%ebp
80101230:	53                   	push   %ebx
80101231:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101234:	8b 45 08             	mov    0x8(%ebp),%eax
80101237:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010123b:	84 c0                	test   %al,%al
8010123d:	75 0a                	jne    80101249 <filewrite+0x1c>
    return -1;
8010123f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101244:	e9 1b 01 00 00       	jmp    80101364 <filewrite+0x137>
  if(f->type == FD_PIPE)
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	8b 00                	mov    (%eax),%eax
8010124e:	83 f8 01             	cmp    $0x1,%eax
80101251:	75 1d                	jne    80101270 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101253:	8b 45 08             	mov    0x8(%ebp),%eax
80101256:	8b 40 0c             	mov    0xc(%eax),%eax
80101259:	83 ec 04             	sub    $0x4,%esp
8010125c:	ff 75 10             	pushl  0x10(%ebp)
8010125f:	ff 75 0c             	pushl  0xc(%ebp)
80101262:	50                   	push   %eax
80101263:	e8 22 2f 00 00       	call   8010418a <pipewrite>
80101268:	83 c4 10             	add    $0x10,%esp
8010126b:	e9 f4 00 00 00       	jmp    80101364 <filewrite+0x137>
  if(f->type == FD_INODE){
80101270:	8b 45 08             	mov    0x8(%ebp),%eax
80101273:	8b 00                	mov    (%eax),%eax
80101275:	83 f8 02             	cmp    $0x2,%eax
80101278:	0f 85 d9 00 00 00    	jne    80101357 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010127e:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101285:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010128c:	e9 a3 00 00 00       	jmp    80101334 <filewrite+0x107>
      int n1 = n - i;
80101291:	8b 45 10             	mov    0x10(%ebp),%eax
80101294:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101297:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010129a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010129d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012a0:	7e 06                	jle    801012a8 <filewrite+0x7b>
        n1 = max;
801012a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012a5:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012a8:	e8 07 22 00 00       	call   801034b4 <begin_op>
      ilock(f->ip);
801012ad:	8b 45 08             	mov    0x8(%ebp),%eax
801012b0:	8b 40 10             	mov    0x10(%eax),%eax
801012b3:	83 ec 0c             	sub    $0xc,%esp
801012b6:	50                   	push   %eax
801012b7:	e8 4f 06 00 00       	call   8010190b <ilock>
801012bc:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012bf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012c2:	8b 45 08             	mov    0x8(%ebp),%eax
801012c5:	8b 50 14             	mov    0x14(%eax),%edx
801012c8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801012ce:	01 c3                	add    %eax,%ebx
801012d0:	8b 45 08             	mov    0x8(%ebp),%eax
801012d3:	8b 40 10             	mov    0x10(%eax),%eax
801012d6:	51                   	push   %ecx
801012d7:	52                   	push   %edx
801012d8:	53                   	push   %ebx
801012d9:	50                   	push   %eax
801012da:	e8 eb 0c 00 00       	call   80101fca <writei>
801012df:	83 c4 10             	add    $0x10,%esp
801012e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012e9:	7e 11                	jle    801012fc <filewrite+0xcf>
        f->off += r;
801012eb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ee:	8b 50 14             	mov    0x14(%eax),%edx
801012f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f4:	01 c2                	add    %eax,%edx
801012f6:	8b 45 08             	mov    0x8(%ebp),%eax
801012f9:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012fc:	8b 45 08             	mov    0x8(%ebp),%eax
801012ff:	8b 40 10             	mov    0x10(%eax),%eax
80101302:	83 ec 0c             	sub    $0xc,%esp
80101305:	50                   	push   %eax
80101306:	e8 58 07 00 00       	call   80101a63 <iunlock>
8010130b:	83 c4 10             	add    $0x10,%esp
      end_op();
8010130e:	e8 2d 22 00 00       	call   80103540 <end_op>

      if(r < 0)
80101313:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101317:	78 29                	js     80101342 <filewrite+0x115>
        break;
      if(r != n1)
80101319:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010131c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010131f:	74 0d                	je     8010132e <filewrite+0x101>
        panic("short filewrite");
80101321:	83 ec 0c             	sub    $0xc,%esp
80101324:	68 47 88 10 80       	push   $0x80108847
80101329:	e8 38 f2 ff ff       	call   80100566 <panic>
      i += r;
8010132e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101331:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101337:	3b 45 10             	cmp    0x10(%ebp),%eax
8010133a:	0f 8c 51 ff ff ff    	jl     80101291 <filewrite+0x64>
80101340:	eb 01                	jmp    80101343 <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
80101342:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101346:	3b 45 10             	cmp    0x10(%ebp),%eax
80101349:	75 05                	jne    80101350 <filewrite+0x123>
8010134b:	8b 45 10             	mov    0x10(%ebp),%eax
8010134e:	eb 14                	jmp    80101364 <filewrite+0x137>
80101350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101355:	eb 0d                	jmp    80101364 <filewrite+0x137>
  }
  panic("filewrite");
80101357:	83 ec 0c             	sub    $0xc,%esp
8010135a:	68 57 88 10 80       	push   $0x80108857
8010135f:	e8 02 f2 ff ff       	call   80100566 <panic>
}
80101364:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101367:	c9                   	leave  
80101368:	c3                   	ret    

80101369 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101369:	55                   	push   %ebp
8010136a:	89 e5                	mov    %esp,%ebp
8010136c:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010136f:	8b 45 08             	mov    0x8(%ebp),%eax
80101372:	83 ec 08             	sub    $0x8,%esp
80101375:	6a 01                	push   $0x1
80101377:	50                   	push   %eax
80101378:	e8 39 ee ff ff       	call   801001b6 <bread>
8010137d:	83 c4 10             	add    $0x10,%esp
80101380:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101386:	83 c0 18             	add    $0x18,%eax
80101389:	83 ec 04             	sub    $0x4,%esp
8010138c:	6a 10                	push   $0x10
8010138e:	50                   	push   %eax
8010138f:	ff 75 0c             	pushl  0xc(%ebp)
80101392:	e8 38 40 00 00       	call   801053cf <memmove>
80101397:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010139a:	83 ec 0c             	sub    $0xc,%esp
8010139d:	ff 75 f4             	pushl  -0xc(%ebp)
801013a0:	e8 89 ee ff ff       	call   8010022e <brelse>
801013a5:	83 c4 10             	add    $0x10,%esp
}
801013a8:	90                   	nop
801013a9:	c9                   	leave  
801013aa:	c3                   	ret    

801013ab <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013ab:	55                   	push   %ebp
801013ac:	89 e5                	mov    %esp,%ebp
801013ae:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013b1:	8b 55 0c             	mov    0xc(%ebp),%edx
801013b4:	8b 45 08             	mov    0x8(%ebp),%eax
801013b7:	83 ec 08             	sub    $0x8,%esp
801013ba:	52                   	push   %edx
801013bb:	50                   	push   %eax
801013bc:	e8 f5 ed ff ff       	call   801001b6 <bread>
801013c1:	83 c4 10             	add    $0x10,%esp
801013c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ca:	83 c0 18             	add    $0x18,%eax
801013cd:	83 ec 04             	sub    $0x4,%esp
801013d0:	68 00 02 00 00       	push   $0x200
801013d5:	6a 00                	push   $0x0
801013d7:	50                   	push   %eax
801013d8:	e8 33 3f 00 00       	call   80105310 <memset>
801013dd:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013e0:	83 ec 0c             	sub    $0xc,%esp
801013e3:	ff 75 f4             	pushl  -0xc(%ebp)
801013e6:	e8 01 23 00 00       	call   801036ec <log_write>
801013eb:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013ee:	83 ec 0c             	sub    $0xc,%esp
801013f1:	ff 75 f4             	pushl  -0xc(%ebp)
801013f4:	e8 35 ee ff ff       	call   8010022e <brelse>
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	90                   	nop
801013fd:	c9                   	leave  
801013fe:	c3                   	ret    

801013ff <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013ff:	55                   	push   %ebp
80101400:	89 e5                	mov    %esp,%ebp
80101402:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
80101405:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
8010140c:	8b 45 08             	mov    0x8(%ebp),%eax
8010140f:	83 ec 08             	sub    $0x8,%esp
80101412:	8d 55 d8             	lea    -0x28(%ebp),%edx
80101415:	52                   	push   %edx
80101416:	50                   	push   %eax
80101417:	e8 4d ff ff ff       	call   80101369 <readsb>
8010141c:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
8010141f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101426:	e9 15 01 00 00       	jmp    80101540 <balloc+0x141>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
8010142b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010142e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101434:	85 c0                	test   %eax,%eax
80101436:	0f 48 c2             	cmovs  %edx,%eax
80101439:	c1 f8 0c             	sar    $0xc,%eax
8010143c:	89 c2                	mov    %eax,%edx
8010143e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101441:	c1 e8 03             	shr    $0x3,%eax
80101444:	01 d0                	add    %edx,%eax
80101446:	83 c0 03             	add    $0x3,%eax
80101449:	83 ec 08             	sub    $0x8,%esp
8010144c:	50                   	push   %eax
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 61 ed ff ff       	call   801001b6 <bread>
80101455:	83 c4 10             	add    $0x10,%esp
80101458:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010145b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101462:	e9 a6 00 00 00       	jmp    8010150d <balloc+0x10e>
      m = 1 << (bi % 8);
80101467:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146a:	99                   	cltd   
8010146b:	c1 ea 1d             	shr    $0x1d,%edx
8010146e:	01 d0                	add    %edx,%eax
80101470:	83 e0 07             	and    $0x7,%eax
80101473:	29 d0                	sub    %edx,%eax
80101475:	ba 01 00 00 00       	mov    $0x1,%edx
8010147a:	89 c1                	mov    %eax,%ecx
8010147c:	d3 e2                	shl    %cl,%edx
8010147e:	89 d0                	mov    %edx,%eax
80101480:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101483:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101486:	8d 50 07             	lea    0x7(%eax),%edx
80101489:	85 c0                	test   %eax,%eax
8010148b:	0f 48 c2             	cmovs  %edx,%eax
8010148e:	c1 f8 03             	sar    $0x3,%eax
80101491:	89 c2                	mov    %eax,%edx
80101493:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101496:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010149b:	0f b6 c0             	movzbl %al,%eax
8010149e:	23 45 e8             	and    -0x18(%ebp),%eax
801014a1:	85 c0                	test   %eax,%eax
801014a3:	75 64                	jne    80101509 <balloc+0x10a>
        bp->data[bi/8] |= m;  // Mark block in use.
801014a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a8:	8d 50 07             	lea    0x7(%eax),%edx
801014ab:	85 c0                	test   %eax,%eax
801014ad:	0f 48 c2             	cmovs  %edx,%eax
801014b0:	c1 f8 03             	sar    $0x3,%eax
801014b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014b6:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014bb:	89 d1                	mov    %edx,%ecx
801014bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014c0:	09 ca                	or     %ecx,%edx
801014c2:	89 d1                	mov    %edx,%ecx
801014c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014c7:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014cb:	83 ec 0c             	sub    $0xc,%esp
801014ce:	ff 75 ec             	pushl  -0x14(%ebp)
801014d1:	e8 16 22 00 00       	call   801036ec <log_write>
801014d6:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014d9:	83 ec 0c             	sub    $0xc,%esp
801014dc:	ff 75 ec             	pushl  -0x14(%ebp)
801014df:	e8 4a ed ff ff       	call   8010022e <brelse>
801014e4:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ed:	01 c2                	add    %eax,%edx
801014ef:	8b 45 08             	mov    0x8(%ebp),%eax
801014f2:	83 ec 08             	sub    $0x8,%esp
801014f5:	52                   	push   %edx
801014f6:	50                   	push   %eax
801014f7:	e8 af fe ff ff       	call   801013ab <bzero>
801014fc:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101502:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101505:	01 d0                	add    %edx,%eax
80101507:	eb 52                	jmp    8010155b <balloc+0x15c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101509:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010150d:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101514:	7f 15                	jg     8010152b <balloc+0x12c>
80101516:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101519:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010151c:	01 d0                	add    %edx,%eax
8010151e:	89 c2                	mov    %eax,%edx
80101520:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101523:	39 c2                	cmp    %eax,%edx
80101525:	0f 82 3c ff ff ff    	jb     80101467 <balloc+0x68>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010152b:	83 ec 0c             	sub    $0xc,%esp
8010152e:	ff 75 ec             	pushl  -0x14(%ebp)
80101531:	e8 f8 ec ff ff       	call   8010022e <brelse>
80101536:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
80101539:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101540:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101546:	39 c2                	cmp    %eax,%edx
80101548:	0f 87 dd fe ff ff    	ja     8010142b <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010154e:	83 ec 0c             	sub    $0xc,%esp
80101551:	68 61 88 10 80       	push   $0x80108861
80101556:	e8 0b f0 ff ff       	call   80100566 <panic>
}
8010155b:	c9                   	leave  
8010155c:	c3                   	ret    

8010155d <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010155d:	55                   	push   %ebp
8010155e:	89 e5                	mov    %esp,%ebp
80101560:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101563:	83 ec 08             	sub    $0x8,%esp
80101566:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101569:	50                   	push   %eax
8010156a:	ff 75 08             	pushl  0x8(%ebp)
8010156d:	e8 f7 fd ff ff       	call   80101369 <readsb>
80101572:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101575:	8b 45 0c             	mov    0xc(%ebp),%eax
80101578:	c1 e8 0c             	shr    $0xc,%eax
8010157b:	89 c2                	mov    %eax,%edx
8010157d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101580:	c1 e8 03             	shr    $0x3,%eax
80101583:	01 d0                	add    %edx,%eax
80101585:	8d 50 03             	lea    0x3(%eax),%edx
80101588:	8b 45 08             	mov    0x8(%ebp),%eax
8010158b:	83 ec 08             	sub    $0x8,%esp
8010158e:	52                   	push   %edx
8010158f:	50                   	push   %eax
80101590:	e8 21 ec ff ff       	call   801001b6 <bread>
80101595:	83 c4 10             	add    $0x10,%esp
80101598:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010159b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010159e:	25 ff 0f 00 00       	and    $0xfff,%eax
801015a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a9:	99                   	cltd   
801015aa:	c1 ea 1d             	shr    $0x1d,%edx
801015ad:	01 d0                	add    %edx,%eax
801015af:	83 e0 07             	and    $0x7,%eax
801015b2:	29 d0                	sub    %edx,%eax
801015b4:	ba 01 00 00 00       	mov    $0x1,%edx
801015b9:	89 c1                	mov    %eax,%ecx
801015bb:	d3 e2                	shl    %cl,%edx
801015bd:	89 d0                	mov    %edx,%eax
801015bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c5:	8d 50 07             	lea    0x7(%eax),%edx
801015c8:	85 c0                	test   %eax,%eax
801015ca:	0f 48 c2             	cmovs  %edx,%eax
801015cd:	c1 f8 03             	sar    $0x3,%eax
801015d0:	89 c2                	mov    %eax,%edx
801015d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015d5:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015da:	0f b6 c0             	movzbl %al,%eax
801015dd:	23 45 ec             	and    -0x14(%ebp),%eax
801015e0:	85 c0                	test   %eax,%eax
801015e2:	75 0d                	jne    801015f1 <bfree+0x94>
    panic("freeing free block");
801015e4:	83 ec 0c             	sub    $0xc,%esp
801015e7:	68 77 88 10 80       	push   $0x80108877
801015ec:	e8 75 ef ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
801015f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f4:	8d 50 07             	lea    0x7(%eax),%edx
801015f7:	85 c0                	test   %eax,%eax
801015f9:	0f 48 c2             	cmovs  %edx,%eax
801015fc:	c1 f8 03             	sar    $0x3,%eax
801015ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101602:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101607:	89 d1                	mov    %edx,%ecx
80101609:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010160c:	f7 d2                	not    %edx
8010160e:	21 ca                	and    %ecx,%edx
80101610:	89 d1                	mov    %edx,%ecx
80101612:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101615:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101619:	83 ec 0c             	sub    $0xc,%esp
8010161c:	ff 75 f4             	pushl  -0xc(%ebp)
8010161f:	e8 c8 20 00 00       	call   801036ec <log_write>
80101624:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101627:	83 ec 0c             	sub    $0xc,%esp
8010162a:	ff 75 f4             	pushl  -0xc(%ebp)
8010162d:	e8 fc eb ff ff       	call   8010022e <brelse>
80101632:	83 c4 10             	add    $0x10,%esp
}
80101635:	90                   	nop
80101636:	c9                   	leave  
80101637:	c3                   	ret    

80101638 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101638:	55                   	push   %ebp
80101639:	89 e5                	mov    %esp,%ebp
8010163b:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
8010163e:	83 ec 08             	sub    $0x8,%esp
80101641:	68 8a 88 10 80       	push   $0x8010888a
80101646:	68 60 12 11 80       	push   $0x80111260
8010164b:	e8 3b 3a 00 00       	call   8010508b <initlock>
80101650:	83 c4 10             	add    $0x10,%esp
}
80101653:	90                   	nop
80101654:	c9                   	leave  
80101655:	c3                   	ret    

80101656 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101656:	55                   	push   %ebp
80101657:	89 e5                	mov    %esp,%ebp
80101659:	83 ec 38             	sub    $0x38,%esp
8010165c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010165f:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101663:	8b 45 08             	mov    0x8(%ebp),%eax
80101666:	83 ec 08             	sub    $0x8,%esp
80101669:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010166c:	52                   	push   %edx
8010166d:	50                   	push   %eax
8010166e:	e8 f6 fc ff ff       	call   80101369 <readsb>
80101673:	83 c4 10             	add    $0x10,%esp

  for(inum = 1; inum < sb.ninodes; inum++){
80101676:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010167d:	e9 98 00 00 00       	jmp    8010171a <ialloc+0xc4>
    bp = bread(dev, IBLOCK(inum));
80101682:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101685:	c1 e8 03             	shr    $0x3,%eax
80101688:	83 c0 02             	add    $0x2,%eax
8010168b:	83 ec 08             	sub    $0x8,%esp
8010168e:	50                   	push   %eax
8010168f:	ff 75 08             	pushl  0x8(%ebp)
80101692:	e8 1f eb ff ff       	call   801001b6 <bread>
80101697:	83 c4 10             	add    $0x10,%esp
8010169a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010169d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a0:	8d 50 18             	lea    0x18(%eax),%edx
801016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016a6:	83 e0 07             	and    $0x7,%eax
801016a9:	c1 e0 06             	shl    $0x6,%eax
801016ac:	01 d0                	add    %edx,%eax
801016ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016b4:	0f b7 00             	movzwl (%eax),%eax
801016b7:	66 85 c0             	test   %ax,%ax
801016ba:	75 4c                	jne    80101708 <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
801016bc:	83 ec 04             	sub    $0x4,%esp
801016bf:	6a 40                	push   $0x40
801016c1:	6a 00                	push   $0x0
801016c3:	ff 75 ec             	pushl  -0x14(%ebp)
801016c6:	e8 45 3c 00 00       	call   80105310 <memset>
801016cb:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801016ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016d1:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
801016d5:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016d8:	83 ec 0c             	sub    $0xc,%esp
801016db:	ff 75 f0             	pushl  -0x10(%ebp)
801016de:	e8 09 20 00 00       	call   801036ec <log_write>
801016e3:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801016e6:	83 ec 0c             	sub    $0xc,%esp
801016e9:	ff 75 f0             	pushl  -0x10(%ebp)
801016ec:	e8 3d eb ff ff       	call   8010022e <brelse>
801016f1:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801016f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f7:	83 ec 08             	sub    $0x8,%esp
801016fa:	50                   	push   %eax
801016fb:	ff 75 08             	pushl  0x8(%ebp)
801016fe:	e8 ef 00 00 00       	call   801017f2 <iget>
80101703:	83 c4 10             	add    $0x10,%esp
80101706:	eb 2d                	jmp    80101735 <ialloc+0xdf>
    }
    brelse(bp);
80101708:	83 ec 0c             	sub    $0xc,%esp
8010170b:	ff 75 f0             	pushl  -0x10(%ebp)
8010170e:	e8 1b eb ff ff       	call   8010022e <brelse>
80101713:	83 c4 10             	add    $0x10,%esp
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101716:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010171a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101720:	39 c2                	cmp    %eax,%edx
80101722:	0f 87 5a ff ff ff    	ja     80101682 <ialloc+0x2c>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101728:	83 ec 0c             	sub    $0xc,%esp
8010172b:	68 91 88 10 80       	push   $0x80108891
80101730:	e8 31 ee ff ff       	call   80100566 <panic>
}
80101735:	c9                   	leave  
80101736:	c3                   	ret    

80101737 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101737:	55                   	push   %ebp
80101738:	89 e5                	mov    %esp,%ebp
8010173a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
8010173d:	8b 45 08             	mov    0x8(%ebp),%eax
80101740:	8b 40 04             	mov    0x4(%eax),%eax
80101743:	c1 e8 03             	shr    $0x3,%eax
80101746:	8d 50 02             	lea    0x2(%eax),%edx
80101749:	8b 45 08             	mov    0x8(%ebp),%eax
8010174c:	8b 00                	mov    (%eax),%eax
8010174e:	83 ec 08             	sub    $0x8,%esp
80101751:	52                   	push   %edx
80101752:	50                   	push   %eax
80101753:	e8 5e ea ff ff       	call   801001b6 <bread>
80101758:	83 c4 10             	add    $0x10,%esp
8010175b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010175e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101761:	8d 50 18             	lea    0x18(%eax),%edx
80101764:	8b 45 08             	mov    0x8(%ebp),%eax
80101767:	8b 40 04             	mov    0x4(%eax),%eax
8010176a:	83 e0 07             	and    $0x7,%eax
8010176d:	c1 e0 06             	shl    $0x6,%eax
80101770:	01 d0                	add    %edx,%eax
80101772:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101775:	8b 45 08             	mov    0x8(%ebp),%eax
80101778:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010177c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010177f:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101782:	8b 45 08             	mov    0x8(%ebp),%eax
80101785:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101789:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010178c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101790:	8b 45 08             	mov    0x8(%ebp),%eax
80101793:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101797:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179a:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010179e:	8b 45 08             	mov    0x8(%ebp),%eax
801017a1:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a8:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801017ac:	8b 45 08             	mov    0x8(%ebp),%eax
801017af:	8b 50 18             	mov    0x18(%eax),%edx
801017b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017b5:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017b8:	8b 45 08             	mov    0x8(%ebp),%eax
801017bb:	8d 50 1c             	lea    0x1c(%eax),%edx
801017be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c1:	83 c0 0c             	add    $0xc,%eax
801017c4:	83 ec 04             	sub    $0x4,%esp
801017c7:	6a 34                	push   $0x34
801017c9:	52                   	push   %edx
801017ca:	50                   	push   %eax
801017cb:	e8 ff 3b 00 00       	call   801053cf <memmove>
801017d0:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801017d3:	83 ec 0c             	sub    $0xc,%esp
801017d6:	ff 75 f4             	pushl  -0xc(%ebp)
801017d9:	e8 0e 1f 00 00       	call   801036ec <log_write>
801017de:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801017e1:	83 ec 0c             	sub    $0xc,%esp
801017e4:	ff 75 f4             	pushl  -0xc(%ebp)
801017e7:	e8 42 ea ff ff       	call   8010022e <brelse>
801017ec:	83 c4 10             	add    $0x10,%esp
}
801017ef:	90                   	nop
801017f0:	c9                   	leave  
801017f1:	c3                   	ret    

801017f2 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017f2:	55                   	push   %ebp
801017f3:	89 e5                	mov    %esp,%ebp
801017f5:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 60 12 11 80       	push   $0x80111260
80101800:	e8 a8 38 00 00       	call   801050ad <acquire>
80101805:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101808:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010180f:	c7 45 f4 94 12 11 80 	movl   $0x80111294,-0xc(%ebp)
80101816:	eb 5d                	jmp    80101875 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181b:	8b 40 08             	mov    0x8(%eax),%eax
8010181e:	85 c0                	test   %eax,%eax
80101820:	7e 39                	jle    8010185b <iget+0x69>
80101822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101825:	8b 00                	mov    (%eax),%eax
80101827:	3b 45 08             	cmp    0x8(%ebp),%eax
8010182a:	75 2f                	jne    8010185b <iget+0x69>
8010182c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182f:	8b 40 04             	mov    0x4(%eax),%eax
80101832:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101835:	75 24                	jne    8010185b <iget+0x69>
      ip->ref++;
80101837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183a:	8b 40 08             	mov    0x8(%eax),%eax
8010183d:	8d 50 01             	lea    0x1(%eax),%edx
80101840:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101843:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101846:	83 ec 0c             	sub    $0xc,%esp
80101849:	68 60 12 11 80       	push   $0x80111260
8010184e:	e8 c1 38 00 00       	call   80105114 <release>
80101853:	83 c4 10             	add    $0x10,%esp
      return ip;
80101856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101859:	eb 74                	jmp    801018cf <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010185b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010185f:	75 10                	jne    80101871 <iget+0x7f>
80101861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101864:	8b 40 08             	mov    0x8(%eax),%eax
80101867:	85 c0                	test   %eax,%eax
80101869:	75 06                	jne    80101871 <iget+0x7f>
      empty = ip;
8010186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101871:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101875:	81 7d f4 34 22 11 80 	cmpl   $0x80112234,-0xc(%ebp)
8010187c:	72 9a                	jb     80101818 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010187e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101882:	75 0d                	jne    80101891 <iget+0x9f>
    panic("iget: no inodes");
80101884:	83 ec 0c             	sub    $0xc,%esp
80101887:	68 a3 88 10 80       	push   $0x801088a3
8010188c:	e8 d5 ec ff ff       	call   80100566 <panic>

  ip = empty;
80101891:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101894:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189a:	8b 55 08             	mov    0x8(%ebp),%edx
8010189d:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010189f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801018a5:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ab:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018bc:	83 ec 0c             	sub    $0xc,%esp
801018bf:	68 60 12 11 80       	push   $0x80111260
801018c4:	e8 4b 38 00 00       	call   80105114 <release>
801018c9:	83 c4 10             	add    $0x10,%esp

  return ip;
801018cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801018cf:	c9                   	leave  
801018d0:	c3                   	ret    

801018d1 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018d1:	55                   	push   %ebp
801018d2:	89 e5                	mov    %esp,%ebp
801018d4:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801018d7:	83 ec 0c             	sub    $0xc,%esp
801018da:	68 60 12 11 80       	push   $0x80111260
801018df:	e8 c9 37 00 00       	call   801050ad <acquire>
801018e4:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801018e7:	8b 45 08             	mov    0x8(%ebp),%eax
801018ea:	8b 40 08             	mov    0x8(%eax),%eax
801018ed:	8d 50 01             	lea    0x1(%eax),%edx
801018f0:	8b 45 08             	mov    0x8(%ebp),%eax
801018f3:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	68 60 12 11 80       	push   $0x80111260
801018fe:	e8 11 38 00 00       	call   80105114 <release>
80101903:	83 c4 10             	add    $0x10,%esp
  return ip;
80101906:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101909:	c9                   	leave  
8010190a:	c3                   	ret    

8010190b <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010190b:	55                   	push   %ebp
8010190c:	89 e5                	mov    %esp,%ebp
8010190e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101911:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101915:	74 0a                	je     80101921 <ilock+0x16>
80101917:	8b 45 08             	mov    0x8(%ebp),%eax
8010191a:	8b 40 08             	mov    0x8(%eax),%eax
8010191d:	85 c0                	test   %eax,%eax
8010191f:	7f 0d                	jg     8010192e <ilock+0x23>
    panic("ilock");
80101921:	83 ec 0c             	sub    $0xc,%esp
80101924:	68 b3 88 10 80       	push   $0x801088b3
80101929:	e8 38 ec ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
8010192e:	83 ec 0c             	sub    $0xc,%esp
80101931:	68 60 12 11 80       	push   $0x80111260
80101936:	e8 72 37 00 00       	call   801050ad <acquire>
8010193b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010193e:	eb 13                	jmp    80101953 <ilock+0x48>
    sleep(ip, &icache.lock);
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	68 60 12 11 80       	push   $0x80111260
80101948:	ff 75 08             	pushl  0x8(%ebp)
8010194b:	e8 20 33 00 00       	call   80104c70 <sleep>
80101950:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101953:	8b 45 08             	mov    0x8(%ebp),%eax
80101956:	8b 40 0c             	mov    0xc(%eax),%eax
80101959:	83 e0 01             	and    $0x1,%eax
8010195c:	85 c0                	test   %eax,%eax
8010195e:	75 e0                	jne    80101940 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101960:	8b 45 08             	mov    0x8(%ebp),%eax
80101963:	8b 40 0c             	mov    0xc(%eax),%eax
80101966:	83 c8 01             	or     $0x1,%eax
80101969:	89 c2                	mov    %eax,%edx
8010196b:	8b 45 08             	mov    0x8(%ebp),%eax
8010196e:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101971:	83 ec 0c             	sub    $0xc,%esp
80101974:	68 60 12 11 80       	push   $0x80111260
80101979:	e8 96 37 00 00       	call   80105114 <release>
8010197e:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
80101984:	8b 40 0c             	mov    0xc(%eax),%eax
80101987:	83 e0 02             	and    $0x2,%eax
8010198a:	85 c0                	test   %eax,%eax
8010198c:	0f 85 ce 00 00 00    	jne    80101a60 <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101992:	8b 45 08             	mov    0x8(%ebp),%eax
80101995:	8b 40 04             	mov    0x4(%eax),%eax
80101998:	c1 e8 03             	shr    $0x3,%eax
8010199b:	8d 50 02             	lea    0x2(%eax),%edx
8010199e:	8b 45 08             	mov    0x8(%ebp),%eax
801019a1:	8b 00                	mov    (%eax),%eax
801019a3:	83 ec 08             	sub    $0x8,%esp
801019a6:	52                   	push   %edx
801019a7:	50                   	push   %eax
801019a8:	e8 09 e8 ff ff       	call   801001b6 <bread>
801019ad:	83 c4 10             	add    $0x10,%esp
801019b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b6:	8d 50 18             	lea    0x18(%eax),%edx
801019b9:	8b 45 08             	mov    0x8(%ebp),%eax
801019bc:	8b 40 04             	mov    0x4(%eax),%eax
801019bf:	83 e0 07             	and    $0x7,%eax
801019c2:	c1 e0 06             	shl    $0x6,%eax
801019c5:	01 d0                	add    %edx,%eax
801019c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019cd:	0f b7 10             	movzwl (%eax),%edx
801019d0:	8b 45 08             	mov    0x8(%ebp),%eax
801019d3:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019da:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019de:	8b 45 08             	mov    0x8(%ebp),%eax
801019e1:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
801019e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019e8:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019ec:	8b 45 08             	mov    0x8(%ebp),%eax
801019ef:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
801019f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f6:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019fa:	8b 45 08             	mov    0x8(%ebp),%eax
801019fd:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a04:	8b 50 08             	mov    0x8(%eax),%edx
80101a07:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0a:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a10:	8d 50 0c             	lea    0xc(%eax),%edx
80101a13:	8b 45 08             	mov    0x8(%ebp),%eax
80101a16:	83 c0 1c             	add    $0x1c,%eax
80101a19:	83 ec 04             	sub    $0x4,%esp
80101a1c:	6a 34                	push   $0x34
80101a1e:	52                   	push   %edx
80101a1f:	50                   	push   %eax
80101a20:	e8 aa 39 00 00       	call   801053cf <memmove>
80101a25:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a28:	83 ec 0c             	sub    $0xc,%esp
80101a2b:	ff 75 f4             	pushl  -0xc(%ebp)
80101a2e:	e8 fb e7 ff ff       	call   8010022e <brelse>
80101a33:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a36:	8b 45 08             	mov    0x8(%ebp),%eax
80101a39:	8b 40 0c             	mov    0xc(%eax),%eax
80101a3c:	83 c8 02             	or     $0x2,%eax
80101a3f:	89 c2                	mov    %eax,%edx
80101a41:	8b 45 08             	mov    0x8(%ebp),%eax
80101a44:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a47:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a4e:	66 85 c0             	test   %ax,%ax
80101a51:	75 0d                	jne    80101a60 <ilock+0x155>
      panic("ilock: no type");
80101a53:	83 ec 0c             	sub    $0xc,%esp
80101a56:	68 b9 88 10 80       	push   $0x801088b9
80101a5b:	e8 06 eb ff ff       	call   80100566 <panic>
  }
}
80101a60:	90                   	nop
80101a61:	c9                   	leave  
80101a62:	c3                   	ret    

80101a63 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a63:	55                   	push   %ebp
80101a64:	89 e5                	mov    %esp,%ebp
80101a66:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a6d:	74 17                	je     80101a86 <iunlock+0x23>
80101a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a72:	8b 40 0c             	mov    0xc(%eax),%eax
80101a75:	83 e0 01             	and    $0x1,%eax
80101a78:	85 c0                	test   %eax,%eax
80101a7a:	74 0a                	je     80101a86 <iunlock+0x23>
80101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7f:	8b 40 08             	mov    0x8(%eax),%eax
80101a82:	85 c0                	test   %eax,%eax
80101a84:	7f 0d                	jg     80101a93 <iunlock+0x30>
    panic("iunlock");
80101a86:	83 ec 0c             	sub    $0xc,%esp
80101a89:	68 c8 88 10 80       	push   $0x801088c8
80101a8e:	e8 d3 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a93:	83 ec 0c             	sub    $0xc,%esp
80101a96:	68 60 12 11 80       	push   $0x80111260
80101a9b:	e8 0d 36 00 00       	call   801050ad <acquire>
80101aa0:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	8b 40 0c             	mov    0xc(%eax),%eax
80101aa9:	83 e0 fe             	and    $0xfffffffe,%eax
80101aac:	89 c2                	mov    %eax,%edx
80101aae:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab1:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101ab4:	83 ec 0c             	sub    $0xc,%esp
80101ab7:	ff 75 08             	pushl  0x8(%ebp)
80101aba:	e8 9f 32 00 00       	call   80104d5e <wakeup>
80101abf:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ac2:	83 ec 0c             	sub    $0xc,%esp
80101ac5:	68 60 12 11 80       	push   $0x80111260
80101aca:	e8 45 36 00 00       	call   80105114 <release>
80101acf:	83 c4 10             	add    $0x10,%esp
}
80101ad2:	90                   	nop
80101ad3:	c9                   	leave  
80101ad4:	c3                   	ret    

80101ad5 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101ad5:	55                   	push   %ebp
80101ad6:	89 e5                	mov    %esp,%ebp
80101ad8:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101adb:	83 ec 0c             	sub    $0xc,%esp
80101ade:	68 60 12 11 80       	push   $0x80111260
80101ae3:	e8 c5 35 00 00       	call   801050ad <acquire>
80101ae8:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101aeb:	8b 45 08             	mov    0x8(%ebp),%eax
80101aee:	8b 40 08             	mov    0x8(%eax),%eax
80101af1:	83 f8 01             	cmp    $0x1,%eax
80101af4:	0f 85 a9 00 00 00    	jne    80101ba3 <iput+0xce>
80101afa:	8b 45 08             	mov    0x8(%ebp),%eax
80101afd:	8b 40 0c             	mov    0xc(%eax),%eax
80101b00:	83 e0 02             	and    $0x2,%eax
80101b03:	85 c0                	test   %eax,%eax
80101b05:	0f 84 98 00 00 00    	je     80101ba3 <iput+0xce>
80101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b12:	66 85 c0             	test   %ax,%ax
80101b15:	0f 85 88 00 00 00    	jne    80101ba3 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1e:	8b 40 0c             	mov    0xc(%eax),%eax
80101b21:	83 e0 01             	and    $0x1,%eax
80101b24:	85 c0                	test   %eax,%eax
80101b26:	74 0d                	je     80101b35 <iput+0x60>
      panic("iput busy");
80101b28:	83 ec 0c             	sub    $0xc,%esp
80101b2b:	68 d0 88 10 80       	push   $0x801088d0
80101b30:	e8 31 ea ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101b35:	8b 45 08             	mov    0x8(%ebp),%eax
80101b38:	8b 40 0c             	mov    0xc(%eax),%eax
80101b3b:	83 c8 01             	or     $0x1,%eax
80101b3e:	89 c2                	mov    %eax,%edx
80101b40:	8b 45 08             	mov    0x8(%ebp),%eax
80101b43:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b46:	83 ec 0c             	sub    $0xc,%esp
80101b49:	68 60 12 11 80       	push   $0x80111260
80101b4e:	e8 c1 35 00 00       	call   80105114 <release>
80101b53:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b56:	83 ec 0c             	sub    $0xc,%esp
80101b59:	ff 75 08             	pushl  0x8(%ebp)
80101b5c:	e8 a8 01 00 00       	call   80101d09 <itrunc>
80101b61:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b64:	8b 45 08             	mov    0x8(%ebp),%eax
80101b67:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b6d:	83 ec 0c             	sub    $0xc,%esp
80101b70:	ff 75 08             	pushl  0x8(%ebp)
80101b73:	e8 bf fb ff ff       	call   80101737 <iupdate>
80101b78:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
80101b7e:	68 60 12 11 80       	push   $0x80111260
80101b83:	e8 25 35 00 00       	call   801050ad <acquire>
80101b88:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b95:	83 ec 0c             	sub    $0xc,%esp
80101b98:	ff 75 08             	pushl  0x8(%ebp)
80101b9b:	e8 be 31 00 00       	call   80104d5e <wakeup>
80101ba0:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101ba3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba6:	8b 40 08             	mov    0x8(%eax),%eax
80101ba9:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bac:	8b 45 08             	mov    0x8(%ebp),%eax
80101baf:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bb2:	83 ec 0c             	sub    $0xc,%esp
80101bb5:	68 60 12 11 80       	push   $0x80111260
80101bba:	e8 55 35 00 00       	call   80105114 <release>
80101bbf:	83 c4 10             	add    $0x10,%esp
}
80101bc2:	90                   	nop
80101bc3:	c9                   	leave  
80101bc4:	c3                   	ret    

80101bc5 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101bc5:	55                   	push   %ebp
80101bc6:	89 e5                	mov    %esp,%ebp
80101bc8:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101bcb:	83 ec 0c             	sub    $0xc,%esp
80101bce:	ff 75 08             	pushl  0x8(%ebp)
80101bd1:	e8 8d fe ff ff       	call   80101a63 <iunlock>
80101bd6:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101bd9:	83 ec 0c             	sub    $0xc,%esp
80101bdc:	ff 75 08             	pushl  0x8(%ebp)
80101bdf:	e8 f1 fe ff ff       	call   80101ad5 <iput>
80101be4:	83 c4 10             	add    $0x10,%esp
}
80101be7:	90                   	nop
80101be8:	c9                   	leave  
80101be9:	c3                   	ret    

80101bea <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101bea:	55                   	push   %ebp
80101beb:	89 e5                	mov    %esp,%ebp
80101bed:	53                   	push   %ebx
80101bee:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101bf1:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bf5:	77 42                	ja     80101c39 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bfd:	83 c2 04             	add    $0x4,%edx
80101c00:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c0b:	75 24                	jne    80101c31 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c10:	8b 00                	mov    (%eax),%eax
80101c12:	83 ec 0c             	sub    $0xc,%esp
80101c15:	50                   	push   %eax
80101c16:	e8 e4 f7 ff ff       	call   801013ff <balloc>
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c21:	8b 45 08             	mov    0x8(%ebp),%eax
80101c24:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c27:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c2d:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c34:	e9 cb 00 00 00       	jmp    80101d04 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101c39:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c3d:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c41:	0f 87 b0 00 00 00    	ja     80101cf7 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c47:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c54:	75 1d                	jne    80101c73 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c56:	8b 45 08             	mov    0x8(%ebp),%eax
80101c59:	8b 00                	mov    (%eax),%eax
80101c5b:	83 ec 0c             	sub    $0xc,%esp
80101c5e:	50                   	push   %eax
80101c5f:	e8 9b f7 ff ff       	call   801013ff <balloc>
80101c64:	83 c4 10             	add    $0x10,%esp
80101c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c70:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c73:	8b 45 08             	mov    0x8(%ebp),%eax
80101c76:	8b 00                	mov    (%eax),%eax
80101c78:	83 ec 08             	sub    $0x8,%esp
80101c7b:	ff 75 f4             	pushl  -0xc(%ebp)
80101c7e:	50                   	push   %eax
80101c7f:	e8 32 e5 ff ff       	call   801001b6 <bread>
80101c84:	83 c4 10             	add    $0x10,%esp
80101c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c8d:	83 c0 18             	add    $0x18,%eax
80101c90:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c93:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ca0:	01 d0                	add    %edx,%eax
80101ca2:	8b 00                	mov    (%eax),%eax
80101ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cab:	75 37                	jne    80101ce4 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101cad:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cb0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cba:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc0:	8b 00                	mov    (%eax),%eax
80101cc2:	83 ec 0c             	sub    $0xc,%esp
80101cc5:	50                   	push   %eax
80101cc6:	e8 34 f7 ff ff       	call   801013ff <balloc>
80101ccb:	83 c4 10             	add    $0x10,%esp
80101cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cd4:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101cd6:	83 ec 0c             	sub    $0xc,%esp
80101cd9:	ff 75 f0             	pushl  -0x10(%ebp)
80101cdc:	e8 0b 1a 00 00       	call   801036ec <log_write>
80101ce1:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101ce4:	83 ec 0c             	sub    $0xc,%esp
80101ce7:	ff 75 f0             	pushl  -0x10(%ebp)
80101cea:	e8 3f e5 ff ff       	call   8010022e <brelse>
80101cef:	83 c4 10             	add    $0x10,%esp
    return addr;
80101cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cf5:	eb 0d                	jmp    80101d04 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101cf7:	83 ec 0c             	sub    $0xc,%esp
80101cfa:	68 da 88 10 80       	push   $0x801088da
80101cff:	e8 62 e8 ff ff       	call   80100566 <panic>
}
80101d04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d07:	c9                   	leave  
80101d08:	c3                   	ret    

80101d09 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d09:	55                   	push   %ebp
80101d0a:	89 e5                	mov    %esp,%ebp
80101d0c:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d16:	eb 45                	jmp    80101d5d <itrunc+0x54>
    if(ip->addrs[i]){
80101d18:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d1e:	83 c2 04             	add    $0x4,%edx
80101d21:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d25:	85 c0                	test   %eax,%eax
80101d27:	74 30                	je     80101d59 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d2f:	83 c2 04             	add    $0x4,%edx
80101d32:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d36:	8b 55 08             	mov    0x8(%ebp),%edx
80101d39:	8b 12                	mov    (%edx),%edx
80101d3b:	83 ec 08             	sub    $0x8,%esp
80101d3e:	50                   	push   %eax
80101d3f:	52                   	push   %edx
80101d40:	e8 18 f8 ff ff       	call   8010155d <bfree>
80101d45:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d48:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d4e:	83 c2 04             	add    $0x4,%edx
80101d51:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d58:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d5d:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d61:	7e b5                	jle    80101d18 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d63:	8b 45 08             	mov    0x8(%ebp),%eax
80101d66:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d69:	85 c0                	test   %eax,%eax
80101d6b:	0f 84 a1 00 00 00    	je     80101e12 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d71:	8b 45 08             	mov    0x8(%ebp),%eax
80101d74:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d77:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7a:	8b 00                	mov    (%eax),%eax
80101d7c:	83 ec 08             	sub    $0x8,%esp
80101d7f:	52                   	push   %edx
80101d80:	50                   	push   %eax
80101d81:	e8 30 e4 ff ff       	call   801001b6 <bread>
80101d86:	83 c4 10             	add    $0x10,%esp
80101d89:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d8f:	83 c0 18             	add    $0x18,%eax
80101d92:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d9c:	eb 3c                	jmp    80101dda <itrunc+0xd1>
      if(a[j])
80101d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101da1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dab:	01 d0                	add    %edx,%eax
80101dad:	8b 00                	mov    (%eax),%eax
80101daf:	85 c0                	test   %eax,%eax
80101db1:	74 23                	je     80101dd6 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101db6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dc0:	01 d0                	add    %edx,%eax
80101dc2:	8b 00                	mov    (%eax),%eax
80101dc4:	8b 55 08             	mov    0x8(%ebp),%edx
80101dc7:	8b 12                	mov    (%edx),%edx
80101dc9:	83 ec 08             	sub    $0x8,%esp
80101dcc:	50                   	push   %eax
80101dcd:	52                   	push   %edx
80101dce:	e8 8a f7 ff ff       	call   8010155d <bfree>
80101dd3:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101dd6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ddd:	83 f8 7f             	cmp    $0x7f,%eax
80101de0:	76 bc                	jbe    80101d9e <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101de2:	83 ec 0c             	sub    $0xc,%esp
80101de5:	ff 75 ec             	pushl  -0x14(%ebp)
80101de8:	e8 41 e4 ff ff       	call   8010022e <brelse>
80101ded:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101df0:	8b 45 08             	mov    0x8(%ebp),%eax
80101df3:	8b 40 4c             	mov    0x4c(%eax),%eax
80101df6:	8b 55 08             	mov    0x8(%ebp),%edx
80101df9:	8b 12                	mov    (%edx),%edx
80101dfb:	83 ec 08             	sub    $0x8,%esp
80101dfe:	50                   	push   %eax
80101dff:	52                   	push   %edx
80101e00:	e8 58 f7 ff ff       	call   8010155d <bfree>
80101e05:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e08:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0b:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e12:	8b 45 08             	mov    0x8(%ebp),%eax
80101e15:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	ff 75 08             	pushl  0x8(%ebp)
80101e22:	e8 10 f9 ff ff       	call   80101737 <iupdate>
80101e27:	83 c4 10             	add    $0x10,%esp
}
80101e2a:	90                   	nop
80101e2b:	c9                   	leave  
80101e2c:	c3                   	ret    

80101e2d <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e2d:	55                   	push   %ebp
80101e2e:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e30:	8b 45 08             	mov    0x8(%ebp),%eax
80101e33:	8b 00                	mov    (%eax),%eax
80101e35:	89 c2                	mov    %eax,%edx
80101e37:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e3a:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e40:	8b 50 04             	mov    0x4(%eax),%edx
80101e43:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e46:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e49:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4c:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e50:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e53:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e56:	8b 45 08             	mov    0x8(%ebp),%eax
80101e59:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e60:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e64:	8b 45 08             	mov    0x8(%ebp),%eax
80101e67:	8b 50 18             	mov    0x18(%eax),%edx
80101e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e6d:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e70:	90                   	nop
80101e71:	5d                   	pop    %ebp
80101e72:	c3                   	ret    

80101e73 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e73:	55                   	push   %ebp
80101e74:	89 e5                	mov    %esp,%ebp
80101e76:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e79:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e80:	66 83 f8 03          	cmp    $0x3,%ax
80101e84:	75 5c                	jne    80101ee2 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e86:	8b 45 08             	mov    0x8(%ebp),%eax
80101e89:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e8d:	66 85 c0             	test   %ax,%ax
80101e90:	78 20                	js     80101eb2 <readi+0x3f>
80101e92:	8b 45 08             	mov    0x8(%ebp),%eax
80101e95:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e99:	66 83 f8 09          	cmp    $0x9,%ax
80101e9d:	7f 13                	jg     80101eb2 <readi+0x3f>
80101e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ea6:	98                   	cwtl   
80101ea7:	8b 04 c5 00 12 11 80 	mov    -0x7feeee00(,%eax,8),%eax
80101eae:	85 c0                	test   %eax,%eax
80101eb0:	75 0a                	jne    80101ebc <readi+0x49>
      return -1;
80101eb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb7:	e9 0c 01 00 00       	jmp    80101fc8 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebf:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ec3:	98                   	cwtl   
80101ec4:	8b 04 c5 00 12 11 80 	mov    -0x7feeee00(,%eax,8),%eax
80101ecb:	8b 55 14             	mov    0x14(%ebp),%edx
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	52                   	push   %edx
80101ed2:	ff 75 0c             	pushl  0xc(%ebp)
80101ed5:	ff 75 08             	pushl  0x8(%ebp)
80101ed8:	ff d0                	call   *%eax
80101eda:	83 c4 10             	add    $0x10,%esp
80101edd:	e9 e6 00 00 00       	jmp    80101fc8 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee5:	8b 40 18             	mov    0x18(%eax),%eax
80101ee8:	3b 45 10             	cmp    0x10(%ebp),%eax
80101eeb:	72 0d                	jb     80101efa <readi+0x87>
80101eed:	8b 55 10             	mov    0x10(%ebp),%edx
80101ef0:	8b 45 14             	mov    0x14(%ebp),%eax
80101ef3:	01 d0                	add    %edx,%eax
80101ef5:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ef8:	73 0a                	jae    80101f04 <readi+0x91>
    return -1;
80101efa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eff:	e9 c4 00 00 00       	jmp    80101fc8 <readi+0x155>
  if(off + n > ip->size)
80101f04:	8b 55 10             	mov    0x10(%ebp),%edx
80101f07:	8b 45 14             	mov    0x14(%ebp),%eax
80101f0a:	01 c2                	add    %eax,%edx
80101f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0f:	8b 40 18             	mov    0x18(%eax),%eax
80101f12:	39 c2                	cmp    %eax,%edx
80101f14:	76 0c                	jbe    80101f22 <readi+0xaf>
    n = ip->size - off;
80101f16:	8b 45 08             	mov    0x8(%ebp),%eax
80101f19:	8b 40 18             	mov    0x18(%eax),%eax
80101f1c:	2b 45 10             	sub    0x10(%ebp),%eax
80101f1f:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f29:	e9 8b 00 00 00       	jmp    80101fb9 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f2e:	8b 45 10             	mov    0x10(%ebp),%eax
80101f31:	c1 e8 09             	shr    $0x9,%eax
80101f34:	83 ec 08             	sub    $0x8,%esp
80101f37:	50                   	push   %eax
80101f38:	ff 75 08             	pushl  0x8(%ebp)
80101f3b:	e8 aa fc ff ff       	call   80101bea <bmap>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	89 c2                	mov    %eax,%edx
80101f45:	8b 45 08             	mov    0x8(%ebp),%eax
80101f48:	8b 00                	mov    (%eax),%eax
80101f4a:	83 ec 08             	sub    $0x8,%esp
80101f4d:	52                   	push   %edx
80101f4e:	50                   	push   %eax
80101f4f:	e8 62 e2 ff ff       	call   801001b6 <bread>
80101f54:	83 c4 10             	add    $0x10,%esp
80101f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f5a:	8b 45 10             	mov    0x10(%ebp),%eax
80101f5d:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f62:	ba 00 02 00 00       	mov    $0x200,%edx
80101f67:	29 c2                	sub    %eax,%edx
80101f69:	8b 45 14             	mov    0x14(%ebp),%eax
80101f6c:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f6f:	39 c2                	cmp    %eax,%edx
80101f71:	0f 46 c2             	cmovbe %edx,%eax
80101f74:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f7a:	8d 50 18             	lea    0x18(%eax),%edx
80101f7d:	8b 45 10             	mov    0x10(%ebp),%eax
80101f80:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f85:	01 d0                	add    %edx,%eax
80101f87:	83 ec 04             	sub    $0x4,%esp
80101f8a:	ff 75 ec             	pushl  -0x14(%ebp)
80101f8d:	50                   	push   %eax
80101f8e:	ff 75 0c             	pushl  0xc(%ebp)
80101f91:	e8 39 34 00 00       	call   801053cf <memmove>
80101f96:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101f99:	83 ec 0c             	sub    $0xc,%esp
80101f9c:	ff 75 f0             	pushl  -0x10(%ebp)
80101f9f:	e8 8a e2 ff ff       	call   8010022e <brelse>
80101fa4:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101faa:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fb0:	01 45 10             	add    %eax,0x10(%ebp)
80101fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fb6:	01 45 0c             	add    %eax,0xc(%ebp)
80101fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fbc:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fbf:	0f 82 69 ff ff ff    	jb     80101f2e <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101fc5:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101fc8:	c9                   	leave  
80101fc9:	c3                   	ret    

80101fca <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101fca:	55                   	push   %ebp
80101fcb:	89 e5                	mov    %esp,%ebp
80101fcd:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101fd7:	66 83 f8 03          	cmp    $0x3,%ax
80101fdb:	75 5c                	jne    80102039 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101fdd:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fe4:	66 85 c0             	test   %ax,%ax
80101fe7:	78 20                	js     80102009 <writei+0x3f>
80101fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fec:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ff0:	66 83 f8 09          	cmp    $0x9,%ax
80101ff4:	7f 13                	jg     80102009 <writei+0x3f>
80101ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ffd:	98                   	cwtl   
80101ffe:	8b 04 c5 04 12 11 80 	mov    -0x7feeedfc(,%eax,8),%eax
80102005:	85 c0                	test   %eax,%eax
80102007:	75 0a                	jne    80102013 <writei+0x49>
      return -1;
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	e9 3d 01 00 00       	jmp    80102150 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102013:	8b 45 08             	mov    0x8(%ebp),%eax
80102016:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010201a:	98                   	cwtl   
8010201b:	8b 04 c5 04 12 11 80 	mov    -0x7feeedfc(,%eax,8),%eax
80102022:	8b 55 14             	mov    0x14(%ebp),%edx
80102025:	83 ec 04             	sub    $0x4,%esp
80102028:	52                   	push   %edx
80102029:	ff 75 0c             	pushl  0xc(%ebp)
8010202c:	ff 75 08             	pushl  0x8(%ebp)
8010202f:	ff d0                	call   *%eax
80102031:	83 c4 10             	add    $0x10,%esp
80102034:	e9 17 01 00 00       	jmp    80102150 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102039:	8b 45 08             	mov    0x8(%ebp),%eax
8010203c:	8b 40 18             	mov    0x18(%eax),%eax
8010203f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102042:	72 0d                	jb     80102051 <writei+0x87>
80102044:	8b 55 10             	mov    0x10(%ebp),%edx
80102047:	8b 45 14             	mov    0x14(%ebp),%eax
8010204a:	01 d0                	add    %edx,%eax
8010204c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010204f:	73 0a                	jae    8010205b <writei+0x91>
    return -1;
80102051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102056:	e9 f5 00 00 00       	jmp    80102150 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
8010205b:	8b 55 10             	mov    0x10(%ebp),%edx
8010205e:	8b 45 14             	mov    0x14(%ebp),%eax
80102061:	01 d0                	add    %edx,%eax
80102063:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102068:	76 0a                	jbe    80102074 <writei+0xaa>
    return -1;
8010206a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010206f:	e9 dc 00 00 00       	jmp    80102150 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102074:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010207b:	e9 99 00 00 00       	jmp    80102119 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102080:	8b 45 10             	mov    0x10(%ebp),%eax
80102083:	c1 e8 09             	shr    $0x9,%eax
80102086:	83 ec 08             	sub    $0x8,%esp
80102089:	50                   	push   %eax
8010208a:	ff 75 08             	pushl  0x8(%ebp)
8010208d:	e8 58 fb ff ff       	call   80101bea <bmap>
80102092:	83 c4 10             	add    $0x10,%esp
80102095:	89 c2                	mov    %eax,%edx
80102097:	8b 45 08             	mov    0x8(%ebp),%eax
8010209a:	8b 00                	mov    (%eax),%eax
8010209c:	83 ec 08             	sub    $0x8,%esp
8010209f:	52                   	push   %edx
801020a0:	50                   	push   %eax
801020a1:	e8 10 e1 ff ff       	call   801001b6 <bread>
801020a6:	83 c4 10             	add    $0x10,%esp
801020a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020ac:	8b 45 10             	mov    0x10(%ebp),%eax
801020af:	25 ff 01 00 00       	and    $0x1ff,%eax
801020b4:	ba 00 02 00 00       	mov    $0x200,%edx
801020b9:	29 c2                	sub    %eax,%edx
801020bb:	8b 45 14             	mov    0x14(%ebp),%eax
801020be:	2b 45 f4             	sub    -0xc(%ebp),%eax
801020c1:	39 c2                	cmp    %eax,%edx
801020c3:	0f 46 c2             	cmovbe %edx,%eax
801020c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020cc:	8d 50 18             	lea    0x18(%eax),%edx
801020cf:	8b 45 10             	mov    0x10(%ebp),%eax
801020d2:	25 ff 01 00 00       	and    $0x1ff,%eax
801020d7:	01 d0                	add    %edx,%eax
801020d9:	83 ec 04             	sub    $0x4,%esp
801020dc:	ff 75 ec             	pushl  -0x14(%ebp)
801020df:	ff 75 0c             	pushl  0xc(%ebp)
801020e2:	50                   	push   %eax
801020e3:	e8 e7 32 00 00       	call   801053cf <memmove>
801020e8:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801020eb:	83 ec 0c             	sub    $0xc,%esp
801020ee:	ff 75 f0             	pushl  -0x10(%ebp)
801020f1:	e8 f6 15 00 00       	call   801036ec <log_write>
801020f6:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020f9:	83 ec 0c             	sub    $0xc,%esp
801020fc:	ff 75 f0             	pushl  -0x10(%ebp)
801020ff:	e8 2a e1 ff ff       	call   8010022e <brelse>
80102104:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102107:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010210a:	01 45 f4             	add    %eax,-0xc(%ebp)
8010210d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102110:	01 45 10             	add    %eax,0x10(%ebp)
80102113:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102116:	01 45 0c             	add    %eax,0xc(%ebp)
80102119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010211c:	3b 45 14             	cmp    0x14(%ebp),%eax
8010211f:	0f 82 5b ff ff ff    	jb     80102080 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102125:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102129:	74 22                	je     8010214d <writei+0x183>
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
8010212e:	8b 40 18             	mov    0x18(%eax),%eax
80102131:	3b 45 10             	cmp    0x10(%ebp),%eax
80102134:	73 17                	jae    8010214d <writei+0x183>
    ip->size = off;
80102136:	8b 45 08             	mov    0x8(%ebp),%eax
80102139:	8b 55 10             	mov    0x10(%ebp),%edx
8010213c:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010213f:	83 ec 0c             	sub    $0xc,%esp
80102142:	ff 75 08             	pushl  0x8(%ebp)
80102145:	e8 ed f5 ff ff       	call   80101737 <iupdate>
8010214a:	83 c4 10             	add    $0x10,%esp
  }
  return n;
8010214d:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102150:	c9                   	leave  
80102151:	c3                   	ret    

80102152 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102152:	55                   	push   %ebp
80102153:	89 e5                	mov    %esp,%ebp
80102155:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102158:	83 ec 04             	sub    $0x4,%esp
8010215b:	6a 0e                	push   $0xe
8010215d:	ff 75 0c             	pushl  0xc(%ebp)
80102160:	ff 75 08             	pushl  0x8(%ebp)
80102163:	e8 fd 32 00 00       	call   80105465 <strncmp>
80102168:	83 c4 10             	add    $0x10,%esp
}
8010216b:	c9                   	leave  
8010216c:	c3                   	ret    

8010216d <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010216d:	55                   	push   %ebp
8010216e:	89 e5                	mov    %esp,%ebp
80102170:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102173:	8b 45 08             	mov    0x8(%ebp),%eax
80102176:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010217a:	66 83 f8 01          	cmp    $0x1,%ax
8010217e:	74 0d                	je     8010218d <dirlookup+0x20>
    panic("dirlookup not DIR");
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	68 ed 88 10 80       	push   $0x801088ed
80102188:	e8 d9 e3 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010218d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102194:	eb 7b                	jmp    80102211 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102196:	6a 10                	push   $0x10
80102198:	ff 75 f4             	pushl  -0xc(%ebp)
8010219b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010219e:	50                   	push   %eax
8010219f:	ff 75 08             	pushl  0x8(%ebp)
801021a2:	e8 cc fc ff ff       	call   80101e73 <readi>
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	83 f8 10             	cmp    $0x10,%eax
801021ad:	74 0d                	je     801021bc <dirlookup+0x4f>
      panic("dirlink read");
801021af:	83 ec 0c             	sub    $0xc,%esp
801021b2:	68 ff 88 10 80       	push   $0x801088ff
801021b7:	e8 aa e3 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801021bc:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021c0:	66 85 c0             	test   %ax,%ax
801021c3:	74 47                	je     8010220c <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801021c5:	83 ec 08             	sub    $0x8,%esp
801021c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021cb:	83 c0 02             	add    $0x2,%eax
801021ce:	50                   	push   %eax
801021cf:	ff 75 0c             	pushl  0xc(%ebp)
801021d2:	e8 7b ff ff ff       	call   80102152 <namecmp>
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	85 c0                	test   %eax,%eax
801021dc:	75 2f                	jne    8010220d <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801021de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021e2:	74 08                	je     801021ec <dirlookup+0x7f>
        *poff = off;
801021e4:	8b 45 10             	mov    0x10(%ebp),%eax
801021e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021ea:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801021ec:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021f0:	0f b7 c0             	movzwl %ax,%eax
801021f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801021f6:	8b 45 08             	mov    0x8(%ebp),%eax
801021f9:	8b 00                	mov    (%eax),%eax
801021fb:	83 ec 08             	sub    $0x8,%esp
801021fe:	ff 75 f0             	pushl  -0x10(%ebp)
80102201:	50                   	push   %eax
80102202:	e8 eb f5 ff ff       	call   801017f2 <iget>
80102207:	83 c4 10             	add    $0x10,%esp
8010220a:	eb 19                	jmp    80102225 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010220c:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010220d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102211:	8b 45 08             	mov    0x8(%ebp),%eax
80102214:	8b 40 18             	mov    0x18(%eax),%eax
80102217:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010221a:	0f 87 76 ff ff ff    	ja     80102196 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102220:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102225:	c9                   	leave  
80102226:	c3                   	ret    

80102227 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102227:	55                   	push   %ebp
80102228:	89 e5                	mov    %esp,%ebp
8010222a:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010222d:	83 ec 04             	sub    $0x4,%esp
80102230:	6a 00                	push   $0x0
80102232:	ff 75 0c             	pushl  0xc(%ebp)
80102235:	ff 75 08             	pushl  0x8(%ebp)
80102238:	e8 30 ff ff ff       	call   8010216d <dirlookup>
8010223d:	83 c4 10             	add    $0x10,%esp
80102240:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102243:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102247:	74 18                	je     80102261 <dirlink+0x3a>
    iput(ip);
80102249:	83 ec 0c             	sub    $0xc,%esp
8010224c:	ff 75 f0             	pushl  -0x10(%ebp)
8010224f:	e8 81 f8 ff ff       	call   80101ad5 <iput>
80102254:	83 c4 10             	add    $0x10,%esp
    return -1;
80102257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010225c:	e9 9c 00 00 00       	jmp    801022fd <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102268:	eb 39                	jmp    801022a3 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010226d:	6a 10                	push   $0x10
8010226f:	50                   	push   %eax
80102270:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102273:	50                   	push   %eax
80102274:	ff 75 08             	pushl  0x8(%ebp)
80102277:	e8 f7 fb ff ff       	call   80101e73 <readi>
8010227c:	83 c4 10             	add    $0x10,%esp
8010227f:	83 f8 10             	cmp    $0x10,%eax
80102282:	74 0d                	je     80102291 <dirlink+0x6a>
      panic("dirlink read");
80102284:	83 ec 0c             	sub    $0xc,%esp
80102287:	68 ff 88 10 80       	push   $0x801088ff
8010228c:	e8 d5 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102291:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102295:	66 85 c0             	test   %ax,%ax
80102298:	74 18                	je     801022b2 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010229d:	83 c0 10             	add    $0x10,%eax
801022a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022a3:	8b 45 08             	mov    0x8(%ebp),%eax
801022a6:	8b 50 18             	mov    0x18(%eax),%edx
801022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022ac:	39 c2                	cmp    %eax,%edx
801022ae:	77 ba                	ja     8010226a <dirlink+0x43>
801022b0:	eb 01                	jmp    801022b3 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801022b2:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801022b3:	83 ec 04             	sub    $0x4,%esp
801022b6:	6a 0e                	push   $0xe
801022b8:	ff 75 0c             	pushl  0xc(%ebp)
801022bb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022be:	83 c0 02             	add    $0x2,%eax
801022c1:	50                   	push   %eax
801022c2:	e8 f4 31 00 00       	call   801054bb <strncpy>
801022c7:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801022ca:	8b 45 10             	mov    0x10(%ebp),%eax
801022cd:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d4:	6a 10                	push   $0x10
801022d6:	50                   	push   %eax
801022d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022da:	50                   	push   %eax
801022db:	ff 75 08             	pushl  0x8(%ebp)
801022de:	e8 e7 fc ff ff       	call   80101fca <writei>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	83 f8 10             	cmp    $0x10,%eax
801022e9:	74 0d                	je     801022f8 <dirlink+0xd1>
    panic("dirlink");
801022eb:	83 ec 0c             	sub    $0xc,%esp
801022ee:	68 0c 89 10 80       	push   $0x8010890c
801022f3:	e8 6e e2 ff ff       	call   80100566 <panic>
  
  return 0;
801022f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022fd:	c9                   	leave  
801022fe:	c3                   	ret    

801022ff <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022ff:	55                   	push   %ebp
80102300:	89 e5                	mov    %esp,%ebp
80102302:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102305:	eb 04                	jmp    8010230b <skipelem+0xc>
    path++;
80102307:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010230b:	8b 45 08             	mov    0x8(%ebp),%eax
8010230e:	0f b6 00             	movzbl (%eax),%eax
80102311:	3c 2f                	cmp    $0x2f,%al
80102313:	74 f2                	je     80102307 <skipelem+0x8>
    path++;
  if(*path == 0)
80102315:	8b 45 08             	mov    0x8(%ebp),%eax
80102318:	0f b6 00             	movzbl (%eax),%eax
8010231b:	84 c0                	test   %al,%al
8010231d:	75 07                	jne    80102326 <skipelem+0x27>
    return 0;
8010231f:	b8 00 00 00 00       	mov    $0x0,%eax
80102324:	eb 7b                	jmp    801023a1 <skipelem+0xa2>
  s = path;
80102326:	8b 45 08             	mov    0x8(%ebp),%eax
80102329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010232c:	eb 04                	jmp    80102332 <skipelem+0x33>
    path++;
8010232e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102332:	8b 45 08             	mov    0x8(%ebp),%eax
80102335:	0f b6 00             	movzbl (%eax),%eax
80102338:	3c 2f                	cmp    $0x2f,%al
8010233a:	74 0a                	je     80102346 <skipelem+0x47>
8010233c:	8b 45 08             	mov    0x8(%ebp),%eax
8010233f:	0f b6 00             	movzbl (%eax),%eax
80102342:	84 c0                	test   %al,%al
80102344:	75 e8                	jne    8010232e <skipelem+0x2f>
    path++;
  len = path - s;
80102346:	8b 55 08             	mov    0x8(%ebp),%edx
80102349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010234c:	29 c2                	sub    %eax,%edx
8010234e:	89 d0                	mov    %edx,%eax
80102350:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102353:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102357:	7e 15                	jle    8010236e <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102359:	83 ec 04             	sub    $0x4,%esp
8010235c:	6a 0e                	push   $0xe
8010235e:	ff 75 f4             	pushl  -0xc(%ebp)
80102361:	ff 75 0c             	pushl  0xc(%ebp)
80102364:	e8 66 30 00 00       	call   801053cf <memmove>
80102369:	83 c4 10             	add    $0x10,%esp
8010236c:	eb 26                	jmp    80102394 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102371:	83 ec 04             	sub    $0x4,%esp
80102374:	50                   	push   %eax
80102375:	ff 75 f4             	pushl  -0xc(%ebp)
80102378:	ff 75 0c             	pushl  0xc(%ebp)
8010237b:	e8 4f 30 00 00       	call   801053cf <memmove>
80102380:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102383:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102386:	8b 45 0c             	mov    0xc(%ebp),%eax
80102389:	01 d0                	add    %edx,%eax
8010238b:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010238e:	eb 04                	jmp    80102394 <skipelem+0x95>
    path++;
80102390:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102394:	8b 45 08             	mov    0x8(%ebp),%eax
80102397:	0f b6 00             	movzbl (%eax),%eax
8010239a:	3c 2f                	cmp    $0x2f,%al
8010239c:	74 f2                	je     80102390 <skipelem+0x91>
    path++;
  return path;
8010239e:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023a1:	c9                   	leave  
801023a2:	c3                   	ret    

801023a3 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023a3:	55                   	push   %ebp
801023a4:	89 e5                	mov    %esp,%ebp
801023a6:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023a9:	8b 45 08             	mov    0x8(%ebp),%eax
801023ac:	0f b6 00             	movzbl (%eax),%eax
801023af:	3c 2f                	cmp    $0x2f,%al
801023b1:	75 17                	jne    801023ca <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801023b3:	83 ec 08             	sub    $0x8,%esp
801023b6:	6a 01                	push   $0x1
801023b8:	6a 01                	push   $0x1
801023ba:	e8 33 f4 ff ff       	call   801017f2 <iget>
801023bf:	83 c4 10             	add    $0x10,%esp
801023c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023c5:	e9 bb 00 00 00       	jmp    80102485 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801023ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023d0:	8b 40 68             	mov    0x68(%eax),%eax
801023d3:	83 ec 0c             	sub    $0xc,%esp
801023d6:	50                   	push   %eax
801023d7:	e8 f5 f4 ff ff       	call   801018d1 <idup>
801023dc:	83 c4 10             	add    $0x10,%esp
801023df:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023e2:	e9 9e 00 00 00       	jmp    80102485 <namex+0xe2>
    ilock(ip);
801023e7:	83 ec 0c             	sub    $0xc,%esp
801023ea:	ff 75 f4             	pushl  -0xc(%ebp)
801023ed:	e8 19 f5 ff ff       	call   8010190b <ilock>
801023f2:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023fc:	66 83 f8 01          	cmp    $0x1,%ax
80102400:	74 18                	je     8010241a <namex+0x77>
      iunlockput(ip);
80102402:	83 ec 0c             	sub    $0xc,%esp
80102405:	ff 75 f4             	pushl  -0xc(%ebp)
80102408:	e8 b8 f7 ff ff       	call   80101bc5 <iunlockput>
8010240d:	83 c4 10             	add    $0x10,%esp
      return 0;
80102410:	b8 00 00 00 00       	mov    $0x0,%eax
80102415:	e9 a7 00 00 00       	jmp    801024c1 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
8010241a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010241e:	74 20                	je     80102440 <namex+0x9d>
80102420:	8b 45 08             	mov    0x8(%ebp),%eax
80102423:	0f b6 00             	movzbl (%eax),%eax
80102426:	84 c0                	test   %al,%al
80102428:	75 16                	jne    80102440 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
8010242a:	83 ec 0c             	sub    $0xc,%esp
8010242d:	ff 75 f4             	pushl  -0xc(%ebp)
80102430:	e8 2e f6 ff ff       	call   80101a63 <iunlock>
80102435:	83 c4 10             	add    $0x10,%esp
      return ip;
80102438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010243b:	e9 81 00 00 00       	jmp    801024c1 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102440:	83 ec 04             	sub    $0x4,%esp
80102443:	6a 00                	push   $0x0
80102445:	ff 75 10             	pushl  0x10(%ebp)
80102448:	ff 75 f4             	pushl  -0xc(%ebp)
8010244b:	e8 1d fd ff ff       	call   8010216d <dirlookup>
80102450:	83 c4 10             	add    $0x10,%esp
80102453:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102456:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010245a:	75 15                	jne    80102471 <namex+0xce>
      iunlockput(ip);
8010245c:	83 ec 0c             	sub    $0xc,%esp
8010245f:	ff 75 f4             	pushl  -0xc(%ebp)
80102462:	e8 5e f7 ff ff       	call   80101bc5 <iunlockput>
80102467:	83 c4 10             	add    $0x10,%esp
      return 0;
8010246a:	b8 00 00 00 00       	mov    $0x0,%eax
8010246f:	eb 50                	jmp    801024c1 <namex+0x11e>
    }
    iunlockput(ip);
80102471:	83 ec 0c             	sub    $0xc,%esp
80102474:	ff 75 f4             	pushl  -0xc(%ebp)
80102477:	e8 49 f7 ff ff       	call   80101bc5 <iunlockput>
8010247c:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010247f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102482:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102485:	83 ec 08             	sub    $0x8,%esp
80102488:	ff 75 10             	pushl  0x10(%ebp)
8010248b:	ff 75 08             	pushl  0x8(%ebp)
8010248e:	e8 6c fe ff ff       	call   801022ff <skipelem>
80102493:	83 c4 10             	add    $0x10,%esp
80102496:	89 45 08             	mov    %eax,0x8(%ebp)
80102499:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010249d:	0f 85 44 ff ff ff    	jne    801023e7 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801024a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024a7:	74 15                	je     801024be <namex+0x11b>
    iput(ip);
801024a9:	83 ec 0c             	sub    $0xc,%esp
801024ac:	ff 75 f4             	pushl  -0xc(%ebp)
801024af:	e8 21 f6 ff ff       	call   80101ad5 <iput>
801024b4:	83 c4 10             	add    $0x10,%esp
    return 0;
801024b7:	b8 00 00 00 00       	mov    $0x0,%eax
801024bc:	eb 03                	jmp    801024c1 <namex+0x11e>
  }
  return ip;
801024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801024c1:	c9                   	leave  
801024c2:	c3                   	ret    

801024c3 <namei>:

struct inode*
namei(char *path)
{
801024c3:	55                   	push   %ebp
801024c4:	89 e5                	mov    %esp,%ebp
801024c6:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024c9:	83 ec 04             	sub    $0x4,%esp
801024cc:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024cf:	50                   	push   %eax
801024d0:	6a 00                	push   $0x0
801024d2:	ff 75 08             	pushl  0x8(%ebp)
801024d5:	e8 c9 fe ff ff       	call   801023a3 <namex>
801024da:	83 c4 10             	add    $0x10,%esp
}
801024dd:	c9                   	leave  
801024de:	c3                   	ret    

801024df <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024df:	55                   	push   %ebp
801024e0:	89 e5                	mov    %esp,%ebp
801024e2:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801024e5:	83 ec 04             	sub    $0x4,%esp
801024e8:	ff 75 0c             	pushl  0xc(%ebp)
801024eb:	6a 01                	push   $0x1
801024ed:	ff 75 08             	pushl  0x8(%ebp)
801024f0:	e8 ae fe ff ff       	call   801023a3 <namex>
801024f5:	83 c4 10             	add    $0x10,%esp
}
801024f8:	c9                   	leave  
801024f9:	c3                   	ret    

801024fa <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024fa:	55                   	push   %ebp
801024fb:	89 e5                	mov    %esp,%ebp
801024fd:	83 ec 14             	sub    $0x14,%esp
80102500:	8b 45 08             	mov    0x8(%ebp),%eax
80102503:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102507:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010250b:	89 c2                	mov    %eax,%edx
8010250d:	ec                   	in     (%dx),%al
8010250e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102511:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102515:	c9                   	leave  
80102516:	c3                   	ret    

80102517 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102517:	55                   	push   %ebp
80102518:	89 e5                	mov    %esp,%ebp
8010251a:	57                   	push   %edi
8010251b:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010251c:	8b 55 08             	mov    0x8(%ebp),%edx
8010251f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102522:	8b 45 10             	mov    0x10(%ebp),%eax
80102525:	89 cb                	mov    %ecx,%ebx
80102527:	89 df                	mov    %ebx,%edi
80102529:	89 c1                	mov    %eax,%ecx
8010252b:	fc                   	cld    
8010252c:	f3 6d                	rep insl (%dx),%es:(%edi)
8010252e:	89 c8                	mov    %ecx,%eax
80102530:	89 fb                	mov    %edi,%ebx
80102532:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102535:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102538:	90                   	nop
80102539:	5b                   	pop    %ebx
8010253a:	5f                   	pop    %edi
8010253b:	5d                   	pop    %ebp
8010253c:	c3                   	ret    

8010253d <outb>:

static inline void
outb(ushort port, uchar data)
{
8010253d:	55                   	push   %ebp
8010253e:	89 e5                	mov    %esp,%ebp
80102540:	83 ec 08             	sub    $0x8,%esp
80102543:	8b 55 08             	mov    0x8(%ebp),%edx
80102546:	8b 45 0c             	mov    0xc(%ebp),%eax
80102549:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010254d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102550:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102554:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102558:	ee                   	out    %al,(%dx)
}
80102559:	90                   	nop
8010255a:	c9                   	leave  
8010255b:	c3                   	ret    

8010255c <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010255c:	55                   	push   %ebp
8010255d:	89 e5                	mov    %esp,%ebp
8010255f:	56                   	push   %esi
80102560:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102561:	8b 55 08             	mov    0x8(%ebp),%edx
80102564:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102567:	8b 45 10             	mov    0x10(%ebp),%eax
8010256a:	89 cb                	mov    %ecx,%ebx
8010256c:	89 de                	mov    %ebx,%esi
8010256e:	89 c1                	mov    %eax,%ecx
80102570:	fc                   	cld    
80102571:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102573:	89 c8                	mov    %ecx,%eax
80102575:	89 f3                	mov    %esi,%ebx
80102577:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010257a:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010257d:	90                   	nop
8010257e:	5b                   	pop    %ebx
8010257f:	5e                   	pop    %esi
80102580:	5d                   	pop    %ebp
80102581:	c3                   	ret    

80102582 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102582:	55                   	push   %ebp
80102583:	89 e5                	mov    %esp,%ebp
80102585:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102588:	90                   	nop
80102589:	68 f7 01 00 00       	push   $0x1f7
8010258e:	e8 67 ff ff ff       	call   801024fa <inb>
80102593:	83 c4 04             	add    $0x4,%esp
80102596:	0f b6 c0             	movzbl %al,%eax
80102599:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010259c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010259f:	25 c0 00 00 00       	and    $0xc0,%eax
801025a4:	83 f8 40             	cmp    $0x40,%eax
801025a7:	75 e0                	jne    80102589 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025ad:	74 11                	je     801025c0 <idewait+0x3e>
801025af:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025b2:	83 e0 21             	and    $0x21,%eax
801025b5:	85 c0                	test   %eax,%eax
801025b7:	74 07                	je     801025c0 <idewait+0x3e>
    return -1;
801025b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025be:	eb 05                	jmp    801025c5 <idewait+0x43>
  return 0;
801025c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025c5:	c9                   	leave  
801025c6:	c3                   	ret    

801025c7 <ideinit>:

void
ideinit(void)
{
801025c7:	55                   	push   %ebp
801025c8:	89 e5                	mov    %esp,%ebp
801025ca:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801025cd:	83 ec 08             	sub    $0x8,%esp
801025d0:	68 14 89 10 80       	push   $0x80108914
801025d5:	68 20 b6 10 80       	push   $0x8010b620
801025da:	e8 ac 2a 00 00       	call   8010508b <initlock>
801025df:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801025e2:	83 ec 0c             	sub    $0xc,%esp
801025e5:	6a 0e                	push   $0xe
801025e7:	e8 8b 18 00 00       	call   80103e77 <picenable>
801025ec:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801025ef:	a1 60 29 11 80       	mov    0x80112960,%eax
801025f4:	83 e8 01             	sub    $0x1,%eax
801025f7:	83 ec 08             	sub    $0x8,%esp
801025fa:	50                   	push   %eax
801025fb:	6a 0e                	push   $0xe
801025fd:	e8 37 04 00 00       	call   80102a39 <ioapicenable>
80102602:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102605:	83 ec 0c             	sub    $0xc,%esp
80102608:	6a 00                	push   $0x0
8010260a:	e8 73 ff ff ff       	call   80102582 <idewait>
8010260f:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102612:	83 ec 08             	sub    $0x8,%esp
80102615:	68 f0 00 00 00       	push   $0xf0
8010261a:	68 f6 01 00 00       	push   $0x1f6
8010261f:	e8 19 ff ff ff       	call   8010253d <outb>
80102624:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102627:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010262e:	eb 24                	jmp    80102654 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	68 f7 01 00 00       	push   $0x1f7
80102638:	e8 bd fe ff ff       	call   801024fa <inb>
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	84 c0                	test   %al,%al
80102642:	74 0c                	je     80102650 <ideinit+0x89>
      havedisk1 = 1;
80102644:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
8010264b:	00 00 00 
      break;
8010264e:	eb 0d                	jmp    8010265d <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102650:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102654:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010265b:	7e d3                	jle    80102630 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010265d:	83 ec 08             	sub    $0x8,%esp
80102660:	68 e0 00 00 00       	push   $0xe0
80102665:	68 f6 01 00 00       	push   $0x1f6
8010266a:	e8 ce fe ff ff       	call   8010253d <outb>
8010266f:	83 c4 10             	add    $0x10,%esp
}
80102672:	90                   	nop
80102673:	c9                   	leave  
80102674:	c3                   	ret    

80102675 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
80102678:	83 ec 08             	sub    $0x8,%esp
  if(b == 0)
8010267b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010267f:	75 0d                	jne    8010268e <idestart+0x19>
    panic("idestart");
80102681:	83 ec 0c             	sub    $0xc,%esp
80102684:	68 18 89 10 80       	push   $0x80108918
80102689:	e8 d8 de ff ff       	call   80100566 <panic>

  idewait(0);
8010268e:	83 ec 0c             	sub    $0xc,%esp
80102691:	6a 00                	push   $0x0
80102693:	e8 ea fe ff ff       	call   80102582 <idewait>
80102698:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
8010269b:	83 ec 08             	sub    $0x8,%esp
8010269e:	6a 00                	push   $0x0
801026a0:	68 f6 03 00 00       	push   $0x3f6
801026a5:	e8 93 fe ff ff       	call   8010253d <outb>
801026aa:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, 1);  // number of sectors
801026ad:	83 ec 08             	sub    $0x8,%esp
801026b0:	6a 01                	push   $0x1
801026b2:	68 f2 01 00 00       	push   $0x1f2
801026b7:	e8 81 fe ff ff       	call   8010253d <outb>
801026bc:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, b->sector & 0xff);
801026bf:	8b 45 08             	mov    0x8(%ebp),%eax
801026c2:	8b 40 08             	mov    0x8(%eax),%eax
801026c5:	0f b6 c0             	movzbl %al,%eax
801026c8:	83 ec 08             	sub    $0x8,%esp
801026cb:	50                   	push   %eax
801026cc:	68 f3 01 00 00       	push   $0x1f3
801026d1:	e8 67 fe ff ff       	call   8010253d <outb>
801026d6:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (b->sector >> 8) & 0xff);
801026d9:	8b 45 08             	mov    0x8(%ebp),%eax
801026dc:	8b 40 08             	mov    0x8(%eax),%eax
801026df:	c1 e8 08             	shr    $0x8,%eax
801026e2:	0f b6 c0             	movzbl %al,%eax
801026e5:	83 ec 08             	sub    $0x8,%esp
801026e8:	50                   	push   %eax
801026e9:	68 f4 01 00 00       	push   $0x1f4
801026ee:	e8 4a fe ff ff       	call   8010253d <outb>
801026f3:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (b->sector >> 16) & 0xff);
801026f6:	8b 45 08             	mov    0x8(%ebp),%eax
801026f9:	8b 40 08             	mov    0x8(%eax),%eax
801026fc:	c1 e8 10             	shr    $0x10,%eax
801026ff:	0f b6 c0             	movzbl %al,%eax
80102702:	83 ec 08             	sub    $0x8,%esp
80102705:	50                   	push   %eax
80102706:	68 f5 01 00 00       	push   $0x1f5
8010270b:	e8 2d fe ff ff       	call   8010253d <outb>
80102710:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102713:	8b 45 08             	mov    0x8(%ebp),%eax
80102716:	8b 40 04             	mov    0x4(%eax),%eax
80102719:	83 e0 01             	and    $0x1,%eax
8010271c:	c1 e0 04             	shl    $0x4,%eax
8010271f:	89 c2                	mov    %eax,%edx
80102721:	8b 45 08             	mov    0x8(%ebp),%eax
80102724:	8b 40 08             	mov    0x8(%eax),%eax
80102727:	c1 e8 18             	shr    $0x18,%eax
8010272a:	83 e0 0f             	and    $0xf,%eax
8010272d:	09 d0                	or     %edx,%eax
8010272f:	83 c8 e0             	or     $0xffffffe0,%eax
80102732:	0f b6 c0             	movzbl %al,%eax
80102735:	83 ec 08             	sub    $0x8,%esp
80102738:	50                   	push   %eax
80102739:	68 f6 01 00 00       	push   $0x1f6
8010273e:	e8 fa fd ff ff       	call   8010253d <outb>
80102743:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102746:	8b 45 08             	mov    0x8(%ebp),%eax
80102749:	8b 00                	mov    (%eax),%eax
8010274b:	83 e0 04             	and    $0x4,%eax
8010274e:	85 c0                	test   %eax,%eax
80102750:	74 30                	je     80102782 <idestart+0x10d>
    outb(0x1f7, IDE_CMD_WRITE);
80102752:	83 ec 08             	sub    $0x8,%esp
80102755:	6a 30                	push   $0x30
80102757:	68 f7 01 00 00       	push   $0x1f7
8010275c:	e8 dc fd ff ff       	call   8010253d <outb>
80102761:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, 512/4);
80102764:	8b 45 08             	mov    0x8(%ebp),%eax
80102767:	83 c0 18             	add    $0x18,%eax
8010276a:	83 ec 04             	sub    $0x4,%esp
8010276d:	68 80 00 00 00       	push   $0x80
80102772:	50                   	push   %eax
80102773:	68 f0 01 00 00       	push   $0x1f0
80102778:	e8 df fd ff ff       	call   8010255c <outsl>
8010277d:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102780:	eb 12                	jmp    80102794 <idestart+0x11f>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102782:	83 ec 08             	sub    $0x8,%esp
80102785:	6a 20                	push   $0x20
80102787:	68 f7 01 00 00       	push   $0x1f7
8010278c:	e8 ac fd ff ff       	call   8010253d <outb>
80102791:	83 c4 10             	add    $0x10,%esp
  }
}
80102794:	90                   	nop
80102795:	c9                   	leave  
80102796:	c3                   	ret    

80102797 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102797:	55                   	push   %ebp
80102798:	89 e5                	mov    %esp,%ebp
8010279a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010279d:	83 ec 0c             	sub    $0xc,%esp
801027a0:	68 20 b6 10 80       	push   $0x8010b620
801027a5:	e8 03 29 00 00       	call   801050ad <acquire>
801027aa:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027ad:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027b9:	75 15                	jne    801027d0 <ideintr+0x39>
    release(&idelock);
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	68 20 b6 10 80       	push   $0x8010b620
801027c3:	e8 4c 29 00 00       	call   80105114 <release>
801027c8:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801027cb:	e9 9a 00 00 00       	jmp    8010286a <ideintr+0xd3>
  }
  idequeue = b->qnext;
801027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d3:	8b 40 14             	mov    0x14(%eax),%eax
801027d6:	a3 54 b6 10 80       	mov    %eax,0x8010b654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027de:	8b 00                	mov    (%eax),%eax
801027e0:	83 e0 04             	and    $0x4,%eax
801027e3:	85 c0                	test   %eax,%eax
801027e5:	75 2d                	jne    80102814 <ideintr+0x7d>
801027e7:	83 ec 0c             	sub    $0xc,%esp
801027ea:	6a 01                	push   $0x1
801027ec:	e8 91 fd ff ff       	call   80102582 <idewait>
801027f1:	83 c4 10             	add    $0x10,%esp
801027f4:	85 c0                	test   %eax,%eax
801027f6:	78 1c                	js     80102814 <ideintr+0x7d>
    insl(0x1f0, b->data, 512/4);
801027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fb:	83 c0 18             	add    $0x18,%eax
801027fe:	83 ec 04             	sub    $0x4,%esp
80102801:	68 80 00 00 00       	push   $0x80
80102806:	50                   	push   %eax
80102807:	68 f0 01 00 00       	push   $0x1f0
8010280c:	e8 06 fd ff ff       	call   80102517 <insl>
80102811:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102817:	8b 00                	mov    (%eax),%eax
80102819:	83 c8 02             	or     $0x2,%eax
8010281c:	89 c2                	mov    %eax,%edx
8010281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102821:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102823:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102826:	8b 00                	mov    (%eax),%eax
80102828:	83 e0 fb             	and    $0xfffffffb,%eax
8010282b:	89 c2                	mov    %eax,%edx
8010282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102830:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102832:	83 ec 0c             	sub    $0xc,%esp
80102835:	ff 75 f4             	pushl  -0xc(%ebp)
80102838:	e8 21 25 00 00       	call   80104d5e <wakeup>
8010283d:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102840:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102845:	85 c0                	test   %eax,%eax
80102847:	74 11                	je     8010285a <ideintr+0xc3>
    idestart(idequeue);
80102849:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010284e:	83 ec 0c             	sub    $0xc,%esp
80102851:	50                   	push   %eax
80102852:	e8 1e fe ff ff       	call   80102675 <idestart>
80102857:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010285a:	83 ec 0c             	sub    $0xc,%esp
8010285d:	68 20 b6 10 80       	push   $0x8010b620
80102862:	e8 ad 28 00 00       	call   80105114 <release>
80102867:	83 c4 10             	add    $0x10,%esp
}
8010286a:	c9                   	leave  
8010286b:	c3                   	ret    

8010286c <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010286c:	55                   	push   %ebp
8010286d:	89 e5                	mov    %esp,%ebp
8010286f:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102872:	8b 45 08             	mov    0x8(%ebp),%eax
80102875:	8b 00                	mov    (%eax),%eax
80102877:	83 e0 01             	and    $0x1,%eax
8010287a:	85 c0                	test   %eax,%eax
8010287c:	75 0d                	jne    8010288b <iderw+0x1f>
    panic("iderw: buf not busy");
8010287e:	83 ec 0c             	sub    $0xc,%esp
80102881:	68 21 89 10 80       	push   $0x80108921
80102886:	e8 db dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010288b:	8b 45 08             	mov    0x8(%ebp),%eax
8010288e:	8b 00                	mov    (%eax),%eax
80102890:	83 e0 06             	and    $0x6,%eax
80102893:	83 f8 02             	cmp    $0x2,%eax
80102896:	75 0d                	jne    801028a5 <iderw+0x39>
    panic("iderw: nothing to do");
80102898:	83 ec 0c             	sub    $0xc,%esp
8010289b:	68 35 89 10 80       	push   $0x80108935
801028a0:	e8 c1 dc ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801028a5:	8b 45 08             	mov    0x8(%ebp),%eax
801028a8:	8b 40 04             	mov    0x4(%eax),%eax
801028ab:	85 c0                	test   %eax,%eax
801028ad:	74 16                	je     801028c5 <iderw+0x59>
801028af:	a1 58 b6 10 80       	mov    0x8010b658,%eax
801028b4:	85 c0                	test   %eax,%eax
801028b6:	75 0d                	jne    801028c5 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801028b8:	83 ec 0c             	sub    $0xc,%esp
801028bb:	68 4a 89 10 80       	push   $0x8010894a
801028c0:	e8 a1 dc ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028c5:	83 ec 0c             	sub    $0xc,%esp
801028c8:	68 20 b6 10 80       	push   $0x8010b620
801028cd:	e8 db 27 00 00       	call   801050ad <acquire>
801028d2:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801028d5:	8b 45 08             	mov    0x8(%ebp),%eax
801028d8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028df:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
801028e6:	eb 0b                	jmp    801028f3 <iderw+0x87>
801028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028eb:	8b 00                	mov    (%eax),%eax
801028ed:	83 c0 14             	add    $0x14,%eax
801028f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f6:	8b 00                	mov    (%eax),%eax
801028f8:	85 c0                	test   %eax,%eax
801028fa:	75 ec                	jne    801028e8 <iderw+0x7c>
    ;
  *pp = b;
801028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ff:	8b 55 08             	mov    0x8(%ebp),%edx
80102902:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102904:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102909:	3b 45 08             	cmp    0x8(%ebp),%eax
8010290c:	75 23                	jne    80102931 <iderw+0xc5>
    idestart(b);
8010290e:	83 ec 0c             	sub    $0xc,%esp
80102911:	ff 75 08             	pushl  0x8(%ebp)
80102914:	e8 5c fd ff ff       	call   80102675 <idestart>
80102919:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010291c:	eb 13                	jmp    80102931 <iderw+0xc5>
    sleep(b, &idelock);
8010291e:	83 ec 08             	sub    $0x8,%esp
80102921:	68 20 b6 10 80       	push   $0x8010b620
80102926:	ff 75 08             	pushl  0x8(%ebp)
80102929:	e8 42 23 00 00       	call   80104c70 <sleep>
8010292e:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102931:	8b 45 08             	mov    0x8(%ebp),%eax
80102934:	8b 00                	mov    (%eax),%eax
80102936:	83 e0 06             	and    $0x6,%eax
80102939:	83 f8 02             	cmp    $0x2,%eax
8010293c:	75 e0                	jne    8010291e <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
8010293e:	83 ec 0c             	sub    $0xc,%esp
80102941:	68 20 b6 10 80       	push   $0x8010b620
80102946:	e8 c9 27 00 00       	call   80105114 <release>
8010294b:	83 c4 10             	add    $0x10,%esp
}
8010294e:	90                   	nop
8010294f:	c9                   	leave  
80102950:	c3                   	ret    

80102951 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102951:	55                   	push   %ebp
80102952:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102954:	a1 34 22 11 80       	mov    0x80112234,%eax
80102959:	8b 55 08             	mov    0x8(%ebp),%edx
8010295c:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
8010295e:	a1 34 22 11 80       	mov    0x80112234,%eax
80102963:	8b 40 10             	mov    0x10(%eax),%eax
}
80102966:	5d                   	pop    %ebp
80102967:	c3                   	ret    

80102968 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102968:	55                   	push   %ebp
80102969:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010296b:	a1 34 22 11 80       	mov    0x80112234,%eax
80102970:	8b 55 08             	mov    0x8(%ebp),%edx
80102973:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102975:	a1 34 22 11 80       	mov    0x80112234,%eax
8010297a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010297d:	89 50 10             	mov    %edx,0x10(%eax)
}
80102980:	90                   	nop
80102981:	5d                   	pop    %ebp
80102982:	c3                   	ret    

80102983 <ioapicinit>:

void
ioapicinit(void)
{
80102983:	55                   	push   %ebp
80102984:	89 e5                	mov    %esp,%ebp
80102986:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102989:	a1 64 23 11 80       	mov    0x80112364,%eax
8010298e:	85 c0                	test   %eax,%eax
80102990:	0f 84 a0 00 00 00    	je     80102a36 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102996:	c7 05 34 22 11 80 00 	movl   $0xfec00000,0x80112234
8010299d:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029a0:	6a 01                	push   $0x1
801029a2:	e8 aa ff ff ff       	call   80102951 <ioapicread>
801029a7:	83 c4 04             	add    $0x4,%esp
801029aa:	c1 e8 10             	shr    $0x10,%eax
801029ad:	25 ff 00 00 00       	and    $0xff,%eax
801029b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029b5:	6a 00                	push   $0x0
801029b7:	e8 95 ff ff ff       	call   80102951 <ioapicread>
801029bc:	83 c4 04             	add    $0x4,%esp
801029bf:	c1 e8 18             	shr    $0x18,%eax
801029c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801029c5:	0f b6 05 60 23 11 80 	movzbl 0x80112360,%eax
801029cc:	0f b6 c0             	movzbl %al,%eax
801029cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801029d2:	74 10                	je     801029e4 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029d4:	83 ec 0c             	sub    $0xc,%esp
801029d7:	68 68 89 10 80       	push   $0x80108968
801029dc:	e8 e5 d9 ff ff       	call   801003c6 <cprintf>
801029e1:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029eb:	eb 3f                	jmp    80102a2c <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f0:	83 c0 20             	add    $0x20,%eax
801029f3:	0d 00 00 01 00       	or     $0x10000,%eax
801029f8:	89 c2                	mov    %eax,%edx
801029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029fd:	83 c0 08             	add    $0x8,%eax
80102a00:	01 c0                	add    %eax,%eax
80102a02:	83 ec 08             	sub    $0x8,%esp
80102a05:	52                   	push   %edx
80102a06:	50                   	push   %eax
80102a07:	e8 5c ff ff ff       	call   80102968 <ioapicwrite>
80102a0c:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a12:	83 c0 08             	add    $0x8,%eax
80102a15:	01 c0                	add    %eax,%eax
80102a17:	83 c0 01             	add    $0x1,%eax
80102a1a:	83 ec 08             	sub    $0x8,%esp
80102a1d:	6a 00                	push   $0x0
80102a1f:	50                   	push   %eax
80102a20:	e8 43 ff ff ff       	call   80102968 <ioapicwrite>
80102a25:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a28:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a2f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a32:	7e b9                	jle    801029ed <ioapicinit+0x6a>
80102a34:	eb 01                	jmp    80102a37 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102a36:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a37:	c9                   	leave  
80102a38:	c3                   	ret    

80102a39 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a39:	55                   	push   %ebp
80102a3a:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102a3c:	a1 64 23 11 80       	mov    0x80112364,%eax
80102a41:	85 c0                	test   %eax,%eax
80102a43:	74 39                	je     80102a7e <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a45:	8b 45 08             	mov    0x8(%ebp),%eax
80102a48:	83 c0 20             	add    $0x20,%eax
80102a4b:	89 c2                	mov    %eax,%edx
80102a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a50:	83 c0 08             	add    $0x8,%eax
80102a53:	01 c0                	add    %eax,%eax
80102a55:	52                   	push   %edx
80102a56:	50                   	push   %eax
80102a57:	e8 0c ff ff ff       	call   80102968 <ioapicwrite>
80102a5c:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a62:	c1 e0 18             	shl    $0x18,%eax
80102a65:	89 c2                	mov    %eax,%edx
80102a67:	8b 45 08             	mov    0x8(%ebp),%eax
80102a6a:	83 c0 08             	add    $0x8,%eax
80102a6d:	01 c0                	add    %eax,%eax
80102a6f:	83 c0 01             	add    $0x1,%eax
80102a72:	52                   	push   %edx
80102a73:	50                   	push   %eax
80102a74:	e8 ef fe ff ff       	call   80102968 <ioapicwrite>
80102a79:	83 c4 08             	add    $0x8,%esp
80102a7c:	eb 01                	jmp    80102a7f <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102a7e:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102a7f:	c9                   	leave  
80102a80:	c3                   	ret    

80102a81 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a81:	55                   	push   %ebp
80102a82:	89 e5                	mov    %esp,%ebp
80102a84:	8b 45 08             	mov    0x8(%ebp),%eax
80102a87:	05 00 00 00 80       	add    $0x80000000,%eax
80102a8c:	5d                   	pop    %ebp
80102a8d:	c3                   	ret    

80102a8e <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a8e:	55                   	push   %ebp
80102a8f:	89 e5                	mov    %esp,%ebp
80102a91:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102a94:	83 ec 08             	sub    $0x8,%esp
80102a97:	68 9a 89 10 80       	push   $0x8010899a
80102a9c:	68 40 22 11 80       	push   $0x80112240
80102aa1:	e8 e5 25 00 00       	call   8010508b <initlock>
80102aa6:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102aa9:	c7 05 74 22 11 80 00 	movl   $0x0,0x80112274
80102ab0:	00 00 00 
  freerange(vstart, vend);
80102ab3:	83 ec 08             	sub    $0x8,%esp
80102ab6:	ff 75 0c             	pushl  0xc(%ebp)
80102ab9:	ff 75 08             	pushl  0x8(%ebp)
80102abc:	e8 2a 00 00 00       	call   80102aeb <freerange>
80102ac1:	83 c4 10             	add    $0x10,%esp
}
80102ac4:	90                   	nop
80102ac5:	c9                   	leave  
80102ac6:	c3                   	ret    

80102ac7 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ac7:	55                   	push   %ebp
80102ac8:	89 e5                	mov    %esp,%ebp
80102aca:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102acd:	83 ec 08             	sub    $0x8,%esp
80102ad0:	ff 75 0c             	pushl  0xc(%ebp)
80102ad3:	ff 75 08             	pushl  0x8(%ebp)
80102ad6:	e8 10 00 00 00       	call   80102aeb <freerange>
80102adb:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102ade:	c7 05 74 22 11 80 01 	movl   $0x1,0x80112274
80102ae5:	00 00 00 
}
80102ae8:	90                   	nop
80102ae9:	c9                   	leave  
80102aea:	c3                   	ret    

80102aeb <freerange>:

void
freerange(void *vstart, void *vend)
{
80102aeb:	55                   	push   %ebp
80102aec:	89 e5                	mov    %esp,%ebp
80102aee:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102af1:	8b 45 08             	mov    0x8(%ebp),%eax
80102af4:	05 ff 0f 00 00       	add    $0xfff,%eax
80102af9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b01:	eb 15                	jmp    80102b18 <freerange+0x2d>
    kfree(p);
80102b03:	83 ec 0c             	sub    $0xc,%esp
80102b06:	ff 75 f4             	pushl  -0xc(%ebp)
80102b09:	e8 1a 00 00 00       	call   80102b28 <kfree>
80102b0e:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b11:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1b:	05 00 10 00 00       	add    $0x1000,%eax
80102b20:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b23:	76 de                	jbe    80102b03 <freerange+0x18>
    kfree(p);
}
80102b25:	90                   	nop
80102b26:	c9                   	leave  
80102b27:	c3                   	ret    

80102b28 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b28:	55                   	push   %ebp
80102b29:	89 e5                	mov    %esp,%ebp
80102b2b:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b31:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b36:	85 c0                	test   %eax,%eax
80102b38:	75 1b                	jne    80102b55 <kfree+0x2d>
80102b3a:	81 7d 08 5c 54 11 80 	cmpl   $0x8011545c,0x8(%ebp)
80102b41:	72 12                	jb     80102b55 <kfree+0x2d>
80102b43:	ff 75 08             	pushl  0x8(%ebp)
80102b46:	e8 36 ff ff ff       	call   80102a81 <v2p>
80102b4b:	83 c4 04             	add    $0x4,%esp
80102b4e:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b53:	76 0d                	jbe    80102b62 <kfree+0x3a>
    panic("kfree");
80102b55:	83 ec 0c             	sub    $0xc,%esp
80102b58:	68 9f 89 10 80       	push   $0x8010899f
80102b5d:	e8 04 da ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b62:	83 ec 04             	sub    $0x4,%esp
80102b65:	68 00 10 00 00       	push   $0x1000
80102b6a:	6a 01                	push   $0x1
80102b6c:	ff 75 08             	pushl  0x8(%ebp)
80102b6f:	e8 9c 27 00 00       	call   80105310 <memset>
80102b74:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b77:	a1 74 22 11 80       	mov    0x80112274,%eax
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	74 10                	je     80102b90 <kfree+0x68>
    acquire(&kmem.lock);
80102b80:	83 ec 0c             	sub    $0xc,%esp
80102b83:	68 40 22 11 80       	push   $0x80112240
80102b88:	e8 20 25 00 00       	call   801050ad <acquire>
80102b8d:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102b90:	8b 45 08             	mov    0x8(%ebp),%eax
80102b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b96:	8b 15 78 22 11 80    	mov    0x80112278,%edx
80102b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9f:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba4:	a3 78 22 11 80       	mov    %eax,0x80112278
  if(kmem.use_lock)
80102ba9:	a1 74 22 11 80       	mov    0x80112274,%eax
80102bae:	85 c0                	test   %eax,%eax
80102bb0:	74 10                	je     80102bc2 <kfree+0x9a>
    release(&kmem.lock);
80102bb2:	83 ec 0c             	sub    $0xc,%esp
80102bb5:	68 40 22 11 80       	push   $0x80112240
80102bba:	e8 55 25 00 00       	call   80105114 <release>
80102bbf:	83 c4 10             	add    $0x10,%esp
}
80102bc2:	90                   	nop
80102bc3:	c9                   	leave  
80102bc4:	c3                   	ret    

80102bc5 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102bc5:	55                   	push   %ebp
80102bc6:	89 e5                	mov    %esp,%ebp
80102bc8:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102bcb:	a1 74 22 11 80       	mov    0x80112274,%eax
80102bd0:	85 c0                	test   %eax,%eax
80102bd2:	74 10                	je     80102be4 <kalloc+0x1f>
    acquire(&kmem.lock);
80102bd4:	83 ec 0c             	sub    $0xc,%esp
80102bd7:	68 40 22 11 80       	push   $0x80112240
80102bdc:	e8 cc 24 00 00       	call   801050ad <acquire>
80102be1:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102be4:	a1 78 22 11 80       	mov    0x80112278,%eax
80102be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bf0:	74 0a                	je     80102bfc <kalloc+0x37>
    kmem.freelist = r->next;
80102bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf5:	8b 00                	mov    (%eax),%eax
80102bf7:	a3 78 22 11 80       	mov    %eax,0x80112278
  if(kmem.use_lock)
80102bfc:	a1 74 22 11 80       	mov    0x80112274,%eax
80102c01:	85 c0                	test   %eax,%eax
80102c03:	74 10                	je     80102c15 <kalloc+0x50>
    release(&kmem.lock);
80102c05:	83 ec 0c             	sub    $0xc,%esp
80102c08:	68 40 22 11 80       	push   $0x80112240
80102c0d:	e8 02 25 00 00       	call   80105114 <release>
80102c12:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c18:	c9                   	leave  
80102c19:	c3                   	ret    

80102c1a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c1a:	55                   	push   %ebp
80102c1b:	89 e5                	mov    %esp,%ebp
80102c1d:	83 ec 14             	sub    $0x14,%esp
80102c20:	8b 45 08             	mov    0x8(%ebp),%eax
80102c23:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c27:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c2b:	89 c2                	mov    %eax,%edx
80102c2d:	ec                   	in     (%dx),%al
80102c2e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c31:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c35:	c9                   	leave  
80102c36:	c3                   	ret    

80102c37 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c37:	55                   	push   %ebp
80102c38:	89 e5                	mov    %esp,%ebp
80102c3a:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c3d:	6a 64                	push   $0x64
80102c3f:	e8 d6 ff ff ff       	call   80102c1a <inb>
80102c44:	83 c4 04             	add    $0x4,%esp
80102c47:	0f b6 c0             	movzbl %al,%eax
80102c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c50:	83 e0 01             	and    $0x1,%eax
80102c53:	85 c0                	test   %eax,%eax
80102c55:	75 0a                	jne    80102c61 <kbdgetc+0x2a>
    return -1;
80102c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c5c:	e9 23 01 00 00       	jmp    80102d84 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c61:	6a 60                	push   $0x60
80102c63:	e8 b2 ff ff ff       	call   80102c1a <inb>
80102c68:	83 c4 04             	add    $0x4,%esp
80102c6b:	0f b6 c0             	movzbl %al,%eax
80102c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c71:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c78:	75 17                	jne    80102c91 <kbdgetc+0x5a>
    shift |= E0ESC;
80102c7a:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c7f:	83 c8 40             	or     $0x40,%eax
80102c82:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102c87:	b8 00 00 00 00       	mov    $0x0,%eax
80102c8c:	e9 f3 00 00 00       	jmp    80102d84 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c94:	25 80 00 00 00       	and    $0x80,%eax
80102c99:	85 c0                	test   %eax,%eax
80102c9b:	74 45                	je     80102ce2 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c9d:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102ca2:	83 e0 40             	and    $0x40,%eax
80102ca5:	85 c0                	test   %eax,%eax
80102ca7:	75 08                	jne    80102cb1 <kbdgetc+0x7a>
80102ca9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cac:	83 e0 7f             	and    $0x7f,%eax
80102caf:	eb 03                	jmp    80102cb4 <kbdgetc+0x7d>
80102cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102cb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cba:	05 20 90 10 80       	add    $0x80109020,%eax
80102cbf:	0f b6 00             	movzbl (%eax),%eax
80102cc2:	83 c8 40             	or     $0x40,%eax
80102cc5:	0f b6 c0             	movzbl %al,%eax
80102cc8:	f7 d0                	not    %eax
80102cca:	89 c2                	mov    %eax,%edx
80102ccc:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cd1:	21 d0                	and    %edx,%eax
80102cd3:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102cd8:	b8 00 00 00 00       	mov    $0x0,%eax
80102cdd:	e9 a2 00 00 00       	jmp    80102d84 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102ce2:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102ce7:	83 e0 40             	and    $0x40,%eax
80102cea:	85 c0                	test   %eax,%eax
80102cec:	74 14                	je     80102d02 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cee:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cf5:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cfa:	83 e0 bf             	and    $0xffffffbf,%eax
80102cfd:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d05:	05 20 90 10 80       	add    $0x80109020,%eax
80102d0a:	0f b6 00             	movzbl (%eax),%eax
80102d0d:	0f b6 d0             	movzbl %al,%edx
80102d10:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d15:	09 d0                	or     %edx,%eax
80102d17:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d1f:	05 20 91 10 80       	add    $0x80109120,%eax
80102d24:	0f b6 00             	movzbl (%eax),%eax
80102d27:	0f b6 d0             	movzbl %al,%edx
80102d2a:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d2f:	31 d0                	xor    %edx,%eax
80102d31:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d36:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d3b:	83 e0 03             	and    $0x3,%eax
80102d3e:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d48:	01 d0                	add    %edx,%eax
80102d4a:	0f b6 00             	movzbl (%eax),%eax
80102d4d:	0f b6 c0             	movzbl %al,%eax
80102d50:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d53:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d58:	83 e0 08             	and    $0x8,%eax
80102d5b:	85 c0                	test   %eax,%eax
80102d5d:	74 22                	je     80102d81 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d5f:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d63:	76 0c                	jbe    80102d71 <kbdgetc+0x13a>
80102d65:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d69:	77 06                	ja     80102d71 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d6b:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d6f:	eb 10                	jmp    80102d81 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d71:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d75:	76 0a                	jbe    80102d81 <kbdgetc+0x14a>
80102d77:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d7b:	77 04                	ja     80102d81 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102d7d:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d84:	c9                   	leave  
80102d85:	c3                   	ret    

80102d86 <kbdintr>:

void
kbdintr(void)
{
80102d86:	55                   	push   %ebp
80102d87:	89 e5                	mov    %esp,%ebp
80102d89:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102d8c:	83 ec 0c             	sub    $0xc,%esp
80102d8f:	68 37 2c 10 80       	push   $0x80102c37
80102d94:	e8 44 da ff ff       	call   801007dd <consoleintr>
80102d99:	83 c4 10             	add    $0x10,%esp
}
80102d9c:	90                   	nop
80102d9d:	c9                   	leave  
80102d9e:	c3                   	ret    

80102d9f <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d9f:	55                   	push   %ebp
80102da0:	89 e5                	mov    %esp,%ebp
80102da2:	83 ec 14             	sub    $0x14,%esp
80102da5:	8b 45 08             	mov    0x8(%ebp),%eax
80102da8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dac:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102db0:	89 c2                	mov    %eax,%edx
80102db2:	ec                   	in     (%dx),%al
80102db3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102db6:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102dba:	c9                   	leave  
80102dbb:	c3                   	ret    

80102dbc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102dbc:	55                   	push   %ebp
80102dbd:	89 e5                	mov    %esp,%ebp
80102dbf:	83 ec 08             	sub    $0x8,%esp
80102dc2:	8b 55 08             	mov    0x8(%ebp),%edx
80102dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dc8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102dcc:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dcf:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102dd3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102dd7:	ee                   	out    %al,(%dx)
}
80102dd8:	90                   	nop
80102dd9:	c9                   	leave  
80102dda:	c3                   	ret    

80102ddb <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102ddb:	55                   	push   %ebp
80102ddc:	89 e5                	mov    %esp,%ebp
80102dde:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102de1:	9c                   	pushf  
80102de2:	58                   	pop    %eax
80102de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102de9:	c9                   	leave  
80102dea:	c3                   	ret    

80102deb <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102deb:	55                   	push   %ebp
80102dec:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102dee:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102df3:	8b 55 08             	mov    0x8(%ebp),%edx
80102df6:	c1 e2 02             	shl    $0x2,%edx
80102df9:	01 c2                	add    %eax,%edx
80102dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dfe:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e00:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102e05:	83 c0 20             	add    $0x20,%eax
80102e08:	8b 00                	mov    (%eax),%eax
}
80102e0a:	90                   	nop
80102e0b:	5d                   	pop    %ebp
80102e0c:	c3                   	ret    

80102e0d <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e0d:	55                   	push   %ebp
80102e0e:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102e10:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102e15:	85 c0                	test   %eax,%eax
80102e17:	0f 84 0b 01 00 00    	je     80102f28 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e1d:	68 3f 01 00 00       	push   $0x13f
80102e22:	6a 3c                	push   $0x3c
80102e24:	e8 c2 ff ff ff       	call   80102deb <lapicw>
80102e29:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e2c:	6a 0b                	push   $0xb
80102e2e:	68 f8 00 00 00       	push   $0xf8
80102e33:	e8 b3 ff ff ff       	call   80102deb <lapicw>
80102e38:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e3b:	68 20 00 02 00       	push   $0x20020
80102e40:	68 c8 00 00 00       	push   $0xc8
80102e45:	e8 a1 ff ff ff       	call   80102deb <lapicw>
80102e4a:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102e4d:	68 80 96 98 00       	push   $0x989680
80102e52:	68 e0 00 00 00       	push   $0xe0
80102e57:	e8 8f ff ff ff       	call   80102deb <lapicw>
80102e5c:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e5f:	68 00 00 01 00       	push   $0x10000
80102e64:	68 d4 00 00 00       	push   $0xd4
80102e69:	e8 7d ff ff ff       	call   80102deb <lapicw>
80102e6e:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102e71:	68 00 00 01 00       	push   $0x10000
80102e76:	68 d8 00 00 00       	push   $0xd8
80102e7b:	e8 6b ff ff ff       	call   80102deb <lapicw>
80102e80:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e83:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102e88:	83 c0 30             	add    $0x30,%eax
80102e8b:	8b 00                	mov    (%eax),%eax
80102e8d:	c1 e8 10             	shr    $0x10,%eax
80102e90:	0f b6 c0             	movzbl %al,%eax
80102e93:	83 f8 03             	cmp    $0x3,%eax
80102e96:	76 12                	jbe    80102eaa <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102e98:	68 00 00 01 00       	push   $0x10000
80102e9d:	68 d0 00 00 00       	push   $0xd0
80102ea2:	e8 44 ff ff ff       	call   80102deb <lapicw>
80102ea7:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102eaa:	6a 33                	push   $0x33
80102eac:	68 dc 00 00 00       	push   $0xdc
80102eb1:	e8 35 ff ff ff       	call   80102deb <lapicw>
80102eb6:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102eb9:	6a 00                	push   $0x0
80102ebb:	68 a0 00 00 00       	push   $0xa0
80102ec0:	e8 26 ff ff ff       	call   80102deb <lapicw>
80102ec5:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102ec8:	6a 00                	push   $0x0
80102eca:	68 a0 00 00 00       	push   $0xa0
80102ecf:	e8 17 ff ff ff       	call   80102deb <lapicw>
80102ed4:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ed7:	6a 00                	push   $0x0
80102ed9:	6a 2c                	push   $0x2c
80102edb:	e8 0b ff ff ff       	call   80102deb <lapicw>
80102ee0:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ee3:	6a 00                	push   $0x0
80102ee5:	68 c4 00 00 00       	push   $0xc4
80102eea:	e8 fc fe ff ff       	call   80102deb <lapicw>
80102eef:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ef2:	68 00 85 08 00       	push   $0x88500
80102ef7:	68 c0 00 00 00       	push   $0xc0
80102efc:	e8 ea fe ff ff       	call   80102deb <lapicw>
80102f01:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102f04:	90                   	nop
80102f05:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102f0a:	05 00 03 00 00       	add    $0x300,%eax
80102f0f:	8b 00                	mov    (%eax),%eax
80102f11:	25 00 10 00 00       	and    $0x1000,%eax
80102f16:	85 c0                	test   %eax,%eax
80102f18:	75 eb                	jne    80102f05 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f1a:	6a 00                	push   $0x0
80102f1c:	6a 20                	push   $0x20
80102f1e:	e8 c8 fe ff ff       	call   80102deb <lapicw>
80102f23:	83 c4 08             	add    $0x8,%esp
80102f26:	eb 01                	jmp    80102f29 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102f28:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f29:	c9                   	leave  
80102f2a:	c3                   	ret    

80102f2b <cpunum>:

int
cpunum(void)
{
80102f2b:	55                   	push   %ebp
80102f2c:	89 e5                	mov    %esp,%ebp
80102f2e:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f31:	e8 a5 fe ff ff       	call   80102ddb <readeflags>
80102f36:	25 00 02 00 00       	and    $0x200,%eax
80102f3b:	85 c0                	test   %eax,%eax
80102f3d:	74 26                	je     80102f65 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102f3f:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80102f44:	8d 50 01             	lea    0x1(%eax),%edx
80102f47:	89 15 60 b6 10 80    	mov    %edx,0x8010b660
80102f4d:	85 c0                	test   %eax,%eax
80102f4f:	75 14                	jne    80102f65 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f51:	8b 45 04             	mov    0x4(%ebp),%eax
80102f54:	83 ec 08             	sub    $0x8,%esp
80102f57:	50                   	push   %eax
80102f58:	68 a8 89 10 80       	push   $0x801089a8
80102f5d:	e8 64 d4 ff ff       	call   801003c6 <cprintf>
80102f62:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102f65:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	74 0f                	je     80102f7d <cpunum+0x52>
    return lapic[ID]>>24;
80102f6e:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102f73:	83 c0 20             	add    $0x20,%eax
80102f76:	8b 00                	mov    (%eax),%eax
80102f78:	c1 e8 18             	shr    $0x18,%eax
80102f7b:	eb 05                	jmp    80102f82 <cpunum+0x57>
  return 0;
80102f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f82:	c9                   	leave  
80102f83:	c3                   	ret    

80102f84 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f84:	55                   	push   %ebp
80102f85:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102f87:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102f8c:	85 c0                	test   %eax,%eax
80102f8e:	74 0c                	je     80102f9c <lapiceoi+0x18>
    lapicw(EOI, 0);
80102f90:	6a 00                	push   $0x0
80102f92:	6a 2c                	push   $0x2c
80102f94:	e8 52 fe ff ff       	call   80102deb <lapicw>
80102f99:	83 c4 08             	add    $0x8,%esp
}
80102f9c:	90                   	nop
80102f9d:	c9                   	leave  
80102f9e:	c3                   	ret    

80102f9f <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f9f:	55                   	push   %ebp
80102fa0:	89 e5                	mov    %esp,%ebp
}
80102fa2:	90                   	nop
80102fa3:	5d                   	pop    %ebp
80102fa4:	c3                   	ret    

80102fa5 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fa5:	55                   	push   %ebp
80102fa6:	89 e5                	mov    %esp,%ebp
80102fa8:	83 ec 14             	sub    $0x14,%esp
80102fab:	8b 45 08             	mov    0x8(%ebp),%eax
80102fae:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102fb1:	6a 0f                	push   $0xf
80102fb3:	6a 70                	push   $0x70
80102fb5:	e8 02 fe ff ff       	call   80102dbc <outb>
80102fba:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80102fbd:	6a 0a                	push   $0xa
80102fbf:	6a 71                	push   $0x71
80102fc1:	e8 f6 fd ff ff       	call   80102dbc <outb>
80102fc6:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102fc9:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fd3:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fdb:	83 c0 02             	add    $0x2,%eax
80102fde:	8b 55 0c             	mov    0xc(%ebp),%edx
80102fe1:	c1 ea 04             	shr    $0x4,%edx
80102fe4:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fe7:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102feb:	c1 e0 18             	shl    $0x18,%eax
80102fee:	50                   	push   %eax
80102fef:	68 c4 00 00 00       	push   $0xc4
80102ff4:	e8 f2 fd ff ff       	call   80102deb <lapicw>
80102ff9:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102ffc:	68 00 c5 00 00       	push   $0xc500
80103001:	68 c0 00 00 00       	push   $0xc0
80103006:	e8 e0 fd ff ff       	call   80102deb <lapicw>
8010300b:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010300e:	68 c8 00 00 00       	push   $0xc8
80103013:	e8 87 ff ff ff       	call   80102f9f <microdelay>
80103018:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010301b:	68 00 85 00 00       	push   $0x8500
80103020:	68 c0 00 00 00       	push   $0xc0
80103025:	e8 c1 fd ff ff       	call   80102deb <lapicw>
8010302a:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010302d:	6a 64                	push   $0x64
8010302f:	e8 6b ff ff ff       	call   80102f9f <microdelay>
80103034:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103037:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010303e:	eb 3d                	jmp    8010307d <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103040:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103044:	c1 e0 18             	shl    $0x18,%eax
80103047:	50                   	push   %eax
80103048:	68 c4 00 00 00       	push   $0xc4
8010304d:	e8 99 fd ff ff       	call   80102deb <lapicw>
80103052:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103055:	8b 45 0c             	mov    0xc(%ebp),%eax
80103058:	c1 e8 0c             	shr    $0xc,%eax
8010305b:	80 cc 06             	or     $0x6,%ah
8010305e:	50                   	push   %eax
8010305f:	68 c0 00 00 00       	push   $0xc0
80103064:	e8 82 fd ff ff       	call   80102deb <lapicw>
80103069:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
8010306c:	68 c8 00 00 00       	push   $0xc8
80103071:	e8 29 ff ff ff       	call   80102f9f <microdelay>
80103076:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103079:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010307d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103081:	7e bd                	jle    80103040 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103083:	90                   	nop
80103084:	c9                   	leave  
80103085:	c3                   	ret    

80103086 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103086:	55                   	push   %ebp
80103087:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103089:	8b 45 08             	mov    0x8(%ebp),%eax
8010308c:	0f b6 c0             	movzbl %al,%eax
8010308f:	50                   	push   %eax
80103090:	6a 70                	push   $0x70
80103092:	e8 25 fd ff ff       	call   80102dbc <outb>
80103097:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010309a:	68 c8 00 00 00       	push   $0xc8
8010309f:	e8 fb fe ff ff       	call   80102f9f <microdelay>
801030a4:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801030a7:	6a 71                	push   $0x71
801030a9:	e8 f1 fc ff ff       	call   80102d9f <inb>
801030ae:	83 c4 04             	add    $0x4,%esp
801030b1:	0f b6 c0             	movzbl %al,%eax
}
801030b4:	c9                   	leave  
801030b5:	c3                   	ret    

801030b6 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801030b6:	55                   	push   %ebp
801030b7:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801030b9:	6a 00                	push   $0x0
801030bb:	e8 c6 ff ff ff       	call   80103086 <cmos_read>
801030c0:	83 c4 04             	add    $0x4,%esp
801030c3:	89 c2                	mov    %eax,%edx
801030c5:	8b 45 08             	mov    0x8(%ebp),%eax
801030c8:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801030ca:	6a 02                	push   $0x2
801030cc:	e8 b5 ff ff ff       	call   80103086 <cmos_read>
801030d1:	83 c4 04             	add    $0x4,%esp
801030d4:	89 c2                	mov    %eax,%edx
801030d6:	8b 45 08             	mov    0x8(%ebp),%eax
801030d9:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801030dc:	6a 04                	push   $0x4
801030de:	e8 a3 ff ff ff       	call   80103086 <cmos_read>
801030e3:	83 c4 04             	add    $0x4,%esp
801030e6:	89 c2                	mov    %eax,%edx
801030e8:	8b 45 08             	mov    0x8(%ebp),%eax
801030eb:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801030ee:	6a 07                	push   $0x7
801030f0:	e8 91 ff ff ff       	call   80103086 <cmos_read>
801030f5:	83 c4 04             	add    $0x4,%esp
801030f8:	89 c2                	mov    %eax,%edx
801030fa:	8b 45 08             	mov    0x8(%ebp),%eax
801030fd:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
80103100:	6a 08                	push   $0x8
80103102:	e8 7f ff ff ff       	call   80103086 <cmos_read>
80103107:	83 c4 04             	add    $0x4,%esp
8010310a:	89 c2                	mov    %eax,%edx
8010310c:	8b 45 08             	mov    0x8(%ebp),%eax
8010310f:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103112:	6a 09                	push   $0x9
80103114:	e8 6d ff ff ff       	call   80103086 <cmos_read>
80103119:	83 c4 04             	add    $0x4,%esp
8010311c:	89 c2                	mov    %eax,%edx
8010311e:	8b 45 08             	mov    0x8(%ebp),%eax
80103121:	89 50 14             	mov    %edx,0x14(%eax)
}
80103124:	90                   	nop
80103125:	c9                   	leave  
80103126:	c3                   	ret    

80103127 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103127:	55                   	push   %ebp
80103128:	89 e5                	mov    %esp,%ebp
8010312a:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010312d:	6a 0b                	push   $0xb
8010312f:	e8 52 ff ff ff       	call   80103086 <cmos_read>
80103134:	83 c4 04             	add    $0x4,%esp
80103137:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010313d:	83 e0 04             	and    $0x4,%eax
80103140:	85 c0                	test   %eax,%eax
80103142:	0f 94 c0             	sete   %al
80103145:	0f b6 c0             	movzbl %al,%eax
80103148:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
8010314b:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010314e:	50                   	push   %eax
8010314f:	e8 62 ff ff ff       	call   801030b6 <fill_rtcdate>
80103154:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103157:	6a 0a                	push   $0xa
80103159:	e8 28 ff ff ff       	call   80103086 <cmos_read>
8010315e:	83 c4 04             	add    $0x4,%esp
80103161:	25 80 00 00 00       	and    $0x80,%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	75 27                	jne    80103191 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
8010316a:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010316d:	50                   	push   %eax
8010316e:	e8 43 ff ff ff       	call   801030b6 <fill_rtcdate>
80103173:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103176:	83 ec 04             	sub    $0x4,%esp
80103179:	6a 18                	push   $0x18
8010317b:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010317e:	50                   	push   %eax
8010317f:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103182:	50                   	push   %eax
80103183:	e8 ef 21 00 00       	call   80105377 <memcmp>
80103188:	83 c4 10             	add    $0x10,%esp
8010318b:	85 c0                	test   %eax,%eax
8010318d:	74 05                	je     80103194 <cmostime+0x6d>
8010318f:	eb ba                	jmp    8010314b <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
80103191:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103192:	eb b7                	jmp    8010314b <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
80103194:	90                   	nop
  }

  // convert
  if (bcd) {
80103195:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103199:	0f 84 b4 00 00 00    	je     80103253 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010319f:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031a2:	c1 e8 04             	shr    $0x4,%eax
801031a5:	89 c2                	mov    %eax,%edx
801031a7:	89 d0                	mov    %edx,%eax
801031a9:	c1 e0 02             	shl    $0x2,%eax
801031ac:	01 d0                	add    %edx,%eax
801031ae:	01 c0                	add    %eax,%eax
801031b0:	89 c2                	mov    %eax,%edx
801031b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031b5:	83 e0 0f             	and    $0xf,%eax
801031b8:	01 d0                	add    %edx,%eax
801031ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801031bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031c0:	c1 e8 04             	shr    $0x4,%eax
801031c3:	89 c2                	mov    %eax,%edx
801031c5:	89 d0                	mov    %edx,%eax
801031c7:	c1 e0 02             	shl    $0x2,%eax
801031ca:	01 d0                	add    %edx,%eax
801031cc:	01 c0                	add    %eax,%eax
801031ce:	89 c2                	mov    %eax,%edx
801031d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031d3:	83 e0 0f             	and    $0xf,%eax
801031d6:	01 d0                	add    %edx,%eax
801031d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801031db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031de:	c1 e8 04             	shr    $0x4,%eax
801031e1:	89 c2                	mov    %eax,%edx
801031e3:	89 d0                	mov    %edx,%eax
801031e5:	c1 e0 02             	shl    $0x2,%eax
801031e8:	01 d0                	add    %edx,%eax
801031ea:	01 c0                	add    %eax,%eax
801031ec:	89 c2                	mov    %eax,%edx
801031ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031f1:	83 e0 0f             	and    $0xf,%eax
801031f4:	01 d0                	add    %edx,%eax
801031f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801031f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031fc:	c1 e8 04             	shr    $0x4,%eax
801031ff:	89 c2                	mov    %eax,%edx
80103201:	89 d0                	mov    %edx,%eax
80103203:	c1 e0 02             	shl    $0x2,%eax
80103206:	01 d0                	add    %edx,%eax
80103208:	01 c0                	add    %eax,%eax
8010320a:	89 c2                	mov    %eax,%edx
8010320c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010320f:	83 e0 0f             	and    $0xf,%eax
80103212:	01 d0                	add    %edx,%eax
80103214:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103217:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010321a:	c1 e8 04             	shr    $0x4,%eax
8010321d:	89 c2                	mov    %eax,%edx
8010321f:	89 d0                	mov    %edx,%eax
80103221:	c1 e0 02             	shl    $0x2,%eax
80103224:	01 d0                	add    %edx,%eax
80103226:	01 c0                	add    %eax,%eax
80103228:	89 c2                	mov    %eax,%edx
8010322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010322d:	83 e0 0f             	and    $0xf,%eax
80103230:	01 d0                	add    %edx,%eax
80103232:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103235:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103238:	c1 e8 04             	shr    $0x4,%eax
8010323b:	89 c2                	mov    %eax,%edx
8010323d:	89 d0                	mov    %edx,%eax
8010323f:	c1 e0 02             	shl    $0x2,%eax
80103242:	01 d0                	add    %edx,%eax
80103244:	01 c0                	add    %eax,%eax
80103246:	89 c2                	mov    %eax,%edx
80103248:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010324b:	83 e0 0f             	and    $0xf,%eax
8010324e:	01 d0                	add    %edx,%eax
80103250:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103253:	8b 45 08             	mov    0x8(%ebp),%eax
80103256:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103259:	89 10                	mov    %edx,(%eax)
8010325b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010325e:	89 50 04             	mov    %edx,0x4(%eax)
80103261:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103264:	89 50 08             	mov    %edx,0x8(%eax)
80103267:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010326a:	89 50 0c             	mov    %edx,0xc(%eax)
8010326d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103270:	89 50 10             	mov    %edx,0x10(%eax)
80103273:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103276:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103279:	8b 45 08             	mov    0x8(%ebp),%eax
8010327c:	8b 40 14             	mov    0x14(%eax),%eax
8010327f:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103285:	8b 45 08             	mov    0x8(%ebp),%eax
80103288:	89 50 14             	mov    %edx,0x14(%eax)
}
8010328b:	90                   	nop
8010328c:	c9                   	leave  
8010328d:	c3                   	ret    

8010328e <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
8010328e:	55                   	push   %ebp
8010328f:	89 e5                	mov    %esp,%ebp
80103291:	83 ec 18             	sub    $0x18,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103294:	83 ec 08             	sub    $0x8,%esp
80103297:	68 d4 89 10 80       	push   $0x801089d4
8010329c:	68 80 22 11 80       	push   $0x80112280
801032a1:	e8 e5 1d 00 00       	call   8010508b <initlock>
801032a6:	83 c4 10             	add    $0x10,%esp
  readsb(ROOTDEV, &sb);
801032a9:	83 ec 08             	sub    $0x8,%esp
801032ac:	8d 45 e8             	lea    -0x18(%ebp),%eax
801032af:	50                   	push   %eax
801032b0:	6a 01                	push   $0x1
801032b2:	e8 b2 e0 ff ff       	call   80101369 <readsb>
801032b7:	83 c4 10             	add    $0x10,%esp
  log.start = sb.size - sb.nlog;
801032ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032c0:	29 c2                	sub    %eax,%edx
801032c2:	89 d0                	mov    %edx,%eax
801032c4:	a3 b4 22 11 80       	mov    %eax,0x801122b4
  log.size = sb.nlog;
801032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032cc:	a3 b8 22 11 80       	mov    %eax,0x801122b8
  log.dev = ROOTDEV;
801032d1:	c7 05 c4 22 11 80 01 	movl   $0x1,0x801122c4
801032d8:	00 00 00 
  recover_from_log();
801032db:	e8 b2 01 00 00       	call   80103492 <recover_from_log>
}
801032e0:	90                   	nop
801032e1:	c9                   	leave  
801032e2:	c3                   	ret    

801032e3 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801032e3:	55                   	push   %ebp
801032e4:	89 e5                	mov    %esp,%ebp
801032e6:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032f0:	e9 95 00 00 00       	jmp    8010338a <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032f5:	8b 15 b4 22 11 80    	mov    0x801122b4,%edx
801032fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032fe:	01 d0                	add    %edx,%eax
80103300:	83 c0 01             	add    $0x1,%eax
80103303:	89 c2                	mov    %eax,%edx
80103305:	a1 c4 22 11 80       	mov    0x801122c4,%eax
8010330a:	83 ec 08             	sub    $0x8,%esp
8010330d:	52                   	push   %edx
8010330e:	50                   	push   %eax
8010330f:	e8 a2 ce ff ff       	call   801001b6 <bread>
80103314:	83 c4 10             	add    $0x10,%esp
80103317:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010331d:	83 c0 10             	add    $0x10,%eax
80103320:	8b 04 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%eax
80103327:	89 c2                	mov    %eax,%edx
80103329:	a1 c4 22 11 80       	mov    0x801122c4,%eax
8010332e:	83 ec 08             	sub    $0x8,%esp
80103331:	52                   	push   %edx
80103332:	50                   	push   %eax
80103333:	e8 7e ce ff ff       	call   801001b6 <bread>
80103338:	83 c4 10             	add    $0x10,%esp
8010333b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010333e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103341:	8d 50 18             	lea    0x18(%eax),%edx
80103344:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103347:	83 c0 18             	add    $0x18,%eax
8010334a:	83 ec 04             	sub    $0x4,%esp
8010334d:	68 00 02 00 00       	push   $0x200
80103352:	52                   	push   %edx
80103353:	50                   	push   %eax
80103354:	e8 76 20 00 00       	call   801053cf <memmove>
80103359:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010335c:	83 ec 0c             	sub    $0xc,%esp
8010335f:	ff 75 ec             	pushl  -0x14(%ebp)
80103362:	e8 88 ce ff ff       	call   801001ef <bwrite>
80103367:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010336a:	83 ec 0c             	sub    $0xc,%esp
8010336d:	ff 75 f0             	pushl  -0x10(%ebp)
80103370:	e8 b9 ce ff ff       	call   8010022e <brelse>
80103375:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103378:	83 ec 0c             	sub    $0xc,%esp
8010337b:	ff 75 ec             	pushl  -0x14(%ebp)
8010337e:	e8 ab ce ff ff       	call   8010022e <brelse>
80103383:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103386:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010338a:	a1 c8 22 11 80       	mov    0x801122c8,%eax
8010338f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103392:	0f 8f 5d ff ff ff    	jg     801032f5 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103398:	90                   	nop
80103399:	c9                   	leave  
8010339a:	c3                   	ret    

8010339b <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010339b:	55                   	push   %ebp
8010339c:	89 e5                	mov    %esp,%ebp
8010339e:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801033a1:	a1 b4 22 11 80       	mov    0x801122b4,%eax
801033a6:	89 c2                	mov    %eax,%edx
801033a8:	a1 c4 22 11 80       	mov    0x801122c4,%eax
801033ad:	83 ec 08             	sub    $0x8,%esp
801033b0:	52                   	push   %edx
801033b1:	50                   	push   %eax
801033b2:	e8 ff cd ff ff       	call   801001b6 <bread>
801033b7:	83 c4 10             	add    $0x10,%esp
801033ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801033bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033c0:	83 c0 18             	add    $0x18,%eax
801033c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033c9:	8b 00                	mov    (%eax),%eax
801033cb:	a3 c8 22 11 80       	mov    %eax,0x801122c8
  for (i = 0; i < log.lh.n; i++) {
801033d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033d7:	eb 1b                	jmp    801033f4 <read_head+0x59>
    log.lh.sector[i] = lh->sector[i];
801033d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033df:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801033e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033e6:	83 c2 10             	add    $0x10,%edx
801033e9:	89 04 95 8c 22 11 80 	mov    %eax,-0x7feedd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801033f0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033f4:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801033f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033fc:	7f db                	jg     801033d9 <read_head+0x3e>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
801033fe:	83 ec 0c             	sub    $0xc,%esp
80103401:	ff 75 f0             	pushl  -0x10(%ebp)
80103404:	e8 25 ce ff ff       	call   8010022e <brelse>
80103409:	83 c4 10             	add    $0x10,%esp
}
8010340c:	90                   	nop
8010340d:	c9                   	leave  
8010340e:	c3                   	ret    

8010340f <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010340f:	55                   	push   %ebp
80103410:	89 e5                	mov    %esp,%ebp
80103412:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103415:	a1 b4 22 11 80       	mov    0x801122b4,%eax
8010341a:	89 c2                	mov    %eax,%edx
8010341c:	a1 c4 22 11 80       	mov    0x801122c4,%eax
80103421:	83 ec 08             	sub    $0x8,%esp
80103424:	52                   	push   %edx
80103425:	50                   	push   %eax
80103426:	e8 8b cd ff ff       	call   801001b6 <bread>
8010342b:	83 c4 10             	add    $0x10,%esp
8010342e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103431:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103434:	83 c0 18             	add    $0x18,%eax
80103437:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010343a:	8b 15 c8 22 11 80    	mov    0x801122c8,%edx
80103440:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103443:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010344c:	eb 1b                	jmp    80103469 <write_head+0x5a>
    hb->sector[i] = log.lh.sector[i];
8010344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103451:	83 c0 10             	add    $0x10,%eax
80103454:	8b 0c 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%ecx
8010345b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010345e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103461:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103465:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103469:	a1 c8 22 11 80       	mov    0x801122c8,%eax
8010346e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103471:	7f db                	jg     8010344e <write_head+0x3f>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103473:	83 ec 0c             	sub    $0xc,%esp
80103476:	ff 75 f0             	pushl  -0x10(%ebp)
80103479:	e8 71 cd ff ff       	call   801001ef <bwrite>
8010347e:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103481:	83 ec 0c             	sub    $0xc,%esp
80103484:	ff 75 f0             	pushl  -0x10(%ebp)
80103487:	e8 a2 cd ff ff       	call   8010022e <brelse>
8010348c:	83 c4 10             	add    $0x10,%esp
}
8010348f:	90                   	nop
80103490:	c9                   	leave  
80103491:	c3                   	ret    

80103492 <recover_from_log>:

static void
recover_from_log(void)
{
80103492:	55                   	push   %ebp
80103493:	89 e5                	mov    %esp,%ebp
80103495:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103498:	e8 fe fe ff ff       	call   8010339b <read_head>
  install_trans(); // if committed, copy from log to disk
8010349d:	e8 41 fe ff ff       	call   801032e3 <install_trans>
  log.lh.n = 0;
801034a2:	c7 05 c8 22 11 80 00 	movl   $0x0,0x801122c8
801034a9:	00 00 00 
  write_head(); // clear the log
801034ac:	e8 5e ff ff ff       	call   8010340f <write_head>
}
801034b1:	90                   	nop
801034b2:	c9                   	leave  
801034b3:	c3                   	ret    

801034b4 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034b4:	55                   	push   %ebp
801034b5:	89 e5                	mov    %esp,%ebp
801034b7:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801034ba:	83 ec 0c             	sub    $0xc,%esp
801034bd:	68 80 22 11 80       	push   $0x80112280
801034c2:	e8 e6 1b 00 00       	call   801050ad <acquire>
801034c7:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801034ca:	a1 c0 22 11 80       	mov    0x801122c0,%eax
801034cf:	85 c0                	test   %eax,%eax
801034d1:	74 17                	je     801034ea <begin_op+0x36>
      sleep(&log, &log.lock);
801034d3:	83 ec 08             	sub    $0x8,%esp
801034d6:	68 80 22 11 80       	push   $0x80112280
801034db:	68 80 22 11 80       	push   $0x80112280
801034e0:	e8 8b 17 00 00       	call   80104c70 <sleep>
801034e5:	83 c4 10             	add    $0x10,%esp
801034e8:	eb e0                	jmp    801034ca <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034ea:	8b 0d c8 22 11 80    	mov    0x801122c8,%ecx
801034f0:	a1 bc 22 11 80       	mov    0x801122bc,%eax
801034f5:	8d 50 01             	lea    0x1(%eax),%edx
801034f8:	89 d0                	mov    %edx,%eax
801034fa:	c1 e0 02             	shl    $0x2,%eax
801034fd:	01 d0                	add    %edx,%eax
801034ff:	01 c0                	add    %eax,%eax
80103501:	01 c8                	add    %ecx,%eax
80103503:	83 f8 1e             	cmp    $0x1e,%eax
80103506:	7e 17                	jle    8010351f <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103508:	83 ec 08             	sub    $0x8,%esp
8010350b:	68 80 22 11 80       	push   $0x80112280
80103510:	68 80 22 11 80       	push   $0x80112280
80103515:	e8 56 17 00 00       	call   80104c70 <sleep>
8010351a:	83 c4 10             	add    $0x10,%esp
8010351d:	eb ab                	jmp    801034ca <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010351f:	a1 bc 22 11 80       	mov    0x801122bc,%eax
80103524:	83 c0 01             	add    $0x1,%eax
80103527:	a3 bc 22 11 80       	mov    %eax,0x801122bc
      release(&log.lock);
8010352c:	83 ec 0c             	sub    $0xc,%esp
8010352f:	68 80 22 11 80       	push   $0x80112280
80103534:	e8 db 1b 00 00       	call   80105114 <release>
80103539:	83 c4 10             	add    $0x10,%esp
      break;
8010353c:	90                   	nop
    }
  }
}
8010353d:	90                   	nop
8010353e:	c9                   	leave  
8010353f:	c3                   	ret    

80103540 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103546:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010354d:	83 ec 0c             	sub    $0xc,%esp
80103550:	68 80 22 11 80       	push   $0x80112280
80103555:	e8 53 1b 00 00       	call   801050ad <acquire>
8010355a:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010355d:	a1 bc 22 11 80       	mov    0x801122bc,%eax
80103562:	83 e8 01             	sub    $0x1,%eax
80103565:	a3 bc 22 11 80       	mov    %eax,0x801122bc
  if(log.committing)
8010356a:	a1 c0 22 11 80       	mov    0x801122c0,%eax
8010356f:	85 c0                	test   %eax,%eax
80103571:	74 0d                	je     80103580 <end_op+0x40>
    panic("log.committing");
80103573:	83 ec 0c             	sub    $0xc,%esp
80103576:	68 d8 89 10 80       	push   $0x801089d8
8010357b:	e8 e6 cf ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103580:	a1 bc 22 11 80       	mov    0x801122bc,%eax
80103585:	85 c0                	test   %eax,%eax
80103587:	75 13                	jne    8010359c <end_op+0x5c>
    do_commit = 1;
80103589:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103590:	c7 05 c0 22 11 80 01 	movl   $0x1,0x801122c0
80103597:	00 00 00 
8010359a:	eb 10                	jmp    801035ac <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010359c:	83 ec 0c             	sub    $0xc,%esp
8010359f:	68 80 22 11 80       	push   $0x80112280
801035a4:	e8 b5 17 00 00       	call   80104d5e <wakeup>
801035a9:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801035ac:	83 ec 0c             	sub    $0xc,%esp
801035af:	68 80 22 11 80       	push   $0x80112280
801035b4:	e8 5b 1b 00 00       	call   80105114 <release>
801035b9:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801035bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035c0:	74 3f                	je     80103601 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801035c2:	e8 f5 00 00 00       	call   801036bc <commit>
    acquire(&log.lock);
801035c7:	83 ec 0c             	sub    $0xc,%esp
801035ca:	68 80 22 11 80       	push   $0x80112280
801035cf:	e8 d9 1a 00 00       	call   801050ad <acquire>
801035d4:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801035d7:	c7 05 c0 22 11 80 00 	movl   $0x0,0x801122c0
801035de:	00 00 00 
    wakeup(&log);
801035e1:	83 ec 0c             	sub    $0xc,%esp
801035e4:	68 80 22 11 80       	push   $0x80112280
801035e9:	e8 70 17 00 00       	call   80104d5e <wakeup>
801035ee:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801035f1:	83 ec 0c             	sub    $0xc,%esp
801035f4:	68 80 22 11 80       	push   $0x80112280
801035f9:	e8 16 1b 00 00       	call   80105114 <release>
801035fe:	83 c4 10             	add    $0x10,%esp
  }
}
80103601:	90                   	nop
80103602:	c9                   	leave  
80103603:	c3                   	ret    

80103604 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103604:	55                   	push   %ebp
80103605:	89 e5                	mov    %esp,%ebp
80103607:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010360a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103611:	e9 95 00 00 00       	jmp    801036ab <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103616:	8b 15 b4 22 11 80    	mov    0x801122b4,%edx
8010361c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010361f:	01 d0                	add    %edx,%eax
80103621:	83 c0 01             	add    $0x1,%eax
80103624:	89 c2                	mov    %eax,%edx
80103626:	a1 c4 22 11 80       	mov    0x801122c4,%eax
8010362b:	83 ec 08             	sub    $0x8,%esp
8010362e:	52                   	push   %edx
8010362f:	50                   	push   %eax
80103630:	e8 81 cb ff ff       	call   801001b6 <bread>
80103635:	83 c4 10             	add    $0x10,%esp
80103638:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
8010363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010363e:	83 c0 10             	add    $0x10,%eax
80103641:	8b 04 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%eax
80103648:	89 c2                	mov    %eax,%edx
8010364a:	a1 c4 22 11 80       	mov    0x801122c4,%eax
8010364f:	83 ec 08             	sub    $0x8,%esp
80103652:	52                   	push   %edx
80103653:	50                   	push   %eax
80103654:	e8 5d cb ff ff       	call   801001b6 <bread>
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010365f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103662:	8d 50 18             	lea    0x18(%eax),%edx
80103665:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103668:	83 c0 18             	add    $0x18,%eax
8010366b:	83 ec 04             	sub    $0x4,%esp
8010366e:	68 00 02 00 00       	push   $0x200
80103673:	52                   	push   %edx
80103674:	50                   	push   %eax
80103675:	e8 55 1d 00 00       	call   801053cf <memmove>
8010367a:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
8010367d:	83 ec 0c             	sub    $0xc,%esp
80103680:	ff 75 f0             	pushl  -0x10(%ebp)
80103683:	e8 67 cb ff ff       	call   801001ef <bwrite>
80103688:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
8010368b:	83 ec 0c             	sub    $0xc,%esp
8010368e:	ff 75 ec             	pushl  -0x14(%ebp)
80103691:	e8 98 cb ff ff       	call   8010022e <brelse>
80103696:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103699:	83 ec 0c             	sub    $0xc,%esp
8010369c:	ff 75 f0             	pushl  -0x10(%ebp)
8010369f:	e8 8a cb ff ff       	call   8010022e <brelse>
801036a4:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036ab:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801036b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036b3:	0f 8f 5d ff ff ff    	jg     80103616 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801036b9:	90                   	nop
801036ba:	c9                   	leave  
801036bb:	c3                   	ret    

801036bc <commit>:

static void
commit()
{
801036bc:	55                   	push   %ebp
801036bd:	89 e5                	mov    %esp,%ebp
801036bf:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801036c2:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801036c7:	85 c0                	test   %eax,%eax
801036c9:	7e 1e                	jle    801036e9 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801036cb:	e8 34 ff ff ff       	call   80103604 <write_log>
    write_head();    // Write header to disk -- the real commit
801036d0:	e8 3a fd ff ff       	call   8010340f <write_head>
    install_trans(); // Now install writes to home locations
801036d5:	e8 09 fc ff ff       	call   801032e3 <install_trans>
    log.lh.n = 0; 
801036da:	c7 05 c8 22 11 80 00 	movl   $0x0,0x801122c8
801036e1:	00 00 00 
    write_head();    // Erase the transaction from the log
801036e4:	e8 26 fd ff ff       	call   8010340f <write_head>
  }
}
801036e9:	90                   	nop
801036ea:	c9                   	leave  
801036eb:	c3                   	ret    

801036ec <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036ec:	55                   	push   %ebp
801036ed:	89 e5                	mov    %esp,%ebp
801036ef:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036f2:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801036f7:	83 f8 1d             	cmp    $0x1d,%eax
801036fa:	7f 12                	jg     8010370e <log_write+0x22>
801036fc:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103701:	8b 15 b8 22 11 80    	mov    0x801122b8,%edx
80103707:	83 ea 01             	sub    $0x1,%edx
8010370a:	39 d0                	cmp    %edx,%eax
8010370c:	7c 0d                	jl     8010371b <log_write+0x2f>
    panic("too big a transaction");
8010370e:	83 ec 0c             	sub    $0xc,%esp
80103711:	68 e7 89 10 80       	push   $0x801089e7
80103716:	e8 4b ce ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010371b:	a1 bc 22 11 80       	mov    0x801122bc,%eax
80103720:	85 c0                	test   %eax,%eax
80103722:	7f 0d                	jg     80103731 <log_write+0x45>
    panic("log_write outside of trans");
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 fd 89 10 80       	push   $0x801089fd
8010372c:	e8 35 ce ff ff       	call   80100566 <panic>

  for (i = 0; i < log.lh.n; i++) {
80103731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103738:	eb 1d                	jmp    80103757 <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
8010373a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010373d:	83 c0 10             	add    $0x10,%eax
80103740:	8b 04 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%eax
80103747:	89 c2                	mov    %eax,%edx
80103749:	8b 45 08             	mov    0x8(%ebp),%eax
8010374c:	8b 40 08             	mov    0x8(%eax),%eax
8010374f:	39 c2                	cmp    %eax,%edx
80103751:	74 10                	je     80103763 <log_write+0x77>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103753:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103757:	a1 c8 22 11 80       	mov    0x801122c8,%eax
8010375c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010375f:	7f d9                	jg     8010373a <log_write+0x4e>
80103761:	eb 01                	jmp    80103764 <log_write+0x78>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
80103763:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
80103764:	8b 45 08             	mov    0x8(%ebp),%eax
80103767:	8b 40 08             	mov    0x8(%eax),%eax
8010376a:	89 c2                	mov    %eax,%edx
8010376c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010376f:	83 c0 10             	add    $0x10,%eax
80103772:	89 14 85 8c 22 11 80 	mov    %edx,-0x7feedd74(,%eax,4)
  if (i == log.lh.n)
80103779:	a1 c8 22 11 80       	mov    0x801122c8,%eax
8010377e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103781:	75 0d                	jne    80103790 <log_write+0xa4>
    log.lh.n++;
80103783:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103788:	83 c0 01             	add    $0x1,%eax
8010378b:	a3 c8 22 11 80       	mov    %eax,0x801122c8
  b->flags |= B_DIRTY; // prevent eviction
80103790:	8b 45 08             	mov    0x8(%ebp),%eax
80103793:	8b 00                	mov    (%eax),%eax
80103795:	83 c8 04             	or     $0x4,%eax
80103798:	89 c2                	mov    %eax,%edx
8010379a:	8b 45 08             	mov    0x8(%ebp),%eax
8010379d:	89 10                	mov    %edx,(%eax)
}
8010379f:	90                   	nop
801037a0:	c9                   	leave  
801037a1:	c3                   	ret    

801037a2 <v2p>:
801037a2:	55                   	push   %ebp
801037a3:	89 e5                	mov    %esp,%ebp
801037a5:	8b 45 08             	mov    0x8(%ebp),%eax
801037a8:	05 00 00 00 80       	add    $0x80000000,%eax
801037ad:	5d                   	pop    %ebp
801037ae:	c3                   	ret    

801037af <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801037af:	55                   	push   %ebp
801037b0:	89 e5                	mov    %esp,%ebp
801037b2:	8b 45 08             	mov    0x8(%ebp),%eax
801037b5:	05 00 00 00 80       	add    $0x80000000,%eax
801037ba:	5d                   	pop    %ebp
801037bb:	c3                   	ret    

801037bc <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801037bc:	55                   	push   %ebp
801037bd:	89 e5                	mov    %esp,%ebp
801037bf:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801037c2:	8b 55 08             	mov    0x8(%ebp),%edx
801037c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801037c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801037cb:	f0 87 02             	lock xchg %eax,(%edx)
801037ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801037d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801037d4:	c9                   	leave  
801037d5:	c3                   	ret    

801037d6 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801037d6:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801037da:	83 e4 f0             	and    $0xfffffff0,%esp
801037dd:	ff 71 fc             	pushl  -0x4(%ecx)
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	51                   	push   %ecx
801037e4:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801037e7:	83 ec 08             	sub    $0x8,%esp
801037ea:	68 00 00 40 80       	push   $0x80400000
801037ef:	68 5c 54 11 80       	push   $0x8011545c
801037f4:	e8 95 f2 ff ff       	call   80102a8e <kinit1>
801037f9:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801037fc:	e8 f0 47 00 00       	call   80107ff1 <kvmalloc>
  mpinit();        // collect info about this machine
80103801:	e8 48 04 00 00       	call   80103c4e <mpinit>
  lapicinit();
80103806:	e8 02 f6 ff ff       	call   80102e0d <lapicinit>
  seginit();       // set up segments
8010380b:	e8 8a 41 00 00       	call   8010799a <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103810:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103816:	0f b6 00             	movzbl (%eax),%eax
80103819:	0f b6 c0             	movzbl %al,%eax
8010381c:	83 ec 08             	sub    $0x8,%esp
8010381f:	50                   	push   %eax
80103820:	68 18 8a 10 80       	push   $0x80108a18
80103825:	e8 9c cb ff ff       	call   801003c6 <cprintf>
8010382a:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010382d:	e8 72 06 00 00       	call   80103ea4 <picinit>
  ioapicinit();    // another interrupt controller
80103832:	e8 4c f1 ff ff       	call   80102983 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103837:	e8 ad d2 ff ff       	call   80100ae9 <consoleinit>
  uartinit();      // serial port
8010383c:	e8 a9 34 00 00       	call   80106cea <uartinit>
  pinit();         // process table
80103841:	e8 5b 0b 00 00       	call   801043a1 <pinit>
  tvinit();        // trap vectors
80103846:	e8 45 30 00 00       	call   80106890 <tvinit>
  binit();         // buffer cache
8010384b:	e8 e4 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103850:	e8 05 d7 ff ff       	call   80100f5a <fileinit>
  iinit();         // inode cache
80103855:	e8 de dd ff ff       	call   80101638 <iinit>
  ideinit();       // disk
8010385a:	e8 68 ed ff ff       	call   801025c7 <ideinit>
  if(!ismp)
8010385f:	a1 64 23 11 80       	mov    0x80112364,%eax
80103864:	85 c0                	test   %eax,%eax
80103866:	75 05                	jne    8010386d <main+0x97>
    timerinit();   // uniprocessor timer
80103868:	e8 80 2f 00 00       	call   801067ed <timerinit>
  startothers();   // start other processors
8010386d:	e8 7f 00 00 00       	call   801038f1 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103872:	83 ec 08             	sub    $0x8,%esp
80103875:	68 00 00 00 8e       	push   $0x8e000000
8010387a:	68 00 00 40 80       	push   $0x80400000
8010387f:	e8 43 f2 ff ff       	call   80102ac7 <kinit2>
80103884:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103887:	e8 63 0c 00 00       	call   801044ef <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
8010388c:	e8 1a 00 00 00       	call   801038ab <mpmain>

80103891 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103891:	55                   	push   %ebp
80103892:	89 e5                	mov    %esp,%ebp
80103894:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103897:	e8 6d 47 00 00       	call   80108009 <switchkvm>
  seginit();
8010389c:	e8 f9 40 00 00       	call   8010799a <seginit>
  lapicinit();
801038a1:	e8 67 f5 ff ff       	call   80102e0d <lapicinit>
  mpmain();
801038a6:	e8 00 00 00 00       	call   801038ab <mpmain>

801038ab <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038ab:	55                   	push   %ebp
801038ac:	89 e5                	mov    %esp,%ebp
801038ae:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801038b1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038b7:	0f b6 00             	movzbl (%eax),%eax
801038ba:	0f b6 c0             	movzbl %al,%eax
801038bd:	83 ec 08             	sub    $0x8,%esp
801038c0:	50                   	push   %eax
801038c1:	68 2f 8a 10 80       	push   $0x80108a2f
801038c6:	e8 fb ca ff ff       	call   801003c6 <cprintf>
801038cb:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801038ce:	e8 33 31 00 00       	call   80106a06 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801038d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038d9:	05 a8 00 00 00       	add    $0xa8,%eax
801038de:	83 ec 08             	sub    $0x8,%esp
801038e1:	6a 01                	push   $0x1
801038e3:	50                   	push   %eax
801038e4:	e8 d3 fe ff ff       	call   801037bc <xchg>
801038e9:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801038ec:	e8 af 11 00 00       	call   80104aa0 <scheduler>

801038f1 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801038f1:	55                   	push   %ebp
801038f2:	89 e5                	mov    %esp,%ebp
801038f4:	53                   	push   %ebx
801038f5:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801038f8:	68 00 70 00 00       	push   $0x7000
801038fd:	e8 ad fe ff ff       	call   801037af <p2v>
80103902:	83 c4 04             	add    $0x4,%esp
80103905:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103908:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010390d:	83 ec 04             	sub    $0x4,%esp
80103910:	50                   	push   %eax
80103911:	68 2c b5 10 80       	push   $0x8010b52c
80103916:	ff 75 f0             	pushl  -0x10(%ebp)
80103919:	e8 b1 1a 00 00       	call   801053cf <memmove>
8010391e:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103921:	c7 45 f4 80 23 11 80 	movl   $0x80112380,-0xc(%ebp)
80103928:	e9 90 00 00 00       	jmp    801039bd <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
8010392d:	e8 f9 f5 ff ff       	call   80102f2b <cpunum>
80103932:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103938:	05 80 23 11 80       	add    $0x80112380,%eax
8010393d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103940:	74 73                	je     801039b5 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103942:	e8 7e f2 ff ff       	call   80102bc5 <kalloc>
80103947:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010394a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010394d:	83 e8 04             	sub    $0x4,%eax
80103950:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103953:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103959:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010395b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010395e:	83 e8 08             	sub    $0x8,%eax
80103961:	c7 00 91 38 10 80    	movl   $0x80103891,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103967:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010396a:	8d 58 f4             	lea    -0xc(%eax),%ebx
8010396d:	83 ec 0c             	sub    $0xc,%esp
80103970:	68 00 a0 10 80       	push   $0x8010a000
80103975:	e8 28 fe ff ff       	call   801037a2 <v2p>
8010397a:	83 c4 10             	add    $0x10,%esp
8010397d:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
8010397f:	83 ec 0c             	sub    $0xc,%esp
80103982:	ff 75 f0             	pushl  -0x10(%ebp)
80103985:	e8 18 fe ff ff       	call   801037a2 <v2p>
8010398a:	83 c4 10             	add    $0x10,%esp
8010398d:	89 c2                	mov    %eax,%edx
8010398f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103992:	0f b6 00             	movzbl (%eax),%eax
80103995:	0f b6 c0             	movzbl %al,%eax
80103998:	83 ec 08             	sub    $0x8,%esp
8010399b:	52                   	push   %edx
8010399c:	50                   	push   %eax
8010399d:	e8 03 f6 ff ff       	call   80102fa5 <lapicstartap>
801039a2:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039a5:	90                   	nop
801039a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a9:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801039af:	85 c0                	test   %eax,%eax
801039b1:	74 f3                	je     801039a6 <startothers+0xb5>
801039b3:	eb 01                	jmp    801039b6 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801039b5:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801039b6:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801039bd:	a1 60 29 11 80       	mov    0x80112960,%eax
801039c2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039c8:	05 80 23 11 80       	add    $0x80112380,%eax
801039cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039d0:	0f 87 57 ff ff ff    	ja     8010392d <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801039d6:	90                   	nop
801039d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039da:	c9                   	leave  
801039db:	c3                   	ret    

801039dc <p2v>:
801039dc:	55                   	push   %ebp
801039dd:	89 e5                	mov    %esp,%ebp
801039df:	8b 45 08             	mov    0x8(%ebp),%eax
801039e2:	05 00 00 00 80       	add    $0x80000000,%eax
801039e7:	5d                   	pop    %ebp
801039e8:	c3                   	ret    

801039e9 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039e9:	55                   	push   %ebp
801039ea:	89 e5                	mov    %esp,%ebp
801039ec:	83 ec 14             	sub    $0x14,%esp
801039ef:	8b 45 08             	mov    0x8(%ebp),%eax
801039f2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039f6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801039fa:	89 c2                	mov    %eax,%edx
801039fc:	ec                   	in     (%dx),%al
801039fd:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a00:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a04:	c9                   	leave  
80103a05:	c3                   	ret    

80103a06 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a06:	55                   	push   %ebp
80103a07:	89 e5                	mov    %esp,%ebp
80103a09:	83 ec 08             	sub    $0x8,%esp
80103a0c:	8b 55 08             	mov    0x8(%ebp),%edx
80103a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a12:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a16:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a19:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a1d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a21:	ee                   	out    %al,(%dx)
}
80103a22:	90                   	nop
80103a23:	c9                   	leave  
80103a24:	c3                   	ret    

80103a25 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a25:	55                   	push   %ebp
80103a26:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a28:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80103a2d:	89 c2                	mov    %eax,%edx
80103a2f:	b8 80 23 11 80       	mov    $0x80112380,%eax
80103a34:	29 c2                	sub    %eax,%edx
80103a36:	89 d0                	mov    %edx,%eax
80103a38:	c1 f8 02             	sar    $0x2,%eax
80103a3b:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a41:	5d                   	pop    %ebp
80103a42:	c3                   	ret    

80103a43 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a43:	55                   	push   %ebp
80103a44:	89 e5                	mov    %esp,%ebp
80103a46:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a49:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a57:	eb 15                	jmp    80103a6e <sum+0x2b>
    sum += addr[i];
80103a59:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80103a5f:	01 d0                	add    %edx,%eax
80103a61:	0f b6 00             	movzbl (%eax),%eax
80103a64:	0f b6 c0             	movzbl %al,%eax
80103a67:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103a6a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a71:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a74:	7c e3                	jl     80103a59 <sum+0x16>
    sum += addr[i];
  return sum;
80103a76:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a79:	c9                   	leave  
80103a7a:	c3                   	ret    

80103a7b <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a7b:	55                   	push   %ebp
80103a7c:	89 e5                	mov    %esp,%ebp
80103a7e:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103a81:	ff 75 08             	pushl  0x8(%ebp)
80103a84:	e8 53 ff ff ff       	call   801039dc <p2v>
80103a89:	83 c4 04             	add    $0x4,%esp
80103a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a95:	01 d0                	add    %edx,%eax
80103a97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aa0:	eb 36                	jmp    80103ad8 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103aa2:	83 ec 04             	sub    $0x4,%esp
80103aa5:	6a 04                	push   $0x4
80103aa7:	68 40 8a 10 80       	push   $0x80108a40
80103aac:	ff 75 f4             	pushl  -0xc(%ebp)
80103aaf:	e8 c3 18 00 00       	call   80105377 <memcmp>
80103ab4:	83 c4 10             	add    $0x10,%esp
80103ab7:	85 c0                	test   %eax,%eax
80103ab9:	75 19                	jne    80103ad4 <mpsearch1+0x59>
80103abb:	83 ec 08             	sub    $0x8,%esp
80103abe:	6a 10                	push   $0x10
80103ac0:	ff 75 f4             	pushl  -0xc(%ebp)
80103ac3:	e8 7b ff ff ff       	call   80103a43 <sum>
80103ac8:	83 c4 10             	add    $0x10,%esp
80103acb:	84 c0                	test   %al,%al
80103acd:	75 05                	jne    80103ad4 <mpsearch1+0x59>
      return (struct mp*)p;
80103acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ad2:	eb 11                	jmp    80103ae5 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103ad4:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103adb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ade:	72 c2                	jb     80103aa2 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103ae0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103ae5:	c9                   	leave  
80103ae6:	c3                   	ret    

80103ae7 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103ae7:	55                   	push   %ebp
80103ae8:	89 e5                	mov    %esp,%ebp
80103aea:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103aed:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af7:	83 c0 0f             	add    $0xf,%eax
80103afa:	0f b6 00             	movzbl (%eax),%eax
80103afd:	0f b6 c0             	movzbl %al,%eax
80103b00:	c1 e0 08             	shl    $0x8,%eax
80103b03:	89 c2                	mov    %eax,%edx
80103b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b08:	83 c0 0e             	add    $0xe,%eax
80103b0b:	0f b6 00             	movzbl (%eax),%eax
80103b0e:	0f b6 c0             	movzbl %al,%eax
80103b11:	09 d0                	or     %edx,%eax
80103b13:	c1 e0 04             	shl    $0x4,%eax
80103b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b1d:	74 21                	je     80103b40 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b1f:	83 ec 08             	sub    $0x8,%esp
80103b22:	68 00 04 00 00       	push   $0x400
80103b27:	ff 75 f0             	pushl  -0x10(%ebp)
80103b2a:	e8 4c ff ff ff       	call   80103a7b <mpsearch1>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b35:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b39:	74 51                	je     80103b8c <mpsearch+0xa5>
      return mp;
80103b3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b3e:	eb 61                	jmp    80103ba1 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b43:	83 c0 14             	add    $0x14,%eax
80103b46:	0f b6 00             	movzbl (%eax),%eax
80103b49:	0f b6 c0             	movzbl %al,%eax
80103b4c:	c1 e0 08             	shl    $0x8,%eax
80103b4f:	89 c2                	mov    %eax,%edx
80103b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b54:	83 c0 13             	add    $0x13,%eax
80103b57:	0f b6 00             	movzbl (%eax),%eax
80103b5a:	0f b6 c0             	movzbl %al,%eax
80103b5d:	09 d0                	or     %edx,%eax
80103b5f:	c1 e0 0a             	shl    $0xa,%eax
80103b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b68:	2d 00 04 00 00       	sub    $0x400,%eax
80103b6d:	83 ec 08             	sub    $0x8,%esp
80103b70:	68 00 04 00 00       	push   $0x400
80103b75:	50                   	push   %eax
80103b76:	e8 00 ff ff ff       	call   80103a7b <mpsearch1>
80103b7b:	83 c4 10             	add    $0x10,%esp
80103b7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b81:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b85:	74 05                	je     80103b8c <mpsearch+0xa5>
      return mp;
80103b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b8a:	eb 15                	jmp    80103ba1 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b8c:	83 ec 08             	sub    $0x8,%esp
80103b8f:	68 00 00 01 00       	push   $0x10000
80103b94:	68 00 00 0f 00       	push   $0xf0000
80103b99:	e8 dd fe ff ff       	call   80103a7b <mpsearch1>
80103b9e:	83 c4 10             	add    $0x10,%esp
}
80103ba1:	c9                   	leave  
80103ba2:	c3                   	ret    

80103ba3 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ba3:	55                   	push   %ebp
80103ba4:	89 e5                	mov    %esp,%ebp
80103ba6:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ba9:	e8 39 ff ff ff       	call   80103ae7 <mpsearch>
80103bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bb5:	74 0a                	je     80103bc1 <mpconfig+0x1e>
80103bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bba:	8b 40 04             	mov    0x4(%eax),%eax
80103bbd:	85 c0                	test   %eax,%eax
80103bbf:	75 0a                	jne    80103bcb <mpconfig+0x28>
    return 0;
80103bc1:	b8 00 00 00 00       	mov    $0x0,%eax
80103bc6:	e9 81 00 00 00       	jmp    80103c4c <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bce:	8b 40 04             	mov    0x4(%eax),%eax
80103bd1:	83 ec 0c             	sub    $0xc,%esp
80103bd4:	50                   	push   %eax
80103bd5:	e8 02 fe ff ff       	call   801039dc <p2v>
80103bda:	83 c4 10             	add    $0x10,%esp
80103bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103be0:	83 ec 04             	sub    $0x4,%esp
80103be3:	6a 04                	push   $0x4
80103be5:	68 45 8a 10 80       	push   $0x80108a45
80103bea:	ff 75 f0             	pushl  -0x10(%ebp)
80103bed:	e8 85 17 00 00       	call   80105377 <memcmp>
80103bf2:	83 c4 10             	add    $0x10,%esp
80103bf5:	85 c0                	test   %eax,%eax
80103bf7:	74 07                	je     80103c00 <mpconfig+0x5d>
    return 0;
80103bf9:	b8 00 00 00 00       	mov    $0x0,%eax
80103bfe:	eb 4c                	jmp    80103c4c <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c03:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c07:	3c 01                	cmp    $0x1,%al
80103c09:	74 12                	je     80103c1d <mpconfig+0x7a>
80103c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c0e:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c12:	3c 04                	cmp    $0x4,%al
80103c14:	74 07                	je     80103c1d <mpconfig+0x7a>
    return 0;
80103c16:	b8 00 00 00 00       	mov    $0x0,%eax
80103c1b:	eb 2f                	jmp    80103c4c <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c20:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c24:	0f b7 c0             	movzwl %ax,%eax
80103c27:	83 ec 08             	sub    $0x8,%esp
80103c2a:	50                   	push   %eax
80103c2b:	ff 75 f0             	pushl  -0x10(%ebp)
80103c2e:	e8 10 fe ff ff       	call   80103a43 <sum>
80103c33:	83 c4 10             	add    $0x10,%esp
80103c36:	84 c0                	test   %al,%al
80103c38:	74 07                	je     80103c41 <mpconfig+0x9e>
    return 0;
80103c3a:	b8 00 00 00 00       	mov    $0x0,%eax
80103c3f:	eb 0b                	jmp    80103c4c <mpconfig+0xa9>
  *pmp = mp;
80103c41:	8b 45 08             	mov    0x8(%ebp),%eax
80103c44:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c47:	89 10                	mov    %edx,(%eax)
  return conf;
80103c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c4c:	c9                   	leave  
80103c4d:	c3                   	ret    

80103c4e <mpinit>:

void
mpinit(void)
{
80103c4e:	55                   	push   %ebp
80103c4f:	89 e5                	mov    %esp,%ebp
80103c51:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c54:	c7 05 64 b6 10 80 80 	movl   $0x80112380,0x8010b664
80103c5b:	23 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c5e:	83 ec 0c             	sub    $0xc,%esp
80103c61:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c64:	50                   	push   %eax
80103c65:	e8 39 ff ff ff       	call   80103ba3 <mpconfig>
80103c6a:	83 c4 10             	add    $0x10,%esp
80103c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c74:	0f 84 96 01 00 00    	je     80103e10 <mpinit+0x1c2>
    return;
  ismp = 1;
80103c7a:	c7 05 64 23 11 80 01 	movl   $0x1,0x80112364
80103c81:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c87:	8b 40 24             	mov    0x24(%eax),%eax
80103c8a:	a3 7c 22 11 80       	mov    %eax,0x8011227c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c92:	83 c0 2c             	add    $0x2c,%eax
80103c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c9b:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c9f:	0f b7 d0             	movzwl %ax,%edx
80103ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca5:	01 d0                	add    %edx,%eax
80103ca7:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103caa:	e9 f2 00 00 00       	jmp    80103da1 <mpinit+0x153>
    switch(*p){
80103caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb2:	0f b6 00             	movzbl (%eax),%eax
80103cb5:	0f b6 c0             	movzbl %al,%eax
80103cb8:	83 f8 04             	cmp    $0x4,%eax
80103cbb:	0f 87 bc 00 00 00    	ja     80103d7d <mpinit+0x12f>
80103cc1:	8b 04 85 88 8a 10 80 	mov    -0x7fef7578(,%eax,4),%eax
80103cc8:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ccd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103cd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cd3:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cd7:	0f b6 d0             	movzbl %al,%edx
80103cda:	a1 60 29 11 80       	mov    0x80112960,%eax
80103cdf:	39 c2                	cmp    %eax,%edx
80103ce1:	74 2b                	je     80103d0e <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103ce3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ce6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cea:	0f b6 d0             	movzbl %al,%edx
80103ced:	a1 60 29 11 80       	mov    0x80112960,%eax
80103cf2:	83 ec 04             	sub    $0x4,%esp
80103cf5:	52                   	push   %edx
80103cf6:	50                   	push   %eax
80103cf7:	68 4a 8a 10 80       	push   $0x80108a4a
80103cfc:	e8 c5 c6 ff ff       	call   801003c6 <cprintf>
80103d01:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103d04:	c7 05 64 23 11 80 00 	movl   $0x0,0x80112364
80103d0b:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103d0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d11:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103d15:	0f b6 c0             	movzbl %al,%eax
80103d18:	83 e0 02             	and    $0x2,%eax
80103d1b:	85 c0                	test   %eax,%eax
80103d1d:	74 15                	je     80103d34 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103d1f:	a1 60 29 11 80       	mov    0x80112960,%eax
80103d24:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d2a:	05 80 23 11 80       	add    $0x80112380,%eax
80103d2f:	a3 64 b6 10 80       	mov    %eax,0x8010b664
      cpus[ncpu].id = ncpu;
80103d34:	a1 60 29 11 80       	mov    0x80112960,%eax
80103d39:	8b 15 60 29 11 80    	mov    0x80112960,%edx
80103d3f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d45:	05 80 23 11 80       	add    $0x80112380,%eax
80103d4a:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103d4c:	a1 60 29 11 80       	mov    0x80112960,%eax
80103d51:	83 c0 01             	add    $0x1,%eax
80103d54:	a3 60 29 11 80       	mov    %eax,0x80112960
      p += sizeof(struct mpproc);
80103d59:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d5d:	eb 42                	jmp    80103da1 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103d65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d68:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d6c:	a2 60 23 11 80       	mov    %al,0x80112360
      p += sizeof(struct mpioapic);
80103d71:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d75:	eb 2a                	jmp    80103da1 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d77:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d7b:	eb 24                	jmp    80103da1 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d80:	0f b6 00             	movzbl (%eax),%eax
80103d83:	0f b6 c0             	movzbl %al,%eax
80103d86:	83 ec 08             	sub    $0x8,%esp
80103d89:	50                   	push   %eax
80103d8a:	68 68 8a 10 80       	push   $0x80108a68
80103d8f:	e8 32 c6 ff ff       	call   801003c6 <cprintf>
80103d94:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103d97:	c7 05 64 23 11 80 00 	movl   $0x0,0x80112364
80103d9e:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103da4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103da7:	0f 82 02 ff ff ff    	jb     80103caf <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103dad:	a1 64 23 11 80       	mov    0x80112364,%eax
80103db2:	85 c0                	test   %eax,%eax
80103db4:	75 1d                	jne    80103dd3 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103db6:	c7 05 60 29 11 80 01 	movl   $0x1,0x80112960
80103dbd:	00 00 00 
    lapic = 0;
80103dc0:	c7 05 7c 22 11 80 00 	movl   $0x0,0x8011227c
80103dc7:	00 00 00 
    ioapicid = 0;
80103dca:	c6 05 60 23 11 80 00 	movb   $0x0,0x80112360
    return;
80103dd1:	eb 3e                	jmp    80103e11 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103dd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103dd6:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103dda:	84 c0                	test   %al,%al
80103ddc:	74 33                	je     80103e11 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103dde:	83 ec 08             	sub    $0x8,%esp
80103de1:	6a 70                	push   $0x70
80103de3:	6a 22                	push   $0x22
80103de5:	e8 1c fc ff ff       	call   80103a06 <outb>
80103dea:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103ded:	83 ec 0c             	sub    $0xc,%esp
80103df0:	6a 23                	push   $0x23
80103df2:	e8 f2 fb ff ff       	call   801039e9 <inb>
80103df7:	83 c4 10             	add    $0x10,%esp
80103dfa:	83 c8 01             	or     $0x1,%eax
80103dfd:	0f b6 c0             	movzbl %al,%eax
80103e00:	83 ec 08             	sub    $0x8,%esp
80103e03:	50                   	push   %eax
80103e04:	6a 23                	push   $0x23
80103e06:	e8 fb fb ff ff       	call   80103a06 <outb>
80103e0b:	83 c4 10             	add    $0x10,%esp
80103e0e:	eb 01                	jmp    80103e11 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103e10:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103e11:	c9                   	leave  
80103e12:	c3                   	ret    

80103e13 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e13:	55                   	push   %ebp
80103e14:	89 e5                	mov    %esp,%ebp
80103e16:	83 ec 08             	sub    $0x8,%esp
80103e19:	8b 55 08             	mov    0x8(%ebp),%edx
80103e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e1f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e23:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e26:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e2a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e2e:	ee                   	out    %al,(%dx)
}
80103e2f:	90                   	nop
80103e30:	c9                   	leave  
80103e31:	c3                   	ret    

80103e32 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e32:	55                   	push   %ebp
80103e33:	89 e5                	mov    %esp,%ebp
80103e35:	83 ec 04             	sub    $0x4,%esp
80103e38:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e3f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e43:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103e49:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e4d:	0f b6 c0             	movzbl %al,%eax
80103e50:	50                   	push   %eax
80103e51:	6a 21                	push   $0x21
80103e53:	e8 bb ff ff ff       	call   80103e13 <outb>
80103e58:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103e5b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e5f:	66 c1 e8 08          	shr    $0x8,%ax
80103e63:	0f b6 c0             	movzbl %al,%eax
80103e66:	50                   	push   %eax
80103e67:	68 a1 00 00 00       	push   $0xa1
80103e6c:	e8 a2 ff ff ff       	call   80103e13 <outb>
80103e71:	83 c4 08             	add    $0x8,%esp
}
80103e74:	90                   	nop
80103e75:	c9                   	leave  
80103e76:	c3                   	ret    

80103e77 <picenable>:

void
picenable(int irq)
{
80103e77:	55                   	push   %ebp
80103e78:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7d:	ba 01 00 00 00       	mov    $0x1,%edx
80103e82:	89 c1                	mov    %eax,%ecx
80103e84:	d3 e2                	shl    %cl,%edx
80103e86:	89 d0                	mov    %edx,%eax
80103e88:	f7 d0                	not    %eax
80103e8a:	89 c2                	mov    %eax,%edx
80103e8c:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103e93:	21 d0                	and    %edx,%eax
80103e95:	0f b7 c0             	movzwl %ax,%eax
80103e98:	50                   	push   %eax
80103e99:	e8 94 ff ff ff       	call   80103e32 <picsetmask>
80103e9e:	83 c4 04             	add    $0x4,%esp
}
80103ea1:	90                   	nop
80103ea2:	c9                   	leave  
80103ea3:	c3                   	ret    

80103ea4 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ea4:	55                   	push   %ebp
80103ea5:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ea7:	68 ff 00 00 00       	push   $0xff
80103eac:	6a 21                	push   $0x21
80103eae:	e8 60 ff ff ff       	call   80103e13 <outb>
80103eb3:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103eb6:	68 ff 00 00 00       	push   $0xff
80103ebb:	68 a1 00 00 00       	push   $0xa1
80103ec0:	e8 4e ff ff ff       	call   80103e13 <outb>
80103ec5:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ec8:	6a 11                	push   $0x11
80103eca:	6a 20                	push   $0x20
80103ecc:	e8 42 ff ff ff       	call   80103e13 <outb>
80103ed1:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103ed4:	6a 20                	push   $0x20
80103ed6:	6a 21                	push   $0x21
80103ed8:	e8 36 ff ff ff       	call   80103e13 <outb>
80103edd:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103ee0:	6a 04                	push   $0x4
80103ee2:	6a 21                	push   $0x21
80103ee4:	e8 2a ff ff ff       	call   80103e13 <outb>
80103ee9:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103eec:	6a 03                	push   $0x3
80103eee:	6a 21                	push   $0x21
80103ef0:	e8 1e ff ff ff       	call   80103e13 <outb>
80103ef5:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103ef8:	6a 11                	push   $0x11
80103efa:	68 a0 00 00 00       	push   $0xa0
80103eff:	e8 0f ff ff ff       	call   80103e13 <outb>
80103f04:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f07:	6a 28                	push   $0x28
80103f09:	68 a1 00 00 00       	push   $0xa1
80103f0e:	e8 00 ff ff ff       	call   80103e13 <outb>
80103f13:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f16:	6a 02                	push   $0x2
80103f18:	68 a1 00 00 00       	push   $0xa1
80103f1d:	e8 f1 fe ff ff       	call   80103e13 <outb>
80103f22:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f25:	6a 03                	push   $0x3
80103f27:	68 a1 00 00 00       	push   $0xa1
80103f2c:	e8 e2 fe ff ff       	call   80103e13 <outb>
80103f31:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f34:	6a 68                	push   $0x68
80103f36:	6a 20                	push   $0x20
80103f38:	e8 d6 fe ff ff       	call   80103e13 <outb>
80103f3d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f40:	6a 0a                	push   $0xa
80103f42:	6a 20                	push   $0x20
80103f44:	e8 ca fe ff ff       	call   80103e13 <outb>
80103f49:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103f4c:	6a 68                	push   $0x68
80103f4e:	68 a0 00 00 00       	push   $0xa0
80103f53:	e8 bb fe ff ff       	call   80103e13 <outb>
80103f58:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103f5b:	6a 0a                	push   $0xa
80103f5d:	68 a0 00 00 00       	push   $0xa0
80103f62:	e8 ac fe ff ff       	call   80103e13 <outb>
80103f67:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103f6a:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f71:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f75:	74 13                	je     80103f8a <picinit+0xe6>
    picsetmask(irqmask);
80103f77:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f7e:	0f b7 c0             	movzwl %ax,%eax
80103f81:	50                   	push   %eax
80103f82:	e8 ab fe ff ff       	call   80103e32 <picsetmask>
80103f87:	83 c4 04             	add    $0x4,%esp
}
80103f8a:	90                   	nop
80103f8b:	c9                   	leave  
80103f8c:	c3                   	ret    

80103f8d <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f8d:	55                   	push   %ebp
80103f8e:	89 e5                	mov    %esp,%ebp
80103f90:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103f93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fa6:	8b 10                	mov    (%eax),%edx
80103fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fab:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103fad:	e8 c6 cf ff ff       	call   80100f78 <filealloc>
80103fb2:	89 c2                	mov    %eax,%edx
80103fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb7:	89 10                	mov    %edx,(%eax)
80103fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80103fbc:	8b 00                	mov    (%eax),%eax
80103fbe:	85 c0                	test   %eax,%eax
80103fc0:	0f 84 cb 00 00 00    	je     80104091 <pipealloc+0x104>
80103fc6:	e8 ad cf ff ff       	call   80100f78 <filealloc>
80103fcb:	89 c2                	mov    %eax,%edx
80103fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fd0:	89 10                	mov    %edx,(%eax)
80103fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fd5:	8b 00                	mov    (%eax),%eax
80103fd7:	85 c0                	test   %eax,%eax
80103fd9:	0f 84 b2 00 00 00    	je     80104091 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103fdf:	e8 e1 eb ff ff       	call   80102bc5 <kalloc>
80103fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103feb:	0f 84 9f 00 00 00    	je     80104090 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80103ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ff4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103ffb:	00 00 00 
  p->writeopen = 1;
80103ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104001:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104008:	00 00 00 
  p->nwrite = 0;
8010400b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010400e:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104015:	00 00 00 
  p->nread = 0;
80104018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010401b:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104022:	00 00 00 
  initlock(&p->lock, "pipe");
80104025:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104028:	83 ec 08             	sub    $0x8,%esp
8010402b:	68 9c 8a 10 80       	push   $0x80108a9c
80104030:	50                   	push   %eax
80104031:	e8 55 10 00 00       	call   8010508b <initlock>
80104036:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104039:	8b 45 08             	mov    0x8(%ebp),%eax
8010403c:	8b 00                	mov    (%eax),%eax
8010403e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104044:	8b 45 08             	mov    0x8(%ebp),%eax
80104047:	8b 00                	mov    (%eax),%eax
80104049:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010404d:	8b 45 08             	mov    0x8(%ebp),%eax
80104050:	8b 00                	mov    (%eax),%eax
80104052:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104056:	8b 45 08             	mov    0x8(%ebp),%eax
80104059:	8b 00                	mov    (%eax),%eax
8010405b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010405e:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104061:	8b 45 0c             	mov    0xc(%ebp),%eax
80104064:	8b 00                	mov    (%eax),%eax
80104066:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010406c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010406f:	8b 00                	mov    (%eax),%eax
80104071:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104075:	8b 45 0c             	mov    0xc(%ebp),%eax
80104078:	8b 00                	mov    (%eax),%eax
8010407a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010407e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104081:	8b 00                	mov    (%eax),%eax
80104083:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104086:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104089:	b8 00 00 00 00       	mov    $0x0,%eax
8010408e:	eb 4e                	jmp    801040de <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104090:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80104091:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104095:	74 0e                	je     801040a5 <pipealloc+0x118>
    kfree((char*)p);
80104097:	83 ec 0c             	sub    $0xc,%esp
8010409a:	ff 75 f4             	pushl  -0xc(%ebp)
8010409d:	e8 86 ea ff ff       	call   80102b28 <kfree>
801040a2:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040a5:	8b 45 08             	mov    0x8(%ebp),%eax
801040a8:	8b 00                	mov    (%eax),%eax
801040aa:	85 c0                	test   %eax,%eax
801040ac:	74 11                	je     801040bf <pipealloc+0x132>
    fileclose(*f0);
801040ae:	8b 45 08             	mov    0x8(%ebp),%eax
801040b1:	8b 00                	mov    (%eax),%eax
801040b3:	83 ec 0c             	sub    $0xc,%esp
801040b6:	50                   	push   %eax
801040b7:	e8 7a cf ff ff       	call   80101036 <fileclose>
801040bc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801040bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c2:	8b 00                	mov    (%eax),%eax
801040c4:	85 c0                	test   %eax,%eax
801040c6:	74 11                	je     801040d9 <pipealloc+0x14c>
    fileclose(*f1);
801040c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801040cb:	8b 00                	mov    (%eax),%eax
801040cd:	83 ec 0c             	sub    $0xc,%esp
801040d0:	50                   	push   %eax
801040d1:	e8 60 cf ff ff       	call   80101036 <fileclose>
801040d6:	83 c4 10             	add    $0x10,%esp
  return -1;
801040d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040de:	c9                   	leave  
801040df:	c3                   	ret    

801040e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801040e6:	8b 45 08             	mov    0x8(%ebp),%eax
801040e9:	83 ec 0c             	sub    $0xc,%esp
801040ec:	50                   	push   %eax
801040ed:	e8 bb 0f 00 00       	call   801050ad <acquire>
801040f2:	83 c4 10             	add    $0x10,%esp
  if(writable){
801040f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801040f9:	74 23                	je     8010411e <pipeclose+0x3e>
    p->writeopen = 0;
801040fb:	8b 45 08             	mov    0x8(%ebp),%eax
801040fe:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104105:	00 00 00 
    wakeup(&p->nread);
80104108:	8b 45 08             	mov    0x8(%ebp),%eax
8010410b:	05 34 02 00 00       	add    $0x234,%eax
80104110:	83 ec 0c             	sub    $0xc,%esp
80104113:	50                   	push   %eax
80104114:	e8 45 0c 00 00       	call   80104d5e <wakeup>
80104119:	83 c4 10             	add    $0x10,%esp
8010411c:	eb 21                	jmp    8010413f <pipeclose+0x5f>
  } else {
    p->readopen = 0;
8010411e:	8b 45 08             	mov    0x8(%ebp),%eax
80104121:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104128:	00 00 00 
    wakeup(&p->nwrite);
8010412b:	8b 45 08             	mov    0x8(%ebp),%eax
8010412e:	05 38 02 00 00       	add    $0x238,%eax
80104133:	83 ec 0c             	sub    $0xc,%esp
80104136:	50                   	push   %eax
80104137:	e8 22 0c 00 00       	call   80104d5e <wakeup>
8010413c:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010413f:	8b 45 08             	mov    0x8(%ebp),%eax
80104142:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104148:	85 c0                	test   %eax,%eax
8010414a:	75 2c                	jne    80104178 <pipeclose+0x98>
8010414c:	8b 45 08             	mov    0x8(%ebp),%eax
8010414f:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104155:	85 c0                	test   %eax,%eax
80104157:	75 1f                	jne    80104178 <pipeclose+0x98>
    release(&p->lock);
80104159:	8b 45 08             	mov    0x8(%ebp),%eax
8010415c:	83 ec 0c             	sub    $0xc,%esp
8010415f:	50                   	push   %eax
80104160:	e8 af 0f 00 00       	call   80105114 <release>
80104165:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104168:	83 ec 0c             	sub    $0xc,%esp
8010416b:	ff 75 08             	pushl  0x8(%ebp)
8010416e:	e8 b5 e9 ff ff       	call   80102b28 <kfree>
80104173:	83 c4 10             	add    $0x10,%esp
80104176:	eb 0f                	jmp    80104187 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104178:	8b 45 08             	mov    0x8(%ebp),%eax
8010417b:	83 ec 0c             	sub    $0xc,%esp
8010417e:	50                   	push   %eax
8010417f:	e8 90 0f 00 00       	call   80105114 <release>
80104184:	83 c4 10             	add    $0x10,%esp
}
80104187:	90                   	nop
80104188:	c9                   	leave  
80104189:	c3                   	ret    

8010418a <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010418a:	55                   	push   %ebp
8010418b:	89 e5                	mov    %esp,%ebp
8010418d:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104190:	8b 45 08             	mov    0x8(%ebp),%eax
80104193:	83 ec 0c             	sub    $0xc,%esp
80104196:	50                   	push   %eax
80104197:	e8 11 0f 00 00       	call   801050ad <acquire>
8010419c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
8010419f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041a6:	e9 ad 00 00 00       	jmp    80104258 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801041ab:	8b 45 08             	mov    0x8(%ebp),%eax
801041ae:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041b4:	85 c0                	test   %eax,%eax
801041b6:	74 0d                	je     801041c5 <pipewrite+0x3b>
801041b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041be:	8b 40 24             	mov    0x24(%eax),%eax
801041c1:	85 c0                	test   %eax,%eax
801041c3:	74 19                	je     801041de <pipewrite+0x54>
        release(&p->lock);
801041c5:	8b 45 08             	mov    0x8(%ebp),%eax
801041c8:	83 ec 0c             	sub    $0xc,%esp
801041cb:	50                   	push   %eax
801041cc:	e8 43 0f 00 00       	call   80105114 <release>
801041d1:	83 c4 10             	add    $0x10,%esp
        return -1;
801041d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041d9:	e9 a8 00 00 00       	jmp    80104286 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801041de:	8b 45 08             	mov    0x8(%ebp),%eax
801041e1:	05 34 02 00 00       	add    $0x234,%eax
801041e6:	83 ec 0c             	sub    $0xc,%esp
801041e9:	50                   	push   %eax
801041ea:	e8 6f 0b 00 00       	call   80104d5e <wakeup>
801041ef:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801041f2:	8b 45 08             	mov    0x8(%ebp),%eax
801041f5:	8b 55 08             	mov    0x8(%ebp),%edx
801041f8:	81 c2 38 02 00 00    	add    $0x238,%edx
801041fe:	83 ec 08             	sub    $0x8,%esp
80104201:	50                   	push   %eax
80104202:	52                   	push   %edx
80104203:	e8 68 0a 00 00       	call   80104c70 <sleep>
80104208:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010420b:	8b 45 08             	mov    0x8(%ebp),%eax
8010420e:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104214:	8b 45 08             	mov    0x8(%ebp),%eax
80104217:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010421d:	05 00 02 00 00       	add    $0x200,%eax
80104222:	39 c2                	cmp    %eax,%edx
80104224:	74 85                	je     801041ab <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104226:	8b 45 08             	mov    0x8(%ebp),%eax
80104229:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010422f:	8d 48 01             	lea    0x1(%eax),%ecx
80104232:	8b 55 08             	mov    0x8(%ebp),%edx
80104235:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010423b:	25 ff 01 00 00       	and    $0x1ff,%eax
80104240:	89 c1                	mov    %eax,%ecx
80104242:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104245:	8b 45 0c             	mov    0xc(%ebp),%eax
80104248:	01 d0                	add    %edx,%eax
8010424a:	0f b6 10             	movzbl (%eax),%edx
8010424d:	8b 45 08             	mov    0x8(%ebp),%eax
80104250:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104254:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104258:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010425e:	7c ab                	jl     8010420b <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104260:	8b 45 08             	mov    0x8(%ebp),%eax
80104263:	05 34 02 00 00       	add    $0x234,%eax
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	50                   	push   %eax
8010426c:	e8 ed 0a 00 00       	call   80104d5e <wakeup>
80104271:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104274:	8b 45 08             	mov    0x8(%ebp),%eax
80104277:	83 ec 0c             	sub    $0xc,%esp
8010427a:	50                   	push   %eax
8010427b:	e8 94 0e 00 00       	call   80105114 <release>
80104280:	83 c4 10             	add    $0x10,%esp
  return n;
80104283:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104286:	c9                   	leave  
80104287:	c3                   	ret    

80104288 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104288:	55                   	push   %ebp
80104289:	89 e5                	mov    %esp,%ebp
8010428b:	53                   	push   %ebx
8010428c:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010428f:	8b 45 08             	mov    0x8(%ebp),%eax
80104292:	83 ec 0c             	sub    $0xc,%esp
80104295:	50                   	push   %eax
80104296:	e8 12 0e 00 00       	call   801050ad <acquire>
8010429b:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010429e:	eb 3f                	jmp    801042df <piperead+0x57>
    if(proc->killed){
801042a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042a6:	8b 40 24             	mov    0x24(%eax),%eax
801042a9:	85 c0                	test   %eax,%eax
801042ab:	74 19                	je     801042c6 <piperead+0x3e>
      release(&p->lock);
801042ad:	8b 45 08             	mov    0x8(%ebp),%eax
801042b0:	83 ec 0c             	sub    $0xc,%esp
801042b3:	50                   	push   %eax
801042b4:	e8 5b 0e 00 00       	call   80105114 <release>
801042b9:	83 c4 10             	add    $0x10,%esp
      return -1;
801042bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042c1:	e9 bf 00 00 00       	jmp    80104385 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801042c6:	8b 45 08             	mov    0x8(%ebp),%eax
801042c9:	8b 55 08             	mov    0x8(%ebp),%edx
801042cc:	81 c2 34 02 00 00    	add    $0x234,%edx
801042d2:	83 ec 08             	sub    $0x8,%esp
801042d5:	50                   	push   %eax
801042d6:	52                   	push   %edx
801042d7:	e8 94 09 00 00       	call   80104c70 <sleep>
801042dc:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042df:	8b 45 08             	mov    0x8(%ebp),%eax
801042e2:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042e8:	8b 45 08             	mov    0x8(%ebp),%eax
801042eb:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042f1:	39 c2                	cmp    %eax,%edx
801042f3:	75 0d                	jne    80104302 <piperead+0x7a>
801042f5:	8b 45 08             	mov    0x8(%ebp),%eax
801042f8:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042fe:	85 c0                	test   %eax,%eax
80104300:	75 9e                	jne    801042a0 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104302:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104309:	eb 49                	jmp    80104354 <piperead+0xcc>
    if(p->nread == p->nwrite)
8010430b:	8b 45 08             	mov    0x8(%ebp),%eax
8010430e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104314:	8b 45 08             	mov    0x8(%ebp),%eax
80104317:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010431d:	39 c2                	cmp    %eax,%edx
8010431f:	74 3d                	je     8010435e <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104321:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104324:	8b 45 0c             	mov    0xc(%ebp),%eax
80104327:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010432a:	8b 45 08             	mov    0x8(%ebp),%eax
8010432d:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104333:	8d 48 01             	lea    0x1(%eax),%ecx
80104336:	8b 55 08             	mov    0x8(%ebp),%edx
80104339:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010433f:	25 ff 01 00 00       	and    $0x1ff,%eax
80104344:	89 c2                	mov    %eax,%edx
80104346:	8b 45 08             	mov    0x8(%ebp),%eax
80104349:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
8010434e:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104350:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104354:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104357:	3b 45 10             	cmp    0x10(%ebp),%eax
8010435a:	7c af                	jl     8010430b <piperead+0x83>
8010435c:	eb 01                	jmp    8010435f <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
8010435e:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010435f:	8b 45 08             	mov    0x8(%ebp),%eax
80104362:	05 38 02 00 00       	add    $0x238,%eax
80104367:	83 ec 0c             	sub    $0xc,%esp
8010436a:	50                   	push   %eax
8010436b:	e8 ee 09 00 00       	call   80104d5e <wakeup>
80104370:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104373:	8b 45 08             	mov    0x8(%ebp),%eax
80104376:	83 ec 0c             	sub    $0xc,%esp
80104379:	50                   	push   %eax
8010437a:	e8 95 0d 00 00       	call   80105114 <release>
8010437f:	83 c4 10             	add    $0x10,%esp
  return i;
80104382:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104388:	c9                   	leave  
80104389:	c3                   	ret    

8010438a <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010438a:	55                   	push   %ebp
8010438b:	89 e5                	mov    %esp,%ebp
8010438d:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104390:	9c                   	pushf  
80104391:	58                   	pop    %eax
80104392:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104395:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104398:	c9                   	leave  
80104399:	c3                   	ret    

8010439a <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010439a:	55                   	push   %ebp
8010439b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010439d:	fb                   	sti    
}
8010439e:	90                   	nop
8010439f:	5d                   	pop    %ebp
801043a0:	c3                   	ret    

801043a1 <pinit>:



void
pinit(void)
{
801043a1:	55                   	push   %ebp
801043a2:	89 e5                	mov    %esp,%ebp
801043a4:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801043a7:	83 ec 08             	sub    $0x8,%esp
801043aa:	68 a1 8a 10 80       	push   $0x80108aa1
801043af:	68 80 29 11 80       	push   $0x80112980
801043b4:	e8 d2 0c 00 00       	call   8010508b <initlock>
801043b9:	83 c4 10             	add    $0x10,%esp
}
801043bc:	90                   	nop
801043bd:	c9                   	leave  
801043be:	c3                   	ret    

801043bf <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801043bf:	55                   	push   %ebp
801043c0:	89 e5                	mov    %esp,%ebp
801043c2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801043c5:	83 ec 0c             	sub    $0xc,%esp
801043c8:	68 80 29 11 80       	push   $0x80112980
801043cd:	e8 db 0c 00 00       	call   801050ad <acquire>
801043d2:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d5:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
801043dc:	eb 11                	jmp    801043ef <allocproc+0x30>
    if(p->state == UNUSED)
801043de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e1:	8b 40 0c             	mov    0xc(%eax),%eax
801043e4:	85 c0                	test   %eax,%eax
801043e6:	74 2a                	je     80104412 <allocproc+0x53>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043e8:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
801043ef:	81 7d f4 b4 4b 11 80 	cmpl   $0x80114bb4,-0xc(%ebp)
801043f6:	72 e6                	jb     801043de <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	68 80 29 11 80       	push   $0x80112980
80104400:	e8 0f 0d 00 00       	call   80105114 <release>
80104405:	83 c4 10             	add    $0x10,%esp
  return 0;
80104408:	b8 00 00 00 00       	mov    $0x0,%eax
8010440d:	e9 db 00 00 00       	jmp    801044ed <allocproc+0x12e>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104412:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104413:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104416:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010441d:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104422:	8d 50 01             	lea    0x1(%eax),%edx
80104425:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
8010442b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010442e:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104431:	83 ec 0c             	sub    $0xc,%esp
80104434:	68 80 29 11 80       	push   $0x80112980
80104439:	e8 d6 0c 00 00       	call   80105114 <release>
8010443e:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104441:	e8 7f e7 ff ff       	call   80102bc5 <kalloc>
80104446:	89 c2                	mov    %eax,%edx
80104448:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010444b:	89 50 08             	mov    %edx,0x8(%eax)
8010444e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104451:	8b 40 08             	mov    0x8(%eax),%eax
80104454:	85 c0                	test   %eax,%eax
80104456:	75 14                	jne    8010446c <allocproc+0xad>
    p->state = UNUSED;
80104458:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010445b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104462:	b8 00 00 00 00       	mov    $0x0,%eax
80104467:	e9 81 00 00 00       	jmp    801044ed <allocproc+0x12e>
  }
  sp = p->kstack + KSTACKSIZE;
8010446c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010446f:	8b 40 08             	mov    0x8(%eax),%eax
80104472:	05 00 10 00 00       	add    $0x1000,%eax
80104477:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010447a:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010447e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104481:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104484:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104487:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010448b:	ba 4a 68 10 80       	mov    $0x8010684a,%edx
80104490:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104493:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104495:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104499:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010449c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010449f:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801044a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a5:	8b 40 1c             	mov    0x1c(%eax),%eax
801044a8:	83 ec 04             	sub    $0x4,%esp
801044ab:	6a 14                	push   $0x14
801044ad:	6a 00                	push   $0x0
801044af:	50                   	push   %eax
801044b0:	e8 5b 0e 00 00       	call   80105310 <memset>
801044b5:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801044b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044bb:	8b 40 1c             	mov    0x1c(%eax),%eax
801044be:	ba 3f 4c 10 80       	mov    $0x80104c3f,%edx
801044c3:	89 50 10             	mov    %edx,0x10(%eax)

  p->handlers[SIGKILL] = (sighandler_t) -1;
801044c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c9:	c7 40 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%eax)
  p->handlers[SIGFPE] = (sighandler_t) -1;
801044d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d3:	c7 80 80 00 00 00 ff 	movl   $0xffffffff,0x80(%eax)
801044da:	ff ff ff 
  p->restorer_addr = -1;
801044dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e0:	c7 80 84 00 00 00 ff 	movl   $0xffffffff,0x84(%eax)
801044e7:	ff ff ff 

  return p;
801044ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044ed:	c9                   	leave  
801044ee:	c3                   	ret    

801044ef <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801044ef:	55                   	push   %ebp
801044f0:	89 e5                	mov    %esp,%ebp
801044f2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801044f5:	e8 c5 fe ff ff       	call   801043bf <allocproc>
801044fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801044fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104500:	a3 68 b6 10 80       	mov    %eax,0x8010b668
  if((p->pgdir = setupkvm()) == 0)
80104505:	e8 35 3a 00 00       	call   80107f3f <setupkvm>
8010450a:	89 c2                	mov    %eax,%edx
8010450c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010450f:	89 50 04             	mov    %edx,0x4(%eax)
80104512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104515:	8b 40 04             	mov    0x4(%eax),%eax
80104518:	85 c0                	test   %eax,%eax
8010451a:	75 0d                	jne    80104529 <userinit+0x3a>
    panic("userinit: out of memory?");
8010451c:	83 ec 0c             	sub    $0xc,%esp
8010451f:	68 a8 8a 10 80       	push   $0x80108aa8
80104524:	e8 3d c0 ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104529:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010452e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104531:	8b 40 04             	mov    0x4(%eax),%eax
80104534:	83 ec 04             	sub    $0x4,%esp
80104537:	52                   	push   %edx
80104538:	68 00 b5 10 80       	push   $0x8010b500
8010453d:	50                   	push   %eax
8010453e:	e8 56 3c 00 00       	call   80108199 <inituvm>
80104543:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104546:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104549:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010454f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104552:	8b 40 18             	mov    0x18(%eax),%eax
80104555:	83 ec 04             	sub    $0x4,%esp
80104558:	6a 4c                	push   $0x4c
8010455a:	6a 00                	push   $0x0
8010455c:	50                   	push   %eax
8010455d:	e8 ae 0d 00 00       	call   80105310 <memset>
80104562:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104565:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104568:	8b 40 18             	mov    0x18(%eax),%eax
8010456b:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104571:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104574:	8b 40 18             	mov    0x18(%eax),%eax
80104577:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010457d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104580:	8b 40 18             	mov    0x18(%eax),%eax
80104583:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104586:	8b 52 18             	mov    0x18(%edx),%edx
80104589:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010458d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104594:	8b 40 18             	mov    0x18(%eax),%eax
80104597:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010459a:	8b 52 18             	mov    0x18(%edx),%edx
8010459d:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045a1:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801045a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a8:	8b 40 18             	mov    0x18(%eax),%eax
801045ab:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801045b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b5:	8b 40 18             	mov    0x18(%eax),%eax
801045b8:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801045bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c2:	8b 40 18             	mov    0x18(%eax),%eax
801045c5:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801045cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045cf:	83 c0 6c             	add    $0x6c,%eax
801045d2:	83 ec 04             	sub    $0x4,%esp
801045d5:	6a 10                	push   $0x10
801045d7:	68 c1 8a 10 80       	push   $0x80108ac1
801045dc:	50                   	push   %eax
801045dd:	e8 31 0f 00 00       	call   80105513 <safestrcpy>
801045e2:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801045e5:	83 ec 0c             	sub    $0xc,%esp
801045e8:	68 ca 8a 10 80       	push   $0x80108aca
801045ed:	e8 d1 de ff ff       	call   801024c3 <namei>
801045f2:	83 c4 10             	add    $0x10,%esp
801045f5:	89 c2                	mov    %eax,%edx
801045f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045fa:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
801045fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104600:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104607:	90                   	nop
80104608:	c9                   	leave  
80104609:	c3                   	ret    

8010460a <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010460a:	55                   	push   %ebp
8010460b:	89 e5                	mov    %esp,%ebp
8010460d:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
80104610:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104616:	8b 00                	mov    (%eax),%eax
80104618:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010461b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010461f:	7e 31                	jle    80104652 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104621:	8b 55 08             	mov    0x8(%ebp),%edx
80104624:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104627:	01 c2                	add    %eax,%edx
80104629:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010462f:	8b 40 04             	mov    0x4(%eax),%eax
80104632:	83 ec 04             	sub    $0x4,%esp
80104635:	52                   	push   %edx
80104636:	ff 75 f4             	pushl  -0xc(%ebp)
80104639:	50                   	push   %eax
8010463a:	e8 10 3d 00 00       	call   8010834f <allocuvm>
8010463f:	83 c4 10             	add    $0x10,%esp
80104642:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104649:	75 3e                	jne    80104689 <growproc+0x7f>
      return -1;
8010464b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104650:	eb 59                	jmp    801046ab <growproc+0xa1>
  } else if(n < 0){
80104652:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104656:	79 31                	jns    80104689 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104658:	8b 55 08             	mov    0x8(%ebp),%edx
8010465b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465e:	01 c2                	add    %eax,%edx
80104660:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104666:	8b 40 04             	mov    0x4(%eax),%eax
80104669:	83 ec 04             	sub    $0x4,%esp
8010466c:	52                   	push   %edx
8010466d:	ff 75 f4             	pushl  -0xc(%ebp)
80104670:	50                   	push   %eax
80104671:	e8 a2 3d 00 00       	call   80108418 <deallocuvm>
80104676:	83 c4 10             	add    $0x10,%esp
80104679:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010467c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104680:	75 07                	jne    80104689 <growproc+0x7f>
      return -1;
80104682:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104687:	eb 22                	jmp    801046ab <growproc+0xa1>
  }
  proc->sz = sz;
80104689:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010468f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104692:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104694:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010469a:	83 ec 0c             	sub    $0xc,%esp
8010469d:	50                   	push   %eax
8010469e:	e8 83 39 00 00       	call   80108026 <switchuvm>
801046a3:	83 c4 10             	add    $0x10,%esp
  return 0;
801046a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046ab:	c9                   	leave  
801046ac:	c3                   	ret    

801046ad <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801046ad:	55                   	push   %ebp
801046ae:	89 e5                	mov    %esp,%ebp
801046b0:	57                   	push   %edi
801046b1:	56                   	push   %esi
801046b2:	53                   	push   %ebx
801046b3:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801046b6:	e8 04 fd ff ff       	call   801043bf <allocproc>
801046bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801046be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801046c2:	75 0a                	jne    801046ce <fork+0x21>
    return -1;
801046c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046c9:	e9 68 01 00 00       	jmp    80104836 <fork+0x189>

  // Copy process state from p.
  //look into this for cowfork
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801046ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046d4:	8b 10                	mov    (%eax),%edx
801046d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046dc:	8b 40 04             	mov    0x4(%eax),%eax
801046df:	83 ec 08             	sub    $0x8,%esp
801046e2:	52                   	push   %edx
801046e3:	50                   	push   %eax
801046e4:	e8 cd 3e 00 00       	call   801085b6 <copyuvm>
801046e9:	83 c4 10             	add    $0x10,%esp
801046ec:	89 c2                	mov    %eax,%edx
801046ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046f1:	89 50 04             	mov    %edx,0x4(%eax)
801046f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046f7:	8b 40 04             	mov    0x4(%eax),%eax
801046fa:	85 c0                	test   %eax,%eax
801046fc:	75 30                	jne    8010472e <fork+0x81>
    kfree(np->kstack);
801046fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104701:	8b 40 08             	mov    0x8(%eax),%eax
80104704:	83 ec 0c             	sub    $0xc,%esp
80104707:	50                   	push   %eax
80104708:	e8 1b e4 ff ff       	call   80102b28 <kfree>
8010470d:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104710:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104713:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010471a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010471d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104729:	e9 08 01 00 00       	jmp    80104836 <fork+0x189>
  }
  np->sz = proc->sz;
8010472e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104734:	8b 10                	mov    (%eax),%edx
80104736:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104739:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010473b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104742:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104745:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104748:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010474b:	8b 50 18             	mov    0x18(%eax),%edx
8010474e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104754:	8b 40 18             	mov    0x18(%eax),%eax
80104757:	89 c3                	mov    %eax,%ebx
80104759:	b8 13 00 00 00       	mov    $0x13,%eax
8010475e:	89 d7                	mov    %edx,%edi
80104760:	89 de                	mov    %ebx,%esi
80104762:	89 c1                	mov    %eax,%ecx
80104764:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104766:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104769:	8b 40 18             	mov    0x18(%eax),%eax
8010476c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104773:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010477a:	eb 43                	jmp    801047bf <fork+0x112>
    if(proc->ofile[i])
8010477c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104782:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104785:	83 c2 08             	add    $0x8,%edx
80104788:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010478c:	85 c0                	test   %eax,%eax
8010478e:	74 2b                	je     801047bb <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
80104790:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104796:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104799:	83 c2 08             	add    $0x8,%edx
8010479c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047a0:	83 ec 0c             	sub    $0xc,%esp
801047a3:	50                   	push   %eax
801047a4:	e8 3c c8 ff ff       	call   80100fe5 <filedup>
801047a9:	83 c4 10             	add    $0x10,%esp
801047ac:	89 c1                	mov    %eax,%ecx
801047ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047b4:	83 c2 08             	add    $0x8,%edx
801047b7:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801047bb:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047bf:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047c3:	7e b7                	jle    8010477c <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801047c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047cb:	8b 40 68             	mov    0x68(%eax),%eax
801047ce:	83 ec 0c             	sub    $0xc,%esp
801047d1:	50                   	push   %eax
801047d2:	e8 fa d0 ff ff       	call   801018d1 <idup>
801047d7:	83 c4 10             	add    $0x10,%esp
801047da:	89 c2                	mov    %eax,%edx
801047dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047df:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801047e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047e8:	8d 50 6c             	lea    0x6c(%eax),%edx
801047eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047ee:	83 c0 6c             	add    $0x6c,%eax
801047f1:	83 ec 04             	sub    $0x4,%esp
801047f4:	6a 10                	push   $0x10
801047f6:	52                   	push   %edx
801047f7:	50                   	push   %eax
801047f8:	e8 16 0d 00 00       	call   80105513 <safestrcpy>
801047fd:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104800:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104803:	8b 40 10             	mov    0x10(%eax),%eax
80104806:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104809:	83 ec 0c             	sub    $0xc,%esp
8010480c:	68 80 29 11 80       	push   $0x80112980
80104811:	e8 97 08 00 00       	call   801050ad <acquire>
80104816:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104819:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010481c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104823:	83 ec 0c             	sub    $0xc,%esp
80104826:	68 80 29 11 80       	push   $0x80112980
8010482b:	e8 e4 08 00 00       	call   80105114 <release>
80104830:	83 c4 10             	add    $0x10,%esp

  return pid;
80104833:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104836:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104839:	5b                   	pop    %ebx
8010483a:	5e                   	pop    %esi
8010483b:	5f                   	pop    %edi
8010483c:	5d                   	pop    %ebp
8010483d:	c3                   	ret    

8010483e <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010483e:	55                   	push   %ebp
8010483f:	89 e5                	mov    %esp,%ebp
80104841:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104844:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010484b:	a1 68 b6 10 80       	mov    0x8010b668,%eax
80104850:	39 c2                	cmp    %eax,%edx
80104852:	75 0d                	jne    80104861 <exit+0x23>
    panic("init exiting");
80104854:	83 ec 0c             	sub    $0xc,%esp
80104857:	68 cc 8a 10 80       	push   $0x80108acc
8010485c:	e8 05 bd ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104861:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104868:	eb 48                	jmp    801048b2 <exit+0x74>
    if(proc->ofile[fd]){
8010486a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104870:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104873:	83 c2 08             	add    $0x8,%edx
80104876:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010487a:	85 c0                	test   %eax,%eax
8010487c:	74 30                	je     801048ae <exit+0x70>
      fileclose(proc->ofile[fd]);
8010487e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104884:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104887:	83 c2 08             	add    $0x8,%edx
8010488a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010488e:	83 ec 0c             	sub    $0xc,%esp
80104891:	50                   	push   %eax
80104892:	e8 9f c7 ff ff       	call   80101036 <fileclose>
80104897:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
8010489a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048a3:	83 c2 08             	add    $0x8,%edx
801048a6:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801048ad:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048ae:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801048b2:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801048b6:	7e b2                	jle    8010486a <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
801048b8:	e8 f7 eb ff ff       	call   801034b4 <begin_op>
  iput(proc->cwd);
801048bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c3:	8b 40 68             	mov    0x68(%eax),%eax
801048c6:	83 ec 0c             	sub    $0xc,%esp
801048c9:	50                   	push   %eax
801048ca:	e8 06 d2 ff ff       	call   80101ad5 <iput>
801048cf:	83 c4 10             	add    $0x10,%esp
  end_op();
801048d2:	e8 69 ec ff ff       	call   80103540 <end_op>
  proc->cwd = 0;
801048d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048dd:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801048e4:	83 ec 0c             	sub    $0xc,%esp
801048e7:	68 80 29 11 80       	push   $0x80112980
801048ec:	e8 bc 07 00 00       	call   801050ad <acquire>
801048f1:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801048f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048fa:	8b 40 14             	mov    0x14(%eax),%eax
801048fd:	83 ec 0c             	sub    $0xc,%esp
80104900:	50                   	push   %eax
80104901:	e8 16 04 00 00       	call   80104d1c <wakeup1>
80104906:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104909:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
80104910:	eb 3f                	jmp    80104951 <exit+0x113>
    if(p->parent == proc){
80104912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104915:	8b 50 14             	mov    0x14(%eax),%edx
80104918:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491e:	39 c2                	cmp    %eax,%edx
80104920:	75 28                	jne    8010494a <exit+0x10c>
      p->parent = initproc;
80104922:	8b 15 68 b6 10 80    	mov    0x8010b668,%edx
80104928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010492b:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010492e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104931:	8b 40 0c             	mov    0xc(%eax),%eax
80104934:	83 f8 05             	cmp    $0x5,%eax
80104937:	75 11                	jne    8010494a <exit+0x10c>
        wakeup1(initproc);
80104939:	a1 68 b6 10 80       	mov    0x8010b668,%eax
8010493e:	83 ec 0c             	sub    $0xc,%esp
80104941:	50                   	push   %eax
80104942:	e8 d5 03 00 00       	call   80104d1c <wakeup1>
80104947:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010494a:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104951:	81 7d f4 b4 4b 11 80 	cmpl   $0x80114bb4,-0xc(%ebp)
80104958:	72 b8                	jb     80104912 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
8010495a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104960:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104967:	e8 dc 01 00 00       	call   80104b48 <sched>
  panic("zombie exit");
8010496c:	83 ec 0c             	sub    $0xc,%esp
8010496f:	68 d9 8a 10 80       	push   $0x80108ad9
80104974:	e8 ed bb ff ff       	call   80100566 <panic>

80104979 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104979:	55                   	push   %ebp
8010497a:	89 e5                	mov    %esp,%ebp
8010497c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
8010497f:	83 ec 0c             	sub    $0xc,%esp
80104982:	68 80 29 11 80       	push   $0x80112980
80104987:	e8 21 07 00 00       	call   801050ad <acquire>
8010498c:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
8010498f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104996:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
8010499d:	e9 a9 00 00 00       	jmp    80104a4b <wait+0xd2>
      if(p->parent != proc)
801049a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a5:	8b 50 14             	mov    0x14(%eax),%edx
801049a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ae:	39 c2                	cmp    %eax,%edx
801049b0:	0f 85 8d 00 00 00    	jne    80104a43 <wait+0xca>
        continue;
      havekids = 1;
801049b6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801049bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c0:	8b 40 0c             	mov    0xc(%eax),%eax
801049c3:	83 f8 05             	cmp    $0x5,%eax
801049c6:	75 7c                	jne    80104a44 <wait+0xcb>
        // Found one.
        pid = p->pid;
801049c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049cb:	8b 40 10             	mov    0x10(%eax),%eax
801049ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801049d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d4:	8b 40 08             	mov    0x8(%eax),%eax
801049d7:	83 ec 0c             	sub    $0xc,%esp
801049da:	50                   	push   %eax
801049db:	e8 48 e1 ff ff       	call   80102b28 <kfree>
801049e0:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801049e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801049ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f0:	8b 40 04             	mov    0x4(%eax),%eax
801049f3:	83 ec 0c             	sub    $0xc,%esp
801049f6:	50                   	push   %eax
801049f7:	e8 d9 3a 00 00       	call   801084d5 <freevm>
801049fc:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
801049ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a02:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a16:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a20:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a27:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104a2e:	83 ec 0c             	sub    $0xc,%esp
80104a31:	68 80 29 11 80       	push   $0x80112980
80104a36:	e8 d9 06 00 00       	call   80105114 <release>
80104a3b:	83 c4 10             	add    $0x10,%esp
        return pid;
80104a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a41:	eb 5b                	jmp    80104a9e <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104a43:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a44:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104a4b:	81 7d f4 b4 4b 11 80 	cmpl   $0x80114bb4,-0xc(%ebp)
80104a52:	0f 82 4a ff ff ff    	jb     801049a2 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104a58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a5c:	74 0d                	je     80104a6b <wait+0xf2>
80104a5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a64:	8b 40 24             	mov    0x24(%eax),%eax
80104a67:	85 c0                	test   %eax,%eax
80104a69:	74 17                	je     80104a82 <wait+0x109>
      release(&ptable.lock);
80104a6b:	83 ec 0c             	sub    $0xc,%esp
80104a6e:	68 80 29 11 80       	push   $0x80112980
80104a73:	e8 9c 06 00 00       	call   80105114 <release>
80104a78:	83 c4 10             	add    $0x10,%esp
      return -1;
80104a7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a80:	eb 1c                	jmp    80104a9e <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104a82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a88:	83 ec 08             	sub    $0x8,%esp
80104a8b:	68 80 29 11 80       	push   $0x80112980
80104a90:	50                   	push   %eax
80104a91:	e8 da 01 00 00       	call   80104c70 <sleep>
80104a96:	83 c4 10             	add    $0x10,%esp
  }
80104a99:	e9 f1 fe ff ff       	jmp    8010498f <wait+0x16>
}
80104a9e:	c9                   	leave  
80104a9f:	c3                   	ret    

80104aa0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104aa6:	e8 ef f8 ff ff       	call   8010439a <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104aab:	83 ec 0c             	sub    $0xc,%esp
80104aae:	68 80 29 11 80       	push   $0x80112980
80104ab3:	e8 f5 05 00 00       	call   801050ad <acquire>
80104ab8:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104abb:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
80104ac2:	eb 66                	jmp    80104b2a <scheduler+0x8a>
      if(p->state != RUNNABLE)
80104ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac7:	8b 40 0c             	mov    0xc(%eax),%eax
80104aca:	83 f8 03             	cmp    $0x3,%eax
80104acd:	75 53                	jne    80104b22 <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad2:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104ad8:	83 ec 0c             	sub    $0xc,%esp
80104adb:	ff 75 f4             	pushl  -0xc(%ebp)
80104ade:	e8 43 35 00 00       	call   80108026 <switchuvm>
80104ae3:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae9:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104af0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af6:	8b 40 1c             	mov    0x1c(%eax),%eax
80104af9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104b00:	83 c2 04             	add    $0x4,%edx
80104b03:	83 ec 08             	sub    $0x8,%esp
80104b06:	50                   	push   %eax
80104b07:	52                   	push   %edx
80104b08:	e8 77 0a 00 00       	call   80105584 <swtch>
80104b0d:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104b10:	e8 f4 34 00 00       	call   80108009 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104b15:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104b1c:	00 00 00 00 
80104b20:	eb 01                	jmp    80104b23 <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104b22:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b23:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104b2a:	81 7d f4 b4 4b 11 80 	cmpl   $0x80114bb4,-0xc(%ebp)
80104b31:	72 91                	jb     80104ac4 <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104b33:	83 ec 0c             	sub    $0xc,%esp
80104b36:	68 80 29 11 80       	push   $0x80112980
80104b3b:	e8 d4 05 00 00       	call   80105114 <release>
80104b40:	83 c4 10             	add    $0x10,%esp

  }
80104b43:	e9 5e ff ff ff       	jmp    80104aa6 <scheduler+0x6>

80104b48 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104b48:	55                   	push   %ebp
80104b49:	89 e5                	mov    %esp,%ebp
80104b4b:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104b4e:	83 ec 0c             	sub    $0xc,%esp
80104b51:	68 80 29 11 80       	push   $0x80112980
80104b56:	e8 85 06 00 00       	call   801051e0 <holding>
80104b5b:	83 c4 10             	add    $0x10,%esp
80104b5e:	85 c0                	test   %eax,%eax
80104b60:	75 0d                	jne    80104b6f <sched+0x27>
    panic("sched ptable.lock");
80104b62:	83 ec 0c             	sub    $0xc,%esp
80104b65:	68 e5 8a 10 80       	push   $0x80108ae5
80104b6a:	e8 f7 b9 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104b6f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b75:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104b7b:	83 f8 01             	cmp    $0x1,%eax
80104b7e:	74 0d                	je     80104b8d <sched+0x45>
    panic("sched locks");
80104b80:	83 ec 0c             	sub    $0xc,%esp
80104b83:	68 f7 8a 10 80       	push   $0x80108af7
80104b88:	e8 d9 b9 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104b8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b93:	8b 40 0c             	mov    0xc(%eax),%eax
80104b96:	83 f8 04             	cmp    $0x4,%eax
80104b99:	75 0d                	jne    80104ba8 <sched+0x60>
    panic("sched running");
80104b9b:	83 ec 0c             	sub    $0xc,%esp
80104b9e:	68 03 8b 10 80       	push   $0x80108b03
80104ba3:	e8 be b9 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104ba8:	e8 dd f7 ff ff       	call   8010438a <readeflags>
80104bad:	25 00 02 00 00       	and    $0x200,%eax
80104bb2:	85 c0                	test   %eax,%eax
80104bb4:	74 0d                	je     80104bc3 <sched+0x7b>
    panic("sched interruptible");
80104bb6:	83 ec 0c             	sub    $0xc,%esp
80104bb9:	68 11 8b 10 80       	push   $0x80108b11
80104bbe:	e8 a3 b9 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104bc3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bc9:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104bd2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bd8:	8b 40 04             	mov    0x4(%eax),%eax
80104bdb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104be2:	83 c2 1c             	add    $0x1c,%edx
80104be5:	83 ec 08             	sub    $0x8,%esp
80104be8:	50                   	push   %eax
80104be9:	52                   	push   %edx
80104bea:	e8 95 09 00 00       	call   80105584 <swtch>
80104bef:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104bf2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bfb:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104c01:	90                   	nop
80104c02:	c9                   	leave  
80104c03:	c3                   	ret    

80104c04 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104c04:	55                   	push   %ebp
80104c05:	89 e5                	mov    %esp,%ebp
80104c07:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104c0a:	83 ec 0c             	sub    $0xc,%esp
80104c0d:	68 80 29 11 80       	push   $0x80112980
80104c12:	e8 96 04 00 00       	call   801050ad <acquire>
80104c17:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104c1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c20:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104c27:	e8 1c ff ff ff       	call   80104b48 <sched>
  release(&ptable.lock);
80104c2c:	83 ec 0c             	sub    $0xc,%esp
80104c2f:	68 80 29 11 80       	push   $0x80112980
80104c34:	e8 db 04 00 00       	call   80105114 <release>
80104c39:	83 c4 10             	add    $0x10,%esp
}
80104c3c:	90                   	nop
80104c3d:	c9                   	leave  
80104c3e:	c3                   	ret    

80104c3f <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c3f:	55                   	push   %ebp
80104c40:	89 e5                	mov    %esp,%ebp
80104c42:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104c45:	83 ec 0c             	sub    $0xc,%esp
80104c48:	68 80 29 11 80       	push   $0x80112980
80104c4d:	e8 c2 04 00 00       	call   80105114 <release>
80104c52:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104c55:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104c5a:	85 c0                	test   %eax,%eax
80104c5c:	74 0f                	je     80104c6d <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104c5e:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104c65:	00 00 00 
    initlog();
80104c68:	e8 21 e6 ff ff       	call   8010328e <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104c6d:	90                   	nop
80104c6e:	c9                   	leave  
80104c6f:	c3                   	ret    

80104c70 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104c76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c7c:	85 c0                	test   %eax,%eax
80104c7e:	75 0d                	jne    80104c8d <sleep+0x1d>
    panic("sleep");
80104c80:	83 ec 0c             	sub    $0xc,%esp
80104c83:	68 25 8b 10 80       	push   $0x80108b25
80104c88:	e8 d9 b8 ff ff       	call   80100566 <panic>

  if(lk == 0)
80104c8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104c91:	75 0d                	jne    80104ca0 <sleep+0x30>
    panic("sleep without lk");
80104c93:	83 ec 0c             	sub    $0xc,%esp
80104c96:	68 2b 8b 10 80       	push   $0x80108b2b
80104c9b:	e8 c6 b8 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ca0:	81 7d 0c 80 29 11 80 	cmpl   $0x80112980,0xc(%ebp)
80104ca7:	74 1e                	je     80104cc7 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ca9:	83 ec 0c             	sub    $0xc,%esp
80104cac:	68 80 29 11 80       	push   $0x80112980
80104cb1:	e8 f7 03 00 00       	call   801050ad <acquire>
80104cb6:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104cb9:	83 ec 0c             	sub    $0xc,%esp
80104cbc:	ff 75 0c             	pushl  0xc(%ebp)
80104cbf:	e8 50 04 00 00       	call   80105114 <release>
80104cc4:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104cc7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ccd:	8b 55 08             	mov    0x8(%ebp),%edx
80104cd0:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104cd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cd9:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104ce0:	e8 63 fe ff ff       	call   80104b48 <sched>

  // Tidy up.
  proc->chan = 0;
80104ce5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ceb:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104cf2:	81 7d 0c 80 29 11 80 	cmpl   $0x80112980,0xc(%ebp)
80104cf9:	74 1e                	je     80104d19 <sleep+0xa9>
    release(&ptable.lock);
80104cfb:	83 ec 0c             	sub    $0xc,%esp
80104cfe:	68 80 29 11 80       	push   $0x80112980
80104d03:	e8 0c 04 00 00       	call   80105114 <release>
80104d08:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104d0b:	83 ec 0c             	sub    $0xc,%esp
80104d0e:	ff 75 0c             	pushl  0xc(%ebp)
80104d11:	e8 97 03 00 00       	call   801050ad <acquire>
80104d16:	83 c4 10             	add    $0x10,%esp
  }
}
80104d19:	90                   	nop
80104d1a:	c9                   	leave  
80104d1b:	c3                   	ret    

80104d1c <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104d1c:	55                   	push   %ebp
80104d1d:	89 e5                	mov    %esp,%ebp
80104d1f:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d22:	c7 45 fc b4 29 11 80 	movl   $0x801129b4,-0x4(%ebp)
80104d29:	eb 27                	jmp    80104d52 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d2e:	8b 40 0c             	mov    0xc(%eax),%eax
80104d31:	83 f8 02             	cmp    $0x2,%eax
80104d34:	75 15                	jne    80104d4b <wakeup1+0x2f>
80104d36:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d39:	8b 40 20             	mov    0x20(%eax),%eax
80104d3c:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d3f:	75 0a                	jne    80104d4b <wakeup1+0x2f>
      p->state = RUNNABLE;
80104d41:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d44:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d4b:	81 45 fc 88 00 00 00 	addl   $0x88,-0x4(%ebp)
80104d52:	81 7d fc b4 4b 11 80 	cmpl   $0x80114bb4,-0x4(%ebp)
80104d59:	72 d0                	jb     80104d2b <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104d5b:	90                   	nop
80104d5c:	c9                   	leave  
80104d5d:	c3                   	ret    

80104d5e <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d5e:	55                   	push   %ebp
80104d5f:	89 e5                	mov    %esp,%ebp
80104d61:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104d64:	83 ec 0c             	sub    $0xc,%esp
80104d67:	68 80 29 11 80       	push   $0x80112980
80104d6c:	e8 3c 03 00 00       	call   801050ad <acquire>
80104d71:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104d74:	83 ec 0c             	sub    $0xc,%esp
80104d77:	ff 75 08             	pushl  0x8(%ebp)
80104d7a:	e8 9d ff ff ff       	call   80104d1c <wakeup1>
80104d7f:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104d82:	83 ec 0c             	sub    $0xc,%esp
80104d85:	68 80 29 11 80       	push   $0x80112980
80104d8a:	e8 85 03 00 00       	call   80105114 <release>
80104d8f:	83 c4 10             	add    $0x10,%esp
}
80104d92:	90                   	nop
80104d93:	c9                   	leave  
80104d94:	c3                   	ret    

80104d95 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d95:	55                   	push   %ebp
80104d96:	89 e5                	mov    %esp,%ebp
80104d98:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104d9b:	83 ec 0c             	sub    $0xc,%esp
80104d9e:	68 80 29 11 80       	push   $0x80112980
80104da3:	e8 05 03 00 00       	call   801050ad <acquire>
80104da8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dab:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
80104db2:	eb 48                	jmp    80104dfc <kill+0x67>
    if(p->pid == pid){
80104db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db7:	8b 40 10             	mov    0x10(%eax),%eax
80104dba:	3b 45 08             	cmp    0x8(%ebp),%eax
80104dbd:	75 36                	jne    80104df5 <kill+0x60>
      p->killed = 1;
80104dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dcc:	8b 40 0c             	mov    0xc(%eax),%eax
80104dcf:	83 f8 02             	cmp    $0x2,%eax
80104dd2:	75 0a                	jne    80104dde <kill+0x49>
        p->state = RUNNABLE;
80104dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104dde:	83 ec 0c             	sub    $0xc,%esp
80104de1:	68 80 29 11 80       	push   $0x80112980
80104de6:	e8 29 03 00 00       	call   80105114 <release>
80104deb:	83 c4 10             	add    $0x10,%esp
      return 0;
80104dee:	b8 00 00 00 00       	mov    $0x0,%eax
80104df3:	eb 25                	jmp    80104e1a <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104df5:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104dfc:	81 7d f4 b4 4b 11 80 	cmpl   $0x80114bb4,-0xc(%ebp)
80104e03:	72 af                	jb     80104db4 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104e05:	83 ec 0c             	sub    $0xc,%esp
80104e08:	68 80 29 11 80       	push   $0x80112980
80104e0d:	e8 02 03 00 00       	call   80105114 <release>
80104e12:	83 c4 10             	add    $0x10,%esp
  return -1;
80104e15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e1a:	c9                   	leave  
80104e1b:	c3                   	ret    

80104e1c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104e1c:	55                   	push   %ebp
80104e1d:	89 e5                	mov    %esp,%ebp
80104e1f:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e22:	c7 45 f0 b4 29 11 80 	movl   $0x801129b4,-0x10(%ebp)
80104e29:	e9 da 00 00 00       	jmp    80104f08 <procdump+0xec>
    if(p->state == UNUSED)
80104e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e31:	8b 40 0c             	mov    0xc(%eax),%eax
80104e34:	85 c0                	test   %eax,%eax
80104e36:	0f 84 c4 00 00 00    	je     80104f00 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e3f:	8b 40 0c             	mov    0xc(%eax),%eax
80104e42:	83 f8 05             	cmp    $0x5,%eax
80104e45:	77 23                	ja     80104e6a <procdump+0x4e>
80104e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e4a:	8b 40 0c             	mov    0xc(%eax),%eax
80104e4d:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104e54:	85 c0                	test   %eax,%eax
80104e56:	74 12                	je     80104e6a <procdump+0x4e>
      state = states[p->state];
80104e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e5b:	8b 40 0c             	mov    0xc(%eax),%eax
80104e5e:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104e65:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e68:	eb 07                	jmp    80104e71 <procdump+0x55>
    else
      state = "???";
80104e6a:	c7 45 ec 3c 8b 10 80 	movl   $0x80108b3c,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e74:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e7a:	8b 40 10             	mov    0x10(%eax),%eax
80104e7d:	52                   	push   %edx
80104e7e:	ff 75 ec             	pushl  -0x14(%ebp)
80104e81:	50                   	push   %eax
80104e82:	68 40 8b 10 80       	push   $0x80108b40
80104e87:	e8 3a b5 ff ff       	call   801003c6 <cprintf>
80104e8c:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e92:	8b 40 0c             	mov    0xc(%eax),%eax
80104e95:	83 f8 02             	cmp    $0x2,%eax
80104e98:	75 54                	jne    80104eee <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e9d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ea0:	8b 40 0c             	mov    0xc(%eax),%eax
80104ea3:	83 c0 08             	add    $0x8,%eax
80104ea6:	89 c2                	mov    %eax,%edx
80104ea8:	83 ec 08             	sub    $0x8,%esp
80104eab:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104eae:	50                   	push   %eax
80104eaf:	52                   	push   %edx
80104eb0:	e8 b1 02 00 00       	call   80105166 <getcallerpcs>
80104eb5:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104eb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104ebf:	eb 1c                	jmp    80104edd <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec4:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ec8:	83 ec 08             	sub    $0x8,%esp
80104ecb:	50                   	push   %eax
80104ecc:	68 49 8b 10 80       	push   $0x80108b49
80104ed1:	e8 f0 b4 ff ff       	call   801003c6 <cprintf>
80104ed6:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104ed9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104edd:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104ee1:	7f 0b                	jg     80104eee <procdump+0xd2>
80104ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee6:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104eea:	85 c0                	test   %eax,%eax
80104eec:	75 d3                	jne    80104ec1 <procdump+0xa5>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104eee:	83 ec 0c             	sub    $0xc,%esp
80104ef1:	68 4d 8b 10 80       	push   $0x80108b4d
80104ef6:	e8 cb b4 ff ff       	call   801003c6 <cprintf>
80104efb:	83 c4 10             	add    $0x10,%esp
80104efe:	eb 01                	jmp    80104f01 <procdump+0xe5>
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104f00:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f01:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
80104f08:	81 7d f0 b4 4b 11 80 	cmpl   $0x80114bb4,-0x10(%ebp)
80104f0f:	0f 82 19 ff ff ff    	jb     80104e2e <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104f15:	90                   	nop
80104f16:	c9                   	leave  
80104f17:	c3                   	ret    

80104f18 <signal_deliver>:

void signal_deliver(int signum)
{
80104f18:	55                   	push   %ebp
80104f19:	89 e5                	mov    %esp,%ebp
80104f1b:	83 ec 10             	sub    $0x10,%esp
	uint old_eip = proc->tf->eip;
80104f1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f24:	8b 40 18             	mov    0x18(%eax),%eax
80104f27:	8b 40 38             	mov    0x38(%eax),%eax
80104f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)

	*((uint*)(proc->tf->esp - 4))  = (uint) old_eip;		// real return address
80104f2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f33:	8b 40 18             	mov    0x18(%eax),%eax
80104f36:	8b 40 44             	mov    0x44(%eax),%eax
80104f39:	83 e8 04             	sub    $0x4,%eax
80104f3c:	89 c2                	mov    %eax,%edx
80104f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f41:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 8))  = proc->tf->eax;			// eax
80104f43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f49:	8b 40 18             	mov    0x18(%eax),%eax
80104f4c:	8b 40 44             	mov    0x44(%eax),%eax
80104f4f:	83 e8 08             	sub    $0x8,%eax
80104f52:	89 c2                	mov    %eax,%edx
80104f54:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f5a:	8b 40 18             	mov    0x18(%eax),%eax
80104f5d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f60:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 12)) = proc->tf->ecx;			// ecx
80104f62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f68:	8b 40 18             	mov    0x18(%eax),%eax
80104f6b:	8b 40 44             	mov    0x44(%eax),%eax
80104f6e:	83 e8 0c             	sub    $0xc,%eax
80104f71:	89 c2                	mov    %eax,%edx
80104f73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f79:	8b 40 18             	mov    0x18(%eax),%eax
80104f7c:	8b 40 18             	mov    0x18(%eax),%eax
80104f7f:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 16)) = proc->tf->edx;			// edx
80104f81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f87:	8b 40 18             	mov    0x18(%eax),%eax
80104f8a:	8b 40 44             	mov    0x44(%eax),%eax
80104f8d:	83 e8 10             	sub    $0x10,%eax
80104f90:	89 c2                	mov    %eax,%edx
80104f92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f98:	8b 40 18             	mov    0x18(%eax),%eax
80104f9b:	8b 40 14             	mov    0x14(%eax),%eax
80104f9e:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 20)) = (uint) signum;			// signal number
80104fa0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fa6:	8b 40 18             	mov    0x18(%eax),%eax
80104fa9:	8b 40 44             	mov    0x44(%eax),%eax
80104fac:	83 e8 14             	sub    $0x14,%eax
80104faf:	89 c2                	mov    %eax,%edx
80104fb1:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb4:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 24)) = proc->restorer_addr;	// address of restorer
80104fb6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fbc:	8b 40 18             	mov    0x18(%eax),%eax
80104fbf:	8b 40 44             	mov    0x44(%eax),%eax
80104fc2:	83 e8 18             	sub    $0x18,%eax
80104fc5:	89 c2                	mov    %eax,%edx
80104fc7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fcd:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104fd3:	89 02                	mov    %eax,(%edx)
	proc->tf->esp -= 24;
80104fd5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fdb:	8b 40 18             	mov    0x18(%eax),%eax
80104fde:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104fe5:	8b 52 18             	mov    0x18(%edx),%edx
80104fe8:	8b 52 44             	mov    0x44(%edx),%edx
80104feb:	83 ea 18             	sub    $0x18,%edx
80104fee:	89 50 44             	mov    %edx,0x44(%eax)
	proc->tf->eip = (uint) proc->handlers[signum];
80104ff1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ff7:	8b 40 18             	mov    0x18(%eax),%eax
80104ffa:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105001:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105004:	83 c1 1c             	add    $0x1c,%ecx
80105007:	8b 54 8a 0c          	mov    0xc(%edx,%ecx,4),%edx
8010500b:	89 50 38             	mov    %edx,0x38(%eax)
}
8010500e:	90                   	nop
8010500f:	c9                   	leave  
80105010:	c3                   	ret    

80105011 <signal_register_handler>:

sighandler_t signal_register_handler(int signum, sighandler_t handler)
{
80105011:	55                   	push   %ebp
80105012:	89 e5                	mov    %esp,%ebp
80105014:	83 ec 10             	sub    $0x10,%esp
	if (!proc)
80105017:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010501d:	85 c0                	test   %eax,%eax
8010501f:	75 07                	jne    80105028 <signal_register_handler+0x17>
		return (sighandler_t) -1;
80105021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105026:	eb 29                	jmp    80105051 <signal_register_handler+0x40>

	sighandler_t previous = proc->handlers[signum];
80105028:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010502e:	8b 55 08             	mov    0x8(%ebp),%edx
80105031:	83 c2 1c             	add    $0x1c,%edx
80105034:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105038:	89 45 fc             	mov    %eax,-0x4(%ebp)

	proc->handlers[signum] = handler;
8010503b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105041:	8b 55 08             	mov    0x8(%ebp),%edx
80105044:	8d 4a 1c             	lea    0x1c(%edx),%ecx
80105047:	8b 55 0c             	mov    0xc(%ebp),%edx
8010504a:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)

	return previous;
8010504e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105051:	c9                   	leave  
80105052:	c3                   	ret    

80105053 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105053:	55                   	push   %ebp
80105054:	89 e5                	mov    %esp,%ebp
80105056:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105059:	9c                   	pushf  
8010505a:	58                   	pop    %eax
8010505b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010505e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105061:	c9                   	leave  
80105062:	c3                   	ret    

80105063 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105063:	55                   	push   %ebp
80105064:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105066:	fa                   	cli    
}
80105067:	90                   	nop
80105068:	5d                   	pop    %ebp
80105069:	c3                   	ret    

8010506a <sti>:

static inline void
sti(void)
{
8010506a:	55                   	push   %ebp
8010506b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010506d:	fb                   	sti    
}
8010506e:	90                   	nop
8010506f:	5d                   	pop    %ebp
80105070:	c3                   	ret    

80105071 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105071:	55                   	push   %ebp
80105072:	89 e5                	mov    %esp,%ebp
80105074:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105077:	8b 55 08             	mov    0x8(%ebp),%edx
8010507a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010507d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105080:	f0 87 02             	lock xchg %eax,(%edx)
80105083:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105086:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105089:	c9                   	leave  
8010508a:	c3                   	ret    

8010508b <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010508b:	55                   	push   %ebp
8010508c:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010508e:	8b 45 08             	mov    0x8(%ebp),%eax
80105091:	8b 55 0c             	mov    0xc(%ebp),%edx
80105094:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105097:	8b 45 08             	mov    0x8(%ebp),%eax
8010509a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801050a0:	8b 45 08             	mov    0x8(%ebp),%eax
801050a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801050aa:	90                   	nop
801050ab:	5d                   	pop    %ebp
801050ac:	c3                   	ret    

801050ad <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801050ad:	55                   	push   %ebp
801050ae:	89 e5                	mov    %esp,%ebp
801050b0:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801050b3:	e8 52 01 00 00       	call   8010520a <pushcli>
  if(holding(lk))
801050b8:	8b 45 08             	mov    0x8(%ebp),%eax
801050bb:	83 ec 0c             	sub    $0xc,%esp
801050be:	50                   	push   %eax
801050bf:	e8 1c 01 00 00       	call   801051e0 <holding>
801050c4:	83 c4 10             	add    $0x10,%esp
801050c7:	85 c0                	test   %eax,%eax
801050c9:	74 0d                	je     801050d8 <acquire+0x2b>
    panic("acquire");
801050cb:	83 ec 0c             	sub    $0xc,%esp
801050ce:	68 79 8b 10 80       	push   $0x80108b79
801050d3:	e8 8e b4 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801050d8:	90                   	nop
801050d9:	8b 45 08             	mov    0x8(%ebp),%eax
801050dc:	83 ec 08             	sub    $0x8,%esp
801050df:	6a 01                	push   $0x1
801050e1:	50                   	push   %eax
801050e2:	e8 8a ff ff ff       	call   80105071 <xchg>
801050e7:	83 c4 10             	add    $0x10,%esp
801050ea:	85 c0                	test   %eax,%eax
801050ec:	75 eb                	jne    801050d9 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801050ee:	8b 45 08             	mov    0x8(%ebp),%eax
801050f1:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801050f8:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801050fb:	8b 45 08             	mov    0x8(%ebp),%eax
801050fe:	83 c0 0c             	add    $0xc,%eax
80105101:	83 ec 08             	sub    $0x8,%esp
80105104:	50                   	push   %eax
80105105:	8d 45 08             	lea    0x8(%ebp),%eax
80105108:	50                   	push   %eax
80105109:	e8 58 00 00 00       	call   80105166 <getcallerpcs>
8010510e:	83 c4 10             	add    $0x10,%esp
}
80105111:	90                   	nop
80105112:	c9                   	leave  
80105113:	c3                   	ret    

80105114 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105114:	55                   	push   %ebp
80105115:	89 e5                	mov    %esp,%ebp
80105117:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010511a:	83 ec 0c             	sub    $0xc,%esp
8010511d:	ff 75 08             	pushl  0x8(%ebp)
80105120:	e8 bb 00 00 00       	call   801051e0 <holding>
80105125:	83 c4 10             	add    $0x10,%esp
80105128:	85 c0                	test   %eax,%eax
8010512a:	75 0d                	jne    80105139 <release+0x25>
    panic("release");
8010512c:	83 ec 0c             	sub    $0xc,%esp
8010512f:	68 81 8b 10 80       	push   $0x80108b81
80105134:	e8 2d b4 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105139:	8b 45 08             	mov    0x8(%ebp),%eax
8010513c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105143:	8b 45 08             	mov    0x8(%ebp),%eax
80105146:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010514d:	8b 45 08             	mov    0x8(%ebp),%eax
80105150:	83 ec 08             	sub    $0x8,%esp
80105153:	6a 00                	push   $0x0
80105155:	50                   	push   %eax
80105156:	e8 16 ff ff ff       	call   80105071 <xchg>
8010515b:	83 c4 10             	add    $0x10,%esp

  popcli();
8010515e:	e8 ec 00 00 00       	call   8010524f <popcli>
}
80105163:	90                   	nop
80105164:	c9                   	leave  
80105165:	c3                   	ret    

80105166 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105166:	55                   	push   %ebp
80105167:	89 e5                	mov    %esp,%ebp
80105169:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010516c:	8b 45 08             	mov    0x8(%ebp),%eax
8010516f:	83 e8 08             	sub    $0x8,%eax
80105172:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105175:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010517c:	eb 38                	jmp    801051b6 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010517e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105182:	74 53                	je     801051d7 <getcallerpcs+0x71>
80105184:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010518b:	76 4a                	jbe    801051d7 <getcallerpcs+0x71>
8010518d:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105191:	74 44                	je     801051d7 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105193:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105196:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010519d:	8b 45 0c             	mov    0xc(%ebp),%eax
801051a0:	01 c2                	add    %eax,%edx
801051a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051a5:	8b 40 04             	mov    0x4(%eax),%eax
801051a8:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801051aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051ad:	8b 00                	mov    (%eax),%eax
801051af:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801051b2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801051b6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801051ba:	7e c2                	jle    8010517e <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801051bc:	eb 19                	jmp    801051d7 <getcallerpcs+0x71>
    pcs[i] = 0;
801051be:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801051c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801051cb:	01 d0                	add    %edx,%eax
801051cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801051d3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801051d7:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801051db:	7e e1                	jle    801051be <getcallerpcs+0x58>
    pcs[i] = 0;
}
801051dd:	90                   	nop
801051de:	c9                   	leave  
801051df:	c3                   	ret    

801051e0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801051e3:	8b 45 08             	mov    0x8(%ebp),%eax
801051e6:	8b 00                	mov    (%eax),%eax
801051e8:	85 c0                	test   %eax,%eax
801051ea:	74 17                	je     80105203 <holding+0x23>
801051ec:	8b 45 08             	mov    0x8(%ebp),%eax
801051ef:	8b 50 08             	mov    0x8(%eax),%edx
801051f2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051f8:	39 c2                	cmp    %eax,%edx
801051fa:	75 07                	jne    80105203 <holding+0x23>
801051fc:	b8 01 00 00 00       	mov    $0x1,%eax
80105201:	eb 05                	jmp    80105208 <holding+0x28>
80105203:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105208:	5d                   	pop    %ebp
80105209:	c3                   	ret    

8010520a <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010520a:	55                   	push   %ebp
8010520b:	89 e5                	mov    %esp,%ebp
8010520d:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105210:	e8 3e fe ff ff       	call   80105053 <readeflags>
80105215:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105218:	e8 46 fe ff ff       	call   80105063 <cli>
  if(cpu->ncli++ == 0)
8010521d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105224:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010522a:	8d 48 01             	lea    0x1(%eax),%ecx
8010522d:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105233:	85 c0                	test   %eax,%eax
80105235:	75 15                	jne    8010524c <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105237:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010523d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105240:	81 e2 00 02 00 00    	and    $0x200,%edx
80105246:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010524c:	90                   	nop
8010524d:	c9                   	leave  
8010524e:	c3                   	ret    

8010524f <popcli>:

void
popcli(void)
{
8010524f:	55                   	push   %ebp
80105250:	89 e5                	mov    %esp,%ebp
80105252:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105255:	e8 f9 fd ff ff       	call   80105053 <readeflags>
8010525a:	25 00 02 00 00       	and    $0x200,%eax
8010525f:	85 c0                	test   %eax,%eax
80105261:	74 0d                	je     80105270 <popcli+0x21>
    panic("popcli - interruptible");
80105263:	83 ec 0c             	sub    $0xc,%esp
80105266:	68 89 8b 10 80       	push   $0x80108b89
8010526b:	e8 f6 b2 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80105270:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105276:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010527c:	83 ea 01             	sub    $0x1,%edx
8010527f:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105285:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010528b:	85 c0                	test   %eax,%eax
8010528d:	79 0d                	jns    8010529c <popcli+0x4d>
    panic("popcli");
8010528f:	83 ec 0c             	sub    $0xc,%esp
80105292:	68 a0 8b 10 80       	push   $0x80108ba0
80105297:	e8 ca b2 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010529c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052a2:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801052a8:	85 c0                	test   %eax,%eax
801052aa:	75 15                	jne    801052c1 <popcli+0x72>
801052ac:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052b2:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801052b8:	85 c0                	test   %eax,%eax
801052ba:	74 05                	je     801052c1 <popcli+0x72>
    sti();
801052bc:	e8 a9 fd ff ff       	call   8010506a <sti>
}
801052c1:	90                   	nop
801052c2:	c9                   	leave  
801052c3:	c3                   	ret    

801052c4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801052c4:	55                   	push   %ebp
801052c5:	89 e5                	mov    %esp,%ebp
801052c7:	57                   	push   %edi
801052c8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801052c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052cc:	8b 55 10             	mov    0x10(%ebp),%edx
801052cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801052d2:	89 cb                	mov    %ecx,%ebx
801052d4:	89 df                	mov    %ebx,%edi
801052d6:	89 d1                	mov    %edx,%ecx
801052d8:	fc                   	cld    
801052d9:	f3 aa                	rep stos %al,%es:(%edi)
801052db:	89 ca                	mov    %ecx,%edx
801052dd:	89 fb                	mov    %edi,%ebx
801052df:	89 5d 08             	mov    %ebx,0x8(%ebp)
801052e2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801052e5:	90                   	nop
801052e6:	5b                   	pop    %ebx
801052e7:	5f                   	pop    %edi
801052e8:	5d                   	pop    %ebp
801052e9:	c3                   	ret    

801052ea <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801052ea:	55                   	push   %ebp
801052eb:	89 e5                	mov    %esp,%ebp
801052ed:	57                   	push   %edi
801052ee:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801052ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052f2:	8b 55 10             	mov    0x10(%ebp),%edx
801052f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801052f8:	89 cb                	mov    %ecx,%ebx
801052fa:	89 df                	mov    %ebx,%edi
801052fc:	89 d1                	mov    %edx,%ecx
801052fe:	fc                   	cld    
801052ff:	f3 ab                	rep stos %eax,%es:(%edi)
80105301:	89 ca                	mov    %ecx,%edx
80105303:	89 fb                	mov    %edi,%ebx
80105305:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105308:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010530b:	90                   	nop
8010530c:	5b                   	pop    %ebx
8010530d:	5f                   	pop    %edi
8010530e:	5d                   	pop    %ebp
8010530f:	c3                   	ret    

80105310 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105313:	8b 45 08             	mov    0x8(%ebp),%eax
80105316:	83 e0 03             	and    $0x3,%eax
80105319:	85 c0                	test   %eax,%eax
8010531b:	75 43                	jne    80105360 <memset+0x50>
8010531d:	8b 45 10             	mov    0x10(%ebp),%eax
80105320:	83 e0 03             	and    $0x3,%eax
80105323:	85 c0                	test   %eax,%eax
80105325:	75 39                	jne    80105360 <memset+0x50>
    c &= 0xFF;
80105327:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010532e:	8b 45 10             	mov    0x10(%ebp),%eax
80105331:	c1 e8 02             	shr    $0x2,%eax
80105334:	89 c1                	mov    %eax,%ecx
80105336:	8b 45 0c             	mov    0xc(%ebp),%eax
80105339:	c1 e0 18             	shl    $0x18,%eax
8010533c:	89 c2                	mov    %eax,%edx
8010533e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105341:	c1 e0 10             	shl    $0x10,%eax
80105344:	09 c2                	or     %eax,%edx
80105346:	8b 45 0c             	mov    0xc(%ebp),%eax
80105349:	c1 e0 08             	shl    $0x8,%eax
8010534c:	09 d0                	or     %edx,%eax
8010534e:	0b 45 0c             	or     0xc(%ebp),%eax
80105351:	51                   	push   %ecx
80105352:	50                   	push   %eax
80105353:	ff 75 08             	pushl  0x8(%ebp)
80105356:	e8 8f ff ff ff       	call   801052ea <stosl>
8010535b:	83 c4 0c             	add    $0xc,%esp
8010535e:	eb 12                	jmp    80105372 <memset+0x62>
  } else
    stosb(dst, c, n);
80105360:	8b 45 10             	mov    0x10(%ebp),%eax
80105363:	50                   	push   %eax
80105364:	ff 75 0c             	pushl  0xc(%ebp)
80105367:	ff 75 08             	pushl  0x8(%ebp)
8010536a:	e8 55 ff ff ff       	call   801052c4 <stosb>
8010536f:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105372:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105375:	c9                   	leave  
80105376:	c3                   	ret    

80105377 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105377:	55                   	push   %ebp
80105378:	89 e5                	mov    %esp,%ebp
8010537a:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010537d:	8b 45 08             	mov    0x8(%ebp),%eax
80105380:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105383:	8b 45 0c             	mov    0xc(%ebp),%eax
80105386:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105389:	eb 30                	jmp    801053bb <memcmp+0x44>
    if(*s1 != *s2)
8010538b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010538e:	0f b6 10             	movzbl (%eax),%edx
80105391:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105394:	0f b6 00             	movzbl (%eax),%eax
80105397:	38 c2                	cmp    %al,%dl
80105399:	74 18                	je     801053b3 <memcmp+0x3c>
      return *s1 - *s2;
8010539b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010539e:	0f b6 00             	movzbl (%eax),%eax
801053a1:	0f b6 d0             	movzbl %al,%edx
801053a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053a7:	0f b6 00             	movzbl (%eax),%eax
801053aa:	0f b6 c0             	movzbl %al,%eax
801053ad:	29 c2                	sub    %eax,%edx
801053af:	89 d0                	mov    %edx,%eax
801053b1:	eb 1a                	jmp    801053cd <memcmp+0x56>
    s1++, s2++;
801053b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801053b7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801053bb:	8b 45 10             	mov    0x10(%ebp),%eax
801053be:	8d 50 ff             	lea    -0x1(%eax),%edx
801053c1:	89 55 10             	mov    %edx,0x10(%ebp)
801053c4:	85 c0                	test   %eax,%eax
801053c6:	75 c3                	jne    8010538b <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801053c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053cd:	c9                   	leave  
801053ce:	c3                   	ret    

801053cf <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801053cf:	55                   	push   %ebp
801053d0:	89 e5                	mov    %esp,%ebp
801053d2:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801053d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801053d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801053db:	8b 45 08             	mov    0x8(%ebp),%eax
801053de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801053e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801053e7:	73 54                	jae    8010543d <memmove+0x6e>
801053e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053ec:	8b 45 10             	mov    0x10(%ebp),%eax
801053ef:	01 d0                	add    %edx,%eax
801053f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801053f4:	76 47                	jbe    8010543d <memmove+0x6e>
    s += n;
801053f6:	8b 45 10             	mov    0x10(%ebp),%eax
801053f9:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801053fc:	8b 45 10             	mov    0x10(%ebp),%eax
801053ff:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105402:	eb 13                	jmp    80105417 <memmove+0x48>
      *--d = *--s;
80105404:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105408:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010540c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010540f:	0f b6 10             	movzbl (%eax),%edx
80105412:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105415:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105417:	8b 45 10             	mov    0x10(%ebp),%eax
8010541a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010541d:	89 55 10             	mov    %edx,0x10(%ebp)
80105420:	85 c0                	test   %eax,%eax
80105422:	75 e0                	jne    80105404 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105424:	eb 24                	jmp    8010544a <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105426:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105429:	8d 50 01             	lea    0x1(%eax),%edx
8010542c:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010542f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105432:	8d 4a 01             	lea    0x1(%edx),%ecx
80105435:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105438:	0f b6 12             	movzbl (%edx),%edx
8010543b:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010543d:	8b 45 10             	mov    0x10(%ebp),%eax
80105440:	8d 50 ff             	lea    -0x1(%eax),%edx
80105443:	89 55 10             	mov    %edx,0x10(%ebp)
80105446:	85 c0                	test   %eax,%eax
80105448:	75 dc                	jne    80105426 <memmove+0x57>
      *d++ = *s++;

  return dst;
8010544a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010544d:	c9                   	leave  
8010544e:	c3                   	ret    

8010544f <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010544f:	55                   	push   %ebp
80105450:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105452:	ff 75 10             	pushl  0x10(%ebp)
80105455:	ff 75 0c             	pushl  0xc(%ebp)
80105458:	ff 75 08             	pushl  0x8(%ebp)
8010545b:	e8 6f ff ff ff       	call   801053cf <memmove>
80105460:	83 c4 0c             	add    $0xc,%esp
}
80105463:	c9                   	leave  
80105464:	c3                   	ret    

80105465 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105465:	55                   	push   %ebp
80105466:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105468:	eb 0c                	jmp    80105476 <strncmp+0x11>
    n--, p++, q++;
8010546a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010546e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105472:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105476:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010547a:	74 1a                	je     80105496 <strncmp+0x31>
8010547c:	8b 45 08             	mov    0x8(%ebp),%eax
8010547f:	0f b6 00             	movzbl (%eax),%eax
80105482:	84 c0                	test   %al,%al
80105484:	74 10                	je     80105496 <strncmp+0x31>
80105486:	8b 45 08             	mov    0x8(%ebp),%eax
80105489:	0f b6 10             	movzbl (%eax),%edx
8010548c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010548f:	0f b6 00             	movzbl (%eax),%eax
80105492:	38 c2                	cmp    %al,%dl
80105494:	74 d4                	je     8010546a <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105496:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010549a:	75 07                	jne    801054a3 <strncmp+0x3e>
    return 0;
8010549c:	b8 00 00 00 00       	mov    $0x0,%eax
801054a1:	eb 16                	jmp    801054b9 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801054a3:	8b 45 08             	mov    0x8(%ebp),%eax
801054a6:	0f b6 00             	movzbl (%eax),%eax
801054a9:	0f b6 d0             	movzbl %al,%edx
801054ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801054af:	0f b6 00             	movzbl (%eax),%eax
801054b2:	0f b6 c0             	movzbl %al,%eax
801054b5:	29 c2                	sub    %eax,%edx
801054b7:	89 d0                	mov    %edx,%eax
}
801054b9:	5d                   	pop    %ebp
801054ba:	c3                   	ret    

801054bb <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801054bb:	55                   	push   %ebp
801054bc:	89 e5                	mov    %esp,%ebp
801054be:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801054c1:	8b 45 08             	mov    0x8(%ebp),%eax
801054c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801054c7:	90                   	nop
801054c8:	8b 45 10             	mov    0x10(%ebp),%eax
801054cb:	8d 50 ff             	lea    -0x1(%eax),%edx
801054ce:	89 55 10             	mov    %edx,0x10(%ebp)
801054d1:	85 c0                	test   %eax,%eax
801054d3:	7e 2c                	jle    80105501 <strncpy+0x46>
801054d5:	8b 45 08             	mov    0x8(%ebp),%eax
801054d8:	8d 50 01             	lea    0x1(%eax),%edx
801054db:	89 55 08             	mov    %edx,0x8(%ebp)
801054de:	8b 55 0c             	mov    0xc(%ebp),%edx
801054e1:	8d 4a 01             	lea    0x1(%edx),%ecx
801054e4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801054e7:	0f b6 12             	movzbl (%edx),%edx
801054ea:	88 10                	mov    %dl,(%eax)
801054ec:	0f b6 00             	movzbl (%eax),%eax
801054ef:	84 c0                	test   %al,%al
801054f1:	75 d5                	jne    801054c8 <strncpy+0xd>
    ;
  while(n-- > 0)
801054f3:	eb 0c                	jmp    80105501 <strncpy+0x46>
    *s++ = 0;
801054f5:	8b 45 08             	mov    0x8(%ebp),%eax
801054f8:	8d 50 01             	lea    0x1(%eax),%edx
801054fb:	89 55 08             	mov    %edx,0x8(%ebp)
801054fe:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105501:	8b 45 10             	mov    0x10(%ebp),%eax
80105504:	8d 50 ff             	lea    -0x1(%eax),%edx
80105507:	89 55 10             	mov    %edx,0x10(%ebp)
8010550a:	85 c0                	test   %eax,%eax
8010550c:	7f e7                	jg     801054f5 <strncpy+0x3a>
    *s++ = 0;
  return os;
8010550e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105511:	c9                   	leave  
80105512:	c3                   	ret    

80105513 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105513:	55                   	push   %ebp
80105514:	89 e5                	mov    %esp,%ebp
80105516:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105519:	8b 45 08             	mov    0x8(%ebp),%eax
8010551c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010551f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105523:	7f 05                	jg     8010552a <safestrcpy+0x17>
    return os;
80105525:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105528:	eb 31                	jmp    8010555b <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010552a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010552e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105532:	7e 1e                	jle    80105552 <safestrcpy+0x3f>
80105534:	8b 45 08             	mov    0x8(%ebp),%eax
80105537:	8d 50 01             	lea    0x1(%eax),%edx
8010553a:	89 55 08             	mov    %edx,0x8(%ebp)
8010553d:	8b 55 0c             	mov    0xc(%ebp),%edx
80105540:	8d 4a 01             	lea    0x1(%edx),%ecx
80105543:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105546:	0f b6 12             	movzbl (%edx),%edx
80105549:	88 10                	mov    %dl,(%eax)
8010554b:	0f b6 00             	movzbl (%eax),%eax
8010554e:	84 c0                	test   %al,%al
80105550:	75 d8                	jne    8010552a <safestrcpy+0x17>
    ;
  *s = 0;
80105552:	8b 45 08             	mov    0x8(%ebp),%eax
80105555:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105558:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010555b:	c9                   	leave  
8010555c:	c3                   	ret    

8010555d <strlen>:

int
strlen(const char *s)
{
8010555d:	55                   	push   %ebp
8010555e:	89 e5                	mov    %esp,%ebp
80105560:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105563:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010556a:	eb 04                	jmp    80105570 <strlen+0x13>
8010556c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105570:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105573:	8b 45 08             	mov    0x8(%ebp),%eax
80105576:	01 d0                	add    %edx,%eax
80105578:	0f b6 00             	movzbl (%eax),%eax
8010557b:	84 c0                	test   %al,%al
8010557d:	75 ed                	jne    8010556c <strlen+0xf>
    ;
  return n;
8010557f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105582:	c9                   	leave  
80105583:	c3                   	ret    

80105584 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105584:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105588:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010558c:	55                   	push   %ebp
  pushl %ebx
8010558d:	53                   	push   %ebx
  pushl %esi
8010558e:	56                   	push   %esi
  pushl %edi
8010558f:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105590:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105592:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105594:	5f                   	pop    %edi
  popl %esi
80105595:	5e                   	pop    %esi
  popl %ebx
80105596:	5b                   	pop    %ebx
  popl %ebp
80105597:	5d                   	pop    %ebp
  ret
80105598:	c3                   	ret    

80105599 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105599:	55                   	push   %ebp
8010559a:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010559c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055a2:	8b 00                	mov    (%eax),%eax
801055a4:	3b 45 08             	cmp    0x8(%ebp),%eax
801055a7:	76 12                	jbe    801055bb <fetchint+0x22>
801055a9:	8b 45 08             	mov    0x8(%ebp),%eax
801055ac:	8d 50 04             	lea    0x4(%eax),%edx
801055af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055b5:	8b 00                	mov    (%eax),%eax
801055b7:	39 c2                	cmp    %eax,%edx
801055b9:	76 07                	jbe    801055c2 <fetchint+0x29>
    return -1;
801055bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055c0:	eb 0f                	jmp    801055d1 <fetchint+0x38>
  *ip = *(int*)(addr);
801055c2:	8b 45 08             	mov    0x8(%ebp),%eax
801055c5:	8b 10                	mov    (%eax),%edx
801055c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801055ca:	89 10                	mov    %edx,(%eax)
  return 0;
801055cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055d1:	5d                   	pop    %ebp
801055d2:	c3                   	ret    

801055d3 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801055d3:	55                   	push   %ebp
801055d4:	89 e5                	mov    %esp,%ebp
801055d6:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801055d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055df:	8b 00                	mov    (%eax),%eax
801055e1:	3b 45 08             	cmp    0x8(%ebp),%eax
801055e4:	77 07                	ja     801055ed <fetchstr+0x1a>
    return -1;
801055e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055eb:	eb 46                	jmp    80105633 <fetchstr+0x60>
  *pp = (char*)addr;
801055ed:	8b 55 08             	mov    0x8(%ebp),%edx
801055f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801055f3:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801055f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055fb:	8b 00                	mov    (%eax),%eax
801055fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105600:	8b 45 0c             	mov    0xc(%ebp),%eax
80105603:	8b 00                	mov    (%eax),%eax
80105605:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105608:	eb 1c                	jmp    80105626 <fetchstr+0x53>
    if(*s == 0)
8010560a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010560d:	0f b6 00             	movzbl (%eax),%eax
80105610:	84 c0                	test   %al,%al
80105612:	75 0e                	jne    80105622 <fetchstr+0x4f>
      return s - *pp;
80105614:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105617:	8b 45 0c             	mov    0xc(%ebp),%eax
8010561a:	8b 00                	mov    (%eax),%eax
8010561c:	29 c2                	sub    %eax,%edx
8010561e:	89 d0                	mov    %edx,%eax
80105620:	eb 11                	jmp    80105633 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105622:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105626:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105629:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010562c:	72 dc                	jb     8010560a <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
8010562e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105633:	c9                   	leave  
80105634:	c3                   	ret    

80105635 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105635:	55                   	push   %ebp
80105636:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105638:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010563e:	8b 40 18             	mov    0x18(%eax),%eax
80105641:	8b 40 44             	mov    0x44(%eax),%eax
80105644:	8b 55 08             	mov    0x8(%ebp),%edx
80105647:	c1 e2 02             	shl    $0x2,%edx
8010564a:	01 d0                	add    %edx,%eax
8010564c:	83 c0 04             	add    $0x4,%eax
8010564f:	ff 75 0c             	pushl  0xc(%ebp)
80105652:	50                   	push   %eax
80105653:	e8 41 ff ff ff       	call   80105599 <fetchint>
80105658:	83 c4 08             	add    $0x8,%esp
}
8010565b:	c9                   	leave  
8010565c:	c3                   	ret    

8010565d <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010565d:	55                   	push   %ebp
8010565e:	89 e5                	mov    %esp,%ebp
80105660:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105663:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105666:	50                   	push   %eax
80105667:	ff 75 08             	pushl  0x8(%ebp)
8010566a:	e8 c6 ff ff ff       	call   80105635 <argint>
8010566f:	83 c4 08             	add    $0x8,%esp
80105672:	85 c0                	test   %eax,%eax
80105674:	79 07                	jns    8010567d <argptr+0x20>
    return -1;
80105676:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010567b:	eb 3b                	jmp    801056b8 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010567d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105683:	8b 00                	mov    (%eax),%eax
80105685:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105688:	39 d0                	cmp    %edx,%eax
8010568a:	76 16                	jbe    801056a2 <argptr+0x45>
8010568c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010568f:	89 c2                	mov    %eax,%edx
80105691:	8b 45 10             	mov    0x10(%ebp),%eax
80105694:	01 c2                	add    %eax,%edx
80105696:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010569c:	8b 00                	mov    (%eax),%eax
8010569e:	39 c2                	cmp    %eax,%edx
801056a0:	76 07                	jbe    801056a9 <argptr+0x4c>
    return -1;
801056a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a7:	eb 0f                	jmp    801056b8 <argptr+0x5b>
  *pp = (char*)i;
801056a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056ac:	89 c2                	mov    %eax,%edx
801056ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801056b1:	89 10                	mov    %edx,(%eax)
  return 0;
801056b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056b8:	c9                   	leave  
801056b9:	c3                   	ret    

801056ba <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801056ba:	55                   	push   %ebp
801056bb:	89 e5                	mov    %esp,%ebp
801056bd:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
801056c0:	8d 45 fc             	lea    -0x4(%ebp),%eax
801056c3:	50                   	push   %eax
801056c4:	ff 75 08             	pushl  0x8(%ebp)
801056c7:	e8 69 ff ff ff       	call   80105635 <argint>
801056cc:	83 c4 08             	add    $0x8,%esp
801056cf:	85 c0                	test   %eax,%eax
801056d1:	79 07                	jns    801056da <argstr+0x20>
    return -1;
801056d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d8:	eb 0f                	jmp    801056e9 <argstr+0x2f>
  return fetchstr(addr, pp);
801056da:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056dd:	ff 75 0c             	pushl  0xc(%ebp)
801056e0:	50                   	push   %eax
801056e1:	e8 ed fe ff ff       	call   801055d3 <fetchstr>
801056e6:	83 c4 08             	add    $0x8,%esp
}
801056e9:	c9                   	leave  
801056ea:	c3                   	ret    

801056eb <syscall>:
[SYS_signal_restorer]   sys_signal_restorer,
};

void
syscall(void)
{
801056eb:	55                   	push   %ebp
801056ec:	89 e5                	mov    %esp,%ebp
801056ee:	53                   	push   %ebx
801056ef:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801056f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056f8:	8b 40 18             	mov    0x18(%eax),%eax
801056fb:	8b 40 1c             	mov    0x1c(%eax),%eax
801056fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105701:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105705:	7e 30                	jle    80105737 <syscall+0x4c>
80105707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010570a:	83 f8 18             	cmp    $0x18,%eax
8010570d:	77 28                	ja     80105737 <syscall+0x4c>
8010570f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105712:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105719:	85 c0                	test   %eax,%eax
8010571b:	74 1a                	je     80105737 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
8010571d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105723:	8b 58 18             	mov    0x18(%eax),%ebx
80105726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105729:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105730:	ff d0                	call   *%eax
80105732:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105735:	eb 34                	jmp    8010576b <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105737:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010573d:	8d 50 6c             	lea    0x6c(%eax),%edx
80105740:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105746:	8b 40 10             	mov    0x10(%eax),%eax
80105749:	ff 75 f4             	pushl  -0xc(%ebp)
8010574c:	52                   	push   %edx
8010574d:	50                   	push   %eax
8010574e:	68 a7 8b 10 80       	push   $0x80108ba7
80105753:	e8 6e ac ff ff       	call   801003c6 <cprintf>
80105758:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010575b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105761:	8b 40 18             	mov    0x18(%eax),%eax
80105764:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010576b:	90                   	nop
8010576c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010576f:	c9                   	leave  
80105770:	c3                   	ret    

80105771 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105771:	55                   	push   %ebp
80105772:	89 e5                	mov    %esp,%ebp
80105774:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105777:	83 ec 08             	sub    $0x8,%esp
8010577a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010577d:	50                   	push   %eax
8010577e:	ff 75 08             	pushl  0x8(%ebp)
80105781:	e8 af fe ff ff       	call   80105635 <argint>
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	85 c0                	test   %eax,%eax
8010578b:	79 07                	jns    80105794 <argfd+0x23>
    return -1;
8010578d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105792:	eb 50                	jmp    801057e4 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105794:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105797:	85 c0                	test   %eax,%eax
80105799:	78 21                	js     801057bc <argfd+0x4b>
8010579b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010579e:	83 f8 0f             	cmp    $0xf,%eax
801057a1:	7f 19                	jg     801057bc <argfd+0x4b>
801057a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057ac:	83 c2 08             	add    $0x8,%edx
801057af:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801057b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057ba:	75 07                	jne    801057c3 <argfd+0x52>
    return -1;
801057bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c1:	eb 21                	jmp    801057e4 <argfd+0x73>
  if(pfd)
801057c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801057c7:	74 08                	je     801057d1 <argfd+0x60>
    *pfd = fd;
801057c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801057cf:	89 10                	mov    %edx,(%eax)
  if(pf)
801057d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057d5:	74 08                	je     801057df <argfd+0x6e>
    *pf = f;
801057d7:	8b 45 10             	mov    0x10(%ebp),%eax
801057da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057dd:	89 10                	mov    %edx,(%eax)
  return 0;
801057df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057e4:	c9                   	leave  
801057e5:	c3                   	ret    

801057e6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801057e6:	55                   	push   %ebp
801057e7:	89 e5                	mov    %esp,%ebp
801057e9:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801057ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801057f3:	eb 30                	jmp    80105825 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801057f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057fe:	83 c2 08             	add    $0x8,%edx
80105801:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105805:	85 c0                	test   %eax,%eax
80105807:	75 18                	jne    80105821 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105809:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010580f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105812:	8d 4a 08             	lea    0x8(%edx),%ecx
80105815:	8b 55 08             	mov    0x8(%ebp),%edx
80105818:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010581c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010581f:	eb 0f                	jmp    80105830 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105821:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105825:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105829:	7e ca                	jle    801057f5 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010582b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105830:	c9                   	leave  
80105831:	c3                   	ret    

80105832 <sys_dup>:

int
sys_dup(void)
{
80105832:	55                   	push   %ebp
80105833:	89 e5                	mov    %esp,%ebp
80105835:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105838:	83 ec 04             	sub    $0x4,%esp
8010583b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010583e:	50                   	push   %eax
8010583f:	6a 00                	push   $0x0
80105841:	6a 00                	push   $0x0
80105843:	e8 29 ff ff ff       	call   80105771 <argfd>
80105848:	83 c4 10             	add    $0x10,%esp
8010584b:	85 c0                	test   %eax,%eax
8010584d:	79 07                	jns    80105856 <sys_dup+0x24>
    return -1;
8010584f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105854:	eb 31                	jmp    80105887 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105856:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105859:	83 ec 0c             	sub    $0xc,%esp
8010585c:	50                   	push   %eax
8010585d:	e8 84 ff ff ff       	call   801057e6 <fdalloc>
80105862:	83 c4 10             	add    $0x10,%esp
80105865:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010586c:	79 07                	jns    80105875 <sys_dup+0x43>
    return -1;
8010586e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105873:	eb 12                	jmp    80105887 <sys_dup+0x55>
  filedup(f);
80105875:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105878:	83 ec 0c             	sub    $0xc,%esp
8010587b:	50                   	push   %eax
8010587c:	e8 64 b7 ff ff       	call   80100fe5 <filedup>
80105881:	83 c4 10             	add    $0x10,%esp
  return fd;
80105884:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105887:	c9                   	leave  
80105888:	c3                   	ret    

80105889 <sys_read>:

int
sys_read(void)
{
80105889:	55                   	push   %ebp
8010588a:	89 e5                	mov    %esp,%ebp
8010588c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010588f:	83 ec 04             	sub    $0x4,%esp
80105892:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105895:	50                   	push   %eax
80105896:	6a 00                	push   $0x0
80105898:	6a 00                	push   $0x0
8010589a:	e8 d2 fe ff ff       	call   80105771 <argfd>
8010589f:	83 c4 10             	add    $0x10,%esp
801058a2:	85 c0                	test   %eax,%eax
801058a4:	78 2e                	js     801058d4 <sys_read+0x4b>
801058a6:	83 ec 08             	sub    $0x8,%esp
801058a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058ac:	50                   	push   %eax
801058ad:	6a 02                	push   $0x2
801058af:	e8 81 fd ff ff       	call   80105635 <argint>
801058b4:	83 c4 10             	add    $0x10,%esp
801058b7:	85 c0                	test   %eax,%eax
801058b9:	78 19                	js     801058d4 <sys_read+0x4b>
801058bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058be:	83 ec 04             	sub    $0x4,%esp
801058c1:	50                   	push   %eax
801058c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058c5:	50                   	push   %eax
801058c6:	6a 01                	push   $0x1
801058c8:	e8 90 fd ff ff       	call   8010565d <argptr>
801058cd:	83 c4 10             	add    $0x10,%esp
801058d0:	85 c0                	test   %eax,%eax
801058d2:	79 07                	jns    801058db <sys_read+0x52>
    return -1;
801058d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d9:	eb 17                	jmp    801058f2 <sys_read+0x69>
  return fileread(f, p, n);
801058db:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801058de:	8b 55 ec             	mov    -0x14(%ebp),%edx
801058e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e4:	83 ec 04             	sub    $0x4,%esp
801058e7:	51                   	push   %ecx
801058e8:	52                   	push   %edx
801058e9:	50                   	push   %eax
801058ea:	e8 86 b8 ff ff       	call   80101175 <fileread>
801058ef:	83 c4 10             	add    $0x10,%esp
}
801058f2:	c9                   	leave  
801058f3:	c3                   	ret    

801058f4 <sys_write>:

int
sys_write(void)
{
801058f4:	55                   	push   %ebp
801058f5:	89 e5                	mov    %esp,%ebp
801058f7:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058fa:	83 ec 04             	sub    $0x4,%esp
801058fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105900:	50                   	push   %eax
80105901:	6a 00                	push   $0x0
80105903:	6a 00                	push   $0x0
80105905:	e8 67 fe ff ff       	call   80105771 <argfd>
8010590a:	83 c4 10             	add    $0x10,%esp
8010590d:	85 c0                	test   %eax,%eax
8010590f:	78 2e                	js     8010593f <sys_write+0x4b>
80105911:	83 ec 08             	sub    $0x8,%esp
80105914:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105917:	50                   	push   %eax
80105918:	6a 02                	push   $0x2
8010591a:	e8 16 fd ff ff       	call   80105635 <argint>
8010591f:	83 c4 10             	add    $0x10,%esp
80105922:	85 c0                	test   %eax,%eax
80105924:	78 19                	js     8010593f <sys_write+0x4b>
80105926:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105929:	83 ec 04             	sub    $0x4,%esp
8010592c:	50                   	push   %eax
8010592d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105930:	50                   	push   %eax
80105931:	6a 01                	push   $0x1
80105933:	e8 25 fd ff ff       	call   8010565d <argptr>
80105938:	83 c4 10             	add    $0x10,%esp
8010593b:	85 c0                	test   %eax,%eax
8010593d:	79 07                	jns    80105946 <sys_write+0x52>
    return -1;
8010593f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105944:	eb 17                	jmp    8010595d <sys_write+0x69>
  return filewrite(f, p, n);
80105946:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105949:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010594c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010594f:	83 ec 04             	sub    $0x4,%esp
80105952:	51                   	push   %ecx
80105953:	52                   	push   %edx
80105954:	50                   	push   %eax
80105955:	e8 d3 b8 ff ff       	call   8010122d <filewrite>
8010595a:	83 c4 10             	add    $0x10,%esp
}
8010595d:	c9                   	leave  
8010595e:	c3                   	ret    

8010595f <sys_close>:

int
sys_close(void)
{
8010595f:	55                   	push   %ebp
80105960:	89 e5                	mov    %esp,%ebp
80105962:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105965:	83 ec 04             	sub    $0x4,%esp
80105968:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010596b:	50                   	push   %eax
8010596c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010596f:	50                   	push   %eax
80105970:	6a 00                	push   $0x0
80105972:	e8 fa fd ff ff       	call   80105771 <argfd>
80105977:	83 c4 10             	add    $0x10,%esp
8010597a:	85 c0                	test   %eax,%eax
8010597c:	79 07                	jns    80105985 <sys_close+0x26>
    return -1;
8010597e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105983:	eb 28                	jmp    801059ad <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105985:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010598b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010598e:	83 c2 08             	add    $0x8,%edx
80105991:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105998:	00 
  fileclose(f);
80105999:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010599c:	83 ec 0c             	sub    $0xc,%esp
8010599f:	50                   	push   %eax
801059a0:	e8 91 b6 ff ff       	call   80101036 <fileclose>
801059a5:	83 c4 10             	add    $0x10,%esp
  return 0;
801059a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059ad:	c9                   	leave  
801059ae:	c3                   	ret    

801059af <sys_fstat>:

int
sys_fstat(void)
{
801059af:	55                   	push   %ebp
801059b0:	89 e5                	mov    %esp,%ebp
801059b2:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059b5:	83 ec 04             	sub    $0x4,%esp
801059b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059bb:	50                   	push   %eax
801059bc:	6a 00                	push   $0x0
801059be:	6a 00                	push   $0x0
801059c0:	e8 ac fd ff ff       	call   80105771 <argfd>
801059c5:	83 c4 10             	add    $0x10,%esp
801059c8:	85 c0                	test   %eax,%eax
801059ca:	78 17                	js     801059e3 <sys_fstat+0x34>
801059cc:	83 ec 04             	sub    $0x4,%esp
801059cf:	6a 14                	push   $0x14
801059d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059d4:	50                   	push   %eax
801059d5:	6a 01                	push   $0x1
801059d7:	e8 81 fc ff ff       	call   8010565d <argptr>
801059dc:	83 c4 10             	add    $0x10,%esp
801059df:	85 c0                	test   %eax,%eax
801059e1:	79 07                	jns    801059ea <sys_fstat+0x3b>
    return -1;
801059e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e8:	eb 13                	jmp    801059fd <sys_fstat+0x4e>
  return filestat(f, st);
801059ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
801059ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f0:	83 ec 08             	sub    $0x8,%esp
801059f3:	52                   	push   %edx
801059f4:	50                   	push   %eax
801059f5:	e8 24 b7 ff ff       	call   8010111e <filestat>
801059fa:	83 c4 10             	add    $0x10,%esp
}
801059fd:	c9                   	leave  
801059fe:	c3                   	ret    

801059ff <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801059ff:	55                   	push   %ebp
80105a00:	89 e5                	mov    %esp,%ebp
80105a02:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a05:	83 ec 08             	sub    $0x8,%esp
80105a08:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a0b:	50                   	push   %eax
80105a0c:	6a 00                	push   $0x0
80105a0e:	e8 a7 fc ff ff       	call   801056ba <argstr>
80105a13:	83 c4 10             	add    $0x10,%esp
80105a16:	85 c0                	test   %eax,%eax
80105a18:	78 15                	js     80105a2f <sys_link+0x30>
80105a1a:	83 ec 08             	sub    $0x8,%esp
80105a1d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105a20:	50                   	push   %eax
80105a21:	6a 01                	push   $0x1
80105a23:	e8 92 fc ff ff       	call   801056ba <argstr>
80105a28:	83 c4 10             	add    $0x10,%esp
80105a2b:	85 c0                	test   %eax,%eax
80105a2d:	79 0a                	jns    80105a39 <sys_link+0x3a>
    return -1;
80105a2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a34:	e9 68 01 00 00       	jmp    80105ba1 <sys_link+0x1a2>

  begin_op();
80105a39:	e8 76 da ff ff       	call   801034b4 <begin_op>
  if((ip = namei(old)) == 0){
80105a3e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105a41:	83 ec 0c             	sub    $0xc,%esp
80105a44:	50                   	push   %eax
80105a45:	e8 79 ca ff ff       	call   801024c3 <namei>
80105a4a:	83 c4 10             	add    $0x10,%esp
80105a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a54:	75 0f                	jne    80105a65 <sys_link+0x66>
    end_op();
80105a56:	e8 e5 da ff ff       	call   80103540 <end_op>
    return -1;
80105a5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a60:	e9 3c 01 00 00       	jmp    80105ba1 <sys_link+0x1a2>
  }

  ilock(ip);
80105a65:	83 ec 0c             	sub    $0xc,%esp
80105a68:	ff 75 f4             	pushl  -0xc(%ebp)
80105a6b:	e8 9b be ff ff       	call   8010190b <ilock>
80105a70:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a76:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105a7a:	66 83 f8 01          	cmp    $0x1,%ax
80105a7e:	75 1d                	jne    80105a9d <sys_link+0x9e>
    iunlockput(ip);
80105a80:	83 ec 0c             	sub    $0xc,%esp
80105a83:	ff 75 f4             	pushl  -0xc(%ebp)
80105a86:	e8 3a c1 ff ff       	call   80101bc5 <iunlockput>
80105a8b:	83 c4 10             	add    $0x10,%esp
    end_op();
80105a8e:	e8 ad da ff ff       	call   80103540 <end_op>
    return -1;
80105a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a98:	e9 04 01 00 00       	jmp    80105ba1 <sys_link+0x1a2>
  }

  ip->nlink++;
80105a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa0:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105aa4:	83 c0 01             	add    $0x1,%eax
80105aa7:	89 c2                	mov    %eax,%edx
80105aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aac:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ab0:	83 ec 0c             	sub    $0xc,%esp
80105ab3:	ff 75 f4             	pushl  -0xc(%ebp)
80105ab6:	e8 7c bc ff ff       	call   80101737 <iupdate>
80105abb:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105abe:	83 ec 0c             	sub    $0xc,%esp
80105ac1:	ff 75 f4             	pushl  -0xc(%ebp)
80105ac4:	e8 9a bf ff ff       	call   80101a63 <iunlock>
80105ac9:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105acc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105acf:	83 ec 08             	sub    $0x8,%esp
80105ad2:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105ad5:	52                   	push   %edx
80105ad6:	50                   	push   %eax
80105ad7:	e8 03 ca ff ff       	call   801024df <nameiparent>
80105adc:	83 c4 10             	add    $0x10,%esp
80105adf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ae2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ae6:	74 71                	je     80105b59 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
80105aeb:	ff 75 f0             	pushl  -0x10(%ebp)
80105aee:	e8 18 be ff ff       	call   8010190b <ilock>
80105af3:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af9:	8b 10                	mov    (%eax),%edx
80105afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105afe:	8b 00                	mov    (%eax),%eax
80105b00:	39 c2                	cmp    %eax,%edx
80105b02:	75 1d                	jne    80105b21 <sys_link+0x122>
80105b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b07:	8b 40 04             	mov    0x4(%eax),%eax
80105b0a:	83 ec 04             	sub    $0x4,%esp
80105b0d:	50                   	push   %eax
80105b0e:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105b11:	50                   	push   %eax
80105b12:	ff 75 f0             	pushl  -0x10(%ebp)
80105b15:	e8 0d c7 ff ff       	call   80102227 <dirlink>
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	85 c0                	test   %eax,%eax
80105b1f:	79 10                	jns    80105b31 <sys_link+0x132>
    iunlockput(dp);
80105b21:	83 ec 0c             	sub    $0xc,%esp
80105b24:	ff 75 f0             	pushl  -0x10(%ebp)
80105b27:	e8 99 c0 ff ff       	call   80101bc5 <iunlockput>
80105b2c:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105b2f:	eb 29                	jmp    80105b5a <sys_link+0x15b>
  }
  iunlockput(dp);
80105b31:	83 ec 0c             	sub    $0xc,%esp
80105b34:	ff 75 f0             	pushl  -0x10(%ebp)
80105b37:	e8 89 c0 ff ff       	call   80101bc5 <iunlockput>
80105b3c:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105b3f:	83 ec 0c             	sub    $0xc,%esp
80105b42:	ff 75 f4             	pushl  -0xc(%ebp)
80105b45:	e8 8b bf ff ff       	call   80101ad5 <iput>
80105b4a:	83 c4 10             	add    $0x10,%esp

  end_op();
80105b4d:	e8 ee d9 ff ff       	call   80103540 <end_op>

  return 0;
80105b52:	b8 00 00 00 00       	mov    $0x0,%eax
80105b57:	eb 48                	jmp    80105ba1 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105b59:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105b5a:	83 ec 0c             	sub    $0xc,%esp
80105b5d:	ff 75 f4             	pushl  -0xc(%ebp)
80105b60:	e8 a6 bd ff ff       	call   8010190b <ilock>
80105b65:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b6f:	83 e8 01             	sub    $0x1,%eax
80105b72:	89 c2                	mov    %eax,%edx
80105b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b77:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105b7b:	83 ec 0c             	sub    $0xc,%esp
80105b7e:	ff 75 f4             	pushl  -0xc(%ebp)
80105b81:	e8 b1 bb ff ff       	call   80101737 <iupdate>
80105b86:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105b89:	83 ec 0c             	sub    $0xc,%esp
80105b8c:	ff 75 f4             	pushl  -0xc(%ebp)
80105b8f:	e8 31 c0 ff ff       	call   80101bc5 <iunlockput>
80105b94:	83 c4 10             	add    $0x10,%esp
  end_op();
80105b97:	e8 a4 d9 ff ff       	call   80103540 <end_op>
  return -1;
80105b9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ba1:	c9                   	leave  
80105ba2:	c3                   	ret    

80105ba3 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105ba3:	55                   	push   %ebp
80105ba4:	89 e5                	mov    %esp,%ebp
80105ba6:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ba9:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105bb0:	eb 40                	jmp    80105bf2 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb5:	6a 10                	push   $0x10
80105bb7:	50                   	push   %eax
80105bb8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bbb:	50                   	push   %eax
80105bbc:	ff 75 08             	pushl  0x8(%ebp)
80105bbf:	e8 af c2 ff ff       	call   80101e73 <readi>
80105bc4:	83 c4 10             	add    $0x10,%esp
80105bc7:	83 f8 10             	cmp    $0x10,%eax
80105bca:	74 0d                	je     80105bd9 <isdirempty+0x36>
      panic("isdirempty: readi");
80105bcc:	83 ec 0c             	sub    $0xc,%esp
80105bcf:	68 c3 8b 10 80       	push   $0x80108bc3
80105bd4:	e8 8d a9 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80105bd9:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105bdd:	66 85 c0             	test   %ax,%ax
80105be0:	74 07                	je     80105be9 <isdirempty+0x46>
      return 0;
80105be2:	b8 00 00 00 00       	mov    $0x0,%eax
80105be7:	eb 1b                	jmp    80105c04 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bec:	83 c0 10             	add    $0x10,%eax
80105bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bf2:	8b 45 08             	mov    0x8(%ebp),%eax
80105bf5:	8b 50 18             	mov    0x18(%eax),%edx
80105bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bfb:	39 c2                	cmp    %eax,%edx
80105bfd:	77 b3                	ja     80105bb2 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105bff:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105c04:	c9                   	leave  
80105c05:	c3                   	ret    

80105c06 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105c06:	55                   	push   %ebp
80105c07:	89 e5                	mov    %esp,%ebp
80105c09:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105c0c:	83 ec 08             	sub    $0x8,%esp
80105c0f:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105c12:	50                   	push   %eax
80105c13:	6a 00                	push   $0x0
80105c15:	e8 a0 fa ff ff       	call   801056ba <argstr>
80105c1a:	83 c4 10             	add    $0x10,%esp
80105c1d:	85 c0                	test   %eax,%eax
80105c1f:	79 0a                	jns    80105c2b <sys_unlink+0x25>
    return -1;
80105c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c26:	e9 bc 01 00 00       	jmp    80105de7 <sys_unlink+0x1e1>

  begin_op();
80105c2b:	e8 84 d8 ff ff       	call   801034b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c30:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105c33:	83 ec 08             	sub    $0x8,%esp
80105c36:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105c39:	52                   	push   %edx
80105c3a:	50                   	push   %eax
80105c3b:	e8 9f c8 ff ff       	call   801024df <nameiparent>
80105c40:	83 c4 10             	add    $0x10,%esp
80105c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c4a:	75 0f                	jne    80105c5b <sys_unlink+0x55>
    end_op();
80105c4c:	e8 ef d8 ff ff       	call   80103540 <end_op>
    return -1;
80105c51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c56:	e9 8c 01 00 00       	jmp    80105de7 <sys_unlink+0x1e1>
  }

  ilock(dp);
80105c5b:	83 ec 0c             	sub    $0xc,%esp
80105c5e:	ff 75 f4             	pushl  -0xc(%ebp)
80105c61:	e8 a5 bc ff ff       	call   8010190b <ilock>
80105c66:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c69:	83 ec 08             	sub    $0x8,%esp
80105c6c:	68 d5 8b 10 80       	push   $0x80108bd5
80105c71:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c74:	50                   	push   %eax
80105c75:	e8 d8 c4 ff ff       	call   80102152 <namecmp>
80105c7a:	83 c4 10             	add    $0x10,%esp
80105c7d:	85 c0                	test   %eax,%eax
80105c7f:	0f 84 4a 01 00 00    	je     80105dcf <sys_unlink+0x1c9>
80105c85:	83 ec 08             	sub    $0x8,%esp
80105c88:	68 d7 8b 10 80       	push   $0x80108bd7
80105c8d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c90:	50                   	push   %eax
80105c91:	e8 bc c4 ff ff       	call   80102152 <namecmp>
80105c96:	83 c4 10             	add    $0x10,%esp
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	0f 84 2e 01 00 00    	je     80105dcf <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105ca1:	83 ec 04             	sub    $0x4,%esp
80105ca4:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105ca7:	50                   	push   %eax
80105ca8:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cab:	50                   	push   %eax
80105cac:	ff 75 f4             	pushl  -0xc(%ebp)
80105caf:	e8 b9 c4 ff ff       	call   8010216d <dirlookup>
80105cb4:	83 c4 10             	add    $0x10,%esp
80105cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cbe:	0f 84 0a 01 00 00    	je     80105dce <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80105cc4:	83 ec 0c             	sub    $0xc,%esp
80105cc7:	ff 75 f0             	pushl  -0x10(%ebp)
80105cca:	e8 3c bc ff ff       	call   8010190b <ilock>
80105ccf:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cd5:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105cd9:	66 85 c0             	test   %ax,%ax
80105cdc:	7f 0d                	jg     80105ceb <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105cde:	83 ec 0c             	sub    $0xc,%esp
80105ce1:	68 da 8b 10 80       	push   $0x80108bda
80105ce6:	e8 7b a8 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cee:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105cf2:	66 83 f8 01          	cmp    $0x1,%ax
80105cf6:	75 25                	jne    80105d1d <sys_unlink+0x117>
80105cf8:	83 ec 0c             	sub    $0xc,%esp
80105cfb:	ff 75 f0             	pushl  -0x10(%ebp)
80105cfe:	e8 a0 fe ff ff       	call   80105ba3 <isdirempty>
80105d03:	83 c4 10             	add    $0x10,%esp
80105d06:	85 c0                	test   %eax,%eax
80105d08:	75 13                	jne    80105d1d <sys_unlink+0x117>
    iunlockput(ip);
80105d0a:	83 ec 0c             	sub    $0xc,%esp
80105d0d:	ff 75 f0             	pushl  -0x10(%ebp)
80105d10:	e8 b0 be ff ff       	call   80101bc5 <iunlockput>
80105d15:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105d18:	e9 b2 00 00 00       	jmp    80105dcf <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105d1d:	83 ec 04             	sub    $0x4,%esp
80105d20:	6a 10                	push   $0x10
80105d22:	6a 00                	push   $0x0
80105d24:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d27:	50                   	push   %eax
80105d28:	e8 e3 f5 ff ff       	call   80105310 <memset>
80105d2d:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d30:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105d33:	6a 10                	push   $0x10
80105d35:	50                   	push   %eax
80105d36:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d39:	50                   	push   %eax
80105d3a:	ff 75 f4             	pushl  -0xc(%ebp)
80105d3d:	e8 88 c2 ff ff       	call   80101fca <writei>
80105d42:	83 c4 10             	add    $0x10,%esp
80105d45:	83 f8 10             	cmp    $0x10,%eax
80105d48:	74 0d                	je     80105d57 <sys_unlink+0x151>
    panic("unlink: writei");
80105d4a:	83 ec 0c             	sub    $0xc,%esp
80105d4d:	68 ec 8b 10 80       	push   $0x80108bec
80105d52:	e8 0f a8 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80105d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d5a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d5e:	66 83 f8 01          	cmp    $0x1,%ax
80105d62:	75 21                	jne    80105d85 <sys_unlink+0x17f>
    dp->nlink--;
80105d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d67:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d6b:	83 e8 01             	sub    $0x1,%eax
80105d6e:	89 c2                	mov    %eax,%edx
80105d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d73:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105d77:	83 ec 0c             	sub    $0xc,%esp
80105d7a:	ff 75 f4             	pushl  -0xc(%ebp)
80105d7d:	e8 b5 b9 ff ff       	call   80101737 <iupdate>
80105d82:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105d85:	83 ec 0c             	sub    $0xc,%esp
80105d88:	ff 75 f4             	pushl  -0xc(%ebp)
80105d8b:	e8 35 be ff ff       	call   80101bc5 <iunlockput>
80105d90:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d96:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d9a:	83 e8 01             	sub    $0x1,%eax
80105d9d:	89 c2                	mov    %eax,%edx
80105d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da2:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105da6:	83 ec 0c             	sub    $0xc,%esp
80105da9:	ff 75 f0             	pushl  -0x10(%ebp)
80105dac:	e8 86 b9 ff ff       	call   80101737 <iupdate>
80105db1:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105db4:	83 ec 0c             	sub    $0xc,%esp
80105db7:	ff 75 f0             	pushl  -0x10(%ebp)
80105dba:	e8 06 be ff ff       	call   80101bc5 <iunlockput>
80105dbf:	83 c4 10             	add    $0x10,%esp

  end_op();
80105dc2:	e8 79 d7 ff ff       	call   80103540 <end_op>

  return 0;
80105dc7:	b8 00 00 00 00       	mov    $0x0,%eax
80105dcc:	eb 19                	jmp    80105de7 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105dce:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105dcf:	83 ec 0c             	sub    $0xc,%esp
80105dd2:	ff 75 f4             	pushl  -0xc(%ebp)
80105dd5:	e8 eb bd ff ff       	call   80101bc5 <iunlockput>
80105dda:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ddd:	e8 5e d7 ff ff       	call   80103540 <end_op>
  return -1;
80105de2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105de7:	c9                   	leave  
80105de8:	c3                   	ret    

80105de9 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105de9:	55                   	push   %ebp
80105dea:	89 e5                	mov    %esp,%ebp
80105dec:	83 ec 38             	sub    $0x38,%esp
80105def:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105df2:	8b 55 10             	mov    0x10(%ebp),%edx
80105df5:	8b 45 14             	mov    0x14(%ebp),%eax
80105df8:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105dfc:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105e00:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105e04:	83 ec 08             	sub    $0x8,%esp
80105e07:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e0a:	50                   	push   %eax
80105e0b:	ff 75 08             	pushl  0x8(%ebp)
80105e0e:	e8 cc c6 ff ff       	call   801024df <nameiparent>
80105e13:	83 c4 10             	add    $0x10,%esp
80105e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e1d:	75 0a                	jne    80105e29 <create+0x40>
    return 0;
80105e1f:	b8 00 00 00 00       	mov    $0x0,%eax
80105e24:	e9 90 01 00 00       	jmp    80105fb9 <create+0x1d0>
  ilock(dp);
80105e29:	83 ec 0c             	sub    $0xc,%esp
80105e2c:	ff 75 f4             	pushl  -0xc(%ebp)
80105e2f:	e8 d7 ba ff ff       	call   8010190b <ilock>
80105e34:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105e37:	83 ec 04             	sub    $0x4,%esp
80105e3a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e3d:	50                   	push   %eax
80105e3e:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e41:	50                   	push   %eax
80105e42:	ff 75 f4             	pushl  -0xc(%ebp)
80105e45:	e8 23 c3 ff ff       	call   8010216d <dirlookup>
80105e4a:	83 c4 10             	add    $0x10,%esp
80105e4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e54:	74 50                	je     80105ea6 <create+0xbd>
    iunlockput(dp);
80105e56:	83 ec 0c             	sub    $0xc,%esp
80105e59:	ff 75 f4             	pushl  -0xc(%ebp)
80105e5c:	e8 64 bd ff ff       	call   80101bc5 <iunlockput>
80105e61:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105e64:	83 ec 0c             	sub    $0xc,%esp
80105e67:	ff 75 f0             	pushl  -0x10(%ebp)
80105e6a:	e8 9c ba ff ff       	call   8010190b <ilock>
80105e6f:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105e72:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105e77:	75 15                	jne    80105e8e <create+0xa5>
80105e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e7c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105e80:	66 83 f8 02          	cmp    $0x2,%ax
80105e84:	75 08                	jne    80105e8e <create+0xa5>
      return ip;
80105e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e89:	e9 2b 01 00 00       	jmp    80105fb9 <create+0x1d0>
    iunlockput(ip);
80105e8e:	83 ec 0c             	sub    $0xc,%esp
80105e91:	ff 75 f0             	pushl  -0x10(%ebp)
80105e94:	e8 2c bd ff ff       	call   80101bc5 <iunlockput>
80105e99:	83 c4 10             	add    $0x10,%esp
    return 0;
80105e9c:	b8 00 00 00 00       	mov    $0x0,%eax
80105ea1:	e9 13 01 00 00       	jmp    80105fb9 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105ea6:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ead:	8b 00                	mov    (%eax),%eax
80105eaf:	83 ec 08             	sub    $0x8,%esp
80105eb2:	52                   	push   %edx
80105eb3:	50                   	push   %eax
80105eb4:	e8 9d b7 ff ff       	call   80101656 <ialloc>
80105eb9:	83 c4 10             	add    $0x10,%esp
80105ebc:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ebf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ec3:	75 0d                	jne    80105ed2 <create+0xe9>
    panic("create: ialloc");
80105ec5:	83 ec 0c             	sub    $0xc,%esp
80105ec8:	68 fb 8b 10 80       	push   $0x80108bfb
80105ecd:	e8 94 a6 ff ff       	call   80100566 <panic>

  ilock(ip);
80105ed2:	83 ec 0c             	sub    $0xc,%esp
80105ed5:	ff 75 f0             	pushl  -0x10(%ebp)
80105ed8:	e8 2e ba ff ff       	call   8010190b <ilock>
80105edd:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ee3:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105ee7:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eee:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105ef2:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ef9:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105eff:	83 ec 0c             	sub    $0xc,%esp
80105f02:	ff 75 f0             	pushl  -0x10(%ebp)
80105f05:	e8 2d b8 ff ff       	call   80101737 <iupdate>
80105f0a:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105f0d:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105f12:	75 6a                	jne    80105f7e <create+0x195>
    dp->nlink++;  // for ".."
80105f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f17:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f1b:	83 c0 01             	add    $0x1,%eax
80105f1e:	89 c2                	mov    %eax,%edx
80105f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f23:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105f27:	83 ec 0c             	sub    $0xc,%esp
80105f2a:	ff 75 f4             	pushl  -0xc(%ebp)
80105f2d:	e8 05 b8 ff ff       	call   80101737 <iupdate>
80105f32:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f38:	8b 40 04             	mov    0x4(%eax),%eax
80105f3b:	83 ec 04             	sub    $0x4,%esp
80105f3e:	50                   	push   %eax
80105f3f:	68 d5 8b 10 80       	push   $0x80108bd5
80105f44:	ff 75 f0             	pushl  -0x10(%ebp)
80105f47:	e8 db c2 ff ff       	call   80102227 <dirlink>
80105f4c:	83 c4 10             	add    $0x10,%esp
80105f4f:	85 c0                	test   %eax,%eax
80105f51:	78 1e                	js     80105f71 <create+0x188>
80105f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f56:	8b 40 04             	mov    0x4(%eax),%eax
80105f59:	83 ec 04             	sub    $0x4,%esp
80105f5c:	50                   	push   %eax
80105f5d:	68 d7 8b 10 80       	push   $0x80108bd7
80105f62:	ff 75 f0             	pushl  -0x10(%ebp)
80105f65:	e8 bd c2 ff ff       	call   80102227 <dirlink>
80105f6a:	83 c4 10             	add    $0x10,%esp
80105f6d:	85 c0                	test   %eax,%eax
80105f6f:	79 0d                	jns    80105f7e <create+0x195>
      panic("create dots");
80105f71:	83 ec 0c             	sub    $0xc,%esp
80105f74:	68 0a 8c 10 80       	push   $0x80108c0a
80105f79:	e8 e8 a5 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f81:	8b 40 04             	mov    0x4(%eax),%eax
80105f84:	83 ec 04             	sub    $0x4,%esp
80105f87:	50                   	push   %eax
80105f88:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f8b:	50                   	push   %eax
80105f8c:	ff 75 f4             	pushl  -0xc(%ebp)
80105f8f:	e8 93 c2 ff ff       	call   80102227 <dirlink>
80105f94:	83 c4 10             	add    $0x10,%esp
80105f97:	85 c0                	test   %eax,%eax
80105f99:	79 0d                	jns    80105fa8 <create+0x1bf>
    panic("create: dirlink");
80105f9b:	83 ec 0c             	sub    $0xc,%esp
80105f9e:	68 16 8c 10 80       	push   $0x80108c16
80105fa3:	e8 be a5 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80105fa8:	83 ec 0c             	sub    $0xc,%esp
80105fab:	ff 75 f4             	pushl  -0xc(%ebp)
80105fae:	e8 12 bc ff ff       	call   80101bc5 <iunlockput>
80105fb3:	83 c4 10             	add    $0x10,%esp

  return ip;
80105fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105fb9:	c9                   	leave  
80105fba:	c3                   	ret    

80105fbb <sys_open>:

int
sys_open(void)
{
80105fbb:	55                   	push   %ebp
80105fbc:	89 e5                	mov    %esp,%ebp
80105fbe:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105fc1:	83 ec 08             	sub    $0x8,%esp
80105fc4:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105fc7:	50                   	push   %eax
80105fc8:	6a 00                	push   $0x0
80105fca:	e8 eb f6 ff ff       	call   801056ba <argstr>
80105fcf:	83 c4 10             	add    $0x10,%esp
80105fd2:	85 c0                	test   %eax,%eax
80105fd4:	78 15                	js     80105feb <sys_open+0x30>
80105fd6:	83 ec 08             	sub    $0x8,%esp
80105fd9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fdc:	50                   	push   %eax
80105fdd:	6a 01                	push   $0x1
80105fdf:	e8 51 f6 ff ff       	call   80105635 <argint>
80105fe4:	83 c4 10             	add    $0x10,%esp
80105fe7:	85 c0                	test   %eax,%eax
80105fe9:	79 0a                	jns    80105ff5 <sys_open+0x3a>
    return -1;
80105feb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ff0:	e9 61 01 00 00       	jmp    80106156 <sys_open+0x19b>

  begin_op();
80105ff5:	e8 ba d4 ff ff       	call   801034b4 <begin_op>

  if(omode & O_CREATE){
80105ffa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ffd:	25 00 02 00 00       	and    $0x200,%eax
80106002:	85 c0                	test   %eax,%eax
80106004:	74 2a                	je     80106030 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106006:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106009:	6a 00                	push   $0x0
8010600b:	6a 00                	push   $0x0
8010600d:	6a 02                	push   $0x2
8010600f:	50                   	push   %eax
80106010:	e8 d4 fd ff ff       	call   80105de9 <create>
80106015:	83 c4 10             	add    $0x10,%esp
80106018:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010601b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010601f:	75 75                	jne    80106096 <sys_open+0xdb>
      end_op();
80106021:	e8 1a d5 ff ff       	call   80103540 <end_op>
      return -1;
80106026:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010602b:	e9 26 01 00 00       	jmp    80106156 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106030:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106033:	83 ec 0c             	sub    $0xc,%esp
80106036:	50                   	push   %eax
80106037:	e8 87 c4 ff ff       	call   801024c3 <namei>
8010603c:	83 c4 10             	add    $0x10,%esp
8010603f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106046:	75 0f                	jne    80106057 <sys_open+0x9c>
      end_op();
80106048:	e8 f3 d4 ff ff       	call   80103540 <end_op>
      return -1;
8010604d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106052:	e9 ff 00 00 00       	jmp    80106156 <sys_open+0x19b>
    }
    ilock(ip);
80106057:	83 ec 0c             	sub    $0xc,%esp
8010605a:	ff 75 f4             	pushl  -0xc(%ebp)
8010605d:	e8 a9 b8 ff ff       	call   8010190b <ilock>
80106062:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106065:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106068:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010606c:	66 83 f8 01          	cmp    $0x1,%ax
80106070:	75 24                	jne    80106096 <sys_open+0xdb>
80106072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106075:	85 c0                	test   %eax,%eax
80106077:	74 1d                	je     80106096 <sys_open+0xdb>
      iunlockput(ip);
80106079:	83 ec 0c             	sub    $0xc,%esp
8010607c:	ff 75 f4             	pushl  -0xc(%ebp)
8010607f:	e8 41 bb ff ff       	call   80101bc5 <iunlockput>
80106084:	83 c4 10             	add    $0x10,%esp
      end_op();
80106087:	e8 b4 d4 ff ff       	call   80103540 <end_op>
      return -1;
8010608c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106091:	e9 c0 00 00 00       	jmp    80106156 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106096:	e8 dd ae ff ff       	call   80100f78 <filealloc>
8010609b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010609e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060a2:	74 17                	je     801060bb <sys_open+0x100>
801060a4:	83 ec 0c             	sub    $0xc,%esp
801060a7:	ff 75 f0             	pushl  -0x10(%ebp)
801060aa:	e8 37 f7 ff ff       	call   801057e6 <fdalloc>
801060af:	83 c4 10             	add    $0x10,%esp
801060b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
801060b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801060b9:	79 2e                	jns    801060e9 <sys_open+0x12e>
    if(f)
801060bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060bf:	74 0e                	je     801060cf <sys_open+0x114>
      fileclose(f);
801060c1:	83 ec 0c             	sub    $0xc,%esp
801060c4:	ff 75 f0             	pushl  -0x10(%ebp)
801060c7:	e8 6a af ff ff       	call   80101036 <fileclose>
801060cc:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801060cf:	83 ec 0c             	sub    $0xc,%esp
801060d2:	ff 75 f4             	pushl  -0xc(%ebp)
801060d5:	e8 eb ba ff ff       	call   80101bc5 <iunlockput>
801060da:	83 c4 10             	add    $0x10,%esp
    end_op();
801060dd:	e8 5e d4 ff ff       	call   80103540 <end_op>
    return -1;
801060e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e7:	eb 6d                	jmp    80106156 <sys_open+0x19b>
  }
  iunlock(ip);
801060e9:	83 ec 0c             	sub    $0xc,%esp
801060ec:	ff 75 f4             	pushl  -0xc(%ebp)
801060ef:	e8 6f b9 ff ff       	call   80101a63 <iunlock>
801060f4:	83 c4 10             	add    $0x10,%esp
  end_op();
801060f7:	e8 44 d4 ff ff       	call   80103540 <end_op>

  f->type = FD_INODE;
801060fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ff:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106105:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106108:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010610b:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010610e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106111:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010611b:	83 e0 01             	and    $0x1,%eax
8010611e:	85 c0                	test   %eax,%eax
80106120:	0f 94 c0             	sete   %al
80106123:	89 c2                	mov    %eax,%edx
80106125:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106128:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010612b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010612e:	83 e0 01             	and    $0x1,%eax
80106131:	85 c0                	test   %eax,%eax
80106133:	75 0a                	jne    8010613f <sys_open+0x184>
80106135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106138:	83 e0 02             	and    $0x2,%eax
8010613b:	85 c0                	test   %eax,%eax
8010613d:	74 07                	je     80106146 <sys_open+0x18b>
8010613f:	b8 01 00 00 00       	mov    $0x1,%eax
80106144:	eb 05                	jmp    8010614b <sys_open+0x190>
80106146:	b8 00 00 00 00       	mov    $0x0,%eax
8010614b:	89 c2                	mov    %eax,%edx
8010614d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106150:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106153:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106156:	c9                   	leave  
80106157:	c3                   	ret    

80106158 <sys_mkdir>:

int
sys_mkdir(void)
{
80106158:	55                   	push   %ebp
80106159:	89 e5                	mov    %esp,%ebp
8010615b:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010615e:	e8 51 d3 ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106163:	83 ec 08             	sub    $0x8,%esp
80106166:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106169:	50                   	push   %eax
8010616a:	6a 00                	push   $0x0
8010616c:	e8 49 f5 ff ff       	call   801056ba <argstr>
80106171:	83 c4 10             	add    $0x10,%esp
80106174:	85 c0                	test   %eax,%eax
80106176:	78 1b                	js     80106193 <sys_mkdir+0x3b>
80106178:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010617b:	6a 00                	push   $0x0
8010617d:	6a 00                	push   $0x0
8010617f:	6a 01                	push   $0x1
80106181:	50                   	push   %eax
80106182:	e8 62 fc ff ff       	call   80105de9 <create>
80106187:	83 c4 10             	add    $0x10,%esp
8010618a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010618d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106191:	75 0c                	jne    8010619f <sys_mkdir+0x47>
    end_op();
80106193:	e8 a8 d3 ff ff       	call   80103540 <end_op>
    return -1;
80106198:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010619d:	eb 18                	jmp    801061b7 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010619f:	83 ec 0c             	sub    $0xc,%esp
801061a2:	ff 75 f4             	pushl  -0xc(%ebp)
801061a5:	e8 1b ba ff ff       	call   80101bc5 <iunlockput>
801061aa:	83 c4 10             	add    $0x10,%esp
  end_op();
801061ad:	e8 8e d3 ff ff       	call   80103540 <end_op>
  return 0;
801061b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061b7:	c9                   	leave  
801061b8:	c3                   	ret    

801061b9 <sys_mknod>:

int
sys_mknod(void)
{
801061b9:	55                   	push   %ebp
801061ba:	89 e5                	mov    %esp,%ebp
801061bc:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801061bf:	e8 f0 d2 ff ff       	call   801034b4 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801061c4:	83 ec 08             	sub    $0x8,%esp
801061c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061ca:	50                   	push   %eax
801061cb:	6a 00                	push   $0x0
801061cd:	e8 e8 f4 ff ff       	call   801056ba <argstr>
801061d2:	83 c4 10             	add    $0x10,%esp
801061d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061dc:	78 4f                	js     8010622d <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801061de:	83 ec 08             	sub    $0x8,%esp
801061e1:	8d 45 e8             	lea    -0x18(%ebp),%eax
801061e4:	50                   	push   %eax
801061e5:	6a 01                	push   $0x1
801061e7:	e8 49 f4 ff ff       	call   80105635 <argint>
801061ec:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801061ef:	85 c0                	test   %eax,%eax
801061f1:	78 3a                	js     8010622d <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801061f3:	83 ec 08             	sub    $0x8,%esp
801061f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061f9:	50                   	push   %eax
801061fa:	6a 02                	push   $0x2
801061fc:	e8 34 f4 ff ff       	call   80105635 <argint>
80106201:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106204:	85 c0                	test   %eax,%eax
80106206:	78 25                	js     8010622d <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106208:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010620b:	0f bf c8             	movswl %ax,%ecx
8010620e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106211:	0f bf d0             	movswl %ax,%edx
80106214:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106217:	51                   	push   %ecx
80106218:	52                   	push   %edx
80106219:	6a 03                	push   $0x3
8010621b:	50                   	push   %eax
8010621c:	e8 c8 fb ff ff       	call   80105de9 <create>
80106221:	83 c4 10             	add    $0x10,%esp
80106224:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106227:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010622b:	75 0c                	jne    80106239 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
8010622d:	e8 0e d3 ff ff       	call   80103540 <end_op>
    return -1;
80106232:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106237:	eb 18                	jmp    80106251 <sys_mknod+0x98>
  }
  iunlockput(ip);
80106239:	83 ec 0c             	sub    $0xc,%esp
8010623c:	ff 75 f0             	pushl  -0x10(%ebp)
8010623f:	e8 81 b9 ff ff       	call   80101bc5 <iunlockput>
80106244:	83 c4 10             	add    $0x10,%esp
  end_op();
80106247:	e8 f4 d2 ff ff       	call   80103540 <end_op>
  return 0;
8010624c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106251:	c9                   	leave  
80106252:	c3                   	ret    

80106253 <sys_chdir>:

int
sys_chdir(void)
{
80106253:	55                   	push   %ebp
80106254:	89 e5                	mov    %esp,%ebp
80106256:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106259:	e8 56 d2 ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010625e:	83 ec 08             	sub    $0x8,%esp
80106261:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106264:	50                   	push   %eax
80106265:	6a 00                	push   $0x0
80106267:	e8 4e f4 ff ff       	call   801056ba <argstr>
8010626c:	83 c4 10             	add    $0x10,%esp
8010626f:	85 c0                	test   %eax,%eax
80106271:	78 18                	js     8010628b <sys_chdir+0x38>
80106273:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106276:	83 ec 0c             	sub    $0xc,%esp
80106279:	50                   	push   %eax
8010627a:	e8 44 c2 ff ff       	call   801024c3 <namei>
8010627f:	83 c4 10             	add    $0x10,%esp
80106282:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106285:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106289:	75 0c                	jne    80106297 <sys_chdir+0x44>
    end_op();
8010628b:	e8 b0 d2 ff ff       	call   80103540 <end_op>
    return -1;
80106290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106295:	eb 6e                	jmp    80106305 <sys_chdir+0xb2>
  }
  ilock(ip);
80106297:	83 ec 0c             	sub    $0xc,%esp
8010629a:	ff 75 f4             	pushl  -0xc(%ebp)
8010629d:	e8 69 b6 ff ff       	call   8010190b <ilock>
801062a2:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801062a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062a8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062ac:	66 83 f8 01          	cmp    $0x1,%ax
801062b0:	74 1a                	je     801062cc <sys_chdir+0x79>
    iunlockput(ip);
801062b2:	83 ec 0c             	sub    $0xc,%esp
801062b5:	ff 75 f4             	pushl  -0xc(%ebp)
801062b8:	e8 08 b9 ff ff       	call   80101bc5 <iunlockput>
801062bd:	83 c4 10             	add    $0x10,%esp
    end_op();
801062c0:	e8 7b d2 ff ff       	call   80103540 <end_op>
    return -1;
801062c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ca:	eb 39                	jmp    80106305 <sys_chdir+0xb2>
  }
  iunlock(ip);
801062cc:	83 ec 0c             	sub    $0xc,%esp
801062cf:	ff 75 f4             	pushl  -0xc(%ebp)
801062d2:	e8 8c b7 ff ff       	call   80101a63 <iunlock>
801062d7:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801062da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062e0:	8b 40 68             	mov    0x68(%eax),%eax
801062e3:	83 ec 0c             	sub    $0xc,%esp
801062e6:	50                   	push   %eax
801062e7:	e8 e9 b7 ff ff       	call   80101ad5 <iput>
801062ec:	83 c4 10             	add    $0x10,%esp
  end_op();
801062ef:	e8 4c d2 ff ff       	call   80103540 <end_op>
  proc->cwd = ip;
801062f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062fd:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106300:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106305:	c9                   	leave  
80106306:	c3                   	ret    

80106307 <sys_exec>:

int
sys_exec(void)
{
80106307:	55                   	push   %ebp
80106308:	89 e5                	mov    %esp,%ebp
8010630a:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106310:	83 ec 08             	sub    $0x8,%esp
80106313:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106316:	50                   	push   %eax
80106317:	6a 00                	push   $0x0
80106319:	e8 9c f3 ff ff       	call   801056ba <argstr>
8010631e:	83 c4 10             	add    $0x10,%esp
80106321:	85 c0                	test   %eax,%eax
80106323:	78 18                	js     8010633d <sys_exec+0x36>
80106325:	83 ec 08             	sub    $0x8,%esp
80106328:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010632e:	50                   	push   %eax
8010632f:	6a 01                	push   $0x1
80106331:	e8 ff f2 ff ff       	call   80105635 <argint>
80106336:	83 c4 10             	add    $0x10,%esp
80106339:	85 c0                	test   %eax,%eax
8010633b:	79 0a                	jns    80106347 <sys_exec+0x40>
    return -1;
8010633d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106342:	e9 c6 00 00 00       	jmp    8010640d <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106347:	83 ec 04             	sub    $0x4,%esp
8010634a:	68 80 00 00 00       	push   $0x80
8010634f:	6a 00                	push   $0x0
80106351:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106357:	50                   	push   %eax
80106358:	e8 b3 ef ff ff       	call   80105310 <memset>
8010635d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106360:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010636a:	83 f8 1f             	cmp    $0x1f,%eax
8010636d:	76 0a                	jbe    80106379 <sys_exec+0x72>
      return -1;
8010636f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106374:	e9 94 00 00 00       	jmp    8010640d <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010637c:	c1 e0 02             	shl    $0x2,%eax
8010637f:	89 c2                	mov    %eax,%edx
80106381:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106387:	01 c2                	add    %eax,%edx
80106389:	83 ec 08             	sub    $0x8,%esp
8010638c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106392:	50                   	push   %eax
80106393:	52                   	push   %edx
80106394:	e8 00 f2 ff ff       	call   80105599 <fetchint>
80106399:	83 c4 10             	add    $0x10,%esp
8010639c:	85 c0                	test   %eax,%eax
8010639e:	79 07                	jns    801063a7 <sys_exec+0xa0>
      return -1;
801063a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a5:	eb 66                	jmp    8010640d <sys_exec+0x106>
    if(uarg == 0){
801063a7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801063ad:	85 c0                	test   %eax,%eax
801063af:	75 27                	jne    801063d8 <sys_exec+0xd1>
      argv[i] = 0;
801063b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b4:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801063bb:	00 00 00 00 
      break;
801063bf:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801063c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063c3:	83 ec 08             	sub    $0x8,%esp
801063c6:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801063cc:	52                   	push   %edx
801063cd:	50                   	push   %eax
801063ce:	e8 83 a7 ff ff       	call   80100b56 <exec>
801063d3:	83 c4 10             	add    $0x10,%esp
801063d6:	eb 35                	jmp    8010640d <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801063d8:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801063de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063e1:	c1 e2 02             	shl    $0x2,%edx
801063e4:	01 c2                	add    %eax,%edx
801063e6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801063ec:	83 ec 08             	sub    $0x8,%esp
801063ef:	52                   	push   %edx
801063f0:	50                   	push   %eax
801063f1:	e8 dd f1 ff ff       	call   801055d3 <fetchstr>
801063f6:	83 c4 10             	add    $0x10,%esp
801063f9:	85 c0                	test   %eax,%eax
801063fb:	79 07                	jns    80106404 <sys_exec+0xfd>
      return -1;
801063fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106402:	eb 09                	jmp    8010640d <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106404:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106408:	e9 5a ff ff ff       	jmp    80106367 <sys_exec+0x60>
  return exec(path, argv);
}
8010640d:	c9                   	leave  
8010640e:	c3                   	ret    

8010640f <sys_pipe>:

int
sys_pipe(void)
{
8010640f:	55                   	push   %ebp
80106410:	89 e5                	mov    %esp,%ebp
80106412:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106415:	83 ec 04             	sub    $0x4,%esp
80106418:	6a 08                	push   $0x8
8010641a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010641d:	50                   	push   %eax
8010641e:	6a 00                	push   $0x0
80106420:	e8 38 f2 ff ff       	call   8010565d <argptr>
80106425:	83 c4 10             	add    $0x10,%esp
80106428:	85 c0                	test   %eax,%eax
8010642a:	79 0a                	jns    80106436 <sys_pipe+0x27>
    return -1;
8010642c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106431:	e9 af 00 00 00       	jmp    801064e5 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106436:	83 ec 08             	sub    $0x8,%esp
80106439:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010643c:	50                   	push   %eax
8010643d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106440:	50                   	push   %eax
80106441:	e8 47 db ff ff       	call   80103f8d <pipealloc>
80106446:	83 c4 10             	add    $0x10,%esp
80106449:	85 c0                	test   %eax,%eax
8010644b:	79 0a                	jns    80106457 <sys_pipe+0x48>
    return -1;
8010644d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106452:	e9 8e 00 00 00       	jmp    801064e5 <sys_pipe+0xd6>
  fd0 = -1;
80106457:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010645e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106461:	83 ec 0c             	sub    $0xc,%esp
80106464:	50                   	push   %eax
80106465:	e8 7c f3 ff ff       	call   801057e6 <fdalloc>
8010646a:	83 c4 10             	add    $0x10,%esp
8010646d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106470:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106474:	78 18                	js     8010648e <sys_pipe+0x7f>
80106476:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106479:	83 ec 0c             	sub    $0xc,%esp
8010647c:	50                   	push   %eax
8010647d:	e8 64 f3 ff ff       	call   801057e6 <fdalloc>
80106482:	83 c4 10             	add    $0x10,%esp
80106485:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010648c:	79 3f                	jns    801064cd <sys_pipe+0xbe>
    if(fd0 >= 0)
8010648e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106492:	78 14                	js     801064a8 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106494:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010649a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010649d:	83 c2 08             	add    $0x8,%edx
801064a0:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801064a7:	00 
    fileclose(rf);
801064a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064ab:	83 ec 0c             	sub    $0xc,%esp
801064ae:	50                   	push   %eax
801064af:	e8 82 ab ff ff       	call   80101036 <fileclose>
801064b4:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801064b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064ba:	83 ec 0c             	sub    $0xc,%esp
801064bd:	50                   	push   %eax
801064be:	e8 73 ab ff ff       	call   80101036 <fileclose>
801064c3:	83 c4 10             	add    $0x10,%esp
    return -1;
801064c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064cb:	eb 18                	jmp    801064e5 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801064cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064d3:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801064d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064d8:	8d 50 04             	lea    0x4(%eax),%edx
801064db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064de:	89 02                	mov    %eax,(%edx)
  return 0;
801064e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064e5:	c9                   	leave  
801064e6:	c3                   	ret    

801064e7 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
801064e7:	55                   	push   %ebp
801064e8:	89 e5                	mov    %esp,%ebp
801064ea:	83 ec 08             	sub    $0x8,%esp
801064ed:	8b 55 08             	mov    0x8(%ebp),%edx
801064f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801064f3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801064f7:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064fb:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
801064ff:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106503:	66 ef                	out    %ax,(%dx)
}
80106505:	90                   	nop
80106506:	c9                   	leave  
80106507:	c3                   	ret    

80106508 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106508:	55                   	push   %ebp
80106509:	89 e5                	mov    %esp,%ebp
8010650b:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010650e:	e8 9a e1 ff ff       	call   801046ad <fork>
}
80106513:	c9                   	leave  
80106514:	c3                   	ret    

80106515 <sys_exit>:


int
sys_exit(void)
{
80106515:	55                   	push   %ebp
80106516:	89 e5                	mov    %esp,%ebp
80106518:	83 ec 08             	sub    $0x8,%esp
  exit();
8010651b:	e8 1e e3 ff ff       	call   8010483e <exit>
  return 0;  // not reached
80106520:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106525:	c9                   	leave  
80106526:	c3                   	ret    

80106527 <sys_wait>:

int
sys_wait(void)
{
80106527:	55                   	push   %ebp
80106528:	89 e5                	mov    %esp,%ebp
8010652a:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010652d:	e8 47 e4 ff ff       	call   80104979 <wait>
}
80106532:	c9                   	leave  
80106533:	c3                   	ret    

80106534 <sys_kill>:

int
sys_kill(void)
{
80106534:	55                   	push   %ebp
80106535:	89 e5                	mov    %esp,%ebp
80106537:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010653a:	83 ec 08             	sub    $0x8,%esp
8010653d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106540:	50                   	push   %eax
80106541:	6a 00                	push   $0x0
80106543:	e8 ed f0 ff ff       	call   80105635 <argint>
80106548:	83 c4 10             	add    $0x10,%esp
8010654b:	85 c0                	test   %eax,%eax
8010654d:	79 07                	jns    80106556 <sys_kill+0x22>
    return -1;
8010654f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106554:	eb 0f                	jmp    80106565 <sys_kill+0x31>
  return kill(pid);
80106556:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106559:	83 ec 0c             	sub    $0xc,%esp
8010655c:	50                   	push   %eax
8010655d:	e8 33 e8 ff ff       	call   80104d95 <kill>
80106562:	83 c4 10             	add    $0x10,%esp
}
80106565:	c9                   	leave  
80106566:	c3                   	ret    

80106567 <sys_getpid>:

int
sys_getpid(void)
{
80106567:	55                   	push   %ebp
80106568:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010656a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106570:	8b 40 10             	mov    0x10(%eax),%eax
}
80106573:	5d                   	pop    %ebp
80106574:	c3                   	ret    

80106575 <sys_sbrk>:

int
sys_sbrk(void)
{
80106575:	55                   	push   %ebp
80106576:	89 e5                	mov    %esp,%ebp
80106578:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010657b:	83 ec 08             	sub    $0x8,%esp
8010657e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106581:	50                   	push   %eax
80106582:	6a 00                	push   $0x0
80106584:	e8 ac f0 ff ff       	call   80105635 <argint>
80106589:	83 c4 10             	add    $0x10,%esp
8010658c:	85 c0                	test   %eax,%eax
8010658e:	79 07                	jns    80106597 <sys_sbrk+0x22>
    return -1;
80106590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106595:	eb 28                	jmp    801065bf <sys_sbrk+0x4a>
  addr = proc->sz;
80106597:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010659d:	8b 00                	mov    (%eax),%eax
8010659f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801065a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065a5:	83 ec 0c             	sub    $0xc,%esp
801065a8:	50                   	push   %eax
801065a9:	e8 5c e0 ff ff       	call   8010460a <growproc>
801065ae:	83 c4 10             	add    $0x10,%esp
801065b1:	85 c0                	test   %eax,%eax
801065b3:	79 07                	jns    801065bc <sys_sbrk+0x47>
    return -1;
801065b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ba:	eb 03                	jmp    801065bf <sys_sbrk+0x4a>
  return addr;
801065bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801065bf:	c9                   	leave  
801065c0:	c3                   	ret    

801065c1 <sys_sleep>:

int
sys_sleep(void)
{
801065c1:	55                   	push   %ebp
801065c2:	89 e5                	mov    %esp,%ebp
801065c4:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801065c7:	83 ec 08             	sub    $0x8,%esp
801065ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065cd:	50                   	push   %eax
801065ce:	6a 00                	push   $0x0
801065d0:	e8 60 f0 ff ff       	call   80105635 <argint>
801065d5:	83 c4 10             	add    $0x10,%esp
801065d8:	85 c0                	test   %eax,%eax
801065da:	79 07                	jns    801065e3 <sys_sleep+0x22>
    return -1;
801065dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e1:	eb 77                	jmp    8010665a <sys_sleep+0x99>
  acquire(&tickslock);
801065e3:	83 ec 0c             	sub    $0xc,%esp
801065e6:	68 c0 4b 11 80       	push   $0x80114bc0
801065eb:	e8 bd ea ff ff       	call   801050ad <acquire>
801065f0:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801065f3:	a1 00 54 11 80       	mov    0x80115400,%eax
801065f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801065fb:	eb 39                	jmp    80106636 <sys_sleep+0x75>
    if(proc->killed){
801065fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106603:	8b 40 24             	mov    0x24(%eax),%eax
80106606:	85 c0                	test   %eax,%eax
80106608:	74 17                	je     80106621 <sys_sleep+0x60>
      release(&tickslock);
8010660a:	83 ec 0c             	sub    $0xc,%esp
8010660d:	68 c0 4b 11 80       	push   $0x80114bc0
80106612:	e8 fd ea ff ff       	call   80105114 <release>
80106617:	83 c4 10             	add    $0x10,%esp
      return -1;
8010661a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010661f:	eb 39                	jmp    8010665a <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106621:	83 ec 08             	sub    $0x8,%esp
80106624:	68 c0 4b 11 80       	push   $0x80114bc0
80106629:	68 00 54 11 80       	push   $0x80115400
8010662e:	e8 3d e6 ff ff       	call   80104c70 <sleep>
80106633:	83 c4 10             	add    $0x10,%esp

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106636:	a1 00 54 11 80       	mov    0x80115400,%eax
8010663b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010663e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106641:	39 d0                	cmp    %edx,%eax
80106643:	72 b8                	jb     801065fd <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106645:	83 ec 0c             	sub    $0xc,%esp
80106648:	68 c0 4b 11 80       	push   $0x80114bc0
8010664d:	e8 c2 ea ff ff       	call   80105114 <release>
80106652:	83 c4 10             	add    $0x10,%esp
  return 0;
80106655:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010665a:	c9                   	leave  
8010665b:	c3                   	ret    

8010665c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010665c:	55                   	push   %ebp
8010665d:	89 e5                	mov    %esp,%ebp
8010665f:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106662:	83 ec 0c             	sub    $0xc,%esp
80106665:	68 c0 4b 11 80       	push   $0x80114bc0
8010666a:	e8 3e ea ff ff       	call   801050ad <acquire>
8010666f:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106672:	a1 00 54 11 80       	mov    0x80115400,%eax
80106677:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010667a:	83 ec 0c             	sub    $0xc,%esp
8010667d:	68 c0 4b 11 80       	push   $0x80114bc0
80106682:	e8 8d ea ff ff       	call   80105114 <release>
80106687:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010668a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010668d:	c9                   	leave  
8010668e:	c3                   	ret    

8010668f <sys_halt>:
// signal to QEMU.
// Based on: http://pdos.csail.mit.edu/6.828/2012/homework/xv6-syscall.html
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
8010668f:	55                   	push   %ebp
80106690:	89 e5                	mov    %esp,%ebp
80106692:	83 ec 10             	sub    $0x10,%esp
  char *p = "Shutdown";
80106695:	c7 45 fc 26 8c 10 80 	movl   $0x80108c26,-0x4(%ebp)
  for( ; *p; p++)
8010669c:	eb 16                	jmp    801066b4 <sys_halt+0x25>
    outw(0xB004, 0x2000);
8010669e:	68 00 20 00 00       	push   $0x2000
801066a3:	68 04 b0 00 00       	push   $0xb004
801066a8:	e8 3a fe ff ff       	call   801064e7 <outw>
801066ad:	83 c4 08             	add    $0x8,%esp
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
  char *p = "Shutdown";
  for( ; *p; p++)
801066b0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801066b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801066b7:	0f b6 00             	movzbl (%eax),%eax
801066ba:	84 c0                	test   %al,%al
801066bc:	75 e0                	jne    8010669e <sys_halt+0xf>
    outw(0xB004, 0x2000);
  return 0;
801066be:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066c3:	c9                   	leave  
801066c4:	c3                   	ret    

801066c5 <sys_mprotect>:

int sys_mprotect(void)
{
801066c5:	55                   	push   %ebp
801066c6:	89 e5                	mov    %esp,%ebp
801066c8:	83 ec 18             	sub    $0x18,%esp
  int addr,len,prot;

  if(argint(0, &addr) <0)
801066cb:	83 ec 08             	sub    $0x8,%esp
801066ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066d1:	50                   	push   %eax
801066d2:	6a 00                	push   $0x0
801066d4:	e8 5c ef ff ff       	call   80105635 <argint>
801066d9:	83 c4 10             	add    $0x10,%esp
801066dc:	85 c0                	test   %eax,%eax
801066de:	79 07                	jns    801066e7 <sys_mprotect+0x22>
    return -1;
801066e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066e5:	eb 4f                	jmp    80106736 <sys_mprotect+0x71>
  if(argint(1,&len) <0)
801066e7:	83 ec 08             	sub    $0x8,%esp
801066ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066ed:	50                   	push   %eax
801066ee:	6a 01                	push   $0x1
801066f0:	e8 40 ef ff ff       	call   80105635 <argint>
801066f5:	83 c4 10             	add    $0x10,%esp
801066f8:	85 c0                	test   %eax,%eax
801066fa:	79 07                	jns    80106703 <sys_mprotect+0x3e>
    return -1;
801066fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106701:	eb 33                	jmp    80106736 <sys_mprotect+0x71>
  if(argint(2,&prot) <0)
80106703:	83 ec 08             	sub    $0x8,%esp
80106706:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106709:	50                   	push   %eax
8010670a:	6a 02                	push   $0x2
8010670c:	e8 24 ef ff ff       	call   80105635 <argint>
80106711:	83 c4 10             	add    $0x10,%esp
80106714:	85 c0                	test   %eax,%eax
80106716:	79 07                	jns    8010671f <sys_mprotect+0x5a>
    return -1;
80106718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671d:	eb 17                	jmp    80106736 <sys_mprotect+0x71>

  return mprotect((void*)addr,len,prot);
8010671f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106722:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106725:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80106728:	83 ec 04             	sub    $0x4,%esp
8010672b:	52                   	push   %edx
8010672c:	50                   	push   %eax
8010672d:	51                   	push   %ecx
8010672e:	e8 b3 1b 00 00       	call   801082e6 <mprotect>
80106733:	83 c4 10             	add    $0x10,%esp
}
80106736:	c9                   	leave  
80106737:	c3                   	ret    

80106738 <sys_signal_register>:

int sys_signal_register(void)
{
80106738:	55                   	push   %ebp
80106739:	89 e5                	mov    %esp,%ebp
8010673b:	83 ec 18             	sub    $0x18,%esp
    uint signum;
    sighandler_t handler;
    int n;

    if (argint(0, &n) < 0)
8010673e:	83 ec 08             	sub    $0x8,%esp
80106741:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106744:	50                   	push   %eax
80106745:	6a 00                	push   $0x0
80106747:	e8 e9 ee ff ff       	call   80105635 <argint>
8010674c:	83 c4 10             	add    $0x10,%esp
8010674f:	85 c0                	test   %eax,%eax
80106751:	79 07                	jns    8010675a <sys_signal_register+0x22>
      return -1;
80106753:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106758:	eb 3a                	jmp    80106794 <sys_signal_register+0x5c>
    signum = (uint) n;
8010675a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010675d:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (argint(1, &n) < 0)
80106760:	83 ec 08             	sub    $0x8,%esp
80106763:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106766:	50                   	push   %eax
80106767:	6a 01                	push   $0x1
80106769:	e8 c7 ee ff ff       	call   80105635 <argint>
8010676e:	83 c4 10             	add    $0x10,%esp
80106771:	85 c0                	test   %eax,%eax
80106773:	79 07                	jns    8010677c <sys_signal_register+0x44>
      return -1;
80106775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010677a:	eb 18                	jmp    80106794 <sys_signal_register+0x5c>
    handler = (sighandler_t) n;
8010677c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010677f:	89 45 f0             	mov    %eax,-0x10(%ebp)

    return (int) signal_register_handler(signum, handler);
80106782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106785:	83 ec 08             	sub    $0x8,%esp
80106788:	ff 75 f0             	pushl  -0x10(%ebp)
8010678b:	50                   	push   %eax
8010678c:	e8 80 e8 ff ff       	call   80105011 <signal_register_handler>
80106791:	83 c4 10             	add    $0x10,%esp
}
80106794:	c9                   	leave  
80106795:	c3                   	ret    

80106796 <sys_signal_restorer>:

int sys_signal_restorer(void)
{
80106796:	55                   	push   %ebp
80106797:	89 e5                	mov    %esp,%ebp
80106799:	83 ec 18             	sub    $0x18,%esp
    int restorer_addr;
    if (argint(0, &restorer_addr) < 0)
8010679c:	83 ec 08             	sub    $0x8,%esp
8010679f:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067a2:	50                   	push   %eax
801067a3:	6a 00                	push   $0x0
801067a5:	e8 8b ee ff ff       	call   80105635 <argint>
801067aa:	83 c4 10             	add    $0x10,%esp
801067ad:	85 c0                	test   %eax,%eax
801067af:	79 07                	jns    801067b8 <sys_signal_restorer+0x22>
      return -1;
801067b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067b6:	eb 14                	jmp    801067cc <sys_signal_restorer+0x36>

    proc->restorer_addr = (uint) restorer_addr;
801067b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067c1:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

    return 0;
801067c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067cc:	c9                   	leave  
801067cd:	c3                   	ret    

801067ce <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801067ce:	55                   	push   %ebp
801067cf:	89 e5                	mov    %esp,%ebp
801067d1:	83 ec 08             	sub    $0x8,%esp
801067d4:	8b 55 08             	mov    0x8(%ebp),%edx
801067d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801067da:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801067de:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067e1:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801067e5:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801067e9:	ee                   	out    %al,(%dx)
}
801067ea:	90                   	nop
801067eb:	c9                   	leave  
801067ec:	c3                   	ret    

801067ed <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801067ed:	55                   	push   %ebp
801067ee:	89 e5                	mov    %esp,%ebp
801067f0:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801067f3:	6a 34                	push   $0x34
801067f5:	6a 43                	push   $0x43
801067f7:	e8 d2 ff ff ff       	call   801067ce <outb>
801067fc:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801067ff:	68 9c 00 00 00       	push   $0x9c
80106804:	6a 40                	push   $0x40
80106806:	e8 c3 ff ff ff       	call   801067ce <outb>
8010680b:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
8010680e:	6a 2e                	push   $0x2e
80106810:	6a 40                	push   $0x40
80106812:	e8 b7 ff ff ff       	call   801067ce <outb>
80106817:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
8010681a:	83 ec 0c             	sub    $0xc,%esp
8010681d:	6a 00                	push   $0x0
8010681f:	e8 53 d6 ff ff       	call   80103e77 <picenable>
80106824:	83 c4 10             	add    $0x10,%esp
}
80106827:	90                   	nop
80106828:	c9                   	leave  
80106829:	c3                   	ret    

8010682a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010682a:	1e                   	push   %ds
  pushl %es
8010682b:	06                   	push   %es
  pushl %fs
8010682c:	0f a0                	push   %fs
  pushl %gs
8010682e:	0f a8                	push   %gs
  pushal
80106830:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106831:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106835:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106837:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106839:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010683d:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
8010683f:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106841:	54                   	push   %esp
  call trap
80106842:	e8 d7 01 00 00       	call   80106a1e <trap>
  addl $4, %esp
80106847:	83 c4 04             	add    $0x4,%esp

8010684a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010684a:	61                   	popa   
  popl %gs
8010684b:	0f a9                	pop    %gs
  popl %fs
8010684d:	0f a1                	pop    %fs
  popl %es
8010684f:	07                   	pop    %es
  popl %ds
80106850:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106851:	83 c4 08             	add    $0x8,%esp
  iret
80106854:	cf                   	iret   

80106855 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106855:	55                   	push   %ebp
80106856:	89 e5                	mov    %esp,%ebp
80106858:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010685b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010685e:	83 e8 01             	sub    $0x1,%eax
80106861:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106865:	8b 45 08             	mov    0x8(%ebp),%eax
80106868:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010686c:	8b 45 08             	mov    0x8(%ebp),%eax
8010686f:	c1 e8 10             	shr    $0x10,%eax
80106872:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106876:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106879:	0f 01 18             	lidtl  (%eax)
}
8010687c:	90                   	nop
8010687d:	c9                   	leave  
8010687e:	c3                   	ret    

8010687f <rcr2>:
  asm volatile("movl %eax,%cr3");
}

static inline uint
rcr2(void)
{
8010687f:	55                   	push   %ebp
80106880:	89 e5                	mov    %esp,%ebp
80106882:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106885:	0f 20 d0             	mov    %cr2,%eax
80106888:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010688b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010688e:	c9                   	leave  
8010688f:	c3                   	ret    

80106890 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106896:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010689d:	e9 c3 00 00 00       	jmp    80106965 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801068a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068a5:	8b 04 85 a4 b0 10 80 	mov    -0x7fef4f5c(,%eax,4),%eax
801068ac:	89 c2                	mov    %eax,%edx
801068ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b1:	66 89 14 c5 00 4c 11 	mov    %dx,-0x7feeb400(,%eax,8)
801068b8:	80 
801068b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068bc:	66 c7 04 c5 02 4c 11 	movw   $0x8,-0x7feeb3fe(,%eax,8)
801068c3:	80 08 00 
801068c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c9:	0f b6 14 c5 04 4c 11 	movzbl -0x7feeb3fc(,%eax,8),%edx
801068d0:	80 
801068d1:	83 e2 e0             	and    $0xffffffe0,%edx
801068d4:	88 14 c5 04 4c 11 80 	mov    %dl,-0x7feeb3fc(,%eax,8)
801068db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068de:	0f b6 14 c5 04 4c 11 	movzbl -0x7feeb3fc(,%eax,8),%edx
801068e5:	80 
801068e6:	83 e2 1f             	and    $0x1f,%edx
801068e9:	88 14 c5 04 4c 11 80 	mov    %dl,-0x7feeb3fc(,%eax,8)
801068f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068f3:	0f b6 14 c5 05 4c 11 	movzbl -0x7feeb3fb(,%eax,8),%edx
801068fa:	80 
801068fb:	83 e2 f0             	and    $0xfffffff0,%edx
801068fe:	83 ca 0e             	or     $0xe,%edx
80106901:	88 14 c5 05 4c 11 80 	mov    %dl,-0x7feeb3fb(,%eax,8)
80106908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010690b:	0f b6 14 c5 05 4c 11 	movzbl -0x7feeb3fb(,%eax,8),%edx
80106912:	80 
80106913:	83 e2 ef             	and    $0xffffffef,%edx
80106916:	88 14 c5 05 4c 11 80 	mov    %dl,-0x7feeb3fb(,%eax,8)
8010691d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106920:	0f b6 14 c5 05 4c 11 	movzbl -0x7feeb3fb(,%eax,8),%edx
80106927:	80 
80106928:	83 e2 9f             	and    $0xffffff9f,%edx
8010692b:	88 14 c5 05 4c 11 80 	mov    %dl,-0x7feeb3fb(,%eax,8)
80106932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106935:	0f b6 14 c5 05 4c 11 	movzbl -0x7feeb3fb(,%eax,8),%edx
8010693c:	80 
8010693d:	83 ca 80             	or     $0xffffff80,%edx
80106940:	88 14 c5 05 4c 11 80 	mov    %dl,-0x7feeb3fb(,%eax,8)
80106947:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010694a:	8b 04 85 a4 b0 10 80 	mov    -0x7fef4f5c(,%eax,4),%eax
80106951:	c1 e8 10             	shr    $0x10,%eax
80106954:	89 c2                	mov    %eax,%edx
80106956:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106959:	66 89 14 c5 06 4c 11 	mov    %dx,-0x7feeb3fa(,%eax,8)
80106960:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106961:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106965:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010696c:	0f 8e 30 ff ff ff    	jle    801068a2 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106972:	a1 a4 b1 10 80       	mov    0x8010b1a4,%eax
80106977:	66 a3 00 4e 11 80    	mov    %ax,0x80114e00
8010697d:	66 c7 05 02 4e 11 80 	movw   $0x8,0x80114e02
80106984:	08 00 
80106986:	0f b6 05 04 4e 11 80 	movzbl 0x80114e04,%eax
8010698d:	83 e0 e0             	and    $0xffffffe0,%eax
80106990:	a2 04 4e 11 80       	mov    %al,0x80114e04
80106995:	0f b6 05 04 4e 11 80 	movzbl 0x80114e04,%eax
8010699c:	83 e0 1f             	and    $0x1f,%eax
8010699f:	a2 04 4e 11 80       	mov    %al,0x80114e04
801069a4:	0f b6 05 05 4e 11 80 	movzbl 0x80114e05,%eax
801069ab:	83 c8 0f             	or     $0xf,%eax
801069ae:	a2 05 4e 11 80       	mov    %al,0x80114e05
801069b3:	0f b6 05 05 4e 11 80 	movzbl 0x80114e05,%eax
801069ba:	83 e0 ef             	and    $0xffffffef,%eax
801069bd:	a2 05 4e 11 80       	mov    %al,0x80114e05
801069c2:	0f b6 05 05 4e 11 80 	movzbl 0x80114e05,%eax
801069c9:	83 c8 60             	or     $0x60,%eax
801069cc:	a2 05 4e 11 80       	mov    %al,0x80114e05
801069d1:	0f b6 05 05 4e 11 80 	movzbl 0x80114e05,%eax
801069d8:	83 c8 80             	or     $0xffffff80,%eax
801069db:	a2 05 4e 11 80       	mov    %al,0x80114e05
801069e0:	a1 a4 b1 10 80       	mov    0x8010b1a4,%eax
801069e5:	c1 e8 10             	shr    $0x10,%eax
801069e8:	66 a3 06 4e 11 80    	mov    %ax,0x80114e06

  initlock(&tickslock, "time");
801069ee:	83 ec 08             	sub    $0x8,%esp
801069f1:	68 30 8c 10 80       	push   $0x80108c30
801069f6:	68 c0 4b 11 80       	push   $0x80114bc0
801069fb:	e8 8b e6 ff ff       	call   8010508b <initlock>
80106a00:	83 c4 10             	add    $0x10,%esp
}
80106a03:	90                   	nop
80106a04:	c9                   	leave  
80106a05:	c3                   	ret    

80106a06 <idtinit>:

void
idtinit(void)
{
80106a06:	55                   	push   %ebp
80106a07:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106a09:	68 00 08 00 00       	push   $0x800
80106a0e:	68 00 4c 11 80       	push   $0x80114c00
80106a13:	e8 3d fe ff ff       	call   80106855 <lidt>
80106a18:	83 c4 08             	add    $0x8,%esp
}
80106a1b:	90                   	nop
80106a1c:	c9                   	leave  
80106a1d:	c3                   	ret    

80106a1e <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106a1e:	55                   	push   %ebp
80106a1f:	89 e5                	mov    %esp,%ebp
80106a21:	57                   	push   %edi
80106a22:	56                   	push   %esi
80106a23:	53                   	push   %ebx
80106a24:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106a27:	8b 45 08             	mov    0x8(%ebp),%eax
80106a2a:	8b 40 30             	mov    0x30(%eax),%eax
80106a2d:	83 f8 40             	cmp    $0x40,%eax
80106a30:	75 3e                	jne    80106a70 <trap+0x52>
    if(proc->killed)
80106a32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a38:	8b 40 24             	mov    0x24(%eax),%eax
80106a3b:	85 c0                	test   %eax,%eax
80106a3d:	74 05                	je     80106a44 <trap+0x26>
      exit();
80106a3f:	e8 fa dd ff ff       	call   8010483e <exit>
    proc->tf = tf;
80106a44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a4a:	8b 55 08             	mov    0x8(%ebp),%edx
80106a4d:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106a50:	e8 96 ec ff ff       	call   801056eb <syscall>
    if(proc->killed)
80106a55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a5b:	8b 40 24             	mov    0x24(%eax),%eax
80106a5e:	85 c0                	test   %eax,%eax
80106a60:	0f 84 3f 02 00 00    	je     80106ca5 <trap+0x287>
      exit();
80106a66:	e8 d3 dd ff ff       	call   8010483e <exit>
    return;
80106a6b:	e9 35 02 00 00       	jmp    80106ca5 <trap+0x287>
  }

  switch(tf->trapno){
80106a70:	8b 45 08             	mov    0x8(%ebp),%eax
80106a73:	8b 40 30             	mov    0x30(%eax),%eax
80106a76:	83 f8 3f             	cmp    $0x3f,%eax
80106a79:	0f 87 e7 00 00 00    	ja     80106b66 <trap+0x148>
80106a7f:	8b 04 85 d8 8c 10 80 	mov    -0x7fef7328(,%eax,4),%eax
80106a86:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106a88:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a8e:	0f b6 00             	movzbl (%eax),%eax
80106a91:	84 c0                	test   %al,%al
80106a93:	75 3d                	jne    80106ad2 <trap+0xb4>
      acquire(&tickslock);
80106a95:	83 ec 0c             	sub    $0xc,%esp
80106a98:	68 c0 4b 11 80       	push   $0x80114bc0
80106a9d:	e8 0b e6 ff ff       	call   801050ad <acquire>
80106aa2:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106aa5:	a1 00 54 11 80       	mov    0x80115400,%eax
80106aaa:	83 c0 01             	add    $0x1,%eax
80106aad:	a3 00 54 11 80       	mov    %eax,0x80115400
      wakeup(&ticks);
80106ab2:	83 ec 0c             	sub    $0xc,%esp
80106ab5:	68 00 54 11 80       	push   $0x80115400
80106aba:	e8 9f e2 ff ff       	call   80104d5e <wakeup>
80106abf:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106ac2:	83 ec 0c             	sub    $0xc,%esp
80106ac5:	68 c0 4b 11 80       	push   $0x80114bc0
80106aca:	e8 45 e6 ff ff       	call   80105114 <release>
80106acf:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106ad2:	e8 ad c4 ff ff       	call   80102f84 <lapiceoi>
    break;
80106ad7:	e9 43 01 00 00       	jmp    80106c1f <trap+0x201>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106adc:	e8 b6 bc ff ff       	call   80102797 <ideintr>
    lapiceoi();
80106ae1:	e8 9e c4 ff ff       	call   80102f84 <lapiceoi>
    break;
80106ae6:	e9 34 01 00 00       	jmp    80106c1f <trap+0x201>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106aeb:	e8 96 c2 ff ff       	call   80102d86 <kbdintr>
    lapiceoi();
80106af0:	e8 8f c4 ff ff       	call   80102f84 <lapiceoi>
    break;
80106af5:	e9 25 01 00 00       	jmp    80106c1f <trap+0x201>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106afa:	e8 87 03 00 00       	call   80106e86 <uartintr>
    lapiceoi();
80106aff:	e8 80 c4 ff ff       	call   80102f84 <lapiceoi>
    break;
80106b04:	e9 16 01 00 00       	jmp    80106c1f <trap+0x201>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b09:	8b 45 08             	mov    0x8(%ebp),%eax
80106b0c:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b12:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b16:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106b19:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106b1f:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b22:	0f b6 c0             	movzbl %al,%eax
80106b25:	51                   	push   %ecx
80106b26:	52                   	push   %edx
80106b27:	50                   	push   %eax
80106b28:	68 38 8c 10 80       	push   $0x80108c38
80106b2d:	e8 94 98 ff ff       	call   801003c6 <cprintf>
80106b32:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106b35:	e8 4a c4 ff ff       	call   80102f84 <lapiceoi>
    break;
80106b3a:	e9 e0 00 00 00       	jmp    80106c1f <trap+0x201>

   case T_DIVIDE:
      if (proc->handlers[SIGFPE] != (sighandler_t) -1) {
80106b3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b45:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106b4b:	83 f8 ff             	cmp    $0xffffffff,%eax
80106b4e:	0f 84 ca 00 00 00    	je     80106c1e <trap+0x200>
        signal_deliver(SIGFPE);
80106b54:	83 ec 0c             	sub    $0xc,%esp
80106b57:	6a 01                	push   $0x1
80106b59:	e8 ba e3 ff ff       	call   80104f18 <signal_deliver>
80106b5e:	83 c4 10             	add    $0x10,%esp
        break;
80106b61:	e9 b9 00 00 00       	jmp    80106c1f <trap+0x201>
    case T_PGFLT:
      break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106b66:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b6c:	85 c0                	test   %eax,%eax
80106b6e:	74 11                	je     80106b81 <trap+0x163>
80106b70:	8b 45 08             	mov    0x8(%ebp),%eax
80106b73:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106b77:	0f b7 c0             	movzwl %ax,%eax
80106b7a:	83 e0 03             	and    $0x3,%eax
80106b7d:	85 c0                	test   %eax,%eax
80106b7f:	75 40                	jne    80106bc1 <trap+0x1a3>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106b81:	e8 f9 fc ff ff       	call   8010687f <rcr2>
80106b86:	89 c3                	mov    %eax,%ebx
80106b88:	8b 45 08             	mov    0x8(%ebp),%eax
80106b8b:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106b8e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106b94:	0f b6 00             	movzbl (%eax),%eax

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106b97:	0f b6 d0             	movzbl %al,%edx
80106b9a:	8b 45 08             	mov    0x8(%ebp),%eax
80106b9d:	8b 40 30             	mov    0x30(%eax),%eax
80106ba0:	83 ec 0c             	sub    $0xc,%esp
80106ba3:	53                   	push   %ebx
80106ba4:	51                   	push   %ecx
80106ba5:	52                   	push   %edx
80106ba6:	50                   	push   %eax
80106ba7:	68 5c 8c 10 80       	push   $0x80108c5c
80106bac:	e8 15 98 ff ff       	call   801003c6 <cprintf>
80106bb1:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106bb4:	83 ec 0c             	sub    $0xc,%esp
80106bb7:	68 8e 8c 10 80       	push   $0x80108c8e
80106bbc:	e8 a5 99 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106bc1:	e8 b9 fc ff ff       	call   8010687f <rcr2>
80106bc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106bc9:	8b 45 08             	mov    0x8(%ebp),%eax
80106bcc:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106bcf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106bd5:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106bd8:	0f b6 d8             	movzbl %al,%ebx
80106bdb:	8b 45 08             	mov    0x8(%ebp),%eax
80106bde:	8b 48 34             	mov    0x34(%eax),%ecx
80106be1:	8b 45 08             	mov    0x8(%ebp),%eax
80106be4:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106be7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bed:	8d 78 6c             	lea    0x6c(%eax),%edi
80106bf0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106bf6:	8b 40 10             	mov    0x10(%eax),%eax
80106bf9:	ff 75 e4             	pushl  -0x1c(%ebp)
80106bfc:	56                   	push   %esi
80106bfd:	53                   	push   %ebx
80106bfe:	51                   	push   %ecx
80106bff:	52                   	push   %edx
80106c00:	57                   	push   %edi
80106c01:	50                   	push   %eax
80106c02:	68 94 8c 10 80       	push   $0x80108c94
80106c07:	e8 ba 97 ff ff       	call   801003c6 <cprintf>
80106c0c:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
            rcr2());
    proc->killed = 1;
80106c0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c15:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106c1c:	eb 01                	jmp    80106c1f <trap+0x201>
        signal_deliver(SIGFPE);
        break;
      }
    //handle pgfault with mem_protect
    case T_PGFLT:
      break;
80106c1e:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106c1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c25:	85 c0                	test   %eax,%eax
80106c27:	74 24                	je     80106c4d <trap+0x22f>
80106c29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c2f:	8b 40 24             	mov    0x24(%eax),%eax
80106c32:	85 c0                	test   %eax,%eax
80106c34:	74 17                	je     80106c4d <trap+0x22f>
80106c36:	8b 45 08             	mov    0x8(%ebp),%eax
80106c39:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106c3d:	0f b7 c0             	movzwl %ax,%eax
80106c40:	83 e0 03             	and    $0x3,%eax
80106c43:	83 f8 03             	cmp    $0x3,%eax
80106c46:	75 05                	jne    80106c4d <trap+0x22f>
    exit();
80106c48:	e8 f1 db ff ff       	call   8010483e <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106c4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c53:	85 c0                	test   %eax,%eax
80106c55:	74 1e                	je     80106c75 <trap+0x257>
80106c57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c5d:	8b 40 0c             	mov    0xc(%eax),%eax
80106c60:	83 f8 04             	cmp    $0x4,%eax
80106c63:	75 10                	jne    80106c75 <trap+0x257>
80106c65:	8b 45 08             	mov    0x8(%ebp),%eax
80106c68:	8b 40 30             	mov    0x30(%eax),%eax
80106c6b:	83 f8 20             	cmp    $0x20,%eax
80106c6e:	75 05                	jne    80106c75 <trap+0x257>
    yield();
80106c70:	e8 8f df ff ff       	call   80104c04 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106c75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c7b:	85 c0                	test   %eax,%eax
80106c7d:	74 27                	je     80106ca6 <trap+0x288>
80106c7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c85:	8b 40 24             	mov    0x24(%eax),%eax
80106c88:	85 c0                	test   %eax,%eax
80106c8a:	74 1a                	je     80106ca6 <trap+0x288>
80106c8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c8f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106c93:	0f b7 c0             	movzwl %ax,%eax
80106c96:	83 e0 03             	and    $0x3,%eax
80106c99:	83 f8 03             	cmp    $0x3,%eax
80106c9c:	75 08                	jne    80106ca6 <trap+0x288>
    exit();
80106c9e:	e8 9b db ff ff       	call   8010483e <exit>
80106ca3:	eb 01                	jmp    80106ca6 <trap+0x288>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106ca5:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ca9:	5b                   	pop    %ebx
80106caa:	5e                   	pop    %esi
80106cab:	5f                   	pop    %edi
80106cac:	5d                   	pop    %ebp
80106cad:	c3                   	ret    

80106cae <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106cae:	55                   	push   %ebp
80106caf:	89 e5                	mov    %esp,%ebp
80106cb1:	83 ec 14             	sub    $0x14,%esp
80106cb4:	8b 45 08             	mov    0x8(%ebp),%eax
80106cb7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106cbb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106cbf:	89 c2                	mov    %eax,%edx
80106cc1:	ec                   	in     (%dx),%al
80106cc2:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106cc5:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106cc9:	c9                   	leave  
80106cca:	c3                   	ret    

80106ccb <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106ccb:	55                   	push   %ebp
80106ccc:	89 e5                	mov    %esp,%ebp
80106cce:	83 ec 08             	sub    $0x8,%esp
80106cd1:	8b 55 08             	mov    0x8(%ebp),%edx
80106cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cd7:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106cdb:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106cde:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106ce2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106ce6:	ee                   	out    %al,(%dx)
}
80106ce7:	90                   	nop
80106ce8:	c9                   	leave  
80106ce9:	c3                   	ret    

80106cea <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106cea:	55                   	push   %ebp
80106ceb:	89 e5                	mov    %esp,%ebp
80106ced:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106cf0:	6a 00                	push   $0x0
80106cf2:	68 fa 03 00 00       	push   $0x3fa
80106cf7:	e8 cf ff ff ff       	call   80106ccb <outb>
80106cfc:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106cff:	68 80 00 00 00       	push   $0x80
80106d04:	68 fb 03 00 00       	push   $0x3fb
80106d09:	e8 bd ff ff ff       	call   80106ccb <outb>
80106d0e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106d11:	6a 0c                	push   $0xc
80106d13:	68 f8 03 00 00       	push   $0x3f8
80106d18:	e8 ae ff ff ff       	call   80106ccb <outb>
80106d1d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106d20:	6a 00                	push   $0x0
80106d22:	68 f9 03 00 00       	push   $0x3f9
80106d27:	e8 9f ff ff ff       	call   80106ccb <outb>
80106d2c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106d2f:	6a 03                	push   $0x3
80106d31:	68 fb 03 00 00       	push   $0x3fb
80106d36:	e8 90 ff ff ff       	call   80106ccb <outb>
80106d3b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106d3e:	6a 00                	push   $0x0
80106d40:	68 fc 03 00 00       	push   $0x3fc
80106d45:	e8 81 ff ff ff       	call   80106ccb <outb>
80106d4a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106d4d:	6a 01                	push   $0x1
80106d4f:	68 f9 03 00 00       	push   $0x3f9
80106d54:	e8 72 ff ff ff       	call   80106ccb <outb>
80106d59:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106d5c:	68 fd 03 00 00       	push   $0x3fd
80106d61:	e8 48 ff ff ff       	call   80106cae <inb>
80106d66:	83 c4 04             	add    $0x4,%esp
80106d69:	3c ff                	cmp    $0xff,%al
80106d6b:	74 6e                	je     80106ddb <uartinit+0xf1>
    return;
  uart = 1;
80106d6d:	c7 05 6c b6 10 80 01 	movl   $0x1,0x8010b66c
80106d74:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106d77:	68 fa 03 00 00       	push   $0x3fa
80106d7c:	e8 2d ff ff ff       	call   80106cae <inb>
80106d81:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106d84:	68 f8 03 00 00       	push   $0x3f8
80106d89:	e8 20 ff ff ff       	call   80106cae <inb>
80106d8e:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106d91:	83 ec 0c             	sub    $0xc,%esp
80106d94:	6a 04                	push   $0x4
80106d96:	e8 dc d0 ff ff       	call   80103e77 <picenable>
80106d9b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106d9e:	83 ec 08             	sub    $0x8,%esp
80106da1:	6a 00                	push   $0x0
80106da3:	6a 04                	push   $0x4
80106da5:	e8 8f bc ff ff       	call   80102a39 <ioapicenable>
80106daa:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106dad:	c7 45 f4 d8 8d 10 80 	movl   $0x80108dd8,-0xc(%ebp)
80106db4:	eb 19                	jmp    80106dcf <uartinit+0xe5>
    uartputc(*p);
80106db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106db9:	0f b6 00             	movzbl (%eax),%eax
80106dbc:	0f be c0             	movsbl %al,%eax
80106dbf:	83 ec 0c             	sub    $0xc,%esp
80106dc2:	50                   	push   %eax
80106dc3:	e8 16 00 00 00       	call   80106dde <uartputc>
80106dc8:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106dcb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dd2:	0f b6 00             	movzbl (%eax),%eax
80106dd5:	84 c0                	test   %al,%al
80106dd7:	75 dd                	jne    80106db6 <uartinit+0xcc>
80106dd9:	eb 01                	jmp    80106ddc <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106ddb:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106ddc:	c9                   	leave  
80106ddd:	c3                   	ret    

80106dde <uartputc>:

void
uartputc(int c)
{
80106dde:	55                   	push   %ebp
80106ddf:	89 e5                	mov    %esp,%ebp
80106de1:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106de4:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106de9:	85 c0                	test   %eax,%eax
80106deb:	74 53                	je     80106e40 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ded:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106df4:	eb 11                	jmp    80106e07 <uartputc+0x29>
    microdelay(10);
80106df6:	83 ec 0c             	sub    $0xc,%esp
80106df9:	6a 0a                	push   $0xa
80106dfb:	e8 9f c1 ff ff       	call   80102f9f <microdelay>
80106e00:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106e03:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e07:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106e0b:	7f 1a                	jg     80106e27 <uartputc+0x49>
80106e0d:	83 ec 0c             	sub    $0xc,%esp
80106e10:	68 fd 03 00 00       	push   $0x3fd
80106e15:	e8 94 fe ff ff       	call   80106cae <inb>
80106e1a:	83 c4 10             	add    $0x10,%esp
80106e1d:	0f b6 c0             	movzbl %al,%eax
80106e20:	83 e0 20             	and    $0x20,%eax
80106e23:	85 c0                	test   %eax,%eax
80106e25:	74 cf                	je     80106df6 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106e27:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2a:	0f b6 c0             	movzbl %al,%eax
80106e2d:	83 ec 08             	sub    $0x8,%esp
80106e30:	50                   	push   %eax
80106e31:	68 f8 03 00 00       	push   $0x3f8
80106e36:	e8 90 fe ff ff       	call   80106ccb <outb>
80106e3b:	83 c4 10             	add    $0x10,%esp
80106e3e:	eb 01                	jmp    80106e41 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106e40:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106e41:	c9                   	leave  
80106e42:	c3                   	ret    

80106e43 <uartgetc>:

static int
uartgetc(void)
{
80106e43:	55                   	push   %ebp
80106e44:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106e46:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106e4b:	85 c0                	test   %eax,%eax
80106e4d:	75 07                	jne    80106e56 <uartgetc+0x13>
    return -1;
80106e4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e54:	eb 2e                	jmp    80106e84 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106e56:	68 fd 03 00 00       	push   $0x3fd
80106e5b:	e8 4e fe ff ff       	call   80106cae <inb>
80106e60:	83 c4 04             	add    $0x4,%esp
80106e63:	0f b6 c0             	movzbl %al,%eax
80106e66:	83 e0 01             	and    $0x1,%eax
80106e69:	85 c0                	test   %eax,%eax
80106e6b:	75 07                	jne    80106e74 <uartgetc+0x31>
    return -1;
80106e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e72:	eb 10                	jmp    80106e84 <uartgetc+0x41>
  return inb(COM1+0);
80106e74:	68 f8 03 00 00       	push   $0x3f8
80106e79:	e8 30 fe ff ff       	call   80106cae <inb>
80106e7e:	83 c4 04             	add    $0x4,%esp
80106e81:	0f b6 c0             	movzbl %al,%eax
}
80106e84:	c9                   	leave  
80106e85:	c3                   	ret    

80106e86 <uartintr>:

void
uartintr(void)
{
80106e86:	55                   	push   %ebp
80106e87:	89 e5                	mov    %esp,%ebp
80106e89:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106e8c:	83 ec 0c             	sub    $0xc,%esp
80106e8f:	68 43 6e 10 80       	push   $0x80106e43
80106e94:	e8 44 99 ff ff       	call   801007dd <consoleintr>
80106e99:	83 c4 10             	add    $0x10,%esp
}
80106e9c:	90                   	nop
80106e9d:	c9                   	leave  
80106e9e:	c3                   	ret    

80106e9f <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $0
80106ea1:	6a 00                	push   $0x0
  jmp alltraps
80106ea3:	e9 82 f9 ff ff       	jmp    8010682a <alltraps>

80106ea8 <vector1>:
.globl vector1
vector1:
  pushl $0
80106ea8:	6a 00                	push   $0x0
  pushl $1
80106eaa:	6a 01                	push   $0x1
  jmp alltraps
80106eac:	e9 79 f9 ff ff       	jmp    8010682a <alltraps>

80106eb1 <vector2>:
.globl vector2
vector2:
  pushl $0
80106eb1:	6a 00                	push   $0x0
  pushl $2
80106eb3:	6a 02                	push   $0x2
  jmp alltraps
80106eb5:	e9 70 f9 ff ff       	jmp    8010682a <alltraps>

80106eba <vector3>:
.globl vector3
vector3:
  pushl $0
80106eba:	6a 00                	push   $0x0
  pushl $3
80106ebc:	6a 03                	push   $0x3
  jmp alltraps
80106ebe:	e9 67 f9 ff ff       	jmp    8010682a <alltraps>

80106ec3 <vector4>:
.globl vector4
vector4:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $4
80106ec5:	6a 04                	push   $0x4
  jmp alltraps
80106ec7:	e9 5e f9 ff ff       	jmp    8010682a <alltraps>

80106ecc <vector5>:
.globl vector5
vector5:
  pushl $0
80106ecc:	6a 00                	push   $0x0
  pushl $5
80106ece:	6a 05                	push   $0x5
  jmp alltraps
80106ed0:	e9 55 f9 ff ff       	jmp    8010682a <alltraps>

80106ed5 <vector6>:
.globl vector6
vector6:
  pushl $0
80106ed5:	6a 00                	push   $0x0
  pushl $6
80106ed7:	6a 06                	push   $0x6
  jmp alltraps
80106ed9:	e9 4c f9 ff ff       	jmp    8010682a <alltraps>

80106ede <vector7>:
.globl vector7
vector7:
  pushl $0
80106ede:	6a 00                	push   $0x0
  pushl $7
80106ee0:	6a 07                	push   $0x7
  jmp alltraps
80106ee2:	e9 43 f9 ff ff       	jmp    8010682a <alltraps>

80106ee7 <vector8>:
.globl vector8
vector8:
  pushl $8
80106ee7:	6a 08                	push   $0x8
  jmp alltraps
80106ee9:	e9 3c f9 ff ff       	jmp    8010682a <alltraps>

80106eee <vector9>:
.globl vector9
vector9:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $9
80106ef0:	6a 09                	push   $0x9
  jmp alltraps
80106ef2:	e9 33 f9 ff ff       	jmp    8010682a <alltraps>

80106ef7 <vector10>:
.globl vector10
vector10:
  pushl $10
80106ef7:	6a 0a                	push   $0xa
  jmp alltraps
80106ef9:	e9 2c f9 ff ff       	jmp    8010682a <alltraps>

80106efe <vector11>:
.globl vector11
vector11:
  pushl $11
80106efe:	6a 0b                	push   $0xb
  jmp alltraps
80106f00:	e9 25 f9 ff ff       	jmp    8010682a <alltraps>

80106f05 <vector12>:
.globl vector12
vector12:
  pushl $12
80106f05:	6a 0c                	push   $0xc
  jmp alltraps
80106f07:	e9 1e f9 ff ff       	jmp    8010682a <alltraps>

80106f0c <vector13>:
.globl vector13
vector13:
  pushl $13
80106f0c:	6a 0d                	push   $0xd
  jmp alltraps
80106f0e:	e9 17 f9 ff ff       	jmp    8010682a <alltraps>

80106f13 <vector14>:
.globl vector14
vector14:
  pushl $14
80106f13:	6a 0e                	push   $0xe
  jmp alltraps
80106f15:	e9 10 f9 ff ff       	jmp    8010682a <alltraps>

80106f1a <vector15>:
.globl vector15
vector15:
  pushl $0
80106f1a:	6a 00                	push   $0x0
  pushl $15
80106f1c:	6a 0f                	push   $0xf
  jmp alltraps
80106f1e:	e9 07 f9 ff ff       	jmp    8010682a <alltraps>

80106f23 <vector16>:
.globl vector16
vector16:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $16
80106f25:	6a 10                	push   $0x10
  jmp alltraps
80106f27:	e9 fe f8 ff ff       	jmp    8010682a <alltraps>

80106f2c <vector17>:
.globl vector17
vector17:
  pushl $17
80106f2c:	6a 11                	push   $0x11
  jmp alltraps
80106f2e:	e9 f7 f8 ff ff       	jmp    8010682a <alltraps>

80106f33 <vector18>:
.globl vector18
vector18:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $18
80106f35:	6a 12                	push   $0x12
  jmp alltraps
80106f37:	e9 ee f8 ff ff       	jmp    8010682a <alltraps>

80106f3c <vector19>:
.globl vector19
vector19:
  pushl $0
80106f3c:	6a 00                	push   $0x0
  pushl $19
80106f3e:	6a 13                	push   $0x13
  jmp alltraps
80106f40:	e9 e5 f8 ff ff       	jmp    8010682a <alltraps>

80106f45 <vector20>:
.globl vector20
vector20:
  pushl $0
80106f45:	6a 00                	push   $0x0
  pushl $20
80106f47:	6a 14                	push   $0x14
  jmp alltraps
80106f49:	e9 dc f8 ff ff       	jmp    8010682a <alltraps>

80106f4e <vector21>:
.globl vector21
vector21:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $21
80106f50:	6a 15                	push   $0x15
  jmp alltraps
80106f52:	e9 d3 f8 ff ff       	jmp    8010682a <alltraps>

80106f57 <vector22>:
.globl vector22
vector22:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $22
80106f59:	6a 16                	push   $0x16
  jmp alltraps
80106f5b:	e9 ca f8 ff ff       	jmp    8010682a <alltraps>

80106f60 <vector23>:
.globl vector23
vector23:
  pushl $0
80106f60:	6a 00                	push   $0x0
  pushl $23
80106f62:	6a 17                	push   $0x17
  jmp alltraps
80106f64:	e9 c1 f8 ff ff       	jmp    8010682a <alltraps>

80106f69 <vector24>:
.globl vector24
vector24:
  pushl $0
80106f69:	6a 00                	push   $0x0
  pushl $24
80106f6b:	6a 18                	push   $0x18
  jmp alltraps
80106f6d:	e9 b8 f8 ff ff       	jmp    8010682a <alltraps>

80106f72 <vector25>:
.globl vector25
vector25:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $25
80106f74:	6a 19                	push   $0x19
  jmp alltraps
80106f76:	e9 af f8 ff ff       	jmp    8010682a <alltraps>

80106f7b <vector26>:
.globl vector26
vector26:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $26
80106f7d:	6a 1a                	push   $0x1a
  jmp alltraps
80106f7f:	e9 a6 f8 ff ff       	jmp    8010682a <alltraps>

80106f84 <vector27>:
.globl vector27
vector27:
  pushl $0
80106f84:	6a 00                	push   $0x0
  pushl $27
80106f86:	6a 1b                	push   $0x1b
  jmp alltraps
80106f88:	e9 9d f8 ff ff       	jmp    8010682a <alltraps>

80106f8d <vector28>:
.globl vector28
vector28:
  pushl $0
80106f8d:	6a 00                	push   $0x0
  pushl $28
80106f8f:	6a 1c                	push   $0x1c
  jmp alltraps
80106f91:	e9 94 f8 ff ff       	jmp    8010682a <alltraps>

80106f96 <vector29>:
.globl vector29
vector29:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $29
80106f98:	6a 1d                	push   $0x1d
  jmp alltraps
80106f9a:	e9 8b f8 ff ff       	jmp    8010682a <alltraps>

80106f9f <vector30>:
.globl vector30
vector30:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $30
80106fa1:	6a 1e                	push   $0x1e
  jmp alltraps
80106fa3:	e9 82 f8 ff ff       	jmp    8010682a <alltraps>

80106fa8 <vector31>:
.globl vector31
vector31:
  pushl $0
80106fa8:	6a 00                	push   $0x0
  pushl $31
80106faa:	6a 1f                	push   $0x1f
  jmp alltraps
80106fac:	e9 79 f8 ff ff       	jmp    8010682a <alltraps>

80106fb1 <vector32>:
.globl vector32
vector32:
  pushl $0
80106fb1:	6a 00                	push   $0x0
  pushl $32
80106fb3:	6a 20                	push   $0x20
  jmp alltraps
80106fb5:	e9 70 f8 ff ff       	jmp    8010682a <alltraps>

80106fba <vector33>:
.globl vector33
vector33:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $33
80106fbc:	6a 21                	push   $0x21
  jmp alltraps
80106fbe:	e9 67 f8 ff ff       	jmp    8010682a <alltraps>

80106fc3 <vector34>:
.globl vector34
vector34:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $34
80106fc5:	6a 22                	push   $0x22
  jmp alltraps
80106fc7:	e9 5e f8 ff ff       	jmp    8010682a <alltraps>

80106fcc <vector35>:
.globl vector35
vector35:
  pushl $0
80106fcc:	6a 00                	push   $0x0
  pushl $35
80106fce:	6a 23                	push   $0x23
  jmp alltraps
80106fd0:	e9 55 f8 ff ff       	jmp    8010682a <alltraps>

80106fd5 <vector36>:
.globl vector36
vector36:
  pushl $0
80106fd5:	6a 00                	push   $0x0
  pushl $36
80106fd7:	6a 24                	push   $0x24
  jmp alltraps
80106fd9:	e9 4c f8 ff ff       	jmp    8010682a <alltraps>

80106fde <vector37>:
.globl vector37
vector37:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $37
80106fe0:	6a 25                	push   $0x25
  jmp alltraps
80106fe2:	e9 43 f8 ff ff       	jmp    8010682a <alltraps>

80106fe7 <vector38>:
.globl vector38
vector38:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $38
80106fe9:	6a 26                	push   $0x26
  jmp alltraps
80106feb:	e9 3a f8 ff ff       	jmp    8010682a <alltraps>

80106ff0 <vector39>:
.globl vector39
vector39:
  pushl $0
80106ff0:	6a 00                	push   $0x0
  pushl $39
80106ff2:	6a 27                	push   $0x27
  jmp alltraps
80106ff4:	e9 31 f8 ff ff       	jmp    8010682a <alltraps>

80106ff9 <vector40>:
.globl vector40
vector40:
  pushl $0
80106ff9:	6a 00                	push   $0x0
  pushl $40
80106ffb:	6a 28                	push   $0x28
  jmp alltraps
80106ffd:	e9 28 f8 ff ff       	jmp    8010682a <alltraps>

80107002 <vector41>:
.globl vector41
vector41:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $41
80107004:	6a 29                	push   $0x29
  jmp alltraps
80107006:	e9 1f f8 ff ff       	jmp    8010682a <alltraps>

8010700b <vector42>:
.globl vector42
vector42:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $42
8010700d:	6a 2a                	push   $0x2a
  jmp alltraps
8010700f:	e9 16 f8 ff ff       	jmp    8010682a <alltraps>

80107014 <vector43>:
.globl vector43
vector43:
  pushl $0
80107014:	6a 00                	push   $0x0
  pushl $43
80107016:	6a 2b                	push   $0x2b
  jmp alltraps
80107018:	e9 0d f8 ff ff       	jmp    8010682a <alltraps>

8010701d <vector44>:
.globl vector44
vector44:
  pushl $0
8010701d:	6a 00                	push   $0x0
  pushl $44
8010701f:	6a 2c                	push   $0x2c
  jmp alltraps
80107021:	e9 04 f8 ff ff       	jmp    8010682a <alltraps>

80107026 <vector45>:
.globl vector45
vector45:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $45
80107028:	6a 2d                	push   $0x2d
  jmp alltraps
8010702a:	e9 fb f7 ff ff       	jmp    8010682a <alltraps>

8010702f <vector46>:
.globl vector46
vector46:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $46
80107031:	6a 2e                	push   $0x2e
  jmp alltraps
80107033:	e9 f2 f7 ff ff       	jmp    8010682a <alltraps>

80107038 <vector47>:
.globl vector47
vector47:
  pushl $0
80107038:	6a 00                	push   $0x0
  pushl $47
8010703a:	6a 2f                	push   $0x2f
  jmp alltraps
8010703c:	e9 e9 f7 ff ff       	jmp    8010682a <alltraps>

80107041 <vector48>:
.globl vector48
vector48:
  pushl $0
80107041:	6a 00                	push   $0x0
  pushl $48
80107043:	6a 30                	push   $0x30
  jmp alltraps
80107045:	e9 e0 f7 ff ff       	jmp    8010682a <alltraps>

8010704a <vector49>:
.globl vector49
vector49:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $49
8010704c:	6a 31                	push   $0x31
  jmp alltraps
8010704e:	e9 d7 f7 ff ff       	jmp    8010682a <alltraps>

80107053 <vector50>:
.globl vector50
vector50:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $50
80107055:	6a 32                	push   $0x32
  jmp alltraps
80107057:	e9 ce f7 ff ff       	jmp    8010682a <alltraps>

8010705c <vector51>:
.globl vector51
vector51:
  pushl $0
8010705c:	6a 00                	push   $0x0
  pushl $51
8010705e:	6a 33                	push   $0x33
  jmp alltraps
80107060:	e9 c5 f7 ff ff       	jmp    8010682a <alltraps>

80107065 <vector52>:
.globl vector52
vector52:
  pushl $0
80107065:	6a 00                	push   $0x0
  pushl $52
80107067:	6a 34                	push   $0x34
  jmp alltraps
80107069:	e9 bc f7 ff ff       	jmp    8010682a <alltraps>

8010706e <vector53>:
.globl vector53
vector53:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $53
80107070:	6a 35                	push   $0x35
  jmp alltraps
80107072:	e9 b3 f7 ff ff       	jmp    8010682a <alltraps>

80107077 <vector54>:
.globl vector54
vector54:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $54
80107079:	6a 36                	push   $0x36
  jmp alltraps
8010707b:	e9 aa f7 ff ff       	jmp    8010682a <alltraps>

80107080 <vector55>:
.globl vector55
vector55:
  pushl $0
80107080:	6a 00                	push   $0x0
  pushl $55
80107082:	6a 37                	push   $0x37
  jmp alltraps
80107084:	e9 a1 f7 ff ff       	jmp    8010682a <alltraps>

80107089 <vector56>:
.globl vector56
vector56:
  pushl $0
80107089:	6a 00                	push   $0x0
  pushl $56
8010708b:	6a 38                	push   $0x38
  jmp alltraps
8010708d:	e9 98 f7 ff ff       	jmp    8010682a <alltraps>

80107092 <vector57>:
.globl vector57
vector57:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $57
80107094:	6a 39                	push   $0x39
  jmp alltraps
80107096:	e9 8f f7 ff ff       	jmp    8010682a <alltraps>

8010709b <vector58>:
.globl vector58
vector58:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $58
8010709d:	6a 3a                	push   $0x3a
  jmp alltraps
8010709f:	e9 86 f7 ff ff       	jmp    8010682a <alltraps>

801070a4 <vector59>:
.globl vector59
vector59:
  pushl $0
801070a4:	6a 00                	push   $0x0
  pushl $59
801070a6:	6a 3b                	push   $0x3b
  jmp alltraps
801070a8:	e9 7d f7 ff ff       	jmp    8010682a <alltraps>

801070ad <vector60>:
.globl vector60
vector60:
  pushl $0
801070ad:	6a 00                	push   $0x0
  pushl $60
801070af:	6a 3c                	push   $0x3c
  jmp alltraps
801070b1:	e9 74 f7 ff ff       	jmp    8010682a <alltraps>

801070b6 <vector61>:
.globl vector61
vector61:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $61
801070b8:	6a 3d                	push   $0x3d
  jmp alltraps
801070ba:	e9 6b f7 ff ff       	jmp    8010682a <alltraps>

801070bf <vector62>:
.globl vector62
vector62:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $62
801070c1:	6a 3e                	push   $0x3e
  jmp alltraps
801070c3:	e9 62 f7 ff ff       	jmp    8010682a <alltraps>

801070c8 <vector63>:
.globl vector63
vector63:
  pushl $0
801070c8:	6a 00                	push   $0x0
  pushl $63
801070ca:	6a 3f                	push   $0x3f
  jmp alltraps
801070cc:	e9 59 f7 ff ff       	jmp    8010682a <alltraps>

801070d1 <vector64>:
.globl vector64
vector64:
  pushl $0
801070d1:	6a 00                	push   $0x0
  pushl $64
801070d3:	6a 40                	push   $0x40
  jmp alltraps
801070d5:	e9 50 f7 ff ff       	jmp    8010682a <alltraps>

801070da <vector65>:
.globl vector65
vector65:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $65
801070dc:	6a 41                	push   $0x41
  jmp alltraps
801070de:	e9 47 f7 ff ff       	jmp    8010682a <alltraps>

801070e3 <vector66>:
.globl vector66
vector66:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $66
801070e5:	6a 42                	push   $0x42
  jmp alltraps
801070e7:	e9 3e f7 ff ff       	jmp    8010682a <alltraps>

801070ec <vector67>:
.globl vector67
vector67:
  pushl $0
801070ec:	6a 00                	push   $0x0
  pushl $67
801070ee:	6a 43                	push   $0x43
  jmp alltraps
801070f0:	e9 35 f7 ff ff       	jmp    8010682a <alltraps>

801070f5 <vector68>:
.globl vector68
vector68:
  pushl $0
801070f5:	6a 00                	push   $0x0
  pushl $68
801070f7:	6a 44                	push   $0x44
  jmp alltraps
801070f9:	e9 2c f7 ff ff       	jmp    8010682a <alltraps>

801070fe <vector69>:
.globl vector69
vector69:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $69
80107100:	6a 45                	push   $0x45
  jmp alltraps
80107102:	e9 23 f7 ff ff       	jmp    8010682a <alltraps>

80107107 <vector70>:
.globl vector70
vector70:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $70
80107109:	6a 46                	push   $0x46
  jmp alltraps
8010710b:	e9 1a f7 ff ff       	jmp    8010682a <alltraps>

80107110 <vector71>:
.globl vector71
vector71:
  pushl $0
80107110:	6a 00                	push   $0x0
  pushl $71
80107112:	6a 47                	push   $0x47
  jmp alltraps
80107114:	e9 11 f7 ff ff       	jmp    8010682a <alltraps>

80107119 <vector72>:
.globl vector72
vector72:
  pushl $0
80107119:	6a 00                	push   $0x0
  pushl $72
8010711b:	6a 48                	push   $0x48
  jmp alltraps
8010711d:	e9 08 f7 ff ff       	jmp    8010682a <alltraps>

80107122 <vector73>:
.globl vector73
vector73:
  pushl $0
80107122:	6a 00                	push   $0x0
  pushl $73
80107124:	6a 49                	push   $0x49
  jmp alltraps
80107126:	e9 ff f6 ff ff       	jmp    8010682a <alltraps>

8010712b <vector74>:
.globl vector74
vector74:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $74
8010712d:	6a 4a                	push   $0x4a
  jmp alltraps
8010712f:	e9 f6 f6 ff ff       	jmp    8010682a <alltraps>

80107134 <vector75>:
.globl vector75
vector75:
  pushl $0
80107134:	6a 00                	push   $0x0
  pushl $75
80107136:	6a 4b                	push   $0x4b
  jmp alltraps
80107138:	e9 ed f6 ff ff       	jmp    8010682a <alltraps>

8010713d <vector76>:
.globl vector76
vector76:
  pushl $0
8010713d:	6a 00                	push   $0x0
  pushl $76
8010713f:	6a 4c                	push   $0x4c
  jmp alltraps
80107141:	e9 e4 f6 ff ff       	jmp    8010682a <alltraps>

80107146 <vector77>:
.globl vector77
vector77:
  pushl $0
80107146:	6a 00                	push   $0x0
  pushl $77
80107148:	6a 4d                	push   $0x4d
  jmp alltraps
8010714a:	e9 db f6 ff ff       	jmp    8010682a <alltraps>

8010714f <vector78>:
.globl vector78
vector78:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $78
80107151:	6a 4e                	push   $0x4e
  jmp alltraps
80107153:	e9 d2 f6 ff ff       	jmp    8010682a <alltraps>

80107158 <vector79>:
.globl vector79
vector79:
  pushl $0
80107158:	6a 00                	push   $0x0
  pushl $79
8010715a:	6a 4f                	push   $0x4f
  jmp alltraps
8010715c:	e9 c9 f6 ff ff       	jmp    8010682a <alltraps>

80107161 <vector80>:
.globl vector80
vector80:
  pushl $0
80107161:	6a 00                	push   $0x0
  pushl $80
80107163:	6a 50                	push   $0x50
  jmp alltraps
80107165:	e9 c0 f6 ff ff       	jmp    8010682a <alltraps>

8010716a <vector81>:
.globl vector81
vector81:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $81
8010716c:	6a 51                	push   $0x51
  jmp alltraps
8010716e:	e9 b7 f6 ff ff       	jmp    8010682a <alltraps>

80107173 <vector82>:
.globl vector82
vector82:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $82
80107175:	6a 52                	push   $0x52
  jmp alltraps
80107177:	e9 ae f6 ff ff       	jmp    8010682a <alltraps>

8010717c <vector83>:
.globl vector83
vector83:
  pushl $0
8010717c:	6a 00                	push   $0x0
  pushl $83
8010717e:	6a 53                	push   $0x53
  jmp alltraps
80107180:	e9 a5 f6 ff ff       	jmp    8010682a <alltraps>

80107185 <vector84>:
.globl vector84
vector84:
  pushl $0
80107185:	6a 00                	push   $0x0
  pushl $84
80107187:	6a 54                	push   $0x54
  jmp alltraps
80107189:	e9 9c f6 ff ff       	jmp    8010682a <alltraps>

8010718e <vector85>:
.globl vector85
vector85:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $85
80107190:	6a 55                	push   $0x55
  jmp alltraps
80107192:	e9 93 f6 ff ff       	jmp    8010682a <alltraps>

80107197 <vector86>:
.globl vector86
vector86:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $86
80107199:	6a 56                	push   $0x56
  jmp alltraps
8010719b:	e9 8a f6 ff ff       	jmp    8010682a <alltraps>

801071a0 <vector87>:
.globl vector87
vector87:
  pushl $0
801071a0:	6a 00                	push   $0x0
  pushl $87
801071a2:	6a 57                	push   $0x57
  jmp alltraps
801071a4:	e9 81 f6 ff ff       	jmp    8010682a <alltraps>

801071a9 <vector88>:
.globl vector88
vector88:
  pushl $0
801071a9:	6a 00                	push   $0x0
  pushl $88
801071ab:	6a 58                	push   $0x58
  jmp alltraps
801071ad:	e9 78 f6 ff ff       	jmp    8010682a <alltraps>

801071b2 <vector89>:
.globl vector89
vector89:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $89
801071b4:	6a 59                	push   $0x59
  jmp alltraps
801071b6:	e9 6f f6 ff ff       	jmp    8010682a <alltraps>

801071bb <vector90>:
.globl vector90
vector90:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $90
801071bd:	6a 5a                	push   $0x5a
  jmp alltraps
801071bf:	e9 66 f6 ff ff       	jmp    8010682a <alltraps>

801071c4 <vector91>:
.globl vector91
vector91:
  pushl $0
801071c4:	6a 00                	push   $0x0
  pushl $91
801071c6:	6a 5b                	push   $0x5b
  jmp alltraps
801071c8:	e9 5d f6 ff ff       	jmp    8010682a <alltraps>

801071cd <vector92>:
.globl vector92
vector92:
  pushl $0
801071cd:	6a 00                	push   $0x0
  pushl $92
801071cf:	6a 5c                	push   $0x5c
  jmp alltraps
801071d1:	e9 54 f6 ff ff       	jmp    8010682a <alltraps>

801071d6 <vector93>:
.globl vector93
vector93:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $93
801071d8:	6a 5d                	push   $0x5d
  jmp alltraps
801071da:	e9 4b f6 ff ff       	jmp    8010682a <alltraps>

801071df <vector94>:
.globl vector94
vector94:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $94
801071e1:	6a 5e                	push   $0x5e
  jmp alltraps
801071e3:	e9 42 f6 ff ff       	jmp    8010682a <alltraps>

801071e8 <vector95>:
.globl vector95
vector95:
  pushl $0
801071e8:	6a 00                	push   $0x0
  pushl $95
801071ea:	6a 5f                	push   $0x5f
  jmp alltraps
801071ec:	e9 39 f6 ff ff       	jmp    8010682a <alltraps>

801071f1 <vector96>:
.globl vector96
vector96:
  pushl $0
801071f1:	6a 00                	push   $0x0
  pushl $96
801071f3:	6a 60                	push   $0x60
  jmp alltraps
801071f5:	e9 30 f6 ff ff       	jmp    8010682a <alltraps>

801071fa <vector97>:
.globl vector97
vector97:
  pushl $0
801071fa:	6a 00                	push   $0x0
  pushl $97
801071fc:	6a 61                	push   $0x61
  jmp alltraps
801071fe:	e9 27 f6 ff ff       	jmp    8010682a <alltraps>

80107203 <vector98>:
.globl vector98
vector98:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $98
80107205:	6a 62                	push   $0x62
  jmp alltraps
80107207:	e9 1e f6 ff ff       	jmp    8010682a <alltraps>

8010720c <vector99>:
.globl vector99
vector99:
  pushl $0
8010720c:	6a 00                	push   $0x0
  pushl $99
8010720e:	6a 63                	push   $0x63
  jmp alltraps
80107210:	e9 15 f6 ff ff       	jmp    8010682a <alltraps>

80107215 <vector100>:
.globl vector100
vector100:
  pushl $0
80107215:	6a 00                	push   $0x0
  pushl $100
80107217:	6a 64                	push   $0x64
  jmp alltraps
80107219:	e9 0c f6 ff ff       	jmp    8010682a <alltraps>

8010721e <vector101>:
.globl vector101
vector101:
  pushl $0
8010721e:	6a 00                	push   $0x0
  pushl $101
80107220:	6a 65                	push   $0x65
  jmp alltraps
80107222:	e9 03 f6 ff ff       	jmp    8010682a <alltraps>

80107227 <vector102>:
.globl vector102
vector102:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $102
80107229:	6a 66                	push   $0x66
  jmp alltraps
8010722b:	e9 fa f5 ff ff       	jmp    8010682a <alltraps>

80107230 <vector103>:
.globl vector103
vector103:
  pushl $0
80107230:	6a 00                	push   $0x0
  pushl $103
80107232:	6a 67                	push   $0x67
  jmp alltraps
80107234:	e9 f1 f5 ff ff       	jmp    8010682a <alltraps>

80107239 <vector104>:
.globl vector104
vector104:
  pushl $0
80107239:	6a 00                	push   $0x0
  pushl $104
8010723b:	6a 68                	push   $0x68
  jmp alltraps
8010723d:	e9 e8 f5 ff ff       	jmp    8010682a <alltraps>

80107242 <vector105>:
.globl vector105
vector105:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $105
80107244:	6a 69                	push   $0x69
  jmp alltraps
80107246:	e9 df f5 ff ff       	jmp    8010682a <alltraps>

8010724b <vector106>:
.globl vector106
vector106:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $106
8010724d:	6a 6a                	push   $0x6a
  jmp alltraps
8010724f:	e9 d6 f5 ff ff       	jmp    8010682a <alltraps>

80107254 <vector107>:
.globl vector107
vector107:
  pushl $0
80107254:	6a 00                	push   $0x0
  pushl $107
80107256:	6a 6b                	push   $0x6b
  jmp alltraps
80107258:	e9 cd f5 ff ff       	jmp    8010682a <alltraps>

8010725d <vector108>:
.globl vector108
vector108:
  pushl $0
8010725d:	6a 00                	push   $0x0
  pushl $108
8010725f:	6a 6c                	push   $0x6c
  jmp alltraps
80107261:	e9 c4 f5 ff ff       	jmp    8010682a <alltraps>

80107266 <vector109>:
.globl vector109
vector109:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $109
80107268:	6a 6d                	push   $0x6d
  jmp alltraps
8010726a:	e9 bb f5 ff ff       	jmp    8010682a <alltraps>

8010726f <vector110>:
.globl vector110
vector110:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $110
80107271:	6a 6e                	push   $0x6e
  jmp alltraps
80107273:	e9 b2 f5 ff ff       	jmp    8010682a <alltraps>

80107278 <vector111>:
.globl vector111
vector111:
  pushl $0
80107278:	6a 00                	push   $0x0
  pushl $111
8010727a:	6a 6f                	push   $0x6f
  jmp alltraps
8010727c:	e9 a9 f5 ff ff       	jmp    8010682a <alltraps>

80107281 <vector112>:
.globl vector112
vector112:
  pushl $0
80107281:	6a 00                	push   $0x0
  pushl $112
80107283:	6a 70                	push   $0x70
  jmp alltraps
80107285:	e9 a0 f5 ff ff       	jmp    8010682a <alltraps>

8010728a <vector113>:
.globl vector113
vector113:
  pushl $0
8010728a:	6a 00                	push   $0x0
  pushl $113
8010728c:	6a 71                	push   $0x71
  jmp alltraps
8010728e:	e9 97 f5 ff ff       	jmp    8010682a <alltraps>

80107293 <vector114>:
.globl vector114
vector114:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $114
80107295:	6a 72                	push   $0x72
  jmp alltraps
80107297:	e9 8e f5 ff ff       	jmp    8010682a <alltraps>

8010729c <vector115>:
.globl vector115
vector115:
  pushl $0
8010729c:	6a 00                	push   $0x0
  pushl $115
8010729e:	6a 73                	push   $0x73
  jmp alltraps
801072a0:	e9 85 f5 ff ff       	jmp    8010682a <alltraps>

801072a5 <vector116>:
.globl vector116
vector116:
  pushl $0
801072a5:	6a 00                	push   $0x0
  pushl $116
801072a7:	6a 74                	push   $0x74
  jmp alltraps
801072a9:	e9 7c f5 ff ff       	jmp    8010682a <alltraps>

801072ae <vector117>:
.globl vector117
vector117:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $117
801072b0:	6a 75                	push   $0x75
  jmp alltraps
801072b2:	e9 73 f5 ff ff       	jmp    8010682a <alltraps>

801072b7 <vector118>:
.globl vector118
vector118:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $118
801072b9:	6a 76                	push   $0x76
  jmp alltraps
801072bb:	e9 6a f5 ff ff       	jmp    8010682a <alltraps>

801072c0 <vector119>:
.globl vector119
vector119:
  pushl $0
801072c0:	6a 00                	push   $0x0
  pushl $119
801072c2:	6a 77                	push   $0x77
  jmp alltraps
801072c4:	e9 61 f5 ff ff       	jmp    8010682a <alltraps>

801072c9 <vector120>:
.globl vector120
vector120:
  pushl $0
801072c9:	6a 00                	push   $0x0
  pushl $120
801072cb:	6a 78                	push   $0x78
  jmp alltraps
801072cd:	e9 58 f5 ff ff       	jmp    8010682a <alltraps>

801072d2 <vector121>:
.globl vector121
vector121:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $121
801072d4:	6a 79                	push   $0x79
  jmp alltraps
801072d6:	e9 4f f5 ff ff       	jmp    8010682a <alltraps>

801072db <vector122>:
.globl vector122
vector122:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $122
801072dd:	6a 7a                	push   $0x7a
  jmp alltraps
801072df:	e9 46 f5 ff ff       	jmp    8010682a <alltraps>

801072e4 <vector123>:
.globl vector123
vector123:
  pushl $0
801072e4:	6a 00                	push   $0x0
  pushl $123
801072e6:	6a 7b                	push   $0x7b
  jmp alltraps
801072e8:	e9 3d f5 ff ff       	jmp    8010682a <alltraps>

801072ed <vector124>:
.globl vector124
vector124:
  pushl $0
801072ed:	6a 00                	push   $0x0
  pushl $124
801072ef:	6a 7c                	push   $0x7c
  jmp alltraps
801072f1:	e9 34 f5 ff ff       	jmp    8010682a <alltraps>

801072f6 <vector125>:
.globl vector125
vector125:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $125
801072f8:	6a 7d                	push   $0x7d
  jmp alltraps
801072fa:	e9 2b f5 ff ff       	jmp    8010682a <alltraps>

801072ff <vector126>:
.globl vector126
vector126:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $126
80107301:	6a 7e                	push   $0x7e
  jmp alltraps
80107303:	e9 22 f5 ff ff       	jmp    8010682a <alltraps>

80107308 <vector127>:
.globl vector127
vector127:
  pushl $0
80107308:	6a 00                	push   $0x0
  pushl $127
8010730a:	6a 7f                	push   $0x7f
  jmp alltraps
8010730c:	e9 19 f5 ff ff       	jmp    8010682a <alltraps>

80107311 <vector128>:
.globl vector128
vector128:
  pushl $0
80107311:	6a 00                	push   $0x0
  pushl $128
80107313:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107318:	e9 0d f5 ff ff       	jmp    8010682a <alltraps>

8010731d <vector129>:
.globl vector129
vector129:
  pushl $0
8010731d:	6a 00                	push   $0x0
  pushl $129
8010731f:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107324:	e9 01 f5 ff ff       	jmp    8010682a <alltraps>

80107329 <vector130>:
.globl vector130
vector130:
  pushl $0
80107329:	6a 00                	push   $0x0
  pushl $130
8010732b:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107330:	e9 f5 f4 ff ff       	jmp    8010682a <alltraps>

80107335 <vector131>:
.globl vector131
vector131:
  pushl $0
80107335:	6a 00                	push   $0x0
  pushl $131
80107337:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010733c:	e9 e9 f4 ff ff       	jmp    8010682a <alltraps>

80107341 <vector132>:
.globl vector132
vector132:
  pushl $0
80107341:	6a 00                	push   $0x0
  pushl $132
80107343:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107348:	e9 dd f4 ff ff       	jmp    8010682a <alltraps>

8010734d <vector133>:
.globl vector133
vector133:
  pushl $0
8010734d:	6a 00                	push   $0x0
  pushl $133
8010734f:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107354:	e9 d1 f4 ff ff       	jmp    8010682a <alltraps>

80107359 <vector134>:
.globl vector134
vector134:
  pushl $0
80107359:	6a 00                	push   $0x0
  pushl $134
8010735b:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107360:	e9 c5 f4 ff ff       	jmp    8010682a <alltraps>

80107365 <vector135>:
.globl vector135
vector135:
  pushl $0
80107365:	6a 00                	push   $0x0
  pushl $135
80107367:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010736c:	e9 b9 f4 ff ff       	jmp    8010682a <alltraps>

80107371 <vector136>:
.globl vector136
vector136:
  pushl $0
80107371:	6a 00                	push   $0x0
  pushl $136
80107373:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107378:	e9 ad f4 ff ff       	jmp    8010682a <alltraps>

8010737d <vector137>:
.globl vector137
vector137:
  pushl $0
8010737d:	6a 00                	push   $0x0
  pushl $137
8010737f:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107384:	e9 a1 f4 ff ff       	jmp    8010682a <alltraps>

80107389 <vector138>:
.globl vector138
vector138:
  pushl $0
80107389:	6a 00                	push   $0x0
  pushl $138
8010738b:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107390:	e9 95 f4 ff ff       	jmp    8010682a <alltraps>

80107395 <vector139>:
.globl vector139
vector139:
  pushl $0
80107395:	6a 00                	push   $0x0
  pushl $139
80107397:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010739c:	e9 89 f4 ff ff       	jmp    8010682a <alltraps>

801073a1 <vector140>:
.globl vector140
vector140:
  pushl $0
801073a1:	6a 00                	push   $0x0
  pushl $140
801073a3:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801073a8:	e9 7d f4 ff ff       	jmp    8010682a <alltraps>

801073ad <vector141>:
.globl vector141
vector141:
  pushl $0
801073ad:	6a 00                	push   $0x0
  pushl $141
801073af:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801073b4:	e9 71 f4 ff ff       	jmp    8010682a <alltraps>

801073b9 <vector142>:
.globl vector142
vector142:
  pushl $0
801073b9:	6a 00                	push   $0x0
  pushl $142
801073bb:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801073c0:	e9 65 f4 ff ff       	jmp    8010682a <alltraps>

801073c5 <vector143>:
.globl vector143
vector143:
  pushl $0
801073c5:	6a 00                	push   $0x0
  pushl $143
801073c7:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801073cc:	e9 59 f4 ff ff       	jmp    8010682a <alltraps>

801073d1 <vector144>:
.globl vector144
vector144:
  pushl $0
801073d1:	6a 00                	push   $0x0
  pushl $144
801073d3:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801073d8:	e9 4d f4 ff ff       	jmp    8010682a <alltraps>

801073dd <vector145>:
.globl vector145
vector145:
  pushl $0
801073dd:	6a 00                	push   $0x0
  pushl $145
801073df:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801073e4:	e9 41 f4 ff ff       	jmp    8010682a <alltraps>

801073e9 <vector146>:
.globl vector146
vector146:
  pushl $0
801073e9:	6a 00                	push   $0x0
  pushl $146
801073eb:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801073f0:	e9 35 f4 ff ff       	jmp    8010682a <alltraps>

801073f5 <vector147>:
.globl vector147
vector147:
  pushl $0
801073f5:	6a 00                	push   $0x0
  pushl $147
801073f7:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801073fc:	e9 29 f4 ff ff       	jmp    8010682a <alltraps>

80107401 <vector148>:
.globl vector148
vector148:
  pushl $0
80107401:	6a 00                	push   $0x0
  pushl $148
80107403:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107408:	e9 1d f4 ff ff       	jmp    8010682a <alltraps>

8010740d <vector149>:
.globl vector149
vector149:
  pushl $0
8010740d:	6a 00                	push   $0x0
  pushl $149
8010740f:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107414:	e9 11 f4 ff ff       	jmp    8010682a <alltraps>

80107419 <vector150>:
.globl vector150
vector150:
  pushl $0
80107419:	6a 00                	push   $0x0
  pushl $150
8010741b:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107420:	e9 05 f4 ff ff       	jmp    8010682a <alltraps>

80107425 <vector151>:
.globl vector151
vector151:
  pushl $0
80107425:	6a 00                	push   $0x0
  pushl $151
80107427:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010742c:	e9 f9 f3 ff ff       	jmp    8010682a <alltraps>

80107431 <vector152>:
.globl vector152
vector152:
  pushl $0
80107431:	6a 00                	push   $0x0
  pushl $152
80107433:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107438:	e9 ed f3 ff ff       	jmp    8010682a <alltraps>

8010743d <vector153>:
.globl vector153
vector153:
  pushl $0
8010743d:	6a 00                	push   $0x0
  pushl $153
8010743f:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107444:	e9 e1 f3 ff ff       	jmp    8010682a <alltraps>

80107449 <vector154>:
.globl vector154
vector154:
  pushl $0
80107449:	6a 00                	push   $0x0
  pushl $154
8010744b:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107450:	e9 d5 f3 ff ff       	jmp    8010682a <alltraps>

80107455 <vector155>:
.globl vector155
vector155:
  pushl $0
80107455:	6a 00                	push   $0x0
  pushl $155
80107457:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010745c:	e9 c9 f3 ff ff       	jmp    8010682a <alltraps>

80107461 <vector156>:
.globl vector156
vector156:
  pushl $0
80107461:	6a 00                	push   $0x0
  pushl $156
80107463:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107468:	e9 bd f3 ff ff       	jmp    8010682a <alltraps>

8010746d <vector157>:
.globl vector157
vector157:
  pushl $0
8010746d:	6a 00                	push   $0x0
  pushl $157
8010746f:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107474:	e9 b1 f3 ff ff       	jmp    8010682a <alltraps>

80107479 <vector158>:
.globl vector158
vector158:
  pushl $0
80107479:	6a 00                	push   $0x0
  pushl $158
8010747b:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107480:	e9 a5 f3 ff ff       	jmp    8010682a <alltraps>

80107485 <vector159>:
.globl vector159
vector159:
  pushl $0
80107485:	6a 00                	push   $0x0
  pushl $159
80107487:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010748c:	e9 99 f3 ff ff       	jmp    8010682a <alltraps>

80107491 <vector160>:
.globl vector160
vector160:
  pushl $0
80107491:	6a 00                	push   $0x0
  pushl $160
80107493:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107498:	e9 8d f3 ff ff       	jmp    8010682a <alltraps>

8010749d <vector161>:
.globl vector161
vector161:
  pushl $0
8010749d:	6a 00                	push   $0x0
  pushl $161
8010749f:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801074a4:	e9 81 f3 ff ff       	jmp    8010682a <alltraps>

801074a9 <vector162>:
.globl vector162
vector162:
  pushl $0
801074a9:	6a 00                	push   $0x0
  pushl $162
801074ab:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801074b0:	e9 75 f3 ff ff       	jmp    8010682a <alltraps>

801074b5 <vector163>:
.globl vector163
vector163:
  pushl $0
801074b5:	6a 00                	push   $0x0
  pushl $163
801074b7:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801074bc:	e9 69 f3 ff ff       	jmp    8010682a <alltraps>

801074c1 <vector164>:
.globl vector164
vector164:
  pushl $0
801074c1:	6a 00                	push   $0x0
  pushl $164
801074c3:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801074c8:	e9 5d f3 ff ff       	jmp    8010682a <alltraps>

801074cd <vector165>:
.globl vector165
vector165:
  pushl $0
801074cd:	6a 00                	push   $0x0
  pushl $165
801074cf:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801074d4:	e9 51 f3 ff ff       	jmp    8010682a <alltraps>

801074d9 <vector166>:
.globl vector166
vector166:
  pushl $0
801074d9:	6a 00                	push   $0x0
  pushl $166
801074db:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801074e0:	e9 45 f3 ff ff       	jmp    8010682a <alltraps>

801074e5 <vector167>:
.globl vector167
vector167:
  pushl $0
801074e5:	6a 00                	push   $0x0
  pushl $167
801074e7:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801074ec:	e9 39 f3 ff ff       	jmp    8010682a <alltraps>

801074f1 <vector168>:
.globl vector168
vector168:
  pushl $0
801074f1:	6a 00                	push   $0x0
  pushl $168
801074f3:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801074f8:	e9 2d f3 ff ff       	jmp    8010682a <alltraps>

801074fd <vector169>:
.globl vector169
vector169:
  pushl $0
801074fd:	6a 00                	push   $0x0
  pushl $169
801074ff:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107504:	e9 21 f3 ff ff       	jmp    8010682a <alltraps>

80107509 <vector170>:
.globl vector170
vector170:
  pushl $0
80107509:	6a 00                	push   $0x0
  pushl $170
8010750b:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107510:	e9 15 f3 ff ff       	jmp    8010682a <alltraps>

80107515 <vector171>:
.globl vector171
vector171:
  pushl $0
80107515:	6a 00                	push   $0x0
  pushl $171
80107517:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010751c:	e9 09 f3 ff ff       	jmp    8010682a <alltraps>

80107521 <vector172>:
.globl vector172
vector172:
  pushl $0
80107521:	6a 00                	push   $0x0
  pushl $172
80107523:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107528:	e9 fd f2 ff ff       	jmp    8010682a <alltraps>

8010752d <vector173>:
.globl vector173
vector173:
  pushl $0
8010752d:	6a 00                	push   $0x0
  pushl $173
8010752f:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107534:	e9 f1 f2 ff ff       	jmp    8010682a <alltraps>

80107539 <vector174>:
.globl vector174
vector174:
  pushl $0
80107539:	6a 00                	push   $0x0
  pushl $174
8010753b:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107540:	e9 e5 f2 ff ff       	jmp    8010682a <alltraps>

80107545 <vector175>:
.globl vector175
vector175:
  pushl $0
80107545:	6a 00                	push   $0x0
  pushl $175
80107547:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010754c:	e9 d9 f2 ff ff       	jmp    8010682a <alltraps>

80107551 <vector176>:
.globl vector176
vector176:
  pushl $0
80107551:	6a 00                	push   $0x0
  pushl $176
80107553:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107558:	e9 cd f2 ff ff       	jmp    8010682a <alltraps>

8010755d <vector177>:
.globl vector177
vector177:
  pushl $0
8010755d:	6a 00                	push   $0x0
  pushl $177
8010755f:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107564:	e9 c1 f2 ff ff       	jmp    8010682a <alltraps>

80107569 <vector178>:
.globl vector178
vector178:
  pushl $0
80107569:	6a 00                	push   $0x0
  pushl $178
8010756b:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107570:	e9 b5 f2 ff ff       	jmp    8010682a <alltraps>

80107575 <vector179>:
.globl vector179
vector179:
  pushl $0
80107575:	6a 00                	push   $0x0
  pushl $179
80107577:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010757c:	e9 a9 f2 ff ff       	jmp    8010682a <alltraps>

80107581 <vector180>:
.globl vector180
vector180:
  pushl $0
80107581:	6a 00                	push   $0x0
  pushl $180
80107583:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107588:	e9 9d f2 ff ff       	jmp    8010682a <alltraps>

8010758d <vector181>:
.globl vector181
vector181:
  pushl $0
8010758d:	6a 00                	push   $0x0
  pushl $181
8010758f:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107594:	e9 91 f2 ff ff       	jmp    8010682a <alltraps>

80107599 <vector182>:
.globl vector182
vector182:
  pushl $0
80107599:	6a 00                	push   $0x0
  pushl $182
8010759b:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801075a0:	e9 85 f2 ff ff       	jmp    8010682a <alltraps>

801075a5 <vector183>:
.globl vector183
vector183:
  pushl $0
801075a5:	6a 00                	push   $0x0
  pushl $183
801075a7:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801075ac:	e9 79 f2 ff ff       	jmp    8010682a <alltraps>

801075b1 <vector184>:
.globl vector184
vector184:
  pushl $0
801075b1:	6a 00                	push   $0x0
  pushl $184
801075b3:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801075b8:	e9 6d f2 ff ff       	jmp    8010682a <alltraps>

801075bd <vector185>:
.globl vector185
vector185:
  pushl $0
801075bd:	6a 00                	push   $0x0
  pushl $185
801075bf:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801075c4:	e9 61 f2 ff ff       	jmp    8010682a <alltraps>

801075c9 <vector186>:
.globl vector186
vector186:
  pushl $0
801075c9:	6a 00                	push   $0x0
  pushl $186
801075cb:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801075d0:	e9 55 f2 ff ff       	jmp    8010682a <alltraps>

801075d5 <vector187>:
.globl vector187
vector187:
  pushl $0
801075d5:	6a 00                	push   $0x0
  pushl $187
801075d7:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801075dc:	e9 49 f2 ff ff       	jmp    8010682a <alltraps>

801075e1 <vector188>:
.globl vector188
vector188:
  pushl $0
801075e1:	6a 00                	push   $0x0
  pushl $188
801075e3:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801075e8:	e9 3d f2 ff ff       	jmp    8010682a <alltraps>

801075ed <vector189>:
.globl vector189
vector189:
  pushl $0
801075ed:	6a 00                	push   $0x0
  pushl $189
801075ef:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801075f4:	e9 31 f2 ff ff       	jmp    8010682a <alltraps>

801075f9 <vector190>:
.globl vector190
vector190:
  pushl $0
801075f9:	6a 00                	push   $0x0
  pushl $190
801075fb:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107600:	e9 25 f2 ff ff       	jmp    8010682a <alltraps>

80107605 <vector191>:
.globl vector191
vector191:
  pushl $0
80107605:	6a 00                	push   $0x0
  pushl $191
80107607:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010760c:	e9 19 f2 ff ff       	jmp    8010682a <alltraps>

80107611 <vector192>:
.globl vector192
vector192:
  pushl $0
80107611:	6a 00                	push   $0x0
  pushl $192
80107613:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107618:	e9 0d f2 ff ff       	jmp    8010682a <alltraps>

8010761d <vector193>:
.globl vector193
vector193:
  pushl $0
8010761d:	6a 00                	push   $0x0
  pushl $193
8010761f:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107624:	e9 01 f2 ff ff       	jmp    8010682a <alltraps>

80107629 <vector194>:
.globl vector194
vector194:
  pushl $0
80107629:	6a 00                	push   $0x0
  pushl $194
8010762b:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107630:	e9 f5 f1 ff ff       	jmp    8010682a <alltraps>

80107635 <vector195>:
.globl vector195
vector195:
  pushl $0
80107635:	6a 00                	push   $0x0
  pushl $195
80107637:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010763c:	e9 e9 f1 ff ff       	jmp    8010682a <alltraps>

80107641 <vector196>:
.globl vector196
vector196:
  pushl $0
80107641:	6a 00                	push   $0x0
  pushl $196
80107643:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107648:	e9 dd f1 ff ff       	jmp    8010682a <alltraps>

8010764d <vector197>:
.globl vector197
vector197:
  pushl $0
8010764d:	6a 00                	push   $0x0
  pushl $197
8010764f:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107654:	e9 d1 f1 ff ff       	jmp    8010682a <alltraps>

80107659 <vector198>:
.globl vector198
vector198:
  pushl $0
80107659:	6a 00                	push   $0x0
  pushl $198
8010765b:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107660:	e9 c5 f1 ff ff       	jmp    8010682a <alltraps>

80107665 <vector199>:
.globl vector199
vector199:
  pushl $0
80107665:	6a 00                	push   $0x0
  pushl $199
80107667:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010766c:	e9 b9 f1 ff ff       	jmp    8010682a <alltraps>

80107671 <vector200>:
.globl vector200
vector200:
  pushl $0
80107671:	6a 00                	push   $0x0
  pushl $200
80107673:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107678:	e9 ad f1 ff ff       	jmp    8010682a <alltraps>

8010767d <vector201>:
.globl vector201
vector201:
  pushl $0
8010767d:	6a 00                	push   $0x0
  pushl $201
8010767f:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107684:	e9 a1 f1 ff ff       	jmp    8010682a <alltraps>

80107689 <vector202>:
.globl vector202
vector202:
  pushl $0
80107689:	6a 00                	push   $0x0
  pushl $202
8010768b:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107690:	e9 95 f1 ff ff       	jmp    8010682a <alltraps>

80107695 <vector203>:
.globl vector203
vector203:
  pushl $0
80107695:	6a 00                	push   $0x0
  pushl $203
80107697:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010769c:	e9 89 f1 ff ff       	jmp    8010682a <alltraps>

801076a1 <vector204>:
.globl vector204
vector204:
  pushl $0
801076a1:	6a 00                	push   $0x0
  pushl $204
801076a3:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801076a8:	e9 7d f1 ff ff       	jmp    8010682a <alltraps>

801076ad <vector205>:
.globl vector205
vector205:
  pushl $0
801076ad:	6a 00                	push   $0x0
  pushl $205
801076af:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801076b4:	e9 71 f1 ff ff       	jmp    8010682a <alltraps>

801076b9 <vector206>:
.globl vector206
vector206:
  pushl $0
801076b9:	6a 00                	push   $0x0
  pushl $206
801076bb:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801076c0:	e9 65 f1 ff ff       	jmp    8010682a <alltraps>

801076c5 <vector207>:
.globl vector207
vector207:
  pushl $0
801076c5:	6a 00                	push   $0x0
  pushl $207
801076c7:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801076cc:	e9 59 f1 ff ff       	jmp    8010682a <alltraps>

801076d1 <vector208>:
.globl vector208
vector208:
  pushl $0
801076d1:	6a 00                	push   $0x0
  pushl $208
801076d3:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801076d8:	e9 4d f1 ff ff       	jmp    8010682a <alltraps>

801076dd <vector209>:
.globl vector209
vector209:
  pushl $0
801076dd:	6a 00                	push   $0x0
  pushl $209
801076df:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801076e4:	e9 41 f1 ff ff       	jmp    8010682a <alltraps>

801076e9 <vector210>:
.globl vector210
vector210:
  pushl $0
801076e9:	6a 00                	push   $0x0
  pushl $210
801076eb:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801076f0:	e9 35 f1 ff ff       	jmp    8010682a <alltraps>

801076f5 <vector211>:
.globl vector211
vector211:
  pushl $0
801076f5:	6a 00                	push   $0x0
  pushl $211
801076f7:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801076fc:	e9 29 f1 ff ff       	jmp    8010682a <alltraps>

80107701 <vector212>:
.globl vector212
vector212:
  pushl $0
80107701:	6a 00                	push   $0x0
  pushl $212
80107703:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107708:	e9 1d f1 ff ff       	jmp    8010682a <alltraps>

8010770d <vector213>:
.globl vector213
vector213:
  pushl $0
8010770d:	6a 00                	push   $0x0
  pushl $213
8010770f:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107714:	e9 11 f1 ff ff       	jmp    8010682a <alltraps>

80107719 <vector214>:
.globl vector214
vector214:
  pushl $0
80107719:	6a 00                	push   $0x0
  pushl $214
8010771b:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107720:	e9 05 f1 ff ff       	jmp    8010682a <alltraps>

80107725 <vector215>:
.globl vector215
vector215:
  pushl $0
80107725:	6a 00                	push   $0x0
  pushl $215
80107727:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010772c:	e9 f9 f0 ff ff       	jmp    8010682a <alltraps>

80107731 <vector216>:
.globl vector216
vector216:
  pushl $0
80107731:	6a 00                	push   $0x0
  pushl $216
80107733:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107738:	e9 ed f0 ff ff       	jmp    8010682a <alltraps>

8010773d <vector217>:
.globl vector217
vector217:
  pushl $0
8010773d:	6a 00                	push   $0x0
  pushl $217
8010773f:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107744:	e9 e1 f0 ff ff       	jmp    8010682a <alltraps>

80107749 <vector218>:
.globl vector218
vector218:
  pushl $0
80107749:	6a 00                	push   $0x0
  pushl $218
8010774b:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107750:	e9 d5 f0 ff ff       	jmp    8010682a <alltraps>

80107755 <vector219>:
.globl vector219
vector219:
  pushl $0
80107755:	6a 00                	push   $0x0
  pushl $219
80107757:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010775c:	e9 c9 f0 ff ff       	jmp    8010682a <alltraps>

80107761 <vector220>:
.globl vector220
vector220:
  pushl $0
80107761:	6a 00                	push   $0x0
  pushl $220
80107763:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107768:	e9 bd f0 ff ff       	jmp    8010682a <alltraps>

8010776d <vector221>:
.globl vector221
vector221:
  pushl $0
8010776d:	6a 00                	push   $0x0
  pushl $221
8010776f:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107774:	e9 b1 f0 ff ff       	jmp    8010682a <alltraps>

80107779 <vector222>:
.globl vector222
vector222:
  pushl $0
80107779:	6a 00                	push   $0x0
  pushl $222
8010777b:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107780:	e9 a5 f0 ff ff       	jmp    8010682a <alltraps>

80107785 <vector223>:
.globl vector223
vector223:
  pushl $0
80107785:	6a 00                	push   $0x0
  pushl $223
80107787:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010778c:	e9 99 f0 ff ff       	jmp    8010682a <alltraps>

80107791 <vector224>:
.globl vector224
vector224:
  pushl $0
80107791:	6a 00                	push   $0x0
  pushl $224
80107793:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107798:	e9 8d f0 ff ff       	jmp    8010682a <alltraps>

8010779d <vector225>:
.globl vector225
vector225:
  pushl $0
8010779d:	6a 00                	push   $0x0
  pushl $225
8010779f:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801077a4:	e9 81 f0 ff ff       	jmp    8010682a <alltraps>

801077a9 <vector226>:
.globl vector226
vector226:
  pushl $0
801077a9:	6a 00                	push   $0x0
  pushl $226
801077ab:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801077b0:	e9 75 f0 ff ff       	jmp    8010682a <alltraps>

801077b5 <vector227>:
.globl vector227
vector227:
  pushl $0
801077b5:	6a 00                	push   $0x0
  pushl $227
801077b7:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801077bc:	e9 69 f0 ff ff       	jmp    8010682a <alltraps>

801077c1 <vector228>:
.globl vector228
vector228:
  pushl $0
801077c1:	6a 00                	push   $0x0
  pushl $228
801077c3:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801077c8:	e9 5d f0 ff ff       	jmp    8010682a <alltraps>

801077cd <vector229>:
.globl vector229
vector229:
  pushl $0
801077cd:	6a 00                	push   $0x0
  pushl $229
801077cf:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801077d4:	e9 51 f0 ff ff       	jmp    8010682a <alltraps>

801077d9 <vector230>:
.globl vector230
vector230:
  pushl $0
801077d9:	6a 00                	push   $0x0
  pushl $230
801077db:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801077e0:	e9 45 f0 ff ff       	jmp    8010682a <alltraps>

801077e5 <vector231>:
.globl vector231
vector231:
  pushl $0
801077e5:	6a 00                	push   $0x0
  pushl $231
801077e7:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801077ec:	e9 39 f0 ff ff       	jmp    8010682a <alltraps>

801077f1 <vector232>:
.globl vector232
vector232:
  pushl $0
801077f1:	6a 00                	push   $0x0
  pushl $232
801077f3:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801077f8:	e9 2d f0 ff ff       	jmp    8010682a <alltraps>

801077fd <vector233>:
.globl vector233
vector233:
  pushl $0
801077fd:	6a 00                	push   $0x0
  pushl $233
801077ff:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107804:	e9 21 f0 ff ff       	jmp    8010682a <alltraps>

80107809 <vector234>:
.globl vector234
vector234:
  pushl $0
80107809:	6a 00                	push   $0x0
  pushl $234
8010780b:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107810:	e9 15 f0 ff ff       	jmp    8010682a <alltraps>

80107815 <vector235>:
.globl vector235
vector235:
  pushl $0
80107815:	6a 00                	push   $0x0
  pushl $235
80107817:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010781c:	e9 09 f0 ff ff       	jmp    8010682a <alltraps>

80107821 <vector236>:
.globl vector236
vector236:
  pushl $0
80107821:	6a 00                	push   $0x0
  pushl $236
80107823:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107828:	e9 fd ef ff ff       	jmp    8010682a <alltraps>

8010782d <vector237>:
.globl vector237
vector237:
  pushl $0
8010782d:	6a 00                	push   $0x0
  pushl $237
8010782f:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107834:	e9 f1 ef ff ff       	jmp    8010682a <alltraps>

80107839 <vector238>:
.globl vector238
vector238:
  pushl $0
80107839:	6a 00                	push   $0x0
  pushl $238
8010783b:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107840:	e9 e5 ef ff ff       	jmp    8010682a <alltraps>

80107845 <vector239>:
.globl vector239
vector239:
  pushl $0
80107845:	6a 00                	push   $0x0
  pushl $239
80107847:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010784c:	e9 d9 ef ff ff       	jmp    8010682a <alltraps>

80107851 <vector240>:
.globl vector240
vector240:
  pushl $0
80107851:	6a 00                	push   $0x0
  pushl $240
80107853:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107858:	e9 cd ef ff ff       	jmp    8010682a <alltraps>

8010785d <vector241>:
.globl vector241
vector241:
  pushl $0
8010785d:	6a 00                	push   $0x0
  pushl $241
8010785f:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107864:	e9 c1 ef ff ff       	jmp    8010682a <alltraps>

80107869 <vector242>:
.globl vector242
vector242:
  pushl $0
80107869:	6a 00                	push   $0x0
  pushl $242
8010786b:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107870:	e9 b5 ef ff ff       	jmp    8010682a <alltraps>

80107875 <vector243>:
.globl vector243
vector243:
  pushl $0
80107875:	6a 00                	push   $0x0
  pushl $243
80107877:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010787c:	e9 a9 ef ff ff       	jmp    8010682a <alltraps>

80107881 <vector244>:
.globl vector244
vector244:
  pushl $0
80107881:	6a 00                	push   $0x0
  pushl $244
80107883:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107888:	e9 9d ef ff ff       	jmp    8010682a <alltraps>

8010788d <vector245>:
.globl vector245
vector245:
  pushl $0
8010788d:	6a 00                	push   $0x0
  pushl $245
8010788f:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107894:	e9 91 ef ff ff       	jmp    8010682a <alltraps>

80107899 <vector246>:
.globl vector246
vector246:
  pushl $0
80107899:	6a 00                	push   $0x0
  pushl $246
8010789b:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801078a0:	e9 85 ef ff ff       	jmp    8010682a <alltraps>

801078a5 <vector247>:
.globl vector247
vector247:
  pushl $0
801078a5:	6a 00                	push   $0x0
  pushl $247
801078a7:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801078ac:	e9 79 ef ff ff       	jmp    8010682a <alltraps>

801078b1 <vector248>:
.globl vector248
vector248:
  pushl $0
801078b1:	6a 00                	push   $0x0
  pushl $248
801078b3:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801078b8:	e9 6d ef ff ff       	jmp    8010682a <alltraps>

801078bd <vector249>:
.globl vector249
vector249:
  pushl $0
801078bd:	6a 00                	push   $0x0
  pushl $249
801078bf:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801078c4:	e9 61 ef ff ff       	jmp    8010682a <alltraps>

801078c9 <vector250>:
.globl vector250
vector250:
  pushl $0
801078c9:	6a 00                	push   $0x0
  pushl $250
801078cb:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801078d0:	e9 55 ef ff ff       	jmp    8010682a <alltraps>

801078d5 <vector251>:
.globl vector251
vector251:
  pushl $0
801078d5:	6a 00                	push   $0x0
  pushl $251
801078d7:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801078dc:	e9 49 ef ff ff       	jmp    8010682a <alltraps>

801078e1 <vector252>:
.globl vector252
vector252:
  pushl $0
801078e1:	6a 00                	push   $0x0
  pushl $252
801078e3:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801078e8:	e9 3d ef ff ff       	jmp    8010682a <alltraps>

801078ed <vector253>:
.globl vector253
vector253:
  pushl $0
801078ed:	6a 00                	push   $0x0
  pushl $253
801078ef:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801078f4:	e9 31 ef ff ff       	jmp    8010682a <alltraps>

801078f9 <vector254>:
.globl vector254
vector254:
  pushl $0
801078f9:	6a 00                	push   $0x0
  pushl $254
801078fb:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107900:	e9 25 ef ff ff       	jmp    8010682a <alltraps>

80107905 <vector255>:
.globl vector255
vector255:
  pushl $0
80107905:	6a 00                	push   $0x0
  pushl $255
80107907:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010790c:	e9 19 ef ff ff       	jmp    8010682a <alltraps>

80107911 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107911:	55                   	push   %ebp
80107912:	89 e5                	mov    %esp,%ebp
80107914:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107917:	8b 45 0c             	mov    0xc(%ebp),%eax
8010791a:	83 e8 01             	sub    $0x1,%eax
8010791d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107921:	8b 45 08             	mov    0x8(%ebp),%eax
80107924:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107928:	8b 45 08             	mov    0x8(%ebp),%eax
8010792b:	c1 e8 10             	shr    $0x10,%eax
8010792e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107932:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107935:	0f 01 10             	lgdtl  (%eax)
}
80107938:	90                   	nop
80107939:	c9                   	leave  
8010793a:	c3                   	ret    

8010793b <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
8010793b:	55                   	push   %ebp
8010793c:	89 e5                	mov    %esp,%ebp
8010793e:	83 ec 04             	sub    $0x4,%esp
80107941:	8b 45 08             	mov    0x8(%ebp),%eax
80107944:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107948:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010794c:	0f 00 d8             	ltr    %ax
}
8010794f:	90                   	nop
80107950:	c9                   	leave  
80107951:	c3                   	ret    

80107952 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107952:	55                   	push   %ebp
80107953:	89 e5                	mov    %esp,%ebp
80107955:	83 ec 04             	sub    $0x4,%esp
80107958:	8b 45 08             	mov    0x8(%ebp),%eax
8010795b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
8010795f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107963:	8e e8                	mov    %eax,%gs
}
80107965:	90                   	nop
80107966:	c9                   	leave  
80107967:	c3                   	ret    

80107968 <flush_tlb>:
}

//clear the tlb for mprotect/cowfork
static inline void
flush_tlb(void)
{
80107968:	55                   	push   %ebp
80107969:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %cr3,%eax");
8010796b:	0f 20 d8             	mov    %cr3,%eax
  asm volatile("movl %eax,%cr3");
8010796e:	0f 22 d8             	mov    %eax,%cr3
}
80107971:	90                   	nop
80107972:	5d                   	pop    %ebp
80107973:	c3                   	ret    

80107974 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107974:	55                   	push   %ebp
80107975:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107977:	8b 45 08             	mov    0x8(%ebp),%eax
8010797a:	0f 22 d8             	mov    %eax,%cr3
}
8010797d:	90                   	nop
8010797e:	5d                   	pop    %ebp
8010797f:	c3                   	ret    

80107980 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	8b 45 08             	mov    0x8(%ebp),%eax
80107986:	05 00 00 00 80       	add    $0x80000000,%eax
8010798b:	5d                   	pop    %ebp
8010798c:	c3                   	ret    

8010798d <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010798d:	55                   	push   %ebp
8010798e:	89 e5                	mov    %esp,%ebp
80107990:	8b 45 08             	mov    0x8(%ebp),%eax
80107993:	05 00 00 00 80       	add    $0x80000000,%eax
80107998:	5d                   	pop    %ebp
80107999:	c3                   	ret    

8010799a <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010799a:	55                   	push   %ebp
8010799b:	89 e5                	mov    %esp,%ebp
8010799d:	53                   	push   %ebx
8010799e:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801079a1:	e8 85 b5 ff ff       	call   80102f2b <cpunum>
801079a6:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801079ac:	05 80 23 11 80       	add    $0x80112380,%eax
801079b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801079b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b7:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801079bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c0:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801079c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c9:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801079cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d0:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801079d4:	83 e2 f0             	and    $0xfffffff0,%edx
801079d7:	83 ca 0a             	or     $0xa,%edx
801079da:	88 50 7d             	mov    %dl,0x7d(%eax)
801079dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e0:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801079e4:	83 ca 10             	or     $0x10,%edx
801079e7:	88 50 7d             	mov    %dl,0x7d(%eax)
801079ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ed:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801079f1:	83 e2 9f             	and    $0xffffff9f,%edx
801079f4:	88 50 7d             	mov    %dl,0x7d(%eax)
801079f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079fa:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801079fe:	83 ca 80             	or     $0xffffff80,%edx
80107a01:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a07:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107a0b:	83 ca 0f             	or     $0xf,%edx
80107a0e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a14:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107a18:	83 e2 ef             	and    $0xffffffef,%edx
80107a1b:	88 50 7e             	mov    %dl,0x7e(%eax)
80107a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a21:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107a25:	83 e2 df             	and    $0xffffffdf,%edx
80107a28:	88 50 7e             	mov    %dl,0x7e(%eax)
80107a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107a32:	83 ca 40             	or     $0x40,%edx
80107a35:	88 50 7e             	mov    %dl,0x7e(%eax)
80107a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a3b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107a3f:	83 ca 80             	or     $0xffffff80,%edx
80107a42:	88 50 7e             	mov    %dl,0x7e(%eax)
80107a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a48:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4f:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107a56:	ff ff 
80107a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5b:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107a62:	00 00 
80107a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a67:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a71:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107a78:	83 e2 f0             	and    $0xfffffff0,%edx
80107a7b:	83 ca 02             	or     $0x2,%edx
80107a7e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a87:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107a8e:	83 ca 10             	or     $0x10,%edx
80107a91:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a9a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107aa1:	83 e2 9f             	and    $0xffffff9f,%edx
80107aa4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aad:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ab4:	83 ca 80             	or     $0xffffff80,%edx
80107ab7:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ac7:	83 ca 0f             	or     $0xf,%edx
80107aca:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ada:	83 e2 ef             	and    $0xffffffef,%edx
80107add:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae6:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107aed:	83 e2 df             	and    $0xffffffdf,%edx
80107af0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af9:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b00:	83 ca 40             	or     $0x40,%edx
80107b03:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b13:	83 ca 80             	or     $0xffffff80,%edx
80107b16:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1f:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b29:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107b30:	ff ff 
80107b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b35:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107b3c:	00 00 
80107b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b41:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b4b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107b52:	83 e2 f0             	and    $0xfffffff0,%edx
80107b55:	83 ca 0a             	or     $0xa,%edx
80107b58:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b61:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107b68:	83 ca 10             	or     $0x10,%edx
80107b6b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b74:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107b7b:	83 ca 60             	or     $0x60,%edx
80107b7e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b87:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107b8e:	83 ca 80             	or     $0xffffff80,%edx
80107b91:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b9a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ba1:	83 ca 0f             	or     $0xf,%edx
80107ba4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bad:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107bb4:	83 e2 ef             	and    $0xffffffef,%edx
80107bb7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107bc7:	83 e2 df             	and    $0xffffffdf,%edx
80107bca:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107bda:	83 ca 40             	or     $0x40,%edx
80107bdd:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107bed:	83 ca 80             	or     $0xffffff80,%edx
80107bf0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf9:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c03:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107c0a:	ff ff 
80107c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c0f:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107c16:	00 00 
80107c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1b:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c25:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107c2c:	83 e2 f0             	and    $0xfffffff0,%edx
80107c2f:	83 ca 02             	or     $0x2,%edx
80107c32:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c3b:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107c42:	83 ca 10             	or     $0x10,%edx
80107c45:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c4e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107c55:	83 ca 60             	or     $0x60,%edx
80107c58:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c61:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107c68:	83 ca 80             	or     $0xffffff80,%edx
80107c6b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c74:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107c7b:	83 ca 0f             	or     $0xf,%edx
80107c7e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c87:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107c8e:	83 e2 ef             	and    $0xffffffef,%edx
80107c91:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ca1:	83 e2 df             	and    $0xffffffdf,%edx
80107ca4:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cad:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107cb4:	83 ca 40             	or     $0x40,%edx
80107cb7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc0:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107cc7:	83 ca 80             	or     $0xffffff80,%edx
80107cca:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd3:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdd:	05 b4 00 00 00       	add    $0xb4,%eax
80107ce2:	89 c3                	mov    %eax,%ebx
80107ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce7:	05 b4 00 00 00       	add    $0xb4,%eax
80107cec:	c1 e8 10             	shr    $0x10,%eax
80107cef:	89 c2                	mov    %eax,%edx
80107cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf4:	05 b4 00 00 00       	add    $0xb4,%eax
80107cf9:	c1 e8 18             	shr    $0x18,%eax
80107cfc:	89 c1                	mov    %eax,%ecx
80107cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d01:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107d08:	00 00 
80107d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0d:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d17:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d20:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107d27:	83 e2 f0             	and    $0xfffffff0,%edx
80107d2a:	83 ca 02             	or     $0x2,%edx
80107d2d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d36:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107d3d:	83 ca 10             	or     $0x10,%edx
80107d40:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d49:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107d50:	83 e2 9f             	and    $0xffffff9f,%edx
80107d53:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107d63:	83 ca 80             	or     $0xffffff80,%edx
80107d66:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107d76:	83 e2 f0             	and    $0xfffffff0,%edx
80107d79:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d82:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107d89:	83 e2 ef             	and    $0xffffffef,%edx
80107d8c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d95:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107d9c:	83 e2 df             	and    $0xffffffdf,%edx
80107d9f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da8:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107daf:	83 ca 40             	or     $0x40,%edx
80107db2:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dbb:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107dc2:	83 ca 80             	or     $0xffffff80,%edx
80107dc5:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dce:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd7:	83 c0 70             	add    $0x70,%eax
80107dda:	83 ec 08             	sub    $0x8,%esp
80107ddd:	6a 38                	push   $0x38
80107ddf:	50                   	push   %eax
80107de0:	e8 2c fb ff ff       	call   80107911 <lgdt>
80107de5:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107de8:	83 ec 0c             	sub    $0xc,%esp
80107deb:	6a 18                	push   $0x18
80107ded:	e8 60 fb ff ff       	call   80107952 <loadgs>
80107df2:	83 c4 10             	add    $0x10,%esp

  // Initialize cpu-local storage.
  cpu = c;
80107df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df8:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107dfe:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107e05:	00 00 00 00 
}
80107e09:	90                   	nop
80107e0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107e0d:	c9                   	leave  
80107e0e:	c3                   	ret    

80107e0f <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107e0f:	55                   	push   %ebp
80107e10:	89 e5                	mov    %esp,%ebp
80107e12:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107e15:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e18:	c1 e8 16             	shr    $0x16,%eax
80107e1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107e22:	8b 45 08             	mov    0x8(%ebp),%eax
80107e25:	01 d0                	add    %edx,%eax
80107e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e2d:	8b 00                	mov    (%eax),%eax
80107e2f:	83 e0 01             	and    $0x1,%eax
80107e32:	85 c0                	test   %eax,%eax
80107e34:	74 18                	je     80107e4e <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e39:	8b 00                	mov    (%eax),%eax
80107e3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e40:	50                   	push   %eax
80107e41:	e8 47 fb ff ff       	call   8010798d <p2v>
80107e46:	83 c4 04             	add    $0x4,%esp
80107e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107e4c:	eb 48                	jmp    80107e96 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107e4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107e52:	74 0e                	je     80107e62 <walkpgdir+0x53>
80107e54:	e8 6c ad ff ff       	call   80102bc5 <kalloc>
80107e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107e5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107e60:	75 07                	jne    80107e69 <walkpgdir+0x5a>
      return 0;
80107e62:	b8 00 00 00 00       	mov    $0x0,%eax
80107e67:	eb 44                	jmp    80107ead <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107e69:	83 ec 04             	sub    $0x4,%esp
80107e6c:	68 00 10 00 00       	push   $0x1000
80107e71:	6a 00                	push   $0x0
80107e73:	ff 75 f4             	pushl  -0xc(%ebp)
80107e76:	e8 95 d4 ff ff       	call   80105310 <memset>
80107e7b:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U
80107e7e:	83 ec 0c             	sub    $0xc,%esp
80107e81:	ff 75 f4             	pushl  -0xc(%ebp)
80107e84:	e8 f7 fa ff ff       	call   80107980 <v2p>
80107e89:	83 c4 10             	add    $0x10,%esp
80107e8c:	83 c8 07             	or     $0x7,%eax
80107e8f:	89 c2                	mov    %eax,%edx
80107e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e94:	89 10                	mov    %edx,(%eax)
;  }
  return &pgtab[PTX(va)];
80107e96:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e99:	c1 e8 0c             	shr    $0xc,%eax
80107e9c:	25 ff 03 00 00       	and    $0x3ff,%eax
80107ea1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eab:	01 d0                	add    %edx,%eax
}
80107ead:	c9                   	leave  
80107eae:	c3                   	ret    

80107eaf <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107eaf:	55                   	push   %ebp
80107eb0:	89 e5                	mov    %esp,%ebp
80107eb2:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107eb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ebd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ec3:	8b 45 10             	mov    0x10(%ebp),%eax
80107ec6:	01 d0                	add    %edx,%eax
80107ec8:	83 e8 01             	sub    $0x1,%eax
80107ecb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ed0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107ed3:	83 ec 04             	sub    $0x4,%esp
80107ed6:	6a 01                	push   $0x1
80107ed8:	ff 75 f4             	pushl  -0xc(%ebp)
80107edb:	ff 75 08             	pushl  0x8(%ebp)
80107ede:	e8 2c ff ff ff       	call   80107e0f <walkpgdir>
80107ee3:	83 c4 10             	add    $0x10,%esp
80107ee6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107ee9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107eed:	75 07                	jne    80107ef6 <mappages+0x47>
      return -1;
80107eef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ef4:	eb 47                	jmp    80107f3d <mappages+0x8e>
    if(*pte & PTE_P)
80107ef6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ef9:	8b 00                	mov    (%eax),%eax
80107efb:	83 e0 01             	and    $0x1,%eax
80107efe:	85 c0                	test   %eax,%eax
80107f00:	74 0d                	je     80107f0f <mappages+0x60>
      panic("remap");
80107f02:	83 ec 0c             	sub    $0xc,%esp
80107f05:	68 e0 8d 10 80       	push   $0x80108de0
80107f0a:	e8 57 86 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80107f0f:	8b 45 18             	mov    0x18(%ebp),%eax
80107f12:	0b 45 14             	or     0x14(%ebp),%eax
80107f15:	83 c8 01             	or     $0x1,%eax
80107f18:	89 c2                	mov    %eax,%edx
80107f1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f1d:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f22:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107f25:	74 10                	je     80107f37 <mappages+0x88>
      break;
    a += PGSIZE;
80107f27:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107f2e:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107f35:	eb 9c                	jmp    80107ed3 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107f37:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107f38:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f3d:	c9                   	leave  
80107f3e:	c3                   	ret    

80107f3f <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107f3f:	55                   	push   %ebp
80107f40:	89 e5                	mov    %esp,%ebp
80107f42:	53                   	push   %ebx
80107f43:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107f46:	e8 7a ac ff ff       	call   80102bc5 <kalloc>
80107f4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f52:	75 0a                	jne    80107f5e <setupkvm+0x1f>
    return 0;
80107f54:	b8 00 00 00 00       	mov    $0x0,%eax
80107f59:	e9 8e 00 00 00       	jmp    80107fec <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80107f5e:	83 ec 04             	sub    $0x4,%esp
80107f61:	68 00 10 00 00       	push   $0x1000
80107f66:	6a 00                	push   $0x0
80107f68:	ff 75 f0             	pushl  -0x10(%ebp)
80107f6b:	e8 a0 d3 ff ff       	call   80105310 <memset>
80107f70:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107f73:	83 ec 0c             	sub    $0xc,%esp
80107f76:	68 00 00 00 0e       	push   $0xe000000
80107f7b:	e8 0d fa ff ff       	call   8010798d <p2v>
80107f80:	83 c4 10             	add    $0x10,%esp
80107f83:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107f88:	76 0d                	jbe    80107f97 <setupkvm+0x58>
    panic("PHYSTOP too high");
80107f8a:	83 ec 0c             	sub    $0xc,%esp
80107f8d:	68 e6 8d 10 80       	push   $0x80108de6
80107f92:	e8 cf 85 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f97:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80107f9e:	eb 40                	jmp    80107fe0 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa3:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa9:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107faf:	8b 58 08             	mov    0x8(%eax),%ebx
80107fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb5:	8b 40 04             	mov    0x4(%eax),%eax
80107fb8:	29 c3                	sub    %eax,%ebx
80107fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbd:	8b 00                	mov    (%eax),%eax
80107fbf:	83 ec 0c             	sub    $0xc,%esp
80107fc2:	51                   	push   %ecx
80107fc3:	52                   	push   %edx
80107fc4:	53                   	push   %ebx
80107fc5:	50                   	push   %eax
80107fc6:	ff 75 f0             	pushl  -0x10(%ebp)
80107fc9:	e8 e1 fe ff ff       	call   80107eaf <mappages>
80107fce:	83 c4 20             	add    $0x20,%esp
80107fd1:	85 c0                	test   %eax,%eax
80107fd3:	79 07                	jns    80107fdc <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107fd5:	b8 00 00 00 00       	mov    $0x0,%eax
80107fda:	eb 10                	jmp    80107fec <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107fdc:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107fe0:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80107fe7:	72 b7                	jb     80107fa0 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107fec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107fef:	c9                   	leave  
80107ff0:	c3                   	ret    

80107ff1 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107ff1:	55                   	push   %ebp
80107ff2:	89 e5                	mov    %esp,%ebp
80107ff4:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107ff7:	e8 43 ff ff ff       	call   80107f3f <setupkvm>
80107ffc:	a3 58 54 11 80       	mov    %eax,0x80115458
  switchkvm();
80108001:	e8 03 00 00 00       	call   80108009 <switchkvm>
}
80108006:	90                   	nop
80108007:	c9                   	leave  
80108008:	c3                   	ret    

80108009 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108009:	55                   	push   %ebp
8010800a:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010800c:	a1 58 54 11 80       	mov    0x80115458,%eax
80108011:	50                   	push   %eax
80108012:	e8 69 f9 ff ff       	call   80107980 <v2p>
80108017:	83 c4 04             	add    $0x4,%esp
8010801a:	50                   	push   %eax
8010801b:	e8 54 f9 ff ff       	call   80107974 <lcr3>
80108020:	83 c4 04             	add    $0x4,%esp
}
80108023:	90                   	nop
80108024:	c9                   	leave  
80108025:	c3                   	ret    

80108026 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108026:	55                   	push   %ebp
80108027:	89 e5                	mov    %esp,%ebp
80108029:	56                   	push   %esi
8010802a:	53                   	push   %ebx
  pushcli();
8010802b:	e8 da d1 ff ff       	call   8010520a <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108030:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108036:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010803d:	83 c2 08             	add    $0x8,%edx
80108040:	89 d6                	mov    %edx,%esi
80108042:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108049:	83 c2 08             	add    $0x8,%edx
8010804c:	c1 ea 10             	shr    $0x10,%edx
8010804f:	89 d3                	mov    %edx,%ebx
80108051:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108058:	83 c2 08             	add    $0x8,%edx
8010805b:	c1 ea 18             	shr    $0x18,%edx
8010805e:	89 d1                	mov    %edx,%ecx
80108060:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108067:	67 00 
80108069:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108070:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108076:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010807d:	83 e2 f0             	and    $0xfffffff0,%edx
80108080:	83 ca 09             	or     $0x9,%edx
80108083:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108089:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108090:	83 ca 10             	or     $0x10,%edx
80108093:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108099:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801080a0:	83 e2 9f             	and    $0xffffff9f,%edx
801080a3:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801080a9:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801080b0:	83 ca 80             	or     $0xffffff80,%edx
801080b3:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801080b9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801080c0:	83 e2 f0             	and    $0xfffffff0,%edx
801080c3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801080c9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801080d0:	83 e2 ef             	and    $0xffffffef,%edx
801080d3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801080d9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801080e0:	83 e2 df             	and    $0xffffffdf,%edx
801080e3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801080e9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801080f0:	83 ca 40             	or     $0x40,%edx
801080f3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801080f9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108100:	83 e2 7f             	and    $0x7f,%edx
80108103:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108109:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010810f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108115:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010811c:	83 e2 ef             	and    $0xffffffef,%edx
8010811f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108125:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010812b:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108131:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108137:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010813e:	8b 52 08             	mov    0x8(%edx),%edx
80108141:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108147:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010814a:	83 ec 0c             	sub    $0xc,%esp
8010814d:	6a 30                	push   $0x30
8010814f:	e8 e7 f7 ff ff       	call   8010793b <ltr>
80108154:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80108157:	8b 45 08             	mov    0x8(%ebp),%eax
8010815a:	8b 40 04             	mov    0x4(%eax),%eax
8010815d:	85 c0                	test   %eax,%eax
8010815f:	75 0d                	jne    8010816e <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108161:	83 ec 0c             	sub    $0xc,%esp
80108164:	68 f7 8d 10 80       	push   $0x80108df7
80108169:	e8 f8 83 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010816e:	8b 45 08             	mov    0x8(%ebp),%eax
80108171:	8b 40 04             	mov    0x4(%eax),%eax
80108174:	83 ec 0c             	sub    $0xc,%esp
80108177:	50                   	push   %eax
80108178:	e8 03 f8 ff ff       	call   80107980 <v2p>
8010817d:	83 c4 10             	add    $0x10,%esp
80108180:	83 ec 0c             	sub    $0xc,%esp
80108183:	50                   	push   %eax
80108184:	e8 eb f7 ff ff       	call   80107974 <lcr3>
80108189:	83 c4 10             	add    $0x10,%esp
  popcli();
8010818c:	e8 be d0 ff ff       	call   8010524f <popcli>
}
80108191:	90                   	nop
80108192:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108195:	5b                   	pop    %ebx
80108196:	5e                   	pop    %esi
80108197:	5d                   	pop    %ebp
80108198:	c3                   	ret    

80108199 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108199:	55                   	push   %ebp
8010819a:	89 e5                	mov    %esp,%ebp
8010819c:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
8010819f:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801081a6:	76 0d                	jbe    801081b5 <inituvm+0x1c>
    panic("inituvm: more than a page");
801081a8:	83 ec 0c             	sub    $0xc,%esp
801081ab:	68 0b 8e 10 80       	push   $0x80108e0b
801081b0:	e8 b1 83 ff ff       	call   80100566 <panic>
  mem = kalloc();
801081b5:	e8 0b aa ff ff       	call   80102bc5 <kalloc>
801081ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801081bd:	83 ec 04             	sub    $0x4,%esp
801081c0:	68 00 10 00 00       	push   $0x1000
801081c5:	6a 00                	push   $0x0
801081c7:	ff 75 f4             	pushl  -0xc(%ebp)
801081ca:	e8 41 d1 ff ff       	call   80105310 <memset>
801081cf:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801081d2:	83 ec 0c             	sub    $0xc,%esp
801081d5:	ff 75 f4             	pushl  -0xc(%ebp)
801081d8:	e8 a3 f7 ff ff       	call   80107980 <v2p>
801081dd:	83 c4 10             	add    $0x10,%esp
801081e0:	83 ec 0c             	sub    $0xc,%esp
801081e3:	6a 06                	push   $0x6
801081e5:	50                   	push   %eax
801081e6:	68 00 10 00 00       	push   $0x1000
801081eb:	6a 00                	push   $0x0
801081ed:	ff 75 08             	pushl  0x8(%ebp)
801081f0:	e8 ba fc ff ff       	call   80107eaf <mappages>
801081f5:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801081f8:	83 ec 04             	sub    $0x4,%esp
801081fb:	ff 75 10             	pushl  0x10(%ebp)
801081fe:	ff 75 0c             	pushl  0xc(%ebp)
80108201:	ff 75 f4             	pushl  -0xc(%ebp)
80108204:	e8 c6 d1 ff ff       	call   801053cf <memmove>
80108209:	83 c4 10             	add    $0x10,%esp
}
8010820c:	90                   	nop
8010820d:	c9                   	leave  
8010820e:	c3                   	ret    

8010820f <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010820f:	55                   	push   %ebp
80108210:	89 e5                	mov    %esp,%ebp
80108212:	53                   	push   %ebx
80108213:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108216:	8b 45 0c             	mov    0xc(%ebp),%eax
80108219:	25 ff 0f 00 00       	and    $0xfff,%eax
8010821e:	85 c0                	test   %eax,%eax
80108220:	74 0d                	je     8010822f <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108222:	83 ec 0c             	sub    $0xc,%esp
80108225:	68 28 8e 10 80       	push   $0x80108e28
8010822a:	e8 37 83 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010822f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108236:	e9 95 00 00 00       	jmp    801082d0 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010823b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010823e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108241:	01 d0                	add    %edx,%eax
80108243:	83 ec 04             	sub    $0x4,%esp
80108246:	6a 00                	push   $0x0
80108248:	50                   	push   %eax
80108249:	ff 75 08             	pushl  0x8(%ebp)
8010824c:	e8 be fb ff ff       	call   80107e0f <walkpgdir>
80108251:	83 c4 10             	add    $0x10,%esp
80108254:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108257:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010825b:	75 0d                	jne    8010826a <loaduvm+0x5b>
      panic("loaduvm: address should exist");
8010825d:	83 ec 0c             	sub    $0xc,%esp
80108260:	68 4b 8e 10 80       	push   $0x80108e4b
80108265:	e8 fc 82 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010826a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010826d:	8b 00                	mov    (%eax),%eax
8010826f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108274:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108277:	8b 45 18             	mov    0x18(%ebp),%eax
8010827a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010827d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108282:	77 0b                	ja     8010828f <loaduvm+0x80>
      n = sz - i;
80108284:	8b 45 18             	mov    0x18(%ebp),%eax
80108287:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010828a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010828d:	eb 07                	jmp    80108296 <loaduvm+0x87>
    else
      n = PGSIZE;
8010828f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108296:	8b 55 14             	mov    0x14(%ebp),%edx
80108299:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010829c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010829f:	83 ec 0c             	sub    $0xc,%esp
801082a2:	ff 75 e8             	pushl  -0x18(%ebp)
801082a5:	e8 e3 f6 ff ff       	call   8010798d <p2v>
801082aa:	83 c4 10             	add    $0x10,%esp
801082ad:	ff 75 f0             	pushl  -0x10(%ebp)
801082b0:	53                   	push   %ebx
801082b1:	50                   	push   %eax
801082b2:	ff 75 10             	pushl  0x10(%ebp)
801082b5:	e8 b9 9b ff ff       	call   80101e73 <readi>
801082ba:	83 c4 10             	add    $0x10,%esp
801082bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801082c0:	74 07                	je     801082c9 <loaduvm+0xba>
      return -1;
801082c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801082c7:	eb 18                	jmp    801082e1 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801082c9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801082d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d3:	3b 45 18             	cmp    0x18(%ebp),%eax
801082d6:	0f 82 5f ff ff ff    	jb     8010823b <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801082dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801082e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082e4:	c9                   	leave  
801082e5:	c3                   	ret    

801082e6 <mprotect>:

int
mprotect(void *addr, int len, int prot)
{
801082e6:	55                   	push   %ebp
801082e7:	89 e5                	mov    %esp,%ebp
801082e9:	83 ec 18             	sub    $0x18,%esp
  pte_t *page_table_entry;
  int i = 0;
801082ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  //loop through all the page entries that need protection level changed
  for (i = 0; i < len; i++) 
801082f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082fa:	eb 3f                	jmp    8010833b <mprotect+0x55>
  {
    //pass in process pagedir cause that's what we're concerned with
    //now give it addr+i to get address page
    //pass in 0 so it doesn't allocate new tables
    //walk through the physical memory, assigning flags as we go
    page_table_entry = walkpgdir(proc->pgdir,(void *)addr +i, 0);
801082fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082ff:	8b 45 08             	mov    0x8(%ebp),%eax
80108302:	01 c2                	add    %eax,%edx
80108304:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010830a:	8b 40 04             	mov    0x4(%eax),%eax
8010830d:	83 ec 04             	sub    $0x4,%esp
80108310:	6a 00                	push   $0x0
80108312:	52                   	push   %edx
80108313:	50                   	push   %eax
80108314:	e8 f6 fa ff ff       	call   80107e0f <walkpgdir>
80108319:	83 c4 10             	add    $0x10,%esp
8010831c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //going to get rid of last two bits in the pte because those are the flags we care about
    *page_table_entry |= (0 << 2) -1;
8010831f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108322:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

    //add those protection flags 
    *page_table_entry |= prot;    
80108328:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010832b:	8b 10                	mov    (%eax),%edx
8010832d:	8b 45 10             	mov    0x10(%ebp),%eax
80108330:	09 c2                	or     %eax,%edx
80108332:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108335:	89 10                	mov    %edx,(%eax)
{
  pte_t *page_table_entry;
  int i = 0;

  //loop through all the page entries that need protection level changed
  for (i = 0; i < len; i++) 
80108337:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010833b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010833e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108341:	7c b9                	jl     801082fc <mprotect+0x16>

    //add those protection flags 
    *page_table_entry |= prot;    
  }
  //flush that tlb real good
  flush_tlb();
80108343:	e8 20 f6 ff ff       	call   80107968 <flush_tlb>
  return 0;
80108348:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010834d:	c9                   	leave  
8010834e:	c3                   	ret    

8010834f <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010834f:	55                   	push   %ebp
80108350:	89 e5                	mov    %esp,%ebp
80108352:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108355:	8b 45 10             	mov    0x10(%ebp),%eax
80108358:	85 c0                	test   %eax,%eax
8010835a:	79 0a                	jns    80108366 <allocuvm+0x17>
    return 0;
8010835c:	b8 00 00 00 00       	mov    $0x0,%eax
80108361:	e9 b0 00 00 00       	jmp    80108416 <allocuvm+0xc7>
  if(newsz < oldsz)
80108366:	8b 45 10             	mov    0x10(%ebp),%eax
80108369:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010836c:	73 08                	jae    80108376 <allocuvm+0x27>
    return oldsz;
8010836e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108371:	e9 a0 00 00 00       	jmp    80108416 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108376:	8b 45 0c             	mov    0xc(%ebp),%eax
80108379:	05 ff 0f 00 00       	add    $0xfff,%eax
8010837e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108383:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108386:	eb 7f                	jmp    80108407 <allocuvm+0xb8>
    mem = kalloc();
80108388:	e8 38 a8 ff ff       	call   80102bc5 <kalloc>
8010838d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108390:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108394:	75 2b                	jne    801083c1 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108396:	83 ec 0c             	sub    $0xc,%esp
80108399:	68 69 8e 10 80       	push   $0x80108e69
8010839e:	e8 23 80 ff ff       	call   801003c6 <cprintf>
801083a3:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801083a6:	83 ec 04             	sub    $0x4,%esp
801083a9:	ff 75 0c             	pushl  0xc(%ebp)
801083ac:	ff 75 10             	pushl  0x10(%ebp)
801083af:	ff 75 08             	pushl  0x8(%ebp)
801083b2:	e8 61 00 00 00       	call   80108418 <deallocuvm>
801083b7:	83 c4 10             	add    $0x10,%esp
      return 0;
801083ba:	b8 00 00 00 00       	mov    $0x0,%eax
801083bf:	eb 55                	jmp    80108416 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
801083c1:	83 ec 04             	sub    $0x4,%esp
801083c4:	68 00 10 00 00       	push   $0x1000
801083c9:	6a 00                	push   $0x0
801083cb:	ff 75 f0             	pushl  -0x10(%ebp)
801083ce:	e8 3d cf ff ff       	call   80105310 <memset>
801083d3:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801083d6:	83 ec 0c             	sub    $0xc,%esp
801083d9:	ff 75 f0             	pushl  -0x10(%ebp)
801083dc:	e8 9f f5 ff ff       	call   80107980 <v2p>
801083e1:	83 c4 10             	add    $0x10,%esp
801083e4:	89 c2                	mov    %eax,%edx
801083e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e9:	83 ec 0c             	sub    $0xc,%esp
801083ec:	6a 06                	push   $0x6
801083ee:	52                   	push   %edx
801083ef:	68 00 10 00 00       	push   $0x1000
801083f4:	50                   	push   %eax
801083f5:	ff 75 08             	pushl  0x8(%ebp)
801083f8:	e8 b2 fa ff ff       	call   80107eaf <mappages>
801083fd:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108400:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010840a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010840d:	0f 82 75 ff ff ff    	jb     80108388 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108413:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108416:	c9                   	leave  
80108417:	c3                   	ret    

80108418 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108418:	55                   	push   %ebp
80108419:	89 e5                	mov    %esp,%ebp
8010841b:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010841e:	8b 45 10             	mov    0x10(%ebp),%eax
80108421:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108424:	72 08                	jb     8010842e <deallocuvm+0x16>
    return oldsz;
80108426:	8b 45 0c             	mov    0xc(%ebp),%eax
80108429:	e9 a5 00 00 00       	jmp    801084d3 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
8010842e:	8b 45 10             	mov    0x10(%ebp),%eax
80108431:	05 ff 0f 00 00       	add    $0xfff,%eax
80108436:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010843b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010843e:	e9 81 00 00 00       	jmp    801084c4 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108443:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108446:	83 ec 04             	sub    $0x4,%esp
80108449:	6a 00                	push   $0x0
8010844b:	50                   	push   %eax
8010844c:	ff 75 08             	pushl  0x8(%ebp)
8010844f:	e8 bb f9 ff ff       	call   80107e0f <walkpgdir>
80108454:	83 c4 10             	add    $0x10,%esp
80108457:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010845a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010845e:	75 09                	jne    80108469 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108460:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108467:	eb 54                	jmp    801084bd <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108469:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010846c:	8b 00                	mov    (%eax),%eax
8010846e:	83 e0 01             	and    $0x1,%eax
80108471:	85 c0                	test   %eax,%eax
80108473:	74 48                	je     801084bd <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108475:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108478:	8b 00                	mov    (%eax),%eax
8010847a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010847f:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108482:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108486:	75 0d                	jne    80108495 <deallocuvm+0x7d>
        panic("kfree");
80108488:	83 ec 0c             	sub    $0xc,%esp
8010848b:	68 81 8e 10 80       	push   $0x80108e81
80108490:	e8 d1 80 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80108495:	83 ec 0c             	sub    $0xc,%esp
80108498:	ff 75 ec             	pushl  -0x14(%ebp)
8010849b:	e8 ed f4 ff ff       	call   8010798d <p2v>
801084a0:	83 c4 10             	add    $0x10,%esp
801084a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801084a6:	83 ec 0c             	sub    $0xc,%esp
801084a9:	ff 75 e8             	pushl  -0x18(%ebp)
801084ac:	e8 77 a6 ff ff       	call   80102b28 <kfree>
801084b1:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801084b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801084bd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801084c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
801084ca:	0f 82 73 ff ff ff    	jb     80108443 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801084d0:	8b 45 10             	mov    0x10(%ebp),%eax
}
801084d3:	c9                   	leave  
801084d4:	c3                   	ret    

801084d5 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801084d5:	55                   	push   %ebp
801084d6:	89 e5                	mov    %esp,%ebp
801084d8:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801084db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801084df:	75 0d                	jne    801084ee <freevm+0x19>
    panic("freevm: no pgdir");
801084e1:	83 ec 0c             	sub    $0xc,%esp
801084e4:	68 87 8e 10 80       	push   $0x80108e87
801084e9:	e8 78 80 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801084ee:	83 ec 04             	sub    $0x4,%esp
801084f1:	6a 00                	push   $0x0
801084f3:	68 00 00 00 80       	push   $0x80000000
801084f8:	ff 75 08             	pushl  0x8(%ebp)
801084fb:	e8 18 ff ff ff       	call   80108418 <deallocuvm>
80108500:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108503:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010850a:	eb 4f                	jmp    8010855b <freevm+0x86>
    if(pgdir[i] & PTE_P){
8010850c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010850f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108516:	8b 45 08             	mov    0x8(%ebp),%eax
80108519:	01 d0                	add    %edx,%eax
8010851b:	8b 00                	mov    (%eax),%eax
8010851d:	83 e0 01             	and    $0x1,%eax
80108520:	85 c0                	test   %eax,%eax
80108522:	74 33                	je     80108557 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108527:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010852e:	8b 45 08             	mov    0x8(%ebp),%eax
80108531:	01 d0                	add    %edx,%eax
80108533:	8b 00                	mov    (%eax),%eax
80108535:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010853a:	83 ec 0c             	sub    $0xc,%esp
8010853d:	50                   	push   %eax
8010853e:	e8 4a f4 ff ff       	call   8010798d <p2v>
80108543:	83 c4 10             	add    $0x10,%esp
80108546:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108549:	83 ec 0c             	sub    $0xc,%esp
8010854c:	ff 75 f0             	pushl  -0x10(%ebp)
8010854f:	e8 d4 a5 ff ff       	call   80102b28 <kfree>
80108554:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108557:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010855b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108562:	76 a8                	jbe    8010850c <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108564:	83 ec 0c             	sub    $0xc,%esp
80108567:	ff 75 08             	pushl  0x8(%ebp)
8010856a:	e8 b9 a5 ff ff       	call   80102b28 <kfree>
8010856f:	83 c4 10             	add    $0x10,%esp
}
80108572:	90                   	nop
80108573:	c9                   	leave  
80108574:	c3                   	ret    

80108575 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108575:	55                   	push   %ebp
80108576:	89 e5                	mov    %esp,%ebp
80108578:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010857b:	83 ec 04             	sub    $0x4,%esp
8010857e:	6a 00                	push   $0x0
80108580:	ff 75 0c             	pushl  0xc(%ebp)
80108583:	ff 75 08             	pushl  0x8(%ebp)
80108586:	e8 84 f8 ff ff       	call   80107e0f <walkpgdir>
8010858b:	83 c4 10             	add    $0x10,%esp
8010858e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108595:	75 0d                	jne    801085a4 <clearpteu+0x2f>
    panic("clearpteu");
80108597:	83 ec 0c             	sub    $0xc,%esp
8010859a:	68 98 8e 10 80       	push   $0x80108e98
8010859f:	e8 c2 7f ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
801085a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a7:	8b 00                	mov    (%eax),%eax
801085a9:	83 e0 fb             	and    $0xfffffffb,%eax
801085ac:	89 c2                	mov    %eax,%edx
801085ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b1:	89 10                	mov    %edx,(%eax)
}
801085b3:	90                   	nop
801085b4:	c9                   	leave  
801085b5:	c3                   	ret    

801085b6 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801085b6:	55                   	push   %ebp
801085b7:	89 e5                	mov    %esp,%ebp
801085b9:	53                   	push   %ebx
801085ba:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801085bd:	e8 7d f9 ff ff       	call   80107f3f <setupkvm>
801085c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801085c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801085c9:	75 0a                	jne    801085d5 <copyuvm+0x1f>
    return 0;
801085cb:	b8 00 00 00 00       	mov    $0x0,%eax
801085d0:	e9 f8 00 00 00       	jmp    801086cd <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
801085d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801085dc:	e9 c4 00 00 00       	jmp    801086a5 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801085e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e4:	83 ec 04             	sub    $0x4,%esp
801085e7:	6a 00                	push   $0x0
801085e9:	50                   	push   %eax
801085ea:	ff 75 08             	pushl  0x8(%ebp)
801085ed:	e8 1d f8 ff ff       	call   80107e0f <walkpgdir>
801085f2:	83 c4 10             	add    $0x10,%esp
801085f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801085f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801085fc:	75 0d                	jne    8010860b <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801085fe:	83 ec 0c             	sub    $0xc,%esp
80108601:	68 a2 8e 10 80       	push   $0x80108ea2
80108606:	e8 5b 7f ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
8010860b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010860e:	8b 00                	mov    (%eax),%eax
80108610:	83 e0 01             	and    $0x1,%eax
80108613:	85 c0                	test   %eax,%eax
80108615:	75 0d                	jne    80108624 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108617:	83 ec 0c             	sub    $0xc,%esp
8010861a:	68 bc 8e 10 80       	push   $0x80108ebc
8010861f:	e8 42 7f ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108624:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108627:	8b 00                	mov    (%eax),%eax
80108629:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010862e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108631:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108634:	8b 00                	mov    (%eax),%eax
80108636:	25 ff 0f 00 00       	and    $0xfff,%eax
8010863b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010863e:	e8 82 a5 ff ff       	call   80102bc5 <kalloc>
80108643:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108646:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010864a:	74 6a                	je     801086b6 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010864c:	83 ec 0c             	sub    $0xc,%esp
8010864f:	ff 75 e8             	pushl  -0x18(%ebp)
80108652:	e8 36 f3 ff ff       	call   8010798d <p2v>
80108657:	83 c4 10             	add    $0x10,%esp
8010865a:	83 ec 04             	sub    $0x4,%esp
8010865d:	68 00 10 00 00       	push   $0x1000
80108662:	50                   	push   %eax
80108663:	ff 75 e0             	pushl  -0x20(%ebp)
80108666:	e8 64 cd ff ff       	call   801053cf <memmove>
8010866b:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010866e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108671:	83 ec 0c             	sub    $0xc,%esp
80108674:	ff 75 e0             	pushl  -0x20(%ebp)
80108677:	e8 04 f3 ff ff       	call   80107980 <v2p>
8010867c:	83 c4 10             	add    $0x10,%esp
8010867f:	89 c2                	mov    %eax,%edx
80108681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108684:	83 ec 0c             	sub    $0xc,%esp
80108687:	53                   	push   %ebx
80108688:	52                   	push   %edx
80108689:	68 00 10 00 00       	push   $0x1000
8010868e:	50                   	push   %eax
8010868f:	ff 75 f0             	pushl  -0x10(%ebp)
80108692:	e8 18 f8 ff ff       	call   80107eaf <mappages>
80108697:	83 c4 20             	add    $0x20,%esp
8010869a:	85 c0                	test   %eax,%eax
8010869c:	78 1b                	js     801086b9 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010869e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801086a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086ab:	0f 82 30 ff ff ff    	jb     801085e1 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801086b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086b4:	eb 17                	jmp    801086cd <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801086b6:	90                   	nop
801086b7:	eb 01                	jmp    801086ba <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801086b9:	90                   	nop
  }
  return d;

bad:
  freevm(d);
801086ba:	83 ec 0c             	sub    $0xc,%esp
801086bd:	ff 75 f0             	pushl  -0x10(%ebp)
801086c0:	e8 10 fe ff ff       	call   801084d5 <freevm>
801086c5:	83 c4 10             	add    $0x10,%esp
  return 0;
801086c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801086cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801086d0:	c9                   	leave  
801086d1:	c3                   	ret    

801086d2 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801086d2:	55                   	push   %ebp
801086d3:	89 e5                	mov    %esp,%ebp
801086d5:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801086d8:	83 ec 04             	sub    $0x4,%esp
801086db:	6a 00                	push   $0x0
801086dd:	ff 75 0c             	pushl  0xc(%ebp)
801086e0:	ff 75 08             	pushl  0x8(%ebp)
801086e3:	e8 27 f7 ff ff       	call   80107e0f <walkpgdir>
801086e8:	83 c4 10             	add    $0x10,%esp
801086eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801086ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f1:	8b 00                	mov    (%eax),%eax
801086f3:	83 e0 01             	and    $0x1,%eax
801086f6:	85 c0                	test   %eax,%eax
801086f8:	75 07                	jne    80108701 <uva2ka+0x2f>
    return 0;
801086fa:	b8 00 00 00 00       	mov    $0x0,%eax
801086ff:	eb 29                	jmp    8010872a <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108704:	8b 00                	mov    (%eax),%eax
80108706:	83 e0 04             	and    $0x4,%eax
80108709:	85 c0                	test   %eax,%eax
8010870b:	75 07                	jne    80108714 <uva2ka+0x42>
    return 0;
8010870d:	b8 00 00 00 00       	mov    $0x0,%eax
80108712:	eb 16                	jmp    8010872a <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108714:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108717:	8b 00                	mov    (%eax),%eax
80108719:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010871e:	83 ec 0c             	sub    $0xc,%esp
80108721:	50                   	push   %eax
80108722:	e8 66 f2 ff ff       	call   8010798d <p2v>
80108727:	83 c4 10             	add    $0x10,%esp
}
8010872a:	c9                   	leave  
8010872b:	c3                   	ret    

8010872c <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010872c:	55                   	push   %ebp
8010872d:	89 e5                	mov    %esp,%ebp
8010872f:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108732:	8b 45 10             	mov    0x10(%ebp),%eax
80108735:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108738:	eb 7f                	jmp    801087b9 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
8010873a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010873d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108742:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108745:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108748:	83 ec 08             	sub    $0x8,%esp
8010874b:	50                   	push   %eax
8010874c:	ff 75 08             	pushl  0x8(%ebp)
8010874f:	e8 7e ff ff ff       	call   801086d2 <uva2ka>
80108754:	83 c4 10             	add    $0x10,%esp
80108757:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010875a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010875e:	75 07                	jne    80108767 <copyout+0x3b>
      return -1;
80108760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108765:	eb 61                	jmp    801087c8 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108767:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010876a:	2b 45 0c             	sub    0xc(%ebp),%eax
8010876d:	05 00 10 00 00       	add    $0x1000,%eax
80108772:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108775:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108778:	3b 45 14             	cmp    0x14(%ebp),%eax
8010877b:	76 06                	jbe    80108783 <copyout+0x57>
      n = len;
8010877d:	8b 45 14             	mov    0x14(%ebp),%eax
80108780:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108783:	8b 45 0c             	mov    0xc(%ebp),%eax
80108786:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108789:	89 c2                	mov    %eax,%edx
8010878b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010878e:	01 d0                	add    %edx,%eax
80108790:	83 ec 04             	sub    $0x4,%esp
80108793:	ff 75 f0             	pushl  -0x10(%ebp)
80108796:	ff 75 f4             	pushl  -0xc(%ebp)
80108799:	50                   	push   %eax
8010879a:	e8 30 cc ff ff       	call   801053cf <memmove>
8010879f:	83 c4 10             	add    $0x10,%esp
    len -= n;
801087a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087a5:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801087a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087ab:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801087ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087b1:	05 00 10 00 00       	add    $0x1000,%eax
801087b6:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801087b9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801087bd:	0f 85 77 ff ff ff    	jne    8010873a <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801087c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801087c8:	c9                   	leave  
801087c9:	c3                   	ret    
