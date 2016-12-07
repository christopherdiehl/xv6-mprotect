
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp
8010002d:	b8 d6 37 10 80       	mov    $0x801037d6,%eax
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
8010003d:	68 6c 88 10 80       	push   $0x8010886c
80100042:	68 80 c6 10 80       	push   $0x8010c680
80100047:	e8 6b 50 00 00       	call   801050b7 <initlock>
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
801000c1:	e8 13 50 00 00       	call   801050d9 <acquire>
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
8010010c:	e8 2f 50 00 00       	call   80105140 <release>
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
80100188:	e8 b3 4f 00 00       	call   80105140 <release>
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
801001aa:	68 73 88 10 80       	push   $0x80108873
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
80100204:	68 84 88 10 80       	push   $0x80108884
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
80100243:	68 8b 88 10 80       	push   $0x8010888b
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 c6 10 80       	push   $0x8010c680
80100255:	e8 7f 4e 00 00       	call   801050d9 <acquire>
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
801002c9:	e8 72 4e 00 00       	call   80105140 <release>
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
801003e2:	e8 f2 4c 00 00       	call   801050d9 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 92 88 10 80       	push   $0x80108892
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
801004cd:	c7 45 ec 9b 88 10 80 	movl   $0x8010889b,-0x14(%ebp)
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
8010055b:	e8 e0 4b 00 00       	call   80105140 <release>
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
8010058b:	68 a2 88 10 80       	push   $0x801088a2
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
801005aa:	68 b1 88 10 80       	push   $0x801088b1
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 cb 4b 00 00       	call   80105192 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 b3 88 10 80       	push   $0x801088b3
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
801006db:	e8 1b 4d 00 00       	call   801053fb <memmove>
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
80100705:	e8 32 4c 00 00       	call   8010533c <memset>
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
8010079a:	e8 e2 66 00 00       	call   80106e81 <uartputc>
8010079f:	83 c4 10             	add    $0x10,%esp
801007a2:	83 ec 0c             	sub    $0xc,%esp
801007a5:	6a 20                	push   $0x20
801007a7:	e8 d5 66 00 00       	call   80106e81 <uartputc>
801007ac:	83 c4 10             	add    $0x10,%esp
801007af:	83 ec 0c             	sub    $0xc,%esp
801007b2:	6a 08                	push   $0x8
801007b4:	e8 c8 66 00 00       	call   80106e81 <uartputc>
801007b9:	83 c4 10             	add    $0x10,%esp
801007bc:	eb 0e                	jmp    801007cc <consputc+0x56>
  } else
    uartputc(c);
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	ff 75 08             	pushl  0x8(%ebp)
801007c4:	e8 b8 66 00 00       	call   80106e81 <uartputc>
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
801007eb:	e8 e9 48 00 00       	call   801050d9 <acquire>
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
80100954:	e8 e7 47 00 00       	call   80105140 <release>
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
80100981:	e8 53 47 00 00       	call   801050d9 <acquire>
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
801009a3:	e8 98 47 00 00       	call   80105140 <release>
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
80100a4e:	e8 ed 46 00 00       	call   80105140 <release>
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
80100a8c:	e8 48 46 00 00       	call   801050d9 <acquire>
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
80100ace:	e8 6d 46 00 00       	call   80105140 <release>
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
80100af2:	68 b7 88 10 80       	push   $0x801088b7
80100af7:	68 e0 b5 10 80       	push   $0x8010b5e0
80100afc:	e8 b6 45 00 00       	call   801050b7 <initlock>
80100b01:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b04:	83 ec 08             	sub    $0x8,%esp
80100b07:	68 bf 88 10 80       	push   $0x801088bf
80100b0c:	68 a0 07 11 80       	push   $0x801107a0
80100b11:	e8 a1 45 00 00       	call   801050b7 <initlock>
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
80100bcf:	e8 02 74 00 00       	call   80107fd6 <setupkvm>
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
80100c55:	e8 95 77 00 00       	call   801083ef <allocuvm>
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
80100c88:	e8 19 76 00 00       	call   801082a6 <loaduvm>
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
80100cf7:	e8 f3 76 00 00       	call   801083ef <allocuvm>
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
80100d1b:	e8 f5 78 00 00       	call   80108615 <clearpteu>
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
80100d54:	e8 30 48 00 00       	call   80105589 <strlen>
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
80100d81:	e8 03 48 00 00       	call   80105589 <strlen>
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
80100da7:	e8 20 7a 00 00       	call   801087cc <copyout>
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
80100e43:	e8 84 79 00 00       	call   801087cc <copyout>
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
80100e94:	e8 a6 46 00 00       	call   8010553f <safestrcpy>
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
80100eea:	e8 ce 71 00 00       	call   801080bd <switchuvm>
80100eef:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
80100ef5:	ff 75 d0             	pushl  -0x30(%ebp)
80100ef8:	e8 78 76 00 00       	call   80108575 <freevm>
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
80100f32:	e8 3e 76 00 00       	call   80108575 <freevm>
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
80100f63:	68 c5 88 10 80       	push   $0x801088c5
80100f68:	68 60 08 11 80       	push   $0x80110860
80100f6d:	e8 45 41 00 00       	call   801050b7 <initlock>
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
80100f86:	e8 4e 41 00 00       	call   801050d9 <acquire>
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
80100fb3:	e8 88 41 00 00       	call   80105140 <release>
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
80100fd6:	e8 65 41 00 00       	call   80105140 <release>
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
80100ff3:	e8 e1 40 00 00       	call   801050d9 <acquire>
80100ff8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffe:	8b 40 04             	mov    0x4(%eax),%eax
80101001:	85 c0                	test   %eax,%eax
80101003:	7f 0d                	jg     80101012 <filedup+0x2d>
    panic("filedup");
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	68 cc 88 10 80       	push   $0x801088cc
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
80101029:	e8 12 41 00 00       	call   80105140 <release>
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
80101044:	e8 90 40 00 00       	call   801050d9 <acquire>
80101049:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
8010104f:	8b 40 04             	mov    0x4(%eax),%eax
80101052:	85 c0                	test   %eax,%eax
80101054:	7f 0d                	jg     80101063 <fileclose+0x2d>
    panic("fileclose");
80101056:	83 ec 0c             	sub    $0xc,%esp
80101059:	68 d4 88 10 80       	push   $0x801088d4
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
80101084:	e8 b7 40 00 00       	call   80105140 <release>
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
801010d2:	e8 69 40 00 00       	call   80105140 <release>
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
80101221:	68 de 88 10 80       	push   $0x801088de
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
80101324:	68 e7 88 10 80       	push   $0x801088e7
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
8010135a:	68 f7 88 10 80       	push   $0x801088f7
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
80101392:	e8 64 40 00 00       	call   801053fb <memmove>
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
801013d8:	e8 5f 3f 00 00       	call   8010533c <memset>
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
80101551:	68 01 89 10 80       	push   $0x80108901
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
801015e7:	68 17 89 10 80       	push   $0x80108917
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
80101641:	68 2a 89 10 80       	push   $0x8010892a
80101646:	68 60 12 11 80       	push   $0x80111260
8010164b:	e8 67 3a 00 00       	call   801050b7 <initlock>
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
801016c6:	e8 71 3c 00 00       	call   8010533c <memset>
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
8010172b:	68 31 89 10 80       	push   $0x80108931
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
801017cb:	e8 2b 3c 00 00       	call   801053fb <memmove>
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
80101800:	e8 d4 38 00 00       	call   801050d9 <acquire>
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
8010184e:	e8 ed 38 00 00       	call   80105140 <release>
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
80101887:	68 43 89 10 80       	push   $0x80108943
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
801018c4:	e8 77 38 00 00       	call   80105140 <release>
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
801018df:	e8 f5 37 00 00       	call   801050d9 <acquire>
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
801018fe:	e8 3d 38 00 00       	call   80105140 <release>
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
80101924:	68 53 89 10 80       	push   $0x80108953
80101929:	e8 38 ec ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
8010192e:	83 ec 0c             	sub    $0xc,%esp
80101931:	68 60 12 11 80       	push   $0x80111260
80101936:	e8 9e 37 00 00       	call   801050d9 <acquire>
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
80101979:	e8 c2 37 00 00       	call   80105140 <release>
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
80101a20:	e8 d6 39 00 00       	call   801053fb <memmove>
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
80101a56:	68 59 89 10 80       	push   $0x80108959
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
80101a89:	68 68 89 10 80       	push   $0x80108968
80101a8e:	e8 d3 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a93:	83 ec 0c             	sub    $0xc,%esp
80101a96:	68 60 12 11 80       	push   $0x80111260
80101a9b:	e8 39 36 00 00       	call   801050d9 <acquire>
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
80101aca:	e8 71 36 00 00       	call   80105140 <release>
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
80101ae3:	e8 f1 35 00 00       	call   801050d9 <acquire>
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
80101b2b:	68 70 89 10 80       	push   $0x80108970
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
80101b4e:	e8 ed 35 00 00       	call   80105140 <release>
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
80101b83:	e8 51 35 00 00       	call   801050d9 <acquire>
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
80101bba:	e8 81 35 00 00       	call   80105140 <release>
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
80101cfa:	68 7a 89 10 80       	push   $0x8010897a
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
80101f91:	e8 65 34 00 00       	call   801053fb <memmove>
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
801020e3:	e8 13 33 00 00       	call   801053fb <memmove>
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
80102163:	e8 29 33 00 00       	call   80105491 <strncmp>
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
80102183:	68 8d 89 10 80       	push   $0x8010898d
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
801021b2:	68 9f 89 10 80       	push   $0x8010899f
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
80102287:	68 9f 89 10 80       	push   $0x8010899f
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
801022c2:	e8 20 32 00 00       	call   801054e7 <strncpy>
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
801022ee:	68 ac 89 10 80       	push   $0x801089ac
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
80102364:	e8 92 30 00 00       	call   801053fb <memmove>
80102369:	83 c4 10             	add    $0x10,%esp
8010236c:	eb 26                	jmp    80102394 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102371:	83 ec 04             	sub    $0x4,%esp
80102374:	50                   	push   %eax
80102375:	ff 75 f4             	pushl  -0xc(%ebp)
80102378:	ff 75 0c             	pushl  0xc(%ebp)
8010237b:	e8 7b 30 00 00       	call   801053fb <memmove>
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
801025d0:	68 b4 89 10 80       	push   $0x801089b4
801025d5:	68 20 b6 10 80       	push   $0x8010b620
801025da:	e8 d8 2a 00 00       	call   801050b7 <initlock>
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
80102684:	68 b8 89 10 80       	push   $0x801089b8
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
801027a5:	e8 2f 29 00 00       	call   801050d9 <acquire>
801027aa:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027ad:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027b9:	75 15                	jne    801027d0 <ideintr+0x39>
    release(&idelock);
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	68 20 b6 10 80       	push   $0x8010b620
801027c3:	e8 78 29 00 00       	call   80105140 <release>
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
80102862:	e8 d9 28 00 00       	call   80105140 <release>
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
80102881:	68 c1 89 10 80       	push   $0x801089c1
80102886:	e8 db dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010288b:	8b 45 08             	mov    0x8(%ebp),%eax
8010288e:	8b 00                	mov    (%eax),%eax
80102890:	83 e0 06             	and    $0x6,%eax
80102893:	83 f8 02             	cmp    $0x2,%eax
80102896:	75 0d                	jne    801028a5 <iderw+0x39>
    panic("iderw: nothing to do");
80102898:	83 ec 0c             	sub    $0xc,%esp
8010289b:	68 d5 89 10 80       	push   $0x801089d5
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
801028bb:	68 ea 89 10 80       	push   $0x801089ea
801028c0:	e8 a1 dc ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028c5:	83 ec 0c             	sub    $0xc,%esp
801028c8:	68 20 b6 10 80       	push   $0x8010b620
801028cd:	e8 07 28 00 00       	call   801050d9 <acquire>
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
80102946:	e8 f5 27 00 00       	call   80105140 <release>
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
801029d7:	68 08 8a 10 80       	push   $0x80108a08
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
80102a97:	68 3a 8a 10 80       	push   $0x80108a3a
80102a9c:	68 40 22 11 80       	push   $0x80112240
80102aa1:	e8 11 26 00 00       	call   801050b7 <initlock>
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
80102b58:	68 3f 8a 10 80       	push   $0x80108a3f
80102b5d:	e8 04 da ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b62:	83 ec 04             	sub    $0x4,%esp
80102b65:	68 00 10 00 00       	push   $0x1000
80102b6a:	6a 01                	push   $0x1
80102b6c:	ff 75 08             	pushl  0x8(%ebp)
80102b6f:	e8 c8 27 00 00       	call   8010533c <memset>
80102b74:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b77:	a1 74 22 11 80       	mov    0x80112274,%eax
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	74 10                	je     80102b90 <kfree+0x68>
    acquire(&kmem.lock);
80102b80:	83 ec 0c             	sub    $0xc,%esp
80102b83:	68 40 22 11 80       	push   $0x80112240
80102b88:	e8 4c 25 00 00       	call   801050d9 <acquire>
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
80102bba:	e8 81 25 00 00       	call   80105140 <release>
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
80102bdc:	e8 f8 24 00 00       	call   801050d9 <acquire>
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
80102c0d:	e8 2e 25 00 00       	call   80105140 <release>
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
80102f58:	68 48 8a 10 80       	push   $0x80108a48
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
80103183:	e8 1b 22 00 00       	call   801053a3 <memcmp>
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
80103297:	68 74 8a 10 80       	push   $0x80108a74
8010329c:	68 80 22 11 80       	push   $0x80112280
801032a1:	e8 11 1e 00 00       	call   801050b7 <initlock>
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
80103354:	e8 a2 20 00 00       	call   801053fb <memmove>
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
801034c2:	e8 12 1c 00 00       	call   801050d9 <acquire>
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
80103534:	e8 07 1c 00 00       	call   80105140 <release>
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
80103555:	e8 7f 1b 00 00       	call   801050d9 <acquire>
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
80103576:	68 78 8a 10 80       	push   $0x80108a78
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
801035b4:	e8 87 1b 00 00       	call   80105140 <release>
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
801035cf:	e8 05 1b 00 00       	call   801050d9 <acquire>
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
801035f9:	e8 42 1b 00 00       	call   80105140 <release>
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
80103675:	e8 81 1d 00 00       	call   801053fb <memmove>
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
80103711:	68 87 8a 10 80       	push   $0x80108a87
80103716:	e8 4b ce ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010371b:	a1 bc 22 11 80       	mov    0x801122bc,%eax
80103720:	85 c0                	test   %eax,%eax
80103722:	7f 0d                	jg     80103731 <log_write+0x45>
    panic("log_write outside of trans");
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 9d 8a 10 80       	push   $0x80108a9d
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
801037fc:	e8 87 48 00 00       	call   80108088 <kvmalloc>
  mpinit();        // collect info about this machine
80103801:	e8 48 04 00 00       	call   80103c4e <mpinit>
  lapicinit();
80103806:	e8 02 f6 ff ff       	call   80102e0d <lapicinit>
  seginit();       // set up segments
8010380b:	e8 21 42 00 00       	call   80107a31 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103810:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103816:	0f b6 00             	movzbl (%eax),%eax
80103819:	0f b6 c0             	movzbl %al,%eax
8010381c:	83 ec 08             	sub    $0x8,%esp
8010381f:	50                   	push   %eax
80103820:	68 b8 8a 10 80       	push   $0x80108ab8
80103825:	e8 9c cb ff ff       	call   801003c6 <cprintf>
8010382a:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010382d:	e8 72 06 00 00       	call   80103ea4 <picinit>
  ioapicinit();    // another interrupt controller
80103832:	e8 4c f1 ff ff       	call   80102983 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103837:	e8 ad d2 ff ff       	call   80100ae9 <consoleinit>
  uartinit();      // serial port
8010383c:	e8 4c 35 00 00       	call   80106d8d <uartinit>
  pinit();         // process table
80103841:	e8 5b 0b 00 00       	call   801043a1 <pinit>
  tvinit();        // trap vectors
80103846:	e8 71 30 00 00       	call   801068bc <tvinit>
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
80103868:	e8 ac 2f 00 00       	call   80106819 <timerinit>
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
80103897:	e8 04 48 00 00       	call   801080a0 <switchkvm>
  seginit();
8010389c:	e8 90 41 00 00       	call   80107a31 <seginit>
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
801038c1:	68 cf 8a 10 80       	push   $0x80108acf
801038c6:	e8 fb ca ff ff       	call   801003c6 <cprintf>
801038cb:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801038ce:	e8 5f 31 00 00       	call   80106a32 <idtinit>
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
80103919:	e8 dd 1a 00 00       	call   801053fb <memmove>
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
80103aa7:	68 e0 8a 10 80       	push   $0x80108ae0
80103aac:	ff 75 f4             	pushl  -0xc(%ebp)
80103aaf:	e8 ef 18 00 00       	call   801053a3 <memcmp>
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
80103be5:	68 e5 8a 10 80       	push   $0x80108ae5
80103bea:	ff 75 f0             	pushl  -0x10(%ebp)
80103bed:	e8 b1 17 00 00       	call   801053a3 <memcmp>
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
80103cc1:	8b 04 85 28 8b 10 80 	mov    -0x7fef74d8(,%eax,4),%eax
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
80103cf7:	68 ea 8a 10 80       	push   $0x80108aea
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
80103d8a:	68 08 8b 10 80       	push   $0x80108b08
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
8010402b:	68 3c 8b 10 80       	push   $0x80108b3c
80104030:	50                   	push   %eax
80104031:	e8 81 10 00 00       	call   801050b7 <initlock>
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
801040ed:	e8 e7 0f 00 00       	call   801050d9 <acquire>
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
80104160:	e8 db 0f 00 00       	call   80105140 <release>
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
8010417f:	e8 bc 0f 00 00       	call   80105140 <release>
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
80104197:	e8 3d 0f 00 00       	call   801050d9 <acquire>
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
801041cc:	e8 6f 0f 00 00       	call   80105140 <release>
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
8010427b:	e8 c0 0e 00 00       	call   80105140 <release>
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
80104296:	e8 3e 0e 00 00       	call   801050d9 <acquire>
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
801042b4:	e8 87 0e 00 00       	call   80105140 <release>
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
8010437a:	e8 c1 0d 00 00       	call   80105140 <release>
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
801043aa:	68 41 8b 10 80       	push   $0x80108b41
801043af:	68 80 29 11 80       	push   $0x80112980
801043b4:	e8 fe 0c 00 00       	call   801050b7 <initlock>
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
801043cd:	e8 07 0d 00 00       	call   801050d9 <acquire>
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
80104400:	e8 3b 0d 00 00       	call   80105140 <release>
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
80104439:	e8 02 0d 00 00       	call   80105140 <release>
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
8010448b:	ba 76 68 10 80       	mov    $0x80106876,%edx
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
801044b0:	e8 87 0e 00 00       	call   8010533c <memset>
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
80104505:	e8 cc 3a 00 00       	call   80107fd6 <setupkvm>
8010450a:	89 c2                	mov    %eax,%edx
8010450c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010450f:	89 50 04             	mov    %edx,0x4(%eax)
80104512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104515:	8b 40 04             	mov    0x4(%eax),%eax
80104518:	85 c0                	test   %eax,%eax
8010451a:	75 0d                	jne    80104529 <userinit+0x3a>
    panic("userinit: out of memory?");
8010451c:	83 ec 0c             	sub    $0xc,%esp
8010451f:	68 48 8b 10 80       	push   $0x80108b48
80104524:	e8 3d c0 ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104529:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010452e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104531:	8b 40 04             	mov    0x4(%eax),%eax
80104534:	83 ec 04             	sub    $0x4,%esp
80104537:	52                   	push   %edx
80104538:	68 00 b5 10 80       	push   $0x8010b500
8010453d:	50                   	push   %eax
8010453e:	e8 ed 3c 00 00       	call   80108230 <inituvm>
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
8010455d:	e8 da 0d 00 00       	call   8010533c <memset>
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
801045d7:	68 61 8b 10 80       	push   $0x80108b61
801045dc:	50                   	push   %eax
801045dd:	e8 5d 0f 00 00       	call   8010553f <safestrcpy>
801045e2:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801045e5:	83 ec 0c             	sub    $0xc,%esp
801045e8:	68 6a 8b 10 80       	push   $0x80108b6a
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
8010463a:	e8 b0 3d 00 00       	call   801083ef <allocuvm>
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
80104671:	e8 42 3e 00 00       	call   801084b8 <deallocuvm>
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
8010469e:	e8 1a 3a 00 00       	call   801080bd <switchuvm>
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
801046e4:	e8 6d 3f 00 00       	call   80108656 <copyuvm>
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
801047f8:	e8 42 0d 00 00       	call   8010553f <safestrcpy>
801047fd:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104800:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104803:	8b 40 10             	mov    0x10(%eax),%eax
80104806:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104809:	83 ec 0c             	sub    $0xc,%esp
8010480c:	68 80 29 11 80       	push   $0x80112980
80104811:	e8 c3 08 00 00       	call   801050d9 <acquire>
80104816:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104819:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010481c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104823:	83 ec 0c             	sub    $0xc,%esp
80104826:	68 80 29 11 80       	push   $0x80112980
8010482b:	e8 10 09 00 00       	call   80105140 <release>
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
80104857:	68 6c 8b 10 80       	push   $0x80108b6c
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
801048ec:	e8 e8 07 00 00       	call   801050d9 <acquire>
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
8010496f:	68 79 8b 10 80       	push   $0x80108b79
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
80104987:	e8 4d 07 00 00       	call   801050d9 <acquire>
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
801049f7:	e8 79 3b 00 00       	call   80108575 <freevm>
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
80104a36:	e8 05 07 00 00       	call   80105140 <release>
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
80104a73:	e8 c8 06 00 00       	call   80105140 <release>
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
80104ab3:	e8 21 06 00 00       	call   801050d9 <acquire>
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
80104ade:	e8 da 35 00 00       	call   801080bd <switchuvm>
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
80104b08:	e8 a3 0a 00 00       	call   801055b0 <swtch>
80104b0d:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104b10:	e8 8b 35 00 00       	call   801080a0 <switchkvm>

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
80104b3b:	e8 00 06 00 00       	call   80105140 <release>
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
80104b56:	e8 b1 06 00 00       	call   8010520c <holding>
80104b5b:	83 c4 10             	add    $0x10,%esp
80104b5e:	85 c0                	test   %eax,%eax
80104b60:	75 0d                	jne    80104b6f <sched+0x27>
    panic("sched ptable.lock");
80104b62:	83 ec 0c             	sub    $0xc,%esp
80104b65:	68 85 8b 10 80       	push   $0x80108b85
80104b6a:	e8 f7 b9 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104b6f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b75:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104b7b:	83 f8 01             	cmp    $0x1,%eax
80104b7e:	74 0d                	je     80104b8d <sched+0x45>
    panic("sched locks");
80104b80:	83 ec 0c             	sub    $0xc,%esp
80104b83:	68 97 8b 10 80       	push   $0x80108b97
80104b88:	e8 d9 b9 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104b8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b93:	8b 40 0c             	mov    0xc(%eax),%eax
80104b96:	83 f8 04             	cmp    $0x4,%eax
80104b99:	75 0d                	jne    80104ba8 <sched+0x60>
    panic("sched running");
80104b9b:	83 ec 0c             	sub    $0xc,%esp
80104b9e:	68 a3 8b 10 80       	push   $0x80108ba3
80104ba3:	e8 be b9 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104ba8:	e8 dd f7 ff ff       	call   8010438a <readeflags>
80104bad:	25 00 02 00 00       	and    $0x200,%eax
80104bb2:	85 c0                	test   %eax,%eax
80104bb4:	74 0d                	je     80104bc3 <sched+0x7b>
    panic("sched interruptible");
80104bb6:	83 ec 0c             	sub    $0xc,%esp
80104bb9:	68 b1 8b 10 80       	push   $0x80108bb1
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
80104bea:	e8 c1 09 00 00       	call   801055b0 <swtch>
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
80104c12:	e8 c2 04 00 00       	call   801050d9 <acquire>
80104c17:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104c1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c20:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104c27:	e8 1c ff ff ff       	call   80104b48 <sched>
  release(&ptable.lock);
80104c2c:	83 ec 0c             	sub    $0xc,%esp
80104c2f:	68 80 29 11 80       	push   $0x80112980
80104c34:	e8 07 05 00 00       	call   80105140 <release>
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
80104c4d:	e8 ee 04 00 00       	call   80105140 <release>
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
80104c83:	68 c5 8b 10 80       	push   $0x80108bc5
80104c88:	e8 d9 b8 ff ff       	call   80100566 <panic>

  if(lk == 0)
80104c8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104c91:	75 0d                	jne    80104ca0 <sleep+0x30>
    panic("sleep without lk");
80104c93:	83 ec 0c             	sub    $0xc,%esp
80104c96:	68 cb 8b 10 80       	push   $0x80108bcb
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
80104cb1:	e8 23 04 00 00       	call   801050d9 <acquire>
80104cb6:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104cb9:	83 ec 0c             	sub    $0xc,%esp
80104cbc:	ff 75 0c             	pushl  0xc(%ebp)
80104cbf:	e8 7c 04 00 00       	call   80105140 <release>
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
80104d03:	e8 38 04 00 00       	call   80105140 <release>
80104d08:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104d0b:	83 ec 0c             	sub    $0xc,%esp
80104d0e:	ff 75 0c             	pushl  0xc(%ebp)
80104d11:	e8 c3 03 00 00       	call   801050d9 <acquire>
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
80104d6c:	e8 68 03 00 00       	call   801050d9 <acquire>
80104d71:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104d74:	83 ec 0c             	sub    $0xc,%esp
80104d77:	ff 75 08             	pushl  0x8(%ebp)
80104d7a:	e8 9d ff ff ff       	call   80104d1c <wakeup1>
80104d7f:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104d82:	83 ec 0c             	sub    $0xc,%esp
80104d85:	68 80 29 11 80       	push   $0x80112980
80104d8a:	e8 b1 03 00 00       	call   80105140 <release>
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
80104da3:	e8 31 03 00 00       	call   801050d9 <acquire>
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
80104de6:	e8 55 03 00 00       	call   80105140 <release>
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
80104e0d:	e8 2e 03 00 00       	call   80105140 <release>
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
80104e6a:	c7 45 ec dc 8b 10 80 	movl   $0x80108bdc,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e74:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e7a:	8b 40 10             	mov    0x10(%eax),%eax
80104e7d:	52                   	push   %edx
80104e7e:	ff 75 ec             	pushl  -0x14(%ebp)
80104e81:	50                   	push   %eax
80104e82:	68 e0 8b 10 80       	push   $0x80108be0
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
80104eb0:	e8 dd 02 00 00       	call   80105192 <getcallerpcs>
80104eb5:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104eb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104ebf:	eb 1c                	jmp    80104edd <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec4:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ec8:	83 ec 08             	sub    $0x8,%esp
80104ecb:	50                   	push   %eax
80104ecc:	68 e9 8b 10 80       	push   $0x80108be9
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
80104ef1:	68 ed 8b 10 80       	push   $0x80108bed
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

void signal_deliver(int signum,siginfo_t si)
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
  *((uint*)(proc->tf->esp - 20)) = si.addr;       //address mem fault occured
80104fa0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fa6:	8b 40 18             	mov    0x18(%eax),%eax
80104fa9:	8b 40 44             	mov    0x44(%eax),%eax
80104fac:	83 e8 14             	sub    $0x14,%eax
80104faf:	89 c2                	mov    %eax,%edx
80104fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fb4:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 24)) = si.type;       //address mem fault occured
80104fb6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fbc:	8b 40 18             	mov    0x18(%eax),%eax
80104fbf:	8b 40 44             	mov    0x44(%eax),%eax
80104fc2:	83 e8 18             	sub    $0x18,%eax
80104fc5:	89 c2                	mov    %eax,%edx
80104fc7:	8b 45 10             	mov    0x10(%ebp),%eax
80104fca:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 28)) = (uint) signum;			// signal number
80104fcc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fd2:	8b 40 18             	mov    0x18(%eax),%eax
80104fd5:	8b 40 44             	mov    0x44(%eax),%eax
80104fd8:	83 e8 1c             	sub    $0x1c,%eax
80104fdb:	89 c2                	mov    %eax,%edx
80104fdd:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe0:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 32)) = proc->restorer_addr;	// address of restorer
80104fe2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fe8:	8b 40 18             	mov    0x18(%eax),%eax
80104feb:	8b 40 44             	mov    0x44(%eax),%eax
80104fee:	83 e8 20             	sub    $0x20,%eax
80104ff1:	89 c2                	mov    %eax,%edx
80104ff3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ff9:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104fff:	89 02                	mov    %eax,(%edx)
	proc->tf->esp -= 32;
80105001:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105007:	8b 40 18             	mov    0x18(%eax),%eax
8010500a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105011:	8b 52 18             	mov    0x18(%edx),%edx
80105014:	8b 52 44             	mov    0x44(%edx),%edx
80105017:	83 ea 20             	sub    $0x20,%edx
8010501a:	89 50 44             	mov    %edx,0x44(%eax)
	proc->tf->eip = (uint) proc->handlers[signum];
8010501d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105023:	8b 40 18             	mov    0x18(%eax),%eax
80105026:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010502d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105030:	83 c1 1c             	add    $0x1c,%ecx
80105033:	8b 54 8a 0c          	mov    0xc(%edx,%ecx,4),%edx
80105037:	89 50 38             	mov    %edx,0x38(%eax)
}
8010503a:	90                   	nop
8010503b:	c9                   	leave  
8010503c:	c3                   	ret    

8010503d <signal_register_handler>:

sighandler_t signal_register_handler(int signum, sighandler_t handler)
{
8010503d:	55                   	push   %ebp
8010503e:	89 e5                	mov    %esp,%ebp
80105040:	83 ec 10             	sub    $0x10,%esp
	if (!proc)
80105043:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105049:	85 c0                	test   %eax,%eax
8010504b:	75 07                	jne    80105054 <signal_register_handler+0x17>
		return (sighandler_t) -1;
8010504d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105052:	eb 29                	jmp    8010507d <signal_register_handler+0x40>

	sighandler_t previous = proc->handlers[signum];
80105054:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010505a:	8b 55 08             	mov    0x8(%ebp),%edx
8010505d:	83 c2 1c             	add    $0x1c,%edx
80105060:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105064:	89 45 fc             	mov    %eax,-0x4(%ebp)

	proc->handlers[signum] = handler;
80105067:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010506d:	8b 55 08             	mov    0x8(%ebp),%edx
80105070:	8d 4a 1c             	lea    0x1c(%edx),%ecx
80105073:	8b 55 0c             	mov    0xc(%ebp),%edx
80105076:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)

	return previous;
8010507a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010507d:	c9                   	leave  
8010507e:	c3                   	ret    

8010507f <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010507f:	55                   	push   %ebp
80105080:	89 e5                	mov    %esp,%ebp
80105082:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105085:	9c                   	pushf  
80105086:	58                   	pop    %eax
80105087:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010508a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010508d:	c9                   	leave  
8010508e:	c3                   	ret    

8010508f <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010508f:	55                   	push   %ebp
80105090:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105092:	fa                   	cli    
}
80105093:	90                   	nop
80105094:	5d                   	pop    %ebp
80105095:	c3                   	ret    

80105096 <sti>:

static inline void
sti(void)
{
80105096:	55                   	push   %ebp
80105097:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105099:	fb                   	sti    
}
8010509a:	90                   	nop
8010509b:	5d                   	pop    %ebp
8010509c:	c3                   	ret    

8010509d <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010509d:	55                   	push   %ebp
8010509e:	89 e5                	mov    %esp,%ebp
801050a0:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801050a3:	8b 55 08             	mov    0x8(%ebp),%edx
801050a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801050a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050ac:	f0 87 02             	lock xchg %eax,(%edx)
801050af:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801050b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050b5:	c9                   	leave  
801050b6:	c3                   	ret    

801050b7 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801050b7:	55                   	push   %ebp
801050b8:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801050ba:	8b 45 08             	mov    0x8(%ebp),%eax
801050bd:	8b 55 0c             	mov    0xc(%ebp),%edx
801050c0:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801050c3:	8b 45 08             	mov    0x8(%ebp),%eax
801050c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801050cc:	8b 45 08             	mov    0x8(%ebp),%eax
801050cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801050d6:	90                   	nop
801050d7:	5d                   	pop    %ebp
801050d8:	c3                   	ret    

801050d9 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801050d9:	55                   	push   %ebp
801050da:	89 e5                	mov    %esp,%ebp
801050dc:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801050df:	e8 52 01 00 00       	call   80105236 <pushcli>
  if(holding(lk))
