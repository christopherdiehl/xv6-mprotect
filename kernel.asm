
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
8010003d:	68 14 8b 10 80       	push   $0x80108b14
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 0f 52 00 00       	call   8010525b <initlock>
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
801000c1:	e8 b7 51 00 00       	call   8010527d <acquire>
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
8010010c:	e8 d3 51 00 00       	call   801052e4 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 d5 4c 00 00       	call   80104e01 <sleep>
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
80100188:	e8 57 51 00 00       	call   801052e4 <release>
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
801001aa:	68 1b 8b 10 80       	push   $0x80108b1b
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
80100204:	68 2c 8b 10 80       	push   $0x80108b2c
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
80100243:	68 33 8b 10 80       	push   $0x80108b33
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 23 50 00 00       	call   8010527d <acquire>
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
801002b9:	e8 31 4c 00 00       	call   80104eef <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 16 50 00 00       	call   801052e4 <release>
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
801003e2:	e8 96 4e 00 00       	call   8010527d <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 3a 8b 10 80       	push   $0x80108b3a
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
801004cd:	c7 45 ec 43 8b 10 80 	movl   $0x80108b43,-0x14(%ebp)
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
8010055b:	e8 84 4d 00 00       	call   801052e4 <release>
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
8010058b:	68 4a 8b 10 80       	push   $0x80108b4a
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
801005aa:	68 59 8b 10 80       	push   $0x80108b59
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 6f 4d 00 00       	call   80105336 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 5b 8b 10 80       	push   $0x80108b5b
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
801006db:	e8 bf 4e 00 00       	call   8010559f <memmove>
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
80100705:	e8 d6 4d 00 00       	call   801054e0 <memset>
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
8010079a:	e8 d9 68 00 00       	call   80107078 <uartputc>
8010079f:	83 c4 10             	add    $0x10,%esp
801007a2:	83 ec 0c             	sub    $0xc,%esp
801007a5:	6a 20                	push   $0x20
801007a7:	e8 cc 68 00 00       	call   80107078 <uartputc>
801007ac:	83 c4 10             	add    $0x10,%esp
801007af:	83 ec 0c             	sub    $0xc,%esp
801007b2:	6a 08                	push   $0x8
801007b4:	e8 bf 68 00 00       	call   80107078 <uartputc>
801007b9:	83 c4 10             	add    $0x10,%esp
801007bc:	eb 0e                	jmp    801007cc <consputc+0x56>
  } else
    uartputc(c);
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	ff 75 08             	pushl  0x8(%ebp)
801007c4:	e8 af 68 00 00       	call   80107078 <uartputc>
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
801007eb:	e8 8d 4a 00 00       	call   8010527d <acquire>
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
8010081e:	e8 8a 47 00 00       	call   80104fad <procdump>
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
80100931:	e8 b9 45 00 00       	call   80104eef <wakeup>
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
80100954:	e8 8b 49 00 00       	call   801052e4 <release>
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
80100981:	e8 f7 48 00 00       	call   8010527d <acquire>
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
801009a3:	e8 3c 49 00 00       	call   801052e4 <release>
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
801009d0:	e8 2c 44 00 00       	call   80104e01 <sleep>
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
80100a4e:	e8 91 48 00 00       	call   801052e4 <release>
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
80100a8c:	e8 ec 47 00 00       	call   8010527d <acquire>
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
80100ace:	e8 11 48 00 00       	call   801052e4 <release>
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
80100af2:	68 5f 8b 10 80       	push   $0x80108b5f
80100af7:	68 e0 c5 10 80       	push   $0x8010c5e0
80100afc:	e8 5a 47 00 00       	call   8010525b <initlock>
80100b01:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b04:	83 ec 08             	sub    $0x8,%esp
80100b07:	68 67 8b 10 80       	push   $0x80108b67
80100b0c:	68 a0 17 11 80       	push   $0x801117a0
80100b11:	e8 45 47 00 00       	call   8010525b <initlock>
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
80100bcf:	e8 f9 75 00 00       	call   801081cd <setupkvm>
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
80100c55:	e8 3f 7a 00 00       	call   80108699 <allocuvm>
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
80100c88:	e8 10 78 00 00       	call   8010849d <loaduvm>
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
80100cf7:	e8 9d 79 00 00       	call   80108699 <allocuvm>
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
80100d1b:	e8 9f 7b 00 00       	call   801088bf <clearpteu>
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
80100d54:	e8 d4 49 00 00       	call   8010572d <strlen>
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
80100d81:	e8 a7 49 00 00       	call   8010572d <strlen>
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
80100da7:	e8 ca 7c 00 00       	call   80108a76 <copyout>
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
80100e43:	e8 2e 7c 00 00       	call   80108a76 <copyout>
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
80100e94:	e8 4a 48 00 00       	call   801056e3 <safestrcpy>
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
80100eea:	e8 c5 73 00 00       	call   801082b4 <switchuvm>
80100eef:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
80100ef5:	ff 75 d0             	pushl  -0x30(%ebp)
80100ef8:	e8 22 79 00 00       	call   8010881f <freevm>
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
80100f32:	e8 e8 78 00 00       	call   8010881f <freevm>
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
80100f63:	68 6d 8b 10 80       	push   $0x80108b6d
80100f68:	68 60 18 11 80       	push   $0x80111860
80100f6d:	e8 e9 42 00 00       	call   8010525b <initlock>
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
80100f86:	e8 f2 42 00 00       	call   8010527d <acquire>
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
80100fb3:	e8 2c 43 00 00       	call   801052e4 <release>
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
80100fd6:	e8 09 43 00 00       	call   801052e4 <release>
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
80100ff3:	e8 85 42 00 00       	call   8010527d <acquire>
80100ff8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffe:	8b 40 04             	mov    0x4(%eax),%eax
80101001:	85 c0                	test   %eax,%eax
80101003:	7f 0d                	jg     80101012 <filedup+0x2d>
    panic("filedup");
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	68 74 8b 10 80       	push   $0x80108b74
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
80101029:	e8 b6 42 00 00       	call   801052e4 <release>
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
80101044:	e8 34 42 00 00       	call   8010527d <acquire>
80101049:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
8010104f:	8b 40 04             	mov    0x4(%eax),%eax
80101052:	85 c0                	test   %eax,%eax
80101054:	7f 0d                	jg     80101063 <fileclose+0x2d>
    panic("fileclose");
80101056:	83 ec 0c             	sub    $0xc,%esp
80101059:	68 7c 8b 10 80       	push   $0x80108b7c
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
80101084:	e8 5b 42 00 00       	call   801052e4 <release>
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
801010d2:	e8 0d 42 00 00       	call   801052e4 <release>
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
80101221:	68 86 8b 10 80       	push   $0x80108b86
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
80101324:	68 8f 8b 10 80       	push   $0x80108b8f
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
8010135a:	68 9f 8b 10 80       	push   $0x80108b9f
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
80101392:	e8 08 42 00 00       	call   8010559f <memmove>
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
801013d8:	e8 03 41 00 00       	call   801054e0 <memset>
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
80101551:	68 a9 8b 10 80       	push   $0x80108ba9
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
801015e7:	68 bf 8b 10 80       	push   $0x80108bbf
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
80101641:	68 d2 8b 10 80       	push   $0x80108bd2
80101646:	68 60 22 11 80       	push   $0x80112260
8010164b:	e8 0b 3c 00 00       	call   8010525b <initlock>
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
801016c6:	e8 15 3e 00 00       	call   801054e0 <memset>
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
8010172b:	68 d9 8b 10 80       	push   $0x80108bd9
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
801017cb:	e8 cf 3d 00 00       	call   8010559f <memmove>
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
80101800:	e8 78 3a 00 00       	call   8010527d <acquire>
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
8010184e:	e8 91 3a 00 00       	call   801052e4 <release>
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
80101887:	68 eb 8b 10 80       	push   $0x80108beb
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
801018c4:	e8 1b 3a 00 00       	call   801052e4 <release>
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
801018df:	e8 99 39 00 00       	call   8010527d <acquire>
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
801018fe:	e8 e1 39 00 00       	call   801052e4 <release>
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
80101924:	68 fb 8b 10 80       	push   $0x80108bfb
80101929:	e8 38 ec ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
8010192e:	83 ec 0c             	sub    $0xc,%esp
80101931:	68 60 22 11 80       	push   $0x80112260
80101936:	e8 42 39 00 00       	call   8010527d <acquire>
8010193b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010193e:	eb 13                	jmp    80101953 <ilock+0x48>
    sleep(ip, &icache.lock);
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	68 60 22 11 80       	push   $0x80112260
80101948:	ff 75 08             	pushl  0x8(%ebp)
8010194b:	e8 b1 34 00 00       	call   80104e01 <sleep>
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
80101979:	e8 66 39 00 00       	call   801052e4 <release>
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
80101a20:	e8 7a 3b 00 00       	call   8010559f <memmove>
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
80101a56:	68 01 8c 10 80       	push   $0x80108c01
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
80101a89:	68 10 8c 10 80       	push   $0x80108c10
80101a8e:	e8 d3 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a93:	83 ec 0c             	sub    $0xc,%esp
80101a96:	68 60 22 11 80       	push   $0x80112260
80101a9b:	e8 dd 37 00 00       	call   8010527d <acquire>
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
80101aba:	e8 30 34 00 00       	call   80104eef <wakeup>
80101abf:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ac2:	83 ec 0c             	sub    $0xc,%esp
80101ac5:	68 60 22 11 80       	push   $0x80112260
80101aca:	e8 15 38 00 00       	call   801052e4 <release>
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
80101ae3:	e8 95 37 00 00       	call   8010527d <acquire>
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
80101b2b:	68 18 8c 10 80       	push   $0x80108c18
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
80101b4e:	e8 91 37 00 00       	call   801052e4 <release>
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
80101b83:	e8 f5 36 00 00       	call   8010527d <acquire>
80101b88:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b95:	83 ec 0c             	sub    $0xc,%esp
80101b98:	ff 75 08             	pushl  0x8(%ebp)
80101b9b:	e8 4f 33 00 00       	call   80104eef <wakeup>
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
80101bba:	e8 25 37 00 00       	call   801052e4 <release>
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
80101cfa:	68 22 8c 10 80       	push   $0x80108c22
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
80101f91:	e8 09 36 00 00       	call   8010559f <memmove>
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
801020e3:	e8 b7 34 00 00       	call   8010559f <memmove>
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
80102163:	e8 cd 34 00 00       	call   80105635 <strncmp>
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
80102183:	68 35 8c 10 80       	push   $0x80108c35
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
801021b2:	68 47 8c 10 80       	push   $0x80108c47
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
80102287:	68 47 8c 10 80       	push   $0x80108c47
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
801022c2:	e8 c4 33 00 00       	call   8010568b <strncpy>
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
801022ee:	68 54 8c 10 80       	push   $0x80108c54
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
80102364:	e8 36 32 00 00       	call   8010559f <memmove>
80102369:	83 c4 10             	add    $0x10,%esp
8010236c:	eb 26                	jmp    80102394 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102371:	83 ec 04             	sub    $0x4,%esp
80102374:	50                   	push   %eax
80102375:	ff 75 f4             	pushl  -0xc(%ebp)
80102378:	ff 75 0c             	pushl  0xc(%ebp)
8010237b:	e8 1f 32 00 00       	call   8010559f <memmove>
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
801025d0:	68 5c 8c 10 80       	push   $0x80108c5c
801025d5:	68 20 c6 10 80       	push   $0x8010c620
801025da:	e8 7c 2c 00 00       	call   8010525b <initlock>
801025df:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801025e2:	83 ec 0c             	sub    $0xc,%esp
801025e5:	6a 0e                	push   $0xe
801025e7:	e8 8b 18 00 00       	call   80103e77 <picenable>
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
80102684:	68 60 8c 10 80       	push   $0x80108c60
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
801027a5:	e8 d3 2a 00 00       	call   8010527d <acquire>
801027aa:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027ad:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027b9:	75 15                	jne    801027d0 <ideintr+0x39>
    release(&idelock);
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	68 20 c6 10 80       	push   $0x8010c620
801027c3:	e8 1c 2b 00 00       	call   801052e4 <release>
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
80102838:	e8 b2 26 00 00       	call   80104eef <wakeup>
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
80102862:	e8 7d 2a 00 00       	call   801052e4 <release>
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
80102881:	68 69 8c 10 80       	push   $0x80108c69
80102886:	e8 db dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010288b:	8b 45 08             	mov    0x8(%ebp),%eax
8010288e:	8b 00                	mov    (%eax),%eax
80102890:	83 e0 06             	and    $0x6,%eax
80102893:	83 f8 02             	cmp    $0x2,%eax
80102896:	75 0d                	jne    801028a5 <iderw+0x39>
    panic("iderw: nothing to do");
80102898:	83 ec 0c             	sub    $0xc,%esp
8010289b:	68 7d 8c 10 80       	push   $0x80108c7d
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
801028bb:	68 92 8c 10 80       	push   $0x80108c92
801028c0:	e8 a1 dc ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028c5:	83 ec 0c             	sub    $0xc,%esp
801028c8:	68 20 c6 10 80       	push   $0x8010c620
801028cd:	e8 ab 29 00 00       	call   8010527d <acquire>
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
80102929:	e8 d3 24 00 00       	call   80104e01 <sleep>
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
80102946:	e8 99 29 00 00       	call   801052e4 <release>
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
801029d7:	68 b0 8c 10 80       	push   $0x80108cb0
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
80102a97:	68 e2 8c 10 80       	push   $0x80108ce2
80102a9c:	68 40 32 11 80       	push   $0x80113240
80102aa1:	e8 b5 27 00 00       	call   8010525b <initlock>
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
80102b3a:	81 7d 08 5c 64 11 80 	cmpl   $0x8011645c,0x8(%ebp)
80102b41:	72 12                	jb     80102b55 <kfree+0x2d>
80102b43:	ff 75 08             	pushl  0x8(%ebp)
80102b46:	e8 36 ff ff ff       	call   80102a81 <v2p>
80102b4b:	83 c4 04             	add    $0x4,%esp
80102b4e:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b53:	76 0d                	jbe    80102b62 <kfree+0x3a>
    panic("kfree");
80102b55:	83 ec 0c             	sub    $0xc,%esp
80102b58:	68 e7 8c 10 80       	push   $0x80108ce7
80102b5d:	e8 04 da ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b62:	83 ec 04             	sub    $0x4,%esp
80102b65:	68 00 10 00 00       	push   $0x1000
80102b6a:	6a 01                	push   $0x1
80102b6c:	ff 75 08             	pushl  0x8(%ebp)
80102b6f:	e8 6c 29 00 00       	call   801054e0 <memset>
80102b74:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b77:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	74 10                	je     80102b90 <kfree+0x68>
    acquire(&kmem.lock);
80102b80:	83 ec 0c             	sub    $0xc,%esp
80102b83:	68 40 32 11 80       	push   $0x80113240
80102b88:	e8 f0 26 00 00       	call   8010527d <acquire>
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
80102bba:	e8 25 27 00 00       	call   801052e4 <release>
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
80102bdc:	e8 9c 26 00 00       	call   8010527d <acquire>
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
80102c0d:	e8 d2 26 00 00       	call   801052e4 <release>
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
80102f58:	68 f0 8c 10 80       	push   $0x80108cf0
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
80103183:	e8 bf 23 00 00       	call   80105547 <memcmp>
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
80103297:	68 1c 8d 10 80       	push   $0x80108d1c
8010329c:	68 80 32 11 80       	push   $0x80113280
801032a1:	e8 b5 1f 00 00       	call   8010525b <initlock>
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
80103354:	e8 46 22 00 00       	call   8010559f <memmove>
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
801034c2:	e8 b6 1d 00 00       	call   8010527d <acquire>
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
801034e0:	e8 1c 19 00 00       	call   80104e01 <sleep>
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
80103515:	e8 e7 18 00 00       	call   80104e01 <sleep>
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
80103534:	e8 ab 1d 00 00       	call   801052e4 <release>
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
80103555:	e8 23 1d 00 00       	call   8010527d <acquire>
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
80103576:	68 20 8d 10 80       	push   $0x80108d20
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
801035a4:	e8 46 19 00 00       	call   80104eef <wakeup>
801035a9:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801035ac:	83 ec 0c             	sub    $0xc,%esp
801035af:	68 80 32 11 80       	push   $0x80113280
801035b4:	e8 2b 1d 00 00       	call   801052e4 <release>
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
801035cf:	e8 a9 1c 00 00       	call   8010527d <acquire>
801035d4:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801035d7:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
801035de:	00 00 00 
    wakeup(&log);
801035e1:	83 ec 0c             	sub    $0xc,%esp
801035e4:	68 80 32 11 80       	push   $0x80113280
801035e9:	e8 01 19 00 00       	call   80104eef <wakeup>
801035ee:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801035f1:	83 ec 0c             	sub    $0xc,%esp
801035f4:	68 80 32 11 80       	push   $0x80113280
801035f9:	e8 e6 1c 00 00       	call   801052e4 <release>
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
80103675:	e8 25 1f 00 00       	call   8010559f <memmove>
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
80103711:	68 2f 8d 10 80       	push   $0x80108d2f
80103716:	e8 4b ce ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010371b:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103720:	85 c0                	test   %eax,%eax
80103722:	7f 0d                	jg     80103731 <log_write+0x45>
    panic("log_write outside of trans");
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 45 8d 10 80       	push   $0x80108d45
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
801037ef:	68 5c 64 11 80       	push   $0x8011645c
801037f4:	e8 95 f2 ff ff       	call   80102a8e <kinit1>
801037f9:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801037fc:	e8 7e 4a 00 00       	call   8010827f <kvmalloc>
  mpinit();        // collect info about this machine
80103801:	e8 48 04 00 00       	call   80103c4e <mpinit>
  lapicinit();
80103806:	e8 02 f6 ff ff       	call   80102e0d <lapicinit>
  seginit();       // set up segments
8010380b:	e8 18 44 00 00       	call   80107c28 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103810:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103816:	0f b6 00             	movzbl (%eax),%eax
80103819:	0f b6 c0             	movzbl %al,%eax
8010381c:	83 ec 08             	sub    $0x8,%esp
8010381f:	50                   	push   %eax
80103820:	68 60 8d 10 80       	push   $0x80108d60
80103825:	e8 9c cb ff ff       	call   801003c6 <cprintf>
8010382a:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010382d:	e8 72 06 00 00       	call   80103ea4 <picinit>
  ioapicinit();    // another interrupt controller
80103832:	e8 4c f1 ff ff       	call   80102983 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103837:	e8 ad d2 ff ff       	call   80100ae9 <consoleinit>
  uartinit();      // serial port
8010383c:	e8 43 37 00 00       	call   80106f84 <uartinit>
  pinit();         // process table
80103841:	e8 5b 0b 00 00       	call   801043a1 <pinit>
  tvinit();        // trap vectors
80103846:	e8 22 32 00 00       	call   80106a6d <tvinit>
  binit();         // buffer cache
8010384b:	e8 e4 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103850:	e8 05 d7 ff ff       	call   80100f5a <fileinit>
  iinit();         // inode cache
80103855:	e8 de dd ff ff       	call   80101638 <iinit>
  ideinit();       // disk
8010385a:	e8 68 ed ff ff       	call   801025c7 <ideinit>
  if(!ismp)
8010385f:	a1 64 33 11 80       	mov    0x80113364,%eax
80103864:	85 c0                	test   %eax,%eax
80103866:	75 05                	jne    8010386d <main+0x97>
    timerinit();   // uniprocessor timer
80103868:	e8 5d 31 00 00       	call   801069ca <timerinit>
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
80103897:	e8 fb 49 00 00       	call   80108297 <switchkvm>
  seginit();
8010389c:	e8 87 43 00 00       	call   80107c28 <seginit>
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
801038c1:	68 77 8d 10 80       	push   $0x80108d77
801038c6:	e8 fb ca ff ff       	call   801003c6 <cprintf>
801038cb:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801038ce:	e8 10 33 00 00       	call   80106be3 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801038d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038d9:	05 a8 00 00 00       	add    $0xa8,%eax
801038de:	83 ec 08             	sub    $0x8,%esp
801038e1:	6a 01                	push   $0x1
801038e3:	50                   	push   %eax
801038e4:	e8 d3 fe ff ff       	call   801037bc <xchg>
801038e9:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801038ec:	e8 40 13 00 00       	call   80104c31 <scheduler>

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
80103911:	68 2c c5 10 80       	push   $0x8010c52c
80103916:	ff 75 f0             	pushl  -0x10(%ebp)
80103919:	e8 81 1c 00 00       	call   8010559f <memmove>
8010391e:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103921:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
80103928:	e9 90 00 00 00       	jmp    801039bd <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
8010392d:	e8 f9 f5 ff ff       	call   80102f2b <cpunum>
80103932:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103938:	05 80 33 11 80       	add    $0x80113380,%eax
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
80103970:	68 00 b0 10 80       	push   $0x8010b000
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
801039bd:	a1 60 39 11 80       	mov    0x80113960,%eax
801039c2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039c8:	05 80 33 11 80       	add    $0x80113380,%eax
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
80103a28:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103a2d:	89 c2                	mov    %eax,%edx
80103a2f:	b8 80 33 11 80       	mov    $0x80113380,%eax
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
80103aa7:	68 88 8d 10 80       	push   $0x80108d88
80103aac:	ff 75 f4             	pushl  -0xc(%ebp)
80103aaf:	e8 93 1a 00 00       	call   80105547 <memcmp>
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
80103be5:	68 8d 8d 10 80       	push   $0x80108d8d
80103bea:	ff 75 f0             	pushl  -0x10(%ebp)
80103bed:	e8 55 19 00 00       	call   80105547 <memcmp>
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
80103c54:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103c5b:	33 11 80 
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
80103c7a:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103c81:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c87:	8b 40 24             	mov    0x24(%eax),%eax
80103c8a:	a3 7c 32 11 80       	mov    %eax,0x8011327c
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
80103cc1:	8b 04 85 d0 8d 10 80 	mov    -0x7fef7230(,%eax,4),%eax
80103cc8:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ccd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103cd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cd3:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cd7:	0f b6 d0             	movzbl %al,%edx
80103cda:	a1 60 39 11 80       	mov    0x80113960,%eax
80103cdf:	39 c2                	cmp    %eax,%edx
80103ce1:	74 2b                	je     80103d0e <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103ce3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ce6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cea:	0f b6 d0             	movzbl %al,%edx
80103ced:	a1 60 39 11 80       	mov    0x80113960,%eax
80103cf2:	83 ec 04             	sub    $0x4,%esp
80103cf5:	52                   	push   %edx
80103cf6:	50                   	push   %eax
80103cf7:	68 92 8d 10 80       	push   $0x80108d92
80103cfc:	e8 c5 c6 ff ff       	call   801003c6 <cprintf>
80103d01:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103d04:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
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
80103d1f:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d24:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d2a:	05 80 33 11 80       	add    $0x80113380,%eax
80103d2f:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103d34:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d39:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103d3f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d45:	05 80 33 11 80       	add    $0x80113380,%eax
80103d4a:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103d4c:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d51:	83 c0 01             	add    $0x1,%eax
80103d54:	a3 60 39 11 80       	mov    %eax,0x80113960
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
80103d6c:	a2 60 33 11 80       	mov    %al,0x80113360
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
80103d8a:	68 b0 8d 10 80       	push   $0x80108db0
80103d8f:	e8 32 c6 ff ff       	call   801003c6 <cprintf>
80103d94:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103d97:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
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
80103dad:	a1 64 33 11 80       	mov    0x80113364,%eax
80103db2:	85 c0                	test   %eax,%eax
80103db4:	75 1d                	jne    80103dd3 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103db6:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103dbd:	00 00 00 
    lapic = 0;
80103dc0:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103dc7:	00 00 00 
    ioapicid = 0;
80103dca:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
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
80103e43:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
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
80103e8c:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
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
80103f6a:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f71:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f75:	74 13                	je     80103f8a <picinit+0xe6>
    picsetmask(irqmask);
80103f77:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
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
8010402b:	68 e4 8d 10 80       	push   $0x80108de4
80104030:	50                   	push   %eax
80104031:	e8 25 12 00 00       	call   8010525b <initlock>
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
801040ed:	e8 8b 11 00 00       	call   8010527d <acquire>
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
80104114:	e8 d6 0d 00 00       	call   80104eef <wakeup>
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
80104137:	e8 b3 0d 00 00       	call   80104eef <wakeup>
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
80104160:	e8 7f 11 00 00       	call   801052e4 <release>
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
8010417f:	e8 60 11 00 00       	call   801052e4 <release>
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
80104197:	e8 e1 10 00 00       	call   8010527d <acquire>
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
801041cc:	e8 13 11 00 00       	call   801052e4 <release>
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
801041ea:	e8 00 0d 00 00       	call   80104eef <wakeup>
801041ef:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801041f2:	8b 45 08             	mov    0x8(%ebp),%eax
801041f5:	8b 55 08             	mov    0x8(%ebp),%edx
801041f8:	81 c2 38 02 00 00    	add    $0x238,%edx
801041fe:	83 ec 08             	sub    $0x8,%esp
80104201:	50                   	push   %eax
80104202:	52                   	push   %edx
80104203:	e8 f9 0b 00 00       	call   80104e01 <sleep>
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
8010426c:	e8 7e 0c 00 00       	call   80104eef <wakeup>
80104271:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104274:	8b 45 08             	mov    0x8(%ebp),%eax
80104277:	83 ec 0c             	sub    $0xc,%esp
8010427a:	50                   	push   %eax
8010427b:	e8 64 10 00 00       	call   801052e4 <release>
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
80104296:	e8 e2 0f 00 00       	call   8010527d <acquire>
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
801042b4:	e8 2b 10 00 00       	call   801052e4 <release>
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
801042d7:	e8 25 0b 00 00       	call   80104e01 <sleep>
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
8010436b:	e8 7f 0b 00 00       	call   80104eef <wakeup>
80104370:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104373:	8b 45 08             	mov    0x8(%ebp),%eax
80104376:	83 ec 0c             	sub    $0xc,%esp
80104379:	50                   	push   %eax
8010437a:	e8 65 0f 00 00       	call   801052e4 <release>
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
801043aa:	68 e9 8d 10 80       	push   $0x80108de9
801043af:	68 80 39 11 80       	push   $0x80113980
801043b4:	e8 a2 0e 00 00       	call   8010525b <initlock>
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
801043c8:	68 80 39 11 80       	push   $0x80113980
801043cd:	e8 ab 0e 00 00       	call   8010527d <acquire>
801043d2:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d5:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
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
801043ef:	81 7d f4 b4 5b 11 80 	cmpl   $0x80115bb4,-0xc(%ebp)
801043f6:	72 e6                	jb     801043de <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	68 80 39 11 80       	push   $0x80113980
80104400:	e8 df 0e 00 00       	call   801052e4 <release>
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
8010441d:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104422:	8d 50 01             	lea    0x1(%eax),%edx
80104425:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010442b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010442e:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104431:	83 ec 0c             	sub    $0xc,%esp
80104434:	68 80 39 11 80       	push   $0x80113980
80104439:	e8 a6 0e 00 00       	call   801052e4 <release>
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
8010448b:	ba 27 6a 10 80       	mov    $0x80106a27,%edx
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
801044b0:	e8 2b 10 00 00       	call   801054e0 <memset>
801044b5:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801044b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044bb:	8b 40 1c             	mov    0x1c(%eax),%eax
801044be:	ba d0 4d 10 80       	mov    $0x80104dd0,%edx
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
80104500:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
80104505:	e8 c3 3c 00 00       	call   801081cd <setupkvm>
8010450a:	89 c2                	mov    %eax,%edx
8010450c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010450f:	89 50 04             	mov    %edx,0x4(%eax)
80104512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104515:	8b 40 04             	mov    0x4(%eax),%eax
80104518:	85 c0                	test   %eax,%eax
8010451a:	75 0d                	jne    80104529 <userinit+0x3a>
    panic("userinit: out of memory?");
8010451c:	83 ec 0c             	sub    $0xc,%esp
8010451f:	68 f0 8d 10 80       	push   $0x80108df0
80104524:	e8 3d c0 ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104529:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010452e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104531:	8b 40 04             	mov    0x4(%eax),%eax
80104534:	83 ec 04             	sub    $0x4,%esp
80104537:	52                   	push   %edx
80104538:	68 00 c5 10 80       	push   $0x8010c500
8010453d:	50                   	push   %eax
8010453e:	e8 e4 3e 00 00       	call   80108427 <inituvm>
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
8010455d:	e8 7e 0f 00 00       	call   801054e0 <memset>
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
801045d7:	68 09 8e 10 80       	push   $0x80108e09
801045dc:	50                   	push   %eax
801045dd:	e8 01 11 00 00       	call   801056e3 <safestrcpy>
801045e2:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801045e5:	83 ec 0c             	sub    $0xc,%esp
801045e8:	68 12 8e 10 80       	push   $0x80108e12
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
8010463a:	e8 5a 40 00 00       	call   80108699 <allocuvm>
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
80104671:	e8 ec 40 00 00       	call   80108762 <deallocuvm>
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
8010469e:	e8 11 3c 00 00       	call   801082b4 <switchuvm>
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
801046e4:	e8 17 42 00 00       	call   80108900 <copyuvm>
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
801047f8:	e8 e6 0e 00 00       	call   801056e3 <safestrcpy>
801047fd:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104800:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104803:	8b 40 10             	mov    0x10(%eax),%eax
80104806:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104809:	83 ec 0c             	sub    $0xc,%esp
8010480c:	68 80 39 11 80       	push   $0x80113980
80104811:	e8 67 0a 00 00       	call   8010527d <acquire>
80104816:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104819:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010481c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104823:	83 ec 0c             	sub    $0xc,%esp
80104826:	68 80 39 11 80       	push   $0x80113980
8010482b:	e8 b4 0a 00 00       	call   801052e4 <release>
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

8010483e <cowfork>:

int cowfork(void) {
8010483e:	55                   	push   %ebp
8010483f:	89 e5                	mov    %esp,%ebp
80104841:	57                   	push   %edi
80104842:	56                   	push   %esi
80104843:	53                   	push   %ebx
80104844:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104847:	e8 73 fb ff ff       	call   801043bf <allocproc>
8010484c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010484f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104853:	75 0a                	jne    8010485f <cowfork+0x21>
    return -1;
80104855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010485a:	e9 68 01 00 00       	jmp    801049c7 <cowfork+0x189>

  // Copy process state from p.
  //look into this for cowfork
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
8010485f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104865:	8b 10                	mov    (%eax),%edx
80104867:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010486d:	8b 40 04             	mov    0x4(%eax),%eax
80104870:	83 ec 08             	sub    $0x8,%esp
80104873:	52                   	push   %edx
80104874:	50                   	push   %eax
80104875:	e8 86 40 00 00       	call   80108900 <copyuvm>
8010487a:	83 c4 10             	add    $0x10,%esp
8010487d:	89 c2                	mov    %eax,%edx
8010487f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104882:	89 50 04             	mov    %edx,0x4(%eax)
80104885:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104888:	8b 40 04             	mov    0x4(%eax),%eax
8010488b:	85 c0                	test   %eax,%eax
8010488d:	75 30                	jne    801048bf <cowfork+0x81>
    kfree(np->kstack);
8010488f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104892:	8b 40 08             	mov    0x8(%eax),%eax
80104895:	83 ec 0c             	sub    $0xc,%esp
80104898:	50                   	push   %eax
80104899:	e8 8a e2 ff ff       	call   80102b28 <kfree>
8010489e:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801048a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801048ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048ae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801048b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048ba:	e9 08 01 00 00       	jmp    801049c7 <cowfork+0x189>
  }
  np->sz = proc->sz;
801048bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c5:	8b 10                	mov    (%eax),%edx
801048c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048ca:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801048cc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048d6:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801048d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048dc:	8b 50 18             	mov    0x18(%eax),%edx
801048df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e5:	8b 40 18             	mov    0x18(%eax),%eax
801048e8:	89 c3                	mov    %eax,%ebx
801048ea:	b8 13 00 00 00       	mov    $0x13,%eax
801048ef:	89 d7                	mov    %edx,%edi
801048f1:	89 de                	mov    %ebx,%esi
801048f3:	89 c1                	mov    %eax,%ecx
801048f5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801048f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048fa:	8b 40 18             	mov    0x18(%eax),%eax
801048fd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104904:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010490b:	eb 43                	jmp    80104950 <cowfork+0x112>
    if(proc->ofile[i])
8010490d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104913:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104916:	83 c2 08             	add    $0x8,%edx
80104919:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010491d:	85 c0                	test   %eax,%eax
8010491f:	74 2b                	je     8010494c <cowfork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
80104921:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104927:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010492a:	83 c2 08             	add    $0x8,%edx
8010492d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104931:	83 ec 0c             	sub    $0xc,%esp
80104934:	50                   	push   %eax
80104935:	e8 ab c6 ff ff       	call   80100fe5 <filedup>
8010493a:	83 c4 10             	add    $0x10,%esp
8010493d:	89 c1                	mov    %eax,%ecx
8010493f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104942:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104945:	83 c2 08             	add    $0x8,%edx
80104948:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010494c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104950:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104954:	7e b7                	jle    8010490d <cowfork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104956:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010495c:	8b 40 68             	mov    0x68(%eax),%eax
8010495f:	83 ec 0c             	sub    $0xc,%esp
80104962:	50                   	push   %eax
80104963:	e8 69 cf ff ff       	call   801018d1 <idup>
80104968:	83 c4 10             	add    $0x10,%esp
8010496b:	89 c2                	mov    %eax,%edx
8010496d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104970:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104973:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104979:	8d 50 6c             	lea    0x6c(%eax),%edx
8010497c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010497f:	83 c0 6c             	add    $0x6c,%eax
80104982:	83 ec 04             	sub    $0x4,%esp
80104985:	6a 10                	push   $0x10
80104987:	52                   	push   %edx
80104988:	50                   	push   %eax
80104989:	e8 55 0d 00 00       	call   801056e3 <safestrcpy>
8010498e:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104991:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104994:	8b 40 10             	mov    0x10(%eax),%eax
80104997:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010499a:	83 ec 0c             	sub    $0xc,%esp
8010499d:	68 80 39 11 80       	push   $0x80113980
801049a2:	e8 d6 08 00 00       	call   8010527d <acquire>
801049a7:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801049aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801049b4:	83 ec 0c             	sub    $0xc,%esp
801049b7:	68 80 39 11 80       	push   $0x80113980
801049bc:	e8 23 09 00 00       	call   801052e4 <release>
801049c1:	83 c4 10             	add    $0x10,%esp

  return pid;
801049c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801049c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049ca:	5b                   	pop    %ebx
801049cb:	5e                   	pop    %esi
801049cc:	5f                   	pop    %edi
801049cd:	5d                   	pop    %ebp
801049ce:	c3                   	ret    

801049cf <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801049cf:	55                   	push   %ebp
801049d0:	89 e5                	mov    %esp,%ebp
801049d2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801049d5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049dc:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801049e1:	39 c2                	cmp    %eax,%edx
801049e3:	75 0d                	jne    801049f2 <exit+0x23>
    panic("init exiting");
