
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
8010003d:	68 48 8c 10 80       	push   $0x80108c48
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 01 52 00 00       	call   8010524d <initlock>
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
801000c1:	e8 a9 51 00 00       	call   8010526f <acquire>
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
8010010c:	e8 c5 51 00 00       	call   801052d6 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 da 4c 00 00       	call   80104e06 <sleep>
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
80100188:	e8 49 51 00 00       	call   801052d6 <release>
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
801001aa:	68 4f 8c 10 80       	push   $0x80108c4f
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
80100204:	68 60 8c 10 80       	push   $0x80108c60
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
80100243:	68 67 8c 10 80       	push   $0x80108c67
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 15 50 00 00       	call   8010526f <acquire>
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
801002b9:	e8 36 4c 00 00       	call   80104ef4 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 08 50 00 00       	call   801052d6 <release>
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
801003e2:	e8 88 4e 00 00       	call   8010526f <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 6e 8c 10 80       	push   $0x80108c6e
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
801004cd:	c7 45 ec 77 8c 10 80 	movl   $0x80108c77,-0x14(%ebp)
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
8010055b:	e8 76 4d 00 00       	call   801052d6 <release>
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
8010058b:	68 7e 8c 10 80       	push   $0x80108c7e
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
801005aa:	68 8d 8c 10 80       	push   $0x80108c8d
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 61 4d 00 00       	call   80105328 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 8f 8c 10 80       	push   $0x80108c8f
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
801006db:	e8 b1 4e 00 00       	call   80105591 <memmove>
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
80100705:	e8 c8 4d 00 00       	call   801054d2 <memset>
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
8010079a:	e8 cf 68 00 00       	call   8010706e <uartputc>
8010079f:	83 c4 10             	add    $0x10,%esp
801007a2:	83 ec 0c             	sub    $0xc,%esp
801007a5:	6a 20                	push   $0x20
801007a7:	e8 c2 68 00 00       	call   8010706e <uartputc>
801007ac:	83 c4 10             	add    $0x10,%esp
801007af:	83 ec 0c             	sub    $0xc,%esp
801007b2:	6a 08                	push   $0x8
801007b4:	e8 b5 68 00 00       	call   8010706e <uartputc>
801007b9:	83 c4 10             	add    $0x10,%esp
801007bc:	eb 0e                	jmp    801007cc <consputc+0x56>
  } else
    uartputc(c);
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	ff 75 08             	pushl  0x8(%ebp)
801007c4:	e8 a5 68 00 00       	call   8010706e <uartputc>
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
801007eb:	e8 7f 4a 00 00       	call   8010526f <acquire>
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
8010081e:	e8 8f 47 00 00       	call   80104fb2 <procdump>
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
80100931:	e8 be 45 00 00       	call   80104ef4 <wakeup>
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
80100954:	e8 7d 49 00 00       	call   801052d6 <release>
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
80100981:	e8 e9 48 00 00       	call   8010526f <acquire>
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
801009a3:	e8 2e 49 00 00       	call   801052d6 <release>
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
801009d0:	e8 31 44 00 00       	call   80104e06 <sleep>
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
80100a4e:	e8 83 48 00 00       	call   801052d6 <release>
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
80100a8c:	e8 de 47 00 00       	call   8010526f <acquire>
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
80100ace:	e8 03 48 00 00       	call   801052d6 <release>
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
80100af2:	68 93 8c 10 80       	push   $0x80108c93
80100af7:	68 e0 c5 10 80       	push   $0x8010c5e0
80100afc:	e8 4c 47 00 00       	call   8010524d <initlock>
80100b01:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b04:	83 ec 08             	sub    $0x8,%esp
80100b07:	68 9b 8c 10 80       	push   $0x80108c9b
80100b0c:	68 a0 17 11 80       	push   $0x801117a0
80100b11:	e8 37 47 00 00       	call   8010524d <initlock>
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
80100bcf:	e8 0d 76 00 00       	call   801081e1 <setupkvm>
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
80100c55:	e8 57 7a 00 00       	call   801086b1 <allocuvm>
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
80100c88:	e8 24 78 00 00       	call   801084b1 <loaduvm>
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
80100cf7:	e8 b5 79 00 00       	call   801086b1 <allocuvm>
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
80100d1b:	e8 b7 7b 00 00       	call   801088d7 <clearpteu>
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
80100d54:	e8 c6 49 00 00       	call   8010571f <strlen>
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
80100d81:	e8 99 49 00 00       	call   8010571f <strlen>
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
80100da7:	e8 fe 7d 00 00       	call   80108baa <copyout>
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
80100e43:	e8 62 7d 00 00       	call   80108baa <copyout>
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
80100e94:	e8 3c 48 00 00       	call   801056d5 <safestrcpy>
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
80100eea:	e8 d9 73 00 00       	call   801082c8 <switchuvm>
80100eef:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
80100ef5:	ff 75 d0             	pushl  -0x30(%ebp)
80100ef8:	e8 3a 79 00 00       	call   80108837 <freevm>
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
80100f32:	e8 00 79 00 00       	call   80108837 <freevm>
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
80100f63:	68 a1 8c 10 80       	push   $0x80108ca1
80100f68:	68 60 18 11 80       	push   $0x80111860
80100f6d:	e8 db 42 00 00       	call   8010524d <initlock>
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
80100f86:	e8 e4 42 00 00       	call   8010526f <acquire>
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
80100fb3:	e8 1e 43 00 00       	call   801052d6 <release>
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
80100fd6:	e8 fb 42 00 00       	call   801052d6 <release>
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
80100ff3:	e8 77 42 00 00       	call   8010526f <acquire>
80100ff8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffe:	8b 40 04             	mov    0x4(%eax),%eax
80101001:	85 c0                	test   %eax,%eax
80101003:	7f 0d                	jg     80101012 <filedup+0x2d>
    panic("filedup");
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	68 a8 8c 10 80       	push   $0x80108ca8
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
80101029:	e8 a8 42 00 00       	call   801052d6 <release>
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
80101044:	e8 26 42 00 00       	call   8010526f <acquire>
80101049:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
8010104f:	8b 40 04             	mov    0x4(%eax),%eax
80101052:	85 c0                	test   %eax,%eax
80101054:	7f 0d                	jg     80101063 <fileclose+0x2d>
    panic("fileclose");
80101056:	83 ec 0c             	sub    $0xc,%esp
80101059:	68 b0 8c 10 80       	push   $0x80108cb0
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
80101084:	e8 4d 42 00 00       	call   801052d6 <release>
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
801010d2:	e8 ff 41 00 00       	call   801052d6 <release>
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
80101221:	68 ba 8c 10 80       	push   $0x80108cba
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
80101324:	68 c3 8c 10 80       	push   $0x80108cc3
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
8010135a:	68 d3 8c 10 80       	push   $0x80108cd3
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
80101392:	e8 fa 41 00 00       	call   80105591 <memmove>
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
801013d8:	e8 f5 40 00 00       	call   801054d2 <memset>
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
80101551:	68 dd 8c 10 80       	push   $0x80108cdd
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
801015e7:	68 f3 8c 10 80       	push   $0x80108cf3
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
80101641:	68 06 8d 10 80       	push   $0x80108d06
80101646:	68 60 22 11 80       	push   $0x80112260
8010164b:	e8 fd 3b 00 00       	call   8010524d <initlock>
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
801016c6:	e8 07 3e 00 00       	call   801054d2 <memset>
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
8010172b:	68 0d 8d 10 80       	push   $0x80108d0d
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
801017cb:	e8 c1 3d 00 00       	call   80105591 <memmove>
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
80101800:	e8 6a 3a 00 00       	call   8010526f <acquire>
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
8010184e:	e8 83 3a 00 00       	call   801052d6 <release>
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
80101887:	68 1f 8d 10 80       	push   $0x80108d1f
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
801018c4:	e8 0d 3a 00 00       	call   801052d6 <release>
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
801018df:	e8 8b 39 00 00       	call   8010526f <acquire>
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
801018fe:	e8 d3 39 00 00       	call   801052d6 <release>
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
80101924:	68 2f 8d 10 80       	push   $0x80108d2f
80101929:	e8 38 ec ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
8010192e:	83 ec 0c             	sub    $0xc,%esp
80101931:	68 60 22 11 80       	push   $0x80112260
80101936:	e8 34 39 00 00       	call   8010526f <acquire>
8010193b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010193e:	eb 13                	jmp    80101953 <ilock+0x48>
    sleep(ip, &icache.lock);
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	68 60 22 11 80       	push   $0x80112260
80101948:	ff 75 08             	pushl  0x8(%ebp)
8010194b:	e8 b6 34 00 00       	call   80104e06 <sleep>
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
80101979:	e8 58 39 00 00       	call   801052d6 <release>
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
80101a20:	e8 6c 3b 00 00       	call   80105591 <memmove>
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
80101a56:	68 35 8d 10 80       	push   $0x80108d35
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
80101a89:	68 44 8d 10 80       	push   $0x80108d44
80101a8e:	e8 d3 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a93:	83 ec 0c             	sub    $0xc,%esp
80101a96:	68 60 22 11 80       	push   $0x80112260
80101a9b:	e8 cf 37 00 00       	call   8010526f <acquire>
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
80101aba:	e8 35 34 00 00       	call   80104ef4 <wakeup>
80101abf:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ac2:	83 ec 0c             	sub    $0xc,%esp
80101ac5:	68 60 22 11 80       	push   $0x80112260
80101aca:	e8 07 38 00 00       	call   801052d6 <release>
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
80101ae3:	e8 87 37 00 00       	call   8010526f <acquire>
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
80101b2b:	68 4c 8d 10 80       	push   $0x80108d4c
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
80101b4e:	e8 83 37 00 00       	call   801052d6 <release>
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
80101b83:	e8 e7 36 00 00       	call   8010526f <acquire>
80101b88:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b95:	83 ec 0c             	sub    $0xc,%esp
80101b98:	ff 75 08             	pushl  0x8(%ebp)
80101b9b:	e8 54 33 00 00       	call   80104ef4 <wakeup>
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
80101bba:	e8 17 37 00 00       	call   801052d6 <release>
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
80101cfa:	68 56 8d 10 80       	push   $0x80108d56
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
80101f91:	e8 fb 35 00 00       	call   80105591 <memmove>
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
801020e3:	e8 a9 34 00 00       	call   80105591 <memmove>
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
80102163:	e8 bf 34 00 00       	call   80105627 <strncmp>
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
80102183:	68 69 8d 10 80       	push   $0x80108d69
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
801021b2:	68 7b 8d 10 80       	push   $0x80108d7b
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
80102287:	68 7b 8d 10 80       	push   $0x80108d7b
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
801022c2:	e8 b6 33 00 00       	call   8010567d <strncpy>
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
801022ee:	68 88 8d 10 80       	push   $0x80108d88
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
80102364:	e8 28 32 00 00       	call   80105591 <memmove>
80102369:	83 c4 10             	add    $0x10,%esp
8010236c:	eb 26                	jmp    80102394 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102371:	83 ec 04             	sub    $0x4,%esp
80102374:	50                   	push   %eax
80102375:	ff 75 f4             	pushl  -0xc(%ebp)
80102378:	ff 75 0c             	pushl  0xc(%ebp)
8010237b:	e8 11 32 00 00       	call   80105591 <memmove>
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
801025d0:	68 90 8d 10 80       	push   $0x80108d90
801025d5:	68 20 c6 10 80       	push   $0x8010c620
801025da:	e8 6e 2c 00 00       	call   8010524d <initlock>
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
80102684:	68 94 8d 10 80       	push   $0x80108d94
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
801027a5:	e8 c5 2a 00 00       	call   8010526f <acquire>
801027aa:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027ad:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027b9:	75 15                	jne    801027d0 <ideintr+0x39>
    release(&idelock);
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	68 20 c6 10 80       	push   $0x8010c620
801027c3:	e8 0e 2b 00 00       	call   801052d6 <release>
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
80102838:	e8 b7 26 00 00       	call   80104ef4 <wakeup>
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
80102862:	e8 6f 2a 00 00       	call   801052d6 <release>
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
80102881:	68 9d 8d 10 80       	push   $0x80108d9d
80102886:	e8 db dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010288b:	8b 45 08             	mov    0x8(%ebp),%eax
8010288e:	8b 00                	mov    (%eax),%eax
80102890:	83 e0 06             	and    $0x6,%eax
80102893:	83 f8 02             	cmp    $0x2,%eax
80102896:	75 0d                	jne    801028a5 <iderw+0x39>
    panic("iderw: nothing to do");
80102898:	83 ec 0c             	sub    $0xc,%esp
8010289b:	68 b1 8d 10 80       	push   $0x80108db1
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
801028bb:	68 c6 8d 10 80       	push   $0x80108dc6
801028c0:	e8 a1 dc ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028c5:	83 ec 0c             	sub    $0xc,%esp
801028c8:	68 20 c6 10 80       	push   $0x8010c620
801028cd:	e8 9d 29 00 00       	call   8010526f <acquire>
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
80102929:	e8 d8 24 00 00       	call   80104e06 <sleep>
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
80102946:	e8 8b 29 00 00       	call   801052d6 <release>
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
801029d7:	68 e4 8d 10 80       	push   $0x80108de4
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
80102a97:	68 16 8e 10 80       	push   $0x80108e16
80102a9c:	68 40 32 11 80       	push   $0x80113240
80102aa1:	e8 a7 27 00 00       	call   8010524d <initlock>
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
80102b3a:	81 7d 08 9c 24 15 80 	cmpl   $0x8015249c,0x8(%ebp)
80102b41:	72 12                	jb     80102b55 <kfree+0x2d>
80102b43:	ff 75 08             	pushl  0x8(%ebp)
80102b46:	e8 36 ff ff ff       	call   80102a81 <v2p>
80102b4b:	83 c4 04             	add    $0x4,%esp
80102b4e:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b53:	76 0d                	jbe    80102b62 <kfree+0x3a>
    panic("kfree");
80102b55:	83 ec 0c             	sub    $0xc,%esp
80102b58:	68 1b 8e 10 80       	push   $0x80108e1b
80102b5d:	e8 04 da ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b62:	83 ec 04             	sub    $0x4,%esp
80102b65:	68 00 10 00 00       	push   $0x1000
80102b6a:	6a 01                	push   $0x1
80102b6c:	ff 75 08             	pushl  0x8(%ebp)
80102b6f:	e8 5e 29 00 00       	call   801054d2 <memset>
80102b74:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b77:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	74 10                	je     80102b90 <kfree+0x68>
    acquire(&kmem.lock);
80102b80:	83 ec 0c             	sub    $0xc,%esp
80102b83:	68 40 32 11 80       	push   $0x80113240
80102b88:	e8 e2 26 00 00       	call   8010526f <acquire>
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
80102bba:	e8 17 27 00 00       	call   801052d6 <release>
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
80102bdc:	e8 8e 26 00 00       	call   8010526f <acquire>
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
80102c0d:	e8 c4 26 00 00       	call   801052d6 <release>
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
80102f58:	68 24 8e 10 80       	push   $0x80108e24
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
80103183:	e8 b1 23 00 00       	call   80105539 <memcmp>
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
80103297:	68 50 8e 10 80       	push   $0x80108e50
8010329c:	68 80 32 11 80       	push   $0x80113280
801032a1:	e8 a7 1f 00 00       	call   8010524d <initlock>
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
80103354:	e8 38 22 00 00       	call   80105591 <memmove>
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
801034c2:	e8 a8 1d 00 00       	call   8010526f <acquire>
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
801034e0:	e8 21 19 00 00       	call   80104e06 <sleep>
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
80103515:	e8 ec 18 00 00       	call   80104e06 <sleep>
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
80103534:	e8 9d 1d 00 00       	call   801052d6 <release>
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
80103555:	e8 15 1d 00 00       	call   8010526f <acquire>
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
80103576:	68 54 8e 10 80       	push   $0x80108e54
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
801035a4:	e8 4b 19 00 00       	call   80104ef4 <wakeup>
801035a9:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801035ac:	83 ec 0c             	sub    $0xc,%esp
801035af:	68 80 32 11 80       	push   $0x80113280
801035b4:	e8 1d 1d 00 00       	call   801052d6 <release>
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
801035cf:	e8 9b 1c 00 00       	call   8010526f <acquire>
801035d4:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801035d7:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
801035de:	00 00 00 
    wakeup(&log);
801035e1:	83 ec 0c             	sub    $0xc,%esp
801035e4:	68 80 32 11 80       	push   $0x80113280
801035e9:	e8 06 19 00 00       	call   80104ef4 <wakeup>
801035ee:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801035f1:	83 ec 0c             	sub    $0xc,%esp
801035f4:	68 80 32 11 80       	push   $0x80113280
801035f9:	e8 d8 1c 00 00       	call   801052d6 <release>
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
80103675:	e8 17 1f 00 00       	call   80105591 <memmove>
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
80103711:	68 63 8e 10 80       	push   $0x80108e63
80103716:	e8 4b ce ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010371b:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103720:	85 c0                	test   %eax,%eax
80103722:	7f 0d                	jg     80103731 <log_write+0x45>
    panic("log_write outside of trans");
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 79 8e 10 80       	push   $0x80108e79
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
801037ef:	68 9c 24 15 80       	push   $0x8015249c
801037f4:	e8 95 f2 ff ff       	call   80102a8e <kinit1>
801037f9:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801037fc:	e8 92 4a 00 00       	call   80108293 <kvmalloc>
  mpinit();        // collect info about this machine
80103801:	e8 4d 04 00 00       	call   80103c53 <mpinit>
  lapicinit();
80103806:	e8 02 f6 ff ff       	call   80102e0d <lapicinit>
  seginit();       // set up segments
8010380b:	e8 2c 44 00 00       	call   80107c3c <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103810:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103816:	0f b6 00             	movzbl (%eax),%eax
80103819:	0f b6 c0             	movzbl %al,%eax
8010381c:	83 ec 08             	sub    $0x8,%esp
8010381f:	50                   	push   %eax
80103820:	68 94 8e 10 80       	push   $0x80108e94
80103825:	e8 9c cb ff ff       	call   801003c6 <cprintf>
8010382a:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010382d:	e8 77 06 00 00       	call   80103ea9 <picinit>
  ioapicinit();    // another interrupt controller
80103832:	e8 4c f1 ff ff       	call   80102983 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103837:	e8 ad d2 ff ff       	call   80100ae9 <consoleinit>
  uartinit();      // serial port
8010383c:	e8 39 37 00 00       	call   80106f7a <uartinit>
  pinit();         // process table
80103841:	e8 60 0b 00 00       	call   801043a6 <pinit>
  init_pte_lookup_lock(); // pte_lookup lock
80103846:	e8 d3 43 00 00       	call   80107c1e <init_pte_lookup_lock>
  tvinit();        // trap vectors
8010384b:	e8 0f 32 00 00       	call   80106a5f <tvinit>
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
8010386d:	e8 4a 31 00 00       	call   801069bc <timerinit>
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
8010389c:	e8 0a 4a 00 00       	call   801082ab <switchkvm>
  seginit();
801038a1:	e8 96 43 00 00       	call   80107c3c <seginit>
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
801038c6:	68 ab 8e 10 80       	push   $0x80108eab
801038cb:	e8 f6 ca ff ff       	call   801003c6 <cprintf>
801038d0:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801038d3:	e8 fd 32 00 00       	call   80106bd5 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801038d8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038de:	05 a8 00 00 00       	add    $0xa8,%eax
801038e3:	83 ec 08             	sub    $0x8,%esp
801038e6:	6a 01                	push   $0x1
801038e8:	50                   	push   %eax
801038e9:	e8 ce fe ff ff       	call   801037bc <xchg>
801038ee:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801038f1:	e8 40 13 00 00       	call   80104c36 <scheduler>

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
8010391e:	e8 6e 1c 00 00       	call   80105591 <memmove>
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
80103aac:	68 bc 8e 10 80       	push   $0x80108ebc
80103ab1:	ff 75 f4             	pushl  -0xc(%ebp)
80103ab4:	e8 80 1a 00 00       	call   80105539 <memcmp>
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
80103bea:	68 c1 8e 10 80       	push   $0x80108ec1
80103bef:	ff 75 f0             	pushl  -0x10(%ebp)
80103bf2:	e8 42 19 00 00       	call   80105539 <memcmp>
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
80103cc6:	8b 04 85 04 8f 10 80 	mov    -0x7fef70fc(,%eax,4),%eax
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
80103cfc:	68 c6 8e 10 80       	push   $0x80108ec6
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
80103d8f:	68 e4 8e 10 80       	push   $0x80108ee4
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
80104030:	68 18 8f 10 80       	push   $0x80108f18
80104035:	50                   	push   %eax
80104036:	e8 12 12 00 00       	call   8010524d <initlock>
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
801040f2:	e8 78 11 00 00       	call   8010526f <acquire>
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
80104119:	e8 d6 0d 00 00       	call   80104ef4 <wakeup>
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
8010413c:	e8 b3 0d 00 00       	call   80104ef4 <wakeup>
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
80104165:	e8 6c 11 00 00       	call   801052d6 <release>
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
80104184:	e8 4d 11 00 00       	call   801052d6 <release>
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
8010419c:	e8 ce 10 00 00       	call   8010526f <acquire>
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
801041d1:	e8 00 11 00 00       	call   801052d6 <release>
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
801041ef:	e8 00 0d 00 00       	call   80104ef4 <wakeup>
801041f4:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801041f7:	8b 45 08             	mov    0x8(%ebp),%eax
801041fa:	8b 55 08             	mov    0x8(%ebp),%edx
801041fd:	81 c2 38 02 00 00    	add    $0x238,%edx
80104203:	83 ec 08             	sub    $0x8,%esp
80104206:	50                   	push   %eax
80104207:	52                   	push   %edx
80104208:	e8 f9 0b 00 00       	call   80104e06 <sleep>
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
80104271:	e8 7e 0c 00 00       	call   80104ef4 <wakeup>
80104276:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104279:	8b 45 08             	mov    0x8(%ebp),%eax
8010427c:	83 ec 0c             	sub    $0xc,%esp
8010427f:	50                   	push   %eax
80104280:	e8 51 10 00 00       	call   801052d6 <release>
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
8010429b:	e8 cf 0f 00 00       	call   8010526f <acquire>
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
801042b9:	e8 18 10 00 00       	call   801052d6 <release>
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
801042dc:	e8 25 0b 00 00       	call   80104e06 <sleep>
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
80104370:	e8 7f 0b 00 00       	call   80104ef4 <wakeup>
80104375:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104378:	8b 45 08             	mov    0x8(%ebp),%eax
8010437b:	83 ec 0c             	sub    $0xc,%esp
8010437e:	50                   	push   %eax
8010437f:	e8 52 0f 00 00       	call   801052d6 <release>
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
801043af:	68 1d 8f 10 80       	push   $0x80108f1d
801043b4:	68 80 39 11 80       	push   $0x80113980
801043b9:	e8 8f 0e 00 00       	call   8010524d <initlock>
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
801043d2:	e8 98 0e 00 00       	call   8010526f <acquire>
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
801043ed:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
801043f4:	81 7d f4 b4 5b 11 80 	cmpl   $0x80115bb4,-0xc(%ebp)
801043fb:	72 e6                	jb     801043e3 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
801043fd:	83 ec 0c             	sub    $0xc,%esp
80104400:	68 80 39 11 80       	push   $0x80113980
80104405:	e8 cc 0e 00 00       	call   801052d6 <release>
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
8010443e:	e8 93 0e 00 00       	call   801052d6 <release>
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
80104490:	ba 19 6a 10 80       	mov    $0x80106a19,%edx
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
801044b5:	e8 18 10 00 00       	call   801054d2 <memset>
801044ba:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801044bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c0:	8b 40 1c             	mov    0x1c(%eax),%eax
801044c3:	ba d5 4d 10 80       	mov    $0x80104dd5,%edx
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
8010450a:	e8 d2 3c 00 00       	call   801081e1 <setupkvm>
8010450f:	89 c2                	mov    %eax,%edx
80104511:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104514:	89 50 04             	mov    %edx,0x4(%eax)
80104517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451a:	8b 40 04             	mov    0x4(%eax),%eax
8010451d:	85 c0                	test   %eax,%eax
8010451f:	75 0d                	jne    8010452e <userinit+0x3a>
    panic("userinit: out of memory?");
80104521:	83 ec 0c             	sub    $0xc,%esp
80104524:	68 24 8f 10 80       	push   $0x80108f24
80104529:	e8 38 c0 ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010452e:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104533:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104536:	8b 40 04             	mov    0x4(%eax),%eax
80104539:	83 ec 04             	sub    $0x4,%esp
8010453c:	52                   	push   %edx
8010453d:	68 00 c5 10 80       	push   $0x8010c500
80104542:	50                   	push   %eax
80104543:	e8 f3 3e 00 00       	call   8010843b <inituvm>
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
80104562:	e8 6b 0f 00 00       	call   801054d2 <memset>
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
801045dc:	68 3d 8f 10 80       	push   $0x80108f3d
801045e1:	50                   	push   %eax
801045e2:	e8 ee 10 00 00       	call   801056d5 <safestrcpy>
801045e7:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801045ea:	83 ec 0c             	sub    $0xc,%esp
801045ed:	68 46 8f 10 80       	push   $0x80108f46
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
8010463f:	e8 6d 40 00 00       	call   801086b1 <allocuvm>
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
80104676:	e8 ff 40 00 00       	call   8010877a <deallocuvm>
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
801046a3:	e8 20 3c 00 00       	call   801082c8 <switchuvm>
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
801046e9:	e8 2a 42 00 00       	call   80108918 <copyuvm>
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
801047fd:	e8 d3 0e 00 00       	call   801056d5 <safestrcpy>
80104802:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104805:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104808:	8b 40 10             	mov    0x10(%eax),%eax
8010480b:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010480e:	83 ec 0c             	sub    $0xc,%esp
80104811:	68 80 39 11 80       	push   $0x80113980
80104816:	e8 54 0a 00 00       	call   8010526f <acquire>
8010481b:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
8010481e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104821:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	68 80 39 11 80       	push   $0x80113980
80104830:	e8 a1 0a 00 00       	call   801052d6 <release>
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
8010485f:	e9 68 01 00 00       	jmp    801049cc <cowfork+0x189>

  // Copy process state from p.
  //look into this for cowfork
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104864:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010486a:	8b 10                	mov    (%eax),%edx
8010486c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104872:	8b 40 04             	mov    0x4(%eax),%eax
80104875:	83 ec 08             	sub    $0x8,%esp
80104878:	52                   	push   %edx
80104879:	50                   	push   %eax
8010487a:	e8 99 40 00 00       	call   80108918 <copyuvm>
8010487f:	83 c4 10             	add    $0x10,%esp
80104882:	89 c2                	mov    %eax,%edx
80104884:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104887:	89 50 04             	mov    %edx,0x4(%eax)
8010488a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010488d:	8b 40 04             	mov    0x4(%eax),%eax
80104890:	85 c0                	test   %eax,%eax
80104892:	75 30                	jne    801048c4 <cowfork+0x81>
    kfree(np->kstack);
80104894:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104897:	8b 40 08             	mov    0x8(%eax),%eax
8010489a:	83 ec 0c             	sub    $0xc,%esp
8010489d:	50                   	push   %eax
8010489e:	e8 85 e2 ff ff       	call   80102b28 <kfree>
801048a3:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801048a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801048b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801048ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048bf:	e9 08 01 00 00       	jmp    801049cc <cowfork+0x189>
  }
  np->sz = proc->sz;
801048c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ca:	8b 10                	mov    (%eax),%edx
801048cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048cf:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801048d1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048db:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801048de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048e1:	8b 50 18             	mov    0x18(%eax),%edx
801048e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ea:	8b 40 18             	mov    0x18(%eax),%eax
801048ed:	89 c3                	mov    %eax,%ebx
801048ef:	b8 13 00 00 00       	mov    $0x13,%eax
801048f4:	89 d7                	mov    %edx,%edi
801048f6:	89 de                	mov    %ebx,%esi
801048f8:	89 c1                	mov    %eax,%ecx
801048fa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801048fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048ff:	8b 40 18             	mov    0x18(%eax),%eax
80104902:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104909:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104910:	eb 43                	jmp    80104955 <cowfork+0x112>
    if(proc->ofile[i])
80104912:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104918:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010491b:	83 c2 08             	add    $0x8,%edx
8010491e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104922:	85 c0                	test   %eax,%eax
80104924:	74 2b                	je     80104951 <cowfork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
80104926:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010492c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010492f:	83 c2 08             	add    $0x8,%edx
80104932:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104936:	83 ec 0c             	sub    $0xc,%esp
80104939:	50                   	push   %eax
8010493a:	e8 a6 c6 ff ff       	call   80100fe5 <filedup>
8010493f:	83 c4 10             	add    $0x10,%esp
80104942:	89 c1                	mov    %eax,%ecx
80104944:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104947:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010494a:	83 c2 08             	add    $0x8,%edx
8010494d:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104951:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104955:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104959:	7e b7                	jle    80104912 <cowfork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010495b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104961:	8b 40 68             	mov    0x68(%eax),%eax
80104964:	83 ec 0c             	sub    $0xc,%esp
80104967:	50                   	push   %eax
80104968:	e8 64 cf ff ff       	call   801018d1 <idup>
8010496d:	83 c4 10             	add    $0x10,%esp
80104970:	89 c2                	mov    %eax,%edx
80104972:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104975:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104978:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010497e:	8d 50 6c             	lea    0x6c(%eax),%edx
80104981:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104984:	83 c0 6c             	add    $0x6c,%eax
80104987:	83 ec 04             	sub    $0x4,%esp
8010498a:	6a 10                	push   $0x10
8010498c:	52                   	push   %edx
8010498d:	50                   	push   %eax
8010498e:	e8 42 0d 00 00       	call   801056d5 <safestrcpy>
80104993:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104996:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104999:	8b 40 10             	mov    0x10(%eax),%eax
8010499c:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010499f:	83 ec 0c             	sub    $0xc,%esp
801049a2:	68 80 39 11 80       	push   $0x80113980
801049a7:	e8 c3 08 00 00       	call   8010526f <acquire>
801049ac:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801049af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049b2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801049b9:	83 ec 0c             	sub    $0xc,%esp
801049bc:	68 80 39 11 80       	push   $0x80113980
801049c1:	e8 10 09 00 00       	call   801052d6 <release>
801049c6:	83 c4 10             	add    $0x10,%esp

  return pid;
801049c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801049cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049cf:	5b                   	pop    %ebx
801049d0:	5e                   	pop    %esi
801049d1:	5f                   	pop    %edi
801049d2:	5d                   	pop    %ebp
801049d3:	c3                   	ret    

801049d4 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801049d4:	55                   	push   %ebp
801049d5:	89 e5                	mov    %esp,%ebp
801049d7:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801049da:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049e1:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801049e6:	39 c2                	cmp    %eax,%edx
801049e8:	75 0d                	jne    801049f7 <exit+0x23>
    panic("init exiting");
801049ea:	83 ec 0c             	sub    $0xc,%esp
801049ed:	68 48 8f 10 80       	push   $0x80108f48
801049f2:	e8 6f bb ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801049f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801049fe:	eb 48                	jmp    80104a48 <exit+0x74>
    if(proc->ofile[fd]){
80104a00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a06:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a09:	83 c2 08             	add    $0x8,%edx
80104a0c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a10:	85 c0                	test   %eax,%eax
80104a12:	74 30                	je     80104a44 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104a14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a1d:	83 c2 08             	add    $0x8,%edx
80104a20:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a24:	83 ec 0c             	sub    $0xc,%esp
80104a27:	50                   	push   %eax
80104a28:	e8 09 c6 ff ff       	call   80101036 <fileclose>
80104a2d:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104a30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a36:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a39:	83 c2 08             	add    $0x8,%edx
80104a3c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a43:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a44:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a48:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104a4c:	7e b2                	jle    80104a00 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104a4e:	e8 61 ea ff ff       	call   801034b4 <begin_op>
  iput(proc->cwd);
80104a53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a59:	8b 40 68             	mov    0x68(%eax),%eax
80104a5c:	83 ec 0c             	sub    $0xc,%esp
80104a5f:	50                   	push   %eax
80104a60:	e8 70 d0 ff ff       	call   80101ad5 <iput>
80104a65:	83 c4 10             	add    $0x10,%esp
  end_op();
80104a68:	e8 d3 ea ff ff       	call   80103540 <end_op>
  proc->cwd = 0;
80104a6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a73:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	68 80 39 11 80       	push   $0x80113980
80104a82:	e8 e8 07 00 00       	call   8010526f <acquire>
80104a87:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104a8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a90:	8b 40 14             	mov    0x14(%eax),%eax
80104a93:	83 ec 0c             	sub    $0xc,%esp
80104a96:	50                   	push   %eax
80104a97:	e8 16 04 00 00       	call   80104eb2 <wakeup1>
80104a9c:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a9f:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104aa6:	eb 3f                	jmp    80104ae7 <exit+0x113>
    if(p->parent == proc){
80104aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aab:	8b 50 14             	mov    0x14(%eax),%edx
80104aae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab4:	39 c2                	cmp    %eax,%edx
80104ab6:	75 28                	jne    80104ae0 <exit+0x10c>
      p->parent = initproc;
80104ab8:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac1:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac7:	8b 40 0c             	mov    0xc(%eax),%eax
80104aca:	83 f8 05             	cmp    $0x5,%eax
80104acd:	75 11                	jne    80104ae0 <exit+0x10c>
        wakeup1(initproc);
80104acf:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104ad4:	83 ec 0c             	sub    $0xc,%esp
80104ad7:	50                   	push   %eax
80104ad8:	e8 d5 03 00 00       	call   80104eb2 <wakeup1>
80104add:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ae0:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104ae7:	81 7d f4 b4 5b 11 80 	cmpl   $0x80115bb4,-0xc(%ebp)
80104aee:	72 b8                	jb     80104aa8 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104af0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af6:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104afd:	e8 dc 01 00 00       	call   80104cde <sched>
  panic("zombie exit");
80104b02:	83 ec 0c             	sub    $0xc,%esp
80104b05:	68 55 8f 10 80       	push   $0x80108f55
80104b0a:	e8 57 ba ff ff       	call   80100566 <panic>

80104b0f <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104b0f:	55                   	push   %ebp
80104b10:	89 e5                	mov    %esp,%ebp
80104b12:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104b15:	83 ec 0c             	sub    $0xc,%esp
80104b18:	68 80 39 11 80       	push   $0x80113980
80104b1d:	e8 4d 07 00 00       	call   8010526f <acquire>
80104b22:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b25:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b2c:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104b33:	e9 a9 00 00 00       	jmp    80104be1 <wait+0xd2>
      if(p->parent != proc)
80104b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b3b:	8b 50 14             	mov    0x14(%eax),%edx
80104b3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b44:	39 c2                	cmp    %eax,%edx
80104b46:	0f 85 8d 00 00 00    	jne    80104bd9 <wait+0xca>
        continue;
      havekids = 1;
80104b4c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b56:	8b 40 0c             	mov    0xc(%eax),%eax
80104b59:	83 f8 05             	cmp    $0x5,%eax
80104b5c:	75 7c                	jne    80104bda <wait+0xcb>
        // Found one.
        pid = p->pid;
80104b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b61:	8b 40 10             	mov    0x10(%eax),%eax
80104b64:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b6a:	8b 40 08             	mov    0x8(%eax),%eax
80104b6d:	83 ec 0c             	sub    $0xc,%esp
80104b70:	50                   	push   %eax
80104b71:	e8 b2 df ff ff       	call   80102b28 <kfree>
80104b76:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b7c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b86:	8b 40 04             	mov    0x4(%eax),%eax
80104b89:	83 ec 0c             	sub    $0xc,%esp
80104b8c:	50                   	push   %eax
80104b8d:	e8 a5 3c 00 00       	call   80108837 <freevm>
80104b92:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b98:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba2:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bac:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb6:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbd:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104bc4:	83 ec 0c             	sub    $0xc,%esp
80104bc7:	68 80 39 11 80       	push   $0x80113980
80104bcc:	e8 05 07 00 00       	call   801052d6 <release>
80104bd1:	83 c4 10             	add    $0x10,%esp
        return pid;
80104bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bd7:	eb 5b                	jmp    80104c34 <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104bd9:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bda:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104be1:	81 7d f4 b4 5b 11 80 	cmpl   $0x80115bb4,-0xc(%ebp)
80104be8:	0f 82 4a ff ff ff    	jb     80104b38 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104bee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104bf2:	74 0d                	je     80104c01 <wait+0xf2>
80104bf4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bfa:	8b 40 24             	mov    0x24(%eax),%eax
80104bfd:	85 c0                	test   %eax,%eax
80104bff:	74 17                	je     80104c18 <wait+0x109>
      release(&ptable.lock);
80104c01:	83 ec 0c             	sub    $0xc,%esp
80104c04:	68 80 39 11 80       	push   $0x80113980
80104c09:	e8 c8 06 00 00       	call   801052d6 <release>
80104c0e:	83 c4 10             	add    $0x10,%esp
      return -1;
80104c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c16:	eb 1c                	jmp    80104c34 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c1e:	83 ec 08             	sub    $0x8,%esp
80104c21:	68 80 39 11 80       	push   $0x80113980
80104c26:	50                   	push   %eax
80104c27:	e8 da 01 00 00       	call   80104e06 <sleep>
80104c2c:	83 c4 10             	add    $0x10,%esp
  }
80104c2f:	e9 f1 fe ff ff       	jmp    80104b25 <wait+0x16>
}
80104c34:	c9                   	leave  
80104c35:	c3                   	ret    