801050e4:	8b 45 08             	mov    0x8(%ebp),%eax
801050e7:	83 ec 0c             	sub    $0xc,%esp
801050ea:	50                   	push   %eax
801050eb:	e8 1c 01 00 00       	call   8010520c <holding>
801050f0:	83 c4 10             	add    $0x10,%esp
801050f3:	85 c0                	test   %eax,%eax
801050f5:	74 0d                	je     80105104 <acquire+0x2b>
    panic("acquire");
801050f7:	83 ec 0c             	sub    $0xc,%esp
801050fa:	68 19 8c 10 80       	push   $0x80108c19
801050ff:	e8 62 b4 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105104:	90                   	nop
80105105:	8b 45 08             	mov    0x8(%ebp),%eax
80105108:	83 ec 08             	sub    $0x8,%esp
8010510b:	6a 01                	push   $0x1
8010510d:	50                   	push   %eax
8010510e:	e8 8a ff ff ff       	call   8010509d <xchg>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	75 eb                	jne    80105105 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010511a:	8b 45 08             	mov    0x8(%ebp),%eax
8010511d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105124:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105127:	8b 45 08             	mov    0x8(%ebp),%eax
8010512a:	83 c0 0c             	add    $0xc,%eax
8010512d:	83 ec 08             	sub    $0x8,%esp
80105130:	50                   	push   %eax
80105131:	8d 45 08             	lea    0x8(%ebp),%eax
80105134:	50                   	push   %eax
80105135:	e8 58 00 00 00       	call   80105192 <getcallerpcs>
8010513a:	83 c4 10             	add    $0x10,%esp
}
8010513d:	90                   	nop
8010513e:	c9                   	leave  
8010513f:	c3                   	ret    

80105140 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105146:	83 ec 0c             	sub    $0xc,%esp
80105149:	ff 75 08             	pushl  0x8(%ebp)
8010514c:	e8 bb 00 00 00       	call   8010520c <holding>
80105151:	83 c4 10             	add    $0x10,%esp
80105154:	85 c0                	test   %eax,%eax
80105156:	75 0d                	jne    80105165 <release+0x25>
    panic("release");
80105158:	83 ec 0c             	sub    $0xc,%esp
8010515b:	68 21 8c 10 80       	push   $0x80108c21
80105160:	e8 01 b4 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105165:	8b 45 08             	mov    0x8(%ebp),%eax
80105168:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010516f:	8b 45 08             	mov    0x8(%ebp),%eax
80105172:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105179:	8b 45 08             	mov    0x8(%ebp),%eax
8010517c:	83 ec 08             	sub    $0x8,%esp
8010517f:	6a 00                	push   $0x0
80105181:	50                   	push   %eax
80105182:	e8 16 ff ff ff       	call   8010509d <xchg>
80105187:	83 c4 10             	add    $0x10,%esp

  popcli();
8010518a:	e8 ec 00 00 00       	call   8010527b <popcli>
}
8010518f:	90                   	nop
80105190:	c9                   	leave  
80105191:	c3                   	ret    

80105192 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105192:	55                   	push   %ebp
80105193:	89 e5                	mov    %esp,%ebp
80105195:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105198:	8b 45 08             	mov    0x8(%ebp),%eax
8010519b:	83 e8 08             	sub    $0x8,%eax
8010519e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801051a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801051a8:	eb 38                	jmp    801051e2 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801051aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801051ae:	74 53                	je     80105203 <getcallerpcs+0x71>
801051b0:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801051b7:	76 4a                	jbe    80105203 <getcallerpcs+0x71>
801051b9:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801051bd:	74 44                	je     80105203 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801051bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801051c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801051cc:	01 c2                	add    %eax,%edx
801051ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051d1:	8b 40 04             	mov    0x4(%eax),%eax
801051d4:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801051d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051d9:	8b 00                	mov    (%eax),%eax
801051db:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801051de:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801051e2:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801051e6:	7e c2                	jle    801051aa <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801051e8:	eb 19                	jmp    80105203 <getcallerpcs+0x71>
    pcs[i] = 0;
801051ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801051f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801051f7:	01 d0                	add    %edx,%eax
801051f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801051ff:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105203:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105207:	7e e1                	jle    801051ea <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105209:	90                   	nop
8010520a:	c9                   	leave  
8010520b:	c3                   	ret    

8010520c <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010520c:	55                   	push   %ebp
8010520d:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010520f:	8b 45 08             	mov    0x8(%ebp),%eax
80105212:	8b 00                	mov    (%eax),%eax
80105214:	85 c0                	test   %eax,%eax
80105216:	74 17                	je     8010522f <holding+0x23>
80105218:	8b 45 08             	mov    0x8(%ebp),%eax
8010521b:	8b 50 08             	mov    0x8(%eax),%edx
8010521e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105224:	39 c2                	cmp    %eax,%edx
80105226:	75 07                	jne    8010522f <holding+0x23>
80105228:	b8 01 00 00 00       	mov    $0x1,%eax
8010522d:	eb 05                	jmp    80105234 <holding+0x28>
8010522f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105234:	5d                   	pop    %ebp
80105235:	c3                   	ret    

80105236 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105236:	55                   	push   %ebp
80105237:	89 e5                	mov    %esp,%ebp
80105239:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010523c:	e8 3e fe ff ff       	call   8010507f <readeflags>
80105241:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105244:	e8 46 fe ff ff       	call   8010508f <cli>
  if(cpu->ncli++ == 0)
80105249:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105250:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105256:	8d 48 01             	lea    0x1(%eax),%ecx
80105259:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
8010525f:	85 c0                	test   %eax,%eax
80105261:	75 15                	jne    80105278 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105263:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105269:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010526c:	81 e2 00 02 00 00    	and    $0x200,%edx
80105272:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105278:	90                   	nop
80105279:	c9                   	leave  
8010527a:	c3                   	ret    

8010527b <popcli>:

void
popcli(void)
{
8010527b:	55                   	push   %ebp
8010527c:	89 e5                	mov    %esp,%ebp
8010527e:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105281:	e8 f9 fd ff ff       	call   8010507f <readeflags>
80105286:	25 00 02 00 00       	and    $0x200,%eax
8010528b:	85 c0                	test   %eax,%eax
8010528d:	74 0d                	je     8010529c <popcli+0x21>
    panic("popcli - interruptible");
8010528f:	83 ec 0c             	sub    $0xc,%esp
80105292:	68 29 8c 10 80       	push   $0x80108c29
80105297:	e8 ca b2 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
8010529c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052a2:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801052a8:	83 ea 01             	sub    $0x1,%edx
801052ab:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801052b1:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801052b7:	85 c0                	test   %eax,%eax
801052b9:	79 0d                	jns    801052c8 <popcli+0x4d>
    panic("popcli");
801052bb:	83 ec 0c             	sub    $0xc,%esp
801052be:	68 40 8c 10 80       	push   $0x80108c40
801052c3:	e8 9e b2 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801052c8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052ce:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801052d4:	85 c0                	test   %eax,%eax
801052d6:	75 15                	jne    801052ed <popcli+0x72>
801052d8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052de:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801052e4:	85 c0                	test   %eax,%eax
801052e6:	74 05                	je     801052ed <popcli+0x72>
    sti();
801052e8:	e8 a9 fd ff ff       	call   80105096 <sti>
}
801052ed:	90                   	nop
801052ee:	c9                   	leave  
801052ef:	c3                   	ret    

801052f0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	57                   	push   %edi
801052f4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801052f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052f8:	8b 55 10             	mov    0x10(%ebp),%edx
801052fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801052fe:	89 cb                	mov    %ecx,%ebx
80105300:	89 df                	mov    %ebx,%edi
80105302:	89 d1                	mov    %edx,%ecx
80105304:	fc                   	cld    
80105305:	f3 aa                	rep stos %al,%es:(%edi)
80105307:	89 ca                	mov    %ecx,%edx
80105309:	89 fb                	mov    %edi,%ebx
8010530b:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010530e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105311:	90                   	nop
80105312:	5b                   	pop    %ebx
80105313:	5f                   	pop    %edi
80105314:	5d                   	pop    %ebp
80105315:	c3                   	ret    

80105316 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105316:	55                   	push   %ebp
80105317:	89 e5                	mov    %esp,%ebp
80105319:	57                   	push   %edi
8010531a:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010531b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010531e:	8b 55 10             	mov    0x10(%ebp),%edx
80105321:	8b 45 0c             	mov    0xc(%ebp),%eax
80105324:	89 cb                	mov    %ecx,%ebx
80105326:	89 df                	mov    %ebx,%edi
80105328:	89 d1                	mov    %edx,%ecx
8010532a:	fc                   	cld    
8010532b:	f3 ab                	rep stos %eax,%es:(%edi)
8010532d:	89 ca                	mov    %ecx,%edx
8010532f:	89 fb                	mov    %edi,%ebx
80105331:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105334:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105337:	90                   	nop
80105338:	5b                   	pop    %ebx
80105339:	5f                   	pop    %edi
8010533a:	5d                   	pop    %ebp
8010533b:	c3                   	ret    

8010533c <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010533c:	55                   	push   %ebp
8010533d:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
8010533f:	8b 45 08             	mov    0x8(%ebp),%eax
80105342:	83 e0 03             	and    $0x3,%eax
80105345:	85 c0                	test   %eax,%eax
80105347:	75 43                	jne    8010538c <memset+0x50>
80105349:	8b 45 10             	mov    0x10(%ebp),%eax
8010534c:	83 e0 03             	and    $0x3,%eax
8010534f:	85 c0                	test   %eax,%eax
80105351:	75 39                	jne    8010538c <memset+0x50>
    c &= 0xFF;
80105353:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010535a:	8b 45 10             	mov    0x10(%ebp),%eax
8010535d:	c1 e8 02             	shr    $0x2,%eax
80105360:	89 c1                	mov    %eax,%ecx
80105362:	8b 45 0c             	mov    0xc(%ebp),%eax
80105365:	c1 e0 18             	shl    $0x18,%eax
80105368:	89 c2                	mov    %eax,%edx
8010536a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010536d:	c1 e0 10             	shl    $0x10,%eax
80105370:	09 c2                	or     %eax,%edx
80105372:	8b 45 0c             	mov    0xc(%ebp),%eax
80105375:	c1 e0 08             	shl    $0x8,%eax
80105378:	09 d0                	or     %edx,%eax
8010537a:	0b 45 0c             	or     0xc(%ebp),%eax
8010537d:	51                   	push   %ecx
8010537e:	50                   	push   %eax
8010537f:	ff 75 08             	pushl  0x8(%ebp)
80105382:	e8 8f ff ff ff       	call   80105316 <stosl>
80105387:	83 c4 0c             	add    $0xc,%esp
8010538a:	eb 12                	jmp    8010539e <memset+0x62>
  } else
    stosb(dst, c, n);
8010538c:	8b 45 10             	mov    0x10(%ebp),%eax
8010538f:	50                   	push   %eax
80105390:	ff 75 0c             	pushl  0xc(%ebp)
80105393:	ff 75 08             	pushl  0x8(%ebp)
80105396:	e8 55 ff ff ff       	call   801052f0 <stosb>
8010539b:	83 c4 0c             	add    $0xc,%esp
  return dst;
8010539e:	8b 45 08             	mov    0x8(%ebp),%eax
}
801053a1:	c9                   	leave  
801053a2:	c3                   	ret    

801053a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801053a3:	55                   	push   %ebp
801053a4:	89 e5                	mov    %esp,%ebp
801053a6:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801053a9:	8b 45 08             	mov    0x8(%ebp),%eax
801053ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801053af:	8b 45 0c             	mov    0xc(%ebp),%eax
801053b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801053b5:	eb 30                	jmp    801053e7 <memcmp+0x44>
    if(*s1 != *s2)
801053b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053ba:	0f b6 10             	movzbl (%eax),%edx
801053bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053c0:	0f b6 00             	movzbl (%eax),%eax
801053c3:	38 c2                	cmp    %al,%dl
801053c5:	74 18                	je     801053df <memcmp+0x3c>
      return *s1 - *s2;
801053c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053ca:	0f b6 00             	movzbl (%eax),%eax
801053cd:	0f b6 d0             	movzbl %al,%edx
801053d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053d3:	0f b6 00             	movzbl (%eax),%eax
801053d6:	0f b6 c0             	movzbl %al,%eax
801053d9:	29 c2                	sub    %eax,%edx
801053db:	89 d0                	mov    %edx,%eax
801053dd:	eb 1a                	jmp    801053f9 <memcmp+0x56>
    s1++, s2++;
801053df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801053e3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801053e7:	8b 45 10             	mov    0x10(%ebp),%eax
801053ea:	8d 50 ff             	lea    -0x1(%eax),%edx
801053ed:	89 55 10             	mov    %edx,0x10(%ebp)
801053f0:	85 c0                	test   %eax,%eax
801053f2:	75 c3                	jne    801053b7 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801053f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053f9:	c9                   	leave  
801053fa:	c3                   	ret    

801053fb <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801053fb:	55                   	push   %ebp
801053fc:	89 e5                	mov    %esp,%ebp
801053fe:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105401:	8b 45 0c             	mov    0xc(%ebp),%eax
80105404:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105407:	8b 45 08             	mov    0x8(%ebp),%eax
8010540a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010540d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105410:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105413:	73 54                	jae    80105469 <memmove+0x6e>
80105415:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105418:	8b 45 10             	mov    0x10(%ebp),%eax
8010541b:	01 d0                	add    %edx,%eax
8010541d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105420:	76 47                	jbe    80105469 <memmove+0x6e>
    s += n;
80105422:	8b 45 10             	mov    0x10(%ebp),%eax
80105425:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105428:	8b 45 10             	mov    0x10(%ebp),%eax
8010542b:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010542e:	eb 13                	jmp    80105443 <memmove+0x48>
      *--d = *--s;
80105430:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105434:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105438:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010543b:	0f b6 10             	movzbl (%eax),%edx
8010543e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105441:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105443:	8b 45 10             	mov    0x10(%ebp),%eax
80105446:	8d 50 ff             	lea    -0x1(%eax),%edx
80105449:	89 55 10             	mov    %edx,0x10(%ebp)
8010544c:	85 c0                	test   %eax,%eax
8010544e:	75 e0                	jne    80105430 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105450:	eb 24                	jmp    80105476 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105452:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105455:	8d 50 01             	lea    0x1(%eax),%edx
80105458:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010545b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010545e:	8d 4a 01             	lea    0x1(%edx),%ecx
80105461:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105464:	0f b6 12             	movzbl (%edx),%edx
80105467:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105469:	8b 45 10             	mov    0x10(%ebp),%eax
8010546c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010546f:	89 55 10             	mov    %edx,0x10(%ebp)
80105472:	85 c0                	test   %eax,%eax
80105474:	75 dc                	jne    80105452 <memmove+0x57>
      *d++ = *s++;

  return dst;
80105476:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105479:	c9                   	leave  
8010547a:	c3                   	ret    

8010547b <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010547b:	55                   	push   %ebp
8010547c:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
8010547e:	ff 75 10             	pushl  0x10(%ebp)
80105481:	ff 75 0c             	pushl  0xc(%ebp)
80105484:	ff 75 08             	pushl  0x8(%ebp)
80105487:	e8 6f ff ff ff       	call   801053fb <memmove>
8010548c:	83 c4 0c             	add    $0xc,%esp
}
8010548f:	c9                   	leave  
80105490:	c3                   	ret    

80105491 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105491:	55                   	push   %ebp
80105492:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105494:	eb 0c                	jmp    801054a2 <strncmp+0x11>
    n--, p++, q++;
80105496:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010549a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010549e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801054a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801054a6:	74 1a                	je     801054c2 <strncmp+0x31>
801054a8:	8b 45 08             	mov    0x8(%ebp),%eax
801054ab:	0f b6 00             	movzbl (%eax),%eax
801054ae:	84 c0                	test   %al,%al
801054b0:	74 10                	je     801054c2 <strncmp+0x31>
801054b2:	8b 45 08             	mov    0x8(%ebp),%eax
801054b5:	0f b6 10             	movzbl (%eax),%edx
801054b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801054bb:	0f b6 00             	movzbl (%eax),%eax
801054be:	38 c2                	cmp    %al,%dl
801054c0:	74 d4                	je     80105496 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801054c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801054c6:	75 07                	jne    801054cf <strncmp+0x3e>
    return 0;
801054c8:	b8 00 00 00 00       	mov    $0x0,%eax
801054cd:	eb 16                	jmp    801054e5 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801054cf:	8b 45 08             	mov    0x8(%ebp),%eax
801054d2:	0f b6 00             	movzbl (%eax),%eax
801054d5:	0f b6 d0             	movzbl %al,%edx
801054d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801054db:	0f b6 00             	movzbl (%eax),%eax
801054de:	0f b6 c0             	movzbl %al,%eax
801054e1:	29 c2                	sub    %eax,%edx
801054e3:	89 d0                	mov    %edx,%eax
}
801054e5:	5d                   	pop    %ebp
801054e6:	c3                   	ret    

801054e7 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801054e7:	55                   	push   %ebp
801054e8:	89 e5                	mov    %esp,%ebp
801054ea:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801054ed:	8b 45 08             	mov    0x8(%ebp),%eax
801054f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801054f3:	90                   	nop
801054f4:	8b 45 10             	mov    0x10(%ebp),%eax
801054f7:	8d 50 ff             	lea    -0x1(%eax),%edx
801054fa:	89 55 10             	mov    %edx,0x10(%ebp)
801054fd:	85 c0                	test   %eax,%eax
801054ff:	7e 2c                	jle    8010552d <strncpy+0x46>
80105501:	8b 45 08             	mov    0x8(%ebp),%eax
80105504:	8d 50 01             	lea    0x1(%eax),%edx
80105507:	89 55 08             	mov    %edx,0x8(%ebp)
8010550a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010550d:	8d 4a 01             	lea    0x1(%edx),%ecx
80105510:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105513:	0f b6 12             	movzbl (%edx),%edx
80105516:	88 10                	mov    %dl,(%eax)
80105518:	0f b6 00             	movzbl (%eax),%eax
8010551b:	84 c0                	test   %al,%al
8010551d:	75 d5                	jne    801054f4 <strncpy+0xd>
    ;
  while(n-- > 0)
8010551f:	eb 0c                	jmp    8010552d <strncpy+0x46>
    *s++ = 0;
80105521:	8b 45 08             	mov    0x8(%ebp),%eax
80105524:	8d 50 01             	lea    0x1(%eax),%edx
80105527:	89 55 08             	mov    %edx,0x8(%ebp)
8010552a:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010552d:	8b 45 10             	mov    0x10(%ebp),%eax
80105530:	8d 50 ff             	lea    -0x1(%eax),%edx
80105533:	89 55 10             	mov    %edx,0x10(%ebp)
80105536:	85 c0                	test   %eax,%eax
80105538:	7f e7                	jg     80105521 <strncpy+0x3a>
    *s++ = 0;
  return os;
8010553a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010553d:	c9                   	leave  
8010553e:	c3                   	ret    

8010553f <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010553f:	55                   	push   %ebp
80105540:	89 e5                	mov    %esp,%ebp
80105542:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105545:	8b 45 08             	mov    0x8(%ebp),%eax
80105548:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010554b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010554f:	7f 05                	jg     80105556 <safestrcpy+0x17>
    return os;
80105551:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105554:	eb 31                	jmp    80105587 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105556:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010555a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010555e:	7e 1e                	jle    8010557e <safestrcpy+0x3f>
80105560:	8b 45 08             	mov    0x8(%ebp),%eax
80105563:	8d 50 01             	lea    0x1(%eax),%edx
80105566:	89 55 08             	mov    %edx,0x8(%ebp)
80105569:	8b 55 0c             	mov    0xc(%ebp),%edx
8010556c:	8d 4a 01             	lea    0x1(%edx),%ecx
8010556f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105572:	0f b6 12             	movzbl (%edx),%edx
80105575:	88 10                	mov    %dl,(%eax)
80105577:	0f b6 00             	movzbl (%eax),%eax
8010557a:	84 c0                	test   %al,%al
8010557c:	75 d8                	jne    80105556 <safestrcpy+0x17>
    ;
  *s = 0;
8010557e:	8b 45 08             	mov    0x8(%ebp),%eax
80105581:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105584:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105587:	c9                   	leave  
80105588:	c3                   	ret    

80105589 <strlen>:

int
strlen(const char *s)
{
80105589:	55                   	push   %ebp
8010558a:	89 e5                	mov    %esp,%ebp
8010558c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010558f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105596:	eb 04                	jmp    8010559c <strlen+0x13>
80105598:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010559c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010559f:	8b 45 08             	mov    0x8(%ebp),%eax
801055a2:	01 d0                	add    %edx,%eax
801055a4:	0f b6 00             	movzbl (%eax),%eax
801055a7:	84 c0                	test   %al,%al
801055a9:	75 ed                	jne    80105598 <strlen+0xf>
    ;
  return n;
801055ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801055ae:	c9                   	leave  
801055af:	c3                   	ret    

801055b0 <swtch>:
801055b0:	8b 44 24 04          	mov    0x4(%esp),%eax
801055b4:	8b 54 24 08          	mov    0x8(%esp),%edx
801055b8:	55                   	push   %ebp
801055b9:	53                   	push   %ebx
801055ba:	56                   	push   %esi
801055bb:	57                   	push   %edi
801055bc:	89 20                	mov    %esp,(%eax)
801055be:	89 d4                	mov    %edx,%esp
801055c0:	5f                   	pop    %edi
801055c1:	5e                   	pop    %esi
801055c2:	5b                   	pop    %ebx
801055c3:	5d                   	pop    %ebp
801055c4:	c3                   	ret    

801055c5 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801055c5:	55                   	push   %ebp
801055c6:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801055c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055ce:	8b 00                	mov    (%eax),%eax
801055d0:	3b 45 08             	cmp    0x8(%ebp),%eax
801055d3:	76 12                	jbe    801055e7 <fetchint+0x22>
801055d5:	8b 45 08             	mov    0x8(%ebp),%eax
801055d8:	8d 50 04             	lea    0x4(%eax),%edx
801055db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e1:	8b 00                	mov    (%eax),%eax
801055e3:	39 c2                	cmp    %eax,%edx
801055e5:	76 07                	jbe    801055ee <fetchint+0x29>
    return -1;
801055e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ec:	eb 0f                	jmp    801055fd <fetchint+0x38>
  *ip = *(int*)(addr);
801055ee:	8b 45 08             	mov    0x8(%ebp),%eax
801055f1:	8b 10                	mov    (%eax),%edx
801055f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801055f6:	89 10                	mov    %edx,(%eax)
  return 0;
801055f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055fd:	5d                   	pop    %ebp
801055fe:	c3                   	ret    

801055ff <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801055ff:	55                   	push   %ebp
80105600:	89 e5                	mov    %esp,%ebp
80105602:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105605:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010560b:	8b 00                	mov    (%eax),%eax
8010560d:	3b 45 08             	cmp    0x8(%ebp),%eax
80105610:	77 07                	ja     80105619 <fetchstr+0x1a>
    return -1;
80105612:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105617:	eb 46                	jmp    8010565f <fetchstr+0x60>
  *pp = (char*)addr;
80105619:	8b 55 08             	mov    0x8(%ebp),%edx
8010561c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010561f:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105621:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105627:	8b 00                	mov    (%eax),%eax
80105629:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010562c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010562f:	8b 00                	mov    (%eax),%eax
80105631:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105634:	eb 1c                	jmp    80105652 <fetchstr+0x53>
    if(*s == 0)
80105636:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105639:	0f b6 00             	movzbl (%eax),%eax
8010563c:	84 c0                	test   %al,%al
8010563e:	75 0e                	jne    8010564e <fetchstr+0x4f>
      return s - *pp;
80105640:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105643:	8b 45 0c             	mov    0xc(%ebp),%eax
80105646:	8b 00                	mov    (%eax),%eax
80105648:	29 c2                	sub    %eax,%edx
8010564a:	89 d0                	mov    %edx,%eax
8010564c:	eb 11                	jmp    8010565f <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010564e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105652:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105655:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105658:	72 dc                	jb     80105636 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
8010565a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010565f:	c9                   	leave  
80105660:	c3                   	ret    

80105661 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105661:	55                   	push   %ebp
80105662:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105664:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010566a:	8b 40 18             	mov    0x18(%eax),%eax
8010566d:	8b 40 44             	mov    0x44(%eax),%eax
80105670:	8b 55 08             	mov    0x8(%ebp),%edx
80105673:	c1 e2 02             	shl    $0x2,%edx
80105676:	01 d0                	add    %edx,%eax
80105678:	83 c0 04             	add    $0x4,%eax
8010567b:	ff 75 0c             	pushl  0xc(%ebp)
8010567e:	50                   	push   %eax
8010567f:	e8 41 ff ff ff       	call   801055c5 <fetchint>
80105684:	83 c4 08             	add    $0x8,%esp
}
80105687:	c9                   	leave  
80105688:	c3                   	ret    

80105689 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105689:	55                   	push   %ebp
8010568a:	89 e5                	mov    %esp,%ebp
8010568c:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(argint(n, &i) < 0)
8010568f:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105692:	50                   	push   %eax
80105693:	ff 75 08             	pushl  0x8(%ebp)
80105696:	e8 c6 ff ff ff       	call   80105661 <argint>
8010569b:	83 c4 08             	add    $0x8,%esp
8010569e:	85 c0                	test   %eax,%eax
801056a0:	79 07                	jns    801056a9 <argptr+0x20>
    return -1;
801056a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a7:	eb 3b                	jmp    801056e4 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801056a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056af:	8b 00                	mov    (%eax),%eax
801056b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056b4:	39 d0                	cmp    %edx,%eax
801056b6:	76 16                	jbe    801056ce <argptr+0x45>
801056b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056bb:	89 c2                	mov    %eax,%edx
801056bd:	8b 45 10             	mov    0x10(%ebp),%eax
801056c0:	01 c2                	add    %eax,%edx
801056c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056c8:	8b 00                	mov    (%eax),%eax
801056ca:	39 c2                	cmp    %eax,%edx
801056cc:	76 07                	jbe    801056d5 <argptr+0x4c>
    return -1;
801056ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d3:	eb 0f                	jmp    801056e4 <argptr+0x5b>
  *pp = (char*)i;
801056d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056d8:	89 c2                	mov    %eax,%edx
801056da:	8b 45 0c             	mov    0xc(%ebp),%eax
801056dd:	89 10                	mov    %edx,(%eax)
  return 0;
801056df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056e4:	c9                   	leave  
801056e5:	c3                   	ret    

801056e6 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801056e6:	55                   	push   %ebp
801056e7:	89 e5                	mov    %esp,%ebp
801056e9:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
801056ec:	8d 45 fc             	lea    -0x4(%ebp),%eax
801056ef:	50                   	push   %eax
801056f0:	ff 75 08             	pushl  0x8(%ebp)
801056f3:	e8 69 ff ff ff       	call   80105661 <argint>
801056f8:	83 c4 08             	add    $0x8,%esp
801056fb:	85 c0                	test   %eax,%eax
801056fd:	79 07                	jns    80105706 <argstr+0x20>
    return -1;
801056ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105704:	eb 0f                	jmp    80105715 <argstr+0x2f>
  return fetchstr(addr, pp);
80105706:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105709:	ff 75 0c             	pushl  0xc(%ebp)
8010570c:	50                   	push   %eax
8010570d:	e8 ed fe ff ff       	call   801055ff <fetchstr>
80105712:	83 c4 08             	add    $0x8,%esp
}
80105715:	c9                   	leave  
80105716:	c3                   	ret    

80105717 <syscall>:
[SYS_mprotect]  sys_mprotect,
};