801049e5:	83 ec 0c             	sub    $0xc,%esp
801049e8:	68 14 8e 10 80       	push   $0x80108e14
801049ed:	e8 74 bb ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801049f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801049f9:	eb 48                	jmp    80104a43 <exit+0x74>
    if(proc->ofile[fd]){
801049fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a01:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a04:	83 c2 08             	add    $0x8,%edx
80104a07:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a0b:	85 c0                	test   %eax,%eax
80104a0d:	74 30                	je     80104a3f <exit+0x70>
      fileclose(proc->ofile[fd]);
80104a0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a15:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a18:	83 c2 08             	add    $0x8,%edx
80104a1b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a1f:	83 ec 0c             	sub    $0xc,%esp
80104a22:	50                   	push   %eax
80104a23:	e8 0e c6 ff ff       	call   80101036 <fileclose>
80104a28:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104a2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a31:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a34:	83 c2 08             	add    $0x8,%edx
80104a37:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a3e:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a3f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a43:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104a47:	7e b2                	jle    801049fb <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104a49:	e8 66 ea ff ff       	call   801034b4 <begin_op>
  iput(proc->cwd);
80104a4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a54:	8b 40 68             	mov    0x68(%eax),%eax
80104a57:	83 ec 0c             	sub    $0xc,%esp
80104a5a:	50                   	push   %eax
80104a5b:	e8 75 d0 ff ff       	call   80101ad5 <iput>
80104a60:	83 c4 10             	add    $0x10,%esp
  end_op();
80104a63:	e8 d8 ea ff ff       	call   80103540 <end_op>
  proc->cwd = 0;
80104a68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a6e:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104a75:	83 ec 0c             	sub    $0xc,%esp
80104a78:	68 80 39 11 80       	push   $0x80113980
80104a7d:	e8 fb 07 00 00       	call   8010527d <acquire>
80104a82:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104a85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8b:	8b 40 14             	mov    0x14(%eax),%eax
80104a8e:	83 ec 0c             	sub    $0xc,%esp
80104a91:	50                   	push   %eax
80104a92:	e8 16 04 00 00       	call   80104ead <wakeup1>
80104a97:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a9a:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104aa1:	eb 3f                	jmp    80104ae2 <exit+0x113>
    if(p->parent == proc){
80104aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa6:	8b 50 14             	mov    0x14(%eax),%edx
80104aa9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aaf:	39 c2                	cmp    %eax,%edx
80104ab1:	75 28                	jne    80104adb <exit+0x10c>
      p->parent = initproc;
80104ab3:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104abc:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac2:	8b 40 0c             	mov    0xc(%eax),%eax
80104ac5:	83 f8 05             	cmp    $0x5,%eax
80104ac8:	75 11                	jne    80104adb <exit+0x10c>
        wakeup1(initproc);
80104aca:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104acf:	83 ec 0c             	sub    $0xc,%esp
80104ad2:	50                   	push   %eax
80104ad3:	e8 d5 03 00 00       	call   80104ead <wakeup1>
80104ad8:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104adb:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104ae2:	81 7d f4 b4 5b 11 80 	cmpl   $0x80115bb4,-0xc(%ebp)
80104ae9:	72 b8                	jb     80104aa3 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104aeb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af1:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104af8:	e8 dc 01 00 00       	call   80104cd9 <sched>
  panic("zombie exit");
80104afd:	83 ec 0c             	sub    $0xc,%esp
80104b00:	68 21 8e 10 80       	push   $0x80108e21
80104b05:	e8 5c ba ff ff       	call   80100566 <panic>

80104b0a <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104b0a:	55                   	push   %ebp
80104b0b:	89 e5                	mov    %esp,%ebp
80104b0d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104b10:	83 ec 0c             	sub    $0xc,%esp
80104b13:	68 80 39 11 80       	push   $0x80113980
80104b18:	e8 60 07 00 00       	call   8010527d <acquire>
80104b1d:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b20:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b27:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104b2e:	e9 a9 00 00 00       	jmp    80104bdc <wait+0xd2>
      if(p->parent != proc)
80104b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b36:	8b 50 14             	mov    0x14(%eax),%edx
80104b39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b3f:	39 c2                	cmp    %eax,%edx
80104b41:	0f 85 8d 00 00 00    	jne    80104bd4 <wait+0xca>
        continue;
      havekids = 1;
80104b47:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b51:	8b 40 0c             	mov    0xc(%eax),%eax
80104b54:	83 f8 05             	cmp    $0x5,%eax
80104b57:	75 7c                	jne    80104bd5 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b5c:	8b 40 10             	mov    0x10(%eax),%eax
80104b5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b65:	8b 40 08             	mov    0x8(%eax),%eax
80104b68:	83 ec 0c             	sub    $0xc,%esp
80104b6b:	50                   	push   %eax
80104b6c:	e8 b7 df ff ff       	call   80102b28 <kfree>
80104b71:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b81:	8b 40 04             	mov    0x4(%eax),%eax
80104b84:	83 ec 0c             	sub    $0xc,%esp
80104b87:	50                   	push   %eax
80104b88:	e8 92 3c 00 00       	call   8010881f <freevm>
80104b8d:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b93:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b9d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb1:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb8:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104bbf:	83 ec 0c             	sub    $0xc,%esp
80104bc2:	68 80 39 11 80       	push   $0x80113980
80104bc7:	e8 18 07 00 00       	call   801052e4 <release>
80104bcc:	83 c4 10             	add    $0x10,%esp
        return pid;
80104bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bd2:	eb 5b                	jmp    80104c2f <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104bd4:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bd5:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104bdc:	81 7d f4 b4 5b 11 80 	cmpl   $0x80115bb4,-0xc(%ebp)
80104be3:	0f 82 4a ff ff ff    	jb     80104b33 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104be9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104bed:	74 0d                	je     80104bfc <wait+0xf2>
80104bef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bf5:	8b 40 24             	mov    0x24(%eax),%eax
80104bf8:	85 c0                	test   %eax,%eax
80104bfa:	74 17                	je     80104c13 <wait+0x109>
      release(&ptable.lock);
80104bfc:	83 ec 0c             	sub    $0xc,%esp
80104bff:	68 80 39 11 80       	push   $0x80113980
80104c04:	e8 db 06 00 00       	call   801052e4 <release>
80104c09:	83 c4 10             	add    $0x10,%esp
      return -1;
80104c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c11:	eb 1c                	jmp    80104c2f <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c19:	83 ec 08             	sub    $0x8,%esp
80104c1c:	68 80 39 11 80       	push   $0x80113980
80104c21:	50                   	push   %eax
80104c22:	e8 da 01 00 00       	call   80104e01 <sleep>
80104c27:	83 c4 10             	add    $0x10,%esp
  }
80104c2a:	e9 f1 fe ff ff       	jmp    80104b20 <wait+0x16>
}
80104c2f:	c9                   	leave  
80104c30:	c3                   	ret    

80104c31 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104c31:	55                   	push   %ebp
80104c32:	89 e5                	mov    %esp,%ebp
80104c34:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104c37:	e8 5e f7 ff ff       	call   8010439a <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104c3c:	83 ec 0c             	sub    $0xc,%esp
80104c3f:	68 80 39 11 80       	push   $0x80113980
80104c44:	e8 34 06 00 00       	call   8010527d <acquire>
80104c49:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c4c:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104c53:	eb 66                	jmp    80104cbb <scheduler+0x8a>
      if(p->state != RUNNABLE)
80104c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c58:	8b 40 0c             	mov    0xc(%eax),%eax
80104c5b:	83 f8 03             	cmp    $0x3,%eax
80104c5e:	75 53                	jne    80104cb3 <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c63:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104c69:	83 ec 0c             	sub    $0xc,%esp
80104c6c:	ff 75 f4             	pushl  -0xc(%ebp)
80104c6f:	e8 40 36 00 00       	call   801082b4 <switchuvm>
80104c74:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c7a:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104c81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c87:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c8a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c91:	83 c2 04             	add    $0x4,%edx
80104c94:	83 ec 08             	sub    $0x8,%esp
80104c97:	50                   	push   %eax
80104c98:	52                   	push   %edx
80104c99:	e8 b6 0a 00 00       	call   80105754 <swtch>
80104c9e:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104ca1:	e8 f1 35 00 00       	call   80108297 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104ca6:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104cad:	00 00 00 00 
80104cb1:	eb 01                	jmp    80104cb4 <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104cb3:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cb4:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104cbb:	81 7d f4 b4 5b 11 80 	cmpl   $0x80115bb4,-0xc(%ebp)
80104cc2:	72 91                	jb     80104c55 <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104cc4:	83 ec 0c             	sub    $0xc,%esp
80104cc7:	68 80 39 11 80       	push   $0x80113980
80104ccc:	e8 13 06 00 00       	call   801052e4 <release>
80104cd1:	83 c4 10             	add    $0x10,%esp

  }
80104cd4:	e9 5e ff ff ff       	jmp    80104c37 <scheduler+0x6>

80104cd9 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104cd9:	55                   	push   %ebp
80104cda:	89 e5                	mov    %esp,%ebp
80104cdc:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104cdf:	83 ec 0c             	sub    $0xc,%esp
80104ce2:	68 80 39 11 80       	push   $0x80113980
80104ce7:	e8 c4 06 00 00       	call   801053b0 <holding>
80104cec:	83 c4 10             	add    $0x10,%esp
80104cef:	85 c0                	test   %eax,%eax
80104cf1:	75 0d                	jne    80104d00 <sched+0x27>
    panic("sched ptable.lock");
80104cf3:	83 ec 0c             	sub    $0xc,%esp
80104cf6:	68 2d 8e 10 80       	push   $0x80108e2d
80104cfb:	e8 66 b8 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104d00:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d06:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d0c:	83 f8 01             	cmp    $0x1,%eax
80104d0f:	74 0d                	je     80104d1e <sched+0x45>
    panic("sched locks");
80104d11:	83 ec 0c             	sub    $0xc,%esp
80104d14:	68 3f 8e 10 80       	push   $0x80108e3f
80104d19:	e8 48 b8 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104d1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d24:	8b 40 0c             	mov    0xc(%eax),%eax
80104d27:	83 f8 04             	cmp    $0x4,%eax
80104d2a:	75 0d                	jne    80104d39 <sched+0x60>
    panic("sched running");
80104d2c:	83 ec 0c             	sub    $0xc,%esp
80104d2f:	68 4b 8e 10 80       	push   $0x80108e4b
80104d34:	e8 2d b8 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104d39:	e8 4c f6 ff ff       	call   8010438a <readeflags>
80104d3e:	25 00 02 00 00       	and    $0x200,%eax
80104d43:	85 c0                	test   %eax,%eax
80104d45:	74 0d                	je     80104d54 <sched+0x7b>
    panic("sched interruptible");
80104d47:	83 ec 0c             	sub    $0xc,%esp
80104d4a:	68 59 8e 10 80       	push   $0x80108e59
80104d4f:	e8 12 b8 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104d54:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d5a:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104d63:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d69:	8b 40 04             	mov    0x4(%eax),%eax
80104d6c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d73:	83 c2 1c             	add    $0x1c,%edx
80104d76:	83 ec 08             	sub    $0x8,%esp
80104d79:	50                   	push   %eax
80104d7a:	52                   	push   %edx
80104d7b:	e8 d4 09 00 00       	call   80105754 <swtch>
80104d80:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104d83:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d8c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104d92:	90                   	nop
80104d93:	c9                   	leave  
80104d94:	c3                   	ret    

80104d95 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104d95:	55                   	push   %ebp
80104d96:	89 e5                	mov    %esp,%ebp
80104d98:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104d9b:	83 ec 0c             	sub    $0xc,%esp
80104d9e:	68 80 39 11 80       	push   $0x80113980
80104da3:	e8 d5 04 00 00       	call   8010527d <acquire>
80104da8:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104dab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104db1:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104db8:	e8 1c ff ff ff       	call   80104cd9 <sched>
  release(&ptable.lock);
80104dbd:	83 ec 0c             	sub    $0xc,%esp
80104dc0:	68 80 39 11 80       	push   $0x80113980
80104dc5:	e8 1a 05 00 00       	call   801052e4 <release>
80104dca:	83 c4 10             	add    $0x10,%esp
}
80104dcd:	90                   	nop
80104dce:	c9                   	leave  
80104dcf:	c3                   	ret    

80104dd0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104dd6:	83 ec 0c             	sub    $0xc,%esp
80104dd9:	68 80 39 11 80       	push   $0x80113980
80104dde:	e8 01 05 00 00       	call   801052e4 <release>
80104de3:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104de6:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104deb:	85 c0                	test   %eax,%eax
80104ded:	74 0f                	je     80104dfe <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104def:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104df6:	00 00 00 
    initlog();
80104df9:	e8 90 e4 ff ff       	call   8010328e <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104dfe:	90                   	nop
80104dff:	c9                   	leave  
80104e00:	c3                   	ret    

80104e01 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e01:	55                   	push   %ebp
80104e02:	89 e5                	mov    %esp,%ebp
80104e04:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104e07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e0d:	85 c0                	test   %eax,%eax
80104e0f:	75 0d                	jne    80104e1e <sleep+0x1d>
    panic("sleep");
80104e11:	83 ec 0c             	sub    $0xc,%esp
80104e14:	68 6d 8e 10 80       	push   $0x80108e6d
80104e19:	e8 48 b7 ff ff       	call   80100566 <panic>

  if(lk == 0)
80104e1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e22:	75 0d                	jne    80104e31 <sleep+0x30>
    panic("sleep without lk");
80104e24:	83 ec 0c             	sub    $0xc,%esp
80104e27:	68 73 8e 10 80       	push   $0x80108e73
80104e2c:	e8 35 b7 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104e31:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104e38:	74 1e                	je     80104e58 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104e3a:	83 ec 0c             	sub    $0xc,%esp
80104e3d:	68 80 39 11 80       	push   $0x80113980
80104e42:	e8 36 04 00 00       	call   8010527d <acquire>
80104e47:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104e4a:	83 ec 0c             	sub    $0xc,%esp
80104e4d:	ff 75 0c             	pushl  0xc(%ebp)
80104e50:	e8 8f 04 00 00       	call   801052e4 <release>
80104e55:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104e58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e5e:	8b 55 08             	mov    0x8(%ebp),%edx
80104e61:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104e64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e6a:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104e71:	e8 63 fe ff ff       	call   80104cd9 <sched>

  // Tidy up.
  proc->chan = 0;
80104e76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e7c:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104e83:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104e8a:	74 1e                	je     80104eaa <sleep+0xa9>
    release(&ptable.lock);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	68 80 39 11 80       	push   $0x80113980
80104e94:	e8 4b 04 00 00       	call   801052e4 <release>
80104e99:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104e9c:	83 ec 0c             	sub    $0xc,%esp
80104e9f:	ff 75 0c             	pushl  0xc(%ebp)
80104ea2:	e8 d6 03 00 00       	call   8010527d <acquire>
80104ea7:	83 c4 10             	add    $0x10,%esp
  }
}
80104eaa:	90                   	nop
80104eab:	c9                   	leave  
80104eac:	c3                   	ret    

80104ead <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104ead:	55                   	push   %ebp
80104eae:	89 e5                	mov    %esp,%ebp
80104eb0:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104eb3:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104eba:	eb 27                	jmp    80104ee3 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ebf:	8b 40 0c             	mov    0xc(%eax),%eax
80104ec2:	83 f8 02             	cmp    $0x2,%eax
80104ec5:	75 15                	jne    80104edc <wakeup1+0x2f>
80104ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104eca:	8b 40 20             	mov    0x20(%eax),%eax
80104ecd:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ed0:	75 0a                	jne    80104edc <wakeup1+0x2f>
      p->state = RUNNABLE;
80104ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ed5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104edc:	81 45 fc 88 00 00 00 	addl   $0x88,-0x4(%ebp)
80104ee3:	81 7d fc b4 5b 11 80 	cmpl   $0x80115bb4,-0x4(%ebp)
80104eea:	72 d0                	jb     80104ebc <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104eec:	90                   	nop
80104eed:	c9                   	leave  
80104eee:	c3                   	ret    

80104eef <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104eef:	55                   	push   %ebp
80104ef0:	89 e5                	mov    %esp,%ebp
80104ef2:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104ef5:	83 ec 0c             	sub    $0xc,%esp
80104ef8:	68 80 39 11 80       	push   $0x80113980
80104efd:	e8 7b 03 00 00       	call   8010527d <acquire>
80104f02:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104f05:	83 ec 0c             	sub    $0xc,%esp
80104f08:	ff 75 08             	pushl  0x8(%ebp)
80104f0b:	e8 9d ff ff ff       	call   80104ead <wakeup1>
80104f10:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104f13:	83 ec 0c             	sub    $0xc,%esp
80104f16:	68 80 39 11 80       	push   $0x80113980
80104f1b:	e8 c4 03 00 00       	call   801052e4 <release>
80104f20:	83 c4 10             	add    $0x10,%esp
}
80104f23:	90                   	nop
80104f24:	c9                   	leave  
80104f25:	c3                   	ret    

80104f26 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104f26:	55                   	push   %ebp
80104f27:	89 e5                	mov    %esp,%ebp
80104f29:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104f2c:	83 ec 0c             	sub    $0xc,%esp
80104f2f:	68 80 39 11 80       	push   $0x80113980
80104f34:	e8 44 03 00 00       	call   8010527d <acquire>
80104f39:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f3c:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104f43:	eb 48                	jmp    80104f8d <kill+0x67>
    if(p->pid == pid){
80104f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f48:	8b 40 10             	mov    0x10(%eax),%eax
80104f4b:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f4e:	75 36                	jne    80104f86 <kill+0x60>
      p->killed = 1;
80104f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f53:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f5d:	8b 40 0c             	mov    0xc(%eax),%eax
80104f60:	83 f8 02             	cmp    $0x2,%eax
80104f63:	75 0a                	jne    80104f6f <kill+0x49>
        p->state = RUNNABLE;
80104f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f68:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104f6f:	83 ec 0c             	sub    $0xc,%esp
80104f72:	68 80 39 11 80       	push   $0x80113980
80104f77:	e8 68 03 00 00       	call   801052e4 <release>
80104f7c:	83 c4 10             	add    $0x10,%esp
      return 0;
80104f7f:	b8 00 00 00 00       	mov    $0x0,%eax
80104f84:	eb 25                	jmp    80104fab <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f86:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104f8d:	81 7d f4 b4 5b 11 80 	cmpl   $0x80115bb4,-0xc(%ebp)
80104f94:	72 af                	jb     80104f45 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104f96:	83 ec 0c             	sub    $0xc,%esp
80104f99:	68 80 39 11 80       	push   $0x80113980
80104f9e:	e8 41 03 00 00       	call   801052e4 <release>
80104fa3:	83 c4 10             	add    $0x10,%esp
  return -1;
80104fa6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fab:	c9                   	leave  
80104fac:	c3                   	ret    

80104fad <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104fad:	55                   	push   %ebp
80104fae:	89 e5                	mov    %esp,%ebp
80104fb0:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fb3:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80104fba:	e9 da 00 00 00       	jmp    80105099 <procdump+0xec>
    if(p->state == UNUSED)
80104fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fc2:	8b 40 0c             	mov    0xc(%eax),%eax
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	0f 84 c4 00 00 00    	je     80105091 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fd0:	8b 40 0c             	mov    0xc(%eax),%eax
80104fd3:	83 f8 05             	cmp    $0x5,%eax
80104fd6:	77 23                	ja     80104ffb <procdump+0x4e>
80104fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fdb:	8b 40 0c             	mov    0xc(%eax),%eax
80104fde:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104fe5:	85 c0                	test   %eax,%eax
80104fe7:	74 12                	je     80104ffb <procdump+0x4e>
      state = states[p->state];
80104fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fec:	8b 40 0c             	mov    0xc(%eax),%eax
80104fef:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104ff6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104ff9:	eb 07                	jmp    80105002 <procdump+0x55>
    else
      state = "???";
80104ffb:	c7 45 ec 84 8e 10 80 	movl   $0x80108e84,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105002:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105005:	8d 50 6c             	lea    0x6c(%eax),%edx
80105008:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010500b:	8b 40 10             	mov    0x10(%eax),%eax
8010500e:	52                   	push   %edx
8010500f:	ff 75 ec             	pushl  -0x14(%ebp)
80105012:	50                   	push   %eax
80105013:	68 88 8e 10 80       	push   $0x80108e88
80105018:	e8 a9 b3 ff ff       	call   801003c6 <cprintf>
8010501d:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105020:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105023:	8b 40 0c             	mov    0xc(%eax),%eax
80105026:	83 f8 02             	cmp    $0x2,%eax
80105029:	75 54                	jne    8010507f <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010502b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010502e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105031:	8b 40 0c             	mov    0xc(%eax),%eax
80105034:	83 c0 08             	add    $0x8,%eax
80105037:	89 c2                	mov    %eax,%edx
80105039:	83 ec 08             	sub    $0x8,%esp
8010503c:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010503f:	50                   	push   %eax
80105040:	52                   	push   %edx
80105041:	e8 f0 02 00 00       	call   80105336 <getcallerpcs>
80105046:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105049:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105050:	eb 1c                	jmp    8010506e <procdump+0xc1>
        cprintf(" %p", pc[i]);
80105052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105055:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105059:	83 ec 08             	sub    $0x8,%esp
8010505c:	50                   	push   %eax
8010505d:	68 91 8e 10 80       	push   $0x80108e91
80105062:	e8 5f b3 ff ff       	call   801003c6 <cprintf>
80105067:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010506a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010506e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105072:	7f 0b                	jg     8010507f <procdump+0xd2>
80105074:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105077:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010507b:	85 c0                	test   %eax,%eax
8010507d:	75 d3                	jne    80105052 <procdump+0xa5>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
8010507f:	83 ec 0c             	sub    $0xc,%esp
80105082:	68 95 8e 10 80       	push   $0x80108e95
80105087:	e8 3a b3 ff ff       	call   801003c6 <cprintf>
8010508c:	83 c4 10             	add    $0x10,%esp
8010508f:	eb 01                	jmp    80105092 <procdump+0xe5>
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105091:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105092:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
80105099:	81 7d f0 b4 5b 11 80 	cmpl   $0x80115bb4,-0x10(%ebp)
801050a0:	0f 82 19 ff ff ff    	jb     80104fbf <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801050a6:	90                   	nop
801050a7:	c9                   	leave  
801050a8:	c3                   	ret    

801050a9 <signal_deliver>:

void signal_deliver(int signum,siginfo_t si)
{
801050a9:	55                   	push   %ebp
801050aa:	89 e5                	mov    %esp,%ebp
801050ac:	83 ec 18             	sub    $0x18,%esp
  //signal broken? --look here and  restorer
	uint old_eip = proc->tf->eip;
801050af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050b5:	8b 40 18             	mov    0x18(%eax),%eax
801050b8:	8b 40 38             	mov    0x38(%eax),%eax
801050bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*((uint*)(proc->tf->esp - 4))  = (uint) old_eip;		// real return address
801050be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050c4:	8b 40 18             	mov    0x18(%eax),%eax
801050c7:	8b 40 44             	mov    0x44(%eax),%eax
801050ca:	83 e8 04             	sub    $0x4,%eax
801050cd:	89 c2                	mov    %eax,%edx
801050cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050d2:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 8))  = proc->tf->eax;			// eax
801050d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050da:	8b 40 18             	mov    0x18(%eax),%eax
801050dd:	8b 40 44             	mov    0x44(%eax),%eax
801050e0:	83 e8 08             	sub    $0x8,%eax
801050e3:	89 c2                	mov    %eax,%edx
801050e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050eb:	8b 40 18             	mov    0x18(%eax),%eax
801050ee:	8b 40 1c             	mov    0x1c(%eax),%eax
801050f1:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 12)) = proc->tf->ecx;			// ecx
801050f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050f9:	8b 40 18             	mov    0x18(%eax),%eax
801050fc:	8b 40 44             	mov    0x44(%eax),%eax
801050ff:	83 e8 0c             	sub    $0xc,%eax
80105102:	89 c2                	mov    %eax,%edx
80105104:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010510a:	8b 40 18             	mov    0x18(%eax),%eax
8010510d:	8b 40 18             	mov    0x18(%eax),%eax
80105110:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 16)) = proc->tf->edx;			// edx
80105112:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105118:	8b 40 18             	mov    0x18(%eax),%eax
8010511b:	8b 40 44             	mov    0x44(%eax),%eax
8010511e:	83 e8 10             	sub    $0x10,%eax
80105121:	89 c2                	mov    %eax,%edx
80105123:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105129:	8b 40 18             	mov    0x18(%eax),%eax
8010512c:	8b 40 14             	mov    0x14(%eax),%eax
8010512f:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 20)) = si.type;       //address mem fault occured
80105131:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105137:	8b 40 18             	mov    0x18(%eax),%eax
8010513a:	8b 40 44             	mov    0x44(%eax),%eax
8010513d:	83 e8 14             	sub    $0x14,%eax
80105140:	89 c2                	mov    %eax,%edx
80105142:	8b 45 10             	mov    0x10(%ebp),%eax
80105145:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 24)) = si.addr;       //address mem fault occured
80105147:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010514d:	8b 40 18             	mov    0x18(%eax),%eax
80105150:	8b 40 44             	mov    0x44(%eax),%eax
80105153:	83 e8 18             	sub    $0x18,%eax
80105156:	89 c2                	mov    %eax,%edx
80105158:	8b 45 0c             	mov    0xc(%ebp),%eax
8010515b:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 28)) = (uint) signum;			// signal number
8010515d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105163:	8b 40 18             	mov    0x18(%eax),%eax
80105166:	8b 40 44             	mov    0x44(%eax),%eax
80105169:	83 e8 1c             	sub    $0x1c,%eax
8010516c:	89 c2                	mov    %eax,%edx
8010516e:	8b 45 08             	mov    0x8(%ebp),%eax
80105171:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 32)) = proc->restorer_addr;	// address of restorer
80105173:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105179:	8b 40 18             	mov    0x18(%eax),%eax
8010517c:	8b 40 44             	mov    0x44(%eax),%eax
8010517f:	83 e8 20             	sub    $0x20,%eax
80105182:	89 c2                	mov    %eax,%edx
80105184:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010518a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105190:	89 02                	mov    %eax,(%edx)
	proc->tf->esp -= 32;
80105192:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105198:	8b 40 18             	mov    0x18(%eax),%eax
8010519b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051a2:	8b 52 18             	mov    0x18(%edx),%edx
801051a5:	8b 52 44             	mov    0x44(%edx),%edx
801051a8:	83 ea 20             	sub    $0x20,%edx
801051ab:	89 50 44             	mov    %edx,0x44(%eax)
	proc->tf->eip = (uint) proc->handlers[signum];
801051ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051b4:	8b 40 18             	mov    0x18(%eax),%eax
801051b7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051be:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051c1:	83 c1 1c             	add    $0x1c,%ecx
801051c4:	8b 54 8a 0c          	mov    0xc(%edx,%ecx,4),%edx
801051c8:	89 50 38             	mov    %edx,0x38(%eax)

  cprintf("retaddr = 0x%x\n",old_eip);
801051cb:	83 ec 08             	sub    $0x8,%esp
801051ce:	ff 75 f4             	pushl  -0xc(%ebp)
801051d1:	68 97 8e 10 80       	push   $0x80108e97
801051d6:	e8 eb b1 ff ff       	call   801003c6 <cprintf>
801051db:	83 c4 10             	add    $0x10,%esp
}
801051de:	90                   	nop
801051df:	c9                   	leave  
801051e0:	c3                   	ret    

801051e1 <signal_register_handler>:



sighandler_t signal_register_handler(int signum, sighandler_t handler)
{
801051e1:	55                   	push   %ebp
801051e2:	89 e5                	mov    %esp,%ebp
801051e4:	83 ec 10             	sub    $0x10,%esp
	if (!proc)
801051e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051ed:	85 c0                	test   %eax,%eax
801051ef:	75 07                	jne    801051f8 <signal_register_handler+0x17>
		return (sighandler_t) -1;
801051f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f6:	eb 29                	jmp    80105221 <signal_register_handler+0x40>

	sighandler_t previous = proc->handlers[signum];
801051f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051fe:	8b 55 08             	mov    0x8(%ebp),%edx
80105201:	83 c2 1c             	add    $0x1c,%edx
80105204:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105208:	89 45 fc             	mov    %eax,-0x4(%ebp)

	proc->handlers[signum] = handler;
8010520b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105211:	8b 55 08             	mov    0x8(%ebp),%edx
80105214:	8d 4a 1c             	lea    0x1c(%edx),%ecx
80105217:	8b 55 0c             	mov    0xc(%ebp),%edx
8010521a:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)

	return previous;
8010521e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105221:	c9                   	leave  
80105222:	c3                   	ret    

80105223 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105223:	55                   	push   %ebp
80105224:	89 e5                	mov    %esp,%ebp
80105226:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105229:	9c                   	pushf  
8010522a:	58                   	pop    %eax
8010522b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010522e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105231:	c9                   	leave  
80105232:	c3                   	ret    

80105233 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105233:	55                   	push   %ebp
80105234:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105236:	fa                   	cli    
}
80105237:	90                   	nop
80105238:	5d                   	pop    %ebp
80105239:	c3                   	ret    

8010523a <sti>:

static inline void
sti(void)
{
8010523a:	55                   	push   %ebp
8010523b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010523d:	fb                   	sti    
}
8010523e:	90                   	nop
8010523f:	5d                   	pop    %ebp
80105240:	c3                   	ret    

80105241 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105241:	55                   	push   %ebp
80105242:	89 e5                	mov    %esp,%ebp
80105244:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105247:	8b 55 08             	mov    0x8(%ebp),%edx
8010524a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010524d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105250:	f0 87 02             	lock xchg %eax,(%edx)
80105253:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105256:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105259:	c9                   	leave  
8010525a:	c3                   	ret    

8010525b <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010525b:	55                   	push   %ebp
8010525c:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010525e:	8b 45 08             	mov    0x8(%ebp),%eax
80105261:	8b 55 0c             	mov    0xc(%ebp),%edx
80105264:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105267:	8b 45 08             	mov    0x8(%ebp),%eax
8010526a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105270:	8b 45 08             	mov    0x8(%ebp),%eax
80105273:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010527a:	90                   	nop
8010527b:	5d                   	pop    %ebp
8010527c:	c3                   	ret    

8010527d <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010527d:	55                   	push   %ebp
8010527e:	89 e5                	mov    %esp,%ebp
80105280:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105283:	e8 52 01 00 00       	call   801053da <pushcli>
  if(holding(lk))
80105288:	8b 45 08             	mov    0x8(%ebp),%eax
8010528b:	83 ec 0c             	sub    $0xc,%esp
8010528e:	50                   	push   %eax
8010528f:	e8 1c 01 00 00       	call   801053b0 <holding>
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	85 c0                	test   %eax,%eax
80105299:	74 0d                	je     801052a8 <acquire+0x2b>
    panic("acquire");
8010529b:	83 ec 0c             	sub    $0xc,%esp
8010529e:	68 d1 8e 10 80       	push   $0x80108ed1
801052a3:	e8 be b2 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801052a8:	90                   	nop
801052a9:	8b 45 08             	mov    0x8(%ebp),%eax
801052ac:	83 ec 08             	sub    $0x8,%esp
801052af:	6a 01                	push   $0x1
801052b1:	50                   	push   %eax
801052b2:	e8 8a ff ff ff       	call   80105241 <xchg>
801052b7:	83 c4 10             	add    $0x10,%esp
801052ba:	85 c0                	test   %eax,%eax
801052bc:	75 eb                	jne    801052a9 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801052be:	8b 45 08             	mov    0x8(%ebp),%eax
801052c1:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801052c8:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801052cb:	8b 45 08             	mov    0x8(%ebp),%eax
801052ce:	83 c0 0c             	add    $0xc,%eax
801052d1:	83 ec 08             	sub    $0x8,%esp
801052d4:	50                   	push   %eax
801052d5:	8d 45 08             	lea    0x8(%ebp),%eax
801052d8:	50                   	push   %eax
801052d9:	e8 58 00 00 00       	call   80105336 <getcallerpcs>
801052de:	83 c4 10             	add    $0x10,%esp
}
801052e1:	90                   	nop
801052e2:	c9                   	leave  
801052e3:	c3                   	ret    

801052e4 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801052e4:	55                   	push   %ebp
801052e5:	89 e5                	mov    %esp,%ebp
801052e7:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801052ea:	83 ec 0c             	sub    $0xc,%esp
801052ed:	ff 75 08             	pushl  0x8(%ebp)
801052f0:	e8 bb 00 00 00       	call   801053b0 <holding>
801052f5:	83 c4 10             	add    $0x10,%esp
801052f8:	85 c0                	test   %eax,%eax
801052fa:	75 0d                	jne    80105309 <release+0x25>
    panic("release");
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	68 d9 8e 10 80       	push   $0x80108ed9
80105304:	e8 5d b2 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105309:	8b 45 08             	mov    0x8(%ebp),%eax
8010530c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105313:	8b 45 08             	mov    0x8(%ebp),%eax
80105316:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010531d:	8b 45 08             	mov    0x8(%ebp),%eax
80105320:	83 ec 08             	sub    $0x8,%esp
80105323:	6a 00                	push   $0x0
80105325:	50                   	push   %eax
80105326:	e8 16 ff ff ff       	call   80105241 <xchg>
8010532b:	83 c4 10             	add    $0x10,%esp

  popcli();
8010532e:	e8 ec 00 00 00       	call   8010541f <popcli>
}
80105333:	90                   	nop
80105334:	c9                   	leave  
80105335:	c3                   	ret    

80105336 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105336:	55                   	push   %ebp
80105337:	89 e5                	mov    %esp,%ebp
80105339:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010533c:	8b 45 08             	mov    0x8(%ebp),%eax
8010533f:	83 e8 08             	sub    $0x8,%eax
80105342:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105345:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010534c:	eb 38                	jmp    80105386 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010534e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105352:	74 53                	je     801053a7 <getcallerpcs+0x71>
80105354:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010535b:	76 4a                	jbe    801053a7 <getcallerpcs+0x71>
8010535d:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105361:	74 44                	je     801053a7 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105363:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105366:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010536d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105370:	01 c2                	add    %eax,%edx
80105372:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105375:	8b 40 04             	mov    0x4(%eax),%eax
80105378:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010537a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010537d:	8b 00                	mov    (%eax),%eax
8010537f:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105382:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105386:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010538a:	7e c2                	jle    8010534e <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010538c:	eb 19                	jmp    801053a7 <getcallerpcs+0x71>
    pcs[i] = 0;
8010538e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105391:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105398:	8b 45 0c             	mov    0xc(%ebp),%eax
8010539b:	01 d0                	add    %edx,%eax
8010539d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801053a3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801053a7:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801053ab:	7e e1                	jle    8010538e <getcallerpcs+0x58>
    pcs[i] = 0;
}
801053ad:	90                   	nop
801053ae:	c9                   	leave  
801053af:	c3                   	ret    

801053b0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801053b3:	8b 45 08             	mov    0x8(%ebp),%eax
801053b6:	8b 00                	mov    (%eax),%eax
801053b8:	85 c0                	test   %eax,%eax
801053ba:	74 17                	je     801053d3 <holding+0x23>
801053bc:	8b 45 08             	mov    0x8(%ebp),%eax
801053bf:	8b 50 08             	mov    0x8(%eax),%edx
801053c2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053c8:	39 c2                	cmp    %eax,%edx
801053ca:	75 07                	jne    801053d3 <holding+0x23>
801053cc:	b8 01 00 00 00       	mov    $0x1,%eax
801053d1:	eb 05                	jmp    801053d8 <holding+0x28>
801053d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053d8:	5d                   	pop    %ebp
801053d9:	c3                   	ret    

801053da <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801053da:	55                   	push   %ebp
801053db:	89 e5                	mov    %esp,%ebp
801053dd:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801053e0:	e8 3e fe ff ff       	call   80105223 <readeflags>
801053e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801053e8:	e8 46 fe ff ff       	call   80105233 <cli>
  if(cpu->ncli++ == 0)
801053ed:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801053f4:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801053fa:	8d 48 01             	lea    0x1(%eax),%ecx
801053fd:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105403:	85 c0                	test   %eax,%eax
80105405:	75 15                	jne    8010541c <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105407:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010540d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105410:	81 e2 00 02 00 00    	and    $0x200,%edx
80105416:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010541c:	90                   	nop
8010541d:	c9                   	leave  
8010541e:	c3                   	ret    

8010541f <popcli>:

void
popcli(void)
{
8010541f:	55                   	push   %ebp
80105420:	89 e5                	mov    %esp,%ebp
80105422:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105425:	e8 f9 fd ff ff       	call   80105223 <readeflags>
8010542a:	25 00 02 00 00       	and    $0x200,%eax
8010542f:	85 c0                	test   %eax,%eax
80105431:	74 0d                	je     80105440 <popcli+0x21>
    panic("popcli - interruptible");
80105433:	83 ec 0c             	sub    $0xc,%esp
80105436:	68 e1 8e 10 80       	push   $0x80108ee1
8010543b:	e8 26 b1 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80105440:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105446:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010544c:	83 ea 01             	sub    $0x1,%edx
8010544f:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105455:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010545b:	85 c0                	test   %eax,%eax
8010545d:	79 0d                	jns    8010546c <popcli+0x4d>
    panic("popcli");
8010545f:	83 ec 0c             	sub    $0xc,%esp
80105462:	68 f8 8e 10 80       	push   $0x80108ef8
80105467:	e8 fa b0 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010546c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105472:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105478:	85 c0                	test   %eax,%eax
8010547a:	75 15                	jne    80105491 <popcli+0x72>
8010547c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105482:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105488:	85 c0                	test   %eax,%eax
8010548a:	74 05                	je     80105491 <popcli+0x72>
    sti();
8010548c:	e8 a9 fd ff ff       	call   8010523a <sti>
}
80105491:	90                   	nop
80105492:	c9                   	leave  
80105493:	c3                   	ret    

80105494 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105494:	55                   	push   %ebp
80105495:	89 e5                	mov    %esp,%ebp
80105497:	57                   	push   %edi
80105498:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105499:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010549c:	8b 55 10             	mov    0x10(%ebp),%edx
8010549f:	8b 45 0c             	mov    0xc(%ebp),%eax
801054a2:	89 cb                	mov    %ecx,%ebx
801054a4:	89 df                	mov    %ebx,%edi
801054a6:	89 d1                	mov    %edx,%ecx
801054a8:	fc                   	cld    
801054a9:	f3 aa                	rep stos %al,%es:(%edi)
801054ab:	89 ca                	mov    %ecx,%edx
801054ad:	89 fb                	mov    %edi,%ebx
801054af:	89 5d 08             	mov    %ebx,0x8(%ebp)
801054b2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801054b5:	90                   	nop
801054b6:	5b                   	pop    %ebx
801054b7:	5f                   	pop    %edi
801054b8:	5d                   	pop    %ebp
801054b9:	c3                   	ret    

801054ba <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801054ba:	55                   	push   %ebp
801054bb:	89 e5                	mov    %esp,%ebp
801054bd:	57                   	push   %edi
801054be:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801054bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054c2:	8b 55 10             	mov    0x10(%ebp),%edx
801054c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c8:	89 cb                	mov    %ecx,%ebx
801054ca:	89 df                	mov    %ebx,%edi
801054cc:	89 d1                	mov    %edx,%ecx
801054ce:	fc                   	cld    
801054cf:	f3 ab                	rep stos %eax,%es:(%edi)
801054d1:	89 ca                	mov    %ecx,%edx
801054d3:	89 fb                	mov    %edi,%ebx
801054d5:	89 5d 08             	mov    %ebx,0x8(%ebp)
801054d8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801054db:	90                   	nop
801054dc:	5b                   	pop    %ebx
801054dd:	5f                   	pop    %edi
801054de:	5d                   	pop    %ebp
801054df:	c3                   	ret    