80104c36 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104c36:	55                   	push   %ebp
80104c37:	89 e5                	mov    %esp,%ebp
80104c39:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104c3c:	e8 5e f7 ff ff       	call   8010439f <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104c41:	83 ec 0c             	sub    $0xc,%esp
80104c44:	68 80 39 11 80       	push   $0x80113980
80104c49:	e8 21 06 00 00       	call   8010526f <acquire>
80104c4e:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c51:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104c58:	eb 66                	jmp    80104cc0 <scheduler+0x8a>
      if(p->state != RUNNABLE)
80104c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c5d:	8b 40 0c             	mov    0xc(%eax),%eax
80104c60:	83 f8 03             	cmp    $0x3,%eax
80104c63:	75 53                	jne    80104cb8 <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c68:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104c6e:	83 ec 0c             	sub    $0xc,%esp
80104c71:	ff 75 f4             	pushl  -0xc(%ebp)
80104c74:	e8 4f 36 00 00       	call   801082c8 <switchuvm>
80104c79:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c7f:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104c86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c8c:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c8f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c96:	83 c2 04             	add    $0x4,%edx
80104c99:	83 ec 08             	sub    $0x8,%esp
80104c9c:	50                   	push   %eax
80104c9d:	52                   	push   %edx
80104c9e:	e8 a3 0a 00 00       	call   80105746 <swtch>
80104ca3:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104ca6:	e8 00 36 00 00       	call   801082ab <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104cab:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104cb2:	00 00 00 00 
80104cb6:	eb 01                	jmp    80104cb9 <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104cb8:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cb9:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104cc0:	81 7d f4 b4 5b 11 80 	cmpl   $0x80115bb4,-0xc(%ebp)
80104cc7:	72 91                	jb     80104c5a <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104cc9:	83 ec 0c             	sub    $0xc,%esp
80104ccc:	68 80 39 11 80       	push   $0x80113980
80104cd1:	e8 00 06 00 00       	call   801052d6 <release>
80104cd6:	83 c4 10             	add    $0x10,%esp

  }
80104cd9:	e9 5e ff ff ff       	jmp    80104c3c <scheduler+0x6>

80104cde <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104cde:	55                   	push   %ebp
80104cdf:	89 e5                	mov    %esp,%ebp
80104ce1:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104ce4:	83 ec 0c             	sub    $0xc,%esp
80104ce7:	68 80 39 11 80       	push   $0x80113980
80104cec:	e8 b1 06 00 00       	call   801053a2 <holding>
80104cf1:	83 c4 10             	add    $0x10,%esp
80104cf4:	85 c0                	test   %eax,%eax
80104cf6:	75 0d                	jne    80104d05 <sched+0x27>
    panic("sched ptable.lock");
80104cf8:	83 ec 0c             	sub    $0xc,%esp
80104cfb:	68 61 8f 10 80       	push   $0x80108f61
80104d00:	e8 61 b8 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104d05:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d0b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d11:	83 f8 01             	cmp    $0x1,%eax
80104d14:	74 0d                	je     80104d23 <sched+0x45>
    panic("sched locks");
80104d16:	83 ec 0c             	sub    $0xc,%esp
80104d19:	68 73 8f 10 80       	push   $0x80108f73
80104d1e:	e8 43 b8 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104d23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d29:	8b 40 0c             	mov    0xc(%eax),%eax
80104d2c:	83 f8 04             	cmp    $0x4,%eax
80104d2f:	75 0d                	jne    80104d3e <sched+0x60>
    panic("sched running");
80104d31:	83 ec 0c             	sub    $0xc,%esp
80104d34:	68 7f 8f 10 80       	push   $0x80108f7f
80104d39:	e8 28 b8 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104d3e:	e8 4c f6 ff ff       	call   8010438f <readeflags>
80104d43:	25 00 02 00 00       	and    $0x200,%eax
80104d48:	85 c0                	test   %eax,%eax
80104d4a:	74 0d                	je     80104d59 <sched+0x7b>
    panic("sched interruptible");
80104d4c:	83 ec 0c             	sub    $0xc,%esp
80104d4f:	68 8d 8f 10 80       	push   $0x80108f8d
80104d54:	e8 0d b8 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104d59:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d5f:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104d68:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d6e:	8b 40 04             	mov    0x4(%eax),%eax
80104d71:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d78:	83 c2 1c             	add    $0x1c,%edx
80104d7b:	83 ec 08             	sub    $0x8,%esp
80104d7e:	50                   	push   %eax
80104d7f:	52                   	push   %edx
80104d80:	e8 c1 09 00 00       	call   80105746 <swtch>
80104d85:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104d88:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d91:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104d97:	90                   	nop
80104d98:	c9                   	leave  
80104d99:	c3                   	ret    

80104d9a <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104d9a:	55                   	push   %ebp
80104d9b:	89 e5                	mov    %esp,%ebp
80104d9d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104da0:	83 ec 0c             	sub    $0xc,%esp
80104da3:	68 80 39 11 80       	push   $0x80113980
80104da8:	e8 c2 04 00 00       	call   8010526f <acquire>
80104dad:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104db0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104db6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104dbd:	e8 1c ff ff ff       	call   80104cde <sched>
  release(&ptable.lock);
80104dc2:	83 ec 0c             	sub    $0xc,%esp
80104dc5:	68 80 39 11 80       	push   $0x80113980
80104dca:	e8 07 05 00 00       	call   801052d6 <release>
80104dcf:	83 c4 10             	add    $0x10,%esp
}
80104dd2:	90                   	nop
80104dd3:	c9                   	leave  
80104dd4:	c3                   	ret    

80104dd5 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104dd5:	55                   	push   %ebp
80104dd6:	89 e5                	mov    %esp,%ebp
80104dd8:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104ddb:	83 ec 0c             	sub    $0xc,%esp
80104dde:	68 80 39 11 80       	push   $0x80113980
80104de3:	e8 ee 04 00 00       	call   801052d6 <release>
80104de8:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104deb:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104df0:	85 c0                	test   %eax,%eax
80104df2:	74 0f                	je     80104e03 <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104df4:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104dfb:	00 00 00 
    initlog();
80104dfe:	e8 8b e4 ff ff       	call   8010328e <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104e03:	90                   	nop
80104e04:	c9                   	leave  
80104e05:	c3                   	ret    

80104e06 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e06:	55                   	push   %ebp
80104e07:	89 e5                	mov    %esp,%ebp
80104e09:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104e0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e12:	85 c0                	test   %eax,%eax
80104e14:	75 0d                	jne    80104e23 <sleep+0x1d>
    panic("sleep");
80104e16:	83 ec 0c             	sub    $0xc,%esp
80104e19:	68 a1 8f 10 80       	push   $0x80108fa1
80104e1e:	e8 43 b7 ff ff       	call   80100566 <panic>

  if(lk == 0)
80104e23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e27:	75 0d                	jne    80104e36 <sleep+0x30>
    panic("sleep without lk");
80104e29:	83 ec 0c             	sub    $0xc,%esp
80104e2c:	68 a7 8f 10 80       	push   $0x80108fa7
80104e31:	e8 30 b7 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104e36:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104e3d:	74 1e                	je     80104e5d <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104e3f:	83 ec 0c             	sub    $0xc,%esp
80104e42:	68 80 39 11 80       	push   $0x80113980
80104e47:	e8 23 04 00 00       	call   8010526f <acquire>
80104e4c:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104e4f:	83 ec 0c             	sub    $0xc,%esp
80104e52:	ff 75 0c             	pushl  0xc(%ebp)
80104e55:	e8 7c 04 00 00       	call   801052d6 <release>
80104e5a:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104e5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e63:	8b 55 08             	mov    0x8(%ebp),%edx
80104e66:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104e69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e6f:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104e76:	e8 63 fe ff ff       	call   80104cde <sched>

  // Tidy up.
  proc->chan = 0;
80104e7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e81:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104e88:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104e8f:	74 1e                	je     80104eaf <sleep+0xa9>
    release(&ptable.lock);
80104e91:	83 ec 0c             	sub    $0xc,%esp
80104e94:	68 80 39 11 80       	push   $0x80113980
80104e99:	e8 38 04 00 00       	call   801052d6 <release>
80104e9e:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104ea1:	83 ec 0c             	sub    $0xc,%esp
80104ea4:	ff 75 0c             	pushl  0xc(%ebp)
80104ea7:	e8 c3 03 00 00       	call   8010526f <acquire>
80104eac:	83 c4 10             	add    $0x10,%esp
  }
}
80104eaf:	90                   	nop
80104eb0:	c9                   	leave  
80104eb1:	c3                   	ret    

80104eb2 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104eb2:	55                   	push   %ebp
80104eb3:	89 e5                	mov    %esp,%ebp
80104eb5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104eb8:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104ebf:	eb 27                	jmp    80104ee8 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ec4:	8b 40 0c             	mov    0xc(%eax),%eax
80104ec7:	83 f8 02             	cmp    $0x2,%eax
80104eca:	75 15                	jne    80104ee1 <wakeup1+0x2f>
80104ecc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ecf:	8b 40 20             	mov    0x20(%eax),%eax
80104ed2:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ed5:	75 0a                	jne    80104ee1 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104eda:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ee1:	81 45 fc 88 00 00 00 	addl   $0x88,-0x4(%ebp)
80104ee8:	81 7d fc b4 5b 11 80 	cmpl   $0x80115bb4,-0x4(%ebp)
80104eef:	72 d0                	jb     80104ec1 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104ef1:	90                   	nop
80104ef2:	c9                   	leave  
80104ef3:	c3                   	ret    

80104ef4 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104efa:	83 ec 0c             	sub    $0xc,%esp
80104efd:	68 80 39 11 80       	push   $0x80113980
80104f02:	e8 68 03 00 00       	call   8010526f <acquire>
80104f07:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104f0a:	83 ec 0c             	sub    $0xc,%esp
80104f0d:	ff 75 08             	pushl  0x8(%ebp)
80104f10:	e8 9d ff ff ff       	call   80104eb2 <wakeup1>
80104f15:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104f18:	83 ec 0c             	sub    $0xc,%esp
80104f1b:	68 80 39 11 80       	push   $0x80113980
80104f20:	e8 b1 03 00 00       	call   801052d6 <release>
80104f25:	83 c4 10             	add    $0x10,%esp
}
80104f28:	90                   	nop
80104f29:	c9                   	leave  
80104f2a:	c3                   	ret    

80104f2b <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104f2b:	55                   	push   %ebp
80104f2c:	89 e5                	mov    %esp,%ebp
80104f2e:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104f31:	83 ec 0c             	sub    $0xc,%esp
80104f34:	68 80 39 11 80       	push   $0x80113980
80104f39:	e8 31 03 00 00       	call   8010526f <acquire>
80104f3e:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f41:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104f48:	eb 48                	jmp    80104f92 <kill+0x67>
    if(p->pid == pid){
80104f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4d:	8b 40 10             	mov    0x10(%eax),%eax
80104f50:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f53:	75 36                	jne    80104f8b <kill+0x60>
      p->killed = 1;
80104f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f58:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f62:	8b 40 0c             	mov    0xc(%eax),%eax
80104f65:	83 f8 02             	cmp    $0x2,%eax
80104f68:	75 0a                	jne    80104f74 <kill+0x49>
        p->state = RUNNABLE;
80104f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f6d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104f74:	83 ec 0c             	sub    $0xc,%esp
80104f77:	68 80 39 11 80       	push   $0x80113980
80104f7c:	e8 55 03 00 00       	call   801052d6 <release>
80104f81:	83 c4 10             	add    $0x10,%esp
      return 0;
80104f84:	b8 00 00 00 00       	mov    $0x0,%eax
80104f89:	eb 25                	jmp    80104fb0 <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f8b:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104f92:	81 7d f4 b4 5b 11 80 	cmpl   $0x80115bb4,-0xc(%ebp)
80104f99:	72 af                	jb     80104f4a <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104f9b:	83 ec 0c             	sub    $0xc,%esp
80104f9e:	68 80 39 11 80       	push   $0x80113980
80104fa3:	e8 2e 03 00 00       	call   801052d6 <release>
80104fa8:	83 c4 10             	add    $0x10,%esp
  return -1;
80104fab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fb0:	c9                   	leave  
80104fb1:	c3                   	ret    

80104fb2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104fb2:	55                   	push   %ebp
80104fb3:	89 e5                	mov    %esp,%ebp
80104fb5:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fb8:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80104fbf:	e9 da 00 00 00       	jmp    8010509e <procdump+0xec>
    if(p->state == UNUSED)
80104fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fc7:	8b 40 0c             	mov    0xc(%eax),%eax
80104fca:	85 c0                	test   %eax,%eax
80104fcc:	0f 84 c4 00 00 00    	je     80105096 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fd5:	8b 40 0c             	mov    0xc(%eax),%eax
80104fd8:	83 f8 05             	cmp    $0x5,%eax
80104fdb:	77 23                	ja     80105000 <procdump+0x4e>
80104fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fe0:	8b 40 0c             	mov    0xc(%eax),%eax
80104fe3:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104fea:	85 c0                	test   %eax,%eax
80104fec:	74 12                	je     80105000 <procdump+0x4e>
      state = states[p->state];
80104fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ff1:	8b 40 0c             	mov    0xc(%eax),%eax
80104ff4:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104ffb:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104ffe:	eb 07                	jmp    80105007 <procdump+0x55>
    else
      state = "???";
80105000:	c7 45 ec b8 8f 10 80 	movl   $0x80108fb8,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105007:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010500a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010500d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105010:	8b 40 10             	mov    0x10(%eax),%eax
80105013:	52                   	push   %edx
80105014:	ff 75 ec             	pushl  -0x14(%ebp)
80105017:	50                   	push   %eax
80105018:	68 bc 8f 10 80       	push   $0x80108fbc
8010501d:	e8 a4 b3 ff ff       	call   801003c6 <cprintf>
80105022:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105025:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105028:	8b 40 0c             	mov    0xc(%eax),%eax
8010502b:	83 f8 02             	cmp    $0x2,%eax
8010502e:	75 54                	jne    80105084 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105030:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105033:	8b 40 1c             	mov    0x1c(%eax),%eax
80105036:	8b 40 0c             	mov    0xc(%eax),%eax
80105039:	83 c0 08             	add    $0x8,%eax
8010503c:	89 c2                	mov    %eax,%edx
8010503e:	83 ec 08             	sub    $0x8,%esp
80105041:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105044:	50                   	push   %eax
80105045:	52                   	push   %edx
80105046:	e8 dd 02 00 00       	call   80105328 <getcallerpcs>
8010504b:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010504e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105055:	eb 1c                	jmp    80105073 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80105057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010505a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010505e:	83 ec 08             	sub    $0x8,%esp
80105061:	50                   	push   %eax
80105062:	68 c5 8f 10 80       	push   $0x80108fc5
80105067:	e8 5a b3 ff ff       	call   801003c6 <cprintf>
8010506c:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010506f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105073:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105077:	7f 0b                	jg     80105084 <procdump+0xd2>
80105079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010507c:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105080:	85 c0                	test   %eax,%eax
80105082:	75 d3                	jne    80105057 <procdump+0xa5>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	68 c9 8f 10 80       	push   $0x80108fc9
8010508c:	e8 35 b3 ff ff       	call   801003c6 <cprintf>
80105091:	83 c4 10             	add    $0x10,%esp
80105094:	eb 01                	jmp    80105097 <procdump+0xe5>
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105096:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105097:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
8010509e:	81 7d f0 b4 5b 11 80 	cmpl   $0x80115bb4,-0x10(%ebp)
801050a5:	0f 82 19 ff ff ff    	jb     80104fc4 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801050ab:	90                   	nop
801050ac:	c9                   	leave  
801050ad:	c3                   	ret    

801050ae <signal_deliver>:

void signal_deliver(int signum,siginfo_t si)
{
801050ae:	55                   	push   %ebp
801050af:	89 e5                	mov    %esp,%ebp
801050b1:	83 ec 10             	sub    $0x10,%esp
	uint old_eip = proc->tf->eip;
801050b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050ba:	8b 40 18             	mov    0x18(%eax),%eax
801050bd:	8b 40 38             	mov    0x38(%eax),%eax
801050c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	*((uint*)(proc->tf->esp - 4))  = (uint) old_eip;		// real return address
801050c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050c9:	8b 40 18             	mov    0x18(%eax),%eax
801050cc:	8b 40 44             	mov    0x44(%eax),%eax
801050cf:	83 e8 04             	sub    $0x4,%eax
801050d2:	89 c2                	mov    %eax,%edx
801050d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050d7:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 8))  = proc->tf->eax;			// eax
801050d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050df:	8b 40 18             	mov    0x18(%eax),%eax
801050e2:	8b 40 44             	mov    0x44(%eax),%eax
801050e5:	83 e8 08             	sub    $0x8,%eax
801050e8:	89 c2                	mov    %eax,%edx
801050ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050f0:	8b 40 18             	mov    0x18(%eax),%eax
801050f3:	8b 40 1c             	mov    0x1c(%eax),%eax
801050f6:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 12)) = proc->tf->ecx;			// ecx
801050f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050fe:	8b 40 18             	mov    0x18(%eax),%eax
80105101:	8b 40 44             	mov    0x44(%eax),%eax
80105104:	83 e8 0c             	sub    $0xc,%eax
80105107:	89 c2                	mov    %eax,%edx
80105109:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010510f:	8b 40 18             	mov    0x18(%eax),%eax
80105112:	8b 40 18             	mov    0x18(%eax),%eax
80105115:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 16)) = proc->tf->edx;			// edx
80105117:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010511d:	8b 40 18             	mov    0x18(%eax),%eax
80105120:	8b 40 44             	mov    0x44(%eax),%eax
80105123:	83 e8 10             	sub    $0x10,%eax
80105126:	89 c2                	mov    %eax,%edx
80105128:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010512e:	8b 40 18             	mov    0x18(%eax),%eax
80105131:	8b 40 14             	mov    0x14(%eax),%eax
80105134:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 20)) = si.type;       //address mem fault occured
80105136:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010513c:	8b 40 18             	mov    0x18(%eax),%eax
8010513f:	8b 40 44             	mov    0x44(%eax),%eax
80105142:	83 e8 14             	sub    $0x14,%eax
80105145:	89 c2                	mov    %eax,%edx
80105147:	8b 45 10             	mov    0x10(%ebp),%eax
8010514a:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 24)) = si.addr;       //address mem fault occured
8010514c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105152:	8b 40 18             	mov    0x18(%eax),%eax
80105155:	8b 40 44             	mov    0x44(%eax),%eax
80105158:	83 e8 18             	sub    $0x18,%eax
8010515b:	89 c2                	mov    %eax,%edx
8010515d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105160:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 28)) = (uint) signum;			// signal number
80105162:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105168:	8b 40 18             	mov    0x18(%eax),%eax
8010516b:	8b 40 44             	mov    0x44(%eax),%eax
8010516e:	83 e8 1c             	sub    $0x1c,%eax
80105171:	89 c2                	mov    %eax,%edx
80105173:	8b 45 08             	mov    0x8(%ebp),%eax
80105176:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 32)) = proc->restorer_addr;	// address of restorer
80105178:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010517e:	8b 40 18             	mov    0x18(%eax),%eax
80105181:	8b 40 44             	mov    0x44(%eax),%eax
80105184:	83 e8 20             	sub    $0x20,%eax
80105187:	89 c2                	mov    %eax,%edx
80105189:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010518f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105195:	89 02                	mov    %eax,(%edx)
	proc->tf->esp -= 32;
80105197:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010519d:	8b 40 18             	mov    0x18(%eax),%eax
801051a0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051a7:	8b 52 18             	mov    0x18(%edx),%edx
801051aa:	8b 52 44             	mov    0x44(%edx),%edx
801051ad:	83 ea 20             	sub    $0x20,%edx
801051b0:	89 50 44             	mov    %edx,0x44(%eax)
	proc->tf->eip = (uint) proc->handlers[signum];
801051b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051b9:	8b 40 18             	mov    0x18(%eax),%eax
801051bc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051c6:	83 c1 1c             	add    $0x1c,%ecx
801051c9:	8b 54 8a 0c          	mov    0xc(%edx,%ecx,4),%edx
801051cd:	89 50 38             	mov    %edx,0x38(%eax)
}
801051d0:	90                   	nop
801051d1:	c9                   	leave  
801051d2:	c3                   	ret    

801051d3 <signal_register_handler>:



sighandler_t signal_register_handler(int signum, sighandler_t handler)
{
801051d3:	55                   	push   %ebp
801051d4:	89 e5                	mov    %esp,%ebp
801051d6:	83 ec 10             	sub    $0x10,%esp
	if (!proc)
801051d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051df:	85 c0                	test   %eax,%eax
801051e1:	75 07                	jne    801051ea <signal_register_handler+0x17>
		return (sighandler_t) -1;
801051e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e8:	eb 29                	jmp    80105213 <signal_register_handler+0x40>

	sighandler_t previous = proc->handlers[signum];
801051ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051f0:	8b 55 08             	mov    0x8(%ebp),%edx
801051f3:	83 c2 1c             	add    $0x1c,%edx
801051f6:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801051fa:	89 45 fc             	mov    %eax,-0x4(%ebp)

	proc->handlers[signum] = handler;
801051fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105203:	8b 55 08             	mov    0x8(%ebp),%edx
80105206:	8d 4a 1c             	lea    0x1c(%edx),%ecx
80105209:	8b 55 0c             	mov    0xc(%ebp),%edx
8010520c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)

	return previous;
80105210:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105213:	c9                   	leave  
80105214:	c3                   	ret    

80105215 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105215:	55                   	push   %ebp
80105216:	89 e5                	mov    %esp,%ebp
80105218:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010521b:	9c                   	pushf  
8010521c:	58                   	pop    %eax
8010521d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105220:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105223:	c9                   	leave  
80105224:	c3                   	ret    

80105225 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105225:	55                   	push   %ebp
80105226:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105228:	fa                   	cli    
}
80105229:	90                   	nop
8010522a:	5d                   	pop    %ebp
8010522b:	c3                   	ret    

8010522c <sti>:

static inline void
sti(void)
{
8010522c:	55                   	push   %ebp
8010522d:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010522f:	fb                   	sti    
}
80105230:	90                   	nop
80105231:	5d                   	pop    %ebp
80105232:	c3                   	ret    

80105233 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105233:	55                   	push   %ebp
80105234:	89 e5                	mov    %esp,%ebp
80105236:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105239:	8b 55 08             	mov    0x8(%ebp),%edx
8010523c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010523f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105242:	f0 87 02             	lock xchg %eax,(%edx)
80105245:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105248:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010524b:	c9                   	leave  
8010524c:	c3                   	ret    

8010524d <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010524d:	55                   	push   %ebp
8010524e:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105250:	8b 45 08             	mov    0x8(%ebp),%eax
80105253:	8b 55 0c             	mov    0xc(%ebp),%edx
80105256:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105259:	8b 45 08             	mov    0x8(%ebp),%eax
8010525c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105262:	8b 45 08             	mov    0x8(%ebp),%eax
80105265:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010526c:	90                   	nop
8010526d:	5d                   	pop    %ebp
8010526e:	c3                   	ret    

8010526f <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010526f:	55                   	push   %ebp
80105270:	89 e5                	mov    %esp,%ebp
80105272:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105275:	e8 52 01 00 00       	call   801053cc <pushcli>
  if(holding(lk))
8010527a:	8b 45 08             	mov    0x8(%ebp),%eax
8010527d:	83 ec 0c             	sub    $0xc,%esp
80105280:	50                   	push   %eax
80105281:	e8 1c 01 00 00       	call   801053a2 <holding>
80105286:	83 c4 10             	add    $0x10,%esp
80105289:	85 c0                	test   %eax,%eax
8010528b:	74 0d                	je     8010529a <acquire+0x2b>
    panic("acquire");
8010528d:	83 ec 0c             	sub    $0xc,%esp
80105290:	68 f5 8f 10 80       	push   $0x80108ff5
80105295:	e8 cc b2 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010529a:	90                   	nop
8010529b:	8b 45 08             	mov    0x8(%ebp),%eax
8010529e:	83 ec 08             	sub    $0x8,%esp
801052a1:	6a 01                	push   $0x1
801052a3:	50                   	push   %eax
801052a4:	e8 8a ff ff ff       	call   80105233 <xchg>
801052a9:	83 c4 10             	add    $0x10,%esp
801052ac:	85 c0                	test   %eax,%eax
801052ae:	75 eb                	jne    8010529b <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801052b0:	8b 45 08             	mov    0x8(%ebp),%eax
801052b3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801052ba:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801052bd:	8b 45 08             	mov    0x8(%ebp),%eax
801052c0:	83 c0 0c             	add    $0xc,%eax
801052c3:	83 ec 08             	sub    $0x8,%esp
801052c6:	50                   	push   %eax
801052c7:	8d 45 08             	lea    0x8(%ebp),%eax
801052ca:	50                   	push   %eax
801052cb:	e8 58 00 00 00       	call   80105328 <getcallerpcs>
801052d0:	83 c4 10             	add    $0x10,%esp
}
801052d3:	90                   	nop
801052d4:	c9                   	leave  
801052d5:	c3                   	ret    

801052d6 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801052d6:	55                   	push   %ebp
801052d7:	89 e5                	mov    %esp,%ebp
801052d9:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801052dc:	83 ec 0c             	sub    $0xc,%esp
801052df:	ff 75 08             	pushl  0x8(%ebp)
801052e2:	e8 bb 00 00 00       	call   801053a2 <holding>
801052e7:	83 c4 10             	add    $0x10,%esp
801052ea:	85 c0                	test   %eax,%eax
801052ec:	75 0d                	jne    801052fb <release+0x25>
    panic("release");
801052ee:	83 ec 0c             	sub    $0xc,%esp
801052f1:	68 fd 8f 10 80       	push   $0x80108ffd
801052f6:	e8 6b b2 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801052fb:	8b 45 08             	mov    0x8(%ebp),%eax
801052fe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105305:	8b 45 08             	mov    0x8(%ebp),%eax
80105308:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010530f:	8b 45 08             	mov    0x8(%ebp),%eax
80105312:	83 ec 08             	sub    $0x8,%esp
80105315:	6a 00                	push   $0x0
80105317:	50                   	push   %eax
80105318:	e8 16 ff ff ff       	call   80105233 <xchg>
8010531d:	83 c4 10             	add    $0x10,%esp

  popcli();
80105320:	e8 ec 00 00 00       	call   80105411 <popcli>
}
80105325:	90                   	nop
80105326:	c9                   	leave  
80105327:	c3                   	ret    

80105328 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105328:	55                   	push   %ebp
80105329:	89 e5                	mov    %esp,%ebp
8010532b:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010532e:	8b 45 08             	mov    0x8(%ebp),%eax
80105331:	83 e8 08             	sub    $0x8,%eax
80105334:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105337:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010533e:	eb 38                	jmp    80105378 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105340:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105344:	74 53                	je     80105399 <getcallerpcs+0x71>
80105346:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010534d:	76 4a                	jbe    80105399 <getcallerpcs+0x71>
8010534f:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105353:	74 44                	je     80105399 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105355:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105358:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010535f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105362:	01 c2                	add    %eax,%edx
80105364:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105367:	8b 40 04             	mov    0x4(%eax),%eax
8010536a:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010536c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010536f:	8b 00                	mov    (%eax),%eax
80105371:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105374:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105378:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010537c:	7e c2                	jle    80105340 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010537e:	eb 19                	jmp    80105399 <getcallerpcs+0x71>
    pcs[i] = 0;
80105380:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105383:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010538a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010538d:	01 d0                	add    %edx,%eax
8010538f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105395:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105399:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010539d:	7e e1                	jle    80105380 <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010539f:	90                   	nop
801053a0:	c9                   	leave  
801053a1:	c3                   	ret    

801053a2 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801053a2:	55                   	push   %ebp
801053a3:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801053a5:	8b 45 08             	mov    0x8(%ebp),%eax
801053a8:	8b 00                	mov    (%eax),%eax
801053aa:	85 c0                	test   %eax,%eax
801053ac:	74 17                	je     801053c5 <holding+0x23>
801053ae:	8b 45 08             	mov    0x8(%ebp),%eax
801053b1:	8b 50 08             	mov    0x8(%eax),%edx
801053b4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053ba:	39 c2                	cmp    %eax,%edx
801053bc:	75 07                	jne    801053c5 <holding+0x23>
801053be:	b8 01 00 00 00       	mov    $0x1,%eax
801053c3:	eb 05                	jmp    801053ca <holding+0x28>
801053c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053ca:	5d                   	pop    %ebp
801053cb:	c3                   	ret    

801053cc <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801053cc:	55                   	push   %ebp
801053cd:	89 e5                	mov    %esp,%ebp
801053cf:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801053d2:	e8 3e fe ff ff       	call   80105215 <readeflags>
801053d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801053da:	e8 46 fe ff ff       	call   80105225 <cli>
  if(cpu->ncli++ == 0)
801053df:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801053e6:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801053ec:	8d 48 01             	lea    0x1(%eax),%ecx
801053ef:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801053f5:	85 c0                	test   %eax,%eax
801053f7:	75 15                	jne    8010540e <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801053f9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105402:	81 e2 00 02 00 00    	and    $0x200,%edx
80105408:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010540e:	90                   	nop
8010540f:	c9                   	leave  
80105410:	c3                   	ret    

80105411 <popcli>:

void
popcli(void)
{
80105411:	55                   	push   %ebp
80105412:	89 e5                	mov    %esp,%ebp
80105414:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105417:	e8 f9 fd ff ff       	call   80105215 <readeflags>
8010541c:	25 00 02 00 00       	and    $0x200,%eax
80105421:	85 c0                	test   %eax,%eax
80105423:	74 0d                	je     80105432 <popcli+0x21>
    panic("popcli - interruptible");
80105425:	83 ec 0c             	sub    $0xc,%esp
80105428:	68 05 90 10 80       	push   $0x80109005
8010542d:	e8 34 b1 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80105432:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105438:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010543e:	83 ea 01             	sub    $0x1,%edx
80105441:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105447:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010544d:	85 c0                	test   %eax,%eax
8010544f:	79 0d                	jns    8010545e <popcli+0x4d>
    panic("popcli");
80105451:	83 ec 0c             	sub    $0xc,%esp
80105454:	68 1c 90 10 80       	push   $0x8010901c
80105459:	e8 08 b1 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010545e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105464:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010546a:	85 c0                	test   %eax,%eax
8010546c:	75 15                	jne    80105483 <popcli+0x72>
8010546e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105474:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010547a:	85 c0                	test   %eax,%eax
8010547c:	74 05                	je     80105483 <popcli+0x72>
    sti();
8010547e:	e8 a9 fd ff ff       	call   8010522c <sti>
}
80105483:	90                   	nop
80105484:	c9                   	leave  
80105485:	c3                   	ret    

80105486 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105486:	55                   	push   %ebp
80105487:	89 e5                	mov    %esp,%ebp
80105489:	57                   	push   %edi
8010548a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010548b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010548e:	8b 55 10             	mov    0x10(%ebp),%edx
80105491:	8b 45 0c             	mov    0xc(%ebp),%eax
80105494:	89 cb                	mov    %ecx,%ebx
80105496:	89 df                	mov    %ebx,%edi
80105498:	89 d1                	mov    %edx,%ecx
8010549a:	fc                   	cld    
8010549b:	f3 aa                	rep stos %al,%es:(%edi)
8010549d:	89 ca                	mov    %ecx,%edx
8010549f:	89 fb                	mov    %edi,%ebx
801054a1:	89 5d 08             	mov    %ebx,0x8(%ebp)
801054a4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801054a7:	90                   	nop
801054a8:	5b                   	pop    %ebx
801054a9:	5f                   	pop    %edi
801054aa:	5d                   	pop    %ebp
801054ab:	c3                   	ret    

801054ac <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801054ac:	55                   	push   %ebp
801054ad:	89 e5                	mov    %esp,%ebp
801054af:	57                   	push   %edi
801054b0:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801054b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054b4:	8b 55 10             	mov    0x10(%ebp),%edx
801054b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ba:	89 cb                	mov    %ecx,%ebx
801054bc:	89 df                	mov    %ebx,%edi
801054be:	89 d1                	mov    %edx,%ecx
801054c0:	fc                   	cld    
801054c1:	f3 ab                	rep stos %eax,%es:(%edi)
801054c3:	89 ca                	mov    %ecx,%edx
801054c5:	89 fb                	mov    %edi,%ebx
801054c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
801054ca:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801054cd:	90                   	nop
801054ce:	5b                   	pop    %ebx
801054cf:	5f                   	pop    %edi
801054d0:	5d                   	pop    %ebp
801054d1:	c3                   	ret    

801054d2 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801054d2:	55                   	push   %ebp
801054d3:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801054d5:	8b 45 08             	mov    0x8(%ebp),%eax
801054d8:	83 e0 03             	and    $0x3,%eax
801054db:	85 c0                	test   %eax,%eax
801054dd:	75 43                	jne    80105522 <memset+0x50>
801054df:	8b 45 10             	mov    0x10(%ebp),%eax
801054e2:	83 e0 03             	and    $0x3,%eax
801054e5:	85 c0                	test   %eax,%eax
801054e7:	75 39                	jne    80105522 <memset+0x50>
    c &= 0xFF;
801054e9:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801054f0:	8b 45 10             	mov    0x10(%ebp),%eax
801054f3:	c1 e8 02             	shr    $0x2,%eax
801054f6:	89 c1                	mov    %eax,%ecx
801054f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801054fb:	c1 e0 18             	shl    $0x18,%eax
801054fe:	89 c2                	mov    %eax,%edx
80105500:	8b 45 0c             	mov    0xc(%ebp),%eax
80105503:	c1 e0 10             	shl    $0x10,%eax
80105506:	09 c2                	or     %eax,%edx
80105508:	8b 45 0c             	mov    0xc(%ebp),%eax
8010550b:	c1 e0 08             	shl    $0x8,%eax
8010550e:	09 d0                	or     %edx,%eax
80105510:	0b 45 0c             	or     0xc(%ebp),%eax
80105513:	51                   	push   %ecx
80105514:	50                   	push   %eax
80105515:	ff 75 08             	pushl  0x8(%ebp)
80105518:	e8 8f ff ff ff       	call   801054ac <stosl>
8010551d:	83 c4 0c             	add    $0xc,%esp
80105520:	eb 12                	jmp    80105534 <memset+0x62>
  } else
    stosb(dst, c, n);
80105522:	8b 45 10             	mov    0x10(%ebp),%eax
80105525:	50                   	push   %eax
80105526:	ff 75 0c             	pushl  0xc(%ebp)
80105529:	ff 75 08             	pushl  0x8(%ebp)
8010552c:	e8 55 ff ff ff       	call   80105486 <stosb>
80105531:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105534:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105537:	c9                   	leave  
80105538:	c3                   	ret    

80105539 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105539:	55                   	push   %ebp
8010553a:	89 e5                	mov    %esp,%ebp
8010553c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010553f:	8b 45 08             	mov    0x8(%ebp),%eax
80105542:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105545:	8b 45 0c             	mov    0xc(%ebp),%eax
80105548:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010554b:	eb 30                	jmp    8010557d <memcmp+0x44>
    if(*s1 != *s2)
8010554d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105550:	0f b6 10             	movzbl (%eax),%edx
80105553:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105556:	0f b6 00             	movzbl (%eax),%eax
80105559:	38 c2                	cmp    %al,%dl
8010555b:	74 18                	je     80105575 <memcmp+0x3c>
      return *s1 - *s2;
8010555d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105560:	0f b6 00             	movzbl (%eax),%eax
80105563:	0f b6 d0             	movzbl %al,%edx
80105566:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105569:	0f b6 00             	movzbl (%eax),%eax
8010556c:	0f b6 c0             	movzbl %al,%eax
8010556f:	29 c2                	sub    %eax,%edx
80105571:	89 d0                	mov    %edx,%eax
80105573:	eb 1a                	jmp    8010558f <memcmp+0x56>
    s1++, s2++;
80105575:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105579:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010557d:	8b 45 10             	mov    0x10(%ebp),%eax
80105580:	8d 50 ff             	lea    -0x1(%eax),%edx
80105583:	89 55 10             	mov    %edx,0x10(%ebp)
80105586:	85 c0                	test   %eax,%eax
80105588:	75 c3                	jne    8010554d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010558a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010558f:	c9                   	leave  
80105590:	c3                   	ret    

80105591 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105591:	55                   	push   %ebp
80105592:	89 e5                	mov    %esp,%ebp
80105594:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105597:	8b 45 0c             	mov    0xc(%ebp),%eax
8010559a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010559d:	8b 45 08             	mov    0x8(%ebp),%eax
801055a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801055a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801055a9:	73 54                	jae    801055ff <memmove+0x6e>
801055ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055ae:	8b 45 10             	mov    0x10(%ebp),%eax
801055b1:	01 d0                	add    %edx,%eax
801055b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801055b6:	76 47                	jbe    801055ff <memmove+0x6e>
    s += n;
801055b8:	8b 45 10             	mov    0x10(%ebp),%eax
801055bb:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801055be:	8b 45 10             	mov    0x10(%ebp),%eax
801055c1:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801055c4:	eb 13                	jmp    801055d9 <memmove+0x48>
      *--d = *--s;