void
syscall(void)
{
80105717:	55                   	push   %ebp
80105718:	89 e5                	mov    %esp,%ebp
8010571a:	53                   	push   %ebx
8010571b:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
8010571e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105724:	8b 40 18             	mov    0x18(%eax),%eax
80105727:	8b 40 1c             	mov    0x1c(%eax),%eax
8010572a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010572d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105731:	7e 30                	jle    80105763 <syscall+0x4c>
80105733:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105736:	83 f8 19             	cmp    $0x19,%eax
80105739:	77 28                	ja     80105763 <syscall+0x4c>
8010573b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010573e:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105745:	85 c0                	test   %eax,%eax
80105747:	74 1a                	je     80105763 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105749:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010574f:	8b 58 18             	mov    0x18(%eax),%ebx
80105752:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105755:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010575c:	ff d0                	call   *%eax
8010575e:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105761:	eb 34                	jmp    80105797 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105763:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105769:	8d 50 6c             	lea    0x6c(%eax),%edx
8010576c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105772:	8b 40 10             	mov    0x10(%eax),%eax
80105775:	ff 75 f4             	pushl  -0xc(%ebp)
80105778:	52                   	push   %edx
80105779:	50                   	push   %eax
8010577a:	68 47 8c 10 80       	push   $0x80108c47
8010577f:	e8 42 ac ff ff       	call   801003c6 <cprintf>
80105784:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105787:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010578d:	8b 40 18             	mov    0x18(%eax),%eax
80105790:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105797:	90                   	nop
80105798:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010579b:	c9                   	leave  
8010579c:	c3                   	ret    

8010579d <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010579d:	55                   	push   %ebp
8010579e:	89 e5                	mov    %esp,%ebp
801057a0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801057a3:	83 ec 08             	sub    $0x8,%esp
801057a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057a9:	50                   	push   %eax
801057aa:	ff 75 08             	pushl  0x8(%ebp)
801057ad:	e8 af fe ff ff       	call   80105661 <argint>
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	85 c0                	test   %eax,%eax
801057b7:	79 07                	jns    801057c0 <argfd+0x23>
    return -1;
801057b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057be:	eb 50                	jmp    80105810 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801057c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057c3:	85 c0                	test   %eax,%eax
801057c5:	78 21                	js     801057e8 <argfd+0x4b>
801057c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ca:	83 f8 0f             	cmp    $0xf,%eax
801057cd:	7f 19                	jg     801057e8 <argfd+0x4b>
801057cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057d8:	83 c2 08             	add    $0x8,%edx
801057db:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801057df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057e6:	75 07                	jne    801057ef <argfd+0x52>
    return -1;
801057e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ed:	eb 21                	jmp    80105810 <argfd+0x73>
  if(pfd)
801057ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801057f3:	74 08                	je     801057fd <argfd+0x60>
    *pfd = fd;
801057f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801057fb:	89 10                	mov    %edx,(%eax)
  if(pf)
801057fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105801:	74 08                	je     8010580b <argfd+0x6e>
    *pf = f;
80105803:	8b 45 10             	mov    0x10(%ebp),%eax
80105806:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105809:	89 10                	mov    %edx,(%eax)
  return 0;
8010580b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105810:	c9                   	leave  
80105811:	c3                   	ret    

80105812 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105812:	55                   	push   %ebp
80105813:	89 e5                	mov    %esp,%ebp
80105815:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105818:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010581f:	eb 30                	jmp    80105851 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105821:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105827:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010582a:	83 c2 08             	add    $0x8,%edx
8010582d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105831:	85 c0                	test   %eax,%eax
80105833:	75 18                	jne    8010584d <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105835:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010583b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010583e:	8d 4a 08             	lea    0x8(%edx),%ecx
80105841:	8b 55 08             	mov    0x8(%ebp),%edx
80105844:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105848:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010584b:	eb 0f                	jmp    8010585c <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010584d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105851:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105855:	7e ca                	jle    80105821 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010585c:	c9                   	leave  
8010585d:	c3                   	ret    

8010585e <sys_dup>:

int
sys_dup(void)
{
8010585e:	55                   	push   %ebp
8010585f:	89 e5                	mov    %esp,%ebp
80105861:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105864:	83 ec 04             	sub    $0x4,%esp
80105867:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010586a:	50                   	push   %eax
8010586b:	6a 00                	push   $0x0
8010586d:	6a 00                	push   $0x0
8010586f:	e8 29 ff ff ff       	call   8010579d <argfd>
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
80105879:	79 07                	jns    80105882 <sys_dup+0x24>
    return -1;
8010587b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105880:	eb 31                	jmp    801058b3 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105882:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105885:	83 ec 0c             	sub    $0xc,%esp
80105888:	50                   	push   %eax
80105889:	e8 84 ff ff ff       	call   80105812 <fdalloc>
8010588e:	83 c4 10             	add    $0x10,%esp
80105891:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105894:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105898:	79 07                	jns    801058a1 <sys_dup+0x43>
    return -1;
8010589a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589f:	eb 12                	jmp    801058b3 <sys_dup+0x55>
  filedup(f);
801058a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a4:	83 ec 0c             	sub    $0xc,%esp
801058a7:	50                   	push   %eax
801058a8:	e8 38 b7 ff ff       	call   80100fe5 <filedup>
801058ad:	83 c4 10             	add    $0x10,%esp
  return fd;
801058b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801058b3:	c9                   	leave  
801058b4:	c3                   	ret    

801058b5 <sys_read>:

int
sys_read(void)
{
801058b5:	55                   	push   %ebp
801058b6:	89 e5                	mov    %esp,%ebp
801058b8:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058bb:	83 ec 04             	sub    $0x4,%esp
801058be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058c1:	50                   	push   %eax
801058c2:	6a 00                	push   $0x0
801058c4:	6a 00                	push   $0x0
801058c6:	e8 d2 fe ff ff       	call   8010579d <argfd>
801058cb:	83 c4 10             	add    $0x10,%esp
801058ce:	85 c0                	test   %eax,%eax
801058d0:	78 2e                	js     80105900 <sys_read+0x4b>
801058d2:	83 ec 08             	sub    $0x8,%esp
801058d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d8:	50                   	push   %eax
801058d9:	6a 02                	push   $0x2
801058db:	e8 81 fd ff ff       	call   80105661 <argint>
801058e0:	83 c4 10             	add    $0x10,%esp
801058e3:	85 c0                	test   %eax,%eax
801058e5:	78 19                	js     80105900 <sys_read+0x4b>
801058e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058ea:	83 ec 04             	sub    $0x4,%esp
801058ed:	50                   	push   %eax
801058ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058f1:	50                   	push   %eax
801058f2:	6a 01                	push   $0x1
801058f4:	e8 90 fd ff ff       	call   80105689 <argptr>
801058f9:	83 c4 10             	add    $0x10,%esp
801058fc:	85 c0                	test   %eax,%eax
801058fe:	79 07                	jns    80105907 <sys_read+0x52>
    return -1;
80105900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105905:	eb 17                	jmp    8010591e <sys_read+0x69>
  return fileread(f, p, n);
80105907:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010590a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010590d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105910:	83 ec 04             	sub    $0x4,%esp
80105913:	51                   	push   %ecx
80105914:	52                   	push   %edx
80105915:	50                   	push   %eax
80105916:	e8 5a b8 ff ff       	call   80101175 <fileread>
8010591b:	83 c4 10             	add    $0x10,%esp
}
8010591e:	c9                   	leave  
8010591f:	c3                   	ret    

80105920 <sys_write>:

int
sys_write(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105926:	83 ec 04             	sub    $0x4,%esp
80105929:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010592c:	50                   	push   %eax
8010592d:	6a 00                	push   $0x0
8010592f:	6a 00                	push   $0x0
80105931:	e8 67 fe ff ff       	call   8010579d <argfd>
80105936:	83 c4 10             	add    $0x10,%esp
80105939:	85 c0                	test   %eax,%eax
8010593b:	78 2e                	js     8010596b <sys_write+0x4b>
8010593d:	83 ec 08             	sub    $0x8,%esp
80105940:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105943:	50                   	push   %eax
80105944:	6a 02                	push   $0x2
80105946:	e8 16 fd ff ff       	call   80105661 <argint>
8010594b:	83 c4 10             	add    $0x10,%esp
8010594e:	85 c0                	test   %eax,%eax
80105950:	78 19                	js     8010596b <sys_write+0x4b>
80105952:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105955:	83 ec 04             	sub    $0x4,%esp
80105958:	50                   	push   %eax
80105959:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010595c:	50                   	push   %eax
8010595d:	6a 01                	push   $0x1
8010595f:	e8 25 fd ff ff       	call   80105689 <argptr>
80105964:	83 c4 10             	add    $0x10,%esp
80105967:	85 c0                	test   %eax,%eax
80105969:	79 07                	jns    80105972 <sys_write+0x52>
    return -1;
8010596b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105970:	eb 17                	jmp    80105989 <sys_write+0x69>
  return filewrite(f, p, n);
80105972:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105975:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010597b:	83 ec 04             	sub    $0x4,%esp
8010597e:	51                   	push   %ecx
8010597f:	52                   	push   %edx
80105980:	50                   	push   %eax
80105981:	e8 a7 b8 ff ff       	call   8010122d <filewrite>
80105986:	83 c4 10             	add    $0x10,%esp
}
80105989:	c9                   	leave  
8010598a:	c3                   	ret    

8010598b <sys_close>:

int
sys_close(void)
{
8010598b:	55                   	push   %ebp
8010598c:	89 e5                	mov    %esp,%ebp
8010598e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105991:	83 ec 04             	sub    $0x4,%esp
80105994:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105997:	50                   	push   %eax
80105998:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010599b:	50                   	push   %eax
8010599c:	6a 00                	push   $0x0
8010599e:	e8 fa fd ff ff       	call   8010579d <argfd>
801059a3:	83 c4 10             	add    $0x10,%esp
801059a6:	85 c0                	test   %eax,%eax
801059a8:	79 07                	jns    801059b1 <sys_close+0x26>
    return -1;
801059aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059af:	eb 28                	jmp    801059d9 <sys_close+0x4e>
  proc->ofile[fd] = 0;
801059b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059ba:	83 c2 08             	add    $0x8,%edx
801059bd:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801059c4:	00 
  fileclose(f);
801059c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c8:	83 ec 0c             	sub    $0xc,%esp
801059cb:	50                   	push   %eax
801059cc:	e8 65 b6 ff ff       	call   80101036 <fileclose>
801059d1:	83 c4 10             	add    $0x10,%esp
  return 0;
801059d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059d9:	c9                   	leave  
801059da:	c3                   	ret    

801059db <sys_fstat>:

int
sys_fstat(void)
{
801059db:	55                   	push   %ebp
801059dc:	89 e5                	mov    %esp,%ebp
801059de:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059e1:	83 ec 04             	sub    $0x4,%esp
801059e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059e7:	50                   	push   %eax
801059e8:	6a 00                	push   $0x0
801059ea:	6a 00                	push   $0x0
801059ec:	e8 ac fd ff ff       	call   8010579d <argfd>
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	85 c0                	test   %eax,%eax
801059f6:	78 17                	js     80105a0f <sys_fstat+0x34>
801059f8:	83 ec 04             	sub    $0x4,%esp
801059fb:	6a 14                	push   $0x14
801059fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a00:	50                   	push   %eax
80105a01:	6a 01                	push   $0x1
80105a03:	e8 81 fc ff ff       	call   80105689 <argptr>
80105a08:	83 c4 10             	add    $0x10,%esp
80105a0b:	85 c0                	test   %eax,%eax
80105a0d:	79 07                	jns    80105a16 <sys_fstat+0x3b>
    return -1;
80105a0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a14:	eb 13                	jmp    80105a29 <sys_fstat+0x4e>
  return filestat(f, st);
80105a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a1c:	83 ec 08             	sub    $0x8,%esp
80105a1f:	52                   	push   %edx
80105a20:	50                   	push   %eax
80105a21:	e8 f8 b6 ff ff       	call   8010111e <filestat>
80105a26:	83 c4 10             	add    $0x10,%esp
}
80105a29:	c9                   	leave  
80105a2a:	c3                   	ret    

80105a2b <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a2b:	55                   	push   %ebp
80105a2c:	89 e5                	mov    %esp,%ebp
80105a2e:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a31:	83 ec 08             	sub    $0x8,%esp
80105a34:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a37:	50                   	push   %eax
80105a38:	6a 00                	push   $0x0
80105a3a:	e8 a7 fc ff ff       	call   801056e6 <argstr>
80105a3f:	83 c4 10             	add    $0x10,%esp
80105a42:	85 c0                	test   %eax,%eax
80105a44:	78 15                	js     80105a5b <sys_link+0x30>
80105a46:	83 ec 08             	sub    $0x8,%esp
80105a49:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105a4c:	50                   	push   %eax
80105a4d:	6a 01                	push   $0x1
80105a4f:	e8 92 fc ff ff       	call   801056e6 <argstr>
80105a54:	83 c4 10             	add    $0x10,%esp
80105a57:	85 c0                	test   %eax,%eax
80105a59:	79 0a                	jns    80105a65 <sys_link+0x3a>
    return -1;
80105a5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a60:	e9 68 01 00 00       	jmp    80105bcd <sys_link+0x1a2>

  begin_op();
80105a65:	e8 4a da ff ff       	call   801034b4 <begin_op>
  if((ip = namei(old)) == 0){
80105a6a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105a6d:	83 ec 0c             	sub    $0xc,%esp
80105a70:	50                   	push   %eax
80105a71:	e8 4d ca ff ff       	call   801024c3 <namei>
80105a76:	83 c4 10             	add    $0x10,%esp
80105a79:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a80:	75 0f                	jne    80105a91 <sys_link+0x66>
    end_op();
80105a82:	e8 b9 da ff ff       	call   80103540 <end_op>
    return -1;
80105a87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a8c:	e9 3c 01 00 00       	jmp    80105bcd <sys_link+0x1a2>
  }

  ilock(ip);
80105a91:	83 ec 0c             	sub    $0xc,%esp
80105a94:	ff 75 f4             	pushl  -0xc(%ebp)
80105a97:	e8 6f be ff ff       	call   8010190b <ilock>
80105a9c:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105aa6:	66 83 f8 01          	cmp    $0x1,%ax
80105aaa:	75 1d                	jne    80105ac9 <sys_link+0x9e>
    iunlockput(ip);
80105aac:	83 ec 0c             	sub    $0xc,%esp
80105aaf:	ff 75 f4             	pushl  -0xc(%ebp)
80105ab2:	e8 0e c1 ff ff       	call   80101bc5 <iunlockput>
80105ab7:	83 c4 10             	add    $0x10,%esp
    end_op();
80105aba:	e8 81 da ff ff       	call   80103540 <end_op>
    return -1;
80105abf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ac4:	e9 04 01 00 00       	jmp    80105bcd <sys_link+0x1a2>
  }

  ip->nlink++;
80105ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105acc:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ad0:	83 c0 01             	add    $0x1,%eax
80105ad3:	89 c2                	mov    %eax,%edx
80105ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad8:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105adc:	83 ec 0c             	sub    $0xc,%esp
80105adf:	ff 75 f4             	pushl  -0xc(%ebp)
80105ae2:	e8 50 bc ff ff       	call   80101737 <iupdate>
80105ae7:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105aea:	83 ec 0c             	sub    $0xc,%esp
80105aed:	ff 75 f4             	pushl  -0xc(%ebp)
80105af0:	e8 6e bf ff ff       	call   80101a63 <iunlock>
80105af5:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105af8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105afb:	83 ec 08             	sub    $0x8,%esp
80105afe:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105b01:	52                   	push   %edx
80105b02:	50                   	push   %eax
80105b03:	e8 d7 c9 ff ff       	call   801024df <nameiparent>
80105b08:	83 c4 10             	add    $0x10,%esp
80105b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b12:	74 71                	je     80105b85 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105b14:	83 ec 0c             	sub    $0xc,%esp
80105b17:	ff 75 f0             	pushl  -0x10(%ebp)
80105b1a:	e8 ec bd ff ff       	call   8010190b <ilock>
80105b1f:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b25:	8b 10                	mov    (%eax),%edx
80105b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2a:	8b 00                	mov    (%eax),%eax
80105b2c:	39 c2                	cmp    %eax,%edx
80105b2e:	75 1d                	jne    80105b4d <sys_link+0x122>
80105b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b33:	8b 40 04             	mov    0x4(%eax),%eax
80105b36:	83 ec 04             	sub    $0x4,%esp
80105b39:	50                   	push   %eax
80105b3a:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105b3d:	50                   	push   %eax
80105b3e:	ff 75 f0             	pushl  -0x10(%ebp)
80105b41:	e8 e1 c6 ff ff       	call   80102227 <dirlink>
80105b46:	83 c4 10             	add    $0x10,%esp
80105b49:	85 c0                	test   %eax,%eax
80105b4b:	79 10                	jns    80105b5d <sys_link+0x132>
    iunlockput(dp);
80105b4d:	83 ec 0c             	sub    $0xc,%esp
80105b50:	ff 75 f0             	pushl  -0x10(%ebp)
80105b53:	e8 6d c0 ff ff       	call   80101bc5 <iunlockput>
80105b58:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105b5b:	eb 29                	jmp    80105b86 <sys_link+0x15b>
  }
  iunlockput(dp);
80105b5d:	83 ec 0c             	sub    $0xc,%esp
80105b60:	ff 75 f0             	pushl  -0x10(%ebp)
80105b63:	e8 5d c0 ff ff       	call   80101bc5 <iunlockput>
80105b68:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105b6b:	83 ec 0c             	sub    $0xc,%esp
80105b6e:	ff 75 f4             	pushl  -0xc(%ebp)
80105b71:	e8 5f bf ff ff       	call   80101ad5 <iput>
80105b76:	83 c4 10             	add    $0x10,%esp

  end_op();
80105b79:	e8 c2 d9 ff ff       	call   80103540 <end_op>

  return 0;
80105b7e:	b8 00 00 00 00       	mov    $0x0,%eax
80105b83:	eb 48                	jmp    80105bcd <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105b85:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105b86:	83 ec 0c             	sub    $0xc,%esp
80105b89:	ff 75 f4             	pushl  -0xc(%ebp)
80105b8c:	e8 7a bd ff ff       	call   8010190b <ilock>
80105b91:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b97:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b9b:	83 e8 01             	sub    $0x1,%eax
80105b9e:	89 c2                	mov    %eax,%edx
80105ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba3:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ba7:	83 ec 0c             	sub    $0xc,%esp
80105baa:	ff 75 f4             	pushl  -0xc(%ebp)
80105bad:	e8 85 bb ff ff       	call   80101737 <iupdate>
80105bb2:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105bb5:	83 ec 0c             	sub    $0xc,%esp
80105bb8:	ff 75 f4             	pushl  -0xc(%ebp)
80105bbb:	e8 05 c0 ff ff       	call   80101bc5 <iunlockput>
80105bc0:	83 c4 10             	add    $0x10,%esp
  end_op();
80105bc3:	e8 78 d9 ff ff       	call   80103540 <end_op>
  return -1;
80105bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bcd:	c9                   	leave  
80105bce:	c3                   	ret    

80105bcf <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105bcf:	55                   	push   %ebp
80105bd0:	89 e5                	mov    %esp,%ebp
80105bd2:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105bd5:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105bdc:	eb 40                	jmp    80105c1e <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be1:	6a 10                	push   $0x10
80105be3:	50                   	push   %eax
80105be4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105be7:	50                   	push   %eax
80105be8:	ff 75 08             	pushl  0x8(%ebp)
80105beb:	e8 83 c2 ff ff       	call   80101e73 <readi>
80105bf0:	83 c4 10             	add    $0x10,%esp
80105bf3:	83 f8 10             	cmp    $0x10,%eax
80105bf6:	74 0d                	je     80105c05 <isdirempty+0x36>
      panic("isdirempty: readi");
80105bf8:	83 ec 0c             	sub    $0xc,%esp
80105bfb:	68 63 8c 10 80       	push   $0x80108c63
80105c00:	e8 61 a9 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80105c05:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105c09:	66 85 c0             	test   %ax,%ax
80105c0c:	74 07                	je     80105c15 <isdirempty+0x46>
      return 0;
80105c0e:	b8 00 00 00 00       	mov    $0x0,%eax
80105c13:	eb 1b                	jmp    80105c30 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c18:	83 c0 10             	add    $0x10,%eax
80105c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80105c21:	8b 50 18             	mov    0x18(%eax),%edx
80105c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c27:	39 c2                	cmp    %eax,%edx
80105c29:	77 b3                	ja     80105bde <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105c2b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105c30:	c9                   	leave  
80105c31:	c3                   	ret    

80105c32 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105c32:	55                   	push   %ebp
80105c33:	89 e5                	mov    %esp,%ebp
80105c35:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105c38:	83 ec 08             	sub    $0x8,%esp
80105c3b:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105c3e:	50                   	push   %eax
80105c3f:	6a 00                	push   $0x0
80105c41:	e8 a0 fa ff ff       	call   801056e6 <argstr>
80105c46:	83 c4 10             	add    $0x10,%esp
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	79 0a                	jns    80105c57 <sys_unlink+0x25>
    return -1;
80105c4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c52:	e9 bc 01 00 00       	jmp    80105e13 <sys_unlink+0x1e1>

  begin_op();
80105c57:	e8 58 d8 ff ff       	call   801034b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105c5f:	83 ec 08             	sub    $0x8,%esp
80105c62:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105c65:	52                   	push   %edx
80105c66:	50                   	push   %eax
80105c67:	e8 73 c8 ff ff       	call   801024df <nameiparent>
80105c6c:	83 c4 10             	add    $0x10,%esp
80105c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c76:	75 0f                	jne    80105c87 <sys_unlink+0x55>
    end_op();
80105c78:	e8 c3 d8 ff ff       	call   80103540 <end_op>
    return -1;
80105c7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c82:	e9 8c 01 00 00       	jmp    80105e13 <sys_unlink+0x1e1>
  }

  ilock(dp);
80105c87:	83 ec 0c             	sub    $0xc,%esp
80105c8a:	ff 75 f4             	pushl  -0xc(%ebp)
80105c8d:	e8 79 bc ff ff       	call   8010190b <ilock>
80105c92:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c95:	83 ec 08             	sub    $0x8,%esp
80105c98:	68 75 8c 10 80       	push   $0x80108c75
80105c9d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ca0:	50                   	push   %eax
80105ca1:	e8 ac c4 ff ff       	call   80102152 <namecmp>
80105ca6:	83 c4 10             	add    $0x10,%esp
80105ca9:	85 c0                	test   %eax,%eax
80105cab:	0f 84 4a 01 00 00    	je     80105dfb <sys_unlink+0x1c9>
80105cb1:	83 ec 08             	sub    $0x8,%esp
80105cb4:	68 77 8c 10 80       	push   $0x80108c77
80105cb9:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cbc:	50                   	push   %eax
80105cbd:	e8 90 c4 ff ff       	call   80102152 <namecmp>
80105cc2:	83 c4 10             	add    $0x10,%esp
80105cc5:	85 c0                	test   %eax,%eax
80105cc7:	0f 84 2e 01 00 00    	je     80105dfb <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105ccd:	83 ec 04             	sub    $0x4,%esp
80105cd0:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105cd3:	50                   	push   %eax
80105cd4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cd7:	50                   	push   %eax
80105cd8:	ff 75 f4             	pushl  -0xc(%ebp)
80105cdb:	e8 8d c4 ff ff       	call   8010216d <dirlookup>
80105ce0:	83 c4 10             	add    $0x10,%esp
80105ce3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ce6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cea:	0f 84 0a 01 00 00    	je     80105dfa <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	ff 75 f0             	pushl  -0x10(%ebp)
80105cf6:	e8 10 bc ff ff       	call   8010190b <ilock>
80105cfb:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d01:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d05:	66 85 c0             	test   %ax,%ax
80105d08:	7f 0d                	jg     80105d17 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105d0a:	83 ec 0c             	sub    $0xc,%esp
80105d0d:	68 7a 8c 10 80       	push   $0x80108c7a
80105d12:	e8 4f a8 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d1a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d1e:	66 83 f8 01          	cmp    $0x1,%ax
80105d22:	75 25                	jne    80105d49 <sys_unlink+0x117>
80105d24:	83 ec 0c             	sub    $0xc,%esp
80105d27:	ff 75 f0             	pushl  -0x10(%ebp)
80105d2a:	e8 a0 fe ff ff       	call   80105bcf <isdirempty>
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	85 c0                	test   %eax,%eax
80105d34:	75 13                	jne    80105d49 <sys_unlink+0x117>
    iunlockput(ip);
80105d36:	83 ec 0c             	sub    $0xc,%esp
80105d39:	ff 75 f0             	pushl  -0x10(%ebp)
80105d3c:	e8 84 be ff ff       	call   80101bc5 <iunlockput>
80105d41:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105d44:	e9 b2 00 00 00       	jmp    80105dfb <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105d49:	83 ec 04             	sub    $0x4,%esp
80105d4c:	6a 10                	push   $0x10
80105d4e:	6a 00                	push   $0x0
80105d50:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d53:	50                   	push   %eax
80105d54:	e8 e3 f5 ff ff       	call   8010533c <memset>
80105d59:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d5c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105d5f:	6a 10                	push   $0x10
80105d61:	50                   	push   %eax
80105d62:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d65:	50                   	push   %eax
80105d66:	ff 75 f4             	pushl  -0xc(%ebp)
80105d69:	e8 5c c2 ff ff       	call   80101fca <writei>
80105d6e:	83 c4 10             	add    $0x10,%esp
80105d71:	83 f8 10             	cmp    $0x10,%eax
80105d74:	74 0d                	je     80105d83 <sys_unlink+0x151>
    panic("unlink: writei");
80105d76:	83 ec 0c             	sub    $0xc,%esp
80105d79:	68 8c 8c 10 80       	push   $0x80108c8c
80105d7e:	e8 e3 a7 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80105d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d86:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d8a:	66 83 f8 01          	cmp    $0x1,%ax
80105d8e:	75 21                	jne    80105db1 <sys_unlink+0x17f>
    dp->nlink--;
80105d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d93:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d97:	83 e8 01             	sub    $0x1,%eax
80105d9a:	89 c2                	mov    %eax,%edx
80105d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d9f:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105da3:	83 ec 0c             	sub    $0xc,%esp
80105da6:	ff 75 f4             	pushl  -0xc(%ebp)
80105da9:	e8 89 b9 ff ff       	call   80101737 <iupdate>
80105dae:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105db1:	83 ec 0c             	sub    $0xc,%esp
80105db4:	ff 75 f4             	pushl  -0xc(%ebp)
80105db7:	e8 09 be ff ff       	call   80101bc5 <iunlockput>
80105dbc:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc2:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105dc6:	83 e8 01             	sub    $0x1,%eax
80105dc9:	89 c2                	mov    %eax,%edx
80105dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dce:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105dd2:	83 ec 0c             	sub    $0xc,%esp
80105dd5:	ff 75 f0             	pushl  -0x10(%ebp)
80105dd8:	e8 5a b9 ff ff       	call   80101737 <iupdate>
80105ddd:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105de0:	83 ec 0c             	sub    $0xc,%esp
80105de3:	ff 75 f0             	pushl  -0x10(%ebp)
80105de6:	e8 da bd ff ff       	call   80101bc5 <iunlockput>
80105deb:	83 c4 10             	add    $0x10,%esp

  end_op();
80105dee:	e8 4d d7 ff ff       	call   80103540 <end_op>

  return 0;
80105df3:	b8 00 00 00 00       	mov    $0x0,%eax
80105df8:	eb 19                	jmp    80105e13 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105dfa:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105dfb:	83 ec 0c             	sub    $0xc,%esp
80105dfe:	ff 75 f4             	pushl  -0xc(%ebp)
80105e01:	e8 bf bd ff ff       	call   80101bc5 <iunlockput>
80105e06:	83 c4 10             	add    $0x10,%esp
  end_op();
80105e09:	e8 32 d7 ff ff       	call   80103540 <end_op>
  return -1;
80105e0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e13:	c9                   	leave  
80105e14:	c3                   	ret    

80105e15 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105e15:	55                   	push   %ebp
80105e16:	89 e5                	mov    %esp,%ebp
80105e18:	83 ec 38             	sub    $0x38,%esp
80105e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105e1e:	8b 55 10             	mov    0x10(%ebp),%edx
80105e21:	8b 45 14             	mov    0x14(%ebp),%eax
80105e24:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105e28:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105e2c:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105e30:	83 ec 08             	sub    $0x8,%esp
80105e33:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e36:	50                   	push   %eax
80105e37:	ff 75 08             	pushl  0x8(%ebp)
80105e3a:	e8 a0 c6 ff ff       	call   801024df <nameiparent>
80105e3f:	83 c4 10             	add    $0x10,%esp
80105e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e49:	75 0a                	jne    80105e55 <create+0x40>
    return 0;
80105e4b:	b8 00 00 00 00       	mov    $0x0,%eax
80105e50:	e9 90 01 00 00       	jmp    80105fe5 <create+0x1d0>
  ilock(dp);
80105e55:	83 ec 0c             	sub    $0xc,%esp
80105e58:	ff 75 f4             	pushl  -0xc(%ebp)
80105e5b:	e8 ab ba ff ff       	call   8010190b <ilock>
80105e60:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105e63:	83 ec 04             	sub    $0x4,%esp
80105e66:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e69:	50                   	push   %eax
80105e6a:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e6d:	50                   	push   %eax
80105e6e:	ff 75 f4             	pushl  -0xc(%ebp)
80105e71:	e8 f7 c2 ff ff       	call   8010216d <dirlookup>
80105e76:	83 c4 10             	add    $0x10,%esp
80105e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e80:	74 50                	je     80105ed2 <create+0xbd>
    iunlockput(dp);
80105e82:	83 ec 0c             	sub    $0xc,%esp
80105e85:	ff 75 f4             	pushl  -0xc(%ebp)
80105e88:	e8 38 bd ff ff       	call   80101bc5 <iunlockput>
80105e8d:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	ff 75 f0             	pushl  -0x10(%ebp)
80105e96:	e8 70 ba ff ff       	call   8010190b <ilock>
80105e9b:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105e9e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105ea3:	75 15                	jne    80105eba <create+0xa5>
80105ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105eac:	66 83 f8 02          	cmp    $0x2,%ax
80105eb0:	75 08                	jne    80105eba <create+0xa5>
      return ip;
80105eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb5:	e9 2b 01 00 00       	jmp    80105fe5 <create+0x1d0>
    iunlockput(ip);
80105eba:	83 ec 0c             	sub    $0xc,%esp
80105ebd:	ff 75 f0             	pushl  -0x10(%ebp)
80105ec0:	e8 00 bd ff ff       	call   80101bc5 <iunlockput>
80105ec5:	83 c4 10             	add    $0x10,%esp
    return 0;
80105ec8:	b8 00 00 00 00       	mov    $0x0,%eax
80105ecd:	e9 13 01 00 00       	jmp    80105fe5 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105ed2:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed9:	8b 00                	mov    (%eax),%eax
80105edb:	83 ec 08             	sub    $0x8,%esp
80105ede:	52                   	push   %edx
80105edf:	50                   	push   %eax
80105ee0:	e8 71 b7 ff ff       	call   80101656 <ialloc>
80105ee5:	83 c4 10             	add    $0x10,%esp
80105ee8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105eeb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105eef:	75 0d                	jne    80105efe <create+0xe9>
    panic("create: ialloc");
80105ef1:	83 ec 0c             	sub    $0xc,%esp
80105ef4:	68 9b 8c 10 80       	push   $0x80108c9b
80105ef9:	e8 68 a6 ff ff       	call   80100566 <panic>

  ilock(ip);
80105efe:	83 ec 0c             	sub    $0xc,%esp
80105f01:	ff 75 f0             	pushl  -0x10(%ebp)
80105f04:	e8 02 ba ff ff       	call   8010190b <ilock>
80105f09:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f0f:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105f13:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f1a:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105f1e:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f25:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105f2b:	83 ec 0c             	sub    $0xc,%esp
80105f2e:	ff 75 f0             	pushl  -0x10(%ebp)
80105f31:	e8 01 b8 ff ff       	call   80101737 <iupdate>
80105f36:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105f39:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105f3e:	75 6a                	jne    80105faa <create+0x195>
    dp->nlink++;  // for ".."
80105f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f43:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f47:	83 c0 01             	add    $0x1,%eax
80105f4a:	89 c2                	mov    %eax,%edx
80105f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f4f:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105f53:	83 ec 0c             	sub    $0xc,%esp
80105f56:	ff 75 f4             	pushl  -0xc(%ebp)
80105f59:	e8 d9 b7 ff ff       	call   80101737 <iupdate>
80105f5e:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f64:	8b 40 04             	mov    0x4(%eax),%eax
80105f67:	83 ec 04             	sub    $0x4,%esp
80105f6a:	50                   	push   %eax
80105f6b:	68 75 8c 10 80       	push   $0x80108c75
80105f70:	ff 75 f0             	pushl  -0x10(%ebp)
80105f73:	e8 af c2 ff ff       	call   80102227 <dirlink>
80105f78:	83 c4 10             	add    $0x10,%esp
80105f7b:	85 c0                	test   %eax,%eax
80105f7d:	78 1e                	js     80105f9d <create+0x188>
80105f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f82:	8b 40 04             	mov    0x4(%eax),%eax
80105f85:	83 ec 04             	sub    $0x4,%esp
80105f88:	50                   	push   %eax
80105f89:	68 77 8c 10 80       	push   $0x80108c77
80105f8e:	ff 75 f0             	pushl  -0x10(%ebp)
80105f91:	e8 91 c2 ff ff       	call   80102227 <dirlink>
80105f96:	83 c4 10             	add    $0x10,%esp
80105f99:	85 c0                	test   %eax,%eax
80105f9b:	79 0d                	jns    80105faa <create+0x195>
      panic("create dots");
80105f9d:	83 ec 0c             	sub    $0xc,%esp
80105fa0:	68 aa 8c 10 80       	push   $0x80108caa
80105fa5:	e8 bc a5 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fad:	8b 40 04             	mov    0x4(%eax),%eax
80105fb0:	83 ec 04             	sub    $0x4,%esp
80105fb3:	50                   	push   %eax
80105fb4:	8d 45 de             	lea    -0x22(%ebp),%eax
80105fb7:	50                   	push   %eax
80105fb8:	ff 75 f4             	pushl  -0xc(%ebp)
80105fbb:	e8 67 c2 ff ff       	call   80102227 <dirlink>
80105fc0:	83 c4 10             	add    $0x10,%esp
80105fc3:	85 c0                	test   %eax,%eax
80105fc5:	79 0d                	jns    80105fd4 <create+0x1bf>
    panic("create: dirlink");
80105fc7:	83 ec 0c             	sub    $0xc,%esp
80105fca:	68 b6 8c 10 80       	push   $0x80108cb6
80105fcf:	e8 92 a5 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80105fd4:	83 ec 0c             	sub    $0xc,%esp
80105fd7:	ff 75 f4             	pushl  -0xc(%ebp)
80105fda:	e8 e6 bb ff ff       	call   80101bc5 <iunlockput>
80105fdf:	83 c4 10             	add    $0x10,%esp

  return ip;
80105fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105fe5:	c9                   	leave  
80105fe6:	c3                   	ret    

80105fe7 <sys_open>:

int
sys_open(void)
{
80105fe7:	55                   	push   %ebp
80105fe8:	89 e5                	mov    %esp,%ebp
80105fea:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105fed:	83 ec 08             	sub    $0x8,%esp
80105ff0:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ff3:	50                   	push   %eax
80105ff4:	6a 00                	push   $0x0
80105ff6:	e8 eb f6 ff ff       	call   801056e6 <argstr>
80105ffb:	83 c4 10             	add    $0x10,%esp
80105ffe:	85 c0                	test   %eax,%eax
80106000:	78 15                	js     80106017 <sys_open+0x30>
80106002:	83 ec 08             	sub    $0x8,%esp
80106005:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106008:	50                   	push   %eax
80106009:	6a 01                	push   $0x1
8010600b:	e8 51 f6 ff ff       	call   80105661 <argint>
80106010:	83 c4 10             	add    $0x10,%esp
80106013:	85 c0                	test   %eax,%eax
80106015:	79 0a                	jns    80106021 <sys_open+0x3a>
    return -1;
80106017:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010601c:	e9 61 01 00 00       	jmp    80106182 <sys_open+0x19b>

  begin_op();
80106021:	e8 8e d4 ff ff       	call   801034b4 <begin_op>

  if(omode & O_CREATE){
80106026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106029:	25 00 02 00 00       	and    $0x200,%eax
8010602e:	85 c0                	test   %eax,%eax
80106030:	74 2a                	je     8010605c <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106032:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106035:	6a 00                	push   $0x0
80106037:	6a 00                	push   $0x0
80106039:	6a 02                	push   $0x2
8010603b:	50                   	push   %eax
8010603c:	e8 d4 fd ff ff       	call   80105e15 <create>
80106041:	83 c4 10             	add    $0x10,%esp
80106044:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106047:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010604b:	75 75                	jne    801060c2 <sys_open+0xdb>
      end_op();
8010604d:	e8 ee d4 ff ff       	call   80103540 <end_op>
      return -1;
80106052:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106057:	e9 26 01 00 00       	jmp    80106182 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
8010605c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010605f:	83 ec 0c             	sub    $0xc,%esp
80106062:	50                   	push   %eax
80106063:	e8 5b c4 ff ff       	call   801024c3 <namei>
80106068:	83 c4 10             	add    $0x10,%esp
8010606b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010606e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106072:	75 0f                	jne    80106083 <sys_open+0x9c>
      end_op();
80106074:	e8 c7 d4 ff ff       	call   80103540 <end_op>
      return -1;
80106079:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010607e:	e9 ff 00 00 00       	jmp    80106182 <sys_open+0x19b>
    }
    ilock(ip);
80106083:	83 ec 0c             	sub    $0xc,%esp
80106086:	ff 75 f4             	pushl  -0xc(%ebp)
80106089:	e8 7d b8 ff ff       	call   8010190b <ilock>
8010608e:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106091:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106094:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106098:	66 83 f8 01          	cmp    $0x1,%ax
8010609c:	75 24                	jne    801060c2 <sys_open+0xdb>
8010609e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060a1:	85 c0                	test   %eax,%eax
801060a3:	74 1d                	je     801060c2 <sys_open+0xdb>
      iunlockput(ip);
801060a5:	83 ec 0c             	sub    $0xc,%esp
801060a8:	ff 75 f4             	pushl  -0xc(%ebp)
801060ab:	e8 15 bb ff ff       	call   80101bc5 <iunlockput>
801060b0:	83 c4 10             	add    $0x10,%esp
      end_op();
801060b3:	e8 88 d4 ff ff       	call   80103540 <end_op>
      return -1;
801060b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060bd:	e9 c0 00 00 00       	jmp    80106182 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801060c2:	e8 b1 ae ff ff       	call   80100f78 <filealloc>
801060c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060ce:	74 17                	je     801060e7 <sys_open+0x100>
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	ff 75 f0             	pushl  -0x10(%ebp)
801060d6:	e8 37 f7 ff ff       	call   80105812 <fdalloc>
801060db:	83 c4 10             	add    $0x10,%esp
801060de:	89 45 ec             	mov    %eax,-0x14(%ebp)
801060e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801060e5:	79 2e                	jns    80106115 <sys_open+0x12e>
    if(f)
801060e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060eb:	74 0e                	je     801060fb <sys_open+0x114>
      fileclose(f);
801060ed:	83 ec 0c             	sub    $0xc,%esp
801060f0:	ff 75 f0             	pushl  -0x10(%ebp)
801060f3:	e8 3e af ff ff       	call   80101036 <fileclose>
801060f8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801060fb:	83 ec 0c             	sub    $0xc,%esp
801060fe:	ff 75 f4             	pushl  -0xc(%ebp)
80106101:	e8 bf ba ff ff       	call   80101bc5 <iunlockput>
80106106:	83 c4 10             	add    $0x10,%esp
    end_op();
80106109:	e8 32 d4 ff ff       	call   80103540 <end_op>
    return -1;
8010610e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106113:	eb 6d                	jmp    80106182 <sys_open+0x19b>
  }
  iunlock(ip);
80106115:	83 ec 0c             	sub    $0xc,%esp
80106118:	ff 75 f4             	pushl  -0xc(%ebp)
8010611b:	e8 43 b9 ff ff       	call   80101a63 <iunlock>
80106120:	83 c4 10             	add    $0x10,%esp
  end_op();
80106123:	e8 18 d4 ff ff       	call   80103540 <end_op>

  f->type = FD_INODE;
80106128:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010612b:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106131:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106134:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106137:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010613a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010613d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106147:	83 e0 01             	and    $0x1,%eax
8010614a:	85 c0                	test   %eax,%eax
8010614c:	0f 94 c0             	sete   %al
8010614f:	89 c2                	mov    %eax,%edx
80106151:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106154:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010615a:	83 e0 01             	and    $0x1,%eax
8010615d:	85 c0                	test   %eax,%eax
8010615f:	75 0a                	jne    8010616b <sys_open+0x184>
80106161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106164:	83 e0 02             	and    $0x2,%eax
80106167:	85 c0                	test   %eax,%eax
80106169:	74 07                	je     80106172 <sys_open+0x18b>
8010616b:	b8 01 00 00 00       	mov    $0x1,%eax
80106170:	eb 05                	jmp    80106177 <sys_open+0x190>
80106172:	b8 00 00 00 00       	mov    $0x0,%eax
80106177:	89 c2                	mov    %eax,%edx
80106179:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010617c:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010617f:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106182:	c9                   	leave  
80106183:	c3                   	ret    

80106184 <sys_mkdir>:

int
sys_mkdir(void)
{
80106184:	55                   	push   %ebp
80106185:	89 e5                	mov    %esp,%ebp
80106187:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010618a:	e8 25 d3 ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010618f:	83 ec 08             	sub    $0x8,%esp
80106192:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106195:	50                   	push   %eax
80106196:	6a 00                	push   $0x0
80106198:	e8 49 f5 ff ff       	call   801056e6 <argstr>
8010619d:	83 c4 10             	add    $0x10,%esp
801061a0:	85 c0                	test   %eax,%eax
801061a2:	78 1b                	js     801061bf <sys_mkdir+0x3b>
801061a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061a7:	6a 00                	push   $0x0
801061a9:	6a 00                	push   $0x0
801061ab:	6a 01                	push   $0x1
801061ad:	50                   	push   %eax
801061ae:	e8 62 fc ff ff       	call   80105e15 <create>
801061b3:	83 c4 10             	add    $0x10,%esp
801061b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061bd:	75 0c                	jne    801061cb <sys_mkdir+0x47>
    end_op();
801061bf:	e8 7c d3 ff ff       	call   80103540 <end_op>
    return -1;
801061c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061c9:	eb 18                	jmp    801061e3 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801061cb:	83 ec 0c             	sub    $0xc,%esp
801061ce:	ff 75 f4             	pushl  -0xc(%ebp)
801061d1:	e8 ef b9 ff ff       	call   80101bc5 <iunlockput>
801061d6:	83 c4 10             	add    $0x10,%esp
  end_op();
801061d9:	e8 62 d3 ff ff       	call   80103540 <end_op>
  return 0;
801061de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061e3:	c9                   	leave  
801061e4:	c3                   	ret    

801061e5 <sys_mknod>:

int
sys_mknod(void)
{
801061e5:	55                   	push   %ebp
801061e6:	89 e5                	mov    %esp,%ebp
801061e8:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801061eb:	e8 c4 d2 ff ff       	call   801034b4 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801061f0:	83 ec 08             	sub    $0x8,%esp
801061f3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061f6:	50                   	push   %eax
801061f7:	6a 00                	push   $0x0
801061f9:	e8 e8 f4 ff ff       	call   801056e6 <argstr>
801061fe:	83 c4 10             	add    $0x10,%esp
80106201:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106208:	78 4f                	js     80106259 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
8010620a:	83 ec 08             	sub    $0x8,%esp
8010620d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106210:	50                   	push   %eax
80106211:	6a 01                	push   $0x1
80106213:	e8 49 f4 ff ff       	call   80105661 <argint>
80106218:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010621b:	85 c0                	test   %eax,%eax
8010621d:	78 3a                	js     80106259 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010621f:	83 ec 08             	sub    $0x8,%esp
80106222:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106225:	50                   	push   %eax
80106226:	6a 02                	push   $0x2
80106228:	e8 34 f4 ff ff       	call   80105661 <argint>
8010622d:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106230:	85 c0                	test   %eax,%eax
80106232:	78 25                	js     80106259 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106234:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106237:	0f bf c8             	movswl %ax,%ecx
8010623a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010623d:	0f bf d0             	movswl %ax,%edx
80106240:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106243:	51                   	push   %ecx
80106244:	52                   	push   %edx
80106245:	6a 03                	push   $0x3
80106247:	50                   	push   %eax
80106248:	e8 c8 fb ff ff       	call   80105e15 <create>
8010624d:	83 c4 10             	add    $0x10,%esp
80106250:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106253:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106257:	75 0c                	jne    80106265 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106259:	e8 e2 d2 ff ff       	call   80103540 <end_op>
    return -1;
8010625e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106263:	eb 18                	jmp    8010627d <sys_mknod+0x98>
  }
  iunlockput(ip);
80106265:	83 ec 0c             	sub    $0xc,%esp
80106268:	ff 75 f0             	pushl  -0x10(%ebp)
8010626b:	e8 55 b9 ff ff       	call   80101bc5 <iunlockput>
80106270:	83 c4 10             	add    $0x10,%esp
  end_op();
80106273:	e8 c8 d2 ff ff       	call   80103540 <end_op>
  return 0;
80106278:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010627d:	c9                   	leave  
8010627e:	c3                   	ret    

8010627f <sys_chdir>:

int
sys_chdir(void)
{
8010627f:	55                   	push   %ebp
80106280:	89 e5                	mov    %esp,%ebp
80106282:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106285:	e8 2a d2 ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010628a:	83 ec 08             	sub    $0x8,%esp
8010628d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106290:	50                   	push   %eax
80106291:	6a 00                	push   $0x0
80106293:	e8 4e f4 ff ff       	call   801056e6 <argstr>
80106298:	83 c4 10             	add    $0x10,%esp
8010629b:	85 c0                	test   %eax,%eax
8010629d:	78 18                	js     801062b7 <sys_chdir+0x38>
8010629f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062a2:	83 ec 0c             	sub    $0xc,%esp
801062a5:	50                   	push   %eax
801062a6:	e8 18 c2 ff ff       	call   801024c3 <namei>
801062ab:	83 c4 10             	add    $0x10,%esp
801062ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062b5:	75 0c                	jne    801062c3 <sys_chdir+0x44>
    end_op();
801062b7:	e8 84 d2 ff ff       	call   80103540 <end_op>
    return -1;
801062bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062c1:	eb 6e                	jmp    80106331 <sys_chdir+0xb2>
  }
  ilock(ip);
801062c3:	83 ec 0c             	sub    $0xc,%esp
801062c6:	ff 75 f4             	pushl  -0xc(%ebp)
801062c9:	e8 3d b6 ff ff       	call   8010190b <ilock>
801062ce:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801062d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062d8:	66 83 f8 01          	cmp    $0x1,%ax
801062dc:	74 1a                	je     801062f8 <sys_chdir+0x79>
    iunlockput(ip);
801062de:	83 ec 0c             	sub    $0xc,%esp
801062e1:	ff 75 f4             	pushl  -0xc(%ebp)
801062e4:	e8 dc b8 ff ff       	call   80101bc5 <iunlockput>
801062e9:	83 c4 10             	add    $0x10,%esp
    end_op();
801062ec:	e8 4f d2 ff ff       	call   80103540 <end_op>
    return -1;
801062f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062f6:	eb 39                	jmp    80106331 <sys_chdir+0xb2>
  }
  iunlock(ip);
801062f8:	83 ec 0c             	sub    $0xc,%esp
801062fb:	ff 75 f4             	pushl  -0xc(%ebp)
801062fe:	e8 60 b7 ff ff       	call   80101a63 <iunlock>
80106303:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106306:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010630c:	8b 40 68             	mov    0x68(%eax),%eax
8010630f:	83 ec 0c             	sub    $0xc,%esp
80106312:	50                   	push   %eax
80106313:	e8 bd b7 ff ff       	call   80101ad5 <iput>
80106318:	83 c4 10             	add    $0x10,%esp
  end_op();
8010631b:	e8 20 d2 ff ff       	call   80103540 <end_op>
  proc->cwd = ip;
80106320:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106326:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106329:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010632c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106331:	c9                   	leave  
80106332:	c3                   	ret    

80106333 <sys_exec>:

int
sys_exec(void)
{
80106333:	55                   	push   %ebp
80106334:	89 e5                	mov    %esp,%ebp
80106336:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010633c:	83 ec 08             	sub    $0x8,%esp
8010633f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106342:	50                   	push   %eax
80106343:	6a 00                	push   $0x0
80106345:	e8 9c f3 ff ff       	call   801056e6 <argstr>
8010634a:	83 c4 10             	add    $0x10,%esp
8010634d:	85 c0                	test   %eax,%eax
8010634f:	78 18                	js     80106369 <sys_exec+0x36>
80106351:	83 ec 08             	sub    $0x8,%esp
80106354:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010635a:	50                   	push   %eax
8010635b:	6a 01                	push   $0x1
8010635d:	e8 ff f2 ff ff       	call   80105661 <argint>
80106362:	83 c4 10             	add    $0x10,%esp
80106365:	85 c0                	test   %eax,%eax
80106367:	79 0a                	jns    80106373 <sys_exec+0x40>
    return -1;
80106369:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010636e:	e9 c6 00 00 00       	jmp    80106439 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106373:	83 ec 04             	sub    $0x4,%esp
80106376:	68 80 00 00 00       	push   $0x80
8010637b:	6a 00                	push   $0x0
8010637d:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106383:	50                   	push   %eax
80106384:	e8 b3 ef ff ff       	call   8010533c <memset>
80106389:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
8010638c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106396:	83 f8 1f             	cmp    $0x1f,%eax
80106399:	76 0a                	jbe    801063a5 <sys_exec+0x72>
      return -1;
8010639b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a0:	e9 94 00 00 00       	jmp    80106439 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801063a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a8:	c1 e0 02             	shl    $0x2,%eax
801063ab:	89 c2                	mov    %eax,%edx
801063ad:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801063b3:	01 c2                	add    %eax,%edx
801063b5:	83 ec 08             	sub    $0x8,%esp
801063b8:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801063be:	50                   	push   %eax
801063bf:	52                   	push   %edx
801063c0:	e8 00 f2 ff ff       	call   801055c5 <fetchint>
801063c5:	83 c4 10             	add    $0x10,%esp
801063c8:	85 c0                	test   %eax,%eax
801063ca:	79 07                	jns    801063d3 <sys_exec+0xa0>
      return -1;
801063cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063d1:	eb 66                	jmp    80106439 <sys_exec+0x106>
    if(uarg == 0){
801063d3:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801063d9:	85 c0                	test   %eax,%eax
801063db:	75 27                	jne    80106404 <sys_exec+0xd1>
      argv[i] = 0;
801063dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063e0:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801063e7:	00 00 00 00 
      break;
801063eb:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801063ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ef:	83 ec 08             	sub    $0x8,%esp
801063f2:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801063f8:	52                   	push   %edx
801063f9:	50                   	push   %eax
801063fa:	e8 57 a7 ff ff       	call   80100b56 <exec>
801063ff:	83 c4 10             	add    $0x10,%esp
80106402:	eb 35                	jmp    80106439 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106404:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010640a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010640d:	c1 e2 02             	shl    $0x2,%edx
80106410:	01 c2                	add    %eax,%edx
80106412:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106418:	83 ec 08             	sub    $0x8,%esp
8010641b:	52                   	push   %edx
8010641c:	50                   	push   %eax
8010641d:	e8 dd f1 ff ff       	call   801055ff <fetchstr>
80106422:	83 c4 10             	add    $0x10,%esp
80106425:	85 c0                	test   %eax,%eax
80106427:	79 07                	jns    80106430 <sys_exec+0xfd>
      return -1;
80106429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010642e:	eb 09                	jmp    80106439 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106430:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106434:	e9 5a ff ff ff       	jmp    80106393 <sys_exec+0x60>
  return exec(path, argv);
}
80106439:	c9                   	leave  
8010643a:	c3                   	ret    

8010643b <sys_pipe>:

int
sys_pipe(void)
{
8010643b:	55                   	push   %ebp
8010643c:	89 e5                	mov    %esp,%ebp
8010643e:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106441:	83 ec 04             	sub    $0x4,%esp
80106444:	6a 08                	push   $0x8
80106446:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106449:	50                   	push   %eax
8010644a:	6a 00                	push   $0x0
8010644c:	e8 38 f2 ff ff       	call   80105689 <argptr>
80106451:	83 c4 10             	add    $0x10,%esp
80106454:	85 c0                	test   %eax,%eax
80106456:	79 0a                	jns    80106462 <sys_pipe+0x27>
    return -1;
80106458:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010645d:	e9 af 00 00 00       	jmp    80106511 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106462:	83 ec 08             	sub    $0x8,%esp
80106465:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106468:	50                   	push   %eax
80106469:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010646c:	50                   	push   %eax
8010646d:	e8 1b db ff ff       	call   80103f8d <pipealloc>
80106472:	83 c4 10             	add    $0x10,%esp
80106475:	85 c0                	test   %eax,%eax
80106477:	79 0a                	jns    80106483 <sys_pipe+0x48>
    return -1;
80106479:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010647e:	e9 8e 00 00 00       	jmp    80106511 <sys_pipe+0xd6>
  fd0 = -1;
80106483:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010648a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010648d:	83 ec 0c             	sub    $0xc,%esp
80106490:	50                   	push   %eax
80106491:	e8 7c f3 ff ff       	call   80105812 <fdalloc>
80106496:	83 c4 10             	add    $0x10,%esp
80106499:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010649c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064a0:	78 18                	js     801064ba <sys_pipe+0x7f>
801064a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064a5:	83 ec 0c             	sub    $0xc,%esp
801064a8:	50                   	push   %eax
801064a9:	e8 64 f3 ff ff       	call   80105812 <fdalloc>
801064ae:	83 c4 10             	add    $0x10,%esp
801064b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064b8:	79 3f                	jns    801064f9 <sys_pipe+0xbe>
    if(fd0 >= 0)
801064ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064be:	78 14                	js     801064d4 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
801064c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064c9:	83 c2 08             	add    $0x8,%edx
801064cc:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801064d3:	00 
    fileclose(rf);
801064d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064d7:	83 ec 0c             	sub    $0xc,%esp
801064da:	50                   	push   %eax
801064db:	e8 56 ab ff ff       	call   80101036 <fileclose>
801064e0:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801064e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064e6:	83 ec 0c             	sub    $0xc,%esp
801064e9:	50                   	push   %eax
801064ea:	e8 47 ab ff ff       	call   80101036 <fileclose>
801064ef:	83 c4 10             	add    $0x10,%esp
    return -1;
801064f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064f7:	eb 18                	jmp    80106511 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801064f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064ff:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106501:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106504:	8d 50 04             	lea    0x4(%eax),%edx
80106507:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010650a:	89 02                	mov    %eax,(%edx)
  return 0;
8010650c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106511:	c9                   	leave  
80106512:	c3                   	ret    

80106513 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80106513:	55                   	push   %ebp
80106514:	89 e5                	mov    %esp,%ebp
80106516:	83 ec 08             	sub    $0x8,%esp
80106519:	8b 55 08             	mov    0x8(%ebp),%edx
8010651c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010651f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106523:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106527:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
8010652b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010652f:	66 ef                	out    %ax,(%dx)
}
80106531:	90                   	nop
80106532:	c9                   	leave  
80106533:	c3                   	ret    

80106534 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106534:	55                   	push   %ebp
80106535:	89 e5                	mov    %esp,%ebp
80106537:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010653a:	e8 6e e1 ff ff       	call   801046ad <fork>
}
8010653f:	c9                   	leave  
80106540:	c3                   	ret    

80106541 <sys_exit>:


int
sys_exit(void)
{
80106541:	55                   	push   %ebp
80106542:	89 e5                	mov    %esp,%ebp
80106544:	83 ec 08             	sub    $0x8,%esp
  exit();
80106547:	e8 f2 e2 ff ff       	call   8010483e <exit>
  return 0;  // not reached
8010654c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106551:	c9                   	leave  
80106552:	c3                   	ret    

80106553 <sys_wait>:

int
sys_wait(void)
{
80106553:	55                   	push   %ebp
80106554:	89 e5                	mov    %esp,%ebp
80106556:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106559:	e8 1b e4 ff ff       	call   80104979 <wait>
}
8010655e:	c9                   	leave  
8010655f:	c3                   	ret    

80106560 <sys_kill>:

int
sys_kill(void)
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106566:	83 ec 08             	sub    $0x8,%esp
80106569:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010656c:	50                   	push   %eax
8010656d:	6a 00                	push   $0x0
8010656f:	e8 ed f0 ff ff       	call   80105661 <argint>
80106574:	83 c4 10             	add    $0x10,%esp
80106577:	85 c0                	test   %eax,%eax
80106579:	79 07                	jns    80106582 <sys_kill+0x22>
    return -1;
8010657b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106580:	eb 0f                	jmp    80106591 <sys_kill+0x31>
  return kill(pid);
80106582:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106585:	83 ec 0c             	sub    $0xc,%esp
80106588:	50                   	push   %eax
80106589:	e8 07 e8 ff ff       	call   80104d95 <kill>
8010658e:	83 c4 10             	add    $0x10,%esp
}
80106591:	c9                   	leave  
80106592:	c3                   	ret    

80106593 <sys_getpid>:

int
sys_getpid(void)
{
80106593:	55                   	push   %ebp
80106594:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106596:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010659c:	8b 40 10             	mov    0x10(%eax),%eax
}
8010659f:	5d                   	pop    %ebp
801065a0:	c3                   	ret    

801065a1 <sys_sbrk>:

int
sys_sbrk(void)
{
801065a1:	55                   	push   %ebp
801065a2:	89 e5                	mov    %esp,%ebp
801065a4:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801065a7:	83 ec 08             	sub    $0x8,%esp
801065aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065ad:	50                   	push   %eax
801065ae:	6a 00                	push   $0x0
801065b0:	e8 ac f0 ff ff       	call   80105661 <argint>
801065b5:	83 c4 10             	add    $0x10,%esp
801065b8:	85 c0                	test   %eax,%eax
801065ba:	79 07                	jns    801065c3 <sys_sbrk+0x22>
    return -1;
801065bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065c1:	eb 28                	jmp    801065eb <sys_sbrk+0x4a>
  addr = proc->sz;
801065c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065c9:	8b 00                	mov    (%eax),%eax
801065cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801065ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065d1:	83 ec 0c             	sub    $0xc,%esp
801065d4:	50                   	push   %eax
801065d5:	e8 30 e0 ff ff       	call   8010460a <growproc>
801065da:	83 c4 10             	add    $0x10,%esp
801065dd:	85 c0                	test   %eax,%eax
801065df:	79 07                	jns    801065e8 <sys_sbrk+0x47>
    return -1;
801065e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e6:	eb 03                	jmp    801065eb <sys_sbrk+0x4a>
  return addr;
801065e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801065eb:	c9                   	leave  
801065ec:	c3                   	ret    

801065ed <sys_sleep>:

int
sys_sleep(void)
{
801065ed:	55                   	push   %ebp
801065ee:	89 e5                	mov    %esp,%ebp
801065f0:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801065f3:	83 ec 08             	sub    $0x8,%esp
801065f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065f9:	50                   	push   %eax
801065fa:	6a 00                	push   $0x0
801065fc:	e8 60 f0 ff ff       	call   80105661 <argint>
80106601:	83 c4 10             	add    $0x10,%esp
80106604:	85 c0                	test   %eax,%eax
80106606:	79 07                	jns    8010660f <sys_sleep+0x22>
    return -1;
80106608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010660d:	eb 77                	jmp    80106686 <sys_sleep+0x99>
  acquire(&tickslock);
8010660f:	83 ec 0c             	sub    $0xc,%esp
80106612:	68 c0 4b 11 80       	push   $0x80114bc0
80106617:	e8 bd ea ff ff       	call   801050d9 <acquire>
8010661c:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
8010661f:	a1 00 54 11 80       	mov    0x80115400,%eax
80106624:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106627:	eb 39                	jmp    80106662 <sys_sleep+0x75>
    if(proc->killed){
80106629:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010662f:	8b 40 24             	mov    0x24(%eax),%eax
80106632:	85 c0                	test   %eax,%eax
80106634:	74 17                	je     8010664d <sys_sleep+0x60>
      release(&tickslock);
80106636:	83 ec 0c             	sub    $0xc,%esp
80106639:	68 c0 4b 11 80       	push   $0x80114bc0
8010663e:	e8 fd ea ff ff       	call   80105140 <release>
80106643:	83 c4 10             	add    $0x10,%esp
      return -1;
80106646:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010664b:	eb 39                	jmp    80106686 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
8010664d:	83 ec 08             	sub    $0x8,%esp
80106650:	68 c0 4b 11 80       	push   $0x80114bc0
80106655:	68 00 54 11 80       	push   $0x80115400
8010665a:	e8 11 e6 ff ff       	call   80104c70 <sleep>
8010665f:	83 c4 10             	add    $0x10,%esp

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106662:	a1 00 54 11 80       	mov    0x80115400,%eax
80106667:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010666a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010666d:	39 d0                	cmp    %edx,%eax
8010666f:	72 b8                	jb     80106629 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106671:	83 ec 0c             	sub    $0xc,%esp
80106674:	68 c0 4b 11 80       	push   $0x80114bc0
80106679:	e8 c2 ea ff ff       	call   80105140 <release>
8010667e:	83 c4 10             	add    $0x10,%esp
  return 0;
80106681:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106686:	c9                   	leave  
80106687:	c3                   	ret    

80106688 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106688:	55                   	push   %ebp
80106689:	89 e5                	mov    %esp,%ebp
8010668b:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
8010668e:	83 ec 0c             	sub    $0xc,%esp
80106691:	68 c0 4b 11 80       	push   $0x80114bc0
80106696:	e8 3e ea ff ff       	call   801050d9 <acquire>
8010669b:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
8010669e:	a1 00 54 11 80       	mov    0x80115400,%eax
801066a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801066a6:	83 ec 0c             	sub    $0xc,%esp
801066a9:	68 c0 4b 11 80       	push   $0x80114bc0
801066ae:	e8 8d ea ff ff       	call   80105140 <release>
801066b3:	83 c4 10             	add    $0x10,%esp
  return xticks;
801066b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801066b9:	c9                   	leave  
801066ba:	c3                   	ret    

801066bb <sys_halt>:
// signal to QEMU.
// Based on: http://pdos.csail.mit.edu/6.828/2012/homework/xv6-syscall.html
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
801066bb:	55                   	push   %ebp
801066bc:	89 e5                	mov    %esp,%ebp
801066be:	83 ec 10             	sub    $0x10,%esp
  char *p = "Shutdown";
801066c1:	c7 45 fc c6 8c 10 80 	movl   $0x80108cc6,-0x4(%ebp)
  for( ; *p; p++)
801066c8:	eb 16                	jmp    801066e0 <sys_halt+0x25>
    outw(0xB004, 0x2000);
801066ca:	68 00 20 00 00       	push   $0x2000
801066cf:	68 04 b0 00 00       	push   $0xb004
801066d4:	e8 3a fe ff ff       	call   80106513 <outw>
801066d9:	83 c4 08             	add    $0x8,%esp
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
  char *p = "Shutdown";
  for( ; *p; p++)
801066dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801066e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801066e3:	0f b6 00             	movzbl (%eax),%eax
801066e6:	84 c0                	test   %al,%al
801066e8:	75 e0                	jne    801066ca <sys_halt+0xf>
    outw(0xB004, 0x2000);
  return 0;
801066ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066ef:	c9                   	leave  
801066f0:	c3                   	ret    

801066f1 <sys_mprotect>:

int sys_mprotect(void)
{
801066f1:	55                   	push   %ebp
801066f2:	89 e5                	mov    %esp,%ebp
801066f4:	83 ec 18             	sub    $0x18,%esp
  int addr,len,prot;

  if(argint(0, &addr) <0)
801066f7:	83 ec 08             	sub    $0x8,%esp
801066fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066fd:	50                   	push   %eax
801066fe:	6a 00                	push   $0x0
80106700:	e8 5c ef ff ff       	call   80105661 <argint>
80106705:	83 c4 10             	add    $0x10,%esp
80106708:	85 c0                	test   %eax,%eax
8010670a:	79 07                	jns    80106713 <sys_mprotect+0x22>
    return -1;
8010670c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106711:	eb 4f                	jmp    80106762 <sys_mprotect+0x71>
  if(argint(1,&len) <0)
80106713:	83 ec 08             	sub    $0x8,%esp
80106716:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106719:	50                   	push   %eax
8010671a:	6a 01                	push   $0x1
8010671c:	e8 40 ef ff ff       	call   80105661 <argint>
80106721:	83 c4 10             	add    $0x10,%esp
80106724:	85 c0                	test   %eax,%eax
80106726:	79 07                	jns    8010672f <sys_mprotect+0x3e>
    return -1;
80106728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010672d:	eb 33                	jmp    80106762 <sys_mprotect+0x71>
  if(argint(2,&prot) <0)
8010672f:	83 ec 08             	sub    $0x8,%esp
80106732:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106735:	50                   	push   %eax
80106736:	6a 02                	push   $0x2
80106738:	e8 24 ef ff ff       	call   80105661 <argint>
8010673d:	83 c4 10             	add    $0x10,%esp
80106740:	85 c0                	test   %eax,%eax
80106742:	79 07                	jns    8010674b <sys_mprotect+0x5a>
    return -1;
80106744:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106749:	eb 17                	jmp    80106762 <sys_mprotect+0x71>

  return mprotect((void*)addr,len,prot);
8010674b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010674e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106751:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80106754:	83 ec 04             	sub    $0x4,%esp
80106757:	52                   	push   %edx
80106758:	50                   	push   %eax
80106759:	51                   	push   %ecx
8010675a:	e8 1e 1c 00 00       	call   8010837d <mprotect>
8010675f:	83 c4 10             	add    $0x10,%esp
}
80106762:	c9                   	leave  
80106763:	c3                   	ret    

80106764 <sys_signal_register>:

int sys_signal_register(void)
{
80106764:	55                   	push   %ebp
80106765:	89 e5                	mov    %esp,%ebp
80106767:	83 ec 18             	sub    $0x18,%esp
    uint signum;
    sighandler_t handler;
    int n;

    if (argint(0, &n) < 0)
8010676a:	83 ec 08             	sub    $0x8,%esp
8010676d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106770:	50                   	push   %eax
80106771:	6a 00                	push   $0x0
80106773:	e8 e9 ee ff ff       	call   80105661 <argint>
80106778:	83 c4 10             	add    $0x10,%esp
8010677b:	85 c0                	test   %eax,%eax
8010677d:	79 07                	jns    80106786 <sys_signal_register+0x22>
      return -1;
8010677f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106784:	eb 3a                	jmp    801067c0 <sys_signal_register+0x5c>
    signum = (uint) n;
80106786:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106789:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (argint(1, &n) < 0)
8010678c:	83 ec 08             	sub    $0x8,%esp
8010678f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106792:	50                   	push   %eax
80106793:	6a 01                	push   $0x1
80106795:	e8 c7 ee ff ff       	call   80105661 <argint>
8010679a:	83 c4 10             	add    $0x10,%esp
8010679d:	85 c0                	test   %eax,%eax
8010679f:	79 07                	jns    801067a8 <sys_signal_register+0x44>
      return -1;
801067a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067a6:	eb 18                	jmp    801067c0 <sys_signal_register+0x5c>
    handler = (sighandler_t) n;
801067a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067ab:	89 45 f0             	mov    %eax,-0x10(%ebp)

    return (int) signal_register_handler(signum, handler);
801067ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067b1:	83 ec 08             	sub    $0x8,%esp
801067b4:	ff 75 f0             	pushl  -0x10(%ebp)
801067b7:	50                   	push   %eax
801067b8:	e8 80 e8 ff ff       	call   8010503d <signal_register_handler>
801067bd:	83 c4 10             	add    $0x10,%esp
}
801067c0:	c9                   	leave  
801067c1:	c3                   	ret    

801067c2 <sys_signal_restorer>:

int sys_signal_restorer(void)
{
801067c2:	55                   	push   %ebp
801067c3:	89 e5                	mov    %esp,%ebp
801067c5:	83 ec 18             	sub    $0x18,%esp
    int restorer_addr;
    if (argint(0, &restorer_addr) < 0)
801067c8:	83 ec 08             	sub    $0x8,%esp
801067cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067ce:	50                   	push   %eax
801067cf:	6a 00                	push   $0x0
801067d1:	e8 8b ee ff ff       	call   80105661 <argint>
801067d6:	83 c4 10             	add    $0x10,%esp
801067d9:	85 c0                	test   %eax,%eax
801067db:	79 07                	jns    801067e4 <sys_signal_restorer+0x22>
      return -1;
801067dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067e2:	eb 14                	jmp    801067f8 <sys_signal_restorer+0x36>

    proc->restorer_addr = (uint) restorer_addr;
801067e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067ed:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

    return 0;
801067f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067f8:	c9                   	leave  
801067f9:	c3                   	ret    

801067fa <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801067fa:	55                   	push   %ebp
801067fb:	89 e5                	mov    %esp,%ebp
801067fd:	83 ec 08             	sub    $0x8,%esp
80106800:	8b 55 08             	mov    0x8(%ebp),%edx
80106803:	8b 45 0c             	mov    0xc(%ebp),%eax
80106806:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010680a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010680d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106811:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106815:	ee                   	out    %al,(%dx)
}
80106816:	90                   	nop
80106817:	c9                   	leave  
80106818:	c3                   	ret    

80106819 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106819:	55                   	push   %ebp
8010681a:	89 e5                	mov    %esp,%ebp
8010681c:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
8010681f:	6a 34                	push   $0x34
80106821:	6a 43                	push   $0x43
80106823:	e8 d2 ff ff ff       	call   801067fa <outb>
80106828:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
8010682b:	68 9c 00 00 00       	push   $0x9c
80106830:	6a 40                	push   $0x40
80106832:	e8 c3 ff ff ff       	call   801067fa <outb>
80106837:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
8010683a:	6a 2e                	push   $0x2e
8010683c:	6a 40                	push   $0x40
8010683e:	e8 b7 ff ff ff       	call   801067fa <outb>
80106843:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106846:	83 ec 0c             	sub    $0xc,%esp
80106849:	6a 00                	push   $0x0
8010684b:	e8 27 d6 ff ff       	call   80103e77 <picenable>
80106850:	83 c4 10             	add    $0x10,%esp
}
80106853:	90                   	nop
80106854:	c9                   	leave  
80106855:	c3                   	ret    

80106856 <alltraps>:
80106856:	1e                   	push   %ds
80106857:	06                   	push   %es
80106858:	0f a0                	push   %fs
8010685a:	0f a8                	push   %gs
8010685c:	60                   	pusha  
8010685d:	66 b8 10 00          	mov    $0x10,%ax
80106861:	8e d8                	mov    %eax,%ds
80106863:	8e c0                	mov    %eax,%es
80106865:	66 b8 18 00          	mov    $0x18,%ax
80106869:	8e e0                	mov    %eax,%fs
8010686b:	8e e8                	mov    %eax,%gs
8010686d:	54                   	push   %esp
8010686e:	e8 d7 01 00 00       	call   80106a4a <trap>
80106873:	83 c4 04             	add    $0x4,%esp

80106876 <trapret>:
80106876:	61                   	popa   
80106877:	0f a9                	pop    %gs
80106879:	0f a1                	pop    %fs
8010687b:	07                   	pop    %es
8010687c:	1f                   	pop    %ds
8010687d:	83 c4 08             	add    $0x8,%esp
80106880:	cf                   	iret   

80106881 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106881:	55                   	push   %ebp
80106882:	89 e5                	mov    %esp,%ebp
80106884:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106887:	8b 45 0c             	mov    0xc(%ebp),%eax
8010688a:	83 e8 01             	sub    $0x1,%eax
8010688d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106891:	8b 45 08             	mov    0x8(%ebp),%eax
80106894:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106898:	8b 45 08             	mov    0x8(%ebp),%eax
8010689b:	c1 e8 10             	shr    $0x10,%eax
8010689e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801068a2:	8d 45 fa             	lea    -0x6(%ebp),%eax
801068a5:	0f 01 18             	lidtl  (%eax)
}
801068a8:	90                   	nop
801068a9:	c9                   	leave  
801068aa:	c3                   	ret    

801068ab <rcr2>:
  asm volatile("movl %eax,%cr3");
}