801054e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801054e3:	8b 45 08             	mov    0x8(%ebp),%eax
801054e6:	83 e0 03             	and    $0x3,%eax
801054e9:	85 c0                	test   %eax,%eax
801054eb:	75 43                	jne    80105530 <memset+0x50>
801054ed:	8b 45 10             	mov    0x10(%ebp),%eax
801054f0:	83 e0 03             	and    $0x3,%eax
801054f3:	85 c0                	test   %eax,%eax
801054f5:	75 39                	jne    80105530 <memset+0x50>
    c &= 0xFF;
801054f7:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801054fe:	8b 45 10             	mov    0x10(%ebp),%eax
80105501:	c1 e8 02             	shr    $0x2,%eax
80105504:	89 c1                	mov    %eax,%ecx
80105506:	8b 45 0c             	mov    0xc(%ebp),%eax
80105509:	c1 e0 18             	shl    $0x18,%eax
8010550c:	89 c2                	mov    %eax,%edx
8010550e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105511:	c1 e0 10             	shl    $0x10,%eax
80105514:	09 c2                	or     %eax,%edx
80105516:	8b 45 0c             	mov    0xc(%ebp),%eax
80105519:	c1 e0 08             	shl    $0x8,%eax
8010551c:	09 d0                	or     %edx,%eax
8010551e:	0b 45 0c             	or     0xc(%ebp),%eax
80105521:	51                   	push   %ecx
80105522:	50                   	push   %eax
80105523:	ff 75 08             	pushl  0x8(%ebp)
80105526:	e8 8f ff ff ff       	call   801054ba <stosl>
8010552b:	83 c4 0c             	add    $0xc,%esp
8010552e:	eb 12                	jmp    80105542 <memset+0x62>
  } else
    stosb(dst, c, n);
80105530:	8b 45 10             	mov    0x10(%ebp),%eax
80105533:	50                   	push   %eax
80105534:	ff 75 0c             	pushl  0xc(%ebp)
80105537:	ff 75 08             	pushl  0x8(%ebp)
8010553a:	e8 55 ff ff ff       	call   80105494 <stosb>
8010553f:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105542:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105545:	c9                   	leave  
80105546:	c3                   	ret    

80105547 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105547:	55                   	push   %ebp
80105548:	89 e5                	mov    %esp,%ebp
8010554a:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010554d:	8b 45 08             	mov    0x8(%ebp),%eax
80105550:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105553:	8b 45 0c             	mov    0xc(%ebp),%eax
80105556:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105559:	eb 30                	jmp    8010558b <memcmp+0x44>
    if(*s1 != *s2)
8010555b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010555e:	0f b6 10             	movzbl (%eax),%edx
80105561:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105564:	0f b6 00             	movzbl (%eax),%eax
80105567:	38 c2                	cmp    %al,%dl
80105569:	74 18                	je     80105583 <memcmp+0x3c>
      return *s1 - *s2;
8010556b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010556e:	0f b6 00             	movzbl (%eax),%eax
80105571:	0f b6 d0             	movzbl %al,%edx
80105574:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105577:	0f b6 00             	movzbl (%eax),%eax
8010557a:	0f b6 c0             	movzbl %al,%eax
8010557d:	29 c2                	sub    %eax,%edx
8010557f:	89 d0                	mov    %edx,%eax
80105581:	eb 1a                	jmp    8010559d <memcmp+0x56>
    s1++, s2++;
80105583:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105587:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010558b:	8b 45 10             	mov    0x10(%ebp),%eax
8010558e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105591:	89 55 10             	mov    %edx,0x10(%ebp)
80105594:	85 c0                	test   %eax,%eax
80105596:	75 c3                	jne    8010555b <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105598:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010559d:	c9                   	leave  
8010559e:	c3                   	ret    

8010559f <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010559f:	55                   	push   %ebp
801055a0:	89 e5                	mov    %esp,%ebp
801055a2:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801055a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801055a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801055ab:	8b 45 08             	mov    0x8(%ebp),%eax
801055ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801055b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801055b7:	73 54                	jae    8010560d <memmove+0x6e>
801055b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055bc:	8b 45 10             	mov    0x10(%ebp),%eax
801055bf:	01 d0                	add    %edx,%eax
801055c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801055c4:	76 47                	jbe    8010560d <memmove+0x6e>
    s += n;
801055c6:	8b 45 10             	mov    0x10(%ebp),%eax
801055c9:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801055cc:	8b 45 10             	mov    0x10(%ebp),%eax
801055cf:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801055d2:	eb 13                	jmp    801055e7 <memmove+0x48>
      *--d = *--s;
801055d4:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801055d8:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801055dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055df:	0f b6 10             	movzbl (%eax),%edx
801055e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055e5:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801055e7:	8b 45 10             	mov    0x10(%ebp),%eax
801055ea:	8d 50 ff             	lea    -0x1(%eax),%edx
801055ed:	89 55 10             	mov    %edx,0x10(%ebp)
801055f0:	85 c0                	test   %eax,%eax
801055f2:	75 e0                	jne    801055d4 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801055f4:	eb 24                	jmp    8010561a <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801055f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055f9:	8d 50 01             	lea    0x1(%eax),%edx
801055fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
801055ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105602:	8d 4a 01             	lea    0x1(%edx),%ecx
80105605:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105608:	0f b6 12             	movzbl (%edx),%edx
8010560b:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010560d:	8b 45 10             	mov    0x10(%ebp),%eax
80105610:	8d 50 ff             	lea    -0x1(%eax),%edx
80105613:	89 55 10             	mov    %edx,0x10(%ebp)
80105616:	85 c0                	test   %eax,%eax
80105618:	75 dc                	jne    801055f6 <memmove+0x57>
      *d++ = *s++;

  return dst;
8010561a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010561d:	c9                   	leave  
8010561e:	c3                   	ret    

8010561f <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010561f:	55                   	push   %ebp
80105620:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105622:	ff 75 10             	pushl  0x10(%ebp)
80105625:	ff 75 0c             	pushl  0xc(%ebp)
80105628:	ff 75 08             	pushl  0x8(%ebp)
8010562b:	e8 6f ff ff ff       	call   8010559f <memmove>
80105630:	83 c4 0c             	add    $0xc,%esp
}
80105633:	c9                   	leave  
80105634:	c3                   	ret    

80105635 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105635:	55                   	push   %ebp
80105636:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105638:	eb 0c                	jmp    80105646 <strncmp+0x11>
    n--, p++, q++;
8010563a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010563e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105642:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105646:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010564a:	74 1a                	je     80105666 <strncmp+0x31>
8010564c:	8b 45 08             	mov    0x8(%ebp),%eax
8010564f:	0f b6 00             	movzbl (%eax),%eax
80105652:	84 c0                	test   %al,%al
80105654:	74 10                	je     80105666 <strncmp+0x31>
80105656:	8b 45 08             	mov    0x8(%ebp),%eax
80105659:	0f b6 10             	movzbl (%eax),%edx
8010565c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010565f:	0f b6 00             	movzbl (%eax),%eax
80105662:	38 c2                	cmp    %al,%dl
80105664:	74 d4                	je     8010563a <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105666:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010566a:	75 07                	jne    80105673 <strncmp+0x3e>
    return 0;
8010566c:	b8 00 00 00 00       	mov    $0x0,%eax
80105671:	eb 16                	jmp    80105689 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105673:	8b 45 08             	mov    0x8(%ebp),%eax
80105676:	0f b6 00             	movzbl (%eax),%eax
80105679:	0f b6 d0             	movzbl %al,%edx
8010567c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010567f:	0f b6 00             	movzbl (%eax),%eax
80105682:	0f b6 c0             	movzbl %al,%eax
80105685:	29 c2                	sub    %eax,%edx
80105687:	89 d0                	mov    %edx,%eax
}
80105689:	5d                   	pop    %ebp
8010568a:	c3                   	ret    

8010568b <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010568b:	55                   	push   %ebp
8010568c:	89 e5                	mov    %esp,%ebp
8010568e:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105691:	8b 45 08             	mov    0x8(%ebp),%eax
80105694:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105697:	90                   	nop
80105698:	8b 45 10             	mov    0x10(%ebp),%eax
8010569b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010569e:	89 55 10             	mov    %edx,0x10(%ebp)
801056a1:	85 c0                	test   %eax,%eax
801056a3:	7e 2c                	jle    801056d1 <strncpy+0x46>
801056a5:	8b 45 08             	mov    0x8(%ebp),%eax
801056a8:	8d 50 01             	lea    0x1(%eax),%edx
801056ab:	89 55 08             	mov    %edx,0x8(%ebp)
801056ae:	8b 55 0c             	mov    0xc(%ebp),%edx
801056b1:	8d 4a 01             	lea    0x1(%edx),%ecx
801056b4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801056b7:	0f b6 12             	movzbl (%edx),%edx
801056ba:	88 10                	mov    %dl,(%eax)
801056bc:	0f b6 00             	movzbl (%eax),%eax
801056bf:	84 c0                	test   %al,%al
801056c1:	75 d5                	jne    80105698 <strncpy+0xd>
    ;
  while(n-- > 0)
801056c3:	eb 0c                	jmp    801056d1 <strncpy+0x46>
    *s++ = 0;
801056c5:	8b 45 08             	mov    0x8(%ebp),%eax
801056c8:	8d 50 01             	lea    0x1(%eax),%edx
801056cb:	89 55 08             	mov    %edx,0x8(%ebp)
801056ce:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801056d1:	8b 45 10             	mov    0x10(%ebp),%eax
801056d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801056d7:	89 55 10             	mov    %edx,0x10(%ebp)
801056da:	85 c0                	test   %eax,%eax
801056dc:	7f e7                	jg     801056c5 <strncpy+0x3a>
    *s++ = 0;
  return os;
801056de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801056e1:	c9                   	leave  
801056e2:	c3                   	ret    

801056e3 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801056e3:	55                   	push   %ebp
801056e4:	89 e5                	mov    %esp,%ebp
801056e6:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801056e9:	8b 45 08             	mov    0x8(%ebp),%eax
801056ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801056ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056f3:	7f 05                	jg     801056fa <safestrcpy+0x17>
    return os;
801056f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056f8:	eb 31                	jmp    8010572b <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801056fa:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801056fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105702:	7e 1e                	jle    80105722 <safestrcpy+0x3f>
80105704:	8b 45 08             	mov    0x8(%ebp),%eax
80105707:	8d 50 01             	lea    0x1(%eax),%edx
8010570a:	89 55 08             	mov    %edx,0x8(%ebp)
8010570d:	8b 55 0c             	mov    0xc(%ebp),%edx
80105710:	8d 4a 01             	lea    0x1(%edx),%ecx
80105713:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105716:	0f b6 12             	movzbl (%edx),%edx
80105719:	88 10                	mov    %dl,(%eax)
8010571b:	0f b6 00             	movzbl (%eax),%eax
8010571e:	84 c0                	test   %al,%al
80105720:	75 d8                	jne    801056fa <safestrcpy+0x17>
    ;
  *s = 0;
80105722:	8b 45 08             	mov    0x8(%ebp),%eax
80105725:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105728:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010572b:	c9                   	leave  
8010572c:	c3                   	ret    

8010572d <strlen>:

int
strlen(const char *s)
{
8010572d:	55                   	push   %ebp
8010572e:	89 e5                	mov    %esp,%ebp
80105730:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105733:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010573a:	eb 04                	jmp    80105740 <strlen+0x13>
8010573c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105740:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105743:	8b 45 08             	mov    0x8(%ebp),%eax
80105746:	01 d0                	add    %edx,%eax
80105748:	0f b6 00             	movzbl (%eax),%eax
8010574b:	84 c0                	test   %al,%al
8010574d:	75 ed                	jne    8010573c <strlen+0xf>
    ;
  return n;
8010574f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105752:	c9                   	leave  
80105753:	c3                   	ret    

80105754 <swtch>:
80105754:	8b 44 24 04          	mov    0x4(%esp),%eax
80105758:	8b 54 24 08          	mov    0x8(%esp),%edx
8010575c:	55                   	push   %ebp
8010575d:	53                   	push   %ebx
8010575e:	56                   	push   %esi
8010575f:	57                   	push   %edi
80105760:	89 20                	mov    %esp,(%eax)
80105762:	89 d4                	mov    %edx,%esp
80105764:	5f                   	pop    %edi
80105765:	5e                   	pop    %esi
80105766:	5b                   	pop    %ebx
80105767:	5d                   	pop    %ebp
80105768:	c3                   	ret    

80105769 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105769:	55                   	push   %ebp
8010576a:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010576c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105772:	8b 00                	mov    (%eax),%eax
80105774:	3b 45 08             	cmp    0x8(%ebp),%eax
80105777:	76 12                	jbe    8010578b <fetchint+0x22>
80105779:	8b 45 08             	mov    0x8(%ebp),%eax
8010577c:	8d 50 04             	lea    0x4(%eax),%edx
8010577f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105785:	8b 00                	mov    (%eax),%eax
80105787:	39 c2                	cmp    %eax,%edx
80105789:	76 07                	jbe    80105792 <fetchint+0x29>
    return -1;
8010578b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105790:	eb 0f                	jmp    801057a1 <fetchint+0x38>
  *ip = *(int*)(addr);
80105792:	8b 45 08             	mov    0x8(%ebp),%eax
80105795:	8b 10                	mov    (%eax),%edx
80105797:	8b 45 0c             	mov    0xc(%ebp),%eax
8010579a:	89 10                	mov    %edx,(%eax)
  return 0;
8010579c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057a1:	5d                   	pop    %ebp
801057a2:	c3                   	ret    

801057a3 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801057a3:	55                   	push   %ebp
801057a4:	89 e5                	mov    %esp,%ebp
801057a6:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801057a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057af:	8b 00                	mov    (%eax),%eax
801057b1:	3b 45 08             	cmp    0x8(%ebp),%eax
801057b4:	77 07                	ja     801057bd <fetchstr+0x1a>
    return -1;
801057b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057bb:	eb 46                	jmp    80105803 <fetchstr+0x60>
  *pp = (char*)addr;
801057bd:	8b 55 08             	mov    0x8(%ebp),%edx
801057c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801057c3:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801057c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057cb:	8b 00                	mov    (%eax),%eax
801057cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801057d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801057d3:	8b 00                	mov    (%eax),%eax
801057d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
801057d8:	eb 1c                	jmp    801057f6 <fetchstr+0x53>
    if(*s == 0)
801057da:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057dd:	0f b6 00             	movzbl (%eax),%eax
801057e0:	84 c0                	test   %al,%al
801057e2:	75 0e                	jne    801057f2 <fetchstr+0x4f>
      return s - *pp;
801057e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801057ea:	8b 00                	mov    (%eax),%eax
801057ec:	29 c2                	sub    %eax,%edx
801057ee:	89 d0                	mov    %edx,%eax
801057f0:	eb 11                	jmp    80105803 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801057f2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801057f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801057fc:	72 dc                	jb     801057da <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801057fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105803:	c9                   	leave  
80105804:	c3                   	ret    

80105805 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105805:	55                   	push   %ebp
80105806:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105808:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010580e:	8b 40 18             	mov    0x18(%eax),%eax
80105811:	8b 40 44             	mov    0x44(%eax),%eax
80105814:	8b 55 08             	mov    0x8(%ebp),%edx
80105817:	c1 e2 02             	shl    $0x2,%edx
8010581a:	01 d0                	add    %edx,%eax
8010581c:	83 c0 04             	add    $0x4,%eax
8010581f:	ff 75 0c             	pushl  0xc(%ebp)
80105822:	50                   	push   %eax
80105823:	e8 41 ff ff ff       	call   80105769 <fetchint>
80105828:	83 c4 08             	add    $0x8,%esp
}
8010582b:	c9                   	leave  
8010582c:	c3                   	ret    

8010582d <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010582d:	55                   	push   %ebp
8010582e:	89 e5                	mov    %esp,%ebp
80105830:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(argint(n, &i) < 0)
80105833:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105836:	50                   	push   %eax
80105837:	ff 75 08             	pushl  0x8(%ebp)
8010583a:	e8 c6 ff ff ff       	call   80105805 <argint>
8010583f:	83 c4 08             	add    $0x8,%esp
80105842:	85 c0                	test   %eax,%eax
80105844:	79 07                	jns    8010584d <argptr+0x20>
    return -1;
80105846:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584b:	eb 3b                	jmp    80105888 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010584d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105853:	8b 00                	mov    (%eax),%eax
80105855:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105858:	39 d0                	cmp    %edx,%eax
8010585a:	76 16                	jbe    80105872 <argptr+0x45>
8010585c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010585f:	89 c2                	mov    %eax,%edx
80105861:	8b 45 10             	mov    0x10(%ebp),%eax
80105864:	01 c2                	add    %eax,%edx
80105866:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010586c:	8b 00                	mov    (%eax),%eax
8010586e:	39 c2                	cmp    %eax,%edx
80105870:	76 07                	jbe    80105879 <argptr+0x4c>
    return -1;
80105872:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105877:	eb 0f                	jmp    80105888 <argptr+0x5b>
  *pp = (char*)i;
80105879:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010587c:	89 c2                	mov    %eax,%edx
8010587e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105881:	89 10                	mov    %edx,(%eax)
  return 0;
80105883:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105888:	c9                   	leave  
80105889:	c3                   	ret    

8010588a <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010588a:	55                   	push   %ebp
8010588b:	89 e5                	mov    %esp,%ebp
8010588d:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105890:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105893:	50                   	push   %eax
80105894:	ff 75 08             	pushl  0x8(%ebp)
80105897:	e8 69 ff ff ff       	call   80105805 <argint>
8010589c:	83 c4 08             	add    $0x8,%esp
8010589f:	85 c0                	test   %eax,%eax
801058a1:	79 07                	jns    801058aa <argstr+0x20>
    return -1;
801058a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a8:	eb 0f                	jmp    801058b9 <argstr+0x2f>
  return fetchstr(addr, pp);
801058aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058ad:	ff 75 0c             	pushl  0xc(%ebp)
801058b0:	50                   	push   %eax
801058b1:	e8 ed fe ff ff       	call   801057a3 <fetchstr>
801058b6:	83 c4 08             	add    $0x8,%esp
}
801058b9:	c9                   	leave  
801058ba:	c3                   	ret    

801058bb <syscall>:
[SYS_cowfork] sys_cowfork,
};

void
syscall(void)
{
801058bb:	55                   	push   %ebp
801058bc:	89 e5                	mov    %esp,%ebp
801058be:	53                   	push   %ebx
801058bf:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801058c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058c8:	8b 40 18             	mov    0x18(%eax),%eax
801058cb:	8b 40 1c             	mov    0x1c(%eax),%eax
801058ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801058d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058d5:	7e 30                	jle    80105907 <syscall+0x4c>
801058d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058da:	83 f8 1a             	cmp    $0x1a,%eax
801058dd:	77 28                	ja     80105907 <syscall+0x4c>
801058df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e2:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
801058e9:	85 c0                	test   %eax,%eax
801058eb:	74 1a                	je     80105907 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801058ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058f3:	8b 58 18             	mov    0x18(%eax),%ebx
801058f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f9:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105900:	ff d0                	call   *%eax
80105902:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105905:	eb 34                	jmp    8010593b <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105907:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010590d:	8d 50 6c             	lea    0x6c(%eax),%edx
80105910:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105916:	8b 40 10             	mov    0x10(%eax),%eax
80105919:	ff 75 f4             	pushl  -0xc(%ebp)
8010591c:	52                   	push   %edx
8010591d:	50                   	push   %eax
8010591e:	68 ff 8e 10 80       	push   $0x80108eff
80105923:	e8 9e aa ff ff       	call   801003c6 <cprintf>
80105928:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010592b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105931:	8b 40 18             	mov    0x18(%eax),%eax
80105934:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010593b:	90                   	nop
8010593c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010593f:	c9                   	leave  
80105940:	c3                   	ret    

80105941 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105941:	55                   	push   %ebp
80105942:	89 e5                	mov    %esp,%ebp
80105944:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105947:	83 ec 08             	sub    $0x8,%esp
8010594a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010594d:	50                   	push   %eax
8010594e:	ff 75 08             	pushl  0x8(%ebp)
80105951:	e8 af fe ff ff       	call   80105805 <argint>
80105956:	83 c4 10             	add    $0x10,%esp
80105959:	85 c0                	test   %eax,%eax
8010595b:	79 07                	jns    80105964 <argfd+0x23>
    return -1;
8010595d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105962:	eb 50                	jmp    801059b4 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105964:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105967:	85 c0                	test   %eax,%eax
80105969:	78 21                	js     8010598c <argfd+0x4b>
8010596b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010596e:	83 f8 0f             	cmp    $0xf,%eax
80105971:	7f 19                	jg     8010598c <argfd+0x4b>
80105973:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105979:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010597c:	83 c2 08             	add    $0x8,%edx
8010597f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105983:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010598a:	75 07                	jne    80105993 <argfd+0x52>
    return -1;
8010598c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105991:	eb 21                	jmp    801059b4 <argfd+0x73>
  if(pfd)
80105993:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105997:	74 08                	je     801059a1 <argfd+0x60>
    *pfd = fd;
80105999:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010599c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010599f:	89 10                	mov    %edx,(%eax)
  if(pf)
801059a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059a5:	74 08                	je     801059af <argfd+0x6e>
    *pf = f;
801059a7:	8b 45 10             	mov    0x10(%ebp),%eax
801059aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059ad:	89 10                	mov    %edx,(%eax)
  return 0;
801059af:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059b4:	c9                   	leave  
801059b5:	c3                   	ret    

801059b6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801059b6:	55                   	push   %ebp
801059b7:	89 e5                	mov    %esp,%ebp
801059b9:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801059bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801059c3:	eb 30                	jmp    801059f5 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801059c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059ce:	83 c2 08             	add    $0x8,%edx
801059d1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801059d5:	85 c0                	test   %eax,%eax
801059d7:	75 18                	jne    801059f1 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801059d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059df:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059e2:	8d 4a 08             	lea    0x8(%edx),%ecx
801059e5:	8b 55 08             	mov    0x8(%ebp),%edx
801059e8:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801059ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059ef:	eb 0f                	jmp    80105a00 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801059f1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801059f5:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801059f9:	7e ca                	jle    801059c5 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801059fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a00:	c9                   	leave  
80105a01:	c3                   	ret    

80105a02 <sys_dup>:

int
sys_dup(void)
{
80105a02:	55                   	push   %ebp
80105a03:	89 e5                	mov    %esp,%ebp
80105a05:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105a08:	83 ec 04             	sub    $0x4,%esp
80105a0b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a0e:	50                   	push   %eax
80105a0f:	6a 00                	push   $0x0
80105a11:	6a 00                	push   $0x0
80105a13:	e8 29 ff ff ff       	call   80105941 <argfd>
80105a18:	83 c4 10             	add    $0x10,%esp
80105a1b:	85 c0                	test   %eax,%eax
80105a1d:	79 07                	jns    80105a26 <sys_dup+0x24>
    return -1;
80105a1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a24:	eb 31                	jmp    80105a57 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a29:	83 ec 0c             	sub    $0xc,%esp
80105a2c:	50                   	push   %eax
80105a2d:	e8 84 ff ff ff       	call   801059b6 <fdalloc>
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a3c:	79 07                	jns    80105a45 <sys_dup+0x43>
    return -1;
80105a3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a43:	eb 12                	jmp    80105a57 <sys_dup+0x55>
  filedup(f);
80105a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a48:	83 ec 0c             	sub    $0xc,%esp
80105a4b:	50                   	push   %eax
80105a4c:	e8 94 b5 ff ff       	call   80100fe5 <filedup>
80105a51:	83 c4 10             	add    $0x10,%esp
  return fd;
80105a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105a57:	c9                   	leave  
80105a58:	c3                   	ret    

80105a59 <sys_read>:

int
sys_read(void)
{
80105a59:	55                   	push   %ebp
80105a5a:	89 e5                	mov    %esp,%ebp
80105a5c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a5f:	83 ec 04             	sub    $0x4,%esp
80105a62:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a65:	50                   	push   %eax
80105a66:	6a 00                	push   $0x0
80105a68:	6a 00                	push   $0x0
80105a6a:	e8 d2 fe ff ff       	call   80105941 <argfd>
80105a6f:	83 c4 10             	add    $0x10,%esp
80105a72:	85 c0                	test   %eax,%eax
80105a74:	78 2e                	js     80105aa4 <sys_read+0x4b>
80105a76:	83 ec 08             	sub    $0x8,%esp
80105a79:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a7c:	50                   	push   %eax
80105a7d:	6a 02                	push   $0x2
80105a7f:	e8 81 fd ff ff       	call   80105805 <argint>
80105a84:	83 c4 10             	add    $0x10,%esp
80105a87:	85 c0                	test   %eax,%eax
80105a89:	78 19                	js     80105aa4 <sys_read+0x4b>
80105a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a8e:	83 ec 04             	sub    $0x4,%esp
80105a91:	50                   	push   %eax
80105a92:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a95:	50                   	push   %eax
80105a96:	6a 01                	push   $0x1
80105a98:	e8 90 fd ff ff       	call   8010582d <argptr>
80105a9d:	83 c4 10             	add    $0x10,%esp
80105aa0:	85 c0                	test   %eax,%eax
80105aa2:	79 07                	jns    80105aab <sys_read+0x52>
    return -1;
80105aa4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa9:	eb 17                	jmp    80105ac2 <sys_read+0x69>
  return fileread(f, p, n);
80105aab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105aae:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab4:	83 ec 04             	sub    $0x4,%esp
80105ab7:	51                   	push   %ecx
80105ab8:	52                   	push   %edx
80105ab9:	50                   	push   %eax
80105aba:	e8 b6 b6 ff ff       	call   80101175 <fileread>
80105abf:	83 c4 10             	add    $0x10,%esp
}
80105ac2:	c9                   	leave  
80105ac3:	c3                   	ret    

80105ac4 <sys_write>:

int
sys_write(void)
{
80105ac4:	55                   	push   %ebp
80105ac5:	89 e5                	mov    %esp,%ebp
80105ac7:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105aca:	83 ec 04             	sub    $0x4,%esp
80105acd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ad0:	50                   	push   %eax
80105ad1:	6a 00                	push   $0x0
80105ad3:	6a 00                	push   $0x0
80105ad5:	e8 67 fe ff ff       	call   80105941 <argfd>
80105ada:	83 c4 10             	add    $0x10,%esp
80105add:	85 c0                	test   %eax,%eax
80105adf:	78 2e                	js     80105b0f <sys_write+0x4b>
80105ae1:	83 ec 08             	sub    $0x8,%esp
80105ae4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ae7:	50                   	push   %eax
80105ae8:	6a 02                	push   $0x2
80105aea:	e8 16 fd ff ff       	call   80105805 <argint>
80105aef:	83 c4 10             	add    $0x10,%esp
80105af2:	85 c0                	test   %eax,%eax
80105af4:	78 19                	js     80105b0f <sys_write+0x4b>
80105af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af9:	83 ec 04             	sub    $0x4,%esp
80105afc:	50                   	push   %eax
80105afd:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b00:	50                   	push   %eax
80105b01:	6a 01                	push   $0x1
80105b03:	e8 25 fd ff ff       	call   8010582d <argptr>
80105b08:	83 c4 10             	add    $0x10,%esp
80105b0b:	85 c0                	test   %eax,%eax
80105b0d:	79 07                	jns    80105b16 <sys_write+0x52>
    return -1;
80105b0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b14:	eb 17                	jmp    80105b2d <sys_write+0x69>
  return filewrite(f, p, n);
80105b16:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b19:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b1f:	83 ec 04             	sub    $0x4,%esp
80105b22:	51                   	push   %ecx
80105b23:	52                   	push   %edx
80105b24:	50                   	push   %eax
80105b25:	e8 03 b7 ff ff       	call   8010122d <filewrite>
80105b2a:	83 c4 10             	add    $0x10,%esp
}
80105b2d:	c9                   	leave  
80105b2e:	c3                   	ret    

80105b2f <sys_close>:

int
sys_close(void)
{
80105b2f:	55                   	push   %ebp
80105b30:	89 e5                	mov    %esp,%ebp
80105b32:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105b35:	83 ec 04             	sub    $0x4,%esp
80105b38:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b3b:	50                   	push   %eax
80105b3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b3f:	50                   	push   %eax
80105b40:	6a 00                	push   $0x0
80105b42:	e8 fa fd ff ff       	call   80105941 <argfd>
80105b47:	83 c4 10             	add    $0x10,%esp
80105b4a:	85 c0                	test   %eax,%eax
80105b4c:	79 07                	jns    80105b55 <sys_close+0x26>
    return -1;
80105b4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b53:	eb 28                	jmp    80105b7d <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105b55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b5e:	83 c2 08             	add    $0x8,%edx
80105b61:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105b68:	00 
  fileclose(f);
80105b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b6c:	83 ec 0c             	sub    $0xc,%esp
80105b6f:	50                   	push   %eax
80105b70:	e8 c1 b4 ff ff       	call   80101036 <fileclose>
80105b75:	83 c4 10             	add    $0x10,%esp
  return 0;
80105b78:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b7d:	c9                   	leave  
80105b7e:	c3                   	ret    

80105b7f <sys_fstat>:

int
sys_fstat(void)
{
80105b7f:	55                   	push   %ebp
80105b80:	89 e5                	mov    %esp,%ebp
80105b82:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105b85:	83 ec 04             	sub    $0x4,%esp
80105b88:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b8b:	50                   	push   %eax
80105b8c:	6a 00                	push   $0x0
80105b8e:	6a 00                	push   $0x0
80105b90:	e8 ac fd ff ff       	call   80105941 <argfd>
80105b95:	83 c4 10             	add    $0x10,%esp
80105b98:	85 c0                	test   %eax,%eax
80105b9a:	78 17                	js     80105bb3 <sys_fstat+0x34>
80105b9c:	83 ec 04             	sub    $0x4,%esp
80105b9f:	6a 14                	push   $0x14
80105ba1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ba4:	50                   	push   %eax
80105ba5:	6a 01                	push   $0x1
80105ba7:	e8 81 fc ff ff       	call   8010582d <argptr>
80105bac:	83 c4 10             	add    $0x10,%esp
80105baf:	85 c0                	test   %eax,%eax
80105bb1:	79 07                	jns    80105bba <sys_fstat+0x3b>
    return -1;
80105bb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb8:	eb 13                	jmp    80105bcd <sys_fstat+0x4e>
  return filestat(f, st);
80105bba:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc0:	83 ec 08             	sub    $0x8,%esp
80105bc3:	52                   	push   %edx
80105bc4:	50                   	push   %eax
80105bc5:	e8 54 b5 ff ff       	call   8010111e <filestat>
80105bca:	83 c4 10             	add    $0x10,%esp
}
80105bcd:	c9                   	leave  
80105bce:	c3                   	ret    

80105bcf <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105bcf:	55                   	push   %ebp
80105bd0:	89 e5                	mov    %esp,%ebp
80105bd2:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105bd5:	83 ec 08             	sub    $0x8,%esp
80105bd8:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105bdb:	50                   	push   %eax
80105bdc:	6a 00                	push   $0x0
80105bde:	e8 a7 fc ff ff       	call   8010588a <argstr>
80105be3:	83 c4 10             	add    $0x10,%esp
80105be6:	85 c0                	test   %eax,%eax
80105be8:	78 15                	js     80105bff <sys_link+0x30>
80105bea:	83 ec 08             	sub    $0x8,%esp
80105bed:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105bf0:	50                   	push   %eax
80105bf1:	6a 01                	push   $0x1
80105bf3:	e8 92 fc ff ff       	call   8010588a <argstr>
80105bf8:	83 c4 10             	add    $0x10,%esp
80105bfb:	85 c0                	test   %eax,%eax
80105bfd:	79 0a                	jns    80105c09 <sys_link+0x3a>
    return -1;
80105bff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c04:	e9 68 01 00 00       	jmp    80105d71 <sys_link+0x1a2>

  begin_op();
80105c09:	e8 a6 d8 ff ff       	call   801034b4 <begin_op>
  if((ip = namei(old)) == 0){
80105c0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105c11:	83 ec 0c             	sub    $0xc,%esp
80105c14:	50                   	push   %eax
80105c15:	e8 a9 c8 ff ff       	call   801024c3 <namei>
80105c1a:	83 c4 10             	add    $0x10,%esp
80105c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c24:	75 0f                	jne    80105c35 <sys_link+0x66>
    end_op();
80105c26:	e8 15 d9 ff ff       	call   80103540 <end_op>
    return -1;
80105c2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c30:	e9 3c 01 00 00       	jmp    80105d71 <sys_link+0x1a2>
  }

  ilock(ip);
80105c35:	83 ec 0c             	sub    $0xc,%esp
80105c38:	ff 75 f4             	pushl  -0xc(%ebp)
80105c3b:	e8 cb bc ff ff       	call   8010190b <ilock>
80105c40:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c46:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c4a:	66 83 f8 01          	cmp    $0x1,%ax
80105c4e:	75 1d                	jne    80105c6d <sys_link+0x9e>
    iunlockput(ip);
80105c50:	83 ec 0c             	sub    $0xc,%esp
80105c53:	ff 75 f4             	pushl  -0xc(%ebp)
80105c56:	e8 6a bf ff ff       	call   80101bc5 <iunlockput>
80105c5b:	83 c4 10             	add    $0x10,%esp
    end_op();
80105c5e:	e8 dd d8 ff ff       	call   80103540 <end_op>
    return -1;
80105c63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c68:	e9 04 01 00 00       	jmp    80105d71 <sys_link+0x1a2>
  }

  ip->nlink++;
80105c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c70:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c74:	83 c0 01             	add    $0x1,%eax
80105c77:	89 c2                	mov    %eax,%edx
80105c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c7c:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	ff 75 f4             	pushl  -0xc(%ebp)
80105c86:	e8 ac ba ff ff       	call   80101737 <iupdate>
80105c8b:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105c8e:	83 ec 0c             	sub    $0xc,%esp
80105c91:	ff 75 f4             	pushl  -0xc(%ebp)
80105c94:	e8 ca bd ff ff       	call   80101a63 <iunlock>
80105c99:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105c9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c9f:	83 ec 08             	sub    $0x8,%esp
80105ca2:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105ca5:	52                   	push   %edx
80105ca6:	50                   	push   %eax
80105ca7:	e8 33 c8 ff ff       	call   801024df <nameiparent>
80105cac:	83 c4 10             	add    $0x10,%esp
80105caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cb6:	74 71                	je     80105d29 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105cb8:	83 ec 0c             	sub    $0xc,%esp
80105cbb:	ff 75 f0             	pushl  -0x10(%ebp)
80105cbe:	e8 48 bc ff ff       	call   8010190b <ilock>
80105cc3:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cc9:	8b 10                	mov    (%eax),%edx
80105ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cce:	8b 00                	mov    (%eax),%eax
80105cd0:	39 c2                	cmp    %eax,%edx
80105cd2:	75 1d                	jne    80105cf1 <sys_link+0x122>
80105cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cd7:	8b 40 04             	mov    0x4(%eax),%eax
80105cda:	83 ec 04             	sub    $0x4,%esp
80105cdd:	50                   	push   %eax
80105cde:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105ce1:	50                   	push   %eax
80105ce2:	ff 75 f0             	pushl  -0x10(%ebp)
80105ce5:	e8 3d c5 ff ff       	call   80102227 <dirlink>
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	85 c0                	test   %eax,%eax
80105cef:	79 10                	jns    80105d01 <sys_link+0x132>
    iunlockput(dp);
80105cf1:	83 ec 0c             	sub    $0xc,%esp
80105cf4:	ff 75 f0             	pushl  -0x10(%ebp)
80105cf7:	e8 c9 be ff ff       	call   80101bc5 <iunlockput>
80105cfc:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105cff:	eb 29                	jmp    80105d2a <sys_link+0x15b>
  }
  iunlockput(dp);
80105d01:	83 ec 0c             	sub    $0xc,%esp
80105d04:	ff 75 f0             	pushl  -0x10(%ebp)
80105d07:	e8 b9 be ff ff       	call   80101bc5 <iunlockput>
80105d0c:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105d0f:	83 ec 0c             	sub    $0xc,%esp
80105d12:	ff 75 f4             	pushl  -0xc(%ebp)
80105d15:	e8 bb bd ff ff       	call   80101ad5 <iput>
80105d1a:	83 c4 10             	add    $0x10,%esp

  end_op();
80105d1d:	e8 1e d8 ff ff       	call   80103540 <end_op>

  return 0;
80105d22:	b8 00 00 00 00       	mov    $0x0,%eax
80105d27:	eb 48                	jmp    80105d71 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105d29:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105d2a:	83 ec 0c             	sub    $0xc,%esp
80105d2d:	ff 75 f4             	pushl  -0xc(%ebp)
80105d30:	e8 d6 bb ff ff       	call   8010190b <ilock>
80105d35:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d3b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d3f:	83 e8 01             	sub    $0x1,%eax
80105d42:	89 c2                	mov    %eax,%edx
80105d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d47:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105d4b:	83 ec 0c             	sub    $0xc,%esp
80105d4e:	ff 75 f4             	pushl  -0xc(%ebp)
80105d51:	e8 e1 b9 ff ff       	call   80101737 <iupdate>
80105d56:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105d59:	83 ec 0c             	sub    $0xc,%esp
80105d5c:	ff 75 f4             	pushl  -0xc(%ebp)
80105d5f:	e8 61 be ff ff       	call   80101bc5 <iunlockput>
80105d64:	83 c4 10             	add    $0x10,%esp
  end_op();
80105d67:	e8 d4 d7 ff ff       	call   80103540 <end_op>
  return -1;
80105d6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d71:	c9                   	leave  
80105d72:	c3                   	ret    

80105d73 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105d73:	55                   	push   %ebp
80105d74:	89 e5                	mov    %esp,%ebp
80105d76:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d79:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105d80:	eb 40                	jmp    80105dc2 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d85:	6a 10                	push   $0x10
80105d87:	50                   	push   %eax
80105d88:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d8b:	50                   	push   %eax
80105d8c:	ff 75 08             	pushl  0x8(%ebp)
80105d8f:	e8 df c0 ff ff       	call   80101e73 <readi>
80105d94:	83 c4 10             	add    $0x10,%esp
80105d97:	83 f8 10             	cmp    $0x10,%eax
80105d9a:	74 0d                	je     80105da9 <isdirempty+0x36>
      panic("isdirempty: readi");
80105d9c:	83 ec 0c             	sub    $0xc,%esp
80105d9f:	68 1b 8f 10 80       	push   $0x80108f1b
80105da4:	e8 bd a7 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80105da9:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105dad:	66 85 c0             	test   %ax,%ax
80105db0:	74 07                	je     80105db9 <isdirempty+0x46>
      return 0;
80105db2:	b8 00 00 00 00       	mov    $0x0,%eax
80105db7:	eb 1b                	jmp    80105dd4 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dbc:	83 c0 10             	add    $0x10,%eax
80105dbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80105dc5:	8b 50 18             	mov    0x18(%eax),%edx
80105dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dcb:	39 c2                	cmp    %eax,%edx
80105dcd:	77 b3                	ja     80105d82 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105dcf:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105dd4:	c9                   	leave  
80105dd5:	c3                   	ret    

80105dd6 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105dd6:	55                   	push   %ebp
80105dd7:	89 e5                	mov    %esp,%ebp
80105dd9:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105ddc:	83 ec 08             	sub    $0x8,%esp
80105ddf:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105de2:	50                   	push   %eax
80105de3:	6a 00                	push   $0x0
80105de5:	e8 a0 fa ff ff       	call   8010588a <argstr>
80105dea:	83 c4 10             	add    $0x10,%esp
80105ded:	85 c0                	test   %eax,%eax
80105def:	79 0a                	jns    80105dfb <sys_unlink+0x25>
    return -1;
80105df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105df6:	e9 bc 01 00 00       	jmp    80105fb7 <sys_unlink+0x1e1>

  begin_op();
80105dfb:	e8 b4 d6 ff ff       	call   801034b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105e00:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105e03:	83 ec 08             	sub    $0x8,%esp
80105e06:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105e09:	52                   	push   %edx
80105e0a:	50                   	push   %eax
80105e0b:	e8 cf c6 ff ff       	call   801024df <nameiparent>
80105e10:	83 c4 10             	add    $0x10,%esp
80105e13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e1a:	75 0f                	jne    80105e2b <sys_unlink+0x55>
    end_op();
80105e1c:	e8 1f d7 ff ff       	call   80103540 <end_op>
    return -1;
80105e21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e26:	e9 8c 01 00 00       	jmp    80105fb7 <sys_unlink+0x1e1>
  }

  ilock(dp);