801055c6:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801055ca:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801055ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055d1:	0f b6 10             	movzbl (%eax),%edx
801055d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055d7:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801055d9:	8b 45 10             	mov    0x10(%ebp),%eax
801055dc:	8d 50 ff             	lea    -0x1(%eax),%edx
801055df:	89 55 10             	mov    %edx,0x10(%ebp)
801055e2:	85 c0                	test   %eax,%eax
801055e4:	75 e0                	jne    801055c6 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801055e6:	eb 24                	jmp    8010560c <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801055e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055eb:	8d 50 01             	lea    0x1(%eax),%edx
801055ee:	89 55 f8             	mov    %edx,-0x8(%ebp)
801055f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055f4:	8d 4a 01             	lea    0x1(%edx),%ecx
801055f7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801055fa:	0f b6 12             	movzbl (%edx),%edx
801055fd:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801055ff:	8b 45 10             	mov    0x10(%ebp),%eax
80105602:	8d 50 ff             	lea    -0x1(%eax),%edx
80105605:	89 55 10             	mov    %edx,0x10(%ebp)
80105608:	85 c0                	test   %eax,%eax
8010560a:	75 dc                	jne    801055e8 <memmove+0x57>
      *d++ = *s++;

  return dst;
8010560c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010560f:	c9                   	leave  
80105610:	c3                   	ret    

80105611 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105611:	55                   	push   %ebp
80105612:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105614:	ff 75 10             	pushl  0x10(%ebp)
80105617:	ff 75 0c             	pushl  0xc(%ebp)
8010561a:	ff 75 08             	pushl  0x8(%ebp)
8010561d:	e8 6f ff ff ff       	call   80105591 <memmove>
80105622:	83 c4 0c             	add    $0xc,%esp
}
80105625:	c9                   	leave  
80105626:	c3                   	ret    

80105627 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105627:	55                   	push   %ebp
80105628:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010562a:	eb 0c                	jmp    80105638 <strncmp+0x11>
    n--, p++, q++;
8010562c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105630:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105634:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105638:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010563c:	74 1a                	je     80105658 <strncmp+0x31>
8010563e:	8b 45 08             	mov    0x8(%ebp),%eax
80105641:	0f b6 00             	movzbl (%eax),%eax
80105644:	84 c0                	test   %al,%al
80105646:	74 10                	je     80105658 <strncmp+0x31>
80105648:	8b 45 08             	mov    0x8(%ebp),%eax
8010564b:	0f b6 10             	movzbl (%eax),%edx
8010564e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105651:	0f b6 00             	movzbl (%eax),%eax
80105654:	38 c2                	cmp    %al,%dl
80105656:	74 d4                	je     8010562c <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105658:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010565c:	75 07                	jne    80105665 <strncmp+0x3e>
    return 0;
8010565e:	b8 00 00 00 00       	mov    $0x0,%eax
80105663:	eb 16                	jmp    8010567b <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105665:	8b 45 08             	mov    0x8(%ebp),%eax
80105668:	0f b6 00             	movzbl (%eax),%eax
8010566b:	0f b6 d0             	movzbl %al,%edx
8010566e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105671:	0f b6 00             	movzbl (%eax),%eax
80105674:	0f b6 c0             	movzbl %al,%eax
80105677:	29 c2                	sub    %eax,%edx
80105679:	89 d0                	mov    %edx,%eax
}
8010567b:	5d                   	pop    %ebp
8010567c:	c3                   	ret    

8010567d <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010567d:	55                   	push   %ebp
8010567e:	89 e5                	mov    %esp,%ebp
80105680:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105683:	8b 45 08             	mov    0x8(%ebp),%eax
80105686:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105689:	90                   	nop
8010568a:	8b 45 10             	mov    0x10(%ebp),%eax
8010568d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105690:	89 55 10             	mov    %edx,0x10(%ebp)
80105693:	85 c0                	test   %eax,%eax
80105695:	7e 2c                	jle    801056c3 <strncpy+0x46>
80105697:	8b 45 08             	mov    0x8(%ebp),%eax
8010569a:	8d 50 01             	lea    0x1(%eax),%edx
8010569d:	89 55 08             	mov    %edx,0x8(%ebp)
801056a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801056a3:	8d 4a 01             	lea    0x1(%edx),%ecx
801056a6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801056a9:	0f b6 12             	movzbl (%edx),%edx
801056ac:	88 10                	mov    %dl,(%eax)
801056ae:	0f b6 00             	movzbl (%eax),%eax
801056b1:	84 c0                	test   %al,%al
801056b3:	75 d5                	jne    8010568a <strncpy+0xd>
    ;
  while(n-- > 0)
801056b5:	eb 0c                	jmp    801056c3 <strncpy+0x46>
    *s++ = 0;
801056b7:	8b 45 08             	mov    0x8(%ebp),%eax
801056ba:	8d 50 01             	lea    0x1(%eax),%edx
801056bd:	89 55 08             	mov    %edx,0x8(%ebp)
801056c0:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801056c3:	8b 45 10             	mov    0x10(%ebp),%eax
801056c6:	8d 50 ff             	lea    -0x1(%eax),%edx
801056c9:	89 55 10             	mov    %edx,0x10(%ebp)
801056cc:	85 c0                	test   %eax,%eax
801056ce:	7f e7                	jg     801056b7 <strncpy+0x3a>
    *s++ = 0;
  return os;
801056d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801056d3:	c9                   	leave  
801056d4:	c3                   	ret    

801056d5 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801056d5:	55                   	push   %ebp
801056d6:	89 e5                	mov    %esp,%ebp
801056d8:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801056db:	8b 45 08             	mov    0x8(%ebp),%eax
801056de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801056e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056e5:	7f 05                	jg     801056ec <safestrcpy+0x17>
    return os;
801056e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056ea:	eb 31                	jmp    8010571d <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801056ec:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801056f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056f4:	7e 1e                	jle    80105714 <safestrcpy+0x3f>
801056f6:	8b 45 08             	mov    0x8(%ebp),%eax
801056f9:	8d 50 01             	lea    0x1(%eax),%edx
801056fc:	89 55 08             	mov    %edx,0x8(%ebp)
801056ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80105702:	8d 4a 01             	lea    0x1(%edx),%ecx
80105705:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105708:	0f b6 12             	movzbl (%edx),%edx
8010570b:	88 10                	mov    %dl,(%eax)
8010570d:	0f b6 00             	movzbl (%eax),%eax
80105710:	84 c0                	test   %al,%al
80105712:	75 d8                	jne    801056ec <safestrcpy+0x17>
    ;
  *s = 0;
80105714:	8b 45 08             	mov    0x8(%ebp),%eax
80105717:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010571a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010571d:	c9                   	leave  
8010571e:	c3                   	ret    

8010571f <strlen>:

int
strlen(const char *s)
{
8010571f:	55                   	push   %ebp
80105720:	89 e5                	mov    %esp,%ebp
80105722:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105725:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010572c:	eb 04                	jmp    80105732 <strlen+0x13>
8010572e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105732:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105735:	8b 45 08             	mov    0x8(%ebp),%eax
80105738:	01 d0                	add    %edx,%eax
8010573a:	0f b6 00             	movzbl (%eax),%eax
8010573d:	84 c0                	test   %al,%al
8010573f:	75 ed                	jne    8010572e <strlen+0xf>
    ;
  return n;
80105741:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105744:	c9                   	leave  
80105745:	c3                   	ret    

80105746 <swtch>:
80105746:	8b 44 24 04          	mov    0x4(%esp),%eax
8010574a:	8b 54 24 08          	mov    0x8(%esp),%edx
8010574e:	55                   	push   %ebp
8010574f:	53                   	push   %ebx
80105750:	56                   	push   %esi
80105751:	57                   	push   %edi
80105752:	89 20                	mov    %esp,(%eax)
80105754:	89 d4                	mov    %edx,%esp
80105756:	5f                   	pop    %edi
80105757:	5e                   	pop    %esi
80105758:	5b                   	pop    %ebx
80105759:	5d                   	pop    %ebp
8010575a:	c3                   	ret    

8010575b <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010575b:	55                   	push   %ebp
8010575c:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010575e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105764:	8b 00                	mov    (%eax),%eax
80105766:	3b 45 08             	cmp    0x8(%ebp),%eax
80105769:	76 12                	jbe    8010577d <fetchint+0x22>
8010576b:	8b 45 08             	mov    0x8(%ebp),%eax
8010576e:	8d 50 04             	lea    0x4(%eax),%edx
80105771:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105777:	8b 00                	mov    (%eax),%eax
80105779:	39 c2                	cmp    %eax,%edx
8010577b:	76 07                	jbe    80105784 <fetchint+0x29>
    return -1;
8010577d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105782:	eb 0f                	jmp    80105793 <fetchint+0x38>
  *ip = *(int*)(addr);
80105784:	8b 45 08             	mov    0x8(%ebp),%eax
80105787:	8b 10                	mov    (%eax),%edx
80105789:	8b 45 0c             	mov    0xc(%ebp),%eax
8010578c:	89 10                	mov    %edx,(%eax)
  return 0;
8010578e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105793:	5d                   	pop    %ebp
80105794:	c3                   	ret    

80105795 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105795:	55                   	push   %ebp
80105796:	89 e5                	mov    %esp,%ebp
80105798:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010579b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057a1:	8b 00                	mov    (%eax),%eax
801057a3:	3b 45 08             	cmp    0x8(%ebp),%eax
801057a6:	77 07                	ja     801057af <fetchstr+0x1a>
    return -1;
801057a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ad:	eb 46                	jmp    801057f5 <fetchstr+0x60>
  *pp = (char*)addr;
801057af:	8b 55 08             	mov    0x8(%ebp),%edx
801057b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801057b5:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801057b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057bd:	8b 00                	mov    (%eax),%eax
801057bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801057c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801057c5:	8b 00                	mov    (%eax),%eax
801057c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
801057ca:	eb 1c                	jmp    801057e8 <fetchstr+0x53>
    if(*s == 0)
801057cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057cf:	0f b6 00             	movzbl (%eax),%eax
801057d2:	84 c0                	test   %al,%al
801057d4:	75 0e                	jne    801057e4 <fetchstr+0x4f>
      return s - *pp;
801057d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801057dc:	8b 00                	mov    (%eax),%eax
801057de:	29 c2                	sub    %eax,%edx
801057e0:	89 d0                	mov    %edx,%eax
801057e2:	eb 11                	jmp    801057f5 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801057e4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801057e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801057ee:	72 dc                	jb     801057cc <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801057f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057f5:	c9                   	leave  
801057f6:	c3                   	ret    

801057f7 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801057f7:	55                   	push   %ebp
801057f8:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801057fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105800:	8b 40 18             	mov    0x18(%eax),%eax
80105803:	8b 40 44             	mov    0x44(%eax),%eax
80105806:	8b 55 08             	mov    0x8(%ebp),%edx
80105809:	c1 e2 02             	shl    $0x2,%edx
8010580c:	01 d0                	add    %edx,%eax
8010580e:	83 c0 04             	add    $0x4,%eax
80105811:	ff 75 0c             	pushl  0xc(%ebp)
80105814:	50                   	push   %eax
80105815:	e8 41 ff ff ff       	call   8010575b <fetchint>
8010581a:	83 c4 08             	add    $0x8,%esp
}
8010581d:	c9                   	leave  
8010581e:	c3                   	ret    

8010581f <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010581f:	55                   	push   %ebp
80105820:	89 e5                	mov    %esp,%ebp
80105822:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(argint(n, &i) < 0)
80105825:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105828:	50                   	push   %eax
80105829:	ff 75 08             	pushl  0x8(%ebp)
8010582c:	e8 c6 ff ff ff       	call   801057f7 <argint>
80105831:	83 c4 08             	add    $0x8,%esp
80105834:	85 c0                	test   %eax,%eax
80105836:	79 07                	jns    8010583f <argptr+0x20>
    return -1;
80105838:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583d:	eb 3b                	jmp    8010587a <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010583f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105845:	8b 00                	mov    (%eax),%eax
80105847:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010584a:	39 d0                	cmp    %edx,%eax
8010584c:	76 16                	jbe    80105864 <argptr+0x45>
8010584e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105851:	89 c2                	mov    %eax,%edx
80105853:	8b 45 10             	mov    0x10(%ebp),%eax
80105856:	01 c2                	add    %eax,%edx
80105858:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010585e:	8b 00                	mov    (%eax),%eax
80105860:	39 c2                	cmp    %eax,%edx
80105862:	76 07                	jbe    8010586b <argptr+0x4c>
    return -1;
80105864:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105869:	eb 0f                	jmp    8010587a <argptr+0x5b>
  *pp = (char*)i;
8010586b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010586e:	89 c2                	mov    %eax,%edx
80105870:	8b 45 0c             	mov    0xc(%ebp),%eax
80105873:	89 10                	mov    %edx,(%eax)
  return 0;
80105875:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010587a:	c9                   	leave  
8010587b:	c3                   	ret    

8010587c <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010587c:	55                   	push   %ebp
8010587d:	89 e5                	mov    %esp,%ebp
8010587f:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105882:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105885:	50                   	push   %eax
80105886:	ff 75 08             	pushl  0x8(%ebp)
80105889:	e8 69 ff ff ff       	call   801057f7 <argint>
8010588e:	83 c4 08             	add    $0x8,%esp
80105891:	85 c0                	test   %eax,%eax
80105893:	79 07                	jns    8010589c <argstr+0x20>
    return -1;
80105895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589a:	eb 0f                	jmp    801058ab <argstr+0x2f>
  return fetchstr(addr, pp);
8010589c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010589f:	ff 75 0c             	pushl  0xc(%ebp)
801058a2:	50                   	push   %eax
801058a3:	e8 ed fe ff ff       	call   80105795 <fetchstr>
801058a8:	83 c4 08             	add    $0x8,%esp
}
801058ab:	c9                   	leave  
801058ac:	c3                   	ret    

801058ad <syscall>:
[SYS_cowfork] sys_cowfork,
};

void
syscall(void)
{
801058ad:	55                   	push   %ebp
801058ae:	89 e5                	mov    %esp,%ebp
801058b0:	53                   	push   %ebx
801058b1:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801058b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058ba:	8b 40 18             	mov    0x18(%eax),%eax
801058bd:	8b 40 1c             	mov    0x1c(%eax),%eax
801058c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801058c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058c7:	7e 30                	jle    801058f9 <syscall+0x4c>
801058c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058cc:	83 f8 1a             	cmp    $0x1a,%eax
801058cf:	77 28                	ja     801058f9 <syscall+0x4c>
801058d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058d4:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
801058db:	85 c0                	test   %eax,%eax
801058dd:	74 1a                	je     801058f9 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801058df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058e5:	8b 58 18             	mov    0x18(%eax),%ebx
801058e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058eb:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
801058f2:	ff d0                	call   *%eax
801058f4:	89 43 1c             	mov    %eax,0x1c(%ebx)
801058f7:	eb 34                	jmp    8010592d <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801058f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058ff:	8d 50 6c             	lea    0x6c(%eax),%edx
80105902:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105908:	8b 40 10             	mov    0x10(%eax),%eax
8010590b:	ff 75 f4             	pushl  -0xc(%ebp)
8010590e:	52                   	push   %edx
8010590f:	50                   	push   %eax
80105910:	68 23 90 10 80       	push   $0x80109023
80105915:	e8 ac aa ff ff       	call   801003c6 <cprintf>
8010591a:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010591d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105923:	8b 40 18             	mov    0x18(%eax),%eax
80105926:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010592d:	90                   	nop
8010592e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105931:	c9                   	leave  
80105932:	c3                   	ret    

80105933 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105933:	55                   	push   %ebp
80105934:	89 e5                	mov    %esp,%ebp
80105936:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105939:	83 ec 08             	sub    $0x8,%esp
8010593c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010593f:	50                   	push   %eax
80105940:	ff 75 08             	pushl  0x8(%ebp)
80105943:	e8 af fe ff ff       	call   801057f7 <argint>
80105948:	83 c4 10             	add    $0x10,%esp
8010594b:	85 c0                	test   %eax,%eax
8010594d:	79 07                	jns    80105956 <argfd+0x23>
    return -1;
8010594f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105954:	eb 50                	jmp    801059a6 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105956:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105959:	85 c0                	test   %eax,%eax
8010595b:	78 21                	js     8010597e <argfd+0x4b>
8010595d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105960:	83 f8 0f             	cmp    $0xf,%eax
80105963:	7f 19                	jg     8010597e <argfd+0x4b>
80105965:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010596b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010596e:	83 c2 08             	add    $0x8,%edx
80105971:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105975:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010597c:	75 07                	jne    80105985 <argfd+0x52>
    return -1;
8010597e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105983:	eb 21                	jmp    801059a6 <argfd+0x73>
  if(pfd)
80105985:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105989:	74 08                	je     80105993 <argfd+0x60>
    *pfd = fd;
8010598b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010598e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105991:	89 10                	mov    %edx,(%eax)
  if(pf)
80105993:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105997:	74 08                	je     801059a1 <argfd+0x6e>
    *pf = f;
80105999:	8b 45 10             	mov    0x10(%ebp),%eax
8010599c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010599f:	89 10                	mov    %edx,(%eax)
  return 0;
801059a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059a6:	c9                   	leave  
801059a7:	c3                   	ret    

801059a8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801059a8:	55                   	push   %ebp
801059a9:	89 e5                	mov    %esp,%ebp
801059ab:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801059ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801059b5:	eb 30                	jmp    801059e7 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801059b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059c0:	83 c2 08             	add    $0x8,%edx
801059c3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801059c7:	85 c0                	test   %eax,%eax
801059c9:	75 18                	jne    801059e3 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801059cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059d4:	8d 4a 08             	lea    0x8(%edx),%ecx
801059d7:	8b 55 08             	mov    0x8(%ebp),%edx
801059da:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801059de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059e1:	eb 0f                	jmp    801059f2 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801059e3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801059e7:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801059eb:	7e ca                	jle    801059b7 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801059ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f2:	c9                   	leave  
801059f3:	c3                   	ret    

801059f4 <sys_dup>:

int
sys_dup(void)
{
801059f4:	55                   	push   %ebp
801059f5:	89 e5                	mov    %esp,%ebp
801059f7:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801059fa:	83 ec 04             	sub    $0x4,%esp
801059fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a00:	50                   	push   %eax
80105a01:	6a 00                	push   $0x0
80105a03:	6a 00                	push   $0x0
80105a05:	e8 29 ff ff ff       	call   80105933 <argfd>
80105a0a:	83 c4 10             	add    $0x10,%esp
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	79 07                	jns    80105a18 <sys_dup+0x24>
    return -1;
80105a11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a16:	eb 31                	jmp    80105a49 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1b:	83 ec 0c             	sub    $0xc,%esp
80105a1e:	50                   	push   %eax
80105a1f:	e8 84 ff ff ff       	call   801059a8 <fdalloc>
80105a24:	83 c4 10             	add    $0x10,%esp
80105a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a2e:	79 07                	jns    80105a37 <sys_dup+0x43>
    return -1;
80105a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a35:	eb 12                	jmp    80105a49 <sys_dup+0x55>
  filedup(f);
80105a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a3a:	83 ec 0c             	sub    $0xc,%esp
80105a3d:	50                   	push   %eax
80105a3e:	e8 a2 b5 ff ff       	call   80100fe5 <filedup>
80105a43:	83 c4 10             	add    $0x10,%esp
  return fd;
80105a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105a49:	c9                   	leave  
80105a4a:	c3                   	ret    

80105a4b <sys_read>:

int
sys_read(void)
{
80105a4b:	55                   	push   %ebp
80105a4c:	89 e5                	mov    %esp,%ebp
80105a4e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a51:	83 ec 04             	sub    $0x4,%esp
80105a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a57:	50                   	push   %eax
80105a58:	6a 00                	push   $0x0
80105a5a:	6a 00                	push   $0x0
80105a5c:	e8 d2 fe ff ff       	call   80105933 <argfd>
80105a61:	83 c4 10             	add    $0x10,%esp
80105a64:	85 c0                	test   %eax,%eax
80105a66:	78 2e                	js     80105a96 <sys_read+0x4b>
80105a68:	83 ec 08             	sub    $0x8,%esp
80105a6b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a6e:	50                   	push   %eax
80105a6f:	6a 02                	push   $0x2
80105a71:	e8 81 fd ff ff       	call   801057f7 <argint>
80105a76:	83 c4 10             	add    $0x10,%esp
80105a79:	85 c0                	test   %eax,%eax
80105a7b:	78 19                	js     80105a96 <sys_read+0x4b>
80105a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a80:	83 ec 04             	sub    $0x4,%esp
80105a83:	50                   	push   %eax
80105a84:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a87:	50                   	push   %eax
80105a88:	6a 01                	push   $0x1
80105a8a:	e8 90 fd ff ff       	call   8010581f <argptr>
80105a8f:	83 c4 10             	add    $0x10,%esp
80105a92:	85 c0                	test   %eax,%eax
80105a94:	79 07                	jns    80105a9d <sys_read+0x52>
    return -1;
80105a96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9b:	eb 17                	jmp    80105ab4 <sys_read+0x69>
  return fileread(f, p, n);
80105a9d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105aa0:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa6:	83 ec 04             	sub    $0x4,%esp
80105aa9:	51                   	push   %ecx
80105aaa:	52                   	push   %edx
80105aab:	50                   	push   %eax
80105aac:	e8 c4 b6 ff ff       	call   80101175 <fileread>
80105ab1:	83 c4 10             	add    $0x10,%esp
}
80105ab4:	c9                   	leave  
80105ab5:	c3                   	ret    

80105ab6 <sys_write>:

int
sys_write(void)
{
80105ab6:	55                   	push   %ebp
80105ab7:	89 e5                	mov    %esp,%ebp
80105ab9:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105abc:	83 ec 04             	sub    $0x4,%esp
80105abf:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac2:	50                   	push   %eax
80105ac3:	6a 00                	push   $0x0
80105ac5:	6a 00                	push   $0x0
80105ac7:	e8 67 fe ff ff       	call   80105933 <argfd>
80105acc:	83 c4 10             	add    $0x10,%esp
80105acf:	85 c0                	test   %eax,%eax
80105ad1:	78 2e                	js     80105b01 <sys_write+0x4b>
80105ad3:	83 ec 08             	sub    $0x8,%esp
80105ad6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad9:	50                   	push   %eax
80105ada:	6a 02                	push   $0x2
80105adc:	e8 16 fd ff ff       	call   801057f7 <argint>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	78 19                	js     80105b01 <sys_write+0x4b>
80105ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aeb:	83 ec 04             	sub    $0x4,%esp
80105aee:	50                   	push   %eax
80105aef:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105af2:	50                   	push   %eax
80105af3:	6a 01                	push   $0x1
80105af5:	e8 25 fd ff ff       	call   8010581f <argptr>
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	85 c0                	test   %eax,%eax
80105aff:	79 07                	jns    80105b08 <sys_write+0x52>
    return -1;
80105b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b06:	eb 17                	jmp    80105b1f <sys_write+0x69>
  return filewrite(f, p, n);
80105b08:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b11:	83 ec 04             	sub    $0x4,%esp
80105b14:	51                   	push   %ecx
80105b15:	52                   	push   %edx
80105b16:	50                   	push   %eax
80105b17:	e8 11 b7 ff ff       	call   8010122d <filewrite>
80105b1c:	83 c4 10             	add    $0x10,%esp
}
80105b1f:	c9                   	leave  
80105b20:	c3                   	ret    

80105b21 <sys_close>:

int
sys_close(void)
{
80105b21:	55                   	push   %ebp
80105b22:	89 e5                	mov    %esp,%ebp
80105b24:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105b27:	83 ec 04             	sub    $0x4,%esp
80105b2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b2d:	50                   	push   %eax
80105b2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b31:	50                   	push   %eax
80105b32:	6a 00                	push   $0x0
80105b34:	e8 fa fd ff ff       	call   80105933 <argfd>
80105b39:	83 c4 10             	add    $0x10,%esp
80105b3c:	85 c0                	test   %eax,%eax
80105b3e:	79 07                	jns    80105b47 <sys_close+0x26>
    return -1;
80105b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b45:	eb 28                	jmp    80105b6f <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105b47:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b50:	83 c2 08             	add    $0x8,%edx
80105b53:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105b5a:	00 
  fileclose(f);
80105b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b5e:	83 ec 0c             	sub    $0xc,%esp
80105b61:	50                   	push   %eax
80105b62:	e8 cf b4 ff ff       	call   80101036 <fileclose>
80105b67:	83 c4 10             	add    $0x10,%esp
  return 0;
80105b6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b6f:	c9                   	leave  
80105b70:	c3                   	ret    

80105b71 <sys_fstat>:

int
sys_fstat(void)
{
80105b71:	55                   	push   %ebp
80105b72:	89 e5                	mov    %esp,%ebp
80105b74:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105b77:	83 ec 04             	sub    $0x4,%esp
80105b7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b7d:	50                   	push   %eax
80105b7e:	6a 00                	push   $0x0
80105b80:	6a 00                	push   $0x0
80105b82:	e8 ac fd ff ff       	call   80105933 <argfd>
80105b87:	83 c4 10             	add    $0x10,%esp
80105b8a:	85 c0                	test   %eax,%eax
80105b8c:	78 17                	js     80105ba5 <sys_fstat+0x34>
80105b8e:	83 ec 04             	sub    $0x4,%esp
80105b91:	6a 14                	push   $0x14
80105b93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b96:	50                   	push   %eax
80105b97:	6a 01                	push   $0x1
80105b99:	e8 81 fc ff ff       	call   8010581f <argptr>
80105b9e:	83 c4 10             	add    $0x10,%esp
80105ba1:	85 c0                	test   %eax,%eax
80105ba3:	79 07                	jns    80105bac <sys_fstat+0x3b>
    return -1;
80105ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105baa:	eb 13                	jmp    80105bbf <sys_fstat+0x4e>
  return filestat(f, st);
80105bac:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb2:	83 ec 08             	sub    $0x8,%esp
80105bb5:	52                   	push   %edx
80105bb6:	50                   	push   %eax
80105bb7:	e8 62 b5 ff ff       	call   8010111e <filestat>
80105bbc:	83 c4 10             	add    $0x10,%esp
}
80105bbf:	c9                   	leave  
80105bc0:	c3                   	ret    

80105bc1 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105bc1:	55                   	push   %ebp
80105bc2:	89 e5                	mov    %esp,%ebp
80105bc4:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105bc7:	83 ec 08             	sub    $0x8,%esp
80105bca:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105bcd:	50                   	push   %eax
80105bce:	6a 00                	push   $0x0
80105bd0:	e8 a7 fc ff ff       	call   8010587c <argstr>
80105bd5:	83 c4 10             	add    $0x10,%esp
80105bd8:	85 c0                	test   %eax,%eax
80105bda:	78 15                	js     80105bf1 <sys_link+0x30>
80105bdc:	83 ec 08             	sub    $0x8,%esp
80105bdf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105be2:	50                   	push   %eax
80105be3:	6a 01                	push   $0x1
80105be5:	e8 92 fc ff ff       	call   8010587c <argstr>
80105bea:	83 c4 10             	add    $0x10,%esp
80105bed:	85 c0                	test   %eax,%eax
80105bef:	79 0a                	jns    80105bfb <sys_link+0x3a>
    return -1;
80105bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bf6:	e9 68 01 00 00       	jmp    80105d63 <sys_link+0x1a2>

  begin_op();
80105bfb:	e8 b4 d8 ff ff       	call   801034b4 <begin_op>
  if((ip = namei(old)) == 0){
80105c00:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105c03:	83 ec 0c             	sub    $0xc,%esp
80105c06:	50                   	push   %eax
80105c07:	e8 b7 c8 ff ff       	call   801024c3 <namei>
80105c0c:	83 c4 10             	add    $0x10,%esp
80105c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c16:	75 0f                	jne    80105c27 <sys_link+0x66>
    end_op();
80105c18:	e8 23 d9 ff ff       	call   80103540 <end_op>
    return -1;
80105c1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c22:	e9 3c 01 00 00       	jmp    80105d63 <sys_link+0x1a2>
  }

  ilock(ip);
80105c27:	83 ec 0c             	sub    $0xc,%esp
80105c2a:	ff 75 f4             	pushl  -0xc(%ebp)
80105c2d:	e8 d9 bc ff ff       	call   8010190b <ilock>
80105c32:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c38:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c3c:	66 83 f8 01          	cmp    $0x1,%ax
80105c40:	75 1d                	jne    80105c5f <sys_link+0x9e>
    iunlockput(ip);
80105c42:	83 ec 0c             	sub    $0xc,%esp
80105c45:	ff 75 f4             	pushl  -0xc(%ebp)
80105c48:	e8 78 bf ff ff       	call   80101bc5 <iunlockput>
80105c4d:	83 c4 10             	add    $0x10,%esp
    end_op();
80105c50:	e8 eb d8 ff ff       	call   80103540 <end_op>
    return -1;
80105c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c5a:	e9 04 01 00 00       	jmp    80105d63 <sys_link+0x1a2>
  }

  ip->nlink++;
80105c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c62:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c66:	83 c0 01             	add    $0x1,%eax
80105c69:	89 c2                	mov    %eax,%edx
80105c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c6e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105c72:	83 ec 0c             	sub    $0xc,%esp
80105c75:	ff 75 f4             	pushl  -0xc(%ebp)
80105c78:	e8 ba ba ff ff       	call   80101737 <iupdate>
80105c7d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	ff 75 f4             	pushl  -0xc(%ebp)
80105c86:	e8 d8 bd ff ff       	call   80101a63 <iunlock>
80105c8b:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105c8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c91:	83 ec 08             	sub    $0x8,%esp
80105c94:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105c97:	52                   	push   %edx
80105c98:	50                   	push   %eax
80105c99:	e8 41 c8 ff ff       	call   801024df <nameiparent>
80105c9e:	83 c4 10             	add    $0x10,%esp
80105ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ca4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ca8:	74 71                	je     80105d1b <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105caa:	83 ec 0c             	sub    $0xc,%esp
80105cad:	ff 75 f0             	pushl  -0x10(%ebp)
80105cb0:	e8 56 bc ff ff       	call   8010190b <ilock>
80105cb5:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cbb:	8b 10                	mov    (%eax),%edx
80105cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc0:	8b 00                	mov    (%eax),%eax
80105cc2:	39 c2                	cmp    %eax,%edx
80105cc4:	75 1d                	jne    80105ce3 <sys_link+0x122>
80105cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc9:	8b 40 04             	mov    0x4(%eax),%eax
80105ccc:	83 ec 04             	sub    $0x4,%esp
80105ccf:	50                   	push   %eax
80105cd0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105cd3:	50                   	push   %eax
80105cd4:	ff 75 f0             	pushl  -0x10(%ebp)
80105cd7:	e8 4b c5 ff ff       	call   80102227 <dirlink>
80105cdc:	83 c4 10             	add    $0x10,%esp
80105cdf:	85 c0                	test   %eax,%eax
80105ce1:	79 10                	jns    80105cf3 <sys_link+0x132>
    iunlockput(dp);
80105ce3:	83 ec 0c             	sub    $0xc,%esp
80105ce6:	ff 75 f0             	pushl  -0x10(%ebp)
80105ce9:	e8 d7 be ff ff       	call   80101bc5 <iunlockput>
80105cee:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105cf1:	eb 29                	jmp    80105d1c <sys_link+0x15b>
  }
  iunlockput(dp);
80105cf3:	83 ec 0c             	sub    $0xc,%esp
80105cf6:	ff 75 f0             	pushl  -0x10(%ebp)
80105cf9:	e8 c7 be ff ff       	call   80101bc5 <iunlockput>
80105cfe:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105d01:	83 ec 0c             	sub    $0xc,%esp
80105d04:	ff 75 f4             	pushl  -0xc(%ebp)
80105d07:	e8 c9 bd ff ff       	call   80101ad5 <iput>
80105d0c:	83 c4 10             	add    $0x10,%esp

  end_op();
80105d0f:	e8 2c d8 ff ff       	call   80103540 <end_op>

  return 0;
80105d14:	b8 00 00 00 00       	mov    $0x0,%eax
80105d19:	eb 48                	jmp    80105d63 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105d1b:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105d1c:	83 ec 0c             	sub    $0xc,%esp
80105d1f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d22:	e8 e4 bb ff ff       	call   8010190b <ilock>
80105d27:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d31:	83 e8 01             	sub    $0x1,%eax
80105d34:	89 c2                	mov    %eax,%edx
80105d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d39:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105d3d:	83 ec 0c             	sub    $0xc,%esp
80105d40:	ff 75 f4             	pushl  -0xc(%ebp)
80105d43:	e8 ef b9 ff ff       	call   80101737 <iupdate>
80105d48:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105d4b:	83 ec 0c             	sub    $0xc,%esp
80105d4e:	ff 75 f4             	pushl  -0xc(%ebp)
80105d51:	e8 6f be ff ff       	call   80101bc5 <iunlockput>
80105d56:	83 c4 10             	add    $0x10,%esp
  end_op();
80105d59:	e8 e2 d7 ff ff       	call   80103540 <end_op>
  return -1;
80105d5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d63:	c9                   	leave  
80105d64:	c3                   	ret    

80105d65 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105d65:	55                   	push   %ebp
80105d66:	89 e5                	mov    %esp,%ebp
80105d68:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d6b:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105d72:	eb 40                	jmp    80105db4 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d77:	6a 10                	push   $0x10
80105d79:	50                   	push   %eax
80105d7a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d7d:	50                   	push   %eax
80105d7e:	ff 75 08             	pushl  0x8(%ebp)
80105d81:	e8 ed c0 ff ff       	call   80101e73 <readi>
80105d86:	83 c4 10             	add    $0x10,%esp
80105d89:	83 f8 10             	cmp    $0x10,%eax
80105d8c:	74 0d                	je     80105d9b <isdirempty+0x36>
      panic("isdirempty: readi");
80105d8e:	83 ec 0c             	sub    $0xc,%esp
80105d91:	68 3f 90 10 80       	push   $0x8010903f
80105d96:	e8 cb a7 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80105d9b:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105d9f:	66 85 c0             	test   %ax,%ax
80105da2:	74 07                	je     80105dab <isdirempty+0x46>
      return 0;
80105da4:	b8 00 00 00 00       	mov    $0x0,%eax
80105da9:	eb 1b                	jmp    80105dc6 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dae:	83 c0 10             	add    $0x10,%eax
80105db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105db4:	8b 45 08             	mov    0x8(%ebp),%eax
80105db7:	8b 50 18             	mov    0x18(%eax),%edx
80105dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dbd:	39 c2                	cmp    %eax,%edx
80105dbf:	77 b3                	ja     80105d74 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105dc1:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105dc6:	c9                   	leave  
80105dc7:	c3                   	ret    

80105dc8 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105dc8:	55                   	push   %ebp
80105dc9:	89 e5                	mov    %esp,%ebp
80105dcb:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105dce:	83 ec 08             	sub    $0x8,%esp
80105dd1:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105dd4:	50                   	push   %eax
80105dd5:	6a 00                	push   $0x0
80105dd7:	e8 a0 fa ff ff       	call   8010587c <argstr>
80105ddc:	83 c4 10             	add    $0x10,%esp
80105ddf:	85 c0                	test   %eax,%eax
80105de1:	79 0a                	jns    80105ded <sys_unlink+0x25>
    return -1;
80105de3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de8:	e9 bc 01 00 00       	jmp    80105fa9 <sys_unlink+0x1e1>

  begin_op();
80105ded:	e8 c2 d6 ff ff       	call   801034b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105df2:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105df5:	83 ec 08             	sub    $0x8,%esp
80105df8:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105dfb:	52                   	push   %edx
80105dfc:	50                   	push   %eax
80105dfd:	e8 dd c6 ff ff       	call   801024df <nameiparent>
80105e02:	83 c4 10             	add    $0x10,%esp
80105e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e0c:	75 0f                	jne    80105e1d <sys_unlink+0x55>
    end_op();
80105e0e:	e8 2d d7 ff ff       	call   80103540 <end_op>
    return -1;
80105e13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e18:	e9 8c 01 00 00       	jmp    80105fa9 <sys_unlink+0x1e1>
  }

  ilock(dp);
80105e1d:	83 ec 0c             	sub    $0xc,%esp
80105e20:	ff 75 f4             	pushl  -0xc(%ebp)
80105e23:	e8 e3 ba ff ff       	call   8010190b <ilock>
80105e28:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105e2b:	83 ec 08             	sub    $0x8,%esp
80105e2e:	68 51 90 10 80       	push   $0x80109051
80105e33:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e36:	50                   	push   %eax
80105e37:	e8 16 c3 ff ff       	call   80102152 <namecmp>
80105e3c:	83 c4 10             	add    $0x10,%esp
80105e3f:	85 c0                	test   %eax,%eax
80105e41:	0f 84 4a 01 00 00    	je     80105f91 <sys_unlink+0x1c9>
80105e47:	83 ec 08             	sub    $0x8,%esp
80105e4a:	68 53 90 10 80       	push   $0x80109053
80105e4f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e52:	50                   	push   %eax
80105e53:	e8 fa c2 ff ff       	call   80102152 <namecmp>
80105e58:	83 c4 10             	add    $0x10,%esp
80105e5b:	85 c0                	test   %eax,%eax
80105e5d:	0f 84 2e 01 00 00    	je     80105f91 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105e63:	83 ec 04             	sub    $0x4,%esp
80105e66:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105e69:	50                   	push   %eax
80105e6a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e6d:	50                   	push   %eax
80105e6e:	ff 75 f4             	pushl  -0xc(%ebp)
80105e71:	e8 f7 c2 ff ff       	call   8010216d <dirlookup>
80105e76:	83 c4 10             	add    $0x10,%esp
80105e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e80:	0f 84 0a 01 00 00    	je     80105f90 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80105e86:	83 ec 0c             	sub    $0xc,%esp
80105e89:	ff 75 f0             	pushl  -0x10(%ebp)
80105e8c:	e8 7a ba ff ff       	call   8010190b <ilock>
80105e91:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e97:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e9b:	66 85 c0             	test   %ax,%ax
80105e9e:	7f 0d                	jg     80105ead <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	68 56 90 10 80       	push   $0x80109056
80105ea8:	e8 b9 a6 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105eb4:	66 83 f8 01          	cmp    $0x1,%ax
80105eb8:	75 25                	jne    80105edf <sys_unlink+0x117>
80105eba:	83 ec 0c             	sub    $0xc,%esp
80105ebd:	ff 75 f0             	pushl  -0x10(%ebp)
80105ec0:	e8 a0 fe ff ff       	call   80105d65 <isdirempty>
80105ec5:	83 c4 10             	add    $0x10,%esp
80105ec8:	85 c0                	test   %eax,%eax
80105eca:	75 13                	jne    80105edf <sys_unlink+0x117>
    iunlockput(ip);