static inline uint
rcr2(void)
{
801068ab:	55                   	push   %ebp
801068ac:	89 e5                	mov    %esp,%ebp
801068ae:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801068b1:	0f 20 d0             	mov    %cr2,%eax
801068b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801068b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801068ba:	c9                   	leave  
801068bb:	c3                   	ret    

801068bc <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801068bc:	55                   	push   %ebp
801068bd:	89 e5                	mov    %esp,%ebp
801068bf:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801068c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801068c9:	e9 c3 00 00 00       	jmp    80106991 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801068ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068d1:	8b 04 85 a8 b0 10 80 	mov    -0x7fef4f58(,%eax,4),%eax
801068d8:	89 c2                	mov    %eax,%edx
801068da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068dd:	66 89 14 c5 00 4c 11 	mov    %dx,-0x7feeb400(,%eax,8)
801068e4:	80 
801068e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068e8:	66 c7 04 c5 02 4c 11 	movw   $0x8,-0x7feeb3fe(,%eax,8)
801068ef:	80 08 00 
801068f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068f5:	0f b6 14 c5 04 4c 11 	movzbl -0x7feeb3fc(,%eax,8),%edx
801068fc:	80 
801068fd:	83 e2 e0             	and    $0xffffffe0,%edx
80106900:	88 14 c5 04 4c 11 80 	mov    %dl,-0x7feeb3fc(,%eax,8)
80106907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010690a:	0f b6 14 c5 04 4c 11 	movzbl -0x7feeb3fc(,%eax,8),%edx
80106911:	80 
80106912:	83 e2 1f             	and    $0x1f,%edx
80106915:	88 14 c5 04 4c 11 80 	mov    %dl,-0x7feeb3fc(,%eax,8)
8010691c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010691f:	0f b6 14 c5 05 4c 11 	movzbl -0x7feeb3fb(,%eax,8),%edx
80106926:	80 
80106927:	83 e2 f0             	and    $0xfffffff0,%edx
8010692a:	83 ca 0e             	or     $0xe,%edx
8010692d:	88 14 c5 05 4c 11 80 	mov    %dl,-0x7feeb3fb(,%eax,8)
80106934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106937:	0f b6 14 c5 05 4c 11 	movzbl -0x7feeb3fb(,%eax,8),%edx
8010693e:	80 
8010693f:	83 e2 ef             	and    $0xffffffef,%edx
80106942:	88 14 c5 05 4c 11 80 	mov    %dl,-0x7feeb3fb(,%eax,8)
80106949:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010694c:	0f b6 14 c5 05 4c 11 	movzbl -0x7feeb3fb(,%eax,8),%edx
80106953:	80 
80106954:	83 e2 9f             	and    $0xffffff9f,%edx
80106957:	88 14 c5 05 4c 11 80 	mov    %dl,-0x7feeb3fb(,%eax,8)
8010695e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106961:	0f b6 14 c5 05 4c 11 	movzbl -0x7feeb3fb(,%eax,8),%edx
80106968:	80 
80106969:	83 ca 80             	or     $0xffffff80,%edx
8010696c:	88 14 c5 05 4c 11 80 	mov    %dl,-0x7feeb3fb(,%eax,8)
80106973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106976:	8b 04 85 a8 b0 10 80 	mov    -0x7fef4f58(,%eax,4),%eax
8010697d:	c1 e8 10             	shr    $0x10,%eax
80106980:	89 c2                	mov    %eax,%edx
80106982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106985:	66 89 14 c5 06 4c 11 	mov    %dx,-0x7feeb3fa(,%eax,8)
8010698c:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010698d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106991:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106998:	0f 8e 30 ff ff ff    	jle    801068ce <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010699e:	a1 a8 b1 10 80       	mov    0x8010b1a8,%eax
801069a3:	66 a3 00 4e 11 80    	mov    %ax,0x80114e00
801069a9:	66 c7 05 02 4e 11 80 	movw   $0x8,0x80114e02
801069b0:	08 00 
801069b2:	0f b6 05 04 4e 11 80 	movzbl 0x80114e04,%eax
801069b9:	83 e0 e0             	and    $0xffffffe0,%eax
801069bc:	a2 04 4e 11 80       	mov    %al,0x80114e04
801069c1:	0f b6 05 04 4e 11 80 	movzbl 0x80114e04,%eax
801069c8:	83 e0 1f             	and    $0x1f,%eax
801069cb:	a2 04 4e 11 80       	mov    %al,0x80114e04
801069d0:	0f b6 05 05 4e 11 80 	movzbl 0x80114e05,%eax
801069d7:	83 c8 0f             	or     $0xf,%eax
801069da:	a2 05 4e 11 80       	mov    %al,0x80114e05
801069df:	0f b6 05 05 4e 11 80 	movzbl 0x80114e05,%eax
801069e6:	83 e0 ef             	and    $0xffffffef,%eax
801069e9:	a2 05 4e 11 80       	mov    %al,0x80114e05
801069ee:	0f b6 05 05 4e 11 80 	movzbl 0x80114e05,%eax
801069f5:	83 c8 60             	or     $0x60,%eax
801069f8:	a2 05 4e 11 80       	mov    %al,0x80114e05
801069fd:	0f b6 05 05 4e 11 80 	movzbl 0x80114e05,%eax
80106a04:	83 c8 80             	or     $0xffffff80,%eax
80106a07:	a2 05 4e 11 80       	mov    %al,0x80114e05
80106a0c:	a1 a8 b1 10 80       	mov    0x8010b1a8,%eax
80106a11:	c1 e8 10             	shr    $0x10,%eax
80106a14:	66 a3 06 4e 11 80    	mov    %ax,0x80114e06

  initlock(&tickslock, "time");
80106a1a:	83 ec 08             	sub    $0x8,%esp
80106a1d:	68 d0 8c 10 80       	push   $0x80108cd0
80106a22:	68 c0 4b 11 80       	push   $0x80114bc0
80106a27:	e8 8b e6 ff ff       	call   801050b7 <initlock>
80106a2c:	83 c4 10             	add    $0x10,%esp
}
80106a2f:	90                   	nop
80106a30:	c9                   	leave  
80106a31:	c3                   	ret    

80106a32 <idtinit>:

void
idtinit(void)
{
80106a32:	55                   	push   %ebp
80106a33:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106a35:	68 00 08 00 00       	push   $0x800
80106a3a:	68 00 4c 11 80       	push   $0x80114c00
80106a3f:	e8 3d fe ff ff       	call   80106881 <lidt>
80106a44:	83 c4 08             	add    $0x8,%esp
}
80106a47:	90                   	nop
80106a48:	c9                   	leave  
80106a49:	c3                   	ret    

80106a4a <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106a4a:	55                   	push   %ebp
80106a4b:	89 e5                	mov    %esp,%ebp
80106a4d:	57                   	push   %edi
80106a4e:	56                   	push   %esi
80106a4f:	53                   	push   %ebx
80106a50:	83 ec 2c             	sub    $0x2c,%esp
  siginfo_t si;
  if(tf->trapno == T_SYSCALL){
80106a53:	8b 45 08             	mov    0x8(%ebp),%eax
80106a56:	8b 40 30             	mov    0x30(%eax),%eax
80106a59:	83 f8 40             	cmp    $0x40,%eax
80106a5c:	75 3e                	jne    80106a9c <trap+0x52>
    if(proc->killed)
80106a5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a64:	8b 40 24             	mov    0x24(%eax),%eax
80106a67:	85 c0                	test   %eax,%eax
80106a69:	74 05                	je     80106a70 <trap+0x26>
      exit();
80106a6b:	e8 ce dd ff ff       	call   8010483e <exit>
    proc->tf = tf;
80106a70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a76:	8b 55 08             	mov    0x8(%ebp),%edx
80106a79:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106a7c:	e8 96 ec ff ff       	call   80105717 <syscall>
    if(proc->killed)
80106a81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a87:	8b 40 24             	mov    0x24(%eax),%eax
80106a8a:	85 c0                	test   %eax,%eax
80106a8c:	0f 84 b6 02 00 00    	je     80106d48 <trap+0x2fe>
      exit();
80106a92:	e8 a7 dd ff ff       	call   8010483e <exit>
80106a97:	e9 ad 02 00 00       	jmp    80106d49 <trap+0x2ff>
    return;
  }

  switch(tf->trapno){
80106a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a9f:	8b 40 30             	mov    0x30(%eax),%eax
80106aa2:	83 f8 3f             	cmp    $0x3f,%eax
80106aa5:	0f 87 5b 01 00 00    	ja     80106c06 <trap+0x1bc>
80106aab:	8b 04 85 78 8d 10 80 	mov    -0x7fef7288(,%eax,4),%eax
80106ab2:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106ab4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106aba:	0f b6 00             	movzbl (%eax),%eax
80106abd:	84 c0                	test   %al,%al
80106abf:	75 3d                	jne    80106afe <trap+0xb4>
      acquire(&tickslock);
80106ac1:	83 ec 0c             	sub    $0xc,%esp
80106ac4:	68 c0 4b 11 80       	push   $0x80114bc0
80106ac9:	e8 0b e6 ff ff       	call   801050d9 <acquire>
80106ace:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106ad1:	a1 00 54 11 80       	mov    0x80115400,%eax
80106ad6:	83 c0 01             	add    $0x1,%eax
80106ad9:	a3 00 54 11 80       	mov    %eax,0x80115400
      wakeup(&ticks);
80106ade:	83 ec 0c             	sub    $0xc,%esp
80106ae1:	68 00 54 11 80       	push   $0x80115400
80106ae6:	e8 73 e2 ff ff       	call   80104d5e <wakeup>
80106aeb:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106aee:	83 ec 0c             	sub    $0xc,%esp
80106af1:	68 c0 4b 11 80       	push   $0x80114bc0
80106af6:	e8 45 e6 ff ff       	call   80105140 <release>
80106afb:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106afe:	e8 81 c4 ff ff       	call   80102f84 <lapiceoi>
    break;
80106b03:	e9 ba 01 00 00       	jmp    80106cc2 <trap+0x278>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106b08:	e8 8a bc ff ff       	call   80102797 <ideintr>
    lapiceoi();
80106b0d:	e8 72 c4 ff ff       	call   80102f84 <lapiceoi>
    break;
80106b12:	e9 ab 01 00 00       	jmp    80106cc2 <trap+0x278>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106b17:	e8 6a c2 ff ff       	call   80102d86 <kbdintr>
    lapiceoi();
80106b1c:	e8 63 c4 ff ff       	call   80102f84 <lapiceoi>
    break;
80106b21:	e9 9c 01 00 00       	jmp    80106cc2 <trap+0x278>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106b26:	e8 fe 03 00 00       	call   80106f29 <uartintr>
    lapiceoi();
80106b2b:	e8 54 c4 ff ff       	call   80102f84 <lapiceoi>
    break;
80106b30:	e9 8d 01 00 00       	jmp    80106cc2 <trap+0x278>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b35:	8b 45 08             	mov    0x8(%ebp),%eax
80106b38:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b3e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b42:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106b45:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106b4b:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b4e:	0f b6 c0             	movzbl %al,%eax
80106b51:	51                   	push   %ecx
80106b52:	52                   	push   %edx
80106b53:	50                   	push   %eax
80106b54:	68 d8 8c 10 80       	push   $0x80108cd8
80106b59:	e8 68 98 ff ff       	call   801003c6 <cprintf>
80106b5e:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106b61:	e8 1e c4 ff ff       	call   80102f84 <lapiceoi>
    break;
80106b66:	e9 57 01 00 00       	jmp    80106cc2 <trap+0x278>

   case T_DIVIDE:
      if (proc->handlers[SIGFPE] != (sighandler_t) -1) {
80106b6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b71:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106b77:	83 f8 ff             	cmp    $0xffffffff,%eax
80106b7a:	74 27                	je     80106ba3 <trap+0x159>
        si.type=0;
80106b7c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
        si.addr = rcr2();
80106b83:	e8 23 fd ff ff       	call   801068ab <rcr2>
80106b88:	89 45 dc             	mov    %eax,-0x24(%ebp)
        signal_deliver(SIGFPE,si);
80106b8b:	83 ec 04             	sub    $0x4,%esp
80106b8e:	ff 75 e0             	pushl  -0x20(%ebp)
80106b91:	ff 75 dc             	pushl  -0x24(%ebp)
80106b94:	6a 01                	push   $0x1
80106b96:	e8 7d e3 ff ff       	call   80104f18 <signal_deliver>
80106b9b:	83 c4 10             	add    $0x10,%esp
        break;
80106b9e:	e9 1f 01 00 00       	jmp    80106cc2 <trap+0x278>
      }
    //handle pgfault with mem_protect
    case T_PGFLT:
      //create a siginfo_t struct
      if (proc->handlers[SIGSEGV] != (sighandler_t) -1) {
80106ba3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ba9:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80106baf:	83 f8 ff             	cmp    $0xffffffff,%eax
80106bb2:	0f 84 09 01 00 00    	je     80106cc1 <trap+0x277>
        int err = tf->err;
80106bb8:	8b 45 08             	mov    0x8(%ebp),%eax
80106bbb:	8b 40 34             	mov    0x34(%eax),%eax
80106bbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(err < 0x4) {
80106bc1:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
80106bc5:	7f 09                	jg     80106bd0 <trap+0x186>
          si.type = PROT_NONE;
80106bc7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
80106bce:	eb 16                	jmp    80106be6 <trap+0x19c>
        } else if(err < 0x6) {
80106bd0:	83 7d e4 05          	cmpl   $0x5,-0x1c(%ebp)
80106bd4:	7f 09                	jg     80106bdf <trap+0x195>
          si.type = PROT_READ;
80106bd6:	c7 45 e0 fd ff ff ff 	movl   $0xfffffffd,-0x20(%ebp)
80106bdd:	eb 07                	jmp    80106be6 <trap+0x19c>
        } else {
          si.type = PROT_WRITE;
80106bdf:	c7 45 e0 07 00 00 00 	movl   $0x7,-0x20(%ebp)
        }
        si.addr = rcr2();
80106be6:	e8 c0 fc ff ff       	call   801068ab <rcr2>
80106beb:	89 45 dc             	mov    %eax,-0x24(%ebp)
        signal_deliver(SIGSEGV,si);
80106bee:	83 ec 04             	sub    $0x4,%esp
80106bf1:	ff 75 e0             	pushl  -0x20(%ebp)
80106bf4:	ff 75 dc             	pushl  -0x24(%ebp)
80106bf7:	6a 02                	push   $0x2
80106bf9:	e8 1a e3 ff ff       	call   80104f18 <signal_deliver>
80106bfe:	83 c4 10             	add    $0x10,%esp
        break;
80106c01:	e9 bc 00 00 00       	jmp    80106cc2 <trap+0x278>

      break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106c06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c0c:	85 c0                	test   %eax,%eax
80106c0e:	74 11                	je     80106c21 <trap+0x1d7>
80106c10:	8b 45 08             	mov    0x8(%ebp),%eax
80106c13:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106c17:	0f b7 c0             	movzwl %ax,%eax
80106c1a:	83 e0 03             	and    $0x3,%eax
80106c1d:	85 c0                	test   %eax,%eax
80106c1f:	75 40                	jne    80106c61 <trap+0x217>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106c21:	e8 85 fc ff ff       	call   801068ab <rcr2>
80106c26:	89 c3                	mov    %eax,%ebx
80106c28:	8b 45 08             	mov    0x8(%ebp),%eax
80106c2b:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106c2e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106c34:	0f b6 00             	movzbl (%eax),%eax

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106c37:	0f b6 d0             	movzbl %al,%edx
80106c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c3d:	8b 40 30             	mov    0x30(%eax),%eax
80106c40:	83 ec 0c             	sub    $0xc,%esp
80106c43:	53                   	push   %ebx
80106c44:	51                   	push   %ecx
80106c45:	52                   	push   %edx
80106c46:	50                   	push   %eax
80106c47:	68 fc 8c 10 80       	push   $0x80108cfc
80106c4c:	e8 75 97 ff ff       	call   801003c6 <cprintf>
80106c51:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106c54:	83 ec 0c             	sub    $0xc,%esp
80106c57:	68 2e 8d 10 80       	push   $0x80108d2e
80106c5c:	e8 05 99 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c61:	e8 45 fc ff ff       	call   801068ab <rcr2>
80106c66:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106c69:	8b 45 08             	mov    0x8(%ebp),%eax
80106c6c:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106c6f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106c75:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c78:	0f b6 d8             	movzbl %al,%ebx
80106c7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c7e:	8b 48 34             	mov    0x34(%eax),%ecx
80106c81:	8b 45 08             	mov    0x8(%ebp),%eax
80106c84:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106c87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c8d:	8d 78 6c             	lea    0x6c(%eax),%edi
80106c90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c96:	8b 40 10             	mov    0x10(%eax),%eax
80106c99:	ff 75 d4             	pushl  -0x2c(%ebp)
80106c9c:	56                   	push   %esi
80106c9d:	53                   	push   %ebx
80106c9e:	51                   	push   %ecx
80106c9f:	52                   	push   %edx
80106ca0:	57                   	push   %edi
80106ca1:	50                   	push   %eax
80106ca2:	68 34 8d 10 80       	push   $0x80108d34
80106ca7:	e8 1a 97 ff ff       	call   801003c6 <cprintf>
80106cac:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
            rcr2());
    proc->killed = 1;
80106caf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cb5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106cbc:	eb 04                	jmp    80106cc2 <trap+0x278>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106cbe:	90                   	nop
80106cbf:	eb 01                	jmp    80106cc2 <trap+0x278>
        si.addr = rcr2();
        signal_deliver(SIGSEGV,si);
        break;
      }

      break;
80106cc1:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106cc2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cc8:	85 c0                	test   %eax,%eax
80106cca:	74 24                	je     80106cf0 <trap+0x2a6>
80106ccc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cd2:	8b 40 24             	mov    0x24(%eax),%eax
80106cd5:	85 c0                	test   %eax,%eax
80106cd7:	74 17                	je     80106cf0 <trap+0x2a6>
80106cd9:	8b 45 08             	mov    0x8(%ebp),%eax
80106cdc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ce0:	0f b7 c0             	movzwl %ax,%eax
80106ce3:	83 e0 03             	and    $0x3,%eax
80106ce6:	83 f8 03             	cmp    $0x3,%eax
80106ce9:	75 05                	jne    80106cf0 <trap+0x2a6>
    exit();
80106ceb:	e8 4e db ff ff       	call   8010483e <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106cf0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cf6:	85 c0                	test   %eax,%eax
80106cf8:	74 1e                	je     80106d18 <trap+0x2ce>
80106cfa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d00:	8b 40 0c             	mov    0xc(%eax),%eax
80106d03:	83 f8 04             	cmp    $0x4,%eax
80106d06:	75 10                	jne    80106d18 <trap+0x2ce>
80106d08:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0b:	8b 40 30             	mov    0x30(%eax),%eax
80106d0e:	83 f8 20             	cmp    $0x20,%eax
80106d11:	75 05                	jne    80106d18 <trap+0x2ce>
    yield();
80106d13:	e8 ec de ff ff       	call   80104c04 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106d18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d1e:	85 c0                	test   %eax,%eax
80106d20:	74 27                	je     80106d49 <trap+0x2ff>
80106d22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d28:	8b 40 24             	mov    0x24(%eax),%eax
80106d2b:	85 c0                	test   %eax,%eax
80106d2d:	74 1a                	je     80106d49 <trap+0x2ff>
80106d2f:	8b 45 08             	mov    0x8(%ebp),%eax
80106d32:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106d36:	0f b7 c0             	movzwl %ax,%eax
80106d39:	83 e0 03             	and    $0x3,%eax
80106d3c:	83 f8 03             	cmp    $0x3,%eax
80106d3f:	75 08                	jne    80106d49 <trap+0x2ff>
    exit();
80106d41:	e8 f8 da ff ff       	call   8010483e <exit>
80106d46:	eb 01                	jmp    80106d49 <trap+0x2ff>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106d48:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d4c:	5b                   	pop    %ebx
80106d4d:	5e                   	pop    %esi
80106d4e:	5f                   	pop    %edi
80106d4f:	5d                   	pop    %ebp
80106d50:	c3                   	ret    

80106d51 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106d51:	55                   	push   %ebp
80106d52:	89 e5                	mov    %esp,%ebp
80106d54:	83 ec 14             	sub    $0x14,%esp
80106d57:	8b 45 08             	mov    0x8(%ebp),%eax
80106d5a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106d5e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106d62:	89 c2                	mov    %eax,%edx
80106d64:	ec                   	in     (%dx),%al
80106d65:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106d68:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106d6c:	c9                   	leave  
80106d6d:	c3                   	ret    

80106d6e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106d6e:	55                   	push   %ebp
80106d6f:	89 e5                	mov    %esp,%ebp
80106d71:	83 ec 08             	sub    $0x8,%esp
80106d74:	8b 55 08             	mov    0x8(%ebp),%edx
80106d77:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d7a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106d7e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d81:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106d85:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106d89:	ee                   	out    %al,(%dx)
}
80106d8a:	90                   	nop
80106d8b:	c9                   	leave  
80106d8c:	c3                   	ret    

80106d8d <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106d8d:	55                   	push   %ebp
80106d8e:	89 e5                	mov    %esp,%ebp
80106d90:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106d93:	6a 00                	push   $0x0
80106d95:	68 fa 03 00 00       	push   $0x3fa
80106d9a:	e8 cf ff ff ff       	call   80106d6e <outb>
80106d9f:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106da2:	68 80 00 00 00       	push   $0x80
80106da7:	68 fb 03 00 00       	push   $0x3fb
80106dac:	e8 bd ff ff ff       	call   80106d6e <outb>
80106db1:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106db4:	6a 0c                	push   $0xc
80106db6:	68 f8 03 00 00       	push   $0x3f8
80106dbb:	e8 ae ff ff ff       	call   80106d6e <outb>
80106dc0:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106dc3:	6a 00                	push   $0x0
80106dc5:	68 f9 03 00 00       	push   $0x3f9
80106dca:	e8 9f ff ff ff       	call   80106d6e <outb>
80106dcf:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106dd2:	6a 03                	push   $0x3
80106dd4:	68 fb 03 00 00       	push   $0x3fb
80106dd9:	e8 90 ff ff ff       	call   80106d6e <outb>
80106dde:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106de1:	6a 00                	push   $0x0
80106de3:	68 fc 03 00 00       	push   $0x3fc
80106de8:	e8 81 ff ff ff       	call   80106d6e <outb>
80106ded:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106df0:	6a 01                	push   $0x1
80106df2:	68 f9 03 00 00       	push   $0x3f9
80106df7:	e8 72 ff ff ff       	call   80106d6e <outb>
80106dfc:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106dff:	68 fd 03 00 00       	push   $0x3fd
80106e04:	e8 48 ff ff ff       	call   80106d51 <inb>
80106e09:	83 c4 04             	add    $0x4,%esp
80106e0c:	3c ff                	cmp    $0xff,%al
80106e0e:	74 6e                	je     80106e7e <uartinit+0xf1>
    return;
  uart = 1;
80106e10:	c7 05 6c b6 10 80 01 	movl   $0x1,0x8010b66c
80106e17:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106e1a:	68 fa 03 00 00       	push   $0x3fa
80106e1f:	e8 2d ff ff ff       	call   80106d51 <inb>
80106e24:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106e27:	68 f8 03 00 00       	push   $0x3f8
80106e2c:	e8 20 ff ff ff       	call   80106d51 <inb>
80106e31:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106e34:	83 ec 0c             	sub    $0xc,%esp
80106e37:	6a 04                	push   $0x4
80106e39:	e8 39 d0 ff ff       	call   80103e77 <picenable>
80106e3e:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106e41:	83 ec 08             	sub    $0x8,%esp
80106e44:	6a 00                	push   $0x0
80106e46:	6a 04                	push   $0x4
80106e48:	e8 ec bb ff ff       	call   80102a39 <ioapicenable>
80106e4d:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106e50:	c7 45 f4 78 8e 10 80 	movl   $0x80108e78,-0xc(%ebp)
80106e57:	eb 19                	jmp    80106e72 <uartinit+0xe5>
    uartputc(*p);
80106e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e5c:	0f b6 00             	movzbl (%eax),%eax
80106e5f:	0f be c0             	movsbl %al,%eax
80106e62:	83 ec 0c             	sub    $0xc,%esp
80106e65:	50                   	push   %eax
80106e66:	e8 16 00 00 00       	call   80106e81 <uartputc>
80106e6b:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106e6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e75:	0f b6 00             	movzbl (%eax),%eax
80106e78:	84 c0                	test   %al,%al
80106e7a:	75 dd                	jne    80106e59 <uartinit+0xcc>
80106e7c:	eb 01                	jmp    80106e7f <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106e7e:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106e7f:	c9                   	leave  
80106e80:	c3                   	ret    

80106e81 <uartputc>:

void
uartputc(int c)
{
80106e81:	55                   	push   %ebp
80106e82:	89 e5                	mov    %esp,%ebp
80106e84:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106e87:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106e8c:	85 c0                	test   %eax,%eax
80106e8e:	74 53                	je     80106ee3 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106e90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106e97:	eb 11                	jmp    80106eaa <uartputc+0x29>
    microdelay(10);
80106e99:	83 ec 0c             	sub    $0xc,%esp
80106e9c:	6a 0a                	push   $0xa
80106e9e:	e8 fc c0 ff ff       	call   80102f9f <microdelay>
80106ea3:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ea6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106eaa:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106eae:	7f 1a                	jg     80106eca <uartputc+0x49>
80106eb0:	83 ec 0c             	sub    $0xc,%esp
80106eb3:	68 fd 03 00 00       	push   $0x3fd
80106eb8:	e8 94 fe ff ff       	call   80106d51 <inb>
80106ebd:	83 c4 10             	add    $0x10,%esp
80106ec0:	0f b6 c0             	movzbl %al,%eax
80106ec3:	83 e0 20             	and    $0x20,%eax
80106ec6:	85 c0                	test   %eax,%eax
80106ec8:	74 cf                	je     80106e99 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106eca:	8b 45 08             	mov    0x8(%ebp),%eax
80106ecd:	0f b6 c0             	movzbl %al,%eax
80106ed0:	83 ec 08             	sub    $0x8,%esp
80106ed3:	50                   	push   %eax
80106ed4:	68 f8 03 00 00       	push   $0x3f8
80106ed9:	e8 90 fe ff ff       	call   80106d6e <outb>
80106ede:	83 c4 10             	add    $0x10,%esp
80106ee1:	eb 01                	jmp    80106ee4 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106ee3:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106ee4:	c9                   	leave  
80106ee5:	c3                   	ret    

80106ee6 <uartgetc>:

static int
uartgetc(void)
{
80106ee6:	55                   	push   %ebp
80106ee7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106ee9:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106eee:	85 c0                	test   %eax,%eax
80106ef0:	75 07                	jne    80106ef9 <uartgetc+0x13>
    return -1;
80106ef2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ef7:	eb 2e                	jmp    80106f27 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106ef9:	68 fd 03 00 00       	push   $0x3fd
80106efe:	e8 4e fe ff ff       	call   80106d51 <inb>
80106f03:	83 c4 04             	add    $0x4,%esp
80106f06:	0f b6 c0             	movzbl %al,%eax
80106f09:	83 e0 01             	and    $0x1,%eax
80106f0c:	85 c0                	test   %eax,%eax
80106f0e:	75 07                	jne    80106f17 <uartgetc+0x31>
    return -1;
80106f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f15:	eb 10                	jmp    80106f27 <uartgetc+0x41>
  return inb(COM1+0);
80106f17:	68 f8 03 00 00       	push   $0x3f8
80106f1c:	e8 30 fe ff ff       	call   80106d51 <inb>
80106f21:	83 c4 04             	add    $0x4,%esp
80106f24:	0f b6 c0             	movzbl %al,%eax
}
80106f27:	c9                   	leave  
80106f28:	c3                   	ret    

80106f29 <uartintr>:

void
uartintr(void)
{
80106f29:	55                   	push   %ebp
80106f2a:	89 e5                	mov    %esp,%ebp
80106f2c:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106f2f:	83 ec 0c             	sub    $0xc,%esp
80106f32:	68 e6 6e 10 80       	push   $0x80106ee6
80106f37:	e8 a1 98 ff ff       	call   801007dd <consoleintr>
80106f3c:	83 c4 10             	add    $0x10,%esp
}
80106f3f:	90                   	nop
80106f40:	c9                   	leave  
80106f41:	c3                   	ret    

80106f42 <vector0>:
80106f42:	6a 00                	push   $0x0
80106f44:	6a 00                	push   $0x0
80106f46:	e9 0b f9 ff ff       	jmp    80106856 <alltraps>

80106f4b <vector1>:
80106f4b:	6a 00                	push   $0x0
80106f4d:	6a 01                	push   $0x1
80106f4f:	e9 02 f9 ff ff       	jmp    80106856 <alltraps>

80106f54 <vector2>:
80106f54:	6a 00                	push   $0x0
80106f56:	6a 02                	push   $0x2
80106f58:	e9 f9 f8 ff ff       	jmp    80106856 <alltraps>

80106f5d <vector3>:
80106f5d:	6a 00                	push   $0x0
80106f5f:	6a 03                	push   $0x3
80106f61:	e9 f0 f8 ff ff       	jmp    80106856 <alltraps>

80106f66 <vector4>:
80106f66:	6a 00                	push   $0x0
80106f68:	6a 04                	push   $0x4
80106f6a:	e9 e7 f8 ff ff       	jmp    80106856 <alltraps>

80106f6f <vector5>:
80106f6f:	6a 00                	push   $0x0
80106f71:	6a 05                	push   $0x5
80106f73:	e9 de f8 ff ff       	jmp    80106856 <alltraps>

80106f78 <vector6>:
80106f78:	6a 00                	push   $0x0
80106f7a:	6a 06                	push   $0x6
80106f7c:	e9 d5 f8 ff ff       	jmp    80106856 <alltraps>

80106f81 <vector7>:
80106f81:	6a 00                	push   $0x0
80106f83:	6a 07                	push   $0x7
80106f85:	e9 cc f8 ff ff       	jmp    80106856 <alltraps>

80106f8a <vector8>:
80106f8a:	6a 08                	push   $0x8
80106f8c:	e9 c5 f8 ff ff       	jmp    80106856 <alltraps>

80106f91 <vector9>:
80106f91:	6a 00                	push   $0x0
80106f93:	6a 09                	push   $0x9
80106f95:	e9 bc f8 ff ff       	jmp    80106856 <alltraps>

80106f9a <vector10>:
80106f9a:	6a 0a                	push   $0xa
80106f9c:	e9 b5 f8 ff ff       	jmp    80106856 <alltraps>

80106fa1 <vector11>:
80106fa1:	6a 0b                	push   $0xb
80106fa3:	e9 ae f8 ff ff       	jmp    80106856 <alltraps>

80106fa8 <vector12>:
80106fa8:	6a 0c                	push   $0xc
80106faa:	e9 a7 f8 ff ff       	jmp    80106856 <alltraps>

80106faf <vector13>:
80106faf:	6a 0d                	push   $0xd
80106fb1:	e9 a0 f8 ff ff       	jmp    80106856 <alltraps>

80106fb6 <vector14>:
80106fb6:	6a 0e                	push   $0xe
80106fb8:	e9 99 f8 ff ff       	jmp    80106856 <alltraps>

80106fbd <vector15>:
80106fbd:	6a 00                	push   $0x0
80106fbf:	6a 0f                	push   $0xf
80106fc1:	e9 90 f8 ff ff       	jmp    80106856 <alltraps>

80106fc6 <vector16>:
80106fc6:	6a 00                	push   $0x0
80106fc8:	6a 10                	push   $0x10
80106fca:	e9 87 f8 ff ff       	jmp    80106856 <alltraps>

80106fcf <vector17>:
80106fcf:	6a 11                	push   $0x11
80106fd1:	e9 80 f8 ff ff       	jmp    80106856 <alltraps>

80106fd6 <vector18>:
80106fd6:	6a 00                	push   $0x0
80106fd8:	6a 12                	push   $0x12
80106fda:	e9 77 f8 ff ff       	jmp    80106856 <alltraps>

80106fdf <vector19>:
80106fdf:	6a 00                	push   $0x0
80106fe1:	6a 13                	push   $0x13
80106fe3:	e9 6e f8 ff ff       	jmp    80106856 <alltraps>

80106fe8 <vector20>:
80106fe8:	6a 00                	push   $0x0
80106fea:	6a 14                	push   $0x14
80106fec:	e9 65 f8 ff ff       	jmp    80106856 <alltraps>

80106ff1 <vector21>:
80106ff1:	6a 00                	push   $0x0
80106ff3:	6a 15                	push   $0x15
80106ff5:	e9 5c f8 ff ff       	jmp    80106856 <alltraps>

80106ffa <vector22>:
80106ffa:	6a 00                	push   $0x0
80106ffc:	6a 16                	push   $0x16
80106ffe:	e9 53 f8 ff ff       	jmp    80106856 <alltraps>

80107003 <vector23>:
80107003:	6a 00                	push   $0x0
80107005:	6a 17                	push   $0x17
80107007:	e9 4a f8 ff ff       	jmp    80106856 <alltraps>

8010700c <vector24>:
8010700c:	6a 00                	push   $0x0
8010700e:	6a 18                	push   $0x18
80107010:	e9 41 f8 ff ff       	jmp    80106856 <alltraps>

80107015 <vector25>:
80107015:	6a 00                	push   $0x0
80107017:	6a 19                	push   $0x19
80107019:	e9 38 f8 ff ff       	jmp    80106856 <alltraps>

8010701e <vector26>:
8010701e:	6a 00                	push   $0x0
80107020:	6a 1a                	push   $0x1a
80107022:	e9 2f f8 ff ff       	jmp    80106856 <alltraps>

80107027 <vector27>:
80107027:	6a 00                	push   $0x0
80107029:	6a 1b                	push   $0x1b
8010702b:	e9 26 f8 ff ff       	jmp    80106856 <alltraps>

80107030 <vector28>:
80107030:	6a 00                	push   $0x0
80107032:	6a 1c                	push   $0x1c
80107034:	e9 1d f8 ff ff       	jmp    80106856 <alltraps>

80107039 <vector29>:
80107039:	6a 00                	push   $0x0
8010703b:	6a 1d                	push   $0x1d
8010703d:	e9 14 f8 ff ff       	jmp    80106856 <alltraps>

80107042 <vector30>:
80107042:	6a 00                	push   $0x0
80107044:	6a 1e                	push   $0x1e
80107046:	e9 0b f8 ff ff       	jmp    80106856 <alltraps>

8010704b <vector31>:
8010704b:	6a 00                	push   $0x0
8010704d:	6a 1f                	push   $0x1f
8010704f:	e9 02 f8 ff ff       	jmp    80106856 <alltraps>

80107054 <vector32>:
80107054:	6a 00                	push   $0x0
80107056:	6a 20                	push   $0x20
80107058:	e9 f9 f7 ff ff       	jmp    80106856 <alltraps>

8010705d <vector33>:
8010705d:	6a 00                	push   $0x0
8010705f:	6a 21                	push   $0x21
80107061:	e9 f0 f7 ff ff       	jmp    80106856 <alltraps>

80107066 <vector34>:
80107066:	6a 00                	push   $0x0
80107068:	6a 22                	push   $0x22
8010706a:	e9 e7 f7 ff ff       	jmp    80106856 <alltraps>

8010706f <vector35>:
8010706f:	6a 00                	push   $0x0
80107071:	6a 23                	push   $0x23
80107073:	e9 de f7 ff ff       	jmp    80106856 <alltraps>

80107078 <vector36>:
80107078:	6a 00                	push   $0x0
8010707a:	6a 24                	push   $0x24
8010707c:	e9 d5 f7 ff ff       	jmp    80106856 <alltraps>

80107081 <vector37>:
80107081:	6a 00                	push   $0x0
80107083:	6a 25                	push   $0x25
80107085:	e9 cc f7 ff ff       	jmp    80106856 <alltraps>

8010708a <vector38>:
8010708a:	6a 00                	push   $0x0
8010708c:	6a 26                	push   $0x26
8010708e:	e9 c3 f7 ff ff       	jmp    80106856 <alltraps>

80107093 <vector39>:
80107093:	6a 00                	push   $0x0
80107095:	6a 27                	push   $0x27
80107097:	e9 ba f7 ff ff       	jmp    80106856 <alltraps>

8010709c <vector40>:
8010709c:	6a 00                	push   $0x0
8010709e:	6a 28                	push   $0x28
801070a0:	e9 b1 f7 ff ff       	jmp    80106856 <alltraps>

801070a5 <vector41>:
801070a5:	6a 00                	push   $0x0
801070a7:	6a 29                	push   $0x29
801070a9:	e9 a8 f7 ff ff       	jmp    80106856 <alltraps>

801070ae <vector42>:
801070ae:	6a 00                	push   $0x0
801070b0:	6a 2a                	push   $0x2a
801070b2:	e9 9f f7 ff ff       	jmp    80106856 <alltraps>

801070b7 <vector43>:
801070b7:	6a 00                	push   $0x0
801070b9:	6a 2b                	push   $0x2b
801070bb:	e9 96 f7 ff ff       	jmp    80106856 <alltraps>

801070c0 <vector44>:
801070c0:	6a 00                	push   $0x0
801070c2:	6a 2c                	push   $0x2c
801070c4:	e9 8d f7 ff ff       	jmp    80106856 <alltraps>

801070c9 <vector45>:
801070c9:	6a 00                	push   $0x0
801070cb:	6a 2d                	push   $0x2d
801070cd:	e9 84 f7 ff ff       	jmp    80106856 <alltraps>

801070d2 <vector46>:
801070d2:	6a 00                	push   $0x0
801070d4:	6a 2e                	push   $0x2e
801070d6:	e9 7b f7 ff ff       	jmp    80106856 <alltraps>

801070db <vector47>:
801070db:	6a 00                	push   $0x0
801070dd:	6a 2f                	push   $0x2f
801070df:	e9 72 f7 ff ff       	jmp    80106856 <alltraps>

801070e4 <vector48>:
801070e4:	6a 00                	push   $0x0
801070e6:	6a 30                	push   $0x30
801070e8:	e9 69 f7 ff ff       	jmp    80106856 <alltraps>

801070ed <vector49>:
801070ed:	6a 00                	push   $0x0
801070ef:	6a 31                	push   $0x31
801070f1:	e9 60 f7 ff ff       	jmp    80106856 <alltraps>

801070f6 <vector50>:
801070f6:	6a 00                	push   $0x0
801070f8:	6a 32                	push   $0x32
801070fa:	e9 57 f7 ff ff       	jmp    80106856 <alltraps>

801070ff <vector51>:
801070ff:	6a 00                	push   $0x0
80107101:	6a 33                	push   $0x33
80107103:	e9 4e f7 ff ff       	jmp    80106856 <alltraps>

80107108 <vector52>:
80107108:	6a 00                	push   $0x0
8010710a:	6a 34                	push   $0x34
8010710c:	e9 45 f7 ff ff       	jmp    80106856 <alltraps>

80107111 <vector53>:
80107111:	6a 00                	push   $0x0
80107113:	6a 35                	push   $0x35
80107115:	e9 3c f7 ff ff       	jmp    80106856 <alltraps>

8010711a <vector54>:
8010711a:	6a 00                	push   $0x0
8010711c:	6a 36                	push   $0x36
8010711e:	e9 33 f7 ff ff       	jmp    80106856 <alltraps>

80107123 <vector55>:
80107123:	6a 00                	push   $0x0
80107125:	6a 37                	push   $0x37
80107127:	e9 2a f7 ff ff       	jmp    80106856 <alltraps>

8010712c <vector56>:
8010712c:	6a 00                	push   $0x0
8010712e:	6a 38                	push   $0x38
80107130:	e9 21 f7 ff ff       	jmp    80106856 <alltraps>

80107135 <vector57>:
80107135:	6a 00                	push   $0x0
80107137:	6a 39                	push   $0x39
80107139:	e9 18 f7 ff ff       	jmp    80106856 <alltraps>

8010713e <vector58>:
8010713e:	6a 00                	push   $0x0
80107140:	6a 3a                	push   $0x3a
80107142:	e9 0f f7 ff ff       	jmp    80106856 <alltraps>

80107147 <vector59>:
80107147:	6a 00                	push   $0x0
80107149:	6a 3b                	push   $0x3b
8010714b:	e9 06 f7 ff ff       	jmp    80106856 <alltraps>

80107150 <vector60>:
80107150:	6a 00                	push   $0x0
80107152:	6a 3c                	push   $0x3c
80107154:	e9 fd f6 ff ff       	jmp    80106856 <alltraps>

80107159 <vector61>:
80107159:	6a 00                	push   $0x0
8010715b:	6a 3d                	push   $0x3d
8010715d:	e9 f4 f6 ff ff       	jmp    80106856 <alltraps>

80107162 <vector62>:
80107162:	6a 00                	push   $0x0
80107164:	6a 3e                	push   $0x3e
80107166:	e9 eb f6 ff ff       	jmp    80106856 <alltraps>

8010716b <vector63>:
8010716b:	6a 00                	push   $0x0
8010716d:	6a 3f                	push   $0x3f
8010716f:	e9 e2 f6 ff ff       	jmp    80106856 <alltraps>

80107174 <vector64>:
80107174:	6a 00                	push   $0x0
80107176:	6a 40                	push   $0x40
80107178:	e9 d9 f6 ff ff       	jmp    80106856 <alltraps>

8010717d <vector65>:
8010717d:	6a 00                	push   $0x0
8010717f:	6a 41                	push   $0x41
80107181:	e9 d0 f6 ff ff       	jmp    80106856 <alltraps>

80107186 <vector66>:
80107186:	6a 00                	push   $0x0
80107188:	6a 42                	push   $0x42
8010718a:	e9 c7 f6 ff ff       	jmp    80106856 <alltraps>

8010718f <vector67>:
8010718f:	6a 00                	push   $0x0
80107191:	6a 43                	push   $0x43
80107193:	e9 be f6 ff ff       	jmp    80106856 <alltraps>

80107198 <vector68>:
80107198:	6a 00                	push   $0x0
8010719a:	6a 44                	push   $0x44
8010719c:	e9 b5 f6 ff ff       	jmp    80106856 <alltraps>

801071a1 <vector69>:
801071a1:	6a 00                	push   $0x0
801071a3:	6a 45                	push   $0x45
801071a5:	e9 ac f6 ff ff       	jmp    80106856 <alltraps>

801071aa <vector70>:
801071aa:	6a 00                	push   $0x0
801071ac:	6a 46                	push   $0x46
801071ae:	e9 a3 f6 ff ff       	jmp    80106856 <alltraps>

801071b3 <vector71>:
801071b3:	6a 00                	push   $0x0
801071b5:	6a 47                	push   $0x47
801071b7:	e9 9a f6 ff ff       	jmp    80106856 <alltraps>

801071bc <vector72>:
801071bc:	6a 00                	push   $0x0
801071be:	6a 48                	push   $0x48
801071c0:	e9 91 f6 ff ff       	jmp    80106856 <alltraps>

801071c5 <vector73>:
801071c5:	6a 00                	push   $0x0
801071c7:	6a 49                	push   $0x49
801071c9:	e9 88 f6 ff ff       	jmp    80106856 <alltraps>

801071ce <vector74>:
801071ce:	6a 00                	push   $0x0
801071d0:	6a 4a                	push   $0x4a
801071d2:	e9 7f f6 ff ff       	jmp    80106856 <alltraps>

801071d7 <vector75>:
801071d7:	6a 00                	push   $0x0
801071d9:	6a 4b                	push   $0x4b
801071db:	e9 76 f6 ff ff       	jmp    80106856 <alltraps>

801071e0 <vector76>:
801071e0:	6a 00                	push   $0x0
801071e2:	6a 4c                	push   $0x4c
801071e4:	e9 6d f6 ff ff       	jmp    80106856 <alltraps>

801071e9 <vector77>:
801071e9:	6a 00                	push   $0x0
801071eb:	6a 4d                	push   $0x4d
801071ed:	e9 64 f6 ff ff       	jmp    80106856 <alltraps>

801071f2 <vector78>:
801071f2:	6a 00                	push   $0x0
801071f4:	6a 4e                	push   $0x4e
801071f6:	e9 5b f6 ff ff       	jmp    80106856 <alltraps>

801071fb <vector79>:
801071fb:	6a 00                	push   $0x0
801071fd:	6a 4f                	push   $0x4f
801071ff:	e9 52 f6 ff ff       	jmp    80106856 <alltraps>

80107204 <vector80>:
80107204:	6a 00                	push   $0x0
80107206:	6a 50                	push   $0x50
80107208:	e9 49 f6 ff ff       	jmp    80106856 <alltraps>

8010720d <vector81>:
8010720d:	6a 00                	push   $0x0
8010720f:	6a 51                	push   $0x51
80107211:	e9 40 f6 ff ff       	jmp    80106856 <alltraps>

80107216 <vector82>:
80107216:	6a 00                	push   $0x0
80107218:	6a 52                	push   $0x52
8010721a:	e9 37 f6 ff ff       	jmp    80106856 <alltraps>

8010721f <vector83>:
8010721f:	6a 00                	push   $0x0
80107221:	6a 53                	push   $0x53
80107223:	e9 2e f6 ff ff       	jmp    80106856 <alltraps>

80107228 <vector84>:
80107228:	6a 00                	push   $0x0
8010722a:	6a 54                	push   $0x54
8010722c:	e9 25 f6 ff ff       	jmp    80106856 <alltraps>

80107231 <vector85>:
80107231:	6a 00                	push   $0x0
80107233:	6a 55                	push   $0x55
80107235:	e9 1c f6 ff ff       	jmp    80106856 <alltraps>

8010723a <vector86>:
8010723a:	6a 00                	push   $0x0
8010723c:	6a 56                	push   $0x56
8010723e:	e9 13 f6 ff ff       	jmp    80106856 <alltraps>

80107243 <vector87>:
80107243:	6a 00                	push   $0x0
80107245:	6a 57                	push   $0x57
80107247:	e9 0a f6 ff ff       	jmp    80106856 <alltraps>

8010724c <vector88>:
8010724c:	6a 00                	push   $0x0
8010724e:	6a 58                	push   $0x58
80107250:	e9 01 f6 ff ff       	jmp    80106856 <alltraps>

80107255 <vector89>:
80107255:	6a 00                	push   $0x0
80107257:	6a 59                	push   $0x59
80107259:	e9 f8 f5 ff ff       	jmp    80106856 <alltraps>

8010725e <vector90>:
8010725e:	6a 00                	push   $0x0
80107260:	6a 5a                	push   $0x5a
80107262:	e9 ef f5 ff ff       	jmp    80106856 <alltraps>

80107267 <vector91>:
80107267:	6a 00                	push   $0x0
80107269:	6a 5b                	push   $0x5b
8010726b:	e9 e6 f5 ff ff       	jmp    80106856 <alltraps>

80107270 <vector92>:
80107270:	6a 00                	push   $0x0
80107272:	6a 5c                	push   $0x5c
80107274:	e9 dd f5 ff ff       	jmp    80106856 <alltraps>

80107279 <vector93>:
80107279:	6a 00                	push   $0x0
8010727b:	6a 5d                	push   $0x5d
8010727d:	e9 d4 f5 ff ff       	jmp    80106856 <alltraps>

80107282 <vector94>:
80107282:	6a 00                	push   $0x0
80107284:	6a 5e                	push   $0x5e
80107286:	e9 cb f5 ff ff       	jmp    80106856 <alltraps>

8010728b <vector95>:
8010728b:	6a 00                	push   $0x0
8010728d:	6a 5f                	push   $0x5f
8010728f:	e9 c2 f5 ff ff       	jmp    80106856 <alltraps>

80107294 <vector96>:
80107294:	6a 00                	push   $0x0
80107296:	6a 60                	push   $0x60
80107298:	e9 b9 f5 ff ff       	jmp    80106856 <alltraps>

8010729d <vector97>:
8010729d:	6a 00                	push   $0x0
8010729f:	6a 61                	push   $0x61
801072a1:	e9 b0 f5 ff ff       	jmp    80106856 <alltraps>

801072a6 <vector98>:
801072a6:	6a 00                	push   $0x0
801072a8:	6a 62                	push   $0x62
801072aa:	e9 a7 f5 ff ff       	jmp    80106856 <alltraps>

801072af <vector99>:
801072af:	6a 00                	push   $0x0
801072b1:	6a 63                	push   $0x63
801072b3:	e9 9e f5 ff ff       	jmp    80106856 <alltraps>

801072b8 <vector100>:
801072b8:	6a 00                	push   $0x0
801072ba:	6a 64                	push   $0x64
801072bc:	e9 95 f5 ff ff       	jmp    80106856 <alltraps>

801072c1 <vector101>:
801072c1:	6a 00                	push   $0x0
801072c3:	6a 65                	push   $0x65
801072c5:	e9 8c f5 ff ff       	jmp    80106856 <alltraps>

801072ca <vector102>:
801072ca:	6a 00                	push   $0x0
801072cc:	6a 66                	push   $0x66
801072ce:	e9 83 f5 ff ff       	jmp    80106856 <alltraps>

801072d3 <vector103>:
801072d3:	6a 00                	push   $0x0
801072d5:	6a 67                	push   $0x67
801072d7:	e9 7a f5 ff ff       	jmp    80106856 <alltraps>

801072dc <vector104>:
801072dc:	6a 00                	push   $0x0
801072de:	6a 68                	push   $0x68
801072e0:	e9 71 f5 ff ff       	jmp    80106856 <alltraps>

801072e5 <vector105>:
801072e5:	6a 00                	push   $0x0
801072e7:	6a 69                	push   $0x69
801072e9:	e9 68 f5 ff ff       	jmp    80106856 <alltraps>

801072ee <vector106>:
801072ee:	6a 00                	push   $0x0
801072f0:	6a 6a                	push   $0x6a
801072f2:	e9 5f f5 ff ff       	jmp    80106856 <alltraps>

801072f7 <vector107>:
801072f7:	6a 00                	push   $0x0
801072f9:	6a 6b                	push   $0x6b
801072fb:	e9 56 f5 ff ff       	jmp    80106856 <alltraps>

80107300 <vector108>:
80107300:	6a 00                	push   $0x0
80107302:	6a 6c                	push   $0x6c
80107304:	e9 4d f5 ff ff       	jmp    80106856 <alltraps>

80107309 <vector109>:
80107309:	6a 00                	push   $0x0
8010730b:	6a 6d                	push   $0x6d
8010730d:	e9 44 f5 ff ff       	jmp    80106856 <alltraps>

80107312 <vector110>:
80107312:	6a 00                	push   $0x0
80107314:	6a 6e                	push   $0x6e
80107316:	e9 3b f5 ff ff       	jmp    80106856 <alltraps>

8010731b <vector111>:
8010731b:	6a 00                	push   $0x0
8010731d:	6a 6f                	push   $0x6f
8010731f:	e9 32 f5 ff ff       	jmp    80106856 <alltraps>

80107324 <vector112>:
80107324:	6a 00                	push   $0x0
80107326:	6a 70                	push   $0x70
80107328:	e9 29 f5 ff ff       	jmp    80106856 <alltraps>

8010732d <vector113>:
8010732d:	6a 00                	push   $0x0
8010732f:	6a 71                	push   $0x71
80107331:	e9 20 f5 ff ff       	jmp    80106856 <alltraps>

80107336 <vector114>:
80107336:	6a 00                	push   $0x0
80107338:	6a 72                	push   $0x72
8010733a:	e9 17 f5 ff ff       	jmp    80106856 <alltraps>

8010733f <vector115>:
8010733f:	6a 00                	push   $0x0
80107341:	6a 73                	push   $0x73
80107343:	e9 0e f5 ff ff       	jmp    80106856 <alltraps>

80107348 <vector116>:
80107348:	6a 00                	push   $0x0
8010734a:	6a 74                	push   $0x74
8010734c:	e9 05 f5 ff ff       	jmp    80106856 <alltraps>

80107351 <vector117>:
80107351:	6a 00                	push   $0x0
80107353:	6a 75                	push   $0x75
80107355:	e9 fc f4 ff ff       	jmp    80106856 <alltraps>

8010735a <vector118>:
8010735a:	6a 00                	push   $0x0
8010735c:	6a 76                	push   $0x76
8010735e:	e9 f3 f4 ff ff       	jmp    80106856 <alltraps>

80107363 <vector119>:
80107363:	6a 00                	push   $0x0
80107365:	6a 77                	push   $0x77
80107367:	e9 ea f4 ff ff       	jmp    80106856 <alltraps>

8010736c <vector120>:
8010736c:	6a 00                	push   $0x0
8010736e:	6a 78                	push   $0x78
80107370:	e9 e1 f4 ff ff       	jmp    80106856 <alltraps>

80107375 <vector121>:
80107375:	6a 00                	push   $0x0
80107377:	6a 79                	push   $0x79
80107379:	e9 d8 f4 ff ff       	jmp    80106856 <alltraps>

8010737e <vector122>:
8010737e:	6a 00                	push   $0x0
80107380:	6a 7a                	push   $0x7a
80107382:	e9 cf f4 ff ff       	jmp    80106856 <alltraps>

80107387 <vector123>:
80107387:	6a 00                	push   $0x0
80107389:	6a 7b                	push   $0x7b
8010738b:	e9 c6 f4 ff ff       	jmp    80106856 <alltraps>

80107390 <vector124>:
80107390:	6a 00                	push   $0x0
80107392:	6a 7c                	push   $0x7c
80107394:	e9 bd f4 ff ff       	jmp    80106856 <alltraps>

80107399 <vector125>:
80107399:	6a 00                	push   $0x0
8010739b:	6a 7d                	push   $0x7d
8010739d:	e9 b4 f4 ff ff       	jmp    80106856 <alltraps>

801073a2 <vector126>:
801073a2:	6a 00                	push   $0x0
801073a4:	6a 7e                	push   $0x7e
801073a6:	e9 ab f4 ff ff       	jmp    80106856 <alltraps>

801073ab <vector127>:
801073ab:	6a 00                	push   $0x0
801073ad:	6a 7f                	push   $0x7f
801073af:	e9 a2 f4 ff ff       	jmp    80106856 <alltraps>

801073b4 <vector128>:
801073b4:	6a 00                	push   $0x0
801073b6:	68 80 00 00 00       	push   $0x80
801073bb:	e9 96 f4 ff ff       	jmp    80106856 <alltraps>

801073c0 <vector129>:
801073c0:	6a 00                	push   $0x0
801073c2:	68 81 00 00 00       	push   $0x81
801073c7:	e9 8a f4 ff ff       	jmp    80106856 <alltraps>

801073cc <vector130>:
801073cc:	6a 00                	push   $0x0
801073ce:	68 82 00 00 00       	push   $0x82
801073d3:	e9 7e f4 ff ff       	jmp    80106856 <alltraps>

801073d8 <vector131>:
801073d8:	6a 00                	push   $0x0
801073da:	68 83 00 00 00       	push   $0x83
801073df:	e9 72 f4 ff ff       	jmp    80106856 <alltraps>

801073e4 <vector132>:
801073e4:	6a 00                	push   $0x0
801073e6:	68 84 00 00 00       	push   $0x84
801073eb:	e9 66 f4 ff ff       	jmp    80106856 <alltraps>

801073f0 <vector133>:
801073f0:	6a 00                	push   $0x0
801073f2:	68 85 00 00 00       	push   $0x85
801073f7:	e9 5a f4 ff ff       	jmp    80106856 <alltraps>

801073fc <vector134>:
801073fc:	6a 00                	push   $0x0
801073fe:	68 86 00 00 00       	push   $0x86
80107403:	e9 4e f4 ff ff       	jmp    80106856 <alltraps>

80107408 <vector135>:
80107408:	6a 00                	push   $0x0
8010740a:	68 87 00 00 00       	push   $0x87
8010740f:	e9 42 f4 ff ff       	jmp    80106856 <alltraps>

80107414 <vector136>:
80107414:	6a 00                	push   $0x0
80107416:	68 88 00 00 00       	push   $0x88
8010741b:	e9 36 f4 ff ff       	jmp    80106856 <alltraps>

80107420 <vector137>:
80107420:	6a 00                	push   $0x0
80107422:	68 89 00 00 00       	push   $0x89
80107427:	e9 2a f4 ff ff       	jmp    80106856 <alltraps>

8010742c <vector138>:
8010742c:	6a 00                	push   $0x0
8010742e:	68 8a 00 00 00       	push   $0x8a
80107433:	e9 1e f4 ff ff       	jmp    80106856 <alltraps>

80107438 <vector139>:
80107438:	6a 00                	push   $0x0
8010743a:	68 8b 00 00 00       	push   $0x8b
8010743f:	e9 12 f4 ff ff       	jmp    80106856 <alltraps>

80107444 <vector140>:
80107444:	6a 00                	push   $0x0
80107446:	68 8c 00 00 00       	push   $0x8c
8010744b:	e9 06 f4 ff ff       	jmp    80106856 <alltraps>

80107450 <vector141>:
80107450:	6a 00                	push   $0x0
80107452:	68 8d 00 00 00       	push   $0x8d
80107457:	e9 fa f3 ff ff       	jmp    80106856 <alltraps>

8010745c <vector142>:
8010745c:	6a 00                	push   $0x0
8010745e:	68 8e 00 00 00       	push   $0x8e
80107463:	e9 ee f3 ff ff       	jmp    80106856 <alltraps>

80107468 <vector143>:
80107468:	6a 00                	push   $0x0
8010746a:	68 8f 00 00 00       	push   $0x8f
8010746f:	e9 e2 f3 ff ff       	jmp    80106856 <alltraps>

80107474 <vector144>:
80107474:	6a 00                	push   $0x0
80107476:	68 90 00 00 00       	push   $0x90
8010747b:	e9 d6 f3 ff ff       	jmp    80106856 <alltraps>

80107480 <vector145>:
80107480:	6a 00                	push   $0x0
80107482:	68 91 00 00 00       	push   $0x91
80107487:	e9 ca f3 ff ff       	jmp    80106856 <alltraps>

8010748c <vector146>:
8010748c:	6a 00                	push   $0x0
8010748e:	68 92 00 00 00       	push   $0x92
80107493:	e9 be f3 ff ff       	jmp    80106856 <alltraps>

80107498 <vector147>:
80107498:	6a 00                	push   $0x0
8010749a:	68 93 00 00 00       	push   $0x93
8010749f:	e9 b2 f3 ff ff       	jmp    80106856 <alltraps>

801074a4 <vector148>:
801074a4:	6a 00                	push   $0x0
801074a6:	68 94 00 00 00       	push   $0x94
801074ab:	e9 a6 f3 ff ff       	jmp    80106856 <alltraps>

801074b0 <vector149>:
801074b0:	6a 00                	push   $0x0
801074b2:	68 95 00 00 00       	push   $0x95
801074b7:	e9 9a f3 ff ff       	jmp    80106856 <alltraps>

801074bc <vector150>:
801074bc:	6a 00                	push   $0x0
801074be:	68 96 00 00 00       	push   $0x96
801074c3:	e9 8e f3 ff ff       	jmp    80106856 <alltraps>

801074c8 <vector151>:
801074c8:	6a 00                	push   $0x0
801074ca:	68 97 00 00 00       	push   $0x97
801074cf:	e9 82 f3 ff ff       	jmp    80106856 <alltraps>

801074d4 <vector152>:
801074d4:	6a 00                	push   $0x0
801074d6:	68 98 00 00 00       	push   $0x98
801074db:	e9 76 f3 ff ff       	jmp    80106856 <alltraps>

801074e0 <vector153>:
801074e0:	6a 00                	push   $0x0
801074e2:	68 99 00 00 00       	push   $0x99
801074e7:	e9 6a f3 ff ff       	jmp    80106856 <alltraps>

801074ec <vector154>:
801074ec:	6a 00                	push   $0x0
801074ee:	68 9a 00 00 00       	push   $0x9a
801074f3:	e9 5e f3 ff ff       	jmp    80106856 <alltraps>

801074f8 <vector155>:
801074f8:	6a 00                	push   $0x0
801074fa:	68 9b 00 00 00       	push   $0x9b
801074ff:	e9 52 f3 ff ff       	jmp    80106856 <alltraps>

80107504 <vector156>:
80107504:	6a 00                	push   $0x0
80107506:	68 9c 00 00 00       	push   $0x9c
8010750b:	e9 46 f3 ff ff       	jmp    80106856 <alltraps>

80107510 <vector157>:
80107510:	6a 00                	push   $0x0
80107512:	68 9d 00 00 00       	push   $0x9d
80107517:	e9 3a f3 ff ff       	jmp    80106856 <alltraps>

8010751c <vector158>:
8010751c:	6a 00                	push   $0x0
8010751e:	68 9e 00 00 00       	push   $0x9e
80107523:	e9 2e f3 ff ff       	jmp    80106856 <alltraps>

80107528 <vector159>:
80107528:	6a 00                	push   $0x0
8010752a:	68 9f 00 00 00       	push   $0x9f
8010752f:	e9 22 f3 ff ff       	jmp    80106856 <alltraps>

80107534 <vector160>:
80107534:	6a 00                	push   $0x0
80107536:	68 a0 00 00 00       	push   $0xa0
8010753b:	e9 16 f3 ff ff       	jmp    80106856 <alltraps>

80107540 <vector161>:
80107540:	6a 00                	push   $0x0
80107542:	68 a1 00 00 00       	push   $0xa1
80107547:	e9 0a f3 ff ff       	jmp    80106856 <alltraps>

8010754c <vector162>:
8010754c:	6a 00                	push   $0x0
8010754e:	68 a2 00 00 00       	push   $0xa2
80107553:	e9 fe f2 ff ff       	jmp    80106856 <alltraps>

80107558 <vector163>:
80107558:	6a 00                	push   $0x0
8010755a:	68 a3 00 00 00       	push   $0xa3
8010755f:	e9 f2 f2 ff ff       	jmp    80106856 <alltraps>

80107564 <vector164>:
80107564:	6a 00                	push   $0x0
80107566:	68 a4 00 00 00       	push   $0xa4
8010756b:	e9 e6 f2 ff ff       	jmp    80106856 <alltraps>

80107570 <vector165>:
80107570:	6a 00                	push   $0x0
80107572:	68 a5 00 00 00       	push   $0xa5
80107577:	e9 da f2 ff ff       	jmp    80106856 <alltraps>

8010757c <vector166>:
8010757c:	6a 00                	push   $0x0
8010757e:	68 a6 00 00 00       	push   $0xa6
80107583:	e9 ce f2 ff ff       	jmp    80106856 <alltraps>

80107588 <vector167>:
80107588:	6a 00                	push   $0x0
8010758a:	68 a7 00 00 00       	push   $0xa7
8010758f:	e9 c2 f2 ff ff       	jmp    80106856 <alltraps>

80107594 <vector168>:
80107594:	6a 00                	push   $0x0
80107596:	68 a8 00 00 00       	push   $0xa8
8010759b:	e9 b6 f2 ff ff       	jmp    80106856 <alltraps>

801075a0 <vector169>:
801075a0:	6a 00                	push   $0x0
801075a2:	68 a9 00 00 00       	push   $0xa9
801075a7:	e9 aa f2 ff ff       	jmp    80106856 <alltraps>

801075ac <vector170>:
801075ac:	6a 00                	push   $0x0
801075ae:	68 aa 00 00 00       	push   $0xaa
801075b3:	e9 9e f2 ff ff       	jmp    80106856 <alltraps>

801075b8 <vector171>:
801075b8:	6a 00                	push   $0x0
801075ba:	68 ab 00 00 00       	push   $0xab
801075bf:	e9 92 f2 ff ff       	jmp    80106856 <alltraps>

801075c4 <vector172>:
801075c4:	6a 00                	push   $0x0
801075c6:	68 ac 00 00 00       	push   $0xac
801075cb:	e9 86 f2 ff ff       	jmp    80106856 <alltraps>

801075d0 <vector173>:
801075d0:	6a 00                	push   $0x0
801075d2:	68 ad 00 00 00       	push   $0xad
801075d7:	e9 7a f2 ff ff       	jmp    80106856 <alltraps>

801075dc <vector174>:
801075dc:	6a 00                	push   $0x0
801075de:	68 ae 00 00 00       	push   $0xae
801075e3:	e9 6e f2 ff ff       	jmp    80106856 <alltraps>

801075e8 <vector175>:
801075e8:	6a 00                	push   $0x0
801075ea:	68 af 00 00 00       	push   $0xaf
801075ef:	e9 62 f2 ff ff       	jmp    80106856 <alltraps>

801075f4 <vector176>:
801075f4:	6a 00                	push   $0x0
801075f6:	68 b0 00 00 00       	push   $0xb0
801075fb:	e9 56 f2 ff ff       	jmp    80106856 <alltraps>

80107600 <vector177>:
80107600:	6a 00                	push   $0x0
80107602:	68 b1 00 00 00       	push   $0xb1
80107607:	e9 4a f2 ff ff       	jmp    80106856 <alltraps>

8010760c <vector178>:
8010760c:	6a 00                	push   $0x0
8010760e:	68 b2 00 00 00       	push   $0xb2
80107613:	e9 3e f2 ff ff       	jmp    80106856 <alltraps>

80107618 <vector179>:
80107618:	6a 00                	push   $0x0
8010761a:	68 b3 00 00 00       	push   $0xb3
8010761f:	e9 32 f2 ff ff       	jmp    80106856 <alltraps>

80107624 <vector180>:
80107624:	6a 00                	push   $0x0
80107626:	68 b4 00 00 00       	push   $0xb4
8010762b:	e9 26 f2 ff ff       	jmp    80106856 <alltraps>

80107630 <vector181>:
80107630:	6a 00                	push   $0x0
80107632:	68 b5 00 00 00       	push   $0xb5
80107637:	e9 1a f2 ff ff       	jmp    80106856 <alltraps>

8010763c <vector182>:
8010763c:	6a 00                	push   $0x0
8010763e:	68 b6 00 00 00       	push   $0xb6
80107643:	e9 0e f2 ff ff       	jmp    80106856 <alltraps>

80107648 <vector183>:
80107648:	6a 00                	push   $0x0
8010764a:	68 b7 00 00 00       	push   $0xb7
8010764f:	e9 02 f2 ff ff       	jmp    80106856 <alltraps>

80107654 <vector184>:
80107654:	6a 00                	push   $0x0
80107656:	68 b8 00 00 00       	push   $0xb8
8010765b:	e9 f6 f1 ff ff       	jmp    80106856 <alltraps>

80107660 <vector185>:
80107660:	6a 00                	push   $0x0
80107662:	68 b9 00 00 00       	push   $0xb9
80107667:	e9 ea f1 ff ff       	jmp    80106856 <alltraps>

8010766c <vector186>:
8010766c:	6a 00                	push   $0x0
8010766e:	68 ba 00 00 00       	push   $0xba
80107673:	e9 de f1 ff ff       	jmp    80106856 <alltraps>

80107678 <vector187>:
80107678:	6a 00                	push   $0x0
8010767a:	68 bb 00 00 00       	push   $0xbb
8010767f:	e9 d2 f1 ff ff       	jmp    80106856 <alltraps>

80107684 <vector188>:
80107684:	6a 00                	push   $0x0
80107686:	68 bc 00 00 00       	push   $0xbc
8010768b:	e9 c6 f1 ff ff       	jmp    80106856 <alltraps>

80107690 <vector189>:
80107690:	6a 00                	push   $0x0
80107692:	68 bd 00 00 00       	push   $0xbd
80107697:	e9 ba f1 ff ff       	jmp    80106856 <alltraps>

8010769c <vector190>:
8010769c:	6a 00                	push   $0x0
8010769e:	68 be 00 00 00       	push   $0xbe
801076a3:	e9 ae f1 ff ff       	jmp    80106856 <alltraps>

801076a8 <vector191>:
801076a8:	6a 00                	push   $0x0
801076aa:	68 bf 00 00 00       	push   $0xbf
801076af:	e9 a2 f1 ff ff       	jmp    80106856 <alltraps>

801076b4 <vector192>:
801076b4:	6a 00                	push   $0x0
801076b6:	68 c0 00 00 00       	push   $0xc0
801076bb:	e9 96 f1 ff ff       	jmp    80106856 <alltraps>

801076c0 <vector193>:
801076c0:	6a 00                	push   $0x0
801076c2:	68 c1 00 00 00       	push   $0xc1
801076c7:	e9 8a f1 ff ff       	jmp    80106856 <alltraps>

801076cc <vector194>:
801076cc:	6a 00                	push   $0x0
801076ce:	68 c2 00 00 00       	push   $0xc2
801076d3:	e9 7e f1 ff ff       	jmp    80106856 <alltraps>

801076d8 <vector195>:
801076d8:	6a 00                	push   $0x0
801076da:	68 c3 00 00 00       	push   $0xc3
801076df:	e9 72 f1 ff ff       	jmp    80106856 <alltraps>

801076e4 <vector196>:
801076e4:	6a 00                	push   $0x0
801076e6:	68 c4 00 00 00       	push   $0xc4
801076eb:	e9 66 f1 ff ff       	jmp    80106856 <alltraps>

801076f0 <vector197>:
801076f0:	6a 00                	push   $0x0
801076f2:	68 c5 00 00 00       	push   $0xc5
801076f7:	e9 5a f1 ff ff       	jmp    80106856 <alltraps>

801076fc <vector198>:
801076fc:	6a 00                	push   $0x0
801076fe:	68 c6 00 00 00       	push   $0xc6
80107703:	e9 4e f1 ff ff       	jmp    80106856 <alltraps>

80107708 <vector199>:
80107708:	6a 00                	push   $0x0
8010770a:	68 c7 00 00 00       	push   $0xc7
8010770f:	e9 42 f1 ff ff       	jmp    80106856 <alltraps>

80107714 <vector200>:
80107714:	6a 00                	push   $0x0
80107716:	68 c8 00 00 00       	push   $0xc8
8010771b:	e9 36 f1 ff ff       	jmp    80106856 <alltraps>

80107720 <vector201>:
80107720:	6a 00                	push   $0x0
80107722:	68 c9 00 00 00       	push   $0xc9
80107727:	e9 2a f1 ff ff       	jmp    80106856 <alltraps>

8010772c <vector202>:
8010772c:	6a 00                	push   $0x0
8010772e:	68 ca 00 00 00       	push   $0xca
80107733:	e9 1e f1 ff ff       	jmp    80106856 <alltraps>

80107738 <vector203>:
80107738:	6a 00                	push   $0x0
8010773a:	68 cb 00 00 00       	push   $0xcb
8010773f:	e9 12 f1 ff ff       	jmp    80106856 <alltraps>

80107744 <vector204>:
80107744:	6a 00                	push   $0x0
80107746:	68 cc 00 00 00       	push   $0xcc
8010774b:	e9 06 f1 ff ff       	jmp    80106856 <alltraps>

80107750 <vector205>:
80107750:	6a 00                	push   $0x0
80107752:	68 cd 00 00 00       	push   $0xcd
80107757:	e9 fa f0 ff ff       	jmp    80106856 <alltraps>

8010775c <vector206>:
8010775c:	6a 00                	push   $0x0
8010775e:	68 ce 00 00 00       	push   $0xce
80107763:	e9 ee f0 ff ff       	jmp    80106856 <alltraps>

80107768 <vector207>:
80107768:	6a 00                	push   $0x0
8010776a:	68 cf 00 00 00       	push   $0xcf
8010776f:	e9 e2 f0 ff ff       	jmp    80106856 <alltraps>

80107774 <vector208>:
80107774:	6a 00                	push   $0x0
80107776:	68 d0 00 00 00       	push   $0xd0
8010777b:	e9 d6 f0 ff ff       	jmp    80106856 <alltraps>

80107780 <vector209>:
80107780:	6a 00                	push   $0x0
80107782:	68 d1 00 00 00       	push   $0xd1
80107787:	e9 ca f0 ff ff       	jmp    80106856 <alltraps>

8010778c <vector210>:
8010778c:	6a 00                	push   $0x0
8010778e:	68 d2 00 00 00       	push   $0xd2
80107793:	e9 be f0 ff ff       	jmp    80106856 <alltraps>

80107798 <vector211>:
80107798:	6a 00                	push   $0x0
8010779a:	68 d3 00 00 00       	push   $0xd3
8010779f:	e9 b2 f0 ff ff       	jmp    80106856 <alltraps>

801077a4 <vector212>:
801077a4:	6a 00                	push   $0x0
801077a6:	68 d4 00 00 00       	push   $0xd4
801077ab:	e9 a6 f0 ff ff       	jmp    80106856 <alltraps>

801077b0 <vector213>:
801077b0:	6a 00                	push   $0x0
801077b2:	68 d5 00 00 00       	push   $0xd5
801077b7:	e9 9a f0 ff ff       	jmp    80106856 <alltraps>

801077bc <vector214>:
801077bc:	6a 00                	push   $0x0
801077be:	68 d6 00 00 00       	push   $0xd6
801077c3:	e9 8e f0 ff ff       	jmp    80106856 <alltraps>

801077c8 <vector215>:
801077c8:	6a 00                	push   $0x0
801077ca:	68 d7 00 00 00       	push   $0xd7
801077cf:	e9 82 f0 ff ff       	jmp    80106856 <alltraps>

801077d4 <vector216>:
801077d4:	6a 00                	push   $0x0
801077d6:	68 d8 00 00 00       	push   $0xd8
801077db:	e9 76 f0 ff ff       	jmp    80106856 <alltraps>

801077e0 <vector217>:
801077e0:	6a 00                	push   $0x0
801077e2:	68 d9 00 00 00       	push   $0xd9
801077e7:	e9 6a f0 ff ff       	jmp    80106856 <alltraps>

801077ec <vector218>:
801077ec:	6a 00                	push   $0x0
801077ee:	68 da 00 00 00       	push   $0xda
801077f3:	e9 5e f0 ff ff       	jmp    80106856 <alltraps>

801077f8 <vector219>:
801077f8:	6a 00                	push   $0x0
801077fa:	68 db 00 00 00       	push   $0xdb
801077ff:	e9 52 f0 ff ff       	jmp    80106856 <alltraps>

80107804 <vector220>:
80107804:	6a 00                	push   $0x0
80107806:	68 dc 00 00 00       	push   $0xdc
8010780b:	e9 46 f0 ff ff       	jmp    80106856 <alltraps>

80107810 <vector221>:
80107810:	6a 00                	push   $0x0
80107812:	68 dd 00 00 00       	push   $0xdd
80107817:	e9 3a f0 ff ff       	jmp    80106856 <alltraps>

8010781c <vector222>:
8010781c:	6a 00                	push   $0x0
8010781e:	68 de 00 00 00       	push   $0xde
80107823:	e9 2e f0 ff ff       	jmp    80106856 <alltraps>

80107828 <vector223>:
80107828:	6a 00                	push   $0x0
8010782a:	68 df 00 00 00       	push   $0xdf
8010782f:	e9 22 f0 ff ff       	jmp    80106856 <alltraps>

80107834 <vector224>:
80107834:	6a 00                	push   $0x0
80107836:	68 e0 00 00 00       	push   $0xe0
8010783b:	e9 16 f0 ff ff       	jmp    80106856 <alltraps>

80107840 <vector225>:
80107840:	6a 00                	push   $0x0
80107842:	68 e1 00 00 00       	push   $0xe1
80107847:	e9 0a f0 ff ff       	jmp    80106856 <alltraps>

8010784c <vector226>:
8010784c:	6a 00                	push   $0x0
8010784e:	68 e2 00 00 00       	push   $0xe2
80107853:	e9 fe ef ff ff       	jmp    80106856 <alltraps>

80107858 <vector227>:
80107858:	6a 00                	push   $0x0
8010785a:	68 e3 00 00 00       	push   $0xe3
8010785f:	e9 f2 ef ff ff       	jmp    80106856 <alltraps>

80107864 <vector228>:
80107864:	6a 00                	push   $0x0
80107866:	68 e4 00 00 00       	push   $0xe4
8010786b:	e9 e6 ef ff ff       	jmp    80106856 <alltraps>

80107870 <vector229>:
80107870:	6a 00                	push   $0x0
80107872:	68 e5 00 00 00       	push   $0xe5
80107877:	e9 da ef ff ff       	jmp    80106856 <alltraps>

8010787c <vector230>:
8010787c:	6a 00                	push   $0x0
8010787e:	68 e6 00 00 00       	push   $0xe6
80107883:	e9 ce ef ff ff       	jmp    80106856 <alltraps>

80107888 <vector231>:
80107888:	6a 00                	push   $0x0
8010788a:	68 e7 00 00 00       	push   $0xe7
8010788f:	e9 c2 ef ff ff       	jmp    80106856 <alltraps>

80107894 <vector232>:
80107894:	6a 00                	push   $0x0
80107896:	68 e8 00 00 00       	push   $0xe8
8010789b:	e9 b6 ef ff ff       	jmp    80106856 <alltraps>

801078a0 <vector233>:
801078a0:	6a 00                	push   $0x0
801078a2:	68 e9 00 00 00       	push   $0xe9
801078a7:	e9 aa ef ff ff       	jmp    80106856 <alltraps>

801078ac <vector234>:
801078ac:	6a 00                	push   $0x0
801078ae:	68 ea 00 00 00       	push   $0xea
801078b3:	e9 9e ef ff ff       	jmp    80106856 <alltraps>

801078b8 <vector235>:
801078b8:	6a 00                	push   $0x0
801078ba:	68 eb 00 00 00       	push   $0xeb
801078bf:	e9 92 ef ff ff       	jmp    80106856 <alltraps>

801078c4 <vector236>:
801078c4:	6a 00                	push   $0x0
801078c6:	68 ec 00 00 00       	push   $0xec
801078cb:	e9 86 ef ff ff       	jmp    80106856 <alltraps>

801078d0 <vector237>:
801078d0:	6a 00                	push   $0x0
801078d2:	68 ed 00 00 00       	push   $0xed
801078d7:	e9 7a ef ff ff       	jmp    80106856 <alltraps>

801078dc <vector238>:
801078dc:	6a 00                	push   $0x0
801078de:	68 ee 00 00 00       	push   $0xee
801078e3:	e9 6e ef ff ff       	jmp    80106856 <alltraps>

801078e8 <vector239>:
801078e8:	6a 00                	push   $0x0
801078ea:	68 ef 00 00 00       	push   $0xef
801078ef:	e9 62 ef ff ff       	jmp    80106856 <alltraps>

801078f4 <vector240>:
801078f4:	6a 00                	push   $0x0
801078f6:	68 f0 00 00 00       	push   $0xf0
801078fb:	e9 56 ef ff ff       	jmp    80106856 <alltraps>

80107900 <vector241>:
80107900:	6a 00                	push   $0x0
80107902:	68 f1 00 00 00       	push   $0xf1
80107907:	e9 4a ef ff ff       	jmp    80106856 <alltraps>

8010790c <vector242>:
8010790c:	6a 00                	push   $0x0
8010790e:	68 f2 00 00 00       	push   $0xf2
80107913:	e9 3e ef ff ff       	jmp    80106856 <alltraps>

80107918 <vector243>:
80107918:	6a 00                	push   $0x0
8010791a:	68 f3 00 00 00       	push   $0xf3
8010791f:	e9 32 ef ff ff       	jmp    80106856 <alltraps>

80107924 <vector244>:
80107924:	6a 00                	push   $0x0
80107926:	68 f4 00 00 00       	push   $0xf4
8010792b:	e9 26 ef ff ff       	jmp    80106856 <alltraps>

80107930 <vector245>:
80107930:	6a 00                	push   $0x0
80107932:	68 f5 00 00 00       	push   $0xf5
80107937:	e9 1a ef ff ff       	jmp    80106856 <alltraps>

8010793c <vector246>:
8010793c:	6a 00                	push   $0x0
8010793e:	68 f6 00 00 00       	push   $0xf6
80107943:	e9 0e ef ff ff       	jmp    80106856 <alltraps>

80107948 <vector247>:
80107948:	6a 00                	push   $0x0
8010794a:	68 f7 00 00 00       	push   $0xf7
8010794f:	e9 02 ef ff ff       	jmp    80106856 <alltraps>

80107954 <vector248>:
80107954:	6a 00                	push   $0x0
80107956:	68 f8 00 00 00       	push   $0xf8
8010795b:	e9 f6 ee ff ff       	jmp    80106856 <alltraps>

80107960 <vector249>:
80107960:	6a 00                	push   $0x0
80107962:	68 f9 00 00 00       	push   $0xf9
80107967:	e9 ea ee ff ff       	jmp    80106856 <alltraps>

8010796c <vector250>:
8010796c:	6a 00                	push   $0x0
8010796e:	68 fa 00 00 00       	push   $0xfa
80107973:	e9 de ee ff ff       	jmp    80106856 <alltraps>

80107978 <vector251>:
80107978:	6a 00                	push   $0x0
8010797a:	68 fb 00 00 00       	push   $0xfb
8010797f:	e9 d2 ee ff ff       	jmp    80106856 <alltraps>

80107984 <vector252>:
80107984:	6a 00                	push   $0x0
80107986:	68 fc 00 00 00       	push   $0xfc
8010798b:	e9 c6 ee ff ff       	jmp    80106856 <alltraps>

80107990 <vector253>:
80107990:	6a 00                	push   $0x0
80107992:	68 fd 00 00 00       	push   $0xfd
80107997:	e9 ba ee ff ff       	jmp    80106856 <alltraps>

8010799c <vector254>:
8010799c:	6a 00                	push   $0x0
8010799e:	68 fe 00 00 00       	push   $0xfe
801079a3:	e9 ae ee ff ff       	jmp    80106856 <alltraps>

801079a8 <vector255>:
801079a8:	6a 00                	push   $0x0
801079aa:	68 ff 00 00 00       	push   $0xff
801079af:	e9 a2 ee ff ff       	jmp    80106856 <alltraps>

801079b4 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801079b4:	55                   	push   %ebp
801079b5:	89 e5                	mov    %esp,%ebp
801079b7:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801079ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801079bd:	83 e8 01             	sub    $0x1,%eax
801079c0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801079c4:	8b 45 08             	mov    0x8(%ebp),%eax
801079c7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801079cb:	8b 45 08             	mov    0x8(%ebp),%eax
801079ce:	c1 e8 10             	shr    $0x10,%eax
801079d1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801079d5:	8d 45 fa             	lea    -0x6(%ebp),%eax
801079d8:	0f 01 10             	lgdtl  (%eax)
}
801079db:	90                   	nop
801079dc:	c9                   	leave  
801079dd:	c3                   	ret    