80105e2b:	83 ec 0c             	sub    $0xc,%esp
80105e2e:	ff 75 f4             	pushl  -0xc(%ebp)
80105e31:	e8 d5 ba ff ff       	call   8010190b <ilock>
80105e36:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105e39:	83 ec 08             	sub    $0x8,%esp
80105e3c:	68 2d 8f 10 80       	push   $0x80108f2d
80105e41:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e44:	50                   	push   %eax
80105e45:	e8 08 c3 ff ff       	call   80102152 <namecmp>
80105e4a:	83 c4 10             	add    $0x10,%esp
80105e4d:	85 c0                	test   %eax,%eax
80105e4f:	0f 84 4a 01 00 00    	je     80105f9f <sys_unlink+0x1c9>
80105e55:	83 ec 08             	sub    $0x8,%esp
80105e58:	68 2f 8f 10 80       	push   $0x80108f2f
80105e5d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e60:	50                   	push   %eax
80105e61:	e8 ec c2 ff ff       	call   80102152 <namecmp>
80105e66:	83 c4 10             	add    $0x10,%esp
80105e69:	85 c0                	test   %eax,%eax
80105e6b:	0f 84 2e 01 00 00    	je     80105f9f <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105e71:	83 ec 04             	sub    $0x4,%esp
80105e74:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105e77:	50                   	push   %eax
80105e78:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e7b:	50                   	push   %eax
80105e7c:	ff 75 f4             	pushl  -0xc(%ebp)
80105e7f:	e8 e9 c2 ff ff       	call   8010216d <dirlookup>
80105e84:	83 c4 10             	add    $0x10,%esp
80105e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e8e:	0f 84 0a 01 00 00    	je     80105f9e <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80105e94:	83 ec 0c             	sub    $0xc,%esp
80105e97:	ff 75 f0             	pushl  -0x10(%ebp)
80105e9a:	e8 6c ba ff ff       	call   8010190b <ilock>
80105e9f:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea5:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ea9:	66 85 c0             	test   %ax,%ax
80105eac:	7f 0d                	jg     80105ebb <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105eae:	83 ec 0c             	sub    $0xc,%esp
80105eb1:	68 32 8f 10 80       	push   $0x80108f32
80105eb6:	e8 ab a6 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ebe:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ec2:	66 83 f8 01          	cmp    $0x1,%ax
80105ec6:	75 25                	jne    80105eed <sys_unlink+0x117>
80105ec8:	83 ec 0c             	sub    $0xc,%esp
80105ecb:	ff 75 f0             	pushl  -0x10(%ebp)
80105ece:	e8 a0 fe ff ff       	call   80105d73 <isdirempty>
80105ed3:	83 c4 10             	add    $0x10,%esp
80105ed6:	85 c0                	test   %eax,%eax
80105ed8:	75 13                	jne    80105eed <sys_unlink+0x117>
    iunlockput(ip);
80105eda:	83 ec 0c             	sub    $0xc,%esp
80105edd:	ff 75 f0             	pushl  -0x10(%ebp)
80105ee0:	e8 e0 bc ff ff       	call   80101bc5 <iunlockput>
80105ee5:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105ee8:	e9 b2 00 00 00       	jmp    80105f9f <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105eed:	83 ec 04             	sub    $0x4,%esp
80105ef0:	6a 10                	push   $0x10
80105ef2:	6a 00                	push   $0x0
80105ef4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ef7:	50                   	push   %eax
80105ef8:	e8 e3 f5 ff ff       	call   801054e0 <memset>
80105efd:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f00:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105f03:	6a 10                	push   $0x10
80105f05:	50                   	push   %eax
80105f06:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f09:	50                   	push   %eax
80105f0a:	ff 75 f4             	pushl  -0xc(%ebp)
80105f0d:	e8 b8 c0 ff ff       	call   80101fca <writei>
80105f12:	83 c4 10             	add    $0x10,%esp
80105f15:	83 f8 10             	cmp    $0x10,%eax
80105f18:	74 0d                	je     80105f27 <sys_unlink+0x151>
    panic("unlink: writei");
80105f1a:	83 ec 0c             	sub    $0xc,%esp
80105f1d:	68 44 8f 10 80       	push   $0x80108f44
80105f22:	e8 3f a6 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80105f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f2a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f2e:	66 83 f8 01          	cmp    $0x1,%ax
80105f32:	75 21                	jne    80105f55 <sys_unlink+0x17f>
    dp->nlink--;
80105f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f37:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f3b:	83 e8 01             	sub    $0x1,%eax
80105f3e:	89 c2                	mov    %eax,%edx
80105f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f43:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105f47:	83 ec 0c             	sub    $0xc,%esp
80105f4a:	ff 75 f4             	pushl  -0xc(%ebp)
80105f4d:	e8 e5 b7 ff ff       	call   80101737 <iupdate>
80105f52:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105f55:	83 ec 0c             	sub    $0xc,%esp
80105f58:	ff 75 f4             	pushl  -0xc(%ebp)
80105f5b:	e8 65 bc ff ff       	call   80101bc5 <iunlockput>
80105f60:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f66:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f6a:	83 e8 01             	sub    $0x1,%eax
80105f6d:	89 c2                	mov    %eax,%edx
80105f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f72:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105f76:	83 ec 0c             	sub    $0xc,%esp
80105f79:	ff 75 f0             	pushl  -0x10(%ebp)
80105f7c:	e8 b6 b7 ff ff       	call   80101737 <iupdate>
80105f81:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105f84:	83 ec 0c             	sub    $0xc,%esp
80105f87:	ff 75 f0             	pushl  -0x10(%ebp)
80105f8a:	e8 36 bc ff ff       	call   80101bc5 <iunlockput>
80105f8f:	83 c4 10             	add    $0x10,%esp

  end_op();
80105f92:	e8 a9 d5 ff ff       	call   80103540 <end_op>

  return 0;
80105f97:	b8 00 00 00 00       	mov    $0x0,%eax
80105f9c:	eb 19                	jmp    80105fb7 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105f9e:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105f9f:	83 ec 0c             	sub    $0xc,%esp
80105fa2:	ff 75 f4             	pushl  -0xc(%ebp)
80105fa5:	e8 1b bc ff ff       	call   80101bc5 <iunlockput>
80105faa:	83 c4 10             	add    $0x10,%esp
  end_op();
80105fad:	e8 8e d5 ff ff       	call   80103540 <end_op>
  return -1;
80105fb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fb7:	c9                   	leave  
80105fb8:	c3                   	ret    

80105fb9 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105fb9:	55                   	push   %ebp
80105fba:	89 e5                	mov    %esp,%ebp
80105fbc:	83 ec 38             	sub    $0x38,%esp
80105fbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105fc2:	8b 55 10             	mov    0x10(%ebp),%edx
80105fc5:	8b 45 14             	mov    0x14(%ebp),%eax
80105fc8:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105fcc:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105fd0:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105fd4:	83 ec 08             	sub    $0x8,%esp
80105fd7:	8d 45 de             	lea    -0x22(%ebp),%eax
80105fda:	50                   	push   %eax
80105fdb:	ff 75 08             	pushl  0x8(%ebp)
80105fde:	e8 fc c4 ff ff       	call   801024df <nameiparent>
80105fe3:	83 c4 10             	add    $0x10,%esp
80105fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fed:	75 0a                	jne    80105ff9 <create+0x40>
    return 0;
80105fef:	b8 00 00 00 00       	mov    $0x0,%eax
80105ff4:	e9 90 01 00 00       	jmp    80106189 <create+0x1d0>
  ilock(dp);
80105ff9:	83 ec 0c             	sub    $0xc,%esp
80105ffc:	ff 75 f4             	pushl  -0xc(%ebp)
80105fff:	e8 07 b9 ff ff       	call   8010190b <ilock>
80106004:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80106007:	83 ec 04             	sub    $0x4,%esp
8010600a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010600d:	50                   	push   %eax
8010600e:	8d 45 de             	lea    -0x22(%ebp),%eax
80106011:	50                   	push   %eax
80106012:	ff 75 f4             	pushl  -0xc(%ebp)
80106015:	e8 53 c1 ff ff       	call   8010216d <dirlookup>
8010601a:	83 c4 10             	add    $0x10,%esp
8010601d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106020:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106024:	74 50                	je     80106076 <create+0xbd>
    iunlockput(dp);
80106026:	83 ec 0c             	sub    $0xc,%esp
80106029:	ff 75 f4             	pushl  -0xc(%ebp)
8010602c:	e8 94 bb ff ff       	call   80101bc5 <iunlockput>
80106031:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106034:	83 ec 0c             	sub    $0xc,%esp
80106037:	ff 75 f0             	pushl  -0x10(%ebp)
8010603a:	e8 cc b8 ff ff       	call   8010190b <ilock>
8010603f:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106042:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106047:	75 15                	jne    8010605e <create+0xa5>
80106049:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010604c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106050:	66 83 f8 02          	cmp    $0x2,%ax
80106054:	75 08                	jne    8010605e <create+0xa5>
      return ip;
80106056:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106059:	e9 2b 01 00 00       	jmp    80106189 <create+0x1d0>
    iunlockput(ip);
8010605e:	83 ec 0c             	sub    $0xc,%esp
80106061:	ff 75 f0             	pushl  -0x10(%ebp)
80106064:	e8 5c bb ff ff       	call   80101bc5 <iunlockput>
80106069:	83 c4 10             	add    $0x10,%esp
    return 0;
8010606c:	b8 00 00 00 00       	mov    $0x0,%eax
80106071:	e9 13 01 00 00       	jmp    80106189 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106076:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010607a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607d:	8b 00                	mov    (%eax),%eax
8010607f:	83 ec 08             	sub    $0x8,%esp
80106082:	52                   	push   %edx
80106083:	50                   	push   %eax
80106084:	e8 cd b5 ff ff       	call   80101656 <ialloc>
80106089:	83 c4 10             	add    $0x10,%esp
8010608c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010608f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106093:	75 0d                	jne    801060a2 <create+0xe9>
    panic("create: ialloc");
80106095:	83 ec 0c             	sub    $0xc,%esp
80106098:	68 53 8f 10 80       	push   $0x80108f53
8010609d:	e8 c4 a4 ff ff       	call   80100566 <panic>

  ilock(ip);
801060a2:	83 ec 0c             	sub    $0xc,%esp
801060a5:	ff 75 f0             	pushl  -0x10(%ebp)
801060a8:	e8 5e b8 ff ff       	call   8010190b <ilock>
801060ad:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801060b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060b3:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801060b7:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801060bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060be:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801060c2:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801060c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060c9:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801060cf:	83 ec 0c             	sub    $0xc,%esp
801060d2:	ff 75 f0             	pushl  -0x10(%ebp)
801060d5:	e8 5d b6 ff ff       	call   80101737 <iupdate>
801060da:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801060dd:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801060e2:	75 6a                	jne    8010614e <create+0x195>
    dp->nlink++;  // for ".."
801060e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e7:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060eb:	83 c0 01             	add    $0x1,%eax
801060ee:	89 c2                	mov    %eax,%edx
801060f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f3:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801060f7:	83 ec 0c             	sub    $0xc,%esp
801060fa:	ff 75 f4             	pushl  -0xc(%ebp)
801060fd:	e8 35 b6 ff ff       	call   80101737 <iupdate>
80106102:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106105:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106108:	8b 40 04             	mov    0x4(%eax),%eax
8010610b:	83 ec 04             	sub    $0x4,%esp
8010610e:	50                   	push   %eax
8010610f:	68 2d 8f 10 80       	push   $0x80108f2d
80106114:	ff 75 f0             	pushl  -0x10(%ebp)
80106117:	e8 0b c1 ff ff       	call   80102227 <dirlink>
8010611c:	83 c4 10             	add    $0x10,%esp
8010611f:	85 c0                	test   %eax,%eax
80106121:	78 1e                	js     80106141 <create+0x188>
80106123:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106126:	8b 40 04             	mov    0x4(%eax),%eax
80106129:	83 ec 04             	sub    $0x4,%esp
8010612c:	50                   	push   %eax
8010612d:	68 2f 8f 10 80       	push   $0x80108f2f
80106132:	ff 75 f0             	pushl  -0x10(%ebp)
80106135:	e8 ed c0 ff ff       	call   80102227 <dirlink>
8010613a:	83 c4 10             	add    $0x10,%esp
8010613d:	85 c0                	test   %eax,%eax
8010613f:	79 0d                	jns    8010614e <create+0x195>
      panic("create dots");
80106141:	83 ec 0c             	sub    $0xc,%esp
80106144:	68 62 8f 10 80       	push   $0x80108f62
80106149:	e8 18 a4 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010614e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106151:	8b 40 04             	mov    0x4(%eax),%eax
80106154:	83 ec 04             	sub    $0x4,%esp
80106157:	50                   	push   %eax
80106158:	8d 45 de             	lea    -0x22(%ebp),%eax
8010615b:	50                   	push   %eax
8010615c:	ff 75 f4             	pushl  -0xc(%ebp)
8010615f:	e8 c3 c0 ff ff       	call   80102227 <dirlink>
80106164:	83 c4 10             	add    $0x10,%esp
80106167:	85 c0                	test   %eax,%eax
80106169:	79 0d                	jns    80106178 <create+0x1bf>
    panic("create: dirlink");
8010616b:	83 ec 0c             	sub    $0xc,%esp
8010616e:	68 6e 8f 10 80       	push   $0x80108f6e
80106173:	e8 ee a3 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80106178:	83 ec 0c             	sub    $0xc,%esp
8010617b:	ff 75 f4             	pushl  -0xc(%ebp)
8010617e:	e8 42 ba ff ff       	call   80101bc5 <iunlockput>
80106183:	83 c4 10             	add    $0x10,%esp

  return ip;
80106186:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106189:	c9                   	leave  
8010618a:	c3                   	ret    

8010618b <sys_open>:

int
sys_open(void)
{
8010618b:	55                   	push   %ebp
8010618c:	89 e5                	mov    %esp,%ebp
8010618e:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106191:	83 ec 08             	sub    $0x8,%esp
80106194:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106197:	50                   	push   %eax
80106198:	6a 00                	push   $0x0
8010619a:	e8 eb f6 ff ff       	call   8010588a <argstr>
8010619f:	83 c4 10             	add    $0x10,%esp
801061a2:	85 c0                	test   %eax,%eax
801061a4:	78 15                	js     801061bb <sys_open+0x30>
801061a6:	83 ec 08             	sub    $0x8,%esp
801061a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061ac:	50                   	push   %eax
801061ad:	6a 01                	push   $0x1
801061af:	e8 51 f6 ff ff       	call   80105805 <argint>
801061b4:	83 c4 10             	add    $0x10,%esp
801061b7:	85 c0                	test   %eax,%eax
801061b9:	79 0a                	jns    801061c5 <sys_open+0x3a>
    return -1;
801061bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061c0:	e9 61 01 00 00       	jmp    80106326 <sys_open+0x19b>

  begin_op();
801061c5:	e8 ea d2 ff ff       	call   801034b4 <begin_op>

  if(omode & O_CREATE){
801061ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061cd:	25 00 02 00 00       	and    $0x200,%eax
801061d2:	85 c0                	test   %eax,%eax
801061d4:	74 2a                	je     80106200 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801061d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801061d9:	6a 00                	push   $0x0
801061db:	6a 00                	push   $0x0
801061dd:	6a 02                	push   $0x2
801061df:	50                   	push   %eax
801061e0:	e8 d4 fd ff ff       	call   80105fb9 <create>
801061e5:	83 c4 10             	add    $0x10,%esp
801061e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801061eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061ef:	75 75                	jne    80106266 <sys_open+0xdb>
      end_op();
801061f1:	e8 4a d3 ff ff       	call   80103540 <end_op>
      return -1;
801061f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061fb:	e9 26 01 00 00       	jmp    80106326 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106200:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106203:	83 ec 0c             	sub    $0xc,%esp
80106206:	50                   	push   %eax
80106207:	e8 b7 c2 ff ff       	call   801024c3 <namei>
8010620c:	83 c4 10             	add    $0x10,%esp
8010620f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106212:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106216:	75 0f                	jne    80106227 <sys_open+0x9c>
      end_op();
80106218:	e8 23 d3 ff ff       	call   80103540 <end_op>
      return -1;
8010621d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106222:	e9 ff 00 00 00       	jmp    80106326 <sys_open+0x19b>
    }
    ilock(ip);
80106227:	83 ec 0c             	sub    $0xc,%esp
8010622a:	ff 75 f4             	pushl  -0xc(%ebp)
8010622d:	e8 d9 b6 ff ff       	call   8010190b <ilock>
80106232:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106235:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106238:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010623c:	66 83 f8 01          	cmp    $0x1,%ax
80106240:	75 24                	jne    80106266 <sys_open+0xdb>
80106242:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106245:	85 c0                	test   %eax,%eax
80106247:	74 1d                	je     80106266 <sys_open+0xdb>
      iunlockput(ip);
80106249:	83 ec 0c             	sub    $0xc,%esp
8010624c:	ff 75 f4             	pushl  -0xc(%ebp)
8010624f:	e8 71 b9 ff ff       	call   80101bc5 <iunlockput>
80106254:	83 c4 10             	add    $0x10,%esp
      end_op();
80106257:	e8 e4 d2 ff ff       	call   80103540 <end_op>
      return -1;
8010625c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106261:	e9 c0 00 00 00       	jmp    80106326 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106266:	e8 0d ad ff ff       	call   80100f78 <filealloc>
8010626b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010626e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106272:	74 17                	je     8010628b <sys_open+0x100>
80106274:	83 ec 0c             	sub    $0xc,%esp
80106277:	ff 75 f0             	pushl  -0x10(%ebp)
8010627a:	e8 37 f7 ff ff       	call   801059b6 <fdalloc>
8010627f:	83 c4 10             	add    $0x10,%esp
80106282:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106285:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106289:	79 2e                	jns    801062b9 <sys_open+0x12e>
    if(f)
8010628b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010628f:	74 0e                	je     8010629f <sys_open+0x114>
      fileclose(f);
80106291:	83 ec 0c             	sub    $0xc,%esp
80106294:	ff 75 f0             	pushl  -0x10(%ebp)
80106297:	e8 9a ad ff ff       	call   80101036 <fileclose>
8010629c:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010629f:	83 ec 0c             	sub    $0xc,%esp
801062a2:	ff 75 f4             	pushl  -0xc(%ebp)
801062a5:	e8 1b b9 ff ff       	call   80101bc5 <iunlockput>
801062aa:	83 c4 10             	add    $0x10,%esp
    end_op();
801062ad:	e8 8e d2 ff ff       	call   80103540 <end_op>
    return -1;
801062b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b7:	eb 6d                	jmp    80106326 <sys_open+0x19b>
  }
  iunlock(ip);
801062b9:	83 ec 0c             	sub    $0xc,%esp
801062bc:	ff 75 f4             	pushl  -0xc(%ebp)
801062bf:	e8 9f b7 ff ff       	call   80101a63 <iunlock>
801062c4:	83 c4 10             	add    $0x10,%esp
  end_op();
801062c7:	e8 74 d2 ff ff       	call   80103540 <end_op>

  f->type = FD_INODE;
801062cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062cf:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801062d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062db:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801062de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062e1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801062e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062eb:	83 e0 01             	and    $0x1,%eax
801062ee:	85 c0                	test   %eax,%eax
801062f0:	0f 94 c0             	sete   %al
801062f3:	89 c2                	mov    %eax,%edx
801062f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f8:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801062fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062fe:	83 e0 01             	and    $0x1,%eax
80106301:	85 c0                	test   %eax,%eax
80106303:	75 0a                	jne    8010630f <sys_open+0x184>
80106305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106308:	83 e0 02             	and    $0x2,%eax
8010630b:	85 c0                	test   %eax,%eax
8010630d:	74 07                	je     80106316 <sys_open+0x18b>
8010630f:	b8 01 00 00 00       	mov    $0x1,%eax
80106314:	eb 05                	jmp    8010631b <sys_open+0x190>
80106316:	b8 00 00 00 00       	mov    $0x0,%eax
8010631b:	89 c2                	mov    %eax,%edx
8010631d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106320:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106323:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106326:	c9                   	leave  
80106327:	c3                   	ret    

80106328 <sys_mkdir>:

int
sys_mkdir(void)
{
80106328:	55                   	push   %ebp
80106329:	89 e5                	mov    %esp,%ebp
8010632b:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010632e:	e8 81 d1 ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106333:	83 ec 08             	sub    $0x8,%esp
80106336:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106339:	50                   	push   %eax
8010633a:	6a 00                	push   $0x0
8010633c:	e8 49 f5 ff ff       	call   8010588a <argstr>
80106341:	83 c4 10             	add    $0x10,%esp
80106344:	85 c0                	test   %eax,%eax
80106346:	78 1b                	js     80106363 <sys_mkdir+0x3b>
80106348:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010634b:	6a 00                	push   $0x0
8010634d:	6a 00                	push   $0x0
8010634f:	6a 01                	push   $0x1
80106351:	50                   	push   %eax
80106352:	e8 62 fc ff ff       	call   80105fb9 <create>
80106357:	83 c4 10             	add    $0x10,%esp
8010635a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010635d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106361:	75 0c                	jne    8010636f <sys_mkdir+0x47>
    end_op();
80106363:	e8 d8 d1 ff ff       	call   80103540 <end_op>
    return -1;
80106368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010636d:	eb 18                	jmp    80106387 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010636f:	83 ec 0c             	sub    $0xc,%esp
80106372:	ff 75 f4             	pushl  -0xc(%ebp)
80106375:	e8 4b b8 ff ff       	call   80101bc5 <iunlockput>
8010637a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010637d:	e8 be d1 ff ff       	call   80103540 <end_op>
  return 0;
80106382:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106387:	c9                   	leave  
80106388:	c3                   	ret    

80106389 <sys_mknod>:

int
sys_mknod(void)
{
80106389:	55                   	push   %ebp
8010638a:	89 e5                	mov    %esp,%ebp
8010638c:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010638f:	e8 20 d1 ff ff       	call   801034b4 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106394:	83 ec 08             	sub    $0x8,%esp
80106397:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010639a:	50                   	push   %eax
8010639b:	6a 00                	push   $0x0
8010639d:	e8 e8 f4 ff ff       	call   8010588a <argstr>
801063a2:	83 c4 10             	add    $0x10,%esp
801063a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063ac:	78 4f                	js     801063fd <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801063ae:	83 ec 08             	sub    $0x8,%esp
801063b1:	8d 45 e8             	lea    -0x18(%ebp),%eax
801063b4:	50                   	push   %eax
801063b5:	6a 01                	push   $0x1
801063b7:	e8 49 f4 ff ff       	call   80105805 <argint>
801063bc:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801063bf:	85 c0                	test   %eax,%eax
801063c1:	78 3a                	js     801063fd <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801063c3:	83 ec 08             	sub    $0x8,%esp
801063c6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801063c9:	50                   	push   %eax
801063ca:	6a 02                	push   $0x2
801063cc:	e8 34 f4 ff ff       	call   80105805 <argint>
801063d1:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801063d4:	85 c0                	test   %eax,%eax
801063d6:	78 25                	js     801063fd <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801063d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063db:	0f bf c8             	movswl %ax,%ecx
801063de:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063e1:	0f bf d0             	movswl %ax,%edx
801063e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801063e7:	51                   	push   %ecx
801063e8:	52                   	push   %edx
801063e9:	6a 03                	push   $0x3
801063eb:	50                   	push   %eax
801063ec:	e8 c8 fb ff ff       	call   80105fb9 <create>
801063f1:	83 c4 10             	add    $0x10,%esp
801063f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063fb:	75 0c                	jne    80106409 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801063fd:	e8 3e d1 ff ff       	call   80103540 <end_op>
    return -1;
80106402:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106407:	eb 18                	jmp    80106421 <sys_mknod+0x98>
  }
  iunlockput(ip);
80106409:	83 ec 0c             	sub    $0xc,%esp
8010640c:	ff 75 f0             	pushl  -0x10(%ebp)
8010640f:	e8 b1 b7 ff ff       	call   80101bc5 <iunlockput>
80106414:	83 c4 10             	add    $0x10,%esp
  end_op();
80106417:	e8 24 d1 ff ff       	call   80103540 <end_op>
  return 0;
8010641c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106421:	c9                   	leave  
80106422:	c3                   	ret    

80106423 <sys_chdir>:

int
sys_chdir(void)
{
80106423:	55                   	push   %ebp
80106424:	89 e5                	mov    %esp,%ebp
80106426:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106429:	e8 86 d0 ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010642e:	83 ec 08             	sub    $0x8,%esp
80106431:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106434:	50                   	push   %eax
80106435:	6a 00                	push   $0x0
80106437:	e8 4e f4 ff ff       	call   8010588a <argstr>
8010643c:	83 c4 10             	add    $0x10,%esp
8010643f:	85 c0                	test   %eax,%eax
80106441:	78 18                	js     8010645b <sys_chdir+0x38>
80106443:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106446:	83 ec 0c             	sub    $0xc,%esp
80106449:	50                   	push   %eax
8010644a:	e8 74 c0 ff ff       	call   801024c3 <namei>
8010644f:	83 c4 10             	add    $0x10,%esp
80106452:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106459:	75 0c                	jne    80106467 <sys_chdir+0x44>
    end_op();
8010645b:	e8 e0 d0 ff ff       	call   80103540 <end_op>
    return -1;
80106460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106465:	eb 6e                	jmp    801064d5 <sys_chdir+0xb2>
  }
  ilock(ip);
80106467:	83 ec 0c             	sub    $0xc,%esp
8010646a:	ff 75 f4             	pushl  -0xc(%ebp)
8010646d:	e8 99 b4 ff ff       	call   8010190b <ilock>
80106472:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106475:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106478:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010647c:	66 83 f8 01          	cmp    $0x1,%ax
80106480:	74 1a                	je     8010649c <sys_chdir+0x79>
    iunlockput(ip);
80106482:	83 ec 0c             	sub    $0xc,%esp
80106485:	ff 75 f4             	pushl  -0xc(%ebp)
80106488:	e8 38 b7 ff ff       	call   80101bc5 <iunlockput>
8010648d:	83 c4 10             	add    $0x10,%esp
    end_op();
80106490:	e8 ab d0 ff ff       	call   80103540 <end_op>
    return -1;
80106495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010649a:	eb 39                	jmp    801064d5 <sys_chdir+0xb2>
  }
  iunlock(ip);
8010649c:	83 ec 0c             	sub    $0xc,%esp
8010649f:	ff 75 f4             	pushl  -0xc(%ebp)
801064a2:	e8 bc b5 ff ff       	call   80101a63 <iunlock>
801064a7:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801064aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064b0:	8b 40 68             	mov    0x68(%eax),%eax
801064b3:	83 ec 0c             	sub    $0xc,%esp
801064b6:	50                   	push   %eax
801064b7:	e8 19 b6 ff ff       	call   80101ad5 <iput>
801064bc:	83 c4 10             	add    $0x10,%esp
  end_op();
801064bf:	e8 7c d0 ff ff       	call   80103540 <end_op>
  proc->cwd = ip;
801064c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064cd:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801064d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064d5:	c9                   	leave  
801064d6:	c3                   	ret    

801064d7 <sys_exec>:

int
sys_exec(void)
{
801064d7:	55                   	push   %ebp
801064d8:	89 e5                	mov    %esp,%ebp
801064da:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801064e0:	83 ec 08             	sub    $0x8,%esp
801064e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064e6:	50                   	push   %eax
801064e7:	6a 00                	push   $0x0
801064e9:	e8 9c f3 ff ff       	call   8010588a <argstr>
801064ee:	83 c4 10             	add    $0x10,%esp
801064f1:	85 c0                	test   %eax,%eax
801064f3:	78 18                	js     8010650d <sys_exec+0x36>
801064f5:	83 ec 08             	sub    $0x8,%esp
801064f8:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801064fe:	50                   	push   %eax
801064ff:	6a 01                	push   $0x1
80106501:	e8 ff f2 ff ff       	call   80105805 <argint>
80106506:	83 c4 10             	add    $0x10,%esp
80106509:	85 c0                	test   %eax,%eax
8010650b:	79 0a                	jns    80106517 <sys_exec+0x40>
    return -1;
8010650d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106512:	e9 c6 00 00 00       	jmp    801065dd <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106517:	83 ec 04             	sub    $0x4,%esp
8010651a:	68 80 00 00 00       	push   $0x80
8010651f:	6a 00                	push   $0x0
80106521:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106527:	50                   	push   %eax
80106528:	e8 b3 ef ff ff       	call   801054e0 <memset>
8010652d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106530:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010653a:	83 f8 1f             	cmp    $0x1f,%eax
8010653d:	76 0a                	jbe    80106549 <sys_exec+0x72>
      return -1;
8010653f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106544:	e9 94 00 00 00       	jmp    801065dd <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106549:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010654c:	c1 e0 02             	shl    $0x2,%eax
8010654f:	89 c2                	mov    %eax,%edx
80106551:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106557:	01 c2                	add    %eax,%edx
80106559:	83 ec 08             	sub    $0x8,%esp
8010655c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106562:	50                   	push   %eax
80106563:	52                   	push   %edx
80106564:	e8 00 f2 ff ff       	call   80105769 <fetchint>
80106569:	83 c4 10             	add    $0x10,%esp
8010656c:	85 c0                	test   %eax,%eax
8010656e:	79 07                	jns    80106577 <sys_exec+0xa0>
      return -1;
80106570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106575:	eb 66                	jmp    801065dd <sys_exec+0x106>
    if(uarg == 0){
80106577:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010657d:	85 c0                	test   %eax,%eax
8010657f:	75 27                	jne    801065a8 <sys_exec+0xd1>
      argv[i] = 0;
80106581:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106584:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010658b:	00 00 00 00 
      break;
8010658f:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106590:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106593:	83 ec 08             	sub    $0x8,%esp
80106596:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010659c:	52                   	push   %edx
8010659d:	50                   	push   %eax
8010659e:	e8 b3 a5 ff ff       	call   80100b56 <exec>
801065a3:	83 c4 10             	add    $0x10,%esp
801065a6:	eb 35                	jmp    801065dd <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801065a8:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801065ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065b1:	c1 e2 02             	shl    $0x2,%edx
801065b4:	01 c2                	add    %eax,%edx
801065b6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801065bc:	83 ec 08             	sub    $0x8,%esp
801065bf:	52                   	push   %edx
801065c0:	50                   	push   %eax
801065c1:	e8 dd f1 ff ff       	call   801057a3 <fetchstr>
801065c6:	83 c4 10             	add    $0x10,%esp
801065c9:	85 c0                	test   %eax,%eax
801065cb:	79 07                	jns    801065d4 <sys_exec+0xfd>
      return -1;
801065cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065d2:	eb 09                	jmp    801065dd <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801065d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801065d8:	e9 5a ff ff ff       	jmp    80106537 <sys_exec+0x60>
  return exec(path, argv);
}
801065dd:	c9                   	leave  
801065de:	c3                   	ret    

801065df <sys_pipe>:

int
sys_pipe(void)
{
801065df:	55                   	push   %ebp
801065e0:	89 e5                	mov    %esp,%ebp
801065e2:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801065e5:	83 ec 04             	sub    $0x4,%esp
801065e8:	6a 08                	push   $0x8
801065ea:	8d 45 ec             	lea    -0x14(%ebp),%eax
801065ed:	50                   	push   %eax
801065ee:	6a 00                	push   $0x0
801065f0:	e8 38 f2 ff ff       	call   8010582d <argptr>
801065f5:	83 c4 10             	add    $0x10,%esp
801065f8:	85 c0                	test   %eax,%eax
801065fa:	79 0a                	jns    80106606 <sys_pipe+0x27>
    return -1;
801065fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106601:	e9 af 00 00 00       	jmp    801066b5 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106606:	83 ec 08             	sub    $0x8,%esp
80106609:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010660c:	50                   	push   %eax
8010660d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106610:	50                   	push   %eax
80106611:	e8 77 d9 ff ff       	call   80103f8d <pipealloc>
80106616:	83 c4 10             	add    $0x10,%esp
80106619:	85 c0                	test   %eax,%eax
8010661b:	79 0a                	jns    80106627 <sys_pipe+0x48>
    return -1;
8010661d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106622:	e9 8e 00 00 00       	jmp    801066b5 <sys_pipe+0xd6>
  fd0 = -1;
80106627:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010662e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106631:	83 ec 0c             	sub    $0xc,%esp
80106634:	50                   	push   %eax
80106635:	e8 7c f3 ff ff       	call   801059b6 <fdalloc>
8010663a:	83 c4 10             	add    $0x10,%esp
8010663d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106640:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106644:	78 18                	js     8010665e <sys_pipe+0x7f>
80106646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106649:	83 ec 0c             	sub    $0xc,%esp
8010664c:	50                   	push   %eax
8010664d:	e8 64 f3 ff ff       	call   801059b6 <fdalloc>
80106652:	83 c4 10             	add    $0x10,%esp
80106655:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106658:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010665c:	79 3f                	jns    8010669d <sys_pipe+0xbe>
    if(fd0 >= 0)
8010665e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106662:	78 14                	js     80106678 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106664:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010666a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010666d:	83 c2 08             	add    $0x8,%edx
80106670:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106677:	00 
    fileclose(rf);
80106678:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010667b:	83 ec 0c             	sub    $0xc,%esp
8010667e:	50                   	push   %eax
8010667f:	e8 b2 a9 ff ff       	call   80101036 <fileclose>
80106684:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010668a:	83 ec 0c             	sub    $0xc,%esp
8010668d:	50                   	push   %eax
8010668e:	e8 a3 a9 ff ff       	call   80101036 <fileclose>
80106693:	83 c4 10             	add    $0x10,%esp
    return -1;
80106696:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010669b:	eb 18                	jmp    801066b5 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
8010669d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801066a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066a3:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801066a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801066a8:	8d 50 04             	lea    0x4(%eax),%edx
801066ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066ae:	89 02                	mov    %eax,(%edx)
  return 0;
801066b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066b5:	c9                   	leave  
801066b6:	c3                   	ret    

801066b7 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
801066b7:	55                   	push   %ebp
801066b8:	89 e5                	mov    %esp,%ebp
801066ba:	83 ec 08             	sub    $0x8,%esp
801066bd:	8b 55 08             	mov    0x8(%ebp),%edx
801066c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801066c3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801066c7:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801066cb:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
801066cf:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801066d3:	66 ef                	out    %ax,(%dx)
}
801066d5:	90                   	nop
801066d6:	c9                   	leave  
801066d7:	c3                   	ret    

801066d8 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801066d8:	55                   	push   %ebp
801066d9:	89 e5                	mov    %esp,%ebp
801066db:	83 ec 08             	sub    $0x8,%esp
  return fork();
801066de:	e8 ca df ff ff       	call   801046ad <fork>
}
801066e3:	c9                   	leave  
801066e4:	c3                   	ret    

