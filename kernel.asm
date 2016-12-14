
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

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
8010003d:	68 2c 8e 10 80       	push   $0x80108e2c
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 8d 52 00 00       	call   801052d9 <initlock>
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
801000c1:	e8 35 52 00 00       	call   801052fb <acquire>
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
8010010c:	e8 51 52 00 00       	call   80105362 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 66 4d 00 00       	call   80104e92 <sleep>
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
80100188:	e8 d5 51 00 00       	call   80105362 <release>
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
801001aa:	68 33 8e 10 80       	push   $0x80108e33
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
80100204:	68 44 8e 10 80       	push   $0x80108e44
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
80100243:	68 4b 8e 10 80       	push   $0x80108e4b
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 a1 50 00 00       	call   801052fb <acquire>
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
801002b9:	e8 c2 4c 00 00       	call   80104f80 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 94 50 00 00       	call   80105362 <release>
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
801003e2:	e8 14 4f 00 00       	call   801052fb <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 52 8e 10 80       	push   $0x80108e52
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
801004cd:	c7 45 ec 5b 8e 10 80 	movl   $0x80108e5b,-0x14(%ebp)
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
8010055b:	e8 02 4e 00 00       	call   80105362 <release>
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
8010058b:	68 62 8e 10 80       	push   $0x80108e62
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
801005aa:	68 71 8e 10 80       	push   $0x80108e71
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 ed 4d 00 00       	call   801053b4 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 73 8e 10 80       	push   $0x80108e73
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
801006db:	e8 3d 4f 00 00       	call   8010561d <memmove>
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
80100705:	e8 54 4e 00 00       	call   8010555e <memset>
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
8010079a:	e8 52 69 00 00       	call   801070f1 <uartputc>
8010079f:	83 c4 10             	add    $0x10,%esp
801007a2:	83 ec 0c             	sub    $0xc,%esp
801007a5:	6a 20                	push   $0x20
801007a7:	e8 45 69 00 00       	call   801070f1 <uartputc>
801007ac:	83 c4 10             	add    $0x10,%esp
801007af:	83 ec 0c             	sub    $0xc,%esp
801007b2:	6a 08                	push   $0x8
801007b4:	e8 38 69 00 00       	call   801070f1 <uartputc>
801007b9:	83 c4 10             	add    $0x10,%esp
801007bc:	eb 0e                	jmp    801007cc <consputc+0x56>
  } else
    uartputc(c);
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	ff 75 08             	pushl  0x8(%ebp)
801007c4:	e8 28 69 00 00       	call   801070f1 <uartputc>
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
801007eb:	e8 0b 4b 00 00       	call   801052fb <acquire>
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
8010081e:	e8 1b 48 00 00       	call   8010503e <procdump>
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
80100931:	e8 4a 46 00 00       	call   80104f80 <wakeup>
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
80100954:	e8 09 4a 00 00       	call   80105362 <release>
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
80100981:	e8 75 49 00 00       	call   801052fb <acquire>
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
801009a3:	e8 ba 49 00 00       	call   80105362 <release>
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
801009d0:	e8 bd 44 00 00       	call   80104e92 <sleep>
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
80100a4e:	e8 0f 49 00 00       	call   80105362 <release>
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
80100a8c:	e8 6a 48 00 00       	call   801052fb <acquire>
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
80100ace:	e8 8f 48 00 00       	call   80105362 <release>
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
80100af2:	68 77 8e 10 80       	push   $0x80108e77
80100af7:	68 e0 c5 10 80       	push   $0x8010c5e0
80100afc:	e8 d8 47 00 00       	call   801052d9 <initlock>
80100b01:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b04:	83 ec 08             	sub    $0x8,%esp
80100b07:	68 7f 8e 10 80       	push   $0x80108e7f
80100b0c:	68 a0 17 11 80       	push   $0x801117a0
80100b11:	e8 c3 47 00 00       	call   801052d9 <initlock>
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
80100bcf:	e8 90 76 00 00       	call   80108264 <setupkvm>
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
80100c55:	e8 d9 7a 00 00       	call   80108733 <allocuvm>
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
80100c88:	e8 a7 78 00 00       	call   80108534 <loaduvm>
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
80100cf7:	e8 37 7a 00 00       	call   80108733 <allocuvm>
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
80100d1b:	e8 19 7d 00 00       	call   80108a39 <clearpteu>
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
80100d54:	e8 52 4a 00 00       	call   801057ab <strlen>
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
80100d81:	e8 25 4a 00 00       	call   801057ab <strlen>
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
80100da7:	e8 df 7f 00 00       	call   80108d8b <copyout>
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
80100e43:	e8 43 7f 00 00       	call   80108d8b <copyout>
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
80100e94:	e8 c8 48 00 00       	call   80105761 <safestrcpy>
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
80100eea:	e8 5c 74 00 00       	call   8010834b <switchuvm>
80100eef:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
80100ef5:	ff 75 d0             	pushl  -0x30(%ebp)
80100ef8:	e8 6b 7a 00 00       	call   80108968 <freevm>
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
80100f32:	e8 31 7a 00 00       	call   80108968 <freevm>
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
80100f63:	68 85 8e 10 80       	push   $0x80108e85
80100f68:	68 60 18 11 80       	push   $0x80111860
80100f6d:	e8 67 43 00 00       	call   801052d9 <initlock>
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
80100f86:	e8 70 43 00 00       	call   801052fb <acquire>
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
80100fb3:	e8 aa 43 00 00       	call   80105362 <release>
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
80100fd6:	e8 87 43 00 00       	call   80105362 <release>
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
80100ff3:	e8 03 43 00 00       	call   801052fb <acquire>
80100ff8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffe:	8b 40 04             	mov    0x4(%eax),%eax
80101001:	85 c0                	test   %eax,%eax
80101003:	7f 0d                	jg     80101012 <filedup+0x2d>
    panic("filedup");
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	68 8c 8e 10 80       	push   $0x80108e8c
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
80101029:	e8 34 43 00 00       	call   80105362 <release>
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
80101044:	e8 b2 42 00 00       	call   801052fb <acquire>
80101049:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
8010104f:	8b 40 04             	mov    0x4(%eax),%eax
80101052:	85 c0                	test   %eax,%eax
80101054:	7f 0d                	jg     80101063 <fileclose+0x2d>
    panic("fileclose");
80101056:	83 ec 0c             	sub    $0xc,%esp
80101059:	68 94 8e 10 80       	push   $0x80108e94
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
80101084:	e8 d9 42 00 00       	call   80105362 <release>
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
801010d2:	e8 8b 42 00 00       	call   80105362 <release>
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
80101221:	68 9e 8e 10 80       	push   $0x80108e9e
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
80101324:	68 a7 8e 10 80       	push   $0x80108ea7
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
8010135a:	68 b7 8e 10 80       	push   $0x80108eb7
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
80101392:	e8 86 42 00 00       	call   8010561d <memmove>
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
801013d8:	e8 81 41 00 00       	call   8010555e <memset>
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
80101551:	68 c1 8e 10 80       	push   $0x80108ec1
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
801015e7:	68 d7 8e 10 80       	push   $0x80108ed7
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
80101641:	68 ea 8e 10 80       	push   $0x80108eea
80101646:	68 60 22 11 80       	push   $0x80112260
8010164b:	e8 89 3c 00 00       	call   801052d9 <initlock>
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
801016c6:	e8 93 3e 00 00       	call   8010555e <memset>
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
8010172b:	68 f1 8e 10 80       	push   $0x80108ef1
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
801017cb:	e8 4d 3e 00 00       	call   8010561d <memmove>
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
80101800:	e8 f6 3a 00 00       	call   801052fb <acquire>
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
8010184e:	e8 0f 3b 00 00       	call   80105362 <release>
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
80101887:	68 03 8f 10 80       	push   $0x80108f03
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
801018c4:	e8 99 3a 00 00       	call   80105362 <release>
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
801018df:	e8 17 3a 00 00       	call   801052fb <acquire>
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
801018fe:	e8 5f 3a 00 00       	call   80105362 <release>
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
80101924:	68 13 8f 10 80       	push   $0x80108f13
80101929:	e8 38 ec ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
8010192e:	83 ec 0c             	sub    $0xc,%esp
80101931:	68 60 22 11 80       	push   $0x80112260
80101936:	e8 c0 39 00 00       	call   801052fb <acquire>
8010193b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010193e:	eb 13                	jmp    80101953 <ilock+0x48>
    sleep(ip, &icache.lock);
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	68 60 22 11 80       	push   $0x80112260
80101948:	ff 75 08             	pushl  0x8(%ebp)
8010194b:	e8 42 35 00 00       	call   80104e92 <sleep>
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
80101979:	e8 e4 39 00 00       	call   80105362 <release>
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
80101a20:	e8 f8 3b 00 00       	call   8010561d <memmove>
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
80101a56:	68 19 8f 10 80       	push   $0x80108f19
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
80101a89:	68 28 8f 10 80       	push   $0x80108f28
80101a8e:	e8 d3 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a93:	83 ec 0c             	sub    $0xc,%esp
80101a96:	68 60 22 11 80       	push   $0x80112260
80101a9b:	e8 5b 38 00 00       	call   801052fb <acquire>
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
80101aba:	e8 c1 34 00 00       	call   80104f80 <wakeup>
80101abf:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ac2:	83 ec 0c             	sub    $0xc,%esp
80101ac5:	68 60 22 11 80       	push   $0x80112260
80101aca:	e8 93 38 00 00       	call   80105362 <release>
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
80101ae3:	e8 13 38 00 00       	call   801052fb <acquire>
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
80101b2b:	68 30 8f 10 80       	push   $0x80108f30
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
80101b4e:	e8 0f 38 00 00       	call   80105362 <release>
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
80101b83:	e8 73 37 00 00       	call   801052fb <acquire>
80101b88:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b95:	83 ec 0c             	sub    $0xc,%esp
80101b98:	ff 75 08             	pushl  0x8(%ebp)
80101b9b:	e8 e0 33 00 00       	call   80104f80 <wakeup>
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
80101bba:	e8 a3 37 00 00       	call   80105362 <release>
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
80101cfa:	68 3a 8f 10 80       	push   $0x80108f3a
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
80101f91:	e8 87 36 00 00       	call   8010561d <memmove>
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
801020e3:	e8 35 35 00 00       	call   8010561d <memmove>
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
80102163:	e8 4b 35 00 00       	call   801056b3 <strncmp>
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
80102183:	68 4d 8f 10 80       	push   $0x80108f4d
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
801021b2:	68 5f 8f 10 80       	push   $0x80108f5f
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
80102287:	68 5f 8f 10 80       	push   $0x80108f5f
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
801022c2:	e8 42 34 00 00       	call   80105709 <strncpy>
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
801022ee:	68 6c 8f 10 80       	push   $0x80108f6c
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
80102364:	e8 b4 32 00 00       	call   8010561d <memmove>
80102369:	83 c4 10             	add    $0x10,%esp
8010236c:	eb 26                	jmp    80102394 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102371:	83 ec 04             	sub    $0x4,%esp
80102374:	50                   	push   %eax
80102375:	ff 75 f4             	pushl  -0xc(%ebp)
80102378:	ff 75 0c             	pushl  0xc(%ebp)
8010237b:	e8 9d 32 00 00       	call   8010561d <memmove>
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
801025d0:	68 74 8f 10 80       	push   $0x80108f74
801025d5:	68 20 c6 10 80       	push   $0x8010c620
801025da:	e8 fa 2c 00 00       	call   801052d9 <initlock>
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
80102684:	68 78 8f 10 80       	push   $0x80108f78
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
801027a5:	e8 51 2b 00 00       	call   801052fb <acquire>
801027aa:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027ad:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027b9:	75 15                	jne    801027d0 <ideintr+0x39>
    release(&idelock);
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	68 20 c6 10 80       	push   $0x8010c620
801027c3:	e8 9a 2b 00 00       	call   80105362 <release>
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
80102838:	e8 43 27 00 00       	call   80104f80 <wakeup>
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
80102862:	e8 fb 2a 00 00       	call   80105362 <release>
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
80102881:	68 81 8f 10 80       	push   $0x80108f81
80102886:	e8 db dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010288b:	8b 45 08             	mov    0x8(%ebp),%eax
8010288e:	8b 00                	mov    (%eax),%eax
80102890:	83 e0 06             	and    $0x6,%eax
80102893:	83 f8 02             	cmp    $0x2,%eax
80102896:	75 0d                	jne    801028a5 <iderw+0x39>
    panic("iderw: nothing to do");
80102898:	83 ec 0c             	sub    $0xc,%esp
8010289b:	68 95 8f 10 80       	push   $0x80108f95
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
801028bb:	68 aa 8f 10 80       	push   $0x80108faa
801028c0:	e8 a1 dc ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028c5:	83 ec 0c             	sub    $0xc,%esp
801028c8:	68 20 c6 10 80       	push   $0x8010c620
801028cd:	e8 29 2a 00 00       	call   801052fb <acquire>
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
80102929:	e8 64 25 00 00       	call   80104e92 <sleep>
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
80102946:	e8 17 2a 00 00       	call   80105362 <release>
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
801029d7:	68 c8 8f 10 80       	push   $0x80108fc8
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
80102a97:	68 fa 8f 10 80       	push   $0x80108ffa
80102a9c:	68 40 32 11 80       	push   $0x80113240
80102aa1:	e8 33 28 00 00       	call   801052d9 <initlock>
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
80102b58:	68 ff 8f 10 80       	push   $0x80108fff
80102b5d:	e8 04 da ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b62:	83 ec 04             	sub    $0x4,%esp
80102b65:	68 00 10 00 00       	push   $0x1000
80102b6a:	6a 01                	push   $0x1
80102b6c:	ff 75 08             	pushl  0x8(%ebp)
80102b6f:	e8 ea 29 00 00       	call   8010555e <memset>
80102b74:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b77:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	74 10                	je     80102b90 <kfree+0x68>
    acquire(&kmem.lock);
80102b80:	83 ec 0c             	sub    $0xc,%esp
80102b83:	68 40 32 11 80       	push   $0x80113240
80102b88:	e8 6e 27 00 00       	call   801052fb <acquire>
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
80102bba:	e8 a3 27 00 00       	call   80105362 <release>
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
80102bdc:	e8 1a 27 00 00       	call   801052fb <acquire>
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
80102c0d:	e8 50 27 00 00       	call   80105362 <release>
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
80102f58:	68 08 90 10 80       	push   $0x80109008
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
80103183:	e8 3d 24 00 00       	call   801055c5 <memcmp>
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
80103297:	68 34 90 10 80       	push   $0x80109034
8010329c:	68 80 32 11 80       	push   $0x80113280
801032a1:	e8 33 20 00 00       	call   801052d9 <initlock>
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
80103354:	e8 c4 22 00 00       	call   8010561d <memmove>
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
801034c2:	e8 34 1e 00 00       	call   801052fb <acquire>
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
801034e0:	e8 ad 19 00 00       	call   80104e92 <sleep>
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
80103515:	e8 78 19 00 00       	call   80104e92 <sleep>
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
80103534:	e8 29 1e 00 00       	call   80105362 <release>
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
80103555:	e8 a1 1d 00 00       	call   801052fb <acquire>
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
80103576:	68 38 90 10 80       	push   $0x80109038
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
801035a4:	e8 d7 19 00 00       	call   80104f80 <wakeup>
801035a9:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801035ac:	83 ec 0c             	sub    $0xc,%esp
801035af:	68 80 32 11 80       	push   $0x80113280
801035b4:	e8 a9 1d 00 00       	call   80105362 <release>
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
801035cf:	e8 27 1d 00 00       	call   801052fb <acquire>
801035d4:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801035d7:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
801035de:	00 00 00 
    wakeup(&log);
801035e1:	83 ec 0c             	sub    $0xc,%esp
801035e4:	68 80 32 11 80       	push   $0x80113280
801035e9:	e8 92 19 00 00       	call   80104f80 <wakeup>
801035ee:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801035f1:	83 ec 0c             	sub    $0xc,%esp
801035f4:	68 80 32 11 80       	push   $0x80113280
801035f9:	e8 64 1d 00 00       	call   80105362 <release>
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
80103675:	e8 a3 1f 00 00       	call   8010561d <memmove>
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
80103711:	68 47 90 10 80       	push   $0x80109047
80103716:	e8 4b ce ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010371b:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103720:	85 c0                	test   %eax,%eax
80103722:	7f 0d                	jg     80103731 <log_write+0x45>
    panic("log_write outside of trans");
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 5d 90 10 80       	push   $0x8010905d
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
801037fc:	e8 15 4b 00 00       	call   80108316 <kvmalloc>
  mpinit();        // collect info about this machine
80103801:	e8 4d 04 00 00       	call   80103c53 <mpinit>
  lapicinit();
80103806:	e8 02 f6 ff ff       	call   80102e0d <lapicinit>
  seginit();       // set up segments
8010380b:	e8 af 44 00 00       	call   80107cbf <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103810:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103816:	0f b6 00             	movzbl (%eax),%eax
80103819:	0f b6 c0             	movzbl %al,%eax
8010381c:	83 ec 08             	sub    $0x8,%esp
8010381f:	50                   	push   %eax
80103820:	68 78 90 10 80       	push   $0x80109078
80103825:	e8 9c cb ff ff       	call   801003c6 <cprintf>
8010382a:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010382d:	e8 77 06 00 00       	call   80103ea9 <picinit>
  ioapicinit();    // another interrupt controller
80103832:	e8 4c f1 ff ff       	call   80102983 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103837:	e8 ad d2 ff ff       	call   80100ae9 <consoleinit>
  uartinit();      // serial port
8010383c:	e8 bc 37 00 00       	call   80106ffd <uartinit>
  pinit();         // process table
80103841:	e8 60 0b 00 00       	call   801043a6 <pinit>
  init_pte_lookup_lock(); // pte_lookup lock
80103846:	e8 56 44 00 00       	call   80107ca1 <init_pte_lookup_lock>
  tvinit();        // trap vectors
8010384b:	e8 9b 32 00 00       	call   80106aeb <tvinit>
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
8010386d:	e8 d6 31 00 00       	call   80106a48 <timerinit>
  startothers();   // start other processors
80103872:	e8 7f 00 00 00       	call   801038f6 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103877:	83 ec 08             	sub    $0x8,%esp
8010387a:	68 00 00 00 8e       	push   $0x8e000000
8010387f:	68 00 00 40 80       	push   $0x80400000
80103884:	e8 3e f2 ff ff       	call   80102ac7 <kinit2>
80103889:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
8010388c:	e8 7d 0c 00 00       	call   8010450e <userinit>
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
8010389c:	e8 8d 4a 00 00       	call   8010832e <switchkvm>
  seginit();
801038a1:	e8 19 44 00 00       	call   80107cbf <seginit>
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
801038c6:	68 8f 90 10 80       	push   $0x8010908f
801038cb:	e8 f6 ca ff ff       	call   801003c6 <cprintf>
801038d0:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801038d3:	e8 89 33 00 00       	call   80106c61 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801038d8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038de:	05 a8 00 00 00       	add    $0xa8,%eax
801038e3:	83 ec 08             	sub    $0x8,%esp
801038e6:	6a 01                	push   $0x1
801038e8:	50                   	push   %eax
801038e9:	e8 ce fe ff ff       	call   801037bc <xchg>
801038ee:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801038f1:	e8 cc 13 00 00       	call   80104cc2 <scheduler>

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
8010391e:	e8 fa 1c 00 00       	call   8010561d <memmove>
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
80103aac:	68 a0 90 10 80       	push   $0x801090a0
80103ab1:	ff 75 f4             	pushl  -0xc(%ebp)
80103ab4:	e8 0c 1b 00 00       	call   801055c5 <memcmp>
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
80103bea:	68 a5 90 10 80       	push   $0x801090a5
80103bef:	ff 75 f0             	pushl  -0x10(%ebp)
80103bf2:	e8 ce 19 00 00       	call   801055c5 <memcmp>
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
80103cc6:	8b 04 85 e8 90 10 80 	mov    -0x7fef6f18(,%eax,4),%eax
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
80103cfc:	68 aa 90 10 80       	push   $0x801090aa
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
80103d8f:	68 c8 90 10 80       	push   $0x801090c8
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
80103e18:	55                   	push   %ebp
80103e19:	89 e5                	mov    %esp,%ebp
80103e1b:	83 ec 08             	sub    $0x8,%esp
80103e1e:	8b 55 08             	mov    0x8(%ebp),%edx
80103e21:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e24:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e28:	88 45 f8             	mov    %al,-0x8(%ebp)
80103e2b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e2f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e33:	ee                   	out    %al,(%dx)
80103e34:	90                   	nop
80103e35:	c9                   	leave  
80103e36:	c3                   	ret    

80103e37 <picsetmask>:
80103e37:	55                   	push   %ebp
80103e38:	89 e5                	mov    %esp,%ebp
80103e3a:	83 ec 04             	sub    $0x4,%esp
80103e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e40:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103e44:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e48:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
80103e4e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e52:	0f b6 c0             	movzbl %al,%eax
80103e55:	50                   	push   %eax
80103e56:	6a 21                	push   $0x21
80103e58:	e8 bb ff ff ff       	call   80103e18 <outb>
80103e5d:	83 c4 08             	add    $0x8,%esp
80103e60:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e64:	66 c1 e8 08          	shr    $0x8,%ax
80103e68:	0f b6 c0             	movzbl %al,%eax
80103e6b:	50                   	push   %eax
80103e6c:	68 a1 00 00 00       	push   $0xa1
80103e71:	e8 a2 ff ff ff       	call   80103e18 <outb>
80103e76:	83 c4 08             	add    $0x8,%esp
80103e79:	90                   	nop
80103e7a:	c9                   	leave  
80103e7b:	c3                   	ret    

80103e7c <picenable>:
80103e7c:	55                   	push   %ebp
80103e7d:	89 e5                	mov    %esp,%ebp
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
80103ea6:	90                   	nop
80103ea7:	c9                   	leave  
80103ea8:	c3                   	ret    

80103ea9 <picinit>:
80103ea9:	55                   	push   %ebp
80103eaa:	89 e5                	mov    %esp,%ebp
80103eac:	68 ff 00 00 00       	push   $0xff
80103eb1:	6a 21                	push   $0x21
80103eb3:	e8 60 ff ff ff       	call   80103e18 <outb>
80103eb8:	83 c4 08             	add    $0x8,%esp
80103ebb:	68 ff 00 00 00       	push   $0xff
80103ec0:	68 a1 00 00 00       	push   $0xa1
80103ec5:	e8 4e ff ff ff       	call   80103e18 <outb>
80103eca:	83 c4 08             	add    $0x8,%esp
80103ecd:	6a 11                	push   $0x11
80103ecf:	6a 20                	push   $0x20
80103ed1:	e8 42 ff ff ff       	call   80103e18 <outb>
80103ed6:	83 c4 08             	add    $0x8,%esp
80103ed9:	6a 20                	push   $0x20
80103edb:	6a 21                	push   $0x21
80103edd:	e8 36 ff ff ff       	call   80103e18 <outb>
80103ee2:	83 c4 08             	add    $0x8,%esp
80103ee5:	6a 04                	push   $0x4
80103ee7:	6a 21                	push   $0x21
80103ee9:	e8 2a ff ff ff       	call   80103e18 <outb>
80103eee:	83 c4 08             	add    $0x8,%esp
80103ef1:	6a 03                	push   $0x3
80103ef3:	6a 21                	push   $0x21
80103ef5:	e8 1e ff ff ff       	call   80103e18 <outb>
80103efa:	83 c4 08             	add    $0x8,%esp
80103efd:	6a 11                	push   $0x11
80103eff:	68 a0 00 00 00       	push   $0xa0
80103f04:	e8 0f ff ff ff       	call   80103e18 <outb>
80103f09:	83 c4 08             	add    $0x8,%esp
80103f0c:	6a 28                	push   $0x28
80103f0e:	68 a1 00 00 00       	push   $0xa1
80103f13:	e8 00 ff ff ff       	call   80103e18 <outb>
80103f18:	83 c4 08             	add    $0x8,%esp
80103f1b:	6a 02                	push   $0x2
80103f1d:	68 a1 00 00 00       	push   $0xa1
80103f22:	e8 f1 fe ff ff       	call   80103e18 <outb>
80103f27:	83 c4 08             	add    $0x8,%esp
80103f2a:	6a 03                	push   $0x3
80103f2c:	68 a1 00 00 00       	push   $0xa1
80103f31:	e8 e2 fe ff ff       	call   80103e18 <outb>
80103f36:	83 c4 08             	add    $0x8,%esp
80103f39:	6a 68                	push   $0x68
80103f3b:	6a 20                	push   $0x20
80103f3d:	e8 d6 fe ff ff       	call   80103e18 <outb>
80103f42:	83 c4 08             	add    $0x8,%esp
80103f45:	6a 0a                	push   $0xa
80103f47:	6a 20                	push   $0x20
80103f49:	e8 ca fe ff ff       	call   80103e18 <outb>
80103f4e:	83 c4 08             	add    $0x8,%esp
80103f51:	6a 68                	push   $0x68
80103f53:	68 a0 00 00 00       	push   $0xa0
80103f58:	e8 bb fe ff ff       	call   80103e18 <outb>
80103f5d:	83 c4 08             	add    $0x8,%esp
80103f60:	6a 0a                	push   $0xa
80103f62:	68 a0 00 00 00       	push   $0xa0
80103f67:	e8 ac fe ff ff       	call   80103e18 <outb>
80103f6c:	83 c4 08             	add    $0x8,%esp
80103f6f:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f76:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f7a:	74 13                	je     80103f8f <picinit+0xe6>
80103f7c:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f83:	0f b7 c0             	movzwl %ax,%eax
80103f86:	50                   	push   %eax
80103f87:	e8 ab fe ff ff       	call   80103e37 <picsetmask>
80103f8c:	83 c4 04             	add    $0x4,%esp
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
80104030:	68 fc 90 10 80       	push   $0x801090fc
80104035:	50                   	push   %eax
80104036:	e8 9e 12 00 00       	call   801052d9 <initlock>
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
801040f2:	e8 04 12 00 00       	call   801052fb <acquire>
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
80104119:	e8 62 0e 00 00       	call   80104f80 <wakeup>
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
8010413c:	e8 3f 0e 00 00       	call   80104f80 <wakeup>
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
80104165:	e8 f8 11 00 00       	call   80105362 <release>
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
80104184:	e8 d9 11 00 00       	call   80105362 <release>
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
8010419c:	e8 5a 11 00 00       	call   801052fb <acquire>
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
801041d1:	e8 8c 11 00 00       	call   80105362 <release>
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
801041ef:	e8 8c 0d 00 00       	call   80104f80 <wakeup>
801041f4:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801041f7:	8b 45 08             	mov    0x8(%ebp),%eax
801041fa:	8b 55 08             	mov    0x8(%ebp),%edx
801041fd:	81 c2 38 02 00 00    	add    $0x238,%edx
80104203:	83 ec 08             	sub    $0x8,%esp
80104206:	50                   	push   %eax
80104207:	52                   	push   %edx
80104208:	e8 85 0c 00 00       	call   80104e92 <sleep>
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
80104271:	e8 0a 0d 00 00       	call   80104f80 <wakeup>
80104276:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104279:	8b 45 08             	mov    0x8(%ebp),%eax
8010427c:	83 ec 0c             	sub    $0xc,%esp
8010427f:	50                   	push   %eax
80104280:	e8 dd 10 00 00       	call   80105362 <release>
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
8010429b:	e8 5b 10 00 00       	call   801052fb <acquire>
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
801042b9:	e8 a4 10 00 00       	call   80105362 <release>
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
801042dc:	e8 b1 0b 00 00       	call   80104e92 <sleep>
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
80104370:	e8 0b 0c 00 00       	call   80104f80 <wakeup>
80104375:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104378:	8b 45 08             	mov    0x8(%ebp),%eax
8010437b:	83 ec 0c             	sub    $0xc,%esp
8010437e:	50                   	push   %eax
8010437f:	e8 de 0f 00 00       	call   80105362 <release>
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
801043af:	68 01 91 10 80       	push   $0x80109101
801043b4:	68 80 39 11 80       	push   $0x80113980
801043b9:	e8 1b 0f 00 00       	call   801052d9 <initlock>
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
801043d2:	e8 24 0f 00 00       	call   801052fb <acquire>
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
80104405:	e8 58 0f 00 00       	call   80105362 <release>
8010440a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010440d:	b8 00 00 00 00       	mov    $0x0,%eax
80104412:	e9 f5 00 00 00       	jmp    8010450c <allocproc+0x148>
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
8010443e:	e8 1f 0f 00 00       	call   80105362 <release>
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
8010446c:	e9 9b 00 00 00       	jmp    8010450c <allocproc+0x148>
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
80104490:	ba a5 6a 10 80       	mov    $0x80106aa5,%edx
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
801044b5:	e8 a4 10 00 00       	call   8010555e <memset>
801044ba:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801044bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c0:	8b 40 1c             	mov    0x1c(%eax),%eax
801044c3:	ba 61 4e 10 80       	mov    $0x80104e61,%edx
801044c8:	89 50 10             	mov    %edx,0x10(%eax)

  p->handlers[SIGKILL] = (sighandler_t) -1;
801044cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ce:	c7 40 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%eax)
  p->handlers[SIGFPE] = (sighandler_t) -1;
801044d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d8:	c7 80 80 00 00 00 ff 	movl   $0xffffffff,0x80(%eax)
801044df:	ff ff ff 
  p->handlers[SIGSEGV] = (sighandler_t) -1;
801044e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e5:	c7 80 b4 00 00 00 ff 	movl   $0xffffffff,0xb4(%eax)
801044ec:	ff ff ff 
  p->restorer_addr = -1;
801044ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f2:	c7 80 84 00 00 00 ff 	movl   $0xffffffff,0x84(%eax)
801044f9:	ff ff ff 
  p->shared = 0;
801044fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ff:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104506:	00 00 00 
  return p;
80104509:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010450c:	c9                   	leave  
8010450d:	c3                   	ret    

8010450e <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010450e:	55                   	push   %ebp
8010450f:	89 e5                	mov    %esp,%ebp
80104511:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104514:	e8 ab fe ff ff       	call   801043c4 <allocproc>
80104519:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010451c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451f:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
80104524:	e8 3b 3d 00 00       	call   80108264 <setupkvm>
80104529:	89 c2                	mov    %eax,%edx
8010452b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452e:	89 50 04             	mov    %edx,0x4(%eax)
80104531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104534:	8b 40 04             	mov    0x4(%eax),%eax
80104537:	85 c0                	test   %eax,%eax
80104539:	75 0d                	jne    80104548 <userinit+0x3a>
    panic("userinit: out of memory?");
8010453b:	83 ec 0c             	sub    $0xc,%esp
8010453e:	68 08 91 10 80       	push   $0x80109108
80104543:	e8 1e c0 ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104548:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010454d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104550:	8b 40 04             	mov    0x4(%eax),%eax
80104553:	83 ec 04             	sub    $0x4,%esp
80104556:	52                   	push   %edx
80104557:	68 00 c5 10 80       	push   $0x8010c500
8010455c:	50                   	push   %eax
8010455d:	e8 5c 3f 00 00       	call   801084be <inituvm>
80104562:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104565:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104568:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010456e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104571:	8b 40 18             	mov    0x18(%eax),%eax
80104574:	83 ec 04             	sub    $0x4,%esp
80104577:	6a 4c                	push   $0x4c
80104579:	6a 00                	push   $0x0
8010457b:	50                   	push   %eax
8010457c:	e8 dd 0f 00 00       	call   8010555e <memset>
80104581:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104587:	8b 40 18             	mov    0x18(%eax),%eax
8010458a:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104593:	8b 40 18             	mov    0x18(%eax),%eax
80104596:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010459c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459f:	8b 40 18             	mov    0x18(%eax),%eax
801045a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045a5:	8b 52 18             	mov    0x18(%edx),%edx
801045a8:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045ac:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801045b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b3:	8b 40 18             	mov    0x18(%eax),%eax
801045b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045b9:	8b 52 18             	mov    0x18(%edx),%edx
801045bc:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045c0:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801045c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c7:	8b 40 18             	mov    0x18(%eax),%eax
801045ca:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801045d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d4:	8b 40 18             	mov    0x18(%eax),%eax
801045d7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801045de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e1:	8b 40 18             	mov    0x18(%eax),%eax
801045e4:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801045eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ee:	83 c0 6c             	add    $0x6c,%eax
801045f1:	83 ec 04             	sub    $0x4,%esp
801045f4:	6a 10                	push   $0x10
801045f6:	68 21 91 10 80       	push   $0x80109121
801045fb:	50                   	push   %eax
801045fc:	e8 60 11 00 00       	call   80105761 <safestrcpy>
80104601:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104604:	83 ec 0c             	sub    $0xc,%esp
80104607:	68 2a 91 10 80       	push   $0x8010912a
8010460c:	e8 b2 de ff ff       	call   801024c3 <namei>
80104611:	83 c4 10             	add    $0x10,%esp
80104614:	89 c2                	mov    %eax,%edx
80104616:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104619:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
8010461c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104626:	90                   	nop
80104627:	c9                   	leave  
80104628:	c3                   	ret    

80104629 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104629:	55                   	push   %ebp
8010462a:	89 e5                	mov    %esp,%ebp
8010462c:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
8010462f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104635:	8b 00                	mov    (%eax),%eax
80104637:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010463a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010463e:	7e 31                	jle    80104671 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104640:	8b 55 08             	mov    0x8(%ebp),%edx
80104643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104646:	01 c2                	add    %eax,%edx
80104648:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010464e:	8b 40 04             	mov    0x4(%eax),%eax
80104651:	83 ec 04             	sub    $0x4,%esp
80104654:	52                   	push   %edx
80104655:	ff 75 f4             	pushl  -0xc(%ebp)
80104658:	50                   	push   %eax
80104659:	e8 d5 40 00 00       	call   80108733 <allocuvm>
8010465e:	83 c4 10             	add    $0x10,%esp
80104661:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104664:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104668:	75 3e                	jne    801046a8 <growproc+0x7f>
      return -1;
8010466a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010466f:	eb 59                	jmp    801046ca <growproc+0xa1>
  } else if(n < 0){
80104671:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104675:	79 31                	jns    801046a8 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104677:	8b 55 08             	mov    0x8(%ebp),%edx
8010467a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467d:	01 c2                	add    %eax,%edx
8010467f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104685:	8b 40 04             	mov    0x4(%eax),%eax
80104688:	83 ec 04             	sub    $0x4,%esp
8010468b:	52                   	push   %edx
8010468c:	ff 75 f4             	pushl  -0xc(%ebp)
8010468f:	50                   	push   %eax
80104690:	e8 67 41 00 00       	call   801087fc <deallocuvm>
80104695:	83 c4 10             	add    $0x10,%esp
80104698:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010469b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010469f:	75 07                	jne    801046a8 <growproc+0x7f>
      return -1;
801046a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046a6:	eb 22                	jmp    801046ca <growproc+0xa1>
  }
  proc->sz = sz;
801046a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046b1:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801046b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b9:	83 ec 0c             	sub    $0xc,%esp
801046bc:	50                   	push   %eax
801046bd:	e8 89 3c 00 00       	call   8010834b <switchuvm>
801046c2:	83 c4 10             	add    $0x10,%esp
  return 0;
801046c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046ca:	c9                   	leave  
801046cb:	c3                   	ret    

801046cc <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801046cc:	55                   	push   %ebp
801046cd:	89 e5                	mov    %esp,%ebp
801046cf:	57                   	push   %edi
801046d0:	56                   	push   %esi
801046d1:	53                   	push   %ebx
801046d2:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801046d5:	e8 ea fc ff ff       	call   801043c4 <allocproc>
801046da:	89 45 e0             	mov    %eax,-0x20(%ebp)
801046dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801046e1:	75 0a                	jne    801046ed <fork+0x21>
    return -1;
801046e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046e8:	e9 68 01 00 00       	jmp    80104855 <fork+0x189>

  // Copy process state from p.
  //look into this for cowfork
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801046ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f3:	8b 10                	mov    (%eax),%edx
801046f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046fb:	8b 40 04             	mov    0x4(%eax),%eax
801046fe:	83 ec 08             	sub    $0x8,%esp
80104701:	52                   	push   %edx
80104702:	50                   	push   %eax
80104703:	e8 72 43 00 00       	call   80108a7a <copyuvm>
80104708:	83 c4 10             	add    $0x10,%esp
8010470b:	89 c2                	mov    %eax,%edx
8010470d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104710:	89 50 04             	mov    %edx,0x4(%eax)
80104713:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104716:	8b 40 04             	mov    0x4(%eax),%eax
80104719:	85 c0                	test   %eax,%eax
8010471b:	75 30                	jne    8010474d <fork+0x81>
    kfree(np->kstack);
8010471d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104720:	8b 40 08             	mov    0x8(%eax),%eax
80104723:	83 ec 0c             	sub    $0xc,%esp
80104726:	50                   	push   %eax
80104727:	e8 fc e3 ff ff       	call   80102b28 <kfree>
8010472c:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010472f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104732:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104739:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010473c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104743:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104748:	e9 08 01 00 00       	jmp    80104855 <fork+0x189>
  }
  np->sz = proc->sz;
8010474d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104753:	8b 10                	mov    (%eax),%edx
80104755:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104758:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010475a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104761:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104764:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104767:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010476a:	8b 50 18             	mov    0x18(%eax),%edx
8010476d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104773:	8b 40 18             	mov    0x18(%eax),%eax
80104776:	89 c3                	mov    %eax,%ebx
80104778:	b8 13 00 00 00       	mov    $0x13,%eax
8010477d:	89 d7                	mov    %edx,%edi
8010477f:	89 de                	mov    %ebx,%esi
80104781:	89 c1                	mov    %eax,%ecx
80104783:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104785:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104788:	8b 40 18             	mov    0x18(%eax),%eax
8010478b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104792:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104799:	eb 43                	jmp    801047de <fork+0x112>
    if(proc->ofile[i])
8010479b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047a4:	83 c2 08             	add    $0x8,%edx
801047a7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047ab:	85 c0                	test   %eax,%eax
801047ad:	74 2b                	je     801047da <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
801047af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047b8:	83 c2 08             	add    $0x8,%edx
801047bb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047bf:	83 ec 0c             	sub    $0xc,%esp
801047c2:	50                   	push   %eax
801047c3:	e8 1d c8 ff ff       	call   80100fe5 <filedup>
801047c8:	83 c4 10             	add    $0x10,%esp
801047cb:	89 c1                	mov    %eax,%ecx
801047cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047d3:	83 c2 08             	add    $0x8,%edx
801047d6:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801047da:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047de:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047e2:	7e b7                	jle    8010479b <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801047e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ea:	8b 40 68             	mov    0x68(%eax),%eax
801047ed:	83 ec 0c             	sub    $0xc,%esp
801047f0:	50                   	push   %eax
801047f1:	e8 db d0 ff ff       	call   801018d1 <idup>
801047f6:	83 c4 10             	add    $0x10,%esp
801047f9:	89 c2                	mov    %eax,%edx
801047fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047fe:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104801:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104807:	8d 50 6c             	lea    0x6c(%eax),%edx
8010480a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010480d:	83 c0 6c             	add    $0x6c,%eax
80104810:	83 ec 04             	sub    $0x4,%esp
80104813:	6a 10                	push   $0x10
80104815:	52                   	push   %edx
80104816:	50                   	push   %eax
80104817:	e8 45 0f 00 00       	call   80105761 <safestrcpy>
8010481c:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
8010481f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104822:	8b 40 10             	mov    0x10(%eax),%eax
80104825:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	68 80 39 11 80       	push   $0x80113980
80104830:	e8 c6 0a 00 00       	call   801052fb <acquire>
80104835:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104838:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010483b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104842:	83 ec 0c             	sub    $0xc,%esp
80104845:	68 80 39 11 80       	push   $0x80113980
8010484a:	e8 13 0b 00 00       	call   80105362 <release>
8010484f:	83 c4 10             	add    $0x10,%esp

  return pid;
80104852:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104855:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104858:	5b                   	pop    %ebx
80104859:	5e                   	pop    %esi
8010485a:	5f                   	pop    %edi
8010485b:	5d                   	pop    %ebp
8010485c:	c3                   	ret    

8010485d <cowfork>:

int cowfork(void) {
8010485d:	55                   	push   %ebp
8010485e:	89 e5                	mov    %esp,%ebp
80104860:	57                   	push   %edi
80104861:	56                   	push   %esi
80104862:	53                   	push   %ebx
80104863:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104866:	e8 59 fb ff ff       	call   801043c4 <allocproc>
8010486b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010486e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104872:	75 0a                	jne    8010487e <cowfork+0x21>
    return -1;
80104874:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104879:	e9 a5 01 00 00       	jmp    80104a23 <cowfork+0x1c6>

  // Copy process state from p.
  //look into this for cowfork
  cprintf("COWFORK ME!\n");
8010487e:	83 ec 0c             	sub    $0xc,%esp
80104881:	68 2c 91 10 80       	push   $0x8010912c
80104886:	e8 3b bb ff ff       	call   801003c6 <cprintf>
8010488b:	83 c4 10             	add    $0x10,%esp
  if((np->pgdir = copyuvm_cow(proc->pgdir, proc->sz)) == 0){
8010488e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104894:	8b 10                	mov    (%eax),%edx
80104896:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010489c:	8b 40 04             	mov    0x4(%eax),%eax
8010489f:	83 ec 08             	sub    $0x8,%esp
801048a2:	52                   	push   %edx
801048a3:	50                   	push   %eax
801048a4:	e8 ed 42 00 00       	call   80108b96 <copyuvm_cow>
801048a9:	83 c4 10             	add    $0x10,%esp
801048ac:	89 c2                	mov    %eax,%edx
801048ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048b1:	89 50 04             	mov    %edx,0x4(%eax)
801048b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048b7:	8b 40 04             	mov    0x4(%eax),%eax
801048ba:	85 c0                	test   %eax,%eax
801048bc:	75 30                	jne    801048ee <cowfork+0x91>
    kfree(np->kstack);
801048be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048c1:	8b 40 08             	mov    0x8(%eax),%eax
801048c4:	83 ec 0c             	sub    $0xc,%esp
801048c7:	50                   	push   %eax
801048c8:	e8 5b e2 ff ff       	call   80102b28 <kfree>
801048cd:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801048d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801048da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048dd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801048e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048e9:	e9 35 01 00 00       	jmp    80104a23 <cowfork+0x1c6>
  }
  np->sz = proc->sz;
801048ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048f4:	8b 10                	mov    (%eax),%edx
801048f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048f9:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801048fb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104902:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104905:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104908:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010490b:	8b 50 18             	mov    0x18(%eax),%edx
8010490e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104914:	8b 40 18             	mov    0x18(%eax),%eax
80104917:	89 c3                	mov    %eax,%ebx
80104919:	b8 13 00 00 00       	mov    $0x13,%eax
8010491e:	89 d7                	mov    %edx,%edi
80104920:	89 de                	mov    %ebx,%esi
80104922:	89 c1                	mov    %eax,%ecx
80104924:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104926:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104929:	8b 40 18             	mov    0x18(%eax),%eax
8010492c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104933:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010493a:	eb 43                	jmp    8010497f <cowfork+0x122>
    if(proc->ofile[i])
8010493c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104942:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104945:	83 c2 08             	add    $0x8,%edx
80104948:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010494c:	85 c0                	test   %eax,%eax
8010494e:	74 2b                	je     8010497b <cowfork+0x11e>
      np->ofile[i] = filedup(proc->ofile[i]);
80104950:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104956:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104959:	83 c2 08             	add    $0x8,%edx
8010495c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	50                   	push   %eax
80104964:	e8 7c c6 ff ff       	call   80100fe5 <filedup>
80104969:	83 c4 10             	add    $0x10,%esp
8010496c:	89 c1                	mov    %eax,%ecx
8010496e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104971:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104974:	83 c2 08             	add    $0x8,%edx
80104977:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010497b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010497f:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104983:	7e b7                	jle    8010493c <cowfork+0xdf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104985:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010498b:	8b 40 68             	mov    0x68(%eax),%eax
8010498e:	83 ec 0c             	sub    $0xc,%esp
80104991:	50                   	push   %eax
80104992:	e8 3a cf ff ff       	call   801018d1 <idup>
80104997:	83 c4 10             	add    $0x10,%esp
8010499a:	89 c2                	mov    %eax,%edx
8010499c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010499f:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801049a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a8:	8d 50 6c             	lea    0x6c(%eax),%edx
801049ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ae:	83 c0 6c             	add    $0x6c,%eax
801049b1:	83 ec 04             	sub    $0x4,%esp
801049b4:	6a 10                	push   $0x10
801049b6:	52                   	push   %edx
801049b7:	50                   	push   %eax
801049b8:	e8 a4 0d 00 00       	call   80105761 <safestrcpy>
801049bd:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
801049c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049c3:	8b 40 10             	mov    0x10(%eax),%eax
801049c6:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801049c9:	83 ec 0c             	sub    $0xc,%esp
801049cc:	68 80 39 11 80       	push   $0x80113980
801049d1:	e8 25 09 00 00       	call   801052fb <acquire>
801049d6:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801049d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801049e3:	83 ec 0c             	sub    $0xc,%esp
801049e6:	68 80 39 11 80       	push   $0x80113980
801049eb:	e8 72 09 00 00       	call   80105362 <release>
801049f0:	83 c4 10             	add    $0x10,%esp

  //set process to shared
  proc->shared = 1;
801049f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049f9:	c7 80 88 00 00 00 01 	movl   $0x1,0x88(%eax)
80104a00:	00 00 00 
  np->shared = 1;
80104a03:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a06:	c7 80 88 00 00 00 01 	movl   $0x1,0x88(%eax)
80104a0d:	00 00 00 
  cprintf("THE FORK IS IN ME!\n");
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	68 39 91 10 80       	push   $0x80109139
80104a18:	e8 a9 b9 ff ff       	call   801003c6 <cprintf>
80104a1d:	83 c4 10             	add    $0x10,%esp
  return pid;
80104a20:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104a23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a26:	5b                   	pop    %ebx
80104a27:	5e                   	pop    %esi
80104a28:	5f                   	pop    %edi
80104a29:	5d                   	pop    %ebp
80104a2a:	c3                   	ret    

80104a2b <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104a2b:	55                   	push   %ebp
80104a2c:	89 e5                	mov    %esp,%ebp
80104a2e:	83 ec 18             	sub    $0x18,%esp
  cprintf("Exiting\n");
80104a31:	83 ec 0c             	sub    $0xc,%esp
80104a34:	68 4d 91 10 80       	push   $0x8010914d
80104a39:	e8 88 b9 ff ff       	call   801003c6 <cprintf>
80104a3e:	83 c4 10             	add    $0x10,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104a41:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a48:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104a4d:	39 c2                	cmp    %eax,%edx
80104a4f:	75 0d                	jne    80104a5e <exit+0x33>
    panic("init exiting");
80104a51:	83 ec 0c             	sub    $0xc,%esp
80104a54:	68 56 91 10 80       	push   $0x80109156
80104a59:	e8 08 bb ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a5e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104a65:	eb 48                	jmp    80104aaf <exit+0x84>
    if(proc->ofile[fd]){
80104a67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a70:	83 c2 08             	add    $0x8,%edx
80104a73:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a77:	85 c0                	test   %eax,%eax
80104a79:	74 30                	je     80104aab <exit+0x80>
      fileclose(proc->ofile[fd]);
80104a7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a81:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a84:	83 c2 08             	add    $0x8,%edx
80104a87:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a8b:	83 ec 0c             	sub    $0xc,%esp
80104a8e:	50                   	push   %eax
80104a8f:	e8 a2 c5 ff ff       	call   80101036 <fileclose>
80104a94:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104a97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104aa0:	83 c2 08             	add    $0x8,%edx
80104aa3:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104aaa:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104aab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104aaf:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104ab3:	7e b2                	jle    80104a67 <exit+0x3c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104ab5:	e8 fa e9 ff ff       	call   801034b4 <begin_op>
  iput(proc->cwd);
80104aba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac0:	8b 40 68             	mov    0x68(%eax),%eax
80104ac3:	83 ec 0c             	sub    $0xc,%esp
80104ac6:	50                   	push   %eax
80104ac7:	e8 09 d0 ff ff       	call   80101ad5 <iput>
80104acc:	83 c4 10             	add    $0x10,%esp
  end_op();
80104acf:	e8 6c ea ff ff       	call   80103540 <end_op>
  proc->cwd = 0;
80104ad4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ada:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104ae1:	83 ec 0c             	sub    $0xc,%esp
80104ae4:	68 80 39 11 80       	push   $0x80113980
80104ae9:	e8 0d 08 00 00       	call   801052fb <acquire>
80104aee:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104af1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af7:	8b 40 14             	mov    0x14(%eax),%eax
80104afa:	83 ec 0c             	sub    $0xc,%esp
80104afd:	50                   	push   %eax
80104afe:	e8 3b 04 00 00       	call   80104f3e <wakeup1>
80104b03:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b06:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104b0d:	eb 3f                	jmp    80104b4e <exit+0x123>
    if(p->parent == proc){
80104b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b12:	8b 50 14             	mov    0x14(%eax),%edx
80104b15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b1b:	39 c2                	cmp    %eax,%edx
80104b1d:	75 28                	jne    80104b47 <exit+0x11c>
      p->parent = initproc;
80104b1f:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b28:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b2e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b31:	83 f8 05             	cmp    $0x5,%eax
80104b34:	75 11                	jne    80104b47 <exit+0x11c>
        wakeup1(initproc);
80104b36:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104b3b:	83 ec 0c             	sub    $0xc,%esp
80104b3e:	50                   	push   %eax
80104b3f:	e8 fa 03 00 00       	call   80104f3e <wakeup1>
80104b44:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b47:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104b4e:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104b55:	72 b8                	jb     80104b0f <exit+0xe4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104b57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5d:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104b64:	e8 01 02 00 00       	call   80104d6a <sched>
  panic("zombie exit");
80104b69:	83 ec 0c             	sub    $0xc,%esp
80104b6c:	68 63 91 10 80       	push   $0x80109163
80104b71:	e8 f0 b9 ff ff       	call   80100566 <panic>

80104b76 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104b76:	55                   	push   %ebp
80104b77:	89 e5                	mov    %esp,%ebp
80104b79:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104b7c:	83 ec 0c             	sub    $0xc,%esp
80104b7f:	68 80 39 11 80       	push   $0x80113980
80104b84:	e8 72 07 00 00       	call   801052fb <acquire>
80104b89:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b93:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104b9a:	e9 ce 00 00 00       	jmp    80104c6d <wait+0xf7>
      if(p->parent != proc)
80104b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba2:	8b 50 14             	mov    0x14(%eax),%edx
80104ba5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bab:	39 c2                	cmp    %eax,%edx
80104bad:	0f 85 b2 00 00 00    	jne    80104c65 <wait+0xef>
        continue;
      havekids = 1;
80104bb3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbd:	8b 40 0c             	mov    0xc(%eax),%eax
80104bc0:	83 f8 05             	cmp    $0x5,%eax
80104bc3:	0f 85 9d 00 00 00    	jne    80104c66 <wait+0xf0>
        // Found one.
        pid = p->pid;
80104bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bcc:	8b 40 10             	mov    0x10(%eax),%eax
80104bcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd5:	8b 40 08             	mov    0x8(%eax),%eax
80104bd8:	83 ec 0c             	sub    $0xc,%esp
80104bdb:	50                   	push   %eax
80104bdc:	e8 47 df ff ff       	call   80102b28 <kfree>
80104be1:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        if(p->shared == 0){
80104bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf1:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104bf7:	85 c0                	test   %eax,%eax
80104bf9:	75 14                	jne    80104c0f <wait+0x99>
          freevm(p->pgdir);
80104bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bfe:	8b 40 04             	mov    0x4(%eax),%eax
80104c01:	83 ec 0c             	sub    $0xc,%esp
80104c04:	50                   	push   %eax
80104c05:	e8 5e 3d 00 00       	call   80108968 <freevm>
80104c0a:	83 c4 10             	add    $0x10,%esp
80104c0d:	eb 12                	jmp    80104c21 <wait+0xab>
        } else {
          free_cow_vm(p->pgdir);
80104c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c12:	8b 40 04             	mov    0x4(%eax),%eax
80104c15:	83 ec 0c             	sub    $0xc,%esp
80104c18:	50                   	push   %eax
80104c19:	e8 ea 3d 00 00       	call   80108a08 <free_cow_vm>
80104c1e:	83 c4 10             	add    $0x10,%esp
        }
        p->state = UNUSED;
80104c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c24:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c2e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c38:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c42:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c49:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104c50:	83 ec 0c             	sub    $0xc,%esp
80104c53:	68 80 39 11 80       	push   $0x80113980
80104c58:	e8 05 07 00 00       	call   80105362 <release>
80104c5d:	83 c4 10             	add    $0x10,%esp
        return pid;
80104c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c63:	eb 5b                	jmp    80104cc0 <wait+0x14a>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104c65:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c66:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104c6d:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104c74:	0f 82 25 ff ff ff    	jb     80104b9f <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104c7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c7e:	74 0d                	je     80104c8d <wait+0x117>
80104c80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c86:	8b 40 24             	mov    0x24(%eax),%eax
80104c89:	85 c0                	test   %eax,%eax
80104c8b:	74 17                	je     80104ca4 <wait+0x12e>
      release(&ptable.lock);
80104c8d:	83 ec 0c             	sub    $0xc,%esp
80104c90:	68 80 39 11 80       	push   $0x80113980
80104c95:	e8 c8 06 00 00       	call   80105362 <release>
80104c9a:	83 c4 10             	add    $0x10,%esp
      return -1;
80104c9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ca2:	eb 1c                	jmp    80104cc0 <wait+0x14a>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104ca4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104caa:	83 ec 08             	sub    $0x8,%esp
80104cad:	68 80 39 11 80       	push   $0x80113980
80104cb2:	50                   	push   %eax
80104cb3:	e8 da 01 00 00       	call   80104e92 <sleep>
80104cb8:	83 c4 10             	add    $0x10,%esp
  }
80104cbb:	e9 cc fe ff ff       	jmp    80104b8c <wait+0x16>
}
80104cc0:	c9                   	leave  
80104cc1:	c3                   	ret    

80104cc2 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104cc2:	55                   	push   %ebp
80104cc3:	89 e5                	mov    %esp,%ebp
80104cc5:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104cc8:	e8 d2 f6 ff ff       	call   8010439f <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104ccd:	83 ec 0c             	sub    $0xc,%esp
80104cd0:	68 80 39 11 80       	push   $0x80113980
80104cd5:	e8 21 06 00 00       	call   801052fb <acquire>
80104cda:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cdd:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104ce4:	eb 66                	jmp    80104d4c <scheduler+0x8a>
      if(p->state != RUNNABLE)
80104ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce9:	8b 40 0c             	mov    0xc(%eax),%eax
80104cec:	83 f8 03             	cmp    $0x3,%eax
80104cef:	75 53                	jne    80104d44 <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf4:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104cfa:	83 ec 0c             	sub    $0xc,%esp
80104cfd:	ff 75 f4             	pushl  -0xc(%ebp)
80104d00:	e8 46 36 00 00       	call   8010834b <switchuvm>
80104d05:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d0b:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104d12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d18:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d1b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104d22:	83 c2 04             	add    $0x4,%edx
80104d25:	83 ec 08             	sub    $0x8,%esp
80104d28:	50                   	push   %eax
80104d29:	52                   	push   %edx
80104d2a:	e8 a3 0a 00 00       	call   801057d2 <swtch>
80104d2f:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104d32:	e8 f7 35 00 00       	call   8010832e <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104d37:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104d3e:	00 00 00 00 
80104d42:	eb 01                	jmp    80104d45 <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104d44:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d45:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104d4c:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104d53:	72 91                	jb     80104ce6 <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104d55:	83 ec 0c             	sub    $0xc,%esp
80104d58:	68 80 39 11 80       	push   $0x80113980
80104d5d:	e8 00 06 00 00       	call   80105362 <release>
80104d62:	83 c4 10             	add    $0x10,%esp

  }
80104d65:	e9 5e ff ff ff       	jmp    80104cc8 <scheduler+0x6>

80104d6a <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104d6a:	55                   	push   %ebp
80104d6b:	89 e5                	mov    %esp,%ebp
80104d6d:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104d70:	83 ec 0c             	sub    $0xc,%esp
80104d73:	68 80 39 11 80       	push   $0x80113980
80104d78:	e8 b1 06 00 00       	call   8010542e <holding>
80104d7d:	83 c4 10             	add    $0x10,%esp
80104d80:	85 c0                	test   %eax,%eax
80104d82:	75 0d                	jne    80104d91 <sched+0x27>
    panic("sched ptable.lock");
80104d84:	83 ec 0c             	sub    $0xc,%esp
80104d87:	68 6f 91 10 80       	push   $0x8010916f
80104d8c:	e8 d5 b7 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104d91:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d97:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d9d:	83 f8 01             	cmp    $0x1,%eax
80104da0:	74 0d                	je     80104daf <sched+0x45>
    panic("sched locks");
80104da2:	83 ec 0c             	sub    $0xc,%esp
80104da5:	68 81 91 10 80       	push   $0x80109181
80104daa:	e8 b7 b7 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104daf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104db5:	8b 40 0c             	mov    0xc(%eax),%eax
80104db8:	83 f8 04             	cmp    $0x4,%eax
80104dbb:	75 0d                	jne    80104dca <sched+0x60>
    panic("sched running");
80104dbd:	83 ec 0c             	sub    $0xc,%esp
80104dc0:	68 8d 91 10 80       	push   $0x8010918d
80104dc5:	e8 9c b7 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104dca:	e8 c0 f5 ff ff       	call   8010438f <readeflags>
80104dcf:	25 00 02 00 00       	and    $0x200,%eax
80104dd4:	85 c0                	test   %eax,%eax
80104dd6:	74 0d                	je     80104de5 <sched+0x7b>
    panic("sched interruptible");
80104dd8:	83 ec 0c             	sub    $0xc,%esp
80104ddb:	68 9b 91 10 80       	push   $0x8010919b
80104de0:	e8 81 b7 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104de5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104deb:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104df4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dfa:	8b 40 04             	mov    0x4(%eax),%eax
80104dfd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e04:	83 c2 1c             	add    $0x1c,%edx
80104e07:	83 ec 08             	sub    $0x8,%esp
80104e0a:	50                   	push   %eax
80104e0b:	52                   	push   %edx
80104e0c:	e8 c1 09 00 00       	call   801057d2 <swtch>
80104e11:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104e14:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e1d:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104e23:	90                   	nop
80104e24:	c9                   	leave  
80104e25:	c3                   	ret    

80104e26 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104e26:	55                   	push   %ebp
80104e27:	89 e5                	mov    %esp,%ebp
80104e29:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104e2c:	83 ec 0c             	sub    $0xc,%esp
80104e2f:	68 80 39 11 80       	push   $0x80113980
80104e34:	e8 c2 04 00 00       	call   801052fb <acquire>
80104e39:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104e3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e42:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104e49:	e8 1c ff ff ff       	call   80104d6a <sched>
  release(&ptable.lock);
80104e4e:	83 ec 0c             	sub    $0xc,%esp
80104e51:	68 80 39 11 80       	push   $0x80113980
80104e56:	e8 07 05 00 00       	call   80105362 <release>
80104e5b:	83 c4 10             	add    $0x10,%esp
}
80104e5e:	90                   	nop
80104e5f:	c9                   	leave  
80104e60:	c3                   	ret    

80104e61 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104e61:	55                   	push   %ebp
80104e62:	89 e5                	mov    %esp,%ebp
80104e64:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104e67:	83 ec 0c             	sub    $0xc,%esp
80104e6a:	68 80 39 11 80       	push   $0x80113980
80104e6f:	e8 ee 04 00 00       	call   80105362 <release>
80104e74:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104e77:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104e7c:	85 c0                	test   %eax,%eax
80104e7e:	74 0f                	je     80104e8f <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104e80:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104e87:	00 00 00 
    initlog();
80104e8a:	e8 ff e3 ff ff       	call   8010328e <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104e8f:	90                   	nop
80104e90:	c9                   	leave  
80104e91:	c3                   	ret    

80104e92 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e92:	55                   	push   %ebp
80104e93:	89 e5                	mov    %esp,%ebp
80104e95:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104e98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e9e:	85 c0                	test   %eax,%eax
80104ea0:	75 0d                	jne    80104eaf <sleep+0x1d>
    panic("sleep");
80104ea2:	83 ec 0c             	sub    $0xc,%esp
80104ea5:	68 af 91 10 80       	push   $0x801091af
80104eaa:	e8 b7 b6 ff ff       	call   80100566 <panic>

  if(lk == 0)
80104eaf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104eb3:	75 0d                	jne    80104ec2 <sleep+0x30>
    panic("sleep without lk");
80104eb5:	83 ec 0c             	sub    $0xc,%esp
80104eb8:	68 b5 91 10 80       	push   $0x801091b5
80104ebd:	e8 a4 b6 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ec2:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104ec9:	74 1e                	je     80104ee9 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ecb:	83 ec 0c             	sub    $0xc,%esp
80104ece:	68 80 39 11 80       	push   $0x80113980
80104ed3:	e8 23 04 00 00       	call   801052fb <acquire>
80104ed8:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104edb:	83 ec 0c             	sub    $0xc,%esp
80104ede:	ff 75 0c             	pushl  0xc(%ebp)
80104ee1:	e8 7c 04 00 00       	call   80105362 <release>
80104ee6:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104ee9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eef:	8b 55 08             	mov    0x8(%ebp),%edx
80104ef2:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104ef5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104efb:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104f02:	e8 63 fe ff ff       	call   80104d6a <sched>

  // Tidy up.
  proc->chan = 0;
80104f07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f0d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104f14:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104f1b:	74 1e                	je     80104f3b <sleep+0xa9>
    release(&ptable.lock);
80104f1d:	83 ec 0c             	sub    $0xc,%esp
80104f20:	68 80 39 11 80       	push   $0x80113980
80104f25:	e8 38 04 00 00       	call   80105362 <release>
80104f2a:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104f2d:	83 ec 0c             	sub    $0xc,%esp
80104f30:	ff 75 0c             	pushl  0xc(%ebp)
80104f33:	e8 c3 03 00 00       	call   801052fb <acquire>
80104f38:	83 c4 10             	add    $0x10,%esp
  }
}
80104f3b:	90                   	nop
80104f3c:	c9                   	leave  
80104f3d:	c3                   	ret    

80104f3e <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104f3e:	55                   	push   %ebp
80104f3f:	89 e5                	mov    %esp,%ebp
80104f41:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f44:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104f4b:	eb 27                	jmp    80104f74 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104f4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f50:	8b 40 0c             	mov    0xc(%eax),%eax
80104f53:	83 f8 02             	cmp    $0x2,%eax
80104f56:	75 15                	jne    80104f6d <wakeup1+0x2f>
80104f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f5b:	8b 40 20             	mov    0x20(%eax),%eax
80104f5e:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f61:	75 0a                	jne    80104f6d <wakeup1+0x2f>
      p->state = RUNNABLE;
80104f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f66:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f6d:	81 45 fc 8c 00 00 00 	addl   $0x8c,-0x4(%ebp)
80104f74:	81 7d fc b4 5c 11 80 	cmpl   $0x80115cb4,-0x4(%ebp)
80104f7b:	72 d0                	jb     80104f4d <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104f7d:	90                   	nop
80104f7e:	c9                   	leave  
80104f7f:	c3                   	ret    

80104f80 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104f86:	83 ec 0c             	sub    $0xc,%esp
80104f89:	68 80 39 11 80       	push   $0x80113980
80104f8e:	e8 68 03 00 00       	call   801052fb <acquire>
80104f93:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104f96:	83 ec 0c             	sub    $0xc,%esp
80104f99:	ff 75 08             	pushl  0x8(%ebp)
80104f9c:	e8 9d ff ff ff       	call   80104f3e <wakeup1>
80104fa1:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104fa4:	83 ec 0c             	sub    $0xc,%esp
80104fa7:	68 80 39 11 80       	push   $0x80113980
80104fac:	e8 b1 03 00 00       	call   80105362 <release>
80104fb1:	83 c4 10             	add    $0x10,%esp
}
80104fb4:	90                   	nop
80104fb5:	c9                   	leave  
80104fb6:	c3                   	ret    

80104fb7 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104fb7:	55                   	push   %ebp
80104fb8:	89 e5                	mov    %esp,%ebp
80104fba:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104fbd:	83 ec 0c             	sub    $0xc,%esp
80104fc0:	68 80 39 11 80       	push   $0x80113980
80104fc5:	e8 31 03 00 00       	call   801052fb <acquire>
80104fca:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fcd:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104fd4:	eb 48                	jmp    8010501e <kill+0x67>
    if(p->pid == pid){
80104fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd9:	8b 40 10             	mov    0x10(%eax),%eax
80104fdc:	3b 45 08             	cmp    0x8(%ebp),%eax
80104fdf:	75 36                	jne    80105017 <kill+0x60>
      p->killed = 1;
80104fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe4:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fee:	8b 40 0c             	mov    0xc(%eax),%eax
80104ff1:	83 f8 02             	cmp    $0x2,%eax
80104ff4:	75 0a                	jne    80105000 <kill+0x49>
        p->state = RUNNABLE;
80104ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105000:	83 ec 0c             	sub    $0xc,%esp
80105003:	68 80 39 11 80       	push   $0x80113980
80105008:	e8 55 03 00 00       	call   80105362 <release>
8010500d:	83 c4 10             	add    $0x10,%esp
      return 0;
80105010:	b8 00 00 00 00       	mov    $0x0,%eax
80105015:	eb 25                	jmp    8010503c <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105017:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
8010501e:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80105025:	72 af                	jb     80104fd6 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80105027:	83 ec 0c             	sub    $0xc,%esp
8010502a:	68 80 39 11 80       	push   $0x80113980
8010502f:	e8 2e 03 00 00       	call   80105362 <release>
80105034:	83 c4 10             	add    $0x10,%esp
  return -1;
80105037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010503c:	c9                   	leave  
8010503d:	c3                   	ret    

8010503e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010503e:	55                   	push   %ebp
8010503f:	89 e5                	mov    %esp,%ebp
80105041:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105044:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
8010504b:	e9 da 00 00 00       	jmp    8010512a <procdump+0xec>
    if(p->state == UNUSED)
80105050:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105053:	8b 40 0c             	mov    0xc(%eax),%eax
80105056:	85 c0                	test   %eax,%eax
80105058:	0f 84 c4 00 00 00    	je     80105122 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010505e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105061:	8b 40 0c             	mov    0xc(%eax),%eax
80105064:	83 f8 05             	cmp    $0x5,%eax
80105067:	77 23                	ja     8010508c <procdump+0x4e>
80105069:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010506c:	8b 40 0c             	mov    0xc(%eax),%eax
8010506f:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105076:	85 c0                	test   %eax,%eax
80105078:	74 12                	je     8010508c <procdump+0x4e>
      state = states[p->state];
8010507a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010507d:	8b 40 0c             	mov    0xc(%eax),%eax
80105080:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105087:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010508a:	eb 07                	jmp    80105093 <procdump+0x55>
    else
      state = "???";
8010508c:	c7 45 ec c6 91 10 80 	movl   $0x801091c6,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105093:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105096:	8d 50 6c             	lea    0x6c(%eax),%edx
80105099:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010509c:	8b 40 10             	mov    0x10(%eax),%eax
8010509f:	52                   	push   %edx
801050a0:	ff 75 ec             	pushl  -0x14(%ebp)
801050a3:	50                   	push   %eax
801050a4:	68 ca 91 10 80       	push   $0x801091ca
801050a9:	e8 18 b3 ff ff       	call   801003c6 <cprintf>
801050ae:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
801050b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050b4:	8b 40 0c             	mov    0xc(%eax),%eax
801050b7:	83 f8 02             	cmp    $0x2,%eax
801050ba:	75 54                	jne    80105110 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801050bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050bf:	8b 40 1c             	mov    0x1c(%eax),%eax
801050c2:	8b 40 0c             	mov    0xc(%eax),%eax
801050c5:	83 c0 08             	add    $0x8,%eax
801050c8:	89 c2                	mov    %eax,%edx
801050ca:	83 ec 08             	sub    $0x8,%esp
801050cd:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050d0:	50                   	push   %eax
801050d1:	52                   	push   %edx
801050d2:	e8 dd 02 00 00       	call   801053b4 <getcallerpcs>
801050d7:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801050da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801050e1:	eb 1c                	jmp    801050ff <procdump+0xc1>
        cprintf(" %p", pc[i]);
801050e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e6:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050ea:	83 ec 08             	sub    $0x8,%esp
801050ed:	50                   	push   %eax
801050ee:	68 d3 91 10 80       	push   $0x801091d3
801050f3:	e8 ce b2 ff ff       	call   801003c6 <cprintf>
801050f8:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801050fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801050ff:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105103:	7f 0b                	jg     80105110 <procdump+0xd2>
80105105:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105108:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010510c:	85 c0                	test   %eax,%eax
8010510e:	75 d3                	jne    801050e3 <procdump+0xa5>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105110:	83 ec 0c             	sub    $0xc,%esp
80105113:	68 d7 91 10 80       	push   $0x801091d7
80105118:	e8 a9 b2 ff ff       	call   801003c6 <cprintf>
8010511d:	83 c4 10             	add    $0x10,%esp
80105120:	eb 01                	jmp    80105123 <procdump+0xe5>
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105122:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105123:	81 45 f0 8c 00 00 00 	addl   $0x8c,-0x10(%ebp)
8010512a:	81 7d f0 b4 5c 11 80 	cmpl   $0x80115cb4,-0x10(%ebp)
80105131:	0f 82 19 ff ff ff    	jb     80105050 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105137:	90                   	nop
80105138:	c9                   	leave  
80105139:	c3                   	ret    

8010513a <signal_deliver>:

void signal_deliver(int signum,siginfo_t si)
{
8010513a:	55                   	push   %ebp
8010513b:	89 e5                	mov    %esp,%ebp
8010513d:	83 ec 10             	sub    $0x10,%esp
	uint old_eip = proc->tf->eip;
80105140:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105146:	8b 40 18             	mov    0x18(%eax),%eax
80105149:	8b 40 38             	mov    0x38(%eax),%eax
8010514c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	*((uint*)(proc->tf->esp - 4))  = (uint) old_eip;		// real return address
8010514f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105155:	8b 40 18             	mov    0x18(%eax),%eax
80105158:	8b 40 44             	mov    0x44(%eax),%eax
8010515b:	83 e8 04             	sub    $0x4,%eax
8010515e:	89 c2                	mov    %eax,%edx
80105160:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105163:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 8))  = proc->tf->eax;			// eax
80105165:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010516b:	8b 40 18             	mov    0x18(%eax),%eax
8010516e:	8b 40 44             	mov    0x44(%eax),%eax
80105171:	83 e8 08             	sub    $0x8,%eax
80105174:	89 c2                	mov    %eax,%edx
80105176:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010517c:	8b 40 18             	mov    0x18(%eax),%eax
8010517f:	8b 40 1c             	mov    0x1c(%eax),%eax
80105182:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 12)) = proc->tf->ecx;			// ecx
80105184:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010518a:	8b 40 18             	mov    0x18(%eax),%eax
8010518d:	8b 40 44             	mov    0x44(%eax),%eax
80105190:	83 e8 0c             	sub    $0xc,%eax
80105193:	89 c2                	mov    %eax,%edx
80105195:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010519b:	8b 40 18             	mov    0x18(%eax),%eax
8010519e:	8b 40 18             	mov    0x18(%eax),%eax
801051a1:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 16)) = proc->tf->edx;			// edx
801051a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051a9:	8b 40 18             	mov    0x18(%eax),%eax
801051ac:	8b 40 44             	mov    0x44(%eax),%eax
801051af:	83 e8 10             	sub    $0x10,%eax
801051b2:	89 c2                	mov    %eax,%edx
801051b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051ba:	8b 40 18             	mov    0x18(%eax),%eax
801051bd:	8b 40 14             	mov    0x14(%eax),%eax
801051c0:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 20)) = si.type;       //address mem fault occured
801051c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051c8:	8b 40 18             	mov    0x18(%eax),%eax
801051cb:	8b 40 44             	mov    0x44(%eax),%eax
801051ce:	83 e8 14             	sub    $0x14,%eax
801051d1:	89 c2                	mov    %eax,%edx
801051d3:	8b 45 10             	mov    0x10(%ebp),%eax
801051d6:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 24)) = si.addr;       //address mem fault occured
801051d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051de:	8b 40 18             	mov    0x18(%eax),%eax
801051e1:	8b 40 44             	mov    0x44(%eax),%eax
801051e4:	83 e8 18             	sub    $0x18,%eax
801051e7:	89 c2                	mov    %eax,%edx
801051e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ec:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 28)) = (uint) signum;			// signal number
801051ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051f4:	8b 40 18             	mov    0x18(%eax),%eax
801051f7:	8b 40 44             	mov    0x44(%eax),%eax
801051fa:	83 e8 1c             	sub    $0x1c,%eax
801051fd:	89 c2                	mov    %eax,%edx
801051ff:	8b 45 08             	mov    0x8(%ebp),%eax
80105202:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 32)) = proc->restorer_addr;	// address of restorer
80105204:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010520a:	8b 40 18             	mov    0x18(%eax),%eax
8010520d:	8b 40 44             	mov    0x44(%eax),%eax
80105210:	83 e8 20             	sub    $0x20,%eax
80105213:	89 c2                	mov    %eax,%edx
80105215:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010521b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105221:	89 02                	mov    %eax,(%edx)
	proc->tf->esp -= 32;
80105223:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105229:	8b 40 18             	mov    0x18(%eax),%eax
8010522c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105233:	8b 52 18             	mov    0x18(%edx),%edx
80105236:	8b 52 44             	mov    0x44(%edx),%edx
80105239:	83 ea 20             	sub    $0x20,%edx
8010523c:	89 50 44             	mov    %edx,0x44(%eax)
	proc->tf->eip = (uint) proc->handlers[signum];
8010523f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105245:	8b 40 18             	mov    0x18(%eax),%eax
80105248:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010524f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105252:	83 c1 1c             	add    $0x1c,%ecx
80105255:	8b 54 8a 0c          	mov    0xc(%edx,%ecx,4),%edx
80105259:	89 50 38             	mov    %edx,0x38(%eax)
}
8010525c:	90                   	nop
8010525d:	c9                   	leave  
8010525e:	c3                   	ret    

8010525f <signal_register_handler>:



sighandler_t signal_register_handler(int signum, sighandler_t handler)
{
8010525f:	55                   	push   %ebp
80105260:	89 e5                	mov    %esp,%ebp
80105262:	83 ec 10             	sub    $0x10,%esp
	if (!proc)
80105265:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010526b:	85 c0                	test   %eax,%eax
8010526d:	75 07                	jne    80105276 <signal_register_handler+0x17>
		return (sighandler_t) -1;
8010526f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105274:	eb 29                	jmp    8010529f <signal_register_handler+0x40>

	sighandler_t previous = proc->handlers[signum];
80105276:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010527c:	8b 55 08             	mov    0x8(%ebp),%edx
8010527f:	83 c2 1c             	add    $0x1c,%edx
80105282:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105286:	89 45 fc             	mov    %eax,-0x4(%ebp)

	proc->handlers[signum] = handler;
80105289:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010528f:	8b 55 08             	mov    0x8(%ebp),%edx
80105292:	8d 4a 1c             	lea    0x1c(%edx),%ecx
80105295:	8b 55 0c             	mov    0xc(%ebp),%edx
80105298:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)

	return previous;
8010529c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010529f:	c9                   	leave  
801052a0:	c3                   	ret    

801052a1 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801052a1:	55                   	push   %ebp
801052a2:	89 e5                	mov    %esp,%ebp
801052a4:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801052a7:	9c                   	pushf  
801052a8:	58                   	pop    %eax
801052a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801052ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801052af:	c9                   	leave  
801052b0:	c3                   	ret    

801052b1 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801052b1:	55                   	push   %ebp
801052b2:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801052b4:	fa                   	cli    
}
801052b5:	90                   	nop
801052b6:	5d                   	pop    %ebp
801052b7:	c3                   	ret    

801052b8 <sti>:

static inline void
sti(void)
{
801052b8:	55                   	push   %ebp
801052b9:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801052bb:	fb                   	sti    
}
801052bc:	90                   	nop
801052bd:	5d                   	pop    %ebp
801052be:	c3                   	ret    

801052bf <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801052bf:	55                   	push   %ebp
801052c0:	89 e5                	mov    %esp,%ebp
801052c2:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801052c5:	8b 55 08             	mov    0x8(%ebp),%edx
801052c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801052cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052ce:	f0 87 02             	lock xchg %eax,(%edx)
801052d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801052d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801052d7:	c9                   	leave  
801052d8:	c3                   	ret    

801052d9 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801052d9:	55                   	push   %ebp
801052da:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801052dc:	8b 45 08             	mov    0x8(%ebp),%eax
801052df:	8b 55 0c             	mov    0xc(%ebp),%edx
801052e2:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801052e5:	8b 45 08             	mov    0x8(%ebp),%eax
801052e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801052ee:	8b 45 08             	mov    0x8(%ebp),%eax
801052f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801052f8:	90                   	nop
801052f9:	5d                   	pop    %ebp
801052fa:	c3                   	ret    

801052fb <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801052fb:	55                   	push   %ebp
801052fc:	89 e5                	mov    %esp,%ebp
801052fe:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105301:	e8 52 01 00 00       	call   80105458 <pushcli>
  if(holding(lk))
80105306:	8b 45 08             	mov    0x8(%ebp),%eax
80105309:	83 ec 0c             	sub    $0xc,%esp
8010530c:	50                   	push   %eax
8010530d:	e8 1c 01 00 00       	call   8010542e <holding>
80105312:	83 c4 10             	add    $0x10,%esp
80105315:	85 c0                	test   %eax,%eax
80105317:	74 0d                	je     80105326 <acquire+0x2b>
    panic("acquire");
80105319:	83 ec 0c             	sub    $0xc,%esp
8010531c:	68 03 92 10 80       	push   $0x80109203
80105321:	e8 40 b2 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105326:	90                   	nop
80105327:	8b 45 08             	mov    0x8(%ebp),%eax
8010532a:	83 ec 08             	sub    $0x8,%esp
8010532d:	6a 01                	push   $0x1
8010532f:	50                   	push   %eax
80105330:	e8 8a ff ff ff       	call   801052bf <xchg>
80105335:	83 c4 10             	add    $0x10,%esp
80105338:	85 c0                	test   %eax,%eax
8010533a:	75 eb                	jne    80105327 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010533c:	8b 45 08             	mov    0x8(%ebp),%eax
8010533f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105346:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105349:	8b 45 08             	mov    0x8(%ebp),%eax
8010534c:	83 c0 0c             	add    $0xc,%eax
8010534f:	83 ec 08             	sub    $0x8,%esp
80105352:	50                   	push   %eax
80105353:	8d 45 08             	lea    0x8(%ebp),%eax
80105356:	50                   	push   %eax
80105357:	e8 58 00 00 00       	call   801053b4 <getcallerpcs>
8010535c:	83 c4 10             	add    $0x10,%esp
}
8010535f:	90                   	nop
80105360:	c9                   	leave  
80105361:	c3                   	ret    

80105362 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105362:	55                   	push   %ebp
80105363:	89 e5                	mov    %esp,%ebp
80105365:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105368:	83 ec 0c             	sub    $0xc,%esp
8010536b:	ff 75 08             	pushl  0x8(%ebp)
8010536e:	e8 bb 00 00 00       	call   8010542e <holding>
80105373:	83 c4 10             	add    $0x10,%esp
80105376:	85 c0                	test   %eax,%eax
80105378:	75 0d                	jne    80105387 <release+0x25>
    panic("release");
8010537a:	83 ec 0c             	sub    $0xc,%esp
8010537d:	68 0b 92 10 80       	push   $0x8010920b
80105382:	e8 df b1 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105387:	8b 45 08             	mov    0x8(%ebp),%eax
8010538a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105391:	8b 45 08             	mov    0x8(%ebp),%eax
80105394:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010539b:	8b 45 08             	mov    0x8(%ebp),%eax
8010539e:	83 ec 08             	sub    $0x8,%esp
801053a1:	6a 00                	push   $0x0
801053a3:	50                   	push   %eax
801053a4:	e8 16 ff ff ff       	call   801052bf <xchg>
801053a9:	83 c4 10             	add    $0x10,%esp

  popcli();
801053ac:	e8 ec 00 00 00       	call   8010549d <popcli>
}
801053b1:	90                   	nop
801053b2:	c9                   	leave  
801053b3:	c3                   	ret    

801053b4 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801053b4:	55                   	push   %ebp
801053b5:	89 e5                	mov    %esp,%ebp
801053b7:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801053ba:	8b 45 08             	mov    0x8(%ebp),%eax
801053bd:	83 e8 08             	sub    $0x8,%eax
801053c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801053c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801053ca:	eb 38                	jmp    80105404 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801053cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801053d0:	74 53                	je     80105425 <getcallerpcs+0x71>
801053d2:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801053d9:	76 4a                	jbe    80105425 <getcallerpcs+0x71>
801053db:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801053df:	74 44                	je     80105425 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801053e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801053eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ee:	01 c2                	add    %eax,%edx
801053f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053f3:	8b 40 04             	mov    0x4(%eax),%eax
801053f6:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801053f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053fb:	8b 00                	mov    (%eax),%eax
801053fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105400:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105404:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105408:	7e c2                	jle    801053cc <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010540a:	eb 19                	jmp    80105425 <getcallerpcs+0x71>
    pcs[i] = 0;
8010540c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010540f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105416:	8b 45 0c             	mov    0xc(%ebp),%eax
80105419:	01 d0                	add    %edx,%eax
8010541b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105421:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105425:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105429:	7e e1                	jle    8010540c <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010542b:	90                   	nop
8010542c:	c9                   	leave  
8010542d:	c3                   	ret    

8010542e <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010542e:	55                   	push   %ebp
8010542f:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105431:	8b 45 08             	mov    0x8(%ebp),%eax
80105434:	8b 00                	mov    (%eax),%eax
80105436:	85 c0                	test   %eax,%eax
80105438:	74 17                	je     80105451 <holding+0x23>
8010543a:	8b 45 08             	mov    0x8(%ebp),%eax
8010543d:	8b 50 08             	mov    0x8(%eax),%edx
80105440:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105446:	39 c2                	cmp    %eax,%edx
80105448:	75 07                	jne    80105451 <holding+0x23>
8010544a:	b8 01 00 00 00       	mov    $0x1,%eax
8010544f:	eb 05                	jmp    80105456 <holding+0x28>
80105451:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105456:	5d                   	pop    %ebp
80105457:	c3                   	ret    

80105458 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105458:	55                   	push   %ebp
80105459:	89 e5                	mov    %esp,%ebp
8010545b:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010545e:	e8 3e fe ff ff       	call   801052a1 <readeflags>
80105463:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105466:	e8 46 fe ff ff       	call   801052b1 <cli>
  if(cpu->ncli++ == 0)
8010546b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105472:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105478:	8d 48 01             	lea    0x1(%eax),%ecx
8010547b:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105481:	85 c0                	test   %eax,%eax
80105483:	75 15                	jne    8010549a <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105485:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010548b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010548e:	81 e2 00 02 00 00    	and    $0x200,%edx
80105494:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010549a:	90                   	nop
8010549b:	c9                   	leave  
8010549c:	c3                   	ret    

8010549d <popcli>:

void
popcli(void)
{
8010549d:	55                   	push   %ebp
8010549e:	89 e5                	mov    %esp,%ebp
801054a0:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801054a3:	e8 f9 fd ff ff       	call   801052a1 <readeflags>
801054a8:	25 00 02 00 00       	and    $0x200,%eax
801054ad:	85 c0                	test   %eax,%eax
801054af:	74 0d                	je     801054be <popcli+0x21>
    panic("popcli - interruptible");
801054b1:	83 ec 0c             	sub    $0xc,%esp
801054b4:	68 13 92 10 80       	push   $0x80109213
801054b9:	e8 a8 b0 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801054be:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054c4:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801054ca:	83 ea 01             	sub    $0x1,%edx
801054cd:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801054d3:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054d9:	85 c0                	test   %eax,%eax
801054db:	79 0d                	jns    801054ea <popcli+0x4d>
    panic("popcli");
801054dd:	83 ec 0c             	sub    $0xc,%esp
801054e0:	68 2a 92 10 80       	push   $0x8010922a
801054e5:	e8 7c b0 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801054ea:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054f0:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054f6:	85 c0                	test   %eax,%eax
801054f8:	75 15                	jne    8010550f <popcli+0x72>
801054fa:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105500:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105506:	85 c0                	test   %eax,%eax
80105508:	74 05                	je     8010550f <popcli+0x72>
    sti();
8010550a:	e8 a9 fd ff ff       	call   801052b8 <sti>
}
8010550f:	90                   	nop
80105510:	c9                   	leave  
80105511:	c3                   	ret    

80105512 <stosb>:
80105512:	55                   	push   %ebp
80105513:	89 e5                	mov    %esp,%ebp
80105515:	57                   	push   %edi
80105516:	53                   	push   %ebx
80105517:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010551a:	8b 55 10             	mov    0x10(%ebp),%edx
8010551d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105520:	89 cb                	mov    %ecx,%ebx
80105522:	89 df                	mov    %ebx,%edi
80105524:	89 d1                	mov    %edx,%ecx
80105526:	fc                   	cld    
80105527:	f3 aa                	rep stos %al,%es:(%edi)
80105529:	89 ca                	mov    %ecx,%edx
8010552b:	89 fb                	mov    %edi,%ebx
8010552d:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105530:	89 55 10             	mov    %edx,0x10(%ebp)
80105533:	90                   	nop
80105534:	5b                   	pop    %ebx
80105535:	5f                   	pop    %edi
80105536:	5d                   	pop    %ebp
80105537:	c3                   	ret    

80105538 <stosl>:
80105538:	55                   	push   %ebp
80105539:	89 e5                	mov    %esp,%ebp
8010553b:	57                   	push   %edi
8010553c:	53                   	push   %ebx
8010553d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105540:	8b 55 10             	mov    0x10(%ebp),%edx
80105543:	8b 45 0c             	mov    0xc(%ebp),%eax
80105546:	89 cb                	mov    %ecx,%ebx
80105548:	89 df                	mov    %ebx,%edi
8010554a:	89 d1                	mov    %edx,%ecx
8010554c:	fc                   	cld    
8010554d:	f3 ab                	rep stos %eax,%es:(%edi)
8010554f:	89 ca                	mov    %ecx,%edx
80105551:	89 fb                	mov    %edi,%ebx
80105553:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105556:	89 55 10             	mov    %edx,0x10(%ebp)
80105559:	90                   	nop
8010555a:	5b                   	pop    %ebx
8010555b:	5f                   	pop    %edi
8010555c:	5d                   	pop    %ebp
8010555d:	c3                   	ret    

8010555e <memset>:
8010555e:	55                   	push   %ebp
8010555f:	89 e5                	mov    %esp,%ebp
80105561:	8b 45 08             	mov    0x8(%ebp),%eax
80105564:	83 e0 03             	and    $0x3,%eax
80105567:	85 c0                	test   %eax,%eax
80105569:	75 43                	jne    801055ae <memset+0x50>
8010556b:	8b 45 10             	mov    0x10(%ebp),%eax
8010556e:	83 e0 03             	and    $0x3,%eax
80105571:	85 c0                	test   %eax,%eax
80105573:	75 39                	jne    801055ae <memset+0x50>
80105575:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
8010557c:	8b 45 10             	mov    0x10(%ebp),%eax
8010557f:	c1 e8 02             	shr    $0x2,%eax
80105582:	89 c1                	mov    %eax,%ecx
80105584:	8b 45 0c             	mov    0xc(%ebp),%eax
80105587:	c1 e0 18             	shl    $0x18,%eax
8010558a:	89 c2                	mov    %eax,%edx
8010558c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010558f:	c1 e0 10             	shl    $0x10,%eax
80105592:	09 c2                	or     %eax,%edx
80105594:	8b 45 0c             	mov    0xc(%ebp),%eax
80105597:	c1 e0 08             	shl    $0x8,%eax
8010559a:	09 d0                	or     %edx,%eax
8010559c:	0b 45 0c             	or     0xc(%ebp),%eax
8010559f:	51                   	push   %ecx
801055a0:	50                   	push   %eax
801055a1:	ff 75 08             	pushl  0x8(%ebp)
801055a4:	e8 8f ff ff ff       	call   80105538 <stosl>
801055a9:	83 c4 0c             	add    $0xc,%esp
801055ac:	eb 12                	jmp    801055c0 <memset+0x62>
801055ae:	8b 45 10             	mov    0x10(%ebp),%eax
801055b1:	50                   	push   %eax
801055b2:	ff 75 0c             	pushl  0xc(%ebp)
801055b5:	ff 75 08             	pushl  0x8(%ebp)
801055b8:	e8 55 ff ff ff       	call   80105512 <stosb>
801055bd:	83 c4 0c             	add    $0xc,%esp
801055c0:	8b 45 08             	mov    0x8(%ebp),%eax
801055c3:	c9                   	leave  
801055c4:	c3                   	ret    

801055c5 <memcmp>:
801055c5:	55                   	push   %ebp
801055c6:	89 e5                	mov    %esp,%ebp
801055c8:	83 ec 10             	sub    $0x10,%esp
801055cb:	8b 45 08             	mov    0x8(%ebp),%eax
801055ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
801055d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801055d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
801055d7:	eb 30                	jmp    80105609 <memcmp+0x44>
801055d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055dc:	0f b6 10             	movzbl (%eax),%edx
801055df:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055e2:	0f b6 00             	movzbl (%eax),%eax
801055e5:	38 c2                	cmp    %al,%dl
801055e7:	74 18                	je     80105601 <memcmp+0x3c>
801055e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055ec:	0f b6 00             	movzbl (%eax),%eax
801055ef:	0f b6 d0             	movzbl %al,%edx
801055f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055f5:	0f b6 00             	movzbl (%eax),%eax
801055f8:	0f b6 c0             	movzbl %al,%eax
801055fb:	29 c2                	sub    %eax,%edx
801055fd:	89 d0                	mov    %edx,%eax
801055ff:	eb 1a                	jmp    8010561b <memcmp+0x56>
80105601:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105605:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105609:	8b 45 10             	mov    0x10(%ebp),%eax
8010560c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010560f:	89 55 10             	mov    %edx,0x10(%ebp)
80105612:	85 c0                	test   %eax,%eax
80105614:	75 c3                	jne    801055d9 <memcmp+0x14>
80105616:	b8 00 00 00 00       	mov    $0x0,%eax
8010561b:	c9                   	leave  
8010561c:	c3                   	ret    

8010561d <memmove>:
8010561d:	55                   	push   %ebp
8010561e:	89 e5                	mov    %esp,%ebp
80105620:	83 ec 10             	sub    $0x10,%esp
80105623:	8b 45 0c             	mov    0xc(%ebp),%eax
80105626:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105629:	8b 45 08             	mov    0x8(%ebp),%eax
8010562c:	89 45 f8             	mov    %eax,-0x8(%ebp)
8010562f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105632:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105635:	73 54                	jae    8010568b <memmove+0x6e>
80105637:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010563a:	8b 45 10             	mov    0x10(%ebp),%eax
8010563d:	01 d0                	add    %edx,%eax
8010563f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105642:	76 47                	jbe    8010568b <memmove+0x6e>
80105644:	8b 45 10             	mov    0x10(%ebp),%eax
80105647:	01 45 fc             	add    %eax,-0x4(%ebp)
8010564a:	8b 45 10             	mov    0x10(%ebp),%eax
8010564d:	01 45 f8             	add    %eax,-0x8(%ebp)
80105650:	eb 13                	jmp    80105665 <memmove+0x48>
80105652:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105656:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010565a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010565d:	0f b6 10             	movzbl (%eax),%edx
80105660:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105663:	88 10                	mov    %dl,(%eax)
80105665:	8b 45 10             	mov    0x10(%ebp),%eax
80105668:	8d 50 ff             	lea    -0x1(%eax),%edx
8010566b:	89 55 10             	mov    %edx,0x10(%ebp)
8010566e:	85 c0                	test   %eax,%eax
80105670:	75 e0                	jne    80105652 <memmove+0x35>
80105672:	eb 24                	jmp    80105698 <memmove+0x7b>
80105674:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105677:	8d 50 01             	lea    0x1(%eax),%edx
8010567a:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010567d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105680:	8d 4a 01             	lea    0x1(%edx),%ecx
80105683:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105686:	0f b6 12             	movzbl (%edx),%edx
80105689:	88 10                	mov    %dl,(%eax)
8010568b:	8b 45 10             	mov    0x10(%ebp),%eax
8010568e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105691:	89 55 10             	mov    %edx,0x10(%ebp)
80105694:	85 c0                	test   %eax,%eax
80105696:	75 dc                	jne    80105674 <memmove+0x57>
80105698:	8b 45 08             	mov    0x8(%ebp),%eax
8010569b:	c9                   	leave  
8010569c:	c3                   	ret    

8010569d <memcpy>:
8010569d:	55                   	push   %ebp
8010569e:	89 e5                	mov    %esp,%ebp
801056a0:	ff 75 10             	pushl  0x10(%ebp)
801056a3:	ff 75 0c             	pushl  0xc(%ebp)
801056a6:	ff 75 08             	pushl  0x8(%ebp)
801056a9:	e8 6f ff ff ff       	call   8010561d <memmove>
801056ae:	83 c4 0c             	add    $0xc,%esp
801056b1:	c9                   	leave  
801056b2:	c3                   	ret    

801056b3 <strncmp>:
801056b3:	55                   	push   %ebp
801056b4:	89 e5                	mov    %esp,%ebp
801056b6:	eb 0c                	jmp    801056c4 <strncmp+0x11>
801056b8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801056bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801056c0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801056c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056c8:	74 1a                	je     801056e4 <strncmp+0x31>
801056ca:	8b 45 08             	mov    0x8(%ebp),%eax
801056cd:	0f b6 00             	movzbl (%eax),%eax
801056d0:	84 c0                	test   %al,%al
801056d2:	74 10                	je     801056e4 <strncmp+0x31>
801056d4:	8b 45 08             	mov    0x8(%ebp),%eax
801056d7:	0f b6 10             	movzbl (%eax),%edx
801056da:	8b 45 0c             	mov    0xc(%ebp),%eax
801056dd:	0f b6 00             	movzbl (%eax),%eax
801056e0:	38 c2                	cmp    %al,%dl
801056e2:	74 d4                	je     801056b8 <strncmp+0x5>
801056e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056e8:	75 07                	jne    801056f1 <strncmp+0x3e>
801056ea:	b8 00 00 00 00       	mov    $0x0,%eax
801056ef:	eb 16                	jmp    80105707 <strncmp+0x54>
801056f1:	8b 45 08             	mov    0x8(%ebp),%eax
801056f4:	0f b6 00             	movzbl (%eax),%eax
801056f7:	0f b6 d0             	movzbl %al,%edx
801056fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801056fd:	0f b6 00             	movzbl (%eax),%eax
80105700:	0f b6 c0             	movzbl %al,%eax
80105703:	29 c2                	sub    %eax,%edx
80105705:	89 d0                	mov    %edx,%eax
80105707:	5d                   	pop    %ebp
80105708:	c3                   	ret    

80105709 <strncpy>:
80105709:	55                   	push   %ebp
8010570a:	89 e5                	mov    %esp,%ebp
8010570c:	83 ec 10             	sub    $0x10,%esp
8010570f:	8b 45 08             	mov    0x8(%ebp),%eax
80105712:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105715:	90                   	nop
80105716:	8b 45 10             	mov    0x10(%ebp),%eax
80105719:	8d 50 ff             	lea    -0x1(%eax),%edx
8010571c:	89 55 10             	mov    %edx,0x10(%ebp)
8010571f:	85 c0                	test   %eax,%eax
80105721:	7e 2c                	jle    8010574f <strncpy+0x46>
80105723:	8b 45 08             	mov    0x8(%ebp),%eax
80105726:	8d 50 01             	lea    0x1(%eax),%edx
80105729:	89 55 08             	mov    %edx,0x8(%ebp)
8010572c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010572f:	8d 4a 01             	lea    0x1(%edx),%ecx
80105732:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105735:	0f b6 12             	movzbl (%edx),%edx
80105738:	88 10                	mov    %dl,(%eax)
8010573a:	0f b6 00             	movzbl (%eax),%eax
8010573d:	84 c0                	test   %al,%al
8010573f:	75 d5                	jne    80105716 <strncpy+0xd>
80105741:	eb 0c                	jmp    8010574f <strncpy+0x46>
80105743:	8b 45 08             	mov    0x8(%ebp),%eax
80105746:	8d 50 01             	lea    0x1(%eax),%edx
80105749:	89 55 08             	mov    %edx,0x8(%ebp)
8010574c:	c6 00 00             	movb   $0x0,(%eax)
8010574f:	8b 45 10             	mov    0x10(%ebp),%eax
80105752:	8d 50 ff             	lea    -0x1(%eax),%edx
80105755:	89 55 10             	mov    %edx,0x10(%ebp)
80105758:	85 c0                	test   %eax,%eax
8010575a:	7f e7                	jg     80105743 <strncpy+0x3a>
8010575c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010575f:	c9                   	leave  
80105760:	c3                   	ret    

80105761 <safestrcpy>:
80105761:	55                   	push   %ebp
80105762:	89 e5                	mov    %esp,%ebp
80105764:	83 ec 10             	sub    $0x10,%esp
80105767:	8b 45 08             	mov    0x8(%ebp),%eax
8010576a:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010576d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105771:	7f 05                	jg     80105778 <safestrcpy+0x17>
80105773:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105776:	eb 31                	jmp    801057a9 <safestrcpy+0x48>
80105778:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010577c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105780:	7e 1e                	jle    801057a0 <safestrcpy+0x3f>
80105782:	8b 45 08             	mov    0x8(%ebp),%eax
80105785:	8d 50 01             	lea    0x1(%eax),%edx
80105788:	89 55 08             	mov    %edx,0x8(%ebp)
8010578b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010578e:	8d 4a 01             	lea    0x1(%edx),%ecx
80105791:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105794:	0f b6 12             	movzbl (%edx),%edx
80105797:	88 10                	mov    %dl,(%eax)
80105799:	0f b6 00             	movzbl (%eax),%eax
8010579c:	84 c0                	test   %al,%al
8010579e:	75 d8                	jne    80105778 <safestrcpy+0x17>
801057a0:	8b 45 08             	mov    0x8(%ebp),%eax
801057a3:	c6 00 00             	movb   $0x0,(%eax)
801057a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057a9:	c9                   	leave  
801057aa:	c3                   	ret    

801057ab <strlen>:
801057ab:	55                   	push   %ebp
801057ac:	89 e5                	mov    %esp,%ebp
801057ae:	83 ec 10             	sub    $0x10,%esp
801057b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801057b8:	eb 04                	jmp    801057be <strlen+0x13>
801057ba:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801057be:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057c1:	8b 45 08             	mov    0x8(%ebp),%eax
801057c4:	01 d0                	add    %edx,%eax
801057c6:	0f b6 00             	movzbl (%eax),%eax
801057c9:	84 c0                	test   %al,%al
801057cb:	75 ed                	jne    801057ba <strlen+0xf>
801057cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057d0:	c9                   	leave  
801057d1:	c3                   	ret    

801057d2 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801057d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801057d6:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801057da:	55                   	push   %ebp
  pushl %ebx
801057db:	53                   	push   %ebx
  pushl %esi
801057dc:	56                   	push   %esi
  pushl %edi
801057dd:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801057de:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801057e0:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801057e2:	5f                   	pop    %edi
  popl %esi
801057e3:	5e                   	pop    %esi
  popl %ebx
801057e4:	5b                   	pop    %ebx
  popl %ebp
801057e5:	5d                   	pop    %ebp
  ret
801057e6:	c3                   	ret    

801057e7 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801057e7:	55                   	push   %ebp
801057e8:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801057ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057f0:	8b 00                	mov    (%eax),%eax
801057f2:	3b 45 08             	cmp    0x8(%ebp),%eax
801057f5:	76 12                	jbe    80105809 <fetchint+0x22>
801057f7:	8b 45 08             	mov    0x8(%ebp),%eax
801057fa:	8d 50 04             	lea    0x4(%eax),%edx
801057fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105803:	8b 00                	mov    (%eax),%eax
80105805:	39 c2                	cmp    %eax,%edx
80105807:	76 07                	jbe    80105810 <fetchint+0x29>
    return -1;
80105809:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580e:	eb 0f                	jmp    8010581f <fetchint+0x38>
  *ip = *(int*)(addr);
80105810:	8b 45 08             	mov    0x8(%ebp),%eax
80105813:	8b 10                	mov    (%eax),%edx
80105815:	8b 45 0c             	mov    0xc(%ebp),%eax
80105818:	89 10                	mov    %edx,(%eax)
  return 0;
8010581a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010581f:	5d                   	pop    %ebp
80105820:	c3                   	ret    

80105821 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105821:	55                   	push   %ebp
80105822:	89 e5                	mov    %esp,%ebp
80105824:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105827:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010582d:	8b 00                	mov    (%eax),%eax
8010582f:	3b 45 08             	cmp    0x8(%ebp),%eax
80105832:	77 07                	ja     8010583b <fetchstr+0x1a>
    return -1;
80105834:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105839:	eb 46                	jmp    80105881 <fetchstr+0x60>
  *pp = (char*)addr;
8010583b:	8b 55 08             	mov    0x8(%ebp),%edx
8010583e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105841:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105843:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105849:	8b 00                	mov    (%eax),%eax
8010584b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010584e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105851:	8b 00                	mov    (%eax),%eax
80105853:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105856:	eb 1c                	jmp    80105874 <fetchstr+0x53>
    if(*s == 0)
80105858:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010585b:	0f b6 00             	movzbl (%eax),%eax
8010585e:	84 c0                	test   %al,%al
80105860:	75 0e                	jne    80105870 <fetchstr+0x4f>
      return s - *pp;
80105862:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105865:	8b 45 0c             	mov    0xc(%ebp),%eax
80105868:	8b 00                	mov    (%eax),%eax
8010586a:	29 c2                	sub    %eax,%edx
8010586c:	89 d0                	mov    %edx,%eax
8010586e:	eb 11                	jmp    80105881 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105870:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105874:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105877:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010587a:	72 dc                	jb     80105858 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
8010587c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105881:	c9                   	leave  
80105882:	c3                   	ret    

80105883 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105883:	55                   	push   %ebp
80105884:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105886:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010588c:	8b 40 18             	mov    0x18(%eax),%eax
8010588f:	8b 40 44             	mov    0x44(%eax),%eax
80105892:	8b 55 08             	mov    0x8(%ebp),%edx
80105895:	c1 e2 02             	shl    $0x2,%edx
80105898:	01 d0                	add    %edx,%eax
8010589a:	83 c0 04             	add    $0x4,%eax
8010589d:	ff 75 0c             	pushl  0xc(%ebp)
801058a0:	50                   	push   %eax
801058a1:	e8 41 ff ff ff       	call   801057e7 <fetchint>
801058a6:	83 c4 08             	add    $0x8,%esp
}
801058a9:	c9                   	leave  
801058aa:	c3                   	ret    

801058ab <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801058ab:	55                   	push   %ebp
801058ac:	89 e5                	mov    %esp,%ebp
801058ae:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(argint(n, &i) < 0)
801058b1:	8d 45 fc             	lea    -0x4(%ebp),%eax
801058b4:	50                   	push   %eax
801058b5:	ff 75 08             	pushl  0x8(%ebp)
801058b8:	e8 c6 ff ff ff       	call   80105883 <argint>
801058bd:	83 c4 08             	add    $0x8,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	79 07                	jns    801058cb <argptr+0x20>
    return -1;
801058c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c9:	eb 3b                	jmp    80105906 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801058cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058d1:	8b 00                	mov    (%eax),%eax
801058d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058d6:	39 d0                	cmp    %edx,%eax
801058d8:	76 16                	jbe    801058f0 <argptr+0x45>
801058da:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058dd:	89 c2                	mov    %eax,%edx
801058df:	8b 45 10             	mov    0x10(%ebp),%eax
801058e2:	01 c2                	add    %eax,%edx
801058e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058ea:	8b 00                	mov    (%eax),%eax
801058ec:	39 c2                	cmp    %eax,%edx
801058ee:	76 07                	jbe    801058f7 <argptr+0x4c>
    return -1;
801058f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f5:	eb 0f                	jmp    80105906 <argptr+0x5b>
  *pp = (char*)i;
801058f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058fa:	89 c2                	mov    %eax,%edx
801058fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ff:	89 10                	mov    %edx,(%eax)
  return 0;
80105901:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105906:	c9                   	leave  
80105907:	c3                   	ret    

80105908 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105908:	55                   	push   %ebp
80105909:	89 e5                	mov    %esp,%ebp
8010590b:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010590e:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105911:	50                   	push   %eax
80105912:	ff 75 08             	pushl  0x8(%ebp)
80105915:	e8 69 ff ff ff       	call   80105883 <argint>
8010591a:	83 c4 08             	add    $0x8,%esp
8010591d:	85 c0                	test   %eax,%eax
8010591f:	79 07                	jns    80105928 <argstr+0x20>
    return -1;
80105921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105926:	eb 0f                	jmp    80105937 <argstr+0x2f>
  return fetchstr(addr, pp);
80105928:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010592b:	ff 75 0c             	pushl  0xc(%ebp)
8010592e:	50                   	push   %eax
8010592f:	e8 ed fe ff ff       	call   80105821 <fetchstr>
80105934:	83 c4 08             	add    $0x8,%esp
}
80105937:	c9                   	leave  
80105938:	c3                   	ret    

80105939 <syscall>:
[SYS_cowfork] sys_cowfork,
};

void
syscall(void)
{
80105939:	55                   	push   %ebp
8010593a:	89 e5                	mov    %esp,%ebp
8010593c:	53                   	push   %ebx
8010593d:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105940:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105946:	8b 40 18             	mov    0x18(%eax),%eax
80105949:	8b 40 1c             	mov    0x1c(%eax),%eax
8010594c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010594f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105953:	7e 30                	jle    80105985 <syscall+0x4c>
80105955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105958:	83 f8 1a             	cmp    $0x1a,%eax
8010595b:	77 28                	ja     80105985 <syscall+0x4c>
8010595d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105960:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105967:	85 c0                	test   %eax,%eax
80105969:	74 1a                	je     80105985 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
8010596b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105971:	8b 58 18             	mov    0x18(%eax),%ebx
80105974:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105977:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010597e:	ff d0                	call   *%eax
80105980:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105983:	eb 34                	jmp    801059b9 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105985:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010598b:	8d 50 6c             	lea    0x6c(%eax),%edx
8010598e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105994:	8b 40 10             	mov    0x10(%eax),%eax
80105997:	ff 75 f4             	pushl  -0xc(%ebp)
8010599a:	52                   	push   %edx
8010599b:	50                   	push   %eax
8010599c:	68 31 92 10 80       	push   $0x80109231
801059a1:	e8 20 aa ff ff       	call   801003c6 <cprintf>
801059a6:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801059a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059af:	8b 40 18             	mov    0x18(%eax),%eax
801059b2:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801059b9:	90                   	nop
801059ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059bd:	c9                   	leave  
801059be:	c3                   	ret    

801059bf <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801059bf:	55                   	push   %ebp
801059c0:	89 e5                	mov    %esp,%ebp
801059c2:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801059c5:	83 ec 08             	sub    $0x8,%esp
801059c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059cb:	50                   	push   %eax
801059cc:	ff 75 08             	pushl  0x8(%ebp)
801059cf:	e8 af fe ff ff       	call   80105883 <argint>
801059d4:	83 c4 10             	add    $0x10,%esp
801059d7:	85 c0                	test   %eax,%eax
801059d9:	79 07                	jns    801059e2 <argfd+0x23>
    return -1;
801059db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e0:	eb 50                	jmp    80105a32 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801059e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e5:	85 c0                	test   %eax,%eax
801059e7:	78 21                	js     80105a0a <argfd+0x4b>
801059e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ec:	83 f8 0f             	cmp    $0xf,%eax
801059ef:	7f 19                	jg     80105a0a <argfd+0x4b>
801059f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801059fa:	83 c2 08             	add    $0x8,%edx
801059fd:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a08:	75 07                	jne    80105a11 <argfd+0x52>
    return -1;
80105a0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0f:	eb 21                	jmp    80105a32 <argfd+0x73>
  if(pfd)
80105a11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105a15:	74 08                	je     80105a1f <argfd+0x60>
    *pfd = fd;
80105a17:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a1d:	89 10                	mov    %edx,(%eax)
  if(pf)
80105a1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a23:	74 08                	je     80105a2d <argfd+0x6e>
    *pf = f;
80105a25:	8b 45 10             	mov    0x10(%ebp),%eax
80105a28:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a2b:	89 10                	mov    %edx,(%eax)
  return 0;
80105a2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a32:	c9                   	leave  
80105a33:	c3                   	ret    

80105a34 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105a34:	55                   	push   %ebp
80105a35:	89 e5                	mov    %esp,%ebp
80105a37:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105a3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a41:	eb 30                	jmp    80105a73 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105a43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a49:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a4c:	83 c2 08             	add    $0x8,%edx
80105a4f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a53:	85 c0                	test   %eax,%eax
80105a55:	75 18                	jne    80105a6f <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105a57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a60:	8d 4a 08             	lea    0x8(%edx),%ecx
80105a63:	8b 55 08             	mov    0x8(%ebp),%edx
80105a66:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105a6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a6d:	eb 0f                	jmp    80105a7e <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105a6f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a73:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105a77:	7e ca                	jle    80105a43 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105a79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a7e:	c9                   	leave  
80105a7f:	c3                   	ret    

80105a80 <sys_dup>:

int
sys_dup(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105a86:	83 ec 04             	sub    $0x4,%esp
80105a89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a8c:	50                   	push   %eax
80105a8d:	6a 00                	push   $0x0
80105a8f:	6a 00                	push   $0x0
80105a91:	e8 29 ff ff ff       	call   801059bf <argfd>
80105a96:	83 c4 10             	add    $0x10,%esp
80105a99:	85 c0                	test   %eax,%eax
80105a9b:	79 07                	jns    80105aa4 <sys_dup+0x24>
    return -1;
80105a9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa2:	eb 31                	jmp    80105ad5 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa7:	83 ec 0c             	sub    $0xc,%esp
80105aaa:	50                   	push   %eax
80105aab:	e8 84 ff ff ff       	call   80105a34 <fdalloc>
80105ab0:	83 c4 10             	add    $0x10,%esp
80105ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ab6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aba:	79 07                	jns    80105ac3 <sys_dup+0x43>
    return -1;
80105abc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ac1:	eb 12                	jmp    80105ad5 <sys_dup+0x55>
  filedup(f);
80105ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ac6:	83 ec 0c             	sub    $0xc,%esp
80105ac9:	50                   	push   %eax
80105aca:	e8 16 b5 ff ff       	call   80100fe5 <filedup>
80105acf:	83 c4 10             	add    $0x10,%esp
  return fd;
80105ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105ad5:	c9                   	leave  
80105ad6:	c3                   	ret    

80105ad7 <sys_read>:

int
sys_read(void)
{
80105ad7:	55                   	push   %ebp
80105ad8:	89 e5                	mov    %esp,%ebp
80105ada:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105add:	83 ec 04             	sub    $0x4,%esp
80105ae0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ae3:	50                   	push   %eax
80105ae4:	6a 00                	push   $0x0
80105ae6:	6a 00                	push   $0x0
80105ae8:	e8 d2 fe ff ff       	call   801059bf <argfd>
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	85 c0                	test   %eax,%eax
80105af2:	78 2e                	js     80105b22 <sys_read+0x4b>
80105af4:	83 ec 08             	sub    $0x8,%esp
80105af7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105afa:	50                   	push   %eax
80105afb:	6a 02                	push   $0x2
80105afd:	e8 81 fd ff ff       	call   80105883 <argint>
80105b02:	83 c4 10             	add    $0x10,%esp
80105b05:	85 c0                	test   %eax,%eax
80105b07:	78 19                	js     80105b22 <sys_read+0x4b>
80105b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b0c:	83 ec 04             	sub    $0x4,%esp
80105b0f:	50                   	push   %eax
80105b10:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b13:	50                   	push   %eax
80105b14:	6a 01                	push   $0x1
80105b16:	e8 90 fd ff ff       	call   801058ab <argptr>
80105b1b:	83 c4 10             	add    $0x10,%esp
80105b1e:	85 c0                	test   %eax,%eax
80105b20:	79 07                	jns    80105b29 <sys_read+0x52>
    return -1;
80105b22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b27:	eb 17                	jmp    80105b40 <sys_read+0x69>
  return fileread(f, p, n);
80105b29:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b32:	83 ec 04             	sub    $0x4,%esp
80105b35:	51                   	push   %ecx
80105b36:	52                   	push   %edx
80105b37:	50                   	push   %eax
80105b38:	e8 38 b6 ff ff       	call   80101175 <fileread>
80105b3d:	83 c4 10             	add    $0x10,%esp
}
80105b40:	c9                   	leave  
80105b41:	c3                   	ret    

80105b42 <sys_write>:

int
sys_write(void)
{
80105b42:	55                   	push   %ebp
80105b43:	89 e5                	mov    %esp,%ebp
80105b45:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b48:	83 ec 04             	sub    $0x4,%esp
80105b4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b4e:	50                   	push   %eax
80105b4f:	6a 00                	push   $0x0
80105b51:	6a 00                	push   $0x0
80105b53:	e8 67 fe ff ff       	call   801059bf <argfd>
80105b58:	83 c4 10             	add    $0x10,%esp
80105b5b:	85 c0                	test   %eax,%eax
80105b5d:	78 2e                	js     80105b8d <sys_write+0x4b>
80105b5f:	83 ec 08             	sub    $0x8,%esp
80105b62:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b65:	50                   	push   %eax
80105b66:	6a 02                	push   $0x2
80105b68:	e8 16 fd ff ff       	call   80105883 <argint>
80105b6d:	83 c4 10             	add    $0x10,%esp
80105b70:	85 c0                	test   %eax,%eax
80105b72:	78 19                	js     80105b8d <sys_write+0x4b>
80105b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b77:	83 ec 04             	sub    $0x4,%esp
80105b7a:	50                   	push   %eax
80105b7b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b7e:	50                   	push   %eax
80105b7f:	6a 01                	push   $0x1
80105b81:	e8 25 fd ff ff       	call   801058ab <argptr>
80105b86:	83 c4 10             	add    $0x10,%esp
80105b89:	85 c0                	test   %eax,%eax
80105b8b:	79 07                	jns    80105b94 <sys_write+0x52>
    return -1;
80105b8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b92:	eb 17                	jmp    80105bab <sys_write+0x69>
  return filewrite(f, p, n);
80105b94:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b97:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b9d:	83 ec 04             	sub    $0x4,%esp
80105ba0:	51                   	push   %ecx
80105ba1:	52                   	push   %edx
80105ba2:	50                   	push   %eax
80105ba3:	e8 85 b6 ff ff       	call   8010122d <filewrite>
80105ba8:	83 c4 10             	add    $0x10,%esp
}
80105bab:	c9                   	leave  
80105bac:	c3                   	ret    

80105bad <sys_close>:

int
sys_close(void)
{
80105bad:	55                   	push   %ebp
80105bae:	89 e5                	mov    %esp,%ebp
80105bb0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105bb3:	83 ec 04             	sub    $0x4,%esp
80105bb6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bb9:	50                   	push   %eax
80105bba:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bbd:	50                   	push   %eax
80105bbe:	6a 00                	push   $0x0
80105bc0:	e8 fa fd ff ff       	call   801059bf <argfd>
80105bc5:	83 c4 10             	add    $0x10,%esp
80105bc8:	85 c0                	test   %eax,%eax
80105bca:	79 07                	jns    80105bd3 <sys_close+0x26>
    return -1;
80105bcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd1:	eb 28                	jmp    80105bfb <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105bd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bdc:	83 c2 08             	add    $0x8,%edx
80105bdf:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105be6:	00 
  fileclose(f);
80105be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bea:	83 ec 0c             	sub    $0xc,%esp
80105bed:	50                   	push   %eax
80105bee:	e8 43 b4 ff ff       	call   80101036 <fileclose>
80105bf3:	83 c4 10             	add    $0x10,%esp
  return 0;
80105bf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bfb:	c9                   	leave  
80105bfc:	c3                   	ret    

80105bfd <sys_fstat>:

int
sys_fstat(void)
{
80105bfd:	55                   	push   %ebp
80105bfe:	89 e5                	mov    %esp,%ebp
80105c00:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105c03:	83 ec 04             	sub    $0x4,%esp
80105c06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c09:	50                   	push   %eax
80105c0a:	6a 00                	push   $0x0
80105c0c:	6a 00                	push   $0x0
80105c0e:	e8 ac fd ff ff       	call   801059bf <argfd>
80105c13:	83 c4 10             	add    $0x10,%esp
80105c16:	85 c0                	test   %eax,%eax
80105c18:	78 17                	js     80105c31 <sys_fstat+0x34>
80105c1a:	83 ec 04             	sub    $0x4,%esp
80105c1d:	6a 14                	push   $0x14
80105c1f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c22:	50                   	push   %eax
80105c23:	6a 01                	push   $0x1
80105c25:	e8 81 fc ff ff       	call   801058ab <argptr>
80105c2a:	83 c4 10             	add    $0x10,%esp
80105c2d:	85 c0                	test   %eax,%eax
80105c2f:	79 07                	jns    80105c38 <sys_fstat+0x3b>
    return -1;
80105c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c36:	eb 13                	jmp    80105c4b <sys_fstat+0x4e>
  return filestat(f, st);
80105c38:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3e:	83 ec 08             	sub    $0x8,%esp
80105c41:	52                   	push   %edx
80105c42:	50                   	push   %eax
80105c43:	e8 d6 b4 ff ff       	call   8010111e <filestat>
80105c48:	83 c4 10             	add    $0x10,%esp
}
80105c4b:	c9                   	leave  
80105c4c:	c3                   	ret    

80105c4d <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105c4d:	55                   	push   %ebp
80105c4e:	89 e5                	mov    %esp,%ebp
80105c50:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105c53:	83 ec 08             	sub    $0x8,%esp
80105c56:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c59:	50                   	push   %eax
80105c5a:	6a 00                	push   $0x0
80105c5c:	e8 a7 fc ff ff       	call   80105908 <argstr>
80105c61:	83 c4 10             	add    $0x10,%esp
80105c64:	85 c0                	test   %eax,%eax
80105c66:	78 15                	js     80105c7d <sys_link+0x30>
80105c68:	83 ec 08             	sub    $0x8,%esp
80105c6b:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105c6e:	50                   	push   %eax
80105c6f:	6a 01                	push   $0x1
80105c71:	e8 92 fc ff ff       	call   80105908 <argstr>
80105c76:	83 c4 10             	add    $0x10,%esp
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	79 0a                	jns    80105c87 <sys_link+0x3a>
    return -1;
80105c7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c82:	e9 68 01 00 00       	jmp    80105def <sys_link+0x1a2>

  begin_op();
80105c87:	e8 28 d8 ff ff       	call   801034b4 <begin_op>
  if((ip = namei(old)) == 0){
80105c8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105c8f:	83 ec 0c             	sub    $0xc,%esp
80105c92:	50                   	push   %eax
80105c93:	e8 2b c8 ff ff       	call   801024c3 <namei>
80105c98:	83 c4 10             	add    $0x10,%esp
80105c9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ca2:	75 0f                	jne    80105cb3 <sys_link+0x66>
    end_op();
80105ca4:	e8 97 d8 ff ff       	call   80103540 <end_op>
    return -1;
80105ca9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cae:	e9 3c 01 00 00       	jmp    80105def <sys_link+0x1a2>
  }

  ilock(ip);
80105cb3:	83 ec 0c             	sub    $0xc,%esp
80105cb6:	ff 75 f4             	pushl  -0xc(%ebp)
80105cb9:	e8 4d bc ff ff       	call   8010190b <ilock>
80105cbe:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105cc8:	66 83 f8 01          	cmp    $0x1,%ax
80105ccc:	75 1d                	jne    80105ceb <sys_link+0x9e>
    iunlockput(ip);
80105cce:	83 ec 0c             	sub    $0xc,%esp
80105cd1:	ff 75 f4             	pushl  -0xc(%ebp)
80105cd4:	e8 ec be ff ff       	call   80101bc5 <iunlockput>
80105cd9:	83 c4 10             	add    $0x10,%esp
    end_op();
80105cdc:	e8 5f d8 ff ff       	call   80103540 <end_op>
    return -1;
80105ce1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce6:	e9 04 01 00 00       	jmp    80105def <sys_link+0x1a2>
  }

  ip->nlink++;
80105ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cee:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105cf2:	83 c0 01             	add    $0x1,%eax
80105cf5:	89 c2                	mov    %eax,%edx
80105cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfa:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105cfe:	83 ec 0c             	sub    $0xc,%esp
80105d01:	ff 75 f4             	pushl  -0xc(%ebp)
80105d04:	e8 2e ba ff ff       	call   80101737 <iupdate>
80105d09:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105d0c:	83 ec 0c             	sub    $0xc,%esp
80105d0f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d12:	e8 4c bd ff ff       	call   80101a63 <iunlock>
80105d17:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105d1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d1d:	83 ec 08             	sub    $0x8,%esp
80105d20:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105d23:	52                   	push   %edx
80105d24:	50                   	push   %eax
80105d25:	e8 b5 c7 ff ff       	call   801024df <nameiparent>
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d34:	74 71                	je     80105da7 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105d36:	83 ec 0c             	sub    $0xc,%esp
80105d39:	ff 75 f0             	pushl  -0x10(%ebp)
80105d3c:	e8 ca bb ff ff       	call   8010190b <ilock>
80105d41:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d47:	8b 10                	mov    (%eax),%edx
80105d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d4c:	8b 00                	mov    (%eax),%eax
80105d4e:	39 c2                	cmp    %eax,%edx
80105d50:	75 1d                	jne    80105d6f <sys_link+0x122>
80105d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d55:	8b 40 04             	mov    0x4(%eax),%eax
80105d58:	83 ec 04             	sub    $0x4,%esp
80105d5b:	50                   	push   %eax
80105d5c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105d5f:	50                   	push   %eax
80105d60:	ff 75 f0             	pushl  -0x10(%ebp)
80105d63:	e8 bf c4 ff ff       	call   80102227 <dirlink>
80105d68:	83 c4 10             	add    $0x10,%esp
80105d6b:	85 c0                	test   %eax,%eax
80105d6d:	79 10                	jns    80105d7f <sys_link+0x132>
    iunlockput(dp);
80105d6f:	83 ec 0c             	sub    $0xc,%esp
80105d72:	ff 75 f0             	pushl  -0x10(%ebp)
80105d75:	e8 4b be ff ff       	call   80101bc5 <iunlockput>
80105d7a:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105d7d:	eb 29                	jmp    80105da8 <sys_link+0x15b>
  }
  iunlockput(dp);
80105d7f:	83 ec 0c             	sub    $0xc,%esp
80105d82:	ff 75 f0             	pushl  -0x10(%ebp)
80105d85:	e8 3b be ff ff       	call   80101bc5 <iunlockput>
80105d8a:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105d8d:	83 ec 0c             	sub    $0xc,%esp
80105d90:	ff 75 f4             	pushl  -0xc(%ebp)
80105d93:	e8 3d bd ff ff       	call   80101ad5 <iput>
80105d98:	83 c4 10             	add    $0x10,%esp

  end_op();
80105d9b:	e8 a0 d7 ff ff       	call   80103540 <end_op>

  return 0;
80105da0:	b8 00 00 00 00       	mov    $0x0,%eax
80105da5:	eb 48                	jmp    80105def <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105da7:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105da8:	83 ec 0c             	sub    $0xc,%esp
80105dab:	ff 75 f4             	pushl  -0xc(%ebp)
80105dae:	e8 58 bb ff ff       	call   8010190b <ilock>
80105db3:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105dbd:	83 e8 01             	sub    $0x1,%eax
80105dc0:	89 c2                	mov    %eax,%edx
80105dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc5:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105dc9:	83 ec 0c             	sub    $0xc,%esp
80105dcc:	ff 75 f4             	pushl  -0xc(%ebp)
80105dcf:	e8 63 b9 ff ff       	call   80101737 <iupdate>
80105dd4:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105dd7:	83 ec 0c             	sub    $0xc,%esp
80105dda:	ff 75 f4             	pushl  -0xc(%ebp)
80105ddd:	e8 e3 bd ff ff       	call   80101bc5 <iunlockput>
80105de2:	83 c4 10             	add    $0x10,%esp
  end_op();
80105de5:	e8 56 d7 ff ff       	call   80103540 <end_op>
  return -1;
80105dea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105def:	c9                   	leave  
80105df0:	c3                   	ret    

80105df1 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105df1:	55                   	push   %ebp
80105df2:	89 e5                	mov    %esp,%ebp
80105df4:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105df7:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105dfe:	eb 40                	jmp    80105e40 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e03:	6a 10                	push   $0x10
80105e05:	50                   	push   %eax
80105e06:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e09:	50                   	push   %eax
80105e0a:	ff 75 08             	pushl  0x8(%ebp)
80105e0d:	e8 61 c0 ff ff       	call   80101e73 <readi>
80105e12:	83 c4 10             	add    $0x10,%esp
80105e15:	83 f8 10             	cmp    $0x10,%eax
80105e18:	74 0d                	je     80105e27 <isdirempty+0x36>
      panic("isdirempty: readi");
80105e1a:	83 ec 0c             	sub    $0xc,%esp
80105e1d:	68 4d 92 10 80       	push   $0x8010924d
80105e22:	e8 3f a7 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80105e27:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105e2b:	66 85 c0             	test   %ax,%ax
80105e2e:	74 07                	je     80105e37 <isdirempty+0x46>
      return 0;
80105e30:	b8 00 00 00 00       	mov    $0x0,%eax
80105e35:	eb 1b                	jmp    80105e52 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e3a:	83 c0 10             	add    $0x10,%eax
80105e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e40:	8b 45 08             	mov    0x8(%ebp),%eax
80105e43:	8b 50 18             	mov    0x18(%eax),%edx
80105e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e49:	39 c2                	cmp    %eax,%edx
80105e4b:	77 b3                	ja     80105e00 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105e4d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105e52:	c9                   	leave  
80105e53:	c3                   	ret    

80105e54 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105e54:	55                   	push   %ebp
80105e55:	89 e5                	mov    %esp,%ebp
80105e57:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105e5a:	83 ec 08             	sub    $0x8,%esp
80105e5d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105e60:	50                   	push   %eax
80105e61:	6a 00                	push   $0x0
80105e63:	e8 a0 fa ff ff       	call   80105908 <argstr>
80105e68:	83 c4 10             	add    $0x10,%esp
80105e6b:	85 c0                	test   %eax,%eax
80105e6d:	79 0a                	jns    80105e79 <sys_unlink+0x25>
    return -1;
80105e6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e74:	e9 bc 01 00 00       	jmp    80106035 <sys_unlink+0x1e1>

  begin_op();
80105e79:	e8 36 d6 ff ff       	call   801034b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105e7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105e81:	83 ec 08             	sub    $0x8,%esp
80105e84:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105e87:	52                   	push   %edx
80105e88:	50                   	push   %eax
80105e89:	e8 51 c6 ff ff       	call   801024df <nameiparent>
80105e8e:	83 c4 10             	add    $0x10,%esp
80105e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e98:	75 0f                	jne    80105ea9 <sys_unlink+0x55>
    end_op();
80105e9a:	e8 a1 d6 ff ff       	call   80103540 <end_op>
    return -1;
80105e9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea4:	e9 8c 01 00 00       	jmp    80106035 <sys_unlink+0x1e1>
  }

  ilock(dp);
80105ea9:	83 ec 0c             	sub    $0xc,%esp
80105eac:	ff 75 f4             	pushl  -0xc(%ebp)
80105eaf:	e8 57 ba ff ff       	call   8010190b <ilock>
80105eb4:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105eb7:	83 ec 08             	sub    $0x8,%esp
80105eba:	68 5f 92 10 80       	push   $0x8010925f
80105ebf:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ec2:	50                   	push   %eax
80105ec3:	e8 8a c2 ff ff       	call   80102152 <namecmp>
80105ec8:	83 c4 10             	add    $0x10,%esp
80105ecb:	85 c0                	test   %eax,%eax
80105ecd:	0f 84 4a 01 00 00    	je     8010601d <sys_unlink+0x1c9>
80105ed3:	83 ec 08             	sub    $0x8,%esp
80105ed6:	68 61 92 10 80       	push   $0x80109261
80105edb:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ede:	50                   	push   %eax
80105edf:	e8 6e c2 ff ff       	call   80102152 <namecmp>
80105ee4:	83 c4 10             	add    $0x10,%esp
80105ee7:	85 c0                	test   %eax,%eax
80105ee9:	0f 84 2e 01 00 00    	je     8010601d <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105eef:	83 ec 04             	sub    $0x4,%esp
80105ef2:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105ef5:	50                   	push   %eax
80105ef6:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ef9:	50                   	push   %eax
80105efa:	ff 75 f4             	pushl  -0xc(%ebp)
80105efd:	e8 6b c2 ff ff       	call   8010216d <dirlookup>
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f0c:	0f 84 0a 01 00 00    	je     8010601c <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80105f12:	83 ec 0c             	sub    $0xc,%esp
80105f15:	ff 75 f0             	pushl  -0x10(%ebp)
80105f18:	e8 ee b9 ff ff       	call   8010190b <ilock>
80105f1d:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f23:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f27:	66 85 c0             	test   %ax,%ax
80105f2a:	7f 0d                	jg     80105f39 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105f2c:	83 ec 0c             	sub    $0xc,%esp
80105f2f:	68 64 92 10 80       	push   $0x80109264
80105f34:	e8 2d a6 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f3c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f40:	66 83 f8 01          	cmp    $0x1,%ax
80105f44:	75 25                	jne    80105f6b <sys_unlink+0x117>
80105f46:	83 ec 0c             	sub    $0xc,%esp
80105f49:	ff 75 f0             	pushl  -0x10(%ebp)
80105f4c:	e8 a0 fe ff ff       	call   80105df1 <isdirempty>
80105f51:	83 c4 10             	add    $0x10,%esp
80105f54:	85 c0                	test   %eax,%eax
80105f56:	75 13                	jne    80105f6b <sys_unlink+0x117>
    iunlockput(ip);
80105f58:	83 ec 0c             	sub    $0xc,%esp
80105f5b:	ff 75 f0             	pushl  -0x10(%ebp)
80105f5e:	e8 62 bc ff ff       	call   80101bc5 <iunlockput>
80105f63:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105f66:	e9 b2 00 00 00       	jmp    8010601d <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105f6b:	83 ec 04             	sub    $0x4,%esp
80105f6e:	6a 10                	push   $0x10
80105f70:	6a 00                	push   $0x0
80105f72:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f75:	50                   	push   %eax
80105f76:	e8 e3 f5 ff ff       	call   8010555e <memset>
80105f7b:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f7e:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105f81:	6a 10                	push   $0x10
80105f83:	50                   	push   %eax
80105f84:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f87:	50                   	push   %eax
80105f88:	ff 75 f4             	pushl  -0xc(%ebp)
80105f8b:	e8 3a c0 ff ff       	call   80101fca <writei>
80105f90:	83 c4 10             	add    $0x10,%esp
80105f93:	83 f8 10             	cmp    $0x10,%eax
80105f96:	74 0d                	je     80105fa5 <sys_unlink+0x151>
    panic("unlink: writei");
80105f98:	83 ec 0c             	sub    $0xc,%esp
80105f9b:	68 76 92 10 80       	push   $0x80109276
80105fa0:	e8 c1 a5 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80105fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105fac:	66 83 f8 01          	cmp    $0x1,%ax
80105fb0:	75 21                	jne    80105fd3 <sys_unlink+0x17f>
    dp->nlink--;
80105fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb5:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105fb9:	83 e8 01             	sub    $0x1,%eax
80105fbc:	89 c2                	mov    %eax,%edx
80105fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc1:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105fc5:	83 ec 0c             	sub    $0xc,%esp
80105fc8:	ff 75 f4             	pushl  -0xc(%ebp)
80105fcb:	e8 67 b7 ff ff       	call   80101737 <iupdate>
80105fd0:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105fd3:	83 ec 0c             	sub    $0xc,%esp
80105fd6:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd9:	e8 e7 bb ff ff       	call   80101bc5 <iunlockput>
80105fde:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105fe8:	83 e8 01             	sub    $0x1,%eax
80105feb:	89 c2                	mov    %eax,%edx
80105fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff0:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ff4:	83 ec 0c             	sub    $0xc,%esp
80105ff7:	ff 75 f0             	pushl  -0x10(%ebp)
80105ffa:	e8 38 b7 ff ff       	call   80101737 <iupdate>
80105fff:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106002:	83 ec 0c             	sub    $0xc,%esp
80106005:	ff 75 f0             	pushl  -0x10(%ebp)
80106008:	e8 b8 bb ff ff       	call   80101bc5 <iunlockput>
8010600d:	83 c4 10             	add    $0x10,%esp

  end_op();
80106010:	e8 2b d5 ff ff       	call   80103540 <end_op>

  return 0;
80106015:	b8 00 00 00 00       	mov    $0x0,%eax
8010601a:	eb 19                	jmp    80106035 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
8010601c:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
8010601d:	83 ec 0c             	sub    $0xc,%esp
80106020:	ff 75 f4             	pushl  -0xc(%ebp)
80106023:	e8 9d bb ff ff       	call   80101bc5 <iunlockput>
80106028:	83 c4 10             	add    $0x10,%esp
  end_op();
8010602b:	e8 10 d5 ff ff       	call   80103540 <end_op>
  return -1;
80106030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106035:	c9                   	leave  
80106036:	c3                   	ret    

80106037 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106037:	55                   	push   %ebp
80106038:	89 e5                	mov    %esp,%ebp
8010603a:	83 ec 38             	sub    $0x38,%esp
8010603d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106040:	8b 55 10             	mov    0x10(%ebp),%edx
80106043:	8b 45 14             	mov    0x14(%ebp),%eax
80106046:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010604a:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010604e:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106052:	83 ec 08             	sub    $0x8,%esp
80106055:	8d 45 de             	lea    -0x22(%ebp),%eax
80106058:	50                   	push   %eax
80106059:	ff 75 08             	pushl  0x8(%ebp)
8010605c:	e8 7e c4 ff ff       	call   801024df <nameiparent>
80106061:	83 c4 10             	add    $0x10,%esp
80106064:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106067:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010606b:	75 0a                	jne    80106077 <create+0x40>
    return 0;
8010606d:	b8 00 00 00 00       	mov    $0x0,%eax
80106072:	e9 90 01 00 00       	jmp    80106207 <create+0x1d0>
  ilock(dp);
80106077:	83 ec 0c             	sub    $0xc,%esp
8010607a:	ff 75 f4             	pushl  -0xc(%ebp)
8010607d:	e8 89 b8 ff ff       	call   8010190b <ilock>
80106082:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80106085:	83 ec 04             	sub    $0x4,%esp
80106088:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010608b:	50                   	push   %eax
8010608c:	8d 45 de             	lea    -0x22(%ebp),%eax
8010608f:	50                   	push   %eax
80106090:	ff 75 f4             	pushl  -0xc(%ebp)
80106093:	e8 d5 c0 ff ff       	call   8010216d <dirlookup>
80106098:	83 c4 10             	add    $0x10,%esp
8010609b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010609e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060a2:	74 50                	je     801060f4 <create+0xbd>
    iunlockput(dp);
801060a4:	83 ec 0c             	sub    $0xc,%esp
801060a7:	ff 75 f4             	pushl  -0xc(%ebp)
801060aa:	e8 16 bb ff ff       	call   80101bc5 <iunlockput>
801060af:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801060b2:	83 ec 0c             	sub    $0xc,%esp
801060b5:	ff 75 f0             	pushl  -0x10(%ebp)
801060b8:	e8 4e b8 ff ff       	call   8010190b <ilock>
801060bd:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801060c0:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801060c5:	75 15                	jne    801060dc <create+0xa5>
801060c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ca:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801060ce:	66 83 f8 02          	cmp    $0x2,%ax
801060d2:	75 08                	jne    801060dc <create+0xa5>
      return ip;
801060d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060d7:	e9 2b 01 00 00       	jmp    80106207 <create+0x1d0>
    iunlockput(ip);
801060dc:	83 ec 0c             	sub    $0xc,%esp
801060df:	ff 75 f0             	pushl  -0x10(%ebp)
801060e2:	e8 de ba ff ff       	call   80101bc5 <iunlockput>
801060e7:	83 c4 10             	add    $0x10,%esp
    return 0;
801060ea:	b8 00 00 00 00       	mov    $0x0,%eax
801060ef:	e9 13 01 00 00       	jmp    80106207 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801060f4:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801060f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060fb:	8b 00                	mov    (%eax),%eax
801060fd:	83 ec 08             	sub    $0x8,%esp
80106100:	52                   	push   %edx
80106101:	50                   	push   %eax
80106102:	e8 4f b5 ff ff       	call   80101656 <ialloc>
80106107:	83 c4 10             	add    $0x10,%esp
8010610a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010610d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106111:	75 0d                	jne    80106120 <create+0xe9>
    panic("create: ialloc");
80106113:	83 ec 0c             	sub    $0xc,%esp
80106116:	68 85 92 10 80       	push   $0x80109285
8010611b:	e8 46 a4 ff ff       	call   80100566 <panic>

  ilock(ip);
80106120:	83 ec 0c             	sub    $0xc,%esp
80106123:	ff 75 f0             	pushl  -0x10(%ebp)
80106126:	e8 e0 b7 ff ff       	call   8010190b <ilock>
8010612b:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
8010612e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106131:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106135:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106139:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010613c:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106140:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106144:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106147:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010614d:	83 ec 0c             	sub    $0xc,%esp
80106150:	ff 75 f0             	pushl  -0x10(%ebp)
80106153:	e8 df b5 ff ff       	call   80101737 <iupdate>
80106158:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010615b:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106160:	75 6a                	jne    801061cc <create+0x195>
    dp->nlink++;  // for ".."
80106162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106165:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106169:	83 c0 01             	add    $0x1,%eax
8010616c:	89 c2                	mov    %eax,%edx
8010616e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106171:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106175:	83 ec 0c             	sub    $0xc,%esp
80106178:	ff 75 f4             	pushl  -0xc(%ebp)
8010617b:	e8 b7 b5 ff ff       	call   80101737 <iupdate>
80106180:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106183:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106186:	8b 40 04             	mov    0x4(%eax),%eax
80106189:	83 ec 04             	sub    $0x4,%esp
8010618c:	50                   	push   %eax
8010618d:	68 5f 92 10 80       	push   $0x8010925f
80106192:	ff 75 f0             	pushl  -0x10(%ebp)
80106195:	e8 8d c0 ff ff       	call   80102227 <dirlink>
8010619a:	83 c4 10             	add    $0x10,%esp
8010619d:	85 c0                	test   %eax,%eax
8010619f:	78 1e                	js     801061bf <create+0x188>
801061a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a4:	8b 40 04             	mov    0x4(%eax),%eax
801061a7:	83 ec 04             	sub    $0x4,%esp
801061aa:	50                   	push   %eax
801061ab:	68 61 92 10 80       	push   $0x80109261
801061b0:	ff 75 f0             	pushl  -0x10(%ebp)
801061b3:	e8 6f c0 ff ff       	call   80102227 <dirlink>
801061b8:	83 c4 10             	add    $0x10,%esp
801061bb:	85 c0                	test   %eax,%eax
801061bd:	79 0d                	jns    801061cc <create+0x195>
      panic("create dots");
801061bf:	83 ec 0c             	sub    $0xc,%esp
801061c2:	68 94 92 10 80       	push   $0x80109294
801061c7:	e8 9a a3 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801061cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061cf:	8b 40 04             	mov    0x4(%eax),%eax
801061d2:	83 ec 04             	sub    $0x4,%esp
801061d5:	50                   	push   %eax
801061d6:	8d 45 de             	lea    -0x22(%ebp),%eax
801061d9:	50                   	push   %eax
801061da:	ff 75 f4             	pushl  -0xc(%ebp)
801061dd:	e8 45 c0 ff ff       	call   80102227 <dirlink>
801061e2:	83 c4 10             	add    $0x10,%esp
801061e5:	85 c0                	test   %eax,%eax
801061e7:	79 0d                	jns    801061f6 <create+0x1bf>
    panic("create: dirlink");
801061e9:	83 ec 0c             	sub    $0xc,%esp
801061ec:	68 a0 92 10 80       	push   $0x801092a0
801061f1:	e8 70 a3 ff ff       	call   80100566 <panic>

  iunlockput(dp);
801061f6:	83 ec 0c             	sub    $0xc,%esp
801061f9:	ff 75 f4             	pushl  -0xc(%ebp)
801061fc:	e8 c4 b9 ff ff       	call   80101bc5 <iunlockput>
80106201:	83 c4 10             	add    $0x10,%esp

  return ip;
80106204:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106207:	c9                   	leave  
80106208:	c3                   	ret    

80106209 <sys_open>:

int
sys_open(void)
{
80106209:	55                   	push   %ebp
8010620a:	89 e5                	mov    %esp,%ebp
8010620c:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010620f:	83 ec 08             	sub    $0x8,%esp
80106212:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106215:	50                   	push   %eax
80106216:	6a 00                	push   $0x0
80106218:	e8 eb f6 ff ff       	call   80105908 <argstr>
8010621d:	83 c4 10             	add    $0x10,%esp
80106220:	85 c0                	test   %eax,%eax
80106222:	78 15                	js     80106239 <sys_open+0x30>
80106224:	83 ec 08             	sub    $0x8,%esp
80106227:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010622a:	50                   	push   %eax
8010622b:	6a 01                	push   $0x1
8010622d:	e8 51 f6 ff ff       	call   80105883 <argint>
80106232:	83 c4 10             	add    $0x10,%esp
80106235:	85 c0                	test   %eax,%eax
80106237:	79 0a                	jns    80106243 <sys_open+0x3a>
    return -1;
80106239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623e:	e9 61 01 00 00       	jmp    801063a4 <sys_open+0x19b>

  begin_op();
80106243:	e8 6c d2 ff ff       	call   801034b4 <begin_op>

  if(omode & O_CREATE){
80106248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010624b:	25 00 02 00 00       	and    $0x200,%eax
80106250:	85 c0                	test   %eax,%eax
80106252:	74 2a                	je     8010627e <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106254:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106257:	6a 00                	push   $0x0
80106259:	6a 00                	push   $0x0
8010625b:	6a 02                	push   $0x2
8010625d:	50                   	push   %eax
8010625e:	e8 d4 fd ff ff       	call   80106037 <create>
80106263:	83 c4 10             	add    $0x10,%esp
80106266:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106269:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010626d:	75 75                	jne    801062e4 <sys_open+0xdb>
      end_op();
8010626f:	e8 cc d2 ff ff       	call   80103540 <end_op>
      return -1;
80106274:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106279:	e9 26 01 00 00       	jmp    801063a4 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
8010627e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106281:	83 ec 0c             	sub    $0xc,%esp
80106284:	50                   	push   %eax
80106285:	e8 39 c2 ff ff       	call   801024c3 <namei>
8010628a:	83 c4 10             	add    $0x10,%esp
8010628d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106294:	75 0f                	jne    801062a5 <sys_open+0x9c>
      end_op();
80106296:	e8 a5 d2 ff ff       	call   80103540 <end_op>
      return -1;
8010629b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062a0:	e9 ff 00 00 00       	jmp    801063a4 <sys_open+0x19b>
    }
    ilock(ip);
801062a5:	83 ec 0c             	sub    $0xc,%esp
801062a8:	ff 75 f4             	pushl  -0xc(%ebp)
801062ab:	e8 5b b6 ff ff       	call   8010190b <ilock>
801062b0:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801062b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062ba:	66 83 f8 01          	cmp    $0x1,%ax
801062be:	75 24                	jne    801062e4 <sys_open+0xdb>
801062c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062c3:	85 c0                	test   %eax,%eax
801062c5:	74 1d                	je     801062e4 <sys_open+0xdb>
      iunlockput(ip);
801062c7:	83 ec 0c             	sub    $0xc,%esp
801062ca:	ff 75 f4             	pushl  -0xc(%ebp)
801062cd:	e8 f3 b8 ff ff       	call   80101bc5 <iunlockput>
801062d2:	83 c4 10             	add    $0x10,%esp
      end_op();
801062d5:	e8 66 d2 ff ff       	call   80103540 <end_op>
      return -1;
801062da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062df:	e9 c0 00 00 00       	jmp    801063a4 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801062e4:	e8 8f ac ff ff       	call   80100f78 <filealloc>
801062e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062f0:	74 17                	je     80106309 <sys_open+0x100>
801062f2:	83 ec 0c             	sub    $0xc,%esp
801062f5:	ff 75 f0             	pushl  -0x10(%ebp)
801062f8:	e8 37 f7 ff ff       	call   80105a34 <fdalloc>
801062fd:	83 c4 10             	add    $0x10,%esp
80106300:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106303:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106307:	79 2e                	jns    80106337 <sys_open+0x12e>
    if(f)
80106309:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010630d:	74 0e                	je     8010631d <sys_open+0x114>
      fileclose(f);
8010630f:	83 ec 0c             	sub    $0xc,%esp
80106312:	ff 75 f0             	pushl  -0x10(%ebp)
80106315:	e8 1c ad ff ff       	call   80101036 <fileclose>
8010631a:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010631d:	83 ec 0c             	sub    $0xc,%esp
80106320:	ff 75 f4             	pushl  -0xc(%ebp)
80106323:	e8 9d b8 ff ff       	call   80101bc5 <iunlockput>
80106328:	83 c4 10             	add    $0x10,%esp
    end_op();
8010632b:	e8 10 d2 ff ff       	call   80103540 <end_op>
    return -1;
80106330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106335:	eb 6d                	jmp    801063a4 <sys_open+0x19b>
  }
  iunlock(ip);
80106337:	83 ec 0c             	sub    $0xc,%esp
8010633a:	ff 75 f4             	pushl  -0xc(%ebp)
8010633d:	e8 21 b7 ff ff       	call   80101a63 <iunlock>
80106342:	83 c4 10             	add    $0x10,%esp
  end_op();
80106345:	e8 f6 d1 ff ff       	call   80103540 <end_op>

  f->type = FD_INODE;
8010634a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010634d:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106353:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106356:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106359:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010635c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010635f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106366:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106369:	83 e0 01             	and    $0x1,%eax
8010636c:	85 c0                	test   %eax,%eax
8010636e:	0f 94 c0             	sete   %al
80106371:	89 c2                	mov    %eax,%edx
80106373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106376:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106379:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010637c:	83 e0 01             	and    $0x1,%eax
8010637f:	85 c0                	test   %eax,%eax
80106381:	75 0a                	jne    8010638d <sys_open+0x184>
80106383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106386:	83 e0 02             	and    $0x2,%eax
80106389:	85 c0                	test   %eax,%eax
8010638b:	74 07                	je     80106394 <sys_open+0x18b>
8010638d:	b8 01 00 00 00       	mov    $0x1,%eax
80106392:	eb 05                	jmp    80106399 <sys_open+0x190>
80106394:	b8 00 00 00 00       	mov    $0x0,%eax
80106399:	89 c2                	mov    %eax,%edx
8010639b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010639e:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801063a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801063a4:	c9                   	leave  
801063a5:	c3                   	ret    

801063a6 <sys_mkdir>:

int
sys_mkdir(void)
{
801063a6:	55                   	push   %ebp
801063a7:	89 e5                	mov    %esp,%ebp
801063a9:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801063ac:	e8 03 d1 ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801063b1:	83 ec 08             	sub    $0x8,%esp
801063b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063b7:	50                   	push   %eax
801063b8:	6a 00                	push   $0x0
801063ba:	e8 49 f5 ff ff       	call   80105908 <argstr>
801063bf:	83 c4 10             	add    $0x10,%esp
801063c2:	85 c0                	test   %eax,%eax
801063c4:	78 1b                	js     801063e1 <sys_mkdir+0x3b>
801063c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063c9:	6a 00                	push   $0x0
801063cb:	6a 00                	push   $0x0
801063cd:	6a 01                	push   $0x1
801063cf:	50                   	push   %eax
801063d0:	e8 62 fc ff ff       	call   80106037 <create>
801063d5:	83 c4 10             	add    $0x10,%esp
801063d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063df:	75 0c                	jne    801063ed <sys_mkdir+0x47>
    end_op();
801063e1:	e8 5a d1 ff ff       	call   80103540 <end_op>
    return -1;
801063e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063eb:	eb 18                	jmp    80106405 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801063ed:	83 ec 0c             	sub    $0xc,%esp
801063f0:	ff 75 f4             	pushl  -0xc(%ebp)
801063f3:	e8 cd b7 ff ff       	call   80101bc5 <iunlockput>
801063f8:	83 c4 10             	add    $0x10,%esp
  end_op();
801063fb:	e8 40 d1 ff ff       	call   80103540 <end_op>
  return 0;
80106400:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106405:	c9                   	leave  
80106406:	c3                   	ret    

80106407 <sys_mknod>:

int
sys_mknod(void)
{
80106407:	55                   	push   %ebp
80106408:	89 e5                	mov    %esp,%ebp
8010640a:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010640d:	e8 a2 d0 ff ff       	call   801034b4 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106412:	83 ec 08             	sub    $0x8,%esp
80106415:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106418:	50                   	push   %eax
80106419:	6a 00                	push   $0x0
8010641b:	e8 e8 f4 ff ff       	call   80105908 <argstr>
80106420:	83 c4 10             	add    $0x10,%esp
80106423:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010642a:	78 4f                	js     8010647b <sys_mknod+0x74>
     argint(1, &major) < 0 ||
8010642c:	83 ec 08             	sub    $0x8,%esp
8010642f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106432:	50                   	push   %eax
80106433:	6a 01                	push   $0x1
80106435:	e8 49 f4 ff ff       	call   80105883 <argint>
8010643a:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010643d:	85 c0                	test   %eax,%eax
8010643f:	78 3a                	js     8010647b <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106441:	83 ec 08             	sub    $0x8,%esp
80106444:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106447:	50                   	push   %eax
80106448:	6a 02                	push   $0x2
8010644a:	e8 34 f4 ff ff       	call   80105883 <argint>
8010644f:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106452:	85 c0                	test   %eax,%eax
80106454:	78 25                	js     8010647b <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106459:	0f bf c8             	movswl %ax,%ecx
8010645c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010645f:	0f bf d0             	movswl %ax,%edx
80106462:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106465:	51                   	push   %ecx
80106466:	52                   	push   %edx
80106467:	6a 03                	push   $0x3
80106469:	50                   	push   %eax
8010646a:	e8 c8 fb ff ff       	call   80106037 <create>
8010646f:	83 c4 10             	add    $0x10,%esp
80106472:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106475:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106479:	75 0c                	jne    80106487 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
8010647b:	e8 c0 d0 ff ff       	call   80103540 <end_op>
    return -1;
80106480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106485:	eb 18                	jmp    8010649f <sys_mknod+0x98>
  }
  iunlockput(ip);
80106487:	83 ec 0c             	sub    $0xc,%esp
8010648a:	ff 75 f0             	pushl  -0x10(%ebp)
8010648d:	e8 33 b7 ff ff       	call   80101bc5 <iunlockput>
80106492:	83 c4 10             	add    $0x10,%esp
  end_op();
80106495:	e8 a6 d0 ff ff       	call   80103540 <end_op>
  return 0;
8010649a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010649f:	c9                   	leave  
801064a0:	c3                   	ret    

801064a1 <sys_chdir>:

int
sys_chdir(void)
{
801064a1:	55                   	push   %ebp
801064a2:	89 e5                	mov    %esp,%ebp
801064a4:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801064a7:	e8 08 d0 ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801064ac:	83 ec 08             	sub    $0x8,%esp
801064af:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064b2:	50                   	push   %eax
801064b3:	6a 00                	push   $0x0
801064b5:	e8 4e f4 ff ff       	call   80105908 <argstr>
801064ba:	83 c4 10             	add    $0x10,%esp
801064bd:	85 c0                	test   %eax,%eax
801064bf:	78 18                	js     801064d9 <sys_chdir+0x38>
801064c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064c4:	83 ec 0c             	sub    $0xc,%esp
801064c7:	50                   	push   %eax
801064c8:	e8 f6 bf ff ff       	call   801024c3 <namei>
801064cd:	83 c4 10             	add    $0x10,%esp
801064d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064d7:	75 0c                	jne    801064e5 <sys_chdir+0x44>
    end_op();
801064d9:	e8 62 d0 ff ff       	call   80103540 <end_op>
    return -1;
801064de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064e3:	eb 6e                	jmp    80106553 <sys_chdir+0xb2>
  }
  ilock(ip);
801064e5:	83 ec 0c             	sub    $0xc,%esp
801064e8:	ff 75 f4             	pushl  -0xc(%ebp)
801064eb:	e8 1b b4 ff ff       	call   8010190b <ilock>
801064f0:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801064f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064f6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801064fa:	66 83 f8 01          	cmp    $0x1,%ax
801064fe:	74 1a                	je     8010651a <sys_chdir+0x79>
    iunlockput(ip);
80106500:	83 ec 0c             	sub    $0xc,%esp
80106503:	ff 75 f4             	pushl  -0xc(%ebp)
80106506:	e8 ba b6 ff ff       	call   80101bc5 <iunlockput>
8010650b:	83 c4 10             	add    $0x10,%esp
    end_op();
8010650e:	e8 2d d0 ff ff       	call   80103540 <end_op>
    return -1;
80106513:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106518:	eb 39                	jmp    80106553 <sys_chdir+0xb2>
  }
  iunlock(ip);
8010651a:	83 ec 0c             	sub    $0xc,%esp
8010651d:	ff 75 f4             	pushl  -0xc(%ebp)
80106520:	e8 3e b5 ff ff       	call   80101a63 <iunlock>
80106525:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106528:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010652e:	8b 40 68             	mov    0x68(%eax),%eax
80106531:	83 ec 0c             	sub    $0xc,%esp
80106534:	50                   	push   %eax
80106535:	e8 9b b5 ff ff       	call   80101ad5 <iput>
8010653a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010653d:	e8 fe cf ff ff       	call   80103540 <end_op>
  proc->cwd = ip;
80106542:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106548:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010654b:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010654e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106553:	c9                   	leave  
80106554:	c3                   	ret    

80106555 <sys_exec>:

int
sys_exec(void)
{
80106555:	55                   	push   %ebp
80106556:	89 e5                	mov    %esp,%ebp
80106558:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010655e:	83 ec 08             	sub    $0x8,%esp
80106561:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106564:	50                   	push   %eax
80106565:	6a 00                	push   $0x0
80106567:	e8 9c f3 ff ff       	call   80105908 <argstr>
8010656c:	83 c4 10             	add    $0x10,%esp
8010656f:	85 c0                	test   %eax,%eax
80106571:	78 18                	js     8010658b <sys_exec+0x36>
80106573:	83 ec 08             	sub    $0x8,%esp
80106576:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010657c:	50                   	push   %eax
8010657d:	6a 01                	push   $0x1
8010657f:	e8 ff f2 ff ff       	call   80105883 <argint>
80106584:	83 c4 10             	add    $0x10,%esp
80106587:	85 c0                	test   %eax,%eax
80106589:	79 0a                	jns    80106595 <sys_exec+0x40>
    return -1;
8010658b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106590:	e9 c6 00 00 00       	jmp    8010665b <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106595:	83 ec 04             	sub    $0x4,%esp
80106598:	68 80 00 00 00       	push   $0x80
8010659d:	6a 00                	push   $0x0
8010659f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801065a5:	50                   	push   %eax
801065a6:	e8 b3 ef ff ff       	call   8010555e <memset>
801065ab:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801065ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801065b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b8:	83 f8 1f             	cmp    $0x1f,%eax
801065bb:	76 0a                	jbe    801065c7 <sys_exec+0x72>
      return -1;
801065bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065c2:	e9 94 00 00 00       	jmp    8010665b <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801065c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ca:	c1 e0 02             	shl    $0x2,%eax
801065cd:	89 c2                	mov    %eax,%edx
801065cf:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801065d5:	01 c2                	add    %eax,%edx
801065d7:	83 ec 08             	sub    $0x8,%esp
801065da:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801065e0:	50                   	push   %eax
801065e1:	52                   	push   %edx
801065e2:	e8 00 f2 ff ff       	call   801057e7 <fetchint>
801065e7:	83 c4 10             	add    $0x10,%esp
801065ea:	85 c0                	test   %eax,%eax
801065ec:	79 07                	jns    801065f5 <sys_exec+0xa0>
      return -1;
801065ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065f3:	eb 66                	jmp    8010665b <sys_exec+0x106>
    if(uarg == 0){
801065f5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801065fb:	85 c0                	test   %eax,%eax
801065fd:	75 27                	jne    80106626 <sys_exec+0xd1>
      argv[i] = 0;
801065ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106602:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106609:	00 00 00 00 
      break;
8010660d:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010660e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106611:	83 ec 08             	sub    $0x8,%esp
80106614:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010661a:	52                   	push   %edx
8010661b:	50                   	push   %eax
8010661c:	e8 35 a5 ff ff       	call   80100b56 <exec>
80106621:	83 c4 10             	add    $0x10,%esp
80106624:	eb 35                	jmp    8010665b <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106626:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010662c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010662f:	c1 e2 02             	shl    $0x2,%edx
80106632:	01 c2                	add    %eax,%edx
80106634:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010663a:	83 ec 08             	sub    $0x8,%esp
8010663d:	52                   	push   %edx
8010663e:	50                   	push   %eax
8010663f:	e8 dd f1 ff ff       	call   80105821 <fetchstr>
80106644:	83 c4 10             	add    $0x10,%esp
80106647:	85 c0                	test   %eax,%eax
80106649:	79 07                	jns    80106652 <sys_exec+0xfd>
      return -1;
8010664b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106650:	eb 09                	jmp    8010665b <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106652:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106656:	e9 5a ff ff ff       	jmp    801065b5 <sys_exec+0x60>
  return exec(path, argv);
}
8010665b:	c9                   	leave  
8010665c:	c3                   	ret    

8010665d <sys_pipe>:

int
sys_pipe(void)
{
8010665d:	55                   	push   %ebp
8010665e:	89 e5                	mov    %esp,%ebp
80106660:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106663:	83 ec 04             	sub    $0x4,%esp
80106666:	6a 08                	push   $0x8
80106668:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010666b:	50                   	push   %eax
8010666c:	6a 00                	push   $0x0
8010666e:	e8 38 f2 ff ff       	call   801058ab <argptr>
80106673:	83 c4 10             	add    $0x10,%esp
80106676:	85 c0                	test   %eax,%eax
80106678:	79 0a                	jns    80106684 <sys_pipe+0x27>
    return -1;
8010667a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010667f:	e9 af 00 00 00       	jmp    80106733 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106684:	83 ec 08             	sub    $0x8,%esp
80106687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010668a:	50                   	push   %eax
8010668b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010668e:	50                   	push   %eax
8010668f:	e8 fe d8 ff ff       	call   80103f92 <pipealloc>
80106694:	83 c4 10             	add    $0x10,%esp
80106697:	85 c0                	test   %eax,%eax
80106699:	79 0a                	jns    801066a5 <sys_pipe+0x48>
    return -1;
8010669b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066a0:	e9 8e 00 00 00       	jmp    80106733 <sys_pipe+0xd6>
  fd0 = -1;
801066a5:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801066ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066af:	83 ec 0c             	sub    $0xc,%esp
801066b2:	50                   	push   %eax
801066b3:	e8 7c f3 ff ff       	call   80105a34 <fdalloc>
801066b8:	83 c4 10             	add    $0x10,%esp
801066bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066c2:	78 18                	js     801066dc <sys_pipe+0x7f>
801066c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066c7:	83 ec 0c             	sub    $0xc,%esp
801066ca:	50                   	push   %eax
801066cb:	e8 64 f3 ff ff       	call   80105a34 <fdalloc>
801066d0:	83 c4 10             	add    $0x10,%esp
801066d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066da:	79 3f                	jns    8010671b <sys_pipe+0xbe>
    if(fd0 >= 0)
801066dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066e0:	78 14                	js     801066f6 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
801066e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066eb:	83 c2 08             	add    $0x8,%edx
801066ee:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801066f5:	00 
    fileclose(rf);
801066f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066f9:	83 ec 0c             	sub    $0xc,%esp
801066fc:	50                   	push   %eax
801066fd:	e8 34 a9 ff ff       	call   80101036 <fileclose>
80106702:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106708:	83 ec 0c             	sub    $0xc,%esp
8010670b:	50                   	push   %eax
8010670c:	e8 25 a9 ff ff       	call   80101036 <fileclose>
80106711:	83 c4 10             	add    $0x10,%esp
    return -1;
80106714:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106719:	eb 18                	jmp    80106733 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
8010671b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010671e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106721:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106723:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106726:	8d 50 04             	lea    0x4(%eax),%edx
80106729:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010672c:	89 02                	mov    %eax,(%edx)
  return 0;
8010672e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106733:	c9                   	leave  
80106734:	c3                   	ret    

80106735 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80106735:	55                   	push   %ebp
80106736:	89 e5                	mov    %esp,%ebp
80106738:	83 ec 08             	sub    $0x8,%esp
8010673b:	8b 55 08             	mov    0x8(%ebp),%edx
8010673e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106741:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106745:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106749:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
8010674d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106751:	66 ef                	out    %ax,(%dx)
}
80106753:	90                   	nop
80106754:	c9                   	leave  
80106755:	c3                   	ret    

80106756 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106756:	55                   	push   %ebp
80106757:	89 e5                	mov    %esp,%ebp
80106759:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010675c:	e8 6b df ff ff       	call   801046cc <fork>
}
80106761:	c9                   	leave  
80106762:	c3                   	ret    

80106763 <sys_exit>:


int
sys_exit(void)
{
80106763:	55                   	push   %ebp
80106764:	89 e5                	mov    %esp,%ebp
80106766:	83 ec 08             	sub    $0x8,%esp
  exit();
80106769:	e8 bd e2 ff ff       	call   80104a2b <exit>
  return 0;  // not reached
8010676e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106773:	c9                   	leave  
80106774:	c3                   	ret    

80106775 <sys_wait>:

int
sys_wait(void)
{
80106775:	55                   	push   %ebp
80106776:	89 e5                	mov    %esp,%ebp
80106778:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010677b:	e8 f6 e3 ff ff       	call   80104b76 <wait>
}
80106780:	c9                   	leave  
80106781:	c3                   	ret    

80106782 <sys_kill>:

int
sys_kill(void)
{
80106782:	55                   	push   %ebp
80106783:	89 e5                	mov    %esp,%ebp
80106785:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106788:	83 ec 08             	sub    $0x8,%esp
8010678b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010678e:	50                   	push   %eax
8010678f:	6a 00                	push   $0x0
80106791:	e8 ed f0 ff ff       	call   80105883 <argint>
80106796:	83 c4 10             	add    $0x10,%esp
80106799:	85 c0                	test   %eax,%eax
8010679b:	79 07                	jns    801067a4 <sys_kill+0x22>
    return -1;
8010679d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067a2:	eb 0f                	jmp    801067b3 <sys_kill+0x31>
  return kill(pid);
801067a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a7:	83 ec 0c             	sub    $0xc,%esp
801067aa:	50                   	push   %eax
801067ab:	e8 07 e8 ff ff       	call   80104fb7 <kill>
801067b0:	83 c4 10             	add    $0x10,%esp
}
801067b3:	c9                   	leave  
801067b4:	c3                   	ret    

801067b5 <sys_getpid>:

int
sys_getpid(void)
{
801067b5:	55                   	push   %ebp
801067b6:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801067b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067be:	8b 40 10             	mov    0x10(%eax),%eax
}
801067c1:	5d                   	pop    %ebp
801067c2:	c3                   	ret    

801067c3 <sys_sbrk>:

int
sys_sbrk(void)
{
801067c3:	55                   	push   %ebp
801067c4:	89 e5                	mov    %esp,%ebp
801067c6:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801067c9:	83 ec 08             	sub    $0x8,%esp
801067cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067cf:	50                   	push   %eax
801067d0:	6a 00                	push   $0x0
801067d2:	e8 ac f0 ff ff       	call   80105883 <argint>
801067d7:	83 c4 10             	add    $0x10,%esp
801067da:	85 c0                	test   %eax,%eax
801067dc:	79 07                	jns    801067e5 <sys_sbrk+0x22>
    return -1;
801067de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067e3:	eb 28                	jmp    8010680d <sys_sbrk+0x4a>
  addr = proc->sz;
801067e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067eb:	8b 00                	mov    (%eax),%eax
801067ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801067f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067f3:	83 ec 0c             	sub    $0xc,%esp
801067f6:	50                   	push   %eax
801067f7:	e8 2d de ff ff       	call   80104629 <growproc>
801067fc:	83 c4 10             	add    $0x10,%esp
801067ff:	85 c0                	test   %eax,%eax
80106801:	79 07                	jns    8010680a <sys_sbrk+0x47>
    return -1;
80106803:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106808:	eb 03                	jmp    8010680d <sys_sbrk+0x4a>
  return addr;
8010680a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010680d:	c9                   	leave  
8010680e:	c3                   	ret    

8010680f <sys_sleep>:

int
sys_sleep(void)
{
8010680f:	55                   	push   %ebp
80106810:	89 e5                	mov    %esp,%ebp
80106812:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106815:	83 ec 08             	sub    $0x8,%esp
80106818:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010681b:	50                   	push   %eax
8010681c:	6a 00                	push   $0x0
8010681e:	e8 60 f0 ff ff       	call   80105883 <argint>
80106823:	83 c4 10             	add    $0x10,%esp
80106826:	85 c0                	test   %eax,%eax
80106828:	79 07                	jns    80106831 <sys_sleep+0x22>
    return -1;
8010682a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010682f:	eb 77                	jmp    801068a8 <sys_sleep+0x99>
  acquire(&tickslock);
80106831:	83 ec 0c             	sub    $0xc,%esp
80106834:	68 c0 5c 11 80       	push   $0x80115cc0
80106839:	e8 bd ea ff ff       	call   801052fb <acquire>
8010683e:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106841:	a1 00 65 11 80       	mov    0x80116500,%eax
80106846:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106849:	eb 39                	jmp    80106884 <sys_sleep+0x75>
    if(proc->killed){
8010684b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106851:	8b 40 24             	mov    0x24(%eax),%eax
80106854:	85 c0                	test   %eax,%eax
80106856:	74 17                	je     8010686f <sys_sleep+0x60>
      release(&tickslock);
80106858:	83 ec 0c             	sub    $0xc,%esp
8010685b:	68 c0 5c 11 80       	push   $0x80115cc0
80106860:	e8 fd ea ff ff       	call   80105362 <release>
80106865:	83 c4 10             	add    $0x10,%esp
      return -1;
80106868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010686d:	eb 39                	jmp    801068a8 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
8010686f:	83 ec 08             	sub    $0x8,%esp
80106872:	68 c0 5c 11 80       	push   $0x80115cc0
80106877:	68 00 65 11 80       	push   $0x80116500
8010687c:	e8 11 e6 ff ff       	call   80104e92 <sleep>
80106881:	83 c4 10             	add    $0x10,%esp

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106884:	a1 00 65 11 80       	mov    0x80116500,%eax
80106889:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010688c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010688f:	39 d0                	cmp    %edx,%eax
80106891:	72 b8                	jb     8010684b <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106893:	83 ec 0c             	sub    $0xc,%esp
80106896:	68 c0 5c 11 80       	push   $0x80115cc0
8010689b:	e8 c2 ea ff ff       	call   80105362 <release>
801068a0:	83 c4 10             	add    $0x10,%esp
  return 0;
801068a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068a8:	c9                   	leave  
801068a9:	c3                   	ret    

801068aa <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801068aa:	55                   	push   %ebp
801068ab:	89 e5                	mov    %esp,%ebp
801068ad:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
801068b0:	83 ec 0c             	sub    $0xc,%esp
801068b3:	68 c0 5c 11 80       	push   $0x80115cc0
801068b8:	e8 3e ea ff ff       	call   801052fb <acquire>
801068bd:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
801068c0:	a1 00 65 11 80       	mov    0x80116500,%eax
801068c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801068c8:	83 ec 0c             	sub    $0xc,%esp
801068cb:	68 c0 5c 11 80       	push   $0x80115cc0
801068d0:	e8 8d ea ff ff       	call   80105362 <release>
801068d5:	83 c4 10             	add    $0x10,%esp
  return xticks;
801068d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801068db:	c9                   	leave  
801068dc:	c3                   	ret    

801068dd <sys_halt>:
// signal to QEMU.
// Based on: http://pdos.csail.mit.edu/6.828/2012/homework/xv6-syscall.html
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
801068dd:	55                   	push   %ebp
801068de:	89 e5                	mov    %esp,%ebp
801068e0:	83 ec 10             	sub    $0x10,%esp
  char *p = "Shutdown";
801068e3:	c7 45 fc b0 92 10 80 	movl   $0x801092b0,-0x4(%ebp)
  for( ; *p; p++)
801068ea:	eb 16                	jmp    80106902 <sys_halt+0x25>
    outw(0xB004, 0x2000);
801068ec:	68 00 20 00 00       	push   $0x2000
801068f1:	68 04 b0 00 00       	push   $0xb004
801068f6:	e8 3a fe ff ff       	call   80106735 <outw>
801068fb:	83 c4 08             	add    $0x8,%esp
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
  char *p = "Shutdown";
  for( ; *p; p++)
801068fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106902:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106905:	0f b6 00             	movzbl (%eax),%eax
80106908:	84 c0                	test   %al,%al
8010690a:	75 e0                	jne    801068ec <sys_halt+0xf>
    outw(0xB004, 0x2000);
  return 0;
8010690c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106911:	c9                   	leave  
80106912:	c3                   	ret    

80106913 <sys_mprotect>:

int sys_mprotect(void)
{
80106913:	55                   	push   %ebp
80106914:	89 e5                	mov    %esp,%ebp
80106916:	83 ec 18             	sub    $0x18,%esp
  int addr,len,prot;

  if(argint(0, &addr) <0)
80106919:	83 ec 08             	sub    $0x8,%esp
8010691c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010691f:	50                   	push   %eax
80106920:	6a 00                	push   $0x0
80106922:	e8 5c ef ff ff       	call   80105883 <argint>
80106927:	83 c4 10             	add    $0x10,%esp
8010692a:	85 c0                	test   %eax,%eax
8010692c:	79 07                	jns    80106935 <sys_mprotect+0x22>
    return -1;
8010692e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106933:	eb 4f                	jmp    80106984 <sys_mprotect+0x71>
  if(argint(1,&len) <0)
80106935:	83 ec 08             	sub    $0x8,%esp
80106938:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010693b:	50                   	push   %eax
8010693c:	6a 01                	push   $0x1
8010693e:	e8 40 ef ff ff       	call   80105883 <argint>
80106943:	83 c4 10             	add    $0x10,%esp
80106946:	85 c0                	test   %eax,%eax
80106948:	79 07                	jns    80106951 <sys_mprotect+0x3e>
    return -1;
8010694a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010694f:	eb 33                	jmp    80106984 <sys_mprotect+0x71>
  if(argint(2,&prot) <0)
80106951:	83 ec 08             	sub    $0x8,%esp
80106954:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106957:	50                   	push   %eax
80106958:	6a 02                	push   $0x2
8010695a:	e8 24 ef ff ff       	call   80105883 <argint>
8010695f:	83 c4 10             	add    $0x10,%esp
80106962:	85 c0                	test   %eax,%eax
80106964:	79 07                	jns    8010696d <sys_mprotect+0x5a>
    return -1;
80106966:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010696b:	eb 17                	jmp    80106984 <sys_mprotect+0x71>

  return mprotect((void*)addr,len,prot);
8010696d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106970:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106973:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80106976:	83 ec 04             	sub    $0x4,%esp
80106979:	52                   	push   %edx
8010697a:	50                   	push   %eax
8010697b:	51                   	push   %ecx
8010697c:	e8 8a 1c 00 00       	call   8010860b <mprotect>
80106981:	83 c4 10             	add    $0x10,%esp
}
80106984:	c9                   	leave  
80106985:	c3                   	ret    

80106986 <sys_signal_register>:

int sys_signal_register(void)
{
80106986:	55                   	push   %ebp
80106987:	89 e5                	mov    %esp,%ebp
80106989:	83 ec 18             	sub    $0x18,%esp
    uint signum;
    sighandler_t handler;
    int n;

    if (argint(0, &n) < 0)
8010698c:	83 ec 08             	sub    $0x8,%esp
8010698f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106992:	50                   	push   %eax
80106993:	6a 00                	push   $0x0
80106995:	e8 e9 ee ff ff       	call   80105883 <argint>
8010699a:	83 c4 10             	add    $0x10,%esp
8010699d:	85 c0                	test   %eax,%eax
8010699f:	79 07                	jns    801069a8 <sys_signal_register+0x22>
      return -1;
801069a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069a6:	eb 3a                	jmp    801069e2 <sys_signal_register+0x5c>
    signum = (uint) n;
801069a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801069ab:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (argint(1, &n) < 0)
801069ae:	83 ec 08             	sub    $0x8,%esp
801069b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801069b4:	50                   	push   %eax
801069b5:	6a 01                	push   $0x1
801069b7:	e8 c7 ee ff ff       	call   80105883 <argint>
801069bc:	83 c4 10             	add    $0x10,%esp
801069bf:	85 c0                	test   %eax,%eax
801069c1:	79 07                	jns    801069ca <sys_signal_register+0x44>
      return -1;
801069c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069c8:	eb 18                	jmp    801069e2 <sys_signal_register+0x5c>
    handler = (sighandler_t) n;
801069ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801069cd:	89 45 f0             	mov    %eax,-0x10(%ebp)

    return (int) signal_register_handler(signum, handler);
801069d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069d3:	83 ec 08             	sub    $0x8,%esp
801069d6:	ff 75 f0             	pushl  -0x10(%ebp)
801069d9:	50                   	push   %eax
801069da:	e8 80 e8 ff ff       	call   8010525f <signal_register_handler>
801069df:	83 c4 10             	add    $0x10,%esp
}
801069e2:	c9                   	leave  
801069e3:	c3                   	ret    

801069e4 <sys_cowfork>:
int sys_cowfork(void)
{
801069e4:	55                   	push   %ebp
801069e5:	89 e5                	mov    %esp,%ebp
801069e7:	83 ec 08             	sub    $0x8,%esp
  return cowfork();
801069ea:	e8 6e de ff ff       	call   8010485d <cowfork>
}
801069ef:	c9                   	leave  
801069f0:	c3                   	ret    

801069f1 <sys_signal_restorer>:
int sys_signal_restorer(void)
{
801069f1:	55                   	push   %ebp
801069f2:	89 e5                	mov    %esp,%ebp
801069f4:	83 ec 18             	sub    $0x18,%esp
    int restorer_addr;
    if (argint(0, &restorer_addr) < 0)
801069f7:	83 ec 08             	sub    $0x8,%esp
801069fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069fd:	50                   	push   %eax
801069fe:	6a 00                	push   $0x0
80106a00:	e8 7e ee ff ff       	call   80105883 <argint>
80106a05:	83 c4 10             	add    $0x10,%esp
80106a08:	85 c0                	test   %eax,%eax
80106a0a:	79 07                	jns    80106a13 <sys_signal_restorer+0x22>
      return -1;
80106a0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a11:	eb 14                	jmp    80106a27 <sys_signal_restorer+0x36>

    proc->restorer_addr = (uint) restorer_addr;
80106a13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a1c:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

    return 0;
80106a22:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a27:	c9                   	leave  
80106a28:	c3                   	ret    

80106a29 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106a29:	55                   	push   %ebp
80106a2a:	89 e5                	mov    %esp,%ebp
80106a2c:	83 ec 08             	sub    $0x8,%esp
80106a2f:	8b 55 08             	mov    0x8(%ebp),%edx
80106a32:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a35:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106a39:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a3c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106a40:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106a44:	ee                   	out    %al,(%dx)
}
80106a45:	90                   	nop
80106a46:	c9                   	leave  
80106a47:	c3                   	ret    

80106a48 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106a48:	55                   	push   %ebp
80106a49:	89 e5                	mov    %esp,%ebp
80106a4b:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106a4e:	6a 34                	push   $0x34
80106a50:	6a 43                	push   $0x43
80106a52:	e8 d2 ff ff ff       	call   80106a29 <outb>
80106a57:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106a5a:	68 9c 00 00 00       	push   $0x9c
80106a5f:	6a 40                	push   $0x40
80106a61:	e8 c3 ff ff ff       	call   80106a29 <outb>
80106a66:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106a69:	6a 2e                	push   $0x2e
80106a6b:	6a 40                	push   $0x40
80106a6d:	e8 b7 ff ff ff       	call   80106a29 <outb>
80106a72:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106a75:	83 ec 0c             	sub    $0xc,%esp
80106a78:	6a 00                	push   $0x0
80106a7a:	e8 fd d3 ff ff       	call   80103e7c <picenable>
80106a7f:	83 c4 10             	add    $0x10,%esp
}
80106a82:	90                   	nop
80106a83:	c9                   	leave  
80106a84:	c3                   	ret    

80106a85 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106a85:	1e                   	push   %ds
  pushl %es
80106a86:	06                   	push   %es
  pushl %fs
80106a87:	0f a0                	push   %fs
  pushl %gs
80106a89:	0f a8                	push   %gs
  pushal
80106a8b:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106a8c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106a90:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106a92:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106a94:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106a98:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106a9a:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106a9c:	54                   	push   %esp
  call trap
80106a9d:	e8 d7 01 00 00       	call   80106c79 <trap>
  addl $4, %esp
80106aa2:	83 c4 04             	add    $0x4,%esp

80106aa5 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106aa5:	61                   	popa   
  popl %gs
80106aa6:	0f a9                	pop    %gs
  popl %fs
80106aa8:	0f a1                	pop    %fs
  popl %es
80106aaa:	07                   	pop    %es
  popl %ds
80106aab:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106aac:	83 c4 08             	add    $0x8,%esp
  iret
80106aaf:	cf                   	iret   

80106ab0 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ab9:	83 e8 01             	sub    $0x1,%eax
80106abc:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ac3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106ac7:	8b 45 08             	mov    0x8(%ebp),%eax
80106aca:	c1 e8 10             	shr    $0x10,%eax
80106acd:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106ad1:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106ad4:	0f 01 18             	lidtl  (%eax)
}
80106ad7:	90                   	nop
80106ad8:	c9                   	leave  
80106ad9:	c3                   	ret    

80106ada <rcr2>:
  asm volatile("movl %eax,%cr3");
}

static inline uint
rcr2(void)
{
80106ada:	55                   	push   %ebp
80106adb:	89 e5                	mov    %esp,%ebp
80106add:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106ae0:	0f 20 d0             	mov    %cr2,%eax
80106ae3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106ae6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106ae9:	c9                   	leave  
80106aea:	c3                   	ret    

80106aeb <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106aeb:	55                   	push   %ebp
80106aec:	89 e5                	mov    %esp,%ebp
80106aee:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106af1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106af8:	e9 c3 00 00 00       	jmp    80106bc0 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b00:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106b07:	89 c2                	mov    %eax,%edx
80106b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b0c:	66 89 14 c5 00 5d 11 	mov    %dx,-0x7feea300(,%eax,8)
80106b13:	80 
80106b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b17:	66 c7 04 c5 02 5d 11 	movw   $0x8,-0x7feea2fe(,%eax,8)
80106b1e:	80 08 00 
80106b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b24:	0f b6 14 c5 04 5d 11 	movzbl -0x7feea2fc(,%eax,8),%edx
80106b2b:	80 
80106b2c:	83 e2 e0             	and    $0xffffffe0,%edx
80106b2f:	88 14 c5 04 5d 11 80 	mov    %dl,-0x7feea2fc(,%eax,8)
80106b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b39:	0f b6 14 c5 04 5d 11 	movzbl -0x7feea2fc(,%eax,8),%edx
80106b40:	80 
80106b41:	83 e2 1f             	and    $0x1f,%edx
80106b44:	88 14 c5 04 5d 11 80 	mov    %dl,-0x7feea2fc(,%eax,8)
80106b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b4e:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106b55:	80 
80106b56:	83 e2 f0             	and    $0xfffffff0,%edx
80106b59:	83 ca 0e             	or     $0xe,%edx
80106b5c:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b66:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106b6d:	80 
80106b6e:	83 e2 ef             	and    $0xffffffef,%edx
80106b71:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b7b:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106b82:	80 
80106b83:	83 e2 9f             	and    $0xffffff9f,%edx
80106b86:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b90:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106b97:	80 
80106b98:	83 ca 80             	or     $0xffffff80,%edx
80106b9b:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ba5:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106bac:	c1 e8 10             	shr    $0x10,%eax
80106baf:	89 c2                	mov    %eax,%edx
80106bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb4:	66 89 14 c5 06 5d 11 	mov    %dx,-0x7feea2fa(,%eax,8)
80106bbb:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106bbc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106bc0:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106bc7:	0f 8e 30 ff ff ff    	jle    80106afd <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106bcd:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106bd2:	66 a3 00 5f 11 80    	mov    %ax,0x80115f00
80106bd8:	66 c7 05 02 5f 11 80 	movw   $0x8,0x80115f02
80106bdf:	08 00 
80106be1:	0f b6 05 04 5f 11 80 	movzbl 0x80115f04,%eax
80106be8:	83 e0 e0             	and    $0xffffffe0,%eax
80106beb:	a2 04 5f 11 80       	mov    %al,0x80115f04
80106bf0:	0f b6 05 04 5f 11 80 	movzbl 0x80115f04,%eax
80106bf7:	83 e0 1f             	and    $0x1f,%eax
80106bfa:	a2 04 5f 11 80       	mov    %al,0x80115f04
80106bff:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106c06:	83 c8 0f             	or     $0xf,%eax
80106c09:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106c0e:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106c15:	83 e0 ef             	and    $0xffffffef,%eax
80106c18:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106c1d:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106c24:	83 c8 60             	or     $0x60,%eax
80106c27:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106c2c:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106c33:	83 c8 80             	or     $0xffffff80,%eax
80106c36:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106c3b:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106c40:	c1 e8 10             	shr    $0x10,%eax
80106c43:	66 a3 06 5f 11 80    	mov    %ax,0x80115f06

  initlock(&tickslock, "time");
80106c49:	83 ec 08             	sub    $0x8,%esp
80106c4c:	68 bc 92 10 80       	push   $0x801092bc
80106c51:	68 c0 5c 11 80       	push   $0x80115cc0
80106c56:	e8 7e e6 ff ff       	call   801052d9 <initlock>
80106c5b:	83 c4 10             	add    $0x10,%esp
}
80106c5e:	90                   	nop
80106c5f:	c9                   	leave  
80106c60:	c3                   	ret    

80106c61 <idtinit>:

void
idtinit(void)
{
80106c61:	55                   	push   %ebp
80106c62:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106c64:	68 00 08 00 00       	push   $0x800
80106c69:	68 00 5d 11 80       	push   $0x80115d00
80106c6e:	e8 3d fe ff ff       	call   80106ab0 <lidt>
80106c73:	83 c4 08             	add    $0x8,%esp
}
80106c76:	90                   	nop
80106c77:	c9                   	leave  
80106c78:	c3                   	ret    

80106c79 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106c79:	55                   	push   %ebp
80106c7a:	89 e5                	mov    %esp,%ebp
80106c7c:	57                   	push   %edi
80106c7d:	56                   	push   %esi
80106c7e:	53                   	push   %ebx
80106c7f:	83 ec 2c             	sub    $0x2c,%esp
  siginfo_t si;
  if(tf->trapno == T_SYSCALL){
80106c82:	8b 45 08             	mov    0x8(%ebp),%eax
80106c85:	8b 40 30             	mov    0x30(%eax),%eax
80106c88:	83 f8 40             	cmp    $0x40,%eax
80106c8b:	75 3e                	jne    80106ccb <trap+0x52>
    if(proc->killed)
80106c8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c93:	8b 40 24             	mov    0x24(%eax),%eax
80106c96:	85 c0                	test   %eax,%eax
80106c98:	74 05                	je     80106c9f <trap+0x26>
      exit();
80106c9a:	e8 8c dd ff ff       	call   80104a2b <exit>
    proc->tf = tf;
80106c9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ca5:	8b 55 08             	mov    0x8(%ebp),%edx
80106ca8:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106cab:	e8 89 ec ff ff       	call   80105939 <syscall>
    if(proc->killed)
80106cb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cb6:	8b 40 24             	mov    0x24(%eax),%eax
80106cb9:	85 c0                	test   %eax,%eax
80106cbb:	0f 84 f7 02 00 00    	je     80106fb8 <trap+0x33f>
      exit();
80106cc1:	e8 65 dd ff ff       	call   80104a2b <exit>
80106cc6:	e9 ee 02 00 00       	jmp    80106fb9 <trap+0x340>
    return;
  }

  switch(tf->trapno){
80106ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80106cce:	8b 40 30             	mov    0x30(%eax),%eax
80106cd1:	83 f8 3f             	cmp    $0x3f,%eax
80106cd4:	0f 87 9c 01 00 00    	ja     80106e76 <trap+0x1fd>
80106cda:	8b 04 85 8c 93 10 80 	mov    -0x7fef6c74(,%eax,4),%eax
80106ce1:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106ce3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ce9:	0f b6 00             	movzbl (%eax),%eax
80106cec:	84 c0                	test   %al,%al
80106cee:	75 3d                	jne    80106d2d <trap+0xb4>
      acquire(&tickslock);
80106cf0:	83 ec 0c             	sub    $0xc,%esp
80106cf3:	68 c0 5c 11 80       	push   $0x80115cc0
80106cf8:	e8 fe e5 ff ff       	call   801052fb <acquire>
80106cfd:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106d00:	a1 00 65 11 80       	mov    0x80116500,%eax
80106d05:	83 c0 01             	add    $0x1,%eax
80106d08:	a3 00 65 11 80       	mov    %eax,0x80116500
      wakeup(&ticks);
80106d0d:	83 ec 0c             	sub    $0xc,%esp
80106d10:	68 00 65 11 80       	push   $0x80116500
80106d15:	e8 66 e2 ff ff       	call   80104f80 <wakeup>
80106d1a:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106d1d:	83 ec 0c             	sub    $0xc,%esp
80106d20:	68 c0 5c 11 80       	push   $0x80115cc0
80106d25:	e8 38 e6 ff ff       	call   80105362 <release>
80106d2a:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106d2d:	e8 52 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d32:	e9 fb 01 00 00       	jmp    80106f32 <trap+0x2b9>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106d37:	e8 5b ba ff ff       	call   80102797 <ideintr>
    lapiceoi();
80106d3c:	e8 43 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d41:	e9 ec 01 00 00       	jmp    80106f32 <trap+0x2b9>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106d46:	e8 3b c0 ff ff       	call   80102d86 <kbdintr>
    lapiceoi();
80106d4b:	e8 34 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d50:	e9 dd 01 00 00       	jmp    80106f32 <trap+0x2b9>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106d55:	e8 3f 04 00 00       	call   80107199 <uartintr>
    lapiceoi();
80106d5a:	e8 25 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d5f:	e9 ce 01 00 00       	jmp    80106f32 <trap+0x2b9>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d64:	8b 45 08             	mov    0x8(%ebp),%eax
80106d67:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106d6a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d6d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d71:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106d74:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106d7a:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d7d:	0f b6 c0             	movzbl %al,%eax
80106d80:	51                   	push   %ecx
80106d81:	52                   	push   %edx
80106d82:	50                   	push   %eax
80106d83:	68 c4 92 10 80       	push   $0x801092c4
80106d88:	e8 39 96 ff ff       	call   801003c6 <cprintf>
80106d8d:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106d90:	e8 ef c1 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d95:	e9 98 01 00 00       	jmp    80106f32 <trap+0x2b9>

   case T_DIVIDE:
      if (proc->handlers[SIGFPE] != (sighandler_t) -1) {
80106d9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106da0:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106da6:	83 f8 ff             	cmp    $0xffffffff,%eax
80106da9:	74 26                	je     80106dd1 <trap+0x158>
        si.type= 1;
80106dab:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
        si.addr = 5;
80106db2:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%ebp)
        signal_deliver(SIGFPE,si);
80106db9:	83 ec 04             	sub    $0x4,%esp
80106dbc:	ff 75 e0             	pushl  -0x20(%ebp)
80106dbf:	ff 75 dc             	pushl  -0x24(%ebp)
80106dc2:	6a 01                	push   $0x1
80106dc4:	e8 71 e3 ff ff       	call   8010513a <signal_deliver>
80106dc9:	83 c4 10             	add    $0x10,%esp
        break;
80106dcc:	e9 61 01 00 00       	jmp    80106f32 <trap+0x2b9>
      }
    //handle pgfault with mem_protect
    case T_PGFLT:
     // cprintf(" PAGEFULT !! SHARED = %d\n",proc->shared);

      if(proc->shared == 1) {
80106dd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dd7:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80106ddd:	83 f8 01             	cmp    $0x1,%eax
80106de0:	75 15                	jne    80106df7 <trap+0x17e>
       cprintf("DO SOMETHING!\n");
80106de2:	83 ec 0c             	sub    $0xc,%esp
80106de5:	68 e8 92 10 80       	push   $0x801092e8
80106dea:	e8 d7 95 ff ff       	call   801003c6 <cprintf>
80106def:	83 c4 10             	add    $0x10,%esp
        si.addr = rcr2();
        // cprintf(" PAGE FAULT addr: 0x%x addrtype: 0x%x\n",si.addr,si.type);
        signal_deliver(SIGSEGV,si);
        break;
      } 
      break;
80106df2:	e9 3a 01 00 00       	jmp    80106f31 <trap+0x2b8>
     // cprintf(" PAGEFULT !! SHARED = %d\n",proc->shared);

      if(proc->shared == 1) {
       cprintf("DO SOMETHING!\n");

      } else if (proc->handlers[SIGSEGV] != (sighandler_t) -1) {
80106df7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dfd:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
80106e03:	83 f8 ff             	cmp    $0xffffffff,%eax
80106e06:	0f 84 25 01 00 00    	je     80106f31 <trap+0x2b8>
        cprintf("WHY IS THIS HAPPENING?\n");
80106e0c:	83 ec 0c             	sub    $0xc,%esp
80106e0f:	68 f7 92 10 80       	push   $0x801092f7
80106e14:	e8 ad 95 ff ff       	call   801003c6 <cprintf>
80106e19:	83 c4 10             	add    $0x10,%esp
        int err = tf->err;
80106e1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e1f:	8b 40 34             	mov    0x34(%eax),%eax
80106e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(err == 0x4 || err == 0x6 || err == 0x5) {
80106e25:	83 7d e4 04          	cmpl   $0x4,-0x1c(%ebp)
80106e29:	74 0c                	je     80106e37 <trap+0x1be>
80106e2b:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
80106e2f:	74 06                	je     80106e37 <trap+0x1be>
80106e31:	83 7d e4 05          	cmpl   $0x5,-0x1c(%ebp)
80106e35:	75 09                	jne    80106e40 <trap+0x1c7>
          si.type = PROT_NONE;
80106e37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106e3e:	eb 16                	jmp    80106e56 <trap+0x1dd>
        } else if(err == 0x7) {
80106e40:	83 7d e4 07          	cmpl   $0x7,-0x1c(%ebp)
80106e44:	75 09                	jne    80106e4f <trap+0x1d6>
          si.type = PROT_READ;
80106e46:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80106e4d:	eb 07                	jmp    80106e56 <trap+0x1dd>
        } else {
          si.type = PROT_WRITE;
80106e4f:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
        }
        si.addr = rcr2();
80106e56:	e8 7f fc ff ff       	call   80106ada <rcr2>
80106e5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        // cprintf(" PAGE FAULT addr: 0x%x addrtype: 0x%x\n",si.addr,si.type);
        signal_deliver(SIGSEGV,si);
80106e5e:	83 ec 04             	sub    $0x4,%esp
80106e61:	ff 75 e0             	pushl  -0x20(%ebp)
80106e64:	ff 75 dc             	pushl  -0x24(%ebp)
80106e67:	6a 0e                	push   $0xe
80106e69:	e8 cc e2 ff ff       	call   8010513a <signal_deliver>
80106e6e:	83 c4 10             	add    $0x10,%esp
        break;
80106e71:	e9 bc 00 00 00       	jmp    80106f32 <trap+0x2b9>
      } 
      break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106e76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e7c:	85 c0                	test   %eax,%eax
80106e7e:	74 11                	je     80106e91 <trap+0x218>
80106e80:	8b 45 08             	mov    0x8(%ebp),%eax
80106e83:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e87:	0f b7 c0             	movzwl %ax,%eax
80106e8a:	83 e0 03             	and    $0x3,%eax
80106e8d:	85 c0                	test   %eax,%eax
80106e8f:	75 40                	jne    80106ed1 <trap+0x258>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e91:	e8 44 fc ff ff       	call   80106ada <rcr2>
80106e96:	89 c3                	mov    %eax,%ebx
80106e98:	8b 45 08             	mov    0x8(%ebp),%eax
80106e9b:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106e9e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ea4:	0f b6 00             	movzbl (%eax),%eax

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ea7:	0f b6 d0             	movzbl %al,%edx
80106eaa:	8b 45 08             	mov    0x8(%ebp),%eax
80106ead:	8b 40 30             	mov    0x30(%eax),%eax
80106eb0:	83 ec 0c             	sub    $0xc,%esp
80106eb3:	53                   	push   %ebx
80106eb4:	51                   	push   %ecx
80106eb5:	52                   	push   %edx
80106eb6:	50                   	push   %eax
80106eb7:	68 10 93 10 80       	push   $0x80109310
80106ebc:	e8 05 95 ff ff       	call   801003c6 <cprintf>
80106ec1:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106ec4:	83 ec 0c             	sub    $0xc,%esp
80106ec7:	68 42 93 10 80       	push   $0x80109342
80106ecc:	e8 95 96 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ed1:	e8 04 fc ff ff       	call   80106ada <rcr2>
80106ed6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80106edc:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106edf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ee5:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ee8:	0f b6 d8             	movzbl %al,%ebx
80106eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80106eee:	8b 48 34             	mov    0x34(%eax),%ecx
80106ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ef4:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106ef7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106efd:	8d 78 6c             	lea    0x6c(%eax),%edi
80106f00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f06:	8b 40 10             	mov    0x10(%eax),%eax
80106f09:	ff 75 d4             	pushl  -0x2c(%ebp)
80106f0c:	56                   	push   %esi
80106f0d:	53                   	push   %ebx
80106f0e:	51                   	push   %ecx
80106f0f:	52                   	push   %edx
80106f10:	57                   	push   %edi
80106f11:	50                   	push   %eax
80106f12:	68 48 93 10 80       	push   $0x80109348
80106f17:	e8 aa 94 ff ff       	call   801003c6 <cprintf>
80106f1c:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
            rcr2());
    proc->killed = 1;
80106f1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f25:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106f2c:	eb 04                	jmp    80106f32 <trap+0x2b9>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106f2e:	90                   	nop
80106f2f:	eb 01                	jmp    80106f32 <trap+0x2b9>
        si.addr = rcr2();
        // cprintf(" PAGE FAULT addr: 0x%x addrtype: 0x%x\n",si.addr,si.type);
        signal_deliver(SIGSEGV,si);
        break;
      } 
      break;
80106f31:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106f32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f38:	85 c0                	test   %eax,%eax
80106f3a:	74 24                	je     80106f60 <trap+0x2e7>
80106f3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f42:	8b 40 24             	mov    0x24(%eax),%eax
80106f45:	85 c0                	test   %eax,%eax
80106f47:	74 17                	je     80106f60 <trap+0x2e7>
80106f49:	8b 45 08             	mov    0x8(%ebp),%eax
80106f4c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f50:	0f b7 c0             	movzwl %ax,%eax
80106f53:	83 e0 03             	and    $0x3,%eax
80106f56:	83 f8 03             	cmp    $0x3,%eax
80106f59:	75 05                	jne    80106f60 <trap+0x2e7>
    exit();
80106f5b:	e8 cb da ff ff       	call   80104a2b <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106f60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f66:	85 c0                	test   %eax,%eax
80106f68:	74 1e                	je     80106f88 <trap+0x30f>
80106f6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f70:	8b 40 0c             	mov    0xc(%eax),%eax
80106f73:	83 f8 04             	cmp    $0x4,%eax
80106f76:	75 10                	jne    80106f88 <trap+0x30f>
80106f78:	8b 45 08             	mov    0x8(%ebp),%eax
80106f7b:	8b 40 30             	mov    0x30(%eax),%eax
80106f7e:	83 f8 20             	cmp    $0x20,%eax
80106f81:	75 05                	jne    80106f88 <trap+0x30f>
    yield();
80106f83:	e8 9e de ff ff       	call   80104e26 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106f88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f8e:	85 c0                	test   %eax,%eax
80106f90:	74 27                	je     80106fb9 <trap+0x340>
80106f92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f98:	8b 40 24             	mov    0x24(%eax),%eax
80106f9b:	85 c0                	test   %eax,%eax
80106f9d:	74 1a                	je     80106fb9 <trap+0x340>
80106f9f:	8b 45 08             	mov    0x8(%ebp),%eax
80106fa2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106fa6:	0f b7 c0             	movzwl %ax,%eax
80106fa9:	83 e0 03             	and    $0x3,%eax
80106fac:	83 f8 03             	cmp    $0x3,%eax
80106faf:	75 08                	jne    80106fb9 <trap+0x340>
    exit();
80106fb1:	e8 75 da ff ff       	call   80104a2b <exit>
80106fb6:	eb 01                	jmp    80106fb9 <trap+0x340>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106fb8:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106fb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fbc:	5b                   	pop    %ebx
80106fbd:	5e                   	pop    %esi
80106fbe:	5f                   	pop    %edi
80106fbf:	5d                   	pop    %ebp
80106fc0:	c3                   	ret    

80106fc1 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106fc1:	55                   	push   %ebp
80106fc2:	89 e5                	mov    %esp,%ebp
80106fc4:	83 ec 14             	sub    $0x14,%esp
80106fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80106fca:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106fce:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106fd2:	89 c2                	mov    %eax,%edx
80106fd4:	ec                   	in     (%dx),%al
80106fd5:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106fd8:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106fdc:	c9                   	leave  
80106fdd:	c3                   	ret    

80106fde <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106fde:	55                   	push   %ebp
80106fdf:	89 e5                	mov    %esp,%ebp
80106fe1:	83 ec 08             	sub    $0x8,%esp
80106fe4:	8b 55 08             	mov    0x8(%ebp),%edx
80106fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fea:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106fee:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106ff1:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106ff5:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106ff9:	ee                   	out    %al,(%dx)
}
80106ffa:	90                   	nop
80106ffb:	c9                   	leave  
80106ffc:	c3                   	ret    

80106ffd <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106ffd:	55                   	push   %ebp
80106ffe:	89 e5                	mov    %esp,%ebp
80107000:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107003:	6a 00                	push   $0x0
80107005:	68 fa 03 00 00       	push   $0x3fa
8010700a:	e8 cf ff ff ff       	call   80106fde <outb>
8010700f:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107012:	68 80 00 00 00       	push   $0x80
80107017:	68 fb 03 00 00       	push   $0x3fb
8010701c:	e8 bd ff ff ff       	call   80106fde <outb>
80107021:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107024:	6a 0c                	push   $0xc
80107026:	68 f8 03 00 00       	push   $0x3f8
8010702b:	e8 ae ff ff ff       	call   80106fde <outb>
80107030:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107033:	6a 00                	push   $0x0
80107035:	68 f9 03 00 00       	push   $0x3f9
8010703a:	e8 9f ff ff ff       	call   80106fde <outb>
8010703f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107042:	6a 03                	push   $0x3
80107044:	68 fb 03 00 00       	push   $0x3fb
80107049:	e8 90 ff ff ff       	call   80106fde <outb>
8010704e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107051:	6a 00                	push   $0x0
80107053:	68 fc 03 00 00       	push   $0x3fc
80107058:	e8 81 ff ff ff       	call   80106fde <outb>
8010705d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107060:	6a 01                	push   $0x1
80107062:	68 f9 03 00 00       	push   $0x3f9
80107067:	e8 72 ff ff ff       	call   80106fde <outb>
8010706c:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010706f:	68 fd 03 00 00       	push   $0x3fd
80107074:	e8 48 ff ff ff       	call   80106fc1 <inb>
80107079:	83 c4 04             	add    $0x4,%esp
8010707c:	3c ff                	cmp    $0xff,%al
8010707e:	74 6e                	je     801070ee <uartinit+0xf1>
    return;
  uart = 1;
80107080:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80107087:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010708a:	68 fa 03 00 00       	push   $0x3fa
8010708f:	e8 2d ff ff ff       	call   80106fc1 <inb>
80107094:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107097:	68 f8 03 00 00       	push   $0x3f8
8010709c:	e8 20 ff ff ff       	call   80106fc1 <inb>
801070a1:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801070a4:	83 ec 0c             	sub    $0xc,%esp
801070a7:	6a 04                	push   $0x4
801070a9:	e8 ce cd ff ff       	call   80103e7c <picenable>
801070ae:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801070b1:	83 ec 08             	sub    $0x8,%esp
801070b4:	6a 00                	push   $0x0
801070b6:	6a 04                	push   $0x4
801070b8:	e8 7c b9 ff ff       	call   80102a39 <ioapicenable>
801070bd:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801070c0:	c7 45 f4 8c 94 10 80 	movl   $0x8010948c,-0xc(%ebp)
801070c7:	eb 19                	jmp    801070e2 <uartinit+0xe5>
    uartputc(*p);
801070c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070cc:	0f b6 00             	movzbl (%eax),%eax
801070cf:	0f be c0             	movsbl %al,%eax
801070d2:	83 ec 0c             	sub    $0xc,%esp
801070d5:	50                   	push   %eax
801070d6:	e8 16 00 00 00       	call   801070f1 <uartputc>
801070db:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801070de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801070e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070e5:	0f b6 00             	movzbl (%eax),%eax
801070e8:	84 c0                	test   %al,%al
801070ea:	75 dd                	jne    801070c9 <uartinit+0xcc>
801070ec:	eb 01                	jmp    801070ef <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801070ee:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
801070ef:	c9                   	leave  
801070f0:	c3                   	ret    

801070f1 <uartputc>:

void
uartputc(int c)
{
801070f1:	55                   	push   %ebp
801070f2:	89 e5                	mov    %esp,%ebp
801070f4:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801070f7:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801070fc:	85 c0                	test   %eax,%eax
801070fe:	74 53                	je     80107153 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107100:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107107:	eb 11                	jmp    8010711a <uartputc+0x29>
    microdelay(10);
80107109:	83 ec 0c             	sub    $0xc,%esp
8010710c:	6a 0a                	push   $0xa
8010710e:	e8 8c be ff ff       	call   80102f9f <microdelay>
80107113:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107116:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010711a:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010711e:	7f 1a                	jg     8010713a <uartputc+0x49>
80107120:	83 ec 0c             	sub    $0xc,%esp
80107123:	68 fd 03 00 00       	push   $0x3fd
80107128:	e8 94 fe ff ff       	call   80106fc1 <inb>
8010712d:	83 c4 10             	add    $0x10,%esp
80107130:	0f b6 c0             	movzbl %al,%eax
80107133:	83 e0 20             	and    $0x20,%eax
80107136:	85 c0                	test   %eax,%eax
80107138:	74 cf                	je     80107109 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
8010713a:	8b 45 08             	mov    0x8(%ebp),%eax
8010713d:	0f b6 c0             	movzbl %al,%eax
80107140:	83 ec 08             	sub    $0x8,%esp
80107143:	50                   	push   %eax
80107144:	68 f8 03 00 00       	push   $0x3f8
80107149:	e8 90 fe ff ff       	call   80106fde <outb>
8010714e:	83 c4 10             	add    $0x10,%esp
80107151:	eb 01                	jmp    80107154 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107153:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107154:	c9                   	leave  
80107155:	c3                   	ret    

80107156 <uartgetc>:

static int
uartgetc(void)
{
80107156:	55                   	push   %ebp
80107157:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107159:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
8010715e:	85 c0                	test   %eax,%eax
80107160:	75 07                	jne    80107169 <uartgetc+0x13>
    return -1;
80107162:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107167:	eb 2e                	jmp    80107197 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107169:	68 fd 03 00 00       	push   $0x3fd
8010716e:	e8 4e fe ff ff       	call   80106fc1 <inb>
80107173:	83 c4 04             	add    $0x4,%esp
80107176:	0f b6 c0             	movzbl %al,%eax
80107179:	83 e0 01             	and    $0x1,%eax
8010717c:	85 c0                	test   %eax,%eax
8010717e:	75 07                	jne    80107187 <uartgetc+0x31>
    return -1;
80107180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107185:	eb 10                	jmp    80107197 <uartgetc+0x41>
  return inb(COM1+0);
80107187:	68 f8 03 00 00       	push   $0x3f8
8010718c:	e8 30 fe ff ff       	call   80106fc1 <inb>
80107191:	83 c4 04             	add    $0x4,%esp
80107194:	0f b6 c0             	movzbl %al,%eax
}
80107197:	c9                   	leave  
80107198:	c3                   	ret    

80107199 <uartintr>:

void
uartintr(void)
{
80107199:	55                   	push   %ebp
8010719a:	89 e5                	mov    %esp,%ebp
8010719c:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010719f:	83 ec 0c             	sub    $0xc,%esp
801071a2:	68 56 71 10 80       	push   $0x80107156
801071a7:	e8 31 96 ff ff       	call   801007dd <consoleintr>
801071ac:	83 c4 10             	add    $0x10,%esp
}
801071af:	90                   	nop
801071b0:	c9                   	leave  
801071b1:	c3                   	ret    

801071b2 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $0
801071b4:	6a 00                	push   $0x0
  jmp alltraps
801071b6:	e9 ca f8 ff ff       	jmp    80106a85 <alltraps>

801071bb <vector1>:
.globl vector1
vector1:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $1
801071bd:	6a 01                	push   $0x1
  jmp alltraps
801071bf:	e9 c1 f8 ff ff       	jmp    80106a85 <alltraps>

801071c4 <vector2>:
.globl vector2
vector2:
  pushl $0
801071c4:	6a 00                	push   $0x0
  pushl $2
801071c6:	6a 02                	push   $0x2
  jmp alltraps
801071c8:	e9 b8 f8 ff ff       	jmp    80106a85 <alltraps>

801071cd <vector3>:
.globl vector3
vector3:
  pushl $0
801071cd:	6a 00                	push   $0x0
  pushl $3
801071cf:	6a 03                	push   $0x3
  jmp alltraps
801071d1:	e9 af f8 ff ff       	jmp    80106a85 <alltraps>

801071d6 <vector4>:
.globl vector4
vector4:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $4
801071d8:	6a 04                	push   $0x4
  jmp alltraps
801071da:	e9 a6 f8 ff ff       	jmp    80106a85 <alltraps>

801071df <vector5>:
.globl vector5
vector5:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $5
801071e1:	6a 05                	push   $0x5
  jmp alltraps
801071e3:	e9 9d f8 ff ff       	jmp    80106a85 <alltraps>

801071e8 <vector6>:
.globl vector6
vector6:
  pushl $0
801071e8:	6a 00                	push   $0x0
  pushl $6
801071ea:	6a 06                	push   $0x6
  jmp alltraps
801071ec:	e9 94 f8 ff ff       	jmp    80106a85 <alltraps>

801071f1 <vector7>:
.globl vector7
vector7:
  pushl $0
801071f1:	6a 00                	push   $0x0
  pushl $7
801071f3:	6a 07                	push   $0x7
  jmp alltraps
801071f5:	e9 8b f8 ff ff       	jmp    80106a85 <alltraps>

801071fa <vector8>:
.globl vector8
vector8:
  pushl $8
801071fa:	6a 08                	push   $0x8
  jmp alltraps
801071fc:	e9 84 f8 ff ff       	jmp    80106a85 <alltraps>

80107201 <vector9>:
.globl vector9
vector9:
  pushl $0
80107201:	6a 00                	push   $0x0
  pushl $9
80107203:	6a 09                	push   $0x9
  jmp alltraps
80107205:	e9 7b f8 ff ff       	jmp    80106a85 <alltraps>

8010720a <vector10>:
.globl vector10
vector10:
  pushl $10
8010720a:	6a 0a                	push   $0xa
  jmp alltraps
8010720c:	e9 74 f8 ff ff       	jmp    80106a85 <alltraps>

80107211 <vector11>:
.globl vector11
vector11:
  pushl $11
80107211:	6a 0b                	push   $0xb
  jmp alltraps
80107213:	e9 6d f8 ff ff       	jmp    80106a85 <alltraps>

80107218 <vector12>:
.globl vector12
vector12:
  pushl $12
80107218:	6a 0c                	push   $0xc
  jmp alltraps
8010721a:	e9 66 f8 ff ff       	jmp    80106a85 <alltraps>

8010721f <vector13>:
.globl vector13
vector13:
  pushl $13
8010721f:	6a 0d                	push   $0xd
  jmp alltraps
80107221:	e9 5f f8 ff ff       	jmp    80106a85 <alltraps>

80107226 <vector14>:
.globl vector14
vector14:
  pushl $14
80107226:	6a 0e                	push   $0xe
  jmp alltraps
80107228:	e9 58 f8 ff ff       	jmp    80106a85 <alltraps>

8010722d <vector15>:
.globl vector15
vector15:
  pushl $0
8010722d:	6a 00                	push   $0x0
  pushl $15
8010722f:	6a 0f                	push   $0xf
  jmp alltraps
80107231:	e9 4f f8 ff ff       	jmp    80106a85 <alltraps>

80107236 <vector16>:
.globl vector16
vector16:
  pushl $0
80107236:	6a 00                	push   $0x0
  pushl $16
80107238:	6a 10                	push   $0x10
  jmp alltraps
8010723a:	e9 46 f8 ff ff       	jmp    80106a85 <alltraps>

8010723f <vector17>:
.globl vector17
vector17:
  pushl $17
8010723f:	6a 11                	push   $0x11
  jmp alltraps
80107241:	e9 3f f8 ff ff       	jmp    80106a85 <alltraps>

80107246 <vector18>:
.globl vector18
vector18:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $18
80107248:	6a 12                	push   $0x12
  jmp alltraps
8010724a:	e9 36 f8 ff ff       	jmp    80106a85 <alltraps>

8010724f <vector19>:
.globl vector19
vector19:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $19
80107251:	6a 13                	push   $0x13
  jmp alltraps
80107253:	e9 2d f8 ff ff       	jmp    80106a85 <alltraps>

80107258 <vector20>:
.globl vector20
vector20:
  pushl $0
80107258:	6a 00                	push   $0x0
  pushl $20
8010725a:	6a 14                	push   $0x14
  jmp alltraps
8010725c:	e9 24 f8 ff ff       	jmp    80106a85 <alltraps>

80107261 <vector21>:
.globl vector21
vector21:
  pushl $0
80107261:	6a 00                	push   $0x0
  pushl $21
80107263:	6a 15                	push   $0x15
  jmp alltraps
80107265:	e9 1b f8 ff ff       	jmp    80106a85 <alltraps>

8010726a <vector22>:
.globl vector22
vector22:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $22
8010726c:	6a 16                	push   $0x16
  jmp alltraps
8010726e:	e9 12 f8 ff ff       	jmp    80106a85 <alltraps>

80107273 <vector23>:
.globl vector23
vector23:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $23
80107275:	6a 17                	push   $0x17
  jmp alltraps
80107277:	e9 09 f8 ff ff       	jmp    80106a85 <alltraps>

8010727c <vector24>:
.globl vector24
vector24:
  pushl $0
8010727c:	6a 00                	push   $0x0
  pushl $24
8010727e:	6a 18                	push   $0x18
  jmp alltraps
80107280:	e9 00 f8 ff ff       	jmp    80106a85 <alltraps>

80107285 <vector25>:
.globl vector25
vector25:
  pushl $0
80107285:	6a 00                	push   $0x0
  pushl $25
80107287:	6a 19                	push   $0x19
  jmp alltraps
80107289:	e9 f7 f7 ff ff       	jmp    80106a85 <alltraps>

8010728e <vector26>:
.globl vector26
vector26:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $26
80107290:	6a 1a                	push   $0x1a
  jmp alltraps
80107292:	e9 ee f7 ff ff       	jmp    80106a85 <alltraps>

80107297 <vector27>:
.globl vector27
vector27:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $27
80107299:	6a 1b                	push   $0x1b
  jmp alltraps
8010729b:	e9 e5 f7 ff ff       	jmp    80106a85 <alltraps>

801072a0 <vector28>:
.globl vector28
vector28:
  pushl $0
801072a0:	6a 00                	push   $0x0
  pushl $28
801072a2:	6a 1c                	push   $0x1c
  jmp alltraps
801072a4:	e9 dc f7 ff ff       	jmp    80106a85 <alltraps>

801072a9 <vector29>:
.globl vector29
vector29:
  pushl $0
801072a9:	6a 00                	push   $0x0
  pushl $29
801072ab:	6a 1d                	push   $0x1d
  jmp alltraps
801072ad:	e9 d3 f7 ff ff       	jmp    80106a85 <alltraps>

801072b2 <vector30>:
.globl vector30
vector30:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $30
801072b4:	6a 1e                	push   $0x1e
  jmp alltraps
801072b6:	e9 ca f7 ff ff       	jmp    80106a85 <alltraps>

801072bb <vector31>:
.globl vector31
vector31:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $31
801072bd:	6a 1f                	push   $0x1f
  jmp alltraps
801072bf:	e9 c1 f7 ff ff       	jmp    80106a85 <alltraps>

801072c4 <vector32>:
.globl vector32
vector32:
  pushl $0
801072c4:	6a 00                	push   $0x0
  pushl $32
801072c6:	6a 20                	push   $0x20
  jmp alltraps
801072c8:	e9 b8 f7 ff ff       	jmp    80106a85 <alltraps>

801072cd <vector33>:
.globl vector33
vector33:
  pushl $0
801072cd:	6a 00                	push   $0x0
  pushl $33
801072cf:	6a 21                	push   $0x21
  jmp alltraps
801072d1:	e9 af f7 ff ff       	jmp    80106a85 <alltraps>

801072d6 <vector34>:
.globl vector34
vector34:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $34
801072d8:	6a 22                	push   $0x22
  jmp alltraps
801072da:	e9 a6 f7 ff ff       	jmp    80106a85 <alltraps>

801072df <vector35>:
.globl vector35
vector35:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $35
801072e1:	6a 23                	push   $0x23
  jmp alltraps
801072e3:	e9 9d f7 ff ff       	jmp    80106a85 <alltraps>

801072e8 <vector36>:
.globl vector36
vector36:
  pushl $0
801072e8:	6a 00                	push   $0x0
  pushl $36
801072ea:	6a 24                	push   $0x24
  jmp alltraps
801072ec:	e9 94 f7 ff ff       	jmp    80106a85 <alltraps>

801072f1 <vector37>:
.globl vector37
vector37:
  pushl $0
801072f1:	6a 00                	push   $0x0
  pushl $37
801072f3:	6a 25                	push   $0x25
  jmp alltraps
801072f5:	e9 8b f7 ff ff       	jmp    80106a85 <alltraps>

801072fa <vector38>:
.globl vector38
vector38:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $38
801072fc:	6a 26                	push   $0x26
  jmp alltraps
801072fe:	e9 82 f7 ff ff       	jmp    80106a85 <alltraps>

80107303 <vector39>:
.globl vector39
vector39:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $39
80107305:	6a 27                	push   $0x27
  jmp alltraps
80107307:	e9 79 f7 ff ff       	jmp    80106a85 <alltraps>

8010730c <vector40>:
.globl vector40
vector40:
  pushl $0
8010730c:	6a 00                	push   $0x0
  pushl $40
8010730e:	6a 28                	push   $0x28
  jmp alltraps
80107310:	e9 70 f7 ff ff       	jmp    80106a85 <alltraps>

80107315 <vector41>:
.globl vector41
vector41:
  pushl $0
80107315:	6a 00                	push   $0x0
  pushl $41
80107317:	6a 29                	push   $0x29
  jmp alltraps
80107319:	e9 67 f7 ff ff       	jmp    80106a85 <alltraps>

8010731e <vector42>:
.globl vector42
vector42:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $42
80107320:	6a 2a                	push   $0x2a
  jmp alltraps
80107322:	e9 5e f7 ff ff       	jmp    80106a85 <alltraps>

80107327 <vector43>:
.globl vector43
vector43:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $43
80107329:	6a 2b                	push   $0x2b
  jmp alltraps
8010732b:	e9 55 f7 ff ff       	jmp    80106a85 <alltraps>

80107330 <vector44>:
.globl vector44
vector44:
  pushl $0
80107330:	6a 00                	push   $0x0
  pushl $44
80107332:	6a 2c                	push   $0x2c
  jmp alltraps
80107334:	e9 4c f7 ff ff       	jmp    80106a85 <alltraps>

80107339 <vector45>:
.globl vector45
vector45:
  pushl $0
80107339:	6a 00                	push   $0x0
  pushl $45
8010733b:	6a 2d                	push   $0x2d
  jmp alltraps
8010733d:	e9 43 f7 ff ff       	jmp    80106a85 <alltraps>

80107342 <vector46>:
.globl vector46
vector46:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $46
80107344:	6a 2e                	push   $0x2e
  jmp alltraps
80107346:	e9 3a f7 ff ff       	jmp    80106a85 <alltraps>

8010734b <vector47>:
.globl vector47
vector47:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $47
8010734d:	6a 2f                	push   $0x2f
  jmp alltraps
8010734f:	e9 31 f7 ff ff       	jmp    80106a85 <alltraps>

80107354 <vector48>:
.globl vector48
vector48:
  pushl $0
80107354:	6a 00                	push   $0x0
  pushl $48
80107356:	6a 30                	push   $0x30
  jmp alltraps
80107358:	e9 28 f7 ff ff       	jmp    80106a85 <alltraps>

8010735d <vector49>:
.globl vector49
vector49:
  pushl $0
8010735d:	6a 00                	push   $0x0
  pushl $49
8010735f:	6a 31                	push   $0x31
  jmp alltraps
80107361:	e9 1f f7 ff ff       	jmp    80106a85 <alltraps>

80107366 <vector50>:
.globl vector50
vector50:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $50
80107368:	6a 32                	push   $0x32
  jmp alltraps
8010736a:	e9 16 f7 ff ff       	jmp    80106a85 <alltraps>

8010736f <vector51>:
.globl vector51
vector51:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $51
80107371:	6a 33                	push   $0x33
  jmp alltraps
80107373:	e9 0d f7 ff ff       	jmp    80106a85 <alltraps>

80107378 <vector52>:
.globl vector52
vector52:
  pushl $0
80107378:	6a 00                	push   $0x0
  pushl $52
8010737a:	6a 34                	push   $0x34
  jmp alltraps
8010737c:	e9 04 f7 ff ff       	jmp    80106a85 <alltraps>

80107381 <vector53>:
.globl vector53
vector53:
  pushl $0
80107381:	6a 00                	push   $0x0
  pushl $53
80107383:	6a 35                	push   $0x35
  jmp alltraps
80107385:	e9 fb f6 ff ff       	jmp    80106a85 <alltraps>

8010738a <vector54>:
.globl vector54
vector54:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $54
8010738c:	6a 36                	push   $0x36
  jmp alltraps
8010738e:	e9 f2 f6 ff ff       	jmp    80106a85 <alltraps>

80107393 <vector55>:
.globl vector55
vector55:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $55
80107395:	6a 37                	push   $0x37
  jmp alltraps
80107397:	e9 e9 f6 ff ff       	jmp    80106a85 <alltraps>

8010739c <vector56>:
.globl vector56
vector56:
  pushl $0
8010739c:	6a 00                	push   $0x0
  pushl $56
8010739e:	6a 38                	push   $0x38
  jmp alltraps
801073a0:	e9 e0 f6 ff ff       	jmp    80106a85 <alltraps>

801073a5 <vector57>:
.globl vector57
vector57:
  pushl $0
801073a5:	6a 00                	push   $0x0
  pushl $57
801073a7:	6a 39                	push   $0x39
  jmp alltraps
801073a9:	e9 d7 f6 ff ff       	jmp    80106a85 <alltraps>

801073ae <vector58>:
.globl vector58
vector58:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $58
801073b0:	6a 3a                	push   $0x3a
  jmp alltraps
801073b2:	e9 ce f6 ff ff       	jmp    80106a85 <alltraps>

801073b7 <vector59>:
.globl vector59
vector59:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $59
801073b9:	6a 3b                	push   $0x3b
  jmp alltraps
801073bb:	e9 c5 f6 ff ff       	jmp    80106a85 <alltraps>

801073c0 <vector60>:
.globl vector60
vector60:
  pushl $0
801073c0:	6a 00                	push   $0x0
  pushl $60
801073c2:	6a 3c                	push   $0x3c
  jmp alltraps
801073c4:	e9 bc f6 ff ff       	jmp    80106a85 <alltraps>

801073c9 <vector61>:
.globl vector61
vector61:
  pushl $0
801073c9:	6a 00                	push   $0x0
  pushl $61
801073cb:	6a 3d                	push   $0x3d
  jmp alltraps
801073cd:	e9 b3 f6 ff ff       	jmp    80106a85 <alltraps>

801073d2 <vector62>:
.globl vector62
vector62:
  pushl $0
801073d2:	6a 00                	push   $0x0
  pushl $62
801073d4:	6a 3e                	push   $0x3e
  jmp alltraps
801073d6:	e9 aa f6 ff ff       	jmp    80106a85 <alltraps>

801073db <vector63>:
.globl vector63
vector63:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $63
801073dd:	6a 3f                	push   $0x3f
  jmp alltraps
801073df:	e9 a1 f6 ff ff       	jmp    80106a85 <alltraps>

801073e4 <vector64>:
.globl vector64
vector64:
  pushl $0
801073e4:	6a 00                	push   $0x0
  pushl $64
801073e6:	6a 40                	push   $0x40
  jmp alltraps
801073e8:	e9 98 f6 ff ff       	jmp    80106a85 <alltraps>

801073ed <vector65>:
.globl vector65
vector65:
  pushl $0
801073ed:	6a 00                	push   $0x0
  pushl $65
801073ef:	6a 41                	push   $0x41
  jmp alltraps
801073f1:	e9 8f f6 ff ff       	jmp    80106a85 <alltraps>

801073f6 <vector66>:
.globl vector66
vector66:
  pushl $0
801073f6:	6a 00                	push   $0x0
  pushl $66
801073f8:	6a 42                	push   $0x42
  jmp alltraps
801073fa:	e9 86 f6 ff ff       	jmp    80106a85 <alltraps>

801073ff <vector67>:
.globl vector67
vector67:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $67
80107401:	6a 43                	push   $0x43
  jmp alltraps
80107403:	e9 7d f6 ff ff       	jmp    80106a85 <alltraps>

80107408 <vector68>:
.globl vector68
vector68:
  pushl $0
80107408:	6a 00                	push   $0x0
  pushl $68
8010740a:	6a 44                	push   $0x44
  jmp alltraps
8010740c:	e9 74 f6 ff ff       	jmp    80106a85 <alltraps>

80107411 <vector69>:
.globl vector69
vector69:
  pushl $0
80107411:	6a 00                	push   $0x0
  pushl $69
80107413:	6a 45                	push   $0x45
  jmp alltraps
80107415:	e9 6b f6 ff ff       	jmp    80106a85 <alltraps>

8010741a <vector70>:
.globl vector70
vector70:
  pushl $0
8010741a:	6a 00                	push   $0x0
  pushl $70
8010741c:	6a 46                	push   $0x46
  jmp alltraps
8010741e:	e9 62 f6 ff ff       	jmp    80106a85 <alltraps>

80107423 <vector71>:
.globl vector71
vector71:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $71
80107425:	6a 47                	push   $0x47
  jmp alltraps
80107427:	e9 59 f6 ff ff       	jmp    80106a85 <alltraps>

8010742c <vector72>:
.globl vector72
vector72:
  pushl $0
8010742c:	6a 00                	push   $0x0
  pushl $72
8010742e:	6a 48                	push   $0x48
  jmp alltraps
80107430:	e9 50 f6 ff ff       	jmp    80106a85 <alltraps>

80107435 <vector73>:
.globl vector73
vector73:
  pushl $0
80107435:	6a 00                	push   $0x0
  pushl $73
80107437:	6a 49                	push   $0x49
  jmp alltraps
80107439:	e9 47 f6 ff ff       	jmp    80106a85 <alltraps>

8010743e <vector74>:
.globl vector74
vector74:
  pushl $0
8010743e:	6a 00                	push   $0x0
  pushl $74
80107440:	6a 4a                	push   $0x4a
  jmp alltraps
80107442:	e9 3e f6 ff ff       	jmp    80106a85 <alltraps>

80107447 <vector75>:
.globl vector75
vector75:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $75
80107449:	6a 4b                	push   $0x4b
  jmp alltraps
8010744b:	e9 35 f6 ff ff       	jmp    80106a85 <alltraps>

80107450 <vector76>:
.globl vector76
vector76:
  pushl $0
80107450:	6a 00                	push   $0x0
  pushl $76
80107452:	6a 4c                	push   $0x4c
  jmp alltraps
80107454:	e9 2c f6 ff ff       	jmp    80106a85 <alltraps>

80107459 <vector77>:
.globl vector77
vector77:
  pushl $0
80107459:	6a 00                	push   $0x0
  pushl $77
8010745b:	6a 4d                	push   $0x4d
  jmp alltraps
8010745d:	e9 23 f6 ff ff       	jmp    80106a85 <alltraps>

80107462 <vector78>:
.globl vector78
vector78:
  pushl $0
80107462:	6a 00                	push   $0x0
  pushl $78
80107464:	6a 4e                	push   $0x4e
  jmp alltraps
80107466:	e9 1a f6 ff ff       	jmp    80106a85 <alltraps>

8010746b <vector79>:
.globl vector79
vector79:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $79
8010746d:	6a 4f                	push   $0x4f
  jmp alltraps
8010746f:	e9 11 f6 ff ff       	jmp    80106a85 <alltraps>

80107474 <vector80>:
.globl vector80
vector80:
  pushl $0
80107474:	6a 00                	push   $0x0
  pushl $80
80107476:	6a 50                	push   $0x50
  jmp alltraps
80107478:	e9 08 f6 ff ff       	jmp    80106a85 <alltraps>

8010747d <vector81>:
.globl vector81
vector81:
  pushl $0
8010747d:	6a 00                	push   $0x0
  pushl $81
8010747f:	6a 51                	push   $0x51
  jmp alltraps
80107481:	e9 ff f5 ff ff       	jmp    80106a85 <alltraps>

80107486 <vector82>:
.globl vector82
vector82:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $82
80107488:	6a 52                	push   $0x52
  jmp alltraps
8010748a:	e9 f6 f5 ff ff       	jmp    80106a85 <alltraps>

8010748f <vector83>:
.globl vector83
vector83:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $83
80107491:	6a 53                	push   $0x53
  jmp alltraps
80107493:	e9 ed f5 ff ff       	jmp    80106a85 <alltraps>

80107498 <vector84>:
.globl vector84
vector84:
  pushl $0
80107498:	6a 00                	push   $0x0
  pushl $84
8010749a:	6a 54                	push   $0x54
  jmp alltraps
8010749c:	e9 e4 f5 ff ff       	jmp    80106a85 <alltraps>

801074a1 <vector85>:
.globl vector85
vector85:
  pushl $0
801074a1:	6a 00                	push   $0x0
  pushl $85
801074a3:	6a 55                	push   $0x55
  jmp alltraps
801074a5:	e9 db f5 ff ff       	jmp    80106a85 <alltraps>

801074aa <vector86>:
.globl vector86
vector86:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $86
801074ac:	6a 56                	push   $0x56
  jmp alltraps
801074ae:	e9 d2 f5 ff ff       	jmp    80106a85 <alltraps>

801074b3 <vector87>:
.globl vector87
vector87:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $87
801074b5:	6a 57                	push   $0x57
  jmp alltraps
801074b7:	e9 c9 f5 ff ff       	jmp    80106a85 <alltraps>

801074bc <vector88>:
.globl vector88
vector88:
  pushl $0
801074bc:	6a 00                	push   $0x0
  pushl $88
801074be:	6a 58                	push   $0x58
  jmp alltraps
801074c0:	e9 c0 f5 ff ff       	jmp    80106a85 <alltraps>

801074c5 <vector89>:
.globl vector89
vector89:
  pushl $0
801074c5:	6a 00                	push   $0x0
  pushl $89
801074c7:	6a 59                	push   $0x59
  jmp alltraps
801074c9:	e9 b7 f5 ff ff       	jmp    80106a85 <alltraps>

801074ce <vector90>:
.globl vector90
vector90:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $90
801074d0:	6a 5a                	push   $0x5a
  jmp alltraps
801074d2:	e9 ae f5 ff ff       	jmp    80106a85 <alltraps>

801074d7 <vector91>:
.globl vector91
vector91:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $91
801074d9:	6a 5b                	push   $0x5b
  jmp alltraps
801074db:	e9 a5 f5 ff ff       	jmp    80106a85 <alltraps>

801074e0 <vector92>:
.globl vector92
vector92:
  pushl $0
801074e0:	6a 00                	push   $0x0
  pushl $92
801074e2:	6a 5c                	push   $0x5c
  jmp alltraps
801074e4:	e9 9c f5 ff ff       	jmp    80106a85 <alltraps>

801074e9 <vector93>:
.globl vector93
vector93:
  pushl $0
801074e9:	6a 00                	push   $0x0
  pushl $93
801074eb:	6a 5d                	push   $0x5d
  jmp alltraps
801074ed:	e9 93 f5 ff ff       	jmp    80106a85 <alltraps>

801074f2 <vector94>:
.globl vector94
vector94:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $94
801074f4:	6a 5e                	push   $0x5e
  jmp alltraps
801074f6:	e9 8a f5 ff ff       	jmp    80106a85 <alltraps>

801074fb <vector95>:
.globl vector95
vector95:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $95
801074fd:	6a 5f                	push   $0x5f
  jmp alltraps
801074ff:	e9 81 f5 ff ff       	jmp    80106a85 <alltraps>

80107504 <vector96>:
.globl vector96
vector96:
  pushl $0
80107504:	6a 00                	push   $0x0
  pushl $96
80107506:	6a 60                	push   $0x60
  jmp alltraps
80107508:	e9 78 f5 ff ff       	jmp    80106a85 <alltraps>

8010750d <vector97>:
.globl vector97
vector97:
  pushl $0
8010750d:	6a 00                	push   $0x0
  pushl $97
8010750f:	6a 61                	push   $0x61
  jmp alltraps
80107511:	e9 6f f5 ff ff       	jmp    80106a85 <alltraps>

80107516 <vector98>:
.globl vector98
vector98:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $98
80107518:	6a 62                	push   $0x62
  jmp alltraps
8010751a:	e9 66 f5 ff ff       	jmp    80106a85 <alltraps>

8010751f <vector99>:
.globl vector99
vector99:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $99
80107521:	6a 63                	push   $0x63
  jmp alltraps
80107523:	e9 5d f5 ff ff       	jmp    80106a85 <alltraps>

80107528 <vector100>:
.globl vector100
vector100:
  pushl $0
80107528:	6a 00                	push   $0x0
  pushl $100
8010752a:	6a 64                	push   $0x64
  jmp alltraps
8010752c:	e9 54 f5 ff ff       	jmp    80106a85 <alltraps>

80107531 <vector101>:
.globl vector101
vector101:
  pushl $0
80107531:	6a 00                	push   $0x0
  pushl $101
80107533:	6a 65                	push   $0x65
  jmp alltraps
80107535:	e9 4b f5 ff ff       	jmp    80106a85 <alltraps>

8010753a <vector102>:
.globl vector102
vector102:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $102
8010753c:	6a 66                	push   $0x66
  jmp alltraps
8010753e:	e9 42 f5 ff ff       	jmp    80106a85 <alltraps>

80107543 <vector103>:
.globl vector103
vector103:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $103
80107545:	6a 67                	push   $0x67
  jmp alltraps
80107547:	e9 39 f5 ff ff       	jmp    80106a85 <alltraps>

8010754c <vector104>:
.globl vector104
vector104:
  pushl $0
8010754c:	6a 00                	push   $0x0
  pushl $104
8010754e:	6a 68                	push   $0x68
  jmp alltraps
80107550:	e9 30 f5 ff ff       	jmp    80106a85 <alltraps>

80107555 <vector105>:
.globl vector105
vector105:
  pushl $0
80107555:	6a 00                	push   $0x0
  pushl $105
80107557:	6a 69                	push   $0x69
  jmp alltraps
80107559:	e9 27 f5 ff ff       	jmp    80106a85 <alltraps>

8010755e <vector106>:
.globl vector106
vector106:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $106
80107560:	6a 6a                	push   $0x6a
  jmp alltraps
80107562:	e9 1e f5 ff ff       	jmp    80106a85 <alltraps>

80107567 <vector107>:
.globl vector107
vector107:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $107
80107569:	6a 6b                	push   $0x6b
  jmp alltraps
8010756b:	e9 15 f5 ff ff       	jmp    80106a85 <alltraps>

80107570 <vector108>:
.globl vector108
vector108:
  pushl $0
80107570:	6a 00                	push   $0x0
  pushl $108
80107572:	6a 6c                	push   $0x6c
  jmp alltraps
80107574:	e9 0c f5 ff ff       	jmp    80106a85 <alltraps>

80107579 <vector109>:
.globl vector109
vector109:
  pushl $0
80107579:	6a 00                	push   $0x0
  pushl $109
8010757b:	6a 6d                	push   $0x6d
  jmp alltraps
8010757d:	e9 03 f5 ff ff       	jmp    80106a85 <alltraps>

80107582 <vector110>:
.globl vector110
vector110:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $110
80107584:	6a 6e                	push   $0x6e
  jmp alltraps
80107586:	e9 fa f4 ff ff       	jmp    80106a85 <alltraps>

8010758b <vector111>:
.globl vector111
vector111:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $111
8010758d:	6a 6f                	push   $0x6f
  jmp alltraps
8010758f:	e9 f1 f4 ff ff       	jmp    80106a85 <alltraps>

80107594 <vector112>:
.globl vector112
vector112:
  pushl $0
80107594:	6a 00                	push   $0x0
  pushl $112
80107596:	6a 70                	push   $0x70
  jmp alltraps
80107598:	e9 e8 f4 ff ff       	jmp    80106a85 <alltraps>

8010759d <vector113>:
.globl vector113
vector113:
  pushl $0
8010759d:	6a 00                	push   $0x0
  pushl $113
8010759f:	6a 71                	push   $0x71
  jmp alltraps
801075a1:	e9 df f4 ff ff       	jmp    80106a85 <alltraps>

801075a6 <vector114>:
.globl vector114
vector114:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $114
801075a8:	6a 72                	push   $0x72
  jmp alltraps
801075aa:	e9 d6 f4 ff ff       	jmp    80106a85 <alltraps>

801075af <vector115>:
.globl vector115
vector115:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $115
801075b1:	6a 73                	push   $0x73
  jmp alltraps
801075b3:	e9 cd f4 ff ff       	jmp    80106a85 <alltraps>

801075b8 <vector116>:
.globl vector116
vector116:
  pushl $0
801075b8:	6a 00                	push   $0x0
  pushl $116
801075ba:	6a 74                	push   $0x74
  jmp alltraps
801075bc:	e9 c4 f4 ff ff       	jmp    80106a85 <alltraps>

801075c1 <vector117>:
.globl vector117
vector117:
  pushl $0
801075c1:	6a 00                	push   $0x0
  pushl $117
801075c3:	6a 75                	push   $0x75
  jmp alltraps
801075c5:	e9 bb f4 ff ff       	jmp    80106a85 <alltraps>

801075ca <vector118>:
.globl vector118
vector118:
  pushl $0
801075ca:	6a 00                	push   $0x0
  pushl $118
801075cc:	6a 76                	push   $0x76
  jmp alltraps
801075ce:	e9 b2 f4 ff ff       	jmp    80106a85 <alltraps>

801075d3 <vector119>:
.globl vector119
vector119:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $119
801075d5:	6a 77                	push   $0x77
  jmp alltraps
801075d7:	e9 a9 f4 ff ff       	jmp    80106a85 <alltraps>

801075dc <vector120>:
.globl vector120
vector120:
  pushl $0
801075dc:	6a 00                	push   $0x0
  pushl $120
801075de:	6a 78                	push   $0x78
  jmp alltraps
801075e0:	e9 a0 f4 ff ff       	jmp    80106a85 <alltraps>

801075e5 <vector121>:
.globl vector121
vector121:
  pushl $0
801075e5:	6a 00                	push   $0x0
  pushl $121
801075e7:	6a 79                	push   $0x79
  jmp alltraps
801075e9:	e9 97 f4 ff ff       	jmp    80106a85 <alltraps>

801075ee <vector122>:
.globl vector122
vector122:
  pushl $0
801075ee:	6a 00                	push   $0x0
  pushl $122
801075f0:	6a 7a                	push   $0x7a
  jmp alltraps
801075f2:	e9 8e f4 ff ff       	jmp    80106a85 <alltraps>

801075f7 <vector123>:
.globl vector123
vector123:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $123
801075f9:	6a 7b                	push   $0x7b
  jmp alltraps
801075fb:	e9 85 f4 ff ff       	jmp    80106a85 <alltraps>

80107600 <vector124>:
.globl vector124
vector124:
  pushl $0
80107600:	6a 00                	push   $0x0
  pushl $124
80107602:	6a 7c                	push   $0x7c
  jmp alltraps
80107604:	e9 7c f4 ff ff       	jmp    80106a85 <alltraps>

80107609 <vector125>:
.globl vector125
vector125:
  pushl $0
80107609:	6a 00                	push   $0x0
  pushl $125
8010760b:	6a 7d                	push   $0x7d
  jmp alltraps
8010760d:	e9 73 f4 ff ff       	jmp    80106a85 <alltraps>

80107612 <vector126>:
.globl vector126
vector126:
  pushl $0
80107612:	6a 00                	push   $0x0
  pushl $126
80107614:	6a 7e                	push   $0x7e
  jmp alltraps
80107616:	e9 6a f4 ff ff       	jmp    80106a85 <alltraps>

8010761b <vector127>:
.globl vector127
vector127:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $127
8010761d:	6a 7f                	push   $0x7f
  jmp alltraps
8010761f:	e9 61 f4 ff ff       	jmp    80106a85 <alltraps>

80107624 <vector128>:
.globl vector128
vector128:
  pushl $0
80107624:	6a 00                	push   $0x0
  pushl $128
80107626:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010762b:	e9 55 f4 ff ff       	jmp    80106a85 <alltraps>

80107630 <vector129>:
.globl vector129
vector129:
  pushl $0
80107630:	6a 00                	push   $0x0
  pushl $129
80107632:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107637:	e9 49 f4 ff ff       	jmp    80106a85 <alltraps>

8010763c <vector130>:
.globl vector130
vector130:
  pushl $0
8010763c:	6a 00                	push   $0x0
  pushl $130
8010763e:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107643:	e9 3d f4 ff ff       	jmp    80106a85 <alltraps>

80107648 <vector131>:
.globl vector131
vector131:
  pushl $0
80107648:	6a 00                	push   $0x0
  pushl $131
8010764a:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010764f:	e9 31 f4 ff ff       	jmp    80106a85 <alltraps>

80107654 <vector132>:
.globl vector132
vector132:
  pushl $0
80107654:	6a 00                	push   $0x0
  pushl $132
80107656:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010765b:	e9 25 f4 ff ff       	jmp    80106a85 <alltraps>

80107660 <vector133>:
.globl vector133
vector133:
  pushl $0
80107660:	6a 00                	push   $0x0
  pushl $133
80107662:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107667:	e9 19 f4 ff ff       	jmp    80106a85 <alltraps>

8010766c <vector134>:
.globl vector134
vector134:
  pushl $0
8010766c:	6a 00                	push   $0x0
  pushl $134
8010766e:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107673:	e9 0d f4 ff ff       	jmp    80106a85 <alltraps>

80107678 <vector135>:
.globl vector135
vector135:
  pushl $0
80107678:	6a 00                	push   $0x0
  pushl $135
8010767a:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010767f:	e9 01 f4 ff ff       	jmp    80106a85 <alltraps>

80107684 <vector136>:
.globl vector136
vector136:
  pushl $0
80107684:	6a 00                	push   $0x0
  pushl $136
80107686:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010768b:	e9 f5 f3 ff ff       	jmp    80106a85 <alltraps>

80107690 <vector137>:
.globl vector137
vector137:
  pushl $0
80107690:	6a 00                	push   $0x0
  pushl $137
80107692:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107697:	e9 e9 f3 ff ff       	jmp    80106a85 <alltraps>

8010769c <vector138>:
.globl vector138
vector138:
  pushl $0
8010769c:	6a 00                	push   $0x0
  pushl $138
8010769e:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801076a3:	e9 dd f3 ff ff       	jmp    80106a85 <alltraps>

801076a8 <vector139>:
.globl vector139
vector139:
  pushl $0
801076a8:	6a 00                	push   $0x0
  pushl $139
801076aa:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801076af:	e9 d1 f3 ff ff       	jmp    80106a85 <alltraps>

801076b4 <vector140>:
.globl vector140
vector140:
  pushl $0
801076b4:	6a 00                	push   $0x0
  pushl $140
801076b6:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801076bb:	e9 c5 f3 ff ff       	jmp    80106a85 <alltraps>

801076c0 <vector141>:
.globl vector141
vector141:
  pushl $0
801076c0:	6a 00                	push   $0x0
  pushl $141
801076c2:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801076c7:	e9 b9 f3 ff ff       	jmp    80106a85 <alltraps>

801076cc <vector142>:
.globl vector142
vector142:
  pushl $0
801076cc:	6a 00                	push   $0x0
  pushl $142
801076ce:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801076d3:	e9 ad f3 ff ff       	jmp    80106a85 <alltraps>

801076d8 <vector143>:
.globl vector143
vector143:
  pushl $0
801076d8:	6a 00                	push   $0x0
  pushl $143
801076da:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801076df:	e9 a1 f3 ff ff       	jmp    80106a85 <alltraps>

801076e4 <vector144>:
.globl vector144
vector144:
  pushl $0
801076e4:	6a 00                	push   $0x0
  pushl $144
801076e6:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801076eb:	e9 95 f3 ff ff       	jmp    80106a85 <alltraps>

801076f0 <vector145>:
.globl vector145
vector145:
  pushl $0
801076f0:	6a 00                	push   $0x0
  pushl $145
801076f2:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801076f7:	e9 89 f3 ff ff       	jmp    80106a85 <alltraps>

801076fc <vector146>:
.globl vector146
vector146:
  pushl $0
801076fc:	6a 00                	push   $0x0
  pushl $146
801076fe:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107703:	e9 7d f3 ff ff       	jmp    80106a85 <alltraps>

80107708 <vector147>:
.globl vector147
vector147:
  pushl $0
80107708:	6a 00                	push   $0x0
  pushl $147
8010770a:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010770f:	e9 71 f3 ff ff       	jmp    80106a85 <alltraps>

80107714 <vector148>:
.globl vector148
vector148:
  pushl $0
80107714:	6a 00                	push   $0x0
  pushl $148
80107716:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010771b:	e9 65 f3 ff ff       	jmp    80106a85 <alltraps>

80107720 <vector149>:
.globl vector149
vector149:
  pushl $0
80107720:	6a 00                	push   $0x0
  pushl $149
80107722:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107727:	e9 59 f3 ff ff       	jmp    80106a85 <alltraps>

8010772c <vector150>:
.globl vector150
vector150:
  pushl $0
8010772c:	6a 00                	push   $0x0
  pushl $150
8010772e:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107733:	e9 4d f3 ff ff       	jmp    80106a85 <alltraps>

80107738 <vector151>:
.globl vector151
vector151:
  pushl $0
80107738:	6a 00                	push   $0x0
  pushl $151
8010773a:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010773f:	e9 41 f3 ff ff       	jmp    80106a85 <alltraps>

80107744 <vector152>:
.globl vector152
vector152:
  pushl $0
80107744:	6a 00                	push   $0x0
  pushl $152
80107746:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010774b:	e9 35 f3 ff ff       	jmp    80106a85 <alltraps>

80107750 <vector153>:
.globl vector153
vector153:
  pushl $0
80107750:	6a 00                	push   $0x0
  pushl $153
80107752:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107757:	e9 29 f3 ff ff       	jmp    80106a85 <alltraps>

8010775c <vector154>:
.globl vector154
vector154:
  pushl $0
8010775c:	6a 00                	push   $0x0
  pushl $154
8010775e:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107763:	e9 1d f3 ff ff       	jmp    80106a85 <alltraps>

80107768 <vector155>:
.globl vector155
vector155:
  pushl $0
80107768:	6a 00                	push   $0x0
  pushl $155
8010776a:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010776f:	e9 11 f3 ff ff       	jmp    80106a85 <alltraps>

80107774 <vector156>:
.globl vector156
vector156:
  pushl $0
80107774:	6a 00                	push   $0x0
  pushl $156
80107776:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010777b:	e9 05 f3 ff ff       	jmp    80106a85 <alltraps>

80107780 <vector157>:
.globl vector157
vector157:
  pushl $0
80107780:	6a 00                	push   $0x0
  pushl $157
80107782:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107787:	e9 f9 f2 ff ff       	jmp    80106a85 <alltraps>

8010778c <vector158>:
.globl vector158
vector158:
  pushl $0
8010778c:	6a 00                	push   $0x0
  pushl $158
8010778e:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107793:	e9 ed f2 ff ff       	jmp    80106a85 <alltraps>

80107798 <vector159>:
.globl vector159
vector159:
  pushl $0
80107798:	6a 00                	push   $0x0
  pushl $159
8010779a:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010779f:	e9 e1 f2 ff ff       	jmp    80106a85 <alltraps>

801077a4 <vector160>:
.globl vector160
vector160:
  pushl $0
801077a4:	6a 00                	push   $0x0
  pushl $160
801077a6:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801077ab:	e9 d5 f2 ff ff       	jmp    80106a85 <alltraps>

801077b0 <vector161>:
.globl vector161
vector161:
  pushl $0
801077b0:	6a 00                	push   $0x0
  pushl $161
801077b2:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801077b7:	e9 c9 f2 ff ff       	jmp    80106a85 <alltraps>

801077bc <vector162>:
.globl vector162
vector162:
  pushl $0
801077bc:	6a 00                	push   $0x0
  pushl $162
801077be:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801077c3:	e9 bd f2 ff ff       	jmp    80106a85 <alltraps>

801077c8 <vector163>:
.globl vector163
vector163:
  pushl $0
801077c8:	6a 00                	push   $0x0
  pushl $163
801077ca:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801077cf:	e9 b1 f2 ff ff       	jmp    80106a85 <alltraps>

801077d4 <vector164>:
.globl vector164
vector164:
  pushl $0
801077d4:	6a 00                	push   $0x0
  pushl $164
801077d6:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801077db:	e9 a5 f2 ff ff       	jmp    80106a85 <alltraps>

801077e0 <vector165>:
.globl vector165
vector165:
  pushl $0
801077e0:	6a 00                	push   $0x0
  pushl $165
801077e2:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801077e7:	e9 99 f2 ff ff       	jmp    80106a85 <alltraps>

801077ec <vector166>:
.globl vector166
vector166:
  pushl $0
801077ec:	6a 00                	push   $0x0
  pushl $166
801077ee:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801077f3:	e9 8d f2 ff ff       	jmp    80106a85 <alltraps>

801077f8 <vector167>:
.globl vector167
vector167:
  pushl $0
801077f8:	6a 00                	push   $0x0
  pushl $167
801077fa:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801077ff:	e9 81 f2 ff ff       	jmp    80106a85 <alltraps>

80107804 <vector168>:
.globl vector168
vector168:
  pushl $0
80107804:	6a 00                	push   $0x0
  pushl $168
80107806:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010780b:	e9 75 f2 ff ff       	jmp    80106a85 <alltraps>

80107810 <vector169>:
.globl vector169
vector169:
  pushl $0
80107810:	6a 00                	push   $0x0
  pushl $169
80107812:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107817:	e9 69 f2 ff ff       	jmp    80106a85 <alltraps>

8010781c <vector170>:
.globl vector170
vector170:
  pushl $0
8010781c:	6a 00                	push   $0x0
  pushl $170
8010781e:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107823:	e9 5d f2 ff ff       	jmp    80106a85 <alltraps>

80107828 <vector171>:
.globl vector171
vector171:
  pushl $0
80107828:	6a 00                	push   $0x0
  pushl $171
8010782a:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010782f:	e9 51 f2 ff ff       	jmp    80106a85 <alltraps>

80107834 <vector172>:
.globl vector172
vector172:
  pushl $0
80107834:	6a 00                	push   $0x0
  pushl $172
80107836:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010783b:	e9 45 f2 ff ff       	jmp    80106a85 <alltraps>

80107840 <vector173>:
.globl vector173
vector173:
  pushl $0
80107840:	6a 00                	push   $0x0
  pushl $173
80107842:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107847:	e9 39 f2 ff ff       	jmp    80106a85 <alltraps>

8010784c <vector174>:
.globl vector174
vector174:
  pushl $0
8010784c:	6a 00                	push   $0x0
  pushl $174
8010784e:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107853:	e9 2d f2 ff ff       	jmp    80106a85 <alltraps>

80107858 <vector175>:
.globl vector175
vector175:
  pushl $0
80107858:	6a 00                	push   $0x0
  pushl $175
8010785a:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010785f:	e9 21 f2 ff ff       	jmp    80106a85 <alltraps>

80107864 <vector176>:
.globl vector176
vector176:
  pushl $0
80107864:	6a 00                	push   $0x0
  pushl $176
80107866:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010786b:	e9 15 f2 ff ff       	jmp    80106a85 <alltraps>

80107870 <vector177>:
.globl vector177
vector177:
  pushl $0
80107870:	6a 00                	push   $0x0
  pushl $177
80107872:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107877:	e9 09 f2 ff ff       	jmp    80106a85 <alltraps>

8010787c <vector178>:
.globl vector178
vector178:
  pushl $0
8010787c:	6a 00                	push   $0x0
  pushl $178
8010787e:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107883:	e9 fd f1 ff ff       	jmp    80106a85 <alltraps>

80107888 <vector179>:
.globl vector179
vector179:
  pushl $0
80107888:	6a 00                	push   $0x0
  pushl $179
8010788a:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010788f:	e9 f1 f1 ff ff       	jmp    80106a85 <alltraps>

80107894 <vector180>:
.globl vector180
vector180:
  pushl $0
80107894:	6a 00                	push   $0x0
  pushl $180
80107896:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010789b:	e9 e5 f1 ff ff       	jmp    80106a85 <alltraps>

801078a0 <vector181>:
.globl vector181
vector181:
  pushl $0
801078a0:	6a 00                	push   $0x0
  pushl $181
801078a2:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801078a7:	e9 d9 f1 ff ff       	jmp    80106a85 <alltraps>

801078ac <vector182>:
.globl vector182
vector182:
  pushl $0
801078ac:	6a 00                	push   $0x0
  pushl $182
801078ae:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801078b3:	e9 cd f1 ff ff       	jmp    80106a85 <alltraps>

801078b8 <vector183>:
.globl vector183
vector183:
  pushl $0
801078b8:	6a 00                	push   $0x0
  pushl $183
801078ba:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801078bf:	e9 c1 f1 ff ff       	jmp    80106a85 <alltraps>

801078c4 <vector184>:
.globl vector184
vector184:
  pushl $0
801078c4:	6a 00                	push   $0x0
  pushl $184
801078c6:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801078cb:	e9 b5 f1 ff ff       	jmp    80106a85 <alltraps>

801078d0 <vector185>:
.globl vector185
vector185:
  pushl $0
801078d0:	6a 00                	push   $0x0
  pushl $185
801078d2:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801078d7:	e9 a9 f1 ff ff       	jmp    80106a85 <alltraps>

801078dc <vector186>:
.globl vector186
vector186:
  pushl $0
801078dc:	6a 00                	push   $0x0
  pushl $186
801078de:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801078e3:	e9 9d f1 ff ff       	jmp    80106a85 <alltraps>

801078e8 <vector187>:
.globl vector187
vector187:
  pushl $0
801078e8:	6a 00                	push   $0x0
  pushl $187
801078ea:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801078ef:	e9 91 f1 ff ff       	jmp    80106a85 <alltraps>

801078f4 <vector188>:
.globl vector188
vector188:
  pushl $0
801078f4:	6a 00                	push   $0x0
  pushl $188
801078f6:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801078fb:	e9 85 f1 ff ff       	jmp    80106a85 <alltraps>

80107900 <vector189>:
.globl vector189
vector189:
  pushl $0
80107900:	6a 00                	push   $0x0
  pushl $189
80107902:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107907:	e9 79 f1 ff ff       	jmp    80106a85 <alltraps>

8010790c <vector190>:
.globl vector190
vector190:
  pushl $0
8010790c:	6a 00                	push   $0x0
  pushl $190
8010790e:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107913:	e9 6d f1 ff ff       	jmp    80106a85 <alltraps>

80107918 <vector191>:
.globl vector191
vector191:
  pushl $0
80107918:	6a 00                	push   $0x0
  pushl $191
8010791a:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010791f:	e9 61 f1 ff ff       	jmp    80106a85 <alltraps>

80107924 <vector192>:
.globl vector192
vector192:
  pushl $0
80107924:	6a 00                	push   $0x0
  pushl $192
80107926:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010792b:	e9 55 f1 ff ff       	jmp    80106a85 <alltraps>

80107930 <vector193>:
.globl vector193
vector193:
  pushl $0
80107930:	6a 00                	push   $0x0
  pushl $193
80107932:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107937:	e9 49 f1 ff ff       	jmp    80106a85 <alltraps>

8010793c <vector194>:
.globl vector194
vector194:
  pushl $0
8010793c:	6a 00                	push   $0x0
  pushl $194
8010793e:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107943:	e9 3d f1 ff ff       	jmp    80106a85 <alltraps>

80107948 <vector195>:
.globl vector195
vector195:
  pushl $0
80107948:	6a 00                	push   $0x0
  pushl $195
8010794a:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010794f:	e9 31 f1 ff ff       	jmp    80106a85 <alltraps>

80107954 <vector196>:
.globl vector196
vector196:
  pushl $0
80107954:	6a 00                	push   $0x0
  pushl $196
80107956:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010795b:	e9 25 f1 ff ff       	jmp    80106a85 <alltraps>

80107960 <vector197>:
.globl vector197
vector197:
  pushl $0
80107960:	6a 00                	push   $0x0
  pushl $197
80107962:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107967:	e9 19 f1 ff ff       	jmp    80106a85 <alltraps>

8010796c <vector198>:
.globl vector198
vector198:
  pushl $0
8010796c:	6a 00                	push   $0x0
  pushl $198
8010796e:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107973:	e9 0d f1 ff ff       	jmp    80106a85 <alltraps>

80107978 <vector199>:
.globl vector199
vector199:
  pushl $0
80107978:	6a 00                	push   $0x0
  pushl $199
8010797a:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010797f:	e9 01 f1 ff ff       	jmp    80106a85 <alltraps>

80107984 <vector200>:
.globl vector200
vector200:
  pushl $0
80107984:	6a 00                	push   $0x0
  pushl $200
80107986:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010798b:	e9 f5 f0 ff ff       	jmp    80106a85 <alltraps>

80107990 <vector201>:
.globl vector201
vector201:
  pushl $0
80107990:	6a 00                	push   $0x0
  pushl $201
80107992:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107997:	e9 e9 f0 ff ff       	jmp    80106a85 <alltraps>

8010799c <vector202>:
.globl vector202
vector202:
  pushl $0
8010799c:	6a 00                	push   $0x0
  pushl $202
8010799e:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801079a3:	e9 dd f0 ff ff       	jmp    80106a85 <alltraps>

801079a8 <vector203>:
.globl vector203
vector203:
  pushl $0
801079a8:	6a 00                	push   $0x0
  pushl $203
801079aa:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801079af:	e9 d1 f0 ff ff       	jmp    80106a85 <alltraps>

801079b4 <vector204>:
.globl vector204
vector204:
  pushl $0
801079b4:	6a 00                	push   $0x0
  pushl $204
801079b6:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801079bb:	e9 c5 f0 ff ff       	jmp    80106a85 <alltraps>

801079c0 <vector205>:
.globl vector205
vector205:
  pushl $0
801079c0:	6a 00                	push   $0x0
  pushl $205
801079c2:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801079c7:	e9 b9 f0 ff ff       	jmp    80106a85 <alltraps>

801079cc <vector206>:
.globl vector206
vector206:
  pushl $0
801079cc:	6a 00                	push   $0x0
  pushl $206
801079ce:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801079d3:	e9 ad f0 ff ff       	jmp    80106a85 <alltraps>

801079d8 <vector207>:
.globl vector207
vector207:
  pushl $0
801079d8:	6a 00                	push   $0x0
  pushl $207
801079da:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801079df:	e9 a1 f0 ff ff       	jmp    80106a85 <alltraps>

801079e4 <vector208>:
.globl vector208
vector208:
  pushl $0
801079e4:	6a 00                	push   $0x0
  pushl $208
801079e6:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801079eb:	e9 95 f0 ff ff       	jmp    80106a85 <alltraps>

801079f0 <vector209>:
.globl vector209
vector209:
  pushl $0
801079f0:	6a 00                	push   $0x0
  pushl $209
801079f2:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801079f7:	e9 89 f0 ff ff       	jmp    80106a85 <alltraps>

801079fc <vector210>:
.globl vector210
vector210:
  pushl $0
801079fc:	6a 00                	push   $0x0
  pushl $210
801079fe:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107a03:	e9 7d f0 ff ff       	jmp    80106a85 <alltraps>

80107a08 <vector211>:
.globl vector211
vector211:
  pushl $0
80107a08:	6a 00                	push   $0x0
  pushl $211
80107a0a:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107a0f:	e9 71 f0 ff ff       	jmp    80106a85 <alltraps>

80107a14 <vector212>:
.globl vector212
vector212:
  pushl $0
80107a14:	6a 00                	push   $0x0
  pushl $212
80107a16:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107a1b:	e9 65 f0 ff ff       	jmp    80106a85 <alltraps>

80107a20 <vector213>:
.globl vector213
vector213:
  pushl $0
80107a20:	6a 00                	push   $0x0
  pushl $213
80107a22:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107a27:	e9 59 f0 ff ff       	jmp    80106a85 <alltraps>

80107a2c <vector214>:
.globl vector214
vector214:
  pushl $0
80107a2c:	6a 00                	push   $0x0
  pushl $214
80107a2e:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107a33:	e9 4d f0 ff ff       	jmp    80106a85 <alltraps>

80107a38 <vector215>:
.globl vector215
vector215:
  pushl $0
80107a38:	6a 00                	push   $0x0
  pushl $215
80107a3a:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107a3f:	e9 41 f0 ff ff       	jmp    80106a85 <alltraps>

80107a44 <vector216>:
.globl vector216
vector216:
  pushl $0
80107a44:	6a 00                	push   $0x0
  pushl $216
80107a46:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107a4b:	e9 35 f0 ff ff       	jmp    80106a85 <alltraps>

80107a50 <vector217>:
.globl vector217
vector217:
  pushl $0
80107a50:	6a 00                	push   $0x0
  pushl $217
80107a52:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107a57:	e9 29 f0 ff ff       	jmp    80106a85 <alltraps>

80107a5c <vector218>:
.globl vector218
vector218:
  pushl $0
80107a5c:	6a 00                	push   $0x0
  pushl $218
80107a5e:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107a63:	e9 1d f0 ff ff       	jmp    80106a85 <alltraps>

80107a68 <vector219>:
.globl vector219
vector219:
  pushl $0
80107a68:	6a 00                	push   $0x0
  pushl $219
80107a6a:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107a6f:	e9 11 f0 ff ff       	jmp    80106a85 <alltraps>

80107a74 <vector220>:
.globl vector220
vector220:
  pushl $0
80107a74:	6a 00                	push   $0x0
  pushl $220
80107a76:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107a7b:	e9 05 f0 ff ff       	jmp    80106a85 <alltraps>

80107a80 <vector221>:
.globl vector221
vector221:
  pushl $0
80107a80:	6a 00                	push   $0x0
  pushl $221
80107a82:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107a87:	e9 f9 ef ff ff       	jmp    80106a85 <alltraps>

80107a8c <vector222>:
.globl vector222
vector222:
  pushl $0
80107a8c:	6a 00                	push   $0x0
  pushl $222
80107a8e:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107a93:	e9 ed ef ff ff       	jmp    80106a85 <alltraps>

80107a98 <vector223>:
.globl vector223
vector223:
  pushl $0
80107a98:	6a 00                	push   $0x0
  pushl $223
80107a9a:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107a9f:	e9 e1 ef ff ff       	jmp    80106a85 <alltraps>

80107aa4 <vector224>:
.globl vector224
vector224:
  pushl $0
80107aa4:	6a 00                	push   $0x0
  pushl $224
80107aa6:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107aab:	e9 d5 ef ff ff       	jmp    80106a85 <alltraps>

80107ab0 <vector225>:
.globl vector225
vector225:
  pushl $0
80107ab0:	6a 00                	push   $0x0
  pushl $225
80107ab2:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107ab7:	e9 c9 ef ff ff       	jmp    80106a85 <alltraps>

80107abc <vector226>:
.globl vector226
vector226:
  pushl $0
80107abc:	6a 00                	push   $0x0
  pushl $226
80107abe:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107ac3:	e9 bd ef ff ff       	jmp    80106a85 <alltraps>

80107ac8 <vector227>:
.globl vector227
vector227:
  pushl $0
80107ac8:	6a 00                	push   $0x0
  pushl $227
80107aca:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107acf:	e9 b1 ef ff ff       	jmp    80106a85 <alltraps>

80107ad4 <vector228>:
.globl vector228
vector228:
  pushl $0
80107ad4:	6a 00                	push   $0x0
  pushl $228
80107ad6:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107adb:	e9 a5 ef ff ff       	jmp    80106a85 <alltraps>

80107ae0 <vector229>:
.globl vector229
vector229:
  pushl $0
80107ae0:	6a 00                	push   $0x0
  pushl $229
80107ae2:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107ae7:	e9 99 ef ff ff       	jmp    80106a85 <alltraps>

80107aec <vector230>:
.globl vector230
vector230:
  pushl $0
80107aec:	6a 00                	push   $0x0
  pushl $230
80107aee:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107af3:	e9 8d ef ff ff       	jmp    80106a85 <alltraps>

80107af8 <vector231>:
.globl vector231
vector231:
  pushl $0
80107af8:	6a 00                	push   $0x0
  pushl $231
80107afa:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107aff:	e9 81 ef ff ff       	jmp    80106a85 <alltraps>

80107b04 <vector232>:
.globl vector232
vector232:
  pushl $0
80107b04:	6a 00                	push   $0x0
  pushl $232
80107b06:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107b0b:	e9 75 ef ff ff       	jmp    80106a85 <alltraps>

80107b10 <vector233>:
.globl vector233
vector233:
  pushl $0
80107b10:	6a 00                	push   $0x0
  pushl $233
80107b12:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107b17:	e9 69 ef ff ff       	jmp    80106a85 <alltraps>

80107b1c <vector234>:
.globl vector234
vector234:
  pushl $0
80107b1c:	6a 00                	push   $0x0
  pushl $234
80107b1e:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107b23:	e9 5d ef ff ff       	jmp    80106a85 <alltraps>

80107b28 <vector235>:
.globl vector235
vector235:
  pushl $0
80107b28:	6a 00                	push   $0x0
  pushl $235
80107b2a:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107b2f:	e9 51 ef ff ff       	jmp    80106a85 <alltraps>

80107b34 <vector236>:
.globl vector236
vector236:
  pushl $0
80107b34:	6a 00                	push   $0x0
  pushl $236
80107b36:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107b3b:	e9 45 ef ff ff       	jmp    80106a85 <alltraps>

80107b40 <vector237>:
.globl vector237
vector237:
  pushl $0
80107b40:	6a 00                	push   $0x0
  pushl $237
80107b42:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107b47:	e9 39 ef ff ff       	jmp    80106a85 <alltraps>

80107b4c <vector238>:
.globl vector238
vector238:
  pushl $0
80107b4c:	6a 00                	push   $0x0
  pushl $238
80107b4e:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107b53:	e9 2d ef ff ff       	jmp    80106a85 <alltraps>

80107b58 <vector239>:
.globl vector239
vector239:
  pushl $0
80107b58:	6a 00                	push   $0x0
  pushl $239
80107b5a:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107b5f:	e9 21 ef ff ff       	jmp    80106a85 <alltraps>

80107b64 <vector240>:
.globl vector240
vector240:
  pushl $0
80107b64:	6a 00                	push   $0x0
  pushl $240
80107b66:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107b6b:	e9 15 ef ff ff       	jmp    80106a85 <alltraps>

80107b70 <vector241>:
.globl vector241
vector241:
  pushl $0
80107b70:	6a 00                	push   $0x0
  pushl $241
80107b72:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107b77:	e9 09 ef ff ff       	jmp    80106a85 <alltraps>

80107b7c <vector242>:
.globl vector242
vector242:
  pushl $0
80107b7c:	6a 00                	push   $0x0
  pushl $242
80107b7e:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107b83:	e9 fd ee ff ff       	jmp    80106a85 <alltraps>

80107b88 <vector243>:
.globl vector243
vector243:
  pushl $0
80107b88:	6a 00                	push   $0x0
  pushl $243
80107b8a:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107b8f:	e9 f1 ee ff ff       	jmp    80106a85 <alltraps>

80107b94 <vector244>:
.globl vector244
vector244:
  pushl $0
80107b94:	6a 00                	push   $0x0
  pushl $244
80107b96:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107b9b:	e9 e5 ee ff ff       	jmp    80106a85 <alltraps>

80107ba0 <vector245>:
.globl vector245
vector245:
  pushl $0
80107ba0:	6a 00                	push   $0x0
  pushl $245
80107ba2:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107ba7:	e9 d9 ee ff ff       	jmp    80106a85 <alltraps>

80107bac <vector246>:
.globl vector246
vector246:
  pushl $0
80107bac:	6a 00                	push   $0x0
  pushl $246
80107bae:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107bb3:	e9 cd ee ff ff       	jmp    80106a85 <alltraps>

80107bb8 <vector247>:
.globl vector247
vector247:
  pushl $0
80107bb8:	6a 00                	push   $0x0
  pushl $247
80107bba:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107bbf:	e9 c1 ee ff ff       	jmp    80106a85 <alltraps>

80107bc4 <vector248>:
.globl vector248
vector248:
  pushl $0
80107bc4:	6a 00                	push   $0x0
  pushl $248
80107bc6:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107bcb:	e9 b5 ee ff ff       	jmp    80106a85 <alltraps>

80107bd0 <vector249>:
.globl vector249
vector249:
  pushl $0
80107bd0:	6a 00                	push   $0x0
  pushl $249
80107bd2:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107bd7:	e9 a9 ee ff ff       	jmp    80106a85 <alltraps>

80107bdc <vector250>:
.globl vector250
vector250:
  pushl $0
80107bdc:	6a 00                	push   $0x0
  pushl $250
80107bde:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107be3:	e9 9d ee ff ff       	jmp    80106a85 <alltraps>

80107be8 <vector251>:
.globl vector251
vector251:
  pushl $0
80107be8:	6a 00                	push   $0x0
  pushl $251
80107bea:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107bef:	e9 91 ee ff ff       	jmp    80106a85 <alltraps>

80107bf4 <vector252>:
.globl vector252
vector252:
  pushl $0
80107bf4:	6a 00                	push   $0x0
  pushl $252
80107bf6:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107bfb:	e9 85 ee ff ff       	jmp    80106a85 <alltraps>

80107c00 <vector253>:
.globl vector253
vector253:
  pushl $0
80107c00:	6a 00                	push   $0x0
  pushl $253
80107c02:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107c07:	e9 79 ee ff ff       	jmp    80106a85 <alltraps>

80107c0c <vector254>:
.globl vector254
vector254:
  pushl $0
80107c0c:	6a 00                	push   $0x0
  pushl $254
80107c0e:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107c13:	e9 6d ee ff ff       	jmp    80106a85 <alltraps>

80107c18 <vector255>:
.globl vector255
vector255:
  pushl $0
80107c18:	6a 00                	push   $0x0
  pushl $255
80107c1a:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107c1f:	e9 61 ee ff ff       	jmp    80106a85 <alltraps>

80107c24 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107c24:	55                   	push   %ebp
80107c25:	89 e5                	mov    %esp,%ebp
80107c27:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c2d:	83 e8 01             	sub    $0x1,%eax
80107c30:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107c34:	8b 45 08             	mov    0x8(%ebp),%eax
80107c37:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c3e:	c1 e8 10             	shr    $0x10,%eax
80107c41:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107c45:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107c48:	0f 01 10             	lgdtl  (%eax)
}
80107c4b:	90                   	nop
80107c4c:	c9                   	leave  
80107c4d:	c3                   	ret    

80107c4e <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107c4e:	55                   	push   %ebp
80107c4f:	89 e5                	mov    %esp,%ebp
80107c51:	83 ec 04             	sub    $0x4,%esp
80107c54:	8b 45 08             	mov    0x8(%ebp),%eax
80107c57:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107c5b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107c5f:	0f 00 d8             	ltr    %ax
}
80107c62:	90                   	nop
80107c63:	c9                   	leave  
80107c64:	c3                   	ret    

80107c65 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107c65:	55                   	push   %ebp
80107c66:	89 e5                	mov    %esp,%ebp
80107c68:	83 ec 04             	sub    $0x4,%esp
80107c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c6e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107c72:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107c76:	8e e8                	mov    %eax,%gs
}
80107c78:	90                   	nop
80107c79:	c9                   	leave  
80107c7a:	c3                   	ret    

80107c7b <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107c7b:	55                   	push   %ebp
80107c7c:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c7e:	8b 45 08             	mov    0x8(%ebp),%eax
80107c81:	0f 22 d8             	mov    %eax,%cr3
}
80107c84:	90                   	nop
80107c85:	5d                   	pop    %ebp
80107c86:	c3                   	ret    

80107c87 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107c87:	55                   	push   %ebp
80107c88:	89 e5                	mov    %esp,%ebp
80107c8a:	8b 45 08             	mov    0x8(%ebp),%eax
80107c8d:	05 00 00 00 80       	add    $0x80000000,%eax
80107c92:	5d                   	pop    %ebp
80107c93:	c3                   	ret    

80107c94 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107c94:	55                   	push   %ebp
80107c95:	89 e5                	mov    %esp,%ebp
80107c97:	8b 45 08             	mov    0x8(%ebp),%eax
80107c9a:	05 00 00 00 80       	add    $0x80000000,%eax
80107c9f:	5d                   	pop    %ebp
80107ca0:	c3                   	ret    

80107ca1 <init_pte_lookup_lock>:
struct {
  char pte_array [NPDENTRIES*NPTENTRIES];
  struct spinlock lock;
} pte_lookup_table;

void init_pte_lookup_lock(void) {
80107ca1:	55                   	push   %ebp
80107ca2:	89 e5                	mov    %esp,%ebp
80107ca4:	83 ec 08             	sub    $0x8,%esp
  initlock(&pte_lookup_table.lock,"pte_lookup");
80107ca7:	83 ec 08             	sub    $0x8,%esp
80107caa:	68 94 94 10 80       	push   $0x80109494
80107caf:	68 20 65 21 80       	push   $0x80216520
80107cb4:	e8 20 d6 ff ff       	call   801052d9 <initlock>
80107cb9:	83 c4 10             	add    $0x10,%esp
}
80107cbc:	90                   	nop
80107cbd:	c9                   	leave  
80107cbe:	c3                   	ret    

80107cbf <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107cbf:	55                   	push   %ebp
80107cc0:	89 e5                	mov    %esp,%ebp
80107cc2:	53                   	push   %ebx
80107cc3:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107cc6:	e8 60 b2 ff ff       	call   80102f2b <cpunum>
80107ccb:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107cd1:	05 80 33 11 80       	add    $0x80113380,%eax
80107cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdc:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce5:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cee:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf5:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107cf9:	83 e2 f0             	and    $0xfffffff0,%edx
80107cfc:	83 ca 0a             	or     $0xa,%edx
80107cff:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d05:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d09:	83 ca 10             	or     $0x10,%edx
80107d0c:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d12:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d16:	83 e2 9f             	and    $0xffffff9f,%edx
80107d19:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d1f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d23:	83 ca 80             	or     $0xffffff80,%edx
80107d26:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d30:	83 ca 0f             	or     $0xf,%edx
80107d33:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d39:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d3d:	83 e2 ef             	and    $0xffffffef,%edx
80107d40:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d46:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d4a:	83 e2 df             	and    $0xffffffdf,%edx
80107d4d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d53:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d57:	83 ca 40             	or     $0x40,%edx
80107d5a:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d60:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d64:	83 ca 80             	or     $0xffffff80,%edx
80107d67:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6d:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d74:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107d7b:	ff ff 
80107d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d80:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107d87:	00 00 
80107d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8c:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d96:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d9d:	83 e2 f0             	and    $0xfffffff0,%edx
80107da0:	83 ca 02             	or     $0x2,%edx
80107da3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dac:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107db3:	83 ca 10             	or     $0x10,%edx
80107db6:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dbf:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107dc6:	83 e2 9f             	and    $0xffffff9f,%edx
80107dc9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107dd9:	83 ca 80             	or     $0xffffff80,%edx
80107ddc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107dec:	83 ca 0f             	or     $0xf,%edx
80107def:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107dff:	83 e2 ef             	and    $0xffffffef,%edx
80107e02:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e12:	83 e2 df             	and    $0xffffffdf,%edx
80107e15:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e25:	83 ca 40             	or     $0x40,%edx
80107e28:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e31:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e38:	83 ca 80             	or     $0xffffff80,%edx
80107e3b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e44:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107e55:	ff ff 
80107e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5a:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107e61:	00 00 
80107e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e66:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e70:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e77:	83 e2 f0             	and    $0xfffffff0,%edx
80107e7a:	83 ca 0a             	or     $0xa,%edx
80107e7d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e86:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e8d:	83 ca 10             	or     $0x10,%edx
80107e90:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e99:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107ea0:	83 ca 60             	or     $0x60,%edx
80107ea3:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eac:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107eb3:	83 ca 80             	or     $0xffffff80,%edx
80107eb6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebf:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ec6:	83 ca 0f             	or     $0xf,%edx
80107ec9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed2:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ed9:	83 e2 ef             	and    $0xffffffef,%edx
80107edc:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107eec:	83 e2 df             	and    $0xffffffdf,%edx
80107eef:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107eff:	83 ca 40             	or     $0x40,%edx
80107f02:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f12:	83 ca 80             	or     $0xffffff80,%edx
80107f15:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1e:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f28:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107f2f:	ff ff 
80107f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f34:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107f3b:	00 00 
80107f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f40:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f51:	83 e2 f0             	and    $0xfffffff0,%edx
80107f54:	83 ca 02             	or     $0x2,%edx
80107f57:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f60:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f67:	83 ca 10             	or     $0x10,%edx
80107f6a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f73:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f7a:	83 ca 60             	or     $0x60,%edx
80107f7d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f86:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f8d:	83 ca 80             	or     $0xffffff80,%edx
80107f90:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f99:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fa0:	83 ca 0f             	or     $0xf,%edx
80107fa3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fac:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fb3:	83 e2 ef             	and    $0xffffffef,%edx
80107fb6:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbf:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fc6:	83 e2 df             	and    $0xffffffdf,%edx
80107fc9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fd9:	83 ca 40             	or     $0x40,%edx
80107fdc:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fec:	83 ca 80             	or     $0xffffff80,%edx
80107fef:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff8:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108002:	05 b4 00 00 00       	add    $0xb4,%eax
80108007:	89 c3                	mov    %eax,%ebx
80108009:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800c:	05 b4 00 00 00       	add    $0xb4,%eax
80108011:	c1 e8 10             	shr    $0x10,%eax
80108014:	89 c2                	mov    %eax,%edx
80108016:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108019:	05 b4 00 00 00       	add    $0xb4,%eax
8010801e:	c1 e8 18             	shr    $0x18,%eax
80108021:	89 c1                	mov    %eax,%ecx
80108023:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108026:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010802d:	00 00 
8010802f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108032:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108039:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803c:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108045:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010804c:	83 e2 f0             	and    $0xfffffff0,%edx
8010804f:	83 ca 02             	or     $0x2,%edx
80108052:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108058:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108062:	83 ca 10             	or     $0x10,%edx
80108065:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010806b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108075:	83 e2 9f             	and    $0xffffff9f,%edx
80108078:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010807e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108081:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108088:	83 ca 80             	or     $0xffffff80,%edx
8010808b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108091:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108094:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010809b:	83 e2 f0             	and    $0xfffffff0,%edx
8010809e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a7:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080ae:	83 e2 ef             	and    $0xffffffef,%edx
801080b1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ba:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080c1:	83 e2 df             	and    $0xffffffdf,%edx
801080c4:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cd:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080d4:	83 ca 40             	or     $0x40,%edx
801080d7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080e7:	83 ca 80             	or     $0xffffff80,%edx
801080ea:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f3:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801080f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fc:	83 c0 70             	add    $0x70,%eax
801080ff:	83 ec 08             	sub    $0x8,%esp
80108102:	6a 38                	push   $0x38
80108104:	50                   	push   %eax
80108105:	e8 1a fb ff ff       	call   80107c24 <lgdt>
8010810a:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010810d:	83 ec 0c             	sub    $0xc,%esp
80108110:	6a 18                	push   $0x18
80108112:	e8 4e fb ff ff       	call   80107c65 <loadgs>
80108117:	83 c4 10             	add    $0x10,%esp

  // Initialize cpu-local storage.
  cpu = c;
8010811a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811d:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108123:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010812a:	00 00 00 00 
}
8010812e:	90                   	nop
8010812f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108132:	c9                   	leave  
80108133:	c3                   	ret    

80108134 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108134:	55                   	push   %ebp
80108135:	89 e5                	mov    %esp,%ebp
80108137:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010813a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010813d:	c1 e8 16             	shr    $0x16,%eax
80108140:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108147:	8b 45 08             	mov    0x8(%ebp),%eax
8010814a:	01 d0                	add    %edx,%eax
8010814c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010814f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108152:	8b 00                	mov    (%eax),%eax
80108154:	83 e0 01             	and    $0x1,%eax
80108157:	85 c0                	test   %eax,%eax
80108159:	74 18                	je     80108173 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
8010815b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010815e:	8b 00                	mov    (%eax),%eax
80108160:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108165:	50                   	push   %eax
80108166:	e8 29 fb ff ff       	call   80107c94 <p2v>
8010816b:	83 c4 04             	add    $0x4,%esp
8010816e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108171:	eb 48                	jmp    801081bb <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108173:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108177:	74 0e                	je     80108187 <walkpgdir+0x53>
80108179:	e8 47 aa ff ff       	call   80102bc5 <kalloc>
8010817e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108181:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108185:	75 07                	jne    8010818e <walkpgdir+0x5a>
      return 0;
80108187:	b8 00 00 00 00       	mov    $0x0,%eax
8010818c:	eb 44                	jmp    801081d2 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010818e:	83 ec 04             	sub    $0x4,%esp
80108191:	68 00 10 00 00       	push   $0x1000
80108196:	6a 00                	push   $0x0
80108198:	ff 75 f4             	pushl  -0xc(%ebp)
8010819b:	e8 be d3 ff ff       	call   8010555e <memset>
801081a0:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U
801081a3:	83 ec 0c             	sub    $0xc,%esp
801081a6:	ff 75 f4             	pushl  -0xc(%ebp)
801081a9:	e8 d9 fa ff ff       	call   80107c87 <v2p>
801081ae:	83 c4 10             	add    $0x10,%esp
801081b1:	83 c8 07             	or     $0x7,%eax
801081b4:	89 c2                	mov    %eax,%edx
801081b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081b9:	89 10                	mov    %edx,(%eax)
;  }
  return &pgtab[PTX(va)];
801081bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801081be:	c1 e8 0c             	shr    $0xc,%eax
801081c1:	25 ff 03 00 00       	and    $0x3ff,%eax
801081c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d0:	01 d0                	add    %edx,%eax
}
801081d2:	c9                   	leave  
801081d3:	c3                   	ret    

801081d4 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801081d4:	55                   	push   %ebp
801081d5:	89 e5                	mov    %esp,%ebp
801081d7:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801081da:	8b 45 0c             	mov    0xc(%ebp),%eax
801081dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801081e5:	8b 55 0c             	mov    0xc(%ebp),%edx
801081e8:	8b 45 10             	mov    0x10(%ebp),%eax
801081eb:	01 d0                	add    %edx,%eax
801081ed:	83 e8 01             	sub    $0x1,%eax
801081f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801081f8:	83 ec 04             	sub    $0x4,%esp
801081fb:	6a 01                	push   $0x1
801081fd:	ff 75 f4             	pushl  -0xc(%ebp)
80108200:	ff 75 08             	pushl  0x8(%ebp)
80108203:	e8 2c ff ff ff       	call   80108134 <walkpgdir>
80108208:	83 c4 10             	add    $0x10,%esp
8010820b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010820e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108212:	75 07                	jne    8010821b <mappages+0x47>
      return -1;
80108214:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108219:	eb 47                	jmp    80108262 <mappages+0x8e>
    if(*pte & PTE_P)
8010821b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010821e:	8b 00                	mov    (%eax),%eax
80108220:	83 e0 01             	and    $0x1,%eax
80108223:	85 c0                	test   %eax,%eax
80108225:	74 0d                	je     80108234 <mappages+0x60>
      panic("remap");
80108227:	83 ec 0c             	sub    $0xc,%esp
8010822a:	68 9f 94 10 80       	push   $0x8010949f
8010822f:	e8 32 83 ff ff       	call   80100566 <panic>
  //  page_references[PTE_ADDR(*pte)] = 1; //give pte_t a reference of one since fork copy just stopped there
    *pte = pa | perm | PTE_P;
80108234:	8b 45 18             	mov    0x18(%ebp),%eax
80108237:	0b 45 14             	or     0x14(%ebp),%eax
8010823a:	83 c8 01             	or     $0x1,%eax
8010823d:	89 c2                	mov    %eax,%edx
8010823f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108242:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108247:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010824a:	74 10                	je     8010825c <mappages+0x88>
      break;
    a += PGSIZE;
8010824c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108253:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010825a:	eb 9c                	jmp    801081f8 <mappages+0x24>
    if(*pte & PTE_P)
      panic("remap");
  //  page_references[PTE_ADDR(*pte)] = 1; //give pte_t a reference of one since fork copy just stopped there
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
8010825c:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010825d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108262:	c9                   	leave  
80108263:	c3                   	ret    

80108264 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108264:	55                   	push   %ebp
80108265:	89 e5                	mov    %esp,%ebp
80108267:	53                   	push   %ebx
80108268:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010826b:	e8 55 a9 ff ff       	call   80102bc5 <kalloc>
80108270:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108273:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108277:	75 0a                	jne    80108283 <setupkvm+0x1f>
    return 0;
80108279:	b8 00 00 00 00       	mov    $0x0,%eax
8010827e:	e9 8e 00 00 00       	jmp    80108311 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108283:	83 ec 04             	sub    $0x4,%esp
80108286:	68 00 10 00 00       	push   $0x1000
8010828b:	6a 00                	push   $0x0
8010828d:	ff 75 f0             	pushl  -0x10(%ebp)
80108290:	e8 c9 d2 ff ff       	call   8010555e <memset>
80108295:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108298:	83 ec 0c             	sub    $0xc,%esp
8010829b:	68 00 00 00 0e       	push   $0xe000000
801082a0:	e8 ef f9 ff ff       	call   80107c94 <p2v>
801082a5:	83 c4 10             	add    $0x10,%esp
801082a8:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801082ad:	76 0d                	jbe    801082bc <setupkvm+0x58>
    panic("PHYSTOP too high");
801082af:	83 ec 0c             	sub    $0xc,%esp
801082b2:	68 a5 94 10 80       	push   $0x801094a5
801082b7:	e8 aa 82 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801082bc:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801082c3:	eb 40                	jmp    80108305 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801082c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c8:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801082cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ce:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801082d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d4:	8b 58 08             	mov    0x8(%eax),%ebx
801082d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082da:	8b 40 04             	mov    0x4(%eax),%eax
801082dd:	29 c3                	sub    %eax,%ebx
801082df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e2:	8b 00                	mov    (%eax),%eax
801082e4:	83 ec 0c             	sub    $0xc,%esp
801082e7:	51                   	push   %ecx
801082e8:	52                   	push   %edx
801082e9:	53                   	push   %ebx
801082ea:	50                   	push   %eax
801082eb:	ff 75 f0             	pushl  -0x10(%ebp)
801082ee:	e8 e1 fe ff ff       	call   801081d4 <mappages>
801082f3:	83 c4 20             	add    $0x20,%esp
801082f6:	85 c0                	test   %eax,%eax
801082f8:	79 07                	jns    80108301 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801082fa:	b8 00 00 00 00       	mov    $0x0,%eax
801082ff:	eb 10                	jmp    80108311 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108301:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108305:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
8010830c:	72 b7                	jb     801082c5 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010830e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108311:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108314:	c9                   	leave  
80108315:	c3                   	ret    

80108316 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108316:	55                   	push   %ebp
80108317:	89 e5                	mov    %esp,%ebp
80108319:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010831c:	e8 43 ff ff ff       	call   80108264 <setupkvm>
80108321:	a3 98 65 21 80       	mov    %eax,0x80216598
  switchkvm();
80108326:	e8 03 00 00 00       	call   8010832e <switchkvm>
}
8010832b:	90                   	nop
8010832c:	c9                   	leave  
8010832d:	c3                   	ret    

8010832e <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010832e:	55                   	push   %ebp
8010832f:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108331:	a1 98 65 21 80       	mov    0x80216598,%eax
80108336:	50                   	push   %eax
80108337:	e8 4b f9 ff ff       	call   80107c87 <v2p>
8010833c:	83 c4 04             	add    $0x4,%esp
8010833f:	50                   	push   %eax
80108340:	e8 36 f9 ff ff       	call   80107c7b <lcr3>
80108345:	83 c4 04             	add    $0x4,%esp
}
80108348:	90                   	nop
80108349:	c9                   	leave  
8010834a:	c3                   	ret    

8010834b <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010834b:	55                   	push   %ebp
8010834c:	89 e5                	mov    %esp,%ebp
8010834e:	56                   	push   %esi
8010834f:	53                   	push   %ebx
  pushcli();
80108350:	e8 03 d1 ff ff       	call   80105458 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108355:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010835b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108362:	83 c2 08             	add    $0x8,%edx
80108365:	89 d6                	mov    %edx,%esi
80108367:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010836e:	83 c2 08             	add    $0x8,%edx
80108371:	c1 ea 10             	shr    $0x10,%edx
80108374:	89 d3                	mov    %edx,%ebx
80108376:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010837d:	83 c2 08             	add    $0x8,%edx
80108380:	c1 ea 18             	shr    $0x18,%edx
80108383:	89 d1                	mov    %edx,%ecx
80108385:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010838c:	67 00 
8010838e:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108395:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
8010839b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083a2:	83 e2 f0             	and    $0xfffffff0,%edx
801083a5:	83 ca 09             	or     $0x9,%edx
801083a8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801083ae:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083b5:	83 ca 10             	or     $0x10,%edx
801083b8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801083be:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083c5:	83 e2 9f             	and    $0xffffff9f,%edx
801083c8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801083ce:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083d5:	83 ca 80             	or     $0xffffff80,%edx
801083d8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801083de:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801083e5:	83 e2 f0             	and    $0xfffffff0,%edx
801083e8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801083ee:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801083f5:	83 e2 ef             	and    $0xffffffef,%edx
801083f8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801083fe:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108405:	83 e2 df             	and    $0xffffffdf,%edx
80108408:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010840e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108415:	83 ca 40             	or     $0x40,%edx
80108418:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010841e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108425:	83 e2 7f             	and    $0x7f,%edx
80108428:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010842e:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108434:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010843a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108441:	83 e2 ef             	and    $0xffffffef,%edx
80108444:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010844a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108450:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108456:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010845c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108463:	8b 52 08             	mov    0x8(%edx),%edx
80108466:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010846c:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010846f:	83 ec 0c             	sub    $0xc,%esp
80108472:	6a 30                	push   $0x30
80108474:	e8 d5 f7 ff ff       	call   80107c4e <ltr>
80108479:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
8010847c:	8b 45 08             	mov    0x8(%ebp),%eax
8010847f:	8b 40 04             	mov    0x4(%eax),%eax
80108482:	85 c0                	test   %eax,%eax
80108484:	75 0d                	jne    80108493 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108486:	83 ec 0c             	sub    $0xc,%esp
80108489:	68 b6 94 10 80       	push   $0x801094b6
8010848e:	e8 d3 80 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108493:	8b 45 08             	mov    0x8(%ebp),%eax
80108496:	8b 40 04             	mov    0x4(%eax),%eax
80108499:	83 ec 0c             	sub    $0xc,%esp
8010849c:	50                   	push   %eax
8010849d:	e8 e5 f7 ff ff       	call   80107c87 <v2p>
801084a2:	83 c4 10             	add    $0x10,%esp
801084a5:	83 ec 0c             	sub    $0xc,%esp
801084a8:	50                   	push   %eax
801084a9:	e8 cd f7 ff ff       	call   80107c7b <lcr3>
801084ae:	83 c4 10             	add    $0x10,%esp
  popcli();
801084b1:	e8 e7 cf ff ff       	call   8010549d <popcli>
}
801084b6:	90                   	nop
801084b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801084ba:	5b                   	pop    %ebx
801084bb:	5e                   	pop    %esi
801084bc:	5d                   	pop    %ebp
801084bd:	c3                   	ret    

801084be <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801084be:	55                   	push   %ebp
801084bf:	89 e5                	mov    %esp,%ebp
801084c1:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
801084c4:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801084cb:	76 0d                	jbe    801084da <inituvm+0x1c>
    panic("inituvm: more than a page");
801084cd:	83 ec 0c             	sub    $0xc,%esp
801084d0:	68 ca 94 10 80       	push   $0x801094ca
801084d5:	e8 8c 80 ff ff       	call   80100566 <panic>
  mem = kalloc();
801084da:	e8 e6 a6 ff ff       	call   80102bc5 <kalloc>
801084df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801084e2:	83 ec 04             	sub    $0x4,%esp
801084e5:	68 00 10 00 00       	push   $0x1000
801084ea:	6a 00                	push   $0x0
801084ec:	ff 75 f4             	pushl  -0xc(%ebp)
801084ef:	e8 6a d0 ff ff       	call   8010555e <memset>
801084f4:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801084f7:	83 ec 0c             	sub    $0xc,%esp
801084fa:	ff 75 f4             	pushl  -0xc(%ebp)
801084fd:	e8 85 f7 ff ff       	call   80107c87 <v2p>
80108502:	83 c4 10             	add    $0x10,%esp
80108505:	83 ec 0c             	sub    $0xc,%esp
80108508:	6a 06                	push   $0x6
8010850a:	50                   	push   %eax
8010850b:	68 00 10 00 00       	push   $0x1000
80108510:	6a 00                	push   $0x0
80108512:	ff 75 08             	pushl  0x8(%ebp)
80108515:	e8 ba fc ff ff       	call   801081d4 <mappages>
8010851a:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010851d:	83 ec 04             	sub    $0x4,%esp
80108520:	ff 75 10             	pushl  0x10(%ebp)
80108523:	ff 75 0c             	pushl  0xc(%ebp)
80108526:	ff 75 f4             	pushl  -0xc(%ebp)
80108529:	e8 ef d0 ff ff       	call   8010561d <memmove>
8010852e:	83 c4 10             	add    $0x10,%esp
}
80108531:	90                   	nop
80108532:	c9                   	leave  
80108533:	c3                   	ret    

80108534 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108534:	55                   	push   %ebp
80108535:	89 e5                	mov    %esp,%ebp
80108537:	53                   	push   %ebx
80108538:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010853b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010853e:	25 ff 0f 00 00       	and    $0xfff,%eax
80108543:	85 c0                	test   %eax,%eax
80108545:	74 0d                	je     80108554 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108547:	83 ec 0c             	sub    $0xc,%esp
8010854a:	68 e4 94 10 80       	push   $0x801094e4
8010854f:	e8 12 80 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108554:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010855b:	e9 95 00 00 00       	jmp    801085f5 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108560:	8b 55 0c             	mov    0xc(%ebp),%edx
80108563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108566:	01 d0                	add    %edx,%eax
80108568:	83 ec 04             	sub    $0x4,%esp
8010856b:	6a 00                	push   $0x0
8010856d:	50                   	push   %eax
8010856e:	ff 75 08             	pushl  0x8(%ebp)
80108571:	e8 be fb ff ff       	call   80108134 <walkpgdir>
80108576:	83 c4 10             	add    $0x10,%esp
80108579:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010857c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108580:	75 0d                	jne    8010858f <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80108582:	83 ec 0c             	sub    $0xc,%esp
80108585:	68 07 95 10 80       	push   $0x80109507
8010858a:	e8 d7 7f ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010858f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108592:	8b 00                	mov    (%eax),%eax
80108594:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108599:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010859c:	8b 45 18             	mov    0x18(%ebp),%eax
8010859f:	2b 45 f4             	sub    -0xc(%ebp),%eax
801085a2:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801085a7:	77 0b                	ja     801085b4 <loaduvm+0x80>
      n = sz - i;
801085a9:	8b 45 18             	mov    0x18(%ebp),%eax
801085ac:	2b 45 f4             	sub    -0xc(%ebp),%eax
801085af:	89 45 f0             	mov    %eax,-0x10(%ebp)
801085b2:	eb 07                	jmp    801085bb <loaduvm+0x87>
    else
      n = PGSIZE;
801085b4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801085bb:	8b 55 14             	mov    0x14(%ebp),%edx
801085be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801085c4:	83 ec 0c             	sub    $0xc,%esp
801085c7:	ff 75 e8             	pushl  -0x18(%ebp)
801085ca:	e8 c5 f6 ff ff       	call   80107c94 <p2v>
801085cf:	83 c4 10             	add    $0x10,%esp
801085d2:	ff 75 f0             	pushl  -0x10(%ebp)
801085d5:	53                   	push   %ebx
801085d6:	50                   	push   %eax
801085d7:	ff 75 10             	pushl  0x10(%ebp)
801085da:	e8 94 98 ff ff       	call   80101e73 <readi>
801085df:	83 c4 10             	add    $0x10,%esp
801085e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801085e5:	74 07                	je     801085ee <loaduvm+0xba>
      return -1;
801085e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801085ec:	eb 18                	jmp    80108606 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801085ee:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801085f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f8:	3b 45 18             	cmp    0x18(%ebp),%eax
801085fb:	0f 82 5f ff ff ff    	jb     80108560 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108601:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108606:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108609:	c9                   	leave  
8010860a:	c3                   	ret    

8010860b <mprotect>:

int
mprotect(void *addr, int len, int prot)
{
8010860b:	55                   	push   %ebp
8010860c:	89 e5                	mov    %esp,%ebp
8010860e:	83 ec 18             	sub    $0x18,%esp
  pte_t *page_table_entry;
  cprintf("*addr: %d\n",(uint)addr);
80108611:	8b 45 08             	mov    0x8(%ebp),%eax
80108614:	83 ec 08             	sub    $0x8,%esp
80108617:	50                   	push   %eax
80108618:	68 25 95 10 80       	push   $0x80109525
8010861d:	e8 a4 7d ff ff       	call   801003c6 <cprintf>
80108622:	83 c4 10             	add    $0x10,%esp
  //might need to PGRDWN the address
  //loop through all the page entries that need protection level changed
  //makes prot cnstants change in types.h
  //break it down, use PTE
  // cprintf("addr: %d\n",(int)addr);
  uint base_addr = PGROUNDDOWN((uint)addr);
80108625:	8b 45 08             	mov    0x8(%ebp),%eax
80108628:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010862d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint curr = base_addr;
80108630:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108633:	89 45 f4             	mov    %eax,-0xc(%ebp)
  do {

    page_table_entry = walkpgdir(proc->pgdir,(void *)curr ,0);
80108636:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108639:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010863f:	8b 40 04             	mov    0x4(%eax),%eax
80108642:	83 ec 04             	sub    $0x4,%esp
80108645:	6a 00                	push   $0x0
80108647:	52                   	push   %edx
80108648:	50                   	push   %eax
80108649:	e8 e6 fa ff ff       	call   80108134 <walkpgdir>
8010864e:	83 c4 10             	add    $0x10,%esp
80108651:	89 45 ec             	mov    %eax,-0x14(%ebp)
    curr += PGSIZE;
80108654:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    //clear last 3 bits
    cprintf("page table entry before: 0x%x desireced prot = %d\n",*page_table_entry,prot);
8010865b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010865e:	8b 00                	mov    (%eax),%eax
80108660:	83 ec 04             	sub    $0x4,%esp
80108663:	ff 75 10             	pushl  0x10(%ebp)
80108666:	50                   	push   %eax
80108667:	68 30 95 10 80       	push   $0x80109530
8010866c:	e8 55 7d ff ff       	call   801003c6 <cprintf>
80108671:	83 c4 10             	add    $0x10,%esp
    //clear last 3 bits
    *page_table_entry &= 0xfffffff9;
80108674:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108677:	8b 00                	mov    (%eax),%eax
80108679:	83 e0 f9             	and    $0xfffffff9,%eax
8010867c:	89 c2                	mov    %eax,%edx
8010867e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108681:	89 10                	mov    %edx,(%eax)
    // cprintf("page table entry after clear: 0x%x\n",*page_table_entry);
    switch(prot) {
80108683:	8b 45 10             	mov    0x10(%ebp),%eax
80108686:	83 f8 01             	cmp    $0x1,%eax
80108689:	74 28                	je     801086b3 <mprotect+0xa8>
8010868b:	83 f8 01             	cmp    $0x1,%eax
8010868e:	7f 06                	jg     80108696 <mprotect+0x8b>
80108690:	85 c0                	test   %eax,%eax
80108692:	74 0e                	je     801086a2 <mprotect+0x97>
80108694:	eb 4e                	jmp    801086e4 <mprotect+0xd9>
80108696:	83 f8 02             	cmp    $0x2,%eax
80108699:	74 29                	je     801086c4 <mprotect+0xb9>
8010869b:	83 f8 03             	cmp    $0x3,%eax
8010869e:	74 35                	je     801086d5 <mprotect+0xca>
801086a0:	eb 42                	jmp    801086e4 <mprotect+0xd9>
      case PROT_NONE:
        *page_table_entry |= PTE_P;
801086a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086a5:	8b 00                	mov    (%eax),%eax
801086a7:	83 c8 01             	or     $0x1,%eax
801086aa:	89 c2                	mov    %eax,%edx
801086ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086af:	89 10                	mov    %edx,(%eax)
        break;
801086b1:	eb 31                	jmp    801086e4 <mprotect+0xd9>
      case PROT_READ:
        *page_table_entry |= (PTE_P | PTE_U);
801086b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086b6:	8b 00                	mov    (%eax),%eax
801086b8:	83 c8 05             	or     $0x5,%eax
801086bb:	89 c2                	mov    %eax,%edx
801086bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086c0:	89 10                	mov    %edx,(%eax)
        break;
801086c2:	eb 20                	jmp    801086e4 <mprotect+0xd9>
      case PROT_WRITE:
        *page_table_entry |= (PTE_P | PTE_W);
801086c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086c7:	8b 00                	mov    (%eax),%eax
801086c9:	83 c8 03             	or     $0x3,%eax
801086cc:	89 c2                	mov    %eax,%edx
801086ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086d1:	89 10                	mov    %edx,(%eax)
        break;
801086d3:	eb 0f                	jmp    801086e4 <mprotect+0xd9>
      case PROT_READ | PROT_WRITE:
        *page_table_entry |= (PTE_P | PTE_W | PTE_U);
801086d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086d8:	8b 00                	mov    (%eax),%eax
801086da:	83 c8 07             	or     $0x7,%eax
801086dd:	89 c2                	mov    %eax,%edx
801086df:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086e2:	89 10                	mov    %edx,(%eax)
    }
    cprintf("page table entry after: 0x%x\n",*page_table_entry);
801086e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086e7:	8b 00                	mov    (%eax),%eax
801086e9:	83 ec 08             	sub    $0x8,%esp
801086ec:	50                   	push   %eax
801086ed:	68 63 95 10 80       	push   $0x80109563
801086f2:	e8 cf 7c ff ff       	call   801003c6 <cprintf>
801086f7:	83 c4 10             	add    $0x10,%esp
  } while(curr < ((uint)addr +len));
801086fa:	8b 55 08             	mov    0x8(%ebp),%edx
801086fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80108700:	01 d0                	add    %edx,%eax
80108702:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80108705:	0f 87 2b ff ff ff    	ja     80108636 <mprotect+0x2b>

  //flush that tlb real good
  lcr3(v2p(proc->pgdir));
8010870b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108711:	8b 40 04             	mov    0x4(%eax),%eax
80108714:	83 ec 0c             	sub    $0xc,%esp
80108717:	50                   	push   %eax
80108718:	e8 6a f5 ff ff       	call   80107c87 <v2p>
8010871d:	83 c4 10             	add    $0x10,%esp
80108720:	83 ec 0c             	sub    $0xc,%esp
80108723:	50                   	push   %eax
80108724:	e8 52 f5 ff ff       	call   80107c7b <lcr3>
80108729:	83 c4 10             	add    $0x10,%esp
  // cprintf("returning from mprotect\n");
  return 0; ///what happens after returned?
8010872c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108731:	c9                   	leave  
80108732:	c3                   	ret    

80108733 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108733:	55                   	push   %ebp
80108734:	89 e5                	mov    %esp,%ebp
80108736:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108739:	8b 45 10             	mov    0x10(%ebp),%eax
8010873c:	85 c0                	test   %eax,%eax
8010873e:	79 0a                	jns    8010874a <allocuvm+0x17>
    return 0;
80108740:	b8 00 00 00 00       	mov    $0x0,%eax
80108745:	e9 b0 00 00 00       	jmp    801087fa <allocuvm+0xc7>
  if(newsz < oldsz)
8010874a:	8b 45 10             	mov    0x10(%ebp),%eax
8010874d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108750:	73 08                	jae    8010875a <allocuvm+0x27>
    return oldsz;
80108752:	8b 45 0c             	mov    0xc(%ebp),%eax
80108755:	e9 a0 00 00 00       	jmp    801087fa <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
8010875a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010875d:	05 ff 0f 00 00       	add    $0xfff,%eax
80108762:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108767:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010876a:	eb 7f                	jmp    801087eb <allocuvm+0xb8>
    mem = kalloc();
8010876c:	e8 54 a4 ff ff       	call   80102bc5 <kalloc>
80108771:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108774:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108778:	75 2b                	jne    801087a5 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
8010877a:	83 ec 0c             	sub    $0xc,%esp
8010877d:	68 81 95 10 80       	push   $0x80109581
80108782:	e8 3f 7c ff ff       	call   801003c6 <cprintf>
80108787:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010878a:	83 ec 04             	sub    $0x4,%esp
8010878d:	ff 75 0c             	pushl  0xc(%ebp)
80108790:	ff 75 10             	pushl  0x10(%ebp)
80108793:	ff 75 08             	pushl  0x8(%ebp)
80108796:	e8 61 00 00 00       	call   801087fc <deallocuvm>
8010879b:	83 c4 10             	add    $0x10,%esp
      return 0;
8010879e:	b8 00 00 00 00       	mov    $0x0,%eax
801087a3:	eb 55                	jmp    801087fa <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
801087a5:	83 ec 04             	sub    $0x4,%esp
801087a8:	68 00 10 00 00       	push   $0x1000
801087ad:	6a 00                	push   $0x0
801087af:	ff 75 f0             	pushl  -0x10(%ebp)
801087b2:	e8 a7 cd ff ff       	call   8010555e <memset>
801087b7:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801087ba:	83 ec 0c             	sub    $0xc,%esp
801087bd:	ff 75 f0             	pushl  -0x10(%ebp)
801087c0:	e8 c2 f4 ff ff       	call   80107c87 <v2p>
801087c5:	83 c4 10             	add    $0x10,%esp
801087c8:	89 c2                	mov    %eax,%edx
801087ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087cd:	83 ec 0c             	sub    $0xc,%esp
801087d0:	6a 06                	push   $0x6
801087d2:	52                   	push   %edx
801087d3:	68 00 10 00 00       	push   $0x1000
801087d8:	50                   	push   %eax
801087d9:	ff 75 08             	pushl  0x8(%ebp)
801087dc:	e8 f3 f9 ff ff       	call   801081d4 <mappages>
801087e1:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801087e4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801087eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ee:	3b 45 10             	cmp    0x10(%ebp),%eax
801087f1:	0f 82 75 ff ff ff    	jb     8010876c <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801087f7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801087fa:	c9                   	leave  
801087fb:	c3                   	ret    

801087fc <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801087fc:	55                   	push   %ebp
801087fd:	89 e5                	mov    %esp,%ebp
801087ff:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108802:	8b 45 10             	mov    0x10(%ebp),%eax
80108805:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108808:	72 08                	jb     80108812 <deallocuvm+0x16>
    return oldsz;
8010880a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010880d:	e9 54 01 00 00       	jmp    80108966 <deallocuvm+0x16a>

  a = PGROUNDUP(newsz);
80108812:	8b 45 10             	mov    0x10(%ebp),%eax
80108815:	05 ff 0f 00 00       	add    $0xfff,%eax
8010881a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010881f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108822:	e9 30 01 00 00       	jmp    80108957 <deallocuvm+0x15b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010882a:	83 ec 04             	sub    $0x4,%esp
8010882d:	6a 00                	push   $0x0
8010882f:	50                   	push   %eax
80108830:	ff 75 08             	pushl  0x8(%ebp)
80108833:	e8 fc f8 ff ff       	call   80108134 <walkpgdir>
80108838:	83 c4 10             	add    $0x10,%esp
8010883b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010883e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108842:	75 0c                	jne    80108850 <deallocuvm+0x54>
      a += (NPTENTRIES - 1) * PGSIZE;
80108844:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010884b:	e9 00 01 00 00       	jmp    80108950 <deallocuvm+0x154>
    else if((*pte & PTE_P) != 0){
80108850:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108853:	8b 00                	mov    (%eax),%eax
80108855:	83 e0 01             	and    $0x1,%eax
80108858:	85 c0                	test   %eax,%eax
8010885a:	0f 84 f0 00 00 00    	je     80108950 <deallocuvm+0x154>
      pa = PTE_ADDR(*pte);
80108860:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108863:	8b 00                	mov    (%eax),%eax
80108865:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010886a:	89 45 ec             	mov    %eax,-0x14(%ebp)
      acquire(&pte_lookup_table.lock);
8010886d:	83 ec 0c             	sub    $0xc,%esp
80108870:	68 20 65 21 80       	push   $0x80216520
80108875:	e8 81 ca ff ff       	call   801052fb <acquire>
8010887a:	83 c4 10             	add    $0x10,%esp
        if(pte_lookup_table.pte_array[pa/PGSIZE] < 2){
8010887d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108880:	c1 e8 0c             	shr    $0xc,%eax
80108883:	0f b6 80 20 65 11 80 	movzbl -0x7fee9ae0(%eax),%eax
8010888a:	3c 01                	cmp    $0x1,%al
8010888c:	7f 4d                	jg     801088db <deallocuvm+0xdf>
          if(pa == 0) {
8010888e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108892:	75 1d                	jne    801088b1 <deallocuvm+0xb5>
            release(&pte_lookup_table.lock);
80108894:	83 ec 0c             	sub    $0xc,%esp
80108897:	68 20 65 21 80       	push   $0x80216520
8010889c:	e8 c1 ca ff ff       	call   80105362 <release>
801088a1:	83 c4 10             	add    $0x10,%esp
            panic("kfree");
801088a4:	83 ec 0c             	sub    $0xc,%esp
801088a7:	68 99 95 10 80       	push   $0x80109599
801088ac:	e8 b5 7c ff ff       	call   80100566 <panic>
          }
          char *v = p2v(pa);
801088b1:	83 ec 0c             	sub    $0xc,%esp
801088b4:	ff 75 ec             	pushl  -0x14(%ebp)
801088b7:	e8 d8 f3 ff ff       	call   80107c94 <p2v>
801088bc:	83 c4 10             	add    $0x10,%esp
801088bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
          kfree(v);
801088c2:	83 ec 0c             	sub    $0xc,%esp
801088c5:	ff 75 e8             	pushl  -0x18(%ebp)
801088c8:	e8 5b a2 ff ff       	call   80102b28 <kfree>
801088cd:	83 c4 10             	add    $0x10,%esp
          *pte = 0;
801088d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801088d9:	eb 65                	jmp    80108940 <deallocuvm+0x144>
        } else if(pte_lookup_table.pte_array[pa/PGSIZE] == 2) { //need to decrement and make mem writable
801088db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088de:	c1 e8 0c             	shr    $0xc,%eax
801088e1:	0f b6 80 20 65 11 80 	movzbl -0x7fee9ae0(%eax),%eax
801088e8:	3c 02                	cmp    $0x2,%al
801088ea:	75 2e                	jne    8010891a <deallocuvm+0x11e>
          cprintf("I AM TRYING TO DEALLOCATE SECOND MEM WITH 2 POINTERS\n");
801088ec:	83 ec 0c             	sub    $0xc,%esp
801088ef:	68 a0 95 10 80       	push   $0x801095a0
801088f4:	e8 cd 7a ff ff       	call   801003c6 <cprintf>
801088f9:	83 c4 10             	add    $0x10,%esp
          *pte |= PTE_W; //you may now write
801088fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088ff:	8b 00                	mov    (%eax),%eax
80108901:	83 c8 02             	or     $0x2,%eax
80108904:	89 c2                	mov    %eax,%edx
80108906:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108909:	89 10                	mov    %edx,(%eax)
          pte_lookup_table.pte_array[pa/PGSIZE] = 1;
8010890b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010890e:	c1 e8 0c             	shr    $0xc,%eax
80108911:	c6 80 20 65 11 80 01 	movb   $0x1,-0x7fee9ae0(%eax)
80108918:	eb 26                	jmp    80108940 <deallocuvm+0x144>
        } else {
          cprintf("DEALLOC ELSE? \n");
8010891a:	83 ec 0c             	sub    $0xc,%esp
8010891d:	68 d6 95 10 80       	push   $0x801095d6
80108922:	e8 9f 7a ff ff       	call   801003c6 <cprintf>
80108927:	83 c4 10             	add    $0x10,%esp
          pte_lookup_table.pte_array[pa/PGSIZE]--;
8010892a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010892d:	c1 e8 0c             	shr    $0xc,%eax
80108930:	0f b6 90 20 65 11 80 	movzbl -0x7fee9ae0(%eax),%edx
80108937:	83 ea 01             	sub    $0x1,%edx
8010893a:	88 90 20 65 11 80    	mov    %dl,-0x7fee9ae0(%eax)
        }
      release(&pte_lookup_table.lock);
80108940:	83 ec 0c             	sub    $0xc,%esp
80108943:	68 20 65 21 80       	push   $0x80216520
80108948:	e8 15 ca ff ff       	call   80105362 <release>
8010894d:	83 c4 10             	add    $0x10,%esp

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108950:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108957:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010895a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010895d:	0f 82 c4 fe ff ff    	jb     80108827 <deallocuvm+0x2b>
        }
      release(&pte_lookup_table.lock);
      //need to update entries in page table here
    }
  }
  return newsz;
80108963:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108966:	c9                   	leave  
80108967:	c3                   	ret    

80108968 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108968:	55                   	push   %ebp
80108969:	89 e5                	mov    %esp,%ebp
8010896b:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010896e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108972:	75 0d                	jne    80108981 <freevm+0x19>
    panic("freevm: no pgdir");
80108974:	83 ec 0c             	sub    $0xc,%esp
80108977:	68 e6 95 10 80       	push   $0x801095e6
8010897c:	e8 e5 7b ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108981:	83 ec 04             	sub    $0x4,%esp
80108984:	6a 00                	push   $0x0
80108986:	68 00 00 00 80       	push   $0x80000000
8010898b:	ff 75 08             	pushl  0x8(%ebp)
8010898e:	e8 69 fe ff ff       	call   801087fc <deallocuvm>
80108993:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010899d:	eb 4f                	jmp    801089ee <freevm+0x86>
    if(pgdir[i] & PTE_P){
8010899f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801089a9:	8b 45 08             	mov    0x8(%ebp),%eax
801089ac:	01 d0                	add    %edx,%eax
801089ae:	8b 00                	mov    (%eax),%eax
801089b0:	83 e0 01             	and    $0x1,%eax
801089b3:	85 c0                	test   %eax,%eax
801089b5:	74 33                	je     801089ea <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801089b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801089c1:	8b 45 08             	mov    0x8(%ebp),%eax
801089c4:	01 d0                	add    %edx,%eax
801089c6:	8b 00                	mov    (%eax),%eax
801089c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089cd:	83 ec 0c             	sub    $0xc,%esp
801089d0:	50                   	push   %eax
801089d1:	e8 be f2 ff ff       	call   80107c94 <p2v>
801089d6:	83 c4 10             	add    $0x10,%esp
801089d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801089dc:	83 ec 0c             	sub    $0xc,%esp
801089df:	ff 75 f0             	pushl  -0x10(%ebp)
801089e2:	e8 41 a1 ff ff       	call   80102b28 <kfree>
801089e7:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801089ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801089ee:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801089f5:	76 a8                	jbe    8010899f <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801089f7:	83 ec 0c             	sub    $0xc,%esp
801089fa:	ff 75 08             	pushl  0x8(%ebp)
801089fd:	e8 26 a1 ff ff       	call   80102b28 <kfree>
80108a02:	83 c4 10             	add    $0x10,%esp
}
80108a05:	90                   	nop
80108a06:	c9                   	leave  
80108a07:	c3                   	ret    

80108a08 <free_cow_vm>:

// Free a page table and all the physical memory pages
// in the user part.
void
free_cow_vm(pde_t *pgdir)
{
80108a08:	55                   	push   %ebp
80108a09:	89 e5                	mov    %esp,%ebp
80108a0b:	83 ec 08             	sub    $0x8,%esp

  if(pgdir == 0)
80108a0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108a12:	75 0d                	jne    80108a21 <free_cow_vm+0x19>
    panic("freevm: no pgdir");
80108a14:	83 ec 0c             	sub    $0xc,%esp
80108a17:	68 e6 95 10 80       	push   $0x801095e6
80108a1c:	e8 45 7b ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108a21:	83 ec 04             	sub    $0x4,%esp
80108a24:	6a 00                	push   $0x0
80108a26:	68 00 00 00 80       	push   $0x80000000
80108a2b:	ff 75 08             	pushl  0x8(%ebp)
80108a2e:	e8 c9 fd ff ff       	call   801087fc <deallocuvm>
80108a33:	83 c4 10             	add    $0x10,%esp
}
80108a36:	90                   	nop
80108a37:	c9                   	leave  
80108a38:	c3                   	ret    

80108a39 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108a39:	55                   	push   %ebp
80108a3a:	89 e5                	mov    %esp,%ebp
80108a3c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a3f:	83 ec 04             	sub    $0x4,%esp
80108a42:	6a 00                	push   $0x0
80108a44:	ff 75 0c             	pushl  0xc(%ebp)
80108a47:	ff 75 08             	pushl  0x8(%ebp)
80108a4a:	e8 e5 f6 ff ff       	call   80108134 <walkpgdir>
80108a4f:	83 c4 10             	add    $0x10,%esp
80108a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108a55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108a59:	75 0d                	jne    80108a68 <clearpteu+0x2f>
    panic("clearpteu");
80108a5b:	83 ec 0c             	sub    $0xc,%esp
80108a5e:	68 f7 95 10 80       	push   $0x801095f7
80108a63:	e8 fe 7a ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80108a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a6b:	8b 00                	mov    (%eax),%eax
80108a6d:	83 e0 fb             	and    $0xfffffffb,%eax
80108a70:	89 c2                	mov    %eax,%edx
80108a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a75:	89 10                	mov    %edx,(%eax)
}
80108a77:	90                   	nop
80108a78:	c9                   	leave  
80108a79:	c3                   	ret    

80108a7a <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108a7a:	55                   	push   %ebp
80108a7b:	89 e5                	mov    %esp,%ebp
80108a7d:	53                   	push   %ebx
80108a7e:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108a81:	e8 de f7 ff ff       	call   80108264 <setupkvm>
80108a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108a89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a8d:	75 0a                	jne    80108a99 <copyuvm+0x1f>
    return 0;
80108a8f:	b8 00 00 00 00       	mov    $0x0,%eax
80108a94:	e9 f8 00 00 00       	jmp    80108b91 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108a99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108aa0:	e9 c4 00 00 00       	jmp    80108b69 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aa8:	83 ec 04             	sub    $0x4,%esp
80108aab:	6a 00                	push   $0x0
80108aad:	50                   	push   %eax
80108aae:	ff 75 08             	pushl  0x8(%ebp)
80108ab1:	e8 7e f6 ff ff       	call   80108134 <walkpgdir>
80108ab6:	83 c4 10             	add    $0x10,%esp
80108ab9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108abc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108ac0:	75 0d                	jne    80108acf <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108ac2:	83 ec 0c             	sub    $0xc,%esp
80108ac5:	68 01 96 10 80       	push   $0x80109601
80108aca:	e8 97 7a ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ad2:	8b 00                	mov    (%eax),%eax
80108ad4:	83 e0 01             	and    $0x1,%eax
80108ad7:	85 c0                	test   %eax,%eax
80108ad9:	75 0d                	jne    80108ae8 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108adb:	83 ec 0c             	sub    $0xc,%esp
80108ade:	68 1b 96 10 80       	push   $0x8010961b
80108ae3:	e8 7e 7a ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108aeb:	8b 00                	mov    (%eax),%eax
80108aed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108af2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108af8:	8b 00                	mov    (%eax),%eax
80108afa:	25 ff 0f 00 00       	and    $0xfff,%eax
80108aff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108b02:	e8 be a0 ff ff       	call   80102bc5 <kalloc>
80108b07:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108b0a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108b0e:	74 6a                	je     80108b7a <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108b10:	83 ec 0c             	sub    $0xc,%esp
80108b13:	ff 75 e8             	pushl  -0x18(%ebp)
80108b16:	e8 79 f1 ff ff       	call   80107c94 <p2v>
80108b1b:	83 c4 10             	add    $0x10,%esp
80108b1e:	83 ec 04             	sub    $0x4,%esp
80108b21:	68 00 10 00 00       	push   $0x1000
80108b26:	50                   	push   %eax
80108b27:	ff 75 e0             	pushl  -0x20(%ebp)
80108b2a:	e8 ee ca ff ff       	call   8010561d <memmove>
80108b2f:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108b32:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108b35:	83 ec 0c             	sub    $0xc,%esp
80108b38:	ff 75 e0             	pushl  -0x20(%ebp)
80108b3b:	e8 47 f1 ff ff       	call   80107c87 <v2p>
80108b40:	83 c4 10             	add    $0x10,%esp
80108b43:	89 c2                	mov    %eax,%edx
80108b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b48:	83 ec 0c             	sub    $0xc,%esp
80108b4b:	53                   	push   %ebx
80108b4c:	52                   	push   %edx
80108b4d:	68 00 10 00 00       	push   $0x1000
80108b52:	50                   	push   %eax
80108b53:	ff 75 f0             	pushl  -0x10(%ebp)
80108b56:	e8 79 f6 ff ff       	call   801081d4 <mappages>
80108b5b:	83 c4 20             	add    $0x20,%esp
80108b5e:	85 c0                	test   %eax,%eax
80108b60:	78 1b                	js     80108b7d <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108b62:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b6c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108b6f:	0f 82 30 ff ff ff    	jb     80108aa5 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b78:	eb 17                	jmp    80108b91 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108b7a:	90                   	nop
80108b7b:	eb 01                	jmp    80108b7e <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108b7d:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108b7e:	83 ec 0c             	sub    $0xc,%esp
80108b81:	ff 75 f0             	pushl  -0x10(%ebp)
80108b84:	e8 df fd ff ff       	call   80108968 <freevm>
80108b89:	83 c4 10             	add    $0x10,%esp
  return 0;
80108b8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108b94:	c9                   	leave  
80108b95:	c3                   	ret    

80108b96 <copyuvm_cow>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm_cow(pde_t *pgdir, uint sz)
{
80108b96:	55                   	push   %ebp
80108b97:	89 e5                	mov    %esp,%ebp
80108b99:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108b9c:	e8 c3 f6 ff ff       	call   80108264 <setupkvm>
80108ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108ba4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108ba8:	75 0a                	jne    80108bb4 <copyuvm_cow+0x1e>
    return 0;
80108baa:	b8 00 00 00 00       	mov    $0x0,%eax
80108baf:	e9 7b 01 00 00       	jmp    80108d2f <copyuvm_cow+0x199>
  for(i = 0; i < sz; i += PGSIZE){
80108bb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108bbb:	e9 0d 01 00 00       	jmp    80108ccd <copyuvm_cow+0x137>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bc3:	83 ec 04             	sub    $0x4,%esp
80108bc6:	6a 00                	push   $0x0
80108bc8:	50                   	push   %eax
80108bc9:	ff 75 08             	pushl  0x8(%ebp)
80108bcc:	e8 63 f5 ff ff       	call   80108134 <walkpgdir>
80108bd1:	83 c4 10             	add    $0x10,%esp
80108bd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108bd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108bdb:	75 0d                	jne    80108bea <copyuvm_cow+0x54>
      panic("copyuvm: pte should exist");
80108bdd:	83 ec 0c             	sub    $0xc,%esp
80108be0:	68 01 96 10 80       	push   $0x80109601
80108be5:	e8 7c 79 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bed:	8b 00                	mov    (%eax),%eax
80108bef:	83 e0 01             	and    $0x1,%eax
80108bf2:	85 c0                	test   %eax,%eax
80108bf4:	75 0d                	jne    80108c03 <copyuvm_cow+0x6d>
      panic("copyuvm: page not present");
80108bf6:	83 ec 0c             	sub    $0xc,%esp
80108bf9:	68 1b 96 10 80       	push   $0x8010961b
80108bfe:	e8 63 79 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c06:	8b 00                	mov    (%eax),%eax
80108c08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c13:	8b 00                	mov    (%eax),%eax
80108c15:	25 ff 0f 00 00       	and    $0xfff,%eax
80108c1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108c1d:	e8 a3 9f ff ff       	call   80102bc5 <kalloc>
80108c22:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108c25:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108c29:	0f 84 d9 00 00 00    	je     80108d08 <copyuvm_cow+0x172>
      goto bad;
    acquire(&pte_lookup_table.lock);
80108c2f:	83 ec 0c             	sub    $0xc,%esp
80108c32:	68 20 65 21 80       	push   $0x80216520
80108c37:	e8 bf c6 ff ff       	call   801052fb <acquire>
80108c3c:	83 c4 10             	add    $0x10,%esp
      if(pte_lookup_table.pte_array[pa/PGSIZE] == 0) { //page fault
80108c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c42:	c1 e8 0c             	shr    $0xc,%eax
80108c45:	0f b6 80 20 65 11 80 	movzbl -0x7fee9ae0(%eax),%eax
80108c4c:	84 c0                	test   %al,%al
80108c4e:	75 1f                	jne    80108c6f <copyuvm_cow+0xd9>
        cprintf("ITS TWO!\n");
80108c50:	83 ec 0c             	sub    $0xc,%esp
80108c53:	68 35 96 10 80       	push   $0x80109635
80108c58:	e8 69 77 ff ff       	call   801003c6 <cprintf>
80108c5d:	83 c4 10             	add    $0x10,%esp
        pte_lookup_table.pte_array[pa/PGSIZE] = 2; //now child + father fork are pointing at it
80108c60:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c63:	c1 e8 0c             	shr    $0xc,%eax
80108c66:	c6 80 20 65 11 80 02 	movb   $0x2,-0x7fee9ae0(%eax)
80108c6d:	eb 16                	jmp    80108c85 <copyuvm_cow+0xef>
      } else {
        pte_lookup_table.pte_array[pa/PGSIZE] += 1;
80108c6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c72:	c1 e8 0c             	shr    $0xc,%eax
80108c75:	0f b6 90 20 65 11 80 	movzbl -0x7fee9ae0(%eax),%edx
80108c7c:	83 c2 01             	add    $0x1,%edx
80108c7f:	88 90 20 65 11 80    	mov    %dl,-0x7fee9ae0(%eax)

      }
    release(&pte_lookup_table.lock);
80108c85:	83 ec 0c             	sub    $0xc,%esp
80108c88:	68 20 65 21 80       	push   $0x80216520
80108c8d:	e8 d0 c6 ff ff       	call   80105362 <release>
80108c92:	83 c4 10             	add    $0x10,%esp

    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) //dont make new pages
80108c95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9b:	83 ec 0c             	sub    $0xc,%esp
80108c9e:	52                   	push   %edx
80108c9f:	ff 75 e8             	pushl  -0x18(%ebp)
80108ca2:	68 00 10 00 00       	push   $0x1000
80108ca7:	50                   	push   %eax
80108ca8:	ff 75 f0             	pushl  -0x10(%ebp)
80108cab:	e8 24 f5 ff ff       	call   801081d4 <mappages>
80108cb0:	83 c4 20             	add    $0x20,%esp
80108cb3:	85 c0                	test   %eax,%eax
80108cb5:	78 54                	js     80108d0b <copyuvm_cow+0x175>
      goto bad;
    //make it write only
    // cprintf("ABOUT TO MPROTECT\n");
    // mprotect(&pte,PGSIZE,PROT_READ);
    *pte &= ~PTE_W;
80108cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cba:	8b 00                	mov    (%eax),%eax
80108cbc:	83 e0 fd             	and    $0xfffffffd,%eax
80108cbf:	89 c2                	mov    %eax,%edx
80108cc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cc4:	89 10                	mov    %edx,(%eax)
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108cc6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd0:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108cd3:	0f 82 e7 fe ff ff    	jb     80108bc0 <copyuvm_cow+0x2a>
    // mprotect(&pte,PGSIZE,PROT_READ);
    *pte &= ~PTE_W;

  }
  //flush tlb?
  lcr3(v2p(pgdir));
80108cd9:	83 ec 0c             	sub    $0xc,%esp
80108cdc:	ff 75 08             	pushl  0x8(%ebp)
80108cdf:	e8 a3 ef ff ff       	call   80107c87 <v2p>
80108ce4:	83 c4 10             	add    $0x10,%esp
80108ce7:	83 ec 0c             	sub    $0xc,%esp
80108cea:	50                   	push   %eax
80108ceb:	e8 8b ef ff ff       	call   80107c7b <lcr3>
80108cf0:	83 c4 10             	add    $0x10,%esp
  cprintf("FINISHED IN COW!\n");
80108cf3:	83 ec 0c             	sub    $0xc,%esp
80108cf6:	68 3f 96 10 80       	push   $0x8010963f
80108cfb:	e8 c6 76 ff ff       	call   801003c6 <cprintf>
80108d00:	83 c4 10             	add    $0x10,%esp
  return d;
80108d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d06:	eb 27                	jmp    80108d2f <copyuvm_cow+0x199>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108d08:	90                   	nop
80108d09:	eb 01                	jmp    80108d0c <copyuvm_cow+0x176>

      }
    release(&pte_lookup_table.lock);

    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) //dont make new pages
      goto bad;
80108d0b:	90                   	nop
  lcr3(v2p(pgdir));
  cprintf("FINISHED IN COW!\n");
  return d;

bad:
  cprintf("BAD MEMORY!\n");
80108d0c:	83 ec 0c             	sub    $0xc,%esp
80108d0f:	68 51 96 10 80       	push   $0x80109651
80108d14:	e8 ad 76 ff ff       	call   801003c6 <cprintf>
80108d19:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108d1c:	83 ec 0c             	sub    $0xc,%esp
80108d1f:	ff 75 f0             	pushl  -0x10(%ebp)
80108d22:	e8 41 fc ff ff       	call   80108968 <freevm>
80108d27:	83 c4 10             	add    $0x10,%esp
  return 0;
80108d2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d2f:	c9                   	leave  
80108d30:	c3                   	ret    

80108d31 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108d31:	55                   	push   %ebp
80108d32:	89 e5                	mov    %esp,%ebp
80108d34:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108d37:	83 ec 04             	sub    $0x4,%esp
80108d3a:	6a 00                	push   $0x0
80108d3c:	ff 75 0c             	pushl  0xc(%ebp)
80108d3f:	ff 75 08             	pushl  0x8(%ebp)
80108d42:	e8 ed f3 ff ff       	call   80108134 <walkpgdir>
80108d47:	83 c4 10             	add    $0x10,%esp
80108d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d50:	8b 00                	mov    (%eax),%eax
80108d52:	83 e0 01             	and    $0x1,%eax
80108d55:	85 c0                	test   %eax,%eax
80108d57:	75 07                	jne    80108d60 <uva2ka+0x2f>
    return 0;
80108d59:	b8 00 00 00 00       	mov    $0x0,%eax
80108d5e:	eb 29                	jmp    80108d89 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d63:	8b 00                	mov    (%eax),%eax
80108d65:	83 e0 04             	and    $0x4,%eax
80108d68:	85 c0                	test   %eax,%eax
80108d6a:	75 07                	jne    80108d73 <uva2ka+0x42>
    return 0;
80108d6c:	b8 00 00 00 00       	mov    $0x0,%eax
80108d71:	eb 16                	jmp    80108d89 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d76:	8b 00                	mov    (%eax),%eax
80108d78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d7d:	83 ec 0c             	sub    $0xc,%esp
80108d80:	50                   	push   %eax
80108d81:	e8 0e ef ff ff       	call   80107c94 <p2v>
80108d86:	83 c4 10             	add    $0x10,%esp
}
80108d89:	c9                   	leave  
80108d8a:	c3                   	ret    

80108d8b <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108d8b:	55                   	push   %ebp
80108d8c:	89 e5                	mov    %esp,%ebp
80108d8e:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108d91:	8b 45 10             	mov    0x10(%ebp),%eax
80108d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108d97:	eb 7f                	jmp    80108e18 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108d99:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108da1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108da7:	83 ec 08             	sub    $0x8,%esp
80108daa:	50                   	push   %eax
80108dab:	ff 75 08             	pushl  0x8(%ebp)
80108dae:	e8 7e ff ff ff       	call   80108d31 <uva2ka>
80108db3:	83 c4 10             	add    $0x10,%esp
80108db6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108db9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108dbd:	75 07                	jne    80108dc6 <copyout+0x3b>
      return -1;
80108dbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108dc4:	eb 61                	jmp    80108e27 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dc9:	2b 45 0c             	sub    0xc(%ebp),%eax
80108dcc:	05 00 10 00 00       	add    $0x1000,%eax
80108dd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dd7:	3b 45 14             	cmp    0x14(%ebp),%eax
80108dda:	76 06                	jbe    80108de2 <copyout+0x57>
      n = len;
80108ddc:	8b 45 14             	mov    0x14(%ebp),%eax
80108ddf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108de2:	8b 45 0c             	mov    0xc(%ebp),%eax
80108de5:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108de8:	89 c2                	mov    %eax,%edx
80108dea:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ded:	01 d0                	add    %edx,%eax
80108def:	83 ec 04             	sub    $0x4,%esp
80108df2:	ff 75 f0             	pushl  -0x10(%ebp)
80108df5:	ff 75 f4             	pushl  -0xc(%ebp)
80108df8:	50                   	push   %eax
80108df9:	e8 1f c8 ff ff       	call   8010561d <memmove>
80108dfe:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e04:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e0a:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e10:	05 00 10 00 00       	add    $0x1000,%eax
80108e15:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108e18:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108e1c:	0f 85 77 ff ff ff    	jne    80108d99 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108e22:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e27:	c9                   	leave  
80108e28:	c3                   	ret    