80105ecc:	83 ec 0c             	sub    $0xc,%esp
80105ecf:	ff 75 f0             	pushl  -0x10(%ebp)
80105ed2:	e8 ee bc ff ff       	call   80101bc5 <iunlockput>
80105ed7:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105eda:	e9 b2 00 00 00       	jmp    80105f91 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105edf:	83 ec 04             	sub    $0x4,%esp
80105ee2:	6a 10                	push   $0x10
80105ee4:	6a 00                	push   $0x0
80105ee6:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ee9:	50                   	push   %eax
80105eea:	e8 e3 f5 ff ff       	call   801054d2 <memset>
80105eef:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ef2:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105ef5:	6a 10                	push   $0x10
80105ef7:	50                   	push   %eax
80105ef8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105efb:	50                   	push   %eax
80105efc:	ff 75 f4             	pushl  -0xc(%ebp)
80105eff:	e8 c6 c0 ff ff       	call   80101fca <writei>
80105f04:	83 c4 10             	add    $0x10,%esp
80105f07:	83 f8 10             	cmp    $0x10,%eax
80105f0a:	74 0d                	je     80105f19 <sys_unlink+0x151>
    panic("unlink: writei");
80105f0c:	83 ec 0c             	sub    $0xc,%esp
80105f0f:	68 68 90 10 80       	push   $0x80109068
80105f14:	e8 4d a6 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80105f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f1c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f20:	66 83 f8 01          	cmp    $0x1,%ax
80105f24:	75 21                	jne    80105f47 <sys_unlink+0x17f>
    dp->nlink--;
80105f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f29:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f2d:	83 e8 01             	sub    $0x1,%eax
80105f30:	89 c2                	mov    %eax,%edx
80105f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f35:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105f39:	83 ec 0c             	sub    $0xc,%esp
80105f3c:	ff 75 f4             	pushl  -0xc(%ebp)
80105f3f:	e8 f3 b7 ff ff       	call   80101737 <iupdate>
80105f44:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105f47:	83 ec 0c             	sub    $0xc,%esp
80105f4a:	ff 75 f4             	pushl  -0xc(%ebp)
80105f4d:	e8 73 bc ff ff       	call   80101bc5 <iunlockput>
80105f52:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f58:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f5c:	83 e8 01             	sub    $0x1,%eax
80105f5f:	89 c2                	mov    %eax,%edx
80105f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f64:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105f68:	83 ec 0c             	sub    $0xc,%esp
80105f6b:	ff 75 f0             	pushl  -0x10(%ebp)
80105f6e:	e8 c4 b7 ff ff       	call   80101737 <iupdate>
80105f73:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105f76:	83 ec 0c             	sub    $0xc,%esp
80105f79:	ff 75 f0             	pushl  -0x10(%ebp)
80105f7c:	e8 44 bc ff ff       	call   80101bc5 <iunlockput>
80105f81:	83 c4 10             	add    $0x10,%esp

  end_op();
80105f84:	e8 b7 d5 ff ff       	call   80103540 <end_op>

  return 0;
80105f89:	b8 00 00 00 00       	mov    $0x0,%eax
80105f8e:	eb 19                	jmp    80105fa9 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105f90:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105f91:	83 ec 0c             	sub    $0xc,%esp
80105f94:	ff 75 f4             	pushl  -0xc(%ebp)
80105f97:	e8 29 bc ff ff       	call   80101bc5 <iunlockput>
80105f9c:	83 c4 10             	add    $0x10,%esp
  end_op();
80105f9f:	e8 9c d5 ff ff       	call   80103540 <end_op>
  return -1;
80105fa4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fa9:	c9                   	leave  
80105faa:	c3                   	ret    

80105fab <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105fab:	55                   	push   %ebp
80105fac:	89 e5                	mov    %esp,%ebp
80105fae:	83 ec 38             	sub    $0x38,%esp
80105fb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105fb4:	8b 55 10             	mov    0x10(%ebp),%edx
80105fb7:	8b 45 14             	mov    0x14(%ebp),%eax
80105fba:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105fbe:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105fc2:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105fc6:	83 ec 08             	sub    $0x8,%esp
80105fc9:	8d 45 de             	lea    -0x22(%ebp),%eax
80105fcc:	50                   	push   %eax
80105fcd:	ff 75 08             	pushl  0x8(%ebp)
80105fd0:	e8 0a c5 ff ff       	call   801024df <nameiparent>
80105fd5:	83 c4 10             	add    $0x10,%esp
80105fd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fdf:	75 0a                	jne    80105feb <create+0x40>
    return 0;
80105fe1:	b8 00 00 00 00       	mov    $0x0,%eax
80105fe6:	e9 90 01 00 00       	jmp    8010617b <create+0x1d0>
  ilock(dp);
80105feb:	83 ec 0c             	sub    $0xc,%esp
80105fee:	ff 75 f4             	pushl  -0xc(%ebp)
80105ff1:	e8 15 b9 ff ff       	call   8010190b <ilock>
80105ff6:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105ff9:	83 ec 04             	sub    $0x4,%esp
80105ffc:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105fff:	50                   	push   %eax
80106000:	8d 45 de             	lea    -0x22(%ebp),%eax
80106003:	50                   	push   %eax
80106004:	ff 75 f4             	pushl  -0xc(%ebp)
80106007:	e8 61 c1 ff ff       	call   8010216d <dirlookup>
8010600c:	83 c4 10             	add    $0x10,%esp
8010600f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106012:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106016:	74 50                	je     80106068 <create+0xbd>
    iunlockput(dp);
80106018:	83 ec 0c             	sub    $0xc,%esp
8010601b:	ff 75 f4             	pushl  -0xc(%ebp)
8010601e:	e8 a2 bb ff ff       	call   80101bc5 <iunlockput>
80106023:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106026:	83 ec 0c             	sub    $0xc,%esp
80106029:	ff 75 f0             	pushl  -0x10(%ebp)
8010602c:	e8 da b8 ff ff       	call   8010190b <ilock>
80106031:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106034:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106039:	75 15                	jne    80106050 <create+0xa5>
8010603b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010603e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106042:	66 83 f8 02          	cmp    $0x2,%ax
80106046:	75 08                	jne    80106050 <create+0xa5>
      return ip;
80106048:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010604b:	e9 2b 01 00 00       	jmp    8010617b <create+0x1d0>
    iunlockput(ip);
80106050:	83 ec 0c             	sub    $0xc,%esp
80106053:	ff 75 f0             	pushl  -0x10(%ebp)
80106056:	e8 6a bb ff ff       	call   80101bc5 <iunlockput>
8010605b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010605e:	b8 00 00 00 00       	mov    $0x0,%eax
80106063:	e9 13 01 00 00       	jmp    8010617b <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106068:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010606c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010606f:	8b 00                	mov    (%eax),%eax
80106071:	83 ec 08             	sub    $0x8,%esp
80106074:	52                   	push   %edx
80106075:	50                   	push   %eax
80106076:	e8 db b5 ff ff       	call   80101656 <ialloc>
8010607b:	83 c4 10             	add    $0x10,%esp
8010607e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106081:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106085:	75 0d                	jne    80106094 <create+0xe9>
    panic("create: ialloc");
80106087:	83 ec 0c             	sub    $0xc,%esp
8010608a:	68 77 90 10 80       	push   $0x80109077
8010608f:	e8 d2 a4 ff ff       	call   80100566 <panic>

  ilock(ip);
80106094:	83 ec 0c             	sub    $0xc,%esp
80106097:	ff 75 f0             	pushl  -0x10(%ebp)
8010609a:	e8 6c b8 ff ff       	call   8010190b <ilock>
8010609f:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801060a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060a5:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801060a9:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801060ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060b0:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801060b4:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801060b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060bb:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801060c1:	83 ec 0c             	sub    $0xc,%esp
801060c4:	ff 75 f0             	pushl  -0x10(%ebp)
801060c7:	e8 6b b6 ff ff       	call   80101737 <iupdate>
801060cc:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801060cf:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801060d4:	75 6a                	jne    80106140 <create+0x195>
    dp->nlink++;  // for ".."
801060d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060dd:	83 c0 01             	add    $0x1,%eax
801060e0:	89 c2                	mov    %eax,%edx
801060e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e5:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801060e9:	83 ec 0c             	sub    $0xc,%esp
801060ec:	ff 75 f4             	pushl  -0xc(%ebp)
801060ef:	e8 43 b6 ff ff       	call   80101737 <iupdate>
801060f4:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801060f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060fa:	8b 40 04             	mov    0x4(%eax),%eax
801060fd:	83 ec 04             	sub    $0x4,%esp
80106100:	50                   	push   %eax
80106101:	68 51 90 10 80       	push   $0x80109051
80106106:	ff 75 f0             	pushl  -0x10(%ebp)
80106109:	e8 19 c1 ff ff       	call   80102227 <dirlink>
8010610e:	83 c4 10             	add    $0x10,%esp
80106111:	85 c0                	test   %eax,%eax
80106113:	78 1e                	js     80106133 <create+0x188>
80106115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106118:	8b 40 04             	mov    0x4(%eax),%eax
8010611b:	83 ec 04             	sub    $0x4,%esp
8010611e:	50                   	push   %eax
8010611f:	68 53 90 10 80       	push   $0x80109053
80106124:	ff 75 f0             	pushl  -0x10(%ebp)
80106127:	e8 fb c0 ff ff       	call   80102227 <dirlink>
8010612c:	83 c4 10             	add    $0x10,%esp
8010612f:	85 c0                	test   %eax,%eax
80106131:	79 0d                	jns    80106140 <create+0x195>
      panic("create dots");
80106133:	83 ec 0c             	sub    $0xc,%esp
80106136:	68 86 90 10 80       	push   $0x80109086
8010613b:	e8 26 a4 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106140:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106143:	8b 40 04             	mov    0x4(%eax),%eax
80106146:	83 ec 04             	sub    $0x4,%esp
80106149:	50                   	push   %eax
8010614a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010614d:	50                   	push   %eax
8010614e:	ff 75 f4             	pushl  -0xc(%ebp)
80106151:	e8 d1 c0 ff ff       	call   80102227 <dirlink>
80106156:	83 c4 10             	add    $0x10,%esp
80106159:	85 c0                	test   %eax,%eax
8010615b:	79 0d                	jns    8010616a <create+0x1bf>
    panic("create: dirlink");
8010615d:	83 ec 0c             	sub    $0xc,%esp
80106160:	68 92 90 10 80       	push   $0x80109092
80106165:	e8 fc a3 ff ff       	call   80100566 <panic>

  iunlockput(dp);
8010616a:	83 ec 0c             	sub    $0xc,%esp
8010616d:	ff 75 f4             	pushl  -0xc(%ebp)
80106170:	e8 50 ba ff ff       	call   80101bc5 <iunlockput>
80106175:	83 c4 10             	add    $0x10,%esp

  return ip;
80106178:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010617b:	c9                   	leave  
8010617c:	c3                   	ret    

8010617d <sys_open>:

int
sys_open(void)
{
8010617d:	55                   	push   %ebp
8010617e:	89 e5                	mov    %esp,%ebp
80106180:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106183:	83 ec 08             	sub    $0x8,%esp
80106186:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106189:	50                   	push   %eax
8010618a:	6a 00                	push   $0x0
8010618c:	e8 eb f6 ff ff       	call   8010587c <argstr>
80106191:	83 c4 10             	add    $0x10,%esp
80106194:	85 c0                	test   %eax,%eax
80106196:	78 15                	js     801061ad <sys_open+0x30>
80106198:	83 ec 08             	sub    $0x8,%esp
8010619b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010619e:	50                   	push   %eax
8010619f:	6a 01                	push   $0x1
801061a1:	e8 51 f6 ff ff       	call   801057f7 <argint>
801061a6:	83 c4 10             	add    $0x10,%esp
801061a9:	85 c0                	test   %eax,%eax
801061ab:	79 0a                	jns    801061b7 <sys_open+0x3a>
    return -1;
801061ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b2:	e9 61 01 00 00       	jmp    80106318 <sys_open+0x19b>

  begin_op();
801061b7:	e8 f8 d2 ff ff       	call   801034b4 <begin_op>

  if(omode & O_CREATE){
801061bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061bf:	25 00 02 00 00       	and    $0x200,%eax
801061c4:	85 c0                	test   %eax,%eax
801061c6:	74 2a                	je     801061f2 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801061c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801061cb:	6a 00                	push   $0x0
801061cd:	6a 00                	push   $0x0
801061cf:	6a 02                	push   $0x2
801061d1:	50                   	push   %eax
801061d2:	e8 d4 fd ff ff       	call   80105fab <create>
801061d7:	83 c4 10             	add    $0x10,%esp
801061da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801061dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061e1:	75 75                	jne    80106258 <sys_open+0xdb>
      end_op();
801061e3:	e8 58 d3 ff ff       	call   80103540 <end_op>
      return -1;
801061e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ed:	e9 26 01 00 00       	jmp    80106318 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801061f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801061f5:	83 ec 0c             	sub    $0xc,%esp
801061f8:	50                   	push   %eax
801061f9:	e8 c5 c2 ff ff       	call   801024c3 <namei>
801061fe:	83 c4 10             	add    $0x10,%esp
80106201:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106208:	75 0f                	jne    80106219 <sys_open+0x9c>
      end_op();
8010620a:	e8 31 d3 ff ff       	call   80103540 <end_op>
      return -1;
8010620f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106214:	e9 ff 00 00 00       	jmp    80106318 <sys_open+0x19b>
    }
    ilock(ip);
80106219:	83 ec 0c             	sub    $0xc,%esp
8010621c:	ff 75 f4             	pushl  -0xc(%ebp)
8010621f:	e8 e7 b6 ff ff       	call   8010190b <ilock>
80106224:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106227:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010622a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010622e:	66 83 f8 01          	cmp    $0x1,%ax
80106232:	75 24                	jne    80106258 <sys_open+0xdb>
80106234:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106237:	85 c0                	test   %eax,%eax
80106239:	74 1d                	je     80106258 <sys_open+0xdb>
      iunlockput(ip);
8010623b:	83 ec 0c             	sub    $0xc,%esp
8010623e:	ff 75 f4             	pushl  -0xc(%ebp)
80106241:	e8 7f b9 ff ff       	call   80101bc5 <iunlockput>
80106246:	83 c4 10             	add    $0x10,%esp
      end_op();
80106249:	e8 f2 d2 ff ff       	call   80103540 <end_op>
      return -1;
8010624e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106253:	e9 c0 00 00 00       	jmp    80106318 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106258:	e8 1b ad ff ff       	call   80100f78 <filealloc>
8010625d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106260:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106264:	74 17                	je     8010627d <sys_open+0x100>
80106266:	83 ec 0c             	sub    $0xc,%esp
80106269:	ff 75 f0             	pushl  -0x10(%ebp)
8010626c:	e8 37 f7 ff ff       	call   801059a8 <fdalloc>
80106271:	83 c4 10             	add    $0x10,%esp
80106274:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106277:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010627b:	79 2e                	jns    801062ab <sys_open+0x12e>
    if(f)
8010627d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106281:	74 0e                	je     80106291 <sys_open+0x114>
      fileclose(f);
80106283:	83 ec 0c             	sub    $0xc,%esp
80106286:	ff 75 f0             	pushl  -0x10(%ebp)
80106289:	e8 a8 ad ff ff       	call   80101036 <fileclose>
8010628e:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106291:	83 ec 0c             	sub    $0xc,%esp
80106294:	ff 75 f4             	pushl  -0xc(%ebp)
80106297:	e8 29 b9 ff ff       	call   80101bc5 <iunlockput>
8010629c:	83 c4 10             	add    $0x10,%esp
    end_op();
8010629f:	e8 9c d2 ff ff       	call   80103540 <end_op>
    return -1;
801062a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062a9:	eb 6d                	jmp    80106318 <sys_open+0x19b>
  }
  iunlock(ip);
801062ab:	83 ec 0c             	sub    $0xc,%esp
801062ae:	ff 75 f4             	pushl  -0xc(%ebp)
801062b1:	e8 ad b7 ff ff       	call   80101a63 <iunlock>
801062b6:	83 c4 10             	add    $0x10,%esp
  end_op();
801062b9:	e8 82 d2 ff ff       	call   80103540 <end_op>

  f->type = FD_INODE;
801062be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062c1:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801062c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062cd:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801062d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062d3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801062da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062dd:	83 e0 01             	and    $0x1,%eax
801062e0:	85 c0                	test   %eax,%eax
801062e2:	0f 94 c0             	sete   %al
801062e5:	89 c2                	mov    %eax,%edx
801062e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ea:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801062ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062f0:	83 e0 01             	and    $0x1,%eax
801062f3:	85 c0                	test   %eax,%eax
801062f5:	75 0a                	jne    80106301 <sys_open+0x184>
801062f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062fa:	83 e0 02             	and    $0x2,%eax
801062fd:	85 c0                	test   %eax,%eax
801062ff:	74 07                	je     80106308 <sys_open+0x18b>
80106301:	b8 01 00 00 00       	mov    $0x1,%eax
80106306:	eb 05                	jmp    8010630d <sys_open+0x190>
80106308:	b8 00 00 00 00       	mov    $0x0,%eax
8010630d:	89 c2                	mov    %eax,%edx
8010630f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106312:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106315:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106318:	c9                   	leave  
80106319:	c3                   	ret    

8010631a <sys_mkdir>:

int
sys_mkdir(void)
{
8010631a:	55                   	push   %ebp
8010631b:	89 e5                	mov    %esp,%ebp
8010631d:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106320:	e8 8f d1 ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106325:	83 ec 08             	sub    $0x8,%esp
80106328:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010632b:	50                   	push   %eax
8010632c:	6a 00                	push   $0x0
8010632e:	e8 49 f5 ff ff       	call   8010587c <argstr>
80106333:	83 c4 10             	add    $0x10,%esp
80106336:	85 c0                	test   %eax,%eax
80106338:	78 1b                	js     80106355 <sys_mkdir+0x3b>
8010633a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010633d:	6a 00                	push   $0x0
8010633f:	6a 00                	push   $0x0
80106341:	6a 01                	push   $0x1
80106343:	50                   	push   %eax
80106344:	e8 62 fc ff ff       	call   80105fab <create>
80106349:	83 c4 10             	add    $0x10,%esp
8010634c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010634f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106353:	75 0c                	jne    80106361 <sys_mkdir+0x47>
    end_op();
80106355:	e8 e6 d1 ff ff       	call   80103540 <end_op>
    return -1;
8010635a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010635f:	eb 18                	jmp    80106379 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106361:	83 ec 0c             	sub    $0xc,%esp
80106364:	ff 75 f4             	pushl  -0xc(%ebp)
80106367:	e8 59 b8 ff ff       	call   80101bc5 <iunlockput>
8010636c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010636f:	e8 cc d1 ff ff       	call   80103540 <end_op>
  return 0;
80106374:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106379:	c9                   	leave  
8010637a:	c3                   	ret    

8010637b <sys_mknod>:

int
sys_mknod(void)
{
8010637b:	55                   	push   %ebp
8010637c:	89 e5                	mov    %esp,%ebp
8010637e:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106381:	e8 2e d1 ff ff       	call   801034b4 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106386:	83 ec 08             	sub    $0x8,%esp
80106389:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010638c:	50                   	push   %eax
8010638d:	6a 00                	push   $0x0
8010638f:	e8 e8 f4 ff ff       	call   8010587c <argstr>
80106394:	83 c4 10             	add    $0x10,%esp
80106397:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010639a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010639e:	78 4f                	js     801063ef <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801063a0:	83 ec 08             	sub    $0x8,%esp
801063a3:	8d 45 e8             	lea    -0x18(%ebp),%eax
801063a6:	50                   	push   %eax
801063a7:	6a 01                	push   $0x1
801063a9:	e8 49 f4 ff ff       	call   801057f7 <argint>
801063ae:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801063b1:	85 c0                	test   %eax,%eax
801063b3:	78 3a                	js     801063ef <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801063b5:	83 ec 08             	sub    $0x8,%esp
801063b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801063bb:	50                   	push   %eax
801063bc:	6a 02                	push   $0x2
801063be:	e8 34 f4 ff ff       	call   801057f7 <argint>
801063c3:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801063c6:	85 c0                	test   %eax,%eax
801063c8:	78 25                	js     801063ef <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801063ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063cd:	0f bf c8             	movswl %ax,%ecx
801063d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063d3:	0f bf d0             	movswl %ax,%edx
801063d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801063d9:	51                   	push   %ecx
801063da:	52                   	push   %edx
801063db:	6a 03                	push   $0x3
801063dd:	50                   	push   %eax
801063de:	e8 c8 fb ff ff       	call   80105fab <create>
801063e3:	83 c4 10             	add    $0x10,%esp
801063e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063ed:	75 0c                	jne    801063fb <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801063ef:	e8 4c d1 ff ff       	call   80103540 <end_op>
    return -1;
801063f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063f9:	eb 18                	jmp    80106413 <sys_mknod+0x98>
  }
  iunlockput(ip);
801063fb:	83 ec 0c             	sub    $0xc,%esp
801063fe:	ff 75 f0             	pushl  -0x10(%ebp)
80106401:	e8 bf b7 ff ff       	call   80101bc5 <iunlockput>
80106406:	83 c4 10             	add    $0x10,%esp
  end_op();
80106409:	e8 32 d1 ff ff       	call   80103540 <end_op>
  return 0;
8010640e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106413:	c9                   	leave  
80106414:	c3                   	ret    

80106415 <sys_chdir>:

int
sys_chdir(void)
{
80106415:	55                   	push   %ebp
80106416:	89 e5                	mov    %esp,%ebp
80106418:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010641b:	e8 94 d0 ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106420:	83 ec 08             	sub    $0x8,%esp
80106423:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106426:	50                   	push   %eax
80106427:	6a 00                	push   $0x0
80106429:	e8 4e f4 ff ff       	call   8010587c <argstr>
8010642e:	83 c4 10             	add    $0x10,%esp
80106431:	85 c0                	test   %eax,%eax
80106433:	78 18                	js     8010644d <sys_chdir+0x38>
80106435:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106438:	83 ec 0c             	sub    $0xc,%esp
8010643b:	50                   	push   %eax
8010643c:	e8 82 c0 ff ff       	call   801024c3 <namei>
80106441:	83 c4 10             	add    $0x10,%esp
80106444:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106447:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010644b:	75 0c                	jne    80106459 <sys_chdir+0x44>
    end_op();
8010644d:	e8 ee d0 ff ff       	call   80103540 <end_op>
    return -1;
80106452:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106457:	eb 6e                	jmp    801064c7 <sys_chdir+0xb2>
  }
  ilock(ip);
80106459:	83 ec 0c             	sub    $0xc,%esp
8010645c:	ff 75 f4             	pushl  -0xc(%ebp)
8010645f:	e8 a7 b4 ff ff       	call   8010190b <ilock>
80106464:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106467:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010646a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010646e:	66 83 f8 01          	cmp    $0x1,%ax
80106472:	74 1a                	je     8010648e <sys_chdir+0x79>
    iunlockput(ip);
80106474:	83 ec 0c             	sub    $0xc,%esp
80106477:	ff 75 f4             	pushl  -0xc(%ebp)
8010647a:	e8 46 b7 ff ff       	call   80101bc5 <iunlockput>
8010647f:	83 c4 10             	add    $0x10,%esp
    end_op();
80106482:	e8 b9 d0 ff ff       	call   80103540 <end_op>
    return -1;
80106487:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010648c:	eb 39                	jmp    801064c7 <sys_chdir+0xb2>
  }
  iunlock(ip);
8010648e:	83 ec 0c             	sub    $0xc,%esp
80106491:	ff 75 f4             	pushl  -0xc(%ebp)
80106494:	e8 ca b5 ff ff       	call   80101a63 <iunlock>
80106499:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
8010649c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064a2:	8b 40 68             	mov    0x68(%eax),%eax
801064a5:	83 ec 0c             	sub    $0xc,%esp
801064a8:	50                   	push   %eax
801064a9:	e8 27 b6 ff ff       	call   80101ad5 <iput>
801064ae:	83 c4 10             	add    $0x10,%esp
  end_op();
801064b1:	e8 8a d0 ff ff       	call   80103540 <end_op>
  proc->cwd = ip;
801064b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064bf:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801064c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064c7:	c9                   	leave  
801064c8:	c3                   	ret    

801064c9 <sys_exec>:

int
sys_exec(void)
{
801064c9:	55                   	push   %ebp
801064ca:	89 e5                	mov    %esp,%ebp
801064cc:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801064d2:	83 ec 08             	sub    $0x8,%esp
801064d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064d8:	50                   	push   %eax
801064d9:	6a 00                	push   $0x0
801064db:	e8 9c f3 ff ff       	call   8010587c <argstr>
801064e0:	83 c4 10             	add    $0x10,%esp
801064e3:	85 c0                	test   %eax,%eax
801064e5:	78 18                	js     801064ff <sys_exec+0x36>
801064e7:	83 ec 08             	sub    $0x8,%esp
801064ea:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801064f0:	50                   	push   %eax
801064f1:	6a 01                	push   $0x1
801064f3:	e8 ff f2 ff ff       	call   801057f7 <argint>
801064f8:	83 c4 10             	add    $0x10,%esp
801064fb:	85 c0                	test   %eax,%eax
801064fd:	79 0a                	jns    80106509 <sys_exec+0x40>
    return -1;
801064ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106504:	e9 c6 00 00 00       	jmp    801065cf <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106509:	83 ec 04             	sub    $0x4,%esp
8010650c:	68 80 00 00 00       	push   $0x80
80106511:	6a 00                	push   $0x0
80106513:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106519:	50                   	push   %eax
8010651a:	e8 b3 ef ff ff       	call   801054d2 <memset>
8010651f:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106522:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106529:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010652c:	83 f8 1f             	cmp    $0x1f,%eax
8010652f:	76 0a                	jbe    8010653b <sys_exec+0x72>
      return -1;
80106531:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106536:	e9 94 00 00 00       	jmp    801065cf <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010653b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010653e:	c1 e0 02             	shl    $0x2,%eax
80106541:	89 c2                	mov    %eax,%edx
80106543:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106549:	01 c2                	add    %eax,%edx
8010654b:	83 ec 08             	sub    $0x8,%esp
8010654e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106554:	50                   	push   %eax
80106555:	52                   	push   %edx
80106556:	e8 00 f2 ff ff       	call   8010575b <fetchint>
8010655b:	83 c4 10             	add    $0x10,%esp
8010655e:	85 c0                	test   %eax,%eax
80106560:	79 07                	jns    80106569 <sys_exec+0xa0>
      return -1;
80106562:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106567:	eb 66                	jmp    801065cf <sys_exec+0x106>
    if(uarg == 0){
80106569:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010656f:	85 c0                	test   %eax,%eax
80106571:	75 27                	jne    8010659a <sys_exec+0xd1>
      argv[i] = 0;
80106573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106576:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010657d:	00 00 00 00 
      break;
80106581:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106582:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106585:	83 ec 08             	sub    $0x8,%esp
80106588:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010658e:	52                   	push   %edx
8010658f:	50                   	push   %eax
80106590:	e8 c1 a5 ff ff       	call   80100b56 <exec>
80106595:	83 c4 10             	add    $0x10,%esp
80106598:	eb 35                	jmp    801065cf <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010659a:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801065a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065a3:	c1 e2 02             	shl    $0x2,%edx
801065a6:	01 c2                	add    %eax,%edx
801065a8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801065ae:	83 ec 08             	sub    $0x8,%esp
801065b1:	52                   	push   %edx
801065b2:	50                   	push   %eax
801065b3:	e8 dd f1 ff ff       	call   80105795 <fetchstr>
801065b8:	83 c4 10             	add    $0x10,%esp
801065bb:	85 c0                	test   %eax,%eax
801065bd:	79 07                	jns    801065c6 <sys_exec+0xfd>
      return -1;
801065bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065c4:	eb 09                	jmp    801065cf <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801065c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801065ca:	e9 5a ff ff ff       	jmp    80106529 <sys_exec+0x60>
  return exec(path, argv);
}
801065cf:	c9                   	leave  
801065d0:	c3                   	ret    

801065d1 <sys_pipe>:

int
sys_pipe(void)
{
801065d1:	55                   	push   %ebp
801065d2:	89 e5                	mov    %esp,%ebp
801065d4:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801065d7:	83 ec 04             	sub    $0x4,%esp
801065da:	6a 08                	push   $0x8
801065dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
801065df:	50                   	push   %eax
801065e0:	6a 00                	push   $0x0
801065e2:	e8 38 f2 ff ff       	call   8010581f <argptr>
801065e7:	83 c4 10             	add    $0x10,%esp
801065ea:	85 c0                	test   %eax,%eax
801065ec:	79 0a                	jns    801065f8 <sys_pipe+0x27>
    return -1;
801065ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065f3:	e9 af 00 00 00       	jmp    801066a7 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801065f8:	83 ec 08             	sub    $0x8,%esp
801065fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801065fe:	50                   	push   %eax
801065ff:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106602:	50                   	push   %eax
80106603:	e8 8a d9 ff ff       	call   80103f92 <pipealloc>
80106608:	83 c4 10             	add    $0x10,%esp
8010660b:	85 c0                	test   %eax,%eax
8010660d:	79 0a                	jns    80106619 <sys_pipe+0x48>
    return -1;
8010660f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106614:	e9 8e 00 00 00       	jmp    801066a7 <sys_pipe+0xd6>
  fd0 = -1;
80106619:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106620:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106623:	83 ec 0c             	sub    $0xc,%esp
80106626:	50                   	push   %eax
80106627:	e8 7c f3 ff ff       	call   801059a8 <fdalloc>
8010662c:	83 c4 10             	add    $0x10,%esp
8010662f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106632:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106636:	78 18                	js     80106650 <sys_pipe+0x7f>
80106638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010663b:	83 ec 0c             	sub    $0xc,%esp
8010663e:	50                   	push   %eax
8010663f:	e8 64 f3 ff ff       	call   801059a8 <fdalloc>
80106644:	83 c4 10             	add    $0x10,%esp
80106647:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010664a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010664e:	79 3f                	jns    8010668f <sys_pipe+0xbe>
    if(fd0 >= 0)
80106650:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106654:	78 14                	js     8010666a <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106656:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010665c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010665f:	83 c2 08             	add    $0x8,%edx
80106662:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106669:	00 
    fileclose(rf);
8010666a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010666d:	83 ec 0c             	sub    $0xc,%esp
80106670:	50                   	push   %eax
80106671:	e8 c0 a9 ff ff       	call   80101036 <fileclose>
80106676:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010667c:	83 ec 0c             	sub    $0xc,%esp
8010667f:	50                   	push   %eax
80106680:	e8 b1 a9 ff ff       	call   80101036 <fileclose>
80106685:	83 c4 10             	add    $0x10,%esp
    return -1;
80106688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010668d:	eb 18                	jmp    801066a7 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
8010668f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106692:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106695:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106697:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010669a:	8d 50 04             	lea    0x4(%eax),%edx
8010669d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066a0:	89 02                	mov    %eax,(%edx)
  return 0;
801066a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066a7:	c9                   	leave  
801066a8:	c3                   	ret    

801066a9 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
801066a9:	55                   	push   %ebp
801066aa:	89 e5                	mov    %esp,%ebp
801066ac:	83 ec 08             	sub    $0x8,%esp
801066af:	8b 55 08             	mov    0x8(%ebp),%edx
801066b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801066b5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801066b9:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801066bd:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
801066c1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801066c5:	66 ef                	out    %ax,(%dx)
}
801066c7:	90                   	nop
801066c8:	c9                   	leave  
801066c9:	c3                   	ret    

801066ca <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801066ca:	55                   	push   %ebp
801066cb:	89 e5                	mov    %esp,%ebp
801066cd:	83 ec 08             	sub    $0x8,%esp
  return fork();
801066d0:	e8 dd df ff ff       	call   801046b2 <fork>
}
801066d5:	c9                   	leave  
801066d6:	c3                   	ret    

801066d7 <sys_exit>:


int
sys_exit(void)
{
801066d7:	55                   	push   %ebp
801066d8:	89 e5                	mov    %esp,%ebp
801066da:	83 ec 08             	sub    $0x8,%esp
  exit();
801066dd:	e8 f2 e2 ff ff       	call   801049d4 <exit>
  return 0;  // not reached
801066e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066e7:	c9                   	leave  
801066e8:	c3                   	ret    

801066e9 <sys_wait>:

int
sys_wait(void)
{
801066e9:	55                   	push   %ebp
801066ea:	89 e5                	mov    %esp,%ebp
801066ec:	83 ec 08             	sub    $0x8,%esp
  return wait();
801066ef:	e8 1b e4 ff ff       	call   80104b0f <wait>
}
801066f4:	c9                   	leave  
801066f5:	c3                   	ret    

801066f6 <sys_kill>:

int
sys_kill(void)
{
801066f6:	55                   	push   %ebp
801066f7:	89 e5                	mov    %esp,%ebp
801066f9:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801066fc:	83 ec 08             	sub    $0x8,%esp
801066ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106702:	50                   	push   %eax
80106703:	6a 00                	push   $0x0
80106705:	e8 ed f0 ff ff       	call   801057f7 <argint>
8010670a:	83 c4 10             	add    $0x10,%esp
8010670d:	85 c0                	test   %eax,%eax
8010670f:	79 07                	jns    80106718 <sys_kill+0x22>
    return -1;
80106711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106716:	eb 0f                	jmp    80106727 <sys_kill+0x31>
  return kill(pid);
80106718:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010671b:	83 ec 0c             	sub    $0xc,%esp
8010671e:	50                   	push   %eax
8010671f:	e8 07 e8 ff ff       	call   80104f2b <kill>
80106724:	83 c4 10             	add    $0x10,%esp
}
80106727:	c9                   	leave  
80106728:	c3                   	ret    

80106729 <sys_getpid>:

int
sys_getpid(void)
{
80106729:	55                   	push   %ebp
8010672a:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010672c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106732:	8b 40 10             	mov    0x10(%eax),%eax
}
80106735:	5d                   	pop    %ebp
80106736:	c3                   	ret    

80106737 <sys_sbrk>:

int
sys_sbrk(void)
{
80106737:	55                   	push   %ebp
80106738:	89 e5                	mov    %esp,%ebp
8010673a:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010673d:	83 ec 08             	sub    $0x8,%esp
80106740:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106743:	50                   	push   %eax
80106744:	6a 00                	push   $0x0
80106746:	e8 ac f0 ff ff       	call   801057f7 <argint>
8010674b:	83 c4 10             	add    $0x10,%esp
8010674e:	85 c0                	test   %eax,%eax
80106750:	79 07                	jns    80106759 <sys_sbrk+0x22>
    return -1;
80106752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106757:	eb 28                	jmp    80106781 <sys_sbrk+0x4a>
  addr = proc->sz;
80106759:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010675f:	8b 00                	mov    (%eax),%eax
80106761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106764:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106767:	83 ec 0c             	sub    $0xc,%esp
8010676a:	50                   	push   %eax
8010676b:	e8 9f de ff ff       	call   8010460f <growproc>
80106770:	83 c4 10             	add    $0x10,%esp
80106773:	85 c0                	test   %eax,%eax
80106775:	79 07                	jns    8010677e <sys_sbrk+0x47>
    return -1;
80106777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010677c:	eb 03                	jmp    80106781 <sys_sbrk+0x4a>
  return addr;
8010677e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106781:	c9                   	leave  
80106782:	c3                   	ret    

80106783 <sys_sleep>:

int
sys_sleep(void)
{
80106783:	55                   	push   %ebp
80106784:	89 e5                	mov    %esp,%ebp
80106786:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106789:	83 ec 08             	sub    $0x8,%esp
8010678c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010678f:	50                   	push   %eax
80106790:	6a 00                	push   $0x0
80106792:	e8 60 f0 ff ff       	call   801057f7 <argint>
80106797:	83 c4 10             	add    $0x10,%esp
8010679a:	85 c0                	test   %eax,%eax
8010679c:	79 07                	jns    801067a5 <sys_sleep+0x22>
    return -1;
8010679e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067a3:	eb 77                	jmp    8010681c <sys_sleep+0x99>
  acquire(&tickslock);
801067a5:	83 ec 0c             	sub    $0xc,%esp
801067a8:	68 c0 5b 11 80       	push   $0x80115bc0
801067ad:	e8 bd ea ff ff       	call   8010526f <acquire>
801067b2:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801067b5:	a1 00 64 11 80       	mov    0x80116400,%eax
801067ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801067bd:	eb 39                	jmp    801067f8 <sys_sleep+0x75>
    if(proc->killed){
801067bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067c5:	8b 40 24             	mov    0x24(%eax),%eax
801067c8:	85 c0                	test   %eax,%eax
801067ca:	74 17                	je     801067e3 <sys_sleep+0x60>
      release(&tickslock);
801067cc:	83 ec 0c             	sub    $0xc,%esp
801067cf:	68 c0 5b 11 80       	push   $0x80115bc0
801067d4:	e8 fd ea ff ff       	call   801052d6 <release>
801067d9:	83 c4 10             	add    $0x10,%esp
      return -1;
801067dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067e1:	eb 39                	jmp    8010681c <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
801067e3:	83 ec 08             	sub    $0x8,%esp
801067e6:	68 c0 5b 11 80       	push   $0x80115bc0
801067eb:	68 00 64 11 80       	push   $0x80116400
801067f0:	e8 11 e6 ff ff       	call   80104e06 <sleep>
801067f5:	83 c4 10             	add    $0x10,%esp

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801067f8:	a1 00 64 11 80       	mov    0x80116400,%eax
801067fd:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106800:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106803:	39 d0                	cmp    %edx,%eax
80106805:	72 b8                	jb     801067bf <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106807:	83 ec 0c             	sub    $0xc,%esp
8010680a:	68 c0 5b 11 80       	push   $0x80115bc0
8010680f:	e8 c2 ea ff ff       	call   801052d6 <release>
80106814:	83 c4 10             	add    $0x10,%esp
  return 0;
80106817:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010681c:	c9                   	leave  
8010681d:	c3                   	ret    

8010681e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010681e:	55                   	push   %ebp
8010681f:	89 e5                	mov    %esp,%ebp
80106821:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106824:	83 ec 0c             	sub    $0xc,%esp
80106827:	68 c0 5b 11 80       	push   $0x80115bc0
8010682c:	e8 3e ea ff ff       	call   8010526f <acquire>
80106831:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106834:	a1 00 64 11 80       	mov    0x80116400,%eax
80106839:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010683c:	83 ec 0c             	sub    $0xc,%esp
8010683f:	68 c0 5b 11 80       	push   $0x80115bc0
80106844:	e8 8d ea ff ff       	call   801052d6 <release>
80106849:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010684c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010684f:	c9                   	leave  
80106850:	c3                   	ret    

80106851 <sys_halt>:
// signal to QEMU.
// Based on: http://pdos.csail.mit.edu/6.828/2012/homework/xv6-syscall.html
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
80106851:	55                   	push   %ebp
80106852:	89 e5                	mov    %esp,%ebp
80106854:	83 ec 10             	sub    $0x10,%esp
  char *p = "Shutdown";
80106857:	c7 45 fc a2 90 10 80 	movl   $0x801090a2,-0x4(%ebp)
  for( ; *p; p++)
8010685e:	eb 16                	jmp    80106876 <sys_halt+0x25>
    outw(0xB004, 0x2000);
80106860:	68 00 20 00 00       	push   $0x2000
80106865:	68 04 b0 00 00       	push   $0xb004
8010686a:	e8 3a fe ff ff       	call   801066a9 <outw>
8010686f:	83 c4 08             	add    $0x8,%esp
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
  char *p = "Shutdown";
  for( ; *p; p++)
80106872:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106876:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106879:	0f b6 00             	movzbl (%eax),%eax
8010687c:	84 c0                	test   %al,%al
8010687e:	75 e0                	jne    80106860 <sys_halt+0xf>
    outw(0xB004, 0x2000);
  return 0;
80106880:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106885:	c9                   	leave  
80106886:	c3                   	ret    

80106887 <sys_mprotect>:

int sys_mprotect(void)
{
80106887:	55                   	push   %ebp
80106888:	89 e5                	mov    %esp,%ebp
8010688a:	83 ec 18             	sub    $0x18,%esp
  int addr,len,prot;

  if(argint(0, &addr) <0)
8010688d:	83 ec 08             	sub    $0x8,%esp
80106890:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106893:	50                   	push   %eax
80106894:	6a 00                	push   $0x0
80106896:	e8 5c ef ff ff       	call   801057f7 <argint>
8010689b:	83 c4 10             	add    $0x10,%esp
8010689e:	85 c0                	test   %eax,%eax
801068a0:	79 07                	jns    801068a9 <sys_mprotect+0x22>
    return -1;
801068a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068a7:	eb 4f                	jmp    801068f8 <sys_mprotect+0x71>
  if(argint(1,&len) <0)
801068a9:	83 ec 08             	sub    $0x8,%esp
801068ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068af:	50                   	push   %eax
801068b0:	6a 01                	push   $0x1
801068b2:	e8 40 ef ff ff       	call   801057f7 <argint>
801068b7:	83 c4 10             	add    $0x10,%esp
801068ba:	85 c0                	test   %eax,%eax
801068bc:	79 07                	jns    801068c5 <sys_mprotect+0x3e>
    return -1;
801068be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c3:	eb 33                	jmp    801068f8 <sys_mprotect+0x71>
  if(argint(2,&prot) <0)
801068c5:	83 ec 08             	sub    $0x8,%esp
801068c8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801068cb:	50                   	push   %eax
801068cc:	6a 02                	push   $0x2
801068ce:	e8 24 ef ff ff       	call   801057f7 <argint>
801068d3:	83 c4 10             	add    $0x10,%esp
801068d6:	85 c0                	test   %eax,%eax
801068d8:	79 07                	jns    801068e1 <sys_mprotect+0x5a>
    return -1;
801068da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068df:	eb 17                	jmp    801068f8 <sys_mprotect+0x71>

  return mprotect((void*)addr,len,prot);
801068e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801068e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801068ea:	83 ec 04             	sub    $0x4,%esp
801068ed:	52                   	push   %edx
801068ee:	50                   	push   %eax
801068ef:	51                   	push   %ecx
801068f0:	e8 93 1c 00 00       	call   80108588 <mprotect>
801068f5:	83 c4 10             	add    $0x10,%esp
}
801068f8:	c9                   	leave  
801068f9:	c3                   	ret    

801068fa <sys_signal_register>:

int sys_signal_register(void)
{
801068fa:	55                   	push   %ebp
801068fb:	89 e5                	mov    %esp,%ebp
801068fd:	83 ec 18             	sub    $0x18,%esp
    uint signum;
    sighandler_t handler;
    int n;

    if (argint(0, &n) < 0)
80106900:	83 ec 08             	sub    $0x8,%esp
80106903:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106906:	50                   	push   %eax
80106907:	6a 00                	push   $0x0
80106909:	e8 e9 ee ff ff       	call   801057f7 <argint>
8010690e:	83 c4 10             	add    $0x10,%esp
80106911:	85 c0                	test   %eax,%eax
80106913:	79 07                	jns    8010691c <sys_signal_register+0x22>
      return -1;
80106915:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010691a:	eb 3a                	jmp    80106956 <sys_signal_register+0x5c>
    signum = (uint) n;
8010691c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010691f:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (argint(1, &n) < 0)
80106922:	83 ec 08             	sub    $0x8,%esp
80106925:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106928:	50                   	push   %eax
80106929:	6a 01                	push   $0x1
8010692b:	e8 c7 ee ff ff       	call   801057f7 <argint>
80106930:	83 c4 10             	add    $0x10,%esp
80106933:	85 c0                	test   %eax,%eax
80106935:	79 07                	jns    8010693e <sys_signal_register+0x44>
      return -1;
80106937:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010693c:	eb 18                	jmp    80106956 <sys_signal_register+0x5c>
    handler = (sighandler_t) n;
8010693e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106941:	89 45 f0             	mov    %eax,-0x10(%ebp)

    return (int) signal_register_handler(signum, handler);
80106944:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106947:	83 ec 08             	sub    $0x8,%esp
8010694a:	ff 75 f0             	pushl  -0x10(%ebp)
8010694d:	50                   	push   %eax
8010694e:	e8 80 e8 ff ff       	call   801051d3 <signal_register_handler>
80106953:	83 c4 10             	add    $0x10,%esp
}
80106956:	c9                   	leave  
80106957:	c3                   	ret    

80106958 <sys_cowfork>:
int sys_cowfork(void)
{
80106958:	55                   	push   %ebp
80106959:	89 e5                	mov    %esp,%ebp
8010695b:	83 ec 08             	sub    $0x8,%esp
  return cowfork();
8010695e:	e8 e0 de ff ff       	call   80104843 <cowfork>
}
80106963:	c9                   	leave  
80106964:	c3                   	ret    

80106965 <sys_signal_restorer>:
int sys_signal_restorer(void)
{
80106965:	55                   	push   %ebp
80106966:	89 e5                	mov    %esp,%ebp
80106968:	83 ec 18             	sub    $0x18,%esp
    int restorer_addr;
    if (argint(0, &restorer_addr) < 0)
8010696b:	83 ec 08             	sub    $0x8,%esp
8010696e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106971:	50                   	push   %eax
80106972:	6a 00                	push   $0x0
80106974:	e8 7e ee ff ff       	call   801057f7 <argint>
80106979:	83 c4 10             	add    $0x10,%esp
8010697c:	85 c0                	test   %eax,%eax
8010697e:	79 07                	jns    80106987 <sys_signal_restorer+0x22>
      return -1;
80106980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106985:	eb 14                	jmp    8010699b <sys_signal_restorer+0x36>

    proc->restorer_addr = (uint) restorer_addr;
80106987:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010698d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106990:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

    return 0;
80106996:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010699b:	c9                   	leave  
8010699c:	c3                   	ret    

8010699d <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010699d:	55                   	push   %ebp
8010699e:	89 e5                	mov    %esp,%ebp
801069a0:	83 ec 08             	sub    $0x8,%esp
801069a3:	8b 55 08             	mov    0x8(%ebp),%edx
801069a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801069a9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801069ad:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069b0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801069b4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801069b8:	ee                   	out    %al,(%dx)
}
801069b9:	90                   	nop
801069ba:	c9                   	leave  
801069bb:	c3                   	ret    

801069bc <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801069bc:	55                   	push   %ebp
801069bd:	89 e5                	mov    %esp,%ebp
801069bf:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801069c2:	6a 34                	push   $0x34
801069c4:	6a 43                	push   $0x43
801069c6:	e8 d2 ff ff ff       	call   8010699d <outb>
801069cb:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801069ce:	68 9c 00 00 00       	push   $0x9c
801069d3:	6a 40                	push   $0x40
801069d5:	e8 c3 ff ff ff       	call   8010699d <outb>
801069da:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801069dd:	6a 2e                	push   $0x2e
801069df:	6a 40                	push   $0x40
801069e1:	e8 b7 ff ff ff       	call   8010699d <outb>
801069e6:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
801069e9:	83 ec 0c             	sub    $0xc,%esp
801069ec:	6a 00                	push   $0x0
801069ee:	e8 89 d4 ff ff       	call   80103e7c <picenable>
801069f3:	83 c4 10             	add    $0x10,%esp
}
801069f6:	90                   	nop
801069f7:	c9                   	leave  
801069f8:	c3                   	ret    

801069f9 <alltraps>:
801069f9:	1e                   	push   %ds
801069fa:	06                   	push   %es
801069fb:	0f a0                	push   %fs
801069fd:	0f a8                	push   %gs
801069ff:	60                   	pusha  
80106a00:	66 b8 10 00          	mov    $0x10,%ax
80106a04:	8e d8                	mov    %eax,%ds
80106a06:	8e c0                	mov    %eax,%es
80106a08:	66 b8 18 00          	mov    $0x18,%ax
80106a0c:	8e e0                	mov    %eax,%fs
80106a0e:	8e e8                	mov    %eax,%gs
80106a10:	54                   	push   %esp
80106a11:	e8 d7 01 00 00       	call   80106bed <trap>
80106a16:	83 c4 04             	add    $0x4,%esp

80106a19 <trapret>:
80106a19:	61                   	popa   
80106a1a:	0f a9                	pop    %gs
80106a1c:	0f a1                	pop    %fs
80106a1e:	07                   	pop    %es
80106a1f:	1f                   	pop    %ds
80106a20:	83 c4 08             	add    $0x8,%esp
80106a23:	cf                   	iret   

80106a24 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106a24:	55                   	push   %ebp
80106a25:	89 e5                	mov    %esp,%ebp
80106a27:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a2d:	83 e8 01             	sub    $0x1,%eax
80106a30:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a34:	8b 45 08             	mov    0x8(%ebp),%eax
80106a37:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a3e:	c1 e8 10             	shr    $0x10,%eax
80106a41:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106a45:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106a48:	0f 01 18             	lidtl  (%eax)
}
80106a4b:	90                   	nop
80106a4c:	c9                   	leave  
80106a4d:	c3                   	ret    

80106a4e <rcr2>:
  asm volatile("movl %eax,%cr3");
}

static inline uint
rcr2(void)
{
80106a4e:	55                   	push   %ebp
80106a4f:	89 e5                	mov    %esp,%ebp
80106a51:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106a54:	0f 20 d0             	mov    %cr2,%eax
80106a57:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106a5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106a5d:	c9                   	leave  
80106a5e:	c3                   	ret    

80106a5f <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106a5f:	55                   	push   %ebp
80106a60:	89 e5                	mov    %esp,%ebp
80106a62:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106a65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106a6c:	e9 c3 00 00 00       	jmp    80106b34 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a74:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106a7b:	89 c2                	mov    %eax,%edx
80106a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a80:	66 89 14 c5 00 5c 11 	mov    %dx,-0x7feea400(,%eax,8)
80106a87:	80 
80106a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a8b:	66 c7 04 c5 02 5c 11 	movw   $0x8,-0x7feea3fe(,%eax,8)
80106a92:	80 08 00 
80106a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a98:	0f b6 14 c5 04 5c 11 	movzbl -0x7feea3fc(,%eax,8),%edx
80106a9f:	80 
80106aa0:	83 e2 e0             	and    $0xffffffe0,%edx
80106aa3:	88 14 c5 04 5c 11 80 	mov    %dl,-0x7feea3fc(,%eax,8)
80106aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aad:	0f b6 14 c5 04 5c 11 	movzbl -0x7feea3fc(,%eax,8),%edx
80106ab4:	80 
80106ab5:	83 e2 1f             	and    $0x1f,%edx
80106ab8:	88 14 c5 04 5c 11 80 	mov    %dl,-0x7feea3fc(,%eax,8)
80106abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ac2:	0f b6 14 c5 05 5c 11 	movzbl -0x7feea3fb(,%eax,8),%edx
80106ac9:	80 
80106aca:	83 e2 f0             	and    $0xfffffff0,%edx
80106acd:	83 ca 0e             	or     $0xe,%edx
80106ad0:	88 14 c5 05 5c 11 80 	mov    %dl,-0x7feea3fb(,%eax,8)
80106ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ada:	0f b6 14 c5 05 5c 11 	movzbl -0x7feea3fb(,%eax,8),%edx
80106ae1:	80 
80106ae2:	83 e2 ef             	and    $0xffffffef,%edx
80106ae5:	88 14 c5 05 5c 11 80 	mov    %dl,-0x7feea3fb(,%eax,8)
80106aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aef:	0f b6 14 c5 05 5c 11 	movzbl -0x7feea3fb(,%eax,8),%edx
80106af6:	80 
80106af7:	83 e2 9f             	and    $0xffffff9f,%edx
80106afa:	88 14 c5 05 5c 11 80 	mov    %dl,-0x7feea3fb(,%eax,8)
80106b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b04:	0f b6 14 c5 05 5c 11 	movzbl -0x7feea3fb(,%eax,8),%edx
80106b0b:	80 
80106b0c:	83 ca 80             	or     $0xffffff80,%edx
80106b0f:	88 14 c5 05 5c 11 80 	mov    %dl,-0x7feea3fb(,%eax,8)
80106b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b19:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106b20:	c1 e8 10             	shr    $0x10,%eax
80106b23:	89 c2                	mov    %eax,%edx
80106b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b28:	66 89 14 c5 06 5c 11 	mov    %dx,-0x7feea3fa(,%eax,8)
80106b2f:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106b30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b34:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106b3b:	0f 8e 30 ff ff ff    	jle    80106a71 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106b41:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106b46:	66 a3 00 5e 11 80    	mov    %ax,0x80115e00
80106b4c:	66 c7 05 02 5e 11 80 	movw   $0x8,0x80115e02
80106b53:	08 00 
80106b55:	0f b6 05 04 5e 11 80 	movzbl 0x80115e04,%eax
80106b5c:	83 e0 e0             	and    $0xffffffe0,%eax
80106b5f:	a2 04 5e 11 80       	mov    %al,0x80115e04
80106b64:	0f b6 05 04 5e 11 80 	movzbl 0x80115e04,%eax
80106b6b:	83 e0 1f             	and    $0x1f,%eax
80106b6e:	a2 04 5e 11 80       	mov    %al,0x80115e04
80106b73:	0f b6 05 05 5e 11 80 	movzbl 0x80115e05,%eax
80106b7a:	83 c8 0f             	or     $0xf,%eax
80106b7d:	a2 05 5e 11 80       	mov    %al,0x80115e05
80106b82:	0f b6 05 05 5e 11 80 	movzbl 0x80115e05,%eax
80106b89:	83 e0 ef             	and    $0xffffffef,%eax
80106b8c:	a2 05 5e 11 80       	mov    %al,0x80115e05
80106b91:	0f b6 05 05 5e 11 80 	movzbl 0x80115e05,%eax
80106b98:	83 c8 60             	or     $0x60,%eax
80106b9b:	a2 05 5e 11 80       	mov    %al,0x80115e05
80106ba0:	0f b6 05 05 5e 11 80 	movzbl 0x80115e05,%eax
80106ba7:	83 c8 80             	or     $0xffffff80,%eax
80106baa:	a2 05 5e 11 80       	mov    %al,0x80115e05
80106baf:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106bb4:	c1 e8 10             	shr    $0x10,%eax
80106bb7:	66 a3 06 5e 11 80    	mov    %ax,0x80115e06

  initlock(&tickslock, "time");
80106bbd:	83 ec 08             	sub    $0x8,%esp
80106bc0:	68 ac 90 10 80       	push   $0x801090ac
80106bc5:	68 c0 5b 11 80       	push   $0x80115bc0
80106bca:	e8 7e e6 ff ff       	call   8010524d <initlock>
80106bcf:	83 c4 10             	add    $0x10,%esp
}
80106bd2:	90                   	nop
80106bd3:	c9                   	leave  
80106bd4:	c3                   	ret    

80106bd5 <idtinit>:

void
idtinit(void)
{
80106bd5:	55                   	push   %ebp
80106bd6:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106bd8:	68 00 08 00 00       	push   $0x800
80106bdd:	68 00 5c 11 80       	push   $0x80115c00
80106be2:	e8 3d fe ff ff       	call   80106a24 <lidt>
80106be7:	83 c4 08             	add    $0x8,%esp
}
80106bea:	90                   	nop
80106beb:	c9                   	leave  
80106bec:	c3                   	ret    

80106bed <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106bed:	55                   	push   %ebp
80106bee:	89 e5                	mov    %esp,%ebp
80106bf0:	57                   	push   %edi
80106bf1:	56                   	push   %esi
80106bf2:	53                   	push   %ebx
80106bf3:	83 ec 2c             	sub    $0x2c,%esp
  siginfo_t si;
  if(tf->trapno == T_SYSCALL){
80106bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80106bf9:	8b 40 30             	mov    0x30(%eax),%eax
80106bfc:	83 f8 40             	cmp    $0x40,%eax
80106bff:	75 3e                	jne    80106c3f <trap+0x52>
    if(proc->killed)
80106c01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c07:	8b 40 24             	mov    0x24(%eax),%eax
80106c0a:	85 c0                	test   %eax,%eax
80106c0c:	74 05                	je     80106c13 <trap+0x26>
      exit();
80106c0e:	e8 c1 dd ff ff       	call   801049d4 <exit>
    proc->tf = tf;
80106c13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c19:	8b 55 08             	mov    0x8(%ebp),%edx
80106c1c:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106c1f:	e8 89 ec ff ff       	call   801058ad <syscall>
    if(proc->killed)
80106c24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c2a:	8b 40 24             	mov    0x24(%eax),%eax
80106c2d:	85 c0                	test   %eax,%eax
80106c2f:	0f 84 00 03 00 00    	je     80106f35 <trap+0x348>
      exit();
80106c35:	e8 9a dd ff ff       	call   801049d4 <exit>
80106c3a:	e9 f7 02 00 00       	jmp    80106f36 <trap+0x349>
    return;
  }

  switch(tf->trapno){
80106c3f:	8b 45 08             	mov    0x8(%ebp),%eax
80106c42:	8b 40 30             	mov    0x30(%eax),%eax
80106c45:	83 f8 3f             	cmp    $0x3f,%eax
80106c48:	0f 87 a5 01 00 00    	ja     80106df3 <trap+0x206>
80106c4e:	8b 04 85 a4 91 10 80 	mov    -0x7fef6e5c(,%eax,4),%eax
80106c55:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106c57:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106c5d:	0f b6 00             	movzbl (%eax),%eax
80106c60:	84 c0                	test   %al,%al
80106c62:	75 3d                	jne    80106ca1 <trap+0xb4>
      acquire(&tickslock);
80106c64:	83 ec 0c             	sub    $0xc,%esp
80106c67:	68 c0 5b 11 80       	push   $0x80115bc0
80106c6c:	e8 fe e5 ff ff       	call   8010526f <acquire>
80106c71:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106c74:	a1 00 64 11 80       	mov    0x80116400,%eax
80106c79:	83 c0 01             	add    $0x1,%eax
80106c7c:	a3 00 64 11 80       	mov    %eax,0x80116400
      wakeup(&ticks);
80106c81:	83 ec 0c             	sub    $0xc,%esp
80106c84:	68 00 64 11 80       	push   $0x80116400
80106c89:	e8 66 e2 ff ff       	call   80104ef4 <wakeup>
80106c8e:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106c91:	83 ec 0c             	sub    $0xc,%esp
80106c94:	68 c0 5b 11 80       	push   $0x80115bc0
80106c99:	e8 38 e6 ff ff       	call   801052d6 <release>
80106c9e:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106ca1:	e8 de c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106ca6:	e9 04 02 00 00       	jmp    80106eaf <trap+0x2c2>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106cab:	e8 e7 ba ff ff       	call   80102797 <ideintr>
    lapiceoi();
80106cb0:	e8 cf c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106cb5:	e9 f5 01 00 00       	jmp    80106eaf <trap+0x2c2>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106cba:	e8 c7 c0 ff ff       	call   80102d86 <kbdintr>
    lapiceoi();
80106cbf:	e8 c0 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106cc4:	e9 e6 01 00 00       	jmp    80106eaf <trap+0x2c2>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106cc9:	e8 48 04 00 00       	call   80107116 <uartintr>
    lapiceoi();
80106cce:	e8 b1 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106cd3:	e9 d7 01 00 00       	jmp    80106eaf <trap+0x2c2>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106cd8:	8b 45 08             	mov    0x8(%ebp),%eax
80106cdb:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106cde:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106ce5:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106ce8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106cee:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106cf1:	0f b6 c0             	movzbl %al,%eax
80106cf4:	51                   	push   %ecx
80106cf5:	52                   	push   %edx
80106cf6:	50                   	push   %eax
80106cf7:	68 b4 90 10 80       	push   $0x801090b4
80106cfc:	e8 c5 96 ff ff       	call   801003c6 <cprintf>
80106d01:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106d04:	e8 7b c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d09:	e9 a1 01 00 00       	jmp    80106eaf <trap+0x2c2>

   case T_DIVIDE:
      if (proc->handlers[SIGFPE] != (sighandler_t) -1) {
80106d0e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d14:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106d1a:	83 f8 ff             	cmp    $0xffffffff,%eax
80106d1d:	74 36                	je     80106d55 <trap+0x168>
        cprintf("T_DIVIDE err\n");
80106d1f:	83 ec 0c             	sub    $0xc,%esp
80106d22:	68 d8 90 10 80       	push   $0x801090d8
80106d27:	e8 9a 96 ff ff       	call   801003c6 <cprintf>
80106d2c:	83 c4 10             	add    $0x10,%esp
        si.type= 1;
80106d2f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
        si.addr = 5;
80106d36:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%ebp)
        signal_deliver(SIGFPE,si);
80106d3d:	83 ec 04             	sub    $0x4,%esp
80106d40:	ff 75 e0             	pushl  -0x20(%ebp)
80106d43:	ff 75 dc             	pushl  -0x24(%ebp)
80106d46:	6a 01                	push   $0x1
80106d48:	e8 61 e3 ff ff       	call   801050ae <signal_deliver>
80106d4d:	83 c4 10             	add    $0x10,%esp
        break;
80106d50:	e9 5a 01 00 00       	jmp    80106eaf <trap+0x2c2>
      }
    //handle pgfault with mem_protect
    case T_PGFLT:
      //create a siginfo_t struct
      cprintf(" PAGEFULT !!err : 0x%x\n",tf->err);
80106d55:	8b 45 08             	mov    0x8(%ebp),%eax
80106d58:	8b 40 34             	mov    0x34(%eax),%eax
80106d5b:	83 ec 08             	sub    $0x8,%esp
80106d5e:	50                   	push   %eax
80106d5f:	68 e6 90 10 80       	push   $0x801090e6
80106d64:	e8 5d 96 ff ff       	call   801003c6 <cprintf>
80106d69:	83 c4 10             	add    $0x10,%esp

      if (proc->handlers[SIGSEGV] != (sighandler_t) -1) {
80106d6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d72:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
80106d78:	83 f8 ff             	cmp    $0xffffffff,%eax
80106d7b:	0f 84 2d 01 00 00    	je     80106eae <trap+0x2c1>
        int err = tf->err;
80106d81:	8b 45 08             	mov    0x8(%ebp),%eax
80106d84:	8b 40 34             	mov    0x34(%eax),%eax
80106d87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(err == 0x4 || err == 0x6 || err == 0x5) {
80106d8a:	83 7d e4 04          	cmpl   $0x4,-0x1c(%ebp)
80106d8e:	74 0c                	je     80106d9c <trap+0x1af>
80106d90:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
80106d94:	74 06                	je     80106d9c <trap+0x1af>
80106d96:	83 7d e4 05          	cmpl   $0x5,-0x1c(%ebp)
80106d9a:	75 09                	jne    80106da5 <trap+0x1b8>
          si.type = PROT_NONE;
80106d9c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106da3:	eb 16                	jmp    80106dbb <trap+0x1ce>
        } else if(err == 0x7) {
80106da5:	83 7d e4 07          	cmpl   $0x7,-0x1c(%ebp)
80106da9:	75 09                	jne    80106db4 <trap+0x1c7>
          si.type = PROT_READ;
80106dab:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80106db2:	eb 07                	jmp    80106dbb <trap+0x1ce>
        } else {
          si.type = PROT_WRITE;
80106db4:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
        }
        si.addr = rcr2();
80106dbb:	e8 8e fc ff ff       	call   80106a4e <rcr2>
80106dc0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        cprintf(" PAGE FAULT addr: 0x%x addrtype: 0x%x\n",si.addr,si.type);
80106dc3:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106dc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106dc9:	83 ec 04             	sub    $0x4,%esp
80106dcc:	52                   	push   %edx
80106dcd:	50                   	push   %eax
80106dce:	68 00 91 10 80       	push   $0x80109100
80106dd3:	e8 ee 95 ff ff       	call   801003c6 <cprintf>
80106dd8:	83 c4 10             	add    $0x10,%esp
        signal_deliver(SIGSEGV,si);
80106ddb:	83 ec 04             	sub    $0x4,%esp
80106dde:	ff 75 e0             	pushl  -0x20(%ebp)
80106de1:	ff 75 dc             	pushl  -0x24(%ebp)
80106de4:	6a 0e                	push   $0xe
80106de6:	e8 c3 e2 ff ff       	call   801050ae <signal_deliver>
80106deb:	83 c4 10             	add    $0x10,%esp
        break;
80106dee:	e9 bc 00 00 00       	jmp    80106eaf <trap+0x2c2>

      break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106df3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106df9:	85 c0                	test   %eax,%eax
80106dfb:	74 11                	je     80106e0e <trap+0x221>
80106dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80106e00:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e04:	0f b7 c0             	movzwl %ax,%eax
80106e07:	83 e0 03             	and    $0x3,%eax
80106e0a:	85 c0                	test   %eax,%eax
80106e0c:	75 40                	jne    80106e4e <trap+0x261>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e0e:	e8 3b fc ff ff       	call   80106a4e <rcr2>
80106e13:	89 c3                	mov    %eax,%ebx
80106e15:	8b 45 08             	mov    0x8(%ebp),%eax
80106e18:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106e1b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e21:	0f b6 00             	movzbl (%eax),%eax

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e24:	0f b6 d0             	movzbl %al,%edx
80106e27:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2a:	8b 40 30             	mov    0x30(%eax),%eax
80106e2d:	83 ec 0c             	sub    $0xc,%esp
80106e30:	53                   	push   %ebx
80106e31:	51                   	push   %ecx
80106e32:	52                   	push   %edx
80106e33:	50                   	push   %eax
80106e34:	68 28 91 10 80       	push   $0x80109128
80106e39:	e8 88 95 ff ff       	call   801003c6 <cprintf>
80106e3e:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106e41:	83 ec 0c             	sub    $0xc,%esp
80106e44:	68 5a 91 10 80       	push   $0x8010915a
80106e49:	e8 18 97 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e4e:	e8 fb fb ff ff       	call   80106a4e <rcr2>
80106e53:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106e56:	8b 45 08             	mov    0x8(%ebp),%eax
80106e59:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106e5c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e62:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e65:	0f b6 d8             	movzbl %al,%ebx
80106e68:	8b 45 08             	mov    0x8(%ebp),%eax
80106e6b:	8b 48 34             	mov    0x34(%eax),%ecx
80106e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80106e71:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106e74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e7a:	8d 78 6c             	lea    0x6c(%eax),%edi
80106e7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e83:	8b 40 10             	mov    0x10(%eax),%eax
80106e86:	ff 75 d4             	pushl  -0x2c(%ebp)
80106e89:	56                   	push   %esi
80106e8a:	53                   	push   %ebx
80106e8b:	51                   	push   %ecx
80106e8c:	52                   	push   %edx
80106e8d:	57                   	push   %edi
80106e8e:	50                   	push   %eax
80106e8f:	68 60 91 10 80       	push   $0x80109160
80106e94:	e8 2d 95 ff ff       	call   801003c6 <cprintf>
80106e99:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
            rcr2());
    proc->killed = 1;
80106e9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ea2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106ea9:	eb 04                	jmp    80106eaf <trap+0x2c2>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106eab:	90                   	nop
80106eac:	eb 01                	jmp    80106eaf <trap+0x2c2>
        cprintf(" PAGE FAULT addr: 0x%x addrtype: 0x%x\n",si.addr,si.type);
        signal_deliver(SIGSEGV,si);
        break;
      }

      break;
80106eae:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106eaf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106eb5:	85 c0                	test   %eax,%eax
80106eb7:	74 24                	je     80106edd <trap+0x2f0>
80106eb9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ebf:	8b 40 24             	mov    0x24(%eax),%eax
80106ec2:	85 c0                	test   %eax,%eax
80106ec4:	74 17                	je     80106edd <trap+0x2f0>
80106ec6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ec9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ecd:	0f b7 c0             	movzwl %ax,%eax
80106ed0:	83 e0 03             	and    $0x3,%eax
80106ed3:	83 f8 03             	cmp    $0x3,%eax
80106ed6:	75 05                	jne    80106edd <trap+0x2f0>
    exit();
80106ed8:	e8 f7 da ff ff       	call   801049d4 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106edd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ee3:	85 c0                	test   %eax,%eax
80106ee5:	74 1e                	je     80106f05 <trap+0x318>
80106ee7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106eed:	8b 40 0c             	mov    0xc(%eax),%eax
80106ef0:	83 f8 04             	cmp    $0x4,%eax
80106ef3:	75 10                	jne    80106f05 <trap+0x318>
80106ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80106ef8:	8b 40 30             	mov    0x30(%eax),%eax
80106efb:	83 f8 20             	cmp    $0x20,%eax
80106efe:	75 05                	jne    80106f05 <trap+0x318>
    yield();
80106f00:	e8 95 de ff ff       	call   80104d9a <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106f05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f0b:	85 c0                	test   %eax,%eax
80106f0d:	74 27                	je     80106f36 <trap+0x349>
80106f0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f15:	8b 40 24             	mov    0x24(%eax),%eax
80106f18:	85 c0                	test   %eax,%eax
80106f1a:	74 1a                	je     80106f36 <trap+0x349>
80106f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f1f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f23:	0f b7 c0             	movzwl %ax,%eax
80106f26:	83 e0 03             	and    $0x3,%eax
80106f29:	83 f8 03             	cmp    $0x3,%eax
80106f2c:	75 08                	jne    80106f36 <trap+0x349>
    exit();
80106f2e:	e8 a1 da ff ff       	call   801049d4 <exit>
80106f33:	eb 01                	jmp    80106f36 <trap+0x349>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106f35:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f39:	5b                   	pop    %ebx
80106f3a:	5e                   	pop    %esi
80106f3b:	5f                   	pop    %edi
80106f3c:	5d                   	pop    %ebp
80106f3d:	c3                   	ret    

80106f3e <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106f3e:	55                   	push   %ebp
80106f3f:	89 e5                	mov    %esp,%ebp
80106f41:	83 ec 14             	sub    $0x14,%esp
80106f44:	8b 45 08             	mov    0x8(%ebp),%eax
80106f47:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f4b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106f4f:	89 c2                	mov    %eax,%edx
80106f51:	ec                   	in     (%dx),%al
80106f52:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106f55:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106f59:	c9                   	leave  
80106f5a:	c3                   	ret    

80106f5b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106f5b:	55                   	push   %ebp
80106f5c:	89 e5                	mov    %esp,%ebp
80106f5e:	83 ec 08             	sub    $0x8,%esp
80106f61:	8b 55 08             	mov    0x8(%ebp),%edx
80106f64:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f67:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106f6b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f6e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106f72:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106f76:	ee                   	out    %al,(%dx)
}
80106f77:	90                   	nop
80106f78:	c9                   	leave  
80106f79:	c3                   	ret    

80106f7a <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106f7a:	55                   	push   %ebp
80106f7b:	89 e5                	mov    %esp,%ebp
80106f7d:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106f80:	6a 00                	push   $0x0
80106f82:	68 fa 03 00 00       	push   $0x3fa
80106f87:	e8 cf ff ff ff       	call   80106f5b <outb>
80106f8c:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106f8f:	68 80 00 00 00       	push   $0x80
80106f94:	68 fb 03 00 00       	push   $0x3fb
80106f99:	e8 bd ff ff ff       	call   80106f5b <outb>
80106f9e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106fa1:	6a 0c                	push   $0xc
80106fa3:	68 f8 03 00 00       	push   $0x3f8
80106fa8:	e8 ae ff ff ff       	call   80106f5b <outb>
80106fad:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106fb0:	6a 00                	push   $0x0
80106fb2:	68 f9 03 00 00       	push   $0x3f9
80106fb7:	e8 9f ff ff ff       	call   80106f5b <outb>
80106fbc:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106fbf:	6a 03                	push   $0x3
80106fc1:	68 fb 03 00 00       	push   $0x3fb
80106fc6:	e8 90 ff ff ff       	call   80106f5b <outb>
80106fcb:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106fce:	6a 00                	push   $0x0
80106fd0:	68 fc 03 00 00       	push   $0x3fc
80106fd5:	e8 81 ff ff ff       	call   80106f5b <outb>
80106fda:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106fdd:	6a 01                	push   $0x1
80106fdf:	68 f9 03 00 00       	push   $0x3f9
80106fe4:	e8 72 ff ff ff       	call   80106f5b <outb>
80106fe9:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106fec:	68 fd 03 00 00       	push   $0x3fd
80106ff1:	e8 48 ff ff ff       	call   80106f3e <inb>
80106ff6:	83 c4 04             	add    $0x4,%esp
80106ff9:	3c ff                	cmp    $0xff,%al
80106ffb:	74 6e                	je     8010706b <uartinit+0xf1>
    return;
  uart = 1;
80106ffd:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80107004:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107007:	68 fa 03 00 00       	push   $0x3fa
8010700c:	e8 2d ff ff ff       	call   80106f3e <inb>
80107011:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107014:	68 f8 03 00 00       	push   $0x3f8
80107019:	e8 20 ff ff ff       	call   80106f3e <inb>
8010701e:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107021:	83 ec 0c             	sub    $0xc,%esp
80107024:	6a 04                	push   $0x4
80107026:	e8 51 ce ff ff       	call   80103e7c <picenable>
8010702b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
8010702e:	83 ec 08             	sub    $0x8,%esp
80107031:	6a 00                	push   $0x0
80107033:	6a 04                	push   $0x4
80107035:	e8 ff b9 ff ff       	call   80102a39 <ioapicenable>
8010703a:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010703d:	c7 45 f4 a4 92 10 80 	movl   $0x801092a4,-0xc(%ebp)
80107044:	eb 19                	jmp    8010705f <uartinit+0xe5>
    uartputc(*p);
80107046:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107049:	0f b6 00             	movzbl (%eax),%eax
8010704c:	0f be c0             	movsbl %al,%eax
8010704f:	83 ec 0c             	sub    $0xc,%esp
80107052:	50                   	push   %eax
80107053:	e8 16 00 00 00       	call   8010706e <uartputc>
80107058:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010705b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010705f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107062:	0f b6 00             	movzbl (%eax),%eax
80107065:	84 c0                	test   %al,%al
80107067:	75 dd                	jne    80107046 <uartinit+0xcc>
80107069:	eb 01                	jmp    8010706c <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010706b:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010706c:	c9                   	leave  
8010706d:	c3                   	ret    

8010706e <uartputc>:

void
uartputc(int c)
{
8010706e:	55                   	push   %ebp
8010706f:	89 e5                	mov    %esp,%ebp
80107071:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107074:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107079:	85 c0                	test   %eax,%eax
8010707b:	74 53                	je     801070d0 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010707d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107084:	eb 11                	jmp    80107097 <uartputc+0x29>
    microdelay(10);
80107086:	83 ec 0c             	sub    $0xc,%esp
80107089:	6a 0a                	push   $0xa
8010708b:	e8 0f bf ff ff       	call   80102f9f <microdelay>
80107090:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107093:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107097:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010709b:	7f 1a                	jg     801070b7 <uartputc+0x49>
8010709d:	83 ec 0c             	sub    $0xc,%esp
801070a0:	68 fd 03 00 00       	push   $0x3fd
801070a5:	e8 94 fe ff ff       	call   80106f3e <inb>
801070aa:	83 c4 10             	add    $0x10,%esp
801070ad:	0f b6 c0             	movzbl %al,%eax
801070b0:	83 e0 20             	and    $0x20,%eax
801070b3:	85 c0                	test   %eax,%eax
801070b5:	74 cf                	je     80107086 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801070b7:	8b 45 08             	mov    0x8(%ebp),%eax
801070ba:	0f b6 c0             	movzbl %al,%eax
801070bd:	83 ec 08             	sub    $0x8,%esp
801070c0:	50                   	push   %eax
801070c1:	68 f8 03 00 00       	push   $0x3f8
801070c6:	e8 90 fe ff ff       	call   80106f5b <outb>
801070cb:	83 c4 10             	add    $0x10,%esp
801070ce:	eb 01                	jmp    801070d1 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801070d0:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801070d1:	c9                   	leave  
801070d2:	c3                   	ret    

801070d3 <uartgetc>:

static int
uartgetc(void)
{
801070d3:	55                   	push   %ebp
801070d4:	89 e5                	mov    %esp,%ebp
  if(!uart)
801070d6:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801070db:	85 c0                	test   %eax,%eax
801070dd:	75 07                	jne    801070e6 <uartgetc+0x13>
    return -1;
801070df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070e4:	eb 2e                	jmp    80107114 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801070e6:	68 fd 03 00 00       	push   $0x3fd
801070eb:	e8 4e fe ff ff       	call   80106f3e <inb>
801070f0:	83 c4 04             	add    $0x4,%esp
801070f3:	0f b6 c0             	movzbl %al,%eax
801070f6:	83 e0 01             	and    $0x1,%eax
801070f9:	85 c0                	test   %eax,%eax
801070fb:	75 07                	jne    80107104 <uartgetc+0x31>
    return -1;
801070fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107102:	eb 10                	jmp    80107114 <uartgetc+0x41>
  return inb(COM1+0);
80107104:	68 f8 03 00 00       	push   $0x3f8
80107109:	e8 30 fe ff ff       	call   80106f3e <inb>
8010710e:	83 c4 04             	add    $0x4,%esp
80107111:	0f b6 c0             	movzbl %al,%eax
}
80107114:	c9                   	leave  
80107115:	c3                   	ret    

80107116 <uartintr>:

void
uartintr(void)
{
80107116:	55                   	push   %ebp
80107117:	89 e5                	mov    %esp,%ebp
80107119:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010711c:	83 ec 0c             	sub    $0xc,%esp
8010711f:	68 d3 70 10 80       	push   $0x801070d3
80107124:	e8 b4 96 ff ff       	call   801007dd <consoleintr>
80107129:	83 c4 10             	add    $0x10,%esp
}
8010712c:	90                   	nop
8010712d:	c9                   	leave  
8010712e:	c3                   	ret    

8010712f <vector0>:
8010712f:	6a 00                	push   $0x0
80107131:	6a 00                	push   $0x0
80107133:	e9 c1 f8 ff ff       	jmp    801069f9 <alltraps>

80107138 <vector1>:
80107138:	6a 00                	push   $0x0
8010713a:	6a 01                	push   $0x1
8010713c:	e9 b8 f8 ff ff       	jmp    801069f9 <alltraps>

80107141 <vector2>:
80107141:	6a 00                	push   $0x0
80107143:	6a 02                	push   $0x2
80107145:	e9 af f8 ff ff       	jmp    801069f9 <alltraps>

8010714a <vector3>:
8010714a:	6a 00                	push   $0x0
8010714c:	6a 03                	push   $0x3
8010714e:	e9 a6 f8 ff ff       	jmp    801069f9 <alltraps>

80107153 <vector4>:
80107153:	6a 00                	push   $0x0
80107155:	6a 04                	push   $0x4
80107157:	e9 9d f8 ff ff       	jmp    801069f9 <alltraps>

8010715c <vector5>:
8010715c:	6a 00                	push   $0x0
8010715e:	6a 05                	push   $0x5
80107160:	e9 94 f8 ff ff       	jmp    801069f9 <alltraps>

80107165 <vector6>:
80107165:	6a 00                	push   $0x0
80107167:	6a 06                	push   $0x6
80107169:	e9 8b f8 ff ff       	jmp    801069f9 <alltraps>

8010716e <vector7>:
8010716e:	6a 00                	push   $0x0
80107170:	6a 07                	push   $0x7
80107172:	e9 82 f8 ff ff       	jmp    801069f9 <alltraps>

80107177 <vector8>:
80107177:	6a 08                	push   $0x8
80107179:	e9 7b f8 ff ff       	jmp    801069f9 <alltraps>

8010717e <vector9>:
8010717e:	6a 00                	push   $0x0
80107180:	6a 09                	push   $0x9
80107182:	e9 72 f8 ff ff       	jmp    801069f9 <alltraps>

80107187 <vector10>:
80107187:	6a 0a                	push   $0xa
80107189:	e9 6b f8 ff ff       	jmp    801069f9 <alltraps>

8010718e <vector11>:
8010718e:	6a 0b                	push   $0xb
80107190:	e9 64 f8 ff ff       	jmp    801069f9 <alltraps>

80107195 <vector12>:
80107195:	6a 0c                	push   $0xc
80107197:	e9 5d f8 ff ff       	jmp    801069f9 <alltraps>

8010719c <vector13>:
8010719c:	6a 0d                	push   $0xd
8010719e:	e9 56 f8 ff ff       	jmp    801069f9 <alltraps>

801071a3 <vector14>:
801071a3:	6a 0e                	push   $0xe
801071a5:	e9 4f f8 ff ff       	jmp    801069f9 <alltraps>

801071aa <vector15>:
801071aa:	6a 00                	push   $0x0
801071ac:	6a 0f                	push   $0xf
801071ae:	e9 46 f8 ff ff       	jmp    801069f9 <alltraps>

801071b3 <vector16>:
801071b3:	6a 00                	push   $0x0
801071b5:	6a 10                	push   $0x10
801071b7:	e9 3d f8 ff ff       	jmp    801069f9 <alltraps>

801071bc <vector17>:
801071bc:	6a 11                	push   $0x11
801071be:	e9 36 f8 ff ff       	jmp    801069f9 <alltraps>

801071c3 <vector18>:
801071c3:	6a 00                	push   $0x0
801071c5:	6a 12                	push   $0x12
801071c7:	e9 2d f8 ff ff       	jmp    801069f9 <alltraps>

801071cc <vector19>:
801071cc:	6a 00                	push   $0x0
801071ce:	6a 13                	push   $0x13
801071d0:	e9 24 f8 ff ff       	jmp    801069f9 <alltraps>

801071d5 <vector20>:
801071d5:	6a 00                	push   $0x0
801071d7:	6a 14                	push   $0x14
801071d9:	e9 1b f8 ff ff       	jmp    801069f9 <alltraps>

801071de <vector21>:
801071de:	6a 00                	push   $0x0
801071e0:	6a 15                	push   $0x15
801071e2:	e9 12 f8 ff ff       	jmp    801069f9 <alltraps>

801071e7 <vector22>:
801071e7:	6a 00                	push   $0x0
801071e9:	6a 16                	push   $0x16
801071eb:	e9 09 f8 ff ff       	jmp    801069f9 <alltraps>

801071f0 <vector23>:
801071f0:	6a 00                	push   $0x0
801071f2:	6a 17                	push   $0x17
801071f4:	e9 00 f8 ff ff       	jmp    801069f9 <alltraps>

801071f9 <vector24>:
801071f9:	6a 00                	push   $0x0
801071fb:	6a 18                	push   $0x18
801071fd:	e9 f7 f7 ff ff       	jmp    801069f9 <alltraps>

80107202 <vector25>:
80107202:	6a 00                	push   $0x0
80107204:	6a 19                	push   $0x19
80107206:	e9 ee f7 ff ff       	jmp    801069f9 <alltraps>

8010720b <vector26>:
8010720b:	6a 00                	push   $0x0
8010720d:	6a 1a                	push   $0x1a
8010720f:	e9 e5 f7 ff ff       	jmp    801069f9 <alltraps>

80107214 <vector27>:
80107214:	6a 00                	push   $0x0
80107216:	6a 1b                	push   $0x1b
80107218:	e9 dc f7 ff ff       	jmp    801069f9 <alltraps>

8010721d <vector28>:
8010721d:	6a 00                	push   $0x0
8010721f:	6a 1c                	push   $0x1c
80107221:	e9 d3 f7 ff ff       	jmp    801069f9 <alltraps>

80107226 <vector29>:
80107226:	6a 00                	push   $0x0
80107228:	6a 1d                	push   $0x1d
8010722a:	e9 ca f7 ff ff       	jmp    801069f9 <alltraps>

8010722f <vector30>:
8010722f:	6a 00                	push   $0x0
80107231:	6a 1e                	push   $0x1e
80107233:	e9 c1 f7 ff ff       	jmp    801069f9 <alltraps>

80107238 <vector31>:
80107238:	6a 00                	push   $0x0
8010723a:	6a 1f                	push   $0x1f
8010723c:	e9 b8 f7 ff ff       	jmp    801069f9 <alltraps>

80107241 <vector32>:
80107241:	6a 00                	push   $0x0
80107243:	6a 20                	push   $0x20
80107245:	e9 af f7 ff ff       	jmp    801069f9 <alltraps>

8010724a <vector33>:
8010724a:	6a 00                	push   $0x0
8010724c:	6a 21                	push   $0x21
8010724e:	e9 a6 f7 ff ff       	jmp    801069f9 <alltraps>

80107253 <vector34>:
80107253:	6a 00                	push   $0x0
80107255:	6a 22                	push   $0x22
80107257:	e9 9d f7 ff ff       	jmp    801069f9 <alltraps>

8010725c <vector35>:
8010725c:	6a 00                	push   $0x0
8010725e:	6a 23                	push   $0x23
80107260:	e9 94 f7 ff ff       	jmp    801069f9 <alltraps>

80107265 <vector36>:
80107265:	6a 00                	push   $0x0
80107267:	6a 24                	push   $0x24
80107269:	e9 8b f7 ff ff       	jmp    801069f9 <alltraps>

8010726e <vector37>:
8010726e:	6a 00                	push   $0x0
80107270:	6a 25                	push   $0x25
80107272:	e9 82 f7 ff ff       	jmp    801069f9 <alltraps>

80107277 <vector38>:
80107277:	6a 00                	push   $0x0
80107279:	6a 26                	push   $0x26
8010727b:	e9 79 f7 ff ff       	jmp    801069f9 <alltraps>

80107280 <vector39>:
80107280:	6a 00                	push   $0x0
80107282:	6a 27                	push   $0x27
80107284:	e9 70 f7 ff ff       	jmp    801069f9 <alltraps>

80107289 <vector40>:
80107289:	6a 00                	push   $0x0
8010728b:	6a 28                	push   $0x28
8010728d:	e9 67 f7 ff ff       	jmp    801069f9 <alltraps>

80107292 <vector41>:
80107292:	6a 00                	push   $0x0
80107294:	6a 29                	push   $0x29
80107296:	e9 5e f7 ff ff       	jmp    801069f9 <alltraps>

8010729b <vector42>:
8010729b:	6a 00                	push   $0x0
8010729d:	6a 2a                	push   $0x2a
8010729f:	e9 55 f7 ff ff       	jmp    801069f9 <alltraps>

801072a4 <vector43>:
801072a4:	6a 00                	push   $0x0
801072a6:	6a 2b                	push   $0x2b
801072a8:	e9 4c f7 ff ff       	jmp    801069f9 <alltraps>

801072ad <vector44>:
801072ad:	6a 00                	push   $0x0
801072af:	6a 2c                	push   $0x2c
801072b1:	e9 43 f7 ff ff       	jmp    801069f9 <alltraps>

801072b6 <vector45>:
801072b6:	6a 00                	push   $0x0
801072b8:	6a 2d                	push   $0x2d
801072ba:	e9 3a f7 ff ff       	jmp    801069f9 <alltraps>

801072bf <vector46>:
801072bf:	6a 00                	push   $0x0
801072c1:	6a 2e                	push   $0x2e
801072c3:	e9 31 f7 ff ff       	jmp    801069f9 <alltraps>

801072c8 <vector47>:
801072c8:	6a 00                	push   $0x0
801072ca:	6a 2f                	push   $0x2f
801072cc:	e9 28 f7 ff ff       	jmp    801069f9 <alltraps>

801072d1 <vector48>:
801072d1:	6a 00                	push   $0x0
801072d3:	6a 30                	push   $0x30
801072d5:	e9 1f f7 ff ff       	jmp    801069f9 <alltraps>

801072da <vector49>:
801072da:	6a 00                	push   $0x0
801072dc:	6a 31                	push   $0x31
801072de:	e9 16 f7 ff ff       	jmp    801069f9 <alltraps>

801072e3 <vector50>:
801072e3:	6a 00                	push   $0x0
801072e5:	6a 32                	push   $0x32
801072e7:	e9 0d f7 ff ff       	jmp    801069f9 <alltraps>

801072ec <vector51>:
801072ec:	6a 00                	push   $0x0
801072ee:	6a 33                	push   $0x33
801072f0:	e9 04 f7 ff ff       	jmp    801069f9 <alltraps>

801072f5 <vector52>:
801072f5:	6a 00                	push   $0x0
801072f7:	6a 34                	push   $0x34
801072f9:	e9 fb f6 ff ff       	jmp    801069f9 <alltraps>

801072fe <vector53>:
801072fe:	6a 00                	push   $0x0
80107300:	6a 35                	push   $0x35
80107302:	e9 f2 f6 ff ff       	jmp    801069f9 <alltraps>

80107307 <vector54>:
80107307:	6a 00                	push   $0x0
80107309:	6a 36                	push   $0x36
8010730b:	e9 e9 f6 ff ff       	jmp    801069f9 <alltraps>

80107310 <vector55>:
80107310:	6a 00                	push   $0x0
80107312:	6a 37                	push   $0x37
80107314:	e9 e0 f6 ff ff       	jmp    801069f9 <alltraps>

80107319 <vector56>:
80107319:	6a 00                	push   $0x0
8010731b:	6a 38                	push   $0x38
8010731d:	e9 d7 f6 ff ff       	jmp    801069f9 <alltraps>

80107322 <vector57>:
80107322:	6a 00                	push   $0x0
80107324:	6a 39                	push   $0x39
80107326:	e9 ce f6 ff ff       	jmp    801069f9 <alltraps>

8010732b <vector58>:
8010732b:	6a 00                	push   $0x0
8010732d:	6a 3a                	push   $0x3a
8010732f:	e9 c5 f6 ff ff       	jmp    801069f9 <alltraps>

80107334 <vector59>:
80107334:	6a 00                	push   $0x0
80107336:	6a 3b                	push   $0x3b
80107338:	e9 bc f6 ff ff       	jmp    801069f9 <alltraps>

8010733d <vector60>:
8010733d:	6a 00                	push   $0x0
8010733f:	6a 3c                	push   $0x3c
80107341:	e9 b3 f6 ff ff       	jmp    801069f9 <alltraps>

80107346 <vector61>:
80107346:	6a 00                	push   $0x0
80107348:	6a 3d                	push   $0x3d
8010734a:	e9 aa f6 ff ff       	jmp    801069f9 <alltraps>

8010734f <vector62>:
8010734f:	6a 00                	push   $0x0
80107351:	6a 3e                	push   $0x3e
80107353:	e9 a1 f6 ff ff       	jmp    801069f9 <alltraps>

80107358 <vector63>:
80107358:	6a 00                	push   $0x0
8010735a:	6a 3f                	push   $0x3f
8010735c:	e9 98 f6 ff ff       	jmp    801069f9 <alltraps>

80107361 <vector64>:
80107361:	6a 00                	push   $0x0
80107363:	6a 40                	push   $0x40
80107365:	e9 8f f6 ff ff       	jmp    801069f9 <alltraps>

8010736a <vector65>:
8010736a:	6a 00                	push   $0x0
8010736c:	6a 41                	push   $0x41
8010736e:	e9 86 f6 ff ff       	jmp    801069f9 <alltraps>

80107373 <vector66>:
80107373:	6a 00                	push   $0x0
80107375:	6a 42                	push   $0x42
80107377:	e9 7d f6 ff ff       	jmp    801069f9 <alltraps>

8010737c <vector67>:
8010737c:	6a 00                	push   $0x0
8010737e:	6a 43                	push   $0x43
80107380:	e9 74 f6 ff ff       	jmp    801069f9 <alltraps>

80107385 <vector68>:
80107385:	6a 00                	push   $0x0
80107387:	6a 44                	push   $0x44
80107389:	e9 6b f6 ff ff       	jmp    801069f9 <alltraps>

8010738e <vector69>:
8010738e:	6a 00                	push   $0x0
80107390:	6a 45                	push   $0x45
80107392:	e9 62 f6 ff ff       	jmp    801069f9 <alltraps>

80107397 <vector70>:
80107397:	6a 00                	push   $0x0
80107399:	6a 46                	push   $0x46
8010739b:	e9 59 f6 ff ff       	jmp    801069f9 <alltraps>

801073a0 <vector71>:
801073a0:	6a 00                	push   $0x0
801073a2:	6a 47                	push   $0x47
801073a4:	e9 50 f6 ff ff       	jmp    801069f9 <alltraps>

801073a9 <vector72>:
801073a9:	6a 00                	push   $0x0
801073ab:	6a 48                	push   $0x48
801073ad:	e9 47 f6 ff ff       	jmp    801069f9 <alltraps>

801073b2 <vector73>:
801073b2:	6a 00                	push   $0x0
801073b4:	6a 49                	push   $0x49
801073b6:	e9 3e f6 ff ff       	jmp    801069f9 <alltraps>

801073bb <vector74>:
801073bb:	6a 00                	push   $0x0
801073bd:	6a 4a                	push   $0x4a
801073bf:	e9 35 f6 ff ff       	jmp    801069f9 <alltraps>

801073c4 <vector75>:
801073c4:	6a 00                	push   $0x0
801073c6:	6a 4b                	push   $0x4b
801073c8:	e9 2c f6 ff ff       	jmp    801069f9 <alltraps>

801073cd <vector76>:
801073cd:	6a 00                	push   $0x0
801073cf:	6a 4c                	push   $0x4c
801073d1:	e9 23 f6 ff ff       	jmp    801069f9 <alltraps>

801073d6 <vector77>:
801073d6:	6a 00                	push   $0x0
801073d8:	6a 4d                	push   $0x4d
801073da:	e9 1a f6 ff ff       	jmp    801069f9 <alltraps>

801073df <vector78>:
801073df:	6a 00                	push   $0x0
801073e1:	6a 4e                	push   $0x4e
801073e3:	e9 11 f6 ff ff       	jmp    801069f9 <alltraps>

801073e8 <vector79>:
801073e8:	6a 00                	push   $0x0
801073ea:	6a 4f                	push   $0x4f
801073ec:	e9 08 f6 ff ff       	jmp    801069f9 <alltraps>

801073f1 <vector80>:
801073f1:	6a 00                	push   $0x0
801073f3:	6a 50                	push   $0x50
801073f5:	e9 ff f5 ff ff       	jmp    801069f9 <alltraps>

801073fa <vector81>:
801073fa:	6a 00                	push   $0x0
801073fc:	6a 51                	push   $0x51
801073fe:	e9 f6 f5 ff ff       	jmp    801069f9 <alltraps>

80107403 <vector82>:
80107403:	6a 00                	push   $0x0
80107405:	6a 52                	push   $0x52
80107407:	e9 ed f5 ff ff       	jmp    801069f9 <alltraps>

8010740c <vector83>:
8010740c:	6a 00                	push   $0x0
8010740e:	6a 53                	push   $0x53
80107410:	e9 e4 f5 ff ff       	jmp    801069f9 <alltraps>

80107415 <vector84>:
80107415:	6a 00                	push   $0x0
80107417:	6a 54                	push   $0x54
80107419:	e9 db f5 ff ff       	jmp    801069f9 <alltraps>

8010741e <vector85>:
8010741e:	6a 00                	push   $0x0
80107420:	6a 55                	push   $0x55
80107422:	e9 d2 f5 ff ff       	jmp    801069f9 <alltraps>

80107427 <vector86>:
80107427:	6a 00                	push   $0x0
80107429:	6a 56                	push   $0x56
8010742b:	e9 c9 f5 ff ff       	jmp    801069f9 <alltraps>

80107430 <vector87>:
80107430:	6a 00                	push   $0x0
80107432:	6a 57                	push   $0x57
80107434:	e9 c0 f5 ff ff       	jmp    801069f9 <alltraps>

80107439 <vector88>:
80107439:	6a 00                	push   $0x0
8010743b:	6a 58                	push   $0x58
8010743d:	e9 b7 f5 ff ff       	jmp    801069f9 <alltraps>

80107442 <vector89>:
80107442:	6a 00                	push   $0x0
80107444:	6a 59                	push   $0x59
80107446:	e9 ae f5 ff ff       	jmp    801069f9 <alltraps>

8010744b <vector90>:
8010744b:	6a 00                	push   $0x0
8010744d:	6a 5a                	push   $0x5a
8010744f:	e9 a5 f5 ff ff       	jmp    801069f9 <alltraps>

80107454 <vector91>:
80107454:	6a 00                	push   $0x0
80107456:	6a 5b                	push   $0x5b
80107458:	e9 9c f5 ff ff       	jmp    801069f9 <alltraps>

8010745d <vector92>:
8010745d:	6a 00                	push   $0x0
8010745f:	6a 5c                	push   $0x5c
80107461:	e9 93 f5 ff ff       	jmp    801069f9 <alltraps>

80107466 <vector93>:
80107466:	6a 00                	push   $0x0
80107468:	6a 5d                	push   $0x5d
8010746a:	e9 8a f5 ff ff       	jmp    801069f9 <alltraps>

8010746f <vector94>:
8010746f:	6a 00                	push   $0x0
80107471:	6a 5e                	push   $0x5e
80107473:	e9 81 f5 ff ff       	jmp    801069f9 <alltraps>

80107478 <vector95>:
80107478:	6a 00                	push   $0x0
8010747a:	6a 5f                	push   $0x5f
8010747c:	e9 78 f5 ff ff       	jmp    801069f9 <alltraps>

80107481 <vector96>:
80107481:	6a 00                	push   $0x0
80107483:	6a 60                	push   $0x60
80107485:	e9 6f f5 ff ff       	jmp    801069f9 <alltraps>

8010748a <vector97>:
8010748a:	6a 00                	push   $0x0
8010748c:	6a 61                	push   $0x61
8010748e:	e9 66 f5 ff ff       	jmp    801069f9 <alltraps>

80107493 <vector98>:
80107493:	6a 00                	push   $0x0
80107495:	6a 62                	push   $0x62
80107497:	e9 5d f5 ff ff       	jmp    801069f9 <alltraps>

8010749c <vector99>:
8010749c:	6a 00                	push   $0x0
8010749e:	6a 63                	push   $0x63
801074a0:	e9 54 f5 ff ff       	jmp    801069f9 <alltraps>

801074a5 <vector100>:
801074a5:	6a 00                	push   $0x0
801074a7:	6a 64                	push   $0x64
801074a9:	e9 4b f5 ff ff       	jmp    801069f9 <alltraps>

801074ae <vector101>:
801074ae:	6a 00                	push   $0x0
801074b0:	6a 65                	push   $0x65
801074b2:	e9 42 f5 ff ff       	jmp    801069f9 <alltraps>

801074b7 <vector102>:
801074b7:	6a 00                	push   $0x0
801074b9:	6a 66                	push   $0x66
801074bb:	e9 39 f5 ff ff       	jmp    801069f9 <alltraps>

801074c0 <vector103>:
801074c0:	6a 00                	push   $0x0
801074c2:	6a 67                	push   $0x67
801074c4:	e9 30 f5 ff ff       	jmp    801069f9 <alltraps>

801074c9 <vector104>:
801074c9:	6a 00                	push   $0x0
801074cb:	6a 68                	push   $0x68
801074cd:	e9 27 f5 ff ff       	jmp    801069f9 <alltraps>

801074d2 <vector105>:
801074d2:	6a 00                	push   $0x0
801074d4:	6a 69                	push   $0x69
801074d6:	e9 1e f5 ff ff       	jmp    801069f9 <alltraps>

801074db <vector106>:
801074db:	6a 00                	push   $0x0
801074dd:	6a 6a                	push   $0x6a
801074df:	e9 15 f5 ff ff       	jmp    801069f9 <alltraps>

801074e4 <vector107>:
801074e4:	6a 00                	push   $0x0
801074e6:	6a 6b                	push   $0x6b
801074e8:	e9 0c f5 ff ff       	jmp    801069f9 <alltraps>

801074ed <vector108>:
801074ed:	6a 00                	push   $0x0
801074ef:	6a 6c                	push   $0x6c
801074f1:	e9 03 f5 ff ff       	jmp    801069f9 <alltraps>

801074f6 <vector109>:
801074f6:	6a 00                	push   $0x0
801074f8:	6a 6d                	push   $0x6d
801074fa:	e9 fa f4 ff ff       	jmp    801069f9 <alltraps>

801074ff <vector110>:
801074ff:	6a 00                	push   $0x0
80107501:	6a 6e                	push   $0x6e
80107503:	e9 f1 f4 ff ff       	jmp    801069f9 <alltraps>

80107508 <vector111>:
80107508:	6a 00                	push   $0x0
8010750a:	6a 6f                	push   $0x6f
8010750c:	e9 e8 f4 ff ff       	jmp    801069f9 <alltraps>

80107511 <vector112>:
80107511:	6a 00                	push   $0x0
80107513:	6a 70                	push   $0x70
80107515:	e9 df f4 ff ff       	jmp    801069f9 <alltraps>

8010751a <vector113>:
8010751a:	6a 00                	push   $0x0
8010751c:	6a 71                	push   $0x71
8010751e:	e9 d6 f4 ff ff       	jmp    801069f9 <alltraps>

80107523 <vector114>:
80107523:	6a 00                	push   $0x0
80107525:	6a 72                	push   $0x72
80107527:	e9 cd f4 ff ff       	jmp    801069f9 <alltraps>

8010752c <vector115>:
8010752c:	6a 00                	push   $0x0
8010752e:	6a 73                	push   $0x73
80107530:	e9 c4 f4 ff ff       	jmp    801069f9 <alltraps>

80107535 <vector116>:
80107535:	6a 00                	push   $0x0
80107537:	6a 74                	push   $0x74
80107539:	e9 bb f4 ff ff       	jmp    801069f9 <alltraps>

8010753e <vector117>:
8010753e:	6a 00                	push   $0x0
80107540:	6a 75                	push   $0x75
80107542:	e9 b2 f4 ff ff       	jmp    801069f9 <alltraps>

80107547 <vector118>:
80107547:	6a 00                	push   $0x0
80107549:	6a 76                	push   $0x76
8010754b:	e9 a9 f4 ff ff       	jmp    801069f9 <alltraps>

80107550 <vector119>:
80107550:	6a 00                	push   $0x0
80107552:	6a 77                	push   $0x77
80107554:	e9 a0 f4 ff ff       	jmp    801069f9 <alltraps>

80107559 <vector120>:
80107559:	6a 00                	push   $0x0
8010755b:	6a 78                	push   $0x78
8010755d:	e9 97 f4 ff ff       	jmp    801069f9 <alltraps>

80107562 <vector121>:
80107562:	6a 00                	push   $0x0
80107564:	6a 79                	push   $0x79
80107566:	e9 8e f4 ff ff       	jmp    801069f9 <alltraps>

8010756b <vector122>:
8010756b:	6a 00                	push   $0x0
8010756d:	6a 7a                	push   $0x7a
8010756f:	e9 85 f4 ff ff       	jmp    801069f9 <alltraps>

80107574 <vector123>:
80107574:	6a 00                	push   $0x0
80107576:	6a 7b                	push   $0x7b
80107578:	e9 7c f4 ff ff       	jmp    801069f9 <alltraps>

8010757d <vector124>:
8010757d:	6a 00                	push   $0x0
8010757f:	6a 7c                	push   $0x7c
80107581:	e9 73 f4 ff ff       	jmp    801069f9 <alltraps>

80107586 <vector125>:
80107586:	6a 00                	push   $0x0
80107588:	6a 7d                	push   $0x7d
8010758a:	e9 6a f4 ff ff       	jmp    801069f9 <alltraps>

8010758f <vector126>:
8010758f:	6a 00                	push   $0x0
80107591:	6a 7e                	push   $0x7e
80107593:	e9 61 f4 ff ff       	jmp    801069f9 <alltraps>

80107598 <vector127>:
80107598:	6a 00                	push   $0x0
8010759a:	6a 7f                	push   $0x7f
8010759c:	e9 58 f4 ff ff       	jmp    801069f9 <alltraps>

801075a1 <vector128>:
801075a1:	6a 00                	push   $0x0
801075a3:	68 80 00 00 00       	push   $0x80
801075a8:	e9 4c f4 ff ff       	jmp    801069f9 <alltraps>

801075ad <vector129>:
801075ad:	6a 00                	push   $0x0
801075af:	68 81 00 00 00       	push   $0x81
801075b4:	e9 40 f4 ff ff       	jmp    801069f9 <alltraps>

801075b9 <vector130>:
801075b9:	6a 00                	push   $0x0
801075bb:	68 82 00 00 00       	push   $0x82
801075c0:	e9 34 f4 ff ff       	jmp    801069f9 <alltraps>

801075c5 <vector131>:
801075c5:	6a 00                	push   $0x0
801075c7:	68 83 00 00 00       	push   $0x83
801075cc:	e9 28 f4 ff ff       	jmp    801069f9 <alltraps>

801075d1 <vector132>:
801075d1:	6a 00                	push   $0x0
801075d3:	68 84 00 00 00       	push   $0x84
801075d8:	e9 1c f4 ff ff       	jmp    801069f9 <alltraps>

801075dd <vector133>:
801075dd:	6a 00                	push   $0x0
801075df:	68 85 00 00 00       	push   $0x85
801075e4:	e9 10 f4 ff ff       	jmp    801069f9 <alltraps>

801075e9 <vector134>:
801075e9:	6a 00                	push   $0x0
801075eb:	68 86 00 00 00       	push   $0x86
801075f0:	e9 04 f4 ff ff       	jmp    801069f9 <alltraps>

801075f5 <vector135>:
801075f5:	6a 00                	push   $0x0
801075f7:	68 87 00 00 00       	push   $0x87
801075fc:	e9 f8 f3 ff ff       	jmp    801069f9 <alltraps>

80107601 <vector136>:
80107601:	6a 00                	push   $0x0
80107603:	68 88 00 00 00       	push   $0x88
80107608:	e9 ec f3 ff ff       	jmp    801069f9 <alltraps>

8010760d <vector137>:
8010760d:	6a 00                	push   $0x0
8010760f:	68 89 00 00 00       	push   $0x89
80107614:	e9 e0 f3 ff ff       	jmp    801069f9 <alltraps>

80107619 <vector138>:
80107619:	6a 00                	push   $0x0
8010761b:	68 8a 00 00 00       	push   $0x8a
80107620:	e9 d4 f3 ff ff       	jmp    801069f9 <alltraps>

80107625 <vector139>:
80107625:	6a 00                	push   $0x0
80107627:	68 8b 00 00 00       	push   $0x8b
8010762c:	e9 c8 f3 ff ff       	jmp    801069f9 <alltraps>

80107631 <vector140>:
80107631:	6a 00                	push   $0x0
80107633:	68 8c 00 00 00       	push   $0x8c
80107638:	e9 bc f3 ff ff       	jmp    801069f9 <alltraps>

8010763d <vector141>:
8010763d:	6a 00                	push   $0x0
8010763f:	68 8d 00 00 00       	push   $0x8d
80107644:	e9 b0 f3 ff ff       	jmp    801069f9 <alltraps>

80107649 <vector142>:
80107649:	6a 00                	push   $0x0
8010764b:	68 8e 00 00 00       	push   $0x8e
80107650:	e9 a4 f3 ff ff       	jmp    801069f9 <alltraps>

80107655 <vector143>:
80107655:	6a 00                	push   $0x0
80107657:	68 8f 00 00 00       	push   $0x8f
8010765c:	e9 98 f3 ff ff       	jmp    801069f9 <alltraps>

80107661 <vector144>:
80107661:	6a 00                	push   $0x0
80107663:	68 90 00 00 00       	push   $0x90
80107668:	e9 8c f3 ff ff       	jmp    801069f9 <alltraps>

8010766d <vector145>:
8010766d:	6a 00                	push   $0x0
8010766f:	68 91 00 00 00       	push   $0x91
80107674:	e9 80 f3 ff ff       	jmp    801069f9 <alltraps>

80107679 <vector146>:
80107679:	6a 00                	push   $0x0
8010767b:	68 92 00 00 00       	push   $0x92
80107680:	e9 74 f3 ff ff       	jmp    801069f9 <alltraps>

80107685 <vector147>:
80107685:	6a 00                	push   $0x0
80107687:	68 93 00 00 00       	push   $0x93
8010768c:	e9 68 f3 ff ff       	jmp    801069f9 <alltraps>

80107691 <vector148>:
80107691:	6a 00                	push   $0x0
80107693:	68 94 00 00 00       	push   $0x94
80107698:	e9 5c f3 ff ff       	jmp    801069f9 <alltraps>

8010769d <vector149>:
8010769d:	6a 00                	push   $0x0
8010769f:	68 95 00 00 00       	push   $0x95
801076a4:	e9 50 f3 ff ff       	jmp    801069f9 <alltraps>

801076a9 <vector150>:
801076a9:	6a 00                	push   $0x0
801076ab:	68 96 00 00 00       	push   $0x96
801076b0:	e9 44 f3 ff ff       	jmp    801069f9 <alltraps>

801076b5 <vector151>:
801076b5:	6a 00                	push   $0x0
801076b7:	68 97 00 00 00       	push   $0x97
801076bc:	e9 38 f3 ff ff       	jmp    801069f9 <alltraps>

801076c1 <vector152>:
801076c1:	6a 00                	push   $0x0
801076c3:	68 98 00 00 00       	push   $0x98
801076c8:	e9 2c f3 ff ff       	jmp    801069f9 <alltraps>

801076cd <vector153>:
801076cd:	6a 00                	push   $0x0
801076cf:	68 99 00 00 00       	push   $0x99
801076d4:	e9 20 f3 ff ff       	jmp    801069f9 <alltraps>

801076d9 <vector154>:
801076d9:	6a 00                	push   $0x0
801076db:	68 9a 00 00 00       	push   $0x9a
801076e0:	e9 14 f3 ff ff       	jmp    801069f9 <alltraps>

801076e5 <vector155>:
801076e5:	6a 00                	push   $0x0
801076e7:	68 9b 00 00 00       	push   $0x9b
801076ec:	e9 08 f3 ff ff       	jmp    801069f9 <alltraps>

801076f1 <vector156>:
801076f1:	6a 00                	push   $0x0
801076f3:	68 9c 00 00 00       	push   $0x9c
801076f8:	e9 fc f2 ff ff       	jmp    801069f9 <alltraps>

801076fd <vector157>:
801076fd:	6a 00                	push   $0x0
801076ff:	68 9d 00 00 00       	push   $0x9d
80107704:	e9 f0 f2 ff ff       	jmp    801069f9 <alltraps>

80107709 <vector158>:
80107709:	6a 00                	push   $0x0
8010770b:	68 9e 00 00 00       	push   $0x9e
80107710:	e9 e4 f2 ff ff       	jmp    801069f9 <alltraps>

80107715 <vector159>:
80107715:	6a 00                	push   $0x0
80107717:	68 9f 00 00 00       	push   $0x9f
8010771c:	e9 d8 f2 ff ff       	jmp    801069f9 <alltraps>

80107721 <vector160>:
80107721:	6a 00                	push   $0x0
80107723:	68 a0 00 00 00       	push   $0xa0
80107728:	e9 cc f2 ff ff       	jmp    801069f9 <alltraps>

8010772d <vector161>:
8010772d:	6a 00                	push   $0x0
8010772f:	68 a1 00 00 00       	push   $0xa1
80107734:	e9 c0 f2 ff ff       	jmp    801069f9 <alltraps>

80107739 <vector162>:
80107739:	6a 00                	push   $0x0
8010773b:	68 a2 00 00 00       	push   $0xa2
80107740:	e9 b4 f2 ff ff       	jmp    801069f9 <alltraps>

80107745 <vector163>:
80107745:	6a 00                	push   $0x0
80107747:	68 a3 00 00 00       	push   $0xa3
8010774c:	e9 a8 f2 ff ff       	jmp    801069f9 <alltraps>

80107751 <vector164>:
80107751:	6a 00                	push   $0x0
80107753:	68 a4 00 00 00       	push   $0xa4
80107758:	e9 9c f2 ff ff       	jmp    801069f9 <alltraps>

8010775d <vector165>:
8010775d:	6a 00                	push   $0x0
8010775f:	68 a5 00 00 00       	push   $0xa5
80107764:	e9 90 f2 ff ff       	jmp    801069f9 <alltraps>

80107769 <vector166>:
80107769:	6a 00                	push   $0x0
8010776b:	68 a6 00 00 00       	push   $0xa6
80107770:	e9 84 f2 ff ff       	jmp    801069f9 <alltraps>

80107775 <vector167>:
80107775:	6a 00                	push   $0x0
80107777:	68 a7 00 00 00       	push   $0xa7
8010777c:	e9 78 f2 ff ff       	jmp    801069f9 <alltraps>

80107781 <vector168>:
80107781:	6a 00                	push   $0x0
80107783:	68 a8 00 00 00       	push   $0xa8
80107788:	e9 6c f2 ff ff       	jmp    801069f9 <alltraps>

8010778d <vector169>:
8010778d:	6a 00                	push   $0x0
8010778f:	68 a9 00 00 00       	push   $0xa9
80107794:	e9 60 f2 ff ff       	jmp    801069f9 <alltraps>

80107799 <vector170>:
80107799:	6a 00                	push   $0x0
8010779b:	68 aa 00 00 00       	push   $0xaa
801077a0:	e9 54 f2 ff ff       	jmp    801069f9 <alltraps>

801077a5 <vector171>:
801077a5:	6a 00                	push   $0x0
801077a7:	68 ab 00 00 00       	push   $0xab
801077ac:	e9 48 f2 ff ff       	jmp    801069f9 <alltraps>

801077b1 <vector172>:
801077b1:	6a 00                	push   $0x0
801077b3:	68 ac 00 00 00       	push   $0xac
801077b8:	e9 3c f2 ff ff       	jmp    801069f9 <alltraps>

801077bd <vector173>:
801077bd:	6a 00                	push   $0x0
801077bf:	68 ad 00 00 00       	push   $0xad
801077c4:	e9 30 f2 ff ff       	jmp    801069f9 <alltraps>

801077c9 <vector174>:
801077c9:	6a 00                	push   $0x0
801077cb:	68 ae 00 00 00       	push   $0xae
801077d0:	e9 24 f2 ff ff       	jmp    801069f9 <alltraps>

801077d5 <vector175>:
801077d5:	6a 00                	push   $0x0
801077d7:	68 af 00 00 00       	push   $0xaf
801077dc:	e9 18 f2 ff ff       	jmp    801069f9 <alltraps>

801077e1 <vector176>:
801077e1:	6a 00                	push   $0x0
801077e3:	68 b0 00 00 00       	push   $0xb0
801077e8:	e9 0c f2 ff ff       	jmp    801069f9 <alltraps>

801077ed <vector177>:
801077ed:	6a 00                	push   $0x0
801077ef:	68 b1 00 00 00       	push   $0xb1
801077f4:	e9 00 f2 ff ff       	jmp    801069f9 <alltraps>

801077f9 <vector178>:
801077f9:	6a 00                	push   $0x0
801077fb:	68 b2 00 00 00       	push   $0xb2
80107800:	e9 f4 f1 ff ff       	jmp    801069f9 <alltraps>

80107805 <vector179>:
80107805:	6a 00                	push   $0x0
80107807:	68 b3 00 00 00       	push   $0xb3
8010780c:	e9 e8 f1 ff ff       	jmp    801069f9 <alltraps>

80107811 <vector180>:
80107811:	6a 00                	push   $0x0
80107813:	68 b4 00 00 00       	push   $0xb4
80107818:	e9 dc f1 ff ff       	jmp    801069f9 <alltraps>

8010781d <vector181>:
8010781d:	6a 00                	push   $0x0
8010781f:	68 b5 00 00 00       	push   $0xb5
80107824:	e9 d0 f1 ff ff       	jmp    801069f9 <alltraps>

80107829 <vector182>:
80107829:	6a 00                	push   $0x0
8010782b:	68 b6 00 00 00       	push   $0xb6
80107830:	e9 c4 f1 ff ff       	jmp    801069f9 <alltraps>

80107835 <vector183>:
80107835:	6a 00                	push   $0x0
80107837:	68 b7 00 00 00       	push   $0xb7
8010783c:	e9 b8 f1 ff ff       	jmp    801069f9 <alltraps>

80107841 <vector184>:
80107841:	6a 00                	push   $0x0
80107843:	68 b8 00 00 00       	push   $0xb8
80107848:	e9 ac f1 ff ff       	jmp    801069f9 <alltraps>

8010784d <vector185>:
8010784d:	6a 00                	push   $0x0
8010784f:	68 b9 00 00 00       	push   $0xb9
80107854:	e9 a0 f1 ff ff       	jmp    801069f9 <alltraps>

80107859 <vector186>:
80107859:	6a 00                	push   $0x0
8010785b:	68 ba 00 00 00       	push   $0xba
80107860:	e9 94 f1 ff ff       	jmp    801069f9 <alltraps>

80107865 <vector187>:
80107865:	6a 00                	push   $0x0
80107867:	68 bb 00 00 00       	push   $0xbb
8010786c:	e9 88 f1 ff ff       	jmp    801069f9 <alltraps>

80107871 <vector188>:
80107871:	6a 00                	push   $0x0
80107873:	68 bc 00 00 00       	push   $0xbc
80107878:	e9 7c f1 ff ff       	jmp    801069f9 <alltraps>

8010787d <vector189>:
8010787d:	6a 00                	push   $0x0
8010787f:	68 bd 00 00 00       	push   $0xbd
80107884:	e9 70 f1 ff ff       	jmp    801069f9 <alltraps>

80107889 <vector190>:
80107889:	6a 00                	push   $0x0
8010788b:	68 be 00 00 00       	push   $0xbe
80107890:	e9 64 f1 ff ff       	jmp    801069f9 <alltraps>

80107895 <vector191>:
80107895:	6a 00                	push   $0x0
80107897:	68 bf 00 00 00       	push   $0xbf
8010789c:	e9 58 f1 ff ff       	jmp    801069f9 <alltraps>

801078a1 <vector192>:
801078a1:	6a 00                	push   $0x0
801078a3:	68 c0 00 00 00       	push   $0xc0
801078a8:	e9 4c f1 ff ff       	jmp    801069f9 <alltraps>

801078ad <vector193>:
801078ad:	6a 00                	push   $0x0
801078af:	68 c1 00 00 00       	push   $0xc1
801078b4:	e9 40 f1 ff ff       	jmp    801069f9 <alltraps>

801078b9 <vector194>:
801078b9:	6a 00                	push   $0x0
801078bb:	68 c2 00 00 00       	push   $0xc2
801078c0:	e9 34 f1 ff ff       	jmp    801069f9 <alltraps>

801078c5 <vector195>:
801078c5:	6a 00                	push   $0x0
801078c7:	68 c3 00 00 00       	push   $0xc3
801078cc:	e9 28 f1 ff ff       	jmp    801069f9 <alltraps>

801078d1 <vector196>:
801078d1:	6a 00                	push   $0x0
801078d3:	68 c4 00 00 00       	push   $0xc4
801078d8:	e9 1c f1 ff ff       	jmp    801069f9 <alltraps>

801078dd <vector197>:
801078dd:	6a 00                	push   $0x0
801078df:	68 c5 00 00 00       	push   $0xc5
801078e4:	e9 10 f1 ff ff       	jmp    801069f9 <alltraps>

801078e9 <vector198>:
801078e9:	6a 00                	push   $0x0
801078eb:	68 c6 00 00 00       	push   $0xc6
801078f0:	e9 04 f1 ff ff       	jmp    801069f9 <alltraps>

801078f5 <vector199>:
801078f5:	6a 00                	push   $0x0
801078f7:	68 c7 00 00 00       	push   $0xc7
801078fc:	e9 f8 f0 ff ff       	jmp    801069f9 <alltraps>

80107901 <vector200>:
80107901:	6a 00                	push   $0x0
80107903:	68 c8 00 00 00       	push   $0xc8
80107908:	e9 ec f0 ff ff       	jmp    801069f9 <alltraps>

8010790d <vector201>:
8010790d:	6a 00                	push   $0x0
8010790f:	68 c9 00 00 00       	push   $0xc9
80107914:	e9 e0 f0 ff ff       	jmp    801069f9 <alltraps>

80107919 <vector202>:
80107919:	6a 00                	push   $0x0
8010791b:	68 ca 00 00 00       	push   $0xca
80107920:	e9 d4 f0 ff ff       	jmp    801069f9 <alltraps>

80107925 <vector203>:
80107925:	6a 00                	push   $0x0
80107927:	68 cb 00 00 00       	push   $0xcb
8010792c:	e9 c8 f0 ff ff       	jmp    801069f9 <alltraps>

80107931 <vector204>:
80107931:	6a 00                	push   $0x0
80107933:	68 cc 00 00 00       	push   $0xcc
80107938:	e9 bc f0 ff ff       	jmp    801069f9 <alltraps>

8010793d <vector205>:
8010793d:	6a 00                	push   $0x0
8010793f:	68 cd 00 00 00       	push   $0xcd
80107944:	e9 b0 f0 ff ff       	jmp    801069f9 <alltraps>

80107949 <vector206>:
80107949:	6a 00                	push   $0x0
8010794b:	68 ce 00 00 00       	push   $0xce
80107950:	e9 a4 f0 ff ff       	jmp    801069f9 <alltraps>

80107955 <vector207>:
80107955:	6a 00                	push   $0x0
80107957:	68 cf 00 00 00       	push   $0xcf
8010795c:	e9 98 f0 ff ff       	jmp    801069f9 <alltraps>

80107961 <vector208>:
80107961:	6a 00                	push   $0x0
80107963:	68 d0 00 00 00       	push   $0xd0
80107968:	e9 8c f0 ff ff       	jmp    801069f9 <alltraps>

8010796d <vector209>:
8010796d:	6a 00                	push   $0x0
8010796f:	68 d1 00 00 00       	push   $0xd1
80107974:	e9 80 f0 ff ff       	jmp    801069f9 <alltraps>

80107979 <vector210>:
80107979:	6a 00                	push   $0x0
8010797b:	68 d2 00 00 00       	push   $0xd2
80107980:	e9 74 f0 ff ff       	jmp    801069f9 <alltraps>

80107985 <vector211>:
80107985:	6a 00                	push   $0x0
80107987:	68 d3 00 00 00       	push   $0xd3
8010798c:	e9 68 f0 ff ff       	jmp    801069f9 <alltraps>

80107991 <vector212>:
80107991:	6a 00                	push   $0x0
80107993:	68 d4 00 00 00       	push   $0xd4
80107998:	e9 5c f0 ff ff       	jmp    801069f9 <alltraps>

8010799d <vector213>:
8010799d:	6a 00                	push   $0x0
8010799f:	68 d5 00 00 00       	push   $0xd5
801079a4:	e9 50 f0 ff ff       	jmp    801069f9 <alltraps>

801079a9 <vector214>:
801079a9:	6a 00                	push   $0x0
801079ab:	68 d6 00 00 00       	push   $0xd6
801079b0:	e9 44 f0 ff ff       	jmp    801069f9 <alltraps>

801079b5 <vector215>:
801079b5:	6a 00                	push   $0x0
801079b7:	68 d7 00 00 00       	push   $0xd7
801079bc:	e9 38 f0 ff ff       	jmp    801069f9 <alltraps>

801079c1 <vector216>:
801079c1:	6a 00                	push   $0x0
801079c3:	68 d8 00 00 00       	push   $0xd8
801079c8:	e9 2c f0 ff ff       	jmp    801069f9 <alltraps>

801079cd <vector217>:
801079cd:	6a 00                	push   $0x0
801079cf:	68 d9 00 00 00       	push   $0xd9
801079d4:	e9 20 f0 ff ff       	jmp    801069f9 <alltraps>

801079d9 <vector218>:
801079d9:	6a 00                	push   $0x0
801079db:	68 da 00 00 00       	push   $0xda
801079e0:	e9 14 f0 ff ff       	jmp    801069f9 <alltraps>

801079e5 <vector219>:
801079e5:	6a 00                	push   $0x0
801079e7:	68 db 00 00 00       	push   $0xdb
801079ec:	e9 08 f0 ff ff       	jmp    801069f9 <alltraps>

801079f1 <vector220>:
801079f1:	6a 00                	push   $0x0
801079f3:	68 dc 00 00 00       	push   $0xdc
801079f8:	e9 fc ef ff ff       	jmp    801069f9 <alltraps>

801079fd <vector221>:
801079fd:	6a 00                	push   $0x0
801079ff:	68 dd 00 00 00       	push   $0xdd
80107a04:	e9 f0 ef ff ff       	jmp    801069f9 <alltraps>

80107a09 <vector222>:
80107a09:	6a 00                	push   $0x0
80107a0b:	68 de 00 00 00       	push   $0xde
80107a10:	e9 e4 ef ff ff       	jmp    801069f9 <alltraps>

80107a15 <vector223>:
80107a15:	6a 00                	push   $0x0
80107a17:	68 df 00 00 00       	push   $0xdf
80107a1c:	e9 d8 ef ff ff       	jmp    801069f9 <alltraps>

80107a21 <vector224>:
80107a21:	6a 00                	push   $0x0
80107a23:	68 e0 00 00 00       	push   $0xe0
80107a28:	e9 cc ef ff ff       	jmp    801069f9 <alltraps>

80107a2d <vector225>:
80107a2d:	6a 00                	push   $0x0
80107a2f:	68 e1 00 00 00       	push   $0xe1
80107a34:	e9 c0 ef ff ff       	jmp    801069f9 <alltraps>

80107a39 <vector226>:
80107a39:	6a 00                	push   $0x0
80107a3b:	68 e2 00 00 00       	push   $0xe2
80107a40:	e9 b4 ef ff ff       	jmp    801069f9 <alltraps>

80107a45 <vector227>:
80107a45:	6a 00                	push   $0x0
80107a47:	68 e3 00 00 00       	push   $0xe3
80107a4c:	e9 a8 ef ff ff       	jmp    801069f9 <alltraps>

80107a51 <vector228>:
80107a51:	6a 00                	push   $0x0
80107a53:	68 e4 00 00 00       	push   $0xe4
80107a58:	e9 9c ef ff ff       	jmp    801069f9 <alltraps>

80107a5d <vector229>:
80107a5d:	6a 00                	push   $0x0
80107a5f:	68 e5 00 00 00       	push   $0xe5
80107a64:	e9 90 ef ff ff       	jmp    801069f9 <alltraps>

80107a69 <vector230>:
80107a69:	6a 00                	push   $0x0
80107a6b:	68 e6 00 00 00       	push   $0xe6
80107a70:	e9 84 ef ff ff       	jmp    801069f9 <alltraps>

80107a75 <vector231>:
80107a75:	6a 00                	push   $0x0
80107a77:	68 e7 00 00 00       	push   $0xe7
80107a7c:	e9 78 ef ff ff       	jmp    801069f9 <alltraps>

80107a81 <vector232>:
80107a81:	6a 00                	push   $0x0
80107a83:	68 e8 00 00 00       	push   $0xe8
80107a88:	e9 6c ef ff ff       	jmp    801069f9 <alltraps>

80107a8d <vector233>:
80107a8d:	6a 00                	push   $0x0
80107a8f:	68 e9 00 00 00       	push   $0xe9
80107a94:	e9 60 ef ff ff       	jmp    801069f9 <alltraps>

80107a99 <vector234>:
80107a99:	6a 00                	push   $0x0
80107a9b:	68 ea 00 00 00       	push   $0xea
80107aa0:	e9 54 ef ff ff       	jmp    801069f9 <alltraps>

80107aa5 <vector235>:
80107aa5:	6a 00                	push   $0x0
80107aa7:	68 eb 00 00 00       	push   $0xeb
80107aac:	e9 48 ef ff ff       	jmp    801069f9 <alltraps>

80107ab1 <vector236>:
80107ab1:	6a 00                	push   $0x0
80107ab3:	68 ec 00 00 00       	push   $0xec
80107ab8:	e9 3c ef ff ff       	jmp    801069f9 <alltraps>

80107abd <vector237>:
80107abd:	6a 00                	push   $0x0
80107abf:	68 ed 00 00 00       	push   $0xed
80107ac4:	e9 30 ef ff ff       	jmp    801069f9 <alltraps>

80107ac9 <vector238>:
80107ac9:	6a 00                	push   $0x0
80107acb:	68 ee 00 00 00       	push   $0xee
80107ad0:	e9 24 ef ff ff       	jmp    801069f9 <alltraps>

80107ad5 <vector239>:
80107ad5:	6a 00                	push   $0x0
80107ad7:	68 ef 00 00 00       	push   $0xef
80107adc:	e9 18 ef ff ff       	jmp    801069f9 <alltraps>

80107ae1 <vector240>:
80107ae1:	6a 00                	push   $0x0
80107ae3:	68 f0 00 00 00       	push   $0xf0
80107ae8:	e9 0c ef ff ff       	jmp    801069f9 <alltraps>

80107aed <vector241>:
80107aed:	6a 00                	push   $0x0
80107aef:	68 f1 00 00 00       	push   $0xf1
80107af4:	e9 00 ef ff ff       	jmp    801069f9 <alltraps>

80107af9 <vector242>:
80107af9:	6a 00                	push   $0x0
80107afb:	68 f2 00 00 00       	push   $0xf2
80107b00:	e9 f4 ee ff ff       	jmp    801069f9 <alltraps>

80107b05 <vector243>:
80107b05:	6a 00                	push   $0x0
80107b07:	68 f3 00 00 00       	push   $0xf3
80107b0c:	e9 e8 ee ff ff       	jmp    801069f9 <alltraps>

80107b11 <vector244>:
80107b11:	6a 00                	push   $0x0
80107b13:	68 f4 00 00 00       	push   $0xf4
80107b18:	e9 dc ee ff ff       	jmp    801069f9 <alltraps>

80107b1d <vector245>:
80107b1d:	6a 00                	push   $0x0
80107b1f:	68 f5 00 00 00       	push   $0xf5
80107b24:	e9 d0 ee ff ff       	jmp    801069f9 <alltraps>

80107b29 <vector246>:
80107b29:	6a 00                	push   $0x0
80107b2b:	68 f6 00 00 00       	push   $0xf6
80107b30:	e9 c4 ee ff ff       	jmp    801069f9 <alltraps>

80107b35 <vector247>:
80107b35:	6a 00                	push   $0x0
80107b37:	68 f7 00 00 00       	push   $0xf7
80107b3c:	e9 b8 ee ff ff       	jmp    801069f9 <alltraps>

80107b41 <vector248>:
80107b41:	6a 00                	push   $0x0
80107b43:	68 f8 00 00 00       	push   $0xf8
80107b48:	e9 ac ee ff ff       	jmp    801069f9 <alltraps>

80107b4d <vector249>:
80107b4d:	6a 00                	push   $0x0
80107b4f:	68 f9 00 00 00       	push   $0xf9
80107b54:	e9 a0 ee ff ff       	jmp    801069f9 <alltraps>

80107b59 <vector250>:
80107b59:	6a 00                	push   $0x0
80107b5b:	68 fa 00 00 00       	push   $0xfa
80107b60:	e9 94 ee ff ff       	jmp    801069f9 <alltraps>

80107b65 <vector251>:
80107b65:	6a 00                	push   $0x0
80107b67:	68 fb 00 00 00       	push   $0xfb
80107b6c:	e9 88 ee ff ff       	jmp    801069f9 <alltraps>

80107b71 <vector252>:
80107b71:	6a 00                	push   $0x0
80107b73:	68 fc 00 00 00       	push   $0xfc
80107b78:	e9 7c ee ff ff       	jmp    801069f9 <alltraps>

80107b7d <vector253>:
80107b7d:	6a 00                	push   $0x0
80107b7f:	68 fd 00 00 00       	push   $0xfd
80107b84:	e9 70 ee ff ff       	jmp    801069f9 <alltraps>

80107b89 <vector254>:
80107b89:	6a 00                	push   $0x0
80107b8b:	68 fe 00 00 00       	push   $0xfe
80107b90:	e9 64 ee ff ff       	jmp    801069f9 <alltraps>

80107b95 <vector255>:
80107b95:	6a 00                	push   $0x0
80107b97:	68 ff 00 00 00       	push   $0xff
80107b9c:	e9 58 ee ff ff       	jmp    801069f9 <alltraps>

80107ba1 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107ba1:	55                   	push   %ebp
80107ba2:	89 e5                	mov    %esp,%ebp
80107ba4:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107baa:	83 e8 01             	sub    $0x1,%eax
80107bad:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107bb1:	8b 45 08             	mov    0x8(%ebp),%eax
80107bb4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107bb8:	8b 45 08             	mov    0x8(%ebp),%eax
80107bbb:	c1 e8 10             	shr    $0x10,%eax
80107bbe:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107bc2:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107bc5:	0f 01 10             	lgdtl  (%eax)
}
80107bc8:	90                   	nop
80107bc9:	c9                   	leave  
80107bca:	c3                   	ret    