801066e5 <sys_exit>:


int
sys_exit(void)
{
801066e5:	55                   	push   %ebp
801066e6:	89 e5                	mov    %esp,%ebp
801066e8:	83 ec 08             	sub    $0x8,%esp
  exit();
801066eb:	e8 df e2 ff ff       	call   801049cf <exit>
  return 0;  // not reached
801066f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066f5:	c9                   	leave  
801066f6:	c3                   	ret    

801066f7 <sys_wait>:

int
sys_wait(void)
{
801066f7:	55                   	push   %ebp
801066f8:	89 e5                	mov    %esp,%ebp
801066fa:	83 ec 08             	sub    $0x8,%esp
  return wait();
801066fd:	e8 08 e4 ff ff       	call   80104b0a <wait>
}
80106702:	c9                   	leave  
80106703:	c3                   	ret    

80106704 <sys_kill>:

int
sys_kill(void)
{
80106704:	55                   	push   %ebp
80106705:	89 e5                	mov    %esp,%ebp
80106707:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010670a:	83 ec 08             	sub    $0x8,%esp
8010670d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106710:	50                   	push   %eax
80106711:	6a 00                	push   $0x0
80106713:	e8 ed f0 ff ff       	call   80105805 <argint>
80106718:	83 c4 10             	add    $0x10,%esp
8010671b:	85 c0                	test   %eax,%eax
8010671d:	79 07                	jns    80106726 <sys_kill+0x22>
    return -1;
8010671f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106724:	eb 0f                	jmp    80106735 <sys_kill+0x31>
  return kill(pid);
80106726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106729:	83 ec 0c             	sub    $0xc,%esp
8010672c:	50                   	push   %eax
8010672d:	e8 f4 e7 ff ff       	call   80104f26 <kill>
80106732:	83 c4 10             	add    $0x10,%esp
}
80106735:	c9                   	leave  
80106736:	c3                   	ret    

80106737 <sys_getpid>:

int
sys_getpid(void)
{
80106737:	55                   	push   %ebp
80106738:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010673a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106740:	8b 40 10             	mov    0x10(%eax),%eax
}
80106743:	5d                   	pop    %ebp
80106744:	c3                   	ret    

80106745 <sys_sbrk>:

int
sys_sbrk(void)
{
80106745:	55                   	push   %ebp
80106746:	89 e5                	mov    %esp,%ebp
80106748:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010674b:	83 ec 08             	sub    $0x8,%esp
8010674e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106751:	50                   	push   %eax
80106752:	6a 00                	push   $0x0
80106754:	e8 ac f0 ff ff       	call   80105805 <argint>
80106759:	83 c4 10             	add    $0x10,%esp
8010675c:	85 c0                	test   %eax,%eax
8010675e:	79 07                	jns    80106767 <sys_sbrk+0x22>
    return -1;
80106760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106765:	eb 28                	jmp    8010678f <sys_sbrk+0x4a>
  addr = proc->sz;
80106767:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010676d:	8b 00                	mov    (%eax),%eax
8010676f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106772:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106775:	83 ec 0c             	sub    $0xc,%esp
80106778:	50                   	push   %eax
80106779:	e8 8c de ff ff       	call   8010460a <growproc>
8010677e:	83 c4 10             	add    $0x10,%esp
80106781:	85 c0                	test   %eax,%eax
80106783:	79 07                	jns    8010678c <sys_sbrk+0x47>
    return -1;
80106785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010678a:	eb 03                	jmp    8010678f <sys_sbrk+0x4a>
  return addr;
8010678c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010678f:	c9                   	leave  
80106790:	c3                   	ret    

80106791 <sys_sleep>:

int
sys_sleep(void)
{
80106791:	55                   	push   %ebp
80106792:	89 e5                	mov    %esp,%ebp
80106794:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106797:	83 ec 08             	sub    $0x8,%esp
8010679a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010679d:	50                   	push   %eax
8010679e:	6a 00                	push   $0x0
801067a0:	e8 60 f0 ff ff       	call   80105805 <argint>
801067a5:	83 c4 10             	add    $0x10,%esp
801067a8:	85 c0                	test   %eax,%eax
801067aa:	79 07                	jns    801067b3 <sys_sleep+0x22>
    return -1;
801067ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067b1:	eb 77                	jmp    8010682a <sys_sleep+0x99>
  acquire(&tickslock);
801067b3:	83 ec 0c             	sub    $0xc,%esp
801067b6:	68 c0 5b 11 80       	push   $0x80115bc0
801067bb:	e8 bd ea ff ff       	call   8010527d <acquire>
801067c0:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801067c3:	a1 00 64 11 80       	mov    0x80116400,%eax
801067c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801067cb:	eb 39                	jmp    80106806 <sys_sleep+0x75>
    if(proc->killed){
801067cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067d3:	8b 40 24             	mov    0x24(%eax),%eax
801067d6:	85 c0                	test   %eax,%eax
801067d8:	74 17                	je     801067f1 <sys_sleep+0x60>
      release(&tickslock);
801067da:	83 ec 0c             	sub    $0xc,%esp
801067dd:	68 c0 5b 11 80       	push   $0x80115bc0
801067e2:	e8 fd ea ff ff       	call   801052e4 <release>
801067e7:	83 c4 10             	add    $0x10,%esp
      return -1;
801067ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067ef:	eb 39                	jmp    8010682a <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
801067f1:	83 ec 08             	sub    $0x8,%esp
801067f4:	68 c0 5b 11 80       	push   $0x80115bc0
801067f9:	68 00 64 11 80       	push   $0x80116400
801067fe:	e8 fe e5 ff ff       	call   80104e01 <sleep>
80106803:	83 c4 10             	add    $0x10,%esp

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106806:	a1 00 64 11 80       	mov    0x80116400,%eax
8010680b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010680e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106811:	39 d0                	cmp    %edx,%eax
80106813:	72 b8                	jb     801067cd <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106815:	83 ec 0c             	sub    $0xc,%esp
80106818:	68 c0 5b 11 80       	push   $0x80115bc0
8010681d:	e8 c2 ea ff ff       	call   801052e4 <release>
80106822:	83 c4 10             	add    $0x10,%esp
  return 0;
80106825:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010682a:	c9                   	leave  
8010682b:	c3                   	ret    

8010682c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010682c:	55                   	push   %ebp
8010682d:	89 e5                	mov    %esp,%ebp
8010682f:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106832:	83 ec 0c             	sub    $0xc,%esp
80106835:	68 c0 5b 11 80       	push   $0x80115bc0
8010683a:	e8 3e ea ff ff       	call   8010527d <acquire>
8010683f:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106842:	a1 00 64 11 80       	mov    0x80116400,%eax
80106847:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010684a:	83 ec 0c             	sub    $0xc,%esp
8010684d:	68 c0 5b 11 80       	push   $0x80115bc0
80106852:	e8 8d ea ff ff       	call   801052e4 <release>
80106857:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010685a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010685d:	c9                   	leave  
8010685e:	c3                   	ret    

8010685f <sys_halt>:
// signal to QEMU.
// Based on: http://pdos.csail.mit.edu/6.828/2012/homework/xv6-syscall.html
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
8010685f:	55                   	push   %ebp
80106860:	89 e5                	mov    %esp,%ebp
80106862:	83 ec 10             	sub    $0x10,%esp
  char *p = "Shutdown";
80106865:	c7 45 fc 7e 8f 10 80 	movl   $0x80108f7e,-0x4(%ebp)
  for( ; *p; p++)
8010686c:	eb 16                	jmp    80106884 <sys_halt+0x25>
    outw(0xB004, 0x2000);
8010686e:	68 00 20 00 00       	push   $0x2000
80106873:	68 04 b0 00 00       	push   $0xb004
80106878:	e8 3a fe ff ff       	call   801066b7 <outw>
8010687d:	83 c4 08             	add    $0x8,%esp
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
  char *p = "Shutdown";
  for( ; *p; p++)
80106880:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106884:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106887:	0f b6 00             	movzbl (%eax),%eax
8010688a:	84 c0                	test   %al,%al
8010688c:	75 e0                	jne    8010686e <sys_halt+0xf>
    outw(0xB004, 0x2000);
  return 0;
8010688e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106893:	c9                   	leave  
80106894:	c3                   	ret    

80106895 <sys_mprotect>:

int sys_mprotect(void)
{
80106895:	55                   	push   %ebp
80106896:	89 e5                	mov    %esp,%ebp
80106898:	83 ec 18             	sub    $0x18,%esp
  int addr,len,prot;

  if(argint(0, &addr) <0)
8010689b:	83 ec 08             	sub    $0x8,%esp
8010689e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068a1:	50                   	push   %eax
801068a2:	6a 00                	push   $0x0
801068a4:	e8 5c ef ff ff       	call   80105805 <argint>
801068a9:	83 c4 10             	add    $0x10,%esp
801068ac:	85 c0                	test   %eax,%eax
801068ae:	79 07                	jns    801068b7 <sys_mprotect+0x22>
    return -1;
801068b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068b5:	eb 4f                	jmp    80106906 <sys_mprotect+0x71>
  if(argint(1,&len) <0)
801068b7:	83 ec 08             	sub    $0x8,%esp
801068ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068bd:	50                   	push   %eax
801068be:	6a 01                	push   $0x1
801068c0:	e8 40 ef ff ff       	call   80105805 <argint>
801068c5:	83 c4 10             	add    $0x10,%esp
801068c8:	85 c0                	test   %eax,%eax
801068ca:	79 07                	jns    801068d3 <sys_mprotect+0x3e>
    return -1;
801068cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d1:	eb 33                	jmp    80106906 <sys_mprotect+0x71>
  if(argint(2,&prot) <0)
801068d3:	83 ec 08             	sub    $0x8,%esp
801068d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801068d9:	50                   	push   %eax
801068da:	6a 02                	push   $0x2
801068dc:	e8 24 ef ff ff       	call   80105805 <argint>
801068e1:	83 c4 10             	add    $0x10,%esp
801068e4:	85 c0                	test   %eax,%eax
801068e6:	79 07                	jns    801068ef <sys_mprotect+0x5a>
    return -1;
801068e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ed:	eb 17                	jmp    80106906 <sys_mprotect+0x71>

  return mprotect((void*)addr,len,prot);
801068ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
801068f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068f5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801068f8:	83 ec 04             	sub    $0x4,%esp
801068fb:	52                   	push   %edx
801068fc:	50                   	push   %eax
801068fd:	51                   	push   %ecx
801068fe:	e8 71 1c 00 00       	call   80108574 <mprotect>
80106903:	83 c4 10             	add    $0x10,%esp
}
80106906:	c9                   	leave  
80106907:	c3                   	ret    

80106908 <sys_signal_register>:

int sys_signal_register(void)
{
80106908:	55                   	push   %ebp
80106909:	89 e5                	mov    %esp,%ebp
8010690b:	83 ec 18             	sub    $0x18,%esp
    uint signum;
    sighandler_t handler;
    int n;

    if (argint(0, &n) < 0)
8010690e:	83 ec 08             	sub    $0x8,%esp
80106911:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106914:	50                   	push   %eax
80106915:	6a 00                	push   $0x0
80106917:	e8 e9 ee ff ff       	call   80105805 <argint>
8010691c:	83 c4 10             	add    $0x10,%esp
8010691f:	85 c0                	test   %eax,%eax
80106921:	79 07                	jns    8010692a <sys_signal_register+0x22>
      return -1;
80106923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106928:	eb 3a                	jmp    80106964 <sys_signal_register+0x5c>
    signum = (uint) n;
8010692a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010692d:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (argint(1, &n) < 0)
80106930:	83 ec 08             	sub    $0x8,%esp
80106933:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106936:	50                   	push   %eax
80106937:	6a 01                	push   $0x1
80106939:	e8 c7 ee ff ff       	call   80105805 <argint>
8010693e:	83 c4 10             	add    $0x10,%esp
80106941:	85 c0                	test   %eax,%eax
80106943:	79 07                	jns    8010694c <sys_signal_register+0x44>
      return -1;
80106945:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010694a:	eb 18                	jmp    80106964 <sys_signal_register+0x5c>
    handler = (sighandler_t) n;
8010694c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010694f:	89 45 f0             	mov    %eax,-0x10(%ebp)

    return (int) signal_register_handler(signum, handler);
80106952:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106955:	83 ec 08             	sub    $0x8,%esp
80106958:	ff 75 f0             	pushl  -0x10(%ebp)
8010695b:	50                   	push   %eax
8010695c:	e8 80 e8 ff ff       	call   801051e1 <signal_register_handler>
80106961:	83 c4 10             	add    $0x10,%esp
}
80106964:	c9                   	leave  
80106965:	c3                   	ret    

80106966 <sys_cowfork>:
int sys_cowfork(void)
{
80106966:	55                   	push   %ebp
80106967:	89 e5                	mov    %esp,%ebp
80106969:	83 ec 08             	sub    $0x8,%esp
  return cowfork();
8010696c:	e8 cd de ff ff       	call   8010483e <cowfork>
}
80106971:	c9                   	leave  
80106972:	c3                   	ret    

80106973 <sys_signal_restorer>:
int sys_signal_restorer(void)
{
80106973:	55                   	push   %ebp
80106974:	89 e5                	mov    %esp,%ebp
80106976:	83 ec 18             	sub    $0x18,%esp
    int restorer_addr;
    if (argint(0, &restorer_addr) < 0)
80106979:	83 ec 08             	sub    $0x8,%esp
8010697c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010697f:	50                   	push   %eax
80106980:	6a 00                	push   $0x0
80106982:	e8 7e ee ff ff       	call   80105805 <argint>
80106987:	83 c4 10             	add    $0x10,%esp
8010698a:	85 c0                	test   %eax,%eax
8010698c:	79 07                	jns    80106995 <sys_signal_restorer+0x22>
      return -1;
8010698e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106993:	eb 14                	jmp    801069a9 <sys_signal_restorer+0x36>

    proc->restorer_addr = (uint) restorer_addr;
80106995:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010699b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010699e:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

    return 0;
801069a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069a9:	c9                   	leave  
801069aa:	c3                   	ret    

801069ab <outb>:
801069ab:	55                   	push   %ebp
801069ac:	89 e5                	mov    %esp,%ebp
801069ae:	83 ec 08             	sub    $0x8,%esp
801069b1:	8b 55 08             	mov    0x8(%ebp),%edx
801069b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801069b7:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801069bb:	88 45 f8             	mov    %al,-0x8(%ebp)
801069be:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801069c2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801069c6:	ee                   	out    %al,(%dx)
801069c7:	90                   	nop
801069c8:	c9                   	leave  
801069c9:	c3                   	ret    

801069ca <timerinit>:
801069ca:	55                   	push   %ebp
801069cb:	89 e5                	mov    %esp,%ebp
801069cd:	83 ec 08             	sub    $0x8,%esp
801069d0:	6a 34                	push   $0x34
801069d2:	6a 43                	push   $0x43
801069d4:	e8 d2 ff ff ff       	call   801069ab <outb>
801069d9:	83 c4 08             	add    $0x8,%esp
801069dc:	68 9c 00 00 00       	push   $0x9c
801069e1:	6a 40                	push   $0x40
801069e3:	e8 c3 ff ff ff       	call   801069ab <outb>
801069e8:	83 c4 08             	add    $0x8,%esp
801069eb:	6a 2e                	push   $0x2e
801069ed:	6a 40                	push   $0x40
801069ef:	e8 b7 ff ff ff       	call   801069ab <outb>
801069f4:	83 c4 08             	add    $0x8,%esp
801069f7:	83 ec 0c             	sub    $0xc,%esp
801069fa:	6a 00                	push   $0x0
801069fc:	e8 76 d4 ff ff       	call   80103e77 <picenable>
80106a01:	83 c4 10             	add    $0x10,%esp
80106a04:	90                   	nop
80106a05:	c9                   	leave  
80106a06:	c3                   	ret    

80106a07 <alltraps>:
80106a07:	1e                   	push   %ds
80106a08:	06                   	push   %es
80106a09:	0f a0                	push   %fs
80106a0b:	0f a8                	push   %gs
80106a0d:	60                   	pusha  
80106a0e:	66 b8 10 00          	mov    $0x10,%ax
80106a12:	8e d8                	mov    %eax,%ds
80106a14:	8e c0                	mov    %eax,%es
80106a16:	66 b8 18 00          	mov    $0x18,%ax
80106a1a:	8e e0                	mov    %eax,%fs
80106a1c:	8e e8                	mov    %eax,%gs
80106a1e:	54                   	push   %esp
80106a1f:	e8 d7 01 00 00       	call   80106bfb <trap>
80106a24:	83 c4 04             	add    $0x4,%esp

80106a27 <trapret>:
80106a27:	61                   	popa   
80106a28:	0f a9                	pop    %gs
80106a2a:	0f a1                	pop    %fs
80106a2c:	07                   	pop    %es
80106a2d:	1f                   	pop    %ds
80106a2e:	83 c4 08             	add    $0x8,%esp
80106a31:	cf                   	iret   

80106a32 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106a32:	55                   	push   %ebp
80106a33:	89 e5                	mov    %esp,%ebp
80106a35:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106a38:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a3b:	83 e8 01             	sub    $0x1,%eax
80106a3e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a42:	8b 45 08             	mov    0x8(%ebp),%eax
80106a45:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106a49:	8b 45 08             	mov    0x8(%ebp),%eax
80106a4c:	c1 e8 10             	shr    $0x10,%eax
80106a4f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106a53:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106a56:	0f 01 18             	lidtl  (%eax)
}
80106a59:	90                   	nop
80106a5a:	c9                   	leave  
80106a5b:	c3                   	ret    

80106a5c <rcr2>:
  asm volatile("movl %eax,%cr3");
}

static inline uint
rcr2(void)
{
80106a5c:	55                   	push   %ebp
80106a5d:	89 e5                	mov    %esp,%ebp
80106a5f:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106a62:	0f 20 d0             	mov    %cr2,%eax
80106a65:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106a68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106a6b:	c9                   	leave  
80106a6c:	c3                   	ret    

80106a6d <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106a6d:	55                   	push   %ebp
80106a6e:	89 e5                	mov    %esp,%ebp
80106a70:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106a73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106a7a:	e9 c3 00 00 00       	jmp    80106b42 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a82:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106a89:	89 c2                	mov    %eax,%edx
80106a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a8e:	66 89 14 c5 00 5c 11 	mov    %dx,-0x7feea400(,%eax,8)
80106a95:	80 
80106a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a99:	66 c7 04 c5 02 5c 11 	movw   $0x8,-0x7feea3fe(,%eax,8)
80106aa0:	80 08 00 
80106aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aa6:	0f b6 14 c5 04 5c 11 	movzbl -0x7feea3fc(,%eax,8),%edx
80106aad:	80 
80106aae:	83 e2 e0             	and    $0xffffffe0,%edx
80106ab1:	88 14 c5 04 5c 11 80 	mov    %dl,-0x7feea3fc(,%eax,8)
80106ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106abb:	0f b6 14 c5 04 5c 11 	movzbl -0x7feea3fc(,%eax,8),%edx
80106ac2:	80 
80106ac3:	83 e2 1f             	and    $0x1f,%edx
80106ac6:	88 14 c5 04 5c 11 80 	mov    %dl,-0x7feea3fc(,%eax,8)
80106acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ad0:	0f b6 14 c5 05 5c 11 	movzbl -0x7feea3fb(,%eax,8),%edx
80106ad7:	80 
80106ad8:	83 e2 f0             	and    $0xfffffff0,%edx
80106adb:	83 ca 0e             	or     $0xe,%edx
80106ade:	88 14 c5 05 5c 11 80 	mov    %dl,-0x7feea3fb(,%eax,8)
80106ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ae8:	0f b6 14 c5 05 5c 11 	movzbl -0x7feea3fb(,%eax,8),%edx
80106aef:	80 
80106af0:	83 e2 ef             	and    $0xffffffef,%edx
80106af3:	88 14 c5 05 5c 11 80 	mov    %dl,-0x7feea3fb(,%eax,8)
80106afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106afd:	0f b6 14 c5 05 5c 11 	movzbl -0x7feea3fb(,%eax,8),%edx
80106b04:	80 
80106b05:	83 e2 9f             	and    $0xffffff9f,%edx
80106b08:	88 14 c5 05 5c 11 80 	mov    %dl,-0x7feea3fb(,%eax,8)
80106b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b12:	0f b6 14 c5 05 5c 11 	movzbl -0x7feea3fb(,%eax,8),%edx
80106b19:	80 
80106b1a:	83 ca 80             	or     $0xffffff80,%edx
80106b1d:	88 14 c5 05 5c 11 80 	mov    %dl,-0x7feea3fb(,%eax,8)
80106b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b27:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106b2e:	c1 e8 10             	shr    $0x10,%eax
80106b31:	89 c2                	mov    %eax,%edx
80106b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b36:	66 89 14 c5 06 5c 11 	mov    %dx,-0x7feea3fa(,%eax,8)
80106b3d:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106b3e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b42:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106b49:	0f 8e 30 ff ff ff    	jle    80106a7f <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106b4f:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106b54:	66 a3 00 5e 11 80    	mov    %ax,0x80115e00
80106b5a:	66 c7 05 02 5e 11 80 	movw   $0x8,0x80115e02
80106b61:	08 00 
80106b63:	0f b6 05 04 5e 11 80 	movzbl 0x80115e04,%eax
80106b6a:	83 e0 e0             	and    $0xffffffe0,%eax
80106b6d:	a2 04 5e 11 80       	mov    %al,0x80115e04
80106b72:	0f b6 05 04 5e 11 80 	movzbl 0x80115e04,%eax
80106b79:	83 e0 1f             	and    $0x1f,%eax
80106b7c:	a2 04 5e 11 80       	mov    %al,0x80115e04
80106b81:	0f b6 05 05 5e 11 80 	movzbl 0x80115e05,%eax
80106b88:	83 c8 0f             	or     $0xf,%eax
80106b8b:	a2 05 5e 11 80       	mov    %al,0x80115e05
80106b90:	0f b6 05 05 5e 11 80 	movzbl 0x80115e05,%eax
80106b97:	83 e0 ef             	and    $0xffffffef,%eax
80106b9a:	a2 05 5e 11 80       	mov    %al,0x80115e05
80106b9f:	0f b6 05 05 5e 11 80 	movzbl 0x80115e05,%eax
80106ba6:	83 c8 60             	or     $0x60,%eax
80106ba9:	a2 05 5e 11 80       	mov    %al,0x80115e05
80106bae:	0f b6 05 05 5e 11 80 	movzbl 0x80115e05,%eax
80106bb5:	83 c8 80             	or     $0xffffff80,%eax
80106bb8:	a2 05 5e 11 80       	mov    %al,0x80115e05
80106bbd:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106bc2:	c1 e8 10             	shr    $0x10,%eax
80106bc5:	66 a3 06 5e 11 80    	mov    %ax,0x80115e06

  initlock(&tickslock, "time");
80106bcb:	83 ec 08             	sub    $0x8,%esp
80106bce:	68 88 8f 10 80       	push   $0x80108f88
80106bd3:	68 c0 5b 11 80       	push   $0x80115bc0
80106bd8:	e8 7e e6 ff ff       	call   8010525b <initlock>
80106bdd:	83 c4 10             	add    $0x10,%esp
}
80106be0:	90                   	nop
80106be1:	c9                   	leave  
80106be2:	c3                   	ret    

80106be3 <idtinit>:

void
idtinit(void)
{
80106be3:	55                   	push   %ebp
80106be4:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106be6:	68 00 08 00 00       	push   $0x800
80106beb:	68 00 5c 11 80       	push   $0x80115c00
80106bf0:	e8 3d fe ff ff       	call   80106a32 <lidt>
80106bf5:	83 c4 08             	add    $0x8,%esp
}
80106bf8:	90                   	nop
80106bf9:	c9                   	leave  
80106bfa:	c3                   	ret    

80106bfb <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106bfb:	55                   	push   %ebp
80106bfc:	89 e5                	mov    %esp,%ebp
80106bfe:	57                   	push   %edi
80106bff:	56                   	push   %esi
80106c00:	53                   	push   %ebx
80106c01:	83 ec 2c             	sub    $0x2c,%esp
  siginfo_t si;
  if(tf->trapno == T_SYSCALL){
80106c04:	8b 45 08             	mov    0x8(%ebp),%eax
80106c07:	8b 40 30             	mov    0x30(%eax),%eax
80106c0a:	83 f8 40             	cmp    $0x40,%eax
80106c0d:	75 3e                	jne    80106c4d <trap+0x52>
    if(proc->killed)
80106c0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c15:	8b 40 24             	mov    0x24(%eax),%eax
80106c18:	85 c0                	test   %eax,%eax
80106c1a:	74 05                	je     80106c21 <trap+0x26>
      exit();
80106c1c:	e8 ae dd ff ff       	call   801049cf <exit>
    proc->tf = tf;
80106c21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c27:	8b 55 08             	mov    0x8(%ebp),%edx
80106c2a:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106c2d:	e8 89 ec ff ff       	call   801058bb <syscall>
    if(proc->killed)
80106c32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c38:	8b 40 24             	mov    0x24(%eax),%eax
80106c3b:	85 c0                	test   %eax,%eax
80106c3d:	0f 84 fc 02 00 00    	je     80106f3f <trap+0x344>
      exit();
80106c43:	e8 87 dd ff ff       	call   801049cf <exit>
80106c48:	e9 f3 02 00 00       	jmp    80106f40 <trap+0x345>
    return;
  }

  switch(tf->trapno){
80106c4d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c50:	8b 40 30             	mov    0x30(%eax),%eax
80106c53:	83 f8 3f             	cmp    $0x3f,%eax
80106c56:	0f 87 a1 01 00 00    	ja     80106dfd <trap+0x202>
80106c5c:	8b 04 85 70 90 10 80 	mov    -0x7fef6f90(,%eax,4),%eax
80106c63:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106c65:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106c6b:	0f b6 00             	movzbl (%eax),%eax
80106c6e:	84 c0                	test   %al,%al
80106c70:	75 3d                	jne    80106caf <trap+0xb4>
      acquire(&tickslock);
80106c72:	83 ec 0c             	sub    $0xc,%esp
80106c75:	68 c0 5b 11 80       	push   $0x80115bc0
80106c7a:	e8 fe e5 ff ff       	call   8010527d <acquire>
80106c7f:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106c82:	a1 00 64 11 80       	mov    0x80116400,%eax
80106c87:	83 c0 01             	add    $0x1,%eax
80106c8a:	a3 00 64 11 80       	mov    %eax,0x80116400
      wakeup(&ticks);
80106c8f:	83 ec 0c             	sub    $0xc,%esp
80106c92:	68 00 64 11 80       	push   $0x80116400
80106c97:	e8 53 e2 ff ff       	call   80104eef <wakeup>
80106c9c:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106c9f:	83 ec 0c             	sub    $0xc,%esp
80106ca2:	68 c0 5b 11 80       	push   $0x80115bc0
80106ca7:	e8 38 e6 ff ff       	call   801052e4 <release>
80106cac:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106caf:	e8 d0 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106cb4:	e9 00 02 00 00       	jmp    80106eb9 <trap+0x2be>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106cb9:	e8 d9 ba ff ff       	call   80102797 <ideintr>
    lapiceoi();
80106cbe:	e8 c1 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106cc3:	e9 f1 01 00 00       	jmp    80106eb9 <trap+0x2be>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106cc8:	e8 b9 c0 ff ff       	call   80102d86 <kbdintr>
    lapiceoi();
80106ccd:	e8 b2 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106cd2:	e9 e2 01 00 00       	jmp    80106eb9 <trap+0x2be>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106cd7:	e8 44 04 00 00       	call   80107120 <uartintr>
    lapiceoi();
80106cdc:	e8 a3 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106ce1:	e9 d3 01 00 00       	jmp    80106eb9 <trap+0x2be>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce9:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106cec:	8b 45 08             	mov    0x8(%ebp),%eax
80106cef:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106cf3:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106cf6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106cfc:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106cff:	0f b6 c0             	movzbl %al,%eax
80106d02:	51                   	push   %ecx
80106d03:	52                   	push   %edx
80106d04:	50                   	push   %eax
80106d05:	68 90 8f 10 80       	push   $0x80108f90
80106d0a:	e8 b7 96 ff ff       	call   801003c6 <cprintf>
80106d0f:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106d12:	e8 6d c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d17:	e9 9d 01 00 00       	jmp    80106eb9 <trap+0x2be>

   case T_DIVIDE:
      if (proc->handlers[SIGFPE] != (sighandler_t) -1) {
80106d1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d22:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106d28:	83 f8 ff             	cmp    $0xffffffff,%eax
80106d2b:	74 36                	je     80106d63 <trap+0x168>
        cprintf("T_DIVIDE err\n");
80106d2d:	83 ec 0c             	sub    $0xc,%esp
80106d30:	68 b4 8f 10 80       	push   $0x80108fb4
80106d35:	e8 8c 96 ff ff       	call   801003c6 <cprintf>
80106d3a:	83 c4 10             	add    $0x10,%esp
        si.type= 1;
80106d3d:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
        si.addr = 5;
80106d44:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%ebp)
        signal_deliver(SIGFPE,si);
80106d4b:	83 ec 04             	sub    $0x4,%esp
80106d4e:	ff 75 e0             	pushl  -0x20(%ebp)
80106d51:	ff 75 dc             	pushl  -0x24(%ebp)
80106d54:	6a 01                	push   $0x1
80106d56:	e8 4e e3 ff ff       	call   801050a9 <signal_deliver>
80106d5b:	83 c4 10             	add    $0x10,%esp
        break;
80106d5e:	e9 56 01 00 00       	jmp    80106eb9 <trap+0x2be>
      }
    //handle pgfault with mem_protect
    case T_PGFLT:
      //create a siginfo_t struct
      cprintf(" PAGEFULT !!err : 0x%x\n",tf->err);
80106d63:	8b 45 08             	mov    0x8(%ebp),%eax
80106d66:	8b 40 34             	mov    0x34(%eax),%eax
80106d69:	83 ec 08             	sub    $0x8,%esp
80106d6c:	50                   	push   %eax
80106d6d:	68 c2 8f 10 80       	push   $0x80108fc2
80106d72:	e8 4f 96 ff ff       	call   801003c6 <cprintf>
80106d77:	83 c4 10             	add    $0x10,%esp

      if (proc->handlers[SIGSEGV] != (sighandler_t) -1) {
80106d7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d80:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80106d86:	83 f8 ff             	cmp    $0xffffffff,%eax
80106d89:	0f 84 29 01 00 00    	je     80106eb8 <trap+0x2bd>
        int err = tf->err;
80106d8f:	8b 45 08             	mov    0x8(%ebp),%eax
80106d92:	8b 40 34             	mov    0x34(%eax),%eax
80106d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(err == 0x4 || err == 0x6 || err == 0x5) {
80106d98:	83 7d e4 04          	cmpl   $0x4,-0x1c(%ebp)
80106d9c:	74 0c                	je     80106daa <trap+0x1af>
80106d9e:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
80106da2:	74 06                	je     80106daa <trap+0x1af>
80106da4:	83 7d e4 05          	cmpl   $0x5,-0x1c(%ebp)
80106da8:	75 09                	jne    80106db3 <trap+0x1b8>
          si.type = PROT_NONE;
80106daa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106db1:	eb 16                	jmp    80106dc9 <trap+0x1ce>
        } else if(err == 0x7) {
80106db3:	83 7d e4 07          	cmpl   $0x7,-0x1c(%ebp)
80106db7:	75 09                	jne    80106dc2 <trap+0x1c7>
          si.type = PROT_READ;
80106db9:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80106dc0:	eb 07                	jmp    80106dc9 <trap+0x1ce>
        } else {
          si.type = PROT_WRITE;
80106dc2:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
        }
        si.addr = rcr2();
80106dc9:	e8 8e fc ff ff       	call   80106a5c <rcr2>
80106dce:	89 45 dc             	mov    %eax,-0x24(%ebp)
        cprintf(" PAGE FAULT addr: 0x%x\n",si.addr);
80106dd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106dd4:	83 ec 08             	sub    $0x8,%esp
80106dd7:	50                   	push   %eax
80106dd8:	68 da 8f 10 80       	push   $0x80108fda
80106ddd:	e8 e4 95 ff ff       	call   801003c6 <cprintf>
80106de2:	83 c4 10             	add    $0x10,%esp
        signal_deliver(SIGSEGV,si);
80106de5:	83 ec 04             	sub    $0x4,%esp
80106de8:	ff 75 e0             	pushl  -0x20(%ebp)
80106deb:	ff 75 dc             	pushl  -0x24(%ebp)
80106dee:	6a 02                	push   $0x2
80106df0:	e8 b4 e2 ff ff       	call   801050a9 <signal_deliver>
80106df5:	83 c4 10             	add    $0x10,%esp
        break;
80106df8:	e9 bc 00 00 00       	jmp    80106eb9 <trap+0x2be>

      break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106dfd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e03:	85 c0                	test   %eax,%eax
80106e05:	74 11                	je     80106e18 <trap+0x21d>
80106e07:	8b 45 08             	mov    0x8(%ebp),%eax
80106e0a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e0e:	0f b7 c0             	movzwl %ax,%eax
80106e11:	83 e0 03             	and    $0x3,%eax
80106e14:	85 c0                	test   %eax,%eax
80106e16:	75 40                	jne    80106e58 <trap+0x25d>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e18:	e8 3f fc ff ff       	call   80106a5c <rcr2>
80106e1d:	89 c3                	mov    %eax,%ebx
80106e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106e22:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106e25:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e2b:	0f b6 00             	movzbl (%eax),%eax

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e2e:	0f b6 d0             	movzbl %al,%edx
80106e31:	8b 45 08             	mov    0x8(%ebp),%eax
80106e34:	8b 40 30             	mov    0x30(%eax),%eax
80106e37:	83 ec 0c             	sub    $0xc,%esp
80106e3a:	53                   	push   %ebx
80106e3b:	51                   	push   %ecx
80106e3c:	52                   	push   %edx
80106e3d:	50                   	push   %eax
80106e3e:	68 f4 8f 10 80       	push   $0x80108ff4
80106e43:	e8 7e 95 ff ff       	call   801003c6 <cprintf>
80106e48:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106e4b:	83 ec 0c             	sub    $0xc,%esp
80106e4e:	68 26 90 10 80       	push   $0x80109026
80106e53:	e8 0e 97 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e58:	e8 ff fb ff ff       	call   80106a5c <rcr2>
80106e5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106e60:	8b 45 08             	mov    0x8(%ebp),%eax
80106e63:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106e66:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e6c:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e6f:	0f b6 d8             	movzbl %al,%ebx
80106e72:	8b 45 08             	mov    0x8(%ebp),%eax
80106e75:	8b 48 34             	mov    0x34(%eax),%ecx
80106e78:	8b 45 08             	mov    0x8(%ebp),%eax
80106e7b:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106e7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e84:	8d 78 6c             	lea    0x6c(%eax),%edi
80106e87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e8d:	8b 40 10             	mov    0x10(%eax),%eax
80106e90:	ff 75 d4             	pushl  -0x2c(%ebp)
80106e93:	56                   	push   %esi
80106e94:	53                   	push   %ebx
80106e95:	51                   	push   %ecx
80106e96:	52                   	push   %edx
80106e97:	57                   	push   %edi
80106e98:	50                   	push   %eax
80106e99:	68 2c 90 10 80       	push   $0x8010902c
80106e9e:	e8 23 95 ff ff       	call   801003c6 <cprintf>
80106ea3:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
            rcr2());
    proc->killed = 1;
80106ea6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106eac:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106eb3:	eb 04                	jmp    80106eb9 <trap+0x2be>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106eb5:	90                   	nop
80106eb6:	eb 01                	jmp    80106eb9 <trap+0x2be>
        cprintf(" PAGE FAULT addr: 0x%x\n",si.addr);
        signal_deliver(SIGSEGV,si);
        break;
      }

      break;
80106eb8:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106eb9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ebf:	85 c0                	test   %eax,%eax
80106ec1:	74 24                	je     80106ee7 <trap+0x2ec>
80106ec3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ec9:	8b 40 24             	mov    0x24(%eax),%eax
80106ecc:	85 c0                	test   %eax,%eax
80106ece:	74 17                	je     80106ee7 <trap+0x2ec>
80106ed0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ed3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ed7:	0f b7 c0             	movzwl %ax,%eax
80106eda:	83 e0 03             	and    $0x3,%eax
80106edd:	83 f8 03             	cmp    $0x3,%eax
80106ee0:	75 05                	jne    80106ee7 <trap+0x2ec>
    exit();
80106ee2:	e8 e8 da ff ff       	call   801049cf <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106ee7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106eed:	85 c0                	test   %eax,%eax
80106eef:	74 1e                	je     80106f0f <trap+0x314>
80106ef1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ef7:	8b 40 0c             	mov    0xc(%eax),%eax
80106efa:	83 f8 04             	cmp    $0x4,%eax
80106efd:	75 10                	jne    80106f0f <trap+0x314>
80106eff:	8b 45 08             	mov    0x8(%ebp),%eax
80106f02:	8b 40 30             	mov    0x30(%eax),%eax
80106f05:	83 f8 20             	cmp    $0x20,%eax
80106f08:	75 05                	jne    80106f0f <trap+0x314>
    yield();
80106f0a:	e8 86 de ff ff       	call   80104d95 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106f0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f15:	85 c0                	test   %eax,%eax
80106f17:	74 27                	je     80106f40 <trap+0x345>
80106f19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f1f:	8b 40 24             	mov    0x24(%eax),%eax
80106f22:	85 c0                	test   %eax,%eax
80106f24:	74 1a                	je     80106f40 <trap+0x345>
80106f26:	8b 45 08             	mov    0x8(%ebp),%eax
80106f29:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f2d:	0f b7 c0             	movzwl %ax,%eax
80106f30:	83 e0 03             	and    $0x3,%eax
80106f33:	83 f8 03             	cmp    $0x3,%eax
80106f36:	75 08                	jne    80106f40 <trap+0x345>
    exit();
80106f38:	e8 92 da ff ff       	call   801049cf <exit>
80106f3d:	eb 01                	jmp    80106f40 <trap+0x345>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106f3f:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f43:	5b                   	pop    %ebx
80106f44:	5e                   	pop    %esi
80106f45:	5f                   	pop    %edi
80106f46:	5d                   	pop    %ebp
80106f47:	c3                   	ret    

80106f48 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106f48:	55                   	push   %ebp
80106f49:	89 e5                	mov    %esp,%ebp
80106f4b:	83 ec 14             	sub    $0x14,%esp
80106f4e:	8b 45 08             	mov    0x8(%ebp),%eax
80106f51:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f55:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106f59:	89 c2                	mov    %eax,%edx
80106f5b:	ec                   	in     (%dx),%al
80106f5c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106f5f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106f63:	c9                   	leave  
80106f64:	c3                   	ret    

80106f65 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106f65:	55                   	push   %ebp
80106f66:	89 e5                	mov    %esp,%ebp
80106f68:	83 ec 08             	sub    $0x8,%esp
80106f6b:	8b 55 08             	mov    0x8(%ebp),%edx
80106f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f71:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106f75:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f78:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106f7c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106f80:	ee                   	out    %al,(%dx)
}
80106f81:	90                   	nop
80106f82:	c9                   	leave  
80106f83:	c3                   	ret    

80106f84 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106f84:	55                   	push   %ebp
80106f85:	89 e5                	mov    %esp,%ebp
80106f87:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106f8a:	6a 00                	push   $0x0
80106f8c:	68 fa 03 00 00       	push   $0x3fa
80106f91:	e8 cf ff ff ff       	call   80106f65 <outb>
80106f96:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106f99:	68 80 00 00 00       	push   $0x80
80106f9e:	68 fb 03 00 00       	push   $0x3fb
80106fa3:	e8 bd ff ff ff       	call   80106f65 <outb>
80106fa8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106fab:	6a 0c                	push   $0xc
80106fad:	68 f8 03 00 00       	push   $0x3f8
80106fb2:	e8 ae ff ff ff       	call   80106f65 <outb>
80106fb7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106fba:	6a 00                	push   $0x0
80106fbc:	68 f9 03 00 00       	push   $0x3f9
80106fc1:	e8 9f ff ff ff       	call   80106f65 <outb>
80106fc6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106fc9:	6a 03                	push   $0x3
80106fcb:	68 fb 03 00 00       	push   $0x3fb
80106fd0:	e8 90 ff ff ff       	call   80106f65 <outb>
80106fd5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106fd8:	6a 00                	push   $0x0
80106fda:	68 fc 03 00 00       	push   $0x3fc
80106fdf:	e8 81 ff ff ff       	call   80106f65 <outb>
80106fe4:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106fe7:	6a 01                	push   $0x1
80106fe9:	68 f9 03 00 00       	push   $0x3f9
80106fee:	e8 72 ff ff ff       	call   80106f65 <outb>
80106ff3:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106ff6:	68 fd 03 00 00       	push   $0x3fd
80106ffb:	e8 48 ff ff ff       	call   80106f48 <inb>
80107000:	83 c4 04             	add    $0x4,%esp
80107003:	3c ff                	cmp    $0xff,%al
80107005:	74 6e                	je     80107075 <uartinit+0xf1>
    return;
  uart = 1;
80107007:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
8010700e:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107011:	68 fa 03 00 00       	push   $0x3fa
80107016:	e8 2d ff ff ff       	call   80106f48 <inb>
8010701b:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010701e:	68 f8 03 00 00       	push   $0x3f8
80107023:	e8 20 ff ff ff       	call   80106f48 <inb>
80107028:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
8010702b:	83 ec 0c             	sub    $0xc,%esp
8010702e:	6a 04                	push   $0x4
80107030:	e8 42 ce ff ff       	call   80103e77 <picenable>
80107035:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107038:	83 ec 08             	sub    $0x8,%esp
8010703b:	6a 00                	push   $0x0
8010703d:	6a 04                	push   $0x4
8010703f:	e8 f5 b9 ff ff       	call   80102a39 <ioapicenable>
80107044:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107047:	c7 45 f4 70 91 10 80 	movl   $0x80109170,-0xc(%ebp)
8010704e:	eb 19                	jmp    80107069 <uartinit+0xe5>
    uartputc(*p);
80107050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107053:	0f b6 00             	movzbl (%eax),%eax
80107056:	0f be c0             	movsbl %al,%eax
80107059:	83 ec 0c             	sub    $0xc,%esp
8010705c:	50                   	push   %eax
8010705d:	e8 16 00 00 00       	call   80107078 <uartputc>
80107062:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107065:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107069:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010706c:	0f b6 00             	movzbl (%eax),%eax
8010706f:	84 c0                	test   %al,%al
80107071:	75 dd                	jne    80107050 <uartinit+0xcc>
80107073:	eb 01                	jmp    80107076 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107075:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107076:	c9                   	leave  
80107077:	c3                   	ret    

80107078 <uartputc>:

void
uartputc(int c)
{
80107078:	55                   	push   %ebp
80107079:	89 e5                	mov    %esp,%ebp
8010707b:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010707e:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107083:	85 c0                	test   %eax,%eax
80107085:	74 53                	je     801070da <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107087:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010708e:	eb 11                	jmp    801070a1 <uartputc+0x29>
    microdelay(10);
80107090:	83 ec 0c             	sub    $0xc,%esp
80107093:	6a 0a                	push   $0xa
80107095:	e8 05 bf ff ff       	call   80102f9f <microdelay>
8010709a:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010709d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801070a1:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801070a5:	7f 1a                	jg     801070c1 <uartputc+0x49>
801070a7:	83 ec 0c             	sub    $0xc,%esp
801070aa:	68 fd 03 00 00       	push   $0x3fd
801070af:	e8 94 fe ff ff       	call   80106f48 <inb>
801070b4:	83 c4 10             	add    $0x10,%esp
801070b7:	0f b6 c0             	movzbl %al,%eax
801070ba:	83 e0 20             	and    $0x20,%eax
801070bd:	85 c0                	test   %eax,%eax
801070bf:	74 cf                	je     80107090 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801070c1:	8b 45 08             	mov    0x8(%ebp),%eax
801070c4:	0f b6 c0             	movzbl %al,%eax
801070c7:	83 ec 08             	sub    $0x8,%esp
801070ca:	50                   	push   %eax
801070cb:	68 f8 03 00 00       	push   $0x3f8
801070d0:	e8 90 fe ff ff       	call   80106f65 <outb>
801070d5:	83 c4 10             	add    $0x10,%esp
801070d8:	eb 01                	jmp    801070db <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801070da:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801070db:	c9                   	leave  
801070dc:	c3                   	ret    

801070dd <uartgetc>:

static int
uartgetc(void)
{
801070dd:	55                   	push   %ebp
801070de:	89 e5                	mov    %esp,%ebp
  if(!uart)
801070e0:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801070e5:	85 c0                	test   %eax,%eax
801070e7:	75 07                	jne    801070f0 <uartgetc+0x13>
    return -1;
801070e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070ee:	eb 2e                	jmp    8010711e <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801070f0:	68 fd 03 00 00       	push   $0x3fd
801070f5:	e8 4e fe ff ff       	call   80106f48 <inb>
801070fa:	83 c4 04             	add    $0x4,%esp
801070fd:	0f b6 c0             	movzbl %al,%eax
80107100:	83 e0 01             	and    $0x1,%eax
80107103:	85 c0                	test   %eax,%eax
80107105:	75 07                	jne    8010710e <uartgetc+0x31>
    return -1;
80107107:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010710c:	eb 10                	jmp    8010711e <uartgetc+0x41>
  return inb(COM1+0);
8010710e:	68 f8 03 00 00       	push   $0x3f8
80107113:	e8 30 fe ff ff       	call   80106f48 <inb>
80107118:	83 c4 04             	add    $0x4,%esp
8010711b:	0f b6 c0             	movzbl %al,%eax
}
8010711e:	c9                   	leave  
8010711f:	c3                   	ret    

80107120 <uartintr>:

void
uartintr(void)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107126:	83 ec 0c             	sub    $0xc,%esp
80107129:	68 dd 70 10 80       	push   $0x801070dd
8010712e:	e8 aa 96 ff ff       	call   801007dd <consoleintr>
80107133:	83 c4 10             	add    $0x10,%esp
}
80107136:	90                   	nop
80107137:	c9                   	leave  
80107138:	c3                   	ret    

80107139 <vector0>:
80107139:	6a 00                	push   $0x0
8010713b:	6a 00                	push   $0x0
8010713d:	e9 c5 f8 ff ff       	jmp    80106a07 <alltraps>

80107142 <vector1>:
80107142:	6a 00                	push   $0x0
80107144:	6a 01                	push   $0x1
80107146:	e9 bc f8 ff ff       	jmp    80106a07 <alltraps>

8010714b <vector2>:
8010714b:	6a 00                	push   $0x0
8010714d:	6a 02                	push   $0x2
8010714f:	e9 b3 f8 ff ff       	jmp    80106a07 <alltraps>

80107154 <vector3>:
80107154:	6a 00                	push   $0x0
80107156:	6a 03                	push   $0x3
80107158:	e9 aa f8 ff ff       	jmp    80106a07 <alltraps>

8010715d <vector4>:
8010715d:	6a 00                	push   $0x0
8010715f:	6a 04                	push   $0x4
80107161:	e9 a1 f8 ff ff       	jmp    80106a07 <alltraps>

80107166 <vector5>:
80107166:	6a 00                	push   $0x0
80107168:	6a 05                	push   $0x5
8010716a:	e9 98 f8 ff ff       	jmp    80106a07 <alltraps>

8010716f <vector6>:
8010716f:	6a 00                	push   $0x0
80107171:	6a 06                	push   $0x6
80107173:	e9 8f f8 ff ff       	jmp    80106a07 <alltraps>

80107178 <vector7>:
80107178:	6a 00                	push   $0x0
8010717a:	6a 07                	push   $0x7
8010717c:	e9 86 f8 ff ff       	jmp    80106a07 <alltraps>

80107181 <vector8>:
80107181:	6a 08                	push   $0x8
80107183:	e9 7f f8 ff ff       	jmp    80106a07 <alltraps>

80107188 <vector9>:
80107188:	6a 00                	push   $0x0
8010718a:	6a 09                	push   $0x9
8010718c:	e9 76 f8 ff ff       	jmp    80106a07 <alltraps>

80107191 <vector10>:
80107191:	6a 0a                	push   $0xa
80107193:	e9 6f f8 ff ff       	jmp    80106a07 <alltraps>

80107198 <vector11>:
80107198:	6a 0b                	push   $0xb
8010719a:	e9 68 f8 ff ff       	jmp    80106a07 <alltraps>

8010719f <vector12>:
8010719f:	6a 0c                	push   $0xc
801071a1:	e9 61 f8 ff ff       	jmp    80106a07 <alltraps>

801071a6 <vector13>:
801071a6:	6a 0d                	push   $0xd
801071a8:	e9 5a f8 ff ff       	jmp    80106a07 <alltraps>

801071ad <vector14>:
801071ad:	6a 0e                	push   $0xe
801071af:	e9 53 f8 ff ff       	jmp    80106a07 <alltraps>

801071b4 <vector15>:
801071b4:	6a 00                	push   $0x0
801071b6:	6a 0f                	push   $0xf
801071b8:	e9 4a f8 ff ff       	jmp    80106a07 <alltraps>

801071bd <vector16>:
801071bd:	6a 00                	push   $0x0
801071bf:	6a 10                	push   $0x10
801071c1:	e9 41 f8 ff ff       	jmp    80106a07 <alltraps>

801071c6 <vector17>:
801071c6:	6a 11                	push   $0x11
801071c8:	e9 3a f8 ff ff       	jmp    80106a07 <alltraps>

801071cd <vector18>:
801071cd:	6a 00                	push   $0x0
801071cf:	6a 12                	push   $0x12
801071d1:	e9 31 f8 ff ff       	jmp    80106a07 <alltraps>

801071d6 <vector19>:
801071d6:	6a 00                	push   $0x0
801071d8:	6a 13                	push   $0x13
801071da:	e9 28 f8 ff ff       	jmp    80106a07 <alltraps>

801071df <vector20>:
801071df:	6a 00                	push   $0x0
801071e1:	6a 14                	push   $0x14
801071e3:	e9 1f f8 ff ff       	jmp    80106a07 <alltraps>

801071e8 <vector21>:
801071e8:	6a 00                	push   $0x0
801071ea:	6a 15                	push   $0x15
801071ec:	e9 16 f8 ff ff       	jmp    80106a07 <alltraps>

801071f1 <vector22>:
801071f1:	6a 00                	push   $0x0
801071f3:	6a 16                	push   $0x16
801071f5:	e9 0d f8 ff ff       	jmp    80106a07 <alltraps>

801071fa <vector23>:
801071fa:	6a 00                	push   $0x0
801071fc:	6a 17                	push   $0x17
801071fe:	e9 04 f8 ff ff       	jmp    80106a07 <alltraps>

80107203 <vector24>:
80107203:	6a 00                	push   $0x0
80107205:	6a 18                	push   $0x18
80107207:	e9 fb f7 ff ff       	jmp    80106a07 <alltraps>

8010720c <vector25>:
8010720c:	6a 00                	push   $0x0
8010720e:	6a 19                	push   $0x19
80107210:	e9 f2 f7 ff ff       	jmp    80106a07 <alltraps>

80107215 <vector26>:
80107215:	6a 00                	push   $0x0
80107217:	6a 1a                	push   $0x1a
80107219:	e9 e9 f7 ff ff       	jmp    80106a07 <alltraps>

8010721e <vector27>:
8010721e:	6a 00                	push   $0x0
80107220:	6a 1b                	push   $0x1b
80107222:	e9 e0 f7 ff ff       	jmp    80106a07 <alltraps>

80107227 <vector28>:
80107227:	6a 00                	push   $0x0
80107229:	6a 1c                	push   $0x1c
8010722b:	e9 d7 f7 ff ff       	jmp    80106a07 <alltraps>

80107230 <vector29>:
80107230:	6a 00                	push   $0x0
80107232:	6a 1d                	push   $0x1d
80107234:	e9 ce f7 ff ff       	jmp    80106a07 <alltraps>

80107239 <vector30>:
80107239:	6a 00                	push   $0x0
8010723b:	6a 1e                	push   $0x1e
8010723d:	e9 c5 f7 ff ff       	jmp    80106a07 <alltraps>

80107242 <vector31>:
80107242:	6a 00                	push   $0x0
80107244:	6a 1f                	push   $0x1f
80107246:	e9 bc f7 ff ff       	jmp    80106a07 <alltraps>

8010724b <vector32>:
8010724b:	6a 00                	push   $0x0
8010724d:	6a 20                	push   $0x20
8010724f:	e9 b3 f7 ff ff       	jmp    80106a07 <alltraps>

80107254 <vector33>:
80107254:	6a 00                	push   $0x0
80107256:	6a 21                	push   $0x21
80107258:	e9 aa f7 ff ff       	jmp    80106a07 <alltraps>

8010725d <vector34>:
8010725d:	6a 00                	push   $0x0
8010725f:	6a 22                	push   $0x22
80107261:	e9 a1 f7 ff ff       	jmp    80106a07 <alltraps>

80107266 <vector35>:
80107266:	6a 00                	push   $0x0
80107268:	6a 23                	push   $0x23
8010726a:	e9 98 f7 ff ff       	jmp    80106a07 <alltraps>

8010726f <vector36>:
8010726f:	6a 00                	push   $0x0
80107271:	6a 24                	push   $0x24
80107273:	e9 8f f7 ff ff       	jmp    80106a07 <alltraps>

80107278 <vector37>:
80107278:	6a 00                	push   $0x0
8010727a:	6a 25                	push   $0x25
8010727c:	e9 86 f7 ff ff       	jmp    80106a07 <alltraps>

80107281 <vector38>:
80107281:	6a 00                	push   $0x0
80107283:	6a 26                	push   $0x26
80107285:	e9 7d f7 ff ff       	jmp    80106a07 <alltraps>

8010728a <vector39>:
8010728a:	6a 00                	push   $0x0
8010728c:	6a 27                	push   $0x27
8010728e:	e9 74 f7 ff ff       	jmp    80106a07 <alltraps>

80107293 <vector40>:
80107293:	6a 00                	push   $0x0
80107295:	6a 28                	push   $0x28
80107297:	e9 6b f7 ff ff       	jmp    80106a07 <alltraps>

8010729c <vector41>:
8010729c:	6a 00                	push   $0x0
8010729e:	6a 29                	push   $0x29
801072a0:	e9 62 f7 ff ff       	jmp    80106a07 <alltraps>

801072a5 <vector42>:
801072a5:	6a 00                	push   $0x0
801072a7:	6a 2a                	push   $0x2a
801072a9:	e9 59 f7 ff ff       	jmp    80106a07 <alltraps>

801072ae <vector43>:
801072ae:	6a 00                	push   $0x0
801072b0:	6a 2b                	push   $0x2b
801072b2:	e9 50 f7 ff ff       	jmp    80106a07 <alltraps>

801072b7 <vector44>:
801072b7:	6a 00                	push   $0x0
801072b9:	6a 2c                	push   $0x2c
801072bb:	e9 47 f7 ff ff       	jmp    80106a07 <alltraps>

801072c0 <vector45>:
801072c0:	6a 00                	push   $0x0
801072c2:	6a 2d                	push   $0x2d
801072c4:	e9 3e f7 ff ff       	jmp    80106a07 <alltraps>

801072c9 <vector46>:
801072c9:	6a 00                	push   $0x0
801072cb:	6a 2e                	push   $0x2e
801072cd:	e9 35 f7 ff ff       	jmp    80106a07 <alltraps>

801072d2 <vector47>:
801072d2:	6a 00                	push   $0x0
801072d4:	6a 2f                	push   $0x2f
801072d6:	e9 2c f7 ff ff       	jmp    80106a07 <alltraps>

801072db <vector48>:
801072db:	6a 00                	push   $0x0
801072dd:	6a 30                	push   $0x30
801072df:	e9 23 f7 ff ff       	jmp    80106a07 <alltraps>

801072e4 <vector49>:
801072e4:	6a 00                	push   $0x0
801072e6:	6a 31                	push   $0x31
801072e8:	e9 1a f7 ff ff       	jmp    80106a07 <alltraps>

801072ed <vector50>:
801072ed:	6a 00                	push   $0x0
801072ef:	6a 32                	push   $0x32
801072f1:	e9 11 f7 ff ff       	jmp    80106a07 <alltraps>

801072f6 <vector51>:
801072f6:	6a 00                	push   $0x0
801072f8:	6a 33                	push   $0x33
801072fa:	e9 08 f7 ff ff       	jmp    80106a07 <alltraps>

801072ff <vector52>:
801072ff:	6a 00                	push   $0x0
80107301:	6a 34                	push   $0x34
80107303:	e9 ff f6 ff ff       	jmp    80106a07 <alltraps>

80107308 <vector53>:
80107308:	6a 00                	push   $0x0
8010730a:	6a 35                	push   $0x35
8010730c:	e9 f6 f6 ff ff       	jmp    80106a07 <alltraps>

80107311 <vector54>:
80107311:	6a 00                	push   $0x0
80107313:	6a 36                	push   $0x36
80107315:	e9 ed f6 ff ff       	jmp    80106a07 <alltraps>

8010731a <vector55>:
8010731a:	6a 00                	push   $0x0
8010731c:	6a 37                	push   $0x37
8010731e:	e9 e4 f6 ff ff       	jmp    80106a07 <alltraps>

80107323 <vector56>:
80107323:	6a 00                	push   $0x0
80107325:	6a 38                	push   $0x38
80107327:	e9 db f6 ff ff       	jmp    80106a07 <alltraps>

8010732c <vector57>:
8010732c:	6a 00                	push   $0x0
8010732e:	6a 39                	push   $0x39
80107330:	e9 d2 f6 ff ff       	jmp    80106a07 <alltraps>

80107335 <vector58>:
80107335:	6a 00                	push   $0x0
80107337:	6a 3a                	push   $0x3a
80107339:	e9 c9 f6 ff ff       	jmp    80106a07 <alltraps>

8010733e <vector59>:
8010733e:	6a 00                	push   $0x0
80107340:	6a 3b                	push   $0x3b
80107342:	e9 c0 f6 ff ff       	jmp    80106a07 <alltraps>

80107347 <vector60>:
80107347:	6a 00                	push   $0x0
80107349:	6a 3c                	push   $0x3c
8010734b:	e9 b7 f6 ff ff       	jmp    80106a07 <alltraps>

80107350 <vector61>:
80107350:	6a 00                	push   $0x0
80107352:	6a 3d                	push   $0x3d
80107354:	e9 ae f6 ff ff       	jmp    80106a07 <alltraps>

80107359 <vector62>:
80107359:	6a 00                	push   $0x0
8010735b:	6a 3e                	push   $0x3e
8010735d:	e9 a5 f6 ff ff       	jmp    80106a07 <alltraps>

80107362 <vector63>:
80107362:	6a 00                	push   $0x0
80107364:	6a 3f                	push   $0x3f
80107366:	e9 9c f6 ff ff       	jmp    80106a07 <alltraps>

8010736b <vector64>:
8010736b:	6a 00                	push   $0x0
8010736d:	6a 40                	push   $0x40
8010736f:	e9 93 f6 ff ff       	jmp    80106a07 <alltraps>

80107374 <vector65>:
80107374:	6a 00                	push   $0x0
80107376:	6a 41                	push   $0x41
80107378:	e9 8a f6 ff ff       	jmp    80106a07 <alltraps>

8010737d <vector66>:
8010737d:	6a 00                	push   $0x0
8010737f:	6a 42                	push   $0x42
80107381:	e9 81 f6 ff ff       	jmp    80106a07 <alltraps>

80107386 <vector67>:
80107386:	6a 00                	push   $0x0
80107388:	6a 43                	push   $0x43
8010738a:	e9 78 f6 ff ff       	jmp    80106a07 <alltraps>

8010738f <vector68>:
8010738f:	6a 00                	push   $0x0
80107391:	6a 44                	push   $0x44
80107393:	e9 6f f6 ff ff       	jmp    80106a07 <alltraps>

80107398 <vector69>:
80107398:	6a 00                	push   $0x0
8010739a:	6a 45                	push   $0x45
8010739c:	e9 66 f6 ff ff       	jmp    80106a07 <alltraps>

801073a1 <vector70>:
801073a1:	6a 00                	push   $0x0
801073a3:	6a 46                	push   $0x46
801073a5:	e9 5d f6 ff ff       	jmp    80106a07 <alltraps>

801073aa <vector71>:
801073aa:	6a 00                	push   $0x0
801073ac:	6a 47                	push   $0x47
801073ae:	e9 54 f6 ff ff       	jmp    80106a07 <alltraps>

801073b3 <vector72>:
801073b3:	6a 00                	push   $0x0
801073b5:	6a 48                	push   $0x48
801073b7:	e9 4b f6 ff ff       	jmp    80106a07 <alltraps>

801073bc <vector73>:
801073bc:	6a 00                	push   $0x0
801073be:	6a 49                	push   $0x49
801073c0:	e9 42 f6 ff ff       	jmp    80106a07 <alltraps>

801073c5 <vector74>:
801073c5:	6a 00                	push   $0x0
801073c7:	6a 4a                	push   $0x4a
801073c9:	e9 39 f6 ff ff       	jmp    80106a07 <alltraps>

801073ce <vector75>:
801073ce:	6a 00                	push   $0x0
801073d0:	6a 4b                	push   $0x4b
801073d2:	e9 30 f6 ff ff       	jmp    80106a07 <alltraps>

801073d7 <vector76>:
801073d7:	6a 00                	push   $0x0
801073d9:	6a 4c                	push   $0x4c
801073db:	e9 27 f6 ff ff       	jmp    80106a07 <alltraps>

801073e0 <vector77>:
801073e0:	6a 00                	push   $0x0
801073e2:	6a 4d                	push   $0x4d
801073e4:	e9 1e f6 ff ff       	jmp    80106a07 <alltraps>

801073e9 <vector78>:
801073e9:	6a 00                	push   $0x0
801073eb:	6a 4e                	push   $0x4e
801073ed:	e9 15 f6 ff ff       	jmp    80106a07 <alltraps>

801073f2 <vector79>:
801073f2:	6a 00                	push   $0x0
801073f4:	6a 4f                	push   $0x4f
801073f6:	e9 0c f6 ff ff       	jmp    80106a07 <alltraps>

801073fb <vector80>:
801073fb:	6a 00                	push   $0x0
801073fd:	6a 50                	push   $0x50
801073ff:	e9 03 f6 ff ff       	jmp    80106a07 <alltraps>

80107404 <vector81>:
80107404:	6a 00                	push   $0x0
80107406:	6a 51                	push   $0x51
80107408:	e9 fa f5 ff ff       	jmp    80106a07 <alltraps>

8010740d <vector82>:
8010740d:	6a 00                	push   $0x0
8010740f:	6a 52                	push   $0x52
80107411:	e9 f1 f5 ff ff       	jmp    80106a07 <alltraps>

80107416 <vector83>:
80107416:	6a 00                	push   $0x0
80107418:	6a 53                	push   $0x53
8010741a:	e9 e8 f5 ff ff       	jmp    80106a07 <alltraps>

8010741f <vector84>:
8010741f:	6a 00                	push   $0x0
80107421:	6a 54                	push   $0x54
80107423:	e9 df f5 ff ff       	jmp    80106a07 <alltraps>

80107428 <vector85>:
80107428:	6a 00                	push   $0x0
8010742a:	6a 55                	push   $0x55
8010742c:	e9 d6 f5 ff ff       	jmp    80106a07 <alltraps>

80107431 <vector86>:
80107431:	6a 00                	push   $0x0
80107433:	6a 56                	push   $0x56
80107435:	e9 cd f5 ff ff       	jmp    80106a07 <alltraps>

8010743a <vector87>:
8010743a:	6a 00                	push   $0x0
8010743c:	6a 57                	push   $0x57
8010743e:	e9 c4 f5 ff ff       	jmp    80106a07 <alltraps>

80107443 <vector88>:
80107443:	6a 00                	push   $0x0
80107445:	6a 58                	push   $0x58
80107447:	e9 bb f5 ff ff       	jmp    80106a07 <alltraps>

8010744c <vector89>:
8010744c:	6a 00                	push   $0x0
8010744e:	6a 59                	push   $0x59
80107450:	e9 b2 f5 ff ff       	jmp    80106a07 <alltraps>

80107455 <vector90>:
80107455:	6a 00                	push   $0x0
80107457:	6a 5a                	push   $0x5a
80107459:	e9 a9 f5 ff ff       	jmp    80106a07 <alltraps>

8010745e <vector91>:
8010745e:	6a 00                	push   $0x0
80107460:	6a 5b                	push   $0x5b
80107462:	e9 a0 f5 ff ff       	jmp    80106a07 <alltraps>

80107467 <vector92>:
80107467:	6a 00                	push   $0x0
80107469:	6a 5c                	push   $0x5c
8010746b:	e9 97 f5 ff ff       	jmp    80106a07 <alltraps>

80107470 <vector93>:
80107470:	6a 00                	push   $0x0
80107472:	6a 5d                	push   $0x5d
80107474:	e9 8e f5 ff ff       	jmp    80106a07 <alltraps>

80107479 <vector94>:
80107479:	6a 00                	push   $0x0
8010747b:	6a 5e                	push   $0x5e
8010747d:	e9 85 f5 ff ff       	jmp    80106a07 <alltraps>

80107482 <vector95>:
80107482:	6a 00                	push   $0x0
80107484:	6a 5f                	push   $0x5f
80107486:	e9 7c f5 ff ff       	jmp    80106a07 <alltraps>

8010748b <vector96>:
8010748b:	6a 00                	push   $0x0
8010748d:	6a 60                	push   $0x60
8010748f:	e9 73 f5 ff ff       	jmp    80106a07 <alltraps>

80107494 <vector97>:
80107494:	6a 00                	push   $0x0
80107496:	6a 61                	push   $0x61
80107498:	e9 6a f5 ff ff       	jmp    80106a07 <alltraps>

8010749d <vector98>:
8010749d:	6a 00                	push   $0x0
8010749f:	6a 62                	push   $0x62
801074a1:	e9 61 f5 ff ff       	jmp    80106a07 <alltraps>

801074a6 <vector99>:
801074a6:	6a 00                	push   $0x0
801074a8:	6a 63                	push   $0x63
801074aa:	e9 58 f5 ff ff       	jmp    80106a07 <alltraps>

801074af <vector100>:
801074af:	6a 00                	push   $0x0
801074b1:	6a 64                	push   $0x64
801074b3:	e9 4f f5 ff ff       	jmp    80106a07 <alltraps>

801074b8 <vector101>:
801074b8:	6a 00                	push   $0x0
801074ba:	6a 65                	push   $0x65
801074bc:	e9 46 f5 ff ff       	jmp    80106a07 <alltraps>

801074c1 <vector102>:
801074c1:	6a 00                	push   $0x0
801074c3:	6a 66                	push   $0x66
801074c5:	e9 3d f5 ff ff       	jmp    80106a07 <alltraps>

801074ca <vector103>:
801074ca:	6a 00                	push   $0x0
801074cc:	6a 67                	push   $0x67
801074ce:	e9 34 f5 ff ff       	jmp    80106a07 <alltraps>

801074d3 <vector104>:
801074d3:	6a 00                	push   $0x0
801074d5:	6a 68                	push   $0x68
801074d7:	e9 2b f5 ff ff       	jmp    80106a07 <alltraps>

801074dc <vector105>:
801074dc:	6a 00                	push   $0x0
801074de:	6a 69                	push   $0x69
801074e0:	e9 22 f5 ff ff       	jmp    80106a07 <alltraps>

801074e5 <vector106>:
801074e5:	6a 00                	push   $0x0
801074e7:	6a 6a                	push   $0x6a
801074e9:	e9 19 f5 ff ff       	jmp    80106a07 <alltraps>

801074ee <vector107>:
801074ee:	6a 00                	push   $0x0
801074f0:	6a 6b                	push   $0x6b
801074f2:	e9 10 f5 ff ff       	jmp    80106a07 <alltraps>

801074f7 <vector108>:
801074f7:	6a 00                	push   $0x0
801074f9:	6a 6c                	push   $0x6c
801074fb:	e9 07 f5 ff ff       	jmp    80106a07 <alltraps>

80107500 <vector109>:
80107500:	6a 00                	push   $0x0
80107502:	6a 6d                	push   $0x6d
80107504:	e9 fe f4 ff ff       	jmp    80106a07 <alltraps>

80107509 <vector110>:
80107509:	6a 00                	push   $0x0
8010750b:	6a 6e                	push   $0x6e
8010750d:	e9 f5 f4 ff ff       	jmp    80106a07 <alltraps>

80107512 <vector111>:
80107512:	6a 00                	push   $0x0
80107514:	6a 6f                	push   $0x6f
80107516:	e9 ec f4 ff ff       	jmp    80106a07 <alltraps>

8010751b <vector112>:
8010751b:	6a 00                	push   $0x0
8010751d:	6a 70                	push   $0x70
8010751f:	e9 e3 f4 ff ff       	jmp    80106a07 <alltraps>

80107524 <vector113>:
80107524:	6a 00                	push   $0x0
80107526:	6a 71                	push   $0x71
80107528:	e9 da f4 ff ff       	jmp    80106a07 <alltraps>

8010752d <vector114>:
8010752d:	6a 00                	push   $0x0
8010752f:	6a 72                	push   $0x72
80107531:	e9 d1 f4 ff ff       	jmp    80106a07 <alltraps>

80107536 <vector115>:
80107536:	6a 00                	push   $0x0
80107538:	6a 73                	push   $0x73
8010753a:	e9 c8 f4 ff ff       	jmp    80106a07 <alltraps>

8010753f <vector116>:
8010753f:	6a 00                	push   $0x0
80107541:	6a 74                	push   $0x74
80107543:	e9 bf f4 ff ff       	jmp    80106a07 <alltraps>

80107548 <vector117>:
80107548:	6a 00                	push   $0x0
8010754a:	6a 75                	push   $0x75
8010754c:	e9 b6 f4 ff ff       	jmp    80106a07 <alltraps>

80107551 <vector118>:
80107551:	6a 00                	push   $0x0
80107553:	6a 76                	push   $0x76
80107555:	e9 ad f4 ff ff       	jmp    80106a07 <alltraps>

8010755a <vector119>:
8010755a:	6a 00                	push   $0x0
8010755c:	6a 77                	push   $0x77
8010755e:	e9 a4 f4 ff ff       	jmp    80106a07 <alltraps>

80107563 <vector120>:
80107563:	6a 00                	push   $0x0
80107565:	6a 78                	push   $0x78
80107567:	e9 9b f4 ff ff       	jmp    80106a07 <alltraps>

8010756c <vector121>:
8010756c:	6a 00                	push   $0x0
8010756e:	6a 79                	push   $0x79
80107570:	e9 92 f4 ff ff       	jmp    80106a07 <alltraps>

80107575 <vector122>:
80107575:	6a 00                	push   $0x0
80107577:	6a 7a                	push   $0x7a
80107579:	e9 89 f4 ff ff       	jmp    80106a07 <alltraps>

8010757e <vector123>:
8010757e:	6a 00                	push   $0x0
80107580:	6a 7b                	push   $0x7b
80107582:	e9 80 f4 ff ff       	jmp    80106a07 <alltraps>

80107587 <vector124>:
80107587:	6a 00                	push   $0x0
80107589:	6a 7c                	push   $0x7c
8010758b:	e9 77 f4 ff ff       	jmp    80106a07 <alltraps>

80107590 <vector125>:
80107590:	6a 00                	push   $0x0
80107592:	6a 7d                	push   $0x7d
80107594:	e9 6e f4 ff ff       	jmp    80106a07 <alltraps>

80107599 <vector126>:
80107599:	6a 00                	push   $0x0
8010759b:	6a 7e                	push   $0x7e
8010759d:	e9 65 f4 ff ff       	jmp    80106a07 <alltraps>

801075a2 <vector127>:
801075a2:	6a 00                	push   $0x0
801075a4:	6a 7f                	push   $0x7f
801075a6:	e9 5c f4 ff ff       	jmp    80106a07 <alltraps>

801075ab <vector128>:
801075ab:	6a 00                	push   $0x0
801075ad:	68 80 00 00 00       	push   $0x80
801075b2:	e9 50 f4 ff ff       	jmp    80106a07 <alltraps>

801075b7 <vector129>:
801075b7:	6a 00                	push   $0x0
801075b9:	68 81 00 00 00       	push   $0x81
801075be:	e9 44 f4 ff ff       	jmp    80106a07 <alltraps>

801075c3 <vector130>:
801075c3:	6a 00                	push   $0x0
801075c5:	68 82 00 00 00       	push   $0x82
801075ca:	e9 38 f4 ff ff       	jmp    80106a07 <alltraps>

801075cf <vector131>:
801075cf:	6a 00                	push   $0x0
801075d1:	68 83 00 00 00       	push   $0x83
801075d6:	e9 2c f4 ff ff       	jmp    80106a07 <alltraps>

801075db <vector132>:
801075db:	6a 00                	push   $0x0
801075dd:	68 84 00 00 00       	push   $0x84
801075e2:	e9 20 f4 ff ff       	jmp    80106a07 <alltraps>

801075e7 <vector133>:
801075e7:	6a 00                	push   $0x0
801075e9:	68 85 00 00 00       	push   $0x85
801075ee:	e9 14 f4 ff ff       	jmp    80106a07 <alltraps>

801075f3 <vector134>:
801075f3:	6a 00                	push   $0x0
801075f5:	68 86 00 00 00       	push   $0x86
801075fa:	e9 08 f4 ff ff       	jmp    80106a07 <alltraps>

801075ff <vector135>:
801075ff:	6a 00                	push   $0x0
80107601:	68 87 00 00 00       	push   $0x87
80107606:	e9 fc f3 ff ff       	jmp    80106a07 <alltraps>

8010760b <vector136>:
8010760b:	6a 00                	push   $0x0
8010760d:	68 88 00 00 00       	push   $0x88
80107612:	e9 f0 f3 ff ff       	jmp    80106a07 <alltraps>

80107617 <vector137>:
80107617:	6a 00                	push   $0x0
80107619:	68 89 00 00 00       	push   $0x89
8010761e:	e9 e4 f3 ff ff       	jmp    80106a07 <alltraps>

80107623 <vector138>:
80107623:	6a 00                	push   $0x0
80107625:	68 8a 00 00 00       	push   $0x8a
8010762a:	e9 d8 f3 ff ff       	jmp    80106a07 <alltraps>

8010762f <vector139>:
8010762f:	6a 00                	push   $0x0
80107631:	68 8b 00 00 00       	push   $0x8b
80107636:	e9 cc f3 ff ff       	jmp    80106a07 <alltraps>

8010763b <vector140>:
8010763b:	6a 00                	push   $0x0
8010763d:	68 8c 00 00 00       	push   $0x8c
80107642:	e9 c0 f3 ff ff       	jmp    80106a07 <alltraps>

80107647 <vector141>:
80107647:	6a 00                	push   $0x0
80107649:	68 8d 00 00 00       	push   $0x8d
8010764e:	e9 b4 f3 ff ff       	jmp    80106a07 <alltraps>

80107653 <vector142>:
80107653:	6a 00                	push   $0x0
80107655:	68 8e 00 00 00       	push   $0x8e
8010765a:	e9 a8 f3 ff ff       	jmp    80106a07 <alltraps>

8010765f <vector143>:
8010765f:	6a 00                	push   $0x0
80107661:	68 8f 00 00 00       	push   $0x8f
80107666:	e9 9c f3 ff ff       	jmp    80106a07 <alltraps>

8010766b <vector144>:
8010766b:	6a 00                	push   $0x0
8010766d:	68 90 00 00 00       	push   $0x90
80107672:	e9 90 f3 ff ff       	jmp    80106a07 <alltraps>

80107677 <vector145>:
80107677:	6a 00                	push   $0x0
80107679:	68 91 00 00 00       	push   $0x91
8010767e:	e9 84 f3 ff ff       	jmp    80106a07 <alltraps>

80107683 <vector146>:
80107683:	6a 00                	push   $0x0
80107685:	68 92 00 00 00       	push   $0x92
8010768a:	e9 78 f3 ff ff       	jmp    80106a07 <alltraps>

8010768f <vector147>:
8010768f:	6a 00                	push   $0x0
80107691:	68 93 00 00 00       	push   $0x93
80107696:	e9 6c f3 ff ff       	jmp    80106a07 <alltraps>

8010769b <vector148>:
8010769b:	6a 00                	push   $0x0
8010769d:	68 94 00 00 00       	push   $0x94
801076a2:	e9 60 f3 ff ff       	jmp    80106a07 <alltraps>

801076a7 <vector149>:
801076a7:	6a 00                	push   $0x0
801076a9:	68 95 00 00 00       	push   $0x95
801076ae:	e9 54 f3 ff ff       	jmp    80106a07 <alltraps>

801076b3 <vector150>:
801076b3:	6a 00                	push   $0x0
801076b5:	68 96 00 00 00       	push   $0x96
801076ba:	e9 48 f3 ff ff       	jmp    80106a07 <alltraps>

801076bf <vector151>:
801076bf:	6a 00                	push   $0x0
801076c1:	68 97 00 00 00       	push   $0x97
801076c6:	e9 3c f3 ff ff       	jmp    80106a07 <alltraps>

801076cb <vector152>:
801076cb:	6a 00                	push   $0x0
801076cd:	68 98 00 00 00       	push   $0x98
801076d2:	e9 30 f3 ff ff       	jmp    80106a07 <alltraps>

801076d7 <vector153>:
801076d7:	6a 00                	push   $0x0
801076d9:	68 99 00 00 00       	push   $0x99
801076de:	e9 24 f3 ff ff       	jmp    80106a07 <alltraps>

801076e3 <vector154>:
801076e3:	6a 00                	push   $0x0
801076e5:	68 9a 00 00 00       	push   $0x9a
801076ea:	e9 18 f3 ff ff       	jmp    80106a07 <alltraps>

801076ef <vector155>:
801076ef:	6a 00                	push   $0x0
801076f1:	68 9b 00 00 00       	push   $0x9b
801076f6:	e9 0c f3 ff ff       	jmp    80106a07 <alltraps>

801076fb <vector156>:
801076fb:	6a 00                	push   $0x0
801076fd:	68 9c 00 00 00       	push   $0x9c
80107702:	e9 00 f3 ff ff       	jmp    80106a07 <alltraps>

80107707 <vector157>:
80107707:	6a 00                	push   $0x0
80107709:	68 9d 00 00 00       	push   $0x9d
8010770e:	e9 f4 f2 ff ff       	jmp    80106a07 <alltraps>

80107713 <vector158>:
80107713:	6a 00                	push   $0x0
80107715:	68 9e 00 00 00       	push   $0x9e
8010771a:	e9 e8 f2 ff ff       	jmp    80106a07 <alltraps>

8010771f <vector159>:
8010771f:	6a 00                	push   $0x0
80107721:	68 9f 00 00 00       	push   $0x9f
80107726:	e9 dc f2 ff ff       	jmp    80106a07 <alltraps>

8010772b <vector160>:
8010772b:	6a 00                	push   $0x0
8010772d:	68 a0 00 00 00       	push   $0xa0
80107732:	e9 d0 f2 ff ff       	jmp    80106a07 <alltraps>

80107737 <vector161>:
80107737:	6a 00                	push   $0x0
80107739:	68 a1 00 00 00       	push   $0xa1
8010773e:	e9 c4 f2 ff ff       	jmp    80106a07 <alltraps>

80107743 <vector162>:
80107743:	6a 00                	push   $0x0
80107745:	68 a2 00 00 00       	push   $0xa2
8010774a:	e9 b8 f2 ff ff       	jmp    80106a07 <alltraps>

8010774f <vector163>:
8010774f:	6a 00                	push   $0x0
80107751:	68 a3 00 00 00       	push   $0xa3
80107756:	e9 ac f2 ff ff       	jmp    80106a07 <alltraps>

8010775b <vector164>:
8010775b:	6a 00                	push   $0x0
8010775d:	68 a4 00 00 00       	push   $0xa4
80107762:	e9 a0 f2 ff ff       	jmp    80106a07 <alltraps>

80107767 <vector165>:
80107767:	6a 00                	push   $0x0
80107769:	68 a5 00 00 00       	push   $0xa5
8010776e:	e9 94 f2 ff ff       	jmp    80106a07 <alltraps>

80107773 <vector166>:
80107773:	6a 00                	push   $0x0
80107775:	68 a6 00 00 00       	push   $0xa6
8010777a:	e9 88 f2 ff ff       	jmp    80106a07 <alltraps>

8010777f <vector167>:
8010777f:	6a 00                	push   $0x0
80107781:	68 a7 00 00 00       	push   $0xa7
80107786:	e9 7c f2 ff ff       	jmp    80106a07 <alltraps>

8010778b <vector168>:
8010778b:	6a 00                	push   $0x0
8010778d:	68 a8 00 00 00       	push   $0xa8
80107792:	e9 70 f2 ff ff       	jmp    80106a07 <alltraps>

80107797 <vector169>:
80107797:	6a 00                	push   $0x0
80107799:	68 a9 00 00 00       	push   $0xa9
8010779e:	e9 64 f2 ff ff       	jmp    80106a07 <alltraps>

801077a3 <vector170>:
801077a3:	6a 00                	push   $0x0
801077a5:	68 aa 00 00 00       	push   $0xaa
801077aa:	e9 58 f2 ff ff       	jmp    80106a07 <alltraps>

801077af <vector171>:
801077af:	6a 00                	push   $0x0
801077b1:	68 ab 00 00 00       	push   $0xab
801077b6:	e9 4c f2 ff ff       	jmp    80106a07 <alltraps>

801077bb <vector172>:
801077bb:	6a 00                	push   $0x0
801077bd:	68 ac 00 00 00       	push   $0xac
801077c2:	e9 40 f2 ff ff       	jmp    80106a07 <alltraps>

801077c7 <vector173>:
801077c7:	6a 00                	push   $0x0
801077c9:	68 ad 00 00 00       	push   $0xad
801077ce:	e9 34 f2 ff ff       	jmp    80106a07 <alltraps>

801077d3 <vector174>:
801077d3:	6a 00                	push   $0x0
801077d5:	68 ae 00 00 00       	push   $0xae
801077da:	e9 28 f2 ff ff       	jmp    80106a07 <alltraps>

801077df <vector175>:
801077df:	6a 00                	push   $0x0
801077e1:	68 af 00 00 00       	push   $0xaf
801077e6:	e9 1c f2 ff ff       	jmp    80106a07 <alltraps>

801077eb <vector176>:
801077eb:	6a 00                	push   $0x0
801077ed:	68 b0 00 00 00       	push   $0xb0
801077f2:	e9 10 f2 ff ff       	jmp    80106a07 <alltraps>

801077f7 <vector177>:
801077f7:	6a 00                	push   $0x0
801077f9:	68 b1 00 00 00       	push   $0xb1
801077fe:	e9 04 f2 ff ff       	jmp    80106a07 <alltraps>

80107803 <vector178>:
80107803:	6a 00                	push   $0x0
80107805:	68 b2 00 00 00       	push   $0xb2
8010780a:	e9 f8 f1 ff ff       	jmp    80106a07 <alltraps>

8010780f <vector179>:
8010780f:	6a 00                	push   $0x0
80107811:	68 b3 00 00 00       	push   $0xb3
80107816:	e9 ec f1 ff ff       	jmp    80106a07 <alltraps>

8010781b <vector180>:
8010781b:	6a 00                	push   $0x0
8010781d:	68 b4 00 00 00       	push   $0xb4
80107822:	e9 e0 f1 ff ff       	jmp    80106a07 <alltraps>

80107827 <vector181>:
80107827:	6a 00                	push   $0x0
80107829:	68 b5 00 00 00       	push   $0xb5
8010782e:	e9 d4 f1 ff ff       	jmp    80106a07 <alltraps>

80107833 <vector182>:
80107833:	6a 00                	push   $0x0
80107835:	68 b6 00 00 00       	push   $0xb6
8010783a:	e9 c8 f1 ff ff       	jmp    80106a07 <alltraps>

8010783f <vector183>:
8010783f:	6a 00                	push   $0x0
80107841:	68 b7 00 00 00       	push   $0xb7
80107846:	e9 bc f1 ff ff       	jmp    80106a07 <alltraps>

8010784b <vector184>:
8010784b:	6a 00                	push   $0x0
8010784d:	68 b8 00 00 00       	push   $0xb8
80107852:	e9 b0 f1 ff ff       	jmp    80106a07 <alltraps>

80107857 <vector185>:
80107857:	6a 00                	push   $0x0
80107859:	68 b9 00 00 00       	push   $0xb9
8010785e:	e9 a4 f1 ff ff       	jmp    80106a07 <alltraps>

80107863 <vector186>:
80107863:	6a 00                	push   $0x0
80107865:	68 ba 00 00 00       	push   $0xba
8010786a:	e9 98 f1 ff ff       	jmp    80106a07 <alltraps>

8010786f <vector187>:
8010786f:	6a 00                	push   $0x0
80107871:	68 bb 00 00 00       	push   $0xbb
80107876:	e9 8c f1 ff ff       	jmp    80106a07 <alltraps>

8010787b <vector188>:
8010787b:	6a 00                	push   $0x0
8010787d:	68 bc 00 00 00       	push   $0xbc
80107882:	e9 80 f1 ff ff       	jmp    80106a07 <alltraps>

80107887 <vector189>:
80107887:	6a 00                	push   $0x0
80107889:	68 bd 00 00 00       	push   $0xbd
8010788e:	e9 74 f1 ff ff       	jmp    80106a07 <alltraps>

80107893 <vector190>:
80107893:	6a 00                	push   $0x0
80107895:	68 be 00 00 00       	push   $0xbe
8010789a:	e9 68 f1 ff ff       	jmp    80106a07 <alltraps>

8010789f <vector191>:
8010789f:	6a 00                	push   $0x0
801078a1:	68 bf 00 00 00       	push   $0xbf
801078a6:	e9 5c f1 ff ff       	jmp    80106a07 <alltraps>

801078ab <vector192>:
801078ab:	6a 00                	push   $0x0
801078ad:	68 c0 00 00 00       	push   $0xc0
801078b2:	e9 50 f1 ff ff       	jmp    80106a07 <alltraps>

801078b7 <vector193>:
801078b7:	6a 00                	push   $0x0
801078b9:	68 c1 00 00 00       	push   $0xc1
801078be:	e9 44 f1 ff ff       	jmp    80106a07 <alltraps>

801078c3 <vector194>:
801078c3:	6a 00                	push   $0x0
801078c5:	68 c2 00 00 00       	push   $0xc2
801078ca:	e9 38 f1 ff ff       	jmp    80106a07 <alltraps>

801078cf <vector195>:
801078cf:	6a 00                	push   $0x0
801078d1:	68 c3 00 00 00       	push   $0xc3
801078d6:	e9 2c f1 ff ff       	jmp    80106a07 <alltraps>

801078db <vector196>:
801078db:	6a 00                	push   $0x0
801078dd:	68 c4 00 00 00       	push   $0xc4
801078e2:	e9 20 f1 ff ff       	jmp    80106a07 <alltraps>

801078e7 <vector197>:
801078e7:	6a 00                	push   $0x0
801078e9:	68 c5 00 00 00       	push   $0xc5
801078ee:	e9 14 f1 ff ff       	jmp    80106a07 <alltraps>

801078f3 <vector198>:
801078f3:	6a 00                	push   $0x0
801078f5:	68 c6 00 00 00       	push   $0xc6
801078fa:	e9 08 f1 ff ff       	jmp    80106a07 <alltraps>

801078ff <vector199>:
801078ff:	6a 00                	push   $0x0
80107901:	68 c7 00 00 00       	push   $0xc7
80107906:	e9 fc f0 ff ff       	jmp    80106a07 <alltraps>

8010790b <vector200>:
8010790b:	6a 00                	push   $0x0
8010790d:	68 c8 00 00 00       	push   $0xc8
80107912:	e9 f0 f0 ff ff       	jmp    80106a07 <alltraps>

80107917 <vector201>:
80107917:	6a 00                	push   $0x0
80107919:	68 c9 00 00 00       	push   $0xc9
8010791e:	e9 e4 f0 ff ff       	jmp    80106a07 <alltraps>

80107923 <vector202>:
80107923:	6a 00                	push   $0x0
80107925:	68 ca 00 00 00       	push   $0xca
8010792a:	e9 d8 f0 ff ff       	jmp    80106a07 <alltraps>

8010792f <vector203>:
8010792f:	6a 00                	push   $0x0
80107931:	68 cb 00 00 00       	push   $0xcb
80107936:	e9 cc f0 ff ff       	jmp    80106a07 <alltraps>

8010793b <vector204>:
8010793b:	6a 00                	push   $0x0
8010793d:	68 cc 00 00 00       	push   $0xcc
80107942:	e9 c0 f0 ff ff       	jmp    80106a07 <alltraps>

80107947 <vector205>:
80107947:	6a 00                	push   $0x0
80107949:	68 cd 00 00 00       	push   $0xcd
8010794e:	e9 b4 f0 ff ff       	jmp    80106a07 <alltraps>

80107953 <vector206>:
80107953:	6a 00                	push   $0x0
80107955:	68 ce 00 00 00       	push   $0xce
8010795a:	e9 a8 f0 ff ff       	jmp    80106a07 <alltraps>

8010795f <vector207>:
8010795f:	6a 00                	push   $0x0
80107961:	68 cf 00 00 00       	push   $0xcf
80107966:	e9 9c f0 ff ff       	jmp    80106a07 <alltraps>

8010796b <vector208>:
8010796b:	6a 00                	push   $0x0
8010796d:	68 d0 00 00 00       	push   $0xd0
80107972:	e9 90 f0 ff ff       	jmp    80106a07 <alltraps>

80107977 <vector209>:
80107977:	6a 00                	push   $0x0
80107979:	68 d1 00 00 00       	push   $0xd1
8010797e:	e9 84 f0 ff ff       	jmp    80106a07 <alltraps>

80107983 <vector210>:
80107983:	6a 00                	push   $0x0
80107985:	68 d2 00 00 00       	push   $0xd2
8010798a:	e9 78 f0 ff ff       	jmp    80106a07 <alltraps>

8010798f <vector211>:
8010798f:	6a 00                	push   $0x0
80107991:	68 d3 00 00 00       	push   $0xd3
80107996:	e9 6c f0 ff ff       	jmp    80106a07 <alltraps>

8010799b <vector212>:
8010799b:	6a 00                	push   $0x0
8010799d:	68 d4 00 00 00       	push   $0xd4
801079a2:	e9 60 f0 ff ff       	jmp    80106a07 <alltraps>

801079a7 <vector213>:
801079a7:	6a 00                	push   $0x0
801079a9:	68 d5 00 00 00       	push   $0xd5
801079ae:	e9 54 f0 ff ff       	jmp    80106a07 <alltraps>

801079b3 <vector214>:
801079b3:	6a 00                	push   $0x0
801079b5:	68 d6 00 00 00       	push   $0xd6
801079ba:	e9 48 f0 ff ff       	jmp    80106a07 <alltraps>

801079bf <vector215>:
801079bf:	6a 00                	push   $0x0
801079c1:	68 d7 00 00 00       	push   $0xd7
801079c6:	e9 3c f0 ff ff       	jmp    80106a07 <alltraps>

801079cb <vector216>:
801079cb:	6a 00                	push   $0x0
801079cd:	68 d8 00 00 00       	push   $0xd8
801079d2:	e9 30 f0 ff ff       	jmp    80106a07 <alltraps>

801079d7 <vector217>:
801079d7:	6a 00                	push   $0x0
801079d9:	68 d9 00 00 00       	push   $0xd9
801079de:	e9 24 f0 ff ff       	jmp    80106a07 <alltraps>

801079e3 <vector218>:
801079e3:	6a 00                	push   $0x0
801079e5:	68 da 00 00 00       	push   $0xda
801079ea:	e9 18 f0 ff ff       	jmp    80106a07 <alltraps>

801079ef <vector219>:
801079ef:	6a 00                	push   $0x0
801079f1:	68 db 00 00 00       	push   $0xdb
801079f6:	e9 0c f0 ff ff       	jmp    80106a07 <alltraps>

801079fb <vector220>:
801079fb:	6a 00                	push   $0x0
801079fd:	68 dc 00 00 00       	push   $0xdc
80107a02:	e9 00 f0 ff ff       	jmp    80106a07 <alltraps>

80107a07 <vector221>:
80107a07:	6a 00                	push   $0x0
80107a09:	68 dd 00 00 00       	push   $0xdd
80107a0e:	e9 f4 ef ff ff       	jmp    80106a07 <alltraps>

80107a13 <vector222>:
80107a13:	6a 00                	push   $0x0
80107a15:	68 de 00 00 00       	push   $0xde
80107a1a:	e9 e8 ef ff ff       	jmp    80106a07 <alltraps>

80107a1f <vector223>:
80107a1f:	6a 00                	push   $0x0
80107a21:	68 df 00 00 00       	push   $0xdf
80107a26:	e9 dc ef ff ff       	jmp    80106a07 <alltraps>

80107a2b <vector224>:
80107a2b:	6a 00                	push   $0x0
80107a2d:	68 e0 00 00 00       	push   $0xe0
80107a32:	e9 d0 ef ff ff       	jmp    80106a07 <alltraps>

80107a37 <vector225>:
80107a37:	6a 00                	push   $0x0
80107a39:	68 e1 00 00 00       	push   $0xe1
80107a3e:	e9 c4 ef ff ff       	jmp    80106a07 <alltraps>

80107a43 <vector226>:
80107a43:	6a 00                	push   $0x0
80107a45:	68 e2 00 00 00       	push   $0xe2
80107a4a:	e9 b8 ef ff ff       	jmp    80106a07 <alltraps>

80107a4f <vector227>:
80107a4f:	6a 00                	push   $0x0
80107a51:	68 e3 00 00 00       	push   $0xe3
80107a56:	e9 ac ef ff ff       	jmp    80106a07 <alltraps>

80107a5b <vector228>:
80107a5b:	6a 00                	push   $0x0
80107a5d:	68 e4 00 00 00       	push   $0xe4
80107a62:	e9 a0 ef ff ff       	jmp    80106a07 <alltraps>

80107a67 <vector229>:
80107a67:	6a 00                	push   $0x0
80107a69:	68 e5 00 00 00       	push   $0xe5
80107a6e:	e9 94 ef ff ff       	jmp    80106a07 <alltraps>

80107a73 <vector230>:
80107a73:	6a 00                	push   $0x0
80107a75:	68 e6 00 00 00       	push   $0xe6
80107a7a:	e9 88 ef ff ff       	jmp    80106a07 <alltraps>

80107a7f <vector231>:
80107a7f:	6a 00                	push   $0x0
80107a81:	68 e7 00 00 00       	push   $0xe7
80107a86:	e9 7c ef ff ff       	jmp    80106a07 <alltraps>

80107a8b <vector232>:
80107a8b:	6a 00                	push   $0x0
80107a8d:	68 e8 00 00 00       	push   $0xe8
80107a92:	e9 70 ef ff ff       	jmp    80106a07 <alltraps>

80107a97 <vector233>:
80107a97:	6a 00                	push   $0x0
80107a99:	68 e9 00 00 00       	push   $0xe9
80107a9e:	e9 64 ef ff ff       	jmp    80106a07 <alltraps>

80107aa3 <vector234>:
80107aa3:	6a 00                	push   $0x0
80107aa5:	68 ea 00 00 00       	push   $0xea
80107aaa:	e9 58 ef ff ff       	jmp    80106a07 <alltraps>

80107aaf <vector235>:
80107aaf:	6a 00                	push   $0x0
80107ab1:	68 eb 00 00 00       	push   $0xeb
80107ab6:	e9 4c ef ff ff       	jmp    80106a07 <alltraps>

80107abb <vector236>:
80107abb:	6a 00                	push   $0x0
80107abd:	68 ec 00 00 00       	push   $0xec
80107ac2:	e9 40 ef ff ff       	jmp    80106a07 <alltraps>

80107ac7 <vector237>:
80107ac7:	6a 00                	push   $0x0
80107ac9:	68 ed 00 00 00       	push   $0xed
80107ace:	e9 34 ef ff ff       	jmp    80106a07 <alltraps>

80107ad3 <vector238>:
80107ad3:	6a 00                	push   $0x0
80107ad5:	68 ee 00 00 00       	push   $0xee
80107ada:	e9 28 ef ff ff       	jmp    80106a07 <alltraps>

80107adf <vector239>:
80107adf:	6a 00                	push   $0x0
80107ae1:	68 ef 00 00 00       	push   $0xef
80107ae6:	e9 1c ef ff ff       	jmp    80106a07 <alltraps>

80107aeb <vector240>:
80107aeb:	6a 00                	push   $0x0
80107aed:	68 f0 00 00 00       	push   $0xf0
80107af2:	e9 10 ef ff ff       	jmp    80106a07 <alltraps>

80107af7 <vector241>:
80107af7:	6a 00                	push   $0x0
80107af9:	68 f1 00 00 00       	push   $0xf1
80107afe:	e9 04 ef ff ff       	jmp    80106a07 <alltraps>

80107b03 <vector242>:
80107b03:	6a 00                	push   $0x0
80107b05:	68 f2 00 00 00       	push   $0xf2
80107b0a:	e9 f8 ee ff ff       	jmp    80106a07 <alltraps>

80107b0f <vector243>:
80107b0f:	6a 00                	push   $0x0
80107b11:	68 f3 00 00 00       	push   $0xf3
80107b16:	e9 ec ee ff ff       	jmp    80106a07 <alltraps>

80107b1b <vector244>:
80107b1b:	6a 00                	push   $0x0
80107b1d:	68 f4 00 00 00       	push   $0xf4
80107b22:	e9 e0 ee ff ff       	jmp    80106a07 <alltraps>

80107b27 <vector245>:
80107b27:	6a 00                	push   $0x0
80107b29:	68 f5 00 00 00       	push   $0xf5
80107b2e:	e9 d4 ee ff ff       	jmp    80106a07 <alltraps>

80107b33 <vector246>:
80107b33:	6a 00                	push   $0x0
80107b35:	68 f6 00 00 00       	push   $0xf6
80107b3a:	e9 c8 ee ff ff       	jmp    80106a07 <alltraps>

80107b3f <vector247>:
80107b3f:	6a 00                	push   $0x0
80107b41:	68 f7 00 00 00       	push   $0xf7
80107b46:	e9 bc ee ff ff       	jmp    80106a07 <alltraps>

80107b4b <vector248>:
80107b4b:	6a 00                	push   $0x0
80107b4d:	68 f8 00 00 00       	push   $0xf8
80107b52:	e9 b0 ee ff ff       	jmp    80106a07 <alltraps>

80107b57 <vector249>:
80107b57:	6a 00                	push   $0x0
80107b59:	68 f9 00 00 00       	push   $0xf9
80107b5e:	e9 a4 ee ff ff       	jmp    80106a07 <alltraps>

80107b63 <vector250>:
80107b63:	6a 00                	push   $0x0
80107b65:	68 fa 00 00 00       	push   $0xfa
80107b6a:	e9 98 ee ff ff       	jmp    80106a07 <alltraps>

80107b6f <vector251>:
80107b6f:	6a 00                	push   $0x0
80107b71:	68 fb 00 00 00       	push   $0xfb
80107b76:	e9 8c ee ff ff       	jmp    80106a07 <alltraps>

80107b7b <vector252>:
80107b7b:	6a 00                	push   $0x0
80107b7d:	68 fc 00 00 00       	push   $0xfc
80107b82:	e9 80 ee ff ff       	jmp    80106a07 <alltraps>

80107b87 <vector253>:
80107b87:	6a 00                	push   $0x0
80107b89:	68 fd 00 00 00       	push   $0xfd
80107b8e:	e9 74 ee ff ff       	jmp    80106a07 <alltraps>

80107b93 <vector254>:
80107b93:	6a 00                	push   $0x0
80107b95:	68 fe 00 00 00       	push   $0xfe
80107b9a:	e9 68 ee ff ff       	jmp    80106a07 <alltraps>

80107b9f <vector255>:
80107b9f:	6a 00                	push   $0x0
80107ba1:	68 ff 00 00 00       	push   $0xff
80107ba6:	e9 5c ee ff ff       	jmp    80106a07 <alltraps>

80107bab <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107bab:	55                   	push   %ebp
80107bac:	89 e5                	mov    %esp,%ebp
80107bae:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bb4:	83 e8 01             	sub    $0x1,%eax
80107bb7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107bbb:	8b 45 08             	mov    0x8(%ebp),%eax
80107bbe:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107bc2:	8b 45 08             	mov    0x8(%ebp),%eax
80107bc5:	c1 e8 10             	shr    $0x10,%eax
80107bc8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107bcc:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107bcf:	0f 01 10             	lgdtl  (%eax)
}
80107bd2:	90                   	nop
80107bd3:	c9                   	leave  
80107bd4:	c3                   	ret    