801079de <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801079de:	55                   	push   %ebp
801079df:	89 e5                	mov    %esp,%ebp
801079e1:	83 ec 04             	sub    $0x4,%esp
801079e4:	8b 45 08             	mov    0x8(%ebp),%eax
801079e7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801079eb:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801079ef:	0f 00 d8             	ltr    %ax
}
801079f2:	90                   	nop
801079f3:	c9                   	leave  
801079f4:	c3                   	ret    

801079f5 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801079f5:	55                   	push   %ebp
801079f6:	89 e5                	mov    %esp,%ebp
801079f8:	83 ec 04             	sub    $0x4,%esp
801079fb:	8b 45 08             	mov    0x8(%ebp),%eax
801079fe:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107a02:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107a06:	8e e8                	mov    %eax,%gs
}
80107a08:	90                   	nop
80107a09:	c9                   	leave  
80107a0a:	c3                   	ret    

80107a0b <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107a0b:	55                   	push   %ebp
80107a0c:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a0e:	8b 45 08             	mov    0x8(%ebp),%eax
80107a11:	0f 22 d8             	mov    %eax,%cr3
}
80107a14:	90                   	nop
80107a15:	5d                   	pop    %ebp
80107a16:	c3                   	ret    

80107a17 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107a17:	55                   	push   %ebp
80107a18:	89 e5                	mov    %esp,%ebp
80107a1a:	8b 45 08             	mov    0x8(%ebp),%eax
80107a1d:	05 00 00 00 80       	add    $0x80000000,%eax
80107a22:	5d                   	pop    %ebp
80107a23:	c3                   	ret    

80107a24 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107a24:	55                   	push   %ebp
80107a25:	89 e5                	mov    %esp,%ebp
80107a27:	8b 45 08             	mov    0x8(%ebp),%eax
80107a2a:	05 00 00 00 80       	add    $0x80000000,%eax
80107a2f:	5d                   	pop    %ebp
80107a30:	c3                   	ret    

80107a31 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107a31:	55                   	push   %ebp
80107a32:	89 e5                	mov    %esp,%ebp
80107a34:	53                   	push   %ebx
80107a35:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107a38:	e8 ee b4 ff ff       	call   80102f2b <cpunum>
80107a3d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107a43:	05 80 23 11 80       	add    $0x80112380,%eax
80107a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4e:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a57:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a60:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a67:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a6b:	83 e2 f0             	and    $0xfffffff0,%edx
80107a6e:	83 ca 0a             	or     $0xa,%edx
80107a71:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a77:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a7b:	83 ca 10             	or     $0x10,%edx
80107a7e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a84:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a88:	83 e2 9f             	and    $0xffffff9f,%edx
80107a8b:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a91:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a95:	83 ca 80             	or     $0xffffff80,%edx
80107a98:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a9e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107aa2:	83 ca 0f             	or     $0xf,%edx
80107aa5:	88 50 7e             	mov    %dl,0x7e(%eax)
80107aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aab:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107aaf:	83 e2 ef             	and    $0xffffffef,%edx
80107ab2:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107abc:	83 e2 df             	and    $0xffffffdf,%edx
80107abf:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ac9:	83 ca 40             	or     $0x40,%edx
80107acc:	88 50 7e             	mov    %dl,0x7e(%eax)
80107acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ad6:	83 ca 80             	or     $0xffffff80,%edx
80107ad9:	88 50 7e             	mov    %dl,0x7e(%eax)
80107adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107adf:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae6:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107aed:	ff ff 
80107aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af2:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107af9:	00 00 
80107afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107afe:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b08:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b0f:	83 e2 f0             	and    $0xfffffff0,%edx
80107b12:	83 ca 02             	or     $0x2,%edx
80107b15:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b25:	83 ca 10             	or     $0x10,%edx
80107b28:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b31:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b38:	83 e2 9f             	and    $0xffffff9f,%edx
80107b3b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b44:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b4b:	83 ca 80             	or     $0xffffff80,%edx
80107b4e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b57:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b5e:	83 ca 0f             	or     $0xf,%edx
80107b61:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b6a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b71:	83 e2 ef             	and    $0xffffffef,%edx
80107b74:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b7d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b84:	83 e2 df             	and    $0xffffffdf,%edx
80107b87:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b90:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b97:	83 ca 40             	or     $0x40,%edx
80107b9a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107baa:	83 ca 80             	or     $0xffffff80,%edx
80107bad:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb6:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc0:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107bc7:	ff ff 
80107bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bcc:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107bd3:	00 00 
80107bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd8:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107be9:	83 e2 f0             	and    $0xfffffff0,%edx
80107bec:	83 ca 0a             	or     $0xa,%edx
80107bef:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf8:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107bff:	83 ca 10             	or     $0x10,%edx
80107c02:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c0b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107c12:	83 ca 60             	or     $0x60,%edx
80107c15:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107c25:	83 ca 80             	or     $0xffffff80,%edx
80107c28:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c31:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c38:	83 ca 0f             	or     $0xf,%edx
80107c3b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c44:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c4b:	83 e2 ef             	and    $0xffffffef,%edx
80107c4e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c57:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c5e:	83 e2 df             	and    $0xffffffdf,%edx
80107c61:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c71:	83 ca 40             	or     $0x40,%edx
80107c74:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c84:	83 ca 80             	or     $0xffffff80,%edx
80107c87:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c90:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9a:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107ca1:	ff ff 
80107ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca6:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107cad:	00 00 
80107caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb2:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cbc:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cc3:	83 e2 f0             	and    $0xfffffff0,%edx
80107cc6:	83 ca 02             	or     $0x2,%edx
80107cc9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd2:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cd9:	83 ca 10             	or     $0x10,%edx
80107cdc:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce5:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cec:	83 ca 60             	or     $0x60,%edx
80107cef:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cff:	83 ca 80             	or     $0xffffff80,%edx
80107d02:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d12:	83 ca 0f             	or     $0xf,%edx
80107d15:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d1e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d25:	83 e2 ef             	and    $0xffffffef,%edx
80107d28:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d31:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d38:	83 e2 df             	and    $0xffffffdf,%edx
80107d3b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d44:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d4b:	83 ca 40             	or     $0x40,%edx
80107d4e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d57:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d5e:	83 ca 80             	or     $0xffffff80,%edx
80107d61:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d74:	05 b4 00 00 00       	add    $0xb4,%eax
80107d79:	89 c3                	mov    %eax,%ebx
80107d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7e:	05 b4 00 00 00       	add    $0xb4,%eax
80107d83:	c1 e8 10             	shr    $0x10,%eax
80107d86:	89 c2                	mov    %eax,%edx
80107d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8b:	05 b4 00 00 00       	add    $0xb4,%eax
80107d90:	c1 e8 18             	shr    $0x18,%eax
80107d93:	89 c1                	mov    %eax,%ecx
80107d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d98:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107d9f:	00 00 
80107da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da4:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dae:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db7:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107dbe:	83 e2 f0             	and    $0xfffffff0,%edx
80107dc1:	83 ca 02             	or     $0x2,%edx
80107dc4:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dcd:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107dd4:	83 ca 10             	or     $0x10,%edx
80107dd7:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de0:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107de7:	83 e2 9f             	and    $0xffffff9f,%edx
80107dea:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df3:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107dfa:	83 ca 80             	or     $0xffffff80,%edx
80107dfd:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e06:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107e0d:	83 e2 f0             	and    $0xfffffff0,%edx
80107e10:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e19:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107e20:	83 e2 ef             	and    $0xffffffef,%edx
80107e23:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e2c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107e33:	83 e2 df             	and    $0xffffffdf,%edx
80107e36:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e3f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107e46:	83 ca 40             	or     $0x40,%edx
80107e49:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e52:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107e59:	83 ca 80             	or     $0xffffff80,%edx
80107e5c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e65:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6e:	83 c0 70             	add    $0x70,%eax
80107e71:	83 ec 08             	sub    $0x8,%esp
80107e74:	6a 38                	push   $0x38
80107e76:	50                   	push   %eax
80107e77:	e8 38 fb ff ff       	call   801079b4 <lgdt>
80107e7c:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107e7f:	83 ec 0c             	sub    $0xc,%esp
80107e82:	6a 18                	push   $0x18
80107e84:	e8 6c fb ff ff       	call   801079f5 <loadgs>
80107e89:	83 c4 10             	add    $0x10,%esp

  // Initialize cpu-local storage.
  cpu = c;
80107e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e8f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107e95:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107e9c:	00 00 00 00 
}
80107ea0:	90                   	nop
80107ea1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107ea4:	c9                   	leave  
80107ea5:	c3                   	ret    

80107ea6 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107ea6:	55                   	push   %ebp
80107ea7:	89 e5                	mov    %esp,%ebp
80107ea9:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107eac:	8b 45 0c             	mov    0xc(%ebp),%eax
80107eaf:	c1 e8 16             	shr    $0x16,%eax
80107eb2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80107ebc:	01 d0                	add    %edx,%eax
80107ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ec4:	8b 00                	mov    (%eax),%eax
80107ec6:	83 e0 01             	and    $0x1,%eax
80107ec9:	85 c0                	test   %eax,%eax
80107ecb:	74 18                	je     80107ee5 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ed0:	8b 00                	mov    (%eax),%eax
80107ed2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ed7:	50                   	push   %eax
80107ed8:	e8 47 fb ff ff       	call   80107a24 <p2v>
80107edd:	83 c4 04             	add    $0x4,%esp
80107ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ee3:	eb 48                	jmp    80107f2d <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107ee5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107ee9:	74 0e                	je     80107ef9 <walkpgdir+0x53>
80107eeb:	e8 d5 ac ff ff       	call   80102bc5 <kalloc>
80107ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ef3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ef7:	75 07                	jne    80107f00 <walkpgdir+0x5a>
      return 0;
80107ef9:	b8 00 00 00 00       	mov    $0x0,%eax
80107efe:	eb 44                	jmp    80107f44 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107f00:	83 ec 04             	sub    $0x4,%esp
80107f03:	68 00 10 00 00       	push   $0x1000
80107f08:	6a 00                	push   $0x0
80107f0a:	ff 75 f4             	pushl  -0xc(%ebp)
80107f0d:	e8 2a d4 ff ff       	call   8010533c <memset>
80107f12:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U
80107f15:	83 ec 0c             	sub    $0xc,%esp
80107f18:	ff 75 f4             	pushl  -0xc(%ebp)
80107f1b:	e8 f7 fa ff ff       	call   80107a17 <v2p>
80107f20:	83 c4 10             	add    $0x10,%esp
80107f23:	83 c8 07             	or     $0x7,%eax
80107f26:	89 c2                	mov    %eax,%edx
80107f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f2b:	89 10                	mov    %edx,(%eax)
;  }
  return &pgtab[PTX(va)];
80107f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f30:	c1 e8 0c             	shr    $0xc,%eax
80107f33:	25 ff 03 00 00       	and    $0x3ff,%eax
80107f38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f42:	01 d0                	add    %edx,%eax
}
80107f44:	c9                   	leave  
80107f45:	c3                   	ret    

80107f46 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107f46:	55                   	push   %ebp
80107f47:	89 e5                	mov    %esp,%ebp
80107f49:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107f57:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f5a:	8b 45 10             	mov    0x10(%ebp),%eax
80107f5d:	01 d0                	add    %edx,%eax
80107f5f:	83 e8 01             	sub    $0x1,%eax
80107f62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107f6a:	83 ec 04             	sub    $0x4,%esp
80107f6d:	6a 01                	push   $0x1
80107f6f:	ff 75 f4             	pushl  -0xc(%ebp)
80107f72:	ff 75 08             	pushl  0x8(%ebp)
80107f75:	e8 2c ff ff ff       	call   80107ea6 <walkpgdir>
80107f7a:	83 c4 10             	add    $0x10,%esp
80107f7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f84:	75 07                	jne    80107f8d <mappages+0x47>
      return -1;
80107f86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f8b:	eb 47                	jmp    80107fd4 <mappages+0x8e>
    if(*pte & PTE_P)
80107f8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f90:	8b 00                	mov    (%eax),%eax
80107f92:	83 e0 01             	and    $0x1,%eax
80107f95:	85 c0                	test   %eax,%eax
80107f97:	74 0d                	je     80107fa6 <mappages+0x60>
      panic("remap");