80107bcb <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107bcb:	55                   	push   %ebp
80107bcc:	89 e5                	mov    %esp,%ebp
80107bce:	83 ec 04             	sub    $0x4,%esp
80107bd1:	8b 45 08             	mov    0x8(%ebp),%eax
80107bd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107bd8:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107bdc:	0f 00 d8             	ltr    %ax
}
80107bdf:	90                   	nop
80107be0:	c9                   	leave  
80107be1:	c3                   	ret    

80107be2 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107be2:	55                   	push   %ebp
80107be3:	89 e5                	mov    %esp,%ebp
80107be5:	83 ec 04             	sub    $0x4,%esp
80107be8:	8b 45 08             	mov    0x8(%ebp),%eax
80107beb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107bef:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107bf3:	8e e8                	mov    %eax,%gs
}
80107bf5:	90                   	nop
80107bf6:	c9                   	leave  
80107bf7:	c3                   	ret    

80107bf8 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107bf8:	55                   	push   %ebp
80107bf9:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107bfb:	8b 45 08             	mov    0x8(%ebp),%eax
80107bfe:	0f 22 d8             	mov    %eax,%cr3
}
80107c01:	90                   	nop
80107c02:	5d                   	pop    %ebp
80107c03:	c3                   	ret    

80107c04 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107c04:	55                   	push   %ebp
80107c05:	89 e5                	mov    %esp,%ebp
80107c07:	8b 45 08             	mov    0x8(%ebp),%eax
80107c0a:	05 00 00 00 80       	add    $0x80000000,%eax
80107c0f:	5d                   	pop    %ebp
80107c10:	c3                   	ret    

80107c11 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107c11:	55                   	push   %ebp
80107c12:	89 e5                	mov    %esp,%ebp
80107c14:	8b 45 08             	mov    0x8(%ebp),%eax
80107c17:	05 00 00 00 80       	add    $0x80000000,%eax
80107c1c:	5d                   	pop    %ebp
80107c1d:	c3                   	ret    

80107c1e <init_pte_lookup_lock>:
struct {
  int pte_array [TOTAL_NPENTRIES];
  struct spinlock lock;
} pte_lookup_table;

void init_pte_lookup_lock(void) {
80107c1e:	55                   	push   %ebp
80107c1f:	89 e5                	mov    %esp,%ebp
80107c21:	83 ec 08             	sub    $0x8,%esp
  initlock(&pte_lookup_table.lock,"pte_lookup");
80107c24:	83 ec 08             	sub    $0x8,%esp
80107c27:	68 ac 92 10 80       	push   $0x801092ac
80107c2c:	68 20 24 15 80       	push   $0x80152420
80107c31:	e8 17 d6 ff ff       	call   8010524d <initlock>
80107c36:	83 c4 10             	add    $0x10,%esp
}
80107c39:	90                   	nop
80107c3a:	c9                   	leave  
80107c3b:	c3                   	ret    

80107c3c <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107c3c:	55                   	push   %ebp
80107c3d:	89 e5                	mov    %esp,%ebp
80107c3f:	53                   	push   %ebx
80107c40:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107c43:	e8 e3 b2 ff ff       	call   80102f2b <cpunum>
80107c48:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107c4e:	05 80 33 11 80       	add    $0x80113380,%eax
80107c53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c59:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c62:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6b:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c72:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c76:	83 e2 f0             	and    $0xfffffff0,%edx
80107c79:	83 ca 0a             	or     $0xa,%edx
80107c7c:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c82:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c86:	83 ca 10             	or     $0x10,%edx
80107c89:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c93:	83 e2 9f             	and    $0xffffff9f,%edx
80107c96:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107ca0:	83 ca 80             	or     $0xffffff80,%edx
80107ca3:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cad:	83 ca 0f             	or     $0xf,%edx
80107cb0:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cba:	83 e2 ef             	and    $0xffffffef,%edx
80107cbd:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cc7:	83 e2 df             	and    $0xffffffdf,%edx
80107cca:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cd4:	83 ca 40             	or     $0x40,%edx
80107cd7:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdd:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ce1:	83 ca 80             	or     $0xffffff80,%edx
80107ce4:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cea:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf1:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107cf8:	ff ff 
80107cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cfd:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107d04:	00 00 
80107d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d09:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d13:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d1a:	83 e2 f0             	and    $0xfffffff0,%edx
80107d1d:	83 ca 02             	or     $0x2,%edx
80107d20:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d29:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d30:	83 ca 10             	or     $0x10,%edx
80107d33:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d43:	83 e2 9f             	and    $0xffffff9f,%edx
80107d46:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d56:	83 ca 80             	or     $0xffffff80,%edx
80107d59:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d62:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d69:	83 ca 0f             	or     $0xf,%edx
80107d6c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d75:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d7c:	83 e2 ef             	and    $0xffffffef,%edx
80107d7f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d88:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d8f:	83 e2 df             	and    $0xffffffdf,%edx
80107d92:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107da2:	83 ca 40             	or     $0x40,%edx
80107da5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dae:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107db5:	83 ca 80             	or     $0xffffff80,%edx
80107db8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc1:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dcb:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107dd2:	ff ff 
80107dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd7:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107dde:	00 00 
80107de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de3:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ded:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107df4:	83 e2 f0             	and    $0xfffffff0,%edx
80107df7:	83 ca 0a             	or     $0xa,%edx
80107dfa:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e03:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e0a:	83 ca 10             	or     $0x10,%edx
80107e0d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e16:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e1d:	83 ca 60             	or     $0x60,%edx
80107e20:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e29:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e30:	83 ca 80             	or     $0xffffff80,%edx
80107e33:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e3c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e43:	83 ca 0f             	or     $0xf,%edx
80107e46:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e56:	83 e2 ef             	and    $0xffffffef,%edx
80107e59:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e62:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e69:	83 e2 df             	and    $0xffffffdf,%edx
80107e6c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e75:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e7c:	83 ca 40             	or     $0x40,%edx
80107e7f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e88:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e8f:	83 ca 80             	or     $0xffffff80,%edx
80107e92:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e9b:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea5:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107eac:	ff ff 
80107eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb1:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107eb8:	00 00 
80107eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebd:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec7:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ece:	83 e2 f0             	and    $0xfffffff0,%edx
80107ed1:	83 ca 02             	or     $0x2,%edx
80107ed4:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107edd:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ee4:	83 ca 10             	or     $0x10,%edx
80107ee7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef0:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ef7:	83 ca 60             	or     $0x60,%edx
80107efa:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f03:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f0a:	83 ca 80             	or     $0xffffff80,%edx
80107f0d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f16:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f1d:	83 ca 0f             	or     $0xf,%edx
80107f20:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f29:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f30:	83 e2 ef             	and    $0xffffffef,%edx
80107f33:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f43:	83 e2 df             	and    $0xffffffdf,%edx
80107f46:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f56:	83 ca 40             	or     $0x40,%edx
80107f59:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f62:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f69:	83 ca 80             	or     $0xffffff80,%edx
80107f6c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f75:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7f:	05 b4 00 00 00       	add    $0xb4,%eax
80107f84:	89 c3                	mov    %eax,%ebx
80107f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f89:	05 b4 00 00 00       	add    $0xb4,%eax
80107f8e:	c1 e8 10             	shr    $0x10,%eax
80107f91:	89 c2                	mov    %eax,%edx
80107f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f96:	05 b4 00 00 00       	add    $0xb4,%eax
80107f9b:	c1 e8 18             	shr    $0x18,%eax
80107f9e:	89 c1                	mov    %eax,%ecx
80107fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa3:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107faa:	00 00 
80107fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107faf:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb9:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc2:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107fc9:	83 e2 f0             	and    $0xfffffff0,%edx
80107fcc:	83 ca 02             	or     $0x2,%edx
80107fcf:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd8:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107fdf:	83 ca 10             	or     $0x10,%edx
80107fe2:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107feb:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107ff2:	83 e2 9f             	and    $0xffffff9f,%edx
80107ff5:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffe:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108005:	83 ca 80             	or     $0xffffff80,%edx
80108008:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010800e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108011:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108018:	83 e2 f0             	and    $0xfffffff0,%edx
8010801b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108024:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010802b:	83 e2 ef             	and    $0xffffffef,%edx
8010802e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108037:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010803e:	83 e2 df             	and    $0xffffffdf,%edx
80108041:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108051:	83 ca 40             	or     $0x40,%edx
80108054:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010805a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108064:	83 ca 80             	or     $0xffffff80,%edx
80108067:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010806d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108070:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108079:	83 c0 70             	add    $0x70,%eax
8010807c:	83 ec 08             	sub    $0x8,%esp
8010807f:	6a 38                	push   $0x38
80108081:	50                   	push   %eax
80108082:	e8 1a fb ff ff       	call   80107ba1 <lgdt>
80108087:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010808a:	83 ec 0c             	sub    $0xc,%esp
8010808d:	6a 18                	push   $0x18
8010808f:	e8 4e fb ff ff       	call   80107be2 <loadgs>
80108094:	83 c4 10             	add    $0x10,%esp

  // Initialize cpu-local storage.
  cpu = c;
80108097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809a:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801080a0:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801080a7:	00 00 00 00 
}
801080ab:	90                   	nop
801080ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801080af:	c9                   	leave  
801080b0:	c3                   	ret    

801080b1 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801080b1:	55                   	push   %ebp
801080b2:	89 e5                	mov    %esp,%ebp
801080b4:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801080b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801080ba:	c1 e8 16             	shr    $0x16,%eax
801080bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801080c4:	8b 45 08             	mov    0x8(%ebp),%eax
801080c7:	01 d0                	add    %edx,%eax
801080c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801080cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080cf:	8b 00                	mov    (%eax),%eax
801080d1:	83 e0 01             	and    $0x1,%eax
801080d4:	85 c0                	test   %eax,%eax
801080d6:	74 18                	je     801080f0 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801080d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080db:	8b 00                	mov    (%eax),%eax
801080dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080e2:	50                   	push   %eax
801080e3:	e8 29 fb ff ff       	call   80107c11 <p2v>
801080e8:	83 c4 04             	add    $0x4,%esp
801080eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080ee:	eb 48                	jmp    80108138 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801080f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801080f4:	74 0e                	je     80108104 <walkpgdir+0x53>
801080f6:	e8 ca aa ff ff       	call   80102bc5 <kalloc>
801080fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108102:	75 07                	jne    8010810b <walkpgdir+0x5a>
      return 0;
80108104:	b8 00 00 00 00       	mov    $0x0,%eax
80108109:	eb 44                	jmp    8010814f <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010810b:	83 ec 04             	sub    $0x4,%esp
8010810e:	68 00 10 00 00       	push   $0x1000
80108113:	6a 00                	push   $0x0
80108115:	ff 75 f4             	pushl  -0xc(%ebp)
80108118:	e8 b5 d3 ff ff       	call   801054d2 <memset>
8010811d:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U
80108120:	83 ec 0c             	sub    $0xc,%esp
80108123:	ff 75 f4             	pushl  -0xc(%ebp)
80108126:	e8 d9 fa ff ff       	call   80107c04 <v2p>
8010812b:	83 c4 10             	add    $0x10,%esp
8010812e:	83 c8 07             	or     $0x7,%eax
80108131:	89 c2                	mov    %eax,%edx
80108133:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108136:	89 10                	mov    %edx,(%eax)
;  }
  return &pgtab[PTX(va)];
80108138:	8b 45 0c             	mov    0xc(%ebp),%eax
8010813b:	c1 e8 0c             	shr    $0xc,%eax
8010813e:	25 ff 03 00 00       	and    $0x3ff,%eax
80108143:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010814a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010814d:	01 d0                	add    %edx,%eax
}
8010814f:	c9                   	leave  
80108150:	c3                   	ret    

80108151 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108151:	55                   	push   %ebp
80108152:	89 e5                	mov    %esp,%ebp
80108154:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80108157:	8b 45 0c             	mov    0xc(%ebp),%eax
8010815a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010815f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108162:	8b 55 0c             	mov    0xc(%ebp),%edx
80108165:	8b 45 10             	mov    0x10(%ebp),%eax
80108168:	01 d0                	add    %edx,%eax
8010816a:	83 e8 01             	sub    $0x1,%eax
8010816d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108172:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108175:	83 ec 04             	sub    $0x4,%esp
80108178:	6a 01                	push   $0x1
8010817a:	ff 75 f4             	pushl  -0xc(%ebp)
8010817d:	ff 75 08             	pushl  0x8(%ebp)
80108180:	e8 2c ff ff ff       	call   801080b1 <walkpgdir>
80108185:	83 c4 10             	add    $0x10,%esp
80108188:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010818b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010818f:	75 07                	jne    80108198 <mappages+0x47>
      return -1;
80108191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108196:	eb 47                	jmp    801081df <mappages+0x8e>
    if(*pte & PTE_P)
80108198:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010819b:	8b 00                	mov    (%eax),%eax
8010819d:	83 e0 01             	and    $0x1,%eax
801081a0:	85 c0                	test   %eax,%eax
801081a2:	74 0d                	je     801081b1 <mappages+0x60>
      panic("remap");
801081a4:	83 ec 0c             	sub    $0xc,%esp
801081a7:	68 b7 92 10 80       	push   $0x801092b7
801081ac:	e8 b5 83 ff ff       	call   80100566 <panic>
  //  page_references[PTE_ADDR(*pte)] = 1; //give pte_t a reference of one since fork copy just stopped there
    *pte = pa | perm | PTE_P;
801081b1:	8b 45 18             	mov    0x18(%ebp),%eax
801081b4:	0b 45 14             	or     0x14(%ebp),%eax
801081b7:	83 c8 01             	or     $0x1,%eax
801081ba:	89 c2                	mov    %eax,%edx
801081bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081bf:	89 10                	mov    %edx,(%eax)
    if(a == last)
801081c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801081c7:	74 10                	je     801081d9 <mappages+0x88>
      break;
    a += PGSIZE;
801081c9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801081d0:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801081d7:	eb 9c                	jmp    80108175 <mappages+0x24>
    if(*pte & PTE_P)
      panic("remap");
  //  page_references[PTE_ADDR(*pte)] = 1; //give pte_t a reference of one since fork copy just stopped there
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801081d9:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801081da:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081df:	c9                   	leave  
801081e0:	c3                   	ret    

801081e1 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801081e1:	55                   	push   %ebp
801081e2:	89 e5                	mov    %esp,%ebp
801081e4:	53                   	push   %ebx
801081e5:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801081e8:	e8 d8 a9 ff ff       	call   80102bc5 <kalloc>
801081ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
801081f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081f4:	75 0a                	jne    80108200 <setupkvm+0x1f>
    return 0;
801081f6:	b8 00 00 00 00       	mov    $0x0,%eax
801081fb:	e9 8e 00 00 00       	jmp    8010828e <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108200:	83 ec 04             	sub    $0x4,%esp
80108203:	68 00 10 00 00       	push   $0x1000
80108208:	6a 00                	push   $0x0
8010820a:	ff 75 f0             	pushl  -0x10(%ebp)
8010820d:	e8 c0 d2 ff ff       	call   801054d2 <memset>
80108212:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108215:	83 ec 0c             	sub    $0xc,%esp
80108218:	68 00 00 00 0e       	push   $0xe000000
8010821d:	e8 ef f9 ff ff       	call   80107c11 <p2v>
80108222:	83 c4 10             	add    $0x10,%esp
80108225:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010822a:	76 0d                	jbe    80108239 <setupkvm+0x58>
    panic("PHYSTOP too high");
8010822c:	83 ec 0c             	sub    $0xc,%esp
8010822f:	68 bd 92 10 80       	push   $0x801092bd
80108234:	e8 2d 83 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108239:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108240:	eb 40                	jmp    80108282 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108242:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108245:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010824b:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010824e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108251:	8b 58 08             	mov    0x8(%eax),%ebx
80108254:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108257:	8b 40 04             	mov    0x4(%eax),%eax
8010825a:	29 c3                	sub    %eax,%ebx
8010825c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825f:	8b 00                	mov    (%eax),%eax
80108261:	83 ec 0c             	sub    $0xc,%esp
80108264:	51                   	push   %ecx
80108265:	52                   	push   %edx
80108266:	53                   	push   %ebx
80108267:	50                   	push   %eax
80108268:	ff 75 f0             	pushl  -0x10(%ebp)
8010826b:	e8 e1 fe ff ff       	call   80108151 <mappages>
80108270:	83 c4 20             	add    $0x20,%esp
80108273:	85 c0                	test   %eax,%eax
80108275:	79 07                	jns    8010827e <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108277:	b8 00 00 00 00       	mov    $0x0,%eax
8010827c:	eb 10                	jmp    8010828e <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010827e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108282:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108289:	72 b7                	jb     80108242 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010828b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010828e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108291:	c9                   	leave  
80108292:	c3                   	ret    