80107bd5 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107bd5:	55                   	push   %ebp
80107bd6:	89 e5                	mov    %esp,%ebp
80107bd8:	83 ec 04             	sub    $0x4,%esp
80107bdb:	8b 45 08             	mov    0x8(%ebp),%eax
80107bde:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107be2:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107be6:	0f 00 d8             	ltr    %ax
}
80107be9:	90                   	nop
80107bea:	c9                   	leave  
80107beb:	c3                   	ret    

80107bec <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107bec:	55                   	push   %ebp
80107bed:	89 e5                	mov    %esp,%ebp
80107bef:	83 ec 04             	sub    $0x4,%esp
80107bf2:	8b 45 08             	mov    0x8(%ebp),%eax
80107bf5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107bf9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107bfd:	8e e8                	mov    %eax,%gs
}
80107bff:	90                   	nop
80107c00:	c9                   	leave  
80107c01:	c3                   	ret    

80107c02 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107c02:	55                   	push   %ebp
80107c03:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c05:	8b 45 08             	mov    0x8(%ebp),%eax
80107c08:	0f 22 d8             	mov    %eax,%cr3
}
80107c0b:	90                   	nop
80107c0c:	5d                   	pop    %ebp
80107c0d:	c3                   	ret    

80107c0e <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107c0e:	55                   	push   %ebp
80107c0f:	89 e5                	mov    %esp,%ebp
80107c11:	8b 45 08             	mov    0x8(%ebp),%eax
80107c14:	05 00 00 00 80       	add    $0x80000000,%eax
80107c19:	5d                   	pop    %ebp
80107c1a:	c3                   	ret    