80107f99:	83 ec 0c             	sub    $0xc,%esp
80107f9c:	68 80 8e 10 80       	push   $0x80108e80
80107fa1:	e8 c0 85 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80107fa6:	8b 45 18             	mov    0x18(%ebp),%eax
80107fa9:	0b 45 14             	or     0x14(%ebp),%eax
80107fac:	83 c8 01             	or     $0x1,%eax
80107faf:	89 c2                	mov    %eax,%edx
80107fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fb4:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107fbc:	74 10                	je     80107fce <mappages+0x88>
      break;
    a += PGSIZE;
80107fbe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107fc5:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107fcc:	eb 9c                	jmp    80107f6a <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107fce:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107fcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fd4:	c9                   	leave  
80107fd5:	c3                   	ret    

80107fd6 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107fd6:	55                   	push   %ebp
80107fd7:	89 e5                	mov    %esp,%ebp
80107fd9:	53                   	push   %ebx
80107fda:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107fdd:	e8 e3 ab ff ff       	call   80102bc5 <kalloc>
80107fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fe5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107fe9:	75 0a                	jne    80107ff5 <setupkvm+0x1f>
    return 0;
80107feb:	b8 00 00 00 00       	mov    $0x0,%eax
80107ff0:	e9 8e 00 00 00       	jmp    80108083 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80107ff5:	83 ec 04             	sub    $0x4,%esp
80107ff8:	68 00 10 00 00       	push   $0x1000
80107ffd:	6a 00                	push   $0x0
80107fff:	ff 75 f0             	pushl  -0x10(%ebp)
80108002:	e8 35 d3 ff ff       	call   8010533c <memset>
80108007:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010800a:	83 ec 0c             	sub    $0xc,%esp
8010800d:	68 00 00 00 0e       	push   $0xe000000
80108012:	e8 0d fa ff ff       	call   80107a24 <p2v>
80108017:	83 c4 10             	add    $0x10,%esp
8010801a:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010801f:	76 0d                	jbe    8010802e <setupkvm+0x58>
    panic("PHYSTOP too high");
80108021:	83 ec 0c             	sub    $0xc,%esp
80108024:	68 86 8e 10 80       	push   $0x80108e86
80108029:	e8 38 85 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010802e:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80108035:	eb 40                	jmp    80108077 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803a:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
8010803d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108040:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108046:	8b 58 08             	mov    0x8(%eax),%ebx
80108049:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804c:	8b 40 04             	mov    0x4(%eax),%eax
8010804f:	29 c3                	sub    %eax,%ebx
80108051:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108054:	8b 00                	mov    (%eax),%eax
80108056:	83 ec 0c             	sub    $0xc,%esp
80108059:	51                   	push   %ecx
8010805a:	52                   	push   %edx
8010805b:	53                   	push   %ebx
8010805c:	50                   	push   %eax
8010805d:	ff 75 f0             	pushl  -0x10(%ebp)
80108060:	e8 e1 fe ff ff       	call   80107f46 <mappages>
80108065:	83 c4 20             	add    $0x20,%esp
80108068:	85 c0                	test   %eax,%eax
8010806a:	79 07                	jns    80108073 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010806c:	b8 00 00 00 00       	mov    $0x0,%eax
80108071:	eb 10                	jmp    80108083 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108073:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108077:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
8010807e:	72 b7                	jb     80108037 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108080:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108083:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108086:	c9                   	leave  
80108087:	c3                   	ret    

80108088 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108088:	55                   	push   %ebp
80108089:	89 e5                	mov    %esp,%ebp
8010808b:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010808e:	e8 43 ff ff ff       	call   80107fd6 <setupkvm>
80108093:	a3 58 54 11 80       	mov    %eax,0x80115458
  switchkvm();
80108098:	e8 03 00 00 00       	call   801080a0 <switchkvm>
}
8010809d:	90                   	nop
8010809e:	c9                   	leave  
8010809f:	c3                   	ret    

801080a0 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801080a0:	55                   	push   %ebp
801080a1:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801080a3:	a1 58 54 11 80       	mov    0x80115458,%eax
801080a8:	50                   	push   %eax
801080a9:	e8 69 f9 ff ff       	call   80107a17 <v2p>
801080ae:	83 c4 04             	add    $0x4,%esp
801080b1:	50                   	push   %eax
801080b2:	e8 54 f9 ff ff       	call   80107a0b <lcr3>
801080b7:	83 c4 04             	add    $0x4,%esp
}
801080ba:	90                   	nop
801080bb:	c9                   	leave  
801080bc:	c3                   	ret    

801080bd <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801080bd:	55                   	push   %ebp
801080be:	89 e5                	mov    %esp,%ebp
801080c0:	56                   	push   %esi
801080c1:	53                   	push   %ebx
  pushcli();
801080c2:	e8 6f d1 ff ff       	call   80105236 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801080c7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801080cd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801080d4:	83 c2 08             	add    $0x8,%edx
801080d7:	89 d6                	mov    %edx,%esi
801080d9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801080e0:	83 c2 08             	add    $0x8,%edx
801080e3:	c1 ea 10             	shr    $0x10,%edx
801080e6:	89 d3                	mov    %edx,%ebx
801080e8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801080ef:	83 c2 08             	add    $0x8,%edx
801080f2:	c1 ea 18             	shr    $0x18,%edx
801080f5:	89 d1                	mov    %edx,%ecx
801080f7:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801080fe:	67 00 
80108100:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108107:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
8010810d:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108114:	83 e2 f0             	and    $0xfffffff0,%edx
80108117:	83 ca 09             	or     $0x9,%edx
8010811a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108120:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108127:	83 ca 10             	or     $0x10,%edx
8010812a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108130:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108137:	83 e2 9f             	and    $0xffffff9f,%edx
8010813a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108140:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108147:	83 ca 80             	or     $0xffffff80,%edx
8010814a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108150:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108157:	83 e2 f0             	and    $0xfffffff0,%edx
8010815a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108160:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108167:	83 e2 ef             	and    $0xffffffef,%edx
8010816a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108170:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108177:	83 e2 df             	and    $0xffffffdf,%edx
8010817a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108180:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108187:	83 ca 40             	or     $0x40,%edx
8010818a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108190:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108197:	83 e2 7f             	and    $0x7f,%edx
8010819a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801081a0:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801081a6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081ac:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801081b3:	83 e2 ef             	and    $0xffffffef,%edx
801081b6:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801081bc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081c2:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801081c8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081ce:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801081d5:	8b 52 08             	mov    0x8(%edx),%edx
801081d8:	81 c2 00 10 00 00    	add    $0x1000,%edx
801081de:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801081e1:	83 ec 0c             	sub    $0xc,%esp
801081e4:	6a 30                	push   $0x30
801081e6:	e8 f3 f7 ff ff       	call   801079de <ltr>
801081eb:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801081ee:	8b 45 08             	mov    0x8(%ebp),%eax
801081f1:	8b 40 04             	mov    0x4(%eax),%eax
801081f4:	85 c0                	test   %eax,%eax
801081f6:	75 0d                	jne    80108205 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
801081f8:	83 ec 0c             	sub    $0xc,%esp
801081fb:	68 97 8e 10 80       	push   $0x80108e97
80108200:	e8 61 83 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108205:	8b 45 08             	mov    0x8(%ebp),%eax
80108208:	8b 40 04             	mov    0x4(%eax),%eax
8010820b:	83 ec 0c             	sub    $0xc,%esp
8010820e:	50                   	push   %eax
8010820f:	e8 03 f8 ff ff       	call   80107a17 <v2p>
80108214:	83 c4 10             	add    $0x10,%esp
80108217:	83 ec 0c             	sub    $0xc,%esp
8010821a:	50                   	push   %eax
8010821b:	e8 eb f7 ff ff       	call   80107a0b <lcr3>
80108220:	83 c4 10             	add    $0x10,%esp
  popcli();
80108223:	e8 53 d0 ff ff       	call   8010527b <popcli>
}
80108228:	90                   	nop
80108229:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010822c:	5b                   	pop    %ebx
8010822d:	5e                   	pop    %esi
8010822e:	5d                   	pop    %ebp
8010822f:	c3                   	ret    

80108230 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108230:	55                   	push   %ebp
80108231:	89 e5                	mov    %esp,%ebp
80108233:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80108236:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010823d:	76 0d                	jbe    8010824c <inituvm+0x1c>
    panic("inituvm: more than a page");
8010823f:	83 ec 0c             	sub    $0xc,%esp
80108242:	68 ab 8e 10 80       	push   $0x80108eab
80108247:	e8 1a 83 ff ff       	call   80100566 <panic>
  mem = kalloc();
8010824c:	e8 74 a9 ff ff       	call   80102bc5 <kalloc>
80108251:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108254:	83 ec 04             	sub    $0x4,%esp
80108257:	68 00 10 00 00       	push   $0x1000
8010825c:	6a 00                	push   $0x0
8010825e:	ff 75 f4             	pushl  -0xc(%ebp)
80108261:	e8 d6 d0 ff ff       	call   8010533c <memset>
80108266:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108269:	83 ec 0c             	sub    $0xc,%esp
8010826c:	ff 75 f4             	pushl  -0xc(%ebp)
8010826f:	e8 a3 f7 ff ff       	call   80107a17 <v2p>
80108274:	83 c4 10             	add    $0x10,%esp
80108277:	83 ec 0c             	sub    $0xc,%esp
8010827a:	6a 06                	push   $0x6
8010827c:	50                   	push   %eax
8010827d:	68 00 10 00 00       	push   $0x1000
80108282:	6a 00                	push   $0x0
80108284:	ff 75 08             	pushl  0x8(%ebp)
80108287:	e8 ba fc ff ff       	call   80107f46 <mappages>
8010828c:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010828f:	83 ec 04             	sub    $0x4,%esp
80108292:	ff 75 10             	pushl  0x10(%ebp)
80108295:	ff 75 0c             	pushl  0xc(%ebp)
80108298:	ff 75 f4             	pushl  -0xc(%ebp)
8010829b:	e8 5b d1 ff ff       	call   801053fb <memmove>
801082a0:	83 c4 10             	add    $0x10,%esp
}
801082a3:	90                   	nop
801082a4:	c9                   	leave  
801082a5:	c3                   	ret    

801082a6 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801082a6:	55                   	push   %ebp
801082a7:	89 e5                	mov    %esp,%ebp
801082a9:	53                   	push   %ebx
801082aa:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801082ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801082b0:	25 ff 0f 00 00       	and    $0xfff,%eax
801082b5:	85 c0                	test   %eax,%eax
801082b7:	74 0d                	je     801082c6 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801082b9:	83 ec 0c             	sub    $0xc,%esp
801082bc:	68 c8 8e 10 80       	push   $0x80108ec8
801082c1:	e8 a0 82 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801082c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082cd:	e9 95 00 00 00       	jmp    80108367 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801082d2:	8b 55 0c             	mov    0xc(%ebp),%edx
801082d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d8:	01 d0                	add    %edx,%eax
801082da:	83 ec 04             	sub    $0x4,%esp
801082dd:	6a 00                	push   $0x0
801082df:	50                   	push   %eax
801082e0:	ff 75 08             	pushl  0x8(%ebp)
801082e3:	e8 be fb ff ff       	call   80107ea6 <walkpgdir>
801082e8:	83 c4 10             	add    $0x10,%esp
801082eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
801082ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801082f2:	75 0d                	jne    80108301 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801082f4:	83 ec 0c             	sub    $0xc,%esp
801082f7:	68 eb 8e 10 80       	push   $0x80108eeb
801082fc:	e8 65 82 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108301:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108304:	8b 00                	mov    (%eax),%eax
80108306:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010830b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010830e:	8b 45 18             	mov    0x18(%ebp),%eax
80108311:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108314:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108319:	77 0b                	ja     80108326 <loaduvm+0x80>
      n = sz - i;
8010831b:	8b 45 18             	mov    0x18(%ebp),%eax
8010831e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108321:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108324:	eb 07                	jmp    8010832d <loaduvm+0x87>
    else
      n = PGSIZE;
80108326:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010832d:	8b 55 14             	mov    0x14(%ebp),%edx
80108330:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108333:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108336:	83 ec 0c             	sub    $0xc,%esp
80108339:	ff 75 e8             	pushl  -0x18(%ebp)
8010833c:	e8 e3 f6 ff ff       	call   80107a24 <p2v>
80108341:	83 c4 10             	add    $0x10,%esp
80108344:	ff 75 f0             	pushl  -0x10(%ebp)
80108347:	53                   	push   %ebx
80108348:	50                   	push   %eax
80108349:	ff 75 10             	pushl  0x10(%ebp)
8010834c:	e8 22 9b ff ff       	call   80101e73 <readi>
80108351:	83 c4 10             	add    $0x10,%esp
80108354:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108357:	74 07                	je     80108360 <loaduvm+0xba>
      return -1;
80108359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010835e:	eb 18                	jmp    80108378 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108360:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836a:	3b 45 18             	cmp    0x18(%ebp),%eax
8010836d:	0f 82 5f ff ff ff    	jb     801082d2 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108373:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108378:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010837b:	c9                   	leave  
8010837c:	c3                   	ret    

8010837d <mprotect>:

int
mprotect(void *addr, int len, int prot)
{
8010837d:	55                   	push   %ebp
8010837e:	89 e5                	mov    %esp,%ebp
80108380:	83 ec 18             	sub    $0x18,%esp
  pte_t *page_table_entry;
  int i = 0;
80108383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  //might need to PGRDWN the address
  //loop through all the page entries that need protection level changed
  for (i = 0; i < len; i++)
8010838a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108391:	eb 36                	jmp    801083c9 <mprotect+0x4c>
  {
    //pass in process pagedir cause that's what we're concerned with
    //now give it addr+i to get address page
    //pass in 0 so it doesn't allocate new tables
    //walk through the physical memory, assigning flags as we go
    page_table_entry = walkpgdir(proc->pgdir,(void *)addr +i, 0);
80108393:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108396:	8b 45 08             	mov    0x8(%ebp),%eax
80108399:	01 c2                	add    %eax,%edx
8010839b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083a1:	8b 40 04             	mov    0x4(%eax),%eax
801083a4:	83 ec 04             	sub    $0x4,%esp
801083a7:	6a 00                	push   $0x0
801083a9:	52                   	push   %edx
801083aa:	50                   	push   %eax
801083ab:	e8 f6 fa ff ff       	call   80107ea6 <walkpgdir>
801083b0:	83 c4 10             	add    $0x10,%esp
801083b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //change the protection flags
    *page_table_entry &= prot;
801083b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083b9:	8b 10                	mov    (%eax),%edx
801083bb:	8b 45 10             	mov    0x10(%ebp),%eax
801083be:	21 c2                	and    %eax,%edx
801083c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083c3:	89 10                	mov    %edx,(%eax)
{
  pte_t *page_table_entry;
  int i = 0;
  //might need to PGRDWN the address
  //loop through all the page entries that need protection level changed
  for (i = 0; i < len; i++)
801083c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801083c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
801083cf:	7c c2                	jl     80108393 <mprotect+0x16>
    page_table_entry = walkpgdir(proc->pgdir,(void *)addr +i, 0);
    //change the protection flags
    *page_table_entry &= prot;
  }
  //flush that tlb real good
  lcr3(*proc->pgdir);
801083d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083d7:	8b 40 04             	mov    0x4(%eax),%eax
801083da:	8b 00                	mov    (%eax),%eax
801083dc:	83 ec 0c             	sub    $0xc,%esp
801083df:	50                   	push   %eax
801083e0:	e8 26 f6 ff ff       	call   80107a0b <lcr3>
801083e5:	83 c4 10             	add    $0x10,%esp
  return 0;
801083e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801083ed:	c9                   	leave  
801083ee:	c3                   	ret    

801083ef <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801083ef:	55                   	push   %ebp
801083f0:	89 e5                	mov    %esp,%ebp
801083f2:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801083f5:	8b 45 10             	mov    0x10(%ebp),%eax
801083f8:	85 c0                	test   %eax,%eax
801083fa:	79 0a                	jns    80108406 <allocuvm+0x17>
    return 0;
801083fc:	b8 00 00 00 00       	mov    $0x0,%eax
80108401:	e9 b0 00 00 00       	jmp    801084b6 <allocuvm+0xc7>
  if(newsz < oldsz)
80108406:	8b 45 10             	mov    0x10(%ebp),%eax
80108409:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010840c:	73 08                	jae    80108416 <allocuvm+0x27>
    return oldsz;
8010840e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108411:	e9 a0 00 00 00       	jmp    801084b6 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108416:	8b 45 0c             	mov    0xc(%ebp),%eax
80108419:	05 ff 0f 00 00       	add    $0xfff,%eax
8010841e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108423:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108426:	eb 7f                	jmp    801084a7 <allocuvm+0xb8>
    mem = kalloc();
80108428:	e8 98 a7 ff ff       	call   80102bc5 <kalloc>
8010842d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108430:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108434:	75 2b                	jne    80108461 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108436:	83 ec 0c             	sub    $0xc,%esp
80108439:	68 09 8f 10 80       	push   $0x80108f09
8010843e:	e8 83 7f ff ff       	call   801003c6 <cprintf>
80108443:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108446:	83 ec 04             	sub    $0x4,%esp
80108449:	ff 75 0c             	pushl  0xc(%ebp)
8010844c:	ff 75 10             	pushl  0x10(%ebp)
8010844f:	ff 75 08             	pushl  0x8(%ebp)
80108452:	e8 61 00 00 00       	call   801084b8 <deallocuvm>
80108457:	83 c4 10             	add    $0x10,%esp
      return 0;
8010845a:	b8 00 00 00 00       	mov    $0x0,%eax
8010845f:	eb 55                	jmp    801084b6 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108461:	83 ec 04             	sub    $0x4,%esp
80108464:	68 00 10 00 00       	push   $0x1000
80108469:	6a 00                	push   $0x0
8010846b:	ff 75 f0             	pushl  -0x10(%ebp)
8010846e:	e8 c9 ce ff ff       	call   8010533c <memset>
80108473:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108476:	83 ec 0c             	sub    $0xc,%esp
80108479:	ff 75 f0             	pushl  -0x10(%ebp)
8010847c:	e8 96 f5 ff ff       	call   80107a17 <v2p>
80108481:	83 c4 10             	add    $0x10,%esp
80108484:	89 c2                	mov    %eax,%edx
80108486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108489:	83 ec 0c             	sub    $0xc,%esp
8010848c:	6a 06                	push   $0x6
8010848e:	52                   	push   %edx
8010848f:	68 00 10 00 00       	push   $0x1000
80108494:	50                   	push   %eax
80108495:	ff 75 08             	pushl  0x8(%ebp)
80108498:	e8 a9 fa ff ff       	call   80107f46 <mappages>
8010849d:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801084a0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801084a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084aa:	3b 45 10             	cmp    0x10(%ebp),%eax
801084ad:	0f 82 75 ff ff ff    	jb     80108428 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801084b3:	8b 45 10             	mov    0x10(%ebp),%eax
}
801084b6:	c9                   	leave  
801084b7:	c3                   	ret    

801084b8 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801084b8:	55                   	push   %ebp
801084b9:	89 e5                	mov    %esp,%ebp
801084bb:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801084be:	8b 45 10             	mov    0x10(%ebp),%eax
801084c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801084c4:	72 08                	jb     801084ce <deallocuvm+0x16>
    return oldsz;
801084c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801084c9:	e9 a5 00 00 00       	jmp    80108573 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801084ce:	8b 45 10             	mov    0x10(%ebp),%eax
801084d1:	05 ff 0f 00 00       	add    $0xfff,%eax
801084d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801084de:	e9 81 00 00 00       	jmp    80108564 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801084e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e6:	83 ec 04             	sub    $0x4,%esp
801084e9:	6a 00                	push   $0x0
801084eb:	50                   	push   %eax
801084ec:	ff 75 08             	pushl  0x8(%ebp)
801084ef:	e8 b2 f9 ff ff       	call   80107ea6 <walkpgdir>
801084f4:	83 c4 10             	add    $0x10,%esp
801084f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801084fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084fe:	75 09                	jne    80108509 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108500:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108507:	eb 54                	jmp    8010855d <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108509:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010850c:	8b 00                	mov    (%eax),%eax
8010850e:	83 e0 01             	and    $0x1,%eax
80108511:	85 c0                	test   %eax,%eax
80108513:	74 48                	je     8010855d <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108515:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108518:	8b 00                	mov    (%eax),%eax
8010851a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010851f:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108522:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108526:	75 0d                	jne    80108535 <deallocuvm+0x7d>
        panic("kfree");
80108528:	83 ec 0c             	sub    $0xc,%esp
8010852b:	68 21 8f 10 80       	push   $0x80108f21
80108530:	e8 31 80 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80108535:	83 ec 0c             	sub    $0xc,%esp
80108538:	ff 75 ec             	pushl  -0x14(%ebp)
8010853b:	e8 e4 f4 ff ff       	call   80107a24 <p2v>
80108540:	83 c4 10             	add    $0x10,%esp
80108543:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108546:	83 ec 0c             	sub    $0xc,%esp
80108549:	ff 75 e8             	pushl  -0x18(%ebp)
8010854c:	e8 d7 a5 ff ff       	call   80102b28 <kfree>
80108551:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108554:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010855d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108564:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108567:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010856a:	0f 82 73 ff ff ff    	jb     801084e3 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108570:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108573:	c9                   	leave  
80108574:	c3                   	ret    

80108575 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108575:	55                   	push   %ebp
80108576:	89 e5                	mov    %esp,%ebp
80108578:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010857b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010857f:	75 0d                	jne    8010858e <freevm+0x19>
    panic("freevm: no pgdir");
80108581:	83 ec 0c             	sub    $0xc,%esp
80108584:	68 27 8f 10 80       	push   $0x80108f27
80108589:	e8 d8 7f ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010858e:	83 ec 04             	sub    $0x4,%esp
80108591:	6a 00                	push   $0x0
80108593:	68 00 00 00 80       	push   $0x80000000
80108598:	ff 75 08             	pushl  0x8(%ebp)
8010859b:	e8 18 ff ff ff       	call   801084b8 <deallocuvm>
801085a0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801085a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801085aa:	eb 4f                	jmp    801085fb <freevm+0x86>
    if(pgdir[i] & PTE_P){
801085ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801085b6:	8b 45 08             	mov    0x8(%ebp),%eax
801085b9:	01 d0                	add    %edx,%eax
801085bb:	8b 00                	mov    (%eax),%eax
801085bd:	83 e0 01             	and    $0x1,%eax
801085c0:	85 c0                	test   %eax,%eax
801085c2:	74 33                	je     801085f7 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801085c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801085ce:	8b 45 08             	mov    0x8(%ebp),%eax
801085d1:	01 d0                	add    %edx,%eax
801085d3:	8b 00                	mov    (%eax),%eax
801085d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085da:	83 ec 0c             	sub    $0xc,%esp
801085dd:	50                   	push   %eax
801085de:	e8 41 f4 ff ff       	call   80107a24 <p2v>
801085e3:	83 c4 10             	add    $0x10,%esp
801085e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801085e9:	83 ec 0c             	sub    $0xc,%esp
801085ec:	ff 75 f0             	pushl  -0x10(%ebp)
801085ef:	e8 34 a5 ff ff       	call   80102b28 <kfree>
801085f4:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801085f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801085fb:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108602:	76 a8                	jbe    801085ac <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108604:	83 ec 0c             	sub    $0xc,%esp
80108607:	ff 75 08             	pushl  0x8(%ebp)
8010860a:	e8 19 a5 ff ff       	call   80102b28 <kfree>
8010860f:	83 c4 10             	add    $0x10,%esp
}
80108612:	90                   	nop
80108613:	c9                   	leave  
80108614:	c3                   	ret    

80108615 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108615:	55                   	push   %ebp
80108616:	89 e5                	mov    %esp,%ebp
80108618:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010861b:	83 ec 04             	sub    $0x4,%esp
8010861e:	6a 00                	push   $0x0
80108620:	ff 75 0c             	pushl  0xc(%ebp)
80108623:	ff 75 08             	pushl  0x8(%ebp)
80108626:	e8 7b f8 ff ff       	call   80107ea6 <walkpgdir>
8010862b:	83 c4 10             	add    $0x10,%esp
8010862e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108635:	75 0d                	jne    80108644 <clearpteu+0x2f>
    panic("clearpteu");
80108637:	83 ec 0c             	sub    $0xc,%esp
8010863a:	68 38 8f 10 80       	push   $0x80108f38
8010863f:	e8 22 7f ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80108644:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108647:	8b 00                	mov    (%eax),%eax
80108649:	83 e0 fb             	and    $0xfffffffb,%eax
8010864c:	89 c2                	mov    %eax,%edx
8010864e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108651:	89 10                	mov    %edx,(%eax)
}
80108653:	90                   	nop
80108654:	c9                   	leave  
80108655:	c3                   	ret    

80108656 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108656:	55                   	push   %ebp
80108657:	89 e5                	mov    %esp,%ebp
80108659:	53                   	push   %ebx
8010865a:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010865d:	e8 74 f9 ff ff       	call   80107fd6 <setupkvm>
80108662:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108665:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108669:	75 0a                	jne    80108675 <copyuvm+0x1f>
    return 0;
8010866b:	b8 00 00 00 00       	mov    $0x0,%eax
80108670:	e9 f8 00 00 00       	jmp    8010876d <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108675:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010867c:	e9 c4 00 00 00       	jmp    80108745 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108684:	83 ec 04             	sub    $0x4,%esp
80108687:	6a 00                	push   $0x0
80108689:	50                   	push   %eax
8010868a:	ff 75 08             	pushl  0x8(%ebp)
8010868d:	e8 14 f8 ff ff       	call   80107ea6 <walkpgdir>
80108692:	83 c4 10             	add    $0x10,%esp
80108695:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108698:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010869c:	75 0d                	jne    801086ab <copyuvm+0x55>
      panic("copyuvm: pte should exist");
8010869e:	83 ec 0c             	sub    $0xc,%esp
801086a1:	68 42 8f 10 80       	push   $0x80108f42
801086a6:	e8 bb 7e ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
801086ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086ae:	8b 00                	mov    (%eax),%eax
801086b0:	83 e0 01             	and    $0x1,%eax
801086b3:	85 c0                	test   %eax,%eax
801086b5:	75 0d                	jne    801086c4 <copyuvm+0x6e>
      panic("copyuvm: page not present");
801086b7:	83 ec 0c             	sub    $0xc,%esp
801086ba:	68 5c 8f 10 80       	push   $0x80108f5c
801086bf:	e8 a2 7e ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801086c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086c7:	8b 00                	mov    (%eax),%eax
801086c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801086d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086d4:	8b 00                	mov    (%eax),%eax
801086d6:	25 ff 0f 00 00       	and    $0xfff,%eax
801086db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801086de:	e8 e2 a4 ff ff       	call   80102bc5 <kalloc>
801086e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801086e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801086ea:	74 6a                	je     80108756 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801086ec:	83 ec 0c             	sub    $0xc,%esp
801086ef:	ff 75 e8             	pushl  -0x18(%ebp)
801086f2:	e8 2d f3 ff ff       	call   80107a24 <p2v>
801086f7:	83 c4 10             	add    $0x10,%esp
801086fa:	83 ec 04             	sub    $0x4,%esp
801086fd:	68 00 10 00 00       	push   $0x1000
80108702:	50                   	push   %eax
80108703:	ff 75 e0             	pushl  -0x20(%ebp)
80108706:	e8 f0 cc ff ff       	call   801053fb <memmove>
8010870b:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010870e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108711:	83 ec 0c             	sub    $0xc,%esp
80108714:	ff 75 e0             	pushl  -0x20(%ebp)
80108717:	e8 fb f2 ff ff       	call   80107a17 <v2p>
8010871c:	83 c4 10             	add    $0x10,%esp
8010871f:	89 c2                	mov    %eax,%edx
80108721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108724:	83 ec 0c             	sub    $0xc,%esp
80108727:	53                   	push   %ebx
80108728:	52                   	push   %edx
80108729:	68 00 10 00 00       	push   $0x1000
8010872e:	50                   	push   %eax
8010872f:	ff 75 f0             	pushl  -0x10(%ebp)
80108732:	e8 0f f8 ff ff       	call   80107f46 <mappages>
80108737:	83 c4 20             	add    $0x20,%esp
8010873a:	85 c0                	test   %eax,%eax
8010873c:	78 1b                	js     80108759 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010873e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108745:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108748:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010874b:	0f 82 30 ff ff ff    	jb     80108681 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108751:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108754:	eb 17                	jmp    8010876d <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108756:	90                   	nop
80108757:	eb 01                	jmp    8010875a <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108759:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010875a:	83 ec 0c             	sub    $0xc,%esp
8010875d:	ff 75 f0             	pushl  -0x10(%ebp)
80108760:	e8 10 fe ff ff       	call   80108575 <freevm>
80108765:	83 c4 10             	add    $0x10,%esp
  return 0;
80108768:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010876d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108770:	c9                   	leave  
80108771:	c3                   	ret    

80108772 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108772:	55                   	push   %ebp
80108773:	89 e5                	mov    %esp,%ebp
80108775:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108778:	83 ec 04             	sub    $0x4,%esp
8010877b:	6a 00                	push   $0x0
8010877d:	ff 75 0c             	pushl  0xc(%ebp)
80108780:	ff 75 08             	pushl  0x8(%ebp)
80108783:	e8 1e f7 ff ff       	call   80107ea6 <walkpgdir>
80108788:	83 c4 10             	add    $0x10,%esp
8010878b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010878e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108791:	8b 00                	mov    (%eax),%eax
80108793:	83 e0 01             	and    $0x1,%eax
80108796:	85 c0                	test   %eax,%eax
80108798:	75 07                	jne    801087a1 <uva2ka+0x2f>
    return 0;
8010879a:	b8 00 00 00 00       	mov    $0x0,%eax
8010879f:	eb 29                	jmp    801087ca <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801087a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a4:	8b 00                	mov    (%eax),%eax
801087a6:	83 e0 04             	and    $0x4,%eax
801087a9:	85 c0                	test   %eax,%eax
801087ab:	75 07                	jne    801087b4 <uva2ka+0x42>
    return 0;
801087ad:	b8 00 00 00 00       	mov    $0x0,%eax
801087b2:	eb 16                	jmp    801087ca <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
801087b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087b7:	8b 00                	mov    (%eax),%eax
801087b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087be:	83 ec 0c             	sub    $0xc,%esp
801087c1:	50                   	push   %eax
801087c2:	e8 5d f2 ff ff       	call   80107a24 <p2v>
801087c7:	83 c4 10             	add    $0x10,%esp
}
801087ca:	c9                   	leave  
801087cb:	c3                   	ret    

801087cc <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801087cc:	55                   	push   %ebp
801087cd:	89 e5                	mov    %esp,%ebp
801087cf:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801087d2:	8b 45 10             	mov    0x10(%ebp),%eax
801087d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801087d8:	eb 7f                	jmp    80108859 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801087da:	8b 45 0c             	mov    0xc(%ebp),%eax
801087dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801087e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087e8:	83 ec 08             	sub    $0x8,%esp
801087eb:	50                   	push   %eax
801087ec:	ff 75 08             	pushl  0x8(%ebp)
801087ef:	e8 7e ff ff ff       	call   80108772 <uva2ka>
801087f4:	83 c4 10             	add    $0x10,%esp
801087f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801087fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801087fe:	75 07                	jne    80108807 <copyout+0x3b>
      return -1;
80108800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108805:	eb 61                	jmp    80108868 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108807:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010880a:	2b 45 0c             	sub    0xc(%ebp),%eax
8010880d:	05 00 10 00 00       	add    $0x1000,%eax
80108812:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108815:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108818:	3b 45 14             	cmp    0x14(%ebp),%eax
8010881b:	76 06                	jbe    80108823 <copyout+0x57>
      n = len;
8010881d:	8b 45 14             	mov    0x14(%ebp),%eax
80108820:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108823:	8b 45 0c             	mov    0xc(%ebp),%eax
80108826:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108829:	89 c2                	mov    %eax,%edx
8010882b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010882e:	01 d0                	add    %edx,%eax
80108830:	83 ec 04             	sub    $0x4,%esp
80108833:	ff 75 f0             	pushl  -0x10(%ebp)
80108836:	ff 75 f4             	pushl  -0xc(%ebp)
80108839:	50                   	push   %eax
8010883a:	e8 bc cb ff ff       	call   801053fb <memmove>
8010883f:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108842:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108845:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108848:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010884b:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010884e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108851:	05 00 10 00 00       	add    $0x1000,%eax
80108856:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108859:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010885d:	0f 85 77 ff ff ff    	jne    801087da <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108863:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108868:	c9                   	leave  
80108869:	c3                   	ret    
