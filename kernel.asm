
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp
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
8010003d:	68 0c 8d 10 80       	push   $0x80108d0c
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 3e 52 00 00       	call   8010528a <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100056:	15 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
80100060:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 15 11 80       	mov    0x80111594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 15 11 80       	mov    %eax,0x80111594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 15 11 80       	mov    $0x80111584,%eax
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
801000bc:	68 80 d6 10 80       	push   $0x8010d680
801000c1:	e8 e6 51 00 00       	call   801052ac <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 15 11 80       	mov    0x80111594,%eax
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
80100107:	68 80 d6 10 80       	push   $0x8010d680
8010010c:	e8 02 52 00 00       	call   80105313 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 17 4d 00 00       	call   80104e43 <sleep>
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
8010013a:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 15 11 80       	mov    0x80111590,%eax
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
80100183:	68 80 d6 10 80       	push   $0x8010d680
80100188:	e8 86 51 00 00       	call   80105313 <release>
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
8010019e:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 13 8d 10 80       	push   $0x80108d13
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
80100204:	68 24 8d 10 80       	push   $0x80108d24
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
80100243:	68 2b 8d 10 80       	push   $0x80108d2b
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 52 50 00 00       	call   801052ac <acquire>
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
8010027b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 15 11 80       	mov    0x80111594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 15 11 80       	mov    %eax,0x80111594

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
801002b9:	e8 73 4c 00 00       	call   80104f31 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 45 50 00 00       	call   80105313 <release>
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
80100365:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
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
801003cc:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 c5 10 80       	push   $0x8010c5e0
801003e2:	e8 c5 4e 00 00       	call   801052ac <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 32 8d 10 80       	push   $0x80108d32
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
801004cd:	c7 45 ec 3b 8d 10 80 	movl   $0x80108d3b,-0x14(%ebp)
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
80100556:	68 e0 c5 10 80       	push   $0x8010c5e0
8010055b:	e8 b3 4d 00 00       	call   80105313 <release>
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
80100571:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 42 8d 10 80       	push   $0x80108d42
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
801005aa:	68 51 8d 10 80       	push   $0x80108d51
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 9e 4d 00 00       	call   80105365 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 53 8d 10 80       	push   $0x80108d53
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
801005f5:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
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
80100699:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
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
801006c1:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006c6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006cc:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006d1:	83 ec 04             	sub    $0x4,%esp
801006d4:	68 60 0e 00 00       	push   $0xe60
801006d9:	52                   	push   %edx
801006da:	50                   	push   %eax
801006db:	e8 ee 4e 00 00       	call   801055ce <memmove>
801006e0:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006e3:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006e7:	b8 80 07 00 00       	mov    $0x780,%eax
801006ec:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006ef:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006f2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006f7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006fa:	01 c9                	add    %ecx,%ecx
801006fc:	01 c8                	add    %ecx,%eax
801006fe:	83 ec 04             	sub    $0x4,%esp
80100701:	52                   	push   %edx
80100702:	6a 00                	push   $0x0
80100704:	50                   	push   %eax
80100705:	e8 05 4e 00 00       	call   8010550f <memset>
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
80100762:	a1 00 a0 10 80       	mov    0x8010a000,%eax
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
8010077c:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
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
8010079a:	e8 f3 68 00 00       	call   80107092 <uartputc>
8010079f:	83 c4 10             	add    $0x10,%esp
801007a2:	83 ec 0c             	sub    $0xc,%esp
801007a5:	6a 20                	push   $0x20
801007a7:	e8 e6 68 00 00       	call   80107092 <uartputc>
801007ac:	83 c4 10             	add    $0x10,%esp
801007af:	83 ec 0c             	sub    $0xc,%esp
801007b2:	6a 08                	push   $0x8
801007b4:	e8 d9 68 00 00       	call   80107092 <uartputc>
801007b9:	83 c4 10             	add    $0x10,%esp
801007bc:	eb 0e                	jmp    801007cc <consputc+0x56>
  } else
    uartputc(c);
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	ff 75 08             	pushl  0x8(%ebp)
801007c4:	e8 c9 68 00 00       	call   80107092 <uartputc>
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
801007e6:	68 a0 17 11 80       	push   $0x801117a0
801007eb:	e8 bc 4a 00 00       	call   801052ac <acquire>
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
8010081e:	e8 cc 47 00 00       	call   80104fef <procdump>
      break;
80100823:	e9 12 01 00 00       	jmp    8010093a <consoleintr+0x15d>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100828:	a1 5c 18 11 80       	mov    0x8011185c,%eax
8010082d:	83 e8 01             	sub    $0x1,%eax
80100830:	a3 5c 18 11 80       	mov    %eax,0x8011185c
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
80100845:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
8010084b:	a1 58 18 11 80       	mov    0x80111858,%eax
80100850:	39 c2                	cmp    %eax,%edx
80100852:	0f 84 e2 00 00 00    	je     8010093a <consoleintr+0x15d>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100858:	a1 5c 18 11 80       	mov    0x8011185c,%eax
8010085d:	83 e8 01             	sub    $0x1,%eax
80100860:	83 e0 7f             	and    $0x7f,%eax
80100863:	0f b6 80 d4 17 11 80 	movzbl -0x7feee82c(%eax),%eax
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
80100873:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
80100879:	a1 58 18 11 80       	mov    0x80111858,%eax
8010087e:	39 c2                	cmp    %eax,%edx
80100880:	0f 84 b4 00 00 00    	je     8010093a <consoleintr+0x15d>
        input.e--;
80100886:	a1 5c 18 11 80       	mov    0x8011185c,%eax
8010088b:	83 e8 01             	sub    $0x1,%eax
8010088e:	a3 5c 18 11 80       	mov    %eax,0x8011185c
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
801008b2:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
801008b8:	a1 54 18 11 80       	mov    0x80111854,%eax
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
801008d9:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801008de:	8d 50 01             	lea    0x1(%eax),%edx
801008e1:	89 15 5c 18 11 80    	mov    %edx,0x8011185c
801008e7:	83 e0 7f             	and    $0x7f,%eax
801008ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008ed:	88 90 d4 17 11 80    	mov    %dl,-0x7feee82c(%eax)
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
8010090d:	a1 5c 18 11 80       	mov    0x8011185c,%eax
80100912:	8b 15 54 18 11 80    	mov    0x80111854,%edx
80100918:	83 ea 80             	sub    $0xffffff80,%edx
8010091b:	39 d0                	cmp    %edx,%eax
8010091d:	75 1a                	jne    80100939 <consoleintr+0x15c>
          input.w = input.e;
8010091f:	a1 5c 18 11 80       	mov    0x8011185c,%eax
80100924:	a3 58 18 11 80       	mov    %eax,0x80111858
          wakeup(&input.r);
80100929:	83 ec 0c             	sub    $0xc,%esp
8010092c:	68 54 18 11 80       	push   $0x80111854
80100931:	e8 fb 45 00 00       	call   80104f31 <wakeup>
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
8010094f:	68 a0 17 11 80       	push   $0x801117a0
80100954:	e8 ba 49 00 00       	call   80105313 <release>
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
8010097c:	68 a0 17 11 80       	push   $0x801117a0
80100981:	e8 26 49 00 00       	call   801052ac <acquire>
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
8010099e:	68 a0 17 11 80       	push   $0x801117a0
801009a3:	e8 6b 49 00 00       	call   80105313 <release>
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
801009c6:	68 a0 17 11 80       	push   $0x801117a0
801009cb:	68 54 18 11 80       	push   $0x80111854
801009d0:	e8 6e 44 00 00       	call   80104e43 <sleep>
801009d5:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
801009d8:	8b 15 54 18 11 80    	mov    0x80111854,%edx
801009de:	a1 58 18 11 80       	mov    0x80111858,%eax
801009e3:	39 c2                	cmp    %eax,%edx
801009e5:	74 a7                	je     8010098e <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009e7:	a1 54 18 11 80       	mov    0x80111854,%eax
801009ec:	8d 50 01             	lea    0x1(%eax),%edx
801009ef:	89 15 54 18 11 80    	mov    %edx,0x80111854
801009f5:	83 e0 7f             	and    $0x7f,%eax
801009f8:	0f b6 80 d4 17 11 80 	movzbl -0x7feee82c(%eax),%eax
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
80100a13:	a1 54 18 11 80       	mov    0x80111854,%eax
80100a18:	83 e8 01             	sub    $0x1,%eax
80100a1b:	a3 54 18 11 80       	mov    %eax,0x80111854
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
80100a49:	68 a0 17 11 80       	push   $0x801117a0
80100a4e:	e8 c0 48 00 00       	call   80105313 <release>
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
80100a87:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a8c:	e8 1b 48 00 00       	call   801052ac <acquire>
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
80100ac9:	68 e0 c5 10 80       	push   $0x8010c5e0
80100ace:	e8 40 48 00 00       	call   80105313 <release>
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
80100af2:	68 57 8d 10 80       	push   $0x80108d57
80100af7:	68 e0 c5 10 80       	push   $0x8010c5e0
80100afc:	e8 89 47 00 00       	call   8010528a <initlock>
80100b01:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b04:	83 ec 08             	sub    $0x8,%esp
80100b07:	68 5f 8d 10 80       	push   $0x80108d5f
80100b0c:	68 a0 17 11 80       	push   $0x801117a0
80100b11:	e8 74 47 00 00       	call   8010528a <initlock>
80100b16:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b19:	c7 05 0c 22 11 80 70 	movl   $0x80100a70,0x8011220c
80100b20:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b23:	c7 05 08 22 11 80 5f 	movl   $0x8010095f,0x80112208
80100b2a:	09 10 80 
  cons.locking = 1;
80100b2d:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100b34:	00 00 00 

  picenable(IRQ_KBD);
80100b37:	83 ec 0c             	sub    $0xc,%esp
80100b3a:	6a 01                	push   $0x1
80100b3c:	e8 3b 33 00 00       	call   80103e7c <picenable>
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
80100bcf:	e8 31 76 00 00       	call   80108205 <setupkvm>
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
80100c55:	e8 7a 7a 00 00       	call   801086d4 <allocuvm>
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
80100c88:	e8 48 78 00 00       	call   801084d5 <loaduvm>
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
80100cf7:	e8 d8 79 00 00       	call   801086d4 <allocuvm>
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
80100d1b:	e8 da 7b 00 00       	call   801088fa <clearpteu>
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
80100d54:	e8 03 4a 00 00       	call   8010575c <strlen>
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
80100d81:	e8 d6 49 00 00       	call   8010575c <strlen>
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
80100da7:	e8 c0 7e 00 00       	call   80108c6c <copyout>
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
80100e43:	e8 24 7e 00 00       	call   80108c6c <copyout>
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
80100e94:	e8 79 48 00 00       	call   80105712 <safestrcpy>
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
80100eea:	e8 fd 73 00 00       	call   801082ec <switchuvm>
80100eef:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
80100ef5:	ff 75 d0             	pushl  -0x30(%ebp)
80100ef8:	e8 5d 79 00 00       	call   8010885a <freevm>
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
80100f32:	e8 23 79 00 00       	call   8010885a <freevm>
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
80100f63:	68 65 8d 10 80       	push   $0x80108d65
80100f68:	68 60 18 11 80       	push   $0x80111860
80100f6d:	e8 18 43 00 00       	call   8010528a <initlock>
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
80100f81:	68 60 18 11 80       	push   $0x80111860
80100f86:	e8 21 43 00 00       	call   801052ac <acquire>
80100f8b:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f8e:	c7 45 f4 94 18 11 80 	movl   $0x80111894,-0xc(%ebp)
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
80100fae:	68 60 18 11 80       	push   $0x80111860
80100fb3:	e8 5b 43 00 00       	call   80105313 <release>
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
80100fc4:	b8 f4 21 11 80       	mov    $0x801121f4,%eax
80100fc9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100fcc:	72 c9                	jb     80100f97 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fce:	83 ec 0c             	sub    $0xc,%esp
80100fd1:	68 60 18 11 80       	push   $0x80111860
80100fd6:	e8 38 43 00 00       	call   80105313 <release>
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
80100fee:	68 60 18 11 80       	push   $0x80111860
80100ff3:	e8 b4 42 00 00       	call   801052ac <acquire>
80100ff8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffe:	8b 40 04             	mov    0x4(%eax),%eax
80101001:	85 c0                	test   %eax,%eax
80101003:	7f 0d                	jg     80101012 <filedup+0x2d>
    panic("filedup");
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	68 6c 8d 10 80       	push   $0x80108d6c
8010100d:	e8 54 f5 ff ff       	call   80100566 <panic>
  f->ref++;
80101012:	8b 45 08             	mov    0x8(%ebp),%eax
80101015:	8b 40 04             	mov    0x4(%eax),%eax
80101018:	8d 50 01             	lea    0x1(%eax),%edx
8010101b:	8b 45 08             	mov    0x8(%ebp),%eax
8010101e:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101021:	83 ec 0c             	sub    $0xc,%esp
80101024:	68 60 18 11 80       	push   $0x80111860
80101029:	e8 e5 42 00 00       	call   80105313 <release>
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
8010103f:	68 60 18 11 80       	push   $0x80111860
80101044:	e8 63 42 00 00       	call   801052ac <acquire>
80101049:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
8010104f:	8b 40 04             	mov    0x4(%eax),%eax
80101052:	85 c0                	test   %eax,%eax
80101054:	7f 0d                	jg     80101063 <fileclose+0x2d>
    panic("fileclose");
80101056:	83 ec 0c             	sub    $0xc,%esp
80101059:	68 74 8d 10 80       	push   $0x80108d74
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
8010107f:	68 60 18 11 80       	push   $0x80111860
80101084:	e8 8a 42 00 00       	call   80105313 <release>
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
801010cd:	68 60 18 11 80       	push   $0x80111860
801010d2:	e8 3c 42 00 00       	call   80105313 <release>
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
801010f1:	e8 ef 2f 00 00       	call   801040e5 <pipeclose>
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
801011aa:	e8 de 30 00 00       	call   8010428d <piperead>
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
80101221:	68 7e 8d 10 80       	push   $0x80108d7e
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
80101263:	e8 27 2f 00 00       	call   8010418f <pipewrite>
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
80101324:	68 87 8d 10 80       	push   $0x80108d87
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
8010135a:	68 97 8d 10 80       	push   $0x80108d97
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
80101392:	e8 37 42 00 00       	call   801055ce <memmove>
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
801013d8:	e8 32 41 00 00       	call   8010550f <memset>
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
80101551:	68 a1 8d 10 80       	push   $0x80108da1
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
801015e7:	68 b7 8d 10 80       	push   $0x80108db7
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
80101641:	68 ca 8d 10 80       	push   $0x80108dca
80101646:	68 60 22 11 80       	push   $0x80112260
8010164b:	e8 3a 3c 00 00       	call   8010528a <initlock>
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
801016c6:	e8 44 3e 00 00       	call   8010550f <memset>
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
8010172b:	68 d1 8d 10 80       	push   $0x80108dd1
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
801017cb:	e8 fe 3d 00 00       	call   801055ce <memmove>
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
801017fb:	68 60 22 11 80       	push   $0x80112260
80101800:	e8 a7 3a 00 00       	call   801052ac <acquire>
80101805:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101808:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010180f:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
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
80101849:	68 60 22 11 80       	push   $0x80112260
8010184e:	e8 c0 3a 00 00       	call   80105313 <release>
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
80101875:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
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
80101887:	68 e3 8d 10 80       	push   $0x80108de3
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
801018bf:	68 60 22 11 80       	push   $0x80112260
801018c4:	e8 4a 3a 00 00       	call   80105313 <release>
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
801018da:	68 60 22 11 80       	push   $0x80112260
801018df:	e8 c8 39 00 00       	call   801052ac <acquire>
801018e4:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801018e7:	8b 45 08             	mov    0x8(%ebp),%eax
801018ea:	8b 40 08             	mov    0x8(%eax),%eax
801018ed:	8d 50 01             	lea    0x1(%eax),%edx
801018f0:	8b 45 08             	mov    0x8(%ebp),%eax
801018f3:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	68 60 22 11 80       	push   $0x80112260
801018fe:	e8 10 3a 00 00       	call   80105313 <release>
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
80101924:	68 f3 8d 10 80       	push   $0x80108df3
80101929:	e8 38 ec ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
8010192e:	83 ec 0c             	sub    $0xc,%esp
80101931:	68 60 22 11 80       	push   $0x80112260
80101936:	e8 71 39 00 00       	call   801052ac <acquire>
8010193b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010193e:	eb 13                	jmp    80101953 <ilock+0x48>
    sleep(ip, &icache.lock);
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	68 60 22 11 80       	push   $0x80112260
80101948:	ff 75 08             	pushl  0x8(%ebp)
8010194b:	e8 f3 34 00 00       	call   80104e43 <sleep>
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
80101974:	68 60 22 11 80       	push   $0x80112260
80101979:	e8 95 39 00 00       	call   80105313 <release>
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
80101a20:	e8 a9 3b 00 00       	call   801055ce <memmove>
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
80101a56:	68 f9 8d 10 80       	push   $0x80108df9
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
80101a89:	68 08 8e 10 80       	push   $0x80108e08
80101a8e:	e8 d3 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a93:	83 ec 0c             	sub    $0xc,%esp
80101a96:	68 60 22 11 80       	push   $0x80112260
80101a9b:	e8 0c 38 00 00       	call   801052ac <acquire>
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
80101aba:	e8 72 34 00 00       	call   80104f31 <wakeup>
80101abf:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ac2:	83 ec 0c             	sub    $0xc,%esp
80101ac5:	68 60 22 11 80       	push   $0x80112260
80101aca:	e8 44 38 00 00       	call   80105313 <release>
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
80101ade:	68 60 22 11 80       	push   $0x80112260
80101ae3:	e8 c4 37 00 00       	call   801052ac <acquire>
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
80101b2b:	68 10 8e 10 80       	push   $0x80108e10
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
80101b49:	68 60 22 11 80       	push   $0x80112260
80101b4e:	e8 c0 37 00 00       	call   80105313 <release>
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
80101b7e:	68 60 22 11 80       	push   $0x80112260
80101b83:	e8 24 37 00 00       	call   801052ac <acquire>
80101b88:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b95:	83 ec 0c             	sub    $0xc,%esp
80101b98:	ff 75 08             	pushl  0x8(%ebp)
80101b9b:	e8 91 33 00 00       	call   80104f31 <wakeup>
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
80101bb5:	68 60 22 11 80       	push   $0x80112260
80101bba:	e8 54 37 00 00       	call   80105313 <release>
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
80101cfa:	68 1a 8e 10 80       	push   $0x80108e1a
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
80101ea7:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
80101eae:	85 c0                	test   %eax,%eax
80101eb0:	75 0a                	jne    80101ebc <readi+0x49>
      return -1;
80101eb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb7:	e9 0c 01 00 00       	jmp    80101fc8 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebf:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ec3:	98                   	cwtl   
80101ec4:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
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
80101f91:	e8 38 36 00 00       	call   801055ce <memmove>
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
80101ffe:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
80102005:	85 c0                	test   %eax,%eax
80102007:	75 0a                	jne    80102013 <writei+0x49>
      return -1;
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	e9 3d 01 00 00       	jmp    80102150 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102013:	8b 45 08             	mov    0x8(%ebp),%eax
80102016:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010201a:	98                   	cwtl   
8010201b:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
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
801020e3:	e8 e6 34 00 00       	call   801055ce <memmove>
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
80102163:	e8 fc 34 00 00       	call   80105664 <strncmp>
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
80102183:	68 2d 8e 10 80       	push   $0x80108e2d
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
801021b2:	68 3f 8e 10 80       	push   $0x80108e3f
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
80102287:	68 3f 8e 10 80       	push   $0x80108e3f
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
801022c2:	e8 f3 33 00 00       	call   801056ba <strncpy>
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
801022ee:	68 4c 8e 10 80       	push   $0x80108e4c
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
80102364:	e8 65 32 00 00       	call   801055ce <memmove>
80102369:	83 c4 10             	add    $0x10,%esp
8010236c:	eb 26                	jmp    80102394 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102371:	83 ec 04             	sub    $0x4,%esp
80102374:	50                   	push   %eax
80102375:	ff 75 f4             	pushl  -0xc(%ebp)
80102378:	ff 75 0c             	pushl  0xc(%ebp)
8010237b:	e8 4e 32 00 00       	call   801055ce <memmove>
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
801025d0:	68 54 8e 10 80       	push   $0x80108e54
801025d5:	68 20 c6 10 80       	push   $0x8010c620
801025da:	e8 ab 2c 00 00       	call   8010528a <initlock>
801025df:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801025e2:	83 ec 0c             	sub    $0xc,%esp
801025e5:	6a 0e                	push   $0xe
801025e7:	e8 90 18 00 00       	call   80103e7c <picenable>
801025ec:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801025ef:	a1 60 39 11 80       	mov    0x80113960,%eax
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
80102644:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
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
80102684:	68 58 8e 10 80       	push   $0x80108e58
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
801027a0:	68 20 c6 10 80       	push   $0x8010c620
801027a5:	e8 02 2b 00 00       	call   801052ac <acquire>
801027aa:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027ad:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027b9:	75 15                	jne    801027d0 <ideintr+0x39>
    release(&idelock);
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	68 20 c6 10 80       	push   $0x8010c620
801027c3:	e8 4b 2b 00 00       	call   80105313 <release>
801027c8:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801027cb:	e9 9a 00 00 00       	jmp    8010286a <ideintr+0xd3>
  }
  idequeue = b->qnext;
801027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d3:	8b 40 14             	mov    0x14(%eax),%eax
801027d6:	a3 54 c6 10 80       	mov    %eax,0x8010c654

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
80102838:	e8 f4 26 00 00       	call   80104f31 <wakeup>
8010283d:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102840:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102845:	85 c0                	test   %eax,%eax
80102847:	74 11                	je     8010285a <ideintr+0xc3>
    idestart(idequeue);
80102849:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010284e:	83 ec 0c             	sub    $0xc,%esp
80102851:	50                   	push   %eax
80102852:	e8 1e fe ff ff       	call   80102675 <idestart>
80102857:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010285a:	83 ec 0c             	sub    $0xc,%esp
8010285d:	68 20 c6 10 80       	push   $0x8010c620
80102862:	e8 ac 2a 00 00       	call   80105313 <release>
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
80102881:	68 61 8e 10 80       	push   $0x80108e61
80102886:	e8 db dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010288b:	8b 45 08             	mov    0x8(%ebp),%eax
8010288e:	8b 00                	mov    (%eax),%eax
80102890:	83 e0 06             	and    $0x6,%eax
80102893:	83 f8 02             	cmp    $0x2,%eax
80102896:	75 0d                	jne    801028a5 <iderw+0x39>
    panic("iderw: nothing to do");
80102898:	83 ec 0c             	sub    $0xc,%esp
8010289b:	68 75 8e 10 80       	push   $0x80108e75
801028a0:	e8 c1 dc ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801028a5:	8b 45 08             	mov    0x8(%ebp),%eax
801028a8:	8b 40 04             	mov    0x4(%eax),%eax
801028ab:	85 c0                	test   %eax,%eax
801028ad:	74 16                	je     801028c5 <iderw+0x59>
801028af:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801028b4:	85 c0                	test   %eax,%eax
801028b6:	75 0d                	jne    801028c5 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801028b8:	83 ec 0c             	sub    $0xc,%esp
801028bb:	68 8a 8e 10 80       	push   $0x80108e8a
801028c0:	e8 a1 dc ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028c5:	83 ec 0c             	sub    $0xc,%esp
801028c8:	68 20 c6 10 80       	push   $0x8010c620
801028cd:	e8 da 29 00 00       	call   801052ac <acquire>
801028d2:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801028d5:	8b 45 08             	mov    0x8(%ebp),%eax
801028d8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028df:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
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
80102904:	a1 54 c6 10 80       	mov    0x8010c654,%eax
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
80102921:	68 20 c6 10 80       	push   $0x8010c620
80102926:	ff 75 08             	pushl  0x8(%ebp)
80102929:	e8 15 25 00 00       	call   80104e43 <sleep>
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
80102941:	68 20 c6 10 80       	push   $0x8010c620
80102946:	e8 c8 29 00 00       	call   80105313 <release>
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
80102954:	a1 34 32 11 80       	mov    0x80113234,%eax
80102959:	8b 55 08             	mov    0x8(%ebp),%edx
8010295c:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
8010295e:	a1 34 32 11 80       	mov    0x80113234,%eax
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
8010296b:	a1 34 32 11 80       	mov    0x80113234,%eax
80102970:	8b 55 08             	mov    0x8(%ebp),%edx
80102973:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102975:	a1 34 32 11 80       	mov    0x80113234,%eax
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
80102989:	a1 64 33 11 80       	mov    0x80113364,%eax
8010298e:	85 c0                	test   %eax,%eax
80102990:	0f 84 a0 00 00 00    	je     80102a36 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102996:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
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
801029c5:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
801029cc:	0f b6 c0             	movzbl %al,%eax
801029cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801029d2:	74 10                	je     801029e4 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029d4:	83 ec 0c             	sub    $0xc,%esp
801029d7:	68 a8 8e 10 80       	push   $0x80108ea8
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
80102a3c:	a1 64 33 11 80       	mov    0x80113364,%eax
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
80102a97:	68 da 8e 10 80       	push   $0x80108eda
80102a9c:	68 40 32 11 80       	push   $0x80113240
80102aa1:	e8 e4 27 00 00       	call   8010528a <initlock>
80102aa6:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102aa9:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
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
80102ade:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
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
80102b3a:	81 7d 08 9c 65 21 80 	cmpl   $0x8021659c,0x8(%ebp)
80102b41:	72 12                	jb     80102b55 <kfree+0x2d>
80102b43:	ff 75 08             	pushl  0x8(%ebp)
80102b46:	e8 36 ff ff ff       	call   80102a81 <v2p>
80102b4b:	83 c4 04             	add    $0x4,%esp
80102b4e:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b53:	76 0d                	jbe    80102b62 <kfree+0x3a>
    panic("kfree");
80102b55:	83 ec 0c             	sub    $0xc,%esp
80102b58:	68 df 8e 10 80       	push   $0x80108edf
80102b5d:	e8 04 da ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b62:	83 ec 04             	sub    $0x4,%esp
80102b65:	68 00 10 00 00       	push   $0x1000
80102b6a:	6a 01                	push   $0x1
80102b6c:	ff 75 08             	pushl  0x8(%ebp)
80102b6f:	e8 9b 29 00 00       	call   8010550f <memset>
80102b74:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b77:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	74 10                	je     80102b90 <kfree+0x68>
    acquire(&kmem.lock);
80102b80:	83 ec 0c             	sub    $0xc,%esp
80102b83:	68 40 32 11 80       	push   $0x80113240
80102b88:	e8 1f 27 00 00       	call   801052ac <acquire>
80102b8d:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102b90:	8b 45 08             	mov    0x8(%ebp),%eax
80102b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b96:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9f:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba4:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102ba9:	a1 74 32 11 80       	mov    0x80113274,%eax
80102bae:	85 c0                	test   %eax,%eax
80102bb0:	74 10                	je     80102bc2 <kfree+0x9a>
    release(&kmem.lock);
80102bb2:	83 ec 0c             	sub    $0xc,%esp
80102bb5:	68 40 32 11 80       	push   $0x80113240
80102bba:	e8 54 27 00 00       	call   80105313 <release>
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
80102bcb:	a1 74 32 11 80       	mov    0x80113274,%eax
80102bd0:	85 c0                	test   %eax,%eax
80102bd2:	74 10                	je     80102be4 <kalloc+0x1f>
    acquire(&kmem.lock);
80102bd4:	83 ec 0c             	sub    $0xc,%esp
80102bd7:	68 40 32 11 80       	push   $0x80113240
80102bdc:	e8 cb 26 00 00       	call   801052ac <acquire>
80102be1:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102be4:	a1 78 32 11 80       	mov    0x80113278,%eax
80102be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bf0:	74 0a                	je     80102bfc <kalloc+0x37>
    kmem.freelist = r->next;
80102bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf5:	8b 00                	mov    (%eax),%eax
80102bf7:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102bfc:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c01:	85 c0                	test   %eax,%eax
80102c03:	74 10                	je     80102c15 <kalloc+0x50>
    release(&kmem.lock);
80102c05:	83 ec 0c             	sub    $0xc,%esp
80102c08:	68 40 32 11 80       	push   $0x80113240
80102c0d:	e8 01 27 00 00       	call   80105313 <release>
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
80102c7a:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c7f:	83 c8 40             	or     $0x40,%eax
80102c82:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
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
80102c9d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
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
80102cba:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102cbf:	0f b6 00             	movzbl (%eax),%eax
80102cc2:	83 c8 40             	or     $0x40,%eax
80102cc5:	0f b6 c0             	movzbl %al,%eax
80102cc8:	f7 d0                	not    %eax
80102cca:	89 c2                	mov    %eax,%edx
80102ccc:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cd1:	21 d0                	and    %edx,%eax
80102cd3:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102cd8:	b8 00 00 00 00       	mov    $0x0,%eax
80102cdd:	e9 a2 00 00 00       	jmp    80102d84 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102ce2:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ce7:	83 e0 40             	and    $0x40,%eax
80102cea:	85 c0                	test   %eax,%eax
80102cec:	74 14                	je     80102d02 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cee:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cf5:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cfa:	83 e0 bf             	and    $0xffffffbf,%eax
80102cfd:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d05:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d0a:	0f b6 00             	movzbl (%eax),%eax
80102d0d:	0f b6 d0             	movzbl %al,%edx
80102d10:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d15:	09 d0                	or     %edx,%eax
80102d17:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d1f:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102d24:	0f b6 00             	movzbl (%eax),%eax
80102d27:	0f b6 d0             	movzbl %al,%edx
80102d2a:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d2f:	31 d0                	xor    %edx,%eax
80102d31:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d36:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d3b:	83 e0 03             	and    $0x3,%eax
80102d3e:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d48:	01 d0                	add    %edx,%eax
80102d4a:	0f b6 00             	movzbl (%eax),%eax
80102d4d:	0f b6 c0             	movzbl %al,%eax
80102d50:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d53:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
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
80102dee:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102df3:	8b 55 08             	mov    0x8(%ebp),%edx
80102df6:	c1 e2 02             	shl    $0x2,%edx
80102df9:	01 c2                	add    %eax,%edx
80102dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dfe:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e00:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102e10:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102e83:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102f05:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102f3f:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102f44:	8d 50 01             	lea    0x1(%eax),%edx
80102f47:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102f4d:	85 c0                	test   %eax,%eax
80102f4f:	75 14                	jne    80102f65 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f51:	8b 45 04             	mov    0x4(%ebp),%eax
80102f54:	83 ec 08             	sub    $0x8,%esp
80102f57:	50                   	push   %eax
80102f58:	68 e8 8e 10 80       	push   $0x80108ee8
80102f5d:	e8 64 d4 ff ff       	call   801003c6 <cprintf>
80102f62:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102f65:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	74 0f                	je     80102f7d <cpunum+0x52>
    return lapic[ID]>>24;
80102f6e:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102f87:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80103183:	e8 ee 23 00 00       	call   80105576 <memcmp>
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
80103297:	68 14 8f 10 80       	push   $0x80108f14
8010329c:	68 80 32 11 80       	push   $0x80113280
801032a1:	e8 e4 1f 00 00       	call   8010528a <initlock>
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
801032c4:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
801032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032cc:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = ROOTDEV;
801032d1:	c7 05 c4 32 11 80 01 	movl   $0x1,0x801132c4
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
801032f5:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
801032fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032fe:	01 d0                	add    %edx,%eax
80103300:	83 c0 01             	add    $0x1,%eax
80103303:	89 c2                	mov    %eax,%edx
80103305:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010330a:	83 ec 08             	sub    $0x8,%esp
8010330d:	52                   	push   %edx
8010330e:	50                   	push   %eax
8010330f:	e8 a2 ce ff ff       	call   801001b6 <bread>
80103314:	83 c4 10             	add    $0x10,%esp
80103317:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010331d:	83 c0 10             	add    $0x10,%eax
80103320:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103327:	89 c2                	mov    %eax,%edx
80103329:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
80103354:	e8 75 22 00 00       	call   801055ce <memmove>
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
8010338a:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
801033a1:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801033a6:	89 c2                	mov    %eax,%edx
801033a8:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
801033cb:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
801033d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033d7:	eb 1b                	jmp    801033f4 <read_head+0x59>
    log.lh.sector[i] = lh->sector[i];
801033d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033df:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801033e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033e6:	83 c2 10             	add    $0x10,%edx
801033e9:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801033f0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033f4:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
80103415:	a1 b4 32 11 80       	mov    0x801132b4,%eax
8010341a:	89 c2                	mov    %eax,%edx
8010341c:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
8010343a:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
80103440:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103443:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010344c:	eb 1b                	jmp    80103469 <write_head+0x5a>
    hb->sector[i] = log.lh.sector[i];
8010344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103451:	83 c0 10             	add    $0x10,%eax
80103454:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
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
80103469:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
801034a2:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
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
801034bd:	68 80 32 11 80       	push   $0x80113280
801034c2:	e8 e5 1d 00 00       	call   801052ac <acquire>
801034c7:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801034ca:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801034cf:	85 c0                	test   %eax,%eax
801034d1:	74 17                	je     801034ea <begin_op+0x36>
      sleep(&log, &log.lock);
801034d3:	83 ec 08             	sub    $0x8,%esp
801034d6:	68 80 32 11 80       	push   $0x80113280
801034db:	68 80 32 11 80       	push   $0x80113280
801034e0:	e8 5e 19 00 00       	call   80104e43 <sleep>
801034e5:	83 c4 10             	add    $0x10,%esp
801034e8:	eb e0                	jmp    801034ca <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034ea:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
801034f0:	a1 bc 32 11 80       	mov    0x801132bc,%eax
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
8010350b:	68 80 32 11 80       	push   $0x80113280
80103510:	68 80 32 11 80       	push   $0x80113280
80103515:	e8 29 19 00 00       	call   80104e43 <sleep>
8010351a:	83 c4 10             	add    $0x10,%esp
8010351d:	eb ab                	jmp    801034ca <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010351f:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103524:	83 c0 01             	add    $0x1,%eax
80103527:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
8010352c:	83 ec 0c             	sub    $0xc,%esp
8010352f:	68 80 32 11 80       	push   $0x80113280
80103534:	e8 da 1d 00 00       	call   80105313 <release>
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
80103550:	68 80 32 11 80       	push   $0x80113280
80103555:	e8 52 1d 00 00       	call   801052ac <acquire>
8010355a:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010355d:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103562:	83 e8 01             	sub    $0x1,%eax
80103565:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
8010356a:	a1 c0 32 11 80       	mov    0x801132c0,%eax
8010356f:	85 c0                	test   %eax,%eax
80103571:	74 0d                	je     80103580 <end_op+0x40>
    panic("log.committing");
80103573:	83 ec 0c             	sub    $0xc,%esp
80103576:	68 18 8f 10 80       	push   $0x80108f18
8010357b:	e8 e6 cf ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103580:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103585:	85 c0                	test   %eax,%eax
80103587:	75 13                	jne    8010359c <end_op+0x5c>
    do_commit = 1;
80103589:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103590:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
80103597:	00 00 00 
8010359a:	eb 10                	jmp    801035ac <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010359c:	83 ec 0c             	sub    $0xc,%esp
8010359f:	68 80 32 11 80       	push   $0x80113280
801035a4:	e8 88 19 00 00       	call   80104f31 <wakeup>
801035a9:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801035ac:	83 ec 0c             	sub    $0xc,%esp
801035af:	68 80 32 11 80       	push   $0x80113280
801035b4:	e8 5a 1d 00 00       	call   80105313 <release>
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
801035ca:	68 80 32 11 80       	push   $0x80113280
801035cf:	e8 d8 1c 00 00       	call   801052ac <acquire>
801035d4:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801035d7:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
801035de:	00 00 00 
    wakeup(&log);
801035e1:	83 ec 0c             	sub    $0xc,%esp
801035e4:	68 80 32 11 80       	push   $0x80113280
801035e9:	e8 43 19 00 00       	call   80104f31 <wakeup>
801035ee:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801035f1:	83 ec 0c             	sub    $0xc,%esp
801035f4:	68 80 32 11 80       	push   $0x80113280
801035f9:	e8 15 1d 00 00       	call   80105313 <release>
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
80103616:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010361c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010361f:	01 d0                	add    %edx,%eax
80103621:	83 c0 01             	add    $0x1,%eax
80103624:	89 c2                	mov    %eax,%edx
80103626:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010362b:	83 ec 08             	sub    $0x8,%esp
8010362e:	52                   	push   %edx
8010362f:	50                   	push   %eax
80103630:	e8 81 cb ff ff       	call   801001b6 <bread>
80103635:	83 c4 10             	add    $0x10,%esp
80103638:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
8010363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010363e:	83 c0 10             	add    $0x10,%eax
80103641:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103648:	89 c2                	mov    %eax,%edx
8010364a:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
80103675:	e8 54 1f 00 00       	call   801055ce <memmove>
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
801036ab:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
801036c2:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036c7:	85 c0                	test   %eax,%eax
801036c9:	7e 1e                	jle    801036e9 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801036cb:	e8 34 ff ff ff       	call   80103604 <write_log>
    write_head();    // Write header to disk -- the real commit
801036d0:	e8 3a fd ff ff       	call   8010340f <write_head>
    install_trans(); // Now install writes to home locations
801036d5:	e8 09 fc ff ff       	call   801032e3 <install_trans>
    log.lh.n = 0; 
801036da:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
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
801036f2:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036f7:	83 f8 1d             	cmp    $0x1d,%eax
801036fa:	7f 12                	jg     8010370e <log_write+0x22>
801036fc:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103701:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
80103707:	83 ea 01             	sub    $0x1,%edx
8010370a:	39 d0                	cmp    %edx,%eax
8010370c:	7c 0d                	jl     8010371b <log_write+0x2f>
    panic("too big a transaction");
8010370e:	83 ec 0c             	sub    $0xc,%esp
80103711:	68 27 8f 10 80       	push   $0x80108f27
80103716:	e8 4b ce ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010371b:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103720:	85 c0                	test   %eax,%eax
80103722:	7f 0d                	jg     80103731 <log_write+0x45>
    panic("log_write outside of trans");
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 3d 8f 10 80       	push   $0x80108f3d
8010372c:	e8 35 ce ff ff       	call   80100566 <panic>

  for (i = 0; i < log.lh.n; i++) {
80103731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103738:	eb 1d                	jmp    80103757 <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
8010373a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010373d:	83 c0 10             	add    $0x10,%eax
80103740:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
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
80103757:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
80103772:	89 14 85 8c 32 11 80 	mov    %edx,-0x7feecd74(,%eax,4)
  if (i == log.lh.n)
80103779:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010377e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103781:	75 0d                	jne    80103790 <log_write+0xa4>
    log.lh.n++;
80103783:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103788:	83 c0 01             	add    $0x1,%eax
8010378b:	a3 c8 32 11 80       	mov    %eax,0x801132c8
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
801037ef:	68 9c 65 21 80       	push   $0x8021659c
801037f4:	e8 95 f2 ff ff       	call   80102a8e <kinit1>
801037f9:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801037fc:	e8 b6 4a 00 00       	call   801082b7 <kvmalloc>
  mpinit();        // collect info about this machine
80103801:	e8 4d 04 00 00       	call   80103c53 <mpinit>
  lapicinit();
80103806:	e8 02 f6 ff ff       	call   80102e0d <lapicinit>
  seginit();       // set up segments
8010380b:	e8 50 44 00 00       	call   80107c60 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103810:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103816:	0f b6 00             	movzbl (%eax),%eax
80103819:	0f b6 c0             	movzbl %al,%eax
8010381c:	83 ec 08             	sub    $0x8,%esp
8010381f:	50                   	push   %eax
80103820:	68 58 8f 10 80       	push   $0x80108f58
80103825:	e8 9c cb ff ff       	call   801003c6 <cprintf>
8010382a:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010382d:	e8 77 06 00 00       	call   80103ea9 <picinit>
  ioapicinit();    // another interrupt controller
80103832:	e8 4c f1 ff ff       	call   80102983 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103837:	e8 ad d2 ff ff       	call   80100ae9 <consoleinit>
  uartinit();      // serial port
8010383c:	e8 5d 37 00 00       	call   80106f9e <uartinit>
  pinit();         // process table
80103841:	e8 60 0b 00 00       	call   801043a6 <pinit>
  init_pte_lookup_lock(); // pte_lookup lock
80103846:	e8 f7 43 00 00       	call   80107c42 <init_pte_lookup_lock>
  tvinit();        // trap vectors
8010384b:	e8 4c 32 00 00       	call   80106a9c <tvinit>
  binit();         // buffer cache
80103850:	e8 df c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103855:	e8 00 d7 ff ff       	call   80100f5a <fileinit>
  iinit();         // inode cache
8010385a:	e8 d9 dd ff ff       	call   80101638 <iinit>
  ideinit();       // disk
8010385f:	e8 63 ed ff ff       	call   801025c7 <ideinit>
  if(!ismp)
80103864:	a1 64 33 11 80       	mov    0x80113364,%eax
80103869:	85 c0                	test   %eax,%eax
8010386b:	75 05                	jne    80103872 <main+0x9c>
    timerinit();   // uniprocessor timer
8010386d:	e8 87 31 00 00       	call   801069f9 <timerinit>
  startothers();   // start other processors
80103872:	e8 7f 00 00 00       	call   801038f6 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103877:	83 ec 08             	sub    $0x8,%esp
8010387a:	68 00 00 00 8e       	push   $0x8e000000
8010387f:	68 00 00 40 80       	push   $0x80400000
80103884:	e8 3e f2 ff ff       	call   80102ac7 <kinit2>
80103889:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
8010388c:	e8 63 0c 00 00       	call   801044f4 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103891:	e8 1a 00 00 00       	call   801038b0 <mpmain>

80103896 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103896:	55                   	push   %ebp
80103897:	89 e5                	mov    %esp,%ebp
80103899:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010389c:	e8 2e 4a 00 00       	call   801082cf <switchkvm>
  seginit();
801038a1:	e8 ba 43 00 00       	call   80107c60 <seginit>
  lapicinit();
801038a6:	e8 62 f5 ff ff       	call   80102e0d <lapicinit>
  mpmain();
801038ab:	e8 00 00 00 00       	call   801038b0 <mpmain>

801038b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801038b6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038bc:	0f b6 00             	movzbl (%eax),%eax
801038bf:	0f b6 c0             	movzbl %al,%eax
801038c2:	83 ec 08             	sub    $0x8,%esp
801038c5:	50                   	push   %eax
801038c6:	68 6f 8f 10 80       	push   $0x80108f6f
801038cb:	e8 f6 ca ff ff       	call   801003c6 <cprintf>
801038d0:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801038d3:	e8 3a 33 00 00       	call   80106c12 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801038d8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038de:	05 a8 00 00 00       	add    $0xa8,%eax
801038e3:	83 ec 08             	sub    $0x8,%esp
801038e6:	6a 01                	push   $0x1
801038e8:	50                   	push   %eax
801038e9:	e8 ce fe ff ff       	call   801037bc <xchg>
801038ee:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801038f1:	e8 7d 13 00 00       	call   80104c73 <scheduler>

801038f6 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801038f6:	55                   	push   %ebp
801038f7:	89 e5                	mov    %esp,%ebp
801038f9:	53                   	push   %ebx
801038fa:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801038fd:	68 00 70 00 00       	push   $0x7000
80103902:	e8 a8 fe ff ff       	call   801037af <p2v>
80103907:	83 c4 04             	add    $0x4,%esp
8010390a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010390d:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103912:	83 ec 04             	sub    $0x4,%esp
80103915:	50                   	push   %eax
80103916:	68 2c c5 10 80       	push   $0x8010c52c
8010391b:	ff 75 f0             	pushl  -0x10(%ebp)
8010391e:	e8 ab 1c 00 00       	call   801055ce <memmove>
80103923:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103926:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
8010392d:	e9 90 00 00 00       	jmp    801039c2 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103932:	e8 f4 f5 ff ff       	call   80102f2b <cpunum>
80103937:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010393d:	05 80 33 11 80       	add    $0x80113380,%eax
80103942:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103945:	74 73                	je     801039ba <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103947:	e8 79 f2 ff ff       	call   80102bc5 <kalloc>
8010394c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010394f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103952:	83 e8 04             	sub    $0x4,%eax
80103955:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103958:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010395e:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103963:	83 e8 08             	sub    $0x8,%eax
80103966:	c7 00 96 38 10 80    	movl   $0x80103896,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
8010396c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010396f:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103972:	83 ec 0c             	sub    $0xc,%esp
80103975:	68 00 b0 10 80       	push   $0x8010b000
8010397a:	e8 23 fe ff ff       	call   801037a2 <v2p>
8010397f:	83 c4 10             	add    $0x10,%esp
80103982:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103984:	83 ec 0c             	sub    $0xc,%esp
80103987:	ff 75 f0             	pushl  -0x10(%ebp)
8010398a:	e8 13 fe ff ff       	call   801037a2 <v2p>
8010398f:	83 c4 10             	add    $0x10,%esp
80103992:	89 c2                	mov    %eax,%edx
80103994:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103997:	0f b6 00             	movzbl (%eax),%eax
8010399a:	0f b6 c0             	movzbl %al,%eax
8010399d:	83 ec 08             	sub    $0x8,%esp
801039a0:	52                   	push   %edx
801039a1:	50                   	push   %eax
801039a2:	e8 fe f5 ff ff       	call   80102fa5 <lapicstartap>
801039a7:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039aa:	90                   	nop
801039ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ae:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801039b4:	85 c0                	test   %eax,%eax
801039b6:	74 f3                	je     801039ab <startothers+0xb5>
801039b8:	eb 01                	jmp    801039bb <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801039ba:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801039bb:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801039c2:	a1 60 39 11 80       	mov    0x80113960,%eax
801039c7:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039cd:	05 80 33 11 80       	add    $0x80113380,%eax
801039d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039d5:	0f 87 57 ff ff ff    	ja     80103932 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801039db:	90                   	nop
801039dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039df:	c9                   	leave  
801039e0:	c3                   	ret    

801039e1 <p2v>:
801039e1:	55                   	push   %ebp
801039e2:	89 e5                	mov    %esp,%ebp
801039e4:	8b 45 08             	mov    0x8(%ebp),%eax
801039e7:	05 00 00 00 80       	add    $0x80000000,%eax
801039ec:	5d                   	pop    %ebp
801039ed:	c3                   	ret    

801039ee <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039ee:	55                   	push   %ebp
801039ef:	89 e5                	mov    %esp,%ebp
801039f1:	83 ec 14             	sub    $0x14,%esp
801039f4:	8b 45 08             	mov    0x8(%ebp),%eax
801039f7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039fb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801039ff:	89 c2                	mov    %eax,%edx
80103a01:	ec                   	in     (%dx),%al
80103a02:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a05:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a09:	c9                   	leave  
80103a0a:	c3                   	ret    

80103a0b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a0b:	55                   	push   %ebp
80103a0c:	89 e5                	mov    %esp,%ebp
80103a0e:	83 ec 08             	sub    $0x8,%esp
80103a11:	8b 55 08             	mov    0x8(%ebp),%edx
80103a14:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a17:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a1b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a1e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a22:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a26:	ee                   	out    %al,(%dx)
}
80103a27:	90                   	nop
80103a28:	c9                   	leave  
80103a29:	c3                   	ret    

80103a2a <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a2a:	55                   	push   %ebp
80103a2b:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a2d:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103a32:	89 c2                	mov    %eax,%edx
80103a34:	b8 80 33 11 80       	mov    $0x80113380,%eax
80103a39:	29 c2                	sub    %eax,%edx
80103a3b:	89 d0                	mov    %edx,%eax
80103a3d:	c1 f8 02             	sar    $0x2,%eax
80103a40:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a46:	5d                   	pop    %ebp
80103a47:	c3                   	ret    

80103a48 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a48:	55                   	push   %ebp
80103a49:	89 e5                	mov    %esp,%ebp
80103a4b:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a4e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a5c:	eb 15                	jmp    80103a73 <sum+0x2b>
    sum += addr[i];
80103a5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a61:	8b 45 08             	mov    0x8(%ebp),%eax
80103a64:	01 d0                	add    %edx,%eax
80103a66:	0f b6 00             	movzbl (%eax),%eax
80103a69:	0f b6 c0             	movzbl %al,%eax
80103a6c:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103a6f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a73:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a76:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a79:	7c e3                	jl     80103a5e <sum+0x16>
    sum += addr[i];
  return sum;
80103a7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a7e:	c9                   	leave  
80103a7f:	c3                   	ret    

80103a80 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103a86:	ff 75 08             	pushl  0x8(%ebp)
80103a89:	e8 53 ff ff ff       	call   801039e1 <p2v>
80103a8e:	83 c4 04             	add    $0x4,%esp
80103a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a94:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a9a:	01 d0                	add    %edx,%eax
80103a9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aa5:	eb 36                	jmp    80103add <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103aa7:	83 ec 04             	sub    $0x4,%esp
80103aaa:	6a 04                	push   $0x4
80103aac:	68 80 8f 10 80       	push   $0x80108f80
80103ab1:	ff 75 f4             	pushl  -0xc(%ebp)
80103ab4:	e8 bd 1a 00 00       	call   80105576 <memcmp>
80103ab9:	83 c4 10             	add    $0x10,%esp
80103abc:	85 c0                	test   %eax,%eax
80103abe:	75 19                	jne    80103ad9 <mpsearch1+0x59>
80103ac0:	83 ec 08             	sub    $0x8,%esp
80103ac3:	6a 10                	push   $0x10
80103ac5:	ff 75 f4             	pushl  -0xc(%ebp)
80103ac8:	e8 7b ff ff ff       	call   80103a48 <sum>
80103acd:	83 c4 10             	add    $0x10,%esp
80103ad0:	84 c0                	test   %al,%al
80103ad2:	75 05                	jne    80103ad9 <mpsearch1+0x59>
      return (struct mp*)p;
80103ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ad7:	eb 11                	jmp    80103aea <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103ad9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ae3:	72 c2                	jb     80103aa7 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103ae5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103aea:	c9                   	leave  
80103aeb:	c3                   	ret    

80103aec <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103aec:	55                   	push   %ebp
80103aed:	89 e5                	mov    %esp,%ebp
80103aef:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103af2:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103afc:	83 c0 0f             	add    $0xf,%eax
80103aff:	0f b6 00             	movzbl (%eax),%eax
80103b02:	0f b6 c0             	movzbl %al,%eax
80103b05:	c1 e0 08             	shl    $0x8,%eax
80103b08:	89 c2                	mov    %eax,%edx
80103b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b0d:	83 c0 0e             	add    $0xe,%eax
80103b10:	0f b6 00             	movzbl (%eax),%eax
80103b13:	0f b6 c0             	movzbl %al,%eax
80103b16:	09 d0                	or     %edx,%eax
80103b18:	c1 e0 04             	shl    $0x4,%eax
80103b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b22:	74 21                	je     80103b45 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b24:	83 ec 08             	sub    $0x8,%esp
80103b27:	68 00 04 00 00       	push   $0x400
80103b2c:	ff 75 f0             	pushl  -0x10(%ebp)
80103b2f:	e8 4c ff ff ff       	call   80103a80 <mpsearch1>
80103b34:	83 c4 10             	add    $0x10,%esp
80103b37:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b3e:	74 51                	je     80103b91 <mpsearch+0xa5>
      return mp;
80103b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b43:	eb 61                	jmp    80103ba6 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b48:	83 c0 14             	add    $0x14,%eax
80103b4b:	0f b6 00             	movzbl (%eax),%eax
80103b4e:	0f b6 c0             	movzbl %al,%eax
80103b51:	c1 e0 08             	shl    $0x8,%eax
80103b54:	89 c2                	mov    %eax,%edx
80103b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b59:	83 c0 13             	add    $0x13,%eax
80103b5c:	0f b6 00             	movzbl (%eax),%eax
80103b5f:	0f b6 c0             	movzbl %al,%eax
80103b62:	09 d0                	or     %edx,%eax
80103b64:	c1 e0 0a             	shl    $0xa,%eax
80103b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b6d:	2d 00 04 00 00       	sub    $0x400,%eax
80103b72:	83 ec 08             	sub    $0x8,%esp
80103b75:	68 00 04 00 00       	push   $0x400
80103b7a:	50                   	push   %eax
80103b7b:	e8 00 ff ff ff       	call   80103a80 <mpsearch1>
80103b80:	83 c4 10             	add    $0x10,%esp
80103b83:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b86:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b8a:	74 05                	je     80103b91 <mpsearch+0xa5>
      return mp;
80103b8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b8f:	eb 15                	jmp    80103ba6 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b91:	83 ec 08             	sub    $0x8,%esp
80103b94:	68 00 00 01 00       	push   $0x10000
80103b99:	68 00 00 0f 00       	push   $0xf0000
80103b9e:	e8 dd fe ff ff       	call   80103a80 <mpsearch1>
80103ba3:	83 c4 10             	add    $0x10,%esp
}
80103ba6:	c9                   	leave  
80103ba7:	c3                   	ret    

80103ba8 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ba8:	55                   	push   %ebp
80103ba9:	89 e5                	mov    %esp,%ebp
80103bab:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bae:	e8 39 ff ff ff       	call   80103aec <mpsearch>
80103bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bba:	74 0a                	je     80103bc6 <mpconfig+0x1e>
80103bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbf:	8b 40 04             	mov    0x4(%eax),%eax
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	75 0a                	jne    80103bd0 <mpconfig+0x28>
    return 0;
80103bc6:	b8 00 00 00 00       	mov    $0x0,%eax
80103bcb:	e9 81 00 00 00       	jmp    80103c51 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd3:	8b 40 04             	mov    0x4(%eax),%eax
80103bd6:	83 ec 0c             	sub    $0xc,%esp
80103bd9:	50                   	push   %eax
80103bda:	e8 02 fe ff ff       	call   801039e1 <p2v>
80103bdf:	83 c4 10             	add    $0x10,%esp
80103be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103be5:	83 ec 04             	sub    $0x4,%esp
80103be8:	6a 04                	push   $0x4
80103bea:	68 85 8f 10 80       	push   $0x80108f85
80103bef:	ff 75 f0             	pushl  -0x10(%ebp)
80103bf2:	e8 7f 19 00 00       	call   80105576 <memcmp>
80103bf7:	83 c4 10             	add    $0x10,%esp
80103bfa:	85 c0                	test   %eax,%eax
80103bfc:	74 07                	je     80103c05 <mpconfig+0x5d>
    return 0;
80103bfe:	b8 00 00 00 00       	mov    $0x0,%eax
80103c03:	eb 4c                	jmp    80103c51 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c08:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c0c:	3c 01                	cmp    $0x1,%al
80103c0e:	74 12                	je     80103c22 <mpconfig+0x7a>
80103c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c13:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c17:	3c 04                	cmp    $0x4,%al
80103c19:	74 07                	je     80103c22 <mpconfig+0x7a>
    return 0;
80103c1b:	b8 00 00 00 00       	mov    $0x0,%eax
80103c20:	eb 2f                	jmp    80103c51 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c25:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c29:	0f b7 c0             	movzwl %ax,%eax
80103c2c:	83 ec 08             	sub    $0x8,%esp
80103c2f:	50                   	push   %eax
80103c30:	ff 75 f0             	pushl  -0x10(%ebp)
80103c33:	e8 10 fe ff ff       	call   80103a48 <sum>
80103c38:	83 c4 10             	add    $0x10,%esp
80103c3b:	84 c0                	test   %al,%al
80103c3d:	74 07                	je     80103c46 <mpconfig+0x9e>
    return 0;
80103c3f:	b8 00 00 00 00       	mov    $0x0,%eax
80103c44:	eb 0b                	jmp    80103c51 <mpconfig+0xa9>
  *pmp = mp;
80103c46:	8b 45 08             	mov    0x8(%ebp),%eax
80103c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c4c:	89 10                	mov    %edx,(%eax)
  return conf;
80103c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c51:	c9                   	leave  
80103c52:	c3                   	ret    

80103c53 <mpinit>:

void
mpinit(void)
{
80103c53:	55                   	push   %ebp
80103c54:	89 e5                	mov    %esp,%ebp
80103c56:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c59:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103c60:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c63:	83 ec 0c             	sub    $0xc,%esp
80103c66:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c69:	50                   	push   %eax
80103c6a:	e8 39 ff ff ff       	call   80103ba8 <mpconfig>
80103c6f:	83 c4 10             	add    $0x10,%esp
80103c72:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c79:	0f 84 96 01 00 00    	je     80103e15 <mpinit+0x1c2>
    return;
  ismp = 1;
80103c7f:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103c86:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c8c:	8b 40 24             	mov    0x24(%eax),%eax
80103c8f:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c97:	83 c0 2c             	add    $0x2c,%eax
80103c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca0:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103ca4:	0f b7 d0             	movzwl %ax,%edx
80103ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103caa:	01 d0                	add    %edx,%eax
80103cac:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103caf:	e9 f2 00 00 00       	jmp    80103da6 <mpinit+0x153>
    switch(*p){
80103cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb7:	0f b6 00             	movzbl (%eax),%eax
80103cba:	0f b6 c0             	movzbl %al,%eax
80103cbd:	83 f8 04             	cmp    $0x4,%eax
80103cc0:	0f 87 bc 00 00 00    	ja     80103d82 <mpinit+0x12f>
80103cc6:	8b 04 85 c8 8f 10 80 	mov    -0x7fef7038(,%eax,4),%eax
80103ccd:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cd8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cdc:	0f b6 d0             	movzbl %al,%edx
80103cdf:	a1 60 39 11 80       	mov    0x80113960,%eax
80103ce4:	39 c2                	cmp    %eax,%edx
80103ce6:	74 2b                	je     80103d13 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103ce8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ceb:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cef:	0f b6 d0             	movzbl %al,%edx
80103cf2:	a1 60 39 11 80       	mov    0x80113960,%eax
80103cf7:	83 ec 04             	sub    $0x4,%esp
80103cfa:	52                   	push   %edx
80103cfb:	50                   	push   %eax
80103cfc:	68 8a 8f 10 80       	push   $0x80108f8a
80103d01:	e8 c0 c6 ff ff       	call   801003c6 <cprintf>
80103d06:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103d09:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103d10:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103d13:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d16:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103d1a:	0f b6 c0             	movzbl %al,%eax
80103d1d:	83 e0 02             	and    $0x2,%eax
80103d20:	85 c0                	test   %eax,%eax
80103d22:	74 15                	je     80103d39 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103d24:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d29:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d2f:	05 80 33 11 80       	add    $0x80113380,%eax
80103d34:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103d39:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d3e:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103d44:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d4a:	05 80 33 11 80       	add    $0x80113380,%eax
80103d4f:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103d51:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d56:	83 c0 01             	add    $0x1,%eax
80103d59:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103d5e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d62:	eb 42                	jmp    80103da6 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103d6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d6d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d71:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103d76:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d7a:	eb 2a                	jmp    80103da6 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d7c:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d80:	eb 24                	jmp    80103da6 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d85:	0f b6 00             	movzbl (%eax),%eax
80103d88:	0f b6 c0             	movzbl %al,%eax
80103d8b:	83 ec 08             	sub    $0x8,%esp
80103d8e:	50                   	push   %eax
80103d8f:	68 a8 8f 10 80       	push   $0x80108fa8
80103d94:	e8 2d c6 ff ff       	call   801003c6 <cprintf>
80103d99:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103d9c:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103da3:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103da9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103dac:	0f 82 02 ff ff ff    	jb     80103cb4 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103db2:	a1 64 33 11 80       	mov    0x80113364,%eax
80103db7:	85 c0                	test   %eax,%eax
80103db9:	75 1d                	jne    80103dd8 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103dbb:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103dc2:	00 00 00 
    lapic = 0;
80103dc5:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103dcc:	00 00 00 
    ioapicid = 0;
80103dcf:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
    return;
80103dd6:	eb 3e                	jmp    80103e16 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ddb:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103ddf:	84 c0                	test   %al,%al
80103de1:	74 33                	je     80103e16 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103de3:	83 ec 08             	sub    $0x8,%esp
80103de6:	6a 70                	push   $0x70
80103de8:	6a 22                	push   $0x22
80103dea:	e8 1c fc ff ff       	call   80103a0b <outb>
80103def:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103df2:	83 ec 0c             	sub    $0xc,%esp
80103df5:	6a 23                	push   $0x23
80103df7:	e8 f2 fb ff ff       	call   801039ee <inb>
80103dfc:	83 c4 10             	add    $0x10,%esp
80103dff:	83 c8 01             	or     $0x1,%eax
80103e02:	0f b6 c0             	movzbl %al,%eax
80103e05:	83 ec 08             	sub    $0x8,%esp
80103e08:	50                   	push   %eax
80103e09:	6a 23                	push   $0x23
80103e0b:	e8 fb fb ff ff       	call   80103a0b <outb>
80103e10:	83 c4 10             	add    $0x10,%esp
80103e13:	eb 01                	jmp    80103e16 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103e15:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103e16:	c9                   	leave  
80103e17:	c3                   	ret    

80103e18 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e18:	55                   	push   %ebp
80103e19:	89 e5                	mov    %esp,%ebp
80103e1b:	83 ec 08             	sub    $0x8,%esp
80103e1e:	8b 55 08             	mov    0x8(%ebp),%edx
80103e21:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e24:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e28:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e2b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e2f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e33:	ee                   	out    %al,(%dx)
}
80103e34:	90                   	nop
80103e35:	c9                   	leave  
80103e36:	c3                   	ret    

80103e37 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e37:	55                   	push   %ebp
80103e38:	89 e5                	mov    %esp,%ebp
80103e3a:	83 ec 04             	sub    $0x4,%esp
80103e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e40:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e44:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e48:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103e4e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e52:	0f b6 c0             	movzbl %al,%eax
80103e55:	50                   	push   %eax
80103e56:	6a 21                	push   $0x21
80103e58:	e8 bb ff ff ff       	call   80103e18 <outb>
80103e5d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103e60:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e64:	66 c1 e8 08          	shr    $0x8,%ax
80103e68:	0f b6 c0             	movzbl %al,%eax
80103e6b:	50                   	push   %eax
80103e6c:	68 a1 00 00 00       	push   $0xa1
80103e71:	e8 a2 ff ff ff       	call   80103e18 <outb>
80103e76:	83 c4 08             	add    $0x8,%esp
}
80103e79:	90                   	nop
80103e7a:	c9                   	leave  
80103e7b:	c3                   	ret    

80103e7c <picenable>:

void
picenable(int irq)
{
80103e7c:	55                   	push   %ebp
80103e7d:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e82:	ba 01 00 00 00       	mov    $0x1,%edx
80103e87:	89 c1                	mov    %eax,%ecx
80103e89:	d3 e2                	shl    %cl,%edx
80103e8b:	89 d0                	mov    %edx,%eax
80103e8d:	f7 d0                	not    %eax
80103e8f:	89 c2                	mov    %eax,%edx
80103e91:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103e98:	21 d0                	and    %edx,%eax
80103e9a:	0f b7 c0             	movzwl %ax,%eax
80103e9d:	50                   	push   %eax
80103e9e:	e8 94 ff ff ff       	call   80103e37 <picsetmask>
80103ea3:	83 c4 04             	add    $0x4,%esp
}
80103ea6:	90                   	nop
80103ea7:	c9                   	leave  
80103ea8:	c3                   	ret    

80103ea9 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ea9:	55                   	push   %ebp
80103eaa:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103eac:	68 ff 00 00 00       	push   $0xff
80103eb1:	6a 21                	push   $0x21
80103eb3:	e8 60 ff ff ff       	call   80103e18 <outb>
80103eb8:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103ebb:	68 ff 00 00 00       	push   $0xff
80103ec0:	68 a1 00 00 00       	push   $0xa1
80103ec5:	e8 4e ff ff ff       	call   80103e18 <outb>
80103eca:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ecd:	6a 11                	push   $0x11
80103ecf:	6a 20                	push   $0x20
80103ed1:	e8 42 ff ff ff       	call   80103e18 <outb>
80103ed6:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103ed9:	6a 20                	push   $0x20
80103edb:	6a 21                	push   $0x21
80103edd:	e8 36 ff ff ff       	call   80103e18 <outb>
80103ee2:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103ee5:	6a 04                	push   $0x4
80103ee7:	6a 21                	push   $0x21
80103ee9:	e8 2a ff ff ff       	call   80103e18 <outb>
80103eee:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103ef1:	6a 03                	push   $0x3
80103ef3:	6a 21                	push   $0x21
80103ef5:	e8 1e ff ff ff       	call   80103e18 <outb>
80103efa:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103efd:	6a 11                	push   $0x11
80103eff:	68 a0 00 00 00       	push   $0xa0
80103f04:	e8 0f ff ff ff       	call   80103e18 <outb>
80103f09:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f0c:	6a 28                	push   $0x28
80103f0e:	68 a1 00 00 00       	push   $0xa1
80103f13:	e8 00 ff ff ff       	call   80103e18 <outb>
80103f18:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f1b:	6a 02                	push   $0x2
80103f1d:	68 a1 00 00 00       	push   $0xa1
80103f22:	e8 f1 fe ff ff       	call   80103e18 <outb>
80103f27:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f2a:	6a 03                	push   $0x3
80103f2c:	68 a1 00 00 00       	push   $0xa1
80103f31:	e8 e2 fe ff ff       	call   80103e18 <outb>
80103f36:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f39:	6a 68                	push   $0x68
80103f3b:	6a 20                	push   $0x20
80103f3d:	e8 d6 fe ff ff       	call   80103e18 <outb>
80103f42:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f45:	6a 0a                	push   $0xa
80103f47:	6a 20                	push   $0x20
80103f49:	e8 ca fe ff ff       	call   80103e18 <outb>
80103f4e:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103f51:	6a 68                	push   $0x68
80103f53:	68 a0 00 00 00       	push   $0xa0
80103f58:	e8 bb fe ff ff       	call   80103e18 <outb>
80103f5d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103f60:	6a 0a                	push   $0xa
80103f62:	68 a0 00 00 00       	push   $0xa0
80103f67:	e8 ac fe ff ff       	call   80103e18 <outb>
80103f6c:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103f6f:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f76:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f7a:	74 13                	je     80103f8f <picinit+0xe6>
    picsetmask(irqmask);
80103f7c:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f83:	0f b7 c0             	movzwl %ax,%eax
80103f86:	50                   	push   %eax
80103f87:	e8 ab fe ff ff       	call   80103e37 <picsetmask>
80103f8c:	83 c4 04             	add    $0x4,%esp
}
80103f8f:	90                   	nop
80103f90:	c9                   	leave  
80103f91:	c3                   	ret    

80103f92 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f92:	55                   	push   %ebp
80103f93:	89 e5                	mov    %esp,%ebp
80103f95:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103f98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fab:	8b 10                	mov    (%eax),%edx
80103fad:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb0:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103fb2:	e8 c1 cf ff ff       	call   80100f78 <filealloc>
80103fb7:	89 c2                	mov    %eax,%edx
80103fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80103fbc:	89 10                	mov    %edx,(%eax)
80103fbe:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc1:	8b 00                	mov    (%eax),%eax
80103fc3:	85 c0                	test   %eax,%eax
80103fc5:	0f 84 cb 00 00 00    	je     80104096 <pipealloc+0x104>
80103fcb:	e8 a8 cf ff ff       	call   80100f78 <filealloc>
80103fd0:	89 c2                	mov    %eax,%edx
80103fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fd5:	89 10                	mov    %edx,(%eax)
80103fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fda:	8b 00                	mov    (%eax),%eax
80103fdc:	85 c0                	test   %eax,%eax
80103fde:	0f 84 b2 00 00 00    	je     80104096 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103fe4:	e8 dc eb ff ff       	call   80102bc5 <kalloc>
80103fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ff0:	0f 84 9f 00 00 00    	je     80104095 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80103ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ff9:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104000:	00 00 00 
  p->writeopen = 1;
80104003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104006:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010400d:	00 00 00 
  p->nwrite = 0;
80104010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104013:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010401a:	00 00 00 
  p->nread = 0;
8010401d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104020:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104027:	00 00 00 
  initlock(&p->lock, "pipe");
8010402a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010402d:	83 ec 08             	sub    $0x8,%esp
80104030:	68 dc 8f 10 80       	push   $0x80108fdc
80104035:	50                   	push   %eax
80104036:	e8 4f 12 00 00       	call   8010528a <initlock>
8010403b:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010403e:	8b 45 08             	mov    0x8(%ebp),%eax
80104041:	8b 00                	mov    (%eax),%eax
80104043:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104049:	8b 45 08             	mov    0x8(%ebp),%eax
8010404c:	8b 00                	mov    (%eax),%eax
8010404e:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104052:	8b 45 08             	mov    0x8(%ebp),%eax
80104055:	8b 00                	mov    (%eax),%eax
80104057:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010405b:	8b 45 08             	mov    0x8(%ebp),%eax
8010405e:	8b 00                	mov    (%eax),%eax
80104060:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104063:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104066:	8b 45 0c             	mov    0xc(%ebp),%eax
80104069:	8b 00                	mov    (%eax),%eax
8010406b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104071:	8b 45 0c             	mov    0xc(%ebp),%eax
80104074:	8b 00                	mov    (%eax),%eax
80104076:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010407a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010407d:	8b 00                	mov    (%eax),%eax
8010407f:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104083:	8b 45 0c             	mov    0xc(%ebp),%eax
80104086:	8b 00                	mov    (%eax),%eax
80104088:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010408b:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010408e:	b8 00 00 00 00       	mov    $0x0,%eax
80104093:	eb 4e                	jmp    801040e3 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104095:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80104096:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010409a:	74 0e                	je     801040aa <pipealloc+0x118>
    kfree((char*)p);
8010409c:	83 ec 0c             	sub    $0xc,%esp
8010409f:	ff 75 f4             	pushl  -0xc(%ebp)
801040a2:	e8 81 ea ff ff       	call   80102b28 <kfree>
801040a7:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040aa:	8b 45 08             	mov    0x8(%ebp),%eax
801040ad:	8b 00                	mov    (%eax),%eax
801040af:	85 c0                	test   %eax,%eax
801040b1:	74 11                	je     801040c4 <pipealloc+0x132>
    fileclose(*f0);
801040b3:	8b 45 08             	mov    0x8(%ebp),%eax
801040b6:	8b 00                	mov    (%eax),%eax
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	50                   	push   %eax
801040bc:	e8 75 cf ff ff       	call   80101036 <fileclose>
801040c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801040c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c7:	8b 00                	mov    (%eax),%eax
801040c9:	85 c0                	test   %eax,%eax
801040cb:	74 11                	je     801040de <pipealloc+0x14c>
    fileclose(*f1);
801040cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d0:	8b 00                	mov    (%eax),%eax
801040d2:	83 ec 0c             	sub    $0xc,%esp
801040d5:	50                   	push   %eax
801040d6:	e8 5b cf ff ff       	call   80101036 <fileclose>
801040db:	83 c4 10             	add    $0x10,%esp
  return -1;
801040de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040e3:	c9                   	leave  
801040e4:	c3                   	ret    

801040e5 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801040e5:	55                   	push   %ebp
801040e6:	89 e5                	mov    %esp,%ebp
801040e8:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801040eb:	8b 45 08             	mov    0x8(%ebp),%eax
801040ee:	83 ec 0c             	sub    $0xc,%esp
801040f1:	50                   	push   %eax
801040f2:	e8 b5 11 00 00       	call   801052ac <acquire>
801040f7:	83 c4 10             	add    $0x10,%esp
  if(writable){
801040fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801040fe:	74 23                	je     80104123 <pipeclose+0x3e>
    p->writeopen = 0;
80104100:	8b 45 08             	mov    0x8(%ebp),%eax
80104103:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010410a:	00 00 00 
    wakeup(&p->nread);
8010410d:	8b 45 08             	mov    0x8(%ebp),%eax
80104110:	05 34 02 00 00       	add    $0x234,%eax
80104115:	83 ec 0c             	sub    $0xc,%esp
80104118:	50                   	push   %eax
80104119:	e8 13 0e 00 00       	call   80104f31 <wakeup>
8010411e:	83 c4 10             	add    $0x10,%esp
80104121:	eb 21                	jmp    80104144 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104123:	8b 45 08             	mov    0x8(%ebp),%eax
80104126:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010412d:	00 00 00 
    wakeup(&p->nwrite);
80104130:	8b 45 08             	mov    0x8(%ebp),%eax
80104133:	05 38 02 00 00       	add    $0x238,%eax
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	50                   	push   %eax
8010413c:	e8 f0 0d 00 00       	call   80104f31 <wakeup>
80104141:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104144:	8b 45 08             	mov    0x8(%ebp),%eax
80104147:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010414d:	85 c0                	test   %eax,%eax
8010414f:	75 2c                	jne    8010417d <pipeclose+0x98>
80104151:	8b 45 08             	mov    0x8(%ebp),%eax
80104154:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010415a:	85 c0                	test   %eax,%eax
8010415c:	75 1f                	jne    8010417d <pipeclose+0x98>
    release(&p->lock);
8010415e:	8b 45 08             	mov    0x8(%ebp),%eax
80104161:	83 ec 0c             	sub    $0xc,%esp
80104164:	50                   	push   %eax
80104165:	e8 a9 11 00 00       	call   80105313 <release>
8010416a:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
8010416d:	83 ec 0c             	sub    $0xc,%esp
80104170:	ff 75 08             	pushl  0x8(%ebp)
80104173:	e8 b0 e9 ff ff       	call   80102b28 <kfree>
80104178:	83 c4 10             	add    $0x10,%esp
8010417b:	eb 0f                	jmp    8010418c <pipeclose+0xa7>
  } else
    release(&p->lock);
8010417d:	8b 45 08             	mov    0x8(%ebp),%eax
80104180:	83 ec 0c             	sub    $0xc,%esp
80104183:	50                   	push   %eax
80104184:	e8 8a 11 00 00       	call   80105313 <release>
80104189:	83 c4 10             	add    $0x10,%esp
}
8010418c:	90                   	nop
8010418d:	c9                   	leave  
8010418e:	c3                   	ret    

8010418f <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010418f:	55                   	push   %ebp
80104190:	89 e5                	mov    %esp,%ebp
80104192:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104195:	8b 45 08             	mov    0x8(%ebp),%eax
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	50                   	push   %eax
8010419c:	e8 0b 11 00 00       	call   801052ac <acquire>
801041a1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801041a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041ab:	e9 ad 00 00 00       	jmp    8010425d <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801041b0:	8b 45 08             	mov    0x8(%ebp),%eax
801041b3:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041b9:	85 c0                	test   %eax,%eax
801041bb:	74 0d                	je     801041ca <pipewrite+0x3b>
801041bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041c3:	8b 40 24             	mov    0x24(%eax),%eax
801041c6:	85 c0                	test   %eax,%eax
801041c8:	74 19                	je     801041e3 <pipewrite+0x54>
        release(&p->lock);
801041ca:	8b 45 08             	mov    0x8(%ebp),%eax
801041cd:	83 ec 0c             	sub    $0xc,%esp
801041d0:	50                   	push   %eax
801041d1:	e8 3d 11 00 00       	call   80105313 <release>
801041d6:	83 c4 10             	add    $0x10,%esp
        return -1;
801041d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041de:	e9 a8 00 00 00       	jmp    8010428b <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801041e3:	8b 45 08             	mov    0x8(%ebp),%eax
801041e6:	05 34 02 00 00       	add    $0x234,%eax
801041eb:	83 ec 0c             	sub    $0xc,%esp
801041ee:	50                   	push   %eax
801041ef:	e8 3d 0d 00 00       	call   80104f31 <wakeup>
801041f4:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801041f7:	8b 45 08             	mov    0x8(%ebp),%eax
801041fa:	8b 55 08             	mov    0x8(%ebp),%edx
801041fd:	81 c2 38 02 00 00    	add    $0x238,%edx
80104203:	83 ec 08             	sub    $0x8,%esp
80104206:	50                   	push   %eax
80104207:	52                   	push   %edx
80104208:	e8 36 0c 00 00       	call   80104e43 <sleep>
8010420d:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104210:	8b 45 08             	mov    0x8(%ebp),%eax
80104213:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104219:	8b 45 08             	mov    0x8(%ebp),%eax
8010421c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104222:	05 00 02 00 00       	add    $0x200,%eax
80104227:	39 c2                	cmp    %eax,%edx
80104229:	74 85                	je     801041b0 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010422b:	8b 45 08             	mov    0x8(%ebp),%eax
8010422e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104234:	8d 48 01             	lea    0x1(%eax),%ecx
80104237:	8b 55 08             	mov    0x8(%ebp),%edx
8010423a:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104240:	25 ff 01 00 00       	and    $0x1ff,%eax
80104245:	89 c1                	mov    %eax,%ecx
80104247:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010424a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010424d:	01 d0                	add    %edx,%eax
8010424f:	0f b6 10             	movzbl (%eax),%edx
80104252:	8b 45 08             	mov    0x8(%ebp),%eax
80104255:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104259:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010425d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104260:	3b 45 10             	cmp    0x10(%ebp),%eax
80104263:	7c ab                	jl     80104210 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104265:	8b 45 08             	mov    0x8(%ebp),%eax
80104268:	05 34 02 00 00       	add    $0x234,%eax
8010426d:	83 ec 0c             	sub    $0xc,%esp
80104270:	50                   	push   %eax
80104271:	e8 bb 0c 00 00       	call   80104f31 <wakeup>
80104276:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104279:	8b 45 08             	mov    0x8(%ebp),%eax
8010427c:	83 ec 0c             	sub    $0xc,%esp
8010427f:	50                   	push   %eax
80104280:	e8 8e 10 00 00       	call   80105313 <release>
80104285:	83 c4 10             	add    $0x10,%esp
  return n;
80104288:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010428b:	c9                   	leave  
8010428c:	c3                   	ret    

8010428d <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010428d:	55                   	push   %ebp
8010428e:	89 e5                	mov    %esp,%ebp
80104290:	53                   	push   %ebx
80104291:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104294:	8b 45 08             	mov    0x8(%ebp),%eax
80104297:	83 ec 0c             	sub    $0xc,%esp
8010429a:	50                   	push   %eax
8010429b:	e8 0c 10 00 00       	call   801052ac <acquire>
801042a0:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042a3:	eb 3f                	jmp    801042e4 <piperead+0x57>
    if(proc->killed){
801042a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042ab:	8b 40 24             	mov    0x24(%eax),%eax
801042ae:	85 c0                	test   %eax,%eax
801042b0:	74 19                	je     801042cb <piperead+0x3e>
      release(&p->lock);
801042b2:	8b 45 08             	mov    0x8(%ebp),%eax
801042b5:	83 ec 0c             	sub    $0xc,%esp
801042b8:	50                   	push   %eax
801042b9:	e8 55 10 00 00       	call   80105313 <release>
801042be:	83 c4 10             	add    $0x10,%esp
      return -1;
801042c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042c6:	e9 bf 00 00 00       	jmp    8010438a <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801042cb:	8b 45 08             	mov    0x8(%ebp),%eax
801042ce:	8b 55 08             	mov    0x8(%ebp),%edx
801042d1:	81 c2 34 02 00 00    	add    $0x234,%edx
801042d7:	83 ec 08             	sub    $0x8,%esp
801042da:	50                   	push   %eax
801042db:	52                   	push   %edx
801042dc:	e8 62 0b 00 00       	call   80104e43 <sleep>
801042e1:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042e4:	8b 45 08             	mov    0x8(%ebp),%eax
801042e7:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042ed:	8b 45 08             	mov    0x8(%ebp),%eax
801042f0:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042f6:	39 c2                	cmp    %eax,%edx
801042f8:	75 0d                	jne    80104307 <piperead+0x7a>
801042fa:	8b 45 08             	mov    0x8(%ebp),%eax
801042fd:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104303:	85 c0                	test   %eax,%eax
80104305:	75 9e                	jne    801042a5 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104307:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010430e:	eb 49                	jmp    80104359 <piperead+0xcc>
    if(p->nread == p->nwrite)
80104310:	8b 45 08             	mov    0x8(%ebp),%eax
80104313:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104319:	8b 45 08             	mov    0x8(%ebp),%eax
8010431c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104322:	39 c2                	cmp    %eax,%edx
80104324:	74 3d                	je     80104363 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104326:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104329:	8b 45 0c             	mov    0xc(%ebp),%eax
8010432c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010432f:	8b 45 08             	mov    0x8(%ebp),%eax
80104332:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104338:	8d 48 01             	lea    0x1(%eax),%ecx
8010433b:	8b 55 08             	mov    0x8(%ebp),%edx
8010433e:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104344:	25 ff 01 00 00       	and    $0x1ff,%eax
80104349:	89 c2                	mov    %eax,%edx
8010434b:	8b 45 08             	mov    0x8(%ebp),%eax
8010434e:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104353:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104355:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010435f:	7c af                	jl     80104310 <piperead+0x83>
80104361:	eb 01                	jmp    80104364 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
80104363:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104364:	8b 45 08             	mov    0x8(%ebp),%eax
80104367:	05 38 02 00 00       	add    $0x238,%eax
8010436c:	83 ec 0c             	sub    $0xc,%esp
8010436f:	50                   	push   %eax
80104370:	e8 bc 0b 00 00       	call   80104f31 <wakeup>
80104375:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104378:	8b 45 08             	mov    0x8(%ebp),%eax
8010437b:	83 ec 0c             	sub    $0xc,%esp
8010437e:	50                   	push   %eax
8010437f:	e8 8f 0f 00 00       	call   80105313 <release>
80104384:	83 c4 10             	add    $0x10,%esp
  return i;
80104387:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010438a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010438d:	c9                   	leave  
8010438e:	c3                   	ret    

8010438f <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010438f:	55                   	push   %ebp
80104390:	89 e5                	mov    %esp,%ebp
80104392:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104395:	9c                   	pushf  
80104396:	58                   	pop    %eax
80104397:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010439a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010439d:	c9                   	leave  
8010439e:	c3                   	ret    

8010439f <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010439f:	55                   	push   %ebp
801043a0:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043a2:	fb                   	sti    
}
801043a3:	90                   	nop
801043a4:	5d                   	pop    %ebp
801043a5:	c3                   	ret    

801043a6 <pinit>:



void
pinit(void)
{
801043a6:	55                   	push   %ebp
801043a7:	89 e5                	mov    %esp,%ebp
801043a9:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801043ac:	83 ec 08             	sub    $0x8,%esp
801043af:	68 e1 8f 10 80       	push   $0x80108fe1
801043b4:	68 80 39 11 80       	push   $0x80113980
801043b9:	e8 cc 0e 00 00       	call   8010528a <initlock>
801043be:	83 c4 10             	add    $0x10,%esp
}
801043c1:	90                   	nop
801043c2:	c9                   	leave  
801043c3:	c3                   	ret    

801043c4 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801043c4:	55                   	push   %ebp
801043c5:	89 e5                	mov    %esp,%ebp
801043c7:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801043ca:	83 ec 0c             	sub    $0xc,%esp
801043cd:	68 80 39 11 80       	push   $0x80113980
801043d2:	e8 d5 0e 00 00       	call   801052ac <acquire>
801043d7:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043da:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801043e1:	eb 11                	jmp    801043f4 <allocproc+0x30>
    if(p->state == UNUSED)
801043e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e6:	8b 40 0c             	mov    0xc(%eax),%eax
801043e9:	85 c0                	test   %eax,%eax
801043eb:	74 2a                	je     80104417 <allocproc+0x53>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ed:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
801043f4:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
801043fb:	72 e6                	jb     801043e3 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
801043fd:	83 ec 0c             	sub    $0xc,%esp
80104400:	68 80 39 11 80       	push   $0x80113980
80104405:	e8 09 0f 00 00       	call   80105313 <release>
8010440a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010440d:	b8 00 00 00 00       	mov    $0x0,%eax
80104412:	e9 db 00 00 00       	jmp    801044f2 <allocproc+0x12e>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104417:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104418:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441b:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104422:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104427:	8d 50 01             	lea    0x1(%eax),%edx
8010442a:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80104430:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104433:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104436:	83 ec 0c             	sub    $0xc,%esp
80104439:	68 80 39 11 80       	push   $0x80113980
8010443e:	e8 d0 0e 00 00       	call   80105313 <release>
80104443:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104446:	e8 7a e7 ff ff       	call   80102bc5 <kalloc>
8010444b:	89 c2                	mov    %eax,%edx
8010444d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104450:	89 50 08             	mov    %edx,0x8(%eax)
80104453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104456:	8b 40 08             	mov    0x8(%eax),%eax
80104459:	85 c0                	test   %eax,%eax
8010445b:	75 14                	jne    80104471 <allocproc+0xad>
    p->state = UNUSED;
8010445d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104460:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104467:	b8 00 00 00 00       	mov    $0x0,%eax
8010446c:	e9 81 00 00 00       	jmp    801044f2 <allocproc+0x12e>
  }
  sp = p->kstack + KSTACKSIZE;
80104471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104474:	8b 40 08             	mov    0x8(%eax),%eax
80104477:	05 00 10 00 00       	add    $0x1000,%eax
8010447c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010447f:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104486:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104489:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010448c:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104490:	ba 56 6a 10 80       	mov    $0x80106a56,%edx
80104495:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104498:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010449a:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010449e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044a4:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801044a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044aa:	8b 40 1c             	mov    0x1c(%eax),%eax
801044ad:	83 ec 04             	sub    $0x4,%esp
801044b0:	6a 14                	push   $0x14
801044b2:	6a 00                	push   $0x0
801044b4:	50                   	push   %eax
801044b5:	e8 55 10 00 00       	call   8010550f <memset>
801044ba:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801044bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c0:	8b 40 1c             	mov    0x1c(%eax),%eax
801044c3:	ba 12 4e 10 80       	mov    $0x80104e12,%edx
801044c8:	89 50 10             	mov    %edx,0x10(%eax)

  p->handlers[SIGKILL] = (sighandler_t) -1;
801044cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ce:	c7 40 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%eax)
  p->handlers[SIGFPE] = (sighandler_t) -1;
801044d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d8:	c7 80 80 00 00 00 ff 	movl   $0xffffffff,0x80(%eax)
801044df:	ff ff ff 
  p->restorer_addr = -1;
801044e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e5:	c7 80 84 00 00 00 ff 	movl   $0xffffffff,0x84(%eax)
801044ec:	ff ff ff 

  return p;
801044ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044f2:	c9                   	leave  
801044f3:	c3                   	ret    

801044f4 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801044f4:	55                   	push   %ebp
801044f5:	89 e5                	mov    %esp,%ebp
801044f7:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801044fa:	e8 c5 fe ff ff       	call   801043c4 <allocproc>
801044ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104502:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104505:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
8010450a:	e8 f6 3c 00 00       	call   80108205 <setupkvm>
8010450f:	89 c2                	mov    %eax,%edx
80104511:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104514:	89 50 04             	mov    %edx,0x4(%eax)
80104517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451a:	8b 40 04             	mov    0x4(%eax),%eax
8010451d:	85 c0                	test   %eax,%eax
8010451f:	75 0d                	jne    8010452e <userinit+0x3a>
    panic("userinit: out of memory?");
80104521:	83 ec 0c             	sub    $0xc,%esp
80104524:	68 e8 8f 10 80       	push   $0x80108fe8
80104529:	e8 38 c0 ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010452e:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104533:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104536:	8b 40 04             	mov    0x4(%eax),%eax
80104539:	83 ec 04             	sub    $0x4,%esp
8010453c:	52                   	push   %edx
8010453d:	68 00 c5 10 80       	push   $0x8010c500
80104542:	50                   	push   %eax
80104543:	e8 17 3f 00 00       	call   8010845f <inituvm>
80104548:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010454b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454e:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104554:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104557:	8b 40 18             	mov    0x18(%eax),%eax
8010455a:	83 ec 04             	sub    $0x4,%esp
8010455d:	6a 4c                	push   $0x4c
8010455f:	6a 00                	push   $0x0
80104561:	50                   	push   %eax
80104562:	e8 a8 0f 00 00       	call   8010550f <memset>
80104567:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010456a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456d:	8b 40 18             	mov    0x18(%eax),%eax
80104570:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104576:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104579:	8b 40 18             	mov    0x18(%eax),%eax
8010457c:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104582:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104585:	8b 40 18             	mov    0x18(%eax),%eax
80104588:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010458b:	8b 52 18             	mov    0x18(%edx),%edx
8010458e:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104592:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104596:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104599:	8b 40 18             	mov    0x18(%eax),%eax
8010459c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010459f:	8b 52 18             	mov    0x18(%edx),%edx
801045a2:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045a6:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801045aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ad:	8b 40 18             	mov    0x18(%eax),%eax
801045b0:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801045b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ba:	8b 40 18             	mov    0x18(%eax),%eax
801045bd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801045c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c7:	8b 40 18             	mov    0x18(%eax),%eax
801045ca:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801045d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d4:	83 c0 6c             	add    $0x6c,%eax
801045d7:	83 ec 04             	sub    $0x4,%esp
801045da:	6a 10                	push   $0x10
801045dc:	68 01 90 10 80       	push   $0x80109001
801045e1:	50                   	push   %eax
801045e2:	e8 2b 11 00 00       	call   80105712 <safestrcpy>
801045e7:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801045ea:	83 ec 0c             	sub    $0xc,%esp
801045ed:	68 0a 90 10 80       	push   $0x8010900a
801045f2:	e8 cc de ff ff       	call   801024c3 <namei>
801045f7:	83 c4 10             	add    $0x10,%esp
801045fa:	89 c2                	mov    %eax,%edx
801045fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ff:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
80104602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104605:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
8010460c:	90                   	nop
8010460d:	c9                   	leave  
8010460e:	c3                   	ret    

8010460f <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010460f:	55                   	push   %ebp
80104610:	89 e5                	mov    %esp,%ebp
80104612:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
80104615:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010461b:	8b 00                	mov    (%eax),%eax
8010461d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104620:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104624:	7e 31                	jle    80104657 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104626:	8b 55 08             	mov    0x8(%ebp),%edx
80104629:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010462c:	01 c2                	add    %eax,%edx
8010462e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104634:	8b 40 04             	mov    0x4(%eax),%eax
80104637:	83 ec 04             	sub    $0x4,%esp
8010463a:	52                   	push   %edx
8010463b:	ff 75 f4             	pushl  -0xc(%ebp)
8010463e:	50                   	push   %eax
8010463f:	e8 90 40 00 00       	call   801086d4 <allocuvm>
80104644:	83 c4 10             	add    $0x10,%esp
80104647:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010464a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010464e:	75 3e                	jne    8010468e <growproc+0x7f>
      return -1;
80104650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104655:	eb 59                	jmp    801046b0 <growproc+0xa1>
  } else if(n < 0){
80104657:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010465b:	79 31                	jns    8010468e <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010465d:	8b 55 08             	mov    0x8(%ebp),%edx
80104660:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104663:	01 c2                	add    %eax,%edx
80104665:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010466b:	8b 40 04             	mov    0x4(%eax),%eax
8010466e:	83 ec 04             	sub    $0x4,%esp
80104671:	52                   	push   %edx
80104672:	ff 75 f4             	pushl  -0xc(%ebp)
80104675:	50                   	push   %eax
80104676:	e8 22 41 00 00       	call   8010879d <deallocuvm>
8010467b:	83 c4 10             	add    $0x10,%esp
8010467e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104681:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104685:	75 07                	jne    8010468e <growproc+0x7f>
      return -1;
80104687:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010468c:	eb 22                	jmp    801046b0 <growproc+0xa1>
  }
  proc->sz = sz;
8010468e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104694:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104697:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104699:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010469f:	83 ec 0c             	sub    $0xc,%esp
801046a2:	50                   	push   %eax
801046a3:	e8 44 3c 00 00       	call   801082ec <switchuvm>
801046a8:	83 c4 10             	add    $0x10,%esp
  return 0;
801046ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046b0:	c9                   	leave  
801046b1:	c3                   	ret    

801046b2 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801046b2:	55                   	push   %ebp
801046b3:	89 e5                	mov    %esp,%ebp
801046b5:	57                   	push   %edi
801046b6:	56                   	push   %esi
801046b7:	53                   	push   %ebx
801046b8:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801046bb:	e8 04 fd ff ff       	call   801043c4 <allocproc>
801046c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801046c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801046c7:	75 0a                	jne    801046d3 <fork+0x21>
    return -1;
801046c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ce:	e9 68 01 00 00       	jmp    8010483b <fork+0x189>

  // Copy process state from p.
  //look into this for cowfork
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801046d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046d9:	8b 10                	mov    (%eax),%edx
801046db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046e1:	8b 40 04             	mov    0x4(%eax),%eax
801046e4:	83 ec 08             	sub    $0x8,%esp
801046e7:	52                   	push   %edx
801046e8:	50                   	push   %eax
801046e9:	e8 4d 42 00 00       	call   8010893b <copyuvm>
801046ee:	83 c4 10             	add    $0x10,%esp
801046f1:	89 c2                	mov    %eax,%edx
801046f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046f6:	89 50 04             	mov    %edx,0x4(%eax)
801046f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046fc:	8b 40 04             	mov    0x4(%eax),%eax
801046ff:	85 c0                	test   %eax,%eax
80104701:	75 30                	jne    80104733 <fork+0x81>
    kfree(np->kstack);
80104703:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104706:	8b 40 08             	mov    0x8(%eax),%eax
80104709:	83 ec 0c             	sub    $0xc,%esp
8010470c:	50                   	push   %eax
8010470d:	e8 16 e4 ff ff       	call   80102b28 <kfree>
80104712:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104715:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104718:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010471f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104722:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104729:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010472e:	e9 08 01 00 00       	jmp    8010483b <fork+0x189>
  }
  np->sz = proc->sz;
80104733:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104739:	8b 10                	mov    (%eax),%edx
8010473b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010473e:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104740:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104747:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010474a:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010474d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104750:	8b 50 18             	mov    0x18(%eax),%edx
80104753:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104759:	8b 40 18             	mov    0x18(%eax),%eax
8010475c:	89 c3                	mov    %eax,%ebx
8010475e:	b8 13 00 00 00       	mov    $0x13,%eax
80104763:	89 d7                	mov    %edx,%edi
80104765:	89 de                	mov    %ebx,%esi
80104767:	89 c1                	mov    %eax,%ecx
80104769:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010476b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010476e:	8b 40 18             	mov    0x18(%eax),%eax
80104771:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104778:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010477f:	eb 43                	jmp    801047c4 <fork+0x112>
    if(proc->ofile[i])
80104781:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104787:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010478a:	83 c2 08             	add    $0x8,%edx
8010478d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104791:	85 c0                	test   %eax,%eax
80104793:	74 2b                	je     801047c0 <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
80104795:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010479b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010479e:	83 c2 08             	add    $0x8,%edx
801047a1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047a5:	83 ec 0c             	sub    $0xc,%esp
801047a8:	50                   	push   %eax
801047a9:	e8 37 c8 ff ff       	call   80100fe5 <filedup>
801047ae:	83 c4 10             	add    $0x10,%esp
801047b1:	89 c1                	mov    %eax,%ecx
801047b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047b9:	83 c2 08             	add    $0x8,%edx
801047bc:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801047c0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047c4:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047c8:	7e b7                	jle    80104781 <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801047ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047d0:	8b 40 68             	mov    0x68(%eax),%eax
801047d3:	83 ec 0c             	sub    $0xc,%esp
801047d6:	50                   	push   %eax
801047d7:	e8 f5 d0 ff ff       	call   801018d1 <idup>
801047dc:	83 c4 10             	add    $0x10,%esp
801047df:	89 c2                	mov    %eax,%edx
801047e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047e4:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801047e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ed:	8d 50 6c             	lea    0x6c(%eax),%edx
801047f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047f3:	83 c0 6c             	add    $0x6c,%eax
801047f6:	83 ec 04             	sub    $0x4,%esp
801047f9:	6a 10                	push   $0x10
801047fb:	52                   	push   %edx
801047fc:	50                   	push   %eax
801047fd:	e8 10 0f 00 00       	call   80105712 <safestrcpy>
80104802:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104805:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104808:	8b 40 10             	mov    0x10(%eax),%eax
8010480b:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010480e:	83 ec 0c             	sub    $0xc,%esp
80104811:	68 80 39 11 80       	push   $0x80113980
80104816:	e8 91 0a 00 00       	call   801052ac <acquire>
8010481b:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
8010481e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104821:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	68 80 39 11 80       	push   $0x80113980
80104830:	e8 de 0a 00 00       	call   80105313 <release>
80104835:	83 c4 10             	add    $0x10,%esp

  return pid;
80104838:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
8010483b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010483e:	5b                   	pop    %ebx
8010483f:	5e                   	pop    %esi
80104840:	5f                   	pop    %edi
80104841:	5d                   	pop    %ebp
80104842:	c3                   	ret    

80104843 <cowfork>:

int cowfork(void) {
80104843:	55                   	push   %ebp
80104844:	89 e5                	mov    %esp,%ebp
80104846:	57                   	push   %edi
80104847:	56                   	push   %esi
80104848:	53                   	push   %ebx
80104849:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010484c:	e8 73 fb ff ff       	call   801043c4 <allocproc>
80104851:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104854:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104858:	75 0a                	jne    80104864 <cowfork+0x21>
    return -1;
8010485a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010485f:	e9 a5 01 00 00       	jmp    80104a09 <cowfork+0x1c6>

  // Copy process state from p.
  //look into this for cowfork
  cprintf("COWFORK ME!\n");
80104864:	83 ec 0c             	sub    $0xc,%esp
80104867:	68 0c 90 10 80       	push   $0x8010900c
8010486c:	e8 55 bb ff ff       	call   801003c6 <cprintf>
80104871:	83 c4 10             	add    $0x10,%esp
  if((np->pgdir = copyuvm_cow(proc->pgdir, proc->sz)) == 0){
80104874:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010487a:	8b 10                	mov    (%eax),%edx
8010487c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104882:	8b 40 04             	mov    0x4(%eax),%eax
80104885:	83 ec 08             	sub    $0x8,%esp
80104888:	52                   	push   %edx
80104889:	50                   	push   %eax
8010488a:	e8 c8 41 00 00       	call   80108a57 <copyuvm_cow>
8010488f:	83 c4 10             	add    $0x10,%esp
80104892:	89 c2                	mov    %eax,%edx
80104894:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104897:	89 50 04             	mov    %edx,0x4(%eax)
8010489a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010489d:	8b 40 04             	mov    0x4(%eax),%eax
801048a0:	85 c0                	test   %eax,%eax
801048a2:	75 30                	jne    801048d4 <cowfork+0x91>
    kfree(np->kstack);
801048a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048a7:	8b 40 08             	mov    0x8(%eax),%eax
801048aa:	83 ec 0c             	sub    $0xc,%esp
801048ad:	50                   	push   %eax
801048ae:	e8 75 e2 ff ff       	call   80102b28 <kfree>
801048b3:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801048b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801048c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048c3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801048ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048cf:	e9 35 01 00 00       	jmp    80104a09 <cowfork+0x1c6>
  }
  np->sz = proc->sz;
801048d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048da:	8b 10                	mov    (%eax),%edx
801048dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048df:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801048e1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048eb:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801048ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048f1:	8b 50 18             	mov    0x18(%eax),%edx
801048f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048fa:	8b 40 18             	mov    0x18(%eax),%eax
801048fd:	89 c3                	mov    %eax,%ebx
801048ff:	b8 13 00 00 00       	mov    $0x13,%eax
80104904:	89 d7                	mov    %edx,%edi
80104906:	89 de                	mov    %ebx,%esi
80104908:	89 c1                	mov    %eax,%ecx
8010490a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010490c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010490f:	8b 40 18             	mov    0x18(%eax),%eax
80104912:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104919:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104920:	eb 43                	jmp    80104965 <cowfork+0x122>
    if(proc->ofile[i])
80104922:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104928:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010492b:	83 c2 08             	add    $0x8,%edx
8010492e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104932:	85 c0                	test   %eax,%eax
80104934:	74 2b                	je     80104961 <cowfork+0x11e>
      np->ofile[i] = filedup(proc->ofile[i]);
80104936:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010493f:	83 c2 08             	add    $0x8,%edx
80104942:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104946:	83 ec 0c             	sub    $0xc,%esp
80104949:	50                   	push   %eax
8010494a:	e8 96 c6 ff ff       	call   80100fe5 <filedup>
8010494f:	83 c4 10             	add    $0x10,%esp
80104952:	89 c1                	mov    %eax,%ecx
80104954:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104957:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010495a:	83 c2 08             	add    $0x8,%edx
8010495d:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104961:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104965:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104969:	7e b7                	jle    80104922 <cowfork+0xdf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010496b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104971:	8b 40 68             	mov    0x68(%eax),%eax
80104974:	83 ec 0c             	sub    $0xc,%esp
80104977:	50                   	push   %eax
80104978:	e8 54 cf ff ff       	call   801018d1 <idup>
8010497d:	83 c4 10             	add    $0x10,%esp
80104980:	89 c2                	mov    %eax,%edx
80104982:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104985:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104988:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010498e:	8d 50 6c             	lea    0x6c(%eax),%edx
80104991:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104994:	83 c0 6c             	add    $0x6c,%eax
80104997:	83 ec 04             	sub    $0x4,%esp
8010499a:	6a 10                	push   $0x10
8010499c:	52                   	push   %edx
8010499d:	50                   	push   %eax
8010499e:	e8 6f 0d 00 00       	call   80105712 <safestrcpy>
801049a3:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
801049a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049a9:	8b 40 10             	mov    0x10(%eax),%eax
801049ac:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801049af:	83 ec 0c             	sub    $0xc,%esp
801049b2:	68 80 39 11 80       	push   $0x80113980
801049b7:	e8 f0 08 00 00       	call   801052ac <acquire>
801049bc:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801049bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049c2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801049c9:	83 ec 0c             	sub    $0xc,%esp
801049cc:	68 80 39 11 80       	push   $0x80113980
801049d1:	e8 3d 09 00 00       	call   80105313 <release>
801049d6:	83 c4 10             	add    $0x10,%esp

  //set process to shared
  proc->shared = 1;
801049d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049df:	c7 80 88 00 00 00 01 	movl   $0x1,0x88(%eax)
801049e6:	00 00 00 
  np->shared = 1;
801049e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ec:	c7 80 88 00 00 00 01 	movl   $0x1,0x88(%eax)
801049f3:	00 00 00 
  cprintf("THE FORK IS IN ME!\n");
801049f6:	83 ec 0c             	sub    $0xc,%esp
801049f9:	68 19 90 10 80       	push   $0x80109019
801049fe:	e8 c3 b9 ff ff       	call   801003c6 <cprintf>
80104a03:	83 c4 10             	add    $0x10,%esp
  return pid;
80104a06:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104a09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a0c:	5b                   	pop    %ebx
80104a0d:	5e                   	pop    %esi
80104a0e:	5f                   	pop    %edi
80104a0f:	5d                   	pop    %ebp
80104a10:	c3                   	ret    

80104a11 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104a11:	55                   	push   %ebp
80104a12:	89 e5                	mov    %esp,%ebp
80104a14:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104a17:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a1e:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104a23:	39 c2                	cmp    %eax,%edx
80104a25:	75 0d                	jne    80104a34 <exit+0x23>
    panic("init exiting");
80104a27:	83 ec 0c             	sub    $0xc,%esp
80104a2a:	68 2d 90 10 80       	push   $0x8010902d
80104a2f:	e8 32 bb ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a34:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104a3b:	eb 48                	jmp    80104a85 <exit+0x74>
    if(proc->ofile[fd]){
80104a3d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a43:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a46:	83 c2 08             	add    $0x8,%edx
80104a49:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a4d:	85 c0                	test   %eax,%eax
80104a4f:	74 30                	je     80104a81 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104a51:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a57:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a5a:	83 c2 08             	add    $0x8,%edx
80104a5d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a61:	83 ec 0c             	sub    $0xc,%esp
80104a64:	50                   	push   %eax
80104a65:	e8 cc c5 ff ff       	call   80101036 <fileclose>
80104a6a:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104a6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a73:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a76:	83 c2 08             	add    $0x8,%edx
80104a79:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a80:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a81:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a85:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104a89:	7e b2                	jle    80104a3d <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104a8b:	e8 24 ea ff ff       	call   801034b4 <begin_op>
  iput(proc->cwd);
80104a90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a96:	8b 40 68             	mov    0x68(%eax),%eax
80104a99:	83 ec 0c             	sub    $0xc,%esp
80104a9c:	50                   	push   %eax
80104a9d:	e8 33 d0 ff ff       	call   80101ad5 <iput>
80104aa2:	83 c4 10             	add    $0x10,%esp
  end_op();
80104aa5:	e8 96 ea ff ff       	call   80103540 <end_op>
  proc->cwd = 0;
80104aaa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab0:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104ab7:	83 ec 0c             	sub    $0xc,%esp
80104aba:	68 80 39 11 80       	push   $0x80113980
80104abf:	e8 e8 07 00 00       	call   801052ac <acquire>
80104ac4:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104ac7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104acd:	8b 40 14             	mov    0x14(%eax),%eax
80104ad0:	83 ec 0c             	sub    $0xc,%esp
80104ad3:	50                   	push   %eax
80104ad4:	e8 16 04 00 00       	call   80104eef <wakeup1>
80104ad9:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104adc:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104ae3:	eb 3f                	jmp    80104b24 <exit+0x113>
    if(p->parent == proc){
80104ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae8:	8b 50 14             	mov    0x14(%eax),%edx
80104aeb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af1:	39 c2                	cmp    %eax,%edx
80104af3:	75 28                	jne    80104b1d <exit+0x10c>
      p->parent = initproc;
80104af5:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104afe:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b04:	8b 40 0c             	mov    0xc(%eax),%eax
80104b07:	83 f8 05             	cmp    $0x5,%eax
80104b0a:	75 11                	jne    80104b1d <exit+0x10c>
        wakeup1(initproc);
80104b0c:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104b11:	83 ec 0c             	sub    $0xc,%esp
80104b14:	50                   	push   %eax
80104b15:	e8 d5 03 00 00       	call   80104eef <wakeup1>
80104b1a:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b1d:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104b24:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104b2b:	72 b8                	jb     80104ae5 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104b2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b33:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104b3a:	e8 dc 01 00 00       	call   80104d1b <sched>
  panic("zombie exit");
80104b3f:	83 ec 0c             	sub    $0xc,%esp
80104b42:	68 3a 90 10 80       	push   $0x8010903a
80104b47:	e8 1a ba ff ff       	call   80100566 <panic>

80104b4c <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104b4c:	55                   	push   %ebp
80104b4d:	89 e5                	mov    %esp,%ebp
80104b4f:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104b52:	83 ec 0c             	sub    $0xc,%esp
80104b55:	68 80 39 11 80       	push   $0x80113980
80104b5a:	e8 4d 07 00 00       	call   801052ac <acquire>
80104b5f:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b69:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104b70:	e9 a9 00 00 00       	jmp    80104c1e <wait+0xd2>
      if(p->parent != proc)
80104b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b78:	8b 50 14             	mov    0x14(%eax),%edx
80104b7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b81:	39 c2                	cmp    %eax,%edx
80104b83:	0f 85 8d 00 00 00    	jne    80104c16 <wait+0xca>
        continue;
      havekids = 1;
80104b89:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b93:	8b 40 0c             	mov    0xc(%eax),%eax
80104b96:	83 f8 05             	cmp    $0x5,%eax
80104b99:	75 7c                	jne    80104c17 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b9e:	8b 40 10             	mov    0x10(%eax),%eax
80104ba1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba7:	8b 40 08             	mov    0x8(%eax),%eax
80104baa:	83 ec 0c             	sub    $0xc,%esp
80104bad:	50                   	push   %eax
80104bae:	e8 75 df ff ff       	call   80102b28 <kfree>
80104bb3:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc3:	8b 40 04             	mov    0x4(%eax),%eax
80104bc6:	83 ec 0c             	sub    $0xc,%esp
80104bc9:	50                   	push   %eax
80104bca:	e8 8b 3c 00 00       	call   8010885a <freevm>
80104bcf:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bdf:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf3:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bfa:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104c01:	83 ec 0c             	sub    $0xc,%esp
80104c04:	68 80 39 11 80       	push   $0x80113980
80104c09:	e8 05 07 00 00       	call   80105313 <release>
80104c0e:	83 c4 10             	add    $0x10,%esp
        return pid;
80104c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c14:	eb 5b                	jmp    80104c71 <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104c16:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c17:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104c1e:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104c25:	0f 82 4a ff ff ff    	jb     80104b75 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104c2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c2f:	74 0d                	je     80104c3e <wait+0xf2>
80104c31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c37:	8b 40 24             	mov    0x24(%eax),%eax
80104c3a:	85 c0                	test   %eax,%eax
80104c3c:	74 17                	je     80104c55 <wait+0x109>
      release(&ptable.lock);
80104c3e:	83 ec 0c             	sub    $0xc,%esp
80104c41:	68 80 39 11 80       	push   $0x80113980
80104c46:	e8 c8 06 00 00       	call   80105313 <release>
80104c4b:	83 c4 10             	add    $0x10,%esp
      return -1;
80104c4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c53:	eb 1c                	jmp    80104c71 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c5b:	83 ec 08             	sub    $0x8,%esp
80104c5e:	68 80 39 11 80       	push   $0x80113980
80104c63:	50                   	push   %eax
80104c64:	e8 da 01 00 00       	call   80104e43 <sleep>
80104c69:	83 c4 10             	add    $0x10,%esp
  }
80104c6c:	e9 f1 fe ff ff       	jmp    80104b62 <wait+0x16>
}
80104c71:	c9                   	leave  
80104c72:	c3                   	ret    

80104c73 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104c73:	55                   	push   %ebp
80104c74:	89 e5                	mov    %esp,%ebp
80104c76:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104c79:	e8 21 f7 ff ff       	call   8010439f <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104c7e:	83 ec 0c             	sub    $0xc,%esp
80104c81:	68 80 39 11 80       	push   $0x80113980
80104c86:	e8 21 06 00 00       	call   801052ac <acquire>
80104c8b:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c8e:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104c95:	eb 66                	jmp    80104cfd <scheduler+0x8a>
      if(p->state != RUNNABLE)
80104c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c9a:	8b 40 0c             	mov    0xc(%eax),%eax
80104c9d:	83 f8 03             	cmp    $0x3,%eax
80104ca0:	75 53                	jne    80104cf5 <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ca5:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104cab:	83 ec 0c             	sub    $0xc,%esp
80104cae:	ff 75 f4             	pushl  -0xc(%ebp)
80104cb1:	e8 36 36 00 00       	call   801082ec <switchuvm>
80104cb6:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cbc:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104cc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc9:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ccc:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104cd3:	83 c2 04             	add    $0x4,%edx
80104cd6:	83 ec 08             	sub    $0x8,%esp
80104cd9:	50                   	push   %eax
80104cda:	52                   	push   %edx
80104cdb:	e8 a3 0a 00 00       	call   80105783 <swtch>
80104ce0:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104ce3:	e8 e7 35 00 00       	call   801082cf <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104ce8:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104cef:	00 00 00 00 
80104cf3:	eb 01                	jmp    80104cf6 <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104cf5:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cf6:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104cfd:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104d04:	72 91                	jb     80104c97 <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104d06:	83 ec 0c             	sub    $0xc,%esp
80104d09:	68 80 39 11 80       	push   $0x80113980
80104d0e:	e8 00 06 00 00       	call   80105313 <release>
80104d13:	83 c4 10             	add    $0x10,%esp

  }
80104d16:	e9 5e ff ff ff       	jmp    80104c79 <scheduler+0x6>

80104d1b <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104d1b:	55                   	push   %ebp
80104d1c:	89 e5                	mov    %esp,%ebp
80104d1e:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104d21:	83 ec 0c             	sub    $0xc,%esp
80104d24:	68 80 39 11 80       	push   $0x80113980
80104d29:	e8 b1 06 00 00       	call   801053df <holding>
80104d2e:	83 c4 10             	add    $0x10,%esp
80104d31:	85 c0                	test   %eax,%eax
80104d33:	75 0d                	jne    80104d42 <sched+0x27>
    panic("sched ptable.lock");
80104d35:	83 ec 0c             	sub    $0xc,%esp
80104d38:	68 46 90 10 80       	push   $0x80109046
80104d3d:	e8 24 b8 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104d42:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d48:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d4e:	83 f8 01             	cmp    $0x1,%eax
80104d51:	74 0d                	je     80104d60 <sched+0x45>
    panic("sched locks");
80104d53:	83 ec 0c             	sub    $0xc,%esp
80104d56:	68 58 90 10 80       	push   $0x80109058
80104d5b:	e8 06 b8 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104d60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d66:	8b 40 0c             	mov    0xc(%eax),%eax
80104d69:	83 f8 04             	cmp    $0x4,%eax
80104d6c:	75 0d                	jne    80104d7b <sched+0x60>
    panic("sched running");
80104d6e:	83 ec 0c             	sub    $0xc,%esp
80104d71:	68 64 90 10 80       	push   $0x80109064
80104d76:	e8 eb b7 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104d7b:	e8 0f f6 ff ff       	call   8010438f <readeflags>
80104d80:	25 00 02 00 00       	and    $0x200,%eax
80104d85:	85 c0                	test   %eax,%eax
80104d87:	74 0d                	je     80104d96 <sched+0x7b>
    panic("sched interruptible");
80104d89:	83 ec 0c             	sub    $0xc,%esp
80104d8c:	68 72 90 10 80       	push   $0x80109072
80104d91:	e8 d0 b7 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104d96:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d9c:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104da5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dab:	8b 40 04             	mov    0x4(%eax),%eax
80104dae:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104db5:	83 c2 1c             	add    $0x1c,%edx
80104db8:	83 ec 08             	sub    $0x8,%esp
80104dbb:	50                   	push   %eax
80104dbc:	52                   	push   %edx
80104dbd:	e8 c1 09 00 00       	call   80105783 <swtch>
80104dc2:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104dc5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dce:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104dd4:	90                   	nop
80104dd5:	c9                   	leave  
80104dd6:	c3                   	ret    

80104dd7 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104dd7:	55                   	push   %ebp
80104dd8:	89 e5                	mov    %esp,%ebp
80104dda:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104ddd:	83 ec 0c             	sub    $0xc,%esp
80104de0:	68 80 39 11 80       	push   $0x80113980
80104de5:	e8 c2 04 00 00       	call   801052ac <acquire>
80104dea:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104ded:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104df3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104dfa:	e8 1c ff ff ff       	call   80104d1b <sched>
  release(&ptable.lock);
80104dff:	83 ec 0c             	sub    $0xc,%esp
80104e02:	68 80 39 11 80       	push   $0x80113980
80104e07:	e8 07 05 00 00       	call   80105313 <release>
80104e0c:	83 c4 10             	add    $0x10,%esp
}
80104e0f:	90                   	nop
80104e10:	c9                   	leave  
80104e11:	c3                   	ret    

80104e12 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104e12:	55                   	push   %ebp
80104e13:	89 e5                	mov    %esp,%ebp
80104e15:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104e18:	83 ec 0c             	sub    $0xc,%esp
80104e1b:	68 80 39 11 80       	push   $0x80113980
80104e20:	e8 ee 04 00 00       	call   80105313 <release>
80104e25:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104e28:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104e2d:	85 c0                	test   %eax,%eax
80104e2f:	74 0f                	je     80104e40 <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104e31:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104e38:	00 00 00 
    initlog();
80104e3b:	e8 4e e4 ff ff       	call   8010328e <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104e40:	90                   	nop
80104e41:	c9                   	leave  
80104e42:	c3                   	ret    

80104e43 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e43:	55                   	push   %ebp
80104e44:	89 e5                	mov    %esp,%ebp
80104e46:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104e49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e4f:	85 c0                	test   %eax,%eax
80104e51:	75 0d                	jne    80104e60 <sleep+0x1d>
    panic("sleep");
80104e53:	83 ec 0c             	sub    $0xc,%esp
80104e56:	68 86 90 10 80       	push   $0x80109086
80104e5b:	e8 06 b7 ff ff       	call   80100566 <panic>

  if(lk == 0)
80104e60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e64:	75 0d                	jne    80104e73 <sleep+0x30>
    panic("sleep without lk");
80104e66:	83 ec 0c             	sub    $0xc,%esp
80104e69:	68 8c 90 10 80       	push   $0x8010908c
80104e6e:	e8 f3 b6 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104e73:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104e7a:	74 1e                	je     80104e9a <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104e7c:	83 ec 0c             	sub    $0xc,%esp
80104e7f:	68 80 39 11 80       	push   $0x80113980
80104e84:	e8 23 04 00 00       	call   801052ac <acquire>
80104e89:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	ff 75 0c             	pushl  0xc(%ebp)
80104e92:	e8 7c 04 00 00       	call   80105313 <release>
80104e97:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104e9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ea0:	8b 55 08             	mov    0x8(%ebp),%edx
80104ea3:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104ea6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eac:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104eb3:	e8 63 fe ff ff       	call   80104d1b <sched>

  // Tidy up.
  proc->chan = 0;
80104eb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ebe:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104ec5:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104ecc:	74 1e                	je     80104eec <sleep+0xa9>
    release(&ptable.lock);
80104ece:	83 ec 0c             	sub    $0xc,%esp
80104ed1:	68 80 39 11 80       	push   $0x80113980
80104ed6:	e8 38 04 00 00       	call   80105313 <release>
80104edb:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104ede:	83 ec 0c             	sub    $0xc,%esp
80104ee1:	ff 75 0c             	pushl  0xc(%ebp)
80104ee4:	e8 c3 03 00 00       	call   801052ac <acquire>
80104ee9:	83 c4 10             	add    $0x10,%esp
  }
}
80104eec:	90                   	nop
80104eed:	c9                   	leave  
80104eee:	c3                   	ret    

80104eef <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104eef:	55                   	push   %ebp
80104ef0:	89 e5                	mov    %esp,%ebp
80104ef2:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ef5:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104efc:	eb 27                	jmp    80104f25 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104efe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f01:	8b 40 0c             	mov    0xc(%eax),%eax
80104f04:	83 f8 02             	cmp    $0x2,%eax
80104f07:	75 15                	jne    80104f1e <wakeup1+0x2f>
80104f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f0c:	8b 40 20             	mov    0x20(%eax),%eax
80104f0f:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f12:	75 0a                	jne    80104f1e <wakeup1+0x2f>
      p->state = RUNNABLE;
80104f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f1e:	81 45 fc 8c 00 00 00 	addl   $0x8c,-0x4(%ebp)
80104f25:	81 7d fc b4 5c 11 80 	cmpl   $0x80115cb4,-0x4(%ebp)
80104f2c:	72 d0                	jb     80104efe <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104f2e:	90                   	nop
80104f2f:	c9                   	leave  
80104f30:	c3                   	ret    

80104f31 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104f31:	55                   	push   %ebp
80104f32:	89 e5                	mov    %esp,%ebp
80104f34:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104f37:	83 ec 0c             	sub    $0xc,%esp
80104f3a:	68 80 39 11 80       	push   $0x80113980
80104f3f:	e8 68 03 00 00       	call   801052ac <acquire>
80104f44:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104f47:	83 ec 0c             	sub    $0xc,%esp
80104f4a:	ff 75 08             	pushl  0x8(%ebp)
80104f4d:	e8 9d ff ff ff       	call   80104eef <wakeup1>
80104f52:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104f55:	83 ec 0c             	sub    $0xc,%esp
80104f58:	68 80 39 11 80       	push   $0x80113980
80104f5d:	e8 b1 03 00 00       	call   80105313 <release>
80104f62:	83 c4 10             	add    $0x10,%esp
}
80104f65:	90                   	nop
80104f66:	c9                   	leave  
80104f67:	c3                   	ret    

80104f68 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104f68:	55                   	push   %ebp
80104f69:	89 e5                	mov    %esp,%ebp
80104f6b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104f6e:	83 ec 0c             	sub    $0xc,%esp
80104f71:	68 80 39 11 80       	push   $0x80113980
80104f76:	e8 31 03 00 00       	call   801052ac <acquire>
80104f7b:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f7e:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104f85:	eb 48                	jmp    80104fcf <kill+0x67>
    if(p->pid == pid){
80104f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f8a:	8b 40 10             	mov    0x10(%eax),%eax
80104f8d:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f90:	75 36                	jne    80104fc8 <kill+0x60>
      p->killed = 1;
80104f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f95:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f9f:	8b 40 0c             	mov    0xc(%eax),%eax
80104fa2:	83 f8 02             	cmp    $0x2,%eax
80104fa5:	75 0a                	jne    80104fb1 <kill+0x49>
        p->state = RUNNABLE;
80104fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104faa:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104fb1:	83 ec 0c             	sub    $0xc,%esp
80104fb4:	68 80 39 11 80       	push   $0x80113980
80104fb9:	e8 55 03 00 00       	call   80105313 <release>
80104fbe:	83 c4 10             	add    $0x10,%esp
      return 0;
80104fc1:	b8 00 00 00 00       	mov    $0x0,%eax
80104fc6:	eb 25                	jmp    80104fed <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fc8:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104fcf:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104fd6:	72 af                	jb     80104f87 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104fd8:	83 ec 0c             	sub    $0xc,%esp
80104fdb:	68 80 39 11 80       	push   $0x80113980
80104fe0:	e8 2e 03 00 00       	call   80105313 <release>
80104fe5:	83 c4 10             	add    $0x10,%esp
  return -1;
80104fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fed:	c9                   	leave  
80104fee:	c3                   	ret    

80104fef <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104fef:	55                   	push   %ebp
80104ff0:	89 e5                	mov    %esp,%ebp
80104ff2:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ff5:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80104ffc:	e9 da 00 00 00       	jmp    801050db <procdump+0xec>
    if(p->state == UNUSED)
80105001:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105004:	8b 40 0c             	mov    0xc(%eax),%eax
80105007:	85 c0                	test   %eax,%eax
80105009:	0f 84 c4 00 00 00    	je     801050d3 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010500f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105012:	8b 40 0c             	mov    0xc(%eax),%eax
80105015:	83 f8 05             	cmp    $0x5,%eax
80105018:	77 23                	ja     8010503d <procdump+0x4e>
8010501a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010501d:	8b 40 0c             	mov    0xc(%eax),%eax
80105020:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105027:	85 c0                	test   %eax,%eax
80105029:	74 12                	je     8010503d <procdump+0x4e>
      state = states[p->state];
8010502b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010502e:	8b 40 0c             	mov    0xc(%eax),%eax
80105031:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105038:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010503b:	eb 07                	jmp    80105044 <procdump+0x55>
    else
      state = "???";
8010503d:	c7 45 ec 9d 90 10 80 	movl   $0x8010909d,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105044:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105047:	8d 50 6c             	lea    0x6c(%eax),%edx
8010504a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010504d:	8b 40 10             	mov    0x10(%eax),%eax
80105050:	52                   	push   %edx
80105051:	ff 75 ec             	pushl  -0x14(%ebp)
80105054:	50                   	push   %eax
80105055:	68 a1 90 10 80       	push   $0x801090a1
8010505a:	e8 67 b3 ff ff       	call   801003c6 <cprintf>
8010505f:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105062:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105065:	8b 40 0c             	mov    0xc(%eax),%eax
80105068:	83 f8 02             	cmp    $0x2,%eax
8010506b:	75 54                	jne    801050c1 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010506d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105070:	8b 40 1c             	mov    0x1c(%eax),%eax
80105073:	8b 40 0c             	mov    0xc(%eax),%eax
80105076:	83 c0 08             	add    $0x8,%eax
80105079:	89 c2                	mov    %eax,%edx
8010507b:	83 ec 08             	sub    $0x8,%esp
8010507e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105081:	50                   	push   %eax
80105082:	52                   	push   %edx
80105083:	e8 dd 02 00 00       	call   80105365 <getcallerpcs>
80105088:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010508b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105092:	eb 1c                	jmp    801050b0 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80105094:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105097:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010509b:	83 ec 08             	sub    $0x8,%esp
8010509e:	50                   	push   %eax
8010509f:	68 aa 90 10 80       	push   $0x801090aa
801050a4:	e8 1d b3 ff ff       	call   801003c6 <cprintf>
801050a9:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801050ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801050b0:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801050b4:	7f 0b                	jg     801050c1 <procdump+0xd2>
801050b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050b9:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050bd:	85 c0                	test   %eax,%eax
801050bf:	75 d3                	jne    80105094 <procdump+0xa5>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801050c1:	83 ec 0c             	sub    $0xc,%esp
801050c4:	68 ae 90 10 80       	push   $0x801090ae
801050c9:	e8 f8 b2 ff ff       	call   801003c6 <cprintf>
801050ce:	83 c4 10             	add    $0x10,%esp
801050d1:	eb 01                	jmp    801050d4 <procdump+0xe5>
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801050d3:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050d4:	81 45 f0 8c 00 00 00 	addl   $0x8c,-0x10(%ebp)
801050db:	81 7d f0 b4 5c 11 80 	cmpl   $0x80115cb4,-0x10(%ebp)
801050e2:	0f 82 19 ff ff ff    	jb     80105001 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801050e8:	90                   	nop
801050e9:	c9                   	leave  
801050ea:	c3                   	ret    

801050eb <signal_deliver>:

void signal_deliver(int signum,siginfo_t si)
{
801050eb:	55                   	push   %ebp
801050ec:	89 e5                	mov    %esp,%ebp
801050ee:	83 ec 10             	sub    $0x10,%esp
	uint old_eip = proc->tf->eip;
801050f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050f7:	8b 40 18             	mov    0x18(%eax),%eax
801050fa:	8b 40 38             	mov    0x38(%eax),%eax
801050fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	*((uint*)(proc->tf->esp - 4))  = (uint) old_eip;		// real return address
80105100:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105106:	8b 40 18             	mov    0x18(%eax),%eax
80105109:	8b 40 44             	mov    0x44(%eax),%eax
8010510c:	83 e8 04             	sub    $0x4,%eax
8010510f:	89 c2                	mov    %eax,%edx
80105111:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105114:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 8))  = proc->tf->eax;			// eax
80105116:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010511c:	8b 40 18             	mov    0x18(%eax),%eax
8010511f:	8b 40 44             	mov    0x44(%eax),%eax
80105122:	83 e8 08             	sub    $0x8,%eax
80105125:	89 c2                	mov    %eax,%edx
80105127:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010512d:	8b 40 18             	mov    0x18(%eax),%eax
80105130:	8b 40 1c             	mov    0x1c(%eax),%eax
80105133:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 12)) = proc->tf->ecx;			// ecx
80105135:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010513b:	8b 40 18             	mov    0x18(%eax),%eax
8010513e:	8b 40 44             	mov    0x44(%eax),%eax
80105141:	83 e8 0c             	sub    $0xc,%eax
80105144:	89 c2                	mov    %eax,%edx
80105146:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010514c:	8b 40 18             	mov    0x18(%eax),%eax
8010514f:	8b 40 18             	mov    0x18(%eax),%eax
80105152:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 16)) = proc->tf->edx;			// edx
80105154:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010515a:	8b 40 18             	mov    0x18(%eax),%eax
8010515d:	8b 40 44             	mov    0x44(%eax),%eax
80105160:	83 e8 10             	sub    $0x10,%eax
80105163:	89 c2                	mov    %eax,%edx
80105165:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010516b:	8b 40 18             	mov    0x18(%eax),%eax
8010516e:	8b 40 14             	mov    0x14(%eax),%eax
80105171:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 20)) = si.type;       //address mem fault occured
80105173:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105179:	8b 40 18             	mov    0x18(%eax),%eax
8010517c:	8b 40 44             	mov    0x44(%eax),%eax
8010517f:	83 e8 14             	sub    $0x14,%eax
80105182:	89 c2                	mov    %eax,%edx
80105184:	8b 45 10             	mov    0x10(%ebp),%eax
80105187:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 24)) = si.addr;       //address mem fault occured
80105189:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010518f:	8b 40 18             	mov    0x18(%eax),%eax
80105192:	8b 40 44             	mov    0x44(%eax),%eax
80105195:	83 e8 18             	sub    $0x18,%eax
80105198:	89 c2                	mov    %eax,%edx
8010519a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010519d:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 28)) = (uint) signum;			// signal number
8010519f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051a5:	8b 40 18             	mov    0x18(%eax),%eax
801051a8:	8b 40 44             	mov    0x44(%eax),%eax
801051ab:	83 e8 1c             	sub    $0x1c,%eax
801051ae:	89 c2                	mov    %eax,%edx
801051b0:	8b 45 08             	mov    0x8(%ebp),%eax
801051b3:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 32)) = proc->restorer_addr;	// address of restorer
801051b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051bb:	8b 40 18             	mov    0x18(%eax),%eax
801051be:	8b 40 44             	mov    0x44(%eax),%eax
801051c1:	83 e8 20             	sub    $0x20,%eax
801051c4:	89 c2                	mov    %eax,%edx
801051c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051cc:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801051d2:	89 02                	mov    %eax,(%edx)
	proc->tf->esp -= 32;
801051d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051da:	8b 40 18             	mov    0x18(%eax),%eax
801051dd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051e4:	8b 52 18             	mov    0x18(%edx),%edx
801051e7:	8b 52 44             	mov    0x44(%edx),%edx
801051ea:	83 ea 20             	sub    $0x20,%edx
801051ed:	89 50 44             	mov    %edx,0x44(%eax)
	proc->tf->eip = (uint) proc->handlers[signum];
801051f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051f6:	8b 40 18             	mov    0x18(%eax),%eax
801051f9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105200:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105203:	83 c1 1c             	add    $0x1c,%ecx
80105206:	8b 54 8a 0c          	mov    0xc(%edx,%ecx,4),%edx
8010520a:	89 50 38             	mov    %edx,0x38(%eax)
}
8010520d:	90                   	nop
8010520e:	c9                   	leave  
8010520f:	c3                   	ret    

80105210 <signal_register_handler>:



sighandler_t signal_register_handler(int signum, sighandler_t handler)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	83 ec 10             	sub    $0x10,%esp
	if (!proc)
80105216:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010521c:	85 c0                	test   %eax,%eax
8010521e:	75 07                	jne    80105227 <signal_register_handler+0x17>
		return (sighandler_t) -1;
80105220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105225:	eb 29                	jmp    80105250 <signal_register_handler+0x40>

	sighandler_t previous = proc->handlers[signum];
80105227:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010522d:	8b 55 08             	mov    0x8(%ebp),%edx
80105230:	83 c2 1c             	add    $0x1c,%edx
80105233:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105237:	89 45 fc             	mov    %eax,-0x4(%ebp)

	proc->handlers[signum] = handler;
8010523a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105240:	8b 55 08             	mov    0x8(%ebp),%edx
80105243:	8d 4a 1c             	lea    0x1c(%edx),%ecx
80105246:	8b 55 0c             	mov    0xc(%ebp),%edx
80105249:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)

	return previous;
8010524d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105250:	c9                   	leave  
80105251:	c3                   	ret    

80105252 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105252:	55                   	push   %ebp
80105253:	89 e5                	mov    %esp,%ebp
80105255:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105258:	9c                   	pushf  
80105259:	58                   	pop    %eax
8010525a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010525d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105260:	c9                   	leave  
80105261:	c3                   	ret    

80105262 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105262:	55                   	push   %ebp
80105263:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105265:	fa                   	cli    
}
80105266:	90                   	nop
80105267:	5d                   	pop    %ebp
80105268:	c3                   	ret    

80105269 <sti>:

static inline void
sti(void)
{
80105269:	55                   	push   %ebp
8010526a:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010526c:	fb                   	sti    
}
8010526d:	90                   	nop
8010526e:	5d                   	pop    %ebp
8010526f:	c3                   	ret    

80105270 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105276:	8b 55 08             	mov    0x8(%ebp),%edx
80105279:	8b 45 0c             	mov    0xc(%ebp),%eax
8010527c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010527f:	f0 87 02             	lock xchg %eax,(%edx)
80105282:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105285:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105288:	c9                   	leave  
80105289:	c3                   	ret    

8010528a <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010528a:	55                   	push   %ebp
8010528b:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010528d:	8b 45 08             	mov    0x8(%ebp),%eax
80105290:	8b 55 0c             	mov    0xc(%ebp),%edx
80105293:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105296:	8b 45 08             	mov    0x8(%ebp),%eax
80105299:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010529f:	8b 45 08             	mov    0x8(%ebp),%eax
801052a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801052a9:	90                   	nop
801052aa:	5d                   	pop    %ebp
801052ab:	c3                   	ret    

801052ac <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801052ac:	55                   	push   %ebp
801052ad:	89 e5                	mov    %esp,%ebp
801052af:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801052b2:	e8 52 01 00 00       	call   80105409 <pushcli>
  if(holding(lk))
801052b7:	8b 45 08             	mov    0x8(%ebp),%eax
801052ba:	83 ec 0c             	sub    $0xc,%esp
801052bd:	50                   	push   %eax
801052be:	e8 1c 01 00 00       	call   801053df <holding>
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	85 c0                	test   %eax,%eax
801052c8:	74 0d                	je     801052d7 <acquire+0x2b>
    panic("acquire");
801052ca:	83 ec 0c             	sub    $0xc,%esp
801052cd:	68 da 90 10 80       	push   $0x801090da
801052d2:	e8 8f b2 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801052d7:	90                   	nop
801052d8:	8b 45 08             	mov    0x8(%ebp),%eax
801052db:	83 ec 08             	sub    $0x8,%esp
801052de:	6a 01                	push   $0x1
801052e0:	50                   	push   %eax
801052e1:	e8 8a ff ff ff       	call   80105270 <xchg>
801052e6:	83 c4 10             	add    $0x10,%esp
801052e9:	85 c0                	test   %eax,%eax
801052eb:	75 eb                	jne    801052d8 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801052ed:	8b 45 08             	mov    0x8(%ebp),%eax
801052f0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801052f7:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801052fa:	8b 45 08             	mov    0x8(%ebp),%eax
801052fd:	83 c0 0c             	add    $0xc,%eax
80105300:	83 ec 08             	sub    $0x8,%esp
80105303:	50                   	push   %eax
80105304:	8d 45 08             	lea    0x8(%ebp),%eax
80105307:	50                   	push   %eax
80105308:	e8 58 00 00 00       	call   80105365 <getcallerpcs>
8010530d:	83 c4 10             	add    $0x10,%esp
}
80105310:	90                   	nop
80105311:	c9                   	leave  
80105312:	c3                   	ret    

80105313 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105313:	55                   	push   %ebp
80105314:	89 e5                	mov    %esp,%ebp
80105316:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105319:	83 ec 0c             	sub    $0xc,%esp
8010531c:	ff 75 08             	pushl  0x8(%ebp)
8010531f:	e8 bb 00 00 00       	call   801053df <holding>
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	85 c0                	test   %eax,%eax
80105329:	75 0d                	jne    80105338 <release+0x25>
    panic("release");
8010532b:	83 ec 0c             	sub    $0xc,%esp
8010532e:	68 e2 90 10 80       	push   $0x801090e2
80105333:	e8 2e b2 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105338:	8b 45 08             	mov    0x8(%ebp),%eax
8010533b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105342:	8b 45 08             	mov    0x8(%ebp),%eax
80105345:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010534c:	8b 45 08             	mov    0x8(%ebp),%eax
8010534f:	83 ec 08             	sub    $0x8,%esp
80105352:	6a 00                	push   $0x0
80105354:	50                   	push   %eax
80105355:	e8 16 ff ff ff       	call   80105270 <xchg>
8010535a:	83 c4 10             	add    $0x10,%esp

  popcli();
8010535d:	e8 ec 00 00 00       	call   8010544e <popcli>
}
80105362:	90                   	nop
80105363:	c9                   	leave  
80105364:	c3                   	ret    

80105365 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105365:	55                   	push   %ebp
80105366:	89 e5                	mov    %esp,%ebp
80105368:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010536b:	8b 45 08             	mov    0x8(%ebp),%eax
8010536e:	83 e8 08             	sub    $0x8,%eax
80105371:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105374:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010537b:	eb 38                	jmp    801053b5 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010537d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105381:	74 53                	je     801053d6 <getcallerpcs+0x71>
80105383:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010538a:	76 4a                	jbe    801053d6 <getcallerpcs+0x71>
8010538c:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105390:	74 44                	je     801053d6 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105392:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105395:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010539c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010539f:	01 c2                	add    %eax,%edx
801053a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053a4:	8b 40 04             	mov    0x4(%eax),%eax
801053a7:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801053a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053ac:	8b 00                	mov    (%eax),%eax
801053ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801053b1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801053b5:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801053b9:	7e c2                	jle    8010537d <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801053bb:	eb 19                	jmp    801053d6 <getcallerpcs+0x71>
    pcs[i] = 0;
801053bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801053c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ca:	01 d0                	add    %edx,%eax
801053cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801053d2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801053d6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801053da:	7e e1                	jle    801053bd <getcallerpcs+0x58>
    pcs[i] = 0;
}
801053dc:	90                   	nop
801053dd:	c9                   	leave  
801053de:	c3                   	ret    

801053df <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801053df:	55                   	push   %ebp
801053e0:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801053e2:	8b 45 08             	mov    0x8(%ebp),%eax
801053e5:	8b 00                	mov    (%eax),%eax
801053e7:	85 c0                	test   %eax,%eax
801053e9:	74 17                	je     80105402 <holding+0x23>
801053eb:	8b 45 08             	mov    0x8(%ebp),%eax
801053ee:	8b 50 08             	mov    0x8(%eax),%edx
801053f1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053f7:	39 c2                	cmp    %eax,%edx
801053f9:	75 07                	jne    80105402 <holding+0x23>
801053fb:	b8 01 00 00 00       	mov    $0x1,%eax
80105400:	eb 05                	jmp    80105407 <holding+0x28>
80105402:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105407:	5d                   	pop    %ebp
80105408:	c3                   	ret    

80105409 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105409:	55                   	push   %ebp
8010540a:	89 e5                	mov    %esp,%ebp
8010540c:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010540f:	e8 3e fe ff ff       	call   80105252 <readeflags>
80105414:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105417:	e8 46 fe ff ff       	call   80105262 <cli>
  if(cpu->ncli++ == 0)
8010541c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105423:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105429:	8d 48 01             	lea    0x1(%eax),%ecx
8010542c:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105432:	85 c0                	test   %eax,%eax
80105434:	75 15                	jne    8010544b <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105436:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010543c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010543f:	81 e2 00 02 00 00    	and    $0x200,%edx
80105445:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010544b:	90                   	nop
8010544c:	c9                   	leave  
8010544d:	c3                   	ret    

8010544e <popcli>:

void
popcli(void)
{
8010544e:	55                   	push   %ebp
8010544f:	89 e5                	mov    %esp,%ebp
80105451:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105454:	e8 f9 fd ff ff       	call   80105252 <readeflags>
80105459:	25 00 02 00 00       	and    $0x200,%eax
8010545e:	85 c0                	test   %eax,%eax
80105460:	74 0d                	je     8010546f <popcli+0x21>
    panic("popcli - interruptible");
80105462:	83 ec 0c             	sub    $0xc,%esp
80105465:	68 ea 90 10 80       	push   $0x801090ea
8010546a:	e8 f7 b0 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
8010546f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105475:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010547b:	83 ea 01             	sub    $0x1,%edx
8010547e:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105484:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010548a:	85 c0                	test   %eax,%eax
8010548c:	79 0d                	jns    8010549b <popcli+0x4d>
    panic("popcli");
8010548e:	83 ec 0c             	sub    $0xc,%esp
80105491:	68 01 91 10 80       	push   $0x80109101
80105496:	e8 cb b0 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010549b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054a1:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054a7:	85 c0                	test   %eax,%eax
801054a9:	75 15                	jne    801054c0 <popcli+0x72>
801054ab:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054b1:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801054b7:	85 c0                	test   %eax,%eax
801054b9:	74 05                	je     801054c0 <popcli+0x72>
    sti();
801054bb:	e8 a9 fd ff ff       	call   80105269 <sti>
}
801054c0:	90                   	nop
801054c1:	c9                   	leave  
801054c2:	c3                   	ret    

801054c3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801054c3:	55                   	push   %ebp
801054c4:	89 e5                	mov    %esp,%ebp
801054c6:	57                   	push   %edi
801054c7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801054c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054cb:	8b 55 10             	mov    0x10(%ebp),%edx
801054ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801054d1:	89 cb                	mov    %ecx,%ebx
801054d3:	89 df                	mov    %ebx,%edi
801054d5:	89 d1                	mov    %edx,%ecx
801054d7:	fc                   	cld    
801054d8:	f3 aa                	rep stos %al,%es:(%edi)
801054da:	89 ca                	mov    %ecx,%edx
801054dc:	89 fb                	mov    %edi,%ebx
801054de:	89 5d 08             	mov    %ebx,0x8(%ebp)
801054e1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801054e4:	90                   	nop
801054e5:	5b                   	pop    %ebx
801054e6:	5f                   	pop    %edi
801054e7:	5d                   	pop    %ebp
801054e8:	c3                   	ret    

801054e9 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801054e9:	55                   	push   %ebp
801054ea:	89 e5                	mov    %esp,%ebp
801054ec:	57                   	push   %edi
801054ed:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801054ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054f1:	8b 55 10             	mov    0x10(%ebp),%edx
801054f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801054f7:	89 cb                	mov    %ecx,%ebx
801054f9:	89 df                	mov    %ebx,%edi
801054fb:	89 d1                	mov    %edx,%ecx
801054fd:	fc                   	cld    
801054fe:	f3 ab                	rep stos %eax,%es:(%edi)
80105500:	89 ca                	mov    %ecx,%edx
80105502:	89 fb                	mov    %edi,%ebx
80105504:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105507:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010550a:	90                   	nop
8010550b:	5b                   	pop    %ebx
8010550c:	5f                   	pop    %edi
8010550d:	5d                   	pop    %ebp
8010550e:	c3                   	ret    

8010550f <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010550f:	55                   	push   %ebp
80105510:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105512:	8b 45 08             	mov    0x8(%ebp),%eax
80105515:	83 e0 03             	and    $0x3,%eax
80105518:	85 c0                	test   %eax,%eax
8010551a:	75 43                	jne    8010555f <memset+0x50>
8010551c:	8b 45 10             	mov    0x10(%ebp),%eax
8010551f:	83 e0 03             	and    $0x3,%eax
80105522:	85 c0                	test   %eax,%eax
80105524:	75 39                	jne    8010555f <memset+0x50>
    c &= 0xFF;
80105526:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010552d:	8b 45 10             	mov    0x10(%ebp),%eax
80105530:	c1 e8 02             	shr    $0x2,%eax
80105533:	89 c1                	mov    %eax,%ecx
80105535:	8b 45 0c             	mov    0xc(%ebp),%eax
80105538:	c1 e0 18             	shl    $0x18,%eax
8010553b:	89 c2                	mov    %eax,%edx
8010553d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105540:	c1 e0 10             	shl    $0x10,%eax
80105543:	09 c2                	or     %eax,%edx
80105545:	8b 45 0c             	mov    0xc(%ebp),%eax
80105548:	c1 e0 08             	shl    $0x8,%eax
8010554b:	09 d0                	or     %edx,%eax
8010554d:	0b 45 0c             	or     0xc(%ebp),%eax
80105550:	51                   	push   %ecx
80105551:	50                   	push   %eax
80105552:	ff 75 08             	pushl  0x8(%ebp)
80105555:	e8 8f ff ff ff       	call   801054e9 <stosl>
8010555a:	83 c4 0c             	add    $0xc,%esp
8010555d:	eb 12                	jmp    80105571 <memset+0x62>
  } else
    stosb(dst, c, n);
8010555f:	8b 45 10             	mov    0x10(%ebp),%eax
80105562:	50                   	push   %eax
80105563:	ff 75 0c             	pushl  0xc(%ebp)
80105566:	ff 75 08             	pushl  0x8(%ebp)
80105569:	e8 55 ff ff ff       	call   801054c3 <stosb>
8010556e:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105571:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105574:	c9                   	leave  
80105575:	c3                   	ret    

80105576 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105576:	55                   	push   %ebp
80105577:	89 e5                	mov    %esp,%ebp
80105579:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010557c:	8b 45 08             	mov    0x8(%ebp),%eax
8010557f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105582:	8b 45 0c             	mov    0xc(%ebp),%eax
80105585:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105588:	eb 30                	jmp    801055ba <memcmp+0x44>
    if(*s1 != *s2)
8010558a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010558d:	0f b6 10             	movzbl (%eax),%edx
80105590:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105593:	0f b6 00             	movzbl (%eax),%eax
80105596:	38 c2                	cmp    %al,%dl
80105598:	74 18                	je     801055b2 <memcmp+0x3c>
      return *s1 - *s2;
8010559a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010559d:	0f b6 00             	movzbl (%eax),%eax
801055a0:	0f b6 d0             	movzbl %al,%edx
801055a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055a6:	0f b6 00             	movzbl (%eax),%eax
801055a9:	0f b6 c0             	movzbl %al,%eax
801055ac:	29 c2                	sub    %eax,%edx
801055ae:	89 d0                	mov    %edx,%eax
801055b0:	eb 1a                	jmp    801055cc <memcmp+0x56>
    s1++, s2++;
801055b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801055b6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801055ba:	8b 45 10             	mov    0x10(%ebp),%eax
801055bd:	8d 50 ff             	lea    -0x1(%eax),%edx
801055c0:	89 55 10             	mov    %edx,0x10(%ebp)
801055c3:	85 c0                	test   %eax,%eax
801055c5:	75 c3                	jne    8010558a <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801055c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055cc:	c9                   	leave  
801055cd:	c3                   	ret    

801055ce <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801055ce:	55                   	push   %ebp
801055cf:	89 e5                	mov    %esp,%ebp
801055d1:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801055d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801055d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801055da:	8b 45 08             	mov    0x8(%ebp),%eax
801055dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801055e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801055e6:	73 54                	jae    8010563c <memmove+0x6e>
801055e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055eb:	8b 45 10             	mov    0x10(%ebp),%eax
801055ee:	01 d0                	add    %edx,%eax
801055f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801055f3:	76 47                	jbe    8010563c <memmove+0x6e>
    s += n;
801055f5:	8b 45 10             	mov    0x10(%ebp),%eax
801055f8:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801055fb:	8b 45 10             	mov    0x10(%ebp),%eax
801055fe:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105601:	eb 13                	jmp    80105616 <memmove+0x48>
      *--d = *--s;
80105603:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105607:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010560b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010560e:	0f b6 10             	movzbl (%eax),%edx
80105611:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105614:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105616:	8b 45 10             	mov    0x10(%ebp),%eax
80105619:	8d 50 ff             	lea    -0x1(%eax),%edx
8010561c:	89 55 10             	mov    %edx,0x10(%ebp)
8010561f:	85 c0                	test   %eax,%eax
80105621:	75 e0                	jne    80105603 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105623:	eb 24                	jmp    80105649 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105625:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105628:	8d 50 01             	lea    0x1(%eax),%edx
8010562b:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010562e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105631:	8d 4a 01             	lea    0x1(%edx),%ecx
80105634:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105637:	0f b6 12             	movzbl (%edx),%edx
8010563a:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010563c:	8b 45 10             	mov    0x10(%ebp),%eax
8010563f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105642:	89 55 10             	mov    %edx,0x10(%ebp)
80105645:	85 c0                	test   %eax,%eax
80105647:	75 dc                	jne    80105625 <memmove+0x57>
      *d++ = *s++;

  return dst;
80105649:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010564c:	c9                   	leave  
8010564d:	c3                   	ret    

8010564e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010564e:	55                   	push   %ebp
8010564f:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105651:	ff 75 10             	pushl  0x10(%ebp)
80105654:	ff 75 0c             	pushl  0xc(%ebp)
80105657:	ff 75 08             	pushl  0x8(%ebp)
8010565a:	e8 6f ff ff ff       	call   801055ce <memmove>
8010565f:	83 c4 0c             	add    $0xc,%esp
}
80105662:	c9                   	leave  
80105663:	c3                   	ret    

80105664 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105664:	55                   	push   %ebp
80105665:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105667:	eb 0c                	jmp    80105675 <strncmp+0x11>
    n--, p++, q++;
80105669:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010566d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105671:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105675:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105679:	74 1a                	je     80105695 <strncmp+0x31>
8010567b:	8b 45 08             	mov    0x8(%ebp),%eax
8010567e:	0f b6 00             	movzbl (%eax),%eax
80105681:	84 c0                	test   %al,%al
80105683:	74 10                	je     80105695 <strncmp+0x31>
80105685:	8b 45 08             	mov    0x8(%ebp),%eax
80105688:	0f b6 10             	movzbl (%eax),%edx
8010568b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010568e:	0f b6 00             	movzbl (%eax),%eax
80105691:	38 c2                	cmp    %al,%dl
80105693:	74 d4                	je     80105669 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105695:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105699:	75 07                	jne    801056a2 <strncmp+0x3e>
    return 0;
8010569b:	b8 00 00 00 00       	mov    $0x0,%eax
801056a0:	eb 16                	jmp    801056b8 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801056a2:	8b 45 08             	mov    0x8(%ebp),%eax
801056a5:	0f b6 00             	movzbl (%eax),%eax
801056a8:	0f b6 d0             	movzbl %al,%edx
801056ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801056ae:	0f b6 00             	movzbl (%eax),%eax
801056b1:	0f b6 c0             	movzbl %al,%eax
801056b4:	29 c2                	sub    %eax,%edx
801056b6:	89 d0                	mov    %edx,%eax
}
801056b8:	5d                   	pop    %ebp
801056b9:	c3                   	ret    

801056ba <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801056ba:	55                   	push   %ebp
801056bb:	89 e5                	mov    %esp,%ebp
801056bd:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801056c0:	8b 45 08             	mov    0x8(%ebp),%eax
801056c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801056c6:	90                   	nop
801056c7:	8b 45 10             	mov    0x10(%ebp),%eax
801056ca:	8d 50 ff             	lea    -0x1(%eax),%edx
801056cd:	89 55 10             	mov    %edx,0x10(%ebp)
801056d0:	85 c0                	test   %eax,%eax
801056d2:	7e 2c                	jle    80105700 <strncpy+0x46>
801056d4:	8b 45 08             	mov    0x8(%ebp),%eax
801056d7:	8d 50 01             	lea    0x1(%eax),%edx
801056da:	89 55 08             	mov    %edx,0x8(%ebp)
801056dd:	8b 55 0c             	mov    0xc(%ebp),%edx
801056e0:	8d 4a 01             	lea    0x1(%edx),%ecx
801056e3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801056e6:	0f b6 12             	movzbl (%edx),%edx
801056e9:	88 10                	mov    %dl,(%eax)
801056eb:	0f b6 00             	movzbl (%eax),%eax
801056ee:	84 c0                	test   %al,%al
801056f0:	75 d5                	jne    801056c7 <strncpy+0xd>
    ;
  while(n-- > 0)
801056f2:	eb 0c                	jmp    80105700 <strncpy+0x46>
    *s++ = 0;
801056f4:	8b 45 08             	mov    0x8(%ebp),%eax
801056f7:	8d 50 01             	lea    0x1(%eax),%edx
801056fa:	89 55 08             	mov    %edx,0x8(%ebp)
801056fd:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105700:	8b 45 10             	mov    0x10(%ebp),%eax
80105703:	8d 50 ff             	lea    -0x1(%eax),%edx
80105706:	89 55 10             	mov    %edx,0x10(%ebp)
80105709:	85 c0                	test   %eax,%eax
8010570b:	7f e7                	jg     801056f4 <strncpy+0x3a>
    *s++ = 0;
  return os;
8010570d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105710:	c9                   	leave  
80105711:	c3                   	ret    

80105712 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105712:	55                   	push   %ebp
80105713:	89 e5                	mov    %esp,%ebp
80105715:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105718:	8b 45 08             	mov    0x8(%ebp),%eax
8010571b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010571e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105722:	7f 05                	jg     80105729 <safestrcpy+0x17>
    return os;
80105724:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105727:	eb 31                	jmp    8010575a <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105729:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010572d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105731:	7e 1e                	jle    80105751 <safestrcpy+0x3f>
80105733:	8b 45 08             	mov    0x8(%ebp),%eax
80105736:	8d 50 01             	lea    0x1(%eax),%edx
80105739:	89 55 08             	mov    %edx,0x8(%ebp)
8010573c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010573f:	8d 4a 01             	lea    0x1(%edx),%ecx
80105742:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105745:	0f b6 12             	movzbl (%edx),%edx
80105748:	88 10                	mov    %dl,(%eax)
8010574a:	0f b6 00             	movzbl (%eax),%eax
8010574d:	84 c0                	test   %al,%al
8010574f:	75 d8                	jne    80105729 <safestrcpy+0x17>
    ;
  *s = 0;
80105751:	8b 45 08             	mov    0x8(%ebp),%eax
80105754:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105757:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010575a:	c9                   	leave  
8010575b:	c3                   	ret    

8010575c <strlen>:

int
strlen(const char *s)
{
8010575c:	55                   	push   %ebp
8010575d:	89 e5                	mov    %esp,%ebp
8010575f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105762:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105769:	eb 04                	jmp    8010576f <strlen+0x13>
8010576b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010576f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105772:	8b 45 08             	mov    0x8(%ebp),%eax
80105775:	01 d0                	add    %edx,%eax
80105777:	0f b6 00             	movzbl (%eax),%eax
8010577a:	84 c0                	test   %al,%al
8010577c:	75 ed                	jne    8010576b <strlen+0xf>
    ;
  return n;
8010577e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105781:	c9                   	leave  
80105782:	c3                   	ret    

80105783 <swtch>:
80105783:	8b 44 24 04          	mov    0x4(%esp),%eax
80105787:	8b 54 24 08          	mov    0x8(%esp),%edx
8010578b:	55                   	push   %ebp
8010578c:	53                   	push   %ebx
8010578d:	56                   	push   %esi
8010578e:	57                   	push   %edi
8010578f:	89 20                	mov    %esp,(%eax)
80105791:	89 d4                	mov    %edx,%esp
80105793:	5f                   	pop    %edi
80105794:	5e                   	pop    %esi
80105795:	5b                   	pop    %ebx
80105796:	5d                   	pop    %ebp
80105797:	c3                   	ret    

80105798 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105798:	55                   	push   %ebp
80105799:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010579b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057a1:	8b 00                	mov    (%eax),%eax
801057a3:	3b 45 08             	cmp    0x8(%ebp),%eax
801057a6:	76 12                	jbe    801057ba <fetchint+0x22>
801057a8:	8b 45 08             	mov    0x8(%ebp),%eax
801057ab:	8d 50 04             	lea    0x4(%eax),%edx
801057ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057b4:	8b 00                	mov    (%eax),%eax
801057b6:	39 c2                	cmp    %eax,%edx
801057b8:	76 07                	jbe    801057c1 <fetchint+0x29>
    return -1;
801057ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057bf:	eb 0f                	jmp    801057d0 <fetchint+0x38>
  *ip = *(int*)(addr);
801057c1:	8b 45 08             	mov    0x8(%ebp),%eax
801057c4:	8b 10                	mov    (%eax),%edx
801057c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801057c9:	89 10                	mov    %edx,(%eax)
  return 0;
801057cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057d0:	5d                   	pop    %ebp
801057d1:	c3                   	ret    

801057d2 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801057d2:	55                   	push   %ebp
801057d3:	89 e5                	mov    %esp,%ebp
801057d5:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801057d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057de:	8b 00                	mov    (%eax),%eax
801057e0:	3b 45 08             	cmp    0x8(%ebp),%eax
801057e3:	77 07                	ja     801057ec <fetchstr+0x1a>
    return -1;
801057e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ea:	eb 46                	jmp    80105832 <fetchstr+0x60>
  *pp = (char*)addr;
801057ec:	8b 55 08             	mov    0x8(%ebp),%edx
801057ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801057f2:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801057f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057fa:	8b 00                	mov    (%eax),%eax
801057fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801057ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105802:	8b 00                	mov    (%eax),%eax
80105804:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105807:	eb 1c                	jmp    80105825 <fetchstr+0x53>
    if(*s == 0)
80105809:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010580c:	0f b6 00             	movzbl (%eax),%eax
8010580f:	84 c0                	test   %al,%al
80105811:	75 0e                	jne    80105821 <fetchstr+0x4f>
      return s - *pp;
80105813:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105816:	8b 45 0c             	mov    0xc(%ebp),%eax
80105819:	8b 00                	mov    (%eax),%eax
8010581b:	29 c2                	sub    %eax,%edx
8010581d:	89 d0                	mov    %edx,%eax
8010581f:	eb 11                	jmp    80105832 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105821:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105825:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105828:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010582b:	72 dc                	jb     80105809 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
8010582d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105832:	c9                   	leave  
80105833:	c3                   	ret    

80105834 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105834:	55                   	push   %ebp
80105835:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105837:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010583d:	8b 40 18             	mov    0x18(%eax),%eax
80105840:	8b 40 44             	mov    0x44(%eax),%eax
80105843:	8b 55 08             	mov    0x8(%ebp),%edx
80105846:	c1 e2 02             	shl    $0x2,%edx
80105849:	01 d0                	add    %edx,%eax
8010584b:	83 c0 04             	add    $0x4,%eax
8010584e:	ff 75 0c             	pushl  0xc(%ebp)
80105851:	50                   	push   %eax
80105852:	e8 41 ff ff ff       	call   80105798 <fetchint>
80105857:	83 c4 08             	add    $0x8,%esp
}
8010585a:	c9                   	leave  
8010585b:	c3                   	ret    

8010585c <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010585c:	55                   	push   %ebp
8010585d:	89 e5                	mov    %esp,%ebp
8010585f:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(argint(n, &i) < 0)
80105862:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105865:	50                   	push   %eax
80105866:	ff 75 08             	pushl  0x8(%ebp)
80105869:	e8 c6 ff ff ff       	call   80105834 <argint>
8010586e:	83 c4 08             	add    $0x8,%esp
80105871:	85 c0                	test   %eax,%eax
80105873:	79 07                	jns    8010587c <argptr+0x20>
    return -1;
80105875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587a:	eb 3b                	jmp    801058b7 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010587c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105882:	8b 00                	mov    (%eax),%eax
80105884:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105887:	39 d0                	cmp    %edx,%eax
80105889:	76 16                	jbe    801058a1 <argptr+0x45>
8010588b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010588e:	89 c2                	mov    %eax,%edx
80105890:	8b 45 10             	mov    0x10(%ebp),%eax
80105893:	01 c2                	add    %eax,%edx
80105895:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010589b:	8b 00                	mov    (%eax),%eax
8010589d:	39 c2                	cmp    %eax,%edx
8010589f:	76 07                	jbe    801058a8 <argptr+0x4c>
    return -1;
801058a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a6:	eb 0f                	jmp    801058b7 <argptr+0x5b>
  *pp = (char*)i;
801058a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058ab:	89 c2                	mov    %eax,%edx
801058ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801058b0:	89 10                	mov    %edx,(%eax)
  return 0;
801058b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058b7:	c9                   	leave  
801058b8:	c3                   	ret    

801058b9 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801058b9:	55                   	push   %ebp
801058ba:	89 e5                	mov    %esp,%ebp
801058bc:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
801058bf:	8d 45 fc             	lea    -0x4(%ebp),%eax
801058c2:	50                   	push   %eax
801058c3:	ff 75 08             	pushl  0x8(%ebp)
801058c6:	e8 69 ff ff ff       	call   80105834 <argint>
801058cb:	83 c4 08             	add    $0x8,%esp
801058ce:	85 c0                	test   %eax,%eax
801058d0:	79 07                	jns    801058d9 <argstr+0x20>
    return -1;
801058d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d7:	eb 0f                	jmp    801058e8 <argstr+0x2f>
  return fetchstr(addr, pp);
801058d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058dc:	ff 75 0c             	pushl  0xc(%ebp)
801058df:	50                   	push   %eax
801058e0:	e8 ed fe ff ff       	call   801057d2 <fetchstr>
801058e5:	83 c4 08             	add    $0x8,%esp
}
801058e8:	c9                   	leave  
801058e9:	c3                   	ret    

801058ea <syscall>:
[SYS_cowfork] sys_cowfork,
};

void
syscall(void)
{
801058ea:	55                   	push   %ebp
801058eb:	89 e5                	mov    %esp,%ebp
801058ed:	53                   	push   %ebx
801058ee:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801058f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058f7:	8b 40 18             	mov    0x18(%eax),%eax
801058fa:	8b 40 1c             	mov    0x1c(%eax),%eax
801058fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105900:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105904:	7e 30                	jle    80105936 <syscall+0x4c>
80105906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105909:	83 f8 1a             	cmp    $0x1a,%eax
8010590c:	77 28                	ja     80105936 <syscall+0x4c>
8010590e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105911:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105918:	85 c0                	test   %eax,%eax
8010591a:	74 1a                	je     80105936 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
8010591c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105922:	8b 58 18             	mov    0x18(%eax),%ebx
80105925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105928:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010592f:	ff d0                	call   *%eax
80105931:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105934:	eb 34                	jmp    8010596a <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105936:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010593c:	8d 50 6c             	lea    0x6c(%eax),%edx
8010593f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105945:	8b 40 10             	mov    0x10(%eax),%eax
80105948:	ff 75 f4             	pushl  -0xc(%ebp)
8010594b:	52                   	push   %edx
8010594c:	50                   	push   %eax
8010594d:	68 08 91 10 80       	push   $0x80109108
80105952:	e8 6f aa ff ff       	call   801003c6 <cprintf>
80105957:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010595a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105960:	8b 40 18             	mov    0x18(%eax),%eax
80105963:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010596a:	90                   	nop
8010596b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010596e:	c9                   	leave  
8010596f:	c3                   	ret    

80105970 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105976:	83 ec 08             	sub    $0x8,%esp
80105979:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010597c:	50                   	push   %eax
8010597d:	ff 75 08             	pushl  0x8(%ebp)
80105980:	e8 af fe ff ff       	call   80105834 <argint>
80105985:	83 c4 10             	add    $0x10,%esp
80105988:	85 c0                	test   %eax,%eax
8010598a:	79 07                	jns    80105993 <argfd+0x23>
    return -1;
8010598c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105991:	eb 50                	jmp    801059e3 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105993:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105996:	85 c0                	test   %eax,%eax
80105998:	78 21                	js     801059bb <argfd+0x4b>
8010599a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010599d:	83 f8 0f             	cmp    $0xf,%eax
801059a0:	7f 19                	jg     801059bb <argfd+0x4b>
801059a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801059ab:	83 c2 08             	add    $0x8,%edx
801059ae:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801059b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059b9:	75 07                	jne    801059c2 <argfd+0x52>
    return -1;
801059bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c0:	eb 21                	jmp    801059e3 <argfd+0x73>
  if(pfd)
801059c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801059c6:	74 08                	je     801059d0 <argfd+0x60>
    *pfd = fd;
801059c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801059cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801059ce:	89 10                	mov    %edx,(%eax)
  if(pf)
801059d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059d4:	74 08                	je     801059de <argfd+0x6e>
    *pf = f;
801059d6:	8b 45 10             	mov    0x10(%ebp),%eax
801059d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059dc:	89 10                	mov    %edx,(%eax)
  return 0;
801059de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059e3:	c9                   	leave  
801059e4:	c3                   	ret    

801059e5 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801059e5:	55                   	push   %ebp
801059e6:	89 e5                	mov    %esp,%ebp
801059e8:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801059eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801059f2:	eb 30                	jmp    80105a24 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801059f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059fd:	83 c2 08             	add    $0x8,%edx
80105a00:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a04:	85 c0                	test   %eax,%eax
80105a06:	75 18                	jne    80105a20 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105a08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a11:	8d 4a 08             	lea    0x8(%edx),%ecx
80105a14:	8b 55 08             	mov    0x8(%ebp),%edx
80105a17:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a1e:	eb 0f                	jmp    80105a2f <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105a20:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a24:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105a28:	7e ca                	jle    801059f4 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105a2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a2f:	c9                   	leave  
80105a30:	c3                   	ret    

80105a31 <sys_dup>:

int
sys_dup(void)
{
80105a31:	55                   	push   %ebp
80105a32:	89 e5                	mov    %esp,%ebp
80105a34:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105a37:	83 ec 04             	sub    $0x4,%esp
80105a3a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a3d:	50                   	push   %eax
80105a3e:	6a 00                	push   $0x0
80105a40:	6a 00                	push   $0x0
80105a42:	e8 29 ff ff ff       	call   80105970 <argfd>
80105a47:	83 c4 10             	add    $0x10,%esp
80105a4a:	85 c0                	test   %eax,%eax
80105a4c:	79 07                	jns    80105a55 <sys_dup+0x24>
    return -1;
80105a4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a53:	eb 31                	jmp    80105a86 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a58:	83 ec 0c             	sub    $0xc,%esp
80105a5b:	50                   	push   %eax
80105a5c:	e8 84 ff ff ff       	call   801059e5 <fdalloc>
80105a61:	83 c4 10             	add    $0x10,%esp
80105a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a6b:	79 07                	jns    80105a74 <sys_dup+0x43>
    return -1;
80105a6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a72:	eb 12                	jmp    80105a86 <sys_dup+0x55>
  filedup(f);
80105a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a77:	83 ec 0c             	sub    $0xc,%esp
80105a7a:	50                   	push   %eax
80105a7b:	e8 65 b5 ff ff       	call   80100fe5 <filedup>
80105a80:	83 c4 10             	add    $0x10,%esp
  return fd;
80105a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105a86:	c9                   	leave  
80105a87:	c3                   	ret    

80105a88 <sys_read>:

int
sys_read(void)
{
80105a88:	55                   	push   %ebp
80105a89:	89 e5                	mov    %esp,%ebp
80105a8b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a8e:	83 ec 04             	sub    $0x4,%esp
80105a91:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a94:	50                   	push   %eax
80105a95:	6a 00                	push   $0x0
80105a97:	6a 00                	push   $0x0
80105a99:	e8 d2 fe ff ff       	call   80105970 <argfd>
80105a9e:	83 c4 10             	add    $0x10,%esp
80105aa1:	85 c0                	test   %eax,%eax
80105aa3:	78 2e                	js     80105ad3 <sys_read+0x4b>
80105aa5:	83 ec 08             	sub    $0x8,%esp
80105aa8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105aab:	50                   	push   %eax
80105aac:	6a 02                	push   $0x2
80105aae:	e8 81 fd ff ff       	call   80105834 <argint>
80105ab3:	83 c4 10             	add    $0x10,%esp
80105ab6:	85 c0                	test   %eax,%eax
80105ab8:	78 19                	js     80105ad3 <sys_read+0x4b>
80105aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105abd:	83 ec 04             	sub    $0x4,%esp
80105ac0:	50                   	push   %eax
80105ac1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ac4:	50                   	push   %eax
80105ac5:	6a 01                	push   $0x1
80105ac7:	e8 90 fd ff ff       	call   8010585c <argptr>
80105acc:	83 c4 10             	add    $0x10,%esp
80105acf:	85 c0                	test   %eax,%eax
80105ad1:	79 07                	jns    80105ada <sys_read+0x52>
    return -1;
80105ad3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad8:	eb 17                	jmp    80105af1 <sys_read+0x69>
  return fileread(f, p, n);
80105ada:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105add:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae3:	83 ec 04             	sub    $0x4,%esp
80105ae6:	51                   	push   %ecx
80105ae7:	52                   	push   %edx
80105ae8:	50                   	push   %eax
80105ae9:	e8 87 b6 ff ff       	call   80101175 <fileread>
80105aee:	83 c4 10             	add    $0x10,%esp
}
80105af1:	c9                   	leave  
80105af2:	c3                   	ret    

80105af3 <sys_write>:

int
sys_write(void)
{
80105af3:	55                   	push   %ebp
80105af4:	89 e5                	mov    %esp,%ebp
80105af6:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105af9:	83 ec 04             	sub    $0x4,%esp
80105afc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aff:	50                   	push   %eax
80105b00:	6a 00                	push   $0x0
80105b02:	6a 00                	push   $0x0
80105b04:	e8 67 fe ff ff       	call   80105970 <argfd>
80105b09:	83 c4 10             	add    $0x10,%esp
80105b0c:	85 c0                	test   %eax,%eax
80105b0e:	78 2e                	js     80105b3e <sys_write+0x4b>
80105b10:	83 ec 08             	sub    $0x8,%esp
80105b13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b16:	50                   	push   %eax
80105b17:	6a 02                	push   $0x2
80105b19:	e8 16 fd ff ff       	call   80105834 <argint>
80105b1e:	83 c4 10             	add    $0x10,%esp
80105b21:	85 c0                	test   %eax,%eax
80105b23:	78 19                	js     80105b3e <sys_write+0x4b>
80105b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b28:	83 ec 04             	sub    $0x4,%esp
80105b2b:	50                   	push   %eax
80105b2c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b2f:	50                   	push   %eax
80105b30:	6a 01                	push   $0x1
80105b32:	e8 25 fd ff ff       	call   8010585c <argptr>
80105b37:	83 c4 10             	add    $0x10,%esp
80105b3a:	85 c0                	test   %eax,%eax
80105b3c:	79 07                	jns    80105b45 <sys_write+0x52>
    return -1;
80105b3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b43:	eb 17                	jmp    80105b5c <sys_write+0x69>
  return filewrite(f, p, n);
80105b45:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b48:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b4e:	83 ec 04             	sub    $0x4,%esp
80105b51:	51                   	push   %ecx
80105b52:	52                   	push   %edx
80105b53:	50                   	push   %eax
80105b54:	e8 d4 b6 ff ff       	call   8010122d <filewrite>
80105b59:	83 c4 10             	add    $0x10,%esp
}
80105b5c:	c9                   	leave  
80105b5d:	c3                   	ret    

80105b5e <sys_close>:

int
sys_close(void)
{
80105b5e:	55                   	push   %ebp
80105b5f:	89 e5                	mov    %esp,%ebp
80105b61:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105b64:	83 ec 04             	sub    $0x4,%esp
80105b67:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b6a:	50                   	push   %eax
80105b6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b6e:	50                   	push   %eax
80105b6f:	6a 00                	push   $0x0
80105b71:	e8 fa fd ff ff       	call   80105970 <argfd>
80105b76:	83 c4 10             	add    $0x10,%esp
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	79 07                	jns    80105b84 <sys_close+0x26>
    return -1;
80105b7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b82:	eb 28                	jmp    80105bac <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105b84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b8d:	83 c2 08             	add    $0x8,%edx
80105b90:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105b97:	00 
  fileclose(f);
80105b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b9b:	83 ec 0c             	sub    $0xc,%esp
80105b9e:	50                   	push   %eax
80105b9f:	e8 92 b4 ff ff       	call   80101036 <fileclose>
80105ba4:	83 c4 10             	add    $0x10,%esp
  return 0;
80105ba7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bac:	c9                   	leave  
80105bad:	c3                   	ret    

80105bae <sys_fstat>:

int
sys_fstat(void)
{
80105bae:	55                   	push   %ebp
80105baf:	89 e5                	mov    %esp,%ebp
80105bb1:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105bb4:	83 ec 04             	sub    $0x4,%esp
80105bb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bba:	50                   	push   %eax
80105bbb:	6a 00                	push   $0x0
80105bbd:	6a 00                	push   $0x0
80105bbf:	e8 ac fd ff ff       	call   80105970 <argfd>
80105bc4:	83 c4 10             	add    $0x10,%esp
80105bc7:	85 c0                	test   %eax,%eax
80105bc9:	78 17                	js     80105be2 <sys_fstat+0x34>
80105bcb:	83 ec 04             	sub    $0x4,%esp
80105bce:	6a 14                	push   $0x14
80105bd0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bd3:	50                   	push   %eax
80105bd4:	6a 01                	push   $0x1
80105bd6:	e8 81 fc ff ff       	call   8010585c <argptr>
80105bdb:	83 c4 10             	add    $0x10,%esp
80105bde:	85 c0                	test   %eax,%eax
80105be0:	79 07                	jns    80105be9 <sys_fstat+0x3b>
    return -1;
80105be2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be7:	eb 13                	jmp    80105bfc <sys_fstat+0x4e>
  return filestat(f, st);
80105be9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bef:	83 ec 08             	sub    $0x8,%esp
80105bf2:	52                   	push   %edx
80105bf3:	50                   	push   %eax
80105bf4:	e8 25 b5 ff ff       	call   8010111e <filestat>
80105bf9:	83 c4 10             	add    $0x10,%esp
}
80105bfc:	c9                   	leave  
80105bfd:	c3                   	ret    

80105bfe <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105bfe:	55                   	push   %ebp
80105bff:	89 e5                	mov    %esp,%ebp
80105c01:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105c04:	83 ec 08             	sub    $0x8,%esp
80105c07:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c0a:	50                   	push   %eax
80105c0b:	6a 00                	push   $0x0
80105c0d:	e8 a7 fc ff ff       	call   801058b9 <argstr>
80105c12:	83 c4 10             	add    $0x10,%esp
80105c15:	85 c0                	test   %eax,%eax
80105c17:	78 15                	js     80105c2e <sys_link+0x30>
80105c19:	83 ec 08             	sub    $0x8,%esp
80105c1c:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105c1f:	50                   	push   %eax
80105c20:	6a 01                	push   $0x1
80105c22:	e8 92 fc ff ff       	call   801058b9 <argstr>
80105c27:	83 c4 10             	add    $0x10,%esp
80105c2a:	85 c0                	test   %eax,%eax
80105c2c:	79 0a                	jns    80105c38 <sys_link+0x3a>
    return -1;
80105c2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c33:	e9 68 01 00 00       	jmp    80105da0 <sys_link+0x1a2>

  begin_op();
80105c38:	e8 77 d8 ff ff       	call   801034b4 <begin_op>
  if((ip = namei(old)) == 0){
80105c3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105c40:	83 ec 0c             	sub    $0xc,%esp
80105c43:	50                   	push   %eax
80105c44:	e8 7a c8 ff ff       	call   801024c3 <namei>
80105c49:	83 c4 10             	add    $0x10,%esp
80105c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c53:	75 0f                	jne    80105c64 <sys_link+0x66>
    end_op();
80105c55:	e8 e6 d8 ff ff       	call   80103540 <end_op>
    return -1;
80105c5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c5f:	e9 3c 01 00 00       	jmp    80105da0 <sys_link+0x1a2>
  }

  ilock(ip);
80105c64:	83 ec 0c             	sub    $0xc,%esp
80105c67:	ff 75 f4             	pushl  -0xc(%ebp)
80105c6a:	e8 9c bc ff ff       	call   8010190b <ilock>
80105c6f:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c75:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c79:	66 83 f8 01          	cmp    $0x1,%ax
80105c7d:	75 1d                	jne    80105c9c <sys_link+0x9e>
    iunlockput(ip);
80105c7f:	83 ec 0c             	sub    $0xc,%esp
80105c82:	ff 75 f4             	pushl  -0xc(%ebp)
80105c85:	e8 3b bf ff ff       	call   80101bc5 <iunlockput>
80105c8a:	83 c4 10             	add    $0x10,%esp
    end_op();
80105c8d:	e8 ae d8 ff ff       	call   80103540 <end_op>
    return -1;
80105c92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c97:	e9 04 01 00 00       	jmp    80105da0 <sys_link+0x1a2>
  }

  ip->nlink++;
80105c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ca3:	83 c0 01             	add    $0x1,%eax
80105ca6:	89 c2                	mov    %eax,%edx
80105ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cab:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105caf:	83 ec 0c             	sub    $0xc,%esp
80105cb2:	ff 75 f4             	pushl  -0xc(%ebp)
80105cb5:	e8 7d ba ff ff       	call   80101737 <iupdate>
80105cba:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105cbd:	83 ec 0c             	sub    $0xc,%esp
80105cc0:	ff 75 f4             	pushl  -0xc(%ebp)
80105cc3:	e8 9b bd ff ff       	call   80101a63 <iunlock>
80105cc8:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105ccb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cce:	83 ec 08             	sub    $0x8,%esp
80105cd1:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105cd4:	52                   	push   %edx
80105cd5:	50                   	push   %eax
80105cd6:	e8 04 c8 ff ff       	call   801024df <nameiparent>
80105cdb:	83 c4 10             	add    $0x10,%esp
80105cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ce1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ce5:	74 71                	je     80105d58 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105ce7:	83 ec 0c             	sub    $0xc,%esp
80105cea:	ff 75 f0             	pushl  -0x10(%ebp)
80105ced:	e8 19 bc ff ff       	call   8010190b <ilock>
80105cf2:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf8:	8b 10                	mov    (%eax),%edx
80105cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfd:	8b 00                	mov    (%eax),%eax
80105cff:	39 c2                	cmp    %eax,%edx
80105d01:	75 1d                	jne    80105d20 <sys_link+0x122>
80105d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d06:	8b 40 04             	mov    0x4(%eax),%eax
80105d09:	83 ec 04             	sub    $0x4,%esp
80105d0c:	50                   	push   %eax
80105d0d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105d10:	50                   	push   %eax
80105d11:	ff 75 f0             	pushl  -0x10(%ebp)
80105d14:	e8 0e c5 ff ff       	call   80102227 <dirlink>
80105d19:	83 c4 10             	add    $0x10,%esp
80105d1c:	85 c0                	test   %eax,%eax
80105d1e:	79 10                	jns    80105d30 <sys_link+0x132>
    iunlockput(dp);
80105d20:	83 ec 0c             	sub    $0xc,%esp
80105d23:	ff 75 f0             	pushl  -0x10(%ebp)
80105d26:	e8 9a be ff ff       	call   80101bc5 <iunlockput>
80105d2b:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105d2e:	eb 29                	jmp    80105d59 <sys_link+0x15b>
  }
  iunlockput(dp);
80105d30:	83 ec 0c             	sub    $0xc,%esp
80105d33:	ff 75 f0             	pushl  -0x10(%ebp)
80105d36:	e8 8a be ff ff       	call   80101bc5 <iunlockput>
80105d3b:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105d3e:	83 ec 0c             	sub    $0xc,%esp
80105d41:	ff 75 f4             	pushl  -0xc(%ebp)
80105d44:	e8 8c bd ff ff       	call   80101ad5 <iput>
80105d49:	83 c4 10             	add    $0x10,%esp

  end_op();
80105d4c:	e8 ef d7 ff ff       	call   80103540 <end_op>

  return 0;
80105d51:	b8 00 00 00 00       	mov    $0x0,%eax
80105d56:	eb 48                	jmp    80105da0 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105d58:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105d59:	83 ec 0c             	sub    $0xc,%esp
80105d5c:	ff 75 f4             	pushl  -0xc(%ebp)
80105d5f:	e8 a7 bb ff ff       	call   8010190b <ilock>
80105d64:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d6a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d6e:	83 e8 01             	sub    $0x1,%eax
80105d71:	89 c2                	mov    %eax,%edx
80105d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d76:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105d7a:	83 ec 0c             	sub    $0xc,%esp
80105d7d:	ff 75 f4             	pushl  -0xc(%ebp)
80105d80:	e8 b2 b9 ff ff       	call   80101737 <iupdate>
80105d85:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105d88:	83 ec 0c             	sub    $0xc,%esp
80105d8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d8e:	e8 32 be ff ff       	call   80101bc5 <iunlockput>
80105d93:	83 c4 10             	add    $0x10,%esp
  end_op();
80105d96:	e8 a5 d7 ff ff       	call   80103540 <end_op>
  return -1;
80105d9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105da0:	c9                   	leave  
80105da1:	c3                   	ret    

80105da2 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105da2:	55                   	push   %ebp
80105da3:	89 e5                	mov    %esp,%ebp
80105da5:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105da8:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105daf:	eb 40                	jmp    80105df1 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db4:	6a 10                	push   $0x10
80105db6:	50                   	push   %eax
80105db7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105dba:	50                   	push   %eax
80105dbb:	ff 75 08             	pushl  0x8(%ebp)
80105dbe:	e8 b0 c0 ff ff       	call   80101e73 <readi>
80105dc3:	83 c4 10             	add    $0x10,%esp
80105dc6:	83 f8 10             	cmp    $0x10,%eax
80105dc9:	74 0d                	je     80105dd8 <isdirempty+0x36>
      panic("isdirempty: readi");
80105dcb:	83 ec 0c             	sub    $0xc,%esp
80105dce:	68 24 91 10 80       	push   $0x80109124
80105dd3:	e8 8e a7 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80105dd8:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105ddc:	66 85 c0             	test   %ax,%ax
80105ddf:	74 07                	je     80105de8 <isdirempty+0x46>
      return 0;
80105de1:	b8 00 00 00 00       	mov    $0x0,%eax
80105de6:	eb 1b                	jmp    80105e03 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105deb:	83 c0 10             	add    $0x10,%eax
80105dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105df1:	8b 45 08             	mov    0x8(%ebp),%eax
80105df4:	8b 50 18             	mov    0x18(%eax),%edx
80105df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfa:	39 c2                	cmp    %eax,%edx
80105dfc:	77 b3                	ja     80105db1 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105dfe:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105e03:	c9                   	leave  
80105e04:	c3                   	ret    

80105e05 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105e05:	55                   	push   %ebp
80105e06:	89 e5                	mov    %esp,%ebp
80105e08:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105e0b:	83 ec 08             	sub    $0x8,%esp
80105e0e:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105e11:	50                   	push   %eax
80105e12:	6a 00                	push   $0x0
80105e14:	e8 a0 fa ff ff       	call   801058b9 <argstr>
80105e19:	83 c4 10             	add    $0x10,%esp
80105e1c:	85 c0                	test   %eax,%eax
80105e1e:	79 0a                	jns    80105e2a <sys_unlink+0x25>
    return -1;
80105e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e25:	e9 bc 01 00 00       	jmp    80105fe6 <sys_unlink+0x1e1>

  begin_op();
80105e2a:	e8 85 d6 ff ff       	call   801034b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105e2f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105e32:	83 ec 08             	sub    $0x8,%esp
80105e35:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105e38:	52                   	push   %edx
80105e39:	50                   	push   %eax
80105e3a:	e8 a0 c6 ff ff       	call   801024df <nameiparent>
80105e3f:	83 c4 10             	add    $0x10,%esp
80105e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e49:	75 0f                	jne    80105e5a <sys_unlink+0x55>
    end_op();
80105e4b:	e8 f0 d6 ff ff       	call   80103540 <end_op>
    return -1;
80105e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e55:	e9 8c 01 00 00       	jmp    80105fe6 <sys_unlink+0x1e1>
  }

  ilock(dp);
80105e5a:	83 ec 0c             	sub    $0xc,%esp
80105e5d:	ff 75 f4             	pushl  -0xc(%ebp)
80105e60:	e8 a6 ba ff ff       	call   8010190b <ilock>
80105e65:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105e68:	83 ec 08             	sub    $0x8,%esp
80105e6b:	68 36 91 10 80       	push   $0x80109136
80105e70:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e73:	50                   	push   %eax
80105e74:	e8 d9 c2 ff ff       	call   80102152 <namecmp>
80105e79:	83 c4 10             	add    $0x10,%esp
80105e7c:	85 c0                	test   %eax,%eax
80105e7e:	0f 84 4a 01 00 00    	je     80105fce <sys_unlink+0x1c9>
80105e84:	83 ec 08             	sub    $0x8,%esp
80105e87:	68 38 91 10 80       	push   $0x80109138
80105e8c:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e8f:	50                   	push   %eax
80105e90:	e8 bd c2 ff ff       	call   80102152 <namecmp>
80105e95:	83 c4 10             	add    $0x10,%esp
80105e98:	85 c0                	test   %eax,%eax
80105e9a:	0f 84 2e 01 00 00    	je     80105fce <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105ea0:	83 ec 04             	sub    $0x4,%esp
80105ea3:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105ea6:	50                   	push   %eax
80105ea7:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105eaa:	50                   	push   %eax
80105eab:	ff 75 f4             	pushl  -0xc(%ebp)
80105eae:	e8 ba c2 ff ff       	call   8010216d <dirlookup>
80105eb3:	83 c4 10             	add    $0x10,%esp
80105eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105eb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ebd:	0f 84 0a 01 00 00    	je     80105fcd <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80105ec3:	83 ec 0c             	sub    $0xc,%esp
80105ec6:	ff 75 f0             	pushl  -0x10(%ebp)
80105ec9:	e8 3d ba ff ff       	call   8010190b <ilock>
80105ece:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ed8:	66 85 c0             	test   %ax,%ax
80105edb:	7f 0d                	jg     80105eea <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105edd:	83 ec 0c             	sub    $0xc,%esp
80105ee0:	68 3b 91 10 80       	push   $0x8010913b
80105ee5:	e8 7c a6 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eed:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ef1:	66 83 f8 01          	cmp    $0x1,%ax
80105ef5:	75 25                	jne    80105f1c <sys_unlink+0x117>
80105ef7:	83 ec 0c             	sub    $0xc,%esp
80105efa:	ff 75 f0             	pushl  -0x10(%ebp)
80105efd:	e8 a0 fe ff ff       	call   80105da2 <isdirempty>
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	85 c0                	test   %eax,%eax
80105f07:	75 13                	jne    80105f1c <sys_unlink+0x117>
    iunlockput(ip);
80105f09:	83 ec 0c             	sub    $0xc,%esp
80105f0c:	ff 75 f0             	pushl  -0x10(%ebp)
80105f0f:	e8 b1 bc ff ff       	call   80101bc5 <iunlockput>
80105f14:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105f17:	e9 b2 00 00 00       	jmp    80105fce <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105f1c:	83 ec 04             	sub    $0x4,%esp
80105f1f:	6a 10                	push   $0x10
80105f21:	6a 00                	push   $0x0
80105f23:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f26:	50                   	push   %eax
80105f27:	e8 e3 f5 ff ff       	call   8010550f <memset>
80105f2c:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105f32:	6a 10                	push   $0x10
80105f34:	50                   	push   %eax
80105f35:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f38:	50                   	push   %eax
80105f39:	ff 75 f4             	pushl  -0xc(%ebp)
80105f3c:	e8 89 c0 ff ff       	call   80101fca <writei>
80105f41:	83 c4 10             	add    $0x10,%esp
80105f44:	83 f8 10             	cmp    $0x10,%eax
80105f47:	74 0d                	je     80105f56 <sys_unlink+0x151>
    panic("unlink: writei");
80105f49:	83 ec 0c             	sub    $0xc,%esp
80105f4c:	68 4d 91 10 80       	push   $0x8010914d
80105f51:	e8 10 a6 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80105f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f59:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f5d:	66 83 f8 01          	cmp    $0x1,%ax
80105f61:	75 21                	jne    80105f84 <sys_unlink+0x17f>
    dp->nlink--;
80105f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f66:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f6a:	83 e8 01             	sub    $0x1,%eax
80105f6d:	89 c2                	mov    %eax,%edx
80105f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f72:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105f76:	83 ec 0c             	sub    $0xc,%esp
80105f79:	ff 75 f4             	pushl  -0xc(%ebp)
80105f7c:	e8 b6 b7 ff ff       	call   80101737 <iupdate>
80105f81:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105f84:	83 ec 0c             	sub    $0xc,%esp
80105f87:	ff 75 f4             	pushl  -0xc(%ebp)
80105f8a:	e8 36 bc ff ff       	call   80101bc5 <iunlockput>
80105f8f:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f95:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f99:	83 e8 01             	sub    $0x1,%eax
80105f9c:	89 c2                	mov    %eax,%edx
80105f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa1:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105fa5:	83 ec 0c             	sub    $0xc,%esp
80105fa8:	ff 75 f0             	pushl  -0x10(%ebp)
80105fab:	e8 87 b7 ff ff       	call   80101737 <iupdate>
80105fb0:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105fb3:	83 ec 0c             	sub    $0xc,%esp
80105fb6:	ff 75 f0             	pushl  -0x10(%ebp)
80105fb9:	e8 07 bc ff ff       	call   80101bc5 <iunlockput>
80105fbe:	83 c4 10             	add    $0x10,%esp

  end_op();
80105fc1:	e8 7a d5 ff ff       	call   80103540 <end_op>

  return 0;
80105fc6:	b8 00 00 00 00       	mov    $0x0,%eax
80105fcb:	eb 19                	jmp    80105fe6 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105fcd:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105fce:	83 ec 0c             	sub    $0xc,%esp
80105fd1:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd4:	e8 ec bb ff ff       	call   80101bc5 <iunlockput>
80105fd9:	83 c4 10             	add    $0x10,%esp
  end_op();
80105fdc:	e8 5f d5 ff ff       	call   80103540 <end_op>
  return -1;
80105fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fe6:	c9                   	leave  
80105fe7:	c3                   	ret    

80105fe8 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105fe8:	55                   	push   %ebp
80105fe9:	89 e5                	mov    %esp,%ebp
80105feb:	83 ec 38             	sub    $0x38,%esp
80105fee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105ff1:	8b 55 10             	mov    0x10(%ebp),%edx
80105ff4:	8b 45 14             	mov    0x14(%ebp),%eax
80105ff7:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105ffb:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105fff:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106003:	83 ec 08             	sub    $0x8,%esp
80106006:	8d 45 de             	lea    -0x22(%ebp),%eax
80106009:	50                   	push   %eax
8010600a:	ff 75 08             	pushl  0x8(%ebp)
8010600d:	e8 cd c4 ff ff       	call   801024df <nameiparent>
80106012:	83 c4 10             	add    $0x10,%esp
80106015:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106018:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010601c:	75 0a                	jne    80106028 <create+0x40>
    return 0;
8010601e:	b8 00 00 00 00       	mov    $0x0,%eax
80106023:	e9 90 01 00 00       	jmp    801061b8 <create+0x1d0>
  ilock(dp);
80106028:	83 ec 0c             	sub    $0xc,%esp
8010602b:	ff 75 f4             	pushl  -0xc(%ebp)
8010602e:	e8 d8 b8 ff ff       	call   8010190b <ilock>
80106033:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80106036:	83 ec 04             	sub    $0x4,%esp
80106039:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010603c:	50                   	push   %eax
8010603d:	8d 45 de             	lea    -0x22(%ebp),%eax
80106040:	50                   	push   %eax
80106041:	ff 75 f4             	pushl  -0xc(%ebp)
80106044:	e8 24 c1 ff ff       	call   8010216d <dirlookup>
80106049:	83 c4 10             	add    $0x10,%esp
8010604c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010604f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106053:	74 50                	je     801060a5 <create+0xbd>
    iunlockput(dp);
80106055:	83 ec 0c             	sub    $0xc,%esp
80106058:	ff 75 f4             	pushl  -0xc(%ebp)
8010605b:	e8 65 bb ff ff       	call   80101bc5 <iunlockput>
80106060:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106063:	83 ec 0c             	sub    $0xc,%esp
80106066:	ff 75 f0             	pushl  -0x10(%ebp)
80106069:	e8 9d b8 ff ff       	call   8010190b <ilock>
8010606e:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106071:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106076:	75 15                	jne    8010608d <create+0xa5>
80106078:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010607b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010607f:	66 83 f8 02          	cmp    $0x2,%ax
80106083:	75 08                	jne    8010608d <create+0xa5>
      return ip;
80106085:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106088:	e9 2b 01 00 00       	jmp    801061b8 <create+0x1d0>
    iunlockput(ip);
8010608d:	83 ec 0c             	sub    $0xc,%esp
80106090:	ff 75 f0             	pushl  -0x10(%ebp)
80106093:	e8 2d bb ff ff       	call   80101bc5 <iunlockput>
80106098:	83 c4 10             	add    $0x10,%esp
    return 0;
8010609b:	b8 00 00 00 00       	mov    $0x0,%eax
801060a0:	e9 13 01 00 00       	jmp    801061b8 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801060a5:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801060a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ac:	8b 00                	mov    (%eax),%eax
801060ae:	83 ec 08             	sub    $0x8,%esp
801060b1:	52                   	push   %edx
801060b2:	50                   	push   %eax
801060b3:	e8 9e b5 ff ff       	call   80101656 <ialloc>
801060b8:	83 c4 10             	add    $0x10,%esp
801060bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060c2:	75 0d                	jne    801060d1 <create+0xe9>
    panic("create: ialloc");
801060c4:	83 ec 0c             	sub    $0xc,%esp
801060c7:	68 5c 91 10 80       	push   $0x8010915c
801060cc:	e8 95 a4 ff ff       	call   80100566 <panic>

  ilock(ip);
801060d1:	83 ec 0c             	sub    $0xc,%esp
801060d4:	ff 75 f0             	pushl  -0x10(%ebp)
801060d7:	e8 2f b8 ff ff       	call   8010190b <ilock>
801060dc:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801060df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060e2:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801060e6:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801060ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ed:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801060f1:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801060f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060f8:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801060fe:	83 ec 0c             	sub    $0xc,%esp
80106101:	ff 75 f0             	pushl  -0x10(%ebp)
80106104:	e8 2e b6 ff ff       	call   80101737 <iupdate>
80106109:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010610c:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106111:	75 6a                	jne    8010617d <create+0x195>
    dp->nlink++;  // for ".."
80106113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106116:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010611a:	83 c0 01             	add    $0x1,%eax
8010611d:	89 c2                	mov    %eax,%edx
8010611f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106122:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106126:	83 ec 0c             	sub    $0xc,%esp
80106129:	ff 75 f4             	pushl  -0xc(%ebp)
8010612c:	e8 06 b6 ff ff       	call   80101737 <iupdate>
80106131:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106134:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106137:	8b 40 04             	mov    0x4(%eax),%eax
8010613a:	83 ec 04             	sub    $0x4,%esp
8010613d:	50                   	push   %eax
8010613e:	68 36 91 10 80       	push   $0x80109136
80106143:	ff 75 f0             	pushl  -0x10(%ebp)
80106146:	e8 dc c0 ff ff       	call   80102227 <dirlink>
8010614b:	83 c4 10             	add    $0x10,%esp
8010614e:	85 c0                	test   %eax,%eax
80106150:	78 1e                	js     80106170 <create+0x188>
80106152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106155:	8b 40 04             	mov    0x4(%eax),%eax
80106158:	83 ec 04             	sub    $0x4,%esp
8010615b:	50                   	push   %eax
8010615c:	68 38 91 10 80       	push   $0x80109138
80106161:	ff 75 f0             	pushl  -0x10(%ebp)
80106164:	e8 be c0 ff ff       	call   80102227 <dirlink>
80106169:	83 c4 10             	add    $0x10,%esp
8010616c:	85 c0                	test   %eax,%eax
8010616e:	79 0d                	jns    8010617d <create+0x195>
      panic("create dots");
80106170:	83 ec 0c             	sub    $0xc,%esp
80106173:	68 6b 91 10 80       	push   $0x8010916b
80106178:	e8 e9 a3 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010617d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106180:	8b 40 04             	mov    0x4(%eax),%eax
80106183:	83 ec 04             	sub    $0x4,%esp
80106186:	50                   	push   %eax
80106187:	8d 45 de             	lea    -0x22(%ebp),%eax
8010618a:	50                   	push   %eax
8010618b:	ff 75 f4             	pushl  -0xc(%ebp)
8010618e:	e8 94 c0 ff ff       	call   80102227 <dirlink>
80106193:	83 c4 10             	add    $0x10,%esp
80106196:	85 c0                	test   %eax,%eax
80106198:	79 0d                	jns    801061a7 <create+0x1bf>
    panic("create: dirlink");
8010619a:	83 ec 0c             	sub    $0xc,%esp
8010619d:	68 77 91 10 80       	push   $0x80109177
801061a2:	e8 bf a3 ff ff       	call   80100566 <panic>

  iunlockput(dp);
801061a7:	83 ec 0c             	sub    $0xc,%esp
801061aa:	ff 75 f4             	pushl  -0xc(%ebp)
801061ad:	e8 13 ba ff ff       	call   80101bc5 <iunlockput>
801061b2:	83 c4 10             	add    $0x10,%esp

  return ip;
801061b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801061b8:	c9                   	leave  
801061b9:	c3                   	ret    

801061ba <sys_open>:

int
sys_open(void)
{
801061ba:	55                   	push   %ebp
801061bb:	89 e5                	mov    %esp,%ebp
801061bd:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801061c0:	83 ec 08             	sub    $0x8,%esp
801061c3:	8d 45 e8             	lea    -0x18(%ebp),%eax
801061c6:	50                   	push   %eax
801061c7:	6a 00                	push   $0x0
801061c9:	e8 eb f6 ff ff       	call   801058b9 <argstr>
801061ce:	83 c4 10             	add    $0x10,%esp
801061d1:	85 c0                	test   %eax,%eax
801061d3:	78 15                	js     801061ea <sys_open+0x30>
801061d5:	83 ec 08             	sub    $0x8,%esp
801061d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061db:	50                   	push   %eax
801061dc:	6a 01                	push   $0x1
801061de:	e8 51 f6 ff ff       	call   80105834 <argint>
801061e3:	83 c4 10             	add    $0x10,%esp
801061e6:	85 c0                	test   %eax,%eax
801061e8:	79 0a                	jns    801061f4 <sys_open+0x3a>
    return -1;
801061ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ef:	e9 61 01 00 00       	jmp    80106355 <sys_open+0x19b>

  begin_op();
801061f4:	e8 bb d2 ff ff       	call   801034b4 <begin_op>

  if(omode & O_CREATE){
801061f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061fc:	25 00 02 00 00       	and    $0x200,%eax
80106201:	85 c0                	test   %eax,%eax
80106203:	74 2a                	je     8010622f <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106205:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106208:	6a 00                	push   $0x0
8010620a:	6a 00                	push   $0x0
8010620c:	6a 02                	push   $0x2
8010620e:	50                   	push   %eax
8010620f:	e8 d4 fd ff ff       	call   80105fe8 <create>
80106214:	83 c4 10             	add    $0x10,%esp
80106217:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010621a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010621e:	75 75                	jne    80106295 <sys_open+0xdb>
      end_op();
80106220:	e8 1b d3 ff ff       	call   80103540 <end_op>
      return -1;
80106225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622a:	e9 26 01 00 00       	jmp    80106355 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
8010622f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106232:	83 ec 0c             	sub    $0xc,%esp
80106235:	50                   	push   %eax
80106236:	e8 88 c2 ff ff       	call   801024c3 <namei>
8010623b:	83 c4 10             	add    $0x10,%esp
8010623e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106245:	75 0f                	jne    80106256 <sys_open+0x9c>
      end_op();
80106247:	e8 f4 d2 ff ff       	call   80103540 <end_op>
      return -1;
8010624c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106251:	e9 ff 00 00 00       	jmp    80106355 <sys_open+0x19b>
    }
    ilock(ip);
80106256:	83 ec 0c             	sub    $0xc,%esp
80106259:	ff 75 f4             	pushl  -0xc(%ebp)
8010625c:	e8 aa b6 ff ff       	call   8010190b <ilock>
80106261:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106264:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106267:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010626b:	66 83 f8 01          	cmp    $0x1,%ax
8010626f:	75 24                	jne    80106295 <sys_open+0xdb>
80106271:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106274:	85 c0                	test   %eax,%eax
80106276:	74 1d                	je     80106295 <sys_open+0xdb>
      iunlockput(ip);
80106278:	83 ec 0c             	sub    $0xc,%esp
8010627b:	ff 75 f4             	pushl  -0xc(%ebp)
8010627e:	e8 42 b9 ff ff       	call   80101bc5 <iunlockput>
80106283:	83 c4 10             	add    $0x10,%esp
      end_op();
80106286:	e8 b5 d2 ff ff       	call   80103540 <end_op>
      return -1;
8010628b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106290:	e9 c0 00 00 00       	jmp    80106355 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106295:	e8 de ac ff ff       	call   80100f78 <filealloc>
8010629a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010629d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062a1:	74 17                	je     801062ba <sys_open+0x100>
801062a3:	83 ec 0c             	sub    $0xc,%esp
801062a6:	ff 75 f0             	pushl  -0x10(%ebp)
801062a9:	e8 37 f7 ff ff       	call   801059e5 <fdalloc>
801062ae:	83 c4 10             	add    $0x10,%esp
801062b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
801062b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801062b8:	79 2e                	jns    801062e8 <sys_open+0x12e>
    if(f)
801062ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062be:	74 0e                	je     801062ce <sys_open+0x114>
      fileclose(f);
801062c0:	83 ec 0c             	sub    $0xc,%esp
801062c3:	ff 75 f0             	pushl  -0x10(%ebp)
801062c6:	e8 6b ad ff ff       	call   80101036 <fileclose>
801062cb:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801062ce:	83 ec 0c             	sub    $0xc,%esp
801062d1:	ff 75 f4             	pushl  -0xc(%ebp)
801062d4:	e8 ec b8 ff ff       	call   80101bc5 <iunlockput>
801062d9:	83 c4 10             	add    $0x10,%esp
    end_op();
801062dc:	e8 5f d2 ff ff       	call   80103540 <end_op>
    return -1;
801062e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e6:	eb 6d                	jmp    80106355 <sys_open+0x19b>
  }
  iunlock(ip);
801062e8:	83 ec 0c             	sub    $0xc,%esp
801062eb:	ff 75 f4             	pushl  -0xc(%ebp)
801062ee:	e8 70 b7 ff ff       	call   80101a63 <iunlock>
801062f3:	83 c4 10             	add    $0x10,%esp
  end_op();
801062f6:	e8 45 d2 ff ff       	call   80103540 <end_op>

  f->type = FD_INODE;
801062fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062fe:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106304:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106307:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010630a:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010630d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106310:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010631a:	83 e0 01             	and    $0x1,%eax
8010631d:	85 c0                	test   %eax,%eax
8010631f:	0f 94 c0             	sete   %al
80106322:	89 c2                	mov    %eax,%edx
80106324:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106327:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010632a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010632d:	83 e0 01             	and    $0x1,%eax
80106330:	85 c0                	test   %eax,%eax
80106332:	75 0a                	jne    8010633e <sys_open+0x184>
80106334:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106337:	83 e0 02             	and    $0x2,%eax
8010633a:	85 c0                	test   %eax,%eax
8010633c:	74 07                	je     80106345 <sys_open+0x18b>
8010633e:	b8 01 00 00 00       	mov    $0x1,%eax
80106343:	eb 05                	jmp    8010634a <sys_open+0x190>
80106345:	b8 00 00 00 00       	mov    $0x0,%eax
8010634a:	89 c2                	mov    %eax,%edx
8010634c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010634f:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106352:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106355:	c9                   	leave  
80106356:	c3                   	ret    

80106357 <sys_mkdir>:

int
sys_mkdir(void)
{
80106357:	55                   	push   %ebp
80106358:	89 e5                	mov    %esp,%ebp
8010635a:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010635d:	e8 52 d1 ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106362:	83 ec 08             	sub    $0x8,%esp
80106365:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106368:	50                   	push   %eax
80106369:	6a 00                	push   $0x0
8010636b:	e8 49 f5 ff ff       	call   801058b9 <argstr>
80106370:	83 c4 10             	add    $0x10,%esp
80106373:	85 c0                	test   %eax,%eax
80106375:	78 1b                	js     80106392 <sys_mkdir+0x3b>
80106377:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010637a:	6a 00                	push   $0x0
8010637c:	6a 00                	push   $0x0
8010637e:	6a 01                	push   $0x1
80106380:	50                   	push   %eax
80106381:	e8 62 fc ff ff       	call   80105fe8 <create>
80106386:	83 c4 10             	add    $0x10,%esp
80106389:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010638c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106390:	75 0c                	jne    8010639e <sys_mkdir+0x47>
    end_op();
80106392:	e8 a9 d1 ff ff       	call   80103540 <end_op>
    return -1;
80106397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010639c:	eb 18                	jmp    801063b6 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010639e:	83 ec 0c             	sub    $0xc,%esp
801063a1:	ff 75 f4             	pushl  -0xc(%ebp)
801063a4:	e8 1c b8 ff ff       	call   80101bc5 <iunlockput>
801063a9:	83 c4 10             	add    $0x10,%esp
  end_op();
801063ac:	e8 8f d1 ff ff       	call   80103540 <end_op>
  return 0;
801063b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063b6:	c9                   	leave  
801063b7:	c3                   	ret    

801063b8 <sys_mknod>:

int
sys_mknod(void)
{
801063b8:	55                   	push   %ebp
801063b9:	89 e5                	mov    %esp,%ebp
801063bb:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801063be:	e8 f1 d0 ff ff       	call   801034b4 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801063c3:	83 ec 08             	sub    $0x8,%esp
801063c6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801063c9:	50                   	push   %eax
801063ca:	6a 00                	push   $0x0
801063cc:	e8 e8 f4 ff ff       	call   801058b9 <argstr>
801063d1:	83 c4 10             	add    $0x10,%esp
801063d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063db:	78 4f                	js     8010642c <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801063dd:	83 ec 08             	sub    $0x8,%esp
801063e0:	8d 45 e8             	lea    -0x18(%ebp),%eax
801063e3:	50                   	push   %eax
801063e4:	6a 01                	push   $0x1
801063e6:	e8 49 f4 ff ff       	call   80105834 <argint>
801063eb:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801063ee:	85 c0                	test   %eax,%eax
801063f0:	78 3a                	js     8010642c <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801063f2:	83 ec 08             	sub    $0x8,%esp
801063f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801063f8:	50                   	push   %eax
801063f9:	6a 02                	push   $0x2
801063fb:	e8 34 f4 ff ff       	call   80105834 <argint>
80106400:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106403:	85 c0                	test   %eax,%eax
80106405:	78 25                	js     8010642c <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010640a:	0f bf c8             	movswl %ax,%ecx
8010640d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106410:	0f bf d0             	movswl %ax,%edx
80106413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106416:	51                   	push   %ecx
80106417:	52                   	push   %edx
80106418:	6a 03                	push   $0x3
8010641a:	50                   	push   %eax
8010641b:	e8 c8 fb ff ff       	call   80105fe8 <create>
80106420:	83 c4 10             	add    $0x10,%esp
80106423:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106426:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010642a:	75 0c                	jne    80106438 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
8010642c:	e8 0f d1 ff ff       	call   80103540 <end_op>
    return -1;
80106431:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106436:	eb 18                	jmp    80106450 <sys_mknod+0x98>
  }
  iunlockput(ip);
80106438:	83 ec 0c             	sub    $0xc,%esp
8010643b:	ff 75 f0             	pushl  -0x10(%ebp)
8010643e:	e8 82 b7 ff ff       	call   80101bc5 <iunlockput>
80106443:	83 c4 10             	add    $0x10,%esp
  end_op();
80106446:	e8 f5 d0 ff ff       	call   80103540 <end_op>
  return 0;
8010644b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106450:	c9                   	leave  
80106451:	c3                   	ret    

80106452 <sys_chdir>:

int
sys_chdir(void)
{
80106452:	55                   	push   %ebp
80106453:	89 e5                	mov    %esp,%ebp
80106455:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106458:	e8 57 d0 ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010645d:	83 ec 08             	sub    $0x8,%esp
80106460:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106463:	50                   	push   %eax
80106464:	6a 00                	push   $0x0
80106466:	e8 4e f4 ff ff       	call   801058b9 <argstr>
8010646b:	83 c4 10             	add    $0x10,%esp
8010646e:	85 c0                	test   %eax,%eax
80106470:	78 18                	js     8010648a <sys_chdir+0x38>
80106472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106475:	83 ec 0c             	sub    $0xc,%esp
80106478:	50                   	push   %eax
80106479:	e8 45 c0 ff ff       	call   801024c3 <namei>
8010647e:	83 c4 10             	add    $0x10,%esp
80106481:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106488:	75 0c                	jne    80106496 <sys_chdir+0x44>
    end_op();
8010648a:	e8 b1 d0 ff ff       	call   80103540 <end_op>
    return -1;
8010648f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106494:	eb 6e                	jmp    80106504 <sys_chdir+0xb2>
  }
  ilock(ip);
80106496:	83 ec 0c             	sub    $0xc,%esp
80106499:	ff 75 f4             	pushl  -0xc(%ebp)
8010649c:	e8 6a b4 ff ff       	call   8010190b <ilock>
801064a1:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801064a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064a7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801064ab:	66 83 f8 01          	cmp    $0x1,%ax
801064af:	74 1a                	je     801064cb <sys_chdir+0x79>
    iunlockput(ip);
801064b1:	83 ec 0c             	sub    $0xc,%esp
801064b4:	ff 75 f4             	pushl  -0xc(%ebp)
801064b7:	e8 09 b7 ff ff       	call   80101bc5 <iunlockput>
801064bc:	83 c4 10             	add    $0x10,%esp
    end_op();
801064bf:	e8 7c d0 ff ff       	call   80103540 <end_op>
    return -1;
801064c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064c9:	eb 39                	jmp    80106504 <sys_chdir+0xb2>
  }
  iunlock(ip);
801064cb:	83 ec 0c             	sub    $0xc,%esp
801064ce:	ff 75 f4             	pushl  -0xc(%ebp)
801064d1:	e8 8d b5 ff ff       	call   80101a63 <iunlock>
801064d6:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801064d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064df:	8b 40 68             	mov    0x68(%eax),%eax
801064e2:	83 ec 0c             	sub    $0xc,%esp
801064e5:	50                   	push   %eax
801064e6:	e8 ea b5 ff ff       	call   80101ad5 <iput>
801064eb:	83 c4 10             	add    $0x10,%esp
  end_op();
801064ee:	e8 4d d0 ff ff       	call   80103540 <end_op>
  proc->cwd = ip;
801064f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064fc:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801064ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106504:	c9                   	leave  
80106505:	c3                   	ret    

80106506 <sys_exec>:

int
sys_exec(void)
{
80106506:	55                   	push   %ebp
80106507:	89 e5                	mov    %esp,%ebp
80106509:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010650f:	83 ec 08             	sub    $0x8,%esp
80106512:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106515:	50                   	push   %eax
80106516:	6a 00                	push   $0x0
80106518:	e8 9c f3 ff ff       	call   801058b9 <argstr>
8010651d:	83 c4 10             	add    $0x10,%esp
80106520:	85 c0                	test   %eax,%eax
80106522:	78 18                	js     8010653c <sys_exec+0x36>
80106524:	83 ec 08             	sub    $0x8,%esp
80106527:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010652d:	50                   	push   %eax
8010652e:	6a 01                	push   $0x1
80106530:	e8 ff f2 ff ff       	call   80105834 <argint>
80106535:	83 c4 10             	add    $0x10,%esp
80106538:	85 c0                	test   %eax,%eax
8010653a:	79 0a                	jns    80106546 <sys_exec+0x40>
    return -1;
8010653c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106541:	e9 c6 00 00 00       	jmp    8010660c <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106546:	83 ec 04             	sub    $0x4,%esp
80106549:	68 80 00 00 00       	push   $0x80
8010654e:	6a 00                	push   $0x0
80106550:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106556:	50                   	push   %eax
80106557:	e8 b3 ef ff ff       	call   8010550f <memset>
8010655c:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
8010655f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106566:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106569:	83 f8 1f             	cmp    $0x1f,%eax
8010656c:	76 0a                	jbe    80106578 <sys_exec+0x72>
      return -1;
8010656e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106573:	e9 94 00 00 00       	jmp    8010660c <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106578:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010657b:	c1 e0 02             	shl    $0x2,%eax
8010657e:	89 c2                	mov    %eax,%edx
80106580:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106586:	01 c2                	add    %eax,%edx
80106588:	83 ec 08             	sub    $0x8,%esp
8010658b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106591:	50                   	push   %eax
80106592:	52                   	push   %edx
80106593:	e8 00 f2 ff ff       	call   80105798 <fetchint>
80106598:	83 c4 10             	add    $0x10,%esp
8010659b:	85 c0                	test   %eax,%eax
8010659d:	79 07                	jns    801065a6 <sys_exec+0xa0>
      return -1;
8010659f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a4:	eb 66                	jmp    8010660c <sys_exec+0x106>
    if(uarg == 0){
801065a6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801065ac:	85 c0                	test   %eax,%eax
801065ae:	75 27                	jne    801065d7 <sys_exec+0xd1>
      argv[i] = 0;
801065b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b3:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801065ba:	00 00 00 00 
      break;
801065be:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801065bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065c2:	83 ec 08             	sub    $0x8,%esp
801065c5:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801065cb:	52                   	push   %edx
801065cc:	50                   	push   %eax
801065cd:	e8 84 a5 ff ff       	call   80100b56 <exec>
801065d2:	83 c4 10             	add    $0x10,%esp
801065d5:	eb 35                	jmp    8010660c <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801065d7:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801065dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065e0:	c1 e2 02             	shl    $0x2,%edx
801065e3:	01 c2                	add    %eax,%edx
801065e5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801065eb:	83 ec 08             	sub    $0x8,%esp
801065ee:	52                   	push   %edx
801065ef:	50                   	push   %eax
801065f0:	e8 dd f1 ff ff       	call   801057d2 <fetchstr>
801065f5:	83 c4 10             	add    $0x10,%esp
801065f8:	85 c0                	test   %eax,%eax
801065fa:	79 07                	jns    80106603 <sys_exec+0xfd>
      return -1;
801065fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106601:	eb 09                	jmp    8010660c <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106603:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106607:	e9 5a ff ff ff       	jmp    80106566 <sys_exec+0x60>
  return exec(path, argv);
}
8010660c:	c9                   	leave  
8010660d:	c3                   	ret    

8010660e <sys_pipe>:

int
sys_pipe(void)
{
8010660e:	55                   	push   %ebp
8010660f:	89 e5                	mov    %esp,%ebp
80106611:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106614:	83 ec 04             	sub    $0x4,%esp
80106617:	6a 08                	push   $0x8
80106619:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010661c:	50                   	push   %eax
8010661d:	6a 00                	push   $0x0
8010661f:	e8 38 f2 ff ff       	call   8010585c <argptr>
80106624:	83 c4 10             	add    $0x10,%esp
80106627:	85 c0                	test   %eax,%eax
80106629:	79 0a                	jns    80106635 <sys_pipe+0x27>
    return -1;
8010662b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106630:	e9 af 00 00 00       	jmp    801066e4 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106635:	83 ec 08             	sub    $0x8,%esp
80106638:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010663b:	50                   	push   %eax
8010663c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010663f:	50                   	push   %eax
80106640:	e8 4d d9 ff ff       	call   80103f92 <pipealloc>
80106645:	83 c4 10             	add    $0x10,%esp
80106648:	85 c0                	test   %eax,%eax
8010664a:	79 0a                	jns    80106656 <sys_pipe+0x48>
    return -1;
8010664c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106651:	e9 8e 00 00 00       	jmp    801066e4 <sys_pipe+0xd6>
  fd0 = -1;
80106656:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010665d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106660:	83 ec 0c             	sub    $0xc,%esp
80106663:	50                   	push   %eax
80106664:	e8 7c f3 ff ff       	call   801059e5 <fdalloc>
80106669:	83 c4 10             	add    $0x10,%esp
8010666c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010666f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106673:	78 18                	js     8010668d <sys_pipe+0x7f>
80106675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106678:	83 ec 0c             	sub    $0xc,%esp
8010667b:	50                   	push   %eax
8010667c:	e8 64 f3 ff ff       	call   801059e5 <fdalloc>
80106681:	83 c4 10             	add    $0x10,%esp
80106684:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106687:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010668b:	79 3f                	jns    801066cc <sys_pipe+0xbe>
    if(fd0 >= 0)
8010668d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106691:	78 14                	js     801066a7 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106693:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106699:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010669c:	83 c2 08             	add    $0x8,%edx
8010669f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801066a6:	00 
    fileclose(rf);
801066a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066aa:	83 ec 0c             	sub    $0xc,%esp
801066ad:	50                   	push   %eax
801066ae:	e8 83 a9 ff ff       	call   80101036 <fileclose>
801066b3:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801066b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066b9:	83 ec 0c             	sub    $0xc,%esp
801066bc:	50                   	push   %eax
801066bd:	e8 74 a9 ff ff       	call   80101036 <fileclose>
801066c2:	83 c4 10             	add    $0x10,%esp
    return -1;
801066c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ca:	eb 18                	jmp    801066e4 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801066cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801066cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066d2:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801066d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801066d7:	8d 50 04             	lea    0x4(%eax),%edx
801066da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066dd:	89 02                	mov    %eax,(%edx)
  return 0;
801066df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066e4:	c9                   	leave  
801066e5:	c3                   	ret    

801066e6 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
801066e6:	55                   	push   %ebp
801066e7:	89 e5                	mov    %esp,%ebp
801066e9:	83 ec 08             	sub    $0x8,%esp
801066ec:	8b 55 08             	mov    0x8(%ebp),%edx
801066ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801066f2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801066f6:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801066fa:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
801066fe:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106702:	66 ef                	out    %ax,(%dx)
}
80106704:	90                   	nop
80106705:	c9                   	leave  
80106706:	c3                   	ret    

80106707 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106707:	55                   	push   %ebp
80106708:	89 e5                	mov    %esp,%ebp
8010670a:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010670d:	e8 a0 df ff ff       	call   801046b2 <fork>
}
80106712:	c9                   	leave  
80106713:	c3                   	ret    

80106714 <sys_exit>:


int
sys_exit(void)
{
80106714:	55                   	push   %ebp
80106715:	89 e5                	mov    %esp,%ebp
80106717:	83 ec 08             	sub    $0x8,%esp
  exit();
8010671a:	e8 f2 e2 ff ff       	call   80104a11 <exit>
  return 0;  // not reached
8010671f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106724:	c9                   	leave  
80106725:	c3                   	ret    

80106726 <sys_wait>:

int
sys_wait(void)
{
80106726:	55                   	push   %ebp
80106727:	89 e5                	mov    %esp,%ebp
80106729:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010672c:	e8 1b e4 ff ff       	call   80104b4c <wait>
}
80106731:	c9                   	leave  
80106732:	c3                   	ret    

80106733 <sys_kill>:

int
sys_kill(void)
{
80106733:	55                   	push   %ebp
80106734:	89 e5                	mov    %esp,%ebp
80106736:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106739:	83 ec 08             	sub    $0x8,%esp
8010673c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010673f:	50                   	push   %eax
80106740:	6a 00                	push   $0x0
80106742:	e8 ed f0 ff ff       	call   80105834 <argint>
80106747:	83 c4 10             	add    $0x10,%esp
8010674a:	85 c0                	test   %eax,%eax
8010674c:	79 07                	jns    80106755 <sys_kill+0x22>
    return -1;
8010674e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106753:	eb 0f                	jmp    80106764 <sys_kill+0x31>
  return kill(pid);
80106755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106758:	83 ec 0c             	sub    $0xc,%esp
8010675b:	50                   	push   %eax
8010675c:	e8 07 e8 ff ff       	call   80104f68 <kill>
80106761:	83 c4 10             	add    $0x10,%esp
}
80106764:	c9                   	leave  
80106765:	c3                   	ret    

80106766 <sys_getpid>:

int
sys_getpid(void)
{
80106766:	55                   	push   %ebp
80106767:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106769:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010676f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106772:	5d                   	pop    %ebp
80106773:	c3                   	ret    

80106774 <sys_sbrk>:

int
sys_sbrk(void)
{
80106774:	55                   	push   %ebp
80106775:	89 e5                	mov    %esp,%ebp
80106777:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010677a:	83 ec 08             	sub    $0x8,%esp
8010677d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106780:	50                   	push   %eax
80106781:	6a 00                	push   $0x0
80106783:	e8 ac f0 ff ff       	call   80105834 <argint>
80106788:	83 c4 10             	add    $0x10,%esp
8010678b:	85 c0                	test   %eax,%eax
8010678d:	79 07                	jns    80106796 <sys_sbrk+0x22>
    return -1;
8010678f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106794:	eb 28                	jmp    801067be <sys_sbrk+0x4a>
  addr = proc->sz;
80106796:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010679c:	8b 00                	mov    (%eax),%eax
8010679e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801067a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067a4:	83 ec 0c             	sub    $0xc,%esp
801067a7:	50                   	push   %eax
801067a8:	e8 62 de ff ff       	call   8010460f <growproc>
801067ad:	83 c4 10             	add    $0x10,%esp
801067b0:	85 c0                	test   %eax,%eax
801067b2:	79 07                	jns    801067bb <sys_sbrk+0x47>
    return -1;
801067b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067b9:	eb 03                	jmp    801067be <sys_sbrk+0x4a>
  return addr;
801067bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801067be:	c9                   	leave  
801067bf:	c3                   	ret    

801067c0 <sys_sleep>:

int
sys_sleep(void)
{
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801067c6:	83 ec 08             	sub    $0x8,%esp
801067c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067cc:	50                   	push   %eax
801067cd:	6a 00                	push   $0x0
801067cf:	e8 60 f0 ff ff       	call   80105834 <argint>
801067d4:	83 c4 10             	add    $0x10,%esp
801067d7:	85 c0                	test   %eax,%eax
801067d9:	79 07                	jns    801067e2 <sys_sleep+0x22>
    return -1;
801067db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067e0:	eb 77                	jmp    80106859 <sys_sleep+0x99>
  acquire(&tickslock);
801067e2:	83 ec 0c             	sub    $0xc,%esp
801067e5:	68 c0 5c 11 80       	push   $0x80115cc0
801067ea:	e8 bd ea ff ff       	call   801052ac <acquire>
801067ef:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801067f2:	a1 00 65 11 80       	mov    0x80116500,%eax
801067f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801067fa:	eb 39                	jmp    80106835 <sys_sleep+0x75>
    if(proc->killed){
801067fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106802:	8b 40 24             	mov    0x24(%eax),%eax
80106805:	85 c0                	test   %eax,%eax
80106807:	74 17                	je     80106820 <sys_sleep+0x60>
      release(&tickslock);
80106809:	83 ec 0c             	sub    $0xc,%esp
8010680c:	68 c0 5c 11 80       	push   $0x80115cc0
80106811:	e8 fd ea ff ff       	call   80105313 <release>
80106816:	83 c4 10             	add    $0x10,%esp
      return -1;
80106819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010681e:	eb 39                	jmp    80106859 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106820:	83 ec 08             	sub    $0x8,%esp
80106823:	68 c0 5c 11 80       	push   $0x80115cc0
80106828:	68 00 65 11 80       	push   $0x80116500
8010682d:	e8 11 e6 ff ff       	call   80104e43 <sleep>
80106832:	83 c4 10             	add    $0x10,%esp

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106835:	a1 00 65 11 80       	mov    0x80116500,%eax
8010683a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010683d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106840:	39 d0                	cmp    %edx,%eax
80106842:	72 b8                	jb     801067fc <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106844:	83 ec 0c             	sub    $0xc,%esp
80106847:	68 c0 5c 11 80       	push   $0x80115cc0
8010684c:	e8 c2 ea ff ff       	call   80105313 <release>
80106851:	83 c4 10             	add    $0x10,%esp
  return 0;
80106854:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106859:	c9                   	leave  
8010685a:	c3                   	ret    

8010685b <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010685b:	55                   	push   %ebp
8010685c:	89 e5                	mov    %esp,%ebp
8010685e:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106861:	83 ec 0c             	sub    $0xc,%esp
80106864:	68 c0 5c 11 80       	push   $0x80115cc0
80106869:	e8 3e ea ff ff       	call   801052ac <acquire>
8010686e:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106871:	a1 00 65 11 80       	mov    0x80116500,%eax
80106876:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106879:	83 ec 0c             	sub    $0xc,%esp
8010687c:	68 c0 5c 11 80       	push   $0x80115cc0
80106881:	e8 8d ea ff ff       	call   80105313 <release>
80106886:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106889:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010688c:	c9                   	leave  
8010688d:	c3                   	ret    

8010688e <sys_halt>:
// signal to QEMU.
// Based on: http://pdos.csail.mit.edu/6.828/2012/homework/xv6-syscall.html
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
8010688e:	55                   	push   %ebp
8010688f:	89 e5                	mov    %esp,%ebp
80106891:	83 ec 10             	sub    $0x10,%esp
  char *p = "Shutdown";
80106894:	c7 45 fc 87 91 10 80 	movl   $0x80109187,-0x4(%ebp)
  for( ; *p; p++)
8010689b:	eb 16                	jmp    801068b3 <sys_halt+0x25>
    outw(0xB004, 0x2000);
8010689d:	68 00 20 00 00       	push   $0x2000
801068a2:	68 04 b0 00 00       	push   $0xb004
801068a7:	e8 3a fe ff ff       	call   801066e6 <outw>
801068ac:	83 c4 08             	add    $0x8,%esp
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
  char *p = "Shutdown";
  for( ; *p; p++)
801068af:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801068b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801068b6:	0f b6 00             	movzbl (%eax),%eax
801068b9:	84 c0                	test   %al,%al
801068bb:	75 e0                	jne    8010689d <sys_halt+0xf>
    outw(0xB004, 0x2000);
  return 0;
801068bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068c2:	c9                   	leave  
801068c3:	c3                   	ret    

801068c4 <sys_mprotect>:

int sys_mprotect(void)
{
801068c4:	55                   	push   %ebp
801068c5:	89 e5                	mov    %esp,%ebp
801068c7:	83 ec 18             	sub    $0x18,%esp
  int addr,len,prot;

  if(argint(0, &addr) <0)
801068ca:	83 ec 08             	sub    $0x8,%esp
801068cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068d0:	50                   	push   %eax
801068d1:	6a 00                	push   $0x0
801068d3:	e8 5c ef ff ff       	call   80105834 <argint>
801068d8:	83 c4 10             	add    $0x10,%esp
801068db:	85 c0                	test   %eax,%eax
801068dd:	79 07                	jns    801068e6 <sys_mprotect+0x22>
    return -1;
801068df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068e4:	eb 4f                	jmp    80106935 <sys_mprotect+0x71>
  if(argint(1,&len) <0)
801068e6:	83 ec 08             	sub    $0x8,%esp
801068e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068ec:	50                   	push   %eax
801068ed:	6a 01                	push   $0x1
801068ef:	e8 40 ef ff ff       	call   80105834 <argint>
801068f4:	83 c4 10             	add    $0x10,%esp
801068f7:	85 c0                	test   %eax,%eax
801068f9:	79 07                	jns    80106902 <sys_mprotect+0x3e>
    return -1;
801068fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106900:	eb 33                	jmp    80106935 <sys_mprotect+0x71>
  if(argint(2,&prot) <0)
80106902:	83 ec 08             	sub    $0x8,%esp
80106905:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106908:	50                   	push   %eax
80106909:	6a 02                	push   $0x2
8010690b:	e8 24 ef ff ff       	call   80105834 <argint>
80106910:	83 c4 10             	add    $0x10,%esp
80106913:	85 c0                	test   %eax,%eax
80106915:	79 07                	jns    8010691e <sys_mprotect+0x5a>
    return -1;
80106917:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010691c:	eb 17                	jmp    80106935 <sys_mprotect+0x71>

  return mprotect((void*)addr,len,prot);
8010691e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106921:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106924:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80106927:	83 ec 04             	sub    $0x4,%esp
8010692a:	52                   	push   %edx
8010692b:	50                   	push   %eax
8010692c:	51                   	push   %ecx
8010692d:	e8 7a 1c 00 00       	call   801085ac <mprotect>
80106932:	83 c4 10             	add    $0x10,%esp
}
80106935:	c9                   	leave  
80106936:	c3                   	ret    

80106937 <sys_signal_register>:

int sys_signal_register(void)
{
80106937:	55                   	push   %ebp
80106938:	89 e5                	mov    %esp,%ebp
8010693a:	83 ec 18             	sub    $0x18,%esp
    uint signum;
    sighandler_t handler;
    int n;

    if (argint(0, &n) < 0)
8010693d:	83 ec 08             	sub    $0x8,%esp
80106940:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106943:	50                   	push   %eax
80106944:	6a 00                	push   $0x0
80106946:	e8 e9 ee ff ff       	call   80105834 <argint>
8010694b:	83 c4 10             	add    $0x10,%esp
8010694e:	85 c0                	test   %eax,%eax
80106950:	79 07                	jns    80106959 <sys_signal_register+0x22>
      return -1;
80106952:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106957:	eb 3a                	jmp    80106993 <sys_signal_register+0x5c>
    signum = (uint) n;
80106959:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010695c:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (argint(1, &n) < 0)
8010695f:	83 ec 08             	sub    $0x8,%esp
80106962:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106965:	50                   	push   %eax
80106966:	6a 01                	push   $0x1
80106968:	e8 c7 ee ff ff       	call   80105834 <argint>
8010696d:	83 c4 10             	add    $0x10,%esp
80106970:	85 c0                	test   %eax,%eax
80106972:	79 07                	jns    8010697b <sys_signal_register+0x44>
      return -1;
80106974:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106979:	eb 18                	jmp    80106993 <sys_signal_register+0x5c>
    handler = (sighandler_t) n;
8010697b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010697e:	89 45 f0             	mov    %eax,-0x10(%ebp)

    return (int) signal_register_handler(signum, handler);
80106981:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106984:	83 ec 08             	sub    $0x8,%esp
80106987:	ff 75 f0             	pushl  -0x10(%ebp)
8010698a:	50                   	push   %eax
8010698b:	e8 80 e8 ff ff       	call   80105210 <signal_register_handler>
80106990:	83 c4 10             	add    $0x10,%esp
}
80106993:	c9                   	leave  
80106994:	c3                   	ret    

80106995 <sys_cowfork>:
int sys_cowfork(void)
{
80106995:	55                   	push   %ebp
80106996:	89 e5                	mov    %esp,%ebp
80106998:	83 ec 08             	sub    $0x8,%esp
  return cowfork();
8010699b:	e8 a3 de ff ff       	call   80104843 <cowfork>
}
801069a0:	c9                   	leave  
801069a1:	c3                   	ret    

801069a2 <sys_signal_restorer>:
int sys_signal_restorer(void)
{
801069a2:	55                   	push   %ebp
801069a3:	89 e5                	mov    %esp,%ebp
801069a5:	83 ec 18             	sub    $0x18,%esp
    int restorer_addr;
    if (argint(0, &restorer_addr) < 0)
801069a8:	83 ec 08             	sub    $0x8,%esp
801069ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069ae:	50                   	push   %eax
801069af:	6a 00                	push   $0x0
801069b1:	e8 7e ee ff ff       	call   80105834 <argint>
801069b6:	83 c4 10             	add    $0x10,%esp
801069b9:	85 c0                	test   %eax,%eax
801069bb:	79 07                	jns    801069c4 <sys_signal_restorer+0x22>
      return -1;
801069bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069c2:	eb 14                	jmp    801069d8 <sys_signal_restorer+0x36>

    proc->restorer_addr = (uint) restorer_addr;
801069c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069cd:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

    return 0;
801069d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069d8:	c9                   	leave  
801069d9:	c3                   	ret    

801069da <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801069da:	55                   	push   %ebp
801069db:	89 e5                	mov    %esp,%ebp
801069dd:	83 ec 08             	sub    $0x8,%esp
801069e0:	8b 55 08             	mov    0x8(%ebp),%edx
801069e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801069e6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801069ea:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069ed:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801069f1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801069f5:	ee                   	out    %al,(%dx)
}
801069f6:	90                   	nop
801069f7:	c9                   	leave  
801069f8:	c3                   	ret    

801069f9 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801069f9:	55                   	push   %ebp
801069fa:	89 e5                	mov    %esp,%ebp
801069fc:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801069ff:	6a 34                	push   $0x34
80106a01:	6a 43                	push   $0x43
80106a03:	e8 d2 ff ff ff       	call   801069da <outb>
80106a08:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106a0b:	68 9c 00 00 00       	push   $0x9c
80106a10:	6a 40                	push   $0x40
80106a12:	e8 c3 ff ff ff       	call   801069da <outb>
80106a17:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106a1a:	6a 2e                	push   $0x2e
80106a1c:	6a 40                	push   $0x40
80106a1e:	e8 b7 ff ff ff       	call   801069da <outb>
80106a23:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106a26:	83 ec 0c             	sub    $0xc,%esp
80106a29:	6a 00                	push   $0x0
80106a2b:	e8 4c d4 ff ff       	call   80103e7c <picenable>
80106a30:	83 c4 10             	add    $0x10,%esp
}
80106a33:	90                   	nop
80106a34:	c9                   	leave  
80106a35:	c3                   	ret    

80106a36 <alltraps>:
80106a36:	1e                   	push   %ds
80106a37:	06                   	push   %es
80106a38:	0f a0                	push   %fs
80106a3a:	0f a8                	push   %gs
80106a3c:	60                   	pusha  
80106a3d:	66 b8 10 00          	mov    $0x10,%ax
80106a41:	8e d8                	mov    %eax,%ds
80106a43:	8e c0                	mov    %eax,%es
80106a45:	66 b8 18 00          	mov    $0x18,%ax
80106a49:	8e e0                	mov    %eax,%fs
80106a4b:	8e e8                	mov    %eax,%gs
80106a4d:	54                   	push   %esp
80106a4e:	e8 d7 01 00 00       	call   80106c2a <trap>
80106a53:	83 c4 04             	add    $0x4,%esp

80106a56 <trapret>:
80106a56:	61                   	popa   
80106a57:	0f a9                	pop    %gs
80106a59:	0f a1                	pop    %fs
80106a5b:	07                   	pop    %es
80106a5c:	1f                   	pop    %ds
80106a5d:	83 c4 08             	add    $0x8,%esp
80106a60:	cf                   	iret   

80106a61 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106a61:	55                   	push   %ebp
80106a62:	89 e5                	mov    %esp,%ebp
80106a64:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106a67:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a6a:	83 e8 01             	sub    $0x1,%eax
80106a6d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a71:	8b 45 08             	mov    0x8(%ebp),%eax
80106a74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106a78:	8b 45 08             	mov    0x8(%ebp),%eax
80106a7b:	c1 e8 10             	shr    $0x10,%eax
80106a7e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106a82:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106a85:	0f 01 18             	lidtl  (%eax)
}
80106a88:	90                   	nop
80106a89:	c9                   	leave  
80106a8a:	c3                   	ret    

80106a8b <rcr2>:
  asm volatile("movl %eax,%cr3");
}

static inline uint
rcr2(void)
{
80106a8b:	55                   	push   %ebp
80106a8c:	89 e5                	mov    %esp,%ebp
80106a8e:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106a91:	0f 20 d0             	mov    %cr2,%eax
80106a94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106a9a:	c9                   	leave  
80106a9b:	c3                   	ret    

80106a9c <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106a9c:	55                   	push   %ebp
80106a9d:	89 e5                	mov    %esp,%ebp
80106a9f:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106aa2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106aa9:	e9 c3 00 00 00       	jmp    80106b71 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ab1:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106ab8:	89 c2                	mov    %eax,%edx
80106aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106abd:	66 89 14 c5 00 5d 11 	mov    %dx,-0x7feea300(,%eax,8)
80106ac4:	80 
80106ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ac8:	66 c7 04 c5 02 5d 11 	movw   $0x8,-0x7feea2fe(,%eax,8)
80106acf:	80 08 00 
80106ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ad5:	0f b6 14 c5 04 5d 11 	movzbl -0x7feea2fc(,%eax,8),%edx
80106adc:	80 
80106add:	83 e2 e0             	and    $0xffffffe0,%edx
80106ae0:	88 14 c5 04 5d 11 80 	mov    %dl,-0x7feea2fc(,%eax,8)
80106ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aea:	0f b6 14 c5 04 5d 11 	movzbl -0x7feea2fc(,%eax,8),%edx
80106af1:	80 
80106af2:	83 e2 1f             	and    $0x1f,%edx
80106af5:	88 14 c5 04 5d 11 80 	mov    %dl,-0x7feea2fc(,%eax,8)
80106afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aff:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106b06:	80 
80106b07:	83 e2 f0             	and    $0xfffffff0,%edx
80106b0a:	83 ca 0e             	or     $0xe,%edx
80106b0d:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b17:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106b1e:	80 
80106b1f:	83 e2 ef             	and    $0xffffffef,%edx
80106b22:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b2c:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106b33:	80 
80106b34:	83 e2 9f             	and    $0xffffff9f,%edx
80106b37:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b41:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106b48:	80 
80106b49:	83 ca 80             	or     $0xffffff80,%edx
80106b4c:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b56:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106b5d:	c1 e8 10             	shr    $0x10,%eax
80106b60:	89 c2                	mov    %eax,%edx
80106b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b65:	66 89 14 c5 06 5d 11 	mov    %dx,-0x7feea2fa(,%eax,8)
80106b6c:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106b6d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b71:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106b78:	0f 8e 30 ff ff ff    	jle    80106aae <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106b7e:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106b83:	66 a3 00 5f 11 80    	mov    %ax,0x80115f00
80106b89:	66 c7 05 02 5f 11 80 	movw   $0x8,0x80115f02
80106b90:	08 00 
80106b92:	0f b6 05 04 5f 11 80 	movzbl 0x80115f04,%eax
80106b99:	83 e0 e0             	and    $0xffffffe0,%eax
80106b9c:	a2 04 5f 11 80       	mov    %al,0x80115f04
80106ba1:	0f b6 05 04 5f 11 80 	movzbl 0x80115f04,%eax
80106ba8:	83 e0 1f             	and    $0x1f,%eax
80106bab:	a2 04 5f 11 80       	mov    %al,0x80115f04
80106bb0:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106bb7:	83 c8 0f             	or     $0xf,%eax
80106bba:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106bbf:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106bc6:	83 e0 ef             	and    $0xffffffef,%eax
80106bc9:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106bce:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106bd5:	83 c8 60             	or     $0x60,%eax
80106bd8:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106bdd:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106be4:	83 c8 80             	or     $0xffffff80,%eax
80106be7:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106bec:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106bf1:	c1 e8 10             	shr    $0x10,%eax
80106bf4:	66 a3 06 5f 11 80    	mov    %ax,0x80115f06

  initlock(&tickslock, "time");
80106bfa:	83 ec 08             	sub    $0x8,%esp
80106bfd:	68 90 91 10 80       	push   $0x80109190
80106c02:	68 c0 5c 11 80       	push   $0x80115cc0
80106c07:	e8 7e e6 ff ff       	call   8010528a <initlock>
80106c0c:	83 c4 10             	add    $0x10,%esp
}
80106c0f:	90                   	nop
80106c10:	c9                   	leave  
80106c11:	c3                   	ret    

80106c12 <idtinit>:

void
idtinit(void)
{
80106c12:	55                   	push   %ebp
80106c13:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106c15:	68 00 08 00 00       	push   $0x800
80106c1a:	68 00 5d 11 80       	push   $0x80115d00
80106c1f:	e8 3d fe ff ff       	call   80106a61 <lidt>
80106c24:	83 c4 08             	add    $0x8,%esp
}
80106c27:	90                   	nop
80106c28:	c9                   	leave  
80106c29:	c3                   	ret    

80106c2a <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106c2a:	55                   	push   %ebp
80106c2b:	89 e5                	mov    %esp,%ebp
80106c2d:	57                   	push   %edi
80106c2e:	56                   	push   %esi
80106c2f:	53                   	push   %ebx
80106c30:	83 ec 2c             	sub    $0x2c,%esp
  siginfo_t si;
  if(tf->trapno == T_SYSCALL){
80106c33:	8b 45 08             	mov    0x8(%ebp),%eax
80106c36:	8b 40 30             	mov    0x30(%eax),%eax
80106c39:	83 f8 40             	cmp    $0x40,%eax
80106c3c:	75 3e                	jne    80106c7c <trap+0x52>
    if(proc->killed)
80106c3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c44:	8b 40 24             	mov    0x24(%eax),%eax
80106c47:	85 c0                	test   %eax,%eax
80106c49:	74 05                	je     80106c50 <trap+0x26>
      exit();
80106c4b:	e8 c1 dd ff ff       	call   80104a11 <exit>
    proc->tf = tf;
80106c50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c56:	8b 55 08             	mov    0x8(%ebp),%edx
80106c59:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106c5c:	e8 89 ec ff ff       	call   801058ea <syscall>
    if(proc->killed)
80106c61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c67:	8b 40 24             	mov    0x24(%eax),%eax
80106c6a:	85 c0                	test   %eax,%eax
80106c6c:	0f 84 e7 02 00 00    	je     80106f59 <trap+0x32f>
      exit();
80106c72:	e8 9a dd ff ff       	call   80104a11 <exit>
80106c77:	e9 de 02 00 00       	jmp    80106f5a <trap+0x330>
    return;
  }

  switch(tf->trapno){
80106c7c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c7f:	8b 40 30             	mov    0x30(%eax),%eax
80106c82:	83 f8 3f             	cmp    $0x3f,%eax
80106c85:	0f 87 8c 01 00 00    	ja     80106e17 <trap+0x1ed>
80106c8b:	8b 04 85 44 92 10 80 	mov    -0x7fef6dbc(,%eax,4),%eax
80106c92:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106c94:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106c9a:	0f b6 00             	movzbl (%eax),%eax
80106c9d:	84 c0                	test   %al,%al
80106c9f:	75 3d                	jne    80106cde <trap+0xb4>
      acquire(&tickslock);
80106ca1:	83 ec 0c             	sub    $0xc,%esp
80106ca4:	68 c0 5c 11 80       	push   $0x80115cc0
80106ca9:	e8 fe e5 ff ff       	call   801052ac <acquire>
80106cae:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106cb1:	a1 00 65 11 80       	mov    0x80116500,%eax
80106cb6:	83 c0 01             	add    $0x1,%eax
80106cb9:	a3 00 65 11 80       	mov    %eax,0x80116500
      wakeup(&ticks);
80106cbe:	83 ec 0c             	sub    $0xc,%esp
80106cc1:	68 00 65 11 80       	push   $0x80116500
80106cc6:	e8 66 e2 ff ff       	call   80104f31 <wakeup>
80106ccb:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106cce:	83 ec 0c             	sub    $0xc,%esp
80106cd1:	68 c0 5c 11 80       	push   $0x80115cc0
80106cd6:	e8 38 e6 ff ff       	call   80105313 <release>
80106cdb:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106cde:	e8 a1 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106ce3:	e9 eb 01 00 00       	jmp    80106ed3 <trap+0x2a9>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106ce8:	e8 aa ba ff ff       	call   80102797 <ideintr>
    lapiceoi();
80106ced:	e8 92 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106cf2:	e9 dc 01 00 00       	jmp    80106ed3 <trap+0x2a9>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106cf7:	e8 8a c0 ff ff       	call   80102d86 <kbdintr>
    lapiceoi();
80106cfc:	e8 83 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d01:	e9 cd 01 00 00       	jmp    80106ed3 <trap+0x2a9>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106d06:	e8 2f 04 00 00       	call   8010713a <uartintr>
    lapiceoi();
80106d0b:	e8 74 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d10:	e9 be 01 00 00       	jmp    80106ed3 <trap+0x2a9>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d15:	8b 45 08             	mov    0x8(%ebp),%eax
80106d18:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106d1b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d1e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d22:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106d25:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106d2b:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d2e:	0f b6 c0             	movzbl %al,%eax
80106d31:	51                   	push   %ecx
80106d32:	52                   	push   %edx
80106d33:	50                   	push   %eax
80106d34:	68 98 91 10 80       	push   $0x80109198
80106d39:	e8 88 96 ff ff       	call   801003c6 <cprintf>
80106d3e:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106d41:	e8 3e c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d46:	e9 88 01 00 00       	jmp    80106ed3 <trap+0x2a9>

   case T_DIVIDE:
      if (proc->handlers[SIGFPE] != (sighandler_t) -1) {
80106d4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d51:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106d57:	83 f8 ff             	cmp    $0xffffffff,%eax
80106d5a:	74 26                	je     80106d82 <trap+0x158>
        si.type= 1;
80106d5c:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
        si.addr = 5;
80106d63:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%ebp)
        signal_deliver(SIGFPE,si);
80106d6a:	83 ec 04             	sub    $0x4,%esp
80106d6d:	ff 75 e0             	pushl  -0x20(%ebp)
80106d70:	ff 75 dc             	pushl  -0x24(%ebp)
80106d73:	6a 01                	push   $0x1
80106d75:	e8 71 e3 ff ff       	call   801050eb <signal_deliver>
80106d7a:	83 c4 10             	add    $0x10,%esp
        break;
80106d7d:	e9 51 01 00 00       	jmp    80106ed3 <trap+0x2a9>
      }
    //handle pgfault with mem_protect
    case T_PGFLT:
      // cprintf(" PAGEFULT !!err : 0x%x\n",tf->err);

      if (proc->handlers[SIGSEGV] != (sighandler_t) -1) {
80106d82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d88:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
80106d8e:	83 f8 ff             	cmp    $0xffffffff,%eax
80106d91:	74 5a                	je     80106ded <trap+0x1c3>
        int err = tf->err;
80106d93:	8b 45 08             	mov    0x8(%ebp),%eax
80106d96:	8b 40 34             	mov    0x34(%eax),%eax
80106d99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(err == 0x4 || err == 0x6 || err == 0x5) {
80106d9c:	83 7d e4 04          	cmpl   $0x4,-0x1c(%ebp)
80106da0:	74 0c                	je     80106dae <trap+0x184>
80106da2:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
80106da6:	74 06                	je     80106dae <trap+0x184>
80106da8:	83 7d e4 05          	cmpl   $0x5,-0x1c(%ebp)
80106dac:	75 09                	jne    80106db7 <trap+0x18d>
          si.type = PROT_NONE;
80106dae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106db5:	eb 16                	jmp    80106dcd <trap+0x1a3>
        } else if(err == 0x7) {
80106db7:	83 7d e4 07          	cmpl   $0x7,-0x1c(%ebp)
80106dbb:	75 09                	jne    80106dc6 <trap+0x19c>
          si.type = PROT_READ;
80106dbd:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80106dc4:	eb 07                	jmp    80106dcd <trap+0x1a3>
        } else {
          si.type = PROT_WRITE;
80106dc6:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
        }
        si.addr = rcr2();
80106dcd:	e8 b9 fc ff ff       	call   80106a8b <rcr2>
80106dd2:	89 45 dc             	mov    %eax,-0x24(%ebp)
        // cprintf(" PAGE FAULT addr: 0x%x addrtype: 0x%x\n",si.addr,si.type);
        signal_deliver(SIGSEGV,si);
80106dd5:	83 ec 04             	sub    $0x4,%esp
80106dd8:	ff 75 e0             	pushl  -0x20(%ebp)
80106ddb:	ff 75 dc             	pushl  -0x24(%ebp)
80106dde:	6a 0e                	push   $0xe
80106de0:	e8 06 e3 ff ff       	call   801050eb <signal_deliver>
80106de5:	83 c4 10             	add    $0x10,%esp
        break;
80106de8:	e9 e6 00 00 00       	jmp    80106ed3 <trap+0x2a9>
      } else if (proc->shared == 1) {
80106ded:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106df3:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80106df9:	83 f8 01             	cmp    $0x1,%eax
80106dfc:	0f 85 d0 00 00 00    	jne    80106ed2 <trap+0x2a8>
        cprintf("Do stuff!");
80106e02:	83 ec 0c             	sub    $0xc,%esp
80106e05:	68 bc 91 10 80       	push   $0x801091bc
80106e0a:	e8 b7 95 ff ff       	call   801003c6 <cprintf>
80106e0f:	83 c4 10             	add    $0x10,%esp
        
      }

      break;
80106e12:	e9 bb 00 00 00       	jmp    80106ed2 <trap+0x2a8>

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106e17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e1d:	85 c0                	test   %eax,%eax
80106e1f:	74 11                	je     80106e32 <trap+0x208>
80106e21:	8b 45 08             	mov    0x8(%ebp),%eax
80106e24:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e28:	0f b7 c0             	movzwl %ax,%eax
80106e2b:	83 e0 03             	and    $0x3,%eax
80106e2e:	85 c0                	test   %eax,%eax
80106e30:	75 40                	jne    80106e72 <trap+0x248>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e32:	e8 54 fc ff ff       	call   80106a8b <rcr2>
80106e37:	89 c3                	mov    %eax,%ebx
80106e39:	8b 45 08             	mov    0x8(%ebp),%eax
80106e3c:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106e3f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e45:	0f b6 00             	movzbl (%eax),%eax

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e48:	0f b6 d0             	movzbl %al,%edx
80106e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e4e:	8b 40 30             	mov    0x30(%eax),%eax
80106e51:	83 ec 0c             	sub    $0xc,%esp
80106e54:	53                   	push   %ebx
80106e55:	51                   	push   %ecx
80106e56:	52                   	push   %edx
80106e57:	50                   	push   %eax
80106e58:	68 c8 91 10 80       	push   $0x801091c8
80106e5d:	e8 64 95 ff ff       	call   801003c6 <cprintf>
80106e62:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106e65:	83 ec 0c             	sub    $0xc,%esp
80106e68:	68 fa 91 10 80       	push   $0x801091fa
80106e6d:	e8 f4 96 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e72:	e8 14 fc ff ff       	call   80106a8b <rcr2>
80106e77:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80106e7d:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106e80:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e86:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e89:	0f b6 d8             	movzbl %al,%ebx
80106e8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e8f:	8b 48 34             	mov    0x34(%eax),%ecx
80106e92:	8b 45 08             	mov    0x8(%ebp),%eax
80106e95:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106e98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e9e:	8d 78 6c             	lea    0x6c(%eax),%edi
80106ea1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ea7:	8b 40 10             	mov    0x10(%eax),%eax
80106eaa:	ff 75 d4             	pushl  -0x2c(%ebp)
80106ead:	56                   	push   %esi
80106eae:	53                   	push   %ebx
80106eaf:	51                   	push   %ecx
80106eb0:	52                   	push   %edx
80106eb1:	57                   	push   %edi
80106eb2:	50                   	push   %eax
80106eb3:	68 00 92 10 80       	push   $0x80109200
80106eb8:	e8 09 95 ff ff       	call   801003c6 <cprintf>
80106ebd:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
            rcr2());
    proc->killed = 1;
80106ec0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ec6:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106ecd:	eb 04                	jmp    80106ed3 <trap+0x2a9>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106ecf:	90                   	nop
80106ed0:	eb 01                	jmp    80106ed3 <trap+0x2a9>
      } else if (proc->shared == 1) {
        cprintf("Do stuff!");
        
      }

      break;
80106ed2:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106ed3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ed9:	85 c0                	test   %eax,%eax
80106edb:	74 24                	je     80106f01 <trap+0x2d7>
80106edd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ee3:	8b 40 24             	mov    0x24(%eax),%eax
80106ee6:	85 c0                	test   %eax,%eax
80106ee8:	74 17                	je     80106f01 <trap+0x2d7>
80106eea:	8b 45 08             	mov    0x8(%ebp),%eax
80106eed:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ef1:	0f b7 c0             	movzwl %ax,%eax
80106ef4:	83 e0 03             	and    $0x3,%eax
80106ef7:	83 f8 03             	cmp    $0x3,%eax
80106efa:	75 05                	jne    80106f01 <trap+0x2d7>
    exit();
80106efc:	e8 10 db ff ff       	call   80104a11 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106f01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f07:	85 c0                	test   %eax,%eax
80106f09:	74 1e                	je     80106f29 <trap+0x2ff>
80106f0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f11:	8b 40 0c             	mov    0xc(%eax),%eax
80106f14:	83 f8 04             	cmp    $0x4,%eax
80106f17:	75 10                	jne    80106f29 <trap+0x2ff>
80106f19:	8b 45 08             	mov    0x8(%ebp),%eax
80106f1c:	8b 40 30             	mov    0x30(%eax),%eax
80106f1f:	83 f8 20             	cmp    $0x20,%eax
80106f22:	75 05                	jne    80106f29 <trap+0x2ff>
    yield();
80106f24:	e8 ae de ff ff       	call   80104dd7 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106f29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f2f:	85 c0                	test   %eax,%eax
80106f31:	74 27                	je     80106f5a <trap+0x330>
80106f33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f39:	8b 40 24             	mov    0x24(%eax),%eax
80106f3c:	85 c0                	test   %eax,%eax
80106f3e:	74 1a                	je     80106f5a <trap+0x330>
80106f40:	8b 45 08             	mov    0x8(%ebp),%eax
80106f43:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f47:	0f b7 c0             	movzwl %ax,%eax
80106f4a:	83 e0 03             	and    $0x3,%eax
80106f4d:	83 f8 03             	cmp    $0x3,%eax
80106f50:	75 08                	jne    80106f5a <trap+0x330>
    exit();
80106f52:	e8 ba da ff ff       	call   80104a11 <exit>
80106f57:	eb 01                	jmp    80106f5a <trap+0x330>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106f59:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f5d:	5b                   	pop    %ebx
80106f5e:	5e                   	pop    %esi
80106f5f:	5f                   	pop    %edi
80106f60:	5d                   	pop    %ebp
80106f61:	c3                   	ret    

80106f62 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106f62:	55                   	push   %ebp
80106f63:	89 e5                	mov    %esp,%ebp
80106f65:	83 ec 14             	sub    $0x14,%esp
80106f68:	8b 45 08             	mov    0x8(%ebp),%eax
80106f6b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f6f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106f73:	89 c2                	mov    %eax,%edx
80106f75:	ec                   	in     (%dx),%al
80106f76:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106f79:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106f7d:	c9                   	leave  
80106f7e:	c3                   	ret    

80106f7f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106f7f:	55                   	push   %ebp
80106f80:	89 e5                	mov    %esp,%ebp
80106f82:	83 ec 08             	sub    $0x8,%esp
80106f85:	8b 55 08             	mov    0x8(%ebp),%edx
80106f88:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f8b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106f8f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f92:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106f96:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106f9a:	ee                   	out    %al,(%dx)
}
80106f9b:	90                   	nop
80106f9c:	c9                   	leave  
80106f9d:	c3                   	ret    

80106f9e <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106f9e:	55                   	push   %ebp
80106f9f:	89 e5                	mov    %esp,%ebp
80106fa1:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106fa4:	6a 00                	push   $0x0
80106fa6:	68 fa 03 00 00       	push   $0x3fa
80106fab:	e8 cf ff ff ff       	call   80106f7f <outb>
80106fb0:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106fb3:	68 80 00 00 00       	push   $0x80
80106fb8:	68 fb 03 00 00       	push   $0x3fb
80106fbd:	e8 bd ff ff ff       	call   80106f7f <outb>
80106fc2:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106fc5:	6a 0c                	push   $0xc
80106fc7:	68 f8 03 00 00       	push   $0x3f8
80106fcc:	e8 ae ff ff ff       	call   80106f7f <outb>
80106fd1:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106fd4:	6a 00                	push   $0x0
80106fd6:	68 f9 03 00 00       	push   $0x3f9
80106fdb:	e8 9f ff ff ff       	call   80106f7f <outb>
80106fe0:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106fe3:	6a 03                	push   $0x3
80106fe5:	68 fb 03 00 00       	push   $0x3fb
80106fea:	e8 90 ff ff ff       	call   80106f7f <outb>
80106fef:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106ff2:	6a 00                	push   $0x0
80106ff4:	68 fc 03 00 00       	push   $0x3fc
80106ff9:	e8 81 ff ff ff       	call   80106f7f <outb>
80106ffe:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107001:	6a 01                	push   $0x1
80107003:	68 f9 03 00 00       	push   $0x3f9
80107008:	e8 72 ff ff ff       	call   80106f7f <outb>
8010700d:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107010:	68 fd 03 00 00       	push   $0x3fd
80107015:	e8 48 ff ff ff       	call   80106f62 <inb>
8010701a:	83 c4 04             	add    $0x4,%esp
8010701d:	3c ff                	cmp    $0xff,%al
8010701f:	74 6e                	je     8010708f <uartinit+0xf1>
    return;
  uart = 1;
80107021:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80107028:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010702b:	68 fa 03 00 00       	push   $0x3fa
80107030:	e8 2d ff ff ff       	call   80106f62 <inb>
80107035:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107038:	68 f8 03 00 00       	push   $0x3f8
8010703d:	e8 20 ff ff ff       	call   80106f62 <inb>
80107042:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107045:	83 ec 0c             	sub    $0xc,%esp
80107048:	6a 04                	push   $0x4
8010704a:	e8 2d ce ff ff       	call   80103e7c <picenable>
8010704f:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107052:	83 ec 08             	sub    $0x8,%esp
80107055:	6a 00                	push   $0x0
80107057:	6a 04                	push   $0x4
80107059:	e8 db b9 ff ff       	call   80102a39 <ioapicenable>
8010705e:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107061:	c7 45 f4 44 93 10 80 	movl   $0x80109344,-0xc(%ebp)
80107068:	eb 19                	jmp    80107083 <uartinit+0xe5>
    uartputc(*p);
8010706a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010706d:	0f b6 00             	movzbl (%eax),%eax
80107070:	0f be c0             	movsbl %al,%eax
80107073:	83 ec 0c             	sub    $0xc,%esp
80107076:	50                   	push   %eax
80107077:	e8 16 00 00 00       	call   80107092 <uartputc>
8010707c:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010707f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107086:	0f b6 00             	movzbl (%eax),%eax
80107089:	84 c0                	test   %al,%al
8010708b:	75 dd                	jne    8010706a <uartinit+0xcc>
8010708d:	eb 01                	jmp    80107090 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010708f:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107090:	c9                   	leave  
80107091:	c3                   	ret    

80107092 <uartputc>:

void
uartputc(int c)
{
80107092:	55                   	push   %ebp
80107093:	89 e5                	mov    %esp,%ebp
80107095:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107098:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
8010709d:	85 c0                	test   %eax,%eax
8010709f:	74 53                	je     801070f4 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801070a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801070a8:	eb 11                	jmp    801070bb <uartputc+0x29>
    microdelay(10);
801070aa:	83 ec 0c             	sub    $0xc,%esp
801070ad:	6a 0a                	push   $0xa
801070af:	e8 eb be ff ff       	call   80102f9f <microdelay>
801070b4:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801070b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801070bb:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801070bf:	7f 1a                	jg     801070db <uartputc+0x49>
801070c1:	83 ec 0c             	sub    $0xc,%esp
801070c4:	68 fd 03 00 00       	push   $0x3fd
801070c9:	e8 94 fe ff ff       	call   80106f62 <inb>
801070ce:	83 c4 10             	add    $0x10,%esp
801070d1:	0f b6 c0             	movzbl %al,%eax
801070d4:	83 e0 20             	and    $0x20,%eax
801070d7:	85 c0                	test   %eax,%eax
801070d9:	74 cf                	je     801070aa <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801070db:	8b 45 08             	mov    0x8(%ebp),%eax
801070de:	0f b6 c0             	movzbl %al,%eax
801070e1:	83 ec 08             	sub    $0x8,%esp
801070e4:	50                   	push   %eax
801070e5:	68 f8 03 00 00       	push   $0x3f8
801070ea:	e8 90 fe ff ff       	call   80106f7f <outb>
801070ef:	83 c4 10             	add    $0x10,%esp
801070f2:	eb 01                	jmp    801070f5 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801070f4:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801070f5:	c9                   	leave  
801070f6:	c3                   	ret    

801070f7 <uartgetc>:

static int
uartgetc(void)
{
801070f7:	55                   	push   %ebp
801070f8:	89 e5                	mov    %esp,%ebp
  if(!uart)
801070fa:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801070ff:	85 c0                	test   %eax,%eax
80107101:	75 07                	jne    8010710a <uartgetc+0x13>
    return -1;
80107103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107108:	eb 2e                	jmp    80107138 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010710a:	68 fd 03 00 00       	push   $0x3fd
8010710f:	e8 4e fe ff ff       	call   80106f62 <inb>
80107114:	83 c4 04             	add    $0x4,%esp
80107117:	0f b6 c0             	movzbl %al,%eax
8010711a:	83 e0 01             	and    $0x1,%eax
8010711d:	85 c0                	test   %eax,%eax
8010711f:	75 07                	jne    80107128 <uartgetc+0x31>
    return -1;
80107121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107126:	eb 10                	jmp    80107138 <uartgetc+0x41>
  return inb(COM1+0);
80107128:	68 f8 03 00 00       	push   $0x3f8
8010712d:	e8 30 fe ff ff       	call   80106f62 <inb>
80107132:	83 c4 04             	add    $0x4,%esp
80107135:	0f b6 c0             	movzbl %al,%eax
}
80107138:	c9                   	leave  
80107139:	c3                   	ret    

8010713a <uartintr>:

void
uartintr(void)
{
8010713a:	55                   	push   %ebp
8010713b:	89 e5                	mov    %esp,%ebp
8010713d:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107140:	83 ec 0c             	sub    $0xc,%esp
80107143:	68 f7 70 10 80       	push   $0x801070f7
80107148:	e8 90 96 ff ff       	call   801007dd <consoleintr>
8010714d:	83 c4 10             	add    $0x10,%esp
}
80107150:	90                   	nop
80107151:	c9                   	leave  
80107152:	c3                   	ret    

80107153 <vector0>:
80107153:	6a 00                	push   $0x0
80107155:	6a 00                	push   $0x0
80107157:	e9 da f8 ff ff       	jmp    80106a36 <alltraps>

8010715c <vector1>:
8010715c:	6a 00                	push   $0x0
8010715e:	6a 01                	push   $0x1
80107160:	e9 d1 f8 ff ff       	jmp    80106a36 <alltraps>

80107165 <vector2>:
80107165:	6a 00                	push   $0x0
80107167:	6a 02                	push   $0x2
80107169:	e9 c8 f8 ff ff       	jmp    80106a36 <alltraps>

8010716e <vector3>:
8010716e:	6a 00                	push   $0x0
80107170:	6a 03                	push   $0x3
80107172:	e9 bf f8 ff ff       	jmp    80106a36 <alltraps>

80107177 <vector4>:
80107177:	6a 00                	push   $0x0
80107179:	6a 04                	push   $0x4
8010717b:	e9 b6 f8 ff ff       	jmp    80106a36 <alltraps>

80107180 <vector5>:
80107180:	6a 00                	push   $0x0
80107182:	6a 05                	push   $0x5
80107184:	e9 ad f8 ff ff       	jmp    80106a36 <alltraps>

80107189 <vector6>:
80107189:	6a 00                	push   $0x0
8010718b:	6a 06                	push   $0x6
8010718d:	e9 a4 f8 ff ff       	jmp    80106a36 <alltraps>

80107192 <vector7>:
80107192:	6a 00                	push   $0x0
80107194:	6a 07                	push   $0x7
80107196:	e9 9b f8 ff ff       	jmp    80106a36 <alltraps>

8010719b <vector8>:
8010719b:	6a 08                	push   $0x8
8010719d:	e9 94 f8 ff ff       	jmp    80106a36 <alltraps>

801071a2 <vector9>:
801071a2:	6a 00                	push   $0x0
801071a4:	6a 09                	push   $0x9
801071a6:	e9 8b f8 ff ff       	jmp    80106a36 <alltraps>

801071ab <vector10>:
801071ab:	6a 0a                	push   $0xa
801071ad:	e9 84 f8 ff ff       	jmp    80106a36 <alltraps>

801071b2 <vector11>:
801071b2:	6a 0b                	push   $0xb
801071b4:	e9 7d f8 ff ff       	jmp    80106a36 <alltraps>

801071b9 <vector12>:
801071b9:	6a 0c                	push   $0xc
801071bb:	e9 76 f8 ff ff       	jmp    80106a36 <alltraps>

801071c0 <vector13>:
801071c0:	6a 0d                	push   $0xd
801071c2:	e9 6f f8 ff ff       	jmp    80106a36 <alltraps>

801071c7 <vector14>:
801071c7:	6a 0e                	push   $0xe
801071c9:	e9 68 f8 ff ff       	jmp    80106a36 <alltraps>

801071ce <vector15>:
801071ce:	6a 00                	push   $0x0
801071d0:	6a 0f                	push   $0xf
801071d2:	e9 5f f8 ff ff       	jmp    80106a36 <alltraps>

801071d7 <vector16>:
801071d7:	6a 00                	push   $0x0
801071d9:	6a 10                	push   $0x10
801071db:	e9 56 f8 ff ff       	jmp    80106a36 <alltraps>

801071e0 <vector17>:
801071e0:	6a 11                	push   $0x11
801071e2:	e9 4f f8 ff ff       	jmp    80106a36 <alltraps>

801071e7 <vector18>:
801071e7:	6a 00                	push   $0x0
801071e9:	6a 12                	push   $0x12
801071eb:	e9 46 f8 ff ff       	jmp    80106a36 <alltraps>

801071f0 <vector19>:
801071f0:	6a 00                	push   $0x0
801071f2:	6a 13                	push   $0x13
801071f4:	e9 3d f8 ff ff       	jmp    80106a36 <alltraps>

801071f9 <vector20>:
801071f9:	6a 00                	push   $0x0
801071fb:	6a 14                	push   $0x14
801071fd:	e9 34 f8 ff ff       	jmp    80106a36 <alltraps>

80107202 <vector21>:
80107202:	6a 00                	push   $0x0
80107204:	6a 15                	push   $0x15
80107206:	e9 2b f8 ff ff       	jmp    80106a36 <alltraps>

8010720b <vector22>:
8010720b:	6a 00                	push   $0x0
8010720d:	6a 16                	push   $0x16
8010720f:	e9 22 f8 ff ff       	jmp    80106a36 <alltraps>

80107214 <vector23>:
80107214:	6a 00                	push   $0x0
80107216:	6a 17                	push   $0x17
80107218:	e9 19 f8 ff ff       	jmp    80106a36 <alltraps>

8010721d <vector24>:
8010721d:	6a 00                	push   $0x0
8010721f:	6a 18                	push   $0x18
80107221:	e9 10 f8 ff ff       	jmp    80106a36 <alltraps>

80107226 <vector25>:
80107226:	6a 00                	push   $0x0
80107228:	6a 19                	push   $0x19
8010722a:	e9 07 f8 ff ff       	jmp    80106a36 <alltraps>

8010722f <vector26>:
8010722f:	6a 00                	push   $0x0
80107231:	6a 1a                	push   $0x1a
80107233:	e9 fe f7 ff ff       	jmp    80106a36 <alltraps>

80107238 <vector27>:
80107238:	6a 00                	push   $0x0
8010723a:	6a 1b                	push   $0x1b
8010723c:	e9 f5 f7 ff ff       	jmp    80106a36 <alltraps>

80107241 <vector28>:
80107241:	6a 00                	push   $0x0
80107243:	6a 1c                	push   $0x1c
80107245:	e9 ec f7 ff ff       	jmp    80106a36 <alltraps>

8010724a <vector29>:
8010724a:	6a 00                	push   $0x0
8010724c:	6a 1d                	push   $0x1d
8010724e:	e9 e3 f7 ff ff       	jmp    80106a36 <alltraps>

80107253 <vector30>:
80107253:	6a 00                	push   $0x0
80107255:	6a 1e                	push   $0x1e
80107257:	e9 da f7 ff ff       	jmp    80106a36 <alltraps>

8010725c <vector31>:
8010725c:	6a 00                	push   $0x0
8010725e:	6a 1f                	push   $0x1f
80107260:	e9 d1 f7 ff ff       	jmp    80106a36 <alltraps>

80107265 <vector32>:
80107265:	6a 00                	push   $0x0
80107267:	6a 20                	push   $0x20
80107269:	e9 c8 f7 ff ff       	jmp    80106a36 <alltraps>

8010726e <vector33>:
8010726e:	6a 00                	push   $0x0
80107270:	6a 21                	push   $0x21
80107272:	e9 bf f7 ff ff       	jmp    80106a36 <alltraps>

80107277 <vector34>:
80107277:	6a 00                	push   $0x0
80107279:	6a 22                	push   $0x22
8010727b:	e9 b6 f7 ff ff       	jmp    80106a36 <alltraps>

80107280 <vector35>:
80107280:	6a 00                	push   $0x0
80107282:	6a 23                	push   $0x23
80107284:	e9 ad f7 ff ff       	jmp    80106a36 <alltraps>

80107289 <vector36>:
80107289:	6a 00                	push   $0x0
8010728b:	6a 24                	push   $0x24
8010728d:	e9 a4 f7 ff ff       	jmp    80106a36 <alltraps>

80107292 <vector37>:
80107292:	6a 00                	push   $0x0
80107294:	6a 25                	push   $0x25
80107296:	e9 9b f7 ff ff       	jmp    80106a36 <alltraps>

8010729b <vector38>:
8010729b:	6a 00                	push   $0x0
8010729d:	6a 26                	push   $0x26
8010729f:	e9 92 f7 ff ff       	jmp    80106a36 <alltraps>

801072a4 <vector39>:
801072a4:	6a 00                	push   $0x0
801072a6:	6a 27                	push   $0x27
801072a8:	e9 89 f7 ff ff       	jmp    80106a36 <alltraps>

801072ad <vector40>:
801072ad:	6a 00                	push   $0x0
801072af:	6a 28                	push   $0x28
801072b1:	e9 80 f7 ff ff       	jmp    80106a36 <alltraps>

801072b6 <vector41>:
801072b6:	6a 00                	push   $0x0
801072b8:	6a 29                	push   $0x29
801072ba:	e9 77 f7 ff ff       	jmp    80106a36 <alltraps>

801072bf <vector42>:
801072bf:	6a 00                	push   $0x0
801072c1:	6a 2a                	push   $0x2a
801072c3:	e9 6e f7 ff ff       	jmp    80106a36 <alltraps>

801072c8 <vector43>:
801072c8:	6a 00                	push   $0x0
801072ca:	6a 2b                	push   $0x2b
801072cc:	e9 65 f7 ff ff       	jmp    80106a36 <alltraps>

801072d1 <vector44>:
801072d1:	6a 00                	push   $0x0
801072d3:	6a 2c                	push   $0x2c
801072d5:	e9 5c f7 ff ff       	jmp    80106a36 <alltraps>

801072da <vector45>:
801072da:	6a 00                	push   $0x0
801072dc:	6a 2d                	push   $0x2d
801072de:	e9 53 f7 ff ff       	jmp    80106a36 <alltraps>

801072e3 <vector46>:
801072e3:	6a 00                	push   $0x0
801072e5:	6a 2e                	push   $0x2e
801072e7:	e9 4a f7 ff ff       	jmp    80106a36 <alltraps>

801072ec <vector47>:
801072ec:	6a 00                	push   $0x0
801072ee:	6a 2f                	push   $0x2f
801072f0:	e9 41 f7 ff ff       	jmp    80106a36 <alltraps>

801072f5 <vector48>:
801072f5:	6a 00                	push   $0x0
801072f7:	6a 30                	push   $0x30
801072f9:	e9 38 f7 ff ff       	jmp    80106a36 <alltraps>

801072fe <vector49>:
801072fe:	6a 00                	push   $0x0
80107300:	6a 31                	push   $0x31
80107302:	e9 2f f7 ff ff       	jmp    80106a36 <alltraps>

80107307 <vector50>:
80107307:	6a 00                	push   $0x0
80107309:	6a 32                	push   $0x32
8010730b:	e9 26 f7 ff ff       	jmp    80106a36 <alltraps>

80107310 <vector51>:
80107310:	6a 00                	push   $0x0
80107312:	6a 33                	push   $0x33
80107314:	e9 1d f7 ff ff       	jmp    80106a36 <alltraps>

80107319 <vector52>:
80107319:	6a 00                	push   $0x0
8010731b:	6a 34                	push   $0x34
8010731d:	e9 14 f7 ff ff       	jmp    80106a36 <alltraps>

80107322 <vector53>:
80107322:	6a 00                	push   $0x0
80107324:	6a 35                	push   $0x35
80107326:	e9 0b f7 ff ff       	jmp    80106a36 <alltraps>

8010732b <vector54>:
8010732b:	6a 00                	push   $0x0
8010732d:	6a 36                	push   $0x36
8010732f:	e9 02 f7 ff ff       	jmp    80106a36 <alltraps>

80107334 <vector55>:
80107334:	6a 00                	push   $0x0
80107336:	6a 37                	push   $0x37
80107338:	e9 f9 f6 ff ff       	jmp    80106a36 <alltraps>

8010733d <vector56>:
8010733d:	6a 00                	push   $0x0
8010733f:	6a 38                	push   $0x38
80107341:	e9 f0 f6 ff ff       	jmp    80106a36 <alltraps>

80107346 <vector57>:
80107346:	6a 00                	push   $0x0
80107348:	6a 39                	push   $0x39
8010734a:	e9 e7 f6 ff ff       	jmp    80106a36 <alltraps>

8010734f <vector58>:
8010734f:	6a 00                	push   $0x0
80107351:	6a 3a                	push   $0x3a
80107353:	e9 de f6 ff ff       	jmp    80106a36 <alltraps>

80107358 <vector59>:
80107358:	6a 00                	push   $0x0
8010735a:	6a 3b                	push   $0x3b
8010735c:	e9 d5 f6 ff ff       	jmp    80106a36 <alltraps>

80107361 <vector60>:
80107361:	6a 00                	push   $0x0
80107363:	6a 3c                	push   $0x3c
80107365:	e9 cc f6 ff ff       	jmp    80106a36 <alltraps>

8010736a <vector61>:
8010736a:	6a 00                	push   $0x0
8010736c:	6a 3d                	push   $0x3d
8010736e:	e9 c3 f6 ff ff       	jmp    80106a36 <alltraps>

80107373 <vector62>:
80107373:	6a 00                	push   $0x0
80107375:	6a 3e                	push   $0x3e
80107377:	e9 ba f6 ff ff       	jmp    80106a36 <alltraps>

8010737c <vector63>:
8010737c:	6a 00                	push   $0x0
8010737e:	6a 3f                	push   $0x3f
80107380:	e9 b1 f6 ff ff       	jmp    80106a36 <alltraps>

80107385 <vector64>:
80107385:	6a 00                	push   $0x0
80107387:	6a 40                	push   $0x40
80107389:	e9 a8 f6 ff ff       	jmp    80106a36 <alltraps>

8010738e <vector65>:
8010738e:	6a 00                	push   $0x0
80107390:	6a 41                	push   $0x41
80107392:	e9 9f f6 ff ff       	jmp    80106a36 <alltraps>

80107397 <vector66>:
80107397:	6a 00                	push   $0x0
80107399:	6a 42                	push   $0x42
8010739b:	e9 96 f6 ff ff       	jmp    80106a36 <alltraps>

801073a0 <vector67>:
801073a0:	6a 00                	push   $0x0
801073a2:	6a 43                	push   $0x43
801073a4:	e9 8d f6 ff ff       	jmp    80106a36 <alltraps>

801073a9 <vector68>:
801073a9:	6a 00                	push   $0x0
801073ab:	6a 44                	push   $0x44
801073ad:	e9 84 f6 ff ff       	jmp    80106a36 <alltraps>

801073b2 <vector69>:
801073b2:	6a 00                	push   $0x0
801073b4:	6a 45                	push   $0x45
801073b6:	e9 7b f6 ff ff       	jmp    80106a36 <alltraps>

801073bb <vector70>:
801073bb:	6a 00                	push   $0x0
801073bd:	6a 46                	push   $0x46
801073bf:	e9 72 f6 ff ff       	jmp    80106a36 <alltraps>

801073c4 <vector71>:
801073c4:	6a 00                	push   $0x0
801073c6:	6a 47                	push   $0x47
801073c8:	e9 69 f6 ff ff       	jmp    80106a36 <alltraps>

801073cd <vector72>:
801073cd:	6a 00                	push   $0x0
801073cf:	6a 48                	push   $0x48
801073d1:	e9 60 f6 ff ff       	jmp    80106a36 <alltraps>

801073d6 <vector73>:
801073d6:	6a 00                	push   $0x0
801073d8:	6a 49                	push   $0x49
801073da:	e9 57 f6 ff ff       	jmp    80106a36 <alltraps>

801073df <vector74>:
801073df:	6a 00                	push   $0x0
801073e1:	6a 4a                	push   $0x4a
801073e3:	e9 4e f6 ff ff       	jmp    80106a36 <alltraps>

801073e8 <vector75>:
801073e8:	6a 00                	push   $0x0
801073ea:	6a 4b                	push   $0x4b
801073ec:	e9 45 f6 ff ff       	jmp    80106a36 <alltraps>

801073f1 <vector76>:
801073f1:	6a 00                	push   $0x0
801073f3:	6a 4c                	push   $0x4c
801073f5:	e9 3c f6 ff ff       	jmp    80106a36 <alltraps>

801073fa <vector77>:
801073fa:	6a 00                	push   $0x0
801073fc:	6a 4d                	push   $0x4d
801073fe:	e9 33 f6 ff ff       	jmp    80106a36 <alltraps>

80107403 <vector78>:
80107403:	6a 00                	push   $0x0
80107405:	6a 4e                	push   $0x4e
80107407:	e9 2a f6 ff ff       	jmp    80106a36 <alltraps>

8010740c <vector79>:
8010740c:	6a 00                	push   $0x0
8010740e:	6a 4f                	push   $0x4f
80107410:	e9 21 f6 ff ff       	jmp    80106a36 <alltraps>

80107415 <vector80>:
80107415:	6a 00                	push   $0x0
80107417:	6a 50                	push   $0x50
80107419:	e9 18 f6 ff ff       	jmp    80106a36 <alltraps>

8010741e <vector81>:
8010741e:	6a 00                	push   $0x0
80107420:	6a 51                	push   $0x51
80107422:	e9 0f f6 ff ff       	jmp    80106a36 <alltraps>

80107427 <vector82>:
80107427:	6a 00                	push   $0x0
80107429:	6a 52                	push   $0x52
8010742b:	e9 06 f6 ff ff       	jmp    80106a36 <alltraps>

80107430 <vector83>:
80107430:	6a 00                	push   $0x0
80107432:	6a 53                	push   $0x53
80107434:	e9 fd f5 ff ff       	jmp    80106a36 <alltraps>

80107439 <vector84>:
80107439:	6a 00                	push   $0x0
8010743b:	6a 54                	push   $0x54
8010743d:	e9 f4 f5 ff ff       	jmp    80106a36 <alltraps>

80107442 <vector85>:
80107442:	6a 00                	push   $0x0
80107444:	6a 55                	push   $0x55
80107446:	e9 eb f5 ff ff       	jmp    80106a36 <alltraps>

8010744b <vector86>:
8010744b:	6a 00                	push   $0x0
8010744d:	6a 56                	push   $0x56
8010744f:	e9 e2 f5 ff ff       	jmp    80106a36 <alltraps>

80107454 <vector87>:
80107454:	6a 00                	push   $0x0
80107456:	6a 57                	push   $0x57
80107458:	e9 d9 f5 ff ff       	jmp    80106a36 <alltraps>

8010745d <vector88>:
8010745d:	6a 00                	push   $0x0
8010745f:	6a 58                	push   $0x58
80107461:	e9 d0 f5 ff ff       	jmp    80106a36 <alltraps>

80107466 <vector89>:
80107466:	6a 00                	push   $0x0
80107468:	6a 59                	push   $0x59
8010746a:	e9 c7 f5 ff ff       	jmp    80106a36 <alltraps>

8010746f <vector90>:
8010746f:	6a 00                	push   $0x0
80107471:	6a 5a                	push   $0x5a
80107473:	e9 be f5 ff ff       	jmp    80106a36 <alltraps>

80107478 <vector91>:
80107478:	6a 00                	push   $0x0
8010747a:	6a 5b                	push   $0x5b
8010747c:	e9 b5 f5 ff ff       	jmp    80106a36 <alltraps>

80107481 <vector92>:
80107481:	6a 00                	push   $0x0
80107483:	6a 5c                	push   $0x5c
80107485:	e9 ac f5 ff ff       	jmp    80106a36 <alltraps>

8010748a <vector93>:
8010748a:	6a 00                	push   $0x0
8010748c:	6a 5d                	push   $0x5d
8010748e:	e9 a3 f5 ff ff       	jmp    80106a36 <alltraps>

80107493 <vector94>:
80107493:	6a 00                	push   $0x0
80107495:	6a 5e                	push   $0x5e
80107497:	e9 9a f5 ff ff       	jmp    80106a36 <alltraps>

8010749c <vector95>:
8010749c:	6a 00                	push   $0x0
8010749e:	6a 5f                	push   $0x5f
801074a0:	e9 91 f5 ff ff       	jmp    80106a36 <alltraps>

801074a5 <vector96>:
801074a5:	6a 00                	push   $0x0
801074a7:	6a 60                	push   $0x60
801074a9:	e9 88 f5 ff ff       	jmp    80106a36 <alltraps>

801074ae <vector97>:
801074ae:	6a 00                	push   $0x0
801074b0:	6a 61                	push   $0x61
801074b2:	e9 7f f5 ff ff       	jmp    80106a36 <alltraps>

801074b7 <vector98>:
801074b7:	6a 00                	push   $0x0
801074b9:	6a 62                	push   $0x62
801074bb:	e9 76 f5 ff ff       	jmp    80106a36 <alltraps>

801074c0 <vector99>:
801074c0:	6a 00                	push   $0x0
801074c2:	6a 63                	push   $0x63
801074c4:	e9 6d f5 ff ff       	jmp    80106a36 <alltraps>

801074c9 <vector100>:
801074c9:	6a 00                	push   $0x0
801074cb:	6a 64                	push   $0x64
801074cd:	e9 64 f5 ff ff       	jmp    80106a36 <alltraps>

801074d2 <vector101>:
801074d2:	6a 00                	push   $0x0
801074d4:	6a 65                	push   $0x65
801074d6:	e9 5b f5 ff ff       	jmp    80106a36 <alltraps>

801074db <vector102>:
801074db:	6a 00                	push   $0x0
801074dd:	6a 66                	push   $0x66
801074df:	e9 52 f5 ff ff       	jmp    80106a36 <alltraps>

801074e4 <vector103>:
801074e4:	6a 00                	push   $0x0
801074e6:	6a 67                	push   $0x67
801074e8:	e9 49 f5 ff ff       	jmp    80106a36 <alltraps>

801074ed <vector104>:
801074ed:	6a 00                	push   $0x0
801074ef:	6a 68                	push   $0x68
801074f1:	e9 40 f5 ff ff       	jmp    80106a36 <alltraps>

801074f6 <vector105>:
801074f6:	6a 00                	push   $0x0
801074f8:	6a 69                	push   $0x69
801074fa:	e9 37 f5 ff ff       	jmp    80106a36 <alltraps>

801074ff <vector106>:
801074ff:	6a 00                	push   $0x0
80107501:	6a 6a                	push   $0x6a
80107503:	e9 2e f5 ff ff       	jmp    80106a36 <alltraps>

80107508 <vector107>:
80107508:	6a 00                	push   $0x0
8010750a:	6a 6b                	push   $0x6b
8010750c:	e9 25 f5 ff ff       	jmp    80106a36 <alltraps>

80107511 <vector108>:
80107511:	6a 00                	push   $0x0
80107513:	6a 6c                	push   $0x6c
80107515:	e9 1c f5 ff ff       	jmp    80106a36 <alltraps>

8010751a <vector109>:
8010751a:	6a 00                	push   $0x0
8010751c:	6a 6d                	push   $0x6d
8010751e:	e9 13 f5 ff ff       	jmp    80106a36 <alltraps>

80107523 <vector110>:
80107523:	6a 00                	push   $0x0
80107525:	6a 6e                	push   $0x6e
80107527:	e9 0a f5 ff ff       	jmp    80106a36 <alltraps>

8010752c <vector111>:
8010752c:	6a 00                	push   $0x0
8010752e:	6a 6f                	push   $0x6f
80107530:	e9 01 f5 ff ff       	jmp    80106a36 <alltraps>

80107535 <vector112>:
80107535:	6a 00                	push   $0x0
80107537:	6a 70                	push   $0x70
80107539:	e9 f8 f4 ff ff       	jmp    80106a36 <alltraps>

8010753e <vector113>:
8010753e:	6a 00                	push   $0x0
80107540:	6a 71                	push   $0x71
80107542:	e9 ef f4 ff ff       	jmp    80106a36 <alltraps>

80107547 <vector114>:
80107547:	6a 00                	push   $0x0
80107549:	6a 72                	push   $0x72
8010754b:	e9 e6 f4 ff ff       	jmp    80106a36 <alltraps>

80107550 <vector115>:
80107550:	6a 00                	push   $0x0
80107552:	6a 73                	push   $0x73
80107554:	e9 dd f4 ff ff       	jmp    80106a36 <alltraps>

80107559 <vector116>:
80107559:	6a 00                	push   $0x0
8010755b:	6a 74                	push   $0x74
8010755d:	e9 d4 f4 ff ff       	jmp    80106a36 <alltraps>

80107562 <vector117>:
80107562:	6a 00                	push   $0x0
80107564:	6a 75                	push   $0x75
80107566:	e9 cb f4 ff ff       	jmp    80106a36 <alltraps>

8010756b <vector118>:
8010756b:	6a 00                	push   $0x0
8010756d:	6a 76                	push   $0x76
8010756f:	e9 c2 f4 ff ff       	jmp    80106a36 <alltraps>

80107574 <vector119>:
80107574:	6a 00                	push   $0x0
80107576:	6a 77                	push   $0x77
80107578:	e9 b9 f4 ff ff       	jmp    80106a36 <alltraps>

8010757d <vector120>:
8010757d:	6a 00                	push   $0x0
8010757f:	6a 78                	push   $0x78
80107581:	e9 b0 f4 ff ff       	jmp    80106a36 <alltraps>

80107586 <vector121>:
80107586:	6a 00                	push   $0x0
80107588:	6a 79                	push   $0x79
8010758a:	e9 a7 f4 ff ff       	jmp    80106a36 <alltraps>

8010758f <vector122>:
8010758f:	6a 00                	push   $0x0
80107591:	6a 7a                	push   $0x7a
80107593:	e9 9e f4 ff ff       	jmp    80106a36 <alltraps>

80107598 <vector123>:
80107598:	6a 00                	push   $0x0
8010759a:	6a 7b                	push   $0x7b
8010759c:	e9 95 f4 ff ff       	jmp    80106a36 <alltraps>

801075a1 <vector124>:
801075a1:	6a 00                	push   $0x0
801075a3:	6a 7c                	push   $0x7c
801075a5:	e9 8c f4 ff ff       	jmp    80106a36 <alltraps>

801075aa <vector125>:
801075aa:	6a 00                	push   $0x0
801075ac:	6a 7d                	push   $0x7d
801075ae:	e9 83 f4 ff ff       	jmp    80106a36 <alltraps>

801075b3 <vector126>:
801075b3:	6a 00                	push   $0x0
801075b5:	6a 7e                	push   $0x7e
801075b7:	e9 7a f4 ff ff       	jmp    80106a36 <alltraps>

801075bc <vector127>:
801075bc:	6a 00                	push   $0x0
801075be:	6a 7f                	push   $0x7f
801075c0:	e9 71 f4 ff ff       	jmp    80106a36 <alltraps>

801075c5 <vector128>:
801075c5:	6a 00                	push   $0x0
801075c7:	68 80 00 00 00       	push   $0x80
801075cc:	e9 65 f4 ff ff       	jmp    80106a36 <alltraps>

801075d1 <vector129>:
801075d1:	6a 00                	push   $0x0
801075d3:	68 81 00 00 00       	push   $0x81
801075d8:	e9 59 f4 ff ff       	jmp    80106a36 <alltraps>

801075dd <vector130>:
801075dd:	6a 00                	push   $0x0
801075df:	68 82 00 00 00       	push   $0x82
801075e4:	e9 4d f4 ff ff       	jmp    80106a36 <alltraps>

801075e9 <vector131>:
801075e9:	6a 00                	push   $0x0
801075eb:	68 83 00 00 00       	push   $0x83
801075f0:	e9 41 f4 ff ff       	jmp    80106a36 <alltraps>

801075f5 <vector132>:
801075f5:	6a 00                	push   $0x0
801075f7:	68 84 00 00 00       	push   $0x84
801075fc:	e9 35 f4 ff ff       	jmp    80106a36 <alltraps>

80107601 <vector133>:
80107601:	6a 00                	push   $0x0
80107603:	68 85 00 00 00       	push   $0x85
80107608:	e9 29 f4 ff ff       	jmp    80106a36 <alltraps>

8010760d <vector134>:
8010760d:	6a 00                	push   $0x0
8010760f:	68 86 00 00 00       	push   $0x86
80107614:	e9 1d f4 ff ff       	jmp    80106a36 <alltraps>

80107619 <vector135>:
80107619:	6a 00                	push   $0x0
8010761b:	68 87 00 00 00       	push   $0x87
80107620:	e9 11 f4 ff ff       	jmp    80106a36 <alltraps>

80107625 <vector136>:
80107625:	6a 00                	push   $0x0
80107627:	68 88 00 00 00       	push   $0x88
8010762c:	e9 05 f4 ff ff       	jmp    80106a36 <alltraps>

80107631 <vector137>:
80107631:	6a 00                	push   $0x0
80107633:	68 89 00 00 00       	push   $0x89
80107638:	e9 f9 f3 ff ff       	jmp    80106a36 <alltraps>

8010763d <vector138>:
8010763d:	6a 00                	push   $0x0
8010763f:	68 8a 00 00 00       	push   $0x8a
80107644:	e9 ed f3 ff ff       	jmp    80106a36 <alltraps>

80107649 <vector139>:
80107649:	6a 00                	push   $0x0
8010764b:	68 8b 00 00 00       	push   $0x8b
80107650:	e9 e1 f3 ff ff       	jmp    80106a36 <alltraps>

80107655 <vector140>:
80107655:	6a 00                	push   $0x0
80107657:	68 8c 00 00 00       	push   $0x8c
8010765c:	e9 d5 f3 ff ff       	jmp    80106a36 <alltraps>

80107661 <vector141>:
80107661:	6a 00                	push   $0x0
80107663:	68 8d 00 00 00       	push   $0x8d
80107668:	e9 c9 f3 ff ff       	jmp    80106a36 <alltraps>

8010766d <vector142>:
8010766d:	6a 00                	push   $0x0
8010766f:	68 8e 00 00 00       	push   $0x8e
80107674:	e9 bd f3 ff ff       	jmp    80106a36 <alltraps>

80107679 <vector143>:
80107679:	6a 00                	push   $0x0
8010767b:	68 8f 00 00 00       	push   $0x8f
80107680:	e9 b1 f3 ff ff       	jmp    80106a36 <alltraps>

80107685 <vector144>:
80107685:	6a 00                	push   $0x0
80107687:	68 90 00 00 00       	push   $0x90
8010768c:	e9 a5 f3 ff ff       	jmp    80106a36 <alltraps>

80107691 <vector145>:
80107691:	6a 00                	push   $0x0
80107693:	68 91 00 00 00       	push   $0x91
80107698:	e9 99 f3 ff ff       	jmp    80106a36 <alltraps>

8010769d <vector146>:
8010769d:	6a 00                	push   $0x0
8010769f:	68 92 00 00 00       	push   $0x92
801076a4:	e9 8d f3 ff ff       	jmp    80106a36 <alltraps>

801076a9 <vector147>:
801076a9:	6a 00                	push   $0x0
801076ab:	68 93 00 00 00       	push   $0x93
801076b0:	e9 81 f3 ff ff       	jmp    80106a36 <alltraps>

801076b5 <vector148>:
801076b5:	6a 00                	push   $0x0
801076b7:	68 94 00 00 00       	push   $0x94
801076bc:	e9 75 f3 ff ff       	jmp    80106a36 <alltraps>

801076c1 <vector149>:
801076c1:	6a 00                	push   $0x0
801076c3:	68 95 00 00 00       	push   $0x95
801076c8:	e9 69 f3 ff ff       	jmp    80106a36 <alltraps>

801076cd <vector150>:
801076cd:	6a 00                	push   $0x0
801076cf:	68 96 00 00 00       	push   $0x96
801076d4:	e9 5d f3 ff ff       	jmp    80106a36 <alltraps>

801076d9 <vector151>:
801076d9:	6a 00                	push   $0x0
801076db:	68 97 00 00 00       	push   $0x97
801076e0:	e9 51 f3 ff ff       	jmp    80106a36 <alltraps>

801076e5 <vector152>:
801076e5:	6a 00                	push   $0x0
801076e7:	68 98 00 00 00       	push   $0x98
801076ec:	e9 45 f3 ff ff       	jmp    80106a36 <alltraps>

801076f1 <vector153>:
801076f1:	6a 00                	push   $0x0
801076f3:	68 99 00 00 00       	push   $0x99
801076f8:	e9 39 f3 ff ff       	jmp    80106a36 <alltraps>

801076fd <vector154>:
801076fd:	6a 00                	push   $0x0
801076ff:	68 9a 00 00 00       	push   $0x9a
80107704:	e9 2d f3 ff ff       	jmp    80106a36 <alltraps>

80107709 <vector155>:
80107709:	6a 00                	push   $0x0
8010770b:	68 9b 00 00 00       	push   $0x9b
80107710:	e9 21 f3 ff ff       	jmp    80106a36 <alltraps>

80107715 <vector156>:
80107715:	6a 00                	push   $0x0
80107717:	68 9c 00 00 00       	push   $0x9c
8010771c:	e9 15 f3 ff ff       	jmp    80106a36 <alltraps>

80107721 <vector157>:
80107721:	6a 00                	push   $0x0
80107723:	68 9d 00 00 00       	push   $0x9d
80107728:	e9 09 f3 ff ff       	jmp    80106a36 <alltraps>

8010772d <vector158>:
8010772d:	6a 00                	push   $0x0
8010772f:	68 9e 00 00 00       	push   $0x9e
80107734:	e9 fd f2 ff ff       	jmp    80106a36 <alltraps>

80107739 <vector159>:
80107739:	6a 00                	push   $0x0
8010773b:	68 9f 00 00 00       	push   $0x9f
80107740:	e9 f1 f2 ff ff       	jmp    80106a36 <alltraps>

80107745 <vector160>:
80107745:	6a 00                	push   $0x0
80107747:	68 a0 00 00 00       	push   $0xa0
8010774c:	e9 e5 f2 ff ff       	jmp    80106a36 <alltraps>

80107751 <vector161>:
80107751:	6a 00                	push   $0x0
80107753:	68 a1 00 00 00       	push   $0xa1
80107758:	e9 d9 f2 ff ff       	jmp    80106a36 <alltraps>

8010775d <vector162>:
8010775d:	6a 00                	push   $0x0
8010775f:	68 a2 00 00 00       	push   $0xa2
80107764:	e9 cd f2 ff ff       	jmp    80106a36 <alltraps>

80107769 <vector163>:
80107769:	6a 00                	push   $0x0
8010776b:	68 a3 00 00 00       	push   $0xa3
80107770:	e9 c1 f2 ff ff       	jmp    80106a36 <alltraps>

80107775 <vector164>:
80107775:	6a 00                	push   $0x0
80107777:	68 a4 00 00 00       	push   $0xa4
8010777c:	e9 b5 f2 ff ff       	jmp    80106a36 <alltraps>

80107781 <vector165>:
80107781:	6a 00                	push   $0x0
80107783:	68 a5 00 00 00       	push   $0xa5
80107788:	e9 a9 f2 ff ff       	jmp    80106a36 <alltraps>

8010778d <vector166>:
8010778d:	6a 00                	push   $0x0
8010778f:	68 a6 00 00 00       	push   $0xa6
80107794:	e9 9d f2 ff ff       	jmp    80106a36 <alltraps>

80107799 <vector167>:
80107799:	6a 00                	push   $0x0
8010779b:	68 a7 00 00 00       	push   $0xa7
801077a0:	e9 91 f2 ff ff       	jmp    80106a36 <alltraps>

801077a5 <vector168>:
801077a5:	6a 00                	push   $0x0
801077a7:	68 a8 00 00 00       	push   $0xa8
801077ac:	e9 85 f2 ff ff       	jmp    80106a36 <alltraps>

801077b1 <vector169>:
801077b1:	6a 00                	push   $0x0
801077b3:	68 a9 00 00 00       	push   $0xa9
801077b8:	e9 79 f2 ff ff       	jmp    80106a36 <alltraps>

801077bd <vector170>:
801077bd:	6a 00                	push   $0x0
801077bf:	68 aa 00 00 00       	push   $0xaa
801077c4:	e9 6d f2 ff ff       	jmp    80106a36 <alltraps>

801077c9 <vector171>:
801077c9:	6a 00                	push   $0x0
801077cb:	68 ab 00 00 00       	push   $0xab
801077d0:	e9 61 f2 ff ff       	jmp    80106a36 <alltraps>

801077d5 <vector172>:
801077d5:	6a 00                	push   $0x0
801077d7:	68 ac 00 00 00       	push   $0xac
801077dc:	e9 55 f2 ff ff       	jmp    80106a36 <alltraps>

801077e1 <vector173>:
801077e1:	6a 00                	push   $0x0
801077e3:	68 ad 00 00 00       	push   $0xad
801077e8:	e9 49 f2 ff ff       	jmp    80106a36 <alltraps>

801077ed <vector174>:
801077ed:	6a 00                	push   $0x0
801077ef:	68 ae 00 00 00       	push   $0xae
801077f4:	e9 3d f2 ff ff       	jmp    80106a36 <alltraps>

801077f9 <vector175>:
801077f9:	6a 00                	push   $0x0
801077fb:	68 af 00 00 00       	push   $0xaf
80107800:	e9 31 f2 ff ff       	jmp    80106a36 <alltraps>

80107805 <vector176>:
80107805:	6a 00                	push   $0x0
80107807:	68 b0 00 00 00       	push   $0xb0
8010780c:	e9 25 f2 ff ff       	jmp    80106a36 <alltraps>

80107811 <vector177>:
80107811:	6a 00                	push   $0x0
80107813:	68 b1 00 00 00       	push   $0xb1
80107818:	e9 19 f2 ff ff       	jmp    80106a36 <alltraps>

8010781d <vector178>:
8010781d:	6a 00                	push   $0x0
8010781f:	68 b2 00 00 00       	push   $0xb2
80107824:	e9 0d f2 ff ff       	jmp    80106a36 <alltraps>

80107829 <vector179>:
80107829:	6a 00                	push   $0x0
8010782b:	68 b3 00 00 00       	push   $0xb3
80107830:	e9 01 f2 ff ff       	jmp    80106a36 <alltraps>

80107835 <vector180>:
80107835:	6a 00                	push   $0x0
80107837:	68 b4 00 00 00       	push   $0xb4
8010783c:	e9 f5 f1 ff ff       	jmp    80106a36 <alltraps>

80107841 <vector181>:
80107841:	6a 00                	push   $0x0
80107843:	68 b5 00 00 00       	push   $0xb5
80107848:	e9 e9 f1 ff ff       	jmp    80106a36 <alltraps>

8010784d <vector182>:
8010784d:	6a 00                	push   $0x0
8010784f:	68 b6 00 00 00       	push   $0xb6
80107854:	e9 dd f1 ff ff       	jmp    80106a36 <alltraps>

80107859 <vector183>:
80107859:	6a 00                	push   $0x0
8010785b:	68 b7 00 00 00       	push   $0xb7
80107860:	e9 d1 f1 ff ff       	jmp    80106a36 <alltraps>

80107865 <vector184>:
80107865:	6a 00                	push   $0x0
80107867:	68 b8 00 00 00       	push   $0xb8
8010786c:	e9 c5 f1 ff ff       	jmp    80106a36 <alltraps>

80107871 <vector185>:
80107871:	6a 00                	push   $0x0
80107873:	68 b9 00 00 00       	push   $0xb9
80107878:	e9 b9 f1 ff ff       	jmp    80106a36 <alltraps>

8010787d <vector186>:
8010787d:	6a 00                	push   $0x0
8010787f:	68 ba 00 00 00       	push   $0xba
80107884:	e9 ad f1 ff ff       	jmp    80106a36 <alltraps>

80107889 <vector187>:
80107889:	6a 00                	push   $0x0
8010788b:	68 bb 00 00 00       	push   $0xbb
80107890:	e9 a1 f1 ff ff       	jmp    80106a36 <alltraps>

80107895 <vector188>:
80107895:	6a 00                	push   $0x0
80107897:	68 bc 00 00 00       	push   $0xbc
8010789c:	e9 95 f1 ff ff       	jmp    80106a36 <alltraps>

801078a1 <vector189>:
801078a1:	6a 00                	push   $0x0
801078a3:	68 bd 00 00 00       	push   $0xbd
801078a8:	e9 89 f1 ff ff       	jmp    80106a36 <alltraps>

801078ad <vector190>:
801078ad:	6a 00                	push   $0x0
801078af:	68 be 00 00 00       	push   $0xbe
801078b4:	e9 7d f1 ff ff       	jmp    80106a36 <alltraps>

801078b9 <vector191>:
801078b9:	6a 00                	push   $0x0
801078bb:	68 bf 00 00 00       	push   $0xbf
801078c0:	e9 71 f1 ff ff       	jmp    80106a36 <alltraps>

801078c5 <vector192>:
801078c5:	6a 00                	push   $0x0
801078c7:	68 c0 00 00 00       	push   $0xc0
801078cc:	e9 65 f1 ff ff       	jmp    80106a36 <alltraps>

801078d1 <vector193>:
801078d1:	6a 00                	push   $0x0
801078d3:	68 c1 00 00 00       	push   $0xc1
801078d8:	e9 59 f1 ff ff       	jmp    80106a36 <alltraps>

801078dd <vector194>:
801078dd:	6a 00                	push   $0x0
801078df:	68 c2 00 00 00       	push   $0xc2
801078e4:	e9 4d f1 ff ff       	jmp    80106a36 <alltraps>

801078e9 <vector195>:
801078e9:	6a 00                	push   $0x0
801078eb:	68 c3 00 00 00       	push   $0xc3
801078f0:	e9 41 f1 ff ff       	jmp    80106a36 <alltraps>

801078f5 <vector196>:
801078f5:	6a 00                	push   $0x0
801078f7:	68 c4 00 00 00       	push   $0xc4
801078fc:	e9 35 f1 ff ff       	jmp    80106a36 <alltraps>

80107901 <vector197>:
80107901:	6a 00                	push   $0x0
80107903:	68 c5 00 00 00       	push   $0xc5
80107908:	e9 29 f1 ff ff       	jmp    80106a36 <alltraps>

8010790d <vector198>:
8010790d:	6a 00                	push   $0x0
8010790f:	68 c6 00 00 00       	push   $0xc6
80107914:	e9 1d f1 ff ff       	jmp    80106a36 <alltraps>

80107919 <vector199>:
80107919:	6a 00                	push   $0x0
8010791b:	68 c7 00 00 00       	push   $0xc7
80107920:	e9 11 f1 ff ff       	jmp    80106a36 <alltraps>

80107925 <vector200>:
80107925:	6a 00                	push   $0x0
80107927:	68 c8 00 00 00       	push   $0xc8
8010792c:	e9 05 f1 ff ff       	jmp    80106a36 <alltraps>

80107931 <vector201>:
80107931:	6a 00                	push   $0x0
80107933:	68 c9 00 00 00       	push   $0xc9
80107938:	e9 f9 f0 ff ff       	jmp    80106a36 <alltraps>

8010793d <vector202>:
8010793d:	6a 00                	push   $0x0
8010793f:	68 ca 00 00 00       	push   $0xca
80107944:	e9 ed f0 ff ff       	jmp    80106a36 <alltraps>

80107949 <vector203>:
80107949:	6a 00                	push   $0x0
8010794b:	68 cb 00 00 00       	push   $0xcb
80107950:	e9 e1 f0 ff ff       	jmp    80106a36 <alltraps>

80107955 <vector204>:
80107955:	6a 00                	push   $0x0
80107957:	68 cc 00 00 00       	push   $0xcc
8010795c:	e9 d5 f0 ff ff       	jmp    80106a36 <alltraps>

80107961 <vector205>:
80107961:	6a 00                	push   $0x0
80107963:	68 cd 00 00 00       	push   $0xcd
80107968:	e9 c9 f0 ff ff       	jmp    80106a36 <alltraps>

8010796d <vector206>:
8010796d:	6a 00                	push   $0x0
8010796f:	68 ce 00 00 00       	push   $0xce
80107974:	e9 bd f0 ff ff       	jmp    80106a36 <alltraps>

80107979 <vector207>:
80107979:	6a 00                	push   $0x0
8010797b:	68 cf 00 00 00       	push   $0xcf
80107980:	e9 b1 f0 ff ff       	jmp    80106a36 <alltraps>

80107985 <vector208>:
80107985:	6a 00                	push   $0x0
80107987:	68 d0 00 00 00       	push   $0xd0
8010798c:	e9 a5 f0 ff ff       	jmp    80106a36 <alltraps>

80107991 <vector209>:
80107991:	6a 00                	push   $0x0
80107993:	68 d1 00 00 00       	push   $0xd1
80107998:	e9 99 f0 ff ff       	jmp    80106a36 <alltraps>

8010799d <vector210>:
8010799d:	6a 00                	push   $0x0
8010799f:	68 d2 00 00 00       	push   $0xd2
801079a4:	e9 8d f0 ff ff       	jmp    80106a36 <alltraps>

801079a9 <vector211>:
801079a9:	6a 00                	push   $0x0
801079ab:	68 d3 00 00 00       	push   $0xd3
801079b0:	e9 81 f0 ff ff       	jmp    80106a36 <alltraps>

801079b5 <vector212>:
801079b5:	6a 00                	push   $0x0
801079b7:	68 d4 00 00 00       	push   $0xd4
801079bc:	e9 75 f0 ff ff       	jmp    80106a36 <alltraps>

801079c1 <vector213>:
801079c1:	6a 00                	push   $0x0
801079c3:	68 d5 00 00 00       	push   $0xd5
801079c8:	e9 69 f0 ff ff       	jmp    80106a36 <alltraps>

801079cd <vector214>:
801079cd:	6a 00                	push   $0x0
801079cf:	68 d6 00 00 00       	push   $0xd6
801079d4:	e9 5d f0 ff ff       	jmp    80106a36 <alltraps>

801079d9 <vector215>:
801079d9:	6a 00                	push   $0x0
801079db:	68 d7 00 00 00       	push   $0xd7
801079e0:	e9 51 f0 ff ff       	jmp    80106a36 <alltraps>

801079e5 <vector216>:
801079e5:	6a 00                	push   $0x0
801079e7:	68 d8 00 00 00       	push   $0xd8
801079ec:	e9 45 f0 ff ff       	jmp    80106a36 <alltraps>

801079f1 <vector217>:
801079f1:	6a 00                	push   $0x0
801079f3:	68 d9 00 00 00       	push   $0xd9
801079f8:	e9 39 f0 ff ff       	jmp    80106a36 <alltraps>

801079fd <vector218>:
801079fd:	6a 00                	push   $0x0
801079ff:	68 da 00 00 00       	push   $0xda
80107a04:	e9 2d f0 ff ff       	jmp    80106a36 <alltraps>

80107a09 <vector219>:
80107a09:	6a 00                	push   $0x0
80107a0b:	68 db 00 00 00       	push   $0xdb
80107a10:	e9 21 f0 ff ff       	jmp    80106a36 <alltraps>

80107a15 <vector220>:
80107a15:	6a 00                	push   $0x0
80107a17:	68 dc 00 00 00       	push   $0xdc
80107a1c:	e9 15 f0 ff ff       	jmp    80106a36 <alltraps>

80107a21 <vector221>:
80107a21:	6a 00                	push   $0x0
80107a23:	68 dd 00 00 00       	push   $0xdd
80107a28:	e9 09 f0 ff ff       	jmp    80106a36 <alltraps>

80107a2d <vector222>:
80107a2d:	6a 00                	push   $0x0
80107a2f:	68 de 00 00 00       	push   $0xde
80107a34:	e9 fd ef ff ff       	jmp    80106a36 <alltraps>

80107a39 <vector223>:
80107a39:	6a 00                	push   $0x0
80107a3b:	68 df 00 00 00       	push   $0xdf
80107a40:	e9 f1 ef ff ff       	jmp    80106a36 <alltraps>

80107a45 <vector224>:
80107a45:	6a 00                	push   $0x0
80107a47:	68 e0 00 00 00       	push   $0xe0
80107a4c:	e9 e5 ef ff ff       	jmp    80106a36 <alltraps>

80107a51 <vector225>:
80107a51:	6a 00                	push   $0x0
80107a53:	68 e1 00 00 00       	push   $0xe1
80107a58:	e9 d9 ef ff ff       	jmp    80106a36 <alltraps>

80107a5d <vector226>:
80107a5d:	6a 00                	push   $0x0
80107a5f:	68 e2 00 00 00       	push   $0xe2
80107a64:	e9 cd ef ff ff       	jmp    80106a36 <alltraps>

80107a69 <vector227>:
80107a69:	6a 00                	push   $0x0
80107a6b:	68 e3 00 00 00       	push   $0xe3
80107a70:	e9 c1 ef ff ff       	jmp    80106a36 <alltraps>

80107a75 <vector228>:
80107a75:	6a 00                	push   $0x0
80107a77:	68 e4 00 00 00       	push   $0xe4
80107a7c:	e9 b5 ef ff ff       	jmp    80106a36 <alltraps>

80107a81 <vector229>:
80107a81:	6a 00                	push   $0x0
80107a83:	68 e5 00 00 00       	push   $0xe5
80107a88:	e9 a9 ef ff ff       	jmp    80106a36 <alltraps>

80107a8d <vector230>:
80107a8d:	6a 00                	push   $0x0
80107a8f:	68 e6 00 00 00       	push   $0xe6
80107a94:	e9 9d ef ff ff       	jmp    80106a36 <alltraps>

80107a99 <vector231>:
80107a99:	6a 00                	push   $0x0
80107a9b:	68 e7 00 00 00       	push   $0xe7
80107aa0:	e9 91 ef ff ff       	jmp    80106a36 <alltraps>

80107aa5 <vector232>:
80107aa5:	6a 00                	push   $0x0
80107aa7:	68 e8 00 00 00       	push   $0xe8
80107aac:	e9 85 ef ff ff       	jmp    80106a36 <alltraps>

80107ab1 <vector233>:
80107ab1:	6a 00                	push   $0x0
80107ab3:	68 e9 00 00 00       	push   $0xe9
80107ab8:	e9 79 ef ff ff       	jmp    80106a36 <alltraps>

80107abd <vector234>:
80107abd:	6a 00                	push   $0x0
80107abf:	68 ea 00 00 00       	push   $0xea
80107ac4:	e9 6d ef ff ff       	jmp    80106a36 <alltraps>

80107ac9 <vector235>:
80107ac9:	6a 00                	push   $0x0
80107acb:	68 eb 00 00 00       	push   $0xeb
80107ad0:	e9 61 ef ff ff       	jmp    80106a36 <alltraps>

80107ad5 <vector236>:
80107ad5:	6a 00                	push   $0x0
80107ad7:	68 ec 00 00 00       	push   $0xec
80107adc:	e9 55 ef ff ff       	jmp    80106a36 <alltraps>

80107ae1 <vector237>:
80107ae1:	6a 00                	push   $0x0
80107ae3:	68 ed 00 00 00       	push   $0xed
80107ae8:	e9 49 ef ff ff       	jmp    80106a36 <alltraps>

80107aed <vector238>:
80107aed:	6a 00                	push   $0x0
80107aef:	68 ee 00 00 00       	push   $0xee
80107af4:	e9 3d ef ff ff       	jmp    80106a36 <alltraps>

80107af9 <vector239>:
80107af9:	6a 00                	push   $0x0
80107afb:	68 ef 00 00 00       	push   $0xef
80107b00:	e9 31 ef ff ff       	jmp    80106a36 <alltraps>

80107b05 <vector240>:
80107b05:	6a 00                	push   $0x0
80107b07:	68 f0 00 00 00       	push   $0xf0
80107b0c:	e9 25 ef ff ff       	jmp    80106a36 <alltraps>

80107b11 <vector241>:
80107b11:	6a 00                	push   $0x0
80107b13:	68 f1 00 00 00       	push   $0xf1
80107b18:	e9 19 ef ff ff       	jmp    80106a36 <alltraps>

80107b1d <vector242>:
80107b1d:	6a 00                	push   $0x0
80107b1f:	68 f2 00 00 00       	push   $0xf2
80107b24:	e9 0d ef ff ff       	jmp    80106a36 <alltraps>

80107b29 <vector243>:
80107b29:	6a 00                	push   $0x0
80107b2b:	68 f3 00 00 00       	push   $0xf3
80107b30:	e9 01 ef ff ff       	jmp    80106a36 <alltraps>

80107b35 <vector244>:
80107b35:	6a 00                	push   $0x0
80107b37:	68 f4 00 00 00       	push   $0xf4
80107b3c:	e9 f5 ee ff ff       	jmp    80106a36 <alltraps>

80107b41 <vector245>:
80107b41:	6a 00                	push   $0x0
80107b43:	68 f5 00 00 00       	push   $0xf5
80107b48:	e9 e9 ee ff ff       	jmp    80106a36 <alltraps>

80107b4d <vector246>:
80107b4d:	6a 00                	push   $0x0
80107b4f:	68 f6 00 00 00       	push   $0xf6
80107b54:	e9 dd ee ff ff       	jmp    80106a36 <alltraps>

80107b59 <vector247>:
80107b59:	6a 00                	push   $0x0
80107b5b:	68 f7 00 00 00       	push   $0xf7
80107b60:	e9 d1 ee ff ff       	jmp    80106a36 <alltraps>

80107b65 <vector248>:
80107b65:	6a 00                	push   $0x0
80107b67:	68 f8 00 00 00       	push   $0xf8
80107b6c:	e9 c5 ee ff ff       	jmp    80106a36 <alltraps>

80107b71 <vector249>:
80107b71:	6a 00                	push   $0x0
80107b73:	68 f9 00 00 00       	push   $0xf9
80107b78:	e9 b9 ee ff ff       	jmp    80106a36 <alltraps>

80107b7d <vector250>:
80107b7d:	6a 00                	push   $0x0
80107b7f:	68 fa 00 00 00       	push   $0xfa
80107b84:	e9 ad ee ff ff       	jmp    80106a36 <alltraps>

80107b89 <vector251>:
80107b89:	6a 00                	push   $0x0
80107b8b:	68 fb 00 00 00       	push   $0xfb
80107b90:	e9 a1 ee ff ff       	jmp    80106a36 <alltraps>

80107b95 <vector252>:
80107b95:	6a 00                	push   $0x0
80107b97:	68 fc 00 00 00       	push   $0xfc
80107b9c:	e9 95 ee ff ff       	jmp    80106a36 <alltraps>

80107ba1 <vector253>:
80107ba1:	6a 00                	push   $0x0
80107ba3:	68 fd 00 00 00       	push   $0xfd
80107ba8:	e9 89 ee ff ff       	jmp    80106a36 <alltraps>

80107bad <vector254>:
80107bad:	6a 00                	push   $0x0
80107baf:	68 fe 00 00 00       	push   $0xfe
80107bb4:	e9 7d ee ff ff       	jmp    80106a36 <alltraps>

80107bb9 <vector255>:
80107bb9:	6a 00                	push   $0x0
80107bbb:	68 ff 00 00 00       	push   $0xff
80107bc0:	e9 71 ee ff ff       	jmp    80106a36 <alltraps>

80107bc5 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107bc5:	55                   	push   %ebp
80107bc6:	89 e5                	mov    %esp,%ebp
80107bc8:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bce:	83 e8 01             	sub    $0x1,%eax
80107bd1:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80107bd8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107bdc:	8b 45 08             	mov    0x8(%ebp),%eax
80107bdf:	c1 e8 10             	shr    $0x10,%eax
80107be2:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107be6:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107be9:	0f 01 10             	lgdtl  (%eax)
}
80107bec:	90                   	nop
80107bed:	c9                   	leave  
80107bee:	c3                   	ret    

80107bef <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107bef:	55                   	push   %ebp
80107bf0:	89 e5                	mov    %esp,%ebp
80107bf2:	83 ec 04             	sub    $0x4,%esp
80107bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80107bf8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107bfc:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107c00:	0f 00 d8             	ltr    %ax
}
80107c03:	90                   	nop
80107c04:	c9                   	leave  
80107c05:	c3                   	ret    

80107c06 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107c06:	55                   	push   %ebp
80107c07:	89 e5                	mov    %esp,%ebp
80107c09:	83 ec 04             	sub    $0x4,%esp
80107c0c:	8b 45 08             	mov    0x8(%ebp),%eax
80107c0f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107c13:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107c17:	8e e8                	mov    %eax,%gs
}
80107c19:	90                   	nop
80107c1a:	c9                   	leave  
80107c1b:	c3                   	ret    

80107c1c <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107c1c:	55                   	push   %ebp
80107c1d:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c1f:	8b 45 08             	mov    0x8(%ebp),%eax
80107c22:	0f 22 d8             	mov    %eax,%cr3
}
80107c25:	90                   	nop
80107c26:	5d                   	pop    %ebp
80107c27:	c3                   	ret    

80107c28 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107c28:	55                   	push   %ebp
80107c29:	89 e5                	mov    %esp,%ebp
80107c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c2e:	05 00 00 00 80       	add    $0x80000000,%eax
80107c33:	5d                   	pop    %ebp
80107c34:	c3                   	ret    

80107c35 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107c35:	55                   	push   %ebp
80107c36:	89 e5                	mov    %esp,%ebp
80107c38:	8b 45 08             	mov    0x8(%ebp),%eax
80107c3b:	05 00 00 00 80       	add    $0x80000000,%eax
80107c40:	5d                   	pop    %ebp
80107c41:	c3                   	ret    

80107c42 <init_pte_lookup_lock>:
struct {
  char pte_array [NPDENTRIES*NPTENTRIES];
  struct spinlock lock;
} pte_lookup_table;

void init_pte_lookup_lock(void) {
80107c42:	55                   	push   %ebp
80107c43:	89 e5                	mov    %esp,%ebp
80107c45:	83 ec 08             	sub    $0x8,%esp
  initlock(&pte_lookup_table.lock,"pte_lookup");
80107c48:	83 ec 08             	sub    $0x8,%esp
80107c4b:	68 4c 93 10 80       	push   $0x8010934c
80107c50:	68 20 65 21 80       	push   $0x80216520
80107c55:	e8 30 d6 ff ff       	call   8010528a <initlock>
80107c5a:	83 c4 10             	add    $0x10,%esp
}
80107c5d:	90                   	nop
80107c5e:	c9                   	leave  
80107c5f:	c3                   	ret    

80107c60 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107c60:	55                   	push   %ebp
80107c61:	89 e5                	mov    %esp,%ebp
80107c63:	53                   	push   %ebx
80107c64:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107c67:	e8 bf b2 ff ff       	call   80102f2b <cpunum>
80107c6c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107c72:	05 80 33 11 80       	add    $0x80113380,%eax
80107c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7d:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c86:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8f:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c96:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c9a:	83 e2 f0             	and    $0xfffffff0,%edx
80107c9d:	83 ca 0a             	or     $0xa,%edx
80107ca0:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca6:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107caa:	83 ca 10             	or     $0x10,%edx
80107cad:	88 50 7d             	mov    %dl,0x7d(%eax)
80107cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb3:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107cb7:	83 e2 9f             	and    $0xffffff9f,%edx
80107cba:	88 50 7d             	mov    %dl,0x7d(%eax)
80107cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc0:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107cc4:	83 ca 80             	or     $0xffffff80,%edx
80107cc7:	88 50 7d             	mov    %dl,0x7d(%eax)
80107cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccd:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cd1:	83 ca 0f             	or     $0xf,%edx
80107cd4:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cda:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cde:	83 e2 ef             	and    $0xffffffef,%edx
80107ce1:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce7:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ceb:	83 e2 df             	and    $0xffffffdf,%edx
80107cee:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf4:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cf8:	83 ca 40             	or     $0x40,%edx
80107cfb:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d01:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d05:	83 ca 80             	or     $0xffffff80,%edx
80107d08:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0e:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d15:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107d1c:	ff ff 
80107d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d21:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107d28:	00 00 
80107d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2d:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d37:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d3e:	83 e2 f0             	and    $0xfffffff0,%edx
80107d41:	83 ca 02             	or     $0x2,%edx
80107d44:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d54:	83 ca 10             	or     $0x10,%edx
80107d57:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d60:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d67:	83 e2 9f             	and    $0xffffff9f,%edx
80107d6a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d73:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d7a:	83 ca 80             	or     $0xffffff80,%edx
80107d7d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d86:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d8d:	83 ca 0f             	or     $0xf,%edx
80107d90:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d99:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107da0:	83 e2 ef             	and    $0xffffffef,%edx
80107da3:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dac:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107db3:	83 e2 df             	and    $0xffffffdf,%edx
80107db6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dbf:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107dc6:	83 ca 40             	or     $0x40,%edx
80107dc9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd2:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107dd9:	83 ca 80             	or     $0xffffff80,%edx
80107ddc:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de5:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107def:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107df6:	ff ff 
80107df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfb:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107e02:	00 00 
80107e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e07:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e11:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e18:	83 e2 f0             	and    $0xfffffff0,%edx
80107e1b:	83 ca 0a             	or     $0xa,%edx
80107e1e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e27:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e2e:	83 ca 10             	or     $0x10,%edx
80107e31:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e3a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e41:	83 ca 60             	or     $0x60,%edx
80107e44:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e54:	83 ca 80             	or     $0xffffff80,%edx
80107e57:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e60:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e67:	83 ca 0f             	or     $0xf,%edx
80107e6a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e73:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e7a:	83 e2 ef             	and    $0xffffffef,%edx
80107e7d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e86:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e8d:	83 e2 df             	and    $0xffffffdf,%edx
80107e90:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e99:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ea0:	83 ca 40             	or     $0x40,%edx
80107ea3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eac:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107eb3:	83 ca 80             	or     $0xffffff80,%edx
80107eb6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebf:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec9:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107ed0:	ff ff 
80107ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed5:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107edc:	00 00 
80107ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee1:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eeb:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ef2:	83 e2 f0             	and    $0xfffffff0,%edx
80107ef5:	83 ca 02             	or     $0x2,%edx
80107ef8:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f01:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f08:	83 ca 10             	or     $0x10,%edx
80107f0b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f14:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f1b:	83 ca 60             	or     $0x60,%edx
80107f1e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f27:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f2e:	83 ca 80             	or     $0xffffff80,%edx
80107f31:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f41:	83 ca 0f             	or     $0xf,%edx
80107f44:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f54:	83 e2 ef             	and    $0xffffffef,%edx
80107f57:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f60:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f67:	83 e2 df             	and    $0xffffffdf,%edx
80107f6a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f73:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f7a:	83 ca 40             	or     $0x40,%edx
80107f7d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f86:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f8d:	83 ca 80             	or     $0xffffff80,%edx
80107f90:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f99:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa3:	05 b4 00 00 00       	add    $0xb4,%eax
80107fa8:	89 c3                	mov    %eax,%ebx
80107faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fad:	05 b4 00 00 00       	add    $0xb4,%eax
80107fb2:	c1 e8 10             	shr    $0x10,%eax
80107fb5:	89 c2                	mov    %eax,%edx
80107fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fba:	05 b4 00 00 00       	add    $0xb4,%eax
80107fbf:	c1 e8 18             	shr    $0x18,%eax
80107fc2:	89 c1                	mov    %eax,%ecx
80107fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc7:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107fce:	00 00 
80107fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd3:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdd:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe6:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107fed:	83 e2 f0             	and    $0xfffffff0,%edx
80107ff0:	83 ca 02             	or     $0x2,%edx
80107ff3:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffc:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108003:	83 ca 10             	or     $0x10,%edx
80108006:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010800c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108016:	83 e2 9f             	and    $0xffffff9f,%edx
80108019:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010801f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108022:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108029:	83 ca 80             	or     $0xffffff80,%edx
8010802c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108032:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108035:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010803c:	83 e2 f0             	and    $0xfffffff0,%edx
8010803f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108048:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010804f:	83 e2 ef             	and    $0xffffffef,%edx
80108052:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108058:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108062:	83 e2 df             	and    $0xffffffdf,%edx
80108065:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010806b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108075:	83 ca 40             	or     $0x40,%edx
80108078:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010807e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108081:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108088:	83 ca 80             	or     $0xffffff80,%edx
8010808b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108091:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108094:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010809a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809d:	83 c0 70             	add    $0x70,%eax
801080a0:	83 ec 08             	sub    $0x8,%esp
801080a3:	6a 38                	push   $0x38
801080a5:	50                   	push   %eax
801080a6:	e8 1a fb ff ff       	call   80107bc5 <lgdt>
801080ab:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
801080ae:	83 ec 0c             	sub    $0xc,%esp
801080b1:	6a 18                	push   $0x18
801080b3:	e8 4e fb ff ff       	call   80107c06 <loadgs>
801080b8:	83 c4 10             	add    $0x10,%esp

  // Initialize cpu-local storage.
  cpu = c;
801080bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080be:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801080c4:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801080cb:	00 00 00 00 
}
801080cf:	90                   	nop
801080d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801080d3:	c9                   	leave  
801080d4:	c3                   	ret    

801080d5 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801080d5:	55                   	push   %ebp
801080d6:	89 e5                	mov    %esp,%ebp
801080d8:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801080db:	8b 45 0c             	mov    0xc(%ebp),%eax
801080de:	c1 e8 16             	shr    $0x16,%eax
801080e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801080e8:	8b 45 08             	mov    0x8(%ebp),%eax
801080eb:	01 d0                	add    %edx,%eax
801080ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801080f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080f3:	8b 00                	mov    (%eax),%eax
801080f5:	83 e0 01             	and    $0x1,%eax
801080f8:	85 c0                	test   %eax,%eax
801080fa:	74 18                	je     80108114 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801080fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080ff:	8b 00                	mov    (%eax),%eax
80108101:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108106:	50                   	push   %eax
80108107:	e8 29 fb ff ff       	call   80107c35 <p2v>
8010810c:	83 c4 04             	add    $0x4,%esp
8010810f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108112:	eb 48                	jmp    8010815c <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108114:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108118:	74 0e                	je     80108128 <walkpgdir+0x53>
8010811a:	e8 a6 aa ff ff       	call   80102bc5 <kalloc>
8010811f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108122:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108126:	75 07                	jne    8010812f <walkpgdir+0x5a>
      return 0;
80108128:	b8 00 00 00 00       	mov    $0x0,%eax
8010812d:	eb 44                	jmp    80108173 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010812f:	83 ec 04             	sub    $0x4,%esp
80108132:	68 00 10 00 00       	push   $0x1000
80108137:	6a 00                	push   $0x0
80108139:	ff 75 f4             	pushl  -0xc(%ebp)
8010813c:	e8 ce d3 ff ff       	call   8010550f <memset>
80108141:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U
80108144:	83 ec 0c             	sub    $0xc,%esp
80108147:	ff 75 f4             	pushl  -0xc(%ebp)
8010814a:	e8 d9 fa ff ff       	call   80107c28 <v2p>
8010814f:	83 c4 10             	add    $0x10,%esp
80108152:	83 c8 07             	or     $0x7,%eax
80108155:	89 c2                	mov    %eax,%edx
80108157:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010815a:	89 10                	mov    %edx,(%eax)
;  }
  return &pgtab[PTX(va)];
8010815c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010815f:	c1 e8 0c             	shr    $0xc,%eax
80108162:	25 ff 03 00 00       	and    $0x3ff,%eax
80108167:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010816e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108171:	01 d0                	add    %edx,%eax
}
80108173:	c9                   	leave  
80108174:	c3                   	ret    

80108175 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108175:	55                   	push   %ebp
80108176:	89 e5                	mov    %esp,%ebp
80108178:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010817b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010817e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108186:	8b 55 0c             	mov    0xc(%ebp),%edx
80108189:	8b 45 10             	mov    0x10(%ebp),%eax
8010818c:	01 d0                	add    %edx,%eax
8010818e:	83 e8 01             	sub    $0x1,%eax
80108191:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108196:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108199:	83 ec 04             	sub    $0x4,%esp
8010819c:	6a 01                	push   $0x1
8010819e:	ff 75 f4             	pushl  -0xc(%ebp)
801081a1:	ff 75 08             	pushl  0x8(%ebp)
801081a4:	e8 2c ff ff ff       	call   801080d5 <walkpgdir>
801081a9:	83 c4 10             	add    $0x10,%esp
801081ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
801081af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801081b3:	75 07                	jne    801081bc <mappages+0x47>
      return -1;
801081b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081ba:	eb 47                	jmp    80108203 <mappages+0x8e>
    if(*pte & PTE_P)
801081bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081bf:	8b 00                	mov    (%eax),%eax
801081c1:	83 e0 01             	and    $0x1,%eax
801081c4:	85 c0                	test   %eax,%eax
801081c6:	74 0d                	je     801081d5 <mappages+0x60>
      panic("remap");
801081c8:	83 ec 0c             	sub    $0xc,%esp
801081cb:	68 57 93 10 80       	push   $0x80109357
801081d0:	e8 91 83 ff ff       	call   80100566 <panic>
  //  page_references[PTE_ADDR(*pte)] = 1; //give pte_t a reference of one since fork copy just stopped there
    *pte = pa | perm | PTE_P;
801081d5:	8b 45 18             	mov    0x18(%ebp),%eax
801081d8:	0b 45 14             	or     0x14(%ebp),%eax
801081db:	83 c8 01             	or     $0x1,%eax
801081de:	89 c2                	mov    %eax,%edx
801081e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081e3:	89 10                	mov    %edx,(%eax)
    if(a == last)
801081e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801081eb:	74 10                	je     801081fd <mappages+0x88>
      break;
    a += PGSIZE;
801081ed:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801081f4:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801081fb:	eb 9c                	jmp    80108199 <mappages+0x24>
    if(*pte & PTE_P)
      panic("remap");
  //  page_references[PTE_ADDR(*pte)] = 1; //give pte_t a reference of one since fork copy just stopped there
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801081fd:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801081fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108203:	c9                   	leave  
80108204:	c3                   	ret    

80108205 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108205:	55                   	push   %ebp
80108206:	89 e5                	mov    %esp,%ebp
80108208:	53                   	push   %ebx
80108209:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010820c:	e8 b4 a9 ff ff       	call   80102bc5 <kalloc>
80108211:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108214:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108218:	75 0a                	jne    80108224 <setupkvm+0x1f>
    return 0;
8010821a:	b8 00 00 00 00       	mov    $0x0,%eax
8010821f:	e9 8e 00 00 00       	jmp    801082b2 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108224:	83 ec 04             	sub    $0x4,%esp
80108227:	68 00 10 00 00       	push   $0x1000
8010822c:	6a 00                	push   $0x0
8010822e:	ff 75 f0             	pushl  -0x10(%ebp)
80108231:	e8 d9 d2 ff ff       	call   8010550f <memset>
80108236:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108239:	83 ec 0c             	sub    $0xc,%esp
8010823c:	68 00 00 00 0e       	push   $0xe000000
80108241:	e8 ef f9 ff ff       	call   80107c35 <p2v>
80108246:	83 c4 10             	add    $0x10,%esp
80108249:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010824e:	76 0d                	jbe    8010825d <setupkvm+0x58>
    panic("PHYSTOP too high");
80108250:	83 ec 0c             	sub    $0xc,%esp
80108253:	68 5d 93 10 80       	push   $0x8010935d
80108258:	e8 09 83 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010825d:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108264:	eb 40                	jmp    801082a6 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108266:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108269:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
8010826c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826f:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108272:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108275:	8b 58 08             	mov    0x8(%eax),%ebx
80108278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827b:	8b 40 04             	mov    0x4(%eax),%eax
8010827e:	29 c3                	sub    %eax,%ebx
80108280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108283:	8b 00                	mov    (%eax),%eax
80108285:	83 ec 0c             	sub    $0xc,%esp
80108288:	51                   	push   %ecx
80108289:	52                   	push   %edx
8010828a:	53                   	push   %ebx
8010828b:	50                   	push   %eax
8010828c:	ff 75 f0             	pushl  -0x10(%ebp)
8010828f:	e8 e1 fe ff ff       	call   80108175 <mappages>
80108294:	83 c4 20             	add    $0x20,%esp
80108297:	85 c0                	test   %eax,%eax
80108299:	79 07                	jns    801082a2 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010829b:	b8 00 00 00 00       	mov    $0x0,%eax
801082a0:	eb 10                	jmp    801082b2 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801082a2:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801082a6:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
801082ad:	72 b7                	jb     80108266 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801082af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801082b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082b5:	c9                   	leave  
801082b6:	c3                   	ret    

801082b7 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801082b7:	55                   	push   %ebp
801082b8:	89 e5                	mov    %esp,%ebp
801082ba:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801082bd:	e8 43 ff ff ff       	call   80108205 <setupkvm>
801082c2:	a3 98 65 21 80       	mov    %eax,0x80216598
  switchkvm();
801082c7:	e8 03 00 00 00       	call   801082cf <switchkvm>
}
801082cc:	90                   	nop
801082cd:	c9                   	leave  
801082ce:	c3                   	ret    

801082cf <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801082cf:	55                   	push   %ebp
801082d0:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801082d2:	a1 98 65 21 80       	mov    0x80216598,%eax
801082d7:	50                   	push   %eax
801082d8:	e8 4b f9 ff ff       	call   80107c28 <v2p>
801082dd:	83 c4 04             	add    $0x4,%esp
801082e0:	50                   	push   %eax
801082e1:	e8 36 f9 ff ff       	call   80107c1c <lcr3>
801082e6:	83 c4 04             	add    $0x4,%esp
}
801082e9:	90                   	nop
801082ea:	c9                   	leave  
801082eb:	c3                   	ret    

801082ec <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801082ec:	55                   	push   %ebp
801082ed:	89 e5                	mov    %esp,%ebp
801082ef:	56                   	push   %esi
801082f0:	53                   	push   %ebx
  pushcli();
801082f1:	e8 13 d1 ff ff       	call   80105409 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801082f6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801082fc:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108303:	83 c2 08             	add    $0x8,%edx
80108306:	89 d6                	mov    %edx,%esi
80108308:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010830f:	83 c2 08             	add    $0x8,%edx
80108312:	c1 ea 10             	shr    $0x10,%edx
80108315:	89 d3                	mov    %edx,%ebx
80108317:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010831e:	83 c2 08             	add    $0x8,%edx
80108321:	c1 ea 18             	shr    $0x18,%edx
80108324:	89 d1                	mov    %edx,%ecx
80108326:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010832d:	67 00 
8010832f:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108336:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
8010833c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108343:	83 e2 f0             	and    $0xfffffff0,%edx
80108346:	83 ca 09             	or     $0x9,%edx
80108349:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010834f:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108356:	83 ca 10             	or     $0x10,%edx
80108359:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010835f:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108366:	83 e2 9f             	and    $0xffffff9f,%edx
80108369:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010836f:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108376:	83 ca 80             	or     $0xffffff80,%edx
80108379:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010837f:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108386:	83 e2 f0             	and    $0xfffffff0,%edx
80108389:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010838f:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108396:	83 e2 ef             	and    $0xffffffef,%edx
80108399:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010839f:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801083a6:	83 e2 df             	and    $0xffffffdf,%edx
801083a9:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801083af:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801083b6:	83 ca 40             	or     $0x40,%edx
801083b9:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801083bf:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801083c6:	83 e2 7f             	and    $0x7f,%edx
801083c9:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801083cf:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801083d5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083db:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083e2:	83 e2 ef             	and    $0xffffffef,%edx
801083e5:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801083eb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083f1:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801083f7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083fd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108404:	8b 52 08             	mov    0x8(%edx),%edx
80108407:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010840d:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108410:	83 ec 0c             	sub    $0xc,%esp
80108413:	6a 30                	push   $0x30
80108415:	e8 d5 f7 ff ff       	call   80107bef <ltr>
8010841a:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
8010841d:	8b 45 08             	mov    0x8(%ebp),%eax
80108420:	8b 40 04             	mov    0x4(%eax),%eax
80108423:	85 c0                	test   %eax,%eax
80108425:	75 0d                	jne    80108434 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108427:	83 ec 0c             	sub    $0xc,%esp
8010842a:	68 6e 93 10 80       	push   $0x8010936e
8010842f:	e8 32 81 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108434:	8b 45 08             	mov    0x8(%ebp),%eax
80108437:	8b 40 04             	mov    0x4(%eax),%eax
8010843a:	83 ec 0c             	sub    $0xc,%esp
8010843d:	50                   	push   %eax
8010843e:	e8 e5 f7 ff ff       	call   80107c28 <v2p>
80108443:	83 c4 10             	add    $0x10,%esp
80108446:	83 ec 0c             	sub    $0xc,%esp
80108449:	50                   	push   %eax
8010844a:	e8 cd f7 ff ff       	call   80107c1c <lcr3>
8010844f:	83 c4 10             	add    $0x10,%esp
  popcli();
80108452:	e8 f7 cf ff ff       	call   8010544e <popcli>
}
80108457:	90                   	nop
80108458:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010845b:	5b                   	pop    %ebx
8010845c:	5e                   	pop    %esi
8010845d:	5d                   	pop    %ebp
8010845e:	c3                   	ret    

8010845f <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010845f:	55                   	push   %ebp
80108460:	89 e5                	mov    %esp,%ebp
80108462:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80108465:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010846c:	76 0d                	jbe    8010847b <inituvm+0x1c>
    panic("inituvm: more than a page");
8010846e:	83 ec 0c             	sub    $0xc,%esp
80108471:	68 82 93 10 80       	push   $0x80109382
80108476:	e8 eb 80 ff ff       	call   80100566 <panic>
  mem = kalloc();
8010847b:	e8 45 a7 ff ff       	call   80102bc5 <kalloc>
80108480:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108483:	83 ec 04             	sub    $0x4,%esp
80108486:	68 00 10 00 00       	push   $0x1000
8010848b:	6a 00                	push   $0x0
8010848d:	ff 75 f4             	pushl  -0xc(%ebp)
80108490:	e8 7a d0 ff ff       	call   8010550f <memset>
80108495:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108498:	83 ec 0c             	sub    $0xc,%esp
8010849b:	ff 75 f4             	pushl  -0xc(%ebp)
8010849e:	e8 85 f7 ff ff       	call   80107c28 <v2p>
801084a3:	83 c4 10             	add    $0x10,%esp
801084a6:	83 ec 0c             	sub    $0xc,%esp
801084a9:	6a 06                	push   $0x6
801084ab:	50                   	push   %eax
801084ac:	68 00 10 00 00       	push   $0x1000
801084b1:	6a 00                	push   $0x0
801084b3:	ff 75 08             	pushl  0x8(%ebp)
801084b6:	e8 ba fc ff ff       	call   80108175 <mappages>
801084bb:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801084be:	83 ec 04             	sub    $0x4,%esp
801084c1:	ff 75 10             	pushl  0x10(%ebp)
801084c4:	ff 75 0c             	pushl  0xc(%ebp)
801084c7:	ff 75 f4             	pushl  -0xc(%ebp)
801084ca:	e8 ff d0 ff ff       	call   801055ce <memmove>
801084cf:	83 c4 10             	add    $0x10,%esp
}
801084d2:	90                   	nop
801084d3:	c9                   	leave  
801084d4:	c3                   	ret    

801084d5 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801084d5:	55                   	push   %ebp
801084d6:	89 e5                	mov    %esp,%ebp
801084d8:	53                   	push   %ebx
801084d9:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801084dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801084df:	25 ff 0f 00 00       	and    $0xfff,%eax
801084e4:	85 c0                	test   %eax,%eax
801084e6:	74 0d                	je     801084f5 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801084e8:	83 ec 0c             	sub    $0xc,%esp
801084eb:	68 9c 93 10 80       	push   $0x8010939c
801084f0:	e8 71 80 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801084f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801084fc:	e9 95 00 00 00       	jmp    80108596 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108501:	8b 55 0c             	mov    0xc(%ebp),%edx
80108504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108507:	01 d0                	add    %edx,%eax
80108509:	83 ec 04             	sub    $0x4,%esp
8010850c:	6a 00                	push   $0x0
8010850e:	50                   	push   %eax
8010850f:	ff 75 08             	pushl  0x8(%ebp)
80108512:	e8 be fb ff ff       	call   801080d5 <walkpgdir>
80108517:	83 c4 10             	add    $0x10,%esp
8010851a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010851d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108521:	75 0d                	jne    80108530 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80108523:	83 ec 0c             	sub    $0xc,%esp
80108526:	68 bf 93 10 80       	push   $0x801093bf
8010852b:	e8 36 80 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108530:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108533:	8b 00                	mov    (%eax),%eax
80108535:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010853a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010853d:	8b 45 18             	mov    0x18(%ebp),%eax
80108540:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108543:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108548:	77 0b                	ja     80108555 <loaduvm+0x80>
      n = sz - i;
8010854a:	8b 45 18             	mov    0x18(%ebp),%eax
8010854d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108550:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108553:	eb 07                	jmp    8010855c <loaduvm+0x87>
    else
      n = PGSIZE;
80108555:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010855c:	8b 55 14             	mov    0x14(%ebp),%edx
8010855f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108562:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108565:	83 ec 0c             	sub    $0xc,%esp
80108568:	ff 75 e8             	pushl  -0x18(%ebp)
8010856b:	e8 c5 f6 ff ff       	call   80107c35 <p2v>
80108570:	83 c4 10             	add    $0x10,%esp
80108573:	ff 75 f0             	pushl  -0x10(%ebp)
80108576:	53                   	push   %ebx
80108577:	50                   	push   %eax
80108578:	ff 75 10             	pushl  0x10(%ebp)
8010857b:	e8 f3 98 ff ff       	call   80101e73 <readi>
80108580:	83 c4 10             	add    $0x10,%esp
80108583:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108586:	74 07                	je     8010858f <loaduvm+0xba>
      return -1;
80108588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010858d:	eb 18                	jmp    801085a7 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010858f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108596:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108599:	3b 45 18             	cmp    0x18(%ebp),%eax
8010859c:	0f 82 5f ff ff ff    	jb     80108501 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801085a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801085a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801085aa:	c9                   	leave  
801085ab:	c3                   	ret    

801085ac <mprotect>:

int
mprotect(void *addr, int len, int prot)
{
801085ac:	55                   	push   %ebp
801085ad:	89 e5                	mov    %esp,%ebp
801085af:	83 ec 18             	sub    $0x18,%esp
  pte_t *page_table_entry;
  cprintf("*addr: %d\n",(uint)addr);
801085b2:	8b 45 08             	mov    0x8(%ebp),%eax
801085b5:	83 ec 08             	sub    $0x8,%esp
801085b8:	50                   	push   %eax
801085b9:	68 dd 93 10 80       	push   $0x801093dd
801085be:	e8 03 7e ff ff       	call   801003c6 <cprintf>
801085c3:	83 c4 10             	add    $0x10,%esp
  //might need to PGRDWN the address
  //loop through all the page entries that need protection level changed
  //makes prot cnstants change in types.h
  //break it down, use PTE
  // cprintf("addr: %d\n",(int)addr);
  uint base_addr = PGROUNDDOWN((uint)addr);
801085c6:	8b 45 08             	mov    0x8(%ebp),%eax
801085c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint curr = base_addr;
801085d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  do {

    page_table_entry = walkpgdir(proc->pgdir,(void *)curr ,0);
801085d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801085da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085e0:	8b 40 04             	mov    0x4(%eax),%eax
801085e3:	83 ec 04             	sub    $0x4,%esp
801085e6:	6a 00                	push   $0x0
801085e8:	52                   	push   %edx
801085e9:	50                   	push   %eax
801085ea:	e8 e6 fa ff ff       	call   801080d5 <walkpgdir>
801085ef:	83 c4 10             	add    $0x10,%esp
801085f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    curr += PGSIZE;
801085f5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    //clear last 3 bits
    cprintf("page table entry before: 0x%x desireced prot = %d\n",*page_table_entry,prot);
801085fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085ff:	8b 00                	mov    (%eax),%eax
80108601:	83 ec 04             	sub    $0x4,%esp
80108604:	ff 75 10             	pushl  0x10(%ebp)
80108607:	50                   	push   %eax
80108608:	68 e8 93 10 80       	push   $0x801093e8
8010860d:	e8 b4 7d ff ff       	call   801003c6 <cprintf>
80108612:	83 c4 10             	add    $0x10,%esp
    //clear last 3 bits
    *page_table_entry &= 0xfffffff9;
80108615:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108618:	8b 00                	mov    (%eax),%eax
8010861a:	83 e0 f9             	and    $0xfffffff9,%eax
8010861d:	89 c2                	mov    %eax,%edx
8010861f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108622:	89 10                	mov    %edx,(%eax)
    // cprintf("page table entry after clear: 0x%x\n",*page_table_entry);
    switch(prot) {
80108624:	8b 45 10             	mov    0x10(%ebp),%eax
80108627:	83 f8 01             	cmp    $0x1,%eax
8010862a:	74 28                	je     80108654 <mprotect+0xa8>
8010862c:	83 f8 01             	cmp    $0x1,%eax
8010862f:	7f 06                	jg     80108637 <mprotect+0x8b>
80108631:	85 c0                	test   %eax,%eax
80108633:	74 0e                	je     80108643 <mprotect+0x97>
80108635:	eb 4e                	jmp    80108685 <mprotect+0xd9>
80108637:	83 f8 02             	cmp    $0x2,%eax
8010863a:	74 29                	je     80108665 <mprotect+0xb9>
8010863c:	83 f8 03             	cmp    $0x3,%eax
8010863f:	74 35                	je     80108676 <mprotect+0xca>
80108641:	eb 42                	jmp    80108685 <mprotect+0xd9>
      case PROT_NONE:
        *page_table_entry |= PTE_P;
80108643:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108646:	8b 00                	mov    (%eax),%eax
80108648:	83 c8 01             	or     $0x1,%eax
8010864b:	89 c2                	mov    %eax,%edx
8010864d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108650:	89 10                	mov    %edx,(%eax)
        break;
80108652:	eb 31                	jmp    80108685 <mprotect+0xd9>
      case PROT_READ:
        *page_table_entry |= (PTE_P | PTE_U);
80108654:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108657:	8b 00                	mov    (%eax),%eax
80108659:	83 c8 05             	or     $0x5,%eax
8010865c:	89 c2                	mov    %eax,%edx
8010865e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108661:	89 10                	mov    %edx,(%eax)
        break;
80108663:	eb 20                	jmp    80108685 <mprotect+0xd9>
      case PROT_WRITE:
        *page_table_entry |= (PTE_P | PTE_W);
80108665:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108668:	8b 00                	mov    (%eax),%eax
8010866a:	83 c8 03             	or     $0x3,%eax
8010866d:	89 c2                	mov    %eax,%edx
8010866f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108672:	89 10                	mov    %edx,(%eax)
        break;
80108674:	eb 0f                	jmp    80108685 <mprotect+0xd9>
      case PROT_READ | PROT_WRITE:
        *page_table_entry |= (PTE_P | PTE_W | PTE_U);
80108676:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108679:	8b 00                	mov    (%eax),%eax
8010867b:	83 c8 07             	or     $0x7,%eax
8010867e:	89 c2                	mov    %eax,%edx
80108680:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108683:	89 10                	mov    %edx,(%eax)
    }
    cprintf("page table entry after: 0x%x\n",*page_table_entry);
80108685:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108688:	8b 00                	mov    (%eax),%eax
8010868a:	83 ec 08             	sub    $0x8,%esp
8010868d:	50                   	push   %eax
8010868e:	68 1b 94 10 80       	push   $0x8010941b
80108693:	e8 2e 7d ff ff       	call   801003c6 <cprintf>
80108698:	83 c4 10             	add    $0x10,%esp
  } while(curr < ((uint)addr +len));
8010869b:	8b 55 08             	mov    0x8(%ebp),%edx
8010869e:	8b 45 0c             	mov    0xc(%ebp),%eax
801086a1:	01 d0                	add    %edx,%eax
801086a3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801086a6:	0f 87 2b ff ff ff    	ja     801085d7 <mprotect+0x2b>

  //flush that tlb real good
  lcr3(v2p(proc->pgdir));
801086ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801086b2:	8b 40 04             	mov    0x4(%eax),%eax
801086b5:	83 ec 0c             	sub    $0xc,%esp
801086b8:	50                   	push   %eax
801086b9:	e8 6a f5 ff ff       	call   80107c28 <v2p>
801086be:	83 c4 10             	add    $0x10,%esp
801086c1:	83 ec 0c             	sub    $0xc,%esp
801086c4:	50                   	push   %eax
801086c5:	e8 52 f5 ff ff       	call   80107c1c <lcr3>
801086ca:	83 c4 10             	add    $0x10,%esp
  // cprintf("returning from mprotect\n");
  return 0; ///what happens after returned?
801086cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801086d2:	c9                   	leave  
801086d3:	c3                   	ret    

801086d4 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801086d4:	55                   	push   %ebp
801086d5:	89 e5                	mov    %esp,%ebp
801086d7:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801086da:	8b 45 10             	mov    0x10(%ebp),%eax
801086dd:	85 c0                	test   %eax,%eax
801086df:	79 0a                	jns    801086eb <allocuvm+0x17>
    return 0;
801086e1:	b8 00 00 00 00       	mov    $0x0,%eax
801086e6:	e9 b0 00 00 00       	jmp    8010879b <allocuvm+0xc7>
  if(newsz < oldsz)
801086eb:	8b 45 10             	mov    0x10(%ebp),%eax
801086ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086f1:	73 08                	jae    801086fb <allocuvm+0x27>
    return oldsz;
801086f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801086f6:	e9 a0 00 00 00       	jmp    8010879b <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
801086fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801086fe:	05 ff 0f 00 00       	add    $0xfff,%eax
80108703:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108708:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010870b:	eb 7f                	jmp    8010878c <allocuvm+0xb8>
    mem = kalloc();
8010870d:	e8 b3 a4 ff ff       	call   80102bc5 <kalloc>
80108712:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108715:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108719:	75 2b                	jne    80108746 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
8010871b:	83 ec 0c             	sub    $0xc,%esp
8010871e:	68 39 94 10 80       	push   $0x80109439
80108723:	e8 9e 7c ff ff       	call   801003c6 <cprintf>
80108728:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010872b:	83 ec 04             	sub    $0x4,%esp
8010872e:	ff 75 0c             	pushl  0xc(%ebp)
80108731:	ff 75 10             	pushl  0x10(%ebp)
80108734:	ff 75 08             	pushl  0x8(%ebp)
80108737:	e8 61 00 00 00       	call   8010879d <deallocuvm>
8010873c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010873f:	b8 00 00 00 00       	mov    $0x0,%eax
80108744:	eb 55                	jmp    8010879b <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108746:	83 ec 04             	sub    $0x4,%esp
80108749:	68 00 10 00 00       	push   $0x1000
8010874e:	6a 00                	push   $0x0
80108750:	ff 75 f0             	pushl  -0x10(%ebp)
80108753:	e8 b7 cd ff ff       	call   8010550f <memset>
80108758:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010875b:	83 ec 0c             	sub    $0xc,%esp
8010875e:	ff 75 f0             	pushl  -0x10(%ebp)
80108761:	e8 c2 f4 ff ff       	call   80107c28 <v2p>
80108766:	83 c4 10             	add    $0x10,%esp
80108769:	89 c2                	mov    %eax,%edx
8010876b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010876e:	83 ec 0c             	sub    $0xc,%esp
80108771:	6a 06                	push   $0x6
80108773:	52                   	push   %edx
80108774:	68 00 10 00 00       	push   $0x1000
80108779:	50                   	push   %eax
8010877a:	ff 75 08             	pushl  0x8(%ebp)
8010877d:	e8 f3 f9 ff ff       	call   80108175 <mappages>
80108782:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108785:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010878c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010878f:	3b 45 10             	cmp    0x10(%ebp),%eax
80108792:	0f 82 75 ff ff ff    	jb     8010870d <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108798:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010879b:	c9                   	leave  
8010879c:	c3                   	ret    

8010879d <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010879d:	55                   	push   %ebp
8010879e:	89 e5                	mov    %esp,%ebp
801087a0:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801087a3:	8b 45 10             	mov    0x10(%ebp),%eax
801087a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
801087a9:	72 08                	jb     801087b3 <deallocuvm+0x16>
    return oldsz;
801087ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801087ae:	e9 a5 00 00 00       	jmp    80108858 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801087b3:	8b 45 10             	mov    0x10(%ebp),%eax
801087b6:	05 ff 0f 00 00       	add    $0xfff,%eax
801087bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801087c3:	e9 81 00 00 00       	jmp    80108849 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801087c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087cb:	83 ec 04             	sub    $0x4,%esp
801087ce:	6a 00                	push   $0x0
801087d0:	50                   	push   %eax
801087d1:	ff 75 08             	pushl  0x8(%ebp)
801087d4:	e8 fc f8 ff ff       	call   801080d5 <walkpgdir>
801087d9:	83 c4 10             	add    $0x10,%esp
801087dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801087df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087e3:	75 09                	jne    801087ee <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801087e5:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801087ec:	eb 54                	jmp    80108842 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
801087ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087f1:	8b 00                	mov    (%eax),%eax
801087f3:	83 e0 01             	and    $0x1,%eax
801087f6:	85 c0                	test   %eax,%eax
801087f8:	74 48                	je     80108842 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801087fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087fd:	8b 00                	mov    (%eax),%eax
801087ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108804:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108807:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010880b:	75 0d                	jne    8010881a <deallocuvm+0x7d>
        panic("kfree");
8010880d:	83 ec 0c             	sub    $0xc,%esp
80108810:	68 51 94 10 80       	push   $0x80109451
80108815:	e8 4c 7d ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
8010881a:	83 ec 0c             	sub    $0xc,%esp
8010881d:	ff 75 ec             	pushl  -0x14(%ebp)
80108820:	e8 10 f4 ff ff       	call   80107c35 <p2v>
80108825:	83 c4 10             	add    $0x10,%esp
80108828:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010882b:	83 ec 0c             	sub    $0xc,%esp
8010882e:	ff 75 e8             	pushl  -0x18(%ebp)
80108831:	e8 f2 a2 ff ff       	call   80102b28 <kfree>
80108836:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108839:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010883c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108842:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010884c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010884f:	0f 82 73 ff ff ff    	jb     801087c8 <deallocuvm+0x2b>
      kfree(v);
      *pte = 0;
      //need to update entries in page table here
    }
  }
  return newsz;
80108855:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108858:	c9                   	leave  
80108859:	c3                   	ret    

8010885a <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010885a:	55                   	push   %ebp
8010885b:	89 e5                	mov    %esp,%ebp
8010885d:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108860:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108864:	75 0d                	jne    80108873 <freevm+0x19>
    panic("freevm: no pgdir");
80108866:	83 ec 0c             	sub    $0xc,%esp
80108869:	68 57 94 10 80       	push   $0x80109457
8010886e:	e8 f3 7c ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108873:	83 ec 04             	sub    $0x4,%esp
80108876:	6a 00                	push   $0x0
80108878:	68 00 00 00 80       	push   $0x80000000
8010887d:	ff 75 08             	pushl  0x8(%ebp)
80108880:	e8 18 ff ff ff       	call   8010879d <deallocuvm>
80108885:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108888:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010888f:	eb 4f                	jmp    801088e0 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108891:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108894:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010889b:	8b 45 08             	mov    0x8(%ebp),%eax
8010889e:	01 d0                	add    %edx,%eax
801088a0:	8b 00                	mov    (%eax),%eax
801088a2:	83 e0 01             	and    $0x1,%eax
801088a5:	85 c0                	test   %eax,%eax
801088a7:	74 33                	je     801088dc <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801088a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801088b3:	8b 45 08             	mov    0x8(%ebp),%eax
801088b6:	01 d0                	add    %edx,%eax
801088b8:	8b 00                	mov    (%eax),%eax
801088ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088bf:	83 ec 0c             	sub    $0xc,%esp
801088c2:	50                   	push   %eax
801088c3:	e8 6d f3 ff ff       	call   80107c35 <p2v>
801088c8:	83 c4 10             	add    $0x10,%esp
801088cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801088ce:	83 ec 0c             	sub    $0xc,%esp
801088d1:	ff 75 f0             	pushl  -0x10(%ebp)
801088d4:	e8 4f a2 ff ff       	call   80102b28 <kfree>
801088d9:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801088dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801088e0:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801088e7:	76 a8                	jbe    80108891 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801088e9:	83 ec 0c             	sub    $0xc,%esp
801088ec:	ff 75 08             	pushl  0x8(%ebp)
801088ef:	e8 34 a2 ff ff       	call   80102b28 <kfree>
801088f4:	83 c4 10             	add    $0x10,%esp
}
801088f7:	90                   	nop
801088f8:	c9                   	leave  
801088f9:	c3                   	ret    

801088fa <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801088fa:	55                   	push   %ebp
801088fb:	89 e5                	mov    %esp,%ebp
801088fd:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108900:	83 ec 04             	sub    $0x4,%esp
80108903:	6a 00                	push   $0x0
80108905:	ff 75 0c             	pushl  0xc(%ebp)
80108908:	ff 75 08             	pushl  0x8(%ebp)
8010890b:	e8 c5 f7 ff ff       	call   801080d5 <walkpgdir>
80108910:	83 c4 10             	add    $0x10,%esp
80108913:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010891a:	75 0d                	jne    80108929 <clearpteu+0x2f>
    panic("clearpteu");
8010891c:	83 ec 0c             	sub    $0xc,%esp
8010891f:	68 68 94 10 80       	push   $0x80109468
80108924:	e8 3d 7c ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80108929:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010892c:	8b 00                	mov    (%eax),%eax
8010892e:	83 e0 fb             	and    $0xfffffffb,%eax
80108931:	89 c2                	mov    %eax,%edx
80108933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108936:	89 10                	mov    %edx,(%eax)
}
80108938:	90                   	nop
80108939:	c9                   	leave  
8010893a:	c3                   	ret    

8010893b <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010893b:	55                   	push   %ebp
8010893c:	89 e5                	mov    %esp,%ebp
8010893e:	53                   	push   %ebx
8010893f:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108942:	e8 be f8 ff ff       	call   80108205 <setupkvm>
80108947:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010894a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010894e:	75 0a                	jne    8010895a <copyuvm+0x1f>
    return 0;
80108950:	b8 00 00 00 00       	mov    $0x0,%eax
80108955:	e9 f8 00 00 00       	jmp    80108a52 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
8010895a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108961:	e9 c4 00 00 00       	jmp    80108a2a <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108969:	83 ec 04             	sub    $0x4,%esp
8010896c:	6a 00                	push   $0x0
8010896e:	50                   	push   %eax
8010896f:	ff 75 08             	pushl  0x8(%ebp)
80108972:	e8 5e f7 ff ff       	call   801080d5 <walkpgdir>
80108977:	83 c4 10             	add    $0x10,%esp
8010897a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010897d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108981:	75 0d                	jne    80108990 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108983:	83 ec 0c             	sub    $0xc,%esp
80108986:	68 72 94 10 80       	push   $0x80109472
8010898b:	e8 d6 7b ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108990:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108993:	8b 00                	mov    (%eax),%eax
80108995:	83 e0 01             	and    $0x1,%eax
80108998:	85 c0                	test   %eax,%eax
8010899a:	75 0d                	jne    801089a9 <copyuvm+0x6e>
      panic("copyuvm: page not present");
8010899c:	83 ec 0c             	sub    $0xc,%esp
8010899f:	68 8c 94 10 80       	push   $0x8010948c
801089a4:	e8 bd 7b ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801089a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089ac:	8b 00                	mov    (%eax),%eax
801089ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801089b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089b9:	8b 00                	mov    (%eax),%eax
801089bb:	25 ff 0f 00 00       	and    $0xfff,%eax
801089c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801089c3:	e8 fd a1 ff ff       	call   80102bc5 <kalloc>
801089c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801089cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801089cf:	74 6a                	je     80108a3b <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801089d1:	83 ec 0c             	sub    $0xc,%esp
801089d4:	ff 75 e8             	pushl  -0x18(%ebp)
801089d7:	e8 59 f2 ff ff       	call   80107c35 <p2v>
801089dc:	83 c4 10             	add    $0x10,%esp
801089df:	83 ec 04             	sub    $0x4,%esp
801089e2:	68 00 10 00 00       	push   $0x1000
801089e7:	50                   	push   %eax
801089e8:	ff 75 e0             	pushl  -0x20(%ebp)
801089eb:	e8 de cb ff ff       	call   801055ce <memmove>
801089f0:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801089f3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801089f6:	83 ec 0c             	sub    $0xc,%esp
801089f9:	ff 75 e0             	pushl  -0x20(%ebp)
801089fc:	e8 27 f2 ff ff       	call   80107c28 <v2p>
80108a01:	83 c4 10             	add    $0x10,%esp
80108a04:	89 c2                	mov    %eax,%edx
80108a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a09:	83 ec 0c             	sub    $0xc,%esp
80108a0c:	53                   	push   %ebx
80108a0d:	52                   	push   %edx
80108a0e:	68 00 10 00 00       	push   $0x1000
80108a13:	50                   	push   %eax
80108a14:	ff 75 f0             	pushl  -0x10(%ebp)
80108a17:	e8 59 f7 ff ff       	call   80108175 <mappages>
80108a1c:	83 c4 20             	add    $0x20,%esp
80108a1f:	85 c0                	test   %eax,%eax
80108a21:	78 1b                	js     80108a3e <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108a23:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a2d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a30:	0f 82 30 ff ff ff    	jb     80108966 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a39:	eb 17                	jmp    80108a52 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108a3b:	90                   	nop
80108a3c:	eb 01                	jmp    80108a3f <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108a3e:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108a3f:	83 ec 0c             	sub    $0xc,%esp
80108a42:	ff 75 f0             	pushl  -0x10(%ebp)
80108a45:	e8 10 fe ff ff       	call   8010885a <freevm>
80108a4a:	83 c4 10             	add    $0x10,%esp
  return 0;
80108a4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108a55:	c9                   	leave  
80108a56:	c3                   	ret    

80108a57 <copyuvm_cow>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm_cow(pde_t *pgdir, uint sz)
{
80108a57:	55                   	push   %ebp
80108a58:	89 e5                	mov    %esp,%ebp
80108a5a:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108a5d:	e8 a3 f7 ff ff       	call   80108205 <setupkvm>
80108a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108a65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a69:	75 0a                	jne    80108a75 <copyuvm_cow+0x1e>
    return 0;
80108a6b:	b8 00 00 00 00       	mov    $0x0,%eax
80108a70:	e9 9b 01 00 00       	jmp    80108c10 <copyuvm_cow+0x1b9>
  for(i = 0; i < sz; i += PGSIZE){
80108a75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a7c:	e9 3d 01 00 00       	jmp    80108bbe <copyuvm_cow+0x167>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a84:	83 ec 04             	sub    $0x4,%esp
80108a87:	6a 00                	push   $0x0
80108a89:	50                   	push   %eax
80108a8a:	ff 75 08             	pushl  0x8(%ebp)
80108a8d:	e8 43 f6 ff ff       	call   801080d5 <walkpgdir>
80108a92:	83 c4 10             	add    $0x10,%esp
80108a95:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108a98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a9c:	75 0d                	jne    80108aab <copyuvm_cow+0x54>
      panic("copyuvm: pte should exist");
80108a9e:	83 ec 0c             	sub    $0xc,%esp
80108aa1:	68 72 94 10 80       	push   $0x80109472
80108aa6:	e8 bb 7a ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108aae:	8b 00                	mov    (%eax),%eax
80108ab0:	83 e0 01             	and    $0x1,%eax
80108ab3:	85 c0                	test   %eax,%eax
80108ab5:	75 0d                	jne    80108ac4 <copyuvm_cow+0x6d>
      panic("copyuvm: page not present");
80108ab7:	83 ec 0c             	sub    $0xc,%esp
80108aba:	68 8c 94 10 80       	push   $0x8010948c
80108abf:	e8 a2 7a ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ac7:	8b 00                	mov    (%eax),%eax
80108ac9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ace:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108ad1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ad4:	8b 00                	mov    (%eax),%eax
80108ad6:	25 ff 0f 00 00       	and    $0xfff,%eax
80108adb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108ade:	e8 e2 a0 ff ff       	call   80102bc5 <kalloc>
80108ae3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108ae6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108aea:	0f 84 09 01 00 00    	je     80108bf9 <copyuvm_cow+0x1a2>
      goto bad;
    acquire(&pte_lookup_table.lock);
80108af0:	83 ec 0c             	sub    $0xc,%esp
80108af3:	68 20 65 21 80       	push   $0x80216520
80108af8:	e8 af c7 ff ff       	call   801052ac <acquire>
80108afd:	83 c4 10             	add    $0x10,%esp
      if(pte_lookup_table.pte_array[pa/PGSIZE] == 0) { //page fault
80108b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b03:	c1 e8 0c             	shr    $0xc,%eax
80108b06:	0f b6 80 20 65 11 80 	movzbl -0x7fee9ae0(%eax),%eax
80108b0d:	84 c0                	test   %al,%al
80108b0f:	75 0f                	jne    80108b20 <copyuvm_cow+0xc9>
        pte_lookup_table.pte_array[pa/PGSIZE] = 2; //now child + father fork are pointing at it
80108b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b14:	c1 e8 0c             	shr    $0xc,%eax
80108b17:	c6 80 20 65 11 80 02 	movb   $0x2,-0x7fee9ae0(%eax)
80108b1e:	eb 16                	jmp    80108b36 <copyuvm_cow+0xdf>
      } else {
        pte_lookup_table.pte_array[pa/PGSIZE] += 1;
80108b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b23:	c1 e8 0c             	shr    $0xc,%eax
80108b26:	0f b6 90 20 65 11 80 	movzbl -0x7fee9ae0(%eax),%edx
80108b2d:	83 c2 01             	add    $0x1,%edx
80108b30:	88 90 20 65 11 80    	mov    %dl,-0x7fee9ae0(%eax)
      }
    release(&pte_lookup_table.lock);
80108b36:	83 ec 0c             	sub    $0xc,%esp
80108b39:	68 20 65 21 80       	push   $0x80216520
80108b3e:	e8 d0 c7 ff ff       	call   80105313 <release>
80108b43:	83 c4 10             	add    $0x10,%esp
    cprintf("ABOUT TO MAP\n");
80108b46:	83 ec 0c             	sub    $0xc,%esp
80108b49:	68 a6 94 10 80       	push   $0x801094a6
80108b4e:	e8 73 78 ff ff       	call   801003c6 <cprintf>
80108b53:	83 c4 10             	add    $0x10,%esp

    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) //dont make new pages
80108b56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5c:	83 ec 0c             	sub    $0xc,%esp
80108b5f:	52                   	push   %edx
80108b60:	ff 75 e8             	pushl  -0x18(%ebp)
80108b63:	68 00 10 00 00       	push   $0x1000
80108b68:	50                   	push   %eax
80108b69:	ff 75 f0             	pushl  -0x10(%ebp)
80108b6c:	e8 04 f6 ff ff       	call   80108175 <mappages>
80108b71:	83 c4 20             	add    $0x20,%esp
80108b74:	85 c0                	test   %eax,%eax
80108b76:	0f 88 80 00 00 00    	js     80108bfc <copyuvm_cow+0x1a5>
      goto bad;
    //make it write only
    // cprintf("ABOUT TO MPROTECT\n");
    // mprotect(&pte,PGSIZE,PROT_READ);
    cprintf("pte: 0x%x\n",*pte);
80108b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b7f:	8b 00                	mov    (%eax),%eax
80108b81:	83 ec 08             	sub    $0x8,%esp
80108b84:	50                   	push   %eax
80108b85:	68 b4 94 10 80       	push   $0x801094b4
80108b8a:	e8 37 78 ff ff       	call   801003c6 <cprintf>
80108b8f:	83 c4 10             	add    $0x10,%esp
    *pte &= ~PTE_W;
80108b92:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b95:	8b 00                	mov    (%eax),%eax
80108b97:	83 e0 fd             	and    $0xfffffffd,%eax
80108b9a:	89 c2                	mov    %eax,%edx
80108b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b9f:	89 10                	mov    %edx,(%eax)
    cprintf(" after pte: 0x%x\n",*pte);
80108ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ba4:	8b 00                	mov    (%eax),%eax
80108ba6:	83 ec 08             	sub    $0x8,%esp
80108ba9:	50                   	push   %eax
80108baa:	68 bf 94 10 80       	push   $0x801094bf
80108baf:	e8 12 78 ff ff       	call   801003c6 <cprintf>
80108bb4:	83 c4 10             	add    $0x10,%esp
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108bb7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bc1:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108bc4:	0f 82 b7 fe ff ff    	jb     80108a81 <copyuvm_cow+0x2a>
    *pte &= ~PTE_W;
    cprintf(" after pte: 0x%x\n",*pte);

  }

  cprintf("Returning from copyuvm_cow\n");
80108bca:	83 ec 0c             	sub    $0xc,%esp
80108bcd:	68 d1 94 10 80       	push   $0x801094d1
80108bd2:	e8 ef 77 ff ff       	call   801003c6 <cprintf>
80108bd7:	83 c4 10             	add    $0x10,%esp

  //flush tlb?
  lcr3(v2p(pgdir));
80108bda:	83 ec 0c             	sub    $0xc,%esp
80108bdd:	ff 75 08             	pushl  0x8(%ebp)
80108be0:	e8 43 f0 ff ff       	call   80107c28 <v2p>
80108be5:	83 c4 10             	add    $0x10,%esp
80108be8:	83 ec 0c             	sub    $0xc,%esp
80108beb:	50                   	push   %eax
80108bec:	e8 2b f0 ff ff       	call   80107c1c <lcr3>
80108bf1:	83 c4 10             	add    $0x10,%esp
  return d;
80108bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bf7:	eb 17                	jmp    80108c10 <copyuvm_cow+0x1b9>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108bf9:	90                   	nop
80108bfa:	eb 01                	jmp    80108bfd <copyuvm_cow+0x1a6>
      }
    release(&pte_lookup_table.lock);
    cprintf("ABOUT TO MAP\n");

    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) //dont make new pages
      goto bad;
80108bfc:	90                   	nop
  //flush tlb?
  lcr3(v2p(pgdir));
  return d;

bad:
  freevm(d);
80108bfd:	83 ec 0c             	sub    $0xc,%esp
80108c00:	ff 75 f0             	pushl  -0x10(%ebp)
80108c03:	e8 52 fc ff ff       	call   8010885a <freevm>
80108c08:	83 c4 10             	add    $0x10,%esp
  return 0;
80108c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c10:	c9                   	leave  
80108c11:	c3                   	ret    

80108c12 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108c12:	55                   	push   %ebp
80108c13:	89 e5                	mov    %esp,%ebp
80108c15:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108c18:	83 ec 04             	sub    $0x4,%esp
80108c1b:	6a 00                	push   $0x0
80108c1d:	ff 75 0c             	pushl  0xc(%ebp)
80108c20:	ff 75 08             	pushl  0x8(%ebp)
80108c23:	e8 ad f4 ff ff       	call   801080d5 <walkpgdir>
80108c28:	83 c4 10             	add    $0x10,%esp
80108c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c31:	8b 00                	mov    (%eax),%eax
80108c33:	83 e0 01             	and    $0x1,%eax
80108c36:	85 c0                	test   %eax,%eax
80108c38:	75 07                	jne    80108c41 <uva2ka+0x2f>
    return 0;
80108c3a:	b8 00 00 00 00       	mov    $0x0,%eax
80108c3f:	eb 29                	jmp    80108c6a <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c44:	8b 00                	mov    (%eax),%eax
80108c46:	83 e0 04             	and    $0x4,%eax
80108c49:	85 c0                	test   %eax,%eax
80108c4b:	75 07                	jne    80108c54 <uva2ka+0x42>
    return 0;
80108c4d:	b8 00 00 00 00       	mov    $0x0,%eax
80108c52:	eb 16                	jmp    80108c6a <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c57:	8b 00                	mov    (%eax),%eax
80108c59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c5e:	83 ec 0c             	sub    $0xc,%esp
80108c61:	50                   	push   %eax
80108c62:	e8 ce ef ff ff       	call   80107c35 <p2v>
80108c67:	83 c4 10             	add    $0x10,%esp
}
80108c6a:	c9                   	leave  
80108c6b:	c3                   	ret    

80108c6c <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108c6c:	55                   	push   %ebp
80108c6d:	89 e5                	mov    %esp,%ebp
80108c6f:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108c72:	8b 45 10             	mov    0x10(%ebp),%eax
80108c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108c78:	eb 7f                	jmp    80108cf9 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c82:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c88:	83 ec 08             	sub    $0x8,%esp
80108c8b:	50                   	push   %eax
80108c8c:	ff 75 08             	pushl  0x8(%ebp)
80108c8f:	e8 7e ff ff ff       	call   80108c12 <uva2ka>
80108c94:	83 c4 10             	add    $0x10,%esp
80108c97:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108c9a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108c9e:	75 07                	jne    80108ca7 <copyout+0x3b>
      return -1;
80108ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108ca5:	eb 61                	jmp    80108d08 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108ca7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108caa:	2b 45 0c             	sub    0xc(%ebp),%eax
80108cad:	05 00 10 00 00       	add    $0x1000,%eax
80108cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cb8:	3b 45 14             	cmp    0x14(%ebp),%eax
80108cbb:	76 06                	jbe    80108cc3 <copyout+0x57>
      n = len;
80108cbd:	8b 45 14             	mov    0x14(%ebp),%eax
80108cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cc6:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108cc9:	89 c2                	mov    %eax,%edx
80108ccb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108cce:	01 d0                	add    %edx,%eax
80108cd0:	83 ec 04             	sub    $0x4,%esp
80108cd3:	ff 75 f0             	pushl  -0x10(%ebp)
80108cd6:	ff 75 f4             	pushl  -0xc(%ebp)
80108cd9:	50                   	push   %eax
80108cda:	e8 ef c8 ff ff       	call   801055ce <memmove>
80108cdf:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ce5:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ceb:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cf1:	05 00 10 00 00       	add    $0x1000,%eax
80108cf6:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108cf9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108cfd:	0f 85 77 ff ff ff    	jne    80108c7a <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d08:	c9                   	leave  
80108d09:	c3                   	ret    