80107c1b <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107c1b:	55                   	push   %ebp
80107c1c:	89 e5                	mov    %esp,%ebp
80107c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80107c21:	05 00 00 00 80       	add    $0x80000000,%eax
80107c26:	5d                   	pop    %ebp
80107c27:	c3                   	ret    

80107c28 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107c28:	55                   	push   %ebp
80107c29:	89 e5                	mov    %esp,%ebp
80107c2b:	53                   	push   %ebx
80107c2c:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107c2f:	e8 f7 b2 ff ff       	call   80102f2b <cpunum>
80107c34:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107c3a:	05 80 33 11 80       	add    $0x80113380,%eax
80107c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c45:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c4e:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c57:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c62:	83 e2 f0             	and    $0xfffffff0,%edx
80107c65:	83 ca 0a             	or     $0xa,%edx
80107c68:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c72:	83 ca 10             	or     $0x10,%edx
80107c75:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c7f:	83 e2 9f             	and    $0xffffff9f,%edx
80107c82:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c88:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c8c:	83 ca 80             	or     $0xffffff80,%edx
80107c8f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c95:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c99:	83 ca 0f             	or     $0xf,%edx
80107c9c:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ca6:	83 e2 ef             	and    $0xffffffef,%edx
80107ca9:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107caf:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cb3:	83 e2 df             	and    $0xffffffdf,%edx
80107cb6:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cbc:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cc0:	83 ca 40             	or     $0x40,%edx
80107cc3:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ccd:	83 ca 80             	or     $0xffffff80,%edx
80107cd0:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd6:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdd:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107ce4:	ff ff 
80107ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce9:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107cf0:	00 00 
80107cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf5:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cff:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d06:	83 e2 f0             	and    $0xfffffff0,%edx
80107d09:	83 ca 02             	or     $0x2,%edx
80107d0c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d15:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d1c:	83 ca 10             	or     $0x10,%edx
80107d1f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d28:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d2f:	83 e2 9f             	and    $0xffffff9f,%edx
80107d32:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d42:	83 ca 80             	or     $0xffffff80,%edx
80107d45:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d55:	83 ca 0f             	or     $0xf,%edx
80107d58:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d61:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d68:	83 e2 ef             	and    $0xffffffef,%edx
80107d6b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d74:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d7b:	83 e2 df             	and    $0xffffffdf,%edx
80107d7e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d87:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d8e:	83 ca 40             	or     $0x40,%edx
80107d91:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107da1:	83 ca 80             	or     $0xffffff80,%edx
80107da4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dad:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db7:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107dbe:	ff ff 
80107dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc3:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107dca:	00 00 
80107dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dcf:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd9:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107de0:	83 e2 f0             	and    $0xfffffff0,%edx
80107de3:	83 ca 0a             	or     $0xa,%edx
80107de6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107def:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107df6:	83 ca 10             	or     $0x10,%edx
80107df9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e02:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e09:	83 ca 60             	or     $0x60,%edx
80107e0c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e15:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e1c:	83 ca 80             	or     $0xffffff80,%edx
80107e1f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e28:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e2f:	83 ca 0f             	or     $0xf,%edx
80107e32:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e3b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e42:	83 e2 ef             	and    $0xffffffef,%edx
80107e45:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e55:	83 e2 df             	and    $0xffffffdf,%edx
80107e58:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e61:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e68:	83 ca 40             	or     $0x40,%edx
80107e6b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e74:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e7b:	83 ca 80             	or     $0xffffff80,%edx
80107e7e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e87:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e91:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107e98:	ff ff 
80107e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e9d:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107ea4:	00 00 
80107ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea9:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb3:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107eba:	83 e2 f0             	and    $0xfffffff0,%edx
80107ebd:	83 ca 02             	or     $0x2,%edx
80107ec0:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec9:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ed0:	83 ca 10             	or     $0x10,%edx
80107ed3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107edc:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ee3:	83 ca 60             	or     $0x60,%edx
80107ee6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eef:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ef6:	83 ca 80             	or     $0xffffff80,%edx
80107ef9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f02:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f09:	83 ca 0f             	or     $0xf,%edx
80107f0c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f15:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f1c:	83 e2 ef             	and    $0xffffffef,%edx
80107f1f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f28:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f2f:	83 e2 df             	and    $0xffffffdf,%edx
80107f32:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f42:	83 ca 40             	or     $0x40,%edx
80107f45:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f55:	83 ca 80             	or     $0xffffff80,%edx
80107f58:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f61:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6b:	05 b4 00 00 00       	add    $0xb4,%eax
80107f70:	89 c3                	mov    %eax,%ebx
80107f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f75:	05 b4 00 00 00       	add    $0xb4,%eax
80107f7a:	c1 e8 10             	shr    $0x10,%eax
80107f7d:	89 c2                	mov    %eax,%edx
80107f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f82:	05 b4 00 00 00       	add    $0xb4,%eax
80107f87:	c1 e8 18             	shr    $0x18,%eax
80107f8a:	89 c1                	mov    %eax,%ecx
80107f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8f:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107f96:	00 00 
80107f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9b:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa5:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fae:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107fb5:	83 e2 f0             	and    $0xfffffff0,%edx
80107fb8:	83 ca 02             	or     $0x2,%edx
80107fbb:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc4:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107fcb:	83 ca 10             	or     $0x10,%edx
80107fce:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd7:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107fde:	83 e2 9f             	and    $0xffffff9f,%edx
80107fe1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fea:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107ff1:	83 ca 80             	or     $0xffffff80,%edx
80107ff4:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffd:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108004:	83 e2 f0             	and    $0xfffffff0,%edx
80108007:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010800d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108010:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108017:	83 e2 ef             	and    $0xffffffef,%edx
8010801a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108023:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010802a:	83 e2 df             	and    $0xffffffdf,%edx
8010802d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108036:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010803d:	83 ca 40             	or     $0x40,%edx
80108040:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108046:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108049:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108050:	83 ca 80             	or     $0xffffff80,%edx
80108053:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108059:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805c:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108062:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108065:	83 c0 70             	add    $0x70,%eax
80108068:	83 ec 08             	sub    $0x8,%esp
8010806b:	6a 38                	push   $0x38
8010806d:	50                   	push   %eax
8010806e:	e8 38 fb ff ff       	call   80107bab <lgdt>
80108073:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108076:	83 ec 0c             	sub    $0xc,%esp
80108079:	6a 18                	push   $0x18
8010807b:	e8 6c fb ff ff       	call   80107bec <loadgs>
80108080:	83 c4 10             	add    $0x10,%esp

  // Initialize cpu-local storage.
  cpu = c;
80108083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108086:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010808c:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108093:	00 00 00 00 
}
80108097:	90                   	nop
80108098:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010809b:	c9                   	leave  
8010809c:	c3                   	ret    

8010809d <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010809d:	55                   	push   %ebp
8010809e:	89 e5                	mov    %esp,%ebp
801080a0:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801080a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801080a6:	c1 e8 16             	shr    $0x16,%eax
801080a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801080b0:	8b 45 08             	mov    0x8(%ebp),%eax
801080b3:	01 d0                	add    %edx,%eax
801080b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801080b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080bb:	8b 00                	mov    (%eax),%eax
801080bd:	83 e0 01             	and    $0x1,%eax
801080c0:	85 c0                	test   %eax,%eax
801080c2:	74 18                	je     801080dc <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801080c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080c7:	8b 00                	mov    (%eax),%eax
801080c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080ce:	50                   	push   %eax
801080cf:	e8 47 fb ff ff       	call   80107c1b <p2v>
801080d4:	83 c4 04             	add    $0x4,%esp
801080d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080da:	eb 48                	jmp    80108124 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801080dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801080e0:	74 0e                	je     801080f0 <walkpgdir+0x53>
801080e2:	e8 de aa ff ff       	call   80102bc5 <kalloc>
801080e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801080ee:	75 07                	jne    801080f7 <walkpgdir+0x5a>
      return 0;
801080f0:	b8 00 00 00 00       	mov    $0x0,%eax
801080f5:	eb 44                	jmp    8010813b <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801080f7:	83 ec 04             	sub    $0x4,%esp
801080fa:	68 00 10 00 00       	push   $0x1000
801080ff:	6a 00                	push   $0x0
80108101:	ff 75 f4             	pushl  -0xc(%ebp)
80108104:	e8 d7 d3 ff ff       	call   801054e0 <memset>
80108109:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U
8010810c:	83 ec 0c             	sub    $0xc,%esp
8010810f:	ff 75 f4             	pushl  -0xc(%ebp)
80108112:	e8 f7 fa ff ff       	call   80107c0e <v2p>
80108117:	83 c4 10             	add    $0x10,%esp
8010811a:	83 c8 07             	or     $0x7,%eax
8010811d:	89 c2                	mov    %eax,%edx
8010811f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108122:	89 10                	mov    %edx,(%eax)
;  }
  return &pgtab[PTX(va)];
80108124:	8b 45 0c             	mov    0xc(%ebp),%eax
80108127:	c1 e8 0c             	shr    $0xc,%eax
8010812a:	25 ff 03 00 00       	and    $0x3ff,%eax
8010812f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108136:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108139:	01 d0                	add    %edx,%eax
}
8010813b:	c9                   	leave  
8010813c:	c3                   	ret    

8010813d <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010813d:	55                   	push   %ebp
8010813e:	89 e5                	mov    %esp,%ebp
80108140:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80108143:	8b 45 0c             	mov    0xc(%ebp),%eax
80108146:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010814b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010814e:	8b 55 0c             	mov    0xc(%ebp),%edx
80108151:	8b 45 10             	mov    0x10(%ebp),%eax
80108154:	01 d0                	add    %edx,%eax
80108156:	83 e8 01             	sub    $0x1,%eax
80108159:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010815e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108161:	83 ec 04             	sub    $0x4,%esp
80108164:	6a 01                	push   $0x1
80108166:	ff 75 f4             	pushl  -0xc(%ebp)
80108169:	ff 75 08             	pushl  0x8(%ebp)
8010816c:	e8 2c ff ff ff       	call   8010809d <walkpgdir>
80108171:	83 c4 10             	add    $0x10,%esp
80108174:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108177:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010817b:	75 07                	jne    80108184 <mappages+0x47>
      return -1;