80108293 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108293:	55                   	push   %ebp
80108294:	89 e5                	mov    %esp,%ebp
80108296:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108299:	e8 43 ff ff ff       	call   801081e1 <setupkvm>
8010829e:	a3 98 24 15 80       	mov    %eax,0x80152498
  switchkvm();
801082a3:	e8 03 00 00 00       	call   801082ab <switchkvm>
}
801082a8:	90                   	nop
801082a9:	c9                   	leave  
801082aa:	c3                   	ret    

801082ab <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801082ab:	55                   	push   %ebp
801082ac:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801082ae:	a1 98 24 15 80       	mov    0x80152498,%eax
801082b3:	50                   	push   %eax
801082b4:	e8 4b f9 ff ff       	call   80107c04 <v2p>
801082b9:	83 c4 04             	add    $0x4,%esp
801082bc:	50                   	push   %eax
801082bd:	e8 36 f9 ff ff       	call   80107bf8 <lcr3>
801082c2:	83 c4 04             	add    $0x4,%esp
}
801082c5:	90                   	nop
801082c6:	c9                   	leave  
801082c7:	c3                   	ret    

801082c8 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801082c8:	55                   	push   %ebp
801082c9:	89 e5                	mov    %esp,%ebp
801082cb:	56                   	push   %esi
801082cc:	53                   	push   %ebx
  pushcli();
801082cd:	e8 fa d0 ff ff       	call   801053cc <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801082d2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801082d8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082df:	83 c2 08             	add    $0x8,%edx
801082e2:	89 d6                	mov    %edx,%esi
801082e4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082eb:	83 c2 08             	add    $0x8,%edx
801082ee:	c1 ea 10             	shr    $0x10,%edx
801082f1:	89 d3                	mov    %edx,%ebx
801082f3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082fa:	83 c2 08             	add    $0x8,%edx
801082fd:	c1 ea 18             	shr    $0x18,%edx
80108300:	89 d1                	mov    %edx,%ecx
80108302:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108309:	67 00 
8010830b:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108312:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108318:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010831f:	83 e2 f0             	and    $0xfffffff0,%edx
80108322:	83 ca 09             	or     $0x9,%edx
80108325:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010832b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108332:	83 ca 10             	or     $0x10,%edx
80108335:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010833b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108342:	83 e2 9f             	and    $0xffffff9f,%edx
80108345:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010834b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108352:	83 ca 80             	or     $0xffffff80,%edx
80108355:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010835b:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108362:	83 e2 f0             	and    $0xfffffff0,%edx
80108365:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010836b:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108372:	83 e2 ef             	and    $0xffffffef,%edx
80108375:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010837b:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108382:	83 e2 df             	and    $0xffffffdf,%edx
80108385:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010838b:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108392:	83 ca 40             	or     $0x40,%edx
80108395:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010839b:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801083a2:	83 e2 7f             	and    $0x7f,%edx
801083a5:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801083ab:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801083b1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083b7:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083be:	83 e2 ef             	and    $0xffffffef,%edx
801083c1:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801083c7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083cd:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801083d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083d9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801083e0:	8b 52 08             	mov    0x8(%edx),%edx
801083e3:	81 c2 00 10 00 00    	add    $0x1000,%edx
801083e9:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801083ec:	83 ec 0c             	sub    $0xc,%esp
801083ef:	6a 30                	push   $0x30
801083f1:	e8 d5 f7 ff ff       	call   80107bcb <ltr>
801083f6:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801083f9:	8b 45 08             	mov    0x8(%ebp),%eax
801083fc:	8b 40 04             	mov    0x4(%eax),%eax
801083ff:	85 c0                	test   %eax,%eax
80108401:	75 0d                	jne    80108410 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108403:	83 ec 0c             	sub    $0xc,%esp
80108406:	68 ce 92 10 80       	push   $0x801092ce
8010840b:	e8 56 81 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108410:	8b 45 08             	mov    0x8(%ebp),%eax
80108413:	8b 40 04             	mov    0x4(%eax),%eax
80108416:	83 ec 0c             	sub    $0xc,%esp
80108419:	50                   	push   %eax
8010841a:	e8 e5 f7 ff ff       	call   80107c04 <v2p>
8010841f:	83 c4 10             	add    $0x10,%esp
80108422:	83 ec 0c             	sub    $0xc,%esp
80108425:	50                   	push   %eax
80108426:	e8 cd f7 ff ff       	call   80107bf8 <lcr3>
8010842b:	83 c4 10             	add    $0x10,%esp
  popcli();
8010842e:	e8 de cf ff ff       	call   80105411 <popcli>
}
80108433:	90                   	nop
80108434:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108437:	5b                   	pop    %ebx
80108438:	5e                   	pop    %esi
80108439:	5d                   	pop    %ebp
8010843a:	c3                   	ret    

8010843b <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010843b:	55                   	push   %ebp
8010843c:	89 e5                	mov    %esp,%ebp
8010843e:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80108441:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108448:	76 0d                	jbe    80108457 <inituvm+0x1c>
    panic("inituvm: more than a page");
8010844a:	83 ec 0c             	sub    $0xc,%esp
8010844d:	68 e2 92 10 80       	push   $0x801092e2
80108452:	e8 0f 81 ff ff       	call   80100566 <panic>
  mem = kalloc();
80108457:	e8 69 a7 ff ff       	call   80102bc5 <kalloc>
8010845c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010845f:	83 ec 04             	sub    $0x4,%esp
80108462:	68 00 10 00 00       	push   $0x1000
80108467:	6a 00                	push   $0x0
80108469:	ff 75 f4             	pushl  -0xc(%ebp)
8010846c:	e8 61 d0 ff ff       	call   801054d2 <memset>
80108471:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108474:	83 ec 0c             	sub    $0xc,%esp
80108477:	ff 75 f4             	pushl  -0xc(%ebp)
8010847a:	e8 85 f7 ff ff       	call   80107c04 <v2p>
8010847f:	83 c4 10             	add    $0x10,%esp
80108482:	83 ec 0c             	sub    $0xc,%esp
80108485:	6a 06                	push   $0x6
80108487:	50                   	push   %eax
80108488:	68 00 10 00 00       	push   $0x1000
8010848d:	6a 00                	push   $0x0
8010848f:	ff 75 08             	pushl  0x8(%ebp)
80108492:	e8 ba fc ff ff       	call   80108151 <mappages>
80108497:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010849a:	83 ec 04             	sub    $0x4,%esp
8010849d:	ff 75 10             	pushl  0x10(%ebp)
801084a0:	ff 75 0c             	pushl  0xc(%ebp)
801084a3:	ff 75 f4             	pushl  -0xc(%ebp)
801084a6:	e8 e6 d0 ff ff       	call   80105591 <memmove>
801084ab:	83 c4 10             	add    $0x10,%esp
}
801084ae:	90                   	nop
801084af:	c9                   	leave  
801084b0:	c3                   	ret    

801084b1 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801084b1:	55                   	push   %ebp
801084b2:	89 e5                	mov    %esp,%ebp
801084b4:	53                   	push   %ebx
801084b5:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801084b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801084bb:	25 ff 0f 00 00       	and    $0xfff,%eax
801084c0:	85 c0                	test   %eax,%eax
801084c2:	74 0d                	je     801084d1 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801084c4:	83 ec 0c             	sub    $0xc,%esp
801084c7:	68 fc 92 10 80       	push   $0x801092fc
801084cc:	e8 95 80 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801084d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801084d8:	e9 95 00 00 00       	jmp    80108572 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801084dd:	8b 55 0c             	mov    0xc(%ebp),%edx
801084e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e3:	01 d0                	add    %edx,%eax
801084e5:	83 ec 04             	sub    $0x4,%esp
801084e8:	6a 00                	push   $0x0
801084ea:	50                   	push   %eax
801084eb:	ff 75 08             	pushl  0x8(%ebp)
801084ee:	e8 be fb ff ff       	call   801080b1 <walkpgdir>
801084f3:	83 c4 10             	add    $0x10,%esp
801084f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801084f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801084fd:	75 0d                	jne    8010850c <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801084ff:	83 ec 0c             	sub    $0xc,%esp
80108502:	68 1f 93 10 80       	push   $0x8010931f
80108507:	e8 5a 80 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010850c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010850f:	8b 00                	mov    (%eax),%eax
80108511:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108516:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108519:	8b 45 18             	mov    0x18(%ebp),%eax
8010851c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010851f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108524:	77 0b                	ja     80108531 <loaduvm+0x80>
      n = sz - i;
80108526:	8b 45 18             	mov    0x18(%ebp),%eax
80108529:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010852c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010852f:	eb 07                	jmp    80108538 <loaduvm+0x87>
    else
      n = PGSIZE;
80108531:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108538:	8b 55 14             	mov    0x14(%ebp),%edx
8010853b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010853e:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108541:	83 ec 0c             	sub    $0xc,%esp
80108544:	ff 75 e8             	pushl  -0x18(%ebp)
80108547:	e8 c5 f6 ff ff       	call   80107c11 <p2v>
8010854c:	83 c4 10             	add    $0x10,%esp
8010854f:	ff 75 f0             	pushl  -0x10(%ebp)
80108552:	53                   	push   %ebx
80108553:	50                   	push   %eax
80108554:	ff 75 10             	pushl  0x10(%ebp)
80108557:	e8 17 99 ff ff       	call   80101e73 <readi>
8010855c:	83 c4 10             	add    $0x10,%esp
8010855f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108562:	74 07                	je     8010856b <loaduvm+0xba>
      return -1;
80108564:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108569:	eb 18                	jmp    80108583 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010856b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108572:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108575:	3b 45 18             	cmp    0x18(%ebp),%eax
80108578:	0f 82 5f ff ff ff    	jb     801084dd <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010857e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108583:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108586:	c9                   	leave  
80108587:	c3                   	ret    

80108588 <mprotect>:

int
mprotect(void *addr, int len, int prot)
{
80108588:	55                   	push   %ebp
80108589:	89 e5                	mov    %esp,%ebp
8010858b:	83 ec 18             	sub    $0x18,%esp
  pte_t *page_table_entry;
  //might need to PGRDWN the address
  //loop through all the page entries that need protection level changed
  //makes prot cnstants change in types.h
  //break it down, use PTE
  cprintf("addr: %d\n",(int)addr);
8010858e:	8b 45 08             	mov    0x8(%ebp),%eax
80108591:	83 ec 08             	sub    $0x8,%esp
80108594:	50                   	push   %eax
80108595:	68 3d 93 10 80       	push   $0x8010933d
8010859a:	e8 27 7e ff ff       	call   801003c6 <cprintf>
8010859f:	83 c4 10             	add    $0x10,%esp
  uint base_addr = PGROUNDDOWN((uint)addr);
801085a2:	8b 45 08             	mov    0x8(%ebp),%eax
801085a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint curr = base_addr;
801085ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  do {

    page_table_entry = walkpgdir(proc->pgdir,(void *)curr ,0);
801085b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801085b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085bc:	8b 40 04             	mov    0x4(%eax),%eax
801085bf:	83 ec 04             	sub    $0x4,%esp
801085c2:	6a 00                	push   $0x0
801085c4:	52                   	push   %edx
801085c5:	50                   	push   %eax
801085c6:	e8 e6 fa ff ff       	call   801080b1 <walkpgdir>
801085cb:	83 c4 10             	add    $0x10,%esp
801085ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
    curr += PGSIZE;
801085d1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    //clear last 3 bits
    cprintf("page table entry before: 0x%x desireced prot = %d\n",*page_table_entry,prot);
801085d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085db:	8b 00                	mov    (%eax),%eax
801085dd:	83 ec 04             	sub    $0x4,%esp
801085e0:	ff 75 10             	pushl  0x10(%ebp)
801085e3:	50                   	push   %eax
801085e4:	68 48 93 10 80       	push   $0x80109348
801085e9:	e8 d8 7d ff ff       	call   801003c6 <cprintf>
801085ee:	83 c4 10             	add    $0x10,%esp
    // *page_table_entry &= 0xfffffff9;
    // cprintf("page table entry after clear: 0x%x\n",*page_table_entry);
    switch(prot) {
801085f1:	8b 45 10             	mov    0x10(%ebp),%eax
801085f4:	83 f8 01             	cmp    $0x1,%eax
801085f7:	74 28                	je     80108621 <mprotect+0x99>
801085f9:	83 f8 01             	cmp    $0x1,%eax
801085fc:	7f 06                	jg     80108604 <mprotect+0x7c>
801085fe:	85 c0                	test   %eax,%eax
80108600:	74 0e                	je     80108610 <mprotect+0x88>
80108602:	eb 4e                	jmp    80108652 <mprotect+0xca>
80108604:	83 f8 02             	cmp    $0x2,%eax
80108607:	74 29                	je     80108632 <mprotect+0xaa>
80108609:	83 f8 03             	cmp    $0x3,%eax
8010860c:	74 35                	je     80108643 <mprotect+0xbb>
8010860e:	eb 42                	jmp    80108652 <mprotect+0xca>
      case PROT_NONE:
        *page_table_entry &= ~(PTE_U | PTE_W);
80108610:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108613:	8b 00                	mov    (%eax),%eax
80108615:	83 e0 f9             	and    $0xfffffff9,%eax
80108618:	89 c2                	mov    %eax,%edx
8010861a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010861d:	89 10                	mov    %edx,(%eax)
        break;
8010861f:	eb 31                	jmp    80108652 <mprotect+0xca>
      case PROT_READ: //good
        *page_table_entry &= (~PTE_W |PTE_U);
80108621:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108624:	8b 00                	mov    (%eax),%eax
80108626:	83 e0 fd             	and    $0xfffffffd,%eax
80108629:	89 c2                	mov    %eax,%edx
8010862b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010862e:	89 10                	mov    %edx,(%eax)
        break;
80108630:	eb 20                	jmp    80108652 <mprotect+0xca>
      case PROT_WRITE:
        *page_table_entry |= (PTE_P | PTE_W);
80108632:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108635:	8b 00                	mov    (%eax),%eax
80108637:	83 c8 03             	or     $0x3,%eax
8010863a:	89 c2                	mov    %eax,%edx
8010863c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010863f:	89 10                	mov    %edx,(%eax)
        break;
80108641:	eb 0f                	jmp    80108652 <mprotect+0xca>
      case PROT_READ | PROT_WRITE: //good
        *page_table_entry |= (PTE_P | PTE_W | PTE_U);
80108643:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108646:	8b 00                	mov    (%eax),%eax
80108648:	83 c8 07             	or     $0x7,%eax
8010864b:	89 c2                	mov    %eax,%edx
8010864d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108650:	89 10                	mov    %edx,(%eax)
    }
    cprintf("page table entry after: 0x%x\n",*page_table_entry);
80108652:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108655:	8b 00                	mov    (%eax),%eax
80108657:	83 ec 08             	sub    $0x8,%esp
8010865a:	50                   	push   %eax
8010865b:	68 7b 93 10 80       	push   $0x8010937b
80108660:	e8 61 7d ff ff       	call   801003c6 <cprintf>
80108665:	83 c4 10             	add    $0x10,%esp
  } while(curr < ((uint)addr +len));
80108668:	8b 55 08             	mov    0x8(%ebp),%edx
8010866b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010866e:	01 d0                	add    %edx,%eax
80108670:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80108673:	0f 87 3a ff ff ff    	ja     801085b3 <mprotect+0x2b>

  //flush that tlb real good
  lcr3(v2p(proc->pgdir));
80108679:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010867f:	8b 40 04             	mov    0x4(%eax),%eax
80108682:	83 ec 0c             	sub    $0xc,%esp
80108685:	50                   	push   %eax
80108686:	e8 79 f5 ff ff       	call   80107c04 <v2p>
8010868b:	83 c4 10             	add    $0x10,%esp
8010868e:	83 ec 0c             	sub    $0xc,%esp
80108691:	50                   	push   %eax
80108692:	e8 61 f5 ff ff       	call   80107bf8 <lcr3>
80108697:	83 c4 10             	add    $0x10,%esp
  cprintf("returning from mprotect\n");
8010869a:	83 ec 0c             	sub    $0xc,%esp
8010869d:	68 99 93 10 80       	push   $0x80109399
801086a2:	e8 1f 7d ff ff       	call   801003c6 <cprintf>
801086a7:	83 c4 10             	add    $0x10,%esp
  return 0; ///what happens after returned?
801086aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801086af:	c9                   	leave  
801086b0:	c3                   	ret    

801086b1 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801086b1:	55                   	push   %ebp
801086b2:	89 e5                	mov    %esp,%ebp
801086b4:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801086b7:	8b 45 10             	mov    0x10(%ebp),%eax
801086ba:	85 c0                	test   %eax,%eax
801086bc:	79 0a                	jns    801086c8 <allocuvm+0x17>
    return 0;
801086be:	b8 00 00 00 00       	mov    $0x0,%eax
801086c3:	e9 b0 00 00 00       	jmp    80108778 <allocuvm+0xc7>
  if(newsz < oldsz)
801086c8:	8b 45 10             	mov    0x10(%ebp),%eax
801086cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086ce:	73 08                	jae    801086d8 <allocuvm+0x27>
    return oldsz;
801086d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801086d3:	e9 a0 00 00 00       	jmp    80108778 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
801086d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801086db:	05 ff 0f 00 00       	add    $0xfff,%eax
801086e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801086e8:	eb 7f                	jmp    80108769 <allocuvm+0xb8>
    mem = kalloc();
801086ea:	e8 d6 a4 ff ff       	call   80102bc5 <kalloc>
801086ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801086f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801086f6:	75 2b                	jne    80108723 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
801086f8:	83 ec 0c             	sub    $0xc,%esp
801086fb:	68 b2 93 10 80       	push   $0x801093b2
80108700:	e8 c1 7c ff ff       	call   801003c6 <cprintf>
80108705:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108708:	83 ec 04             	sub    $0x4,%esp
8010870b:	ff 75 0c             	pushl  0xc(%ebp)
8010870e:	ff 75 10             	pushl  0x10(%ebp)
80108711:	ff 75 08             	pushl  0x8(%ebp)
80108714:	e8 61 00 00 00       	call   8010877a <deallocuvm>
80108719:	83 c4 10             	add    $0x10,%esp
      return 0;
8010871c:	b8 00 00 00 00       	mov    $0x0,%eax
80108721:	eb 55                	jmp    80108778 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108723:	83 ec 04             	sub    $0x4,%esp
80108726:	68 00 10 00 00       	push   $0x1000
8010872b:	6a 00                	push   $0x0
8010872d:	ff 75 f0             	pushl  -0x10(%ebp)
80108730:	e8 9d cd ff ff       	call   801054d2 <memset>
80108735:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108738:	83 ec 0c             	sub    $0xc,%esp
8010873b:	ff 75 f0             	pushl  -0x10(%ebp)
8010873e:	e8 c1 f4 ff ff       	call   80107c04 <v2p>
80108743:	83 c4 10             	add    $0x10,%esp
80108746:	89 c2                	mov    %eax,%edx
80108748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010874b:	83 ec 0c             	sub    $0xc,%esp
8010874e:	6a 06                	push   $0x6
80108750:	52                   	push   %edx
80108751:	68 00 10 00 00       	push   $0x1000
80108756:	50                   	push   %eax
80108757:	ff 75 08             	pushl  0x8(%ebp)
8010875a:	e8 f2 f9 ff ff       	call   80108151 <mappages>
8010875f:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108762:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108769:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010876c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010876f:	0f 82 75 ff ff ff    	jb     801086ea <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108775:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108778:	c9                   	leave  
80108779:	c3                   	ret    

8010877a <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010877a:	55                   	push   %ebp
8010877b:	89 e5                	mov    %esp,%ebp
8010877d:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108780:	8b 45 10             	mov    0x10(%ebp),%eax
80108783:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108786:	72 08                	jb     80108790 <deallocuvm+0x16>
    return oldsz;
80108788:	8b 45 0c             	mov    0xc(%ebp),%eax
8010878b:	e9 a5 00 00 00       	jmp    80108835 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108790:	8b 45 10             	mov    0x10(%ebp),%eax
80108793:	05 ff 0f 00 00       	add    $0xfff,%eax
80108798:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010879d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801087a0:	e9 81 00 00 00       	jmp    80108826 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801087a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a8:	83 ec 04             	sub    $0x4,%esp
801087ab:	6a 00                	push   $0x0
801087ad:	50                   	push   %eax
801087ae:	ff 75 08             	pushl  0x8(%ebp)
801087b1:	e8 fb f8 ff ff       	call   801080b1 <walkpgdir>
801087b6:	83 c4 10             	add    $0x10,%esp
801087b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801087bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087c0:	75 09                	jne    801087cb <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801087c2:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801087c9:	eb 54                	jmp    8010881f <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
801087cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087ce:	8b 00                	mov    (%eax),%eax
801087d0:	83 e0 01             	and    $0x1,%eax
801087d3:	85 c0                	test   %eax,%eax
801087d5:	74 48                	je     8010881f <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801087d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087da:	8b 00                	mov    (%eax),%eax
801087dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801087e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087e8:	75 0d                	jne    801087f7 <deallocuvm+0x7d>
        panic("kfree");
801087ea:	83 ec 0c             	sub    $0xc,%esp
801087ed:	68 ca 93 10 80       	push   $0x801093ca
801087f2:	e8 6f 7d ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
801087f7:	83 ec 0c             	sub    $0xc,%esp
801087fa:	ff 75 ec             	pushl  -0x14(%ebp)
801087fd:	e8 0f f4 ff ff       	call   80107c11 <p2v>
80108802:	83 c4 10             	add    $0x10,%esp
80108805:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108808:	83 ec 0c             	sub    $0xc,%esp
8010880b:	ff 75 e8             	pushl  -0x18(%ebp)
8010880e:	e8 15 a3 ff ff       	call   80102b28 <kfree>
80108813:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108816:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010881f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108829:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010882c:	0f 82 73 ff ff ff    	jb     801087a5 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108832:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108835:	c9                   	leave  
80108836:	c3                   	ret    

80108837 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108837:	55                   	push   %ebp
80108838:	89 e5                	mov    %esp,%ebp
8010883a:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010883d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108841:	75 0d                	jne    80108850 <freevm+0x19>
    panic("freevm: no pgdir");
80108843:	83 ec 0c             	sub    $0xc,%esp
80108846:	68 d0 93 10 80       	push   $0x801093d0
8010884b:	e8 16 7d ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108850:	83 ec 04             	sub    $0x4,%esp
80108853:	6a 00                	push   $0x0
80108855:	68 00 00 00 80       	push   $0x80000000
8010885a:	ff 75 08             	pushl  0x8(%ebp)
8010885d:	e8 18 ff ff ff       	call   8010877a <deallocuvm>
80108862:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108865:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010886c:	eb 4f                	jmp    801088bd <freevm+0x86>
    if(pgdir[i] & PTE_P){
8010886e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108871:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108878:	8b 45 08             	mov    0x8(%ebp),%eax
8010887b:	01 d0                	add    %edx,%eax
8010887d:	8b 00                	mov    (%eax),%eax
8010887f:	83 e0 01             	and    $0x1,%eax
80108882:	85 c0                	test   %eax,%eax
80108884:	74 33                	je     801088b9 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108886:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108889:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108890:	8b 45 08             	mov    0x8(%ebp),%eax
80108893:	01 d0                	add    %edx,%eax
80108895:	8b 00                	mov    (%eax),%eax
80108897:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010889c:	83 ec 0c             	sub    $0xc,%esp
8010889f:	50                   	push   %eax
801088a0:	e8 6c f3 ff ff       	call   80107c11 <p2v>
801088a5:	83 c4 10             	add    $0x10,%esp
801088a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801088ab:	83 ec 0c             	sub    $0xc,%esp
801088ae:	ff 75 f0             	pushl  -0x10(%ebp)
801088b1:	e8 72 a2 ff ff       	call   80102b28 <kfree>
801088b6:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801088b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801088bd:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801088c4:	76 a8                	jbe    8010886e <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801088c6:	83 ec 0c             	sub    $0xc,%esp
801088c9:	ff 75 08             	pushl  0x8(%ebp)
801088cc:	e8 57 a2 ff ff       	call   80102b28 <kfree>
801088d1:	83 c4 10             	add    $0x10,%esp
}
801088d4:	90                   	nop
801088d5:	c9                   	leave  
801088d6:	c3                   	ret    

801088d7 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801088d7:	55                   	push   %ebp
801088d8:	89 e5                	mov    %esp,%ebp
801088da:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801088dd:	83 ec 04             	sub    $0x4,%esp
801088e0:	6a 00                	push   $0x0
801088e2:	ff 75 0c             	pushl  0xc(%ebp)
801088e5:	ff 75 08             	pushl  0x8(%ebp)
801088e8:	e8 c4 f7 ff ff       	call   801080b1 <walkpgdir>
801088ed:	83 c4 10             	add    $0x10,%esp
801088f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801088f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801088f7:	75 0d                	jne    80108906 <clearpteu+0x2f>
    panic("clearpteu");
801088f9:	83 ec 0c             	sub    $0xc,%esp
801088fc:	68 e1 93 10 80       	push   $0x801093e1
80108901:	e8 60 7c ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80108906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108909:	8b 00                	mov    (%eax),%eax
8010890b:	83 e0 fb             	and    $0xfffffffb,%eax
8010890e:	89 c2                	mov    %eax,%edx
80108910:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108913:	89 10                	mov    %edx,(%eax)
}
80108915:	90                   	nop
80108916:	c9                   	leave  
80108917:	c3                   	ret    

80108918 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108918:	55                   	push   %ebp
80108919:	89 e5                	mov    %esp,%ebp
8010891b:	53                   	push   %ebx
8010891c:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010891f:	e8 bd f8 ff ff       	call   801081e1 <setupkvm>
80108924:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108927:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010892b:	75 0a                	jne    80108937 <copyuvm+0x1f>
    return 0;
8010892d:	b8 00 00 00 00       	mov    $0x0,%eax
80108932:	e9 f8 00 00 00       	jmp    80108a2f <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108937:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010893e:	e9 c4 00 00 00       	jmp    80108a07 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108946:	83 ec 04             	sub    $0x4,%esp
80108949:	6a 00                	push   $0x0
8010894b:	50                   	push   %eax
8010894c:	ff 75 08             	pushl  0x8(%ebp)
8010894f:	e8 5d f7 ff ff       	call   801080b1 <walkpgdir>
80108954:	83 c4 10             	add    $0x10,%esp
80108957:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010895a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010895e:	75 0d                	jne    8010896d <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108960:	83 ec 0c             	sub    $0xc,%esp
80108963:	68 eb 93 10 80       	push   $0x801093eb
80108968:	e8 f9 7b ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
8010896d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108970:	8b 00                	mov    (%eax),%eax
80108972:	83 e0 01             	and    $0x1,%eax
80108975:	85 c0                	test   %eax,%eax
80108977:	75 0d                	jne    80108986 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108979:	83 ec 0c             	sub    $0xc,%esp
8010897c:	68 05 94 10 80       	push   $0x80109405
80108981:	e8 e0 7b ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108986:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108989:	8b 00                	mov    (%eax),%eax
8010898b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108990:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108993:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108996:	8b 00                	mov    (%eax),%eax
80108998:	25 ff 0f 00 00       	and    $0xfff,%eax
8010899d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801089a0:	e8 20 a2 ff ff       	call   80102bc5 <kalloc>
801089a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801089a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801089ac:	74 6a                	je     80108a18 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801089ae:	83 ec 0c             	sub    $0xc,%esp
801089b1:	ff 75 e8             	pushl  -0x18(%ebp)
801089b4:	e8 58 f2 ff ff       	call   80107c11 <p2v>
801089b9:	83 c4 10             	add    $0x10,%esp
801089bc:	83 ec 04             	sub    $0x4,%esp
801089bf:	68 00 10 00 00       	push   $0x1000
801089c4:	50                   	push   %eax
801089c5:	ff 75 e0             	pushl  -0x20(%ebp)
801089c8:	e8 c4 cb ff ff       	call   80105591 <memmove>
801089cd:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801089d0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801089d3:	83 ec 0c             	sub    $0xc,%esp
801089d6:	ff 75 e0             	pushl  -0x20(%ebp)
801089d9:	e8 26 f2 ff ff       	call   80107c04 <v2p>
801089de:	83 c4 10             	add    $0x10,%esp
801089e1:	89 c2                	mov    %eax,%edx
801089e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089e6:	83 ec 0c             	sub    $0xc,%esp
801089e9:	53                   	push   %ebx
801089ea:	52                   	push   %edx
801089eb:	68 00 10 00 00       	push   $0x1000
801089f0:	50                   	push   %eax
801089f1:	ff 75 f0             	pushl  -0x10(%ebp)
801089f4:	e8 58 f7 ff ff       	call   80108151 <mappages>
801089f9:	83 c4 20             	add    $0x20,%esp
801089fc:	85 c0                	test   %eax,%eax
801089fe:	78 1b                	js     80108a1b <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108a00:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a0a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a0d:	0f 82 30 ff ff ff    	jb     80108943 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a16:	eb 17                	jmp    80108a2f <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108a18:	90                   	nop
80108a19:	eb 01                	jmp    80108a1c <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108a1b:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108a1c:	83 ec 0c             	sub    $0xc,%esp
80108a1f:	ff 75 f0             	pushl  -0x10(%ebp)
80108a22:	e8 10 fe ff ff       	call   80108837 <freevm>
80108a27:	83 c4 10             	add    $0x10,%esp
  return 0;
80108a2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108a32:	c9                   	leave  
80108a33:	c3                   	ret    

80108a34 <copyuvm_cow>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm_cow(pde_t *pgdir, uint sz)
{
80108a34:	55                   	push   %ebp
80108a35:	89 e5                	mov    %esp,%ebp
80108a37:	53                   	push   %ebx
80108a38:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108a3b:	e8 a1 f7 ff ff       	call   801081e1 <setupkvm>
80108a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108a43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a47:	75 0a                	jne    80108a53 <copyuvm_cow+0x1f>
    return 0;
80108a49:	b8 00 00 00 00       	mov    $0x0,%eax
80108a4e:	e9 f8 00 00 00       	jmp    80108b4b <copyuvm_cow+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108a53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a5a:	e9 c4 00 00 00       	jmp    80108b23 <copyuvm_cow+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a62:	83 ec 04             	sub    $0x4,%esp
80108a65:	6a 00                	push   $0x0
80108a67:	50                   	push   %eax
80108a68:	ff 75 08             	pushl  0x8(%ebp)
80108a6b:	e8 41 f6 ff ff       	call   801080b1 <walkpgdir>
80108a70:	83 c4 10             	add    $0x10,%esp
80108a73:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108a76:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a7a:	75 0d                	jne    80108a89 <copyuvm_cow+0x55>
      panic("copyuvm: pte should exist");
80108a7c:	83 ec 0c             	sub    $0xc,%esp
80108a7f:	68 eb 93 10 80       	push   $0x801093eb
80108a84:	e8 dd 7a ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a8c:	8b 00                	mov    (%eax),%eax
80108a8e:	83 e0 01             	and    $0x1,%eax
80108a91:	85 c0                	test   %eax,%eax
80108a93:	75 0d                	jne    80108aa2 <copyuvm_cow+0x6e>
      panic("copyuvm: page not present");
80108a95:	83 ec 0c             	sub    $0xc,%esp
80108a98:	68 05 94 10 80       	push   $0x80109405
80108a9d:	e8 c4 7a ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108aa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108aa5:	8b 00                	mov    (%eax),%eax
80108aa7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108aac:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ab2:	8b 00                	mov    (%eax),%eax
80108ab4:	25 ff 0f 00 00       	and    $0xfff,%eax
80108ab9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108abc:	e8 04 a1 ff ff       	call   80102bc5 <kalloc>
80108ac1:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108ac4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108ac8:	74 6a                	je     80108b34 <copyuvm_cow+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108aca:	83 ec 0c             	sub    $0xc,%esp
80108acd:	ff 75 e8             	pushl  -0x18(%ebp)
80108ad0:	e8 3c f1 ff ff       	call   80107c11 <p2v>
80108ad5:	83 c4 10             	add    $0x10,%esp
80108ad8:	83 ec 04             	sub    $0x4,%esp
80108adb:	68 00 10 00 00       	push   $0x1000
80108ae0:	50                   	push   %eax
80108ae1:	ff 75 e0             	pushl  -0x20(%ebp)
80108ae4:	e8 a8 ca ff ff       	call   80105591 <memmove>
80108ae9:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108aec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108aef:	83 ec 0c             	sub    $0xc,%esp
80108af2:	ff 75 e0             	pushl  -0x20(%ebp)
80108af5:	e8 0a f1 ff ff       	call   80107c04 <v2p>
80108afa:	83 c4 10             	add    $0x10,%esp
80108afd:	89 c2                	mov    %eax,%edx
80108aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b02:	83 ec 0c             	sub    $0xc,%esp
80108b05:	53                   	push   %ebx
80108b06:	52                   	push   %edx
80108b07:	68 00 10 00 00       	push   $0x1000
80108b0c:	50                   	push   %eax
80108b0d:	ff 75 f0             	pushl  -0x10(%ebp)
80108b10:	e8 3c f6 ff ff       	call   80108151 <mappages>
80108b15:	83 c4 20             	add    $0x20,%esp
80108b18:	85 c0                	test   %eax,%eax
80108b1a:	78 1b                	js     80108b37 <copyuvm_cow+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108b1c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b26:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108b29:	0f 82 30 ff ff ff    	jb     80108a5f <copyuvm_cow+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b32:	eb 17                	jmp    80108b4b <copyuvm_cow+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108b34:	90                   	nop
80108b35:	eb 01                	jmp    80108b38 <copyuvm_cow+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108b37:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108b38:	83 ec 0c             	sub    $0xc,%esp
80108b3b:	ff 75 f0             	pushl  -0x10(%ebp)
80108b3e:	e8 f4 fc ff ff       	call   80108837 <freevm>
80108b43:	83 c4 10             	add    $0x10,%esp
  return 0;
80108b46:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108b4e:	c9                   	leave  
80108b4f:	c3                   	ret    

80108b50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108b50:	55                   	push   %ebp
80108b51:	89 e5                	mov    %esp,%ebp
80108b53:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108b56:	83 ec 04             	sub    $0x4,%esp
80108b59:	6a 00                	push   $0x0
80108b5b:	ff 75 0c             	pushl  0xc(%ebp)
80108b5e:	ff 75 08             	pushl  0x8(%ebp)
80108b61:	e8 4b f5 ff ff       	call   801080b1 <walkpgdir>
80108b66:	83 c4 10             	add    $0x10,%esp
80108b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b6f:	8b 00                	mov    (%eax),%eax
80108b71:	83 e0 01             	and    $0x1,%eax
80108b74:	85 c0                	test   %eax,%eax
80108b76:	75 07                	jne    80108b7f <uva2ka+0x2f>
    return 0;
80108b78:	b8 00 00 00 00       	mov    $0x0,%eax
80108b7d:	eb 29                	jmp    80108ba8 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b82:	8b 00                	mov    (%eax),%eax
80108b84:	83 e0 04             	and    $0x4,%eax
80108b87:	85 c0                	test   %eax,%eax
80108b89:	75 07                	jne    80108b92 <uva2ka+0x42>
    return 0;
80108b8b:	b8 00 00 00 00       	mov    $0x0,%eax
80108b90:	eb 16                	jmp    80108ba8 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b95:	8b 00                	mov    (%eax),%eax
80108b97:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b9c:	83 ec 0c             	sub    $0xc,%esp
80108b9f:	50                   	push   %eax
80108ba0:	e8 6c f0 ff ff       	call   80107c11 <p2v>
80108ba5:	83 c4 10             	add    $0x10,%esp
}
80108ba8:	c9                   	leave  
80108ba9:	c3                   	ret    

80108baa <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108baa:	55                   	push   %ebp
80108bab:	89 e5                	mov    %esp,%ebp
80108bad:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108bb0:	8b 45 10             	mov    0x10(%ebp),%eax
80108bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108bb6:	eb 7f                	jmp    80108c37 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bc6:	83 ec 08             	sub    $0x8,%esp
80108bc9:	50                   	push   %eax
80108bca:	ff 75 08             	pushl  0x8(%ebp)
80108bcd:	e8 7e ff ff ff       	call   80108b50 <uva2ka>
80108bd2:	83 c4 10             	add    $0x10,%esp
80108bd5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108bd8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108bdc:	75 07                	jne    80108be5 <copyout+0x3b>
      return -1;
80108bde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108be3:	eb 61                	jmp    80108c46 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108be8:	2b 45 0c             	sub    0xc(%ebp),%eax
80108beb:	05 00 10 00 00       	add    $0x1000,%eax
80108bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bf6:	3b 45 14             	cmp    0x14(%ebp),%eax
80108bf9:	76 06                	jbe    80108c01 <copyout+0x57>
      n = len;
80108bfb:	8b 45 14             	mov    0x14(%ebp),%eax
80108bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108c01:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c04:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108c07:	89 c2                	mov    %eax,%edx
80108c09:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c0c:	01 d0                	add    %edx,%eax
80108c0e:	83 ec 04             	sub    $0x4,%esp
80108c11:	ff 75 f0             	pushl  -0x10(%ebp)
80108c14:	ff 75 f4             	pushl  -0xc(%ebp)
80108c17:	50                   	push   %eax
80108c18:	e8 74 c9 ff ff       	call   80105591 <memmove>
80108c1d:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c23:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c29:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c2f:	05 00 10 00 00       	add    $0x1000,%eax
80108c34:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108c37:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108c3b:	0f 85 77 ff ff ff    	jne    80108bb8 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108c41:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c46:	c9                   	leave  
80108c47:	c3                   	ret    