8010817d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108182:	eb 47                	jmp    801081cb <mappages+0x8e>
    if(*pte & PTE_P)
80108184:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108187:	8b 00                	mov    (%eax),%eax
80108189:	83 e0 01             	and    $0x1,%eax
8010818c:	85 c0                	test   %eax,%eax
8010818e:	74 0d                	je     8010819d <mappages+0x60>
      panic("remap");
80108190:	83 ec 0c             	sub    $0xc,%esp
80108193:	68 78 91 10 80       	push   $0x80109178
80108198:	e8 c9 83 ff ff       	call   80100566 <panic>
  //  page_references[PTE_ADDR(*pte)] = 1; //give pte_t a reference of one since fork copy just stopped there
    *pte = pa | perm | PTE_P;
8010819d:	8b 45 18             	mov    0x18(%ebp),%eax
801081a0:	0b 45 14             	or     0x14(%ebp),%eax
801081a3:	83 c8 01             	or     $0x1,%eax
801081a6:	89 c2                	mov    %eax,%edx
801081a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081ab:	89 10                	mov    %edx,(%eax)
    if(a == last)
801081ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801081b3:	74 10                	je     801081c5 <mappages+0x88>
      break;
    a += PGSIZE;
801081b5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801081bc:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801081c3:	eb 9c                	jmp    80108161 <mappages+0x24>
    if(*pte & PTE_P)
      panic("remap");
  //  page_references[PTE_ADDR(*pte)] = 1; //give pte_t a reference of one since fork copy just stopped there
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801081c5:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801081c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081cb:	c9                   	leave  
801081cc:	c3                   	ret    

801081cd <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801081cd:	55                   	push   %ebp
801081ce:	89 e5                	mov    %esp,%ebp
801081d0:	53                   	push   %ebx
801081d1:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801081d4:	e8 ec a9 ff ff       	call   80102bc5 <kalloc>
801081d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801081dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081e0:	75 0a                	jne    801081ec <setupkvm+0x1f>
    return 0;
801081e2:	b8 00 00 00 00       	mov    $0x0,%eax
801081e7:	e9 8e 00 00 00       	jmp    8010827a <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801081ec:	83 ec 04             	sub    $0x4,%esp
801081ef:	68 00 10 00 00       	push   $0x1000
801081f4:	6a 00                	push   $0x0
801081f6:	ff 75 f0             	pushl  -0x10(%ebp)
801081f9:	e8 e2 d2 ff ff       	call   801054e0 <memset>
801081fe:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108201:	83 ec 0c             	sub    $0xc,%esp
80108204:	68 00 00 00 0e       	push   $0xe000000
80108209:	e8 0d fa ff ff       	call   80107c1b <p2v>
8010820e:	83 c4 10             	add    $0x10,%esp
80108211:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108216:	76 0d                	jbe    80108225 <setupkvm+0x58>
    panic("PHYSTOP too high");
80108218:	83 ec 0c             	sub    $0xc,%esp
8010821b:	68 7e 91 10 80       	push   $0x8010917e
80108220:	e8 41 83 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108225:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
8010822c:	eb 40                	jmp    8010826e <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010822e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108231:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108237:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010823a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823d:	8b 58 08             	mov    0x8(%eax),%ebx
80108240:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108243:	8b 40 04             	mov    0x4(%eax),%eax
80108246:	29 c3                	sub    %eax,%ebx
80108248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010824b:	8b 00                	mov    (%eax),%eax
8010824d:	83 ec 0c             	sub    $0xc,%esp
80108250:	51                   	push   %ecx
80108251:	52                   	push   %edx
80108252:	53                   	push   %ebx
80108253:	50                   	push   %eax
80108254:	ff 75 f0             	pushl  -0x10(%ebp)
80108257:	e8 e1 fe ff ff       	call   8010813d <mappages>
8010825c:	83 c4 20             	add    $0x20,%esp
8010825f:	85 c0                	test   %eax,%eax
80108261:	79 07                	jns    8010826a <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108263:	b8 00 00 00 00       	mov    $0x0,%eax
80108268:	eb 10                	jmp    8010827a <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010826a:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010826e:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108275:	72 b7                	jb     8010822e <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108277:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010827a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010827d:	c9                   	leave  
8010827e:	c3                   	ret    

8010827f <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010827f:	55                   	push   %ebp
80108280:	89 e5                	mov    %esp,%ebp
80108282:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108285:	e8 43 ff ff ff       	call   801081cd <setupkvm>
8010828a:	a3 58 64 11 80       	mov    %eax,0x80116458
  switchkvm();
8010828f:	e8 03 00 00 00       	call   80108297 <switchkvm>
}
80108294:	90                   	nop
80108295:	c9                   	leave  
80108296:	c3                   	ret    

80108297 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108297:	55                   	push   %ebp
80108298:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010829a:	a1 58 64 11 80       	mov    0x80116458,%eax
8010829f:	50                   	push   %eax
801082a0:	e8 69 f9 ff ff       	call   80107c0e <v2p>
801082a5:	83 c4 04             	add    $0x4,%esp
801082a8:	50                   	push   %eax
801082a9:	e8 54 f9 ff ff       	call   80107c02 <lcr3>
801082ae:	83 c4 04             	add    $0x4,%esp
}
801082b1:	90                   	nop
801082b2:	c9                   	leave  
801082b3:	c3                   	ret    

801082b4 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801082b4:	55                   	push   %ebp
801082b5:	89 e5                	mov    %esp,%ebp
801082b7:	56                   	push   %esi
801082b8:	53                   	push   %ebx
  pushcli();
801082b9:	e8 1c d1 ff ff       	call   801053da <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801082be:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801082c4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082cb:	83 c2 08             	add    $0x8,%edx
801082ce:	89 d6                	mov    %edx,%esi
801082d0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082d7:	83 c2 08             	add    $0x8,%edx
801082da:	c1 ea 10             	shr    $0x10,%edx
801082dd:	89 d3                	mov    %edx,%ebx
801082df:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082e6:	83 c2 08             	add    $0x8,%edx
801082e9:	c1 ea 18             	shr    $0x18,%edx
801082ec:	89 d1                	mov    %edx,%ecx
801082ee:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801082f5:	67 00 
801082f7:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801082fe:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108304:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010830b:	83 e2 f0             	and    $0xfffffff0,%edx
8010830e:	83 ca 09             	or     $0x9,%edx
80108311:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108317:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010831e:	83 ca 10             	or     $0x10,%edx
80108321:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108327:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010832e:	83 e2 9f             	and    $0xffffff9f,%edx
80108331:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108337:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010833e:	83 ca 80             	or     $0xffffff80,%edx
80108341:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108347:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010834e:	83 e2 f0             	and    $0xfffffff0,%edx
80108351:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108357:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010835e:	83 e2 ef             	and    $0xffffffef,%edx
80108361:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108367:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010836e:	83 e2 df             	and    $0xffffffdf,%edx
80108371:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108377:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010837e:	83 ca 40             	or     $0x40,%edx
80108381:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108387:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010838e:	83 e2 7f             	and    $0x7f,%edx
80108391:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108397:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010839d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083a3:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083aa:	83 e2 ef             	and    $0xffffffef,%edx
801083ad:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801083b3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083b9:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801083bf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083c5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801083cc:	8b 52 08             	mov    0x8(%edx),%edx
801083cf:	81 c2 00 10 00 00    	add    $0x1000,%edx
801083d5:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801083d8:	83 ec 0c             	sub    $0xc,%esp
801083db:	6a 30                	push   $0x30
801083dd:	e8 f3 f7 ff ff       	call   80107bd5 <ltr>
801083e2:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801083e5:	8b 45 08             	mov    0x8(%ebp),%eax
801083e8:	8b 40 04             	mov    0x4(%eax),%eax
801083eb:	85 c0                	test   %eax,%eax
801083ed:	75 0d                	jne    801083fc <switchuvm+0x148>
    panic("switchuvm: no pgdir");
801083ef:	83 ec 0c             	sub    $0xc,%esp
801083f2:	68 8f 91 10 80       	push   $0x8010918f
801083f7:	e8 6a 81 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801083fc:	8b 45 08             	mov    0x8(%ebp),%eax
801083ff:	8b 40 04             	mov    0x4(%eax),%eax
80108402:	83 ec 0c             	sub    $0xc,%esp
80108405:	50                   	push   %eax
80108406:	e8 03 f8 ff ff       	call   80107c0e <v2p>
8010840b:	83 c4 10             	add    $0x10,%esp
8010840e:	83 ec 0c             	sub    $0xc,%esp
80108411:	50                   	push   %eax
80108412:	e8 eb f7 ff ff       	call   80107c02 <lcr3>
80108417:	83 c4 10             	add    $0x10,%esp
  popcli();
8010841a:	e8 00 d0 ff ff       	call   8010541f <popcli>
}
8010841f:	90                   	nop
80108420:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108423:	5b                   	pop    %ebx
80108424:	5e                   	pop    %esi
80108425:	5d                   	pop    %ebp
80108426:	c3                   	ret    

80108427 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108427:	55                   	push   %ebp
80108428:	89 e5                	mov    %esp,%ebp
8010842a:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
8010842d:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108434:	76 0d                	jbe    80108443 <inituvm+0x1c>
    panic("inituvm: more than a page");
80108436:	83 ec 0c             	sub    $0xc,%esp
80108439:	68 a3 91 10 80       	push   $0x801091a3
8010843e:	e8 23 81 ff ff       	call   80100566 <panic>
  mem = kalloc();
80108443:	e8 7d a7 ff ff       	call   80102bc5 <kalloc>
80108448:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010844b:	83 ec 04             	sub    $0x4,%esp
8010844e:	68 00 10 00 00       	push   $0x1000
80108453:	6a 00                	push   $0x0
80108455:	ff 75 f4             	pushl  -0xc(%ebp)
80108458:	e8 83 d0 ff ff       	call   801054e0 <memset>
8010845d:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108460:	83 ec 0c             	sub    $0xc,%esp
80108463:	ff 75 f4             	pushl  -0xc(%ebp)
80108466:	e8 a3 f7 ff ff       	call   80107c0e <v2p>
8010846b:	83 c4 10             	add    $0x10,%esp
8010846e:	83 ec 0c             	sub    $0xc,%esp
80108471:	6a 06                	push   $0x6
80108473:	50                   	push   %eax
80108474:	68 00 10 00 00       	push   $0x1000
80108479:	6a 00                	push   $0x0
8010847b:	ff 75 08             	pushl  0x8(%ebp)
8010847e:	e8 ba fc ff ff       	call   8010813d <mappages>
80108483:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108486:	83 ec 04             	sub    $0x4,%esp
80108489:	ff 75 10             	pushl  0x10(%ebp)
8010848c:	ff 75 0c             	pushl  0xc(%ebp)
8010848f:	ff 75 f4             	pushl  -0xc(%ebp)
80108492:	e8 08 d1 ff ff       	call   8010559f <memmove>
80108497:	83 c4 10             	add    $0x10,%esp
}
8010849a:	90                   	nop
8010849b:	c9                   	leave  
8010849c:	c3                   	ret    

8010849d <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010849d:	55                   	push   %ebp
8010849e:	89 e5                	mov    %esp,%ebp
801084a0:	53                   	push   %ebx
801084a1:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801084a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801084a7:	25 ff 0f 00 00       	and    $0xfff,%eax
801084ac:	85 c0                	test   %eax,%eax
801084ae:	74 0d                	je     801084bd <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801084b0:	83 ec 0c             	sub    $0xc,%esp
801084b3:	68 c0 91 10 80       	push   $0x801091c0
801084b8:	e8 a9 80 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801084bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801084c4:	e9 95 00 00 00       	jmp    8010855e <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801084c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801084cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084cf:	01 d0                	add    %edx,%eax
801084d1:	83 ec 04             	sub    $0x4,%esp
801084d4:	6a 00                	push   $0x0
801084d6:	50                   	push   %eax
801084d7:	ff 75 08             	pushl  0x8(%ebp)
801084da:	e8 be fb ff ff       	call   8010809d <walkpgdir>
801084df:	83 c4 10             	add    $0x10,%esp
801084e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
801084e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801084e9:	75 0d                	jne    801084f8 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801084eb:	83 ec 0c             	sub    $0xc,%esp
801084ee:	68 e3 91 10 80       	push   $0x801091e3
801084f3:	e8 6e 80 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801084f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084fb:	8b 00                	mov    (%eax),%eax
801084fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108502:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108505:	8b 45 18             	mov    0x18(%ebp),%eax
80108508:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010850b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108510:	77 0b                	ja     8010851d <loaduvm+0x80>
      n = sz - i;
80108512:	8b 45 18             	mov    0x18(%ebp),%eax
80108515:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108518:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010851b:	eb 07                	jmp    80108524 <loaduvm+0x87>
    else
      n = PGSIZE;
8010851d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108524:	8b 55 14             	mov    0x14(%ebp),%edx
80108527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010852a:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010852d:	83 ec 0c             	sub    $0xc,%esp
80108530:	ff 75 e8             	pushl  -0x18(%ebp)
80108533:	e8 e3 f6 ff ff       	call   80107c1b <p2v>
80108538:	83 c4 10             	add    $0x10,%esp
8010853b:	ff 75 f0             	pushl  -0x10(%ebp)
8010853e:	53                   	push   %ebx
8010853f:	50                   	push   %eax
80108540:	ff 75 10             	pushl  0x10(%ebp)
80108543:	e8 2b 99 ff ff       	call   80101e73 <readi>
80108548:	83 c4 10             	add    $0x10,%esp
8010854b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010854e:	74 07                	je     80108557 <loaduvm+0xba>
      return -1;
80108550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108555:	eb 18                	jmp    8010856f <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108557:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010855e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108561:	3b 45 18             	cmp    0x18(%ebp),%eax
80108564:	0f 82 5f ff ff ff    	jb     801084c9 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010856a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010856f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108572:	c9                   	leave  
80108573:	c3                   	ret    

80108574 <mprotect>:

int
mprotect(void *addr, int len, int prot)
{
80108574:	55                   	push   %ebp
80108575:	89 e5                	mov    %esp,%ebp
80108577:	83 ec 18             	sub    $0x18,%esp
  pte_t *page_table_entry;
  //might need to PGRDWN the address
  //loop through all the page entries that need protection level changed
  //makes prot cnstants change in types.h
  //break it down, use PTE
  uint base_addr = PGROUNDDOWN((uint)addr);
8010857a:	8b 45 08             	mov    0x8(%ebp),%eax
8010857d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108582:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint curr = base_addr;
80108585:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108588:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cprintf(" Got to my mprotect!\n");
8010858b:	83 ec 0c             	sub    $0xc,%esp
8010858e:	68 01 92 10 80       	push   $0x80109201
80108593:	e8 2e 7e ff ff       	call   801003c6 <cprintf>
80108598:	83 c4 10             	add    $0x10,%esp
  do {

    page_table_entry = walkpgdir(proc->pgdir,(void *)curr ,0);
8010859b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010859e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085a4:	8b 40 04             	mov    0x4(%eax),%eax
801085a7:	83 ec 04             	sub    $0x4,%esp
801085aa:	6a 00                	push   $0x0
801085ac:	52                   	push   %edx
801085ad:	50                   	push   %eax
801085ae:	e8 ea fa ff ff       	call   8010809d <walkpgdir>
801085b3:	83 c4 10             	add    $0x10,%esp
801085b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    curr += PGSIZE;
801085b9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    //clear last 3 bits
    cprintf("page table entry before: 0x%x desireced prot = %d\n",*page_table_entry,prot);
801085c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085c3:	8b 00                	mov    (%eax),%eax
801085c5:	83 ec 04             	sub    $0x4,%esp
801085c8:	ff 75 10             	pushl  0x10(%ebp)
801085cb:	50                   	push   %eax
801085cc:	68 18 92 10 80       	push   $0x80109218
801085d1:	e8 f0 7d ff ff       	call   801003c6 <cprintf>
801085d6:	83 c4 10             	add    $0x10,%esp

    // *page_table_entry &= 0xfffffff9;
    // cprintf("page table entry after clear: 0x%x\n",*page_table_entry);
    switch(prot) {
801085d9:	8b 45 10             	mov    0x10(%ebp),%eax
801085dc:	83 f8 01             	cmp    $0x1,%eax
801085df:	74 28                	je     80108609 <mprotect+0x95>
801085e1:	83 f8 01             	cmp    $0x1,%eax
801085e4:	7f 06                	jg     801085ec <mprotect+0x78>
801085e6:	85 c0                	test   %eax,%eax
801085e8:	74 0e                	je     801085f8 <mprotect+0x84>
801085ea:	eb 4e                	jmp    8010863a <mprotect+0xc6>
801085ec:	83 f8 02             	cmp    $0x2,%eax
801085ef:	74 29                	je     8010861a <mprotect+0xa6>
801085f1:	83 f8 03             	cmp    $0x3,%eax
801085f4:	74 35                	je     8010862b <mprotect+0xb7>
801085f6:	eb 42                	jmp    8010863a <mprotect+0xc6>
      case PROT_NONE:
        *page_table_entry &= ~(PTE_U | PTE_W);
801085f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085fb:	8b 00                	mov    (%eax),%eax
801085fd:	83 e0 f9             	and    $0xfffffff9,%eax
80108600:	89 c2                	mov    %eax,%edx
80108602:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108605:	89 10                	mov    %edx,(%eax)
        break;
80108607:	eb 31                	jmp    8010863a <mprotect+0xc6>
      case PROT_READ: //good
        *page_table_entry &= (~PTE_W |PTE_U);
80108609:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010860c:	8b 00                	mov    (%eax),%eax
8010860e:	83 e0 fd             	and    $0xfffffffd,%eax
80108611:	89 c2                	mov    %eax,%edx
80108613:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108616:	89 10                	mov    %edx,(%eax)
        break;
80108618:	eb 20                	jmp    8010863a <mprotect+0xc6>
      case PROT_WRITE:
        *page_table_entry |= (PTE_P | PTE_W);
8010861a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010861d:	8b 00                	mov    (%eax),%eax
8010861f:	83 c8 03             	or     $0x3,%eax
80108622:	89 c2                	mov    %eax,%edx
80108624:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108627:	89 10                	mov    %edx,(%eax)
        break;
80108629:	eb 0f                	jmp    8010863a <mprotect+0xc6>
      case PROT_READ | PROT_WRITE: //good
        *page_table_entry |= (PTE_P | PTE_W | PTE_U);
8010862b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010862e:	8b 00                	mov    (%eax),%eax
80108630:	83 c8 07             	or     $0x7,%eax
80108633:	89 c2                	mov    %eax,%edx
80108635:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108638:	89 10                	mov    %edx,(%eax)
    }
    cprintf("page table entry after: 0x%x\n",*page_table_entry);
8010863a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010863d:	8b 00                	mov    (%eax),%eax
8010863f:	83 ec 08             	sub    $0x8,%esp
80108642:	50                   	push   %eax
80108643:	68 4b 92 10 80       	push   $0x8010924b
80108648:	e8 79 7d ff ff       	call   801003c6 <cprintf>
8010864d:	83 c4 10             	add    $0x10,%esp
  } while(curr < ((uint)addr +len));
80108650:	8b 55 08             	mov    0x8(%ebp),%edx
80108653:	8b 45 0c             	mov    0xc(%ebp),%eax
80108656:	01 d0                	add    %edx,%eax
80108658:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010865b:	0f 87 3a ff ff ff    	ja     8010859b <mprotect+0x27>

  cprintf("FLUSHING TLB!\n");
80108661:	83 ec 0c             	sub    $0xc,%esp
80108664:	68 69 92 10 80       	push   $0x80109269
80108669:	e8 58 7d ff ff       	call   801003c6 <cprintf>
8010866e:	83 c4 10             	add    $0x10,%esp
  //flush that tlb real good
  lcr3(v2p(proc->pgdir));
80108671:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108677:	8b 40 04             	mov    0x4(%eax),%eax
8010867a:	83 ec 0c             	sub    $0xc,%esp
8010867d:	50                   	push   %eax
8010867e:	e8 8b f5 ff ff       	call   80107c0e <v2p>
80108683:	83 c4 10             	add    $0x10,%esp
80108686:	83 ec 0c             	sub    $0xc,%esp
80108689:	50                   	push   %eax
8010868a:	e8 73 f5 ff ff       	call   80107c02 <lcr3>
8010868f:	83 c4 10             	add    $0x10,%esp
  return 0; ///what happens after returned?
80108692:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108697:	c9                   	leave  
80108698:	c3                   	ret    

80108699 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108699:	55                   	push   %ebp
8010869a:	89 e5                	mov    %esp,%ebp
8010869c:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010869f:	8b 45 10             	mov    0x10(%ebp),%eax
801086a2:	85 c0                	test   %eax,%eax
801086a4:	79 0a                	jns    801086b0 <allocuvm+0x17>
    return 0;
801086a6:	b8 00 00 00 00       	mov    $0x0,%eax
801086ab:	e9 b0 00 00 00       	jmp    80108760 <allocuvm+0xc7>
  if(newsz < oldsz)
801086b0:	8b 45 10             	mov    0x10(%ebp),%eax
801086b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086b6:	73 08                	jae    801086c0 <allocuvm+0x27>
    return oldsz;
801086b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801086bb:	e9 a0 00 00 00       	jmp    80108760 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
801086c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801086c3:	05 ff 0f 00 00       	add    $0xfff,%eax
801086c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801086d0:	eb 7f                	jmp    80108751 <allocuvm+0xb8>
    mem = kalloc();
801086d2:	e8 ee a4 ff ff       	call   80102bc5 <kalloc>
801086d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801086da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801086de:	75 2b                	jne    8010870b <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
801086e0:	83 ec 0c             	sub    $0xc,%esp
801086e3:	68 78 92 10 80       	push   $0x80109278
801086e8:	e8 d9 7c ff ff       	call   801003c6 <cprintf>
801086ed:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801086f0:	83 ec 04             	sub    $0x4,%esp
801086f3:	ff 75 0c             	pushl  0xc(%ebp)
801086f6:	ff 75 10             	pushl  0x10(%ebp)
801086f9:	ff 75 08             	pushl  0x8(%ebp)
801086fc:	e8 61 00 00 00       	call   80108762 <deallocuvm>
80108701:	83 c4 10             	add    $0x10,%esp
      return 0;
80108704:	b8 00 00 00 00       	mov    $0x0,%eax
80108709:	eb 55                	jmp    80108760 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
8010870b:	83 ec 04             	sub    $0x4,%esp
8010870e:	68 00 10 00 00       	push   $0x1000
80108713:	6a 00                	push   $0x0
80108715:	ff 75 f0             	pushl  -0x10(%ebp)
80108718:	e8 c3 cd ff ff       	call   801054e0 <memset>
8010871d:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108720:	83 ec 0c             	sub    $0xc,%esp
80108723:	ff 75 f0             	pushl  -0x10(%ebp)
80108726:	e8 e3 f4 ff ff       	call   80107c0e <v2p>
8010872b:	83 c4 10             	add    $0x10,%esp
8010872e:	89 c2                	mov    %eax,%edx
80108730:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108733:	83 ec 0c             	sub    $0xc,%esp
80108736:	6a 06                	push   $0x6
80108738:	52                   	push   %edx
80108739:	68 00 10 00 00       	push   $0x1000
8010873e:	50                   	push   %eax
8010873f:	ff 75 08             	pushl  0x8(%ebp)
80108742:	e8 f6 f9 ff ff       	call   8010813d <mappages>
80108747:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010874a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108754:	3b 45 10             	cmp    0x10(%ebp),%eax
80108757:	0f 82 75 ff ff ff    	jb     801086d2 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010875d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108760:	c9                   	leave  
80108761:	c3                   	ret    

80108762 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108762:	55                   	push   %ebp
80108763:	89 e5                	mov    %esp,%ebp
80108765:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108768:	8b 45 10             	mov    0x10(%ebp),%eax
8010876b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010876e:	72 08                	jb     80108778 <deallocuvm+0x16>
    return oldsz;
80108770:	8b 45 0c             	mov    0xc(%ebp),%eax
80108773:	e9 a5 00 00 00       	jmp    8010881d <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108778:	8b 45 10             	mov    0x10(%ebp),%eax
8010877b:	05 ff 0f 00 00       	add    $0xfff,%eax
80108780:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108785:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108788:	e9 81 00 00 00       	jmp    8010880e <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010878d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108790:	83 ec 04             	sub    $0x4,%esp
80108793:	6a 00                	push   $0x0
80108795:	50                   	push   %eax
80108796:	ff 75 08             	pushl  0x8(%ebp)
80108799:	e8 ff f8 ff ff       	call   8010809d <walkpgdir>
8010879e:	83 c4 10             	add    $0x10,%esp
801087a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801087a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087a8:	75 09                	jne    801087b3 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801087aa:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801087b1:	eb 54                	jmp    80108807 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
801087b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087b6:	8b 00                	mov    (%eax),%eax
801087b8:	83 e0 01             	and    $0x1,%eax
801087bb:	85 c0                	test   %eax,%eax
801087bd:	74 48                	je     80108807 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801087bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087c2:	8b 00                	mov    (%eax),%eax
801087c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801087cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087d0:	75 0d                	jne    801087df <deallocuvm+0x7d>
        panic("kfree");
801087d2:	83 ec 0c             	sub    $0xc,%esp
801087d5:	68 90 92 10 80       	push   $0x80109290
801087da:	e8 87 7d ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
801087df:	83 ec 0c             	sub    $0xc,%esp
801087e2:	ff 75 ec             	pushl  -0x14(%ebp)
801087e5:	e8 31 f4 ff ff       	call   80107c1b <p2v>
801087ea:	83 c4 10             	add    $0x10,%esp
801087ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801087f0:	83 ec 0c             	sub    $0xc,%esp
801087f3:	ff 75 e8             	pushl  -0x18(%ebp)
801087f6:	e8 2d a3 ff ff       	call   80102b28 <kfree>
801087fb:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801087fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108801:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108807:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010880e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108811:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108814:	0f 82 73 ff ff ff    	jb     8010878d <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010881a:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010881d:	c9                   	leave  
8010881e:	c3                   	ret    

8010881f <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010881f:	55                   	push   %ebp
80108820:	89 e5                	mov    %esp,%ebp
80108822:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108825:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108829:	75 0d                	jne    80108838 <freevm+0x19>
    panic("freevm: no pgdir");
8010882b:	83 ec 0c             	sub    $0xc,%esp
8010882e:	68 96 92 10 80       	push   $0x80109296
80108833:	e8 2e 7d ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108838:	83 ec 04             	sub    $0x4,%esp
8010883b:	6a 00                	push   $0x0
8010883d:	68 00 00 00 80       	push   $0x80000000
80108842:	ff 75 08             	pushl  0x8(%ebp)
80108845:	e8 18 ff ff ff       	call   80108762 <deallocuvm>
8010884a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010884d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108854:	eb 4f                	jmp    801088a5 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108859:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108860:	8b 45 08             	mov    0x8(%ebp),%eax
80108863:	01 d0                	add    %edx,%eax
80108865:	8b 00                	mov    (%eax),%eax
80108867:	83 e0 01             	and    $0x1,%eax
8010886a:	85 c0                	test   %eax,%eax
8010886c:	74 33                	je     801088a1 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010886e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108871:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108878:	8b 45 08             	mov    0x8(%ebp),%eax
8010887b:	01 d0                	add    %edx,%eax
8010887d:	8b 00                	mov    (%eax),%eax
8010887f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108884:	83 ec 0c             	sub    $0xc,%esp
80108887:	50                   	push   %eax
80108888:	e8 8e f3 ff ff       	call   80107c1b <p2v>
8010888d:	83 c4 10             	add    $0x10,%esp
80108890:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108893:	83 ec 0c             	sub    $0xc,%esp
80108896:	ff 75 f0             	pushl  -0x10(%ebp)
80108899:	e8 8a a2 ff ff       	call   80102b28 <kfree>
8010889e:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801088a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801088a5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801088ac:	76 a8                	jbe    80108856 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801088ae:	83 ec 0c             	sub    $0xc,%esp
801088b1:	ff 75 08             	pushl  0x8(%ebp)
801088b4:	e8 6f a2 ff ff       	call   80102b28 <kfree>
801088b9:	83 c4 10             	add    $0x10,%esp
}
801088bc:	90                   	nop
801088bd:	c9                   	leave  
801088be:	c3                   	ret    

801088bf <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801088bf:	55                   	push   %ebp
801088c0:	89 e5                	mov    %esp,%ebp
801088c2:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801088c5:	83 ec 04             	sub    $0x4,%esp
801088c8:	6a 00                	push   $0x0
801088ca:	ff 75 0c             	pushl  0xc(%ebp)
801088cd:	ff 75 08             	pushl  0x8(%ebp)
801088d0:	e8 c8 f7 ff ff       	call   8010809d <walkpgdir>
801088d5:	83 c4 10             	add    $0x10,%esp
801088d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801088db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801088df:	75 0d                	jne    801088ee <clearpteu+0x2f>
    panic("clearpteu");
801088e1:	83 ec 0c             	sub    $0xc,%esp
801088e4:	68 a7 92 10 80       	push   $0x801092a7
801088e9:	e8 78 7c ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
801088ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088f1:	8b 00                	mov    (%eax),%eax
801088f3:	83 e0 fb             	and    $0xfffffffb,%eax
801088f6:	89 c2                	mov    %eax,%edx
801088f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088fb:	89 10                	mov    %edx,(%eax)
}
801088fd:	90                   	nop
801088fe:	c9                   	leave  
801088ff:	c3                   	ret    

80108900 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108900:	55                   	push   %ebp
80108901:	89 e5                	mov    %esp,%ebp
80108903:	53                   	push   %ebx
80108904:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108907:	e8 c1 f8 ff ff       	call   801081cd <setupkvm>
8010890c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010890f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108913:	75 0a                	jne    8010891f <copyuvm+0x1f>
    return 0;
80108915:	b8 00 00 00 00       	mov    $0x0,%eax
8010891a:	e9 f8 00 00 00       	jmp    80108a17 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
8010891f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108926:	e9 c4 00 00 00       	jmp    801089ef <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010892b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010892e:	83 ec 04             	sub    $0x4,%esp
80108931:	6a 00                	push   $0x0
80108933:	50                   	push   %eax
80108934:	ff 75 08             	pushl  0x8(%ebp)
80108937:	e8 61 f7 ff ff       	call   8010809d <walkpgdir>
8010893c:	83 c4 10             	add    $0x10,%esp
8010893f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108942:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108946:	75 0d                	jne    80108955 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108948:	83 ec 0c             	sub    $0xc,%esp
8010894b:	68 b1 92 10 80       	push   $0x801092b1
80108950:	e8 11 7c ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108955:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108958:	8b 00                	mov    (%eax),%eax
8010895a:	83 e0 01             	and    $0x1,%eax
8010895d:	85 c0                	test   %eax,%eax
8010895f:	75 0d                	jne    8010896e <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108961:	83 ec 0c             	sub    $0xc,%esp
80108964:	68 cb 92 10 80       	push   $0x801092cb
80108969:	e8 f8 7b ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010896e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108971:	8b 00                	mov    (%eax),%eax
80108973:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108978:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010897b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010897e:	8b 00                	mov    (%eax),%eax
80108980:	25 ff 0f 00 00       	and    $0xfff,%eax
80108985:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108988:	e8 38 a2 ff ff       	call   80102bc5 <kalloc>
8010898d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108990:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108994:	74 6a                	je     80108a00 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108996:	83 ec 0c             	sub    $0xc,%esp
80108999:	ff 75 e8             	pushl  -0x18(%ebp)
8010899c:	e8 7a f2 ff ff       	call   80107c1b <p2v>
801089a1:	83 c4 10             	add    $0x10,%esp
801089a4:	83 ec 04             	sub    $0x4,%esp
801089a7:	68 00 10 00 00       	push   $0x1000
801089ac:	50                   	push   %eax
801089ad:	ff 75 e0             	pushl  -0x20(%ebp)
801089b0:	e8 ea cb ff ff       	call   8010559f <memmove>
801089b5:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801089b8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801089bb:	83 ec 0c             	sub    $0xc,%esp
801089be:	ff 75 e0             	pushl  -0x20(%ebp)
801089c1:	e8 48 f2 ff ff       	call   80107c0e <v2p>
801089c6:	83 c4 10             	add    $0x10,%esp
801089c9:	89 c2                	mov    %eax,%edx
801089cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ce:	83 ec 0c             	sub    $0xc,%esp
801089d1:	53                   	push   %ebx
801089d2:	52                   	push   %edx
801089d3:	68 00 10 00 00       	push   $0x1000
801089d8:	50                   	push   %eax
801089d9:	ff 75 f0             	pushl  -0x10(%ebp)
801089dc:	e8 5c f7 ff ff       	call   8010813d <mappages>
801089e1:	83 c4 20             	add    $0x20,%esp
801089e4:	85 c0                	test   %eax,%eax
801089e6:	78 1b                	js     80108a03 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801089e8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089f5:	0f 82 30 ff ff ff    	jb     8010892b <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801089fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089fe:	eb 17                	jmp    80108a17 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108a00:	90                   	nop
80108a01:	eb 01                	jmp    80108a04 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108a03:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108a04:	83 ec 0c             	sub    $0xc,%esp
80108a07:	ff 75 f0             	pushl  -0x10(%ebp)
80108a0a:	e8 10 fe ff ff       	call   8010881f <freevm>
80108a0f:	83 c4 10             	add    $0x10,%esp
  return 0;
80108a12:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108a1a:	c9                   	leave  
80108a1b:	c3                   	ret    

80108a1c <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108a1c:	55                   	push   %ebp
80108a1d:	89 e5                	mov    %esp,%ebp
80108a1f:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a22:	83 ec 04             	sub    $0x4,%esp
80108a25:	6a 00                	push   $0x0
80108a27:	ff 75 0c             	pushl  0xc(%ebp)
80108a2a:	ff 75 08             	pushl  0x8(%ebp)
80108a2d:	e8 6b f6 ff ff       	call   8010809d <walkpgdir>
80108a32:	83 c4 10             	add    $0x10,%esp
80108a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a3b:	8b 00                	mov    (%eax),%eax
80108a3d:	83 e0 01             	and    $0x1,%eax
80108a40:	85 c0                	test   %eax,%eax
80108a42:	75 07                	jne    80108a4b <uva2ka+0x2f>
    return 0;
80108a44:	b8 00 00 00 00       	mov    $0x0,%eax
80108a49:	eb 29                	jmp    80108a74 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a4e:	8b 00                	mov    (%eax),%eax
80108a50:	83 e0 04             	and    $0x4,%eax
80108a53:	85 c0                	test   %eax,%eax
80108a55:	75 07                	jne    80108a5e <uva2ka+0x42>
    return 0;
80108a57:	b8 00 00 00 00       	mov    $0x0,%eax
80108a5c:	eb 16                	jmp    80108a74 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a61:	8b 00                	mov    (%eax),%eax
80108a63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a68:	83 ec 0c             	sub    $0xc,%esp
80108a6b:	50                   	push   %eax
80108a6c:	e8 aa f1 ff ff       	call   80107c1b <p2v>
80108a71:	83 c4 10             	add    $0x10,%esp
}
80108a74:	c9                   	leave  
80108a75:	c3                   	ret    

80108a76 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108a76:	55                   	push   %ebp
80108a77:	89 e5                	mov    %esp,%ebp
80108a79:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108a7c:	8b 45 10             	mov    0x10(%ebp),%eax
80108a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108a82:	eb 7f                	jmp    80108b03 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108a84:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a92:	83 ec 08             	sub    $0x8,%esp
80108a95:	50                   	push   %eax
80108a96:	ff 75 08             	pushl  0x8(%ebp)
80108a99:	e8 7e ff ff ff       	call   80108a1c <uva2ka>
80108a9e:	83 c4 10             	add    $0x10,%esp
80108aa1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108aa4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108aa8:	75 07                	jne    80108ab1 <copyout+0x3b>
      return -1;
80108aaa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108aaf:	eb 61                	jmp    80108b12 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ab4:	2b 45 0c             	sub    0xc(%ebp),%eax
80108ab7:	05 00 10 00 00       	add    $0x1000,%eax
80108abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ac2:	3b 45 14             	cmp    0x14(%ebp),%eax
80108ac5:	76 06                	jbe    80108acd <copyout+0x57>
      n = len;
80108ac7:	8b 45 14             	mov    0x14(%ebp),%eax
80108aca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108acd:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ad0:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108ad3:	89 c2                	mov    %eax,%edx
80108ad5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ad8:	01 d0                	add    %edx,%eax
80108ada:	83 ec 04             	sub    $0x4,%esp
80108add:	ff 75 f0             	pushl  -0x10(%ebp)
80108ae0:	ff 75 f4             	pushl  -0xc(%ebp)
80108ae3:	50                   	push   %eax
80108ae4:	e8 b6 ca ff ff       	call   8010559f <memmove>
80108ae9:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108aef:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108af5:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108afb:	05 00 10 00 00       	add    $0x1000,%eax
80108b00:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108b03:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108b07:	0f 85 77 ff ff ff    	jne    80108a84 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108b0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b12:	c9                   	leave  
80108b13:	c3                   	ret    
