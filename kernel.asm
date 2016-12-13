
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
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 e0 8d 10 80       	push   $0x80108de0
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 68 52 00 00       	call   801052b4 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp
8010004f:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100056:	15 11 80 
80100059:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
80100060:	15 11 80 
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
8010006c:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
8010008c:	a1 94 15 11 80       	mov    0x80111594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 15 11 80       	mov    %eax,0x80111594
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 15 11 80       	mov    $0x80111584,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 80 d6 10 80       	push   $0x8010d680
801000c1:	e8 10 52 00 00       	call   801052d6 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp
801000c9:	a1 94 15 11 80       	mov    0x80111594,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 80 d6 10 80       	push   $0x8010d680
8010010c:	e8 2c 52 00 00       	call   8010533d <release>
80100111:	83 c4 10             	add    $0x10,%esp
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 41 4d 00 00       	call   80104e6d <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
80100143:	a1 90 15 11 80       	mov    0x80111590,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
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
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 80 d6 10 80       	push   $0x8010d680
80100188:	e8 b0 51 00 00       	call   8010533d <release>
8010018d:	83 c4 10             	add    $0x10,%esp
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 e7 8d 10 80       	push   $0x80108de7
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 85 26 00 00       	call   8010286c <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 f8 8d 10 80       	push   $0x80108df8
80100209:	e8 58 03 00 00       	call   80100566 <panic>
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 44 26 00 00       	call   8010286c <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 ff 8d 10 80       	push   $0x80108dff
80100248:	e8 19 03 00 00       	call   80100566 <panic>
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 7c 50 00 00       	call   801052d6 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
8010027b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
80100291:	a1 94 15 11 80       	mov    0x80111594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 15 11 80       	mov    %eax,0x80111594
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 9d 4c 00 00       	call   80104f5b <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 6f 50 00 00       	call   8010533d <release>
801002ce:	83 c4 10             	add    $0x10,%esp
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
80100313:	fa                   	cli    
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
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
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 c3 03 00 00       	call   80100776 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
801003cc:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 c5 10 80       	push   $0x8010c5e0
801003e2:	e8 ef 4e 00 00       	call   801052d6 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 06 8e 10 80       	push   $0x80108e06
801003f9:	e8 68 01 00 00       	call   80100566 <panic>
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 55 03 00 00       	call   80100776 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
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
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
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
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
801004cd:	c7 45 ec 0f 8e 10 80 	movl   $0x80108e0f,-0x14(%ebp)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 8e 02 00 00       	call   80100776 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 71 02 00 00       	call   80100776 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 62 02 00 00       	call   80100776 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 54 02 00 00       	call   80100776 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	90                   	nop
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
8010054c:	90                   	nop
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 e0 c5 10 80       	push   $0x8010c5e0
8010055b:	e8 dd 4d 00 00       	call   8010533d <release>
80100560:	83 c4 10             	add    $0x10,%esp
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
80100571:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
80100578:	00 00 00 
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 16 8e 10 80       	push   $0x80108e16
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 25 8e 10 80       	push   $0x80108e25
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 c8 4d 00 00       	call   8010538f <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 27 8e 10 80       	push   $0x80108e27
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
801005f5:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005fc:	00 00 00 
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
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
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
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
801006b8:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006bf:	7e 4c                	jle    8010070d <cgaputc+0x10c>
801006c1:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006c6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006cc:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006d1:	83 ec 04             	sub    $0x4,%esp
801006d4:	68 60 0e 00 00       	push   $0xe60
801006d9:	52                   	push   %edx
801006da:	50                   	push   %eax
801006db:	e8 18 4f 00 00       	call   801055f8 <memmove>
801006e0:	83 c4 10             	add    $0x10,%esp
801006e3:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
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
80100705:	e8 2f 4e 00 00       	call   80105539 <memset>
8010070a:	83 c4 10             	add    $0x10,%esp
8010070d:	83 ec 08             	sub    $0x8,%esp
80100710:	6a 0e                	push   $0xe
80100712:	68 d4 03 00 00       	push   $0x3d4
80100717:	e8 d5 fb ff ff       	call   801002f1 <outb>
8010071c:	83 c4 10             	add    $0x10,%esp
8010071f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100722:	c1 f8 08             	sar    $0x8,%eax
80100725:	0f b6 c0             	movzbl %al,%eax
80100728:	83 ec 08             	sub    $0x8,%esp
8010072b:	50                   	push   %eax
8010072c:	68 d5 03 00 00       	push   $0x3d5
80100731:	e8 bb fb ff ff       	call   801002f1 <outb>
80100736:	83 c4 10             	add    $0x10,%esp
80100739:	83 ec 08             	sub    $0x8,%esp
8010073c:	6a 0f                	push   $0xf
8010073e:	68 d4 03 00 00       	push   $0x3d4
80100743:	e8 a9 fb ff ff       	call   801002f1 <outb>
80100748:	83 c4 10             	add    $0x10,%esp
8010074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010074e:	0f b6 c0             	movzbl %al,%eax
80100751:	83 ec 08             	sub    $0x8,%esp
80100754:	50                   	push   %eax
80100755:	68 d5 03 00 00       	push   $0x3d5
8010075a:	e8 92 fb ff ff       	call   801002f1 <outb>
8010075f:	83 c4 10             	add    $0x10,%esp
80100762:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100767:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010076a:	01 d2                	add    %edx,%edx
8010076c:	01 d0                	add    %edx,%eax
8010076e:	66 c7 00 20 07       	movw   $0x720,(%eax)
80100773:	90                   	nop
80100774:	c9                   	leave  
80100775:	c3                   	ret    

80100776 <consputc>:
80100776:	55                   	push   %ebp
80100777:	89 e5                	mov    %esp,%ebp
80100779:	83 ec 08             	sub    $0x8,%esp
8010077c:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
80100781:	85 c0                	test   %eax,%eax
80100783:	74 07                	je     8010078c <consputc+0x16>
80100785:	e8 86 fb ff ff       	call   80100310 <cli>
8010078a:	eb fe                	jmp    8010078a <consputc+0x14>
8010078c:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100793:	75 29                	jne    801007be <consputc+0x48>
80100795:	83 ec 0c             	sub    $0xc,%esp
80100798:	6a 08                	push   $0x8
8010079a:	e8 4a 69 00 00       	call   801070e9 <uartputc>
8010079f:	83 c4 10             	add    $0x10,%esp
801007a2:	83 ec 0c             	sub    $0xc,%esp
801007a5:	6a 20                	push   $0x20
801007a7:	e8 3d 69 00 00       	call   801070e9 <uartputc>
801007ac:	83 c4 10             	add    $0x10,%esp
801007af:	83 ec 0c             	sub    $0xc,%esp
801007b2:	6a 08                	push   $0x8
801007b4:	e8 30 69 00 00       	call   801070e9 <uartputc>
801007b9:	83 c4 10             	add    $0x10,%esp
801007bc:	eb 0e                	jmp    801007cc <consputc+0x56>
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	ff 75 08             	pushl  0x8(%ebp)
801007c4:	e8 20 69 00 00       	call   801070e9 <uartputc>
801007c9:	83 c4 10             	add    $0x10,%esp
801007cc:	83 ec 0c             	sub    $0xc,%esp
801007cf:	ff 75 08             	pushl  0x8(%ebp)
801007d2:	e8 2a fe ff ff       	call   80100601 <cgaputc>
801007d7:	83 c4 10             	add    $0x10,%esp
801007da:	90                   	nop
801007db:	c9                   	leave  
801007dc:	c3                   	ret    

801007dd <consoleintr>:
801007dd:	55                   	push   %ebp
801007de:	89 e5                	mov    %esp,%ebp
801007e0:	83 ec 18             	sub    $0x18,%esp
801007e3:	83 ec 0c             	sub    $0xc,%esp
801007e6:	68 a0 17 11 80       	push   $0x801117a0
801007eb:	e8 e6 4a 00 00       	call   801052d6 <acquire>
801007f0:	83 c4 10             	add    $0x10,%esp
801007f3:	e9 42 01 00 00       	jmp    8010093a <consoleintr+0x15d>
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
8010081e:	e8 f6 47 00 00       	call   80105019 <procdump>
80100823:	e9 12 01 00 00       	jmp    8010093a <consoleintr+0x15d>
80100828:	a1 5c 18 11 80       	mov    0x8011185c,%eax
8010082d:	83 e8 01             	sub    $0x1,%eax
80100830:	a3 5c 18 11 80       	mov    %eax,0x8011185c
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 00 01 00 00       	push   $0x100
8010083d:	e8 34 ff ff ff       	call   80100776 <consputc>
80100842:	83 c4 10             	add    $0x10,%esp
80100845:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
8010084b:	a1 58 18 11 80       	mov    0x80111858,%eax
80100850:	39 c2                	cmp    %eax,%edx
80100852:	0f 84 e2 00 00 00    	je     8010093a <consoleintr+0x15d>
80100858:	a1 5c 18 11 80       	mov    0x8011185c,%eax
8010085d:	83 e8 01             	sub    $0x1,%eax
80100860:	83 e0 7f             	and    $0x7f,%eax
80100863:	0f b6 80 d4 17 11 80 	movzbl -0x7feee82c(%eax),%eax
8010086a:	3c 0a                	cmp    $0xa,%al
8010086c:	75 ba                	jne    80100828 <consoleintr+0x4b>
8010086e:	e9 c7 00 00 00       	jmp    8010093a <consoleintr+0x15d>
80100873:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
80100879:	a1 58 18 11 80       	mov    0x80111858,%eax
8010087e:	39 c2                	cmp    %eax,%edx
80100880:	0f 84 b4 00 00 00    	je     8010093a <consoleintr+0x15d>
80100886:	a1 5c 18 11 80       	mov    0x8011185c,%eax
8010088b:	83 e8 01             	sub    $0x1,%eax
8010088e:	a3 5c 18 11 80       	mov    %eax,0x8011185c
80100893:	83 ec 0c             	sub    $0xc,%esp
80100896:	68 00 01 00 00       	push   $0x100
8010089b:	e8 d6 fe ff ff       	call   80100776 <consputc>
801008a0:	83 c4 10             	add    $0x10,%esp
801008a3:	e9 92 00 00 00       	jmp    8010093a <consoleintr+0x15d>
801008a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801008ac:	0f 84 87 00 00 00    	je     80100939 <consoleintr+0x15c>
801008b2:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
801008b8:	a1 54 18 11 80       	mov    0x80111854,%eax
801008bd:	29 c2                	sub    %eax,%edx
801008bf:	89 d0                	mov    %edx,%eax
801008c1:	83 f8 7f             	cmp    $0x7f,%eax
801008c4:	77 73                	ja     80100939 <consoleintr+0x15c>
801008c6:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008ca:	74 05                	je     801008d1 <consoleintr+0xf4>
801008cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008cf:	eb 05                	jmp    801008d6 <consoleintr+0xf9>
801008d1:	b8 0a 00 00 00       	mov    $0xa,%eax
801008d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801008d9:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801008de:	8d 50 01             	lea    0x1(%eax),%edx
801008e1:	89 15 5c 18 11 80    	mov    %edx,0x8011185c
801008e7:	83 e0 7f             	and    $0x7f,%eax
801008ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008ed:	88 90 d4 17 11 80    	mov    %dl,-0x7feee82c(%eax)
801008f3:	83 ec 0c             	sub    $0xc,%esp
801008f6:	ff 75 f4             	pushl  -0xc(%ebp)
801008f9:	e8 78 fe ff ff       	call   80100776 <consputc>
801008fe:	83 c4 10             	add    $0x10,%esp
80100901:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80100905:	74 18                	je     8010091f <consoleintr+0x142>
80100907:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
8010090b:	74 12                	je     8010091f <consoleintr+0x142>
8010090d:	a1 5c 18 11 80       	mov    0x8011185c,%eax
80100912:	8b 15 54 18 11 80    	mov    0x80111854,%edx
80100918:	83 ea 80             	sub    $0xffffff80,%edx
8010091b:	39 d0                	cmp    %edx,%eax
8010091d:	75 1a                	jne    80100939 <consoleintr+0x15c>
8010091f:	a1 5c 18 11 80       	mov    0x8011185c,%eax
80100924:	a3 58 18 11 80       	mov    %eax,0x80111858
80100929:	83 ec 0c             	sub    $0xc,%esp
8010092c:	68 54 18 11 80       	push   $0x80111854
80100931:	e8 25 46 00 00       	call   80104f5b <wakeup>
80100936:	83 c4 10             	add    $0x10,%esp
80100939:	90                   	nop
8010093a:	8b 45 08             	mov    0x8(%ebp),%eax
8010093d:	ff d0                	call   *%eax
8010093f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100946:	0f 89 ac fe ff ff    	jns    801007f8 <consoleintr+0x1b>
8010094c:	83 ec 0c             	sub    $0xc,%esp
8010094f:	68 a0 17 11 80       	push   $0x801117a0
80100954:	e8 e4 49 00 00       	call   8010533d <release>
80100959:	83 c4 10             	add    $0x10,%esp
8010095c:	90                   	nop
8010095d:	c9                   	leave  
8010095e:	c3                   	ret    

8010095f <consoleread>:
8010095f:	55                   	push   %ebp
80100960:	89 e5                	mov    %esp,%ebp
80100962:	83 ec 18             	sub    $0x18,%esp
80100965:	83 ec 0c             	sub    $0xc,%esp
80100968:	ff 75 08             	pushl  0x8(%ebp)
8010096b:	e8 f3 10 00 00       	call   80101a63 <iunlock>
80100970:	83 c4 10             	add    $0x10,%esp
80100973:	8b 45 10             	mov    0x10(%ebp),%eax
80100976:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100979:	83 ec 0c             	sub    $0xc,%esp
8010097c:	68 a0 17 11 80       	push   $0x801117a0
80100981:	e8 50 49 00 00       	call   801052d6 <acquire>
80100986:	83 c4 10             	add    $0x10,%esp
80100989:	e9 ac 00 00 00       	jmp    80100a3a <consoleread+0xdb>
8010098e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100994:	8b 40 24             	mov    0x24(%eax),%eax
80100997:	85 c0                	test   %eax,%eax
80100999:	74 28                	je     801009c3 <consoleread+0x64>
8010099b:	83 ec 0c             	sub    $0xc,%esp
8010099e:	68 a0 17 11 80       	push   $0x801117a0
801009a3:	e8 95 49 00 00       	call   8010533d <release>
801009a8:	83 c4 10             	add    $0x10,%esp
801009ab:	83 ec 0c             	sub    $0xc,%esp
801009ae:	ff 75 08             	pushl  0x8(%ebp)
801009b1:	e8 55 0f 00 00       	call   8010190b <ilock>
801009b6:	83 c4 10             	add    $0x10,%esp
801009b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009be:	e9 ab 00 00 00       	jmp    80100a6e <consoleread+0x10f>
801009c3:	83 ec 08             	sub    $0x8,%esp
801009c6:	68 a0 17 11 80       	push   $0x801117a0
801009cb:	68 54 18 11 80       	push   $0x80111854
801009d0:	e8 98 44 00 00       	call   80104e6d <sleep>
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	8b 15 54 18 11 80    	mov    0x80111854,%edx
801009de:	a1 58 18 11 80       	mov    0x80111858,%eax
801009e3:	39 c2                	cmp    %eax,%edx
801009e5:	74 a7                	je     8010098e <consoleread+0x2f>
801009e7:	a1 54 18 11 80       	mov    0x80111854,%eax
801009ec:	8d 50 01             	lea    0x1(%eax),%edx
801009ef:	89 15 54 18 11 80    	mov    %edx,0x80111854
801009f5:	83 e0 7f             	and    $0x7f,%eax
801009f8:	0f b6 80 d4 17 11 80 	movzbl -0x7feee82c(%eax),%eax
801009ff:	0f be c0             	movsbl %al,%eax
80100a02:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100a05:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a09:	75 17                	jne    80100a22 <consoleread+0xc3>
80100a0b:	8b 45 10             	mov    0x10(%ebp),%eax
80100a0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a11:	73 2f                	jae    80100a42 <consoleread+0xe3>
80100a13:	a1 54 18 11 80       	mov    0x80111854,%eax
80100a18:	83 e8 01             	sub    $0x1,%eax
80100a1b:	a3 54 18 11 80       	mov    %eax,0x80111854
80100a20:	eb 20                	jmp    80100a42 <consoleread+0xe3>
80100a22:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a25:	8d 50 01             	lea    0x1(%eax),%edx
80100a28:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a2e:	88 10                	mov    %dl,(%eax)
80100a30:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80100a34:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a38:	74 0b                	je     80100a45 <consoleread+0xe6>
80100a3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a3e:	7f 98                	jg     801009d8 <consoleread+0x79>
80100a40:	eb 04                	jmp    80100a46 <consoleread+0xe7>
80100a42:	90                   	nop
80100a43:	eb 01                	jmp    80100a46 <consoleread+0xe7>
80100a45:	90                   	nop
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	68 a0 17 11 80       	push   $0x801117a0
80100a4e:	e8 ea 48 00 00       	call   8010533d <release>
80100a53:	83 c4 10             	add    $0x10,%esp
80100a56:	83 ec 0c             	sub    $0xc,%esp
80100a59:	ff 75 08             	pushl  0x8(%ebp)
80100a5c:	e8 aa 0e 00 00       	call   8010190b <ilock>
80100a61:	83 c4 10             	add    $0x10,%esp
80100a64:	8b 45 10             	mov    0x10(%ebp),%eax
80100a67:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a6a:	29 c2                	sub    %eax,%edx
80100a6c:	89 d0                	mov    %edx,%eax
80100a6e:	c9                   	leave  
80100a6f:	c3                   	ret    

80100a70 <consolewrite>:
80100a70:	55                   	push   %ebp
80100a71:	89 e5                	mov    %esp,%ebp
80100a73:	83 ec 18             	sub    $0x18,%esp
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	ff 75 08             	pushl  0x8(%ebp)
80100a7c:	e8 e2 0f 00 00       	call   80101a63 <iunlock>
80100a81:	83 c4 10             	add    $0x10,%esp
80100a84:	83 ec 0c             	sub    $0xc,%esp
80100a87:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a8c:	e8 45 48 00 00       	call   801052d6 <acquire>
80100a91:	83 c4 10             	add    $0x10,%esp
80100a94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a9b:	eb 21                	jmp    80100abe <consolewrite+0x4e>
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
80100aba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ac1:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ac4:	7c d7                	jl     80100a9d <consolewrite+0x2d>
80100ac6:	83 ec 0c             	sub    $0xc,%esp
80100ac9:	68 e0 c5 10 80       	push   $0x8010c5e0
80100ace:	e8 6a 48 00 00       	call   8010533d <release>
80100ad3:	83 c4 10             	add    $0x10,%esp
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	ff 75 08             	pushl  0x8(%ebp)
80100adc:	e8 2a 0e 00 00       	call   8010190b <ilock>
80100ae1:	83 c4 10             	add    $0x10,%esp
80100ae4:	8b 45 10             	mov    0x10(%ebp),%eax
80100ae7:	c9                   	leave  
80100ae8:	c3                   	ret    

80100ae9 <consoleinit>:
80100ae9:	55                   	push   %ebp
80100aea:	89 e5                	mov    %esp,%ebp
80100aec:	83 ec 08             	sub    $0x8,%esp
80100aef:	83 ec 08             	sub    $0x8,%esp
80100af2:	68 2b 8e 10 80       	push   $0x80108e2b
80100af7:	68 e0 c5 10 80       	push   $0x8010c5e0
80100afc:	e8 b3 47 00 00       	call   801052b4 <initlock>
80100b01:	83 c4 10             	add    $0x10,%esp
80100b04:	83 ec 08             	sub    $0x8,%esp
80100b07:	68 33 8e 10 80       	push   $0x80108e33
80100b0c:	68 a0 17 11 80       	push   $0x801117a0
80100b11:	e8 9e 47 00 00       	call   801052b4 <initlock>
80100b16:	83 c4 10             	add    $0x10,%esp
80100b19:	c7 05 0c 22 11 80 70 	movl   $0x80100a70,0x8011220c
80100b20:	0a 10 80 
80100b23:	c7 05 08 22 11 80 5f 	movl   $0x8010095f,0x80112208
80100b2a:	09 10 80 
80100b2d:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100b34:	00 00 00 
80100b37:	83 ec 0c             	sub    $0xc,%esp
80100b3a:	6a 01                	push   $0x1
80100b3c:	e8 3b 33 00 00       	call   80103e7c <picenable>
80100b41:	83 c4 10             	add    $0x10,%esp
80100b44:	83 ec 08             	sub    $0x8,%esp
80100b47:	6a 00                	push   $0x0
80100b49:	6a 01                	push   $0x1
80100b4b:	e8 e9 1e 00 00       	call   80102a39 <ioapicenable>
80100b50:	83 c4 10             	add    $0x10,%esp
80100b53:	90                   	nop
80100b54:	c9                   	leave  
80100b55:	c3                   	ret    

80100b56 <exec>:
80100b56:	55                   	push   %ebp
80100b57:	89 e5                	mov    %esp,%ebp
80100b59:	81 ec 18 01 00 00    	sub    $0x118,%esp
80100b5f:	e8 50 29 00 00       	call   801034b4 <begin_op>
80100b64:	83 ec 0c             	sub    $0xc,%esp
80100b67:	ff 75 08             	pushl  0x8(%ebp)
80100b6a:	e8 54 19 00 00       	call   801024c3 <namei>
80100b6f:	83 c4 10             	add    $0x10,%esp
80100b72:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b75:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b79:	75 0f                	jne    80100b8a <exec+0x34>
80100b7b:	e8 c0 29 00 00       	call   80103540 <end_op>
80100b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b85:	e9 ce 03 00 00       	jmp    80100f58 <exec+0x402>
80100b8a:	83 ec 0c             	sub    $0xc,%esp
80100b8d:	ff 75 d8             	pushl  -0x28(%ebp)
80100b90:	e8 76 0d 00 00       	call   8010190b <ilock>
80100b95:	83 c4 10             	add    $0x10,%esp
80100b98:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
80100b9f:	6a 34                	push   $0x34
80100ba1:	6a 00                	push   $0x0
80100ba3:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100ba9:	50                   	push   %eax
80100baa:	ff 75 d8             	pushl  -0x28(%ebp)
80100bad:	e8 c1 12 00 00       	call   80101e73 <readi>
80100bb2:	83 c4 10             	add    $0x10,%esp
80100bb5:	83 f8 33             	cmp    $0x33,%eax
80100bb8:	0f 86 49 03 00 00    	jbe    80100f07 <exec+0x3b1>
80100bbe:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bc4:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bc9:	0f 85 3b 03 00 00    	jne    80100f0a <exec+0x3b4>
80100bcf:	e8 88 76 00 00       	call   8010825c <setupkvm>
80100bd4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bd7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bdb:	0f 84 2c 03 00 00    	je     80100f0d <exec+0x3b7>
80100be1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80100be8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bef:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bf5:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bf8:	e9 ab 00 00 00       	jmp    80100ca8 <exec+0x152>
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
80100c1e:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c24:	83 f8 01             	cmp    $0x1,%eax
80100c27:	75 71                	jne    80100c9a <exec+0x144>
80100c29:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c2f:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c35:	39 c2                	cmp    %eax,%edx
80100c37:	0f 82 d6 02 00 00    	jb     80100f13 <exec+0x3bd>
80100c3d:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c43:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c49:	01 d0                	add    %edx,%eax
80100c4b:	83 ec 04             	sub    $0x4,%esp
80100c4e:	50                   	push   %eax
80100c4f:	ff 75 e0             	pushl  -0x20(%ebp)
80100c52:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c55:	e8 d1 7a 00 00       	call   8010872b <allocuvm>
80100c5a:	83 c4 10             	add    $0x10,%esp
80100c5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c64:	0f 84 ac 02 00 00    	je     80100f16 <exec+0x3c0>
80100c6a:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c70:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c7c:	83 ec 0c             	sub    $0xc,%esp
80100c7f:	52                   	push   %edx
80100c80:	50                   	push   %eax
80100c81:	ff 75 d8             	pushl  -0x28(%ebp)
80100c84:	51                   	push   %ecx
80100c85:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c88:	e8 9f 78 00 00       	call   8010852c <loaduvm>
80100c8d:	83 c4 20             	add    $0x20,%esp
80100c90:	85 c0                	test   %eax,%eax
80100c92:	0f 88 81 02 00 00    	js     80100f19 <exec+0x3c3>
80100c98:	eb 01                	jmp    80100c9b <exec+0x145>
80100c9a:	90                   	nop
80100c9b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ca2:	83 c0 20             	add    $0x20,%eax
80100ca5:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ca8:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100caf:	0f b7 c0             	movzwl %ax,%eax
80100cb2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cb5:	0f 8f 42 ff ff ff    	jg     80100bfd <exec+0xa7>
80100cbb:	83 ec 0c             	sub    $0xc,%esp
80100cbe:	ff 75 d8             	pushl  -0x28(%ebp)
80100cc1:	e8 ff 0e 00 00       	call   80101bc5 <iunlockput>
80100cc6:	83 c4 10             	add    $0x10,%esp
80100cc9:	e8 72 28 00 00       	call   80103540 <end_op>
80100cce:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80100cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd8:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cdd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce8:	05 00 20 00 00       	add    $0x2000,%eax
80100ced:	83 ec 04             	sub    $0x4,%esp
80100cf0:	50                   	push   %eax
80100cf1:	ff 75 e0             	pushl  -0x20(%ebp)
80100cf4:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cf7:	e8 2f 7a 00 00       	call   8010872b <allocuvm>
80100cfc:	83 c4 10             	add    $0x10,%esp
80100cff:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d06:	0f 84 10 02 00 00    	je     80100f1c <exec+0x3c6>
80100d0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0f:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d14:	83 ec 08             	sub    $0x8,%esp
80100d17:	50                   	push   %eax
80100d18:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d1b:	e8 e0 7c 00 00       	call   80108a00 <clearpteu>
80100d20:	83 c4 10             	add    $0x10,%esp
80100d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d26:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100d29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d30:	e9 96 00 00 00       	jmp    80100dcb <exec+0x275>
80100d35:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d39:	0f 87 e0 01 00 00    	ja     80100f1f <exec+0x3c9>
80100d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d4c:	01 d0                	add    %edx,%eax
80100d4e:	8b 00                	mov    (%eax),%eax
80100d50:	83 ec 0c             	sub    $0xc,%esp
80100d53:	50                   	push   %eax
80100d54:	e8 2d 4a 00 00       	call   80105786 <strlen>
80100d59:	83 c4 10             	add    $0x10,%esp
80100d5c:	89 c2                	mov    %eax,%edx
80100d5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d61:	29 d0                	sub    %edx,%eax
80100d63:	83 e8 01             	sub    $0x1,%eax
80100d66:	83 e0 fc             	and    $0xfffffffc,%eax
80100d69:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d76:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d79:	01 d0                	add    %edx,%eax
80100d7b:	8b 00                	mov    (%eax),%eax
80100d7d:	83 ec 0c             	sub    $0xc,%esp
80100d80:	50                   	push   %eax
80100d81:	e8 00 4a 00 00       	call   80105786 <strlen>
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
80100da7:	e8 96 7f 00 00       	call   80108d42 <copyout>
80100dac:	83 c4 10             	add    $0x10,%esp
80100daf:	85 c0                	test   %eax,%eax
80100db1:	0f 88 6b 01 00 00    	js     80100f22 <exec+0x3cc>
80100db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dba:	8d 50 03             	lea    0x3(%eax),%edx
80100dbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dc0:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
80100dc7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dd8:	01 d0                	add    %edx,%eax
80100dda:	8b 00                	mov    (%eax),%eax
80100ddc:	85 c0                	test   %eax,%eax
80100dde:	0f 85 51 ff ff ff    	jne    80100d35 <exec+0x1df>
80100de4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de7:	83 c0 03             	add    $0x3,%eax
80100dea:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100df1:	00 00 00 00 
80100df5:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dfc:	ff ff ff 
80100dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e02:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
80100e08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0b:	83 c0 01             	add    $0x1,%eax
80100e0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e15:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e18:	29 d0                	sub    %edx,%eax
80100e1a:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
80100e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e23:	83 c0 04             	add    $0x4,%eax
80100e26:	c1 e0 02             	shl    $0x2,%eax
80100e29:	29 45 dc             	sub    %eax,-0x24(%ebp)
80100e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2f:	83 c0 04             	add    $0x4,%eax
80100e32:	c1 e0 02             	shl    $0x2,%eax
80100e35:	50                   	push   %eax
80100e36:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e3c:	50                   	push   %eax
80100e3d:	ff 75 dc             	pushl  -0x24(%ebp)
80100e40:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e43:	e8 fa 7e 00 00       	call   80108d42 <copyout>
80100e48:	83 c4 10             	add    $0x10,%esp
80100e4b:	85 c0                	test   %eax,%eax
80100e4d:	0f 88 d2 00 00 00    	js     80100f25 <exec+0x3cf>
80100e53:	8b 45 08             	mov    0x8(%ebp),%eax
80100e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e5f:	eb 17                	jmp    80100e78 <exec+0x322>
80100e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e64:	0f b6 00             	movzbl (%eax),%eax
80100e67:	3c 2f                	cmp    $0x2f,%al
80100e69:	75 09                	jne    80100e74 <exec+0x31e>
80100e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e6e:	83 c0 01             	add    $0x1,%eax
80100e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7b:	0f b6 00             	movzbl (%eax),%eax
80100e7e:	84 c0                	test   %al,%al
80100e80:	75 df                	jne    80100e61 <exec+0x30b>
80100e82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e88:	83 c0 6c             	add    $0x6c,%eax
80100e8b:	83 ec 04             	sub    $0x4,%esp
80100e8e:	6a 10                	push   $0x10
80100e90:	ff 75 f0             	pushl  -0x10(%ebp)
80100e93:	50                   	push   %eax
80100e94:	e8 a3 48 00 00       	call   8010573c <safestrcpy>
80100e99:	83 c4 10             	add    $0x10,%esp
80100e9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea2:	8b 40 04             	mov    0x4(%eax),%eax
80100ea5:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100ea8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eb1:	89 50 04             	mov    %edx,0x4(%eax)
80100eb4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ebd:	89 10                	mov    %edx,(%eax)
80100ebf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec5:	8b 40 18             	mov    0x18(%eax),%eax
80100ec8:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ece:	89 50 38             	mov    %edx,0x38(%eax)
80100ed1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed7:	8b 40 18             	mov    0x18(%eax),%eax
80100eda:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100edd:	89 50 44             	mov    %edx,0x44(%eax)
80100ee0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee6:	83 ec 0c             	sub    $0xc,%esp
80100ee9:	50                   	push   %eax
80100eea:	e8 54 74 00 00       	call   80108343 <switchuvm>
80100eef:	83 c4 10             	add    $0x10,%esp
80100ef2:	83 ec 0c             	sub    $0xc,%esp
80100ef5:	ff 75 d0             	pushl  -0x30(%ebp)
80100ef8:	e8 63 7a 00 00       	call   80108960 <freevm>
80100efd:	83 c4 10             	add    $0x10,%esp
80100f00:	b8 00 00 00 00       	mov    $0x0,%eax
80100f05:	eb 51                	jmp    80100f58 <exec+0x402>
80100f07:	90                   	nop
80100f08:	eb 1c                	jmp    80100f26 <exec+0x3d0>
80100f0a:	90                   	nop
80100f0b:	eb 19                	jmp    80100f26 <exec+0x3d0>
80100f0d:	90                   	nop
80100f0e:	eb 16                	jmp    80100f26 <exec+0x3d0>
80100f10:	90                   	nop
80100f11:	eb 13                	jmp    80100f26 <exec+0x3d0>
80100f13:	90                   	nop
80100f14:	eb 10                	jmp    80100f26 <exec+0x3d0>
80100f16:	90                   	nop
80100f17:	eb 0d                	jmp    80100f26 <exec+0x3d0>
80100f19:	90                   	nop
80100f1a:	eb 0a                	jmp    80100f26 <exec+0x3d0>
80100f1c:	90                   	nop
80100f1d:	eb 07                	jmp    80100f26 <exec+0x3d0>
80100f1f:	90                   	nop
80100f20:	eb 04                	jmp    80100f26 <exec+0x3d0>
80100f22:	90                   	nop
80100f23:	eb 01                	jmp    80100f26 <exec+0x3d0>
80100f25:	90                   	nop
80100f26:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f2a:	74 0e                	je     80100f3a <exec+0x3e4>
80100f2c:	83 ec 0c             	sub    $0xc,%esp
80100f2f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f32:	e8 29 7a 00 00       	call   80108960 <freevm>
80100f37:	83 c4 10             	add    $0x10,%esp
80100f3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f3e:	74 13                	je     80100f53 <exec+0x3fd>
80100f40:	83 ec 0c             	sub    $0xc,%esp
80100f43:	ff 75 d8             	pushl  -0x28(%ebp)
80100f46:	e8 7a 0c 00 00       	call   80101bc5 <iunlockput>
80100f4b:	83 c4 10             	add    $0x10,%esp
80100f4e:	e8 ed 25 00 00       	call   80103540 <end_op>
80100f53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f58:	c9                   	leave  
80100f59:	c3                   	ret    

80100f5a <fileinit>:
80100f5a:	55                   	push   %ebp
80100f5b:	89 e5                	mov    %esp,%ebp
80100f5d:	83 ec 08             	sub    $0x8,%esp
80100f60:	83 ec 08             	sub    $0x8,%esp
80100f63:	68 39 8e 10 80       	push   $0x80108e39
80100f68:	68 60 18 11 80       	push   $0x80111860
80100f6d:	e8 42 43 00 00       	call   801052b4 <initlock>
80100f72:	83 c4 10             	add    $0x10,%esp
80100f75:	90                   	nop
80100f76:	c9                   	leave  
80100f77:	c3                   	ret    

80100f78 <filealloc>:
80100f78:	55                   	push   %ebp
80100f79:	89 e5                	mov    %esp,%ebp
80100f7b:	83 ec 18             	sub    $0x18,%esp
80100f7e:	83 ec 0c             	sub    $0xc,%esp
80100f81:	68 60 18 11 80       	push   $0x80111860
80100f86:	e8 4b 43 00 00       	call   801052d6 <acquire>
80100f8b:	83 c4 10             	add    $0x10,%esp
80100f8e:	c7 45 f4 94 18 11 80 	movl   $0x80111894,-0xc(%ebp)
80100f95:	eb 2d                	jmp    80100fc4 <filealloc+0x4c>
80100f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f9a:	8b 40 04             	mov    0x4(%eax),%eax
80100f9d:	85 c0                	test   %eax,%eax
80100f9f:	75 1f                	jne    80100fc0 <filealloc+0x48>
80100fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa4:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
80100fab:	83 ec 0c             	sub    $0xc,%esp
80100fae:	68 60 18 11 80       	push   $0x80111860
80100fb3:	e8 85 43 00 00       	call   8010533d <release>
80100fb8:	83 c4 10             	add    $0x10,%esp
80100fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fbe:	eb 23                	jmp    80100fe3 <filealloc+0x6b>
80100fc0:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fc4:	b8 f4 21 11 80       	mov    $0x801121f4,%eax
80100fc9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100fcc:	72 c9                	jb     80100f97 <filealloc+0x1f>
80100fce:	83 ec 0c             	sub    $0xc,%esp
80100fd1:	68 60 18 11 80       	push   $0x80111860
80100fd6:	e8 62 43 00 00       	call   8010533d <release>
80100fdb:	83 c4 10             	add    $0x10,%esp
80100fde:	b8 00 00 00 00       	mov    $0x0,%eax
80100fe3:	c9                   	leave  
80100fe4:	c3                   	ret    

80100fe5 <filedup>:
80100fe5:	55                   	push   %ebp
80100fe6:	89 e5                	mov    %esp,%ebp
80100fe8:	83 ec 08             	sub    $0x8,%esp
80100feb:	83 ec 0c             	sub    $0xc,%esp
80100fee:	68 60 18 11 80       	push   $0x80111860
80100ff3:	e8 de 42 00 00       	call   801052d6 <acquire>
80100ff8:	83 c4 10             	add    $0x10,%esp
80100ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffe:	8b 40 04             	mov    0x4(%eax),%eax
80101001:	85 c0                	test   %eax,%eax
80101003:	7f 0d                	jg     80101012 <filedup+0x2d>
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	68 40 8e 10 80       	push   $0x80108e40
8010100d:	e8 54 f5 ff ff       	call   80100566 <panic>
80101012:	8b 45 08             	mov    0x8(%ebp),%eax
80101015:	8b 40 04             	mov    0x4(%eax),%eax
80101018:	8d 50 01             	lea    0x1(%eax),%edx
8010101b:	8b 45 08             	mov    0x8(%ebp),%eax
8010101e:	89 50 04             	mov    %edx,0x4(%eax)
80101021:	83 ec 0c             	sub    $0xc,%esp
80101024:	68 60 18 11 80       	push   $0x80111860
80101029:	e8 0f 43 00 00       	call   8010533d <release>
8010102e:	83 c4 10             	add    $0x10,%esp
80101031:	8b 45 08             	mov    0x8(%ebp),%eax
80101034:	c9                   	leave  
80101035:	c3                   	ret    

80101036 <fileclose>:
80101036:	55                   	push   %ebp
80101037:	89 e5                	mov    %esp,%ebp
80101039:	83 ec 28             	sub    $0x28,%esp
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	68 60 18 11 80       	push   $0x80111860
80101044:	e8 8d 42 00 00       	call   801052d6 <acquire>
80101049:	83 c4 10             	add    $0x10,%esp
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
8010104f:	8b 40 04             	mov    0x4(%eax),%eax
80101052:	85 c0                	test   %eax,%eax
80101054:	7f 0d                	jg     80101063 <fileclose+0x2d>
80101056:	83 ec 0c             	sub    $0xc,%esp
80101059:	68 48 8e 10 80       	push   $0x80108e48
8010105e:	e8 03 f5 ff ff       	call   80100566 <panic>
80101063:	8b 45 08             	mov    0x8(%ebp),%eax
80101066:	8b 40 04             	mov    0x4(%eax),%eax
80101069:	8d 50 ff             	lea    -0x1(%eax),%edx
8010106c:	8b 45 08             	mov    0x8(%ebp),%eax
8010106f:	89 50 04             	mov    %edx,0x4(%eax)
80101072:	8b 45 08             	mov    0x8(%ebp),%eax
80101075:	8b 40 04             	mov    0x4(%eax),%eax
80101078:	85 c0                	test   %eax,%eax
8010107a:	7e 15                	jle    80101091 <fileclose+0x5b>
8010107c:	83 ec 0c             	sub    $0xc,%esp
8010107f:	68 60 18 11 80       	push   $0x80111860
80101084:	e8 b4 42 00 00       	call   8010533d <release>
80101089:	83 c4 10             	add    $0x10,%esp
8010108c:	e9 8b 00 00 00       	jmp    8010111c <fileclose+0xe6>
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
801010b7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
801010c1:	8b 45 08             	mov    0x8(%ebp),%eax
801010c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801010ca:	83 ec 0c             	sub    $0xc,%esp
801010cd:	68 60 18 11 80       	push   $0x80111860
801010d2:	e8 66 42 00 00       	call   8010533d <release>
801010d7:	83 c4 10             	add    $0x10,%esp
801010da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010dd:	83 f8 01             	cmp    $0x1,%eax
801010e0:	75 19                	jne    801010fb <fileclose+0xc5>
801010e2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010e6:	0f be d0             	movsbl %al,%edx
801010e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010ec:	83 ec 08             	sub    $0x8,%esp
801010ef:	52                   	push   %edx
801010f0:	50                   	push   %eax
801010f1:	e8 ef 2f 00 00       	call   801040e5 <pipeclose>
801010f6:	83 c4 10             	add    $0x10,%esp
801010f9:	eb 21                	jmp    8010111c <fileclose+0xe6>
801010fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010fe:	83 f8 02             	cmp    $0x2,%eax
80101101:	75 19                	jne    8010111c <fileclose+0xe6>
80101103:	e8 ac 23 00 00       	call   801034b4 <begin_op>
80101108:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	50                   	push   %eax
8010110f:	e8 c1 09 00 00       	call   80101ad5 <iput>
80101114:	83 c4 10             	add    $0x10,%esp
80101117:	e8 24 24 00 00       	call   80103540 <end_op>
8010111c:	c9                   	leave  
8010111d:	c3                   	ret    

8010111e <filestat>:
8010111e:	55                   	push   %ebp
8010111f:	89 e5                	mov    %esp,%ebp
80101121:	83 ec 08             	sub    $0x8,%esp
80101124:	8b 45 08             	mov    0x8(%ebp),%eax
80101127:	8b 00                	mov    (%eax),%eax
80101129:	83 f8 02             	cmp    $0x2,%eax
8010112c:	75 40                	jne    8010116e <filestat+0x50>
8010112e:	8b 45 08             	mov    0x8(%ebp),%eax
80101131:	8b 40 10             	mov    0x10(%eax),%eax
80101134:	83 ec 0c             	sub    $0xc,%esp
80101137:	50                   	push   %eax
80101138:	e8 ce 07 00 00       	call   8010190b <ilock>
8010113d:	83 c4 10             	add    $0x10,%esp
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	8b 40 10             	mov    0x10(%eax),%eax
80101146:	83 ec 08             	sub    $0x8,%esp
80101149:	ff 75 0c             	pushl  0xc(%ebp)
8010114c:	50                   	push   %eax
8010114d:	e8 db 0c 00 00       	call   80101e2d <stati>
80101152:	83 c4 10             	add    $0x10,%esp
80101155:	8b 45 08             	mov    0x8(%ebp),%eax
80101158:	8b 40 10             	mov    0x10(%eax),%eax
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	50                   	push   %eax
8010115f:	e8 ff 08 00 00       	call   80101a63 <iunlock>
80101164:	83 c4 10             	add    $0x10,%esp
80101167:	b8 00 00 00 00       	mov    $0x0,%eax
8010116c:	eb 05                	jmp    80101173 <filestat+0x55>
8010116e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101173:	c9                   	leave  
80101174:	c3                   	ret    

80101175 <fileread>:
80101175:	55                   	push   %ebp
80101176:	89 e5                	mov    %esp,%ebp
80101178:	83 ec 18             	sub    $0x18,%esp
8010117b:	8b 45 08             	mov    0x8(%ebp),%eax
8010117e:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101182:	84 c0                	test   %al,%al
80101184:	75 0a                	jne    80101190 <fileread+0x1b>
80101186:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010118b:	e9 9b 00 00 00       	jmp    8010122b <fileread+0xb6>
80101190:	8b 45 08             	mov    0x8(%ebp),%eax
80101193:	8b 00                	mov    (%eax),%eax
80101195:	83 f8 01             	cmp    $0x1,%eax
80101198:	75 1a                	jne    801011b4 <fileread+0x3f>
8010119a:	8b 45 08             	mov    0x8(%ebp),%eax
8010119d:	8b 40 0c             	mov    0xc(%eax),%eax
801011a0:	83 ec 04             	sub    $0x4,%esp
801011a3:	ff 75 10             	pushl  0x10(%ebp)
801011a6:	ff 75 0c             	pushl  0xc(%ebp)
801011a9:	50                   	push   %eax
801011aa:	e8 de 30 00 00       	call   8010428d <piperead>
801011af:	83 c4 10             	add    $0x10,%esp
801011b2:	eb 77                	jmp    8010122b <fileread+0xb6>
801011b4:	8b 45 08             	mov    0x8(%ebp),%eax
801011b7:	8b 00                	mov    (%eax),%eax
801011b9:	83 f8 02             	cmp    $0x2,%eax
801011bc:	75 60                	jne    8010121e <fileread+0xa9>
801011be:	8b 45 08             	mov    0x8(%ebp),%eax
801011c1:	8b 40 10             	mov    0x10(%eax),%eax
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	50                   	push   %eax
801011c8:	e8 3e 07 00 00       	call   8010190b <ilock>
801011cd:	83 c4 10             	add    $0x10,%esp
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
801011f6:	8b 45 08             	mov    0x8(%ebp),%eax
801011f9:	8b 50 14             	mov    0x14(%eax),%edx
801011fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ff:	01 c2                	add    %eax,%edx
80101201:	8b 45 08             	mov    0x8(%ebp),%eax
80101204:	89 50 14             	mov    %edx,0x14(%eax)
80101207:	8b 45 08             	mov    0x8(%ebp),%eax
8010120a:	8b 40 10             	mov    0x10(%eax),%eax
8010120d:	83 ec 0c             	sub    $0xc,%esp
80101210:	50                   	push   %eax
80101211:	e8 4d 08 00 00       	call   80101a63 <iunlock>
80101216:	83 c4 10             	add    $0x10,%esp
80101219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010121c:	eb 0d                	jmp    8010122b <fileread+0xb6>
8010121e:	83 ec 0c             	sub    $0xc,%esp
80101221:	68 52 8e 10 80       	push   $0x80108e52
80101226:	e8 3b f3 ff ff       	call   80100566 <panic>
8010122b:	c9                   	leave  
8010122c:	c3                   	ret    

8010122d <filewrite>:
8010122d:	55                   	push   %ebp
8010122e:	89 e5                	mov    %esp,%ebp
80101230:	53                   	push   %ebx
80101231:	83 ec 14             	sub    $0x14,%esp
80101234:	8b 45 08             	mov    0x8(%ebp),%eax
80101237:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010123b:	84 c0                	test   %al,%al
8010123d:	75 0a                	jne    80101249 <filewrite+0x1c>
8010123f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101244:	e9 1b 01 00 00       	jmp    80101364 <filewrite+0x137>
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	8b 00                	mov    (%eax),%eax
8010124e:	83 f8 01             	cmp    $0x1,%eax
80101251:	75 1d                	jne    80101270 <filewrite+0x43>
80101253:	8b 45 08             	mov    0x8(%ebp),%eax
80101256:	8b 40 0c             	mov    0xc(%eax),%eax
80101259:	83 ec 04             	sub    $0x4,%esp
8010125c:	ff 75 10             	pushl  0x10(%ebp)
8010125f:	ff 75 0c             	pushl  0xc(%ebp)
80101262:	50                   	push   %eax
80101263:	e8 27 2f 00 00       	call   8010418f <pipewrite>
80101268:	83 c4 10             	add    $0x10,%esp
8010126b:	e9 f4 00 00 00       	jmp    80101364 <filewrite+0x137>
80101270:	8b 45 08             	mov    0x8(%ebp),%eax
80101273:	8b 00                	mov    (%eax),%eax
80101275:	83 f8 02             	cmp    $0x2,%eax
80101278:	0f 85 d9 00 00 00    	jne    80101357 <filewrite+0x12a>
8010127e:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
80101285:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010128c:	e9 a3 00 00 00       	jmp    80101334 <filewrite+0x107>
80101291:	8b 45 10             	mov    0x10(%ebp),%eax
80101294:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101297:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010129a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010129d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012a0:	7e 06                	jle    801012a8 <filewrite+0x7b>
801012a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801012a8:	e8 07 22 00 00       	call   801034b4 <begin_op>
801012ad:	8b 45 08             	mov    0x8(%ebp),%eax
801012b0:	8b 40 10             	mov    0x10(%eax),%eax
801012b3:	83 ec 0c             	sub    $0xc,%esp
801012b6:	50                   	push   %eax
801012b7:	e8 4f 06 00 00       	call   8010190b <ilock>
801012bc:	83 c4 10             	add    $0x10,%esp
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
801012eb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ee:	8b 50 14             	mov    0x14(%eax),%edx
801012f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f4:	01 c2                	add    %eax,%edx
801012f6:	8b 45 08             	mov    0x8(%ebp),%eax
801012f9:	89 50 14             	mov    %edx,0x14(%eax)
801012fc:	8b 45 08             	mov    0x8(%ebp),%eax
801012ff:	8b 40 10             	mov    0x10(%eax),%eax
80101302:	83 ec 0c             	sub    $0xc,%esp
80101305:	50                   	push   %eax
80101306:	e8 58 07 00 00       	call   80101a63 <iunlock>
8010130b:	83 c4 10             	add    $0x10,%esp
8010130e:	e8 2d 22 00 00       	call   80103540 <end_op>
80101313:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101317:	78 29                	js     80101342 <filewrite+0x115>
80101319:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010131c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010131f:	74 0d                	je     8010132e <filewrite+0x101>
80101321:	83 ec 0c             	sub    $0xc,%esp
80101324:	68 5b 8e 10 80       	push   $0x80108e5b
80101329:	e8 38 f2 ff ff       	call   80100566 <panic>
8010132e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101331:	01 45 f4             	add    %eax,-0xc(%ebp)
80101334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101337:	3b 45 10             	cmp    0x10(%ebp),%eax
8010133a:	0f 8c 51 ff ff ff    	jl     80101291 <filewrite+0x64>
80101340:	eb 01                	jmp    80101343 <filewrite+0x116>
80101342:	90                   	nop
80101343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101346:	3b 45 10             	cmp    0x10(%ebp),%eax
80101349:	75 05                	jne    80101350 <filewrite+0x123>
8010134b:	8b 45 10             	mov    0x10(%ebp),%eax
8010134e:	eb 14                	jmp    80101364 <filewrite+0x137>
80101350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101355:	eb 0d                	jmp    80101364 <filewrite+0x137>
80101357:	83 ec 0c             	sub    $0xc,%esp
8010135a:	68 6b 8e 10 80       	push   $0x80108e6b
8010135f:	e8 02 f2 ff ff       	call   80100566 <panic>
80101364:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101367:	c9                   	leave  
80101368:	c3                   	ret    

80101369 <readsb>:
80101369:	55                   	push   %ebp
8010136a:	89 e5                	mov    %esp,%ebp
8010136c:	83 ec 18             	sub    $0x18,%esp
8010136f:	8b 45 08             	mov    0x8(%ebp),%eax
80101372:	83 ec 08             	sub    $0x8,%esp
80101375:	6a 01                	push   $0x1
80101377:	50                   	push   %eax
80101378:	e8 39 ee ff ff       	call   801001b6 <bread>
8010137d:	83 c4 10             	add    $0x10,%esp
80101380:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101386:	83 c0 18             	add    $0x18,%eax
80101389:	83 ec 04             	sub    $0x4,%esp
8010138c:	6a 10                	push   $0x10
8010138e:	50                   	push   %eax
8010138f:	ff 75 0c             	pushl  0xc(%ebp)
80101392:	e8 61 42 00 00       	call   801055f8 <memmove>
80101397:	83 c4 10             	add    $0x10,%esp
8010139a:	83 ec 0c             	sub    $0xc,%esp
8010139d:	ff 75 f4             	pushl  -0xc(%ebp)
801013a0:	e8 89 ee ff ff       	call   8010022e <brelse>
801013a5:	83 c4 10             	add    $0x10,%esp
801013a8:	90                   	nop
801013a9:	c9                   	leave  
801013aa:	c3                   	ret    

801013ab <bzero>:
801013ab:	55                   	push   %ebp
801013ac:	89 e5                	mov    %esp,%ebp
801013ae:	83 ec 18             	sub    $0x18,%esp
801013b1:	8b 55 0c             	mov    0xc(%ebp),%edx
801013b4:	8b 45 08             	mov    0x8(%ebp),%eax
801013b7:	83 ec 08             	sub    $0x8,%esp
801013ba:	52                   	push   %edx
801013bb:	50                   	push   %eax
801013bc:	e8 f5 ed ff ff       	call   801001b6 <bread>
801013c1:	83 c4 10             	add    $0x10,%esp
801013c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801013c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ca:	83 c0 18             	add    $0x18,%eax
801013cd:	83 ec 04             	sub    $0x4,%esp
801013d0:	68 00 02 00 00       	push   $0x200
801013d5:	6a 00                	push   $0x0
801013d7:	50                   	push   %eax
801013d8:	e8 5c 41 00 00       	call   80105539 <memset>
801013dd:	83 c4 10             	add    $0x10,%esp
801013e0:	83 ec 0c             	sub    $0xc,%esp
801013e3:	ff 75 f4             	pushl  -0xc(%ebp)
801013e6:	e8 01 23 00 00       	call   801036ec <log_write>
801013eb:	83 c4 10             	add    $0x10,%esp
801013ee:	83 ec 0c             	sub    $0xc,%esp
801013f1:	ff 75 f4             	pushl  -0xc(%ebp)
801013f4:	e8 35 ee ff ff       	call   8010022e <brelse>
801013f9:	83 c4 10             	add    $0x10,%esp
801013fc:	90                   	nop
801013fd:	c9                   	leave  
801013fe:	c3                   	ret    

801013ff <balloc>:
801013ff:	55                   	push   %ebp
80101400:	89 e5                	mov    %esp,%ebp
80101402:	83 ec 28             	sub    $0x28,%esp
80101405:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010140c:	8b 45 08             	mov    0x8(%ebp),%eax
8010140f:	83 ec 08             	sub    $0x8,%esp
80101412:	8d 55 d8             	lea    -0x28(%ebp),%edx
80101415:	52                   	push   %edx
80101416:	50                   	push   %eax
80101417:	e8 4d ff ff ff       	call   80101369 <readsb>
8010141c:	83 c4 10             	add    $0x10,%esp
8010141f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101426:	e9 15 01 00 00       	jmp    80101540 <balloc+0x141>
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
8010145b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101462:	e9 a6 00 00 00       	jmp    8010150d <balloc+0x10e>
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
801014cb:	83 ec 0c             	sub    $0xc,%esp
801014ce:	ff 75 ec             	pushl  -0x14(%ebp)
801014d1:	e8 16 22 00 00       	call   801036ec <log_write>
801014d6:	83 c4 10             	add    $0x10,%esp
801014d9:	83 ec 0c             	sub    $0xc,%esp
801014dc:	ff 75 ec             	pushl  -0x14(%ebp)
801014df:	e8 4a ed ff ff       	call   8010022e <brelse>
801014e4:	83 c4 10             	add    $0x10,%esp
801014e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ed:	01 c2                	add    %eax,%edx
801014ef:	8b 45 08             	mov    0x8(%ebp),%eax
801014f2:	83 ec 08             	sub    $0x8,%esp
801014f5:	52                   	push   %edx
801014f6:	50                   	push   %eax
801014f7:	e8 af fe ff ff       	call   801013ab <bzero>
801014fc:	83 c4 10             	add    $0x10,%esp
801014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101502:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101505:	01 d0                	add    %edx,%eax
80101507:	eb 52                	jmp    8010155b <balloc+0x15c>
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
8010152b:	83 ec 0c             	sub    $0xc,%esp
8010152e:	ff 75 ec             	pushl  -0x14(%ebp)
80101531:	e8 f8 ec ff ff       	call   8010022e <brelse>
80101536:	83 c4 10             	add    $0x10,%esp
80101539:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101540:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101546:	39 c2                	cmp    %eax,%edx
80101548:	0f 87 dd fe ff ff    	ja     8010142b <balloc+0x2c>
8010154e:	83 ec 0c             	sub    $0xc,%esp
80101551:	68 75 8e 10 80       	push   $0x80108e75
80101556:	e8 0b f0 ff ff       	call   80100566 <panic>
8010155b:	c9                   	leave  
8010155c:	c3                   	ret    

8010155d <bfree>:
8010155d:	55                   	push   %ebp
8010155e:	89 e5                	mov    %esp,%ebp
80101560:	83 ec 28             	sub    $0x28,%esp
80101563:	83 ec 08             	sub    $0x8,%esp
80101566:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101569:	50                   	push   %eax
8010156a:	ff 75 08             	pushl  0x8(%ebp)
8010156d:	e8 f7 fd ff ff       	call   80101369 <readsb>
80101572:	83 c4 10             	add    $0x10,%esp
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
8010159b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010159e:	25 ff 0f 00 00       	and    $0xfff,%eax
801015a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
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
801015e4:	83 ec 0c             	sub    $0xc,%esp
801015e7:	68 8b 8e 10 80       	push   $0x80108e8b
801015ec:	e8 75 ef ff ff       	call   80100566 <panic>
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
80101619:	83 ec 0c             	sub    $0xc,%esp
8010161c:	ff 75 f4             	pushl  -0xc(%ebp)
8010161f:	e8 c8 20 00 00       	call   801036ec <log_write>
80101624:	83 c4 10             	add    $0x10,%esp
80101627:	83 ec 0c             	sub    $0xc,%esp
8010162a:	ff 75 f4             	pushl  -0xc(%ebp)
8010162d:	e8 fc eb ff ff       	call   8010022e <brelse>
80101632:	83 c4 10             	add    $0x10,%esp
80101635:	90                   	nop
80101636:	c9                   	leave  
80101637:	c3                   	ret    

80101638 <iinit>:
80101638:	55                   	push   %ebp
80101639:	89 e5                	mov    %esp,%ebp
8010163b:	83 ec 08             	sub    $0x8,%esp
8010163e:	83 ec 08             	sub    $0x8,%esp
80101641:	68 9e 8e 10 80       	push   $0x80108e9e
80101646:	68 60 22 11 80       	push   $0x80112260
8010164b:	e8 64 3c 00 00       	call   801052b4 <initlock>
80101650:	83 c4 10             	add    $0x10,%esp
80101653:	90                   	nop
80101654:	c9                   	leave  
80101655:	c3                   	ret    

80101656 <ialloc>:
80101656:	55                   	push   %ebp
80101657:	89 e5                	mov    %esp,%ebp
80101659:	83 ec 38             	sub    $0x38,%esp
8010165c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010165f:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
80101663:	8b 45 08             	mov    0x8(%ebp),%eax
80101666:	83 ec 08             	sub    $0x8,%esp
80101669:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010166c:	52                   	push   %edx
8010166d:	50                   	push   %eax
8010166e:	e8 f6 fc ff ff       	call   80101369 <readsb>
80101673:	83 c4 10             	add    $0x10,%esp
80101676:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010167d:	e9 98 00 00 00       	jmp    8010171a <ialloc+0xc4>
80101682:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101685:	c1 e8 03             	shr    $0x3,%eax
80101688:	83 c0 02             	add    $0x2,%eax
8010168b:	83 ec 08             	sub    $0x8,%esp
8010168e:	50                   	push   %eax
8010168f:	ff 75 08             	pushl  0x8(%ebp)
80101692:	e8 1f eb ff ff       	call   801001b6 <bread>
80101697:	83 c4 10             	add    $0x10,%esp
8010169a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010169d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a0:	8d 50 18             	lea    0x18(%eax),%edx
801016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016a6:	83 e0 07             	and    $0x7,%eax
801016a9:	c1 e0 06             	shl    $0x6,%eax
801016ac:	01 d0                	add    %edx,%eax
801016ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
801016b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016b4:	0f b7 00             	movzwl (%eax),%eax
801016b7:	66 85 c0             	test   %ax,%ax
801016ba:	75 4c                	jne    80101708 <ialloc+0xb2>
801016bc:	83 ec 04             	sub    $0x4,%esp
801016bf:	6a 40                	push   $0x40
801016c1:	6a 00                	push   $0x0
801016c3:	ff 75 ec             	pushl  -0x14(%ebp)
801016c6:	e8 6e 3e 00 00       	call   80105539 <memset>
801016cb:	83 c4 10             	add    $0x10,%esp
801016ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016d1:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
801016d5:	66 89 10             	mov    %dx,(%eax)
801016d8:	83 ec 0c             	sub    $0xc,%esp
801016db:	ff 75 f0             	pushl  -0x10(%ebp)
801016de:	e8 09 20 00 00       	call   801036ec <log_write>
801016e3:	83 c4 10             	add    $0x10,%esp
801016e6:	83 ec 0c             	sub    $0xc,%esp
801016e9:	ff 75 f0             	pushl  -0x10(%ebp)
801016ec:	e8 3d eb ff ff       	call   8010022e <brelse>
801016f1:	83 c4 10             	add    $0x10,%esp
801016f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f7:	83 ec 08             	sub    $0x8,%esp
801016fa:	50                   	push   %eax
801016fb:	ff 75 08             	pushl  0x8(%ebp)
801016fe:	e8 ef 00 00 00       	call   801017f2 <iget>
80101703:	83 c4 10             	add    $0x10,%esp
80101706:	eb 2d                	jmp    80101735 <ialloc+0xdf>
80101708:	83 ec 0c             	sub    $0xc,%esp
8010170b:	ff 75 f0             	pushl  -0x10(%ebp)
8010170e:	e8 1b eb ff ff       	call   8010022e <brelse>
80101713:	83 c4 10             	add    $0x10,%esp
80101716:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010171a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101720:	39 c2                	cmp    %eax,%edx
80101722:	0f 87 5a ff ff ff    	ja     80101682 <ialloc+0x2c>
80101728:	83 ec 0c             	sub    $0xc,%esp
8010172b:	68 a5 8e 10 80       	push   $0x80108ea5
80101730:	e8 31 ee ff ff       	call   80100566 <panic>
80101735:	c9                   	leave  
80101736:	c3                   	ret    

80101737 <iupdate>:
80101737:	55                   	push   %ebp
80101738:	89 e5                	mov    %esp,%ebp
8010173a:	83 ec 18             	sub    $0x18,%esp
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
8010175e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101761:	8d 50 18             	lea    0x18(%eax),%edx
80101764:	8b 45 08             	mov    0x8(%ebp),%eax
80101767:	8b 40 04             	mov    0x4(%eax),%eax
8010176a:	83 e0 07             	and    $0x7,%eax
8010176d:	c1 e0 06             	shl    $0x6,%eax
80101770:	01 d0                	add    %edx,%eax
80101772:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101775:	8b 45 08             	mov    0x8(%ebp),%eax
80101778:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010177c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010177f:	66 89 10             	mov    %dx,(%eax)
80101782:	8b 45 08             	mov    0x8(%ebp),%eax
80101785:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101789:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010178c:	66 89 50 02          	mov    %dx,0x2(%eax)
80101790:	8b 45 08             	mov    0x8(%ebp),%eax
80101793:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101797:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179a:	66 89 50 04          	mov    %dx,0x4(%eax)
8010179e:	8b 45 08             	mov    0x8(%ebp),%eax
801017a1:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a8:	66 89 50 06          	mov    %dx,0x6(%eax)
801017ac:	8b 45 08             	mov    0x8(%ebp),%eax
801017af:	8b 50 18             	mov    0x18(%eax),%edx
801017b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017b5:	89 50 08             	mov    %edx,0x8(%eax)
801017b8:	8b 45 08             	mov    0x8(%ebp),%eax
801017bb:	8d 50 1c             	lea    0x1c(%eax),%edx
801017be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c1:	83 c0 0c             	add    $0xc,%eax
801017c4:	83 ec 04             	sub    $0x4,%esp
801017c7:	6a 34                	push   $0x34
801017c9:	52                   	push   %edx
801017ca:	50                   	push   %eax
801017cb:	e8 28 3e 00 00       	call   801055f8 <memmove>
801017d0:	83 c4 10             	add    $0x10,%esp
801017d3:	83 ec 0c             	sub    $0xc,%esp
801017d6:	ff 75 f4             	pushl  -0xc(%ebp)
801017d9:	e8 0e 1f 00 00       	call   801036ec <log_write>
801017de:	83 c4 10             	add    $0x10,%esp
801017e1:	83 ec 0c             	sub    $0xc,%esp
801017e4:	ff 75 f4             	pushl  -0xc(%ebp)
801017e7:	e8 42 ea ff ff       	call   8010022e <brelse>
801017ec:	83 c4 10             	add    $0x10,%esp
801017ef:	90                   	nop
801017f0:	c9                   	leave  
801017f1:	c3                   	ret    

801017f2 <iget>:
801017f2:	55                   	push   %ebp
801017f3:	89 e5                	mov    %esp,%ebp
801017f5:	83 ec 18             	sub    $0x18,%esp
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 60 22 11 80       	push   $0x80112260
80101800:	e8 d1 3a 00 00       	call   801052d6 <acquire>
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010180f:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
80101816:	eb 5d                	jmp    80101875 <iget+0x83>
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
80101837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183a:	8b 40 08             	mov    0x8(%eax),%eax
8010183d:	8d 50 01             	lea    0x1(%eax),%edx
80101840:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101843:	89 50 08             	mov    %edx,0x8(%eax)
80101846:	83 ec 0c             	sub    $0xc,%esp
80101849:	68 60 22 11 80       	push   $0x80112260
8010184e:	e8 ea 3a 00 00       	call   8010533d <release>
80101853:	83 c4 10             	add    $0x10,%esp
80101856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101859:	eb 74                	jmp    801018cf <iget+0xdd>
8010185b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010185f:	75 10                	jne    80101871 <iget+0x7f>
80101861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101864:	8b 40 08             	mov    0x8(%eax),%eax
80101867:	85 c0                	test   %eax,%eax
80101869:	75 06                	jne    80101871 <iget+0x7f>
8010186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101871:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101875:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
8010187c:	72 9a                	jb     80101818 <iget+0x26>
8010187e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101882:	75 0d                	jne    80101891 <iget+0x9f>
80101884:	83 ec 0c             	sub    $0xc,%esp
80101887:	68 b7 8e 10 80       	push   $0x80108eb7
8010188c:	e8 d5 ec ff ff       	call   80100566 <panic>
80101891:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101894:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189a:	8b 55 08             	mov    0x8(%ebp),%edx
8010189d:	89 10                	mov    %edx,(%eax)
8010189f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801018a5:	89 50 04             	mov    %edx,0x4(%eax)
801018a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ab:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
801018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
801018bc:	83 ec 0c             	sub    $0xc,%esp
801018bf:	68 60 22 11 80       	push   $0x80112260
801018c4:	e8 74 3a 00 00       	call   8010533d <release>
801018c9:	83 c4 10             	add    $0x10,%esp
801018cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018cf:	c9                   	leave  
801018d0:	c3                   	ret    

801018d1 <idup>:
801018d1:	55                   	push   %ebp
801018d2:	89 e5                	mov    %esp,%ebp
801018d4:	83 ec 08             	sub    $0x8,%esp
801018d7:	83 ec 0c             	sub    $0xc,%esp
801018da:	68 60 22 11 80       	push   $0x80112260
801018df:	e8 f2 39 00 00       	call   801052d6 <acquire>
801018e4:	83 c4 10             	add    $0x10,%esp
801018e7:	8b 45 08             	mov    0x8(%ebp),%eax
801018ea:	8b 40 08             	mov    0x8(%eax),%eax
801018ed:	8d 50 01             	lea    0x1(%eax),%edx
801018f0:	8b 45 08             	mov    0x8(%ebp),%eax
801018f3:	89 50 08             	mov    %edx,0x8(%eax)
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	68 60 22 11 80       	push   $0x80112260
801018fe:	e8 3a 3a 00 00       	call   8010533d <release>
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	8b 45 08             	mov    0x8(%ebp),%eax
80101909:	c9                   	leave  
8010190a:	c3                   	ret    

8010190b <ilock>:
8010190b:	55                   	push   %ebp
8010190c:	89 e5                	mov    %esp,%ebp
8010190e:	83 ec 18             	sub    $0x18,%esp
80101911:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101915:	74 0a                	je     80101921 <ilock+0x16>
80101917:	8b 45 08             	mov    0x8(%ebp),%eax
8010191a:	8b 40 08             	mov    0x8(%eax),%eax
8010191d:	85 c0                	test   %eax,%eax
8010191f:	7f 0d                	jg     8010192e <ilock+0x23>
80101921:	83 ec 0c             	sub    $0xc,%esp
80101924:	68 c7 8e 10 80       	push   $0x80108ec7
80101929:	e8 38 ec ff ff       	call   80100566 <panic>
8010192e:	83 ec 0c             	sub    $0xc,%esp
80101931:	68 60 22 11 80       	push   $0x80112260
80101936:	e8 9b 39 00 00       	call   801052d6 <acquire>
8010193b:	83 c4 10             	add    $0x10,%esp
8010193e:	eb 13                	jmp    80101953 <ilock+0x48>
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	68 60 22 11 80       	push   $0x80112260
80101948:	ff 75 08             	pushl  0x8(%ebp)
8010194b:	e8 1d 35 00 00       	call   80104e6d <sleep>
80101950:	83 c4 10             	add    $0x10,%esp
80101953:	8b 45 08             	mov    0x8(%ebp),%eax
80101956:	8b 40 0c             	mov    0xc(%eax),%eax
80101959:	83 e0 01             	and    $0x1,%eax
8010195c:	85 c0                	test   %eax,%eax
8010195e:	75 e0                	jne    80101940 <ilock+0x35>
80101960:	8b 45 08             	mov    0x8(%ebp),%eax
80101963:	8b 40 0c             	mov    0xc(%eax),%eax
80101966:	83 c8 01             	or     $0x1,%eax
80101969:	89 c2                	mov    %eax,%edx
8010196b:	8b 45 08             	mov    0x8(%ebp),%eax
8010196e:	89 50 0c             	mov    %edx,0xc(%eax)
80101971:	83 ec 0c             	sub    $0xc,%esp
80101974:	68 60 22 11 80       	push   $0x80112260
80101979:	e8 bf 39 00 00       	call   8010533d <release>
8010197e:	83 c4 10             	add    $0x10,%esp
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
80101984:	8b 40 0c             	mov    0xc(%eax),%eax
80101987:	83 e0 02             	and    $0x2,%eax
8010198a:	85 c0                	test   %eax,%eax
8010198c:	0f 85 ce 00 00 00    	jne    80101a60 <ilock+0x155>
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
801019b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b6:	8d 50 18             	lea    0x18(%eax),%edx
801019b9:	8b 45 08             	mov    0x8(%ebp),%eax
801019bc:	8b 40 04             	mov    0x4(%eax),%eax
801019bf:	83 e0 07             	and    $0x7,%eax
801019c2:	c1 e0 06             	shl    $0x6,%eax
801019c5:	01 d0                	add    %edx,%eax
801019c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019cd:	0f b7 10             	movzwl (%eax),%edx
801019d0:	8b 45 08             	mov    0x8(%ebp),%eax
801019d3:	66 89 50 10          	mov    %dx,0x10(%eax)
801019d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019da:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019de:	8b 45 08             	mov    0x8(%ebp),%eax
801019e1:	66 89 50 12          	mov    %dx,0x12(%eax)
801019e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019e8:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019ec:	8b 45 08             	mov    0x8(%ebp),%eax
801019ef:	66 89 50 14          	mov    %dx,0x14(%eax)
801019f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f6:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019fa:	8b 45 08             	mov    0x8(%ebp),%eax
801019fd:	66 89 50 16          	mov    %dx,0x16(%eax)
80101a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a04:	8b 50 08             	mov    0x8(%eax),%edx
80101a07:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0a:	89 50 18             	mov    %edx,0x18(%eax)
80101a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a10:	8d 50 0c             	lea    0xc(%eax),%edx
80101a13:	8b 45 08             	mov    0x8(%ebp),%eax
80101a16:	83 c0 1c             	add    $0x1c,%eax
80101a19:	83 ec 04             	sub    $0x4,%esp
80101a1c:	6a 34                	push   $0x34
80101a1e:	52                   	push   %edx
80101a1f:	50                   	push   %eax
80101a20:	e8 d3 3b 00 00       	call   801055f8 <memmove>
80101a25:	83 c4 10             	add    $0x10,%esp
80101a28:	83 ec 0c             	sub    $0xc,%esp
80101a2b:	ff 75 f4             	pushl  -0xc(%ebp)
80101a2e:	e8 fb e7 ff ff       	call   8010022e <brelse>
80101a33:	83 c4 10             	add    $0x10,%esp
80101a36:	8b 45 08             	mov    0x8(%ebp),%eax
80101a39:	8b 40 0c             	mov    0xc(%eax),%eax
80101a3c:	83 c8 02             	or     $0x2,%eax
80101a3f:	89 c2                	mov    %eax,%edx
80101a41:	8b 45 08             	mov    0x8(%ebp),%eax
80101a44:	89 50 0c             	mov    %edx,0xc(%eax)
80101a47:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a4e:	66 85 c0             	test   %ax,%ax
80101a51:	75 0d                	jne    80101a60 <ilock+0x155>
80101a53:	83 ec 0c             	sub    $0xc,%esp
80101a56:	68 cd 8e 10 80       	push   $0x80108ecd
80101a5b:	e8 06 eb ff ff       	call   80100566 <panic>
80101a60:	90                   	nop
80101a61:	c9                   	leave  
80101a62:	c3                   	ret    

80101a63 <iunlock>:
80101a63:	55                   	push   %ebp
80101a64:	89 e5                	mov    %esp,%ebp
80101a66:	83 ec 08             	sub    $0x8,%esp
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
80101a86:	83 ec 0c             	sub    $0xc,%esp
80101a89:	68 dc 8e 10 80       	push   $0x80108edc
80101a8e:	e8 d3 ea ff ff       	call   80100566 <panic>
80101a93:	83 ec 0c             	sub    $0xc,%esp
80101a96:	68 60 22 11 80       	push   $0x80112260
80101a9b:	e8 36 38 00 00       	call   801052d6 <acquire>
80101aa0:	83 c4 10             	add    $0x10,%esp
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	8b 40 0c             	mov    0xc(%eax),%eax
80101aa9:	83 e0 fe             	and    $0xfffffffe,%eax
80101aac:	89 c2                	mov    %eax,%edx
80101aae:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab1:	89 50 0c             	mov    %edx,0xc(%eax)
80101ab4:	83 ec 0c             	sub    $0xc,%esp
80101ab7:	ff 75 08             	pushl  0x8(%ebp)
80101aba:	e8 9c 34 00 00       	call   80104f5b <wakeup>
80101abf:	83 c4 10             	add    $0x10,%esp
80101ac2:	83 ec 0c             	sub    $0xc,%esp
80101ac5:	68 60 22 11 80       	push   $0x80112260
80101aca:	e8 6e 38 00 00       	call   8010533d <release>
80101acf:	83 c4 10             	add    $0x10,%esp
80101ad2:	90                   	nop
80101ad3:	c9                   	leave  
80101ad4:	c3                   	ret    

80101ad5 <iput>:
80101ad5:	55                   	push   %ebp
80101ad6:	89 e5                	mov    %esp,%ebp
80101ad8:	83 ec 08             	sub    $0x8,%esp
80101adb:	83 ec 0c             	sub    $0xc,%esp
80101ade:	68 60 22 11 80       	push   $0x80112260
80101ae3:	e8 ee 37 00 00       	call   801052d6 <acquire>
80101ae8:	83 c4 10             	add    $0x10,%esp
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
80101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1e:	8b 40 0c             	mov    0xc(%eax),%eax
80101b21:	83 e0 01             	and    $0x1,%eax
80101b24:	85 c0                	test   %eax,%eax
80101b26:	74 0d                	je     80101b35 <iput+0x60>
80101b28:	83 ec 0c             	sub    $0xc,%esp
80101b2b:	68 e4 8e 10 80       	push   $0x80108ee4
80101b30:	e8 31 ea ff ff       	call   80100566 <panic>
80101b35:	8b 45 08             	mov    0x8(%ebp),%eax
80101b38:	8b 40 0c             	mov    0xc(%eax),%eax
80101b3b:	83 c8 01             	or     $0x1,%eax
80101b3e:	89 c2                	mov    %eax,%edx
80101b40:	8b 45 08             	mov    0x8(%ebp),%eax
80101b43:	89 50 0c             	mov    %edx,0xc(%eax)
80101b46:	83 ec 0c             	sub    $0xc,%esp
80101b49:	68 60 22 11 80       	push   $0x80112260
80101b4e:	e8 ea 37 00 00       	call   8010533d <release>
80101b53:	83 c4 10             	add    $0x10,%esp
80101b56:	83 ec 0c             	sub    $0xc,%esp
80101b59:	ff 75 08             	pushl  0x8(%ebp)
80101b5c:	e8 a8 01 00 00       	call   80101d09 <itrunc>
80101b61:	83 c4 10             	add    $0x10,%esp
80101b64:	8b 45 08             	mov    0x8(%ebp),%eax
80101b67:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
80101b6d:	83 ec 0c             	sub    $0xc,%esp
80101b70:	ff 75 08             	pushl  0x8(%ebp)
80101b73:	e8 bf fb ff ff       	call   80101737 <iupdate>
80101b78:	83 c4 10             	add    $0x10,%esp
80101b7b:	83 ec 0c             	sub    $0xc,%esp
80101b7e:	68 60 22 11 80       	push   $0x80112260
80101b83:	e8 4e 37 00 00       	call   801052d6 <acquire>
80101b88:	83 c4 10             	add    $0x10,%esp
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
80101b95:	83 ec 0c             	sub    $0xc,%esp
80101b98:	ff 75 08             	pushl  0x8(%ebp)
80101b9b:	e8 bb 33 00 00       	call   80104f5b <wakeup>
80101ba0:	83 c4 10             	add    $0x10,%esp
80101ba3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba6:	8b 40 08             	mov    0x8(%eax),%eax
80101ba9:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bac:	8b 45 08             	mov    0x8(%ebp),%eax
80101baf:	89 50 08             	mov    %edx,0x8(%eax)
80101bb2:	83 ec 0c             	sub    $0xc,%esp
80101bb5:	68 60 22 11 80       	push   $0x80112260
80101bba:	e8 7e 37 00 00       	call   8010533d <release>
80101bbf:	83 c4 10             	add    $0x10,%esp
80101bc2:	90                   	nop
80101bc3:	c9                   	leave  
80101bc4:	c3                   	ret    

80101bc5 <iunlockput>:
80101bc5:	55                   	push   %ebp
80101bc6:	89 e5                	mov    %esp,%ebp
80101bc8:	83 ec 08             	sub    $0x8,%esp
80101bcb:	83 ec 0c             	sub    $0xc,%esp
80101bce:	ff 75 08             	pushl  0x8(%ebp)
80101bd1:	e8 8d fe ff ff       	call   80101a63 <iunlock>
80101bd6:	83 c4 10             	add    $0x10,%esp
80101bd9:	83 ec 0c             	sub    $0xc,%esp
80101bdc:	ff 75 08             	pushl  0x8(%ebp)
80101bdf:	e8 f1 fe ff ff       	call   80101ad5 <iput>
80101be4:	83 c4 10             	add    $0x10,%esp
80101be7:	90                   	nop
80101be8:	c9                   	leave  
80101be9:	c3                   	ret    

80101bea <bmap>:
80101bea:	55                   	push   %ebp
80101beb:	89 e5                	mov    %esp,%ebp
80101bed:	53                   	push   %ebx
80101bee:	83 ec 14             	sub    $0x14,%esp
80101bf1:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bf5:	77 42                	ja     80101c39 <bmap+0x4f>
80101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bfd:	83 c2 04             	add    $0x4,%edx
80101c00:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c0b:	75 24                	jne    80101c31 <bmap+0x47>
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
80101c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c34:	e9 cb 00 00 00       	jmp    80101d04 <bmap+0x11a>
80101c39:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)
80101c3d:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c41:	0f 87 b0 00 00 00    	ja     80101cf7 <bmap+0x10d>
80101c47:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c54:	75 1d                	jne    80101c73 <bmap+0x89>
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
80101c73:	8b 45 08             	mov    0x8(%ebp),%eax
80101c76:	8b 00                	mov    (%eax),%eax
80101c78:	83 ec 08             	sub    $0x8,%esp
80101c7b:	ff 75 f4             	pushl  -0xc(%ebp)
80101c7e:	50                   	push   %eax
80101c7f:	e8 32 e5 ff ff       	call   801001b6 <bread>
80101c84:	83 c4 10             	add    $0x10,%esp
80101c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c8d:	83 c0 18             	add    $0x18,%eax
80101c90:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101c93:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ca0:	01 d0                	add    %edx,%eax
80101ca2:	8b 00                	mov    (%eax),%eax
80101ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cab:	75 37                	jne    80101ce4 <bmap+0xfa>
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
80101cd6:	83 ec 0c             	sub    $0xc,%esp
80101cd9:	ff 75 f0             	pushl  -0x10(%ebp)
80101cdc:	e8 0b 1a 00 00       	call   801036ec <log_write>
80101ce1:	83 c4 10             	add    $0x10,%esp
80101ce4:	83 ec 0c             	sub    $0xc,%esp
80101ce7:	ff 75 f0             	pushl  -0x10(%ebp)
80101cea:	e8 3f e5 ff ff       	call   8010022e <brelse>
80101cef:	83 c4 10             	add    $0x10,%esp
80101cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cf5:	eb 0d                	jmp    80101d04 <bmap+0x11a>
80101cf7:	83 ec 0c             	sub    $0xc,%esp
80101cfa:	68 ee 8e 10 80       	push   $0x80108eee
80101cff:	e8 62 e8 ff ff       	call   80100566 <panic>
80101d04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d07:	c9                   	leave  
80101d08:	c3                   	ret    

80101d09 <itrunc>:
80101d09:	55                   	push   %ebp
80101d0a:	89 e5                	mov    %esp,%ebp
80101d0c:	83 ec 18             	sub    $0x18,%esp
80101d0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d16:	eb 45                	jmp    80101d5d <itrunc+0x54>
80101d18:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d1e:	83 c2 04             	add    $0x4,%edx
80101d21:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d25:	85 c0                	test   %eax,%eax
80101d27:	74 30                	je     80101d59 <itrunc+0x50>
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
80101d48:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d4e:	83 c2 04             	add    $0x4,%edx
80101d51:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d58:	00 
80101d59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d5d:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d61:	7e b5                	jle    80101d18 <itrunc+0xf>
80101d63:	8b 45 08             	mov    0x8(%ebp),%eax
80101d66:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d69:	85 c0                	test   %eax,%eax
80101d6b:	0f 84 a1 00 00 00    	je     80101e12 <itrunc+0x109>
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
80101d8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d8f:	83 c0 18             	add    $0x18,%eax
80101d92:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101d95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d9c:	eb 3c                	jmp    80101dda <itrunc+0xd1>
80101d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101da1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dab:	01 d0                	add    %edx,%eax
80101dad:	8b 00                	mov    (%eax),%eax
80101daf:	85 c0                	test   %eax,%eax
80101db1:	74 23                	je     80101dd6 <itrunc+0xcd>
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
80101dd6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ddd:	83 f8 7f             	cmp    $0x7f,%eax
80101de0:	76 bc                	jbe    80101d9e <itrunc+0x95>
80101de2:	83 ec 0c             	sub    $0xc,%esp
80101de5:	ff 75 ec             	pushl  -0x14(%ebp)
80101de8:	e8 41 e4 ff ff       	call   8010022e <brelse>
80101ded:	83 c4 10             	add    $0x10,%esp
80101df0:	8b 45 08             	mov    0x8(%ebp),%eax
80101df3:	8b 40 4c             	mov    0x4c(%eax),%eax
80101df6:	8b 55 08             	mov    0x8(%ebp),%edx
80101df9:	8b 12                	mov    (%edx),%edx
80101dfb:	83 ec 08             	sub    $0x8,%esp
80101dfe:	50                   	push   %eax
80101dff:	52                   	push   %edx
80101e00:	e8 58 f7 ff ff       	call   8010155d <bfree>
80101e05:	83 c4 10             	add    $0x10,%esp
80101e08:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0b:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
80101e12:	8b 45 08             	mov    0x8(%ebp),%eax
80101e15:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	ff 75 08             	pushl  0x8(%ebp)
80101e22:	e8 10 f9 ff ff       	call   80101737 <iupdate>
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	90                   	nop
80101e2b:	c9                   	leave  
80101e2c:	c3                   	ret    

80101e2d <stati>:
80101e2d:	55                   	push   %ebp
80101e2e:	89 e5                	mov    %esp,%ebp
80101e30:	8b 45 08             	mov    0x8(%ebp),%eax
80101e33:	8b 00                	mov    (%eax),%eax
80101e35:	89 c2                	mov    %eax,%edx
80101e37:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e3a:	89 50 04             	mov    %edx,0x4(%eax)
80101e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e40:	8b 50 04             	mov    0x4(%eax),%edx
80101e43:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e46:	89 50 08             	mov    %edx,0x8(%eax)
80101e49:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4c:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e50:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e53:	66 89 10             	mov    %dx,(%eax)
80101e56:	8b 45 08             	mov    0x8(%ebp),%eax
80101e59:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e60:	66 89 50 0c          	mov    %dx,0xc(%eax)
80101e64:	8b 45 08             	mov    0x8(%ebp),%eax
80101e67:	8b 50 18             	mov    0x18(%eax),%edx
80101e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e6d:	89 50 10             	mov    %edx,0x10(%eax)
80101e70:	90                   	nop
80101e71:	5d                   	pop    %ebp
80101e72:	c3                   	ret    

80101e73 <readi>:
80101e73:	55                   	push   %ebp
80101e74:	89 e5                	mov    %esp,%ebp
80101e76:	83 ec 18             	sub    $0x18,%esp
80101e79:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e80:	66 83 f8 03          	cmp    $0x3,%ax
80101e84:	75 5c                	jne    80101ee2 <readi+0x6f>
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
80101eb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb7:	e9 0c 01 00 00       	jmp    80101fc8 <readi+0x155>
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
80101ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee5:	8b 40 18             	mov    0x18(%eax),%eax
80101ee8:	3b 45 10             	cmp    0x10(%ebp),%eax
80101eeb:	72 0d                	jb     80101efa <readi+0x87>
80101eed:	8b 55 10             	mov    0x10(%ebp),%edx
80101ef0:	8b 45 14             	mov    0x14(%ebp),%eax
80101ef3:	01 d0                	add    %edx,%eax
80101ef5:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ef8:	73 0a                	jae    80101f04 <readi+0x91>
80101efa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eff:	e9 c4 00 00 00       	jmp    80101fc8 <readi+0x155>
80101f04:	8b 55 10             	mov    0x10(%ebp),%edx
80101f07:	8b 45 14             	mov    0x14(%ebp),%eax
80101f0a:	01 c2                	add    %eax,%edx
80101f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0f:	8b 40 18             	mov    0x18(%eax),%eax
80101f12:	39 c2                	cmp    %eax,%edx
80101f14:	76 0c                	jbe    80101f22 <readi+0xaf>
80101f16:	8b 45 08             	mov    0x8(%ebp),%eax
80101f19:	8b 40 18             	mov    0x18(%eax),%eax
80101f1c:	2b 45 10             	sub    0x10(%ebp),%eax
80101f1f:	89 45 14             	mov    %eax,0x14(%ebp)
80101f22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f29:	e9 8b 00 00 00       	jmp    80101fb9 <readi+0x146>
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
80101f5a:	8b 45 10             	mov    0x10(%ebp),%eax
80101f5d:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f62:	ba 00 02 00 00       	mov    $0x200,%edx
80101f67:	29 c2                	sub    %eax,%edx
80101f69:	8b 45 14             	mov    0x14(%ebp),%eax
80101f6c:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f6f:	39 c2                	cmp    %eax,%edx
80101f71:	0f 46 c2             	cmovbe %edx,%eax
80101f74:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f7a:	8d 50 18             	lea    0x18(%eax),%edx
80101f7d:	8b 45 10             	mov    0x10(%ebp),%eax
80101f80:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f85:	01 d0                	add    %edx,%eax
80101f87:	83 ec 04             	sub    $0x4,%esp
80101f8a:	ff 75 ec             	pushl  -0x14(%ebp)
80101f8d:	50                   	push   %eax
80101f8e:	ff 75 0c             	pushl  0xc(%ebp)
80101f91:	e8 62 36 00 00       	call   801055f8 <memmove>
80101f96:	83 c4 10             	add    $0x10,%esp
80101f99:	83 ec 0c             	sub    $0xc,%esp
80101f9c:	ff 75 f0             	pushl  -0x10(%ebp)
80101f9f:	e8 8a e2 ff ff       	call   8010022e <brelse>
80101fa4:	83 c4 10             	add    $0x10,%esp
80101fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101faa:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fb0:	01 45 10             	add    %eax,0x10(%ebp)
80101fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fb6:	01 45 0c             	add    %eax,0xc(%ebp)
80101fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fbc:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fbf:	0f 82 69 ff ff ff    	jb     80101f2e <readi+0xbb>
80101fc5:	8b 45 14             	mov    0x14(%ebp),%eax
80101fc8:	c9                   	leave  
80101fc9:	c3                   	ret    

80101fca <writei>:
80101fca:	55                   	push   %ebp
80101fcb:	89 e5                	mov    %esp,%ebp
80101fcd:	83 ec 18             	sub    $0x18,%esp
80101fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101fd7:	66 83 f8 03          	cmp    $0x3,%ax
80101fdb:	75 5c                	jne    80102039 <writei+0x6f>
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
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	e9 3d 01 00 00       	jmp    80102150 <writei+0x186>
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
80102039:	8b 45 08             	mov    0x8(%ebp),%eax
8010203c:	8b 40 18             	mov    0x18(%eax),%eax
8010203f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102042:	72 0d                	jb     80102051 <writei+0x87>
80102044:	8b 55 10             	mov    0x10(%ebp),%edx
80102047:	8b 45 14             	mov    0x14(%ebp),%eax
8010204a:	01 d0                	add    %edx,%eax
8010204c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010204f:	73 0a                	jae    8010205b <writei+0x91>
80102051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102056:	e9 f5 00 00 00       	jmp    80102150 <writei+0x186>
8010205b:	8b 55 10             	mov    0x10(%ebp),%edx
8010205e:	8b 45 14             	mov    0x14(%ebp),%eax
80102061:	01 d0                	add    %edx,%eax
80102063:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102068:	76 0a                	jbe    80102074 <writei+0xaa>
8010206a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010206f:	e9 dc 00 00 00       	jmp    80102150 <writei+0x186>
80102074:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010207b:	e9 99 00 00 00       	jmp    80102119 <writei+0x14f>
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
801020ac:	8b 45 10             	mov    0x10(%ebp),%eax
801020af:	25 ff 01 00 00       	and    $0x1ff,%eax
801020b4:	ba 00 02 00 00       	mov    $0x200,%edx
801020b9:	29 c2                	sub    %eax,%edx
801020bb:	8b 45 14             	mov    0x14(%ebp),%eax
801020be:	2b 45 f4             	sub    -0xc(%ebp),%eax
801020c1:	39 c2                	cmp    %eax,%edx
801020c3:	0f 46 c2             	cmovbe %edx,%eax
801020c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801020c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020cc:	8d 50 18             	lea    0x18(%eax),%edx
801020cf:	8b 45 10             	mov    0x10(%ebp),%eax
801020d2:	25 ff 01 00 00       	and    $0x1ff,%eax
801020d7:	01 d0                	add    %edx,%eax
801020d9:	83 ec 04             	sub    $0x4,%esp
801020dc:	ff 75 ec             	pushl  -0x14(%ebp)
801020df:	ff 75 0c             	pushl  0xc(%ebp)
801020e2:	50                   	push   %eax
801020e3:	e8 10 35 00 00       	call   801055f8 <memmove>
801020e8:	83 c4 10             	add    $0x10,%esp
801020eb:	83 ec 0c             	sub    $0xc,%esp
801020ee:	ff 75 f0             	pushl  -0x10(%ebp)
801020f1:	e8 f6 15 00 00       	call   801036ec <log_write>
801020f6:	83 c4 10             	add    $0x10,%esp
801020f9:	83 ec 0c             	sub    $0xc,%esp
801020fc:	ff 75 f0             	pushl  -0x10(%ebp)
801020ff:	e8 2a e1 ff ff       	call   8010022e <brelse>
80102104:	83 c4 10             	add    $0x10,%esp
80102107:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010210a:	01 45 f4             	add    %eax,-0xc(%ebp)
8010210d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102110:	01 45 10             	add    %eax,0x10(%ebp)
80102113:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102116:	01 45 0c             	add    %eax,0xc(%ebp)
80102119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010211c:	3b 45 14             	cmp    0x14(%ebp),%eax
8010211f:	0f 82 5b ff ff ff    	jb     80102080 <writei+0xb6>
80102125:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102129:	74 22                	je     8010214d <writei+0x183>
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
8010212e:	8b 40 18             	mov    0x18(%eax),%eax
80102131:	3b 45 10             	cmp    0x10(%ebp),%eax
80102134:	73 17                	jae    8010214d <writei+0x183>
80102136:	8b 45 08             	mov    0x8(%ebp),%eax
80102139:	8b 55 10             	mov    0x10(%ebp),%edx
8010213c:	89 50 18             	mov    %edx,0x18(%eax)
8010213f:	83 ec 0c             	sub    $0xc,%esp
80102142:	ff 75 08             	pushl  0x8(%ebp)
80102145:	e8 ed f5 ff ff       	call   80101737 <iupdate>
8010214a:	83 c4 10             	add    $0x10,%esp
8010214d:	8b 45 14             	mov    0x14(%ebp),%eax
80102150:	c9                   	leave  
80102151:	c3                   	ret    

80102152 <namecmp>:
80102152:	55                   	push   %ebp
80102153:	89 e5                	mov    %esp,%ebp
80102155:	83 ec 08             	sub    $0x8,%esp
80102158:	83 ec 04             	sub    $0x4,%esp
8010215b:	6a 0e                	push   $0xe
8010215d:	ff 75 0c             	pushl  0xc(%ebp)
80102160:	ff 75 08             	pushl  0x8(%ebp)
80102163:	e8 26 35 00 00       	call   8010568e <strncmp>
80102168:	83 c4 10             	add    $0x10,%esp
8010216b:	c9                   	leave  
8010216c:	c3                   	ret    

8010216d <dirlookup>:
8010216d:	55                   	push   %ebp
8010216e:	89 e5                	mov    %esp,%ebp
80102170:	83 ec 28             	sub    $0x28,%esp
80102173:	8b 45 08             	mov    0x8(%ebp),%eax
80102176:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010217a:	66 83 f8 01          	cmp    $0x1,%ax
8010217e:	74 0d                	je     8010218d <dirlookup+0x20>
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	68 01 8f 10 80       	push   $0x80108f01
80102188:	e8 d9 e3 ff ff       	call   80100566 <panic>
8010218d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102194:	eb 7b                	jmp    80102211 <dirlookup+0xa4>
80102196:	6a 10                	push   $0x10
80102198:	ff 75 f4             	pushl  -0xc(%ebp)
8010219b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010219e:	50                   	push   %eax
8010219f:	ff 75 08             	pushl  0x8(%ebp)
801021a2:	e8 cc fc ff ff       	call   80101e73 <readi>
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	83 f8 10             	cmp    $0x10,%eax
801021ad:	74 0d                	je     801021bc <dirlookup+0x4f>
801021af:	83 ec 0c             	sub    $0xc,%esp
801021b2:	68 13 8f 10 80       	push   $0x80108f13
801021b7:	e8 aa e3 ff ff       	call   80100566 <panic>
801021bc:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021c0:	66 85 c0             	test   %ax,%ax
801021c3:	74 47                	je     8010220c <dirlookup+0x9f>
801021c5:	83 ec 08             	sub    $0x8,%esp
801021c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021cb:	83 c0 02             	add    $0x2,%eax
801021ce:	50                   	push   %eax
801021cf:	ff 75 0c             	pushl  0xc(%ebp)
801021d2:	e8 7b ff ff ff       	call   80102152 <namecmp>
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	85 c0                	test   %eax,%eax
801021dc:	75 2f                	jne    8010220d <dirlookup+0xa0>
801021de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021e2:	74 08                	je     801021ec <dirlookup+0x7f>
801021e4:	8b 45 10             	mov    0x10(%ebp),%eax
801021e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021ea:	89 10                	mov    %edx,(%eax)
801021ec:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021f0:	0f b7 c0             	movzwl %ax,%eax
801021f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021f6:	8b 45 08             	mov    0x8(%ebp),%eax
801021f9:	8b 00                	mov    (%eax),%eax
801021fb:	83 ec 08             	sub    $0x8,%esp
801021fe:	ff 75 f0             	pushl  -0x10(%ebp)
80102201:	50                   	push   %eax
80102202:	e8 eb f5 ff ff       	call   801017f2 <iget>
80102207:	83 c4 10             	add    $0x10,%esp
8010220a:	eb 19                	jmp    80102225 <dirlookup+0xb8>
8010220c:	90                   	nop
8010220d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102211:	8b 45 08             	mov    0x8(%ebp),%eax
80102214:	8b 40 18             	mov    0x18(%eax),%eax
80102217:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010221a:	0f 87 76 ff ff ff    	ja     80102196 <dirlookup+0x29>
80102220:	b8 00 00 00 00       	mov    $0x0,%eax
80102225:	c9                   	leave  
80102226:	c3                   	ret    

80102227 <dirlink>:
80102227:	55                   	push   %ebp
80102228:	89 e5                	mov    %esp,%ebp
8010222a:	83 ec 28             	sub    $0x28,%esp
8010222d:	83 ec 04             	sub    $0x4,%esp
80102230:	6a 00                	push   $0x0
80102232:	ff 75 0c             	pushl  0xc(%ebp)
80102235:	ff 75 08             	pushl  0x8(%ebp)
80102238:	e8 30 ff ff ff       	call   8010216d <dirlookup>
8010223d:	83 c4 10             	add    $0x10,%esp
80102240:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102243:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102247:	74 18                	je     80102261 <dirlink+0x3a>
80102249:	83 ec 0c             	sub    $0xc,%esp
8010224c:	ff 75 f0             	pushl  -0x10(%ebp)
8010224f:	e8 81 f8 ff ff       	call   80101ad5 <iput>
80102254:	83 c4 10             	add    $0x10,%esp
80102257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010225c:	e9 9c 00 00 00       	jmp    801022fd <dirlink+0xd6>
80102261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102268:	eb 39                	jmp    801022a3 <dirlink+0x7c>
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
80102284:	83 ec 0c             	sub    $0xc,%esp
80102287:	68 13 8f 10 80       	push   $0x80108f13
8010228c:	e8 d5 e2 ff ff       	call   80100566 <panic>
80102291:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102295:	66 85 c0             	test   %ax,%ax
80102298:	74 18                	je     801022b2 <dirlink+0x8b>
8010229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010229d:	83 c0 10             	add    $0x10,%eax
801022a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022a3:	8b 45 08             	mov    0x8(%ebp),%eax
801022a6:	8b 50 18             	mov    0x18(%eax),%edx
801022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022ac:	39 c2                	cmp    %eax,%edx
801022ae:	77 ba                	ja     8010226a <dirlink+0x43>
801022b0:	eb 01                	jmp    801022b3 <dirlink+0x8c>
801022b2:	90                   	nop
801022b3:	83 ec 04             	sub    $0x4,%esp
801022b6:	6a 0e                	push   $0xe
801022b8:	ff 75 0c             	pushl  0xc(%ebp)
801022bb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022be:	83 c0 02             	add    $0x2,%eax
801022c1:	50                   	push   %eax
801022c2:	e8 1d 34 00 00       	call   801056e4 <strncpy>
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	8b 45 10             	mov    0x10(%ebp),%eax
801022cd:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
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
801022eb:	83 ec 0c             	sub    $0xc,%esp
801022ee:	68 20 8f 10 80       	push   $0x80108f20
801022f3:	e8 6e e2 ff ff       	call   80100566 <panic>
801022f8:	b8 00 00 00 00       	mov    $0x0,%eax
801022fd:	c9                   	leave  
801022fe:	c3                   	ret    

801022ff <skipelem>:
801022ff:	55                   	push   %ebp
80102300:	89 e5                	mov    %esp,%ebp
80102302:	83 ec 18             	sub    $0x18,%esp
80102305:	eb 04                	jmp    8010230b <skipelem+0xc>
80102307:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010230b:	8b 45 08             	mov    0x8(%ebp),%eax
8010230e:	0f b6 00             	movzbl (%eax),%eax
80102311:	3c 2f                	cmp    $0x2f,%al
80102313:	74 f2                	je     80102307 <skipelem+0x8>
80102315:	8b 45 08             	mov    0x8(%ebp),%eax
80102318:	0f b6 00             	movzbl (%eax),%eax
8010231b:	84 c0                	test   %al,%al
8010231d:	75 07                	jne    80102326 <skipelem+0x27>
8010231f:	b8 00 00 00 00       	mov    $0x0,%eax
80102324:	eb 7b                	jmp    801023a1 <skipelem+0xa2>
80102326:	8b 45 08             	mov    0x8(%ebp),%eax
80102329:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010232c:	eb 04                	jmp    80102332 <skipelem+0x33>
8010232e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80102332:	8b 45 08             	mov    0x8(%ebp),%eax
80102335:	0f b6 00             	movzbl (%eax),%eax
80102338:	3c 2f                	cmp    $0x2f,%al
8010233a:	74 0a                	je     80102346 <skipelem+0x47>
8010233c:	8b 45 08             	mov    0x8(%ebp),%eax
8010233f:	0f b6 00             	movzbl (%eax),%eax
80102342:	84 c0                	test   %al,%al
80102344:	75 e8                	jne    8010232e <skipelem+0x2f>
80102346:	8b 55 08             	mov    0x8(%ebp),%edx
80102349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010234c:	29 c2                	sub    %eax,%edx
8010234e:	89 d0                	mov    %edx,%eax
80102350:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102353:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102357:	7e 15                	jle    8010236e <skipelem+0x6f>
80102359:	83 ec 04             	sub    $0x4,%esp
8010235c:	6a 0e                	push   $0xe
8010235e:	ff 75 f4             	pushl  -0xc(%ebp)
80102361:	ff 75 0c             	pushl  0xc(%ebp)
80102364:	e8 8f 32 00 00       	call   801055f8 <memmove>
80102369:	83 c4 10             	add    $0x10,%esp
8010236c:	eb 26                	jmp    80102394 <skipelem+0x95>
8010236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102371:	83 ec 04             	sub    $0x4,%esp
80102374:	50                   	push   %eax
80102375:	ff 75 f4             	pushl  -0xc(%ebp)
80102378:	ff 75 0c             	pushl  0xc(%ebp)
8010237b:	e8 78 32 00 00       	call   801055f8 <memmove>
80102380:	83 c4 10             	add    $0x10,%esp
80102383:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102386:	8b 45 0c             	mov    0xc(%ebp),%eax
80102389:	01 d0                	add    %edx,%eax
8010238b:	c6 00 00             	movb   $0x0,(%eax)
8010238e:	eb 04                	jmp    80102394 <skipelem+0x95>
80102390:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80102394:	8b 45 08             	mov    0x8(%ebp),%eax
80102397:	0f b6 00             	movzbl (%eax),%eax
8010239a:	3c 2f                	cmp    $0x2f,%al
8010239c:	74 f2                	je     80102390 <skipelem+0x91>
8010239e:	8b 45 08             	mov    0x8(%ebp),%eax
801023a1:	c9                   	leave  
801023a2:	c3                   	ret    

801023a3 <namex>:
801023a3:	55                   	push   %ebp
801023a4:	89 e5                	mov    %esp,%ebp
801023a6:	83 ec 18             	sub    $0x18,%esp
801023a9:	8b 45 08             	mov    0x8(%ebp),%eax
801023ac:	0f b6 00             	movzbl (%eax),%eax
801023af:	3c 2f                	cmp    $0x2f,%al
801023b1:	75 17                	jne    801023ca <namex+0x27>
801023b3:	83 ec 08             	sub    $0x8,%esp
801023b6:	6a 01                	push   $0x1
801023b8:	6a 01                	push   $0x1
801023ba:	e8 33 f4 ff ff       	call   801017f2 <iget>
801023bf:	83 c4 10             	add    $0x10,%esp
801023c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023c5:	e9 bb 00 00 00       	jmp    80102485 <namex+0xe2>
801023ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023d0:	8b 40 68             	mov    0x68(%eax),%eax
801023d3:	83 ec 0c             	sub    $0xc,%esp
801023d6:	50                   	push   %eax
801023d7:	e8 f5 f4 ff ff       	call   801018d1 <idup>
801023dc:	83 c4 10             	add    $0x10,%esp
801023df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023e2:	e9 9e 00 00 00       	jmp    80102485 <namex+0xe2>
801023e7:	83 ec 0c             	sub    $0xc,%esp
801023ea:	ff 75 f4             	pushl  -0xc(%ebp)
801023ed:	e8 19 f5 ff ff       	call   8010190b <ilock>
801023f2:	83 c4 10             	add    $0x10,%esp
801023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023fc:	66 83 f8 01          	cmp    $0x1,%ax
80102400:	74 18                	je     8010241a <namex+0x77>
80102402:	83 ec 0c             	sub    $0xc,%esp
80102405:	ff 75 f4             	pushl  -0xc(%ebp)
80102408:	e8 b8 f7 ff ff       	call   80101bc5 <iunlockput>
8010240d:	83 c4 10             	add    $0x10,%esp
80102410:	b8 00 00 00 00       	mov    $0x0,%eax
80102415:	e9 a7 00 00 00       	jmp    801024c1 <namex+0x11e>
8010241a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010241e:	74 20                	je     80102440 <namex+0x9d>
80102420:	8b 45 08             	mov    0x8(%ebp),%eax
80102423:	0f b6 00             	movzbl (%eax),%eax
80102426:	84 c0                	test   %al,%al
80102428:	75 16                	jne    80102440 <namex+0x9d>
8010242a:	83 ec 0c             	sub    $0xc,%esp
8010242d:	ff 75 f4             	pushl  -0xc(%ebp)
80102430:	e8 2e f6 ff ff       	call   80101a63 <iunlock>
80102435:	83 c4 10             	add    $0x10,%esp
80102438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010243b:	e9 81 00 00 00       	jmp    801024c1 <namex+0x11e>
80102440:	83 ec 04             	sub    $0x4,%esp
80102443:	6a 00                	push   $0x0
80102445:	ff 75 10             	pushl  0x10(%ebp)
80102448:	ff 75 f4             	pushl  -0xc(%ebp)
8010244b:	e8 1d fd ff ff       	call   8010216d <dirlookup>
80102450:	83 c4 10             	add    $0x10,%esp
80102453:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102456:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010245a:	75 15                	jne    80102471 <namex+0xce>
8010245c:	83 ec 0c             	sub    $0xc,%esp
8010245f:	ff 75 f4             	pushl  -0xc(%ebp)
80102462:	e8 5e f7 ff ff       	call   80101bc5 <iunlockput>
80102467:	83 c4 10             	add    $0x10,%esp
8010246a:	b8 00 00 00 00       	mov    $0x0,%eax
8010246f:	eb 50                	jmp    801024c1 <namex+0x11e>
80102471:	83 ec 0c             	sub    $0xc,%esp
80102474:	ff 75 f4             	pushl  -0xc(%ebp)
80102477:	e8 49 f7 ff ff       	call   80101bc5 <iunlockput>
8010247c:	83 c4 10             	add    $0x10,%esp
8010247f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102482:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102485:	83 ec 08             	sub    $0x8,%esp
80102488:	ff 75 10             	pushl  0x10(%ebp)
8010248b:	ff 75 08             	pushl  0x8(%ebp)
8010248e:	e8 6c fe ff ff       	call   801022ff <skipelem>
80102493:	83 c4 10             	add    $0x10,%esp
80102496:	89 45 08             	mov    %eax,0x8(%ebp)
80102499:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010249d:	0f 85 44 ff ff ff    	jne    801023e7 <namex+0x44>
801024a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024a7:	74 15                	je     801024be <namex+0x11b>
801024a9:	83 ec 0c             	sub    $0xc,%esp
801024ac:	ff 75 f4             	pushl  -0xc(%ebp)
801024af:	e8 21 f6 ff ff       	call   80101ad5 <iput>
801024b4:	83 c4 10             	add    $0x10,%esp
801024b7:	b8 00 00 00 00       	mov    $0x0,%eax
801024bc:	eb 03                	jmp    801024c1 <namex+0x11e>
801024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024c1:	c9                   	leave  
801024c2:	c3                   	ret    

801024c3 <namei>:
801024c3:	55                   	push   %ebp
801024c4:	89 e5                	mov    %esp,%ebp
801024c6:	83 ec 18             	sub    $0x18,%esp
801024c9:	83 ec 04             	sub    $0x4,%esp
801024cc:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024cf:	50                   	push   %eax
801024d0:	6a 00                	push   $0x0
801024d2:	ff 75 08             	pushl  0x8(%ebp)
801024d5:	e8 c9 fe ff ff       	call   801023a3 <namex>
801024da:	83 c4 10             	add    $0x10,%esp
801024dd:	c9                   	leave  
801024de:	c3                   	ret    

801024df <nameiparent>:
801024df:	55                   	push   %ebp
801024e0:	89 e5                	mov    %esp,%ebp
801024e2:	83 ec 08             	sub    $0x8,%esp
801024e5:	83 ec 04             	sub    $0x4,%esp
801024e8:	ff 75 0c             	pushl  0xc(%ebp)
801024eb:	6a 01                	push   $0x1
801024ed:	ff 75 08             	pushl  0x8(%ebp)
801024f0:	e8 ae fe ff ff       	call   801023a3 <namex>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	c9                   	leave  
801024f9:	c3                   	ret    

801024fa <inb>:
801024fa:	55                   	push   %ebp
801024fb:	89 e5                	mov    %esp,%ebp
801024fd:	83 ec 14             	sub    $0x14,%esp
80102500:	8b 45 08             	mov    0x8(%ebp),%eax
80102503:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
80102507:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010250b:	89 c2                	mov    %eax,%edx
8010250d:	ec                   	in     (%dx),%al
8010250e:	88 45 ff             	mov    %al,-0x1(%ebp)
80102511:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80102515:	c9                   	leave  
80102516:	c3                   	ret    

80102517 <insl>:
80102517:	55                   	push   %ebp
80102518:	89 e5                	mov    %esp,%ebp
8010251a:	57                   	push   %edi
8010251b:	53                   	push   %ebx
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
80102538:	90                   	nop
80102539:	5b                   	pop    %ebx
8010253a:	5f                   	pop    %edi
8010253b:	5d                   	pop    %ebp
8010253c:	c3                   	ret    

8010253d <outb>:
8010253d:	55                   	push   %ebp
8010253e:	89 e5                	mov    %esp,%ebp
80102540:	83 ec 08             	sub    $0x8,%esp
80102543:	8b 55 08             	mov    0x8(%ebp),%edx
80102546:	8b 45 0c             	mov    0xc(%ebp),%eax
80102549:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010254d:	88 45 f8             	mov    %al,-0x8(%ebp)
80102550:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102554:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102558:	ee                   	out    %al,(%dx)
80102559:	90                   	nop
8010255a:	c9                   	leave  
8010255b:	c3                   	ret    

8010255c <outsl>:
8010255c:	55                   	push   %ebp
8010255d:	89 e5                	mov    %esp,%ebp
8010255f:	56                   	push   %esi
80102560:	53                   	push   %ebx
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
8010257d:	90                   	nop
8010257e:	5b                   	pop    %ebx
8010257f:	5e                   	pop    %esi
80102580:	5d                   	pop    %ebp
80102581:	c3                   	ret    

80102582 <idewait>:
80102582:	55                   	push   %ebp
80102583:	89 e5                	mov    %esp,%ebp
80102585:	83 ec 10             	sub    $0x10,%esp
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
801025a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025ad:	74 11                	je     801025c0 <idewait+0x3e>
801025af:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025b2:	83 e0 21             	and    $0x21,%eax
801025b5:	85 c0                	test   %eax,%eax
801025b7:	74 07                	je     801025c0 <idewait+0x3e>
801025b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025be:	eb 05                	jmp    801025c5 <idewait+0x43>
801025c0:	b8 00 00 00 00       	mov    $0x0,%eax
801025c5:	c9                   	leave  
801025c6:	c3                   	ret    

801025c7 <ideinit>:
801025c7:	55                   	push   %ebp
801025c8:	89 e5                	mov    %esp,%ebp
801025ca:	83 ec 18             	sub    $0x18,%esp
801025cd:	83 ec 08             	sub    $0x8,%esp
801025d0:	68 28 8f 10 80       	push   $0x80108f28
801025d5:	68 20 c6 10 80       	push   $0x8010c620
801025da:	e8 d5 2c 00 00       	call   801052b4 <initlock>
801025df:	83 c4 10             	add    $0x10,%esp
801025e2:	83 ec 0c             	sub    $0xc,%esp
801025e5:	6a 0e                	push   $0xe
801025e7:	e8 90 18 00 00       	call   80103e7c <picenable>
801025ec:	83 c4 10             	add    $0x10,%esp
801025ef:	a1 60 39 11 80       	mov    0x80113960,%eax
801025f4:	83 e8 01             	sub    $0x1,%eax
801025f7:	83 ec 08             	sub    $0x8,%esp
801025fa:	50                   	push   %eax
801025fb:	6a 0e                	push   $0xe
801025fd:	e8 37 04 00 00       	call   80102a39 <ioapicenable>
80102602:	83 c4 10             	add    $0x10,%esp
80102605:	83 ec 0c             	sub    $0xc,%esp
80102608:	6a 00                	push   $0x0
8010260a:	e8 73 ff ff ff       	call   80102582 <idewait>
8010260f:	83 c4 10             	add    $0x10,%esp
80102612:	83 ec 08             	sub    $0x8,%esp
80102615:	68 f0 00 00 00       	push   $0xf0
8010261a:	68 f6 01 00 00       	push   $0x1f6
8010261f:	e8 19 ff ff ff       	call   8010253d <outb>
80102624:	83 c4 10             	add    $0x10,%esp
80102627:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010262e:	eb 24                	jmp    80102654 <ideinit+0x8d>
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	68 f7 01 00 00       	push   $0x1f7
80102638:	e8 bd fe ff ff       	call   801024fa <inb>
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	84 c0                	test   %al,%al
80102642:	74 0c                	je     80102650 <ideinit+0x89>
80102644:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
8010264b:	00 00 00 
8010264e:	eb 0d                	jmp    8010265d <ideinit+0x96>
80102650:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102654:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010265b:	7e d3                	jle    80102630 <ideinit+0x69>
8010265d:	83 ec 08             	sub    $0x8,%esp
80102660:	68 e0 00 00 00       	push   $0xe0
80102665:	68 f6 01 00 00       	push   $0x1f6
8010266a:	e8 ce fe ff ff       	call   8010253d <outb>
8010266f:	83 c4 10             	add    $0x10,%esp
80102672:	90                   	nop
80102673:	c9                   	leave  
80102674:	c3                   	ret    

80102675 <idestart>:
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
80102678:	83 ec 08             	sub    $0x8,%esp
8010267b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010267f:	75 0d                	jne    8010268e <idestart+0x19>
80102681:	83 ec 0c             	sub    $0xc,%esp
80102684:	68 2c 8f 10 80       	push   $0x80108f2c
80102689:	e8 d8 de ff ff       	call   80100566 <panic>
8010268e:	83 ec 0c             	sub    $0xc,%esp
80102691:	6a 00                	push   $0x0
80102693:	e8 ea fe ff ff       	call   80102582 <idewait>
80102698:	83 c4 10             	add    $0x10,%esp
8010269b:	83 ec 08             	sub    $0x8,%esp
8010269e:	6a 00                	push   $0x0
801026a0:	68 f6 03 00 00       	push   $0x3f6
801026a5:	e8 93 fe ff ff       	call   8010253d <outb>
801026aa:	83 c4 10             	add    $0x10,%esp
801026ad:	83 ec 08             	sub    $0x8,%esp
801026b0:	6a 01                	push   $0x1
801026b2:	68 f2 01 00 00       	push   $0x1f2
801026b7:	e8 81 fe ff ff       	call   8010253d <outb>
801026bc:	83 c4 10             	add    $0x10,%esp
801026bf:	8b 45 08             	mov    0x8(%ebp),%eax
801026c2:	8b 40 08             	mov    0x8(%eax),%eax
801026c5:	0f b6 c0             	movzbl %al,%eax
801026c8:	83 ec 08             	sub    $0x8,%esp
801026cb:	50                   	push   %eax
801026cc:	68 f3 01 00 00       	push   $0x1f3
801026d1:	e8 67 fe ff ff       	call   8010253d <outb>
801026d6:	83 c4 10             	add    $0x10,%esp
801026d9:	8b 45 08             	mov    0x8(%ebp),%eax
801026dc:	8b 40 08             	mov    0x8(%eax),%eax
801026df:	c1 e8 08             	shr    $0x8,%eax
801026e2:	0f b6 c0             	movzbl %al,%eax
801026e5:	83 ec 08             	sub    $0x8,%esp
801026e8:	50                   	push   %eax
801026e9:	68 f4 01 00 00       	push   $0x1f4
801026ee:	e8 4a fe ff ff       	call   8010253d <outb>
801026f3:	83 c4 10             	add    $0x10,%esp
801026f6:	8b 45 08             	mov    0x8(%ebp),%eax
801026f9:	8b 40 08             	mov    0x8(%eax),%eax
801026fc:	c1 e8 10             	shr    $0x10,%eax
801026ff:	0f b6 c0             	movzbl %al,%eax
80102702:	83 ec 08             	sub    $0x8,%esp
80102705:	50                   	push   %eax
80102706:	68 f5 01 00 00       	push   $0x1f5
8010270b:	e8 2d fe ff ff       	call   8010253d <outb>
80102710:	83 c4 10             	add    $0x10,%esp
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
80102746:	8b 45 08             	mov    0x8(%ebp),%eax
80102749:	8b 00                	mov    (%eax),%eax
8010274b:	83 e0 04             	and    $0x4,%eax
8010274e:	85 c0                	test   %eax,%eax
80102750:	74 30                	je     80102782 <idestart+0x10d>
80102752:	83 ec 08             	sub    $0x8,%esp
80102755:	6a 30                	push   $0x30
80102757:	68 f7 01 00 00       	push   $0x1f7
8010275c:	e8 dc fd ff ff       	call   8010253d <outb>
80102761:	83 c4 10             	add    $0x10,%esp
80102764:	8b 45 08             	mov    0x8(%ebp),%eax
80102767:	83 c0 18             	add    $0x18,%eax
8010276a:	83 ec 04             	sub    $0x4,%esp
8010276d:	68 80 00 00 00       	push   $0x80
80102772:	50                   	push   %eax
80102773:	68 f0 01 00 00       	push   $0x1f0
80102778:	e8 df fd ff ff       	call   8010255c <outsl>
8010277d:	83 c4 10             	add    $0x10,%esp
80102780:	eb 12                	jmp    80102794 <idestart+0x11f>
80102782:	83 ec 08             	sub    $0x8,%esp
80102785:	6a 20                	push   $0x20
80102787:	68 f7 01 00 00       	push   $0x1f7
8010278c:	e8 ac fd ff ff       	call   8010253d <outb>
80102791:	83 c4 10             	add    $0x10,%esp
80102794:	90                   	nop
80102795:	c9                   	leave  
80102796:	c3                   	ret    

80102797 <ideintr>:
80102797:	55                   	push   %ebp
80102798:	89 e5                	mov    %esp,%ebp
8010279a:	83 ec 18             	sub    $0x18,%esp
8010279d:	83 ec 0c             	sub    $0xc,%esp
801027a0:	68 20 c6 10 80       	push   $0x8010c620
801027a5:	e8 2c 2b 00 00       	call   801052d6 <acquire>
801027aa:	83 c4 10             	add    $0x10,%esp
801027ad:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027b9:	75 15                	jne    801027d0 <ideintr+0x39>
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	68 20 c6 10 80       	push   $0x8010c620
801027c3:	e8 75 2b 00 00       	call   8010533d <release>
801027c8:	83 c4 10             	add    $0x10,%esp
801027cb:	e9 9a 00 00 00       	jmp    8010286a <ideintr+0xd3>
801027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d3:	8b 40 14             	mov    0x14(%eax),%eax
801027d6:	a3 54 c6 10 80       	mov    %eax,0x8010c654
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
801027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fb:	83 c0 18             	add    $0x18,%eax
801027fe:	83 ec 04             	sub    $0x4,%esp
80102801:	68 80 00 00 00       	push   $0x80
80102806:	50                   	push   %eax
80102807:	68 f0 01 00 00       	push   $0x1f0
8010280c:	e8 06 fd ff ff       	call   80102517 <insl>
80102811:	83 c4 10             	add    $0x10,%esp
80102814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102817:	8b 00                	mov    (%eax),%eax
80102819:	83 c8 02             	or     $0x2,%eax
8010281c:	89 c2                	mov    %eax,%edx
8010281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102821:	89 10                	mov    %edx,(%eax)
80102823:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102826:	8b 00                	mov    (%eax),%eax
80102828:	83 e0 fb             	and    $0xfffffffb,%eax
8010282b:	89 c2                	mov    %eax,%edx
8010282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102830:	89 10                	mov    %edx,(%eax)
80102832:	83 ec 0c             	sub    $0xc,%esp
80102835:	ff 75 f4             	pushl  -0xc(%ebp)
80102838:	e8 1e 27 00 00       	call   80104f5b <wakeup>
8010283d:	83 c4 10             	add    $0x10,%esp
80102840:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102845:	85 c0                	test   %eax,%eax
80102847:	74 11                	je     8010285a <ideintr+0xc3>
80102849:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010284e:	83 ec 0c             	sub    $0xc,%esp
80102851:	50                   	push   %eax
80102852:	e8 1e fe ff ff       	call   80102675 <idestart>
80102857:	83 c4 10             	add    $0x10,%esp
8010285a:	83 ec 0c             	sub    $0xc,%esp
8010285d:	68 20 c6 10 80       	push   $0x8010c620
80102862:	e8 d6 2a 00 00       	call   8010533d <release>
80102867:	83 c4 10             	add    $0x10,%esp
8010286a:	c9                   	leave  
8010286b:	c3                   	ret    

8010286c <iderw>:
8010286c:	55                   	push   %ebp
8010286d:	89 e5                	mov    %esp,%ebp
8010286f:	83 ec 18             	sub    $0x18,%esp
80102872:	8b 45 08             	mov    0x8(%ebp),%eax
80102875:	8b 00                	mov    (%eax),%eax
80102877:	83 e0 01             	and    $0x1,%eax
8010287a:	85 c0                	test   %eax,%eax
8010287c:	75 0d                	jne    8010288b <iderw+0x1f>
8010287e:	83 ec 0c             	sub    $0xc,%esp
80102881:	68 35 8f 10 80       	push   $0x80108f35
80102886:	e8 db dc ff ff       	call   80100566 <panic>
8010288b:	8b 45 08             	mov    0x8(%ebp),%eax
8010288e:	8b 00                	mov    (%eax),%eax
80102890:	83 e0 06             	and    $0x6,%eax
80102893:	83 f8 02             	cmp    $0x2,%eax
80102896:	75 0d                	jne    801028a5 <iderw+0x39>
80102898:	83 ec 0c             	sub    $0xc,%esp
8010289b:	68 49 8f 10 80       	push   $0x80108f49
801028a0:	e8 c1 dc ff ff       	call   80100566 <panic>
801028a5:	8b 45 08             	mov    0x8(%ebp),%eax
801028a8:	8b 40 04             	mov    0x4(%eax),%eax
801028ab:	85 c0                	test   %eax,%eax
801028ad:	74 16                	je     801028c5 <iderw+0x59>
801028af:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801028b4:	85 c0                	test   %eax,%eax
801028b6:	75 0d                	jne    801028c5 <iderw+0x59>
801028b8:	83 ec 0c             	sub    $0xc,%esp
801028bb:	68 5e 8f 10 80       	push   $0x80108f5e
801028c0:	e8 a1 dc ff ff       	call   80100566 <panic>
801028c5:	83 ec 0c             	sub    $0xc,%esp
801028c8:	68 20 c6 10 80       	push   $0x8010c620
801028cd:	e8 04 2a 00 00       	call   801052d6 <acquire>
801028d2:	83 c4 10             	add    $0x10,%esp
801028d5:	8b 45 08             	mov    0x8(%ebp),%eax
801028d8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
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
801028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ff:	8b 55 08             	mov    0x8(%ebp),%edx
80102902:	89 10                	mov    %edx,(%eax)
80102904:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102909:	3b 45 08             	cmp    0x8(%ebp),%eax
8010290c:	75 23                	jne    80102931 <iderw+0xc5>
8010290e:	83 ec 0c             	sub    $0xc,%esp
80102911:	ff 75 08             	pushl  0x8(%ebp)
80102914:	e8 5c fd ff ff       	call   80102675 <idestart>
80102919:	83 c4 10             	add    $0x10,%esp
8010291c:	eb 13                	jmp    80102931 <iderw+0xc5>
8010291e:	83 ec 08             	sub    $0x8,%esp
80102921:	68 20 c6 10 80       	push   $0x8010c620
80102926:	ff 75 08             	pushl  0x8(%ebp)
80102929:	e8 3f 25 00 00       	call   80104e6d <sleep>
8010292e:	83 c4 10             	add    $0x10,%esp
80102931:	8b 45 08             	mov    0x8(%ebp),%eax
80102934:	8b 00                	mov    (%eax),%eax
80102936:	83 e0 06             	and    $0x6,%eax
80102939:	83 f8 02             	cmp    $0x2,%eax
8010293c:	75 e0                	jne    8010291e <iderw+0xb2>
8010293e:	83 ec 0c             	sub    $0xc,%esp
80102941:	68 20 c6 10 80       	push   $0x8010c620
80102946:	e8 f2 29 00 00       	call   8010533d <release>
8010294b:	83 c4 10             	add    $0x10,%esp
8010294e:	90                   	nop
8010294f:	c9                   	leave  
80102950:	c3                   	ret    

80102951 <ioapicread>:
80102951:	55                   	push   %ebp
80102952:	89 e5                	mov    %esp,%ebp
80102954:	a1 34 32 11 80       	mov    0x80113234,%eax
80102959:	8b 55 08             	mov    0x8(%ebp),%edx
8010295c:	89 10                	mov    %edx,(%eax)
8010295e:	a1 34 32 11 80       	mov    0x80113234,%eax
80102963:	8b 40 10             	mov    0x10(%eax),%eax
80102966:	5d                   	pop    %ebp
80102967:	c3                   	ret    

80102968 <ioapicwrite>:
80102968:	55                   	push   %ebp
80102969:	89 e5                	mov    %esp,%ebp
8010296b:	a1 34 32 11 80       	mov    0x80113234,%eax
80102970:	8b 55 08             	mov    0x8(%ebp),%edx
80102973:	89 10                	mov    %edx,(%eax)
80102975:	a1 34 32 11 80       	mov    0x80113234,%eax
8010297a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010297d:	89 50 10             	mov    %edx,0x10(%eax)
80102980:	90                   	nop
80102981:	5d                   	pop    %ebp
80102982:	c3                   	ret    

80102983 <ioapicinit>:
80102983:	55                   	push   %ebp
80102984:	89 e5                	mov    %esp,%ebp
80102986:	83 ec 18             	sub    $0x18,%esp
80102989:	a1 64 33 11 80       	mov    0x80113364,%eax
8010298e:	85 c0                	test   %eax,%eax
80102990:	0f 84 a0 00 00 00    	je     80102a36 <ioapicinit+0xb3>
80102996:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
8010299d:	00 c0 fe 
801029a0:	6a 01                	push   $0x1
801029a2:	e8 aa ff ff ff       	call   80102951 <ioapicread>
801029a7:	83 c4 04             	add    $0x4,%esp
801029aa:	c1 e8 10             	shr    $0x10,%eax
801029ad:	25 ff 00 00 00       	and    $0xff,%eax
801029b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801029b5:	6a 00                	push   $0x0
801029b7:	e8 95 ff ff ff       	call   80102951 <ioapicread>
801029bc:	83 c4 04             	add    $0x4,%esp
801029bf:	c1 e8 18             	shr    $0x18,%eax
801029c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
801029c5:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
801029cc:	0f b6 c0             	movzbl %al,%eax
801029cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801029d2:	74 10                	je     801029e4 <ioapicinit+0x61>
801029d4:	83 ec 0c             	sub    $0xc,%esp
801029d7:	68 7c 8f 10 80       	push   $0x80108f7c
801029dc:	e8 e5 d9 ff ff       	call   801003c6 <cprintf>
801029e1:	83 c4 10             	add    $0x10,%esp
801029e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029eb:	eb 3f                	jmp    80102a2c <ioapicinit+0xa9>
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
80102a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a12:	83 c0 08             	add    $0x8,%eax
80102a15:	01 c0                	add    %eax,%eax
80102a17:	83 c0 01             	add    $0x1,%eax
80102a1a:	83 ec 08             	sub    $0x8,%esp
80102a1d:	6a 00                	push   $0x0
80102a1f:	50                   	push   %eax
80102a20:	e8 43 ff ff ff       	call   80102968 <ioapicwrite>
80102a25:	83 c4 10             	add    $0x10,%esp
80102a28:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a2f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a32:	7e b9                	jle    801029ed <ioapicinit+0x6a>
80102a34:	eb 01                	jmp    80102a37 <ioapicinit+0xb4>
80102a36:	90                   	nop
80102a37:	c9                   	leave  
80102a38:	c3                   	ret    

80102a39 <ioapicenable>:
80102a39:	55                   	push   %ebp
80102a3a:	89 e5                	mov    %esp,%ebp
80102a3c:	a1 64 33 11 80       	mov    0x80113364,%eax
80102a41:	85 c0                	test   %eax,%eax
80102a43:	74 39                	je     80102a7e <ioapicenable+0x45>
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
80102a7e:	90                   	nop
80102a7f:	c9                   	leave  
80102a80:	c3                   	ret    

80102a81 <v2p>:
80102a81:	55                   	push   %ebp
80102a82:	89 e5                	mov    %esp,%ebp
80102a84:	8b 45 08             	mov    0x8(%ebp),%eax
80102a87:	05 00 00 00 80       	add    $0x80000000,%eax
80102a8c:	5d                   	pop    %ebp
80102a8d:	c3                   	ret    

80102a8e <kinit1>:
80102a8e:	55                   	push   %ebp
80102a8f:	89 e5                	mov    %esp,%ebp
80102a91:	83 ec 08             	sub    $0x8,%esp
80102a94:	83 ec 08             	sub    $0x8,%esp
80102a97:	68 ae 8f 10 80       	push   $0x80108fae
80102a9c:	68 40 32 11 80       	push   $0x80113240
80102aa1:	e8 0e 28 00 00       	call   801052b4 <initlock>
80102aa6:	83 c4 10             	add    $0x10,%esp
80102aa9:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
80102ab0:	00 00 00 
80102ab3:	83 ec 08             	sub    $0x8,%esp
80102ab6:	ff 75 0c             	pushl  0xc(%ebp)
80102ab9:	ff 75 08             	pushl  0x8(%ebp)
80102abc:	e8 2a 00 00 00       	call   80102aeb <freerange>
80102ac1:	83 c4 10             	add    $0x10,%esp
80102ac4:	90                   	nop
80102ac5:	c9                   	leave  
80102ac6:	c3                   	ret    

80102ac7 <kinit2>:
80102ac7:	55                   	push   %ebp
80102ac8:	89 e5                	mov    %esp,%ebp
80102aca:	83 ec 08             	sub    $0x8,%esp
80102acd:	83 ec 08             	sub    $0x8,%esp
80102ad0:	ff 75 0c             	pushl  0xc(%ebp)
80102ad3:	ff 75 08             	pushl  0x8(%ebp)
80102ad6:	e8 10 00 00 00       	call   80102aeb <freerange>
80102adb:	83 c4 10             	add    $0x10,%esp
80102ade:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102ae5:	00 00 00 
80102ae8:	90                   	nop
80102ae9:	c9                   	leave  
80102aea:	c3                   	ret    

80102aeb <freerange>:
80102aeb:	55                   	push   %ebp
80102aec:	89 e5                	mov    %esp,%ebp
80102aee:	83 ec 18             	sub    $0x18,%esp
80102af1:	8b 45 08             	mov    0x8(%ebp),%eax
80102af4:	05 ff 0f 00 00       	add    $0xfff,%eax
80102af9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b01:	eb 15                	jmp    80102b18 <freerange+0x2d>
80102b03:	83 ec 0c             	sub    $0xc,%esp
80102b06:	ff 75 f4             	pushl  -0xc(%ebp)
80102b09:	e8 1a 00 00 00       	call   80102b28 <kfree>
80102b0e:	83 c4 10             	add    $0x10,%esp
80102b11:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1b:	05 00 10 00 00       	add    $0x1000,%eax
80102b20:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b23:	76 de                	jbe    80102b03 <freerange+0x18>
80102b25:	90                   	nop
80102b26:	c9                   	leave  
80102b27:	c3                   	ret    

80102b28 <kfree>:
80102b28:	55                   	push   %ebp
80102b29:	89 e5                	mov    %esp,%ebp
80102b2b:	83 ec 18             	sub    $0x18,%esp
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
80102b55:	83 ec 0c             	sub    $0xc,%esp
80102b58:	68 b3 8f 10 80       	push   $0x80108fb3
80102b5d:	e8 04 da ff ff       	call   80100566 <panic>
80102b62:	83 ec 04             	sub    $0x4,%esp
80102b65:	68 00 10 00 00       	push   $0x1000
80102b6a:	6a 01                	push   $0x1
80102b6c:	ff 75 08             	pushl  0x8(%ebp)
80102b6f:	e8 c5 29 00 00       	call   80105539 <memset>
80102b74:	83 c4 10             	add    $0x10,%esp
80102b77:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	74 10                	je     80102b90 <kfree+0x68>
80102b80:	83 ec 0c             	sub    $0xc,%esp
80102b83:	68 40 32 11 80       	push   $0x80113240
80102b88:	e8 49 27 00 00       	call   801052d6 <acquire>
80102b8d:	83 c4 10             	add    $0x10,%esp
80102b90:	8b 45 08             	mov    0x8(%ebp),%eax
80102b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b96:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9f:	89 10                	mov    %edx,(%eax)
80102ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba4:	a3 78 32 11 80       	mov    %eax,0x80113278
80102ba9:	a1 74 32 11 80       	mov    0x80113274,%eax
80102bae:	85 c0                	test   %eax,%eax
80102bb0:	74 10                	je     80102bc2 <kfree+0x9a>
80102bb2:	83 ec 0c             	sub    $0xc,%esp
80102bb5:	68 40 32 11 80       	push   $0x80113240
80102bba:	e8 7e 27 00 00       	call   8010533d <release>
80102bbf:	83 c4 10             	add    $0x10,%esp
80102bc2:	90                   	nop
80102bc3:	c9                   	leave  
80102bc4:	c3                   	ret    

80102bc5 <kalloc>:
80102bc5:	55                   	push   %ebp
80102bc6:	89 e5                	mov    %esp,%ebp
80102bc8:	83 ec 18             	sub    $0x18,%esp
80102bcb:	a1 74 32 11 80       	mov    0x80113274,%eax
80102bd0:	85 c0                	test   %eax,%eax
80102bd2:	74 10                	je     80102be4 <kalloc+0x1f>
80102bd4:	83 ec 0c             	sub    $0xc,%esp
80102bd7:	68 40 32 11 80       	push   $0x80113240
80102bdc:	e8 f5 26 00 00       	call   801052d6 <acquire>
80102be1:	83 c4 10             	add    $0x10,%esp
80102be4:	a1 78 32 11 80       	mov    0x80113278,%eax
80102be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bf0:	74 0a                	je     80102bfc <kalloc+0x37>
80102bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf5:	8b 00                	mov    (%eax),%eax
80102bf7:	a3 78 32 11 80       	mov    %eax,0x80113278
80102bfc:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c01:	85 c0                	test   %eax,%eax
80102c03:	74 10                	je     80102c15 <kalloc+0x50>
80102c05:	83 ec 0c             	sub    $0xc,%esp
80102c08:	68 40 32 11 80       	push   $0x80113240
80102c0d:	e8 2b 27 00 00       	call   8010533d <release>
80102c12:	83 c4 10             	add    $0x10,%esp
80102c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c18:	c9                   	leave  
80102c19:	c3                   	ret    

80102c1a <inb>:
80102c1a:	55                   	push   %ebp
80102c1b:	89 e5                	mov    %esp,%ebp
80102c1d:	83 ec 14             	sub    $0x14,%esp
80102c20:	8b 45 08             	mov    0x8(%ebp),%eax
80102c23:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
80102c27:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c2b:	89 c2                	mov    %eax,%edx
80102c2d:	ec                   	in     (%dx),%al
80102c2e:	88 45 ff             	mov    %al,-0x1(%ebp)
80102c31:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80102c35:	c9                   	leave  
80102c36:	c3                   	ret    

80102c37 <kbdgetc>:
80102c37:	55                   	push   %ebp
80102c38:	89 e5                	mov    %esp,%ebp
80102c3a:	83 ec 10             	sub    $0x10,%esp
80102c3d:	6a 64                	push   $0x64
80102c3f:	e8 d6 ff ff ff       	call   80102c1a <inb>
80102c44:	83 c4 04             	add    $0x4,%esp
80102c47:	0f b6 c0             	movzbl %al,%eax
80102c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c50:	83 e0 01             	and    $0x1,%eax
80102c53:	85 c0                	test   %eax,%eax
80102c55:	75 0a                	jne    80102c61 <kbdgetc+0x2a>
80102c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c5c:	e9 23 01 00 00       	jmp    80102d84 <kbdgetc+0x14d>
80102c61:	6a 60                	push   $0x60
80102c63:	e8 b2 ff ff ff       	call   80102c1a <inb>
80102c68:	83 c4 04             	add    $0x4,%esp
80102c6b:	0f b6 c0             	movzbl %al,%eax
80102c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102c71:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c78:	75 17                	jne    80102c91 <kbdgetc+0x5a>
80102c7a:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c7f:	83 c8 40             	or     $0x40,%eax
80102c82:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
80102c87:	b8 00 00 00 00       	mov    $0x0,%eax
80102c8c:	e9 f3 00 00 00       	jmp    80102d84 <kbdgetc+0x14d>
80102c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c94:	25 80 00 00 00       	and    $0x80,%eax
80102c99:	85 c0                	test   %eax,%eax
80102c9b:	74 45                	je     80102ce2 <kbdgetc+0xab>
80102c9d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ca2:	83 e0 40             	and    $0x40,%eax
80102ca5:	85 c0                	test   %eax,%eax
80102ca7:	75 08                	jne    80102cb1 <kbdgetc+0x7a>
80102ca9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cac:	83 e0 7f             	and    $0x7f,%eax
80102caf:	eb 03                	jmp    80102cb4 <kbdgetc+0x7d>
80102cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
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
80102cd8:	b8 00 00 00 00       	mov    $0x0,%eax
80102cdd:	e9 a2 00 00 00       	jmp    80102d84 <kbdgetc+0x14d>
80102ce2:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ce7:	83 e0 40             	and    $0x40,%eax
80102cea:	85 c0                	test   %eax,%eax
80102cec:	74 14                	je     80102d02 <kbdgetc+0xcb>
80102cee:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
80102cf5:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cfa:	83 e0 bf             	and    $0xffffffbf,%eax
80102cfd:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
80102d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d05:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d0a:	0f b6 00             	movzbl (%eax),%eax
80102d0d:	0f b6 d0             	movzbl %al,%edx
80102d10:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d15:	09 d0                	or     %edx,%eax
80102d17:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
80102d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d1f:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102d24:	0f b6 00             	movzbl (%eax),%eax
80102d27:	0f b6 d0             	movzbl %al,%edx
80102d2a:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d2f:	31 d0                	xor    %edx,%eax
80102d31:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
80102d36:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d3b:	83 e0 03             	and    $0x3,%eax
80102d3e:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d48:	01 d0                	add    %edx,%eax
80102d4a:	0f b6 00             	movzbl (%eax),%eax
80102d4d:	0f b6 c0             	movzbl %al,%eax
80102d50:	89 45 f8             	mov    %eax,-0x8(%ebp)
80102d53:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d58:	83 e0 08             	and    $0x8,%eax
80102d5b:	85 c0                	test   %eax,%eax
80102d5d:	74 22                	je     80102d81 <kbdgetc+0x14a>
80102d5f:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d63:	76 0c                	jbe    80102d71 <kbdgetc+0x13a>
80102d65:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d69:	77 06                	ja     80102d71 <kbdgetc+0x13a>
80102d6b:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d6f:	eb 10                	jmp    80102d81 <kbdgetc+0x14a>
80102d71:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d75:	76 0a                	jbe    80102d81 <kbdgetc+0x14a>
80102d77:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d7b:	77 04                	ja     80102d81 <kbdgetc+0x14a>
80102d7d:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
80102d81:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102d84:	c9                   	leave  
80102d85:	c3                   	ret    

80102d86 <kbdintr>:
80102d86:	55                   	push   %ebp
80102d87:	89 e5                	mov    %esp,%ebp
80102d89:	83 ec 08             	sub    $0x8,%esp
80102d8c:	83 ec 0c             	sub    $0xc,%esp
80102d8f:	68 37 2c 10 80       	push   $0x80102c37
80102d94:	e8 44 da ff ff       	call   801007dd <consoleintr>
80102d99:	83 c4 10             	add    $0x10,%esp
80102d9c:	90                   	nop
80102d9d:	c9                   	leave  
80102d9e:	c3                   	ret    

80102d9f <inb>:
80102d9f:	55                   	push   %ebp
80102da0:	89 e5                	mov    %esp,%ebp
80102da2:	83 ec 14             	sub    $0x14,%esp
80102da5:	8b 45 08             	mov    0x8(%ebp),%eax
80102da8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
80102dac:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102db0:	89 c2                	mov    %eax,%edx
80102db2:	ec                   	in     (%dx),%al
80102db3:	88 45 ff             	mov    %al,-0x1(%ebp)
80102db6:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80102dba:	c9                   	leave  
80102dbb:	c3                   	ret    

80102dbc <outb>:
80102dbc:	55                   	push   %ebp
80102dbd:	89 e5                	mov    %esp,%ebp
80102dbf:	83 ec 08             	sub    $0x8,%esp
80102dc2:	8b 55 08             	mov    0x8(%ebp),%edx
80102dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dc8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102dcc:	88 45 f8             	mov    %al,-0x8(%ebp)
80102dcf:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102dd3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102dd7:	ee                   	out    %al,(%dx)
80102dd8:	90                   	nop
80102dd9:	c9                   	leave  
80102dda:	c3                   	ret    

80102ddb <readeflags>:
80102ddb:	55                   	push   %ebp
80102ddc:	89 e5                	mov    %esp,%ebp
80102dde:	83 ec 10             	sub    $0x10,%esp
80102de1:	9c                   	pushf  
80102de2:	58                   	pop    %eax
80102de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102de9:	c9                   	leave  
80102dea:	c3                   	ret    

80102deb <lapicw>:
80102deb:	55                   	push   %ebp
80102dec:	89 e5                	mov    %esp,%ebp
80102dee:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102df3:	8b 55 08             	mov    0x8(%ebp),%edx
80102df6:	c1 e2 02             	shl    $0x2,%edx
80102df9:	01 c2                	add    %eax,%edx
80102dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dfe:	89 02                	mov    %eax,(%edx)
80102e00:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e05:	83 c0 20             	add    $0x20,%eax
80102e08:	8b 00                	mov    (%eax),%eax
80102e0a:	90                   	nop
80102e0b:	5d                   	pop    %ebp
80102e0c:	c3                   	ret    

80102e0d <lapicinit>:
80102e0d:	55                   	push   %ebp
80102e0e:	89 e5                	mov    %esp,%ebp
80102e10:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e15:	85 c0                	test   %eax,%eax
80102e17:	0f 84 0b 01 00 00    	je     80102f28 <lapicinit+0x11b>
80102e1d:	68 3f 01 00 00       	push   $0x13f
80102e22:	6a 3c                	push   $0x3c
80102e24:	e8 c2 ff ff ff       	call   80102deb <lapicw>
80102e29:	83 c4 08             	add    $0x8,%esp
80102e2c:	6a 0b                	push   $0xb
80102e2e:	68 f8 00 00 00       	push   $0xf8
80102e33:	e8 b3 ff ff ff       	call   80102deb <lapicw>
80102e38:	83 c4 08             	add    $0x8,%esp
80102e3b:	68 20 00 02 00       	push   $0x20020
80102e40:	68 c8 00 00 00       	push   $0xc8
80102e45:	e8 a1 ff ff ff       	call   80102deb <lapicw>
80102e4a:	83 c4 08             	add    $0x8,%esp
80102e4d:	68 80 96 98 00       	push   $0x989680
80102e52:	68 e0 00 00 00       	push   $0xe0
80102e57:	e8 8f ff ff ff       	call   80102deb <lapicw>
80102e5c:	83 c4 08             	add    $0x8,%esp
80102e5f:	68 00 00 01 00       	push   $0x10000
80102e64:	68 d4 00 00 00       	push   $0xd4
80102e69:	e8 7d ff ff ff       	call   80102deb <lapicw>
80102e6e:	83 c4 08             	add    $0x8,%esp
80102e71:	68 00 00 01 00       	push   $0x10000
80102e76:	68 d8 00 00 00       	push   $0xd8
80102e7b:	e8 6b ff ff ff       	call   80102deb <lapicw>
80102e80:	83 c4 08             	add    $0x8,%esp
80102e83:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e88:	83 c0 30             	add    $0x30,%eax
80102e8b:	8b 00                	mov    (%eax),%eax
80102e8d:	c1 e8 10             	shr    $0x10,%eax
80102e90:	0f b6 c0             	movzbl %al,%eax
80102e93:	83 f8 03             	cmp    $0x3,%eax
80102e96:	76 12                	jbe    80102eaa <lapicinit+0x9d>
80102e98:	68 00 00 01 00       	push   $0x10000
80102e9d:	68 d0 00 00 00       	push   $0xd0
80102ea2:	e8 44 ff ff ff       	call   80102deb <lapicw>
80102ea7:	83 c4 08             	add    $0x8,%esp
80102eaa:	6a 33                	push   $0x33
80102eac:	68 dc 00 00 00       	push   $0xdc
80102eb1:	e8 35 ff ff ff       	call   80102deb <lapicw>
80102eb6:	83 c4 08             	add    $0x8,%esp
80102eb9:	6a 00                	push   $0x0
80102ebb:	68 a0 00 00 00       	push   $0xa0
80102ec0:	e8 26 ff ff ff       	call   80102deb <lapicw>
80102ec5:	83 c4 08             	add    $0x8,%esp
80102ec8:	6a 00                	push   $0x0
80102eca:	68 a0 00 00 00       	push   $0xa0
80102ecf:	e8 17 ff ff ff       	call   80102deb <lapicw>
80102ed4:	83 c4 08             	add    $0x8,%esp
80102ed7:	6a 00                	push   $0x0
80102ed9:	6a 2c                	push   $0x2c
80102edb:	e8 0b ff ff ff       	call   80102deb <lapicw>
80102ee0:	83 c4 08             	add    $0x8,%esp
80102ee3:	6a 00                	push   $0x0
80102ee5:	68 c4 00 00 00       	push   $0xc4
80102eea:	e8 fc fe ff ff       	call   80102deb <lapicw>
80102eef:	83 c4 08             	add    $0x8,%esp
80102ef2:	68 00 85 08 00       	push   $0x88500
80102ef7:	68 c0 00 00 00       	push   $0xc0
80102efc:	e8 ea fe ff ff       	call   80102deb <lapicw>
80102f01:	83 c4 08             	add    $0x8,%esp
80102f04:	90                   	nop
80102f05:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f0a:	05 00 03 00 00       	add    $0x300,%eax
80102f0f:	8b 00                	mov    (%eax),%eax
80102f11:	25 00 10 00 00       	and    $0x1000,%eax
80102f16:	85 c0                	test   %eax,%eax
80102f18:	75 eb                	jne    80102f05 <lapicinit+0xf8>
80102f1a:	6a 00                	push   $0x0
80102f1c:	6a 20                	push   $0x20
80102f1e:	e8 c8 fe ff ff       	call   80102deb <lapicw>
80102f23:	83 c4 08             	add    $0x8,%esp
80102f26:	eb 01                	jmp    80102f29 <lapicinit+0x11c>
80102f28:	90                   	nop
80102f29:	c9                   	leave  
80102f2a:	c3                   	ret    

80102f2b <cpunum>:
80102f2b:	55                   	push   %ebp
80102f2c:	89 e5                	mov    %esp,%ebp
80102f2e:	83 ec 08             	sub    $0x8,%esp
80102f31:	e8 a5 fe ff ff       	call   80102ddb <readeflags>
80102f36:	25 00 02 00 00       	and    $0x200,%eax
80102f3b:	85 c0                	test   %eax,%eax
80102f3d:	74 26                	je     80102f65 <cpunum+0x3a>
80102f3f:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102f44:	8d 50 01             	lea    0x1(%eax),%edx
80102f47:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102f4d:	85 c0                	test   %eax,%eax
80102f4f:	75 14                	jne    80102f65 <cpunum+0x3a>
80102f51:	8b 45 04             	mov    0x4(%ebp),%eax
80102f54:	83 ec 08             	sub    $0x8,%esp
80102f57:	50                   	push   %eax
80102f58:	68 bc 8f 10 80       	push   $0x80108fbc
80102f5d:	e8 64 d4 ff ff       	call   801003c6 <cprintf>
80102f62:	83 c4 10             	add    $0x10,%esp
80102f65:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	74 0f                	je     80102f7d <cpunum+0x52>
80102f6e:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f73:	83 c0 20             	add    $0x20,%eax
80102f76:	8b 00                	mov    (%eax),%eax
80102f78:	c1 e8 18             	shr    $0x18,%eax
80102f7b:	eb 05                	jmp    80102f82 <cpunum+0x57>
80102f7d:	b8 00 00 00 00       	mov    $0x0,%eax
80102f82:	c9                   	leave  
80102f83:	c3                   	ret    

80102f84 <lapiceoi>:
80102f84:	55                   	push   %ebp
80102f85:	89 e5                	mov    %esp,%ebp
80102f87:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f8c:	85 c0                	test   %eax,%eax
80102f8e:	74 0c                	je     80102f9c <lapiceoi+0x18>
80102f90:	6a 00                	push   $0x0
80102f92:	6a 2c                	push   $0x2c
80102f94:	e8 52 fe ff ff       	call   80102deb <lapicw>
80102f99:	83 c4 08             	add    $0x8,%esp
80102f9c:	90                   	nop
80102f9d:	c9                   	leave  
80102f9e:	c3                   	ret    

80102f9f <microdelay>:
80102f9f:	55                   	push   %ebp
80102fa0:	89 e5                	mov    %esp,%ebp
80102fa2:	90                   	nop
80102fa3:	5d                   	pop    %ebp
80102fa4:	c3                   	ret    

80102fa5 <lapicstartap>:
80102fa5:	55                   	push   %ebp
80102fa6:	89 e5                	mov    %esp,%ebp
80102fa8:	83 ec 14             	sub    $0x14,%esp
80102fab:	8b 45 08             	mov    0x8(%ebp),%eax
80102fae:	88 45 ec             	mov    %al,-0x14(%ebp)
80102fb1:	6a 0f                	push   $0xf
80102fb3:	6a 70                	push   $0x70
80102fb5:	e8 02 fe ff ff       	call   80102dbc <outb>
80102fba:	83 c4 08             	add    $0x8,%esp
80102fbd:	6a 0a                	push   $0xa
80102fbf:	6a 71                	push   $0x71
80102fc1:	e8 f6 fd ff ff       	call   80102dbc <outb>
80102fc6:	83 c4 08             	add    $0x8,%esp
80102fc9:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
80102fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fd3:	66 c7 00 00 00       	movw   $0x0,(%eax)
80102fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fdb:	83 c0 02             	add    $0x2,%eax
80102fde:	8b 55 0c             	mov    0xc(%ebp),%edx
80102fe1:	c1 ea 04             	shr    $0x4,%edx
80102fe4:	66 89 10             	mov    %dx,(%eax)
80102fe7:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102feb:	c1 e0 18             	shl    $0x18,%eax
80102fee:	50                   	push   %eax
80102fef:	68 c4 00 00 00       	push   $0xc4
80102ff4:	e8 f2 fd ff ff       	call   80102deb <lapicw>
80102ff9:	83 c4 08             	add    $0x8,%esp
80102ffc:	68 00 c5 00 00       	push   $0xc500
80103001:	68 c0 00 00 00       	push   $0xc0
80103006:	e8 e0 fd ff ff       	call   80102deb <lapicw>
8010300b:	83 c4 08             	add    $0x8,%esp
8010300e:	68 c8 00 00 00       	push   $0xc8
80103013:	e8 87 ff ff ff       	call   80102f9f <microdelay>
80103018:	83 c4 04             	add    $0x4,%esp
8010301b:	68 00 85 00 00       	push   $0x8500
80103020:	68 c0 00 00 00       	push   $0xc0
80103025:	e8 c1 fd ff ff       	call   80102deb <lapicw>
8010302a:	83 c4 08             	add    $0x8,%esp
8010302d:	6a 64                	push   $0x64
8010302f:	e8 6b ff ff ff       	call   80102f9f <microdelay>
80103034:	83 c4 04             	add    $0x4,%esp
80103037:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010303e:	eb 3d                	jmp    8010307d <lapicstartap+0xd8>
80103040:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103044:	c1 e0 18             	shl    $0x18,%eax
80103047:	50                   	push   %eax
80103048:	68 c4 00 00 00       	push   $0xc4
8010304d:	e8 99 fd ff ff       	call   80102deb <lapicw>
80103052:	83 c4 08             	add    $0x8,%esp
80103055:	8b 45 0c             	mov    0xc(%ebp),%eax
80103058:	c1 e8 0c             	shr    $0xc,%eax
8010305b:	80 cc 06             	or     $0x6,%ah
8010305e:	50                   	push   %eax
8010305f:	68 c0 00 00 00       	push   $0xc0
80103064:	e8 82 fd ff ff       	call   80102deb <lapicw>
80103069:	83 c4 08             	add    $0x8,%esp
8010306c:	68 c8 00 00 00       	push   $0xc8
80103071:	e8 29 ff ff ff       	call   80102f9f <microdelay>
80103076:	83 c4 04             	add    $0x4,%esp
80103079:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010307d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103081:	7e bd                	jle    80103040 <lapicstartap+0x9b>
80103083:	90                   	nop
80103084:	c9                   	leave  
80103085:	c3                   	ret    

80103086 <cmos_read>:
80103086:	55                   	push   %ebp
80103087:	89 e5                	mov    %esp,%ebp
80103089:	8b 45 08             	mov    0x8(%ebp),%eax
8010308c:	0f b6 c0             	movzbl %al,%eax
8010308f:	50                   	push   %eax
80103090:	6a 70                	push   $0x70
80103092:	e8 25 fd ff ff       	call   80102dbc <outb>
80103097:	83 c4 08             	add    $0x8,%esp
8010309a:	68 c8 00 00 00       	push   $0xc8
8010309f:	e8 fb fe ff ff       	call   80102f9f <microdelay>
801030a4:	83 c4 04             	add    $0x4,%esp
801030a7:	6a 71                	push   $0x71
801030a9:	e8 f1 fc ff ff       	call   80102d9f <inb>
801030ae:	83 c4 04             	add    $0x4,%esp
801030b1:	0f b6 c0             	movzbl %al,%eax
801030b4:	c9                   	leave  
801030b5:	c3                   	ret    

801030b6 <fill_rtcdate>:
801030b6:	55                   	push   %ebp
801030b7:	89 e5                	mov    %esp,%ebp
801030b9:	6a 00                	push   $0x0
801030bb:	e8 c6 ff ff ff       	call   80103086 <cmos_read>
801030c0:	83 c4 04             	add    $0x4,%esp
801030c3:	89 c2                	mov    %eax,%edx
801030c5:	8b 45 08             	mov    0x8(%ebp),%eax
801030c8:	89 10                	mov    %edx,(%eax)
801030ca:	6a 02                	push   $0x2
801030cc:	e8 b5 ff ff ff       	call   80103086 <cmos_read>
801030d1:	83 c4 04             	add    $0x4,%esp
801030d4:	89 c2                	mov    %eax,%edx
801030d6:	8b 45 08             	mov    0x8(%ebp),%eax
801030d9:	89 50 04             	mov    %edx,0x4(%eax)
801030dc:	6a 04                	push   $0x4
801030de:	e8 a3 ff ff ff       	call   80103086 <cmos_read>
801030e3:	83 c4 04             	add    $0x4,%esp
801030e6:	89 c2                	mov    %eax,%edx
801030e8:	8b 45 08             	mov    0x8(%ebp),%eax
801030eb:	89 50 08             	mov    %edx,0x8(%eax)
801030ee:	6a 07                	push   $0x7
801030f0:	e8 91 ff ff ff       	call   80103086 <cmos_read>
801030f5:	83 c4 04             	add    $0x4,%esp
801030f8:	89 c2                	mov    %eax,%edx
801030fa:	8b 45 08             	mov    0x8(%ebp),%eax
801030fd:	89 50 0c             	mov    %edx,0xc(%eax)
80103100:	6a 08                	push   $0x8
80103102:	e8 7f ff ff ff       	call   80103086 <cmos_read>
80103107:	83 c4 04             	add    $0x4,%esp
8010310a:	89 c2                	mov    %eax,%edx
8010310c:	8b 45 08             	mov    0x8(%ebp),%eax
8010310f:	89 50 10             	mov    %edx,0x10(%eax)
80103112:	6a 09                	push   $0x9
80103114:	e8 6d ff ff ff       	call   80103086 <cmos_read>
80103119:	83 c4 04             	add    $0x4,%esp
8010311c:	89 c2                	mov    %eax,%edx
8010311e:	8b 45 08             	mov    0x8(%ebp),%eax
80103121:	89 50 14             	mov    %edx,0x14(%eax)
80103124:	90                   	nop
80103125:	c9                   	leave  
80103126:	c3                   	ret    

80103127 <cmostime>:
80103127:	55                   	push   %ebp
80103128:	89 e5                	mov    %esp,%ebp
8010312a:	83 ec 48             	sub    $0x48,%esp
8010312d:	6a 0b                	push   $0xb
8010312f:	e8 52 ff ff ff       	call   80103086 <cmos_read>
80103134:	83 c4 04             	add    $0x4,%esp
80103137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010313d:	83 e0 04             	and    $0x4,%eax
80103140:	85 c0                	test   %eax,%eax
80103142:	0f 94 c0             	sete   %al
80103145:	0f b6 c0             	movzbl %al,%eax
80103148:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010314b:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010314e:	50                   	push   %eax
8010314f:	e8 62 ff ff ff       	call   801030b6 <fill_rtcdate>
80103154:	83 c4 04             	add    $0x4,%esp
80103157:	6a 0a                	push   $0xa
80103159:	e8 28 ff ff ff       	call   80103086 <cmos_read>
8010315e:	83 c4 04             	add    $0x4,%esp
80103161:	25 80 00 00 00       	and    $0x80,%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	75 27                	jne    80103191 <cmostime+0x6a>
8010316a:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010316d:	50                   	push   %eax
8010316e:	e8 43 ff ff ff       	call   801030b6 <fill_rtcdate>
80103173:	83 c4 04             	add    $0x4,%esp
80103176:	83 ec 04             	sub    $0x4,%esp
80103179:	6a 18                	push   $0x18
8010317b:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010317e:	50                   	push   %eax
8010317f:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103182:	50                   	push   %eax
80103183:	e8 18 24 00 00       	call   801055a0 <memcmp>
80103188:	83 c4 10             	add    $0x10,%esp
8010318b:	85 c0                	test   %eax,%eax
8010318d:	74 05                	je     80103194 <cmostime+0x6d>
8010318f:	eb ba                	jmp    8010314b <cmostime+0x24>
80103191:	90                   	nop
80103192:	eb b7                	jmp    8010314b <cmostime+0x24>
80103194:	90                   	nop
80103195:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103199:	0f 84 b4 00 00 00    	je     80103253 <cmostime+0x12c>
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
80103279:	8b 45 08             	mov    0x8(%ebp),%eax
8010327c:	8b 40 14             	mov    0x14(%eax),%eax
8010327f:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103285:	8b 45 08             	mov    0x8(%ebp),%eax
80103288:	89 50 14             	mov    %edx,0x14(%eax)
8010328b:	90                   	nop
8010328c:	c9                   	leave  
8010328d:	c3                   	ret    

8010328e <initlog>:
8010328e:	55                   	push   %ebp
8010328f:	89 e5                	mov    %esp,%ebp
80103291:	83 ec 18             	sub    $0x18,%esp
80103294:	83 ec 08             	sub    $0x8,%esp
80103297:	68 e8 8f 10 80       	push   $0x80108fe8
8010329c:	68 80 32 11 80       	push   $0x80113280
801032a1:	e8 0e 20 00 00       	call   801052b4 <initlock>
801032a6:	83 c4 10             	add    $0x10,%esp
801032a9:	83 ec 08             	sub    $0x8,%esp
801032ac:	8d 45 e8             	lea    -0x18(%ebp),%eax
801032af:	50                   	push   %eax
801032b0:	6a 01                	push   $0x1
801032b2:	e8 b2 e0 ff ff       	call   80101369 <readsb>
801032b7:	83 c4 10             	add    $0x10,%esp
801032ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032c0:	29 c2                	sub    %eax,%edx
801032c2:	89 d0                	mov    %edx,%eax
801032c4:	a3 b4 32 11 80       	mov    %eax,0x801132b4
801032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032cc:	a3 b8 32 11 80       	mov    %eax,0x801132b8
801032d1:	c7 05 c4 32 11 80 01 	movl   $0x1,0x801132c4
801032d8:	00 00 00 
801032db:	e8 b2 01 00 00       	call   80103492 <recover_from_log>
801032e0:	90                   	nop
801032e1:	c9                   	leave  
801032e2:	c3                   	ret    

801032e3 <install_trans>:
801032e3:	55                   	push   %ebp
801032e4:	89 e5                	mov    %esp,%ebp
801032e6:	83 ec 18             	sub    $0x18,%esp
801032e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032f0:	e9 95 00 00 00       	jmp    8010338a <install_trans+0xa7>
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
8010333e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103341:	8d 50 18             	lea    0x18(%eax),%edx
80103344:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103347:	83 c0 18             	add    $0x18,%eax
8010334a:	83 ec 04             	sub    $0x4,%esp
8010334d:	68 00 02 00 00       	push   $0x200
80103352:	52                   	push   %edx
80103353:	50                   	push   %eax
80103354:	e8 9f 22 00 00       	call   801055f8 <memmove>
80103359:	83 c4 10             	add    $0x10,%esp
8010335c:	83 ec 0c             	sub    $0xc,%esp
8010335f:	ff 75 ec             	pushl  -0x14(%ebp)
80103362:	e8 88 ce ff ff       	call   801001ef <bwrite>
80103367:	83 c4 10             	add    $0x10,%esp
8010336a:	83 ec 0c             	sub    $0xc,%esp
8010336d:	ff 75 f0             	pushl  -0x10(%ebp)
80103370:	e8 b9 ce ff ff       	call   8010022e <brelse>
80103375:	83 c4 10             	add    $0x10,%esp
80103378:	83 ec 0c             	sub    $0xc,%esp
8010337b:	ff 75 ec             	pushl  -0x14(%ebp)
8010337e:	e8 ab ce ff ff       	call   8010022e <brelse>
80103383:	83 c4 10             	add    $0x10,%esp
80103386:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010338a:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010338f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103392:	0f 8f 5d ff ff ff    	jg     801032f5 <install_trans+0x12>
80103398:	90                   	nop
80103399:	c9                   	leave  
8010339a:	c3                   	ret    

8010339b <read_head>:
8010339b:	55                   	push   %ebp
8010339c:	89 e5                	mov    %esp,%ebp
8010339e:	83 ec 18             	sub    $0x18,%esp
801033a1:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801033a6:	89 c2                	mov    %eax,%edx
801033a8:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801033ad:	83 ec 08             	sub    $0x8,%esp
801033b0:	52                   	push   %edx
801033b1:	50                   	push   %eax
801033b2:	e8 ff cd ff ff       	call   801001b6 <bread>
801033b7:	83 c4 10             	add    $0x10,%esp
801033ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
801033bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033c0:	83 c0 18             	add    $0x18,%eax
801033c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801033c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033c9:	8b 00                	mov    (%eax),%eax
801033cb:	a3 c8 32 11 80       	mov    %eax,0x801132c8
801033d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033d7:	eb 1b                	jmp    801033f4 <read_head+0x59>
801033d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033df:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801033e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033e6:	83 c2 10             	add    $0x10,%edx
801033e9:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
801033f0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033f4:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801033f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033fc:	7f db                	jg     801033d9 <read_head+0x3e>
801033fe:	83 ec 0c             	sub    $0xc,%esp
80103401:	ff 75 f0             	pushl  -0x10(%ebp)
80103404:	e8 25 ce ff ff       	call   8010022e <brelse>
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	90                   	nop
8010340d:	c9                   	leave  
8010340e:	c3                   	ret    

8010340f <write_head>:
8010340f:	55                   	push   %ebp
80103410:	89 e5                	mov    %esp,%ebp
80103412:	83 ec 18             	sub    $0x18,%esp
80103415:	a1 b4 32 11 80       	mov    0x801132b4,%eax
8010341a:	89 c2                	mov    %eax,%edx
8010341c:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103421:	83 ec 08             	sub    $0x8,%esp
80103424:	52                   	push   %edx
80103425:	50                   	push   %eax
80103426:	e8 8b cd ff ff       	call   801001b6 <bread>
8010342b:	83 c4 10             	add    $0x10,%esp
8010342e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103431:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103434:	83 c0 18             	add    $0x18,%eax
80103437:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010343a:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
80103440:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103443:	89 10                	mov    %edx,(%eax)
80103445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010344c:	eb 1b                	jmp    80103469 <write_head+0x5a>
8010344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103451:	83 c0 10             	add    $0x10,%eax
80103454:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
8010345b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010345e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103461:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
80103465:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103469:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010346e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103471:	7f db                	jg     8010344e <write_head+0x3f>
80103473:	83 ec 0c             	sub    $0xc,%esp
80103476:	ff 75 f0             	pushl  -0x10(%ebp)
80103479:	e8 71 cd ff ff       	call   801001ef <bwrite>
8010347e:	83 c4 10             	add    $0x10,%esp
80103481:	83 ec 0c             	sub    $0xc,%esp
80103484:	ff 75 f0             	pushl  -0x10(%ebp)
80103487:	e8 a2 cd ff ff       	call   8010022e <brelse>
8010348c:	83 c4 10             	add    $0x10,%esp
8010348f:	90                   	nop
80103490:	c9                   	leave  
80103491:	c3                   	ret    

80103492 <recover_from_log>:
80103492:	55                   	push   %ebp
80103493:	89 e5                	mov    %esp,%ebp
80103495:	83 ec 08             	sub    $0x8,%esp
80103498:	e8 fe fe ff ff       	call   8010339b <read_head>
8010349d:	e8 41 fe ff ff       	call   801032e3 <install_trans>
801034a2:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
801034a9:	00 00 00 
801034ac:	e8 5e ff ff ff       	call   8010340f <write_head>
801034b1:	90                   	nop
801034b2:	c9                   	leave  
801034b3:	c3                   	ret    

801034b4 <begin_op>:
801034b4:	55                   	push   %ebp
801034b5:	89 e5                	mov    %esp,%ebp
801034b7:	83 ec 08             	sub    $0x8,%esp
801034ba:	83 ec 0c             	sub    $0xc,%esp
801034bd:	68 80 32 11 80       	push   $0x80113280
801034c2:	e8 0f 1e 00 00       	call   801052d6 <acquire>
801034c7:	83 c4 10             	add    $0x10,%esp
801034ca:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801034cf:	85 c0                	test   %eax,%eax
801034d1:	74 17                	je     801034ea <begin_op+0x36>
801034d3:	83 ec 08             	sub    $0x8,%esp
801034d6:	68 80 32 11 80       	push   $0x80113280
801034db:	68 80 32 11 80       	push   $0x80113280
801034e0:	e8 88 19 00 00       	call   80104e6d <sleep>
801034e5:	83 c4 10             	add    $0x10,%esp
801034e8:	eb e0                	jmp    801034ca <begin_op+0x16>
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
80103508:	83 ec 08             	sub    $0x8,%esp
8010350b:	68 80 32 11 80       	push   $0x80113280
80103510:	68 80 32 11 80       	push   $0x80113280
80103515:	e8 53 19 00 00       	call   80104e6d <sleep>
8010351a:	83 c4 10             	add    $0x10,%esp
8010351d:	eb ab                	jmp    801034ca <begin_op+0x16>
8010351f:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103524:	83 c0 01             	add    $0x1,%eax
80103527:	a3 bc 32 11 80       	mov    %eax,0x801132bc
8010352c:	83 ec 0c             	sub    $0xc,%esp
8010352f:	68 80 32 11 80       	push   $0x80113280
80103534:	e8 04 1e 00 00       	call   8010533d <release>
80103539:	83 c4 10             	add    $0x10,%esp
8010353c:	90                   	nop
8010353d:	90                   	nop
8010353e:	c9                   	leave  
8010353f:	c3                   	ret    

80103540 <end_op>:
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	83 ec 18             	sub    $0x18,%esp
80103546:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010354d:	83 ec 0c             	sub    $0xc,%esp
80103550:	68 80 32 11 80       	push   $0x80113280
80103555:	e8 7c 1d 00 00       	call   801052d6 <acquire>
8010355a:	83 c4 10             	add    $0x10,%esp
8010355d:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103562:	83 e8 01             	sub    $0x1,%eax
80103565:	a3 bc 32 11 80       	mov    %eax,0x801132bc
8010356a:	a1 c0 32 11 80       	mov    0x801132c0,%eax
8010356f:	85 c0                	test   %eax,%eax
80103571:	74 0d                	je     80103580 <end_op+0x40>
80103573:	83 ec 0c             	sub    $0xc,%esp
80103576:	68 ec 8f 10 80       	push   $0x80108fec
8010357b:	e8 e6 cf ff ff       	call   80100566 <panic>
80103580:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103585:	85 c0                	test   %eax,%eax
80103587:	75 13                	jne    8010359c <end_op+0x5c>
80103589:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80103590:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
80103597:	00 00 00 
8010359a:	eb 10                	jmp    801035ac <end_op+0x6c>
8010359c:	83 ec 0c             	sub    $0xc,%esp
8010359f:	68 80 32 11 80       	push   $0x80113280
801035a4:	e8 b2 19 00 00       	call   80104f5b <wakeup>
801035a9:	83 c4 10             	add    $0x10,%esp
801035ac:	83 ec 0c             	sub    $0xc,%esp
801035af:	68 80 32 11 80       	push   $0x80113280
801035b4:	e8 84 1d 00 00       	call   8010533d <release>
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035c0:	74 3f                	je     80103601 <end_op+0xc1>
801035c2:	e8 f5 00 00 00       	call   801036bc <commit>
801035c7:	83 ec 0c             	sub    $0xc,%esp
801035ca:	68 80 32 11 80       	push   $0x80113280
801035cf:	e8 02 1d 00 00       	call   801052d6 <acquire>
801035d4:	83 c4 10             	add    $0x10,%esp
801035d7:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
801035de:	00 00 00 
801035e1:	83 ec 0c             	sub    $0xc,%esp
801035e4:	68 80 32 11 80       	push   $0x80113280
801035e9:	e8 6d 19 00 00       	call   80104f5b <wakeup>
801035ee:	83 c4 10             	add    $0x10,%esp
801035f1:	83 ec 0c             	sub    $0xc,%esp
801035f4:	68 80 32 11 80       	push   $0x80113280
801035f9:	e8 3f 1d 00 00       	call   8010533d <release>
801035fe:	83 c4 10             	add    $0x10,%esp
80103601:	90                   	nop
80103602:	c9                   	leave  
80103603:	c3                   	ret    

80103604 <write_log>:
80103604:	55                   	push   %ebp
80103605:	89 e5                	mov    %esp,%ebp
80103607:	83 ec 18             	sub    $0x18,%esp
8010360a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103611:	e9 95 00 00 00       	jmp    801036ab <write_log+0xa7>
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
8010365f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103662:	8d 50 18             	lea    0x18(%eax),%edx
80103665:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103668:	83 c0 18             	add    $0x18,%eax
8010366b:	83 ec 04             	sub    $0x4,%esp
8010366e:	68 00 02 00 00       	push   $0x200
80103673:	52                   	push   %edx
80103674:	50                   	push   %eax
80103675:	e8 7e 1f 00 00       	call   801055f8 <memmove>
8010367a:	83 c4 10             	add    $0x10,%esp
8010367d:	83 ec 0c             	sub    $0xc,%esp
80103680:	ff 75 f0             	pushl  -0x10(%ebp)
80103683:	e8 67 cb ff ff       	call   801001ef <bwrite>
80103688:	83 c4 10             	add    $0x10,%esp
8010368b:	83 ec 0c             	sub    $0xc,%esp
8010368e:	ff 75 ec             	pushl  -0x14(%ebp)
80103691:	e8 98 cb ff ff       	call   8010022e <brelse>
80103696:	83 c4 10             	add    $0x10,%esp
80103699:	83 ec 0c             	sub    $0xc,%esp
8010369c:	ff 75 f0             	pushl  -0x10(%ebp)
8010369f:	e8 8a cb ff ff       	call   8010022e <brelse>
801036a4:	83 c4 10             	add    $0x10,%esp
801036a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036ab:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036b3:	0f 8f 5d ff ff ff    	jg     80103616 <write_log+0x12>
801036b9:	90                   	nop
801036ba:	c9                   	leave  
801036bb:	c3                   	ret    

801036bc <commit>:
801036bc:	55                   	push   %ebp
801036bd:	89 e5                	mov    %esp,%ebp
801036bf:	83 ec 08             	sub    $0x8,%esp
801036c2:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036c7:	85 c0                	test   %eax,%eax
801036c9:	7e 1e                	jle    801036e9 <commit+0x2d>
801036cb:	e8 34 ff ff ff       	call   80103604 <write_log>
801036d0:	e8 3a fd ff ff       	call   8010340f <write_head>
801036d5:	e8 09 fc ff ff       	call   801032e3 <install_trans>
801036da:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
801036e1:	00 00 00 
801036e4:	e8 26 fd ff ff       	call   8010340f <write_head>
801036e9:	90                   	nop
801036ea:	c9                   	leave  
801036eb:	c3                   	ret    

801036ec <log_write>:
801036ec:	55                   	push   %ebp
801036ed:	89 e5                	mov    %esp,%ebp
801036ef:	83 ec 18             	sub    $0x18,%esp
801036f2:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036f7:	83 f8 1d             	cmp    $0x1d,%eax
801036fa:	7f 12                	jg     8010370e <log_write+0x22>
801036fc:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103701:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
80103707:	83 ea 01             	sub    $0x1,%edx
8010370a:	39 d0                	cmp    %edx,%eax
8010370c:	7c 0d                	jl     8010371b <log_write+0x2f>
8010370e:	83 ec 0c             	sub    $0xc,%esp
80103711:	68 fb 8f 10 80       	push   $0x80108ffb
80103716:	e8 4b ce ff ff       	call   80100566 <panic>
8010371b:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103720:	85 c0                	test   %eax,%eax
80103722:	7f 0d                	jg     80103731 <log_write+0x45>
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 11 90 10 80       	push   $0x80109011
8010372c:	e8 35 ce ff ff       	call   80100566 <panic>
80103731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103738:	eb 1d                	jmp    80103757 <log_write+0x6b>
8010373a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010373d:	83 c0 10             	add    $0x10,%eax
80103740:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103747:	89 c2                	mov    %eax,%edx
80103749:	8b 45 08             	mov    0x8(%ebp),%eax
8010374c:	8b 40 08             	mov    0x8(%eax),%eax
8010374f:	39 c2                	cmp    %eax,%edx
80103751:	74 10                	je     80103763 <log_write+0x77>
80103753:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103757:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010375c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010375f:	7f d9                	jg     8010373a <log_write+0x4e>
80103761:	eb 01                	jmp    80103764 <log_write+0x78>
80103763:	90                   	nop
80103764:	8b 45 08             	mov    0x8(%ebp),%eax
80103767:	8b 40 08             	mov    0x8(%eax),%eax
8010376a:	89 c2                	mov    %eax,%edx
8010376c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010376f:	83 c0 10             	add    $0x10,%eax
80103772:	89 14 85 8c 32 11 80 	mov    %edx,-0x7feecd74(,%eax,4)
80103779:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010377e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103781:	75 0d                	jne    80103790 <log_write+0xa4>
80103783:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103788:	83 c0 01             	add    $0x1,%eax
8010378b:	a3 c8 32 11 80       	mov    %eax,0x801132c8
80103790:	8b 45 08             	mov    0x8(%ebp),%eax
80103793:	8b 00                	mov    (%eax),%eax
80103795:	83 c8 04             	or     $0x4,%eax
80103798:	89 c2                	mov    %eax,%edx
8010379a:	8b 45 08             	mov    0x8(%ebp),%eax
8010379d:	89 10                	mov    %edx,(%eax)
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
801037af:	55                   	push   %ebp
801037b0:	89 e5                	mov    %esp,%ebp
801037b2:	8b 45 08             	mov    0x8(%ebp),%eax
801037b5:	05 00 00 00 80       	add    $0x80000000,%eax
801037ba:	5d                   	pop    %ebp
801037bb:	c3                   	ret    

801037bc <xchg>:
801037bc:	55                   	push   %ebp
801037bd:	89 e5                	mov    %esp,%ebp
801037bf:	83 ec 10             	sub    $0x10,%esp
801037c2:	8b 55 08             	mov    0x8(%ebp),%edx
801037c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801037c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801037cb:	f0 87 02             	lock xchg %eax,(%edx)
801037ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
801037d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801037d4:	c9                   	leave  
801037d5:	c3                   	ret    

801037d6 <main>:
801037d6:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801037da:	83 e4 f0             	and    $0xfffffff0,%esp
801037dd:	ff 71 fc             	pushl  -0x4(%ecx)
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	51                   	push   %ecx
801037e4:	83 ec 04             	sub    $0x4,%esp
801037e7:	83 ec 08             	sub    $0x8,%esp
801037ea:	68 00 00 40 80       	push   $0x80400000
801037ef:	68 9c 65 21 80       	push   $0x8021659c
801037f4:	e8 95 f2 ff ff       	call   80102a8e <kinit1>
801037f9:	83 c4 10             	add    $0x10,%esp
801037fc:	e8 0d 4b 00 00       	call   8010830e <kvmalloc>
80103801:	e8 4d 04 00 00       	call   80103c53 <mpinit>
80103806:	e8 02 f6 ff ff       	call   80102e0d <lapicinit>
8010380b:	e8 a7 44 00 00       	call   80107cb7 <seginit>
80103810:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103816:	0f b6 00             	movzbl (%eax),%eax
80103819:	0f b6 c0             	movzbl %al,%eax
8010381c:	83 ec 08             	sub    $0x8,%esp
8010381f:	50                   	push   %eax
80103820:	68 2c 90 10 80       	push   $0x8010902c
80103825:	e8 9c cb ff ff       	call   801003c6 <cprintf>
8010382a:	83 c4 10             	add    $0x10,%esp
8010382d:	e8 77 06 00 00       	call   80103ea9 <picinit>
80103832:	e8 4c f1 ff ff       	call   80102983 <ioapicinit>
80103837:	e8 ad d2 ff ff       	call   80100ae9 <consoleinit>
8010383c:	e8 b4 37 00 00       	call   80106ff5 <uartinit>
80103841:	e8 60 0b 00 00       	call   801043a6 <pinit>
80103846:	e8 4e 44 00 00       	call   80107c99 <init_pte_lookup_lock>
8010384b:	e8 76 32 00 00       	call   80106ac6 <tvinit>
80103850:	e8 df c7 ff ff       	call   80100034 <binit>
80103855:	e8 00 d7 ff ff       	call   80100f5a <fileinit>
8010385a:	e8 d9 dd ff ff       	call   80101638 <iinit>
8010385f:	e8 63 ed ff ff       	call   801025c7 <ideinit>
80103864:	a1 64 33 11 80       	mov    0x80113364,%eax
80103869:	85 c0                	test   %eax,%eax
8010386b:	75 05                	jne    80103872 <main+0x9c>
8010386d:	e8 b1 31 00 00       	call   80106a23 <timerinit>
80103872:	e8 7f 00 00 00       	call   801038f6 <startothers>
80103877:	83 ec 08             	sub    $0x8,%esp
8010387a:	68 00 00 00 8e       	push   $0x8e000000
8010387f:	68 00 00 40 80       	push   $0x80400000
80103884:	e8 3e f2 ff ff       	call   80102ac7 <kinit2>
80103889:	83 c4 10             	add    $0x10,%esp
8010388c:	e8 7d 0c 00 00       	call   8010450e <userinit>
80103891:	e8 1a 00 00 00       	call   801038b0 <mpmain>

80103896 <mpenter>:
80103896:	55                   	push   %ebp
80103897:	89 e5                	mov    %esp,%ebp
80103899:	83 ec 08             	sub    $0x8,%esp
8010389c:	e8 85 4a 00 00       	call   80108326 <switchkvm>
801038a1:	e8 11 44 00 00       	call   80107cb7 <seginit>
801038a6:	e8 62 f5 ff ff       	call   80102e0d <lapicinit>
801038ab:	e8 00 00 00 00       	call   801038b0 <mpmain>

801038b0 <mpmain>:
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 08             	sub    $0x8,%esp
801038b6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038bc:	0f b6 00             	movzbl (%eax),%eax
801038bf:	0f b6 c0             	movzbl %al,%eax
801038c2:	83 ec 08             	sub    $0x8,%esp
801038c5:	50                   	push   %eax
801038c6:	68 43 90 10 80       	push   $0x80109043
801038cb:	e8 f6 ca ff ff       	call   801003c6 <cprintf>
801038d0:	83 c4 10             	add    $0x10,%esp
801038d3:	e8 64 33 00 00       	call   80106c3c <idtinit>
801038d8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038de:	05 a8 00 00 00       	add    $0xa8,%eax
801038e3:	83 ec 08             	sub    $0x8,%esp
801038e6:	6a 01                	push   $0x1
801038e8:	50                   	push   %eax
801038e9:	e8 ce fe ff ff       	call   801037bc <xchg>
801038ee:	83 c4 10             	add    $0x10,%esp
801038f1:	e8 a7 13 00 00       	call   80104c9d <scheduler>

801038f6 <startothers>:
801038f6:	55                   	push   %ebp
801038f7:	89 e5                	mov    %esp,%ebp
801038f9:	53                   	push   %ebx
801038fa:	83 ec 14             	sub    $0x14,%esp
801038fd:	68 00 70 00 00       	push   $0x7000
80103902:	e8 a8 fe ff ff       	call   801037af <p2v>
80103907:	83 c4 04             	add    $0x4,%esp
8010390a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010390d:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103912:	83 ec 04             	sub    $0x4,%esp
80103915:	50                   	push   %eax
80103916:	68 2c c5 10 80       	push   $0x8010c52c
8010391b:	ff 75 f0             	pushl  -0x10(%ebp)
8010391e:	e8 d5 1c 00 00       	call   801055f8 <memmove>
80103923:	83 c4 10             	add    $0x10,%esp
80103926:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
8010392d:	e9 90 00 00 00       	jmp    801039c2 <startothers+0xcc>
80103932:	e8 f4 f5 ff ff       	call   80102f2b <cpunum>
80103937:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010393d:	05 80 33 11 80       	add    $0x80113380,%eax
80103942:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103945:	74 73                	je     801039ba <startothers+0xc4>
80103947:	e8 79 f2 ff ff       	call   80102bc5 <kalloc>
8010394c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010394f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103952:	83 e8 04             	sub    $0x4,%eax
80103955:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103958:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010395e:	89 10                	mov    %edx,(%eax)
80103960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103963:	83 e8 08             	sub    $0x8,%eax
80103966:	c7 00 96 38 10 80    	movl   $0x80103896,(%eax)
8010396c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010396f:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103972:	83 ec 0c             	sub    $0xc,%esp
80103975:	68 00 b0 10 80       	push   $0x8010b000
8010397a:	e8 23 fe ff ff       	call   801037a2 <v2p>
8010397f:	83 c4 10             	add    $0x10,%esp
80103982:	89 03                	mov    %eax,(%ebx)
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
801039aa:	90                   	nop
801039ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ae:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801039b4:	85 c0                	test   %eax,%eax
801039b6:	74 f3                	je     801039ab <startothers+0xb5>
801039b8:	eb 01                	jmp    801039bb <startothers+0xc5>
801039ba:	90                   	nop
801039bb:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801039c2:	a1 60 39 11 80       	mov    0x80113960,%eax
801039c7:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039cd:	05 80 33 11 80       	add    $0x80113380,%eax
801039d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039d5:	0f 87 57 ff ff ff    	ja     80103932 <startothers+0x3c>
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
801039ee:	55                   	push   %ebp
801039ef:	89 e5                	mov    %esp,%ebp
801039f1:	83 ec 14             	sub    $0x14,%esp
801039f4:	8b 45 08             	mov    0x8(%ebp),%eax
801039f7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
801039fb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801039ff:	89 c2                	mov    %eax,%edx
80103a01:	ec                   	in     (%dx),%al
80103a02:	88 45 ff             	mov    %al,-0x1(%ebp)
80103a05:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80103a09:	c9                   	leave  
80103a0a:	c3                   	ret    

80103a0b <outb>:
80103a0b:	55                   	push   %ebp
80103a0c:	89 e5                	mov    %esp,%ebp
80103a0e:	83 ec 08             	sub    $0x8,%esp
80103a11:	8b 55 08             	mov    0x8(%ebp),%edx
80103a14:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a17:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a1b:	88 45 f8             	mov    %al,-0x8(%ebp)
80103a1e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a22:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a26:	ee                   	out    %al,(%dx)
80103a27:	90                   	nop
80103a28:	c9                   	leave  
80103a29:	c3                   	ret    

80103a2a <mpbcpu>:
80103a2a:	55                   	push   %ebp
80103a2b:	89 e5                	mov    %esp,%ebp
80103a2d:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103a32:	89 c2                	mov    %eax,%edx
80103a34:	b8 80 33 11 80       	mov    $0x80113380,%eax
80103a39:	29 c2                	sub    %eax,%edx
80103a3b:	89 d0                	mov    %edx,%eax
80103a3d:	c1 f8 02             	sar    $0x2,%eax
80103a40:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
80103a46:	5d                   	pop    %ebp
80103a47:	c3                   	ret    

80103a48 <sum>:
80103a48:	55                   	push   %ebp
80103a49:	89 e5                	mov    %esp,%ebp
80103a4b:	83 ec 10             	sub    $0x10,%esp
80103a4e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80103a55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a5c:	eb 15                	jmp    80103a73 <sum+0x2b>
80103a5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a61:	8b 45 08             	mov    0x8(%ebp),%eax
80103a64:	01 d0                	add    %edx,%eax
80103a66:	0f b6 00             	movzbl (%eax),%eax
80103a69:	0f b6 c0             	movzbl %al,%eax
80103a6c:	01 45 f8             	add    %eax,-0x8(%ebp)
80103a6f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a73:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a76:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a79:	7c e3                	jl     80103a5e <sum+0x16>
80103a7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103a7e:	c9                   	leave  
80103a7f:	c3                   	ret    

80103a80 <mpsearch1>:
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 18             	sub    $0x18,%esp
80103a86:	ff 75 08             	pushl  0x8(%ebp)
80103a89:	e8 53 ff ff ff       	call   801039e1 <p2v>
80103a8e:	83 c4 04             	add    $0x4,%esp
80103a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a94:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a9a:	01 d0                	add    %edx,%eax
80103a9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aa5:	eb 36                	jmp    80103add <mpsearch1+0x5d>
80103aa7:	83 ec 04             	sub    $0x4,%esp
80103aaa:	6a 04                	push   $0x4
80103aac:	68 54 90 10 80       	push   $0x80109054
80103ab1:	ff 75 f4             	pushl  -0xc(%ebp)
80103ab4:	e8 e7 1a 00 00       	call   801055a0 <memcmp>
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
80103ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ad7:	eb 11                	jmp    80103aea <mpsearch1+0x6a>
80103ad9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ae3:	72 c2                	jb     80103aa7 <mpsearch1+0x27>
80103ae5:	b8 00 00 00 00       	mov    $0x0,%eax
80103aea:	c9                   	leave  
80103aeb:	c3                   	ret    

80103aec <mpsearch>:
80103aec:	55                   	push   %ebp
80103aed:	89 e5                	mov    %esp,%ebp
80103aef:	83 ec 18             	sub    $0x18,%esp
80103af2:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
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
80103b24:	83 ec 08             	sub    $0x8,%esp
80103b27:	68 00 04 00 00       	push   $0x400
80103b2c:	ff 75 f0             	pushl  -0x10(%ebp)
80103b2f:	e8 4c ff ff ff       	call   80103a80 <mpsearch1>
80103b34:	83 c4 10             	add    $0x10,%esp
80103b37:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b3e:	74 51                	je     80103b91 <mpsearch+0xa5>
80103b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b43:	eb 61                	jmp    80103ba6 <mpsearch+0xba>
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
80103b8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b8f:	eb 15                	jmp    80103ba6 <mpsearch+0xba>
80103b91:	83 ec 08             	sub    $0x8,%esp
80103b94:	68 00 00 01 00       	push   $0x10000
80103b99:	68 00 00 0f 00       	push   $0xf0000
80103b9e:	e8 dd fe ff ff       	call   80103a80 <mpsearch1>
80103ba3:	83 c4 10             	add    $0x10,%esp
80103ba6:	c9                   	leave  
80103ba7:	c3                   	ret    

80103ba8 <mpconfig>:
80103ba8:	55                   	push   %ebp
80103ba9:	89 e5                	mov    %esp,%ebp
80103bab:	83 ec 18             	sub    $0x18,%esp
80103bae:	e8 39 ff ff ff       	call   80103aec <mpsearch>
80103bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bba:	74 0a                	je     80103bc6 <mpconfig+0x1e>
80103bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbf:	8b 40 04             	mov    0x4(%eax),%eax
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	75 0a                	jne    80103bd0 <mpconfig+0x28>
80103bc6:	b8 00 00 00 00       	mov    $0x0,%eax
80103bcb:	e9 81 00 00 00       	jmp    80103c51 <mpconfig+0xa9>
80103bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd3:	8b 40 04             	mov    0x4(%eax),%eax
80103bd6:	83 ec 0c             	sub    $0xc,%esp
80103bd9:	50                   	push   %eax
80103bda:	e8 02 fe ff ff       	call   801039e1 <p2v>
80103bdf:	83 c4 10             	add    $0x10,%esp
80103be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103be5:	83 ec 04             	sub    $0x4,%esp
80103be8:	6a 04                	push   $0x4
80103bea:	68 59 90 10 80       	push   $0x80109059
80103bef:	ff 75 f0             	pushl  -0x10(%ebp)
80103bf2:	e8 a9 19 00 00       	call   801055a0 <memcmp>
80103bf7:	83 c4 10             	add    $0x10,%esp
80103bfa:	85 c0                	test   %eax,%eax
80103bfc:	74 07                	je     80103c05 <mpconfig+0x5d>
80103bfe:	b8 00 00 00 00       	mov    $0x0,%eax
80103c03:	eb 4c                	jmp    80103c51 <mpconfig+0xa9>
80103c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c08:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c0c:	3c 01                	cmp    $0x1,%al
80103c0e:	74 12                	je     80103c22 <mpconfig+0x7a>
80103c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c13:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c17:	3c 04                	cmp    $0x4,%al
80103c19:	74 07                	je     80103c22 <mpconfig+0x7a>
80103c1b:	b8 00 00 00 00       	mov    $0x0,%eax
80103c20:	eb 2f                	jmp    80103c51 <mpconfig+0xa9>
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
80103c3f:	b8 00 00 00 00       	mov    $0x0,%eax
80103c44:	eb 0b                	jmp    80103c51 <mpconfig+0xa9>
80103c46:	8b 45 08             	mov    0x8(%ebp),%eax
80103c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c4c:	89 10                	mov    %edx,(%eax)
80103c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c51:	c9                   	leave  
80103c52:	c3                   	ret    

80103c53 <mpinit>:
80103c53:	55                   	push   %ebp
80103c54:	89 e5                	mov    %esp,%ebp
80103c56:	83 ec 28             	sub    $0x28,%esp
80103c59:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103c60:	33 11 80 
80103c63:	83 ec 0c             	sub    $0xc,%esp
80103c66:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c69:	50                   	push   %eax
80103c6a:	e8 39 ff ff ff       	call   80103ba8 <mpconfig>
80103c6f:	83 c4 10             	add    $0x10,%esp
80103c72:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c79:	0f 84 96 01 00 00    	je     80103e15 <mpinit+0x1c2>
80103c7f:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103c86:	00 00 00 
80103c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c8c:	8b 40 24             	mov    0x24(%eax),%eax
80103c8f:	a3 7c 32 11 80       	mov    %eax,0x8011327c
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
80103cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb7:	0f b6 00             	movzbl (%eax),%eax
80103cba:	0f b6 c0             	movzbl %al,%eax
80103cbd:	83 f8 04             	cmp    $0x4,%eax
80103cc0:	0f 87 bc 00 00 00    	ja     80103d82 <mpinit+0x12f>
80103cc6:	8b 04 85 9c 90 10 80 	mov    -0x7fef6f64(,%eax,4),%eax
80103ccd:	ff e0                	jmp    *%eax
80103ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cd8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cdc:	0f b6 d0             	movzbl %al,%edx
80103cdf:	a1 60 39 11 80       	mov    0x80113960,%eax
80103ce4:	39 c2                	cmp    %eax,%edx
80103ce6:	74 2b                	je     80103d13 <mpinit+0xc0>
80103ce8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ceb:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cef:	0f b6 d0             	movzbl %al,%edx
80103cf2:	a1 60 39 11 80       	mov    0x80113960,%eax
80103cf7:	83 ec 04             	sub    $0x4,%esp
80103cfa:	52                   	push   %edx
80103cfb:	50                   	push   %eax
80103cfc:	68 5e 90 10 80       	push   $0x8010905e
80103d01:	e8 c0 c6 ff ff       	call   801003c6 <cprintf>
80103d06:	83 c4 10             	add    $0x10,%esp
80103d09:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103d10:	00 00 00 
80103d13:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d16:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103d1a:	0f b6 c0             	movzbl %al,%eax
80103d1d:	83 e0 02             	and    $0x2,%eax
80103d20:	85 c0                	test   %eax,%eax
80103d22:	74 15                	je     80103d39 <mpinit+0xe6>
80103d24:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d29:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d2f:	05 80 33 11 80       	add    $0x80113380,%eax
80103d34:	a3 64 c6 10 80       	mov    %eax,0x8010c664
80103d39:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d3e:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103d44:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d4a:	05 80 33 11 80       	add    $0x80113380,%eax
80103d4f:	88 10                	mov    %dl,(%eax)
80103d51:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d56:	83 c0 01             	add    $0x1,%eax
80103d59:	a3 60 39 11 80       	mov    %eax,0x80113960
80103d5e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
80103d62:	eb 42                	jmp    80103da6 <mpinit+0x153>
80103d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d6d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d71:	a2 60 33 11 80       	mov    %al,0x80113360
80103d76:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
80103d7a:	eb 2a                	jmp    80103da6 <mpinit+0x153>
80103d7c:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
80103d80:	eb 24                	jmp    80103da6 <mpinit+0x153>
80103d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d85:	0f b6 00             	movzbl (%eax),%eax
80103d88:	0f b6 c0             	movzbl %al,%eax
80103d8b:	83 ec 08             	sub    $0x8,%esp
80103d8e:	50                   	push   %eax
80103d8f:	68 7c 90 10 80       	push   $0x8010907c
80103d94:	e8 2d c6 ff ff       	call   801003c6 <cprintf>
80103d99:	83 c4 10             	add    $0x10,%esp
80103d9c:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103da3:	00 00 00 
80103da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103da9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103dac:	0f 82 02 ff ff ff    	jb     80103cb4 <mpinit+0x61>
80103db2:	a1 64 33 11 80       	mov    0x80113364,%eax
80103db7:	85 c0                	test   %eax,%eax
80103db9:	75 1d                	jne    80103dd8 <mpinit+0x185>
80103dbb:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103dc2:	00 00 00 
80103dc5:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103dcc:	00 00 00 
80103dcf:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
80103dd6:	eb 3e                	jmp    80103e16 <mpinit+0x1c3>
80103dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ddb:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103ddf:	84 c0                	test   %al,%al
80103de1:	74 33                	je     80103e16 <mpinit+0x1c3>
80103de3:	83 ec 08             	sub    $0x8,%esp
80103de6:	6a 70                	push   $0x70
80103de8:	6a 22                	push   $0x22
80103dea:	e8 1c fc ff ff       	call   80103a0b <outb>
80103def:	83 c4 10             	add    $0x10,%esp
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
80103e15:	90                   	nop
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
80103f92:	55                   	push   %ebp
80103f93:	89 e5                	mov    %esp,%ebp
80103f95:	83 ec 18             	sub    $0x18,%esp
80103f98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fab:	8b 10                	mov    (%eax),%edx
80103fad:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb0:	89 10                	mov    %edx,(%eax)
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
80103fe4:	e8 dc eb ff ff       	call   80102bc5 <kalloc>
80103fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ff0:	0f 84 9f 00 00 00    	je     80104095 <pipealloc+0x103>
80103ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ff9:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104000:	00 00 00 
80104003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104006:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010400d:	00 00 00 
80104010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104013:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010401a:	00 00 00 
8010401d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104020:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104027:	00 00 00 
8010402a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010402d:	83 ec 08             	sub    $0x8,%esp
80104030:	68 b0 90 10 80       	push   $0x801090b0
80104035:	50                   	push   %eax
80104036:	e8 79 12 00 00       	call   801052b4 <initlock>
8010403b:	83 c4 10             	add    $0x10,%esp
8010403e:	8b 45 08             	mov    0x8(%ebp),%eax
80104041:	8b 00                	mov    (%eax),%eax
80104043:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80104049:	8b 45 08             	mov    0x8(%ebp),%eax
8010404c:	8b 00                	mov    (%eax),%eax
8010404e:	c6 40 08 01          	movb   $0x1,0x8(%eax)
80104052:	8b 45 08             	mov    0x8(%ebp),%eax
80104055:	8b 00                	mov    (%eax),%eax
80104057:	c6 40 09 00          	movb   $0x0,0x9(%eax)
8010405b:	8b 45 08             	mov    0x8(%ebp),%eax
8010405e:	8b 00                	mov    (%eax),%eax
80104060:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104063:	89 50 0c             	mov    %edx,0xc(%eax)
80104066:	8b 45 0c             	mov    0xc(%ebp),%eax
80104069:	8b 00                	mov    (%eax),%eax
8010406b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80104071:	8b 45 0c             	mov    0xc(%ebp),%eax
80104074:	8b 00                	mov    (%eax),%eax
80104076:	c6 40 08 00          	movb   $0x0,0x8(%eax)
8010407a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010407d:	8b 00                	mov    (%eax),%eax
8010407f:	c6 40 09 01          	movb   $0x1,0x9(%eax)
80104083:	8b 45 0c             	mov    0xc(%ebp),%eax
80104086:	8b 00                	mov    (%eax),%eax
80104088:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010408b:	89 50 0c             	mov    %edx,0xc(%eax)
8010408e:	b8 00 00 00 00       	mov    $0x0,%eax
80104093:	eb 4e                	jmp    801040e3 <pipealloc+0x151>
80104095:	90                   	nop
80104096:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010409a:	74 0e                	je     801040aa <pipealloc+0x118>
8010409c:	83 ec 0c             	sub    $0xc,%esp
8010409f:	ff 75 f4             	pushl  -0xc(%ebp)
801040a2:	e8 81 ea ff ff       	call   80102b28 <kfree>
801040a7:	83 c4 10             	add    $0x10,%esp
801040aa:	8b 45 08             	mov    0x8(%ebp),%eax
801040ad:	8b 00                	mov    (%eax),%eax
801040af:	85 c0                	test   %eax,%eax
801040b1:	74 11                	je     801040c4 <pipealloc+0x132>
801040b3:	8b 45 08             	mov    0x8(%ebp),%eax
801040b6:	8b 00                	mov    (%eax),%eax
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	50                   	push   %eax
801040bc:	e8 75 cf ff ff       	call   80101036 <fileclose>
801040c1:	83 c4 10             	add    $0x10,%esp
801040c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c7:	8b 00                	mov    (%eax),%eax
801040c9:	85 c0                	test   %eax,%eax
801040cb:	74 11                	je     801040de <pipealloc+0x14c>
801040cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d0:	8b 00                	mov    (%eax),%eax
801040d2:	83 ec 0c             	sub    $0xc,%esp
801040d5:	50                   	push   %eax
801040d6:	e8 5b cf ff ff       	call   80101036 <fileclose>
801040db:	83 c4 10             	add    $0x10,%esp
801040de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040e3:	c9                   	leave  
801040e4:	c3                   	ret    

801040e5 <pipeclose>:
801040e5:	55                   	push   %ebp
801040e6:	89 e5                	mov    %esp,%ebp
801040e8:	83 ec 08             	sub    $0x8,%esp
801040eb:	8b 45 08             	mov    0x8(%ebp),%eax
801040ee:	83 ec 0c             	sub    $0xc,%esp
801040f1:	50                   	push   %eax
801040f2:	e8 df 11 00 00       	call   801052d6 <acquire>
801040f7:	83 c4 10             	add    $0x10,%esp
801040fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801040fe:	74 23                	je     80104123 <pipeclose+0x3e>
80104100:	8b 45 08             	mov    0x8(%ebp),%eax
80104103:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010410a:	00 00 00 
8010410d:	8b 45 08             	mov    0x8(%ebp),%eax
80104110:	05 34 02 00 00       	add    $0x234,%eax
80104115:	83 ec 0c             	sub    $0xc,%esp
80104118:	50                   	push   %eax
80104119:	e8 3d 0e 00 00       	call   80104f5b <wakeup>
8010411e:	83 c4 10             	add    $0x10,%esp
80104121:	eb 21                	jmp    80104144 <pipeclose+0x5f>
80104123:	8b 45 08             	mov    0x8(%ebp),%eax
80104126:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010412d:	00 00 00 
80104130:	8b 45 08             	mov    0x8(%ebp),%eax
80104133:	05 38 02 00 00       	add    $0x238,%eax
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	50                   	push   %eax
8010413c:	e8 1a 0e 00 00       	call   80104f5b <wakeup>
80104141:	83 c4 10             	add    $0x10,%esp
80104144:	8b 45 08             	mov    0x8(%ebp),%eax
80104147:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010414d:	85 c0                	test   %eax,%eax
8010414f:	75 2c                	jne    8010417d <pipeclose+0x98>
80104151:	8b 45 08             	mov    0x8(%ebp),%eax
80104154:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010415a:	85 c0                	test   %eax,%eax
8010415c:	75 1f                	jne    8010417d <pipeclose+0x98>
8010415e:	8b 45 08             	mov    0x8(%ebp),%eax
80104161:	83 ec 0c             	sub    $0xc,%esp
80104164:	50                   	push   %eax
80104165:	e8 d3 11 00 00       	call   8010533d <release>
8010416a:	83 c4 10             	add    $0x10,%esp
8010416d:	83 ec 0c             	sub    $0xc,%esp
80104170:	ff 75 08             	pushl  0x8(%ebp)
80104173:	e8 b0 e9 ff ff       	call   80102b28 <kfree>
80104178:	83 c4 10             	add    $0x10,%esp
8010417b:	eb 0f                	jmp    8010418c <pipeclose+0xa7>
8010417d:	8b 45 08             	mov    0x8(%ebp),%eax
80104180:	83 ec 0c             	sub    $0xc,%esp
80104183:	50                   	push   %eax
80104184:	e8 b4 11 00 00       	call   8010533d <release>
80104189:	83 c4 10             	add    $0x10,%esp
8010418c:	90                   	nop
8010418d:	c9                   	leave  
8010418e:	c3                   	ret    

8010418f <pipewrite>:
8010418f:	55                   	push   %ebp
80104190:	89 e5                	mov    %esp,%ebp
80104192:	83 ec 18             	sub    $0x18,%esp
80104195:	8b 45 08             	mov    0x8(%ebp),%eax
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	50                   	push   %eax
8010419c:	e8 35 11 00 00       	call   801052d6 <acquire>
801041a1:	83 c4 10             	add    $0x10,%esp
801041a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041ab:	e9 ad 00 00 00       	jmp    8010425d <pipewrite+0xce>
801041b0:	8b 45 08             	mov    0x8(%ebp),%eax
801041b3:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041b9:	85 c0                	test   %eax,%eax
801041bb:	74 0d                	je     801041ca <pipewrite+0x3b>
801041bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041c3:	8b 40 24             	mov    0x24(%eax),%eax
801041c6:	85 c0                	test   %eax,%eax
801041c8:	74 19                	je     801041e3 <pipewrite+0x54>
801041ca:	8b 45 08             	mov    0x8(%ebp),%eax
801041cd:	83 ec 0c             	sub    $0xc,%esp
801041d0:	50                   	push   %eax
801041d1:	e8 67 11 00 00       	call   8010533d <release>
801041d6:	83 c4 10             	add    $0x10,%esp
801041d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041de:	e9 a8 00 00 00       	jmp    8010428b <pipewrite+0xfc>
801041e3:	8b 45 08             	mov    0x8(%ebp),%eax
801041e6:	05 34 02 00 00       	add    $0x234,%eax
801041eb:	83 ec 0c             	sub    $0xc,%esp
801041ee:	50                   	push   %eax
801041ef:	e8 67 0d 00 00       	call   80104f5b <wakeup>
801041f4:	83 c4 10             	add    $0x10,%esp
801041f7:	8b 45 08             	mov    0x8(%ebp),%eax
801041fa:	8b 55 08             	mov    0x8(%ebp),%edx
801041fd:	81 c2 38 02 00 00    	add    $0x238,%edx
80104203:	83 ec 08             	sub    $0x8,%esp
80104206:	50                   	push   %eax
80104207:	52                   	push   %edx
80104208:	e8 60 0c 00 00       	call   80104e6d <sleep>
8010420d:	83 c4 10             	add    $0x10,%esp
80104210:	8b 45 08             	mov    0x8(%ebp),%eax
80104213:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104219:	8b 45 08             	mov    0x8(%ebp),%eax
8010421c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104222:	05 00 02 00 00       	add    $0x200,%eax
80104227:	39 c2                	cmp    %eax,%edx
80104229:	74 85                	je     801041b0 <pipewrite+0x21>
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
80104259:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010425d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104260:	3b 45 10             	cmp    0x10(%ebp),%eax
80104263:	7c ab                	jl     80104210 <pipewrite+0x81>
80104265:	8b 45 08             	mov    0x8(%ebp),%eax
80104268:	05 34 02 00 00       	add    $0x234,%eax
8010426d:	83 ec 0c             	sub    $0xc,%esp
80104270:	50                   	push   %eax
80104271:	e8 e5 0c 00 00       	call   80104f5b <wakeup>
80104276:	83 c4 10             	add    $0x10,%esp
80104279:	8b 45 08             	mov    0x8(%ebp),%eax
8010427c:	83 ec 0c             	sub    $0xc,%esp
8010427f:	50                   	push   %eax
80104280:	e8 b8 10 00 00       	call   8010533d <release>
80104285:	83 c4 10             	add    $0x10,%esp
80104288:	8b 45 10             	mov    0x10(%ebp),%eax
8010428b:	c9                   	leave  
8010428c:	c3                   	ret    

8010428d <piperead>:
8010428d:	55                   	push   %ebp
8010428e:	89 e5                	mov    %esp,%ebp
80104290:	53                   	push   %ebx
80104291:	83 ec 14             	sub    $0x14,%esp
80104294:	8b 45 08             	mov    0x8(%ebp),%eax
80104297:	83 ec 0c             	sub    $0xc,%esp
8010429a:	50                   	push   %eax
8010429b:	e8 36 10 00 00       	call   801052d6 <acquire>
801042a0:	83 c4 10             	add    $0x10,%esp
801042a3:	eb 3f                	jmp    801042e4 <piperead+0x57>
801042a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042ab:	8b 40 24             	mov    0x24(%eax),%eax
801042ae:	85 c0                	test   %eax,%eax
801042b0:	74 19                	je     801042cb <piperead+0x3e>
801042b2:	8b 45 08             	mov    0x8(%ebp),%eax
801042b5:	83 ec 0c             	sub    $0xc,%esp
801042b8:	50                   	push   %eax
801042b9:	e8 7f 10 00 00       	call   8010533d <release>
801042be:	83 c4 10             	add    $0x10,%esp
801042c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042c6:	e9 bf 00 00 00       	jmp    8010438a <piperead+0xfd>
801042cb:	8b 45 08             	mov    0x8(%ebp),%eax
801042ce:	8b 55 08             	mov    0x8(%ebp),%edx
801042d1:	81 c2 34 02 00 00    	add    $0x234,%edx
801042d7:	83 ec 08             	sub    $0x8,%esp
801042da:	50                   	push   %eax
801042db:	52                   	push   %edx
801042dc:	e8 8c 0b 00 00       	call   80104e6d <sleep>
801042e1:	83 c4 10             	add    $0x10,%esp
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
80104307:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010430e:	eb 49                	jmp    80104359 <piperead+0xcc>
80104310:	8b 45 08             	mov    0x8(%ebp),%eax
80104313:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104319:	8b 45 08             	mov    0x8(%ebp),%eax
8010431c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104322:	39 c2                	cmp    %eax,%edx
80104324:	74 3d                	je     80104363 <piperead+0xd6>
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
80104355:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010435f:	7c af                	jl     80104310 <piperead+0x83>
80104361:	eb 01                	jmp    80104364 <piperead+0xd7>
80104363:	90                   	nop
80104364:	8b 45 08             	mov    0x8(%ebp),%eax
80104367:	05 38 02 00 00       	add    $0x238,%eax
8010436c:	83 ec 0c             	sub    $0xc,%esp
8010436f:	50                   	push   %eax
80104370:	e8 e6 0b 00 00       	call   80104f5b <wakeup>
80104375:	83 c4 10             	add    $0x10,%esp
80104378:	8b 45 08             	mov    0x8(%ebp),%eax
8010437b:	83 ec 0c             	sub    $0xc,%esp
8010437e:	50                   	push   %eax
8010437f:	e8 b9 0f 00 00       	call   8010533d <release>
80104384:	83 c4 10             	add    $0x10,%esp
80104387:	8b 45 f4             	mov    -0xc(%ebp),%eax
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
801043af:	68 b5 90 10 80       	push   $0x801090b5
801043b4:	68 80 39 11 80       	push   $0x80113980
801043b9:	e8 f6 0e 00 00       	call   801052b4 <initlock>
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
801043d2:	e8 ff 0e 00 00       	call   801052d6 <acquire>
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
80104405:	e8 33 0f 00 00       	call   8010533d <release>
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
8010443e:	e8 fa 0e 00 00       	call   8010533d <release>
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
80104490:	ba 80 6a 10 80       	mov    $0x80106a80,%edx
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
801044b5:	e8 7f 10 00 00       	call   80105539 <memset>
801044ba:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801044bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c0:	8b 40 1c             	mov    0x1c(%eax),%eax
801044c3:	ba 3c 4e 10 80       	mov    $0x80104e3c,%edx
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
80104524:	e8 33 3d 00 00       	call   8010825c <setupkvm>
80104529:	89 c2                	mov    %eax,%edx
8010452b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452e:	89 50 04             	mov    %edx,0x4(%eax)
80104531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104534:	8b 40 04             	mov    0x4(%eax),%eax
80104537:	85 c0                	test   %eax,%eax
80104539:	75 0d                	jne    80104548 <userinit+0x3a>
    panic("userinit: out of memory?");
8010453b:	83 ec 0c             	sub    $0xc,%esp
8010453e:	68 bc 90 10 80       	push   $0x801090bc
80104543:	e8 1e c0 ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104548:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010454d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104550:	8b 40 04             	mov    0x4(%eax),%eax
80104553:	83 ec 04             	sub    $0x4,%esp
80104556:	52                   	push   %edx
80104557:	68 00 c5 10 80       	push   $0x8010c500
8010455c:	50                   	push   %eax
8010455d:	e8 54 3f 00 00       	call   801084b6 <inituvm>
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
8010457c:	e8 b8 0f 00 00       	call   80105539 <memset>
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
801045f6:	68 d5 90 10 80       	push   $0x801090d5
801045fb:	50                   	push   %eax
801045fc:	e8 3b 11 00 00       	call   8010573c <safestrcpy>
80104601:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104604:	83 ec 0c             	sub    $0xc,%esp
80104607:	68 de 90 10 80       	push   $0x801090de
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
80104659:	e8 cd 40 00 00       	call   8010872b <allocuvm>
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
80104690:	e8 5f 41 00 00       	call   801087f4 <deallocuvm>
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
801046bd:	e8 81 3c 00 00       	call   80108343 <switchuvm>
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
80104703:	e8 39 43 00 00       	call   80108a41 <copyuvm>
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
80104817:	e8 20 0f 00 00       	call   8010573c <safestrcpy>
8010481c:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
8010481f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104822:	8b 40 10             	mov    0x10(%eax),%eax
80104825:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	68 80 39 11 80       	push   $0x80113980
80104830:	e8 a1 0a 00 00       	call   801052d6 <acquire>
80104835:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104838:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010483b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104842:	83 ec 0c             	sub    $0xc,%esp
80104845:	68 80 39 11 80       	push   $0x80113980
8010484a:	e8 ee 0a 00 00       	call   8010533d <release>
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
80104881:	68 e0 90 10 80       	push   $0x801090e0
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
801048a4:	e8 b4 42 00 00       	call   80108b5d <copyuvm_cow>
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
801049b8:	e8 7f 0d 00 00       	call   8010573c <safestrcpy>
801049bd:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
801049c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049c3:	8b 40 10             	mov    0x10(%eax),%eax
801049c6:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801049c9:	83 ec 0c             	sub    $0xc,%esp
801049cc:	68 80 39 11 80       	push   $0x80113980
801049d1:	e8 00 09 00 00       	call   801052d6 <acquire>
801049d6:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801049d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801049e3:	83 ec 0c             	sub    $0xc,%esp
801049e6:	68 80 39 11 80       	push   $0x80113980
801049eb:	e8 4d 09 00 00       	call   8010533d <release>
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
80104a13:	68 ed 90 10 80       	push   $0x801090ed
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
80104a34:	68 01 91 10 80       	push   $0x80109101
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
80104a54:	68 0a 91 10 80       	push   $0x8010910a
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
80104ae9:	e8 e8 07 00 00       	call   801052d6 <acquire>
80104aee:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104af1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af7:	8b 40 14             	mov    0x14(%eax),%eax
80104afa:	83 ec 0c             	sub    $0xc,%esp
80104afd:	50                   	push   %eax
80104afe:	e8 16 04 00 00       	call   80104f19 <wakeup1>
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
80104b3f:	e8 d5 03 00 00       	call   80104f19 <wakeup1>
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
80104b64:	e8 dc 01 00 00       	call   80104d45 <sched>
  panic("zombie exit");
80104b69:	83 ec 0c             	sub    $0xc,%esp
80104b6c:	68 17 91 10 80       	push   $0x80109117
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
80104b84:	e8 4d 07 00 00       	call   801052d6 <acquire>
80104b89:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b93:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104b9a:	e9 a9 00 00 00       	jmp    80104c48 <wait+0xd2>
      if(p->parent != proc)
80104b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba2:	8b 50 14             	mov    0x14(%eax),%edx
80104ba5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bab:	39 c2                	cmp    %eax,%edx
80104bad:	0f 85 8d 00 00 00    	jne    80104c40 <wait+0xca>
        continue;
      havekids = 1;
80104bb3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbd:	8b 40 0c             	mov    0xc(%eax),%eax
80104bc0:	83 f8 05             	cmp    $0x5,%eax
80104bc3:	75 7c                	jne    80104c41 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc8:	8b 40 10             	mov    0x10(%eax),%eax
80104bcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd1:	8b 40 08             	mov    0x8(%eax),%eax
80104bd4:	83 ec 0c             	sub    $0xc,%esp
80104bd7:	50                   	push   %eax
80104bd8:	e8 4b df ff ff       	call   80102b28 <kfree>
80104bdd:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bed:	8b 40 04             	mov    0x4(%eax),%eax
80104bf0:	83 ec 0c             	sub    $0xc,%esp
80104bf3:	50                   	push   %eax
80104bf4:	e8 67 3d 00 00       	call   80108960 <freevm>
80104bf9:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c09:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c13:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c1d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c24:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104c2b:	83 ec 0c             	sub    $0xc,%esp
80104c2e:	68 80 39 11 80       	push   $0x80113980
80104c33:	e8 05 07 00 00       	call   8010533d <release>
80104c38:	83 c4 10             	add    $0x10,%esp
        return pid;
80104c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c3e:	eb 5b                	jmp    80104c9b <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104c40:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c41:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104c48:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104c4f:	0f 82 4a ff ff ff    	jb     80104b9f <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104c55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c59:	74 0d                	je     80104c68 <wait+0xf2>
80104c5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c61:	8b 40 24             	mov    0x24(%eax),%eax
80104c64:	85 c0                	test   %eax,%eax
80104c66:	74 17                	je     80104c7f <wait+0x109>
      release(&ptable.lock);
80104c68:	83 ec 0c             	sub    $0xc,%esp
80104c6b:	68 80 39 11 80       	push   $0x80113980
80104c70:	e8 c8 06 00 00       	call   8010533d <release>
80104c75:	83 c4 10             	add    $0x10,%esp
      return -1;
80104c78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c7d:	eb 1c                	jmp    80104c9b <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c85:	83 ec 08             	sub    $0x8,%esp
80104c88:	68 80 39 11 80       	push   $0x80113980
80104c8d:	50                   	push   %eax
80104c8e:	e8 da 01 00 00       	call   80104e6d <sleep>
80104c93:	83 c4 10             	add    $0x10,%esp
  }
80104c96:	e9 f1 fe ff ff       	jmp    80104b8c <wait+0x16>
}
80104c9b:	c9                   	leave  
80104c9c:	c3                   	ret    

80104c9d <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104c9d:	55                   	push   %ebp
80104c9e:	89 e5                	mov    %esp,%ebp
80104ca0:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104ca3:	e8 f7 f6 ff ff       	call   8010439f <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104ca8:	83 ec 0c             	sub    $0xc,%esp
80104cab:	68 80 39 11 80       	push   $0x80113980
80104cb0:	e8 21 06 00 00       	call   801052d6 <acquire>
80104cb5:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cb8:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104cbf:	eb 66                	jmp    80104d27 <scheduler+0x8a>
      if(p->state != RUNNABLE)
80104cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc4:	8b 40 0c             	mov    0xc(%eax),%eax
80104cc7:	83 f8 03             	cmp    $0x3,%eax
80104cca:	75 53                	jne    80104d1f <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ccf:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104cd5:	83 ec 0c             	sub    $0xc,%esp
80104cd8:	ff 75 f4             	pushl  -0xc(%ebp)
80104cdb:	e8 63 36 00 00       	call   80108343 <switchuvm>
80104ce0:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce6:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104ced:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cf3:	8b 40 1c             	mov    0x1c(%eax),%eax
80104cf6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104cfd:	83 c2 04             	add    $0x4,%edx
80104d00:	83 ec 08             	sub    $0x8,%esp
80104d03:	50                   	push   %eax
80104d04:	52                   	push   %edx
80104d05:	e8 a3 0a 00 00       	call   801057ad <swtch>
80104d0a:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104d0d:	e8 14 36 00 00       	call   80108326 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104d12:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104d19:	00 00 00 00 
80104d1d:	eb 01                	jmp    80104d20 <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104d1f:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d20:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104d27:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104d2e:	72 91                	jb     80104cc1 <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104d30:	83 ec 0c             	sub    $0xc,%esp
80104d33:	68 80 39 11 80       	push   $0x80113980
80104d38:	e8 00 06 00 00       	call   8010533d <release>
80104d3d:	83 c4 10             	add    $0x10,%esp

  }
80104d40:	e9 5e ff ff ff       	jmp    80104ca3 <scheduler+0x6>

80104d45 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104d45:	55                   	push   %ebp
80104d46:	89 e5                	mov    %esp,%ebp
80104d48:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104d4b:	83 ec 0c             	sub    $0xc,%esp
80104d4e:	68 80 39 11 80       	push   $0x80113980
80104d53:	e8 b1 06 00 00       	call   80105409 <holding>
80104d58:	83 c4 10             	add    $0x10,%esp
80104d5b:	85 c0                	test   %eax,%eax
80104d5d:	75 0d                	jne    80104d6c <sched+0x27>
    panic("sched ptable.lock");
80104d5f:	83 ec 0c             	sub    $0xc,%esp
80104d62:	68 23 91 10 80       	push   $0x80109123
80104d67:	e8 fa b7 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104d6c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d72:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d78:	83 f8 01             	cmp    $0x1,%eax
80104d7b:	74 0d                	je     80104d8a <sched+0x45>
    panic("sched locks");
80104d7d:	83 ec 0c             	sub    $0xc,%esp
80104d80:	68 35 91 10 80       	push   $0x80109135
80104d85:	e8 dc b7 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104d8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d90:	8b 40 0c             	mov    0xc(%eax),%eax
80104d93:	83 f8 04             	cmp    $0x4,%eax
80104d96:	75 0d                	jne    80104da5 <sched+0x60>
    panic("sched running");
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	68 41 91 10 80       	push   $0x80109141
80104da0:	e8 c1 b7 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104da5:	e8 e5 f5 ff ff       	call   8010438f <readeflags>
80104daa:	25 00 02 00 00       	and    $0x200,%eax
80104daf:	85 c0                	test   %eax,%eax
80104db1:	74 0d                	je     80104dc0 <sched+0x7b>
    panic("sched interruptible");
80104db3:	83 ec 0c             	sub    $0xc,%esp
80104db6:	68 4f 91 10 80       	push   $0x8010914f
80104dbb:	e8 a6 b7 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104dc0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dc6:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104dcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104dcf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dd5:	8b 40 04             	mov    0x4(%eax),%eax
80104dd8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ddf:	83 c2 1c             	add    $0x1c,%edx
80104de2:	83 ec 08             	sub    $0x8,%esp
80104de5:	50                   	push   %eax
80104de6:	52                   	push   %edx
80104de7:	e8 c1 09 00 00       	call   801057ad <swtch>
80104dec:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104def:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104df8:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104dfe:	90                   	nop
80104dff:	c9                   	leave  
80104e00:	c3                   	ret    

80104e01 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104e01:	55                   	push   %ebp
80104e02:	89 e5                	mov    %esp,%ebp
80104e04:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104e07:	83 ec 0c             	sub    $0xc,%esp
80104e0a:	68 80 39 11 80       	push   $0x80113980
80104e0f:	e8 c2 04 00 00       	call   801052d6 <acquire>
80104e14:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104e17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e1d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104e24:	e8 1c ff ff ff       	call   80104d45 <sched>
  release(&ptable.lock);
80104e29:	83 ec 0c             	sub    $0xc,%esp
80104e2c:	68 80 39 11 80       	push   $0x80113980
80104e31:	e8 07 05 00 00       	call   8010533d <release>
80104e36:	83 c4 10             	add    $0x10,%esp
}
80104e39:	90                   	nop
80104e3a:	c9                   	leave  
80104e3b:	c3                   	ret    

80104e3c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104e3c:	55                   	push   %ebp
80104e3d:	89 e5                	mov    %esp,%ebp
80104e3f:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104e42:	83 ec 0c             	sub    $0xc,%esp
80104e45:	68 80 39 11 80       	push   $0x80113980
80104e4a:	e8 ee 04 00 00       	call   8010533d <release>
80104e4f:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104e52:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104e57:	85 c0                	test   %eax,%eax
80104e59:	74 0f                	je     80104e6a <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104e5b:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104e62:	00 00 00 
    initlog();
80104e65:	e8 24 e4 ff ff       	call   8010328e <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104e6a:	90                   	nop
80104e6b:	c9                   	leave  
80104e6c:	c3                   	ret    

80104e6d <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e6d:	55                   	push   %ebp
80104e6e:	89 e5                	mov    %esp,%ebp
80104e70:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104e73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e79:	85 c0                	test   %eax,%eax
80104e7b:	75 0d                	jne    80104e8a <sleep+0x1d>
    panic("sleep");
80104e7d:	83 ec 0c             	sub    $0xc,%esp
80104e80:	68 63 91 10 80       	push   $0x80109163
80104e85:	e8 dc b6 ff ff       	call   80100566 <panic>

  if(lk == 0)
80104e8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e8e:	75 0d                	jne    80104e9d <sleep+0x30>
    panic("sleep without lk");
80104e90:	83 ec 0c             	sub    $0xc,%esp
80104e93:	68 69 91 10 80       	push   $0x80109169
80104e98:	e8 c9 b6 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104e9d:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104ea4:	74 1e                	je     80104ec4 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ea6:	83 ec 0c             	sub    $0xc,%esp
80104ea9:	68 80 39 11 80       	push   $0x80113980
80104eae:	e8 23 04 00 00       	call   801052d6 <acquire>
80104eb3:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104eb6:	83 ec 0c             	sub    $0xc,%esp
80104eb9:	ff 75 0c             	pushl  0xc(%ebp)
80104ebc:	e8 7c 04 00 00       	call   8010533d <release>
80104ec1:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104ec4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eca:	8b 55 08             	mov    0x8(%ebp),%edx
80104ecd:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104ed0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ed6:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104edd:	e8 63 fe ff ff       	call   80104d45 <sched>

  // Tidy up.
  proc->chan = 0;
80104ee2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ee8:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104eef:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104ef6:	74 1e                	je     80104f16 <sleep+0xa9>
    release(&ptable.lock);
80104ef8:	83 ec 0c             	sub    $0xc,%esp
80104efb:	68 80 39 11 80       	push   $0x80113980
80104f00:	e8 38 04 00 00       	call   8010533d <release>
80104f05:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104f08:	83 ec 0c             	sub    $0xc,%esp
80104f0b:	ff 75 0c             	pushl  0xc(%ebp)
80104f0e:	e8 c3 03 00 00       	call   801052d6 <acquire>
80104f13:	83 c4 10             	add    $0x10,%esp
  }
}
80104f16:	90                   	nop
80104f17:	c9                   	leave  
80104f18:	c3                   	ret    

80104f19 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104f19:	55                   	push   %ebp
80104f1a:	89 e5                	mov    %esp,%ebp
80104f1c:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f1f:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104f26:	eb 27                	jmp    80104f4f <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104f28:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f2b:	8b 40 0c             	mov    0xc(%eax),%eax
80104f2e:	83 f8 02             	cmp    $0x2,%eax
80104f31:	75 15                	jne    80104f48 <wakeup1+0x2f>
80104f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f36:	8b 40 20             	mov    0x20(%eax),%eax
80104f39:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f3c:	75 0a                	jne    80104f48 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f41:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f48:	81 45 fc 8c 00 00 00 	addl   $0x8c,-0x4(%ebp)
80104f4f:	81 7d fc b4 5c 11 80 	cmpl   $0x80115cb4,-0x4(%ebp)
80104f56:	72 d0                	jb     80104f28 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104f58:	90                   	nop
80104f59:	c9                   	leave  
80104f5a:	c3                   	ret    

80104f5b <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104f5b:	55                   	push   %ebp
80104f5c:	89 e5                	mov    %esp,%ebp
80104f5e:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104f61:	83 ec 0c             	sub    $0xc,%esp
80104f64:	68 80 39 11 80       	push   $0x80113980
80104f69:	e8 68 03 00 00       	call   801052d6 <acquire>
80104f6e:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104f71:	83 ec 0c             	sub    $0xc,%esp
80104f74:	ff 75 08             	pushl  0x8(%ebp)
80104f77:	e8 9d ff ff ff       	call   80104f19 <wakeup1>
80104f7c:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104f7f:	83 ec 0c             	sub    $0xc,%esp
80104f82:	68 80 39 11 80       	push   $0x80113980
80104f87:	e8 b1 03 00 00       	call   8010533d <release>
80104f8c:	83 c4 10             	add    $0x10,%esp
}
80104f8f:	90                   	nop
80104f90:	c9                   	leave  
80104f91:	c3                   	ret    

80104f92 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104f92:	55                   	push   %ebp
80104f93:	89 e5                	mov    %esp,%ebp
80104f95:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104f98:	83 ec 0c             	sub    $0xc,%esp
80104f9b:	68 80 39 11 80       	push   $0x80113980
80104fa0:	e8 31 03 00 00       	call   801052d6 <acquire>
80104fa5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fa8:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104faf:	eb 48                	jmp    80104ff9 <kill+0x67>
    if(p->pid == pid){
80104fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fb4:	8b 40 10             	mov    0x10(%eax),%eax
80104fb7:	3b 45 08             	cmp    0x8(%ebp),%eax
80104fba:	75 36                	jne    80104ff2 <kill+0x60>
      p->killed = 1;
80104fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fbf:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc9:	8b 40 0c             	mov    0xc(%eax),%eax
80104fcc:	83 f8 02             	cmp    $0x2,%eax
80104fcf:	75 0a                	jne    80104fdb <kill+0x49>
        p->state = RUNNABLE;
80104fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104fdb:	83 ec 0c             	sub    $0xc,%esp
80104fde:	68 80 39 11 80       	push   $0x80113980
80104fe3:	e8 55 03 00 00       	call   8010533d <release>
80104fe8:	83 c4 10             	add    $0x10,%esp
      return 0;
80104feb:	b8 00 00 00 00       	mov    $0x0,%eax
80104ff0:	eb 25                	jmp    80105017 <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ff2:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104ff9:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80105000:	72 af                	jb     80104fb1 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80105002:	83 ec 0c             	sub    $0xc,%esp
80105005:	68 80 39 11 80       	push   $0x80113980
8010500a:	e8 2e 03 00 00       	call   8010533d <release>
8010500f:	83 c4 10             	add    $0x10,%esp
  return -1;
80105012:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105017:	c9                   	leave  
80105018:	c3                   	ret    

80105019 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105019:	55                   	push   %ebp
8010501a:	89 e5                	mov    %esp,%ebp
8010501c:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010501f:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80105026:	e9 da 00 00 00       	jmp    80105105 <procdump+0xec>
    if(p->state == UNUSED)
8010502b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010502e:	8b 40 0c             	mov    0xc(%eax),%eax
80105031:	85 c0                	test   %eax,%eax
80105033:	0f 84 c4 00 00 00    	je     801050fd <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105039:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010503c:	8b 40 0c             	mov    0xc(%eax),%eax
8010503f:	83 f8 05             	cmp    $0x5,%eax
80105042:	77 23                	ja     80105067 <procdump+0x4e>
80105044:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105047:	8b 40 0c             	mov    0xc(%eax),%eax
8010504a:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105051:	85 c0                	test   %eax,%eax
80105053:	74 12                	je     80105067 <procdump+0x4e>
      state = states[p->state];
80105055:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105058:	8b 40 0c             	mov    0xc(%eax),%eax
8010505b:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105062:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105065:	eb 07                	jmp    8010506e <procdump+0x55>
    else
      state = "???";
80105067:	c7 45 ec 7a 91 10 80 	movl   $0x8010917a,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
8010506e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105071:	8d 50 6c             	lea    0x6c(%eax),%edx
80105074:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105077:	8b 40 10             	mov    0x10(%eax),%eax
8010507a:	52                   	push   %edx
8010507b:	ff 75 ec             	pushl  -0x14(%ebp)
8010507e:	50                   	push   %eax
8010507f:	68 7e 91 10 80       	push   $0x8010917e
80105084:	e8 3d b3 ff ff       	call   801003c6 <cprintf>
80105089:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
8010508c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010508f:	8b 40 0c             	mov    0xc(%eax),%eax
80105092:	83 f8 02             	cmp    $0x2,%eax
80105095:	75 54                	jne    801050eb <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105097:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010509a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010509d:	8b 40 0c             	mov    0xc(%eax),%eax
801050a0:	83 c0 08             	add    $0x8,%eax
801050a3:	89 c2                	mov    %eax,%edx
801050a5:	83 ec 08             	sub    $0x8,%esp
801050a8:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050ab:	50                   	push   %eax
801050ac:	52                   	push   %edx
801050ad:	e8 dd 02 00 00       	call   8010538f <getcallerpcs>
801050b2:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801050b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801050bc:	eb 1c                	jmp    801050da <procdump+0xc1>
        cprintf(" %p", pc[i]);
801050be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c1:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050c5:	83 ec 08             	sub    $0x8,%esp
801050c8:	50                   	push   %eax
801050c9:	68 87 91 10 80       	push   $0x80109187
801050ce:	e8 f3 b2 ff ff       	call   801003c6 <cprintf>
801050d3:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801050d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801050da:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801050de:	7f 0b                	jg     801050eb <procdump+0xd2>
801050e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e3:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050e7:	85 c0                	test   %eax,%eax
801050e9:	75 d3                	jne    801050be <procdump+0xa5>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801050eb:	83 ec 0c             	sub    $0xc,%esp
801050ee:	68 8b 91 10 80       	push   $0x8010918b
801050f3:	e8 ce b2 ff ff       	call   801003c6 <cprintf>
801050f8:	83 c4 10             	add    $0x10,%esp
801050fb:	eb 01                	jmp    801050fe <procdump+0xe5>
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801050fd:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050fe:	81 45 f0 8c 00 00 00 	addl   $0x8c,-0x10(%ebp)
80105105:	81 7d f0 b4 5c 11 80 	cmpl   $0x80115cb4,-0x10(%ebp)
8010510c:	0f 82 19 ff ff ff    	jb     8010502b <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105112:	90                   	nop
80105113:	c9                   	leave  
80105114:	c3                   	ret    

80105115 <signal_deliver>:

void signal_deliver(int signum,siginfo_t si)
{
80105115:	55                   	push   %ebp
80105116:	89 e5                	mov    %esp,%ebp
80105118:	83 ec 10             	sub    $0x10,%esp
	uint old_eip = proc->tf->eip;
8010511b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105121:	8b 40 18             	mov    0x18(%eax),%eax
80105124:	8b 40 38             	mov    0x38(%eax),%eax
80105127:	89 45 fc             	mov    %eax,-0x4(%ebp)
	*((uint*)(proc->tf->esp - 4))  = (uint) old_eip;		// real return address
8010512a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105130:	8b 40 18             	mov    0x18(%eax),%eax
80105133:	8b 40 44             	mov    0x44(%eax),%eax
80105136:	83 e8 04             	sub    $0x4,%eax
80105139:	89 c2                	mov    %eax,%edx
8010513b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010513e:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 8))  = proc->tf->eax;			// eax
80105140:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105146:	8b 40 18             	mov    0x18(%eax),%eax
80105149:	8b 40 44             	mov    0x44(%eax),%eax
8010514c:	83 e8 08             	sub    $0x8,%eax
8010514f:	89 c2                	mov    %eax,%edx
80105151:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105157:	8b 40 18             	mov    0x18(%eax),%eax
8010515a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010515d:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 12)) = proc->tf->ecx;			// ecx
8010515f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105165:	8b 40 18             	mov    0x18(%eax),%eax
80105168:	8b 40 44             	mov    0x44(%eax),%eax
8010516b:	83 e8 0c             	sub    $0xc,%eax
8010516e:	89 c2                	mov    %eax,%edx
80105170:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105176:	8b 40 18             	mov    0x18(%eax),%eax
80105179:	8b 40 18             	mov    0x18(%eax),%eax
8010517c:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 16)) = proc->tf->edx;			// edx
8010517e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105184:	8b 40 18             	mov    0x18(%eax),%eax
80105187:	8b 40 44             	mov    0x44(%eax),%eax
8010518a:	83 e8 10             	sub    $0x10,%eax
8010518d:	89 c2                	mov    %eax,%edx
8010518f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105195:	8b 40 18             	mov    0x18(%eax),%eax
80105198:	8b 40 14             	mov    0x14(%eax),%eax
8010519b:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 20)) = si.type;       //address mem fault occured
8010519d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051a3:	8b 40 18             	mov    0x18(%eax),%eax
801051a6:	8b 40 44             	mov    0x44(%eax),%eax
801051a9:	83 e8 14             	sub    $0x14,%eax
801051ac:	89 c2                	mov    %eax,%edx
801051ae:	8b 45 10             	mov    0x10(%ebp),%eax
801051b1:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 24)) = si.addr;       //address mem fault occured
801051b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051b9:	8b 40 18             	mov    0x18(%eax),%eax
801051bc:	8b 40 44             	mov    0x44(%eax),%eax
801051bf:	83 e8 18             	sub    $0x18,%eax
801051c2:	89 c2                	mov    %eax,%edx
801051c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801051c7:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 28)) = (uint) signum;			// signal number
801051c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051cf:	8b 40 18             	mov    0x18(%eax),%eax
801051d2:	8b 40 44             	mov    0x44(%eax),%eax
801051d5:	83 e8 1c             	sub    $0x1c,%eax
801051d8:	89 c2                	mov    %eax,%edx
801051da:	8b 45 08             	mov    0x8(%ebp),%eax
801051dd:	89 02                	mov    %eax,(%edx)
	*((uint*)(proc->tf->esp - 32)) = proc->restorer_addr;	// address of restorer
801051df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051e5:	8b 40 18             	mov    0x18(%eax),%eax
801051e8:	8b 40 44             	mov    0x44(%eax),%eax
801051eb:	83 e8 20             	sub    $0x20,%eax
801051ee:	89 c2                	mov    %eax,%edx
801051f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051f6:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801051fc:	89 02                	mov    %eax,(%edx)
	proc->tf->esp -= 32;
801051fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105204:	8b 40 18             	mov    0x18(%eax),%eax
80105207:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010520e:	8b 52 18             	mov    0x18(%edx),%edx
80105211:	8b 52 44             	mov    0x44(%edx),%edx
80105214:	83 ea 20             	sub    $0x20,%edx
80105217:	89 50 44             	mov    %edx,0x44(%eax)
	proc->tf->eip = (uint) proc->handlers[signum];
8010521a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105220:	8b 40 18             	mov    0x18(%eax),%eax
80105223:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010522a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010522d:	83 c1 1c             	add    $0x1c,%ecx
80105230:	8b 54 8a 0c          	mov    0xc(%edx,%ecx,4),%edx
80105234:	89 50 38             	mov    %edx,0x38(%eax)
}
80105237:	90                   	nop
80105238:	c9                   	leave  
80105239:	c3                   	ret    

8010523a <signal_register_handler>:



sighandler_t signal_register_handler(int signum, sighandler_t handler)
{
8010523a:	55                   	push   %ebp
8010523b:	89 e5                	mov    %esp,%ebp
8010523d:	83 ec 10             	sub    $0x10,%esp
	if (!proc)
80105240:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105246:	85 c0                	test   %eax,%eax
80105248:	75 07                	jne    80105251 <signal_register_handler+0x17>
		return (sighandler_t) -1;
8010524a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524f:	eb 29                	jmp    8010527a <signal_register_handler+0x40>

	sighandler_t previous = proc->handlers[signum];
80105251:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105257:	8b 55 08             	mov    0x8(%ebp),%edx
8010525a:	83 c2 1c             	add    $0x1c,%edx
8010525d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105261:	89 45 fc             	mov    %eax,-0x4(%ebp)

	proc->handlers[signum] = handler;
80105264:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010526a:	8b 55 08             	mov    0x8(%ebp),%edx
8010526d:	8d 4a 1c             	lea    0x1c(%edx),%ecx
80105270:	8b 55 0c             	mov    0xc(%ebp),%edx
80105273:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)

	return previous;
80105277:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010527a:	c9                   	leave  
8010527b:	c3                   	ret    

8010527c <readeflags>:
8010527c:	55                   	push   %ebp
8010527d:	89 e5                	mov    %esp,%ebp
8010527f:	83 ec 10             	sub    $0x10,%esp
80105282:	9c                   	pushf  
80105283:	58                   	pop    %eax
80105284:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105287:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010528a:	c9                   	leave  
8010528b:	c3                   	ret    

8010528c <cli>:
8010528c:	55                   	push   %ebp
8010528d:	89 e5                	mov    %esp,%ebp
8010528f:	fa                   	cli    
80105290:	90                   	nop
80105291:	5d                   	pop    %ebp
80105292:	c3                   	ret    

80105293 <sti>:
80105293:	55                   	push   %ebp
80105294:	89 e5                	mov    %esp,%ebp
80105296:	fb                   	sti    
80105297:	90                   	nop
80105298:	5d                   	pop    %ebp
80105299:	c3                   	ret    

8010529a <xchg>:
8010529a:	55                   	push   %ebp
8010529b:	89 e5                	mov    %esp,%ebp
8010529d:	83 ec 10             	sub    $0x10,%esp
801052a0:	8b 55 08             	mov    0x8(%ebp),%edx
801052a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801052a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052a9:	f0 87 02             	lock xchg %eax,(%edx)
801052ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
801052af:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052b2:	c9                   	leave  
801052b3:	c3                   	ret    

801052b4 <initlock>:
801052b4:	55                   	push   %ebp
801052b5:	89 e5                	mov    %esp,%ebp
801052b7:	8b 45 08             	mov    0x8(%ebp),%eax
801052ba:	8b 55 0c             	mov    0xc(%ebp),%edx
801052bd:	89 50 04             	mov    %edx,0x4(%eax)
801052c0:	8b 45 08             	mov    0x8(%ebp),%eax
801052c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801052c9:	8b 45 08             	mov    0x8(%ebp),%eax
801052cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
801052d3:	90                   	nop
801052d4:	5d                   	pop    %ebp
801052d5:	c3                   	ret    

801052d6 <acquire>:
801052d6:	55                   	push   %ebp
801052d7:	89 e5                	mov    %esp,%ebp
801052d9:	83 ec 08             	sub    $0x8,%esp
801052dc:	e8 52 01 00 00       	call   80105433 <pushcli>
801052e1:	8b 45 08             	mov    0x8(%ebp),%eax
801052e4:	83 ec 0c             	sub    $0xc,%esp
801052e7:	50                   	push   %eax
801052e8:	e8 1c 01 00 00       	call   80105409 <holding>
801052ed:	83 c4 10             	add    $0x10,%esp
801052f0:	85 c0                	test   %eax,%eax
801052f2:	74 0d                	je     80105301 <acquire+0x2b>
801052f4:	83 ec 0c             	sub    $0xc,%esp
801052f7:	68 b7 91 10 80       	push   $0x801091b7
801052fc:	e8 65 b2 ff ff       	call   80100566 <panic>
80105301:	90                   	nop
80105302:	8b 45 08             	mov    0x8(%ebp),%eax
80105305:	83 ec 08             	sub    $0x8,%esp
80105308:	6a 01                	push   $0x1
8010530a:	50                   	push   %eax
8010530b:	e8 8a ff ff ff       	call   8010529a <xchg>
80105310:	83 c4 10             	add    $0x10,%esp
80105313:	85 c0                	test   %eax,%eax
80105315:	75 eb                	jne    80105302 <acquire+0x2c>
80105317:	8b 45 08             	mov    0x8(%ebp),%eax
8010531a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105321:	89 50 08             	mov    %edx,0x8(%eax)
80105324:	8b 45 08             	mov    0x8(%ebp),%eax
80105327:	83 c0 0c             	add    $0xc,%eax
8010532a:	83 ec 08             	sub    $0x8,%esp
8010532d:	50                   	push   %eax
8010532e:	8d 45 08             	lea    0x8(%ebp),%eax
80105331:	50                   	push   %eax
80105332:	e8 58 00 00 00       	call   8010538f <getcallerpcs>
80105337:	83 c4 10             	add    $0x10,%esp
8010533a:	90                   	nop
8010533b:	c9                   	leave  
8010533c:	c3                   	ret    

8010533d <release>:
8010533d:	55                   	push   %ebp
8010533e:	89 e5                	mov    %esp,%ebp
80105340:	83 ec 08             	sub    $0x8,%esp
80105343:	83 ec 0c             	sub    $0xc,%esp
80105346:	ff 75 08             	pushl  0x8(%ebp)
80105349:	e8 bb 00 00 00       	call   80105409 <holding>
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	85 c0                	test   %eax,%eax
80105353:	75 0d                	jne    80105362 <release+0x25>
80105355:	83 ec 0c             	sub    $0xc,%esp
80105358:	68 bf 91 10 80       	push   $0x801091bf
8010535d:	e8 04 b2 ff ff       	call   80100566 <panic>
80105362:	8b 45 08             	mov    0x8(%ebp),%eax
80105365:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
8010536c:	8b 45 08             	mov    0x8(%ebp),%eax
8010536f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80105376:	8b 45 08             	mov    0x8(%ebp),%eax
80105379:	83 ec 08             	sub    $0x8,%esp
8010537c:	6a 00                	push   $0x0
8010537e:	50                   	push   %eax
8010537f:	e8 16 ff ff ff       	call   8010529a <xchg>
80105384:	83 c4 10             	add    $0x10,%esp
80105387:	e8 ec 00 00 00       	call   80105478 <popcli>
8010538c:	90                   	nop
8010538d:	c9                   	leave  
8010538e:	c3                   	ret    

8010538f <getcallerpcs>:
8010538f:	55                   	push   %ebp
80105390:	89 e5                	mov    %esp,%ebp
80105392:	83 ec 10             	sub    $0x10,%esp
80105395:	8b 45 08             	mov    0x8(%ebp),%eax
80105398:	83 e8 08             	sub    $0x8,%eax
8010539b:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010539e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801053a5:	eb 38                	jmp    801053df <getcallerpcs+0x50>
801053a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801053ab:	74 53                	je     80105400 <getcallerpcs+0x71>
801053ad:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801053b4:	76 4a                	jbe    80105400 <getcallerpcs+0x71>
801053b6:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801053ba:	74 44                	je     80105400 <getcallerpcs+0x71>
801053bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801053c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801053c9:	01 c2                	add    %eax,%edx
801053cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053ce:	8b 40 04             	mov    0x4(%eax),%eax
801053d1:	89 02                	mov    %eax,(%edx)
801053d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053d6:	8b 00                	mov    (%eax),%eax
801053d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801053db:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801053df:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801053e3:	7e c2                	jle    801053a7 <getcallerpcs+0x18>
801053e5:	eb 19                	jmp    80105400 <getcallerpcs+0x71>
801053e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801053f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801053f4:	01 d0                	add    %edx,%eax
801053f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801053fc:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105400:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105404:	7e e1                	jle    801053e7 <getcallerpcs+0x58>
80105406:	90                   	nop
80105407:	c9                   	leave  
80105408:	c3                   	ret    

80105409 <holding>:
80105409:	55                   	push   %ebp
8010540a:	89 e5                	mov    %esp,%ebp
8010540c:	8b 45 08             	mov    0x8(%ebp),%eax
8010540f:	8b 00                	mov    (%eax),%eax
80105411:	85 c0                	test   %eax,%eax
80105413:	74 17                	je     8010542c <holding+0x23>
80105415:	8b 45 08             	mov    0x8(%ebp),%eax
80105418:	8b 50 08             	mov    0x8(%eax),%edx
8010541b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105421:	39 c2                	cmp    %eax,%edx
80105423:	75 07                	jne    8010542c <holding+0x23>
80105425:	b8 01 00 00 00       	mov    $0x1,%eax
8010542a:	eb 05                	jmp    80105431 <holding+0x28>
8010542c:	b8 00 00 00 00       	mov    $0x0,%eax
80105431:	5d                   	pop    %ebp
80105432:	c3                   	ret    

80105433 <pushcli>:
80105433:	55                   	push   %ebp
80105434:	89 e5                	mov    %esp,%ebp
80105436:	83 ec 10             	sub    $0x10,%esp
80105439:	e8 3e fe ff ff       	call   8010527c <readeflags>
8010543e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105441:	e8 46 fe ff ff       	call   8010528c <cli>
80105446:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010544d:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105453:	8d 48 01             	lea    0x1(%eax),%ecx
80105456:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
8010545c:	85 c0                	test   %eax,%eax
8010545e:	75 15                	jne    80105475 <pushcli+0x42>
80105460:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105466:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105469:	81 e2 00 02 00 00    	and    $0x200,%edx
8010546f:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
80105475:	90                   	nop
80105476:	c9                   	leave  
80105477:	c3                   	ret    

80105478 <popcli>:
80105478:	55                   	push   %ebp
80105479:	89 e5                	mov    %esp,%ebp
8010547b:	83 ec 08             	sub    $0x8,%esp
8010547e:	e8 f9 fd ff ff       	call   8010527c <readeflags>
80105483:	25 00 02 00 00       	and    $0x200,%eax
80105488:	85 c0                	test   %eax,%eax
8010548a:	74 0d                	je     80105499 <popcli+0x21>
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	68 c7 91 10 80       	push   $0x801091c7
80105494:	e8 cd b0 ff ff       	call   80100566 <panic>
80105499:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010549f:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801054a5:	83 ea 01             	sub    $0x1,%edx
801054a8:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801054ae:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054b4:	85 c0                	test   %eax,%eax
801054b6:	79 0d                	jns    801054c5 <popcli+0x4d>
801054b8:	83 ec 0c             	sub    $0xc,%esp
801054bb:	68 de 91 10 80       	push   $0x801091de
801054c0:	e8 a1 b0 ff ff       	call   80100566 <panic>
801054c5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054cb:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054d1:	85 c0                	test   %eax,%eax
801054d3:	75 15                	jne    801054ea <popcli+0x72>
801054d5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054db:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801054e1:	85 c0                	test   %eax,%eax
801054e3:	74 05                	je     801054ea <popcli+0x72>
801054e5:	e8 a9 fd ff ff       	call   80105293 <sti>
801054ea:	90                   	nop
801054eb:	c9                   	leave  
801054ec:	c3                   	ret    

801054ed <stosb>:
801054ed:	55                   	push   %ebp
801054ee:	89 e5                	mov    %esp,%ebp
801054f0:	57                   	push   %edi
801054f1:	53                   	push   %ebx
801054f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054f5:	8b 55 10             	mov    0x10(%ebp),%edx
801054f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801054fb:	89 cb                	mov    %ecx,%ebx
801054fd:	89 df                	mov    %ebx,%edi
801054ff:	89 d1                	mov    %edx,%ecx
80105501:	fc                   	cld    
80105502:	f3 aa                	rep stos %al,%es:(%edi)
80105504:	89 ca                	mov    %ecx,%edx
80105506:	89 fb                	mov    %edi,%ebx
80105508:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010550b:	89 55 10             	mov    %edx,0x10(%ebp)
8010550e:	90                   	nop
8010550f:	5b                   	pop    %ebx
80105510:	5f                   	pop    %edi
80105511:	5d                   	pop    %ebp
80105512:	c3                   	ret    

80105513 <stosl>:
80105513:	55                   	push   %ebp
80105514:	89 e5                	mov    %esp,%ebp
80105516:	57                   	push   %edi
80105517:	53                   	push   %ebx
80105518:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010551b:	8b 55 10             	mov    0x10(%ebp),%edx
8010551e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105521:	89 cb                	mov    %ecx,%ebx
80105523:	89 df                	mov    %ebx,%edi
80105525:	89 d1                	mov    %edx,%ecx
80105527:	fc                   	cld    
80105528:	f3 ab                	rep stos %eax,%es:(%edi)
8010552a:	89 ca                	mov    %ecx,%edx
8010552c:	89 fb                	mov    %edi,%ebx
8010552e:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105531:	89 55 10             	mov    %edx,0x10(%ebp)
80105534:	90                   	nop
80105535:	5b                   	pop    %ebx
80105536:	5f                   	pop    %edi
80105537:	5d                   	pop    %ebp
80105538:	c3                   	ret    

80105539 <memset>:
80105539:	55                   	push   %ebp
8010553a:	89 e5                	mov    %esp,%ebp
8010553c:	8b 45 08             	mov    0x8(%ebp),%eax
8010553f:	83 e0 03             	and    $0x3,%eax
80105542:	85 c0                	test   %eax,%eax
80105544:	75 43                	jne    80105589 <memset+0x50>
80105546:	8b 45 10             	mov    0x10(%ebp),%eax
80105549:	83 e0 03             	and    $0x3,%eax
8010554c:	85 c0                	test   %eax,%eax
8010554e:	75 39                	jne    80105589 <memset+0x50>
80105550:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
80105557:	8b 45 10             	mov    0x10(%ebp),%eax
8010555a:	c1 e8 02             	shr    $0x2,%eax
8010555d:	89 c1                	mov    %eax,%ecx
8010555f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105562:	c1 e0 18             	shl    $0x18,%eax
80105565:	89 c2                	mov    %eax,%edx
80105567:	8b 45 0c             	mov    0xc(%ebp),%eax
8010556a:	c1 e0 10             	shl    $0x10,%eax
8010556d:	09 c2                	or     %eax,%edx
8010556f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105572:	c1 e0 08             	shl    $0x8,%eax
80105575:	09 d0                	or     %edx,%eax
80105577:	0b 45 0c             	or     0xc(%ebp),%eax
8010557a:	51                   	push   %ecx
8010557b:	50                   	push   %eax
8010557c:	ff 75 08             	pushl  0x8(%ebp)
8010557f:	e8 8f ff ff ff       	call   80105513 <stosl>
80105584:	83 c4 0c             	add    $0xc,%esp
80105587:	eb 12                	jmp    8010559b <memset+0x62>
80105589:	8b 45 10             	mov    0x10(%ebp),%eax
8010558c:	50                   	push   %eax
8010558d:	ff 75 0c             	pushl  0xc(%ebp)
80105590:	ff 75 08             	pushl  0x8(%ebp)
80105593:	e8 55 ff ff ff       	call   801054ed <stosb>
80105598:	83 c4 0c             	add    $0xc,%esp
8010559b:	8b 45 08             	mov    0x8(%ebp),%eax
8010559e:	c9                   	leave  
8010559f:	c3                   	ret    

801055a0 <memcmp>:
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	83 ec 10             	sub    $0x10,%esp
801055a6:	8b 45 08             	mov    0x8(%ebp),%eax
801055a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
801055ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801055af:	89 45 f8             	mov    %eax,-0x8(%ebp)
801055b2:	eb 30                	jmp    801055e4 <memcmp+0x44>
801055b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055b7:	0f b6 10             	movzbl (%eax),%edx
801055ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055bd:	0f b6 00             	movzbl (%eax),%eax
801055c0:	38 c2                	cmp    %al,%dl
801055c2:	74 18                	je     801055dc <memcmp+0x3c>
801055c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055c7:	0f b6 00             	movzbl (%eax),%eax
801055ca:	0f b6 d0             	movzbl %al,%edx
801055cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055d0:	0f b6 00             	movzbl (%eax),%eax
801055d3:	0f b6 c0             	movzbl %al,%eax
801055d6:	29 c2                	sub    %eax,%edx
801055d8:	89 d0                	mov    %edx,%eax
801055da:	eb 1a                	jmp    801055f6 <memcmp+0x56>
801055dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801055e0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801055e4:	8b 45 10             	mov    0x10(%ebp),%eax
801055e7:	8d 50 ff             	lea    -0x1(%eax),%edx
801055ea:	89 55 10             	mov    %edx,0x10(%ebp)
801055ed:	85 c0                	test   %eax,%eax
801055ef:	75 c3                	jne    801055b4 <memcmp+0x14>
801055f1:	b8 00 00 00 00       	mov    $0x0,%eax
801055f6:	c9                   	leave  
801055f7:	c3                   	ret    

801055f8 <memmove>:
801055f8:	55                   	push   %ebp
801055f9:	89 e5                	mov    %esp,%ebp
801055fb:	83 ec 10             	sub    $0x10,%esp
801055fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105601:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105604:	8b 45 08             	mov    0x8(%ebp),%eax
80105607:	89 45 f8             	mov    %eax,-0x8(%ebp)
8010560a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010560d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105610:	73 54                	jae    80105666 <memmove+0x6e>
80105612:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105615:	8b 45 10             	mov    0x10(%ebp),%eax
80105618:	01 d0                	add    %edx,%eax
8010561a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010561d:	76 47                	jbe    80105666 <memmove+0x6e>
8010561f:	8b 45 10             	mov    0x10(%ebp),%eax
80105622:	01 45 fc             	add    %eax,-0x4(%ebp)
80105625:	8b 45 10             	mov    0x10(%ebp),%eax
80105628:	01 45 f8             	add    %eax,-0x8(%ebp)
8010562b:	eb 13                	jmp    80105640 <memmove+0x48>
8010562d:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105631:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105635:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105638:	0f b6 10             	movzbl (%eax),%edx
8010563b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010563e:	88 10                	mov    %dl,(%eax)
80105640:	8b 45 10             	mov    0x10(%ebp),%eax
80105643:	8d 50 ff             	lea    -0x1(%eax),%edx
80105646:	89 55 10             	mov    %edx,0x10(%ebp)
80105649:	85 c0                	test   %eax,%eax
8010564b:	75 e0                	jne    8010562d <memmove+0x35>
8010564d:	eb 24                	jmp    80105673 <memmove+0x7b>
8010564f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105652:	8d 50 01             	lea    0x1(%eax),%edx
80105655:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105658:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010565b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010565e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105661:	0f b6 12             	movzbl (%edx),%edx
80105664:	88 10                	mov    %dl,(%eax)
80105666:	8b 45 10             	mov    0x10(%ebp),%eax
80105669:	8d 50 ff             	lea    -0x1(%eax),%edx
8010566c:	89 55 10             	mov    %edx,0x10(%ebp)
8010566f:	85 c0                	test   %eax,%eax
80105671:	75 dc                	jne    8010564f <memmove+0x57>
80105673:	8b 45 08             	mov    0x8(%ebp),%eax
80105676:	c9                   	leave  
80105677:	c3                   	ret    

80105678 <memcpy>:
80105678:	55                   	push   %ebp
80105679:	89 e5                	mov    %esp,%ebp
8010567b:	ff 75 10             	pushl  0x10(%ebp)
8010567e:	ff 75 0c             	pushl  0xc(%ebp)
80105681:	ff 75 08             	pushl  0x8(%ebp)
80105684:	e8 6f ff ff ff       	call   801055f8 <memmove>
80105689:	83 c4 0c             	add    $0xc,%esp
8010568c:	c9                   	leave  
8010568d:	c3                   	ret    

8010568e <strncmp>:
8010568e:	55                   	push   %ebp
8010568f:	89 e5                	mov    %esp,%ebp
80105691:	eb 0c                	jmp    8010569f <strncmp+0x11>
80105693:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105697:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010569b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010569f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056a3:	74 1a                	je     801056bf <strncmp+0x31>
801056a5:	8b 45 08             	mov    0x8(%ebp),%eax
801056a8:	0f b6 00             	movzbl (%eax),%eax
801056ab:	84 c0                	test   %al,%al
801056ad:	74 10                	je     801056bf <strncmp+0x31>
801056af:	8b 45 08             	mov    0x8(%ebp),%eax
801056b2:	0f b6 10             	movzbl (%eax),%edx
801056b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801056b8:	0f b6 00             	movzbl (%eax),%eax
801056bb:	38 c2                	cmp    %al,%dl
801056bd:	74 d4                	je     80105693 <strncmp+0x5>
801056bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056c3:	75 07                	jne    801056cc <strncmp+0x3e>
801056c5:	b8 00 00 00 00       	mov    $0x0,%eax
801056ca:	eb 16                	jmp    801056e2 <strncmp+0x54>
801056cc:	8b 45 08             	mov    0x8(%ebp),%eax
801056cf:	0f b6 00             	movzbl (%eax),%eax
801056d2:	0f b6 d0             	movzbl %al,%edx
801056d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801056d8:	0f b6 00             	movzbl (%eax),%eax
801056db:	0f b6 c0             	movzbl %al,%eax
801056de:	29 c2                	sub    %eax,%edx
801056e0:	89 d0                	mov    %edx,%eax
801056e2:	5d                   	pop    %ebp
801056e3:	c3                   	ret    

801056e4 <strncpy>:
801056e4:	55                   	push   %ebp
801056e5:	89 e5                	mov    %esp,%ebp
801056e7:	83 ec 10             	sub    $0x10,%esp
801056ea:	8b 45 08             	mov    0x8(%ebp),%eax
801056ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
801056f0:	90                   	nop
801056f1:	8b 45 10             	mov    0x10(%ebp),%eax
801056f4:	8d 50 ff             	lea    -0x1(%eax),%edx
801056f7:	89 55 10             	mov    %edx,0x10(%ebp)
801056fa:	85 c0                	test   %eax,%eax
801056fc:	7e 2c                	jle    8010572a <strncpy+0x46>
801056fe:	8b 45 08             	mov    0x8(%ebp),%eax
80105701:	8d 50 01             	lea    0x1(%eax),%edx
80105704:	89 55 08             	mov    %edx,0x8(%ebp)
80105707:	8b 55 0c             	mov    0xc(%ebp),%edx
8010570a:	8d 4a 01             	lea    0x1(%edx),%ecx
8010570d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105710:	0f b6 12             	movzbl (%edx),%edx
80105713:	88 10                	mov    %dl,(%eax)
80105715:	0f b6 00             	movzbl (%eax),%eax
80105718:	84 c0                	test   %al,%al
8010571a:	75 d5                	jne    801056f1 <strncpy+0xd>
8010571c:	eb 0c                	jmp    8010572a <strncpy+0x46>
8010571e:	8b 45 08             	mov    0x8(%ebp),%eax
80105721:	8d 50 01             	lea    0x1(%eax),%edx
80105724:	89 55 08             	mov    %edx,0x8(%ebp)
80105727:	c6 00 00             	movb   $0x0,(%eax)
8010572a:	8b 45 10             	mov    0x10(%ebp),%eax
8010572d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105730:	89 55 10             	mov    %edx,0x10(%ebp)
80105733:	85 c0                	test   %eax,%eax
80105735:	7f e7                	jg     8010571e <strncpy+0x3a>
80105737:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010573a:	c9                   	leave  
8010573b:	c3                   	ret    

8010573c <safestrcpy>:
8010573c:	55                   	push   %ebp
8010573d:	89 e5                	mov    %esp,%ebp
8010573f:	83 ec 10             	sub    $0x10,%esp
80105742:	8b 45 08             	mov    0x8(%ebp),%eax
80105745:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105748:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010574c:	7f 05                	jg     80105753 <safestrcpy+0x17>
8010574e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105751:	eb 31                	jmp    80105784 <safestrcpy+0x48>
80105753:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105757:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010575b:	7e 1e                	jle    8010577b <safestrcpy+0x3f>
8010575d:	8b 45 08             	mov    0x8(%ebp),%eax
80105760:	8d 50 01             	lea    0x1(%eax),%edx
80105763:	89 55 08             	mov    %edx,0x8(%ebp)
80105766:	8b 55 0c             	mov    0xc(%ebp),%edx
80105769:	8d 4a 01             	lea    0x1(%edx),%ecx
8010576c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010576f:	0f b6 12             	movzbl (%edx),%edx
80105772:	88 10                	mov    %dl,(%eax)
80105774:	0f b6 00             	movzbl (%eax),%eax
80105777:	84 c0                	test   %al,%al
80105779:	75 d8                	jne    80105753 <safestrcpy+0x17>
8010577b:	8b 45 08             	mov    0x8(%ebp),%eax
8010577e:	c6 00 00             	movb   $0x0,(%eax)
80105781:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105784:	c9                   	leave  
80105785:	c3                   	ret    

80105786 <strlen>:
80105786:	55                   	push   %ebp
80105787:	89 e5                	mov    %esp,%ebp
80105789:	83 ec 10             	sub    $0x10,%esp
8010578c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105793:	eb 04                	jmp    80105799 <strlen+0x13>
80105795:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105799:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010579c:	8b 45 08             	mov    0x8(%ebp),%eax
8010579f:	01 d0                	add    %edx,%eax
801057a1:	0f b6 00             	movzbl (%eax),%eax
801057a4:	84 c0                	test   %al,%al
801057a6:	75 ed                	jne    80105795 <strlen+0xf>
801057a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057ab:	c9                   	leave  
801057ac:	c3                   	ret    

801057ad <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801057ad:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801057b1:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801057b5:	55                   	push   %ebp
  pushl %ebx
801057b6:	53                   	push   %ebx
  pushl %esi
801057b7:	56                   	push   %esi
  pushl %edi
801057b8:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801057b9:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801057bb:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801057bd:	5f                   	pop    %edi
  popl %esi
801057be:	5e                   	pop    %esi
  popl %ebx
801057bf:	5b                   	pop    %ebx
  popl %ebp
801057c0:	5d                   	pop    %ebp
  ret
801057c1:	c3                   	ret    

801057c2 <fetchint>:
801057c2:	55                   	push   %ebp
801057c3:	89 e5                	mov    %esp,%ebp
801057c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057cb:	8b 00                	mov    (%eax),%eax
801057cd:	3b 45 08             	cmp    0x8(%ebp),%eax
801057d0:	76 12                	jbe    801057e4 <fetchint+0x22>
801057d2:	8b 45 08             	mov    0x8(%ebp),%eax
801057d5:	8d 50 04             	lea    0x4(%eax),%edx
801057d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057de:	8b 00                	mov    (%eax),%eax
801057e0:	39 c2                	cmp    %eax,%edx
801057e2:	76 07                	jbe    801057eb <fetchint+0x29>
801057e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e9:	eb 0f                	jmp    801057fa <fetchint+0x38>
801057eb:	8b 45 08             	mov    0x8(%ebp),%eax
801057ee:	8b 10                	mov    (%eax),%edx
801057f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801057f3:	89 10                	mov    %edx,(%eax)
801057f5:	b8 00 00 00 00       	mov    $0x0,%eax
801057fa:	5d                   	pop    %ebp
801057fb:	c3                   	ret    

801057fc <fetchstr>:
801057fc:	55                   	push   %ebp
801057fd:	89 e5                	mov    %esp,%ebp
801057ff:	83 ec 10             	sub    $0x10,%esp
80105802:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105808:	8b 00                	mov    (%eax),%eax
8010580a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010580d:	77 07                	ja     80105816 <fetchstr+0x1a>
8010580f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105814:	eb 46                	jmp    8010585c <fetchstr+0x60>
80105816:	8b 55 08             	mov    0x8(%ebp),%edx
80105819:	8b 45 0c             	mov    0xc(%ebp),%eax
8010581c:	89 10                	mov    %edx,(%eax)
8010581e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105824:	8b 00                	mov    (%eax),%eax
80105826:	89 45 f8             	mov    %eax,-0x8(%ebp)
80105829:	8b 45 0c             	mov    0xc(%ebp),%eax
8010582c:	8b 00                	mov    (%eax),%eax
8010582e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105831:	eb 1c                	jmp    8010584f <fetchstr+0x53>
80105833:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105836:	0f b6 00             	movzbl (%eax),%eax
80105839:	84 c0                	test   %al,%al
8010583b:	75 0e                	jne    8010584b <fetchstr+0x4f>
8010583d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105840:	8b 45 0c             	mov    0xc(%ebp),%eax
80105843:	8b 00                	mov    (%eax),%eax
80105845:	29 c2                	sub    %eax,%edx
80105847:	89 d0                	mov    %edx,%eax
80105849:	eb 11                	jmp    8010585c <fetchstr+0x60>
8010584b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010584f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105852:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105855:	72 dc                	jb     80105833 <fetchstr+0x37>
80105857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585c:	c9                   	leave  
8010585d:	c3                   	ret    

8010585e <argint>:
8010585e:	55                   	push   %ebp
8010585f:	89 e5                	mov    %esp,%ebp
80105861:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105867:	8b 40 18             	mov    0x18(%eax),%eax
8010586a:	8b 40 44             	mov    0x44(%eax),%eax
8010586d:	8b 55 08             	mov    0x8(%ebp),%edx
80105870:	c1 e2 02             	shl    $0x2,%edx
80105873:	01 d0                	add    %edx,%eax
80105875:	83 c0 04             	add    $0x4,%eax
80105878:	ff 75 0c             	pushl  0xc(%ebp)
8010587b:	50                   	push   %eax
8010587c:	e8 41 ff ff ff       	call   801057c2 <fetchint>
80105881:	83 c4 08             	add    $0x8,%esp
80105884:	c9                   	leave  
80105885:	c3                   	ret    

80105886 <argptr>:
80105886:	55                   	push   %ebp
80105887:	89 e5                	mov    %esp,%ebp
80105889:	83 ec 10             	sub    $0x10,%esp
8010588c:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010588f:	50                   	push   %eax
80105890:	ff 75 08             	pushl  0x8(%ebp)
80105893:	e8 c6 ff ff ff       	call   8010585e <argint>
80105898:	83 c4 08             	add    $0x8,%esp
8010589b:	85 c0                	test   %eax,%eax
8010589d:	79 07                	jns    801058a6 <argptr+0x20>
8010589f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a4:	eb 3b                	jmp    801058e1 <argptr+0x5b>
801058a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058ac:	8b 00                	mov    (%eax),%eax
801058ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058b1:	39 d0                	cmp    %edx,%eax
801058b3:	76 16                	jbe    801058cb <argptr+0x45>
801058b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058b8:	89 c2                	mov    %eax,%edx
801058ba:	8b 45 10             	mov    0x10(%ebp),%eax
801058bd:	01 c2                	add    %eax,%edx
801058bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058c5:	8b 00                	mov    (%eax),%eax
801058c7:	39 c2                	cmp    %eax,%edx
801058c9:	76 07                	jbe    801058d2 <argptr+0x4c>
801058cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d0:	eb 0f                	jmp    801058e1 <argptr+0x5b>
801058d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058d5:	89 c2                	mov    %eax,%edx
801058d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801058da:	89 10                	mov    %edx,(%eax)
801058dc:	b8 00 00 00 00       	mov    $0x0,%eax
801058e1:	c9                   	leave  
801058e2:	c3                   	ret    

801058e3 <argstr>:
801058e3:	55                   	push   %ebp
801058e4:	89 e5                	mov    %esp,%ebp
801058e6:	83 ec 10             	sub    $0x10,%esp
801058e9:	8d 45 fc             	lea    -0x4(%ebp),%eax
801058ec:	50                   	push   %eax
801058ed:	ff 75 08             	pushl  0x8(%ebp)
801058f0:	e8 69 ff ff ff       	call   8010585e <argint>
801058f5:	83 c4 08             	add    $0x8,%esp
801058f8:	85 c0                	test   %eax,%eax
801058fa:	79 07                	jns    80105903 <argstr+0x20>
801058fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105901:	eb 0f                	jmp    80105912 <argstr+0x2f>
80105903:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105906:	ff 75 0c             	pushl  0xc(%ebp)
80105909:	50                   	push   %eax
8010590a:	e8 ed fe ff ff       	call   801057fc <fetchstr>
8010590f:	83 c4 08             	add    $0x8,%esp
80105912:	c9                   	leave  
80105913:	c3                   	ret    

80105914 <syscall>:
80105914:	55                   	push   %ebp
80105915:	89 e5                	mov    %esp,%ebp
80105917:	53                   	push   %ebx
80105918:	83 ec 14             	sub    $0x14,%esp
8010591b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105921:	8b 40 18             	mov    0x18(%eax),%eax
80105924:	8b 40 1c             	mov    0x1c(%eax),%eax
80105927:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010592a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010592e:	7e 30                	jle    80105960 <syscall+0x4c>
80105930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105933:	83 f8 1a             	cmp    $0x1a,%eax
80105936:	77 28                	ja     80105960 <syscall+0x4c>
80105938:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593b:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105942:	85 c0                	test   %eax,%eax
80105944:	74 1a                	je     80105960 <syscall+0x4c>
80105946:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010594c:	8b 58 18             	mov    0x18(%eax),%ebx
8010594f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105952:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105959:	ff d0                	call   *%eax
8010595b:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010595e:	eb 34                	jmp    80105994 <syscall+0x80>
80105960:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105966:	8d 50 6c             	lea    0x6c(%eax),%edx
80105969:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010596f:	8b 40 10             	mov    0x10(%eax),%eax
80105972:	ff 75 f4             	pushl  -0xc(%ebp)
80105975:	52                   	push   %edx
80105976:	50                   	push   %eax
80105977:	68 e5 91 10 80       	push   $0x801091e5
8010597c:	e8 45 aa ff ff       	call   801003c6 <cprintf>
80105981:	83 c4 10             	add    $0x10,%esp
80105984:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010598a:	8b 40 18             	mov    0x18(%eax),%eax
8010598d:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80105994:	90                   	nop
80105995:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105998:	c9                   	leave  
80105999:	c3                   	ret    

8010599a <argfd>:
8010599a:	55                   	push   %ebp
8010599b:	89 e5                	mov    %esp,%ebp
8010599d:	83 ec 18             	sub    $0x18,%esp
801059a0:	83 ec 08             	sub    $0x8,%esp
801059a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059a6:	50                   	push   %eax
801059a7:	ff 75 08             	pushl  0x8(%ebp)
801059aa:	e8 af fe ff ff       	call   8010585e <argint>
801059af:	83 c4 10             	add    $0x10,%esp
801059b2:	85 c0                	test   %eax,%eax
801059b4:	79 07                	jns    801059bd <argfd+0x23>
801059b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059bb:	eb 50                	jmp    80105a0d <argfd+0x73>
801059bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c0:	85 c0                	test   %eax,%eax
801059c2:	78 21                	js     801059e5 <argfd+0x4b>
801059c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c7:	83 f8 0f             	cmp    $0xf,%eax
801059ca:	7f 19                	jg     801059e5 <argfd+0x4b>
801059cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801059d5:	83 c2 08             	add    $0x8,%edx
801059d8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801059dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059e3:	75 07                	jne    801059ec <argfd+0x52>
801059e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ea:	eb 21                	jmp    80105a0d <argfd+0x73>
801059ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801059f0:	74 08                	je     801059fa <argfd+0x60>
801059f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801059f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801059f8:	89 10                	mov    %edx,(%eax)
801059fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059fe:	74 08                	je     80105a08 <argfd+0x6e>
80105a00:	8b 45 10             	mov    0x10(%ebp),%eax
80105a03:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a06:	89 10                	mov    %edx,(%eax)
80105a08:	b8 00 00 00 00       	mov    $0x0,%eax
80105a0d:	c9                   	leave  
80105a0e:	c3                   	ret    

80105a0f <fdalloc>:
80105a0f:	55                   	push   %ebp
80105a10:	89 e5                	mov    %esp,%ebp
80105a12:	83 ec 10             	sub    $0x10,%esp
80105a15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a1c:	eb 30                	jmp    80105a4e <fdalloc+0x3f>
80105a1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a24:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a27:	83 c2 08             	add    $0x8,%edx
80105a2a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a2e:	85 c0                	test   %eax,%eax
80105a30:	75 18                	jne    80105a4a <fdalloc+0x3b>
80105a32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a38:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a3b:	8d 4a 08             	lea    0x8(%edx),%ecx
80105a3e:	8b 55 08             	mov    0x8(%ebp),%edx
80105a41:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
80105a45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a48:	eb 0f                	jmp    80105a59 <fdalloc+0x4a>
80105a4a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a4e:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105a52:	7e ca                	jle    80105a1e <fdalloc+0xf>
80105a54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a59:	c9                   	leave  
80105a5a:	c3                   	ret    

80105a5b <sys_dup>:
80105a5b:	55                   	push   %ebp
80105a5c:	89 e5                	mov    %esp,%ebp
80105a5e:	83 ec 18             	sub    $0x18,%esp
80105a61:	83 ec 04             	sub    $0x4,%esp
80105a64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a67:	50                   	push   %eax
80105a68:	6a 00                	push   $0x0
80105a6a:	6a 00                	push   $0x0
80105a6c:	e8 29 ff ff ff       	call   8010599a <argfd>
80105a71:	83 c4 10             	add    $0x10,%esp
80105a74:	85 c0                	test   %eax,%eax
80105a76:	79 07                	jns    80105a7f <sys_dup+0x24>
80105a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7d:	eb 31                	jmp    80105ab0 <sys_dup+0x55>
80105a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a82:	83 ec 0c             	sub    $0xc,%esp
80105a85:	50                   	push   %eax
80105a86:	e8 84 ff ff ff       	call   80105a0f <fdalloc>
80105a8b:	83 c4 10             	add    $0x10,%esp
80105a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a95:	79 07                	jns    80105a9e <sys_dup+0x43>
80105a97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9c:	eb 12                	jmp    80105ab0 <sys_dup+0x55>
80105a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa1:	83 ec 0c             	sub    $0xc,%esp
80105aa4:	50                   	push   %eax
80105aa5:	e8 3b b5 ff ff       	call   80100fe5 <filedup>
80105aaa:	83 c4 10             	add    $0x10,%esp
80105aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab0:	c9                   	leave  
80105ab1:	c3                   	ret    

80105ab2 <sys_read>:
80105ab2:	55                   	push   %ebp
80105ab3:	89 e5                	mov    %esp,%ebp
80105ab5:	83 ec 18             	sub    $0x18,%esp
80105ab8:	83 ec 04             	sub    $0x4,%esp
80105abb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105abe:	50                   	push   %eax
80105abf:	6a 00                	push   $0x0
80105ac1:	6a 00                	push   $0x0
80105ac3:	e8 d2 fe ff ff       	call   8010599a <argfd>
80105ac8:	83 c4 10             	add    $0x10,%esp
80105acb:	85 c0                	test   %eax,%eax
80105acd:	78 2e                	js     80105afd <sys_read+0x4b>
80105acf:	83 ec 08             	sub    $0x8,%esp
80105ad2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad5:	50                   	push   %eax
80105ad6:	6a 02                	push   $0x2
80105ad8:	e8 81 fd ff ff       	call   8010585e <argint>
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	85 c0                	test   %eax,%eax
80105ae2:	78 19                	js     80105afd <sys_read+0x4b>
80105ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ae7:	83 ec 04             	sub    $0x4,%esp
80105aea:	50                   	push   %eax
80105aeb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105aee:	50                   	push   %eax
80105aef:	6a 01                	push   $0x1
80105af1:	e8 90 fd ff ff       	call   80105886 <argptr>
80105af6:	83 c4 10             	add    $0x10,%esp
80105af9:	85 c0                	test   %eax,%eax
80105afb:	79 07                	jns    80105b04 <sys_read+0x52>
80105afd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b02:	eb 17                	jmp    80105b1b <sys_read+0x69>
80105b04:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b07:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b0d:	83 ec 04             	sub    $0x4,%esp
80105b10:	51                   	push   %ecx
80105b11:	52                   	push   %edx
80105b12:	50                   	push   %eax
80105b13:	e8 5d b6 ff ff       	call   80101175 <fileread>
80105b18:	83 c4 10             	add    $0x10,%esp
80105b1b:	c9                   	leave  
80105b1c:	c3                   	ret    

80105b1d <sys_write>:
80105b1d:	55                   	push   %ebp
80105b1e:	89 e5                	mov    %esp,%ebp
80105b20:	83 ec 18             	sub    $0x18,%esp
80105b23:	83 ec 04             	sub    $0x4,%esp
80105b26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b29:	50                   	push   %eax
80105b2a:	6a 00                	push   $0x0
80105b2c:	6a 00                	push   $0x0
80105b2e:	e8 67 fe ff ff       	call   8010599a <argfd>
80105b33:	83 c4 10             	add    $0x10,%esp
80105b36:	85 c0                	test   %eax,%eax
80105b38:	78 2e                	js     80105b68 <sys_write+0x4b>
80105b3a:	83 ec 08             	sub    $0x8,%esp
80105b3d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b40:	50                   	push   %eax
80105b41:	6a 02                	push   $0x2
80105b43:	e8 16 fd ff ff       	call   8010585e <argint>
80105b48:	83 c4 10             	add    $0x10,%esp
80105b4b:	85 c0                	test   %eax,%eax
80105b4d:	78 19                	js     80105b68 <sys_write+0x4b>
80105b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b52:	83 ec 04             	sub    $0x4,%esp
80105b55:	50                   	push   %eax
80105b56:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b59:	50                   	push   %eax
80105b5a:	6a 01                	push   $0x1
80105b5c:	e8 25 fd ff ff       	call   80105886 <argptr>
80105b61:	83 c4 10             	add    $0x10,%esp
80105b64:	85 c0                	test   %eax,%eax
80105b66:	79 07                	jns    80105b6f <sys_write+0x52>
80105b68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6d:	eb 17                	jmp    80105b86 <sys_write+0x69>
80105b6f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b72:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b78:	83 ec 04             	sub    $0x4,%esp
80105b7b:	51                   	push   %ecx
80105b7c:	52                   	push   %edx
80105b7d:	50                   	push   %eax
80105b7e:	e8 aa b6 ff ff       	call   8010122d <filewrite>
80105b83:	83 c4 10             	add    $0x10,%esp
80105b86:	c9                   	leave  
80105b87:	c3                   	ret    

80105b88 <sys_close>:
80105b88:	55                   	push   %ebp
80105b89:	89 e5                	mov    %esp,%ebp
80105b8b:	83 ec 18             	sub    $0x18,%esp
80105b8e:	83 ec 04             	sub    $0x4,%esp
80105b91:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b94:	50                   	push   %eax
80105b95:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b98:	50                   	push   %eax
80105b99:	6a 00                	push   $0x0
80105b9b:	e8 fa fd ff ff       	call   8010599a <argfd>
80105ba0:	83 c4 10             	add    $0x10,%esp
80105ba3:	85 c0                	test   %eax,%eax
80105ba5:	79 07                	jns    80105bae <sys_close+0x26>
80105ba7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bac:	eb 28                	jmp    80105bd6 <sys_close+0x4e>
80105bae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bb7:	83 c2 08             	add    $0x8,%edx
80105bba:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105bc1:	00 
80105bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc5:	83 ec 0c             	sub    $0xc,%esp
80105bc8:	50                   	push   %eax
80105bc9:	e8 68 b4 ff ff       	call   80101036 <fileclose>
80105bce:	83 c4 10             	add    $0x10,%esp
80105bd1:	b8 00 00 00 00       	mov    $0x0,%eax
80105bd6:	c9                   	leave  
80105bd7:	c3                   	ret    

80105bd8 <sys_fstat>:
80105bd8:	55                   	push   %ebp
80105bd9:	89 e5                	mov    %esp,%ebp
80105bdb:	83 ec 18             	sub    $0x18,%esp
80105bde:	83 ec 04             	sub    $0x4,%esp
80105be1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105be4:	50                   	push   %eax
80105be5:	6a 00                	push   $0x0
80105be7:	6a 00                	push   $0x0
80105be9:	e8 ac fd ff ff       	call   8010599a <argfd>
80105bee:	83 c4 10             	add    $0x10,%esp
80105bf1:	85 c0                	test   %eax,%eax
80105bf3:	78 17                	js     80105c0c <sys_fstat+0x34>
80105bf5:	83 ec 04             	sub    $0x4,%esp
80105bf8:	6a 14                	push   $0x14
80105bfa:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bfd:	50                   	push   %eax
80105bfe:	6a 01                	push   $0x1
80105c00:	e8 81 fc ff ff       	call   80105886 <argptr>
80105c05:	83 c4 10             	add    $0x10,%esp
80105c08:	85 c0                	test   %eax,%eax
80105c0a:	79 07                	jns    80105c13 <sys_fstat+0x3b>
80105c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c11:	eb 13                	jmp    80105c26 <sys_fstat+0x4e>
80105c13:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c19:	83 ec 08             	sub    $0x8,%esp
80105c1c:	52                   	push   %edx
80105c1d:	50                   	push   %eax
80105c1e:	e8 fb b4 ff ff       	call   8010111e <filestat>
80105c23:	83 c4 10             	add    $0x10,%esp
80105c26:	c9                   	leave  
80105c27:	c3                   	ret    

80105c28 <sys_link>:
80105c28:	55                   	push   %ebp
80105c29:	89 e5                	mov    %esp,%ebp
80105c2b:	83 ec 28             	sub    $0x28,%esp
80105c2e:	83 ec 08             	sub    $0x8,%esp
80105c31:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c34:	50                   	push   %eax
80105c35:	6a 00                	push   $0x0
80105c37:	e8 a7 fc ff ff       	call   801058e3 <argstr>
80105c3c:	83 c4 10             	add    $0x10,%esp
80105c3f:	85 c0                	test   %eax,%eax
80105c41:	78 15                	js     80105c58 <sys_link+0x30>
80105c43:	83 ec 08             	sub    $0x8,%esp
80105c46:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105c49:	50                   	push   %eax
80105c4a:	6a 01                	push   $0x1
80105c4c:	e8 92 fc ff ff       	call   801058e3 <argstr>
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	85 c0                	test   %eax,%eax
80105c56:	79 0a                	jns    80105c62 <sys_link+0x3a>
80105c58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c5d:	e9 68 01 00 00       	jmp    80105dca <sys_link+0x1a2>
80105c62:	e8 4d d8 ff ff       	call   801034b4 <begin_op>
80105c67:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105c6a:	83 ec 0c             	sub    $0xc,%esp
80105c6d:	50                   	push   %eax
80105c6e:	e8 50 c8 ff ff       	call   801024c3 <namei>
80105c73:	83 c4 10             	add    $0x10,%esp
80105c76:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c7d:	75 0f                	jne    80105c8e <sys_link+0x66>
80105c7f:	e8 bc d8 ff ff       	call   80103540 <end_op>
80105c84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c89:	e9 3c 01 00 00       	jmp    80105dca <sys_link+0x1a2>
80105c8e:	83 ec 0c             	sub    $0xc,%esp
80105c91:	ff 75 f4             	pushl  -0xc(%ebp)
80105c94:	e8 72 bc ff ff       	call   8010190b <ilock>
80105c99:	83 c4 10             	add    $0x10,%esp
80105c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ca3:	66 83 f8 01          	cmp    $0x1,%ax
80105ca7:	75 1d                	jne    80105cc6 <sys_link+0x9e>
80105ca9:	83 ec 0c             	sub    $0xc,%esp
80105cac:	ff 75 f4             	pushl  -0xc(%ebp)
80105caf:	e8 11 bf ff ff       	call   80101bc5 <iunlockput>
80105cb4:	83 c4 10             	add    $0x10,%esp
80105cb7:	e8 84 d8 ff ff       	call   80103540 <end_op>
80105cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc1:	e9 04 01 00 00       	jmp    80105dca <sys_link+0x1a2>
80105cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ccd:	83 c0 01             	add    $0x1,%eax
80105cd0:	89 c2                	mov    %eax,%edx
80105cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cd5:	66 89 50 16          	mov    %dx,0x16(%eax)
80105cd9:	83 ec 0c             	sub    $0xc,%esp
80105cdc:	ff 75 f4             	pushl  -0xc(%ebp)
80105cdf:	e8 53 ba ff ff       	call   80101737 <iupdate>
80105ce4:	83 c4 10             	add    $0x10,%esp
80105ce7:	83 ec 0c             	sub    $0xc,%esp
80105cea:	ff 75 f4             	pushl  -0xc(%ebp)
80105ced:	e8 71 bd ff ff       	call   80101a63 <iunlock>
80105cf2:	83 c4 10             	add    $0x10,%esp
80105cf5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cf8:	83 ec 08             	sub    $0x8,%esp
80105cfb:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105cfe:	52                   	push   %edx
80105cff:	50                   	push   %eax
80105d00:	e8 da c7 ff ff       	call   801024df <nameiparent>
80105d05:	83 c4 10             	add    $0x10,%esp
80105d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d0f:	74 71                	je     80105d82 <sys_link+0x15a>
80105d11:	83 ec 0c             	sub    $0xc,%esp
80105d14:	ff 75 f0             	pushl  -0x10(%ebp)
80105d17:	e8 ef bb ff ff       	call   8010190b <ilock>
80105d1c:	83 c4 10             	add    $0x10,%esp
80105d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d22:	8b 10                	mov    (%eax),%edx
80105d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d27:	8b 00                	mov    (%eax),%eax
80105d29:	39 c2                	cmp    %eax,%edx
80105d2b:	75 1d                	jne    80105d4a <sys_link+0x122>
80105d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d30:	8b 40 04             	mov    0x4(%eax),%eax
80105d33:	83 ec 04             	sub    $0x4,%esp
80105d36:	50                   	push   %eax
80105d37:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105d3a:	50                   	push   %eax
80105d3b:	ff 75 f0             	pushl  -0x10(%ebp)
80105d3e:	e8 e4 c4 ff ff       	call   80102227 <dirlink>
80105d43:	83 c4 10             	add    $0x10,%esp
80105d46:	85 c0                	test   %eax,%eax
80105d48:	79 10                	jns    80105d5a <sys_link+0x132>
80105d4a:	83 ec 0c             	sub    $0xc,%esp
80105d4d:	ff 75 f0             	pushl  -0x10(%ebp)
80105d50:	e8 70 be ff ff       	call   80101bc5 <iunlockput>
80105d55:	83 c4 10             	add    $0x10,%esp
80105d58:	eb 29                	jmp    80105d83 <sys_link+0x15b>
80105d5a:	83 ec 0c             	sub    $0xc,%esp
80105d5d:	ff 75 f0             	pushl  -0x10(%ebp)
80105d60:	e8 60 be ff ff       	call   80101bc5 <iunlockput>
80105d65:	83 c4 10             	add    $0x10,%esp
80105d68:	83 ec 0c             	sub    $0xc,%esp
80105d6b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d6e:	e8 62 bd ff ff       	call   80101ad5 <iput>
80105d73:	83 c4 10             	add    $0x10,%esp
80105d76:	e8 c5 d7 ff ff       	call   80103540 <end_op>
80105d7b:	b8 00 00 00 00       	mov    $0x0,%eax
80105d80:	eb 48                	jmp    80105dca <sys_link+0x1a2>
80105d82:	90                   	nop
80105d83:	83 ec 0c             	sub    $0xc,%esp
80105d86:	ff 75 f4             	pushl  -0xc(%ebp)
80105d89:	e8 7d bb ff ff       	call   8010190b <ilock>
80105d8e:	83 c4 10             	add    $0x10,%esp
80105d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d94:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d98:	83 e8 01             	sub    $0x1,%eax
80105d9b:	89 c2                	mov    %eax,%edx
80105d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da0:	66 89 50 16          	mov    %dx,0x16(%eax)
80105da4:	83 ec 0c             	sub    $0xc,%esp
80105da7:	ff 75 f4             	pushl  -0xc(%ebp)
80105daa:	e8 88 b9 ff ff       	call   80101737 <iupdate>
80105daf:	83 c4 10             	add    $0x10,%esp
80105db2:	83 ec 0c             	sub    $0xc,%esp
80105db5:	ff 75 f4             	pushl  -0xc(%ebp)
80105db8:	e8 08 be ff ff       	call   80101bc5 <iunlockput>
80105dbd:	83 c4 10             	add    $0x10,%esp
80105dc0:	e8 7b d7 ff ff       	call   80103540 <end_op>
80105dc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dca:	c9                   	leave  
80105dcb:	c3                   	ret    

80105dcc <isdirempty>:
80105dcc:	55                   	push   %ebp
80105dcd:	89 e5                	mov    %esp,%ebp
80105dcf:	83 ec 28             	sub    $0x28,%esp
80105dd2:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105dd9:	eb 40                	jmp    80105e1b <isdirempty+0x4f>
80105ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dde:	6a 10                	push   $0x10
80105de0:	50                   	push   %eax
80105de1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105de4:	50                   	push   %eax
80105de5:	ff 75 08             	pushl  0x8(%ebp)
80105de8:	e8 86 c0 ff ff       	call   80101e73 <readi>
80105ded:	83 c4 10             	add    $0x10,%esp
80105df0:	83 f8 10             	cmp    $0x10,%eax
80105df3:	74 0d                	je     80105e02 <isdirempty+0x36>
80105df5:	83 ec 0c             	sub    $0xc,%esp
80105df8:	68 01 92 10 80       	push   $0x80109201
80105dfd:	e8 64 a7 ff ff       	call   80100566 <panic>
80105e02:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105e06:	66 85 c0             	test   %ax,%ax
80105e09:	74 07                	je     80105e12 <isdirempty+0x46>
80105e0b:	b8 00 00 00 00       	mov    $0x0,%eax
80105e10:	eb 1b                	jmp    80105e2d <isdirempty+0x61>
80105e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e15:	83 c0 10             	add    $0x10,%eax
80105e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80105e1e:	8b 50 18             	mov    0x18(%eax),%edx
80105e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e24:	39 c2                	cmp    %eax,%edx
80105e26:	77 b3                	ja     80105ddb <isdirempty+0xf>
80105e28:	b8 01 00 00 00       	mov    $0x1,%eax
80105e2d:	c9                   	leave  
80105e2e:	c3                   	ret    

80105e2f <sys_unlink>:
80105e2f:	55                   	push   %ebp
80105e30:	89 e5                	mov    %esp,%ebp
80105e32:	83 ec 38             	sub    $0x38,%esp
80105e35:	83 ec 08             	sub    $0x8,%esp
80105e38:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105e3b:	50                   	push   %eax
80105e3c:	6a 00                	push   $0x0
80105e3e:	e8 a0 fa ff ff       	call   801058e3 <argstr>
80105e43:	83 c4 10             	add    $0x10,%esp
80105e46:	85 c0                	test   %eax,%eax
80105e48:	79 0a                	jns    80105e54 <sys_unlink+0x25>
80105e4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e4f:	e9 bc 01 00 00       	jmp    80106010 <sys_unlink+0x1e1>
80105e54:	e8 5b d6 ff ff       	call   801034b4 <begin_op>
80105e59:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105e5c:	83 ec 08             	sub    $0x8,%esp
80105e5f:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105e62:	52                   	push   %edx
80105e63:	50                   	push   %eax
80105e64:	e8 76 c6 ff ff       	call   801024df <nameiparent>
80105e69:	83 c4 10             	add    $0x10,%esp
80105e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e73:	75 0f                	jne    80105e84 <sys_unlink+0x55>
80105e75:	e8 c6 d6 ff ff       	call   80103540 <end_op>
80105e7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e7f:	e9 8c 01 00 00       	jmp    80106010 <sys_unlink+0x1e1>
80105e84:	83 ec 0c             	sub    $0xc,%esp
80105e87:	ff 75 f4             	pushl  -0xc(%ebp)
80105e8a:	e8 7c ba ff ff       	call   8010190b <ilock>
80105e8f:	83 c4 10             	add    $0x10,%esp
80105e92:	83 ec 08             	sub    $0x8,%esp
80105e95:	68 13 92 10 80       	push   $0x80109213
80105e9a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e9d:	50                   	push   %eax
80105e9e:	e8 af c2 ff ff       	call   80102152 <namecmp>
80105ea3:	83 c4 10             	add    $0x10,%esp
80105ea6:	85 c0                	test   %eax,%eax
80105ea8:	0f 84 4a 01 00 00    	je     80105ff8 <sys_unlink+0x1c9>
80105eae:	83 ec 08             	sub    $0x8,%esp
80105eb1:	68 15 92 10 80       	push   $0x80109215
80105eb6:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105eb9:	50                   	push   %eax
80105eba:	e8 93 c2 ff ff       	call   80102152 <namecmp>
80105ebf:	83 c4 10             	add    $0x10,%esp
80105ec2:	85 c0                	test   %eax,%eax
80105ec4:	0f 84 2e 01 00 00    	je     80105ff8 <sys_unlink+0x1c9>
80105eca:	83 ec 04             	sub    $0x4,%esp
80105ecd:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105ed0:	50                   	push   %eax
80105ed1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ed4:	50                   	push   %eax
80105ed5:	ff 75 f4             	pushl  -0xc(%ebp)
80105ed8:	e8 90 c2 ff ff       	call   8010216d <dirlookup>
80105edd:	83 c4 10             	add    $0x10,%esp
80105ee0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ee3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ee7:	0f 84 0a 01 00 00    	je     80105ff7 <sys_unlink+0x1c8>
80105eed:	83 ec 0c             	sub    $0xc,%esp
80105ef0:	ff 75 f0             	pushl  -0x10(%ebp)
80105ef3:	e8 13 ba ff ff       	call   8010190b <ilock>
80105ef8:	83 c4 10             	add    $0x10,%esp
80105efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105efe:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f02:	66 85 c0             	test   %ax,%ax
80105f05:	7f 0d                	jg     80105f14 <sys_unlink+0xe5>
80105f07:	83 ec 0c             	sub    $0xc,%esp
80105f0a:	68 18 92 10 80       	push   $0x80109218
80105f0f:	e8 52 a6 ff ff       	call   80100566 <panic>
80105f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f17:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f1b:	66 83 f8 01          	cmp    $0x1,%ax
80105f1f:	75 25                	jne    80105f46 <sys_unlink+0x117>
80105f21:	83 ec 0c             	sub    $0xc,%esp
80105f24:	ff 75 f0             	pushl  -0x10(%ebp)
80105f27:	e8 a0 fe ff ff       	call   80105dcc <isdirempty>
80105f2c:	83 c4 10             	add    $0x10,%esp
80105f2f:	85 c0                	test   %eax,%eax
80105f31:	75 13                	jne    80105f46 <sys_unlink+0x117>
80105f33:	83 ec 0c             	sub    $0xc,%esp
80105f36:	ff 75 f0             	pushl  -0x10(%ebp)
80105f39:	e8 87 bc ff ff       	call   80101bc5 <iunlockput>
80105f3e:	83 c4 10             	add    $0x10,%esp
80105f41:	e9 b2 00 00 00       	jmp    80105ff8 <sys_unlink+0x1c9>
80105f46:	83 ec 04             	sub    $0x4,%esp
80105f49:	6a 10                	push   $0x10
80105f4b:	6a 00                	push   $0x0
80105f4d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f50:	50                   	push   %eax
80105f51:	e8 e3 f5 ff ff       	call   80105539 <memset>
80105f56:	83 c4 10             	add    $0x10,%esp
80105f59:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105f5c:	6a 10                	push   $0x10
80105f5e:	50                   	push   %eax
80105f5f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f62:	50                   	push   %eax
80105f63:	ff 75 f4             	pushl  -0xc(%ebp)
80105f66:	e8 5f c0 ff ff       	call   80101fca <writei>
80105f6b:	83 c4 10             	add    $0x10,%esp
80105f6e:	83 f8 10             	cmp    $0x10,%eax
80105f71:	74 0d                	je     80105f80 <sys_unlink+0x151>
80105f73:	83 ec 0c             	sub    $0xc,%esp
80105f76:	68 2a 92 10 80       	push   $0x8010922a
80105f7b:	e8 e6 a5 ff ff       	call   80100566 <panic>
80105f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f83:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f87:	66 83 f8 01          	cmp    $0x1,%ax
80105f8b:	75 21                	jne    80105fae <sys_unlink+0x17f>
80105f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f90:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f94:	83 e8 01             	sub    $0x1,%eax
80105f97:	89 c2                	mov    %eax,%edx
80105f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f9c:	66 89 50 16          	mov    %dx,0x16(%eax)
80105fa0:	83 ec 0c             	sub    $0xc,%esp
80105fa3:	ff 75 f4             	pushl  -0xc(%ebp)
80105fa6:	e8 8c b7 ff ff       	call   80101737 <iupdate>
80105fab:	83 c4 10             	add    $0x10,%esp
80105fae:	83 ec 0c             	sub    $0xc,%esp
80105fb1:	ff 75 f4             	pushl  -0xc(%ebp)
80105fb4:	e8 0c bc ff ff       	call   80101bc5 <iunlockput>
80105fb9:	83 c4 10             	add    $0x10,%esp
80105fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fbf:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105fc3:	83 e8 01             	sub    $0x1,%eax
80105fc6:	89 c2                	mov    %eax,%edx
80105fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fcb:	66 89 50 16          	mov    %dx,0x16(%eax)
80105fcf:	83 ec 0c             	sub    $0xc,%esp
80105fd2:	ff 75 f0             	pushl  -0x10(%ebp)
80105fd5:	e8 5d b7 ff ff       	call   80101737 <iupdate>
80105fda:	83 c4 10             	add    $0x10,%esp
80105fdd:	83 ec 0c             	sub    $0xc,%esp
80105fe0:	ff 75 f0             	pushl  -0x10(%ebp)
80105fe3:	e8 dd bb ff ff       	call   80101bc5 <iunlockput>
80105fe8:	83 c4 10             	add    $0x10,%esp
80105feb:	e8 50 d5 ff ff       	call   80103540 <end_op>
80105ff0:	b8 00 00 00 00       	mov    $0x0,%eax
80105ff5:	eb 19                	jmp    80106010 <sys_unlink+0x1e1>
80105ff7:	90                   	nop
80105ff8:	83 ec 0c             	sub    $0xc,%esp
80105ffb:	ff 75 f4             	pushl  -0xc(%ebp)
80105ffe:	e8 c2 bb ff ff       	call   80101bc5 <iunlockput>
80106003:	83 c4 10             	add    $0x10,%esp
80106006:	e8 35 d5 ff ff       	call   80103540 <end_op>
8010600b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106010:	c9                   	leave  
80106011:	c3                   	ret    

80106012 <create>:
80106012:	55                   	push   %ebp
80106013:	89 e5                	mov    %esp,%ebp
80106015:	83 ec 38             	sub    $0x38,%esp
80106018:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010601b:	8b 55 10             	mov    0x10(%ebp),%edx
8010601e:	8b 45 14             	mov    0x14(%ebp),%eax
80106021:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106025:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106029:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
8010602d:	83 ec 08             	sub    $0x8,%esp
80106030:	8d 45 de             	lea    -0x22(%ebp),%eax
80106033:	50                   	push   %eax
80106034:	ff 75 08             	pushl  0x8(%ebp)
80106037:	e8 a3 c4 ff ff       	call   801024df <nameiparent>
8010603c:	83 c4 10             	add    $0x10,%esp
8010603f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106046:	75 0a                	jne    80106052 <create+0x40>
80106048:	b8 00 00 00 00       	mov    $0x0,%eax
8010604d:	e9 90 01 00 00       	jmp    801061e2 <create+0x1d0>
80106052:	83 ec 0c             	sub    $0xc,%esp
80106055:	ff 75 f4             	pushl  -0xc(%ebp)
80106058:	e8 ae b8 ff ff       	call   8010190b <ilock>
8010605d:	83 c4 10             	add    $0x10,%esp
80106060:	83 ec 04             	sub    $0x4,%esp
80106063:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106066:	50                   	push   %eax
80106067:	8d 45 de             	lea    -0x22(%ebp),%eax
8010606a:	50                   	push   %eax
8010606b:	ff 75 f4             	pushl  -0xc(%ebp)
8010606e:	e8 fa c0 ff ff       	call   8010216d <dirlookup>
80106073:	83 c4 10             	add    $0x10,%esp
80106076:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106079:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010607d:	74 50                	je     801060cf <create+0xbd>
8010607f:	83 ec 0c             	sub    $0xc,%esp
80106082:	ff 75 f4             	pushl  -0xc(%ebp)
80106085:	e8 3b bb ff ff       	call   80101bc5 <iunlockput>
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	83 ec 0c             	sub    $0xc,%esp
80106090:	ff 75 f0             	pushl  -0x10(%ebp)
80106093:	e8 73 b8 ff ff       	call   8010190b <ilock>
80106098:	83 c4 10             	add    $0x10,%esp
8010609b:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801060a0:	75 15                	jne    801060b7 <create+0xa5>
801060a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060a5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801060a9:	66 83 f8 02          	cmp    $0x2,%ax
801060ad:	75 08                	jne    801060b7 <create+0xa5>
801060af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060b2:	e9 2b 01 00 00       	jmp    801061e2 <create+0x1d0>
801060b7:	83 ec 0c             	sub    $0xc,%esp
801060ba:	ff 75 f0             	pushl  -0x10(%ebp)
801060bd:	e8 03 bb ff ff       	call   80101bc5 <iunlockput>
801060c2:	83 c4 10             	add    $0x10,%esp
801060c5:	b8 00 00 00 00       	mov    $0x0,%eax
801060ca:	e9 13 01 00 00       	jmp    801061e2 <create+0x1d0>
801060cf:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801060d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d6:	8b 00                	mov    (%eax),%eax
801060d8:	83 ec 08             	sub    $0x8,%esp
801060db:	52                   	push   %edx
801060dc:	50                   	push   %eax
801060dd:	e8 74 b5 ff ff       	call   80101656 <ialloc>
801060e2:	83 c4 10             	add    $0x10,%esp
801060e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060ec:	75 0d                	jne    801060fb <create+0xe9>
801060ee:	83 ec 0c             	sub    $0xc,%esp
801060f1:	68 39 92 10 80       	push   $0x80109239
801060f6:	e8 6b a4 ff ff       	call   80100566 <panic>
801060fb:	83 ec 0c             	sub    $0xc,%esp
801060fe:	ff 75 f0             	pushl  -0x10(%ebp)
80106101:	e8 05 b8 ff ff       	call   8010190b <ilock>
80106106:	83 c4 10             	add    $0x10,%esp
80106109:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010610c:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106110:	66 89 50 12          	mov    %dx,0x12(%eax)
80106114:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106117:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
8010611b:	66 89 50 14          	mov    %dx,0x14(%eax)
8010611f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106122:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
80106128:	83 ec 0c             	sub    $0xc,%esp
8010612b:	ff 75 f0             	pushl  -0x10(%ebp)
8010612e:	e8 04 b6 ff ff       	call   80101737 <iupdate>
80106133:	83 c4 10             	add    $0x10,%esp
80106136:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010613b:	75 6a                	jne    801061a7 <create+0x195>
8010613d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106140:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106144:	83 c0 01             	add    $0x1,%eax
80106147:	89 c2                	mov    %eax,%edx
80106149:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010614c:	66 89 50 16          	mov    %dx,0x16(%eax)
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	ff 75 f4             	pushl  -0xc(%ebp)
80106156:	e8 dc b5 ff ff       	call   80101737 <iupdate>
8010615b:	83 c4 10             	add    $0x10,%esp
8010615e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106161:	8b 40 04             	mov    0x4(%eax),%eax
80106164:	83 ec 04             	sub    $0x4,%esp
80106167:	50                   	push   %eax
80106168:	68 13 92 10 80       	push   $0x80109213
8010616d:	ff 75 f0             	pushl  -0x10(%ebp)
80106170:	e8 b2 c0 ff ff       	call   80102227 <dirlink>
80106175:	83 c4 10             	add    $0x10,%esp
80106178:	85 c0                	test   %eax,%eax
8010617a:	78 1e                	js     8010619a <create+0x188>
8010617c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010617f:	8b 40 04             	mov    0x4(%eax),%eax
80106182:	83 ec 04             	sub    $0x4,%esp
80106185:	50                   	push   %eax
80106186:	68 15 92 10 80       	push   $0x80109215
8010618b:	ff 75 f0             	pushl  -0x10(%ebp)
8010618e:	e8 94 c0 ff ff       	call   80102227 <dirlink>
80106193:	83 c4 10             	add    $0x10,%esp
80106196:	85 c0                	test   %eax,%eax
80106198:	79 0d                	jns    801061a7 <create+0x195>
8010619a:	83 ec 0c             	sub    $0xc,%esp
8010619d:	68 48 92 10 80       	push   $0x80109248
801061a2:	e8 bf a3 ff ff       	call   80100566 <panic>
801061a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061aa:	8b 40 04             	mov    0x4(%eax),%eax
801061ad:	83 ec 04             	sub    $0x4,%esp
801061b0:	50                   	push   %eax
801061b1:	8d 45 de             	lea    -0x22(%ebp),%eax
801061b4:	50                   	push   %eax
801061b5:	ff 75 f4             	pushl  -0xc(%ebp)
801061b8:	e8 6a c0 ff ff       	call   80102227 <dirlink>
801061bd:	83 c4 10             	add    $0x10,%esp
801061c0:	85 c0                	test   %eax,%eax
801061c2:	79 0d                	jns    801061d1 <create+0x1bf>
801061c4:	83 ec 0c             	sub    $0xc,%esp
801061c7:	68 54 92 10 80       	push   $0x80109254
801061cc:	e8 95 a3 ff ff       	call   80100566 <panic>
801061d1:	83 ec 0c             	sub    $0xc,%esp
801061d4:	ff 75 f4             	pushl  -0xc(%ebp)
801061d7:	e8 e9 b9 ff ff       	call   80101bc5 <iunlockput>
801061dc:	83 c4 10             	add    $0x10,%esp
801061df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061e2:	c9                   	leave  
801061e3:	c3                   	ret    

801061e4 <sys_open>:
801061e4:	55                   	push   %ebp
801061e5:	89 e5                	mov    %esp,%ebp
801061e7:	83 ec 28             	sub    $0x28,%esp
801061ea:	83 ec 08             	sub    $0x8,%esp
801061ed:	8d 45 e8             	lea    -0x18(%ebp),%eax
801061f0:	50                   	push   %eax
801061f1:	6a 00                	push   $0x0
801061f3:	e8 eb f6 ff ff       	call   801058e3 <argstr>
801061f8:	83 c4 10             	add    $0x10,%esp
801061fb:	85 c0                	test   %eax,%eax
801061fd:	78 15                	js     80106214 <sys_open+0x30>
801061ff:	83 ec 08             	sub    $0x8,%esp
80106202:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106205:	50                   	push   %eax
80106206:	6a 01                	push   $0x1
80106208:	e8 51 f6 ff ff       	call   8010585e <argint>
8010620d:	83 c4 10             	add    $0x10,%esp
80106210:	85 c0                	test   %eax,%eax
80106212:	79 0a                	jns    8010621e <sys_open+0x3a>
80106214:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106219:	e9 61 01 00 00       	jmp    8010637f <sys_open+0x19b>
8010621e:	e8 91 d2 ff ff       	call   801034b4 <begin_op>
80106223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106226:	25 00 02 00 00       	and    $0x200,%eax
8010622b:	85 c0                	test   %eax,%eax
8010622d:	74 2a                	je     80106259 <sys_open+0x75>
8010622f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106232:	6a 00                	push   $0x0
80106234:	6a 00                	push   $0x0
80106236:	6a 02                	push   $0x2
80106238:	50                   	push   %eax
80106239:	e8 d4 fd ff ff       	call   80106012 <create>
8010623e:	83 c4 10             	add    $0x10,%esp
80106241:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106244:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106248:	75 75                	jne    801062bf <sys_open+0xdb>
8010624a:	e8 f1 d2 ff ff       	call   80103540 <end_op>
8010624f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106254:	e9 26 01 00 00       	jmp    8010637f <sys_open+0x19b>
80106259:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010625c:	83 ec 0c             	sub    $0xc,%esp
8010625f:	50                   	push   %eax
80106260:	e8 5e c2 ff ff       	call   801024c3 <namei>
80106265:	83 c4 10             	add    $0x10,%esp
80106268:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010626b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010626f:	75 0f                	jne    80106280 <sys_open+0x9c>
80106271:	e8 ca d2 ff ff       	call   80103540 <end_op>
80106276:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010627b:	e9 ff 00 00 00       	jmp    8010637f <sys_open+0x19b>
80106280:	83 ec 0c             	sub    $0xc,%esp
80106283:	ff 75 f4             	pushl  -0xc(%ebp)
80106286:	e8 80 b6 ff ff       	call   8010190b <ilock>
8010628b:	83 c4 10             	add    $0x10,%esp
8010628e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106291:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106295:	66 83 f8 01          	cmp    $0x1,%ax
80106299:	75 24                	jne    801062bf <sys_open+0xdb>
8010629b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010629e:	85 c0                	test   %eax,%eax
801062a0:	74 1d                	je     801062bf <sys_open+0xdb>
801062a2:	83 ec 0c             	sub    $0xc,%esp
801062a5:	ff 75 f4             	pushl  -0xc(%ebp)
801062a8:	e8 18 b9 ff ff       	call   80101bc5 <iunlockput>
801062ad:	83 c4 10             	add    $0x10,%esp
801062b0:	e8 8b d2 ff ff       	call   80103540 <end_op>
801062b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ba:	e9 c0 00 00 00       	jmp    8010637f <sys_open+0x19b>
801062bf:	e8 b4 ac ff ff       	call   80100f78 <filealloc>
801062c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062cb:	74 17                	je     801062e4 <sys_open+0x100>
801062cd:	83 ec 0c             	sub    $0xc,%esp
801062d0:	ff 75 f0             	pushl  -0x10(%ebp)
801062d3:	e8 37 f7 ff ff       	call   80105a0f <fdalloc>
801062d8:	83 c4 10             	add    $0x10,%esp
801062db:	89 45 ec             	mov    %eax,-0x14(%ebp)
801062de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801062e2:	79 2e                	jns    80106312 <sys_open+0x12e>
801062e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062e8:	74 0e                	je     801062f8 <sys_open+0x114>
801062ea:	83 ec 0c             	sub    $0xc,%esp
801062ed:	ff 75 f0             	pushl  -0x10(%ebp)
801062f0:	e8 41 ad ff ff       	call   80101036 <fileclose>
801062f5:	83 c4 10             	add    $0x10,%esp
801062f8:	83 ec 0c             	sub    $0xc,%esp
801062fb:	ff 75 f4             	pushl  -0xc(%ebp)
801062fe:	e8 c2 b8 ff ff       	call   80101bc5 <iunlockput>
80106303:	83 c4 10             	add    $0x10,%esp
80106306:	e8 35 d2 ff ff       	call   80103540 <end_op>
8010630b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106310:	eb 6d                	jmp    8010637f <sys_open+0x19b>
80106312:	83 ec 0c             	sub    $0xc,%esp
80106315:	ff 75 f4             	pushl  -0xc(%ebp)
80106318:	e8 46 b7 ff ff       	call   80101a63 <iunlock>
8010631d:	83 c4 10             	add    $0x10,%esp
80106320:	e8 1b d2 ff ff       	call   80103540 <end_op>
80106325:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106328:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
8010632e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106331:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106334:	89 50 10             	mov    %edx,0x10(%eax)
80106337:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010633a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
80106341:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106344:	83 e0 01             	and    $0x1,%eax
80106347:	85 c0                	test   %eax,%eax
80106349:	0f 94 c0             	sete   %al
8010634c:	89 c2                	mov    %eax,%edx
8010634e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106351:	88 50 08             	mov    %dl,0x8(%eax)
80106354:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106357:	83 e0 01             	and    $0x1,%eax
8010635a:	85 c0                	test   %eax,%eax
8010635c:	75 0a                	jne    80106368 <sys_open+0x184>
8010635e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106361:	83 e0 02             	and    $0x2,%eax
80106364:	85 c0                	test   %eax,%eax
80106366:	74 07                	je     8010636f <sys_open+0x18b>
80106368:	b8 01 00 00 00       	mov    $0x1,%eax
8010636d:	eb 05                	jmp    80106374 <sys_open+0x190>
8010636f:	b8 00 00 00 00       	mov    $0x0,%eax
80106374:	89 c2                	mov    %eax,%edx
80106376:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106379:	88 50 09             	mov    %dl,0x9(%eax)
8010637c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010637f:	c9                   	leave  
80106380:	c3                   	ret    

80106381 <sys_mkdir>:
80106381:	55                   	push   %ebp
80106382:	89 e5                	mov    %esp,%ebp
80106384:	83 ec 18             	sub    $0x18,%esp
80106387:	e8 28 d1 ff ff       	call   801034b4 <begin_op>
8010638c:	83 ec 08             	sub    $0x8,%esp
8010638f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106392:	50                   	push   %eax
80106393:	6a 00                	push   $0x0
80106395:	e8 49 f5 ff ff       	call   801058e3 <argstr>
8010639a:	83 c4 10             	add    $0x10,%esp
8010639d:	85 c0                	test   %eax,%eax
8010639f:	78 1b                	js     801063bc <sys_mkdir+0x3b>
801063a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a4:	6a 00                	push   $0x0
801063a6:	6a 00                	push   $0x0
801063a8:	6a 01                	push   $0x1
801063aa:	50                   	push   %eax
801063ab:	e8 62 fc ff ff       	call   80106012 <create>
801063b0:	83 c4 10             	add    $0x10,%esp
801063b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063ba:	75 0c                	jne    801063c8 <sys_mkdir+0x47>
801063bc:	e8 7f d1 ff ff       	call   80103540 <end_op>
801063c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063c6:	eb 18                	jmp    801063e0 <sys_mkdir+0x5f>
801063c8:	83 ec 0c             	sub    $0xc,%esp
801063cb:	ff 75 f4             	pushl  -0xc(%ebp)
801063ce:	e8 f2 b7 ff ff       	call   80101bc5 <iunlockput>
801063d3:	83 c4 10             	add    $0x10,%esp
801063d6:	e8 65 d1 ff ff       	call   80103540 <end_op>
801063db:	b8 00 00 00 00       	mov    $0x0,%eax
801063e0:	c9                   	leave  
801063e1:	c3                   	ret    

801063e2 <sys_mknod>:
801063e2:	55                   	push   %ebp
801063e3:	89 e5                	mov    %esp,%ebp
801063e5:	83 ec 28             	sub    $0x28,%esp
801063e8:	e8 c7 d0 ff ff       	call   801034b4 <begin_op>
801063ed:	83 ec 08             	sub    $0x8,%esp
801063f0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801063f3:	50                   	push   %eax
801063f4:	6a 00                	push   $0x0
801063f6:	e8 e8 f4 ff ff       	call   801058e3 <argstr>
801063fb:	83 c4 10             	add    $0x10,%esp
801063fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106401:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106405:	78 4f                	js     80106456 <sys_mknod+0x74>
80106407:	83 ec 08             	sub    $0x8,%esp
8010640a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010640d:	50                   	push   %eax
8010640e:	6a 01                	push   $0x1
80106410:	e8 49 f4 ff ff       	call   8010585e <argint>
80106415:	83 c4 10             	add    $0x10,%esp
80106418:	85 c0                	test   %eax,%eax
8010641a:	78 3a                	js     80106456 <sys_mknod+0x74>
8010641c:	83 ec 08             	sub    $0x8,%esp
8010641f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106422:	50                   	push   %eax
80106423:	6a 02                	push   $0x2
80106425:	e8 34 f4 ff ff       	call   8010585e <argint>
8010642a:	83 c4 10             	add    $0x10,%esp
8010642d:	85 c0                	test   %eax,%eax
8010642f:	78 25                	js     80106456 <sys_mknod+0x74>
80106431:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106434:	0f bf c8             	movswl %ax,%ecx
80106437:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010643a:	0f bf d0             	movswl %ax,%edx
8010643d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106440:	51                   	push   %ecx
80106441:	52                   	push   %edx
80106442:	6a 03                	push   $0x3
80106444:	50                   	push   %eax
80106445:	e8 c8 fb ff ff       	call   80106012 <create>
8010644a:	83 c4 10             	add    $0x10,%esp
8010644d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106450:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106454:	75 0c                	jne    80106462 <sys_mknod+0x80>
80106456:	e8 e5 d0 ff ff       	call   80103540 <end_op>
8010645b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106460:	eb 18                	jmp    8010647a <sys_mknod+0x98>
80106462:	83 ec 0c             	sub    $0xc,%esp
80106465:	ff 75 f0             	pushl  -0x10(%ebp)
80106468:	e8 58 b7 ff ff       	call   80101bc5 <iunlockput>
8010646d:	83 c4 10             	add    $0x10,%esp
80106470:	e8 cb d0 ff ff       	call   80103540 <end_op>
80106475:	b8 00 00 00 00       	mov    $0x0,%eax
8010647a:	c9                   	leave  
8010647b:	c3                   	ret    

8010647c <sys_chdir>:
8010647c:	55                   	push   %ebp
8010647d:	89 e5                	mov    %esp,%ebp
8010647f:	83 ec 18             	sub    $0x18,%esp
80106482:	e8 2d d0 ff ff       	call   801034b4 <begin_op>
80106487:	83 ec 08             	sub    $0x8,%esp
8010648a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010648d:	50                   	push   %eax
8010648e:	6a 00                	push   $0x0
80106490:	e8 4e f4 ff ff       	call   801058e3 <argstr>
80106495:	83 c4 10             	add    $0x10,%esp
80106498:	85 c0                	test   %eax,%eax
8010649a:	78 18                	js     801064b4 <sys_chdir+0x38>
8010649c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010649f:	83 ec 0c             	sub    $0xc,%esp
801064a2:	50                   	push   %eax
801064a3:	e8 1b c0 ff ff       	call   801024c3 <namei>
801064a8:	83 c4 10             	add    $0x10,%esp
801064ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064b2:	75 0c                	jne    801064c0 <sys_chdir+0x44>
801064b4:	e8 87 d0 ff ff       	call   80103540 <end_op>
801064b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064be:	eb 6e                	jmp    8010652e <sys_chdir+0xb2>
801064c0:	83 ec 0c             	sub    $0xc,%esp
801064c3:	ff 75 f4             	pushl  -0xc(%ebp)
801064c6:	e8 40 b4 ff ff       	call   8010190b <ilock>
801064cb:	83 c4 10             	add    $0x10,%esp
801064ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801064d5:	66 83 f8 01          	cmp    $0x1,%ax
801064d9:	74 1a                	je     801064f5 <sys_chdir+0x79>
801064db:	83 ec 0c             	sub    $0xc,%esp
801064de:	ff 75 f4             	pushl  -0xc(%ebp)
801064e1:	e8 df b6 ff ff       	call   80101bc5 <iunlockput>
801064e6:	83 c4 10             	add    $0x10,%esp
801064e9:	e8 52 d0 ff ff       	call   80103540 <end_op>
801064ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064f3:	eb 39                	jmp    8010652e <sys_chdir+0xb2>
801064f5:	83 ec 0c             	sub    $0xc,%esp
801064f8:	ff 75 f4             	pushl  -0xc(%ebp)
801064fb:	e8 63 b5 ff ff       	call   80101a63 <iunlock>
80106500:	83 c4 10             	add    $0x10,%esp
80106503:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106509:	8b 40 68             	mov    0x68(%eax),%eax
8010650c:	83 ec 0c             	sub    $0xc,%esp
8010650f:	50                   	push   %eax
80106510:	e8 c0 b5 ff ff       	call   80101ad5 <iput>
80106515:	83 c4 10             	add    $0x10,%esp
80106518:	e8 23 d0 ff ff       	call   80103540 <end_op>
8010651d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106523:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106526:	89 50 68             	mov    %edx,0x68(%eax)
80106529:	b8 00 00 00 00       	mov    $0x0,%eax
8010652e:	c9                   	leave  
8010652f:	c3                   	ret    

80106530 <sys_exec>:
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	81 ec 98 00 00 00    	sub    $0x98,%esp
80106539:	83 ec 08             	sub    $0x8,%esp
8010653c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010653f:	50                   	push   %eax
80106540:	6a 00                	push   $0x0
80106542:	e8 9c f3 ff ff       	call   801058e3 <argstr>
80106547:	83 c4 10             	add    $0x10,%esp
8010654a:	85 c0                	test   %eax,%eax
8010654c:	78 18                	js     80106566 <sys_exec+0x36>
8010654e:	83 ec 08             	sub    $0x8,%esp
80106551:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106557:	50                   	push   %eax
80106558:	6a 01                	push   $0x1
8010655a:	e8 ff f2 ff ff       	call   8010585e <argint>
8010655f:	83 c4 10             	add    $0x10,%esp
80106562:	85 c0                	test   %eax,%eax
80106564:	79 0a                	jns    80106570 <sys_exec+0x40>
80106566:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010656b:	e9 c6 00 00 00       	jmp    80106636 <sys_exec+0x106>
80106570:	83 ec 04             	sub    $0x4,%esp
80106573:	68 80 00 00 00       	push   $0x80
80106578:	6a 00                	push   $0x0
8010657a:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106580:	50                   	push   %eax
80106581:	e8 b3 ef ff ff       	call   80105539 <memset>
80106586:	83 c4 10             	add    $0x10,%esp
80106589:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106593:	83 f8 1f             	cmp    $0x1f,%eax
80106596:	76 0a                	jbe    801065a2 <sys_exec+0x72>
80106598:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010659d:	e9 94 00 00 00       	jmp    80106636 <sys_exec+0x106>
801065a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a5:	c1 e0 02             	shl    $0x2,%eax
801065a8:	89 c2                	mov    %eax,%edx
801065aa:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801065b0:	01 c2                	add    %eax,%edx
801065b2:	83 ec 08             	sub    $0x8,%esp
801065b5:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801065bb:	50                   	push   %eax
801065bc:	52                   	push   %edx
801065bd:	e8 00 f2 ff ff       	call   801057c2 <fetchint>
801065c2:	83 c4 10             	add    $0x10,%esp
801065c5:	85 c0                	test   %eax,%eax
801065c7:	79 07                	jns    801065d0 <sys_exec+0xa0>
801065c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ce:	eb 66                	jmp    80106636 <sys_exec+0x106>
801065d0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801065d6:	85 c0                	test   %eax,%eax
801065d8:	75 27                	jne    80106601 <sys_exec+0xd1>
801065da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065dd:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801065e4:	00 00 00 00 
801065e8:	90                   	nop
801065e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065ec:	83 ec 08             	sub    $0x8,%esp
801065ef:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801065f5:	52                   	push   %edx
801065f6:	50                   	push   %eax
801065f7:	e8 5a a5 ff ff       	call   80100b56 <exec>
801065fc:	83 c4 10             	add    $0x10,%esp
801065ff:	eb 35                	jmp    80106636 <sys_exec+0x106>
80106601:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106607:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010660a:	c1 e2 02             	shl    $0x2,%edx
8010660d:	01 c2                	add    %eax,%edx
8010660f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106615:	83 ec 08             	sub    $0x8,%esp
80106618:	52                   	push   %edx
80106619:	50                   	push   %eax
8010661a:	e8 dd f1 ff ff       	call   801057fc <fetchstr>
8010661f:	83 c4 10             	add    $0x10,%esp
80106622:	85 c0                	test   %eax,%eax
80106624:	79 07                	jns    8010662d <sys_exec+0xfd>
80106626:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010662b:	eb 09                	jmp    80106636 <sys_exec+0x106>
8010662d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106631:	e9 5a ff ff ff       	jmp    80106590 <sys_exec+0x60>
80106636:	c9                   	leave  
80106637:	c3                   	ret    

80106638 <sys_pipe>:
80106638:	55                   	push   %ebp
80106639:	89 e5                	mov    %esp,%ebp
8010663b:	83 ec 28             	sub    $0x28,%esp
8010663e:	83 ec 04             	sub    $0x4,%esp
80106641:	6a 08                	push   $0x8
80106643:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106646:	50                   	push   %eax
80106647:	6a 00                	push   $0x0
80106649:	e8 38 f2 ff ff       	call   80105886 <argptr>
8010664e:	83 c4 10             	add    $0x10,%esp
80106651:	85 c0                	test   %eax,%eax
80106653:	79 0a                	jns    8010665f <sys_pipe+0x27>
80106655:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010665a:	e9 af 00 00 00       	jmp    8010670e <sys_pipe+0xd6>
8010665f:	83 ec 08             	sub    $0x8,%esp
80106662:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106665:	50                   	push   %eax
80106666:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106669:	50                   	push   %eax
8010666a:	e8 23 d9 ff ff       	call   80103f92 <pipealloc>
8010666f:	83 c4 10             	add    $0x10,%esp
80106672:	85 c0                	test   %eax,%eax
80106674:	79 0a                	jns    80106680 <sys_pipe+0x48>
80106676:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010667b:	e9 8e 00 00 00       	jmp    8010670e <sys_pipe+0xd6>
80106680:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
80106687:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010668a:	83 ec 0c             	sub    $0xc,%esp
8010668d:	50                   	push   %eax
8010668e:	e8 7c f3 ff ff       	call   80105a0f <fdalloc>
80106693:	83 c4 10             	add    $0x10,%esp
80106696:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106699:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010669d:	78 18                	js     801066b7 <sys_pipe+0x7f>
8010669f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066a2:	83 ec 0c             	sub    $0xc,%esp
801066a5:	50                   	push   %eax
801066a6:	e8 64 f3 ff ff       	call   80105a0f <fdalloc>
801066ab:	83 c4 10             	add    $0x10,%esp
801066ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066b5:	79 3f                	jns    801066f6 <sys_pipe+0xbe>
801066b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066bb:	78 14                	js     801066d1 <sys_pipe+0x99>
801066bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066c6:	83 c2 08             	add    $0x8,%edx
801066c9:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801066d0:	00 
801066d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066d4:	83 ec 0c             	sub    $0xc,%esp
801066d7:	50                   	push   %eax
801066d8:	e8 59 a9 ff ff       	call   80101036 <fileclose>
801066dd:	83 c4 10             	add    $0x10,%esp
801066e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066e3:	83 ec 0c             	sub    $0xc,%esp
801066e6:	50                   	push   %eax
801066e7:	e8 4a a9 ff ff       	call   80101036 <fileclose>
801066ec:	83 c4 10             	add    $0x10,%esp
801066ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066f4:	eb 18                	jmp    8010670e <sys_pipe+0xd6>
801066f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801066f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066fc:	89 10                	mov    %edx,(%eax)
801066fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106701:	8d 50 04             	lea    0x4(%eax),%edx
80106704:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106707:	89 02                	mov    %eax,(%edx)
80106709:	b8 00 00 00 00       	mov    $0x0,%eax
8010670e:	c9                   	leave  
8010670f:	c3                   	ret    

80106710 <outw>:
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	83 ec 08             	sub    $0x8,%esp
80106716:	8b 55 08             	mov    0x8(%ebp),%edx
80106719:	8b 45 0c             	mov    0xc(%ebp),%eax
8010671c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106720:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
80106724:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80106728:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010672c:	66 ef                	out    %ax,(%dx)
8010672e:	90                   	nop
8010672f:	c9                   	leave  
80106730:	c3                   	ret    

80106731 <sys_fork>:
80106731:	55                   	push   %ebp
80106732:	89 e5                	mov    %esp,%ebp
80106734:	83 ec 08             	sub    $0x8,%esp
80106737:	e8 90 df ff ff       	call   801046cc <fork>
8010673c:	c9                   	leave  
8010673d:	c3                   	ret    

8010673e <sys_exit>:
8010673e:	55                   	push   %ebp
8010673f:	89 e5                	mov    %esp,%ebp
80106741:	83 ec 08             	sub    $0x8,%esp
80106744:	e8 e2 e2 ff ff       	call   80104a2b <exit>
80106749:	b8 00 00 00 00       	mov    $0x0,%eax
8010674e:	c9                   	leave  
8010674f:	c3                   	ret    

80106750 <sys_wait>:
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	83 ec 08             	sub    $0x8,%esp
80106756:	e8 1b e4 ff ff       	call   80104b76 <wait>
8010675b:	c9                   	leave  
8010675c:	c3                   	ret    

8010675d <sys_kill>:
8010675d:	55                   	push   %ebp
8010675e:	89 e5                	mov    %esp,%ebp
80106760:	83 ec 18             	sub    $0x18,%esp
80106763:	83 ec 08             	sub    $0x8,%esp
80106766:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106769:	50                   	push   %eax
8010676a:	6a 00                	push   $0x0
8010676c:	e8 ed f0 ff ff       	call   8010585e <argint>
80106771:	83 c4 10             	add    $0x10,%esp
80106774:	85 c0                	test   %eax,%eax
80106776:	79 07                	jns    8010677f <sys_kill+0x22>
80106778:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010677d:	eb 0f                	jmp    8010678e <sys_kill+0x31>
8010677f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106782:	83 ec 0c             	sub    $0xc,%esp
80106785:	50                   	push   %eax
80106786:	e8 07 e8 ff ff       	call   80104f92 <kill>
8010678b:	83 c4 10             	add    $0x10,%esp
8010678e:	c9                   	leave  
8010678f:	c3                   	ret    

80106790 <sys_getpid>:
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106799:	8b 40 10             	mov    0x10(%eax),%eax
8010679c:	5d                   	pop    %ebp
8010679d:	c3                   	ret    

8010679e <sys_sbrk>:
8010679e:	55                   	push   %ebp
8010679f:	89 e5                	mov    %esp,%ebp
801067a1:	83 ec 18             	sub    $0x18,%esp
801067a4:	83 ec 08             	sub    $0x8,%esp
801067a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067aa:	50                   	push   %eax
801067ab:	6a 00                	push   $0x0
801067ad:	e8 ac f0 ff ff       	call   8010585e <argint>
801067b2:	83 c4 10             	add    $0x10,%esp
801067b5:	85 c0                	test   %eax,%eax
801067b7:	79 07                	jns    801067c0 <sys_sbrk+0x22>
801067b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067be:	eb 28                	jmp    801067e8 <sys_sbrk+0x4a>
801067c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067c6:	8b 00                	mov    (%eax),%eax
801067c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067ce:	83 ec 0c             	sub    $0xc,%esp
801067d1:	50                   	push   %eax
801067d2:	e8 52 de ff ff       	call   80104629 <growproc>
801067d7:	83 c4 10             	add    $0x10,%esp
801067da:	85 c0                	test   %eax,%eax
801067dc:	79 07                	jns    801067e5 <sys_sbrk+0x47>
801067de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067e3:	eb 03                	jmp    801067e8 <sys_sbrk+0x4a>
801067e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067e8:	c9                   	leave  
801067e9:	c3                   	ret    

801067ea <sys_sleep>:
801067ea:	55                   	push   %ebp
801067eb:	89 e5                	mov    %esp,%ebp
801067ed:	83 ec 18             	sub    $0x18,%esp
801067f0:	83 ec 08             	sub    $0x8,%esp
801067f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067f6:	50                   	push   %eax
801067f7:	6a 00                	push   $0x0
801067f9:	e8 60 f0 ff ff       	call   8010585e <argint>
801067fe:	83 c4 10             	add    $0x10,%esp
80106801:	85 c0                	test   %eax,%eax
80106803:	79 07                	jns    8010680c <sys_sleep+0x22>
80106805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010680a:	eb 77                	jmp    80106883 <sys_sleep+0x99>
8010680c:	83 ec 0c             	sub    $0xc,%esp
8010680f:	68 c0 5c 11 80       	push   $0x80115cc0
80106814:	e8 bd ea ff ff       	call   801052d6 <acquire>
80106819:	83 c4 10             	add    $0x10,%esp
8010681c:	a1 00 65 11 80       	mov    0x80116500,%eax
80106821:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106824:	eb 39                	jmp    8010685f <sys_sleep+0x75>
80106826:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010682c:	8b 40 24             	mov    0x24(%eax),%eax
8010682f:	85 c0                	test   %eax,%eax
80106831:	74 17                	je     8010684a <sys_sleep+0x60>
80106833:	83 ec 0c             	sub    $0xc,%esp
80106836:	68 c0 5c 11 80       	push   $0x80115cc0
8010683b:	e8 fd ea ff ff       	call   8010533d <release>
80106840:	83 c4 10             	add    $0x10,%esp
80106843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106848:	eb 39                	jmp    80106883 <sys_sleep+0x99>
8010684a:	83 ec 08             	sub    $0x8,%esp
8010684d:	68 c0 5c 11 80       	push   $0x80115cc0
80106852:	68 00 65 11 80       	push   $0x80116500
80106857:	e8 11 e6 ff ff       	call   80104e6d <sleep>
8010685c:	83 c4 10             	add    $0x10,%esp
8010685f:	a1 00 65 11 80       	mov    0x80116500,%eax
80106864:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106867:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010686a:	39 d0                	cmp    %edx,%eax
8010686c:	72 b8                	jb     80106826 <sys_sleep+0x3c>
8010686e:	83 ec 0c             	sub    $0xc,%esp
80106871:	68 c0 5c 11 80       	push   $0x80115cc0
80106876:	e8 c2 ea ff ff       	call   8010533d <release>
8010687b:	83 c4 10             	add    $0x10,%esp
8010687e:	b8 00 00 00 00       	mov    $0x0,%eax
80106883:	c9                   	leave  
80106884:	c3                   	ret    

80106885 <sys_uptime>:
80106885:	55                   	push   %ebp
80106886:	89 e5                	mov    %esp,%ebp
80106888:	83 ec 18             	sub    $0x18,%esp
8010688b:	83 ec 0c             	sub    $0xc,%esp
8010688e:	68 c0 5c 11 80       	push   $0x80115cc0
80106893:	e8 3e ea ff ff       	call   801052d6 <acquire>
80106898:	83 c4 10             	add    $0x10,%esp
8010689b:	a1 00 65 11 80       	mov    0x80116500,%eax
801068a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068a3:	83 ec 0c             	sub    $0xc,%esp
801068a6:	68 c0 5c 11 80       	push   $0x80115cc0
801068ab:	e8 8d ea ff ff       	call   8010533d <release>
801068b0:	83 c4 10             	add    $0x10,%esp
801068b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b6:	c9                   	leave  
801068b7:	c3                   	ret    

801068b8 <sys_halt>:
801068b8:	55                   	push   %ebp
801068b9:	89 e5                	mov    %esp,%ebp
801068bb:	83 ec 10             	sub    $0x10,%esp
801068be:	c7 45 fc 64 92 10 80 	movl   $0x80109264,-0x4(%ebp)
801068c5:	eb 16                	jmp    801068dd <sys_halt+0x25>
801068c7:	68 00 20 00 00       	push   $0x2000
801068cc:	68 04 b0 00 00       	push   $0xb004
801068d1:	e8 3a fe ff ff       	call   80106710 <outw>
801068d6:	83 c4 08             	add    $0x8,%esp
801068d9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801068dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801068e0:	0f b6 00             	movzbl (%eax),%eax
801068e3:	84 c0                	test   %al,%al
801068e5:	75 e0                	jne    801068c7 <sys_halt+0xf>
801068e7:	b8 00 00 00 00       	mov    $0x0,%eax
801068ec:	c9                   	leave  
801068ed:	c3                   	ret    

801068ee <sys_mprotect>:
801068ee:	55                   	push   %ebp
801068ef:	89 e5                	mov    %esp,%ebp
801068f1:	83 ec 18             	sub    $0x18,%esp
801068f4:	83 ec 08             	sub    $0x8,%esp
801068f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068fa:	50                   	push   %eax
801068fb:	6a 00                	push   $0x0
801068fd:	e8 5c ef ff ff       	call   8010585e <argint>
80106902:	83 c4 10             	add    $0x10,%esp
80106905:	85 c0                	test   %eax,%eax
80106907:	79 07                	jns    80106910 <sys_mprotect+0x22>
80106909:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010690e:	eb 4f                	jmp    8010695f <sys_mprotect+0x71>
80106910:	83 ec 08             	sub    $0x8,%esp
80106913:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106916:	50                   	push   %eax
80106917:	6a 01                	push   $0x1
80106919:	e8 40 ef ff ff       	call   8010585e <argint>
8010691e:	83 c4 10             	add    $0x10,%esp
80106921:	85 c0                	test   %eax,%eax
80106923:	79 07                	jns    8010692c <sys_mprotect+0x3e>
80106925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010692a:	eb 33                	jmp    8010695f <sys_mprotect+0x71>
8010692c:	83 ec 08             	sub    $0x8,%esp
8010692f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106932:	50                   	push   %eax
80106933:	6a 02                	push   $0x2
80106935:	e8 24 ef ff ff       	call   8010585e <argint>
8010693a:	83 c4 10             	add    $0x10,%esp
8010693d:	85 c0                	test   %eax,%eax
8010693f:	79 07                	jns    80106948 <sys_mprotect+0x5a>
80106941:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106946:	eb 17                	jmp    8010695f <sys_mprotect+0x71>
80106948:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010694b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010694e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80106951:	83 ec 04             	sub    $0x4,%esp
80106954:	52                   	push   %edx
80106955:	50                   	push   %eax
80106956:	51                   	push   %ecx
80106957:	e8 a7 1c 00 00       	call   80108603 <mprotect>
8010695c:	83 c4 10             	add    $0x10,%esp
8010695f:	c9                   	leave  
80106960:	c3                   	ret    

80106961 <sys_signal_register>:
80106961:	55                   	push   %ebp
80106962:	89 e5                	mov    %esp,%ebp
80106964:	83 ec 18             	sub    $0x18,%esp
80106967:	83 ec 08             	sub    $0x8,%esp
8010696a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010696d:	50                   	push   %eax
8010696e:	6a 00                	push   $0x0
80106970:	e8 e9 ee ff ff       	call   8010585e <argint>
80106975:	83 c4 10             	add    $0x10,%esp
80106978:	85 c0                	test   %eax,%eax
8010697a:	79 07                	jns    80106983 <sys_signal_register+0x22>
8010697c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106981:	eb 3a                	jmp    801069bd <sys_signal_register+0x5c>
80106983:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106986:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106989:	83 ec 08             	sub    $0x8,%esp
8010698c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010698f:	50                   	push   %eax
80106990:	6a 01                	push   $0x1
80106992:	e8 c7 ee ff ff       	call   8010585e <argint>
80106997:	83 c4 10             	add    $0x10,%esp
8010699a:	85 c0                	test   %eax,%eax
8010699c:	79 07                	jns    801069a5 <sys_signal_register+0x44>
8010699e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069a3:	eb 18                	jmp    801069bd <sys_signal_register+0x5c>
801069a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801069a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801069ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069ae:	83 ec 08             	sub    $0x8,%esp
801069b1:	ff 75 f0             	pushl  -0x10(%ebp)
801069b4:	50                   	push   %eax
801069b5:	e8 80 e8 ff ff       	call   8010523a <signal_register_handler>
801069ba:	83 c4 10             	add    $0x10,%esp
801069bd:	c9                   	leave  
801069be:	c3                   	ret    

801069bf <sys_cowfork>:
801069bf:	55                   	push   %ebp
801069c0:	89 e5                	mov    %esp,%ebp
801069c2:	83 ec 08             	sub    $0x8,%esp
801069c5:	e8 93 de ff ff       	call   8010485d <cowfork>
801069ca:	c9                   	leave  
801069cb:	c3                   	ret    

801069cc <sys_signal_restorer>:
801069cc:	55                   	push   %ebp
801069cd:	89 e5                	mov    %esp,%ebp
801069cf:	83 ec 18             	sub    $0x18,%esp
801069d2:	83 ec 08             	sub    $0x8,%esp
801069d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069d8:	50                   	push   %eax
801069d9:	6a 00                	push   $0x0
801069db:	e8 7e ee ff ff       	call   8010585e <argint>
801069e0:	83 c4 10             	add    $0x10,%esp
801069e3:	85 c0                	test   %eax,%eax
801069e5:	79 07                	jns    801069ee <sys_signal_restorer+0x22>
801069e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069ec:	eb 14                	jmp    80106a02 <sys_signal_restorer+0x36>
801069ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069f7:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
801069fd:	b8 00 00 00 00       	mov    $0x0,%eax
80106a02:	c9                   	leave  
80106a03:	c3                   	ret    

80106a04 <outb>:
80106a04:	55                   	push   %ebp
80106a05:	89 e5                	mov    %esp,%ebp
80106a07:	83 ec 08             	sub    $0x8,%esp
80106a0a:	8b 55 08             	mov    0x8(%ebp),%edx
80106a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a10:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106a14:	88 45 f8             	mov    %al,-0x8(%ebp)
80106a17:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106a1b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106a1f:	ee                   	out    %al,(%dx)
80106a20:	90                   	nop
80106a21:	c9                   	leave  
80106a22:	c3                   	ret    

80106a23 <timerinit>:
80106a23:	55                   	push   %ebp
80106a24:	89 e5                	mov    %esp,%ebp
80106a26:	83 ec 08             	sub    $0x8,%esp
80106a29:	6a 34                	push   $0x34
80106a2b:	6a 43                	push   $0x43
80106a2d:	e8 d2 ff ff ff       	call   80106a04 <outb>
80106a32:	83 c4 08             	add    $0x8,%esp
80106a35:	68 9c 00 00 00       	push   $0x9c
80106a3a:	6a 40                	push   $0x40
80106a3c:	e8 c3 ff ff ff       	call   80106a04 <outb>
80106a41:	83 c4 08             	add    $0x8,%esp
80106a44:	6a 2e                	push   $0x2e
80106a46:	6a 40                	push   $0x40
80106a48:	e8 b7 ff ff ff       	call   80106a04 <outb>
80106a4d:	83 c4 08             	add    $0x8,%esp
80106a50:	83 ec 0c             	sub    $0xc,%esp
80106a53:	6a 00                	push   $0x0
80106a55:	e8 22 d4 ff ff       	call   80103e7c <picenable>
80106a5a:	83 c4 10             	add    $0x10,%esp
80106a5d:	90                   	nop
80106a5e:	c9                   	leave  
80106a5f:	c3                   	ret    

80106a60 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106a60:	1e                   	push   %ds
  pushl %es
80106a61:	06                   	push   %es
  pushl %fs
80106a62:	0f a0                	push   %fs
  pushl %gs
80106a64:	0f a8                	push   %gs
  pushal
80106a66:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106a67:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106a6b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106a6d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106a6f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106a73:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106a75:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106a77:	54                   	push   %esp
  call trap
80106a78:	e8 d7 01 00 00       	call   80106c54 <trap>
  addl $4, %esp
80106a7d:	83 c4 04             	add    $0x4,%esp

80106a80 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106a80:	61                   	popa   
  popl %gs
80106a81:	0f a9                	pop    %gs
  popl %fs
80106a83:	0f a1                	pop    %fs
  popl %es
80106a85:	07                   	pop    %es
  popl %ds
80106a86:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106a87:	83 c4 08             	add    $0x8,%esp
  iret
80106a8a:	cf                   	iret   

80106a8b <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106a8b:	55                   	push   %ebp
80106a8c:	89 e5                	mov    %esp,%ebp
80106a8e:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106a91:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a94:	83 e8 01             	sub    $0x1,%eax
80106a97:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a9e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106aa2:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa5:	c1 e8 10             	shr    $0x10,%eax
80106aa8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106aac:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106aaf:	0f 01 18             	lidtl  (%eax)
}
80106ab2:	90                   	nop
80106ab3:	c9                   	leave  
80106ab4:	c3                   	ret    

80106ab5 <rcr2>:
  asm volatile("movl %eax,%cr3");
}

static inline uint
rcr2(void)
{
80106ab5:	55                   	push   %ebp
80106ab6:	89 e5                	mov    %esp,%ebp
80106ab8:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106abb:	0f 20 d0             	mov    %cr2,%eax
80106abe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106ac1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106ac4:	c9                   	leave  
80106ac5:	c3                   	ret    

80106ac6 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106ac6:	55                   	push   %ebp
80106ac7:	89 e5                	mov    %esp,%ebp
80106ac9:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106acc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106ad3:	e9 c3 00 00 00       	jmp    80106b9b <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106adb:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106ae2:	89 c2                	mov    %eax,%edx
80106ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ae7:	66 89 14 c5 00 5d 11 	mov    %dx,-0x7feea300(,%eax,8)
80106aee:	80 
80106aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106af2:	66 c7 04 c5 02 5d 11 	movw   $0x8,-0x7feea2fe(,%eax,8)
80106af9:	80 08 00 
80106afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aff:	0f b6 14 c5 04 5d 11 	movzbl -0x7feea2fc(,%eax,8),%edx
80106b06:	80 
80106b07:	83 e2 e0             	and    $0xffffffe0,%edx
80106b0a:	88 14 c5 04 5d 11 80 	mov    %dl,-0x7feea2fc(,%eax,8)
80106b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b14:	0f b6 14 c5 04 5d 11 	movzbl -0x7feea2fc(,%eax,8),%edx
80106b1b:	80 
80106b1c:	83 e2 1f             	and    $0x1f,%edx
80106b1f:	88 14 c5 04 5d 11 80 	mov    %dl,-0x7feea2fc(,%eax,8)
80106b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b29:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106b30:	80 
80106b31:	83 e2 f0             	and    $0xfffffff0,%edx
80106b34:	83 ca 0e             	or     $0xe,%edx
80106b37:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b41:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106b48:	80 
80106b49:	83 e2 ef             	and    $0xffffffef,%edx
80106b4c:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b56:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106b5d:	80 
80106b5e:	83 e2 9f             	and    $0xffffff9f,%edx
80106b61:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b6b:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106b72:	80 
80106b73:	83 ca 80             	or     $0xffffff80,%edx
80106b76:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b80:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106b87:	c1 e8 10             	shr    $0x10,%eax
80106b8a:	89 c2                	mov    %eax,%edx
80106b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b8f:	66 89 14 c5 06 5d 11 	mov    %dx,-0x7feea2fa(,%eax,8)
80106b96:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106b97:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b9b:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106ba2:	0f 8e 30 ff ff ff    	jle    80106ad8 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106ba8:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106bad:	66 a3 00 5f 11 80    	mov    %ax,0x80115f00
80106bb3:	66 c7 05 02 5f 11 80 	movw   $0x8,0x80115f02
80106bba:	08 00 
80106bbc:	0f b6 05 04 5f 11 80 	movzbl 0x80115f04,%eax
80106bc3:	83 e0 e0             	and    $0xffffffe0,%eax
80106bc6:	a2 04 5f 11 80       	mov    %al,0x80115f04
80106bcb:	0f b6 05 04 5f 11 80 	movzbl 0x80115f04,%eax
80106bd2:	83 e0 1f             	and    $0x1f,%eax
80106bd5:	a2 04 5f 11 80       	mov    %al,0x80115f04
80106bda:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106be1:	83 c8 0f             	or     $0xf,%eax
80106be4:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106be9:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106bf0:	83 e0 ef             	and    $0xffffffef,%eax
80106bf3:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106bf8:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106bff:	83 c8 60             	or     $0x60,%eax
80106c02:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106c07:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106c0e:	83 c8 80             	or     $0xffffff80,%eax
80106c11:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106c16:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106c1b:	c1 e8 10             	shr    $0x10,%eax
80106c1e:	66 a3 06 5f 11 80    	mov    %ax,0x80115f06

  initlock(&tickslock, "time");
80106c24:	83 ec 08             	sub    $0x8,%esp
80106c27:	68 70 92 10 80       	push   $0x80109270
80106c2c:	68 c0 5c 11 80       	push   $0x80115cc0
80106c31:	e8 7e e6 ff ff       	call   801052b4 <initlock>
80106c36:	83 c4 10             	add    $0x10,%esp
}
80106c39:	90                   	nop
80106c3a:	c9                   	leave  
80106c3b:	c3                   	ret    

80106c3c <idtinit>:

void
idtinit(void)
{
80106c3c:	55                   	push   %ebp
80106c3d:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106c3f:	68 00 08 00 00       	push   $0x800
80106c44:	68 00 5d 11 80       	push   $0x80115d00
80106c49:	e8 3d fe ff ff       	call   80106a8b <lidt>
80106c4e:	83 c4 08             	add    $0x8,%esp
}
80106c51:	90                   	nop
80106c52:	c9                   	leave  
80106c53:	c3                   	ret    

80106c54 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106c54:	55                   	push   %ebp
80106c55:	89 e5                	mov    %esp,%ebp
80106c57:	57                   	push   %edi
80106c58:	56                   	push   %esi
80106c59:	53                   	push   %ebx
80106c5a:	83 ec 2c             	sub    $0x2c,%esp
  siginfo_t si;
  if(tf->trapno == T_SYSCALL){
80106c5d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c60:	8b 40 30             	mov    0x30(%eax),%eax
80106c63:	83 f8 40             	cmp    $0x40,%eax
80106c66:	75 3e                	jne    80106ca6 <trap+0x52>
    if(proc->killed)
80106c68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c6e:	8b 40 24             	mov    0x24(%eax),%eax
80106c71:	85 c0                	test   %eax,%eax
80106c73:	74 05                	je     80106c7a <trap+0x26>
      exit();
80106c75:	e8 b1 dd ff ff       	call   80104a2b <exit>
    proc->tf = tf;
80106c7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c80:	8b 55 08             	mov    0x8(%ebp),%edx
80106c83:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106c86:	e8 89 ec ff ff       	call   80105914 <syscall>
    if(proc->killed)
80106c8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c91:	8b 40 24             	mov    0x24(%eax),%eax
80106c94:	85 c0                	test   %eax,%eax
80106c96:	0f 84 14 03 00 00    	je     80106fb0 <trap+0x35c>
      exit();
80106c9c:	e8 8a dd ff ff       	call   80104a2b <exit>
80106ca1:	e9 0b 03 00 00       	jmp    80106fb1 <trap+0x35d>
    return;
  }

  switch(tf->trapno){
80106ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca9:	8b 40 30             	mov    0x30(%eax),%eax
80106cac:	83 f8 3f             	cmp    $0x3f,%eax
80106caf:	0f 87 b9 01 00 00    	ja     80106e6e <trap+0x21a>
80106cb5:	8b 04 85 5c 93 10 80 	mov    -0x7fef6ca4(,%eax,4),%eax
80106cbc:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106cbe:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106cc4:	0f b6 00             	movzbl (%eax),%eax
80106cc7:	84 c0                	test   %al,%al
80106cc9:	75 3d                	jne    80106d08 <trap+0xb4>
      acquire(&tickslock);
80106ccb:	83 ec 0c             	sub    $0xc,%esp
80106cce:	68 c0 5c 11 80       	push   $0x80115cc0
80106cd3:	e8 fe e5 ff ff       	call   801052d6 <acquire>
80106cd8:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106cdb:	a1 00 65 11 80       	mov    0x80116500,%eax
80106ce0:	83 c0 01             	add    $0x1,%eax
80106ce3:	a3 00 65 11 80       	mov    %eax,0x80116500
      wakeup(&ticks);
80106ce8:	83 ec 0c             	sub    $0xc,%esp
80106ceb:	68 00 65 11 80       	push   $0x80116500
80106cf0:	e8 66 e2 ff ff       	call   80104f5b <wakeup>
80106cf5:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106cf8:	83 ec 0c             	sub    $0xc,%esp
80106cfb:	68 c0 5c 11 80       	push   $0x80115cc0
80106d00:	e8 38 e6 ff ff       	call   8010533d <release>
80106d05:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106d08:	e8 77 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d0d:	e9 18 02 00 00       	jmp    80106f2a <trap+0x2d6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106d12:	e8 80 ba ff ff       	call   80102797 <ideintr>
    lapiceoi();
80106d17:	e8 68 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d1c:	e9 09 02 00 00       	jmp    80106f2a <trap+0x2d6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106d21:	e8 60 c0 ff ff       	call   80102d86 <kbdintr>
    lapiceoi();
80106d26:	e8 59 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d2b:	e9 fa 01 00 00       	jmp    80106f2a <trap+0x2d6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106d30:	e8 5c 04 00 00       	call   80107191 <uartintr>
    lapiceoi();
80106d35:	e8 4a c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d3a:	e9 eb 01 00 00       	jmp    80106f2a <trap+0x2d6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80106d42:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106d45:	8b 45 08             	mov    0x8(%ebp),%eax
80106d48:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d4c:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106d4f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106d55:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d58:	0f b6 c0             	movzbl %al,%eax
80106d5b:	51                   	push   %ecx
80106d5c:	52                   	push   %edx
80106d5d:	50                   	push   %eax
80106d5e:	68 78 92 10 80       	push   $0x80109278
80106d63:	e8 5e 96 ff ff       	call   801003c6 <cprintf>
80106d68:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106d6b:	e8 14 c2 ff ff       	call   80102f84 <lapiceoi>
    break;
80106d70:	e9 b5 01 00 00       	jmp    80106f2a <trap+0x2d6>

   case T_DIVIDE:
      if (proc->handlers[SIGFPE] != (sighandler_t) -1) {
80106d75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d7b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106d81:	83 f8 ff             	cmp    $0xffffffff,%eax
80106d84:	74 26                	je     80106dac <trap+0x158>
        si.type= 1;
80106d86:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
        si.addr = 5;
80106d8d:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%ebp)
        signal_deliver(SIGFPE,si);
80106d94:	83 ec 04             	sub    $0x4,%esp
80106d97:	ff 75 e0             	pushl  -0x20(%ebp)
80106d9a:	ff 75 dc             	pushl  -0x24(%ebp)
80106d9d:	6a 01                	push   $0x1
80106d9f:	e8 71 e3 ff ff       	call   80105115 <signal_deliver>
80106da4:	83 c4 10             	add    $0x10,%esp
        break;
80106da7:	e9 7e 01 00 00       	jmp    80106f2a <trap+0x2d6>
      }
    //handle pgfault with mem_protect
    case T_PGFLT:
      cprintf(" PAGEFULT !! SHARED = %d\n",proc->shared);
80106dac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106db2:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80106db8:	83 ec 08             	sub    $0x8,%esp
80106dbb:	50                   	push   %eax
80106dbc:	68 9c 92 10 80       	push   $0x8010929c
80106dc1:	e8 00 96 ff ff       	call   801003c6 <cprintf>
80106dc6:	83 c4 10             	add    $0x10,%esp

      if(proc->shared == 1){
80106dc9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dcf:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80106dd5:	83 f8 01             	cmp    $0x1,%eax
80106dd8:	75 15                	jne    80106def <trap+0x19b>
        cprintf("DO SOMETHING!\n");
80106dda:	83 ec 0c             	sub    $0xc,%esp
80106ddd:	68 b6 92 10 80       	push   $0x801092b6
80106de2:	e8 df 95 ff ff       	call   801003c6 <cprintf>
80106de7:	83 c4 10             	add    $0x10,%esp
        si.addr = rcr2();
        // cprintf(" PAGE FAULT addr: 0x%x addrtype: 0x%x\n",si.addr,si.type);
        signal_deliver(SIGSEGV,si);
        break;
      } 
      break;
80106dea:	e9 3a 01 00 00       	jmp    80106f29 <trap+0x2d5>
    case T_PGFLT:
      cprintf(" PAGEFULT !! SHARED = %d\n",proc->shared);

      if(proc->shared == 1){
        cprintf("DO SOMETHING!\n");
      } else if (proc->handlers[SIGSEGV] != (sighandler_t) -1) {
80106def:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106df5:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
80106dfb:	83 f8 ff             	cmp    $0xffffffff,%eax
80106dfe:	0f 84 25 01 00 00    	je     80106f29 <trap+0x2d5>
        cprintf("WHY IS THIS HAPPENING?\n");
80106e04:	83 ec 0c             	sub    $0xc,%esp
80106e07:	68 c5 92 10 80       	push   $0x801092c5
80106e0c:	e8 b5 95 ff ff       	call   801003c6 <cprintf>
80106e11:	83 c4 10             	add    $0x10,%esp
        int err = tf->err;
80106e14:	8b 45 08             	mov    0x8(%ebp),%eax
80106e17:	8b 40 34             	mov    0x34(%eax),%eax
80106e1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(err == 0x4 || err == 0x6 || err == 0x5) {
80106e1d:	83 7d e4 04          	cmpl   $0x4,-0x1c(%ebp)
80106e21:	74 0c                	je     80106e2f <trap+0x1db>
80106e23:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
80106e27:	74 06                	je     80106e2f <trap+0x1db>
80106e29:	83 7d e4 05          	cmpl   $0x5,-0x1c(%ebp)
80106e2d:	75 09                	jne    80106e38 <trap+0x1e4>
          si.type = PROT_NONE;
80106e2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106e36:	eb 16                	jmp    80106e4e <trap+0x1fa>
        } else if(err == 0x7) {
80106e38:	83 7d e4 07          	cmpl   $0x7,-0x1c(%ebp)
80106e3c:	75 09                	jne    80106e47 <trap+0x1f3>
          si.type = PROT_READ;
80106e3e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80106e45:	eb 07                	jmp    80106e4e <trap+0x1fa>
        } else {
          si.type = PROT_WRITE;
80106e47:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
        }
        si.addr = rcr2();
80106e4e:	e8 62 fc ff ff       	call   80106ab5 <rcr2>
80106e53:	89 45 dc             	mov    %eax,-0x24(%ebp)
        // cprintf(" PAGE FAULT addr: 0x%x addrtype: 0x%x\n",si.addr,si.type);
        signal_deliver(SIGSEGV,si);
80106e56:	83 ec 04             	sub    $0x4,%esp
80106e59:	ff 75 e0             	pushl  -0x20(%ebp)
80106e5c:	ff 75 dc             	pushl  -0x24(%ebp)
80106e5f:	6a 0e                	push   $0xe
80106e61:	e8 af e2 ff ff       	call   80105115 <signal_deliver>
80106e66:	83 c4 10             	add    $0x10,%esp
        break;
80106e69:	e9 bc 00 00 00       	jmp    80106f2a <trap+0x2d6>
      } 
      break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106e6e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e74:	85 c0                	test   %eax,%eax
80106e76:	74 11                	je     80106e89 <trap+0x235>
80106e78:	8b 45 08             	mov    0x8(%ebp),%eax
80106e7b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e7f:	0f b7 c0             	movzwl %ax,%eax
80106e82:	83 e0 03             	and    $0x3,%eax
80106e85:	85 c0                	test   %eax,%eax
80106e87:	75 40                	jne    80106ec9 <trap+0x275>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e89:	e8 27 fc ff ff       	call   80106ab5 <rcr2>
80106e8e:	89 c3                	mov    %eax,%ebx
80106e90:	8b 45 08             	mov    0x8(%ebp),%eax
80106e93:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106e96:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e9c:	0f b6 00             	movzbl (%eax),%eax

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e9f:	0f b6 d0             	movzbl %al,%edx
80106ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ea5:	8b 40 30             	mov    0x30(%eax),%eax
80106ea8:	83 ec 0c             	sub    $0xc,%esp
80106eab:	53                   	push   %ebx
80106eac:	51                   	push   %ecx
80106ead:	52                   	push   %edx
80106eae:	50                   	push   %eax
80106eaf:	68 e0 92 10 80       	push   $0x801092e0
80106eb4:	e8 0d 95 ff ff       	call   801003c6 <cprintf>
80106eb9:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106ebc:	83 ec 0c             	sub    $0xc,%esp
80106ebf:	68 12 93 10 80       	push   $0x80109312
80106ec4:	e8 9d 96 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ec9:	e8 e7 fb ff ff       	call   80106ab5 <rcr2>
80106ece:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ed4:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106ed7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106edd:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ee0:	0f b6 d8             	movzbl %al,%ebx
80106ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80106ee6:	8b 48 34             	mov    0x34(%eax),%ecx
80106ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80106eec:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106eef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ef5:	8d 78 6c             	lea    0x6c(%eax),%edi
80106ef8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106efe:	8b 40 10             	mov    0x10(%eax),%eax
80106f01:	ff 75 d4             	pushl  -0x2c(%ebp)
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	51                   	push   %ecx
80106f07:	52                   	push   %edx
80106f08:	57                   	push   %edi
80106f09:	50                   	push   %eax
80106f0a:	68 18 93 10 80       	push   $0x80109318
80106f0f:	e8 b2 94 ff ff       	call   801003c6 <cprintf>
80106f14:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
            rcr2());
    proc->killed = 1;
80106f17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f1d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106f24:	eb 04                	jmp    80106f2a <trap+0x2d6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106f26:	90                   	nop
80106f27:	eb 01                	jmp    80106f2a <trap+0x2d6>
        si.addr = rcr2();
        // cprintf(" PAGE FAULT addr: 0x%x addrtype: 0x%x\n",si.addr,si.type);
        signal_deliver(SIGSEGV,si);
        break;
      } 
      break;
80106f29:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106f2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f30:	85 c0                	test   %eax,%eax
80106f32:	74 24                	je     80106f58 <trap+0x304>
80106f34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f3a:	8b 40 24             	mov    0x24(%eax),%eax
80106f3d:	85 c0                	test   %eax,%eax
80106f3f:	74 17                	je     80106f58 <trap+0x304>
80106f41:	8b 45 08             	mov    0x8(%ebp),%eax
80106f44:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f48:	0f b7 c0             	movzwl %ax,%eax
80106f4b:	83 e0 03             	and    $0x3,%eax
80106f4e:	83 f8 03             	cmp    $0x3,%eax
80106f51:	75 05                	jne    80106f58 <trap+0x304>
    exit();
80106f53:	e8 d3 da ff ff       	call   80104a2b <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106f58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f5e:	85 c0                	test   %eax,%eax
80106f60:	74 1e                	je     80106f80 <trap+0x32c>
80106f62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f68:	8b 40 0c             	mov    0xc(%eax),%eax
80106f6b:	83 f8 04             	cmp    $0x4,%eax
80106f6e:	75 10                	jne    80106f80 <trap+0x32c>
80106f70:	8b 45 08             	mov    0x8(%ebp),%eax
80106f73:	8b 40 30             	mov    0x30(%eax),%eax
80106f76:	83 f8 20             	cmp    $0x20,%eax
80106f79:	75 05                	jne    80106f80 <trap+0x32c>
    yield();
80106f7b:	e8 81 de ff ff       	call   80104e01 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106f80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f86:	85 c0                	test   %eax,%eax
80106f88:	74 27                	je     80106fb1 <trap+0x35d>
80106f8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f90:	8b 40 24             	mov    0x24(%eax),%eax
80106f93:	85 c0                	test   %eax,%eax
80106f95:	74 1a                	je     80106fb1 <trap+0x35d>
80106f97:	8b 45 08             	mov    0x8(%ebp),%eax
80106f9a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f9e:	0f b7 c0             	movzwl %ax,%eax
80106fa1:	83 e0 03             	and    $0x3,%eax
80106fa4:	83 f8 03             	cmp    $0x3,%eax
80106fa7:	75 08                	jne    80106fb1 <trap+0x35d>
    exit();
80106fa9:	e8 7d da ff ff       	call   80104a2b <exit>
80106fae:	eb 01                	jmp    80106fb1 <trap+0x35d>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106fb0:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fb4:	5b                   	pop    %ebx
80106fb5:	5e                   	pop    %esi
80106fb6:	5f                   	pop    %edi
80106fb7:	5d                   	pop    %ebp
80106fb8:	c3                   	ret    

80106fb9 <inb>:
80106fb9:	55                   	push   %ebp
80106fba:	89 e5                	mov    %esp,%ebp
80106fbc:	83 ec 14             	sub    $0x14,%esp
80106fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80106fc2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
80106fc6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106fca:	89 c2                	mov    %eax,%edx
80106fcc:	ec                   	in     (%dx),%al
80106fcd:	88 45 ff             	mov    %al,-0x1(%ebp)
80106fd0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80106fd4:	c9                   	leave  
80106fd5:	c3                   	ret    

80106fd6 <outb>:
80106fd6:	55                   	push   %ebp
80106fd7:	89 e5                	mov    %esp,%ebp
80106fd9:	83 ec 08             	sub    $0x8,%esp
80106fdc:	8b 55 08             	mov    0x8(%ebp),%edx
80106fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fe2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106fe6:	88 45 f8             	mov    %al,-0x8(%ebp)
80106fe9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106fed:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106ff1:	ee                   	out    %al,(%dx)
80106ff2:	90                   	nop
80106ff3:	c9                   	leave  
80106ff4:	c3                   	ret    

80106ff5 <uartinit>:
80106ff5:	55                   	push   %ebp
80106ff6:	89 e5                	mov    %esp,%ebp
80106ff8:	83 ec 18             	sub    $0x18,%esp
80106ffb:	6a 00                	push   $0x0
80106ffd:	68 fa 03 00 00       	push   $0x3fa
80107002:	e8 cf ff ff ff       	call   80106fd6 <outb>
80107007:	83 c4 08             	add    $0x8,%esp
8010700a:	68 80 00 00 00       	push   $0x80
8010700f:	68 fb 03 00 00       	push   $0x3fb
80107014:	e8 bd ff ff ff       	call   80106fd6 <outb>
80107019:	83 c4 08             	add    $0x8,%esp
8010701c:	6a 0c                	push   $0xc
8010701e:	68 f8 03 00 00       	push   $0x3f8
80107023:	e8 ae ff ff ff       	call   80106fd6 <outb>
80107028:	83 c4 08             	add    $0x8,%esp
8010702b:	6a 00                	push   $0x0
8010702d:	68 f9 03 00 00       	push   $0x3f9
80107032:	e8 9f ff ff ff       	call   80106fd6 <outb>
80107037:	83 c4 08             	add    $0x8,%esp
8010703a:	6a 03                	push   $0x3
8010703c:	68 fb 03 00 00       	push   $0x3fb
80107041:	e8 90 ff ff ff       	call   80106fd6 <outb>
80107046:	83 c4 08             	add    $0x8,%esp
80107049:	6a 00                	push   $0x0
8010704b:	68 fc 03 00 00       	push   $0x3fc
80107050:	e8 81 ff ff ff       	call   80106fd6 <outb>
80107055:	83 c4 08             	add    $0x8,%esp
80107058:	6a 01                	push   $0x1
8010705a:	68 f9 03 00 00       	push   $0x3f9
8010705f:	e8 72 ff ff ff       	call   80106fd6 <outb>
80107064:	83 c4 08             	add    $0x8,%esp
80107067:	68 fd 03 00 00       	push   $0x3fd
8010706c:	e8 48 ff ff ff       	call   80106fb9 <inb>
80107071:	83 c4 04             	add    $0x4,%esp
80107074:	3c ff                	cmp    $0xff,%al
80107076:	74 6e                	je     801070e6 <uartinit+0xf1>
80107078:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
8010707f:	00 00 00 
80107082:	68 fa 03 00 00       	push   $0x3fa
80107087:	e8 2d ff ff ff       	call   80106fb9 <inb>
8010708c:	83 c4 04             	add    $0x4,%esp
8010708f:	68 f8 03 00 00       	push   $0x3f8
80107094:	e8 20 ff ff ff       	call   80106fb9 <inb>
80107099:	83 c4 04             	add    $0x4,%esp
8010709c:	83 ec 0c             	sub    $0xc,%esp
8010709f:	6a 04                	push   $0x4
801070a1:	e8 d6 cd ff ff       	call   80103e7c <picenable>
801070a6:	83 c4 10             	add    $0x10,%esp
801070a9:	83 ec 08             	sub    $0x8,%esp
801070ac:	6a 00                	push   $0x0
801070ae:	6a 04                	push   $0x4
801070b0:	e8 84 b9 ff ff       	call   80102a39 <ioapicenable>
801070b5:	83 c4 10             	add    $0x10,%esp
801070b8:	c7 45 f4 5c 94 10 80 	movl   $0x8010945c,-0xc(%ebp)
801070bf:	eb 19                	jmp    801070da <uartinit+0xe5>
801070c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070c4:	0f b6 00             	movzbl (%eax),%eax
801070c7:	0f be c0             	movsbl %al,%eax
801070ca:	83 ec 0c             	sub    $0xc,%esp
801070cd:	50                   	push   %eax
801070ce:	e8 16 00 00 00       	call   801070e9 <uartputc>
801070d3:	83 c4 10             	add    $0x10,%esp
801070d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801070da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070dd:	0f b6 00             	movzbl (%eax),%eax
801070e0:	84 c0                	test   %al,%al
801070e2:	75 dd                	jne    801070c1 <uartinit+0xcc>
801070e4:	eb 01                	jmp    801070e7 <uartinit+0xf2>
801070e6:	90                   	nop
801070e7:	c9                   	leave  
801070e8:	c3                   	ret    

801070e9 <uartputc>:
801070e9:	55                   	push   %ebp
801070ea:	89 e5                	mov    %esp,%ebp
801070ec:	83 ec 18             	sub    $0x18,%esp
801070ef:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801070f4:	85 c0                	test   %eax,%eax
801070f6:	74 53                	je     8010714b <uartputc+0x62>
801070f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801070ff:	eb 11                	jmp    80107112 <uartputc+0x29>
80107101:	83 ec 0c             	sub    $0xc,%esp
80107104:	6a 0a                	push   $0xa
80107106:	e8 94 be ff ff       	call   80102f9f <microdelay>
8010710b:	83 c4 10             	add    $0x10,%esp
8010710e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107112:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107116:	7f 1a                	jg     80107132 <uartputc+0x49>
80107118:	83 ec 0c             	sub    $0xc,%esp
8010711b:	68 fd 03 00 00       	push   $0x3fd
80107120:	e8 94 fe ff ff       	call   80106fb9 <inb>
80107125:	83 c4 10             	add    $0x10,%esp
80107128:	0f b6 c0             	movzbl %al,%eax
8010712b:	83 e0 20             	and    $0x20,%eax
8010712e:	85 c0                	test   %eax,%eax
80107130:	74 cf                	je     80107101 <uartputc+0x18>
80107132:	8b 45 08             	mov    0x8(%ebp),%eax
80107135:	0f b6 c0             	movzbl %al,%eax
80107138:	83 ec 08             	sub    $0x8,%esp
8010713b:	50                   	push   %eax
8010713c:	68 f8 03 00 00       	push   $0x3f8
80107141:	e8 90 fe ff ff       	call   80106fd6 <outb>
80107146:	83 c4 10             	add    $0x10,%esp
80107149:	eb 01                	jmp    8010714c <uartputc+0x63>
8010714b:	90                   	nop
8010714c:	c9                   	leave  
8010714d:	c3                   	ret    

8010714e <uartgetc>:
8010714e:	55                   	push   %ebp
8010714f:	89 e5                	mov    %esp,%ebp
80107151:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107156:	85 c0                	test   %eax,%eax
80107158:	75 07                	jne    80107161 <uartgetc+0x13>
8010715a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010715f:	eb 2e                	jmp    8010718f <uartgetc+0x41>
80107161:	68 fd 03 00 00       	push   $0x3fd
80107166:	e8 4e fe ff ff       	call   80106fb9 <inb>
8010716b:	83 c4 04             	add    $0x4,%esp
8010716e:	0f b6 c0             	movzbl %al,%eax
80107171:	83 e0 01             	and    $0x1,%eax
80107174:	85 c0                	test   %eax,%eax
80107176:	75 07                	jne    8010717f <uartgetc+0x31>
80107178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010717d:	eb 10                	jmp    8010718f <uartgetc+0x41>
8010717f:	68 f8 03 00 00       	push   $0x3f8
80107184:	e8 30 fe ff ff       	call   80106fb9 <inb>
80107189:	83 c4 04             	add    $0x4,%esp
8010718c:	0f b6 c0             	movzbl %al,%eax
8010718f:	c9                   	leave  
80107190:	c3                   	ret    

80107191 <uartintr>:
80107191:	55                   	push   %ebp
80107192:	89 e5                	mov    %esp,%ebp
80107194:	83 ec 08             	sub    $0x8,%esp
80107197:	83 ec 0c             	sub    $0xc,%esp
8010719a:	68 4e 71 10 80       	push   $0x8010714e
8010719f:	e8 39 96 ff ff       	call   801007dd <consoleintr>
801071a4:	83 c4 10             	add    $0x10,%esp
801071a7:	90                   	nop
801071a8:	c9                   	leave  
801071a9:	c3                   	ret    

801071aa <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $0
801071ac:	6a 00                	push   $0x0
  jmp alltraps
801071ae:	e9 ad f8 ff ff       	jmp    80106a60 <alltraps>

801071b3 <vector1>:
.globl vector1
vector1:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $1
801071b5:	6a 01                	push   $0x1
  jmp alltraps
801071b7:	e9 a4 f8 ff ff       	jmp    80106a60 <alltraps>

801071bc <vector2>:
.globl vector2
vector2:
  pushl $0
801071bc:	6a 00                	push   $0x0
  pushl $2
801071be:	6a 02                	push   $0x2
  jmp alltraps
801071c0:	e9 9b f8 ff ff       	jmp    80106a60 <alltraps>

801071c5 <vector3>:
.globl vector3
vector3:
  pushl $0
801071c5:	6a 00                	push   $0x0
  pushl $3
801071c7:	6a 03                	push   $0x3
  jmp alltraps
801071c9:	e9 92 f8 ff ff       	jmp    80106a60 <alltraps>

801071ce <vector4>:
.globl vector4
vector4:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $4
801071d0:	6a 04                	push   $0x4
  jmp alltraps
801071d2:	e9 89 f8 ff ff       	jmp    80106a60 <alltraps>

801071d7 <vector5>:
.globl vector5
vector5:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $5
801071d9:	6a 05                	push   $0x5
  jmp alltraps
801071db:	e9 80 f8 ff ff       	jmp    80106a60 <alltraps>

801071e0 <vector6>:
.globl vector6
vector6:
  pushl $0
801071e0:	6a 00                	push   $0x0
  pushl $6
801071e2:	6a 06                	push   $0x6
  jmp alltraps
801071e4:	e9 77 f8 ff ff       	jmp    80106a60 <alltraps>

801071e9 <vector7>:
.globl vector7
vector7:
  pushl $0
801071e9:	6a 00                	push   $0x0
  pushl $7
801071eb:	6a 07                	push   $0x7
  jmp alltraps
801071ed:	e9 6e f8 ff ff       	jmp    80106a60 <alltraps>

801071f2 <vector8>:
.globl vector8
vector8:
  pushl $8
801071f2:	6a 08                	push   $0x8
  jmp alltraps
801071f4:	e9 67 f8 ff ff       	jmp    80106a60 <alltraps>

801071f9 <vector9>:
.globl vector9
vector9:
  pushl $0
801071f9:	6a 00                	push   $0x0
  pushl $9
801071fb:	6a 09                	push   $0x9
  jmp alltraps
801071fd:	e9 5e f8 ff ff       	jmp    80106a60 <alltraps>

80107202 <vector10>:
.globl vector10
vector10:
  pushl $10
80107202:	6a 0a                	push   $0xa
  jmp alltraps
80107204:	e9 57 f8 ff ff       	jmp    80106a60 <alltraps>

80107209 <vector11>:
.globl vector11
vector11:
  pushl $11
80107209:	6a 0b                	push   $0xb
  jmp alltraps
8010720b:	e9 50 f8 ff ff       	jmp    80106a60 <alltraps>

80107210 <vector12>:
.globl vector12
vector12:
  pushl $12
80107210:	6a 0c                	push   $0xc
  jmp alltraps
80107212:	e9 49 f8 ff ff       	jmp    80106a60 <alltraps>

80107217 <vector13>:
.globl vector13
vector13:
  pushl $13
80107217:	6a 0d                	push   $0xd
  jmp alltraps
80107219:	e9 42 f8 ff ff       	jmp    80106a60 <alltraps>

8010721e <vector14>:
.globl vector14
vector14:
  pushl $14
8010721e:	6a 0e                	push   $0xe
  jmp alltraps
80107220:	e9 3b f8 ff ff       	jmp    80106a60 <alltraps>

80107225 <vector15>:
.globl vector15
vector15:
  pushl $0
80107225:	6a 00                	push   $0x0
  pushl $15
80107227:	6a 0f                	push   $0xf
  jmp alltraps
80107229:	e9 32 f8 ff ff       	jmp    80106a60 <alltraps>

8010722e <vector16>:
.globl vector16
vector16:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $16
80107230:	6a 10                	push   $0x10
  jmp alltraps
80107232:	e9 29 f8 ff ff       	jmp    80106a60 <alltraps>

80107237 <vector17>:
.globl vector17
vector17:
  pushl $17
80107237:	6a 11                	push   $0x11
  jmp alltraps
80107239:	e9 22 f8 ff ff       	jmp    80106a60 <alltraps>

8010723e <vector18>:
.globl vector18
vector18:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $18
80107240:	6a 12                	push   $0x12
  jmp alltraps
80107242:	e9 19 f8 ff ff       	jmp    80106a60 <alltraps>

80107247 <vector19>:
.globl vector19
vector19:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $19
80107249:	6a 13                	push   $0x13
  jmp alltraps
8010724b:	e9 10 f8 ff ff       	jmp    80106a60 <alltraps>

80107250 <vector20>:
.globl vector20
vector20:
  pushl $0
80107250:	6a 00                	push   $0x0
  pushl $20
80107252:	6a 14                	push   $0x14
  jmp alltraps
80107254:	e9 07 f8 ff ff       	jmp    80106a60 <alltraps>

80107259 <vector21>:
.globl vector21
vector21:
  pushl $0
80107259:	6a 00                	push   $0x0
  pushl $21
8010725b:	6a 15                	push   $0x15
  jmp alltraps
8010725d:	e9 fe f7 ff ff       	jmp    80106a60 <alltraps>

80107262 <vector22>:
.globl vector22
vector22:
  pushl $0
80107262:	6a 00                	push   $0x0
  pushl $22
80107264:	6a 16                	push   $0x16
  jmp alltraps
80107266:	e9 f5 f7 ff ff       	jmp    80106a60 <alltraps>

8010726b <vector23>:
.globl vector23
vector23:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $23
8010726d:	6a 17                	push   $0x17
  jmp alltraps
8010726f:	e9 ec f7 ff ff       	jmp    80106a60 <alltraps>

80107274 <vector24>:
.globl vector24
vector24:
  pushl $0
80107274:	6a 00                	push   $0x0
  pushl $24
80107276:	6a 18                	push   $0x18
  jmp alltraps
80107278:	e9 e3 f7 ff ff       	jmp    80106a60 <alltraps>

8010727d <vector25>:
.globl vector25
vector25:
  pushl $0
8010727d:	6a 00                	push   $0x0
  pushl $25
8010727f:	6a 19                	push   $0x19
  jmp alltraps
80107281:	e9 da f7 ff ff       	jmp    80106a60 <alltraps>

80107286 <vector26>:
.globl vector26
vector26:
  pushl $0
80107286:	6a 00                	push   $0x0
  pushl $26
80107288:	6a 1a                	push   $0x1a
  jmp alltraps
8010728a:	e9 d1 f7 ff ff       	jmp    80106a60 <alltraps>

8010728f <vector27>:
.globl vector27
vector27:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $27
80107291:	6a 1b                	push   $0x1b
  jmp alltraps
80107293:	e9 c8 f7 ff ff       	jmp    80106a60 <alltraps>

80107298 <vector28>:
.globl vector28
vector28:
  pushl $0
80107298:	6a 00                	push   $0x0
  pushl $28
8010729a:	6a 1c                	push   $0x1c
  jmp alltraps
8010729c:	e9 bf f7 ff ff       	jmp    80106a60 <alltraps>

801072a1 <vector29>:
.globl vector29
vector29:
  pushl $0
801072a1:	6a 00                	push   $0x0
  pushl $29
801072a3:	6a 1d                	push   $0x1d
  jmp alltraps
801072a5:	e9 b6 f7 ff ff       	jmp    80106a60 <alltraps>

801072aa <vector30>:
.globl vector30
vector30:
  pushl $0
801072aa:	6a 00                	push   $0x0
  pushl $30
801072ac:	6a 1e                	push   $0x1e
  jmp alltraps
801072ae:	e9 ad f7 ff ff       	jmp    80106a60 <alltraps>

801072b3 <vector31>:
.globl vector31
vector31:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $31
801072b5:	6a 1f                	push   $0x1f
  jmp alltraps
801072b7:	e9 a4 f7 ff ff       	jmp    80106a60 <alltraps>

801072bc <vector32>:
.globl vector32
vector32:
  pushl $0
801072bc:	6a 00                	push   $0x0
  pushl $32
801072be:	6a 20                	push   $0x20
  jmp alltraps
801072c0:	e9 9b f7 ff ff       	jmp    80106a60 <alltraps>

801072c5 <vector33>:
.globl vector33
vector33:
  pushl $0
801072c5:	6a 00                	push   $0x0
  pushl $33
801072c7:	6a 21                	push   $0x21
  jmp alltraps
801072c9:	e9 92 f7 ff ff       	jmp    80106a60 <alltraps>

801072ce <vector34>:
.globl vector34
vector34:
  pushl $0
801072ce:	6a 00                	push   $0x0
  pushl $34
801072d0:	6a 22                	push   $0x22
  jmp alltraps
801072d2:	e9 89 f7 ff ff       	jmp    80106a60 <alltraps>

801072d7 <vector35>:
.globl vector35
vector35:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $35
801072d9:	6a 23                	push   $0x23
  jmp alltraps
801072db:	e9 80 f7 ff ff       	jmp    80106a60 <alltraps>

801072e0 <vector36>:
.globl vector36
vector36:
  pushl $0
801072e0:	6a 00                	push   $0x0
  pushl $36
801072e2:	6a 24                	push   $0x24
  jmp alltraps
801072e4:	e9 77 f7 ff ff       	jmp    80106a60 <alltraps>

801072e9 <vector37>:
.globl vector37
vector37:
  pushl $0
801072e9:	6a 00                	push   $0x0
  pushl $37
801072eb:	6a 25                	push   $0x25
  jmp alltraps
801072ed:	e9 6e f7 ff ff       	jmp    80106a60 <alltraps>

801072f2 <vector38>:
.globl vector38
vector38:
  pushl $0
801072f2:	6a 00                	push   $0x0
  pushl $38
801072f4:	6a 26                	push   $0x26
  jmp alltraps
801072f6:	e9 65 f7 ff ff       	jmp    80106a60 <alltraps>

801072fb <vector39>:
.globl vector39
vector39:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $39
801072fd:	6a 27                	push   $0x27
  jmp alltraps
801072ff:	e9 5c f7 ff ff       	jmp    80106a60 <alltraps>

80107304 <vector40>:
.globl vector40
vector40:
  pushl $0
80107304:	6a 00                	push   $0x0
  pushl $40
80107306:	6a 28                	push   $0x28
  jmp alltraps
80107308:	e9 53 f7 ff ff       	jmp    80106a60 <alltraps>

8010730d <vector41>:
.globl vector41
vector41:
  pushl $0
8010730d:	6a 00                	push   $0x0
  pushl $41
8010730f:	6a 29                	push   $0x29
  jmp alltraps
80107311:	e9 4a f7 ff ff       	jmp    80106a60 <alltraps>

80107316 <vector42>:
.globl vector42
vector42:
  pushl $0
80107316:	6a 00                	push   $0x0
  pushl $42
80107318:	6a 2a                	push   $0x2a
  jmp alltraps
8010731a:	e9 41 f7 ff ff       	jmp    80106a60 <alltraps>

8010731f <vector43>:
.globl vector43
vector43:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $43
80107321:	6a 2b                	push   $0x2b
  jmp alltraps
80107323:	e9 38 f7 ff ff       	jmp    80106a60 <alltraps>

80107328 <vector44>:
.globl vector44
vector44:
  pushl $0
80107328:	6a 00                	push   $0x0
  pushl $44
8010732a:	6a 2c                	push   $0x2c
  jmp alltraps
8010732c:	e9 2f f7 ff ff       	jmp    80106a60 <alltraps>

80107331 <vector45>:
.globl vector45
vector45:
  pushl $0
80107331:	6a 00                	push   $0x0
  pushl $45
80107333:	6a 2d                	push   $0x2d
  jmp alltraps
80107335:	e9 26 f7 ff ff       	jmp    80106a60 <alltraps>

8010733a <vector46>:
.globl vector46
vector46:
  pushl $0
8010733a:	6a 00                	push   $0x0
  pushl $46
8010733c:	6a 2e                	push   $0x2e
  jmp alltraps
8010733e:	e9 1d f7 ff ff       	jmp    80106a60 <alltraps>

80107343 <vector47>:
.globl vector47
vector47:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $47
80107345:	6a 2f                	push   $0x2f
  jmp alltraps
80107347:	e9 14 f7 ff ff       	jmp    80106a60 <alltraps>

8010734c <vector48>:
.globl vector48
vector48:
  pushl $0
8010734c:	6a 00                	push   $0x0
  pushl $48
8010734e:	6a 30                	push   $0x30
  jmp alltraps
80107350:	e9 0b f7 ff ff       	jmp    80106a60 <alltraps>

80107355 <vector49>:
.globl vector49
vector49:
  pushl $0
80107355:	6a 00                	push   $0x0
  pushl $49
80107357:	6a 31                	push   $0x31
  jmp alltraps
80107359:	e9 02 f7 ff ff       	jmp    80106a60 <alltraps>

8010735e <vector50>:
.globl vector50
vector50:
  pushl $0
8010735e:	6a 00                	push   $0x0
  pushl $50
80107360:	6a 32                	push   $0x32
  jmp alltraps
80107362:	e9 f9 f6 ff ff       	jmp    80106a60 <alltraps>

80107367 <vector51>:
.globl vector51
vector51:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $51
80107369:	6a 33                	push   $0x33
  jmp alltraps
8010736b:	e9 f0 f6 ff ff       	jmp    80106a60 <alltraps>

80107370 <vector52>:
.globl vector52
vector52:
  pushl $0
80107370:	6a 00                	push   $0x0
  pushl $52
80107372:	6a 34                	push   $0x34
  jmp alltraps
80107374:	e9 e7 f6 ff ff       	jmp    80106a60 <alltraps>

80107379 <vector53>:
.globl vector53
vector53:
  pushl $0
80107379:	6a 00                	push   $0x0
  pushl $53
8010737b:	6a 35                	push   $0x35
  jmp alltraps
8010737d:	e9 de f6 ff ff       	jmp    80106a60 <alltraps>

80107382 <vector54>:
.globl vector54
vector54:
  pushl $0
80107382:	6a 00                	push   $0x0
  pushl $54
80107384:	6a 36                	push   $0x36
  jmp alltraps
80107386:	e9 d5 f6 ff ff       	jmp    80106a60 <alltraps>

8010738b <vector55>:
.globl vector55
vector55:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $55
8010738d:	6a 37                	push   $0x37
  jmp alltraps
8010738f:	e9 cc f6 ff ff       	jmp    80106a60 <alltraps>

80107394 <vector56>:
.globl vector56
vector56:
  pushl $0
80107394:	6a 00                	push   $0x0
  pushl $56
80107396:	6a 38                	push   $0x38
  jmp alltraps
80107398:	e9 c3 f6 ff ff       	jmp    80106a60 <alltraps>

8010739d <vector57>:
.globl vector57
vector57:
  pushl $0
8010739d:	6a 00                	push   $0x0
  pushl $57
8010739f:	6a 39                	push   $0x39
  jmp alltraps
801073a1:	e9 ba f6 ff ff       	jmp    80106a60 <alltraps>

801073a6 <vector58>:
.globl vector58
vector58:
  pushl $0
801073a6:	6a 00                	push   $0x0
  pushl $58
801073a8:	6a 3a                	push   $0x3a
  jmp alltraps
801073aa:	e9 b1 f6 ff ff       	jmp    80106a60 <alltraps>

801073af <vector59>:
.globl vector59
vector59:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $59
801073b1:	6a 3b                	push   $0x3b
  jmp alltraps
801073b3:	e9 a8 f6 ff ff       	jmp    80106a60 <alltraps>

801073b8 <vector60>:
.globl vector60
vector60:
  pushl $0
801073b8:	6a 00                	push   $0x0
  pushl $60
801073ba:	6a 3c                	push   $0x3c
  jmp alltraps
801073bc:	e9 9f f6 ff ff       	jmp    80106a60 <alltraps>

801073c1 <vector61>:
.globl vector61
vector61:
  pushl $0
801073c1:	6a 00                	push   $0x0
  pushl $61
801073c3:	6a 3d                	push   $0x3d
  jmp alltraps
801073c5:	e9 96 f6 ff ff       	jmp    80106a60 <alltraps>

801073ca <vector62>:
.globl vector62
vector62:
  pushl $0
801073ca:	6a 00                	push   $0x0
  pushl $62
801073cc:	6a 3e                	push   $0x3e
  jmp alltraps
801073ce:	e9 8d f6 ff ff       	jmp    80106a60 <alltraps>

801073d3 <vector63>:
.globl vector63
vector63:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $63
801073d5:	6a 3f                	push   $0x3f
  jmp alltraps
801073d7:	e9 84 f6 ff ff       	jmp    80106a60 <alltraps>

801073dc <vector64>:
.globl vector64
vector64:
  pushl $0
801073dc:	6a 00                	push   $0x0
  pushl $64
801073de:	6a 40                	push   $0x40
  jmp alltraps
801073e0:	e9 7b f6 ff ff       	jmp    80106a60 <alltraps>

801073e5 <vector65>:
.globl vector65
vector65:
  pushl $0
801073e5:	6a 00                	push   $0x0
  pushl $65
801073e7:	6a 41                	push   $0x41
  jmp alltraps
801073e9:	e9 72 f6 ff ff       	jmp    80106a60 <alltraps>

801073ee <vector66>:
.globl vector66
vector66:
  pushl $0
801073ee:	6a 00                	push   $0x0
  pushl $66
801073f0:	6a 42                	push   $0x42
  jmp alltraps
801073f2:	e9 69 f6 ff ff       	jmp    80106a60 <alltraps>

801073f7 <vector67>:
.globl vector67
vector67:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $67
801073f9:	6a 43                	push   $0x43
  jmp alltraps
801073fb:	e9 60 f6 ff ff       	jmp    80106a60 <alltraps>

80107400 <vector68>:
.globl vector68
vector68:
  pushl $0
80107400:	6a 00                	push   $0x0
  pushl $68
80107402:	6a 44                	push   $0x44
  jmp alltraps
80107404:	e9 57 f6 ff ff       	jmp    80106a60 <alltraps>

80107409 <vector69>:
.globl vector69
vector69:
  pushl $0
80107409:	6a 00                	push   $0x0
  pushl $69
8010740b:	6a 45                	push   $0x45
  jmp alltraps
8010740d:	e9 4e f6 ff ff       	jmp    80106a60 <alltraps>

80107412 <vector70>:
.globl vector70
vector70:
  pushl $0
80107412:	6a 00                	push   $0x0
  pushl $70
80107414:	6a 46                	push   $0x46
  jmp alltraps
80107416:	e9 45 f6 ff ff       	jmp    80106a60 <alltraps>

8010741b <vector71>:
.globl vector71
vector71:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $71
8010741d:	6a 47                	push   $0x47
  jmp alltraps
8010741f:	e9 3c f6 ff ff       	jmp    80106a60 <alltraps>

80107424 <vector72>:
.globl vector72
vector72:
  pushl $0
80107424:	6a 00                	push   $0x0
  pushl $72
80107426:	6a 48                	push   $0x48
  jmp alltraps
80107428:	e9 33 f6 ff ff       	jmp    80106a60 <alltraps>

8010742d <vector73>:
.globl vector73
vector73:
  pushl $0
8010742d:	6a 00                	push   $0x0
  pushl $73
8010742f:	6a 49                	push   $0x49
  jmp alltraps
80107431:	e9 2a f6 ff ff       	jmp    80106a60 <alltraps>

80107436 <vector74>:
.globl vector74
vector74:
  pushl $0
80107436:	6a 00                	push   $0x0
  pushl $74
80107438:	6a 4a                	push   $0x4a
  jmp alltraps
8010743a:	e9 21 f6 ff ff       	jmp    80106a60 <alltraps>

8010743f <vector75>:
.globl vector75
vector75:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $75
80107441:	6a 4b                	push   $0x4b
  jmp alltraps
80107443:	e9 18 f6 ff ff       	jmp    80106a60 <alltraps>

80107448 <vector76>:
.globl vector76
vector76:
  pushl $0
80107448:	6a 00                	push   $0x0
  pushl $76
8010744a:	6a 4c                	push   $0x4c
  jmp alltraps
8010744c:	e9 0f f6 ff ff       	jmp    80106a60 <alltraps>

80107451 <vector77>:
.globl vector77
vector77:
  pushl $0
80107451:	6a 00                	push   $0x0
  pushl $77
80107453:	6a 4d                	push   $0x4d
  jmp alltraps
80107455:	e9 06 f6 ff ff       	jmp    80106a60 <alltraps>

8010745a <vector78>:
.globl vector78
vector78:
  pushl $0
8010745a:	6a 00                	push   $0x0
  pushl $78
8010745c:	6a 4e                	push   $0x4e
  jmp alltraps
8010745e:	e9 fd f5 ff ff       	jmp    80106a60 <alltraps>

80107463 <vector79>:
.globl vector79
vector79:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $79
80107465:	6a 4f                	push   $0x4f
  jmp alltraps
80107467:	e9 f4 f5 ff ff       	jmp    80106a60 <alltraps>

8010746c <vector80>:
.globl vector80
vector80:
  pushl $0
8010746c:	6a 00                	push   $0x0
  pushl $80
8010746e:	6a 50                	push   $0x50
  jmp alltraps
80107470:	e9 eb f5 ff ff       	jmp    80106a60 <alltraps>

80107475 <vector81>:
.globl vector81
vector81:
  pushl $0
80107475:	6a 00                	push   $0x0
  pushl $81
80107477:	6a 51                	push   $0x51
  jmp alltraps
80107479:	e9 e2 f5 ff ff       	jmp    80106a60 <alltraps>

8010747e <vector82>:
.globl vector82
vector82:
  pushl $0
8010747e:	6a 00                	push   $0x0
  pushl $82
80107480:	6a 52                	push   $0x52
  jmp alltraps
80107482:	e9 d9 f5 ff ff       	jmp    80106a60 <alltraps>

80107487 <vector83>:
.globl vector83
vector83:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $83
80107489:	6a 53                	push   $0x53
  jmp alltraps
8010748b:	e9 d0 f5 ff ff       	jmp    80106a60 <alltraps>

80107490 <vector84>:
.globl vector84
vector84:
  pushl $0
80107490:	6a 00                	push   $0x0
  pushl $84
80107492:	6a 54                	push   $0x54
  jmp alltraps
80107494:	e9 c7 f5 ff ff       	jmp    80106a60 <alltraps>

80107499 <vector85>:
.globl vector85
vector85:
  pushl $0
80107499:	6a 00                	push   $0x0
  pushl $85
8010749b:	6a 55                	push   $0x55
  jmp alltraps
8010749d:	e9 be f5 ff ff       	jmp    80106a60 <alltraps>

801074a2 <vector86>:
.globl vector86
vector86:
  pushl $0
801074a2:	6a 00                	push   $0x0
  pushl $86
801074a4:	6a 56                	push   $0x56
  jmp alltraps
801074a6:	e9 b5 f5 ff ff       	jmp    80106a60 <alltraps>

801074ab <vector87>:
.globl vector87
vector87:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $87
801074ad:	6a 57                	push   $0x57
  jmp alltraps
801074af:	e9 ac f5 ff ff       	jmp    80106a60 <alltraps>

801074b4 <vector88>:
.globl vector88
vector88:
  pushl $0
801074b4:	6a 00                	push   $0x0
  pushl $88
801074b6:	6a 58                	push   $0x58
  jmp alltraps
801074b8:	e9 a3 f5 ff ff       	jmp    80106a60 <alltraps>

801074bd <vector89>:
.globl vector89
vector89:
  pushl $0
801074bd:	6a 00                	push   $0x0
  pushl $89
801074bf:	6a 59                	push   $0x59
  jmp alltraps
801074c1:	e9 9a f5 ff ff       	jmp    80106a60 <alltraps>

801074c6 <vector90>:
.globl vector90
vector90:
  pushl $0
801074c6:	6a 00                	push   $0x0
  pushl $90
801074c8:	6a 5a                	push   $0x5a
  jmp alltraps
801074ca:	e9 91 f5 ff ff       	jmp    80106a60 <alltraps>

801074cf <vector91>:
.globl vector91
vector91:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $91
801074d1:	6a 5b                	push   $0x5b
  jmp alltraps
801074d3:	e9 88 f5 ff ff       	jmp    80106a60 <alltraps>

801074d8 <vector92>:
.globl vector92
vector92:
  pushl $0
801074d8:	6a 00                	push   $0x0
  pushl $92
801074da:	6a 5c                	push   $0x5c
  jmp alltraps
801074dc:	e9 7f f5 ff ff       	jmp    80106a60 <alltraps>

801074e1 <vector93>:
.globl vector93
vector93:
  pushl $0
801074e1:	6a 00                	push   $0x0
  pushl $93
801074e3:	6a 5d                	push   $0x5d
  jmp alltraps
801074e5:	e9 76 f5 ff ff       	jmp    80106a60 <alltraps>

801074ea <vector94>:
.globl vector94
vector94:
  pushl $0
801074ea:	6a 00                	push   $0x0
  pushl $94
801074ec:	6a 5e                	push   $0x5e
  jmp alltraps
801074ee:	e9 6d f5 ff ff       	jmp    80106a60 <alltraps>

801074f3 <vector95>:
.globl vector95
vector95:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $95
801074f5:	6a 5f                	push   $0x5f
  jmp alltraps
801074f7:	e9 64 f5 ff ff       	jmp    80106a60 <alltraps>

801074fc <vector96>:
.globl vector96
vector96:
  pushl $0
801074fc:	6a 00                	push   $0x0
  pushl $96
801074fe:	6a 60                	push   $0x60
  jmp alltraps
80107500:	e9 5b f5 ff ff       	jmp    80106a60 <alltraps>

80107505 <vector97>:
.globl vector97
vector97:
  pushl $0
80107505:	6a 00                	push   $0x0
  pushl $97
80107507:	6a 61                	push   $0x61
  jmp alltraps
80107509:	e9 52 f5 ff ff       	jmp    80106a60 <alltraps>

8010750e <vector98>:
.globl vector98
vector98:
  pushl $0
8010750e:	6a 00                	push   $0x0
  pushl $98
80107510:	6a 62                	push   $0x62
  jmp alltraps
80107512:	e9 49 f5 ff ff       	jmp    80106a60 <alltraps>

80107517 <vector99>:
.globl vector99
vector99:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $99
80107519:	6a 63                	push   $0x63
  jmp alltraps
8010751b:	e9 40 f5 ff ff       	jmp    80106a60 <alltraps>

80107520 <vector100>:
.globl vector100
vector100:
  pushl $0
80107520:	6a 00                	push   $0x0
  pushl $100
80107522:	6a 64                	push   $0x64
  jmp alltraps
80107524:	e9 37 f5 ff ff       	jmp    80106a60 <alltraps>

80107529 <vector101>:
.globl vector101
vector101:
  pushl $0
80107529:	6a 00                	push   $0x0
  pushl $101
8010752b:	6a 65                	push   $0x65
  jmp alltraps
8010752d:	e9 2e f5 ff ff       	jmp    80106a60 <alltraps>

80107532 <vector102>:
.globl vector102
vector102:
  pushl $0
80107532:	6a 00                	push   $0x0
  pushl $102
80107534:	6a 66                	push   $0x66
  jmp alltraps
80107536:	e9 25 f5 ff ff       	jmp    80106a60 <alltraps>

8010753b <vector103>:
.globl vector103
vector103:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $103
8010753d:	6a 67                	push   $0x67
  jmp alltraps
8010753f:	e9 1c f5 ff ff       	jmp    80106a60 <alltraps>

80107544 <vector104>:
.globl vector104
vector104:
  pushl $0
80107544:	6a 00                	push   $0x0
  pushl $104
80107546:	6a 68                	push   $0x68
  jmp alltraps
80107548:	e9 13 f5 ff ff       	jmp    80106a60 <alltraps>

8010754d <vector105>:
.globl vector105
vector105:
  pushl $0
8010754d:	6a 00                	push   $0x0
  pushl $105
8010754f:	6a 69                	push   $0x69
  jmp alltraps
80107551:	e9 0a f5 ff ff       	jmp    80106a60 <alltraps>

80107556 <vector106>:
.globl vector106
vector106:
  pushl $0
80107556:	6a 00                	push   $0x0
  pushl $106
80107558:	6a 6a                	push   $0x6a
  jmp alltraps
8010755a:	e9 01 f5 ff ff       	jmp    80106a60 <alltraps>

8010755f <vector107>:
.globl vector107
vector107:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $107
80107561:	6a 6b                	push   $0x6b
  jmp alltraps
80107563:	e9 f8 f4 ff ff       	jmp    80106a60 <alltraps>

80107568 <vector108>:
.globl vector108
vector108:
  pushl $0
80107568:	6a 00                	push   $0x0
  pushl $108
8010756a:	6a 6c                	push   $0x6c
  jmp alltraps
8010756c:	e9 ef f4 ff ff       	jmp    80106a60 <alltraps>

80107571 <vector109>:
.globl vector109
vector109:
  pushl $0
80107571:	6a 00                	push   $0x0
  pushl $109
80107573:	6a 6d                	push   $0x6d
  jmp alltraps
80107575:	e9 e6 f4 ff ff       	jmp    80106a60 <alltraps>

8010757a <vector110>:
.globl vector110
vector110:
  pushl $0
8010757a:	6a 00                	push   $0x0
  pushl $110
8010757c:	6a 6e                	push   $0x6e
  jmp alltraps
8010757e:	e9 dd f4 ff ff       	jmp    80106a60 <alltraps>

80107583 <vector111>:
.globl vector111
vector111:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $111
80107585:	6a 6f                	push   $0x6f
  jmp alltraps
80107587:	e9 d4 f4 ff ff       	jmp    80106a60 <alltraps>

8010758c <vector112>:
.globl vector112
vector112:
  pushl $0
8010758c:	6a 00                	push   $0x0
  pushl $112
8010758e:	6a 70                	push   $0x70
  jmp alltraps
80107590:	e9 cb f4 ff ff       	jmp    80106a60 <alltraps>

80107595 <vector113>:
.globl vector113
vector113:
  pushl $0
80107595:	6a 00                	push   $0x0
  pushl $113
80107597:	6a 71                	push   $0x71
  jmp alltraps
80107599:	e9 c2 f4 ff ff       	jmp    80106a60 <alltraps>

8010759e <vector114>:
.globl vector114
vector114:
  pushl $0
8010759e:	6a 00                	push   $0x0
  pushl $114
801075a0:	6a 72                	push   $0x72
  jmp alltraps
801075a2:	e9 b9 f4 ff ff       	jmp    80106a60 <alltraps>

801075a7 <vector115>:
.globl vector115
vector115:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $115
801075a9:	6a 73                	push   $0x73
  jmp alltraps
801075ab:	e9 b0 f4 ff ff       	jmp    80106a60 <alltraps>

801075b0 <vector116>:
.globl vector116
vector116:
  pushl $0
801075b0:	6a 00                	push   $0x0
  pushl $116
801075b2:	6a 74                	push   $0x74
  jmp alltraps
801075b4:	e9 a7 f4 ff ff       	jmp    80106a60 <alltraps>

801075b9 <vector117>:
.globl vector117
vector117:
  pushl $0
801075b9:	6a 00                	push   $0x0
  pushl $117
801075bb:	6a 75                	push   $0x75
  jmp alltraps
801075bd:	e9 9e f4 ff ff       	jmp    80106a60 <alltraps>

801075c2 <vector118>:
.globl vector118
vector118:
  pushl $0
801075c2:	6a 00                	push   $0x0
  pushl $118
801075c4:	6a 76                	push   $0x76
  jmp alltraps
801075c6:	e9 95 f4 ff ff       	jmp    80106a60 <alltraps>

801075cb <vector119>:
.globl vector119
vector119:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $119
801075cd:	6a 77                	push   $0x77
  jmp alltraps
801075cf:	e9 8c f4 ff ff       	jmp    80106a60 <alltraps>

801075d4 <vector120>:
.globl vector120
vector120:
  pushl $0
801075d4:	6a 00                	push   $0x0
  pushl $120
801075d6:	6a 78                	push   $0x78
  jmp alltraps
801075d8:	e9 83 f4 ff ff       	jmp    80106a60 <alltraps>

801075dd <vector121>:
.globl vector121
vector121:
  pushl $0
801075dd:	6a 00                	push   $0x0
  pushl $121
801075df:	6a 79                	push   $0x79
  jmp alltraps
801075e1:	e9 7a f4 ff ff       	jmp    80106a60 <alltraps>

801075e6 <vector122>:
.globl vector122
vector122:
  pushl $0
801075e6:	6a 00                	push   $0x0
  pushl $122
801075e8:	6a 7a                	push   $0x7a
  jmp alltraps
801075ea:	e9 71 f4 ff ff       	jmp    80106a60 <alltraps>

801075ef <vector123>:
.globl vector123
vector123:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $123
801075f1:	6a 7b                	push   $0x7b
  jmp alltraps
801075f3:	e9 68 f4 ff ff       	jmp    80106a60 <alltraps>

801075f8 <vector124>:
.globl vector124
vector124:
  pushl $0
801075f8:	6a 00                	push   $0x0
  pushl $124
801075fa:	6a 7c                	push   $0x7c
  jmp alltraps
801075fc:	e9 5f f4 ff ff       	jmp    80106a60 <alltraps>

80107601 <vector125>:
.globl vector125
vector125:
  pushl $0
80107601:	6a 00                	push   $0x0
  pushl $125
80107603:	6a 7d                	push   $0x7d
  jmp alltraps
80107605:	e9 56 f4 ff ff       	jmp    80106a60 <alltraps>

8010760a <vector126>:
.globl vector126
vector126:
  pushl $0
8010760a:	6a 00                	push   $0x0
  pushl $126
8010760c:	6a 7e                	push   $0x7e
  jmp alltraps
8010760e:	e9 4d f4 ff ff       	jmp    80106a60 <alltraps>

80107613 <vector127>:
.globl vector127
vector127:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $127
80107615:	6a 7f                	push   $0x7f
  jmp alltraps
80107617:	e9 44 f4 ff ff       	jmp    80106a60 <alltraps>

8010761c <vector128>:
.globl vector128
vector128:
  pushl $0
8010761c:	6a 00                	push   $0x0
  pushl $128
8010761e:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107623:	e9 38 f4 ff ff       	jmp    80106a60 <alltraps>

80107628 <vector129>:
.globl vector129
vector129:
  pushl $0
80107628:	6a 00                	push   $0x0
  pushl $129
8010762a:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010762f:	e9 2c f4 ff ff       	jmp    80106a60 <alltraps>

80107634 <vector130>:
.globl vector130
vector130:
  pushl $0
80107634:	6a 00                	push   $0x0
  pushl $130
80107636:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010763b:	e9 20 f4 ff ff       	jmp    80106a60 <alltraps>

80107640 <vector131>:
.globl vector131
vector131:
  pushl $0
80107640:	6a 00                	push   $0x0
  pushl $131
80107642:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107647:	e9 14 f4 ff ff       	jmp    80106a60 <alltraps>

8010764c <vector132>:
.globl vector132
vector132:
  pushl $0
8010764c:	6a 00                	push   $0x0
  pushl $132
8010764e:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107653:	e9 08 f4 ff ff       	jmp    80106a60 <alltraps>

80107658 <vector133>:
.globl vector133
vector133:
  pushl $0
80107658:	6a 00                	push   $0x0
  pushl $133
8010765a:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010765f:	e9 fc f3 ff ff       	jmp    80106a60 <alltraps>

80107664 <vector134>:
.globl vector134
vector134:
  pushl $0
80107664:	6a 00                	push   $0x0
  pushl $134
80107666:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010766b:	e9 f0 f3 ff ff       	jmp    80106a60 <alltraps>

80107670 <vector135>:
.globl vector135
vector135:
  pushl $0
80107670:	6a 00                	push   $0x0
  pushl $135
80107672:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107677:	e9 e4 f3 ff ff       	jmp    80106a60 <alltraps>

8010767c <vector136>:
.globl vector136
vector136:
  pushl $0
8010767c:	6a 00                	push   $0x0
  pushl $136
8010767e:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107683:	e9 d8 f3 ff ff       	jmp    80106a60 <alltraps>

80107688 <vector137>:
.globl vector137
vector137:
  pushl $0
80107688:	6a 00                	push   $0x0
  pushl $137
8010768a:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010768f:	e9 cc f3 ff ff       	jmp    80106a60 <alltraps>

80107694 <vector138>:
.globl vector138
vector138:
  pushl $0
80107694:	6a 00                	push   $0x0
  pushl $138
80107696:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010769b:	e9 c0 f3 ff ff       	jmp    80106a60 <alltraps>

801076a0 <vector139>:
.globl vector139
vector139:
  pushl $0
801076a0:	6a 00                	push   $0x0
  pushl $139
801076a2:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801076a7:	e9 b4 f3 ff ff       	jmp    80106a60 <alltraps>

801076ac <vector140>:
.globl vector140
vector140:
  pushl $0
801076ac:	6a 00                	push   $0x0
  pushl $140
801076ae:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801076b3:	e9 a8 f3 ff ff       	jmp    80106a60 <alltraps>

801076b8 <vector141>:
.globl vector141
vector141:
  pushl $0
801076b8:	6a 00                	push   $0x0
  pushl $141
801076ba:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801076bf:	e9 9c f3 ff ff       	jmp    80106a60 <alltraps>

801076c4 <vector142>:
.globl vector142
vector142:
  pushl $0
801076c4:	6a 00                	push   $0x0
  pushl $142
801076c6:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801076cb:	e9 90 f3 ff ff       	jmp    80106a60 <alltraps>

801076d0 <vector143>:
.globl vector143
vector143:
  pushl $0
801076d0:	6a 00                	push   $0x0
  pushl $143
801076d2:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801076d7:	e9 84 f3 ff ff       	jmp    80106a60 <alltraps>

801076dc <vector144>:
.globl vector144
vector144:
  pushl $0
801076dc:	6a 00                	push   $0x0
  pushl $144
801076de:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801076e3:	e9 78 f3 ff ff       	jmp    80106a60 <alltraps>

801076e8 <vector145>:
.globl vector145
vector145:
  pushl $0
801076e8:	6a 00                	push   $0x0
  pushl $145
801076ea:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801076ef:	e9 6c f3 ff ff       	jmp    80106a60 <alltraps>

801076f4 <vector146>:
.globl vector146
vector146:
  pushl $0
801076f4:	6a 00                	push   $0x0
  pushl $146
801076f6:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801076fb:	e9 60 f3 ff ff       	jmp    80106a60 <alltraps>

80107700 <vector147>:
.globl vector147
vector147:
  pushl $0
80107700:	6a 00                	push   $0x0
  pushl $147
80107702:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107707:	e9 54 f3 ff ff       	jmp    80106a60 <alltraps>

8010770c <vector148>:
.globl vector148
vector148:
  pushl $0
8010770c:	6a 00                	push   $0x0
  pushl $148
8010770e:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107713:	e9 48 f3 ff ff       	jmp    80106a60 <alltraps>

80107718 <vector149>:
.globl vector149
vector149:
  pushl $0
80107718:	6a 00                	push   $0x0
  pushl $149
8010771a:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010771f:	e9 3c f3 ff ff       	jmp    80106a60 <alltraps>

80107724 <vector150>:
.globl vector150
vector150:
  pushl $0
80107724:	6a 00                	push   $0x0
  pushl $150
80107726:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010772b:	e9 30 f3 ff ff       	jmp    80106a60 <alltraps>

80107730 <vector151>:
.globl vector151
vector151:
  pushl $0
80107730:	6a 00                	push   $0x0
  pushl $151
80107732:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107737:	e9 24 f3 ff ff       	jmp    80106a60 <alltraps>

8010773c <vector152>:
.globl vector152
vector152:
  pushl $0
8010773c:	6a 00                	push   $0x0
  pushl $152
8010773e:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107743:	e9 18 f3 ff ff       	jmp    80106a60 <alltraps>

80107748 <vector153>:
.globl vector153
vector153:
  pushl $0
80107748:	6a 00                	push   $0x0
  pushl $153
8010774a:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010774f:	e9 0c f3 ff ff       	jmp    80106a60 <alltraps>

80107754 <vector154>:
.globl vector154
vector154:
  pushl $0
80107754:	6a 00                	push   $0x0
  pushl $154
80107756:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010775b:	e9 00 f3 ff ff       	jmp    80106a60 <alltraps>

80107760 <vector155>:
.globl vector155
vector155:
  pushl $0
80107760:	6a 00                	push   $0x0
  pushl $155
80107762:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107767:	e9 f4 f2 ff ff       	jmp    80106a60 <alltraps>

8010776c <vector156>:
.globl vector156
vector156:
  pushl $0
8010776c:	6a 00                	push   $0x0
  pushl $156
8010776e:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107773:	e9 e8 f2 ff ff       	jmp    80106a60 <alltraps>

80107778 <vector157>:
.globl vector157
vector157:
  pushl $0
80107778:	6a 00                	push   $0x0
  pushl $157
8010777a:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010777f:	e9 dc f2 ff ff       	jmp    80106a60 <alltraps>

80107784 <vector158>:
.globl vector158
vector158:
  pushl $0
80107784:	6a 00                	push   $0x0
  pushl $158
80107786:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010778b:	e9 d0 f2 ff ff       	jmp    80106a60 <alltraps>

80107790 <vector159>:
.globl vector159
vector159:
  pushl $0
80107790:	6a 00                	push   $0x0
  pushl $159
80107792:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107797:	e9 c4 f2 ff ff       	jmp    80106a60 <alltraps>

8010779c <vector160>:
.globl vector160
vector160:
  pushl $0
8010779c:	6a 00                	push   $0x0
  pushl $160
8010779e:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801077a3:	e9 b8 f2 ff ff       	jmp    80106a60 <alltraps>

801077a8 <vector161>:
.globl vector161
vector161:
  pushl $0
801077a8:	6a 00                	push   $0x0
  pushl $161
801077aa:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801077af:	e9 ac f2 ff ff       	jmp    80106a60 <alltraps>

801077b4 <vector162>:
.globl vector162
vector162:
  pushl $0
801077b4:	6a 00                	push   $0x0
  pushl $162
801077b6:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801077bb:	e9 a0 f2 ff ff       	jmp    80106a60 <alltraps>

801077c0 <vector163>:
.globl vector163
vector163:
  pushl $0
801077c0:	6a 00                	push   $0x0
  pushl $163
801077c2:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801077c7:	e9 94 f2 ff ff       	jmp    80106a60 <alltraps>

801077cc <vector164>:
.globl vector164
vector164:
  pushl $0
801077cc:	6a 00                	push   $0x0
  pushl $164
801077ce:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801077d3:	e9 88 f2 ff ff       	jmp    80106a60 <alltraps>

801077d8 <vector165>:
.globl vector165
vector165:
  pushl $0
801077d8:	6a 00                	push   $0x0
  pushl $165
801077da:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801077df:	e9 7c f2 ff ff       	jmp    80106a60 <alltraps>

801077e4 <vector166>:
.globl vector166
vector166:
  pushl $0
801077e4:	6a 00                	push   $0x0
  pushl $166
801077e6:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801077eb:	e9 70 f2 ff ff       	jmp    80106a60 <alltraps>

801077f0 <vector167>:
.globl vector167
vector167:
  pushl $0
801077f0:	6a 00                	push   $0x0
  pushl $167
801077f2:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801077f7:	e9 64 f2 ff ff       	jmp    80106a60 <alltraps>

801077fc <vector168>:
.globl vector168
vector168:
  pushl $0
801077fc:	6a 00                	push   $0x0
  pushl $168
801077fe:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107803:	e9 58 f2 ff ff       	jmp    80106a60 <alltraps>

80107808 <vector169>:
.globl vector169
vector169:
  pushl $0
80107808:	6a 00                	push   $0x0
  pushl $169
8010780a:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010780f:	e9 4c f2 ff ff       	jmp    80106a60 <alltraps>

80107814 <vector170>:
.globl vector170
vector170:
  pushl $0
80107814:	6a 00                	push   $0x0
  pushl $170
80107816:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010781b:	e9 40 f2 ff ff       	jmp    80106a60 <alltraps>

80107820 <vector171>:
.globl vector171
vector171:
  pushl $0
80107820:	6a 00                	push   $0x0
  pushl $171
80107822:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107827:	e9 34 f2 ff ff       	jmp    80106a60 <alltraps>

8010782c <vector172>:
.globl vector172
vector172:
  pushl $0
8010782c:	6a 00                	push   $0x0
  pushl $172
8010782e:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107833:	e9 28 f2 ff ff       	jmp    80106a60 <alltraps>

80107838 <vector173>:
.globl vector173
vector173:
  pushl $0
80107838:	6a 00                	push   $0x0
  pushl $173
8010783a:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010783f:	e9 1c f2 ff ff       	jmp    80106a60 <alltraps>

80107844 <vector174>:
.globl vector174
vector174:
  pushl $0
80107844:	6a 00                	push   $0x0
  pushl $174
80107846:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010784b:	e9 10 f2 ff ff       	jmp    80106a60 <alltraps>

80107850 <vector175>:
.globl vector175
vector175:
  pushl $0
80107850:	6a 00                	push   $0x0
  pushl $175
80107852:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107857:	e9 04 f2 ff ff       	jmp    80106a60 <alltraps>

8010785c <vector176>:
.globl vector176
vector176:
  pushl $0
8010785c:	6a 00                	push   $0x0
  pushl $176
8010785e:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107863:	e9 f8 f1 ff ff       	jmp    80106a60 <alltraps>

80107868 <vector177>:
.globl vector177
vector177:
  pushl $0
80107868:	6a 00                	push   $0x0
  pushl $177
8010786a:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010786f:	e9 ec f1 ff ff       	jmp    80106a60 <alltraps>

80107874 <vector178>:
.globl vector178
vector178:
  pushl $0
80107874:	6a 00                	push   $0x0
  pushl $178
80107876:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010787b:	e9 e0 f1 ff ff       	jmp    80106a60 <alltraps>

80107880 <vector179>:
.globl vector179
vector179:
  pushl $0
80107880:	6a 00                	push   $0x0
  pushl $179
80107882:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107887:	e9 d4 f1 ff ff       	jmp    80106a60 <alltraps>

8010788c <vector180>:
.globl vector180
vector180:
  pushl $0
8010788c:	6a 00                	push   $0x0
  pushl $180
8010788e:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107893:	e9 c8 f1 ff ff       	jmp    80106a60 <alltraps>

80107898 <vector181>:
.globl vector181
vector181:
  pushl $0
80107898:	6a 00                	push   $0x0
  pushl $181
8010789a:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010789f:	e9 bc f1 ff ff       	jmp    80106a60 <alltraps>

801078a4 <vector182>:
.globl vector182
vector182:
  pushl $0
801078a4:	6a 00                	push   $0x0
  pushl $182
801078a6:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801078ab:	e9 b0 f1 ff ff       	jmp    80106a60 <alltraps>

801078b0 <vector183>:
.globl vector183
vector183:
  pushl $0
801078b0:	6a 00                	push   $0x0
  pushl $183
801078b2:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801078b7:	e9 a4 f1 ff ff       	jmp    80106a60 <alltraps>

801078bc <vector184>:
.globl vector184
vector184:
  pushl $0
801078bc:	6a 00                	push   $0x0
  pushl $184
801078be:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801078c3:	e9 98 f1 ff ff       	jmp    80106a60 <alltraps>

801078c8 <vector185>:
.globl vector185
vector185:
  pushl $0
801078c8:	6a 00                	push   $0x0
  pushl $185
801078ca:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801078cf:	e9 8c f1 ff ff       	jmp    80106a60 <alltraps>

801078d4 <vector186>:
.globl vector186
vector186:
  pushl $0
801078d4:	6a 00                	push   $0x0
  pushl $186
801078d6:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801078db:	e9 80 f1 ff ff       	jmp    80106a60 <alltraps>

801078e0 <vector187>:
.globl vector187
vector187:
  pushl $0
801078e0:	6a 00                	push   $0x0
  pushl $187
801078e2:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801078e7:	e9 74 f1 ff ff       	jmp    80106a60 <alltraps>

801078ec <vector188>:
.globl vector188
vector188:
  pushl $0
801078ec:	6a 00                	push   $0x0
  pushl $188
801078ee:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801078f3:	e9 68 f1 ff ff       	jmp    80106a60 <alltraps>

801078f8 <vector189>:
.globl vector189
vector189:
  pushl $0
801078f8:	6a 00                	push   $0x0
  pushl $189
801078fa:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801078ff:	e9 5c f1 ff ff       	jmp    80106a60 <alltraps>

80107904 <vector190>:
.globl vector190
vector190:
  pushl $0
80107904:	6a 00                	push   $0x0
  pushl $190
80107906:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010790b:	e9 50 f1 ff ff       	jmp    80106a60 <alltraps>

80107910 <vector191>:
.globl vector191
vector191:
  pushl $0
80107910:	6a 00                	push   $0x0
  pushl $191
80107912:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107917:	e9 44 f1 ff ff       	jmp    80106a60 <alltraps>

8010791c <vector192>:
.globl vector192
vector192:
  pushl $0
8010791c:	6a 00                	push   $0x0
  pushl $192
8010791e:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107923:	e9 38 f1 ff ff       	jmp    80106a60 <alltraps>

80107928 <vector193>:
.globl vector193
vector193:
  pushl $0
80107928:	6a 00                	push   $0x0
  pushl $193
8010792a:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010792f:	e9 2c f1 ff ff       	jmp    80106a60 <alltraps>

80107934 <vector194>:
.globl vector194
vector194:
  pushl $0
80107934:	6a 00                	push   $0x0
  pushl $194
80107936:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010793b:	e9 20 f1 ff ff       	jmp    80106a60 <alltraps>

80107940 <vector195>:
.globl vector195
vector195:
  pushl $0
80107940:	6a 00                	push   $0x0
  pushl $195
80107942:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107947:	e9 14 f1 ff ff       	jmp    80106a60 <alltraps>

8010794c <vector196>:
.globl vector196
vector196:
  pushl $0
8010794c:	6a 00                	push   $0x0
  pushl $196
8010794e:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107953:	e9 08 f1 ff ff       	jmp    80106a60 <alltraps>

80107958 <vector197>:
.globl vector197
vector197:
  pushl $0
80107958:	6a 00                	push   $0x0
  pushl $197
8010795a:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010795f:	e9 fc f0 ff ff       	jmp    80106a60 <alltraps>

80107964 <vector198>:
.globl vector198
vector198:
  pushl $0
80107964:	6a 00                	push   $0x0
  pushl $198
80107966:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010796b:	e9 f0 f0 ff ff       	jmp    80106a60 <alltraps>

80107970 <vector199>:
.globl vector199
vector199:
  pushl $0
80107970:	6a 00                	push   $0x0
  pushl $199
80107972:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107977:	e9 e4 f0 ff ff       	jmp    80106a60 <alltraps>

8010797c <vector200>:
.globl vector200
vector200:
  pushl $0
8010797c:	6a 00                	push   $0x0
  pushl $200
8010797e:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107983:	e9 d8 f0 ff ff       	jmp    80106a60 <alltraps>

80107988 <vector201>:
.globl vector201
vector201:
  pushl $0
80107988:	6a 00                	push   $0x0
  pushl $201
8010798a:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010798f:	e9 cc f0 ff ff       	jmp    80106a60 <alltraps>

80107994 <vector202>:
.globl vector202
vector202:
  pushl $0
80107994:	6a 00                	push   $0x0
  pushl $202
80107996:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010799b:	e9 c0 f0 ff ff       	jmp    80106a60 <alltraps>

801079a0 <vector203>:
.globl vector203
vector203:
  pushl $0
801079a0:	6a 00                	push   $0x0
  pushl $203
801079a2:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801079a7:	e9 b4 f0 ff ff       	jmp    80106a60 <alltraps>

801079ac <vector204>:
.globl vector204
vector204:
  pushl $0
801079ac:	6a 00                	push   $0x0
  pushl $204
801079ae:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801079b3:	e9 a8 f0 ff ff       	jmp    80106a60 <alltraps>

801079b8 <vector205>:
.globl vector205
vector205:
  pushl $0
801079b8:	6a 00                	push   $0x0
  pushl $205
801079ba:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801079bf:	e9 9c f0 ff ff       	jmp    80106a60 <alltraps>

801079c4 <vector206>:
.globl vector206
vector206:
  pushl $0
801079c4:	6a 00                	push   $0x0
  pushl $206
801079c6:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801079cb:	e9 90 f0 ff ff       	jmp    80106a60 <alltraps>

801079d0 <vector207>:
.globl vector207
vector207:
  pushl $0
801079d0:	6a 00                	push   $0x0
  pushl $207
801079d2:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801079d7:	e9 84 f0 ff ff       	jmp    80106a60 <alltraps>

801079dc <vector208>:
.globl vector208
vector208:
  pushl $0
801079dc:	6a 00                	push   $0x0
  pushl $208
801079de:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801079e3:	e9 78 f0 ff ff       	jmp    80106a60 <alltraps>

801079e8 <vector209>:
.globl vector209
vector209:
  pushl $0
801079e8:	6a 00                	push   $0x0
  pushl $209
801079ea:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801079ef:	e9 6c f0 ff ff       	jmp    80106a60 <alltraps>

801079f4 <vector210>:
.globl vector210
vector210:
  pushl $0
801079f4:	6a 00                	push   $0x0
  pushl $210
801079f6:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801079fb:	e9 60 f0 ff ff       	jmp    80106a60 <alltraps>

80107a00 <vector211>:
.globl vector211
vector211:
  pushl $0
80107a00:	6a 00                	push   $0x0
  pushl $211
80107a02:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107a07:	e9 54 f0 ff ff       	jmp    80106a60 <alltraps>

80107a0c <vector212>:
.globl vector212
vector212:
  pushl $0
80107a0c:	6a 00                	push   $0x0
  pushl $212
80107a0e:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107a13:	e9 48 f0 ff ff       	jmp    80106a60 <alltraps>

80107a18 <vector213>:
.globl vector213
vector213:
  pushl $0
80107a18:	6a 00                	push   $0x0
  pushl $213
80107a1a:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107a1f:	e9 3c f0 ff ff       	jmp    80106a60 <alltraps>

80107a24 <vector214>:
.globl vector214
vector214:
  pushl $0
80107a24:	6a 00                	push   $0x0
  pushl $214
80107a26:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107a2b:	e9 30 f0 ff ff       	jmp    80106a60 <alltraps>

80107a30 <vector215>:
.globl vector215
vector215:
  pushl $0
80107a30:	6a 00                	push   $0x0
  pushl $215
80107a32:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107a37:	e9 24 f0 ff ff       	jmp    80106a60 <alltraps>

80107a3c <vector216>:
.globl vector216
vector216:
  pushl $0
80107a3c:	6a 00                	push   $0x0
  pushl $216
80107a3e:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107a43:	e9 18 f0 ff ff       	jmp    80106a60 <alltraps>

80107a48 <vector217>:
.globl vector217
vector217:
  pushl $0
80107a48:	6a 00                	push   $0x0
  pushl $217
80107a4a:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107a4f:	e9 0c f0 ff ff       	jmp    80106a60 <alltraps>

80107a54 <vector218>:
.globl vector218
vector218:
  pushl $0
80107a54:	6a 00                	push   $0x0
  pushl $218
80107a56:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107a5b:	e9 00 f0 ff ff       	jmp    80106a60 <alltraps>

80107a60 <vector219>:
.globl vector219
vector219:
  pushl $0
80107a60:	6a 00                	push   $0x0
  pushl $219
80107a62:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107a67:	e9 f4 ef ff ff       	jmp    80106a60 <alltraps>

80107a6c <vector220>:
.globl vector220
vector220:
  pushl $0
80107a6c:	6a 00                	push   $0x0
  pushl $220
80107a6e:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107a73:	e9 e8 ef ff ff       	jmp    80106a60 <alltraps>

80107a78 <vector221>:
.globl vector221
vector221:
  pushl $0
80107a78:	6a 00                	push   $0x0
  pushl $221
80107a7a:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107a7f:	e9 dc ef ff ff       	jmp    80106a60 <alltraps>

80107a84 <vector222>:
.globl vector222
vector222:
  pushl $0
80107a84:	6a 00                	push   $0x0
  pushl $222
80107a86:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107a8b:	e9 d0 ef ff ff       	jmp    80106a60 <alltraps>

80107a90 <vector223>:
.globl vector223
vector223:
  pushl $0
80107a90:	6a 00                	push   $0x0
  pushl $223
80107a92:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107a97:	e9 c4 ef ff ff       	jmp    80106a60 <alltraps>

80107a9c <vector224>:
.globl vector224
vector224:
  pushl $0
80107a9c:	6a 00                	push   $0x0
  pushl $224
80107a9e:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107aa3:	e9 b8 ef ff ff       	jmp    80106a60 <alltraps>

80107aa8 <vector225>:
.globl vector225
vector225:
  pushl $0
80107aa8:	6a 00                	push   $0x0
  pushl $225
80107aaa:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107aaf:	e9 ac ef ff ff       	jmp    80106a60 <alltraps>

80107ab4 <vector226>:
.globl vector226
vector226:
  pushl $0
80107ab4:	6a 00                	push   $0x0
  pushl $226
80107ab6:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107abb:	e9 a0 ef ff ff       	jmp    80106a60 <alltraps>

80107ac0 <vector227>:
.globl vector227
vector227:
  pushl $0
80107ac0:	6a 00                	push   $0x0
  pushl $227
80107ac2:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107ac7:	e9 94 ef ff ff       	jmp    80106a60 <alltraps>

80107acc <vector228>:
.globl vector228
vector228:
  pushl $0
80107acc:	6a 00                	push   $0x0
  pushl $228
80107ace:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107ad3:	e9 88 ef ff ff       	jmp    80106a60 <alltraps>

80107ad8 <vector229>:
.globl vector229
vector229:
  pushl $0
80107ad8:	6a 00                	push   $0x0
  pushl $229
80107ada:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107adf:	e9 7c ef ff ff       	jmp    80106a60 <alltraps>

80107ae4 <vector230>:
.globl vector230
vector230:
  pushl $0
80107ae4:	6a 00                	push   $0x0
  pushl $230
80107ae6:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107aeb:	e9 70 ef ff ff       	jmp    80106a60 <alltraps>

80107af0 <vector231>:
.globl vector231
vector231:
  pushl $0
80107af0:	6a 00                	push   $0x0
  pushl $231
80107af2:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107af7:	e9 64 ef ff ff       	jmp    80106a60 <alltraps>

80107afc <vector232>:
.globl vector232
vector232:
  pushl $0
80107afc:	6a 00                	push   $0x0
  pushl $232
80107afe:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107b03:	e9 58 ef ff ff       	jmp    80106a60 <alltraps>

80107b08 <vector233>:
.globl vector233
vector233:
  pushl $0
80107b08:	6a 00                	push   $0x0
  pushl $233
80107b0a:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107b0f:	e9 4c ef ff ff       	jmp    80106a60 <alltraps>

80107b14 <vector234>:
.globl vector234
vector234:
  pushl $0
80107b14:	6a 00                	push   $0x0
  pushl $234
80107b16:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107b1b:	e9 40 ef ff ff       	jmp    80106a60 <alltraps>

80107b20 <vector235>:
.globl vector235
vector235:
  pushl $0
80107b20:	6a 00                	push   $0x0
  pushl $235
80107b22:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107b27:	e9 34 ef ff ff       	jmp    80106a60 <alltraps>

80107b2c <vector236>:
.globl vector236
vector236:
  pushl $0
80107b2c:	6a 00                	push   $0x0
  pushl $236
80107b2e:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107b33:	e9 28 ef ff ff       	jmp    80106a60 <alltraps>

80107b38 <vector237>:
.globl vector237
vector237:
  pushl $0
80107b38:	6a 00                	push   $0x0
  pushl $237
80107b3a:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107b3f:	e9 1c ef ff ff       	jmp    80106a60 <alltraps>

80107b44 <vector238>:
.globl vector238
vector238:
  pushl $0
80107b44:	6a 00                	push   $0x0
  pushl $238
80107b46:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107b4b:	e9 10 ef ff ff       	jmp    80106a60 <alltraps>

80107b50 <vector239>:
.globl vector239
vector239:
  pushl $0
80107b50:	6a 00                	push   $0x0
  pushl $239
80107b52:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107b57:	e9 04 ef ff ff       	jmp    80106a60 <alltraps>

80107b5c <vector240>:
.globl vector240
vector240:
  pushl $0
80107b5c:	6a 00                	push   $0x0
  pushl $240
80107b5e:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107b63:	e9 f8 ee ff ff       	jmp    80106a60 <alltraps>

80107b68 <vector241>:
.globl vector241
vector241:
  pushl $0
80107b68:	6a 00                	push   $0x0
  pushl $241
80107b6a:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107b6f:	e9 ec ee ff ff       	jmp    80106a60 <alltraps>

80107b74 <vector242>:
.globl vector242
vector242:
  pushl $0
80107b74:	6a 00                	push   $0x0
  pushl $242
80107b76:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107b7b:	e9 e0 ee ff ff       	jmp    80106a60 <alltraps>

80107b80 <vector243>:
.globl vector243
vector243:
  pushl $0
80107b80:	6a 00                	push   $0x0
  pushl $243
80107b82:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107b87:	e9 d4 ee ff ff       	jmp    80106a60 <alltraps>

80107b8c <vector244>:
.globl vector244
vector244:
  pushl $0
80107b8c:	6a 00                	push   $0x0
  pushl $244
80107b8e:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107b93:	e9 c8 ee ff ff       	jmp    80106a60 <alltraps>

80107b98 <vector245>:
.globl vector245
vector245:
  pushl $0
80107b98:	6a 00                	push   $0x0
  pushl $245
80107b9a:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107b9f:	e9 bc ee ff ff       	jmp    80106a60 <alltraps>

80107ba4 <vector246>:
.globl vector246
vector246:
  pushl $0
80107ba4:	6a 00                	push   $0x0
  pushl $246
80107ba6:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107bab:	e9 b0 ee ff ff       	jmp    80106a60 <alltraps>

80107bb0 <vector247>:
.globl vector247
vector247:
  pushl $0
80107bb0:	6a 00                	push   $0x0
  pushl $247
80107bb2:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107bb7:	e9 a4 ee ff ff       	jmp    80106a60 <alltraps>

80107bbc <vector248>:
.globl vector248
vector248:
  pushl $0
80107bbc:	6a 00                	push   $0x0
  pushl $248
80107bbe:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107bc3:	e9 98 ee ff ff       	jmp    80106a60 <alltraps>

80107bc8 <vector249>:
.globl vector249
vector249:
  pushl $0
80107bc8:	6a 00                	push   $0x0
  pushl $249
80107bca:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107bcf:	e9 8c ee ff ff       	jmp    80106a60 <alltraps>

80107bd4 <vector250>:
.globl vector250
vector250:
  pushl $0
80107bd4:	6a 00                	push   $0x0
  pushl $250
80107bd6:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107bdb:	e9 80 ee ff ff       	jmp    80106a60 <alltraps>

80107be0 <vector251>:
.globl vector251
vector251:
  pushl $0
80107be0:	6a 00                	push   $0x0
  pushl $251
80107be2:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107be7:	e9 74 ee ff ff       	jmp    80106a60 <alltraps>

80107bec <vector252>:
.globl vector252
vector252:
  pushl $0
80107bec:	6a 00                	push   $0x0
  pushl $252
80107bee:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107bf3:	e9 68 ee ff ff       	jmp    80106a60 <alltraps>

80107bf8 <vector253>:
.globl vector253
vector253:
  pushl $0
80107bf8:	6a 00                	push   $0x0
  pushl $253
80107bfa:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107bff:	e9 5c ee ff ff       	jmp    80106a60 <alltraps>

80107c04 <vector254>:
.globl vector254
vector254:
  pushl $0
80107c04:	6a 00                	push   $0x0
  pushl $254
80107c06:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107c0b:	e9 50 ee ff ff       	jmp    80106a60 <alltraps>

80107c10 <vector255>:
.globl vector255
vector255:
  pushl $0
80107c10:	6a 00                	push   $0x0
  pushl $255
80107c12:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107c17:	e9 44 ee ff ff       	jmp    80106a60 <alltraps>

80107c1c <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107c1c:	55                   	push   %ebp
80107c1d:	89 e5                	mov    %esp,%ebp
80107c1f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107c22:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c25:	83 e8 01             	sub    $0x1,%eax
80107c28:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107c2c:	8b 45 08             	mov    0x8(%ebp),%eax
80107c2f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107c33:	8b 45 08             	mov    0x8(%ebp),%eax
80107c36:	c1 e8 10             	shr    $0x10,%eax
80107c39:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107c3d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107c40:	0f 01 10             	lgdtl  (%eax)
}
80107c43:	90                   	nop
80107c44:	c9                   	leave  
80107c45:	c3                   	ret    

80107c46 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107c46:	55                   	push   %ebp
80107c47:	89 e5                	mov    %esp,%ebp
80107c49:	83 ec 04             	sub    $0x4,%esp
80107c4c:	8b 45 08             	mov    0x8(%ebp),%eax
80107c4f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107c53:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107c57:	0f 00 d8             	ltr    %ax
}
80107c5a:	90                   	nop
80107c5b:	c9                   	leave  
80107c5c:	c3                   	ret    

80107c5d <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107c5d:	55                   	push   %ebp
80107c5e:	89 e5                	mov    %esp,%ebp
80107c60:	83 ec 04             	sub    $0x4,%esp
80107c63:	8b 45 08             	mov    0x8(%ebp),%eax
80107c66:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107c6a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107c6e:	8e e8                	mov    %eax,%gs
}
80107c70:	90                   	nop
80107c71:	c9                   	leave  
80107c72:	c3                   	ret    

80107c73 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107c73:	55                   	push   %ebp
80107c74:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c76:	8b 45 08             	mov    0x8(%ebp),%eax
80107c79:	0f 22 d8             	mov    %eax,%cr3
}
80107c7c:	90                   	nop
80107c7d:	5d                   	pop    %ebp
80107c7e:	c3                   	ret    

80107c7f <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107c7f:	55                   	push   %ebp
80107c80:	89 e5                	mov    %esp,%ebp
80107c82:	8b 45 08             	mov    0x8(%ebp),%eax
80107c85:	05 00 00 00 80       	add    $0x80000000,%eax
80107c8a:	5d                   	pop    %ebp
80107c8b:	c3                   	ret    

80107c8c <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107c8c:	55                   	push   %ebp
80107c8d:	89 e5                	mov    %esp,%ebp
80107c8f:	8b 45 08             	mov    0x8(%ebp),%eax
80107c92:	05 00 00 00 80       	add    $0x80000000,%eax
80107c97:	5d                   	pop    %ebp
80107c98:	c3                   	ret    

80107c99 <init_pte_lookup_lock>:
struct {
  char pte_array [NPDENTRIES*NPTENTRIES];
  struct spinlock lock;
} pte_lookup_table;

void init_pte_lookup_lock(void) {
80107c99:	55                   	push   %ebp
80107c9a:	89 e5                	mov    %esp,%ebp
80107c9c:	83 ec 08             	sub    $0x8,%esp
  initlock(&pte_lookup_table.lock,"pte_lookup");
80107c9f:	83 ec 08             	sub    $0x8,%esp
80107ca2:	68 64 94 10 80       	push   $0x80109464
80107ca7:	68 20 65 21 80       	push   $0x80216520
80107cac:	e8 03 d6 ff ff       	call   801052b4 <initlock>
80107cb1:	83 c4 10             	add    $0x10,%esp
}
80107cb4:	90                   	nop
80107cb5:	c9                   	leave  
80107cb6:	c3                   	ret    

80107cb7 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107cb7:	55                   	push   %ebp
80107cb8:	89 e5                	mov    %esp,%ebp
80107cba:	53                   	push   %ebx
80107cbb:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107cbe:	e8 68 b2 ff ff       	call   80102f2b <cpunum>
80107cc3:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107cc9:	05 80 33 11 80       	add    $0x80113380,%eax
80107cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd4:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdd:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce6:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ced:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107cf1:	83 e2 f0             	and    $0xfffffff0,%edx
80107cf4:	83 ca 0a             	or     $0xa,%edx
80107cf7:	88 50 7d             	mov    %dl,0x7d(%eax)
80107cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cfd:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d01:	83 ca 10             	or     $0x10,%edx
80107d04:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d0e:	83 e2 9f             	and    $0xffffff9f,%edx
80107d11:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d17:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d1b:	83 ca 80             	or     $0xffffff80,%edx
80107d1e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d24:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d28:	83 ca 0f             	or     $0xf,%edx
80107d2b:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d31:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d35:	83 e2 ef             	and    $0xffffffef,%edx
80107d38:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d42:	83 e2 df             	and    $0xffffffdf,%edx
80107d45:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d4f:	83 ca 40             	or     $0x40,%edx
80107d52:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d58:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d5c:	83 ca 80             	or     $0xffffff80,%edx
80107d5f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d65:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6c:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107d73:	ff ff 
80107d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d78:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107d7f:	00 00 
80107d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d84:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d95:	83 e2 f0             	and    $0xfffffff0,%edx
80107d98:	83 ca 02             	or     $0x2,%edx
80107d9b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107dab:	83 ca 10             	or     $0x10,%edx
80107dae:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db7:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107dbe:	83 e2 9f             	and    $0xffffff9f,%edx
80107dc1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dca:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107dd1:	83 ca 80             	or     $0xffffff80,%edx
80107dd4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ddd:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107de4:	83 ca 0f             	or     $0xf,%edx
80107de7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107df7:	83 e2 ef             	and    $0xffffffef,%edx
80107dfa:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e03:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e0a:	83 e2 df             	and    $0xffffffdf,%edx
80107e0d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e16:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e1d:	83 ca 40             	or     $0x40,%edx
80107e20:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e29:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e30:	83 ca 80             	or     $0xffffff80,%edx
80107e33:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e3c:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e46:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107e4d:	ff ff 
80107e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e52:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107e59:	00 00 
80107e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e68:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e6f:	83 e2 f0             	and    $0xfffffff0,%edx
80107e72:	83 ca 0a             	or     $0xa,%edx
80107e75:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e85:	83 ca 10             	or     $0x10,%edx
80107e88:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e91:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e98:	83 ca 60             	or     $0x60,%edx
80107e9b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea4:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107eab:	83 ca 80             	or     $0xffffff80,%edx
80107eae:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb7:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ebe:	83 ca 0f             	or     $0xf,%edx
80107ec1:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eca:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ed1:	83 e2 ef             	and    $0xffffffef,%edx
80107ed4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107edd:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ee4:	83 e2 df             	and    $0xffffffdf,%edx
80107ee7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ef7:	83 ca 40             	or     $0x40,%edx
80107efa:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f03:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f0a:	83 ca 80             	or     $0xffffff80,%edx
80107f0d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f16:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f20:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107f27:	ff ff 
80107f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107f33:	00 00 
80107f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f38:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f42:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f49:	83 e2 f0             	and    $0xfffffff0,%edx
80107f4c:	83 ca 02             	or     $0x2,%edx
80107f4f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f58:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f5f:	83 ca 10             	or     $0x10,%edx
80107f62:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6b:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f72:	83 ca 60             	or     $0x60,%edx
80107f75:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f85:	83 ca 80             	or     $0xffffff80,%edx
80107f88:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f91:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f98:	83 ca 0f             	or     $0xf,%edx
80107f9b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa4:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fab:	83 e2 ef             	and    $0xffffffef,%edx
80107fae:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb7:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fbe:	83 e2 df             	and    $0xffffffdf,%edx
80107fc1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fca:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fd1:	83 ca 40             	or     $0x40,%edx
80107fd4:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdd:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fe4:	83 ca 80             	or     $0xffffff80,%edx
80107fe7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff0:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffa:	05 b4 00 00 00       	add    $0xb4,%eax
80107fff:	89 c3                	mov    %eax,%ebx
80108001:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108004:	05 b4 00 00 00       	add    $0xb4,%eax
80108009:	c1 e8 10             	shr    $0x10,%eax
8010800c:	89 c2                	mov    %eax,%edx
8010800e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108011:	05 b4 00 00 00       	add    $0xb4,%eax
80108016:	c1 e8 18             	shr    $0x18,%eax
80108019:	89 c1                	mov    %eax,%ecx
8010801b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801e:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108025:	00 00 
80108027:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802a:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108031:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108034:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
8010803a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803d:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108044:	83 e2 f0             	and    $0xfffffff0,%edx
80108047:	83 ca 02             	or     $0x2,%edx
8010804a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108053:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010805a:	83 ca 10             	or     $0x10,%edx
8010805d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108063:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108066:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010806d:	83 e2 9f             	and    $0xffffff9f,%edx
80108070:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108079:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108080:	83 ca 80             	or     $0xffffff80,%edx
80108083:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108089:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108093:	83 e2 f0             	and    $0xfffffff0,%edx
80108096:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010809c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080a6:	83 e2 ef             	and    $0xffffffef,%edx
801080a9:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b2:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080b9:	83 e2 df             	and    $0xffffffdf,%edx
801080bc:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c5:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080cc:	83 ca 40             	or     $0x40,%edx
801080cf:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d8:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080df:	83 ca 80             	or     $0xffffff80,%edx
801080e2:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080eb:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801080f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f4:	83 c0 70             	add    $0x70,%eax
801080f7:	83 ec 08             	sub    $0x8,%esp
801080fa:	6a 38                	push   $0x38
801080fc:	50                   	push   %eax
801080fd:	e8 1a fb ff ff       	call   80107c1c <lgdt>
80108102:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108105:	83 ec 0c             	sub    $0xc,%esp
80108108:	6a 18                	push   $0x18
8010810a:	e8 4e fb ff ff       	call   80107c5d <loadgs>
8010810f:	83 c4 10             	add    $0x10,%esp

  // Initialize cpu-local storage.
  cpu = c;
80108112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108115:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010811b:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108122:	00 00 00 00 
}
80108126:	90                   	nop
80108127:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010812a:	c9                   	leave  
8010812b:	c3                   	ret    

8010812c <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010812c:	55                   	push   %ebp
8010812d:	89 e5                	mov    %esp,%ebp
8010812f:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108132:	8b 45 0c             	mov    0xc(%ebp),%eax
80108135:	c1 e8 16             	shr    $0x16,%eax
80108138:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010813f:	8b 45 08             	mov    0x8(%ebp),%eax
80108142:	01 d0                	add    %edx,%eax
80108144:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108147:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010814a:	8b 00                	mov    (%eax),%eax
8010814c:	83 e0 01             	and    $0x1,%eax
8010814f:	85 c0                	test   %eax,%eax
80108151:	74 18                	je     8010816b <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108153:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108156:	8b 00                	mov    (%eax),%eax
80108158:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010815d:	50                   	push   %eax
8010815e:	e8 29 fb ff ff       	call   80107c8c <p2v>
80108163:	83 c4 04             	add    $0x4,%esp
80108166:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108169:	eb 48                	jmp    801081b3 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010816b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010816f:	74 0e                	je     8010817f <walkpgdir+0x53>
80108171:	e8 4f aa ff ff       	call   80102bc5 <kalloc>
80108176:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108179:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010817d:	75 07                	jne    80108186 <walkpgdir+0x5a>
      return 0;
8010817f:	b8 00 00 00 00       	mov    $0x0,%eax
80108184:	eb 44                	jmp    801081ca <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108186:	83 ec 04             	sub    $0x4,%esp
80108189:	68 00 10 00 00       	push   $0x1000
8010818e:	6a 00                	push   $0x0
80108190:	ff 75 f4             	pushl  -0xc(%ebp)
80108193:	e8 a1 d3 ff ff       	call   80105539 <memset>
80108198:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U
8010819b:	83 ec 0c             	sub    $0xc,%esp
8010819e:	ff 75 f4             	pushl  -0xc(%ebp)
801081a1:	e8 d9 fa ff ff       	call   80107c7f <v2p>
801081a6:	83 c4 10             	add    $0x10,%esp
801081a9:	83 c8 07             	or     $0x7,%eax
801081ac:	89 c2                	mov    %eax,%edx
801081ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081b1:	89 10                	mov    %edx,(%eax)
;  }
  return &pgtab[PTX(va)];
801081b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801081b6:	c1 e8 0c             	shr    $0xc,%eax
801081b9:	25 ff 03 00 00       	and    $0x3ff,%eax
801081be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c8:	01 d0                	add    %edx,%eax
}
801081ca:	c9                   	leave  
801081cb:	c3                   	ret    

801081cc <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801081cc:	55                   	push   %ebp
801081cd:	89 e5                	mov    %esp,%ebp
801081cf:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801081d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801081d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801081dd:	8b 55 0c             	mov    0xc(%ebp),%edx
801081e0:	8b 45 10             	mov    0x10(%ebp),%eax
801081e3:	01 d0                	add    %edx,%eax
801081e5:	83 e8 01             	sub    $0x1,%eax
801081e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801081f0:	83 ec 04             	sub    $0x4,%esp
801081f3:	6a 01                	push   $0x1
801081f5:	ff 75 f4             	pushl  -0xc(%ebp)
801081f8:	ff 75 08             	pushl  0x8(%ebp)
801081fb:	e8 2c ff ff ff       	call   8010812c <walkpgdir>
80108200:	83 c4 10             	add    $0x10,%esp
80108203:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108206:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010820a:	75 07                	jne    80108213 <mappages+0x47>
      return -1;
8010820c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108211:	eb 47                	jmp    8010825a <mappages+0x8e>
    if(*pte & PTE_P)
80108213:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108216:	8b 00                	mov    (%eax),%eax
80108218:	83 e0 01             	and    $0x1,%eax
8010821b:	85 c0                	test   %eax,%eax
8010821d:	74 0d                	je     8010822c <mappages+0x60>
      panic("remap");
8010821f:	83 ec 0c             	sub    $0xc,%esp
80108222:	68 6f 94 10 80       	push   $0x8010946f
80108227:	e8 3a 83 ff ff       	call   80100566 <panic>
  //  page_references[PTE_ADDR(*pte)] = 1; //give pte_t a reference of one since fork copy just stopped there
    *pte = pa | perm | PTE_P;
8010822c:	8b 45 18             	mov    0x18(%ebp),%eax
8010822f:	0b 45 14             	or     0x14(%ebp),%eax
80108232:	83 c8 01             	or     $0x1,%eax
80108235:	89 c2                	mov    %eax,%edx
80108237:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010823a:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010823c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108242:	74 10                	je     80108254 <mappages+0x88>
      break;
    a += PGSIZE;
80108244:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010824b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108252:	eb 9c                	jmp    801081f0 <mappages+0x24>
    if(*pte & PTE_P)
      panic("remap");
  //  page_references[PTE_ADDR(*pte)] = 1; //give pte_t a reference of one since fork copy just stopped there
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108254:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108255:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010825a:	c9                   	leave  
8010825b:	c3                   	ret    

8010825c <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010825c:	55                   	push   %ebp
8010825d:	89 e5                	mov    %esp,%ebp
8010825f:	53                   	push   %ebx
80108260:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108263:	e8 5d a9 ff ff       	call   80102bc5 <kalloc>
80108268:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010826b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010826f:	75 0a                	jne    8010827b <setupkvm+0x1f>
    return 0;
80108271:	b8 00 00 00 00       	mov    $0x0,%eax
80108276:	e9 8e 00 00 00       	jmp    80108309 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
8010827b:	83 ec 04             	sub    $0x4,%esp
8010827e:	68 00 10 00 00       	push   $0x1000
80108283:	6a 00                	push   $0x0
80108285:	ff 75 f0             	pushl  -0x10(%ebp)
80108288:	e8 ac d2 ff ff       	call   80105539 <memset>
8010828d:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108290:	83 ec 0c             	sub    $0xc,%esp
80108293:	68 00 00 00 0e       	push   $0xe000000
80108298:	e8 ef f9 ff ff       	call   80107c8c <p2v>
8010829d:	83 c4 10             	add    $0x10,%esp
801082a0:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801082a5:	76 0d                	jbe    801082b4 <setupkvm+0x58>
    panic("PHYSTOP too high");
801082a7:	83 ec 0c             	sub    $0xc,%esp
801082aa:	68 75 94 10 80       	push   $0x80109475
801082af:	e8 b2 82 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801082b4:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801082bb:	eb 40                	jmp    801082fd <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801082bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c0:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801082c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c6:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801082c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082cc:	8b 58 08             	mov    0x8(%eax),%ebx
801082cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d2:	8b 40 04             	mov    0x4(%eax),%eax
801082d5:	29 c3                	sub    %eax,%ebx
801082d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082da:	8b 00                	mov    (%eax),%eax
801082dc:	83 ec 0c             	sub    $0xc,%esp
801082df:	51                   	push   %ecx
801082e0:	52                   	push   %edx
801082e1:	53                   	push   %ebx
801082e2:	50                   	push   %eax
801082e3:	ff 75 f0             	pushl  -0x10(%ebp)
801082e6:	e8 e1 fe ff ff       	call   801081cc <mappages>
801082eb:	83 c4 20             	add    $0x20,%esp
801082ee:	85 c0                	test   %eax,%eax
801082f0:	79 07                	jns    801082f9 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801082f2:	b8 00 00 00 00       	mov    $0x0,%eax
801082f7:	eb 10                	jmp    80108309 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801082f9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801082fd:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108304:	72 b7                	jb     801082bd <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108306:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108309:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010830c:	c9                   	leave  
8010830d:	c3                   	ret    

8010830e <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010830e:	55                   	push   %ebp
8010830f:	89 e5                	mov    %esp,%ebp
80108311:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108314:	e8 43 ff ff ff       	call   8010825c <setupkvm>
80108319:	a3 98 65 21 80       	mov    %eax,0x80216598
  switchkvm();
8010831e:	e8 03 00 00 00       	call   80108326 <switchkvm>
}
80108323:	90                   	nop
80108324:	c9                   	leave  
80108325:	c3                   	ret    

80108326 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108326:	55                   	push   %ebp
80108327:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108329:	a1 98 65 21 80       	mov    0x80216598,%eax
8010832e:	50                   	push   %eax
8010832f:	e8 4b f9 ff ff       	call   80107c7f <v2p>
80108334:	83 c4 04             	add    $0x4,%esp
80108337:	50                   	push   %eax
80108338:	e8 36 f9 ff ff       	call   80107c73 <lcr3>
8010833d:	83 c4 04             	add    $0x4,%esp
}
80108340:	90                   	nop
80108341:	c9                   	leave  
80108342:	c3                   	ret    

80108343 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108343:	55                   	push   %ebp
80108344:	89 e5                	mov    %esp,%ebp
80108346:	56                   	push   %esi
80108347:	53                   	push   %ebx
  pushcli();
80108348:	e8 e6 d0 ff ff       	call   80105433 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010834d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108353:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010835a:	83 c2 08             	add    $0x8,%edx
8010835d:	89 d6                	mov    %edx,%esi
8010835f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108366:	83 c2 08             	add    $0x8,%edx
80108369:	c1 ea 10             	shr    $0x10,%edx
8010836c:	89 d3                	mov    %edx,%ebx
8010836e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108375:	83 c2 08             	add    $0x8,%edx
80108378:	c1 ea 18             	shr    $0x18,%edx
8010837b:	89 d1                	mov    %edx,%ecx
8010837d:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108384:	67 00 
80108386:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
8010838d:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108393:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010839a:	83 e2 f0             	and    $0xfffffff0,%edx
8010839d:	83 ca 09             	or     $0x9,%edx
801083a0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801083a6:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083ad:	83 ca 10             	or     $0x10,%edx
801083b0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801083b6:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083bd:	83 e2 9f             	and    $0xffffff9f,%edx
801083c0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801083c6:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083cd:	83 ca 80             	or     $0xffffff80,%edx
801083d0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801083d6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801083dd:	83 e2 f0             	and    $0xfffffff0,%edx
801083e0:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801083e6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801083ed:	83 e2 ef             	and    $0xffffffef,%edx
801083f0:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801083f6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801083fd:	83 e2 df             	and    $0xffffffdf,%edx
80108400:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108406:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010840d:	83 ca 40             	or     $0x40,%edx
80108410:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108416:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010841d:	83 e2 7f             	and    $0x7f,%edx
80108420:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108426:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010842c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108432:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108439:	83 e2 ef             	and    $0xffffffef,%edx
8010843c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108442:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108448:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010844e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108454:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010845b:	8b 52 08             	mov    0x8(%edx),%edx
8010845e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108464:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108467:	83 ec 0c             	sub    $0xc,%esp
8010846a:	6a 30                	push   $0x30
8010846c:	e8 d5 f7 ff ff       	call   80107c46 <ltr>
80108471:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80108474:	8b 45 08             	mov    0x8(%ebp),%eax
80108477:	8b 40 04             	mov    0x4(%eax),%eax
8010847a:	85 c0                	test   %eax,%eax
8010847c:	75 0d                	jne    8010848b <switchuvm+0x148>
    panic("switchuvm: no pgdir");
8010847e:	83 ec 0c             	sub    $0xc,%esp
80108481:	68 86 94 10 80       	push   $0x80109486
80108486:	e8 db 80 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010848b:	8b 45 08             	mov    0x8(%ebp),%eax
8010848e:	8b 40 04             	mov    0x4(%eax),%eax
80108491:	83 ec 0c             	sub    $0xc,%esp
80108494:	50                   	push   %eax
80108495:	e8 e5 f7 ff ff       	call   80107c7f <v2p>
8010849a:	83 c4 10             	add    $0x10,%esp
8010849d:	83 ec 0c             	sub    $0xc,%esp
801084a0:	50                   	push   %eax
801084a1:	e8 cd f7 ff ff       	call   80107c73 <lcr3>
801084a6:	83 c4 10             	add    $0x10,%esp
  popcli();
801084a9:	e8 ca cf ff ff       	call   80105478 <popcli>
}
801084ae:	90                   	nop
801084af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801084b2:	5b                   	pop    %ebx
801084b3:	5e                   	pop    %esi
801084b4:	5d                   	pop    %ebp
801084b5:	c3                   	ret    

801084b6 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801084b6:	55                   	push   %ebp
801084b7:	89 e5                	mov    %esp,%ebp
801084b9:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
801084bc:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801084c3:	76 0d                	jbe    801084d2 <inituvm+0x1c>
    panic("inituvm: more than a page");
801084c5:	83 ec 0c             	sub    $0xc,%esp
801084c8:	68 9a 94 10 80       	push   $0x8010949a
801084cd:	e8 94 80 ff ff       	call   80100566 <panic>
  mem = kalloc();
801084d2:	e8 ee a6 ff ff       	call   80102bc5 <kalloc>
801084d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801084da:	83 ec 04             	sub    $0x4,%esp
801084dd:	68 00 10 00 00       	push   $0x1000
801084e2:	6a 00                	push   $0x0
801084e4:	ff 75 f4             	pushl  -0xc(%ebp)
801084e7:	e8 4d d0 ff ff       	call   80105539 <memset>
801084ec:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801084ef:	83 ec 0c             	sub    $0xc,%esp
801084f2:	ff 75 f4             	pushl  -0xc(%ebp)
801084f5:	e8 85 f7 ff ff       	call   80107c7f <v2p>
801084fa:	83 c4 10             	add    $0x10,%esp
801084fd:	83 ec 0c             	sub    $0xc,%esp
80108500:	6a 06                	push   $0x6
80108502:	50                   	push   %eax
80108503:	68 00 10 00 00       	push   $0x1000
80108508:	6a 00                	push   $0x0
8010850a:	ff 75 08             	pushl  0x8(%ebp)
8010850d:	e8 ba fc ff ff       	call   801081cc <mappages>
80108512:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108515:	83 ec 04             	sub    $0x4,%esp
80108518:	ff 75 10             	pushl  0x10(%ebp)
8010851b:	ff 75 0c             	pushl  0xc(%ebp)
8010851e:	ff 75 f4             	pushl  -0xc(%ebp)
80108521:	e8 d2 d0 ff ff       	call   801055f8 <memmove>
80108526:	83 c4 10             	add    $0x10,%esp
}
80108529:	90                   	nop
8010852a:	c9                   	leave  
8010852b:	c3                   	ret    

8010852c <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010852c:	55                   	push   %ebp
8010852d:	89 e5                	mov    %esp,%ebp
8010852f:	53                   	push   %ebx
80108530:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108533:	8b 45 0c             	mov    0xc(%ebp),%eax
80108536:	25 ff 0f 00 00       	and    $0xfff,%eax
8010853b:	85 c0                	test   %eax,%eax
8010853d:	74 0d                	je     8010854c <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
8010853f:	83 ec 0c             	sub    $0xc,%esp
80108542:	68 b4 94 10 80       	push   $0x801094b4
80108547:	e8 1a 80 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010854c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108553:	e9 95 00 00 00       	jmp    801085ed <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108558:	8b 55 0c             	mov    0xc(%ebp),%edx
8010855b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010855e:	01 d0                	add    %edx,%eax
80108560:	83 ec 04             	sub    $0x4,%esp
80108563:	6a 00                	push   $0x0
80108565:	50                   	push   %eax
80108566:	ff 75 08             	pushl  0x8(%ebp)
80108569:	e8 be fb ff ff       	call   8010812c <walkpgdir>
8010856e:	83 c4 10             	add    $0x10,%esp
80108571:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108574:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108578:	75 0d                	jne    80108587 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
8010857a:	83 ec 0c             	sub    $0xc,%esp
8010857d:	68 d7 94 10 80       	push   $0x801094d7
80108582:	e8 df 7f ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108587:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010858a:	8b 00                	mov    (%eax),%eax
8010858c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108591:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108594:	8b 45 18             	mov    0x18(%ebp),%eax
80108597:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010859a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010859f:	77 0b                	ja     801085ac <loaduvm+0x80>
      n = sz - i;
801085a1:	8b 45 18             	mov    0x18(%ebp),%eax
801085a4:	2b 45 f4             	sub    -0xc(%ebp),%eax
801085a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801085aa:	eb 07                	jmp    801085b3 <loaduvm+0x87>
    else
      n = PGSIZE;
801085ac:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801085b3:	8b 55 14             	mov    0x14(%ebp),%edx
801085b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b9:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801085bc:	83 ec 0c             	sub    $0xc,%esp
801085bf:	ff 75 e8             	pushl  -0x18(%ebp)
801085c2:	e8 c5 f6 ff ff       	call   80107c8c <p2v>
801085c7:	83 c4 10             	add    $0x10,%esp
801085ca:	ff 75 f0             	pushl  -0x10(%ebp)
801085cd:	53                   	push   %ebx
801085ce:	50                   	push   %eax
801085cf:	ff 75 10             	pushl  0x10(%ebp)
801085d2:	e8 9c 98 ff ff       	call   80101e73 <readi>
801085d7:	83 c4 10             	add    $0x10,%esp
801085da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801085dd:	74 07                	je     801085e6 <loaduvm+0xba>
      return -1;
801085df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801085e4:	eb 18                	jmp    801085fe <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801085e6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801085ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f0:	3b 45 18             	cmp    0x18(%ebp),%eax
801085f3:	0f 82 5f ff ff ff    	jb     80108558 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801085f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801085fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108601:	c9                   	leave  
80108602:	c3                   	ret    

80108603 <mprotect>:

int
mprotect(void *addr, int len, int prot)
{
80108603:	55                   	push   %ebp
80108604:	89 e5                	mov    %esp,%ebp
80108606:	83 ec 18             	sub    $0x18,%esp
  pte_t *page_table_entry;
  cprintf("*addr: %d\n",(uint)addr);
80108609:	8b 45 08             	mov    0x8(%ebp),%eax
8010860c:	83 ec 08             	sub    $0x8,%esp
8010860f:	50                   	push   %eax
80108610:	68 f5 94 10 80       	push   $0x801094f5
80108615:	e8 ac 7d ff ff       	call   801003c6 <cprintf>
8010861a:	83 c4 10             	add    $0x10,%esp
  //might need to PGRDWN the address
  //loop through all the page entries that need protection level changed
  //makes prot cnstants change in types.h
  //break it down, use PTE
  // cprintf("addr: %d\n",(int)addr);
  uint base_addr = PGROUNDDOWN((uint)addr);
8010861d:	8b 45 08             	mov    0x8(%ebp),%eax
80108620:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108625:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint curr = base_addr;
80108628:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010862b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  do {

    page_table_entry = walkpgdir(proc->pgdir,(void *)curr ,0);
8010862e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108631:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108637:	8b 40 04             	mov    0x4(%eax),%eax
8010863a:	83 ec 04             	sub    $0x4,%esp
8010863d:	6a 00                	push   $0x0
8010863f:	52                   	push   %edx
80108640:	50                   	push   %eax
80108641:	e8 e6 fa ff ff       	call   8010812c <walkpgdir>
80108646:	83 c4 10             	add    $0x10,%esp
80108649:	89 45 ec             	mov    %eax,-0x14(%ebp)
    curr += PGSIZE;
8010864c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    //clear last 3 bits
    cprintf("page table entry before: 0x%x desireced prot = %d\n",*page_table_entry,prot);
80108653:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108656:	8b 00                	mov    (%eax),%eax
80108658:	83 ec 04             	sub    $0x4,%esp
8010865b:	ff 75 10             	pushl  0x10(%ebp)
8010865e:	50                   	push   %eax
8010865f:	68 00 95 10 80       	push   $0x80109500
80108664:	e8 5d 7d ff ff       	call   801003c6 <cprintf>
80108669:	83 c4 10             	add    $0x10,%esp
    //clear last 3 bits
    *page_table_entry &= 0xfffffff9;
8010866c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010866f:	8b 00                	mov    (%eax),%eax
80108671:	83 e0 f9             	and    $0xfffffff9,%eax
80108674:	89 c2                	mov    %eax,%edx
80108676:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108679:	89 10                	mov    %edx,(%eax)
    // cprintf("page table entry after clear: 0x%x\n",*page_table_entry);
    switch(prot) {
8010867b:	8b 45 10             	mov    0x10(%ebp),%eax
8010867e:	83 f8 01             	cmp    $0x1,%eax
80108681:	74 28                	je     801086ab <mprotect+0xa8>
80108683:	83 f8 01             	cmp    $0x1,%eax
80108686:	7f 06                	jg     8010868e <mprotect+0x8b>
80108688:	85 c0                	test   %eax,%eax
8010868a:	74 0e                	je     8010869a <mprotect+0x97>
8010868c:	eb 4e                	jmp    801086dc <mprotect+0xd9>
8010868e:	83 f8 02             	cmp    $0x2,%eax
80108691:	74 29                	je     801086bc <mprotect+0xb9>
80108693:	83 f8 03             	cmp    $0x3,%eax
80108696:	74 35                	je     801086cd <mprotect+0xca>
80108698:	eb 42                	jmp    801086dc <mprotect+0xd9>
      case PROT_NONE:
        *page_table_entry |= PTE_P;
8010869a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010869d:	8b 00                	mov    (%eax),%eax
8010869f:	83 c8 01             	or     $0x1,%eax
801086a2:	89 c2                	mov    %eax,%edx
801086a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086a7:	89 10                	mov    %edx,(%eax)
        break;
801086a9:	eb 31                	jmp    801086dc <mprotect+0xd9>
      case PROT_READ:
        *page_table_entry |= (PTE_P | PTE_U);
801086ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086ae:	8b 00                	mov    (%eax),%eax
801086b0:	83 c8 05             	or     $0x5,%eax
801086b3:	89 c2                	mov    %eax,%edx
801086b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086b8:	89 10                	mov    %edx,(%eax)
        break;
801086ba:	eb 20                	jmp    801086dc <mprotect+0xd9>
      case PROT_WRITE:
        *page_table_entry |= (PTE_P | PTE_W);
801086bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086bf:	8b 00                	mov    (%eax),%eax
801086c1:	83 c8 03             	or     $0x3,%eax
801086c4:	89 c2                	mov    %eax,%edx
801086c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086c9:	89 10                	mov    %edx,(%eax)
        break;
801086cb:	eb 0f                	jmp    801086dc <mprotect+0xd9>
      case PROT_READ | PROT_WRITE:
        *page_table_entry |= (PTE_P | PTE_W | PTE_U);
801086cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086d0:	8b 00                	mov    (%eax),%eax
801086d2:	83 c8 07             	or     $0x7,%eax
801086d5:	89 c2                	mov    %eax,%edx
801086d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086da:	89 10                	mov    %edx,(%eax)
    }
    cprintf("page table entry after: 0x%x\n",*page_table_entry);
801086dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086df:	8b 00                	mov    (%eax),%eax
801086e1:	83 ec 08             	sub    $0x8,%esp
801086e4:	50                   	push   %eax
801086e5:	68 33 95 10 80       	push   $0x80109533
801086ea:	e8 d7 7c ff ff       	call   801003c6 <cprintf>
801086ef:	83 c4 10             	add    $0x10,%esp
  } while(curr < ((uint)addr +len));
801086f2:	8b 55 08             	mov    0x8(%ebp),%edx
801086f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801086f8:	01 d0                	add    %edx,%eax
801086fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801086fd:	0f 87 2b ff ff ff    	ja     8010862e <mprotect+0x2b>

  //flush that tlb real good
  lcr3(v2p(proc->pgdir));
80108703:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108709:	8b 40 04             	mov    0x4(%eax),%eax
8010870c:	83 ec 0c             	sub    $0xc,%esp
8010870f:	50                   	push   %eax
80108710:	e8 6a f5 ff ff       	call   80107c7f <v2p>
80108715:	83 c4 10             	add    $0x10,%esp
80108718:	83 ec 0c             	sub    $0xc,%esp
8010871b:	50                   	push   %eax
8010871c:	e8 52 f5 ff ff       	call   80107c73 <lcr3>
80108721:	83 c4 10             	add    $0x10,%esp
  // cprintf("returning from mprotect\n");
  return 0; ///what happens after returned?
80108724:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108729:	c9                   	leave  
8010872a:	c3                   	ret    

8010872b <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010872b:	55                   	push   %ebp
8010872c:	89 e5                	mov    %esp,%ebp
8010872e:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108731:	8b 45 10             	mov    0x10(%ebp),%eax
80108734:	85 c0                	test   %eax,%eax
80108736:	79 0a                	jns    80108742 <allocuvm+0x17>
    return 0;
80108738:	b8 00 00 00 00       	mov    $0x0,%eax
8010873d:	e9 b0 00 00 00       	jmp    801087f2 <allocuvm+0xc7>
  if(newsz < oldsz)
80108742:	8b 45 10             	mov    0x10(%ebp),%eax
80108745:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108748:	73 08                	jae    80108752 <allocuvm+0x27>
    return oldsz;
8010874a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010874d:	e9 a0 00 00 00       	jmp    801087f2 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108752:	8b 45 0c             	mov    0xc(%ebp),%eax
80108755:	05 ff 0f 00 00       	add    $0xfff,%eax
8010875a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010875f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108762:	eb 7f                	jmp    801087e3 <allocuvm+0xb8>
    mem = kalloc();
80108764:	e8 5c a4 ff ff       	call   80102bc5 <kalloc>
80108769:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010876c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108770:	75 2b                	jne    8010879d <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108772:	83 ec 0c             	sub    $0xc,%esp
80108775:	68 51 95 10 80       	push   $0x80109551
8010877a:	e8 47 7c ff ff       	call   801003c6 <cprintf>
8010877f:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108782:	83 ec 04             	sub    $0x4,%esp
80108785:	ff 75 0c             	pushl  0xc(%ebp)
80108788:	ff 75 10             	pushl  0x10(%ebp)
8010878b:	ff 75 08             	pushl  0x8(%ebp)
8010878e:	e8 61 00 00 00       	call   801087f4 <deallocuvm>
80108793:	83 c4 10             	add    $0x10,%esp
      return 0;
80108796:	b8 00 00 00 00       	mov    $0x0,%eax
8010879b:	eb 55                	jmp    801087f2 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
8010879d:	83 ec 04             	sub    $0x4,%esp
801087a0:	68 00 10 00 00       	push   $0x1000
801087a5:	6a 00                	push   $0x0
801087a7:	ff 75 f0             	pushl  -0x10(%ebp)
801087aa:	e8 8a cd ff ff       	call   80105539 <memset>
801087af:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801087b2:	83 ec 0c             	sub    $0xc,%esp
801087b5:	ff 75 f0             	pushl  -0x10(%ebp)
801087b8:	e8 c2 f4 ff ff       	call   80107c7f <v2p>
801087bd:	83 c4 10             	add    $0x10,%esp
801087c0:	89 c2                	mov    %eax,%edx
801087c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087c5:	83 ec 0c             	sub    $0xc,%esp
801087c8:	6a 06                	push   $0x6
801087ca:	52                   	push   %edx
801087cb:	68 00 10 00 00       	push   $0x1000
801087d0:	50                   	push   %eax
801087d1:	ff 75 08             	pushl  0x8(%ebp)
801087d4:	e8 f3 f9 ff ff       	call   801081cc <mappages>
801087d9:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801087dc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801087e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e6:	3b 45 10             	cmp    0x10(%ebp),%eax
801087e9:	0f 82 75 ff ff ff    	jb     80108764 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801087ef:	8b 45 10             	mov    0x10(%ebp),%eax
}
801087f2:	c9                   	leave  
801087f3:	c3                   	ret    

801087f4 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801087f4:	55                   	push   %ebp
801087f5:	89 e5                	mov    %esp,%ebp
801087f7:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801087fa:	8b 45 10             	mov    0x10(%ebp),%eax
801087fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108800:	72 08                	jb     8010880a <deallocuvm+0x16>
    return oldsz;
80108802:	8b 45 0c             	mov    0xc(%ebp),%eax
80108805:	e9 54 01 00 00       	jmp    8010895e <deallocuvm+0x16a>

  a = PGROUNDUP(newsz);
8010880a:	8b 45 10             	mov    0x10(%ebp),%eax
8010880d:	05 ff 0f 00 00       	add    $0xfff,%eax
80108812:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108817:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010881a:	e9 30 01 00 00       	jmp    8010894f <deallocuvm+0x15b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010881f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108822:	83 ec 04             	sub    $0x4,%esp
80108825:	6a 00                	push   $0x0
80108827:	50                   	push   %eax
80108828:	ff 75 08             	pushl  0x8(%ebp)
8010882b:	e8 fc f8 ff ff       	call   8010812c <walkpgdir>
80108830:	83 c4 10             	add    $0x10,%esp
80108833:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108836:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010883a:	75 0c                	jne    80108848 <deallocuvm+0x54>
      a += (NPTENTRIES - 1) * PGSIZE;
8010883c:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108843:	e9 00 01 00 00       	jmp    80108948 <deallocuvm+0x154>
    else if((*pte & PTE_P) != 0){
80108848:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010884b:	8b 00                	mov    (%eax),%eax
8010884d:	83 e0 01             	and    $0x1,%eax
80108850:	85 c0                	test   %eax,%eax
80108852:	0f 84 f0 00 00 00    	je     80108948 <deallocuvm+0x154>
      pa = PTE_ADDR(*pte);
80108858:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010885b:	8b 00                	mov    (%eax),%eax
8010885d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108862:	89 45 ec             	mov    %eax,-0x14(%ebp)
      acquire(&pte_lookup_table.lock);
80108865:	83 ec 0c             	sub    $0xc,%esp
80108868:	68 20 65 21 80       	push   $0x80216520
8010886d:	e8 64 ca ff ff       	call   801052d6 <acquire>
80108872:	83 c4 10             	add    $0x10,%esp
        if(pte_lookup_table.pte_array[pa/PGSIZE] < 2){
80108875:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108878:	c1 e8 0c             	shr    $0xc,%eax
8010887b:	0f b6 80 20 65 11 80 	movzbl -0x7fee9ae0(%eax),%eax
80108882:	3c 01                	cmp    $0x1,%al
80108884:	7f 4d                	jg     801088d3 <deallocuvm+0xdf>
          if(pa == 0) {
80108886:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010888a:	75 1d                	jne    801088a9 <deallocuvm+0xb5>
            release(&pte_lookup_table.lock);
8010888c:	83 ec 0c             	sub    $0xc,%esp
8010888f:	68 20 65 21 80       	push   $0x80216520
80108894:	e8 a4 ca ff ff       	call   8010533d <release>
80108899:	83 c4 10             	add    $0x10,%esp
            panic("kfree");
8010889c:	83 ec 0c             	sub    $0xc,%esp
8010889f:	68 69 95 10 80       	push   $0x80109569
801088a4:	e8 bd 7c ff ff       	call   80100566 <panic>
          }
          char *v = p2v(pa);
801088a9:	83 ec 0c             	sub    $0xc,%esp
801088ac:	ff 75 ec             	pushl  -0x14(%ebp)
801088af:	e8 d8 f3 ff ff       	call   80107c8c <p2v>
801088b4:	83 c4 10             	add    $0x10,%esp
801088b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
          kfree(v);
801088ba:	83 ec 0c             	sub    $0xc,%esp
801088bd:	ff 75 e8             	pushl  -0x18(%ebp)
801088c0:	e8 63 a2 ff ff       	call   80102b28 <kfree>
801088c5:	83 c4 10             	add    $0x10,%esp
          *pte = 0;
801088c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801088d1:	eb 65                	jmp    80108938 <deallocuvm+0x144>
        } else if(pte_lookup_table.pte_array[pa/PGSIZE] == 2) { //need to decrement and make mem writable
801088d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088d6:	c1 e8 0c             	shr    $0xc,%eax
801088d9:	0f b6 80 20 65 11 80 	movzbl -0x7fee9ae0(%eax),%eax
801088e0:	3c 02                	cmp    $0x2,%al
801088e2:	75 2e                	jne    80108912 <deallocuvm+0x11e>
          cprintf("I AM TRYING TO DEALLOCATE SECOND MEM WITH 2 POINTERS\n");
801088e4:	83 ec 0c             	sub    $0xc,%esp
801088e7:	68 70 95 10 80       	push   $0x80109570
801088ec:	e8 d5 7a ff ff       	call   801003c6 <cprintf>
801088f1:	83 c4 10             	add    $0x10,%esp
          *pte |= PTE_W; //you may now write
801088f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088f7:	8b 00                	mov    (%eax),%eax
801088f9:	83 c8 02             	or     $0x2,%eax
801088fc:	89 c2                	mov    %eax,%edx
801088fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108901:	89 10                	mov    %edx,(%eax)
          pte_lookup_table.pte_array[pa/PGSIZE] = 1;
80108903:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108906:	c1 e8 0c             	shr    $0xc,%eax
80108909:	c6 80 20 65 11 80 01 	movb   $0x1,-0x7fee9ae0(%eax)
80108910:	eb 26                	jmp    80108938 <deallocuvm+0x144>
        } else {
          cprintf("DEALLOC ELSE? \n");
80108912:	83 ec 0c             	sub    $0xc,%esp
80108915:	68 a6 95 10 80       	push   $0x801095a6
8010891a:	e8 a7 7a ff ff       	call   801003c6 <cprintf>
8010891f:	83 c4 10             	add    $0x10,%esp
          pte_lookup_table.pte_array[pa/PGSIZE]--;
80108922:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108925:	c1 e8 0c             	shr    $0xc,%eax
80108928:	0f b6 90 20 65 11 80 	movzbl -0x7fee9ae0(%eax),%edx
8010892f:	83 ea 01             	sub    $0x1,%edx
80108932:	88 90 20 65 11 80    	mov    %dl,-0x7fee9ae0(%eax)
        }
      release(&pte_lookup_table.lock);
80108938:	83 ec 0c             	sub    $0xc,%esp
8010893b:	68 20 65 21 80       	push   $0x80216520
80108940:	e8 f8 c9 ff ff       	call   8010533d <release>
80108945:	83 c4 10             	add    $0x10,%esp

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108948:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010894f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108952:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108955:	0f 82 c4 fe ff ff    	jb     8010881f <deallocuvm+0x2b>
        }
      release(&pte_lookup_table.lock);
      //need to update entries in page table here
    }
  }
  return newsz;
8010895b:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010895e:	c9                   	leave  
8010895f:	c3                   	ret    

80108960 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108960:	55                   	push   %ebp
80108961:	89 e5                	mov    %esp,%ebp
80108963:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108966:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010896a:	75 0d                	jne    80108979 <freevm+0x19>
    panic("freevm: no pgdir");
8010896c:	83 ec 0c             	sub    $0xc,%esp
8010896f:	68 b6 95 10 80       	push   $0x801095b6
80108974:	e8 ed 7b ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108979:	83 ec 04             	sub    $0x4,%esp
8010897c:	6a 00                	push   $0x0
8010897e:	68 00 00 00 80       	push   $0x80000000
80108983:	ff 75 08             	pushl  0x8(%ebp)
80108986:	e8 69 fe ff ff       	call   801087f4 <deallocuvm>
8010898b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010898e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108995:	eb 4f                	jmp    801089e6 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108997:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010899a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801089a1:	8b 45 08             	mov    0x8(%ebp),%eax
801089a4:	01 d0                	add    %edx,%eax
801089a6:	8b 00                	mov    (%eax),%eax
801089a8:	83 e0 01             	and    $0x1,%eax
801089ab:	85 c0                	test   %eax,%eax
801089ad:	74 33                	je     801089e2 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801089af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801089b9:	8b 45 08             	mov    0x8(%ebp),%eax
801089bc:	01 d0                	add    %edx,%eax
801089be:	8b 00                	mov    (%eax),%eax
801089c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089c5:	83 ec 0c             	sub    $0xc,%esp
801089c8:	50                   	push   %eax
801089c9:	e8 be f2 ff ff       	call   80107c8c <p2v>
801089ce:	83 c4 10             	add    $0x10,%esp
801089d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801089d4:	83 ec 0c             	sub    $0xc,%esp
801089d7:	ff 75 f0             	pushl  -0x10(%ebp)
801089da:	e8 49 a1 ff ff       	call   80102b28 <kfree>
801089df:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801089e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801089e6:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801089ed:	76 a8                	jbe    80108997 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801089ef:	83 ec 0c             	sub    $0xc,%esp
801089f2:	ff 75 08             	pushl  0x8(%ebp)
801089f5:	e8 2e a1 ff ff       	call   80102b28 <kfree>
801089fa:	83 c4 10             	add    $0x10,%esp
}
801089fd:	90                   	nop
801089fe:	c9                   	leave  
801089ff:	c3                   	ret    

80108a00 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108a00:	55                   	push   %ebp
80108a01:	89 e5                	mov    %esp,%ebp
80108a03:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a06:	83 ec 04             	sub    $0x4,%esp
80108a09:	6a 00                	push   $0x0
80108a0b:	ff 75 0c             	pushl  0xc(%ebp)
80108a0e:	ff 75 08             	pushl  0x8(%ebp)
80108a11:	e8 16 f7 ff ff       	call   8010812c <walkpgdir>
80108a16:	83 c4 10             	add    $0x10,%esp
80108a19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108a1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108a20:	75 0d                	jne    80108a2f <clearpteu+0x2f>
    panic("clearpteu");
80108a22:	83 ec 0c             	sub    $0xc,%esp
80108a25:	68 c7 95 10 80       	push   $0x801095c7
80108a2a:	e8 37 7b ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80108a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a32:	8b 00                	mov    (%eax),%eax
80108a34:	83 e0 fb             	and    $0xfffffffb,%eax
80108a37:	89 c2                	mov    %eax,%edx
80108a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a3c:	89 10                	mov    %edx,(%eax)
}
80108a3e:	90                   	nop
80108a3f:	c9                   	leave  
80108a40:	c3                   	ret    

80108a41 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108a41:	55                   	push   %ebp
80108a42:	89 e5                	mov    %esp,%ebp
80108a44:	53                   	push   %ebx
80108a45:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108a48:	e8 0f f8 ff ff       	call   8010825c <setupkvm>
80108a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108a50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a54:	75 0a                	jne    80108a60 <copyuvm+0x1f>
    return 0;
80108a56:	b8 00 00 00 00       	mov    $0x0,%eax
80108a5b:	e9 f8 00 00 00       	jmp    80108b58 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108a60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a67:	e9 c4 00 00 00       	jmp    80108b30 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a6f:	83 ec 04             	sub    $0x4,%esp
80108a72:	6a 00                	push   $0x0
80108a74:	50                   	push   %eax
80108a75:	ff 75 08             	pushl  0x8(%ebp)
80108a78:	e8 af f6 ff ff       	call   8010812c <walkpgdir>
80108a7d:	83 c4 10             	add    $0x10,%esp
80108a80:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108a83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a87:	75 0d                	jne    80108a96 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108a89:	83 ec 0c             	sub    $0xc,%esp
80108a8c:	68 d1 95 10 80       	push   $0x801095d1
80108a91:	e8 d0 7a ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a99:	8b 00                	mov    (%eax),%eax
80108a9b:	83 e0 01             	and    $0x1,%eax
80108a9e:	85 c0                	test   %eax,%eax
80108aa0:	75 0d                	jne    80108aaf <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108aa2:	83 ec 0c             	sub    $0xc,%esp
80108aa5:	68 eb 95 10 80       	push   $0x801095eb
80108aaa:	e8 b7 7a ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ab2:	8b 00                	mov    (%eax),%eax
80108ab4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ab9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108abf:	8b 00                	mov    (%eax),%eax
80108ac1:	25 ff 0f 00 00       	and    $0xfff,%eax
80108ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108ac9:	e8 f7 a0 ff ff       	call   80102bc5 <kalloc>
80108ace:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108ad1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108ad5:	74 6a                	je     80108b41 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108ad7:	83 ec 0c             	sub    $0xc,%esp
80108ada:	ff 75 e8             	pushl  -0x18(%ebp)
80108add:	e8 aa f1 ff ff       	call   80107c8c <p2v>
80108ae2:	83 c4 10             	add    $0x10,%esp
80108ae5:	83 ec 04             	sub    $0x4,%esp
80108ae8:	68 00 10 00 00       	push   $0x1000
80108aed:	50                   	push   %eax
80108aee:	ff 75 e0             	pushl  -0x20(%ebp)
80108af1:	e8 02 cb ff ff       	call   801055f8 <memmove>
80108af6:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108af9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108afc:	83 ec 0c             	sub    $0xc,%esp
80108aff:	ff 75 e0             	pushl  -0x20(%ebp)
80108b02:	e8 78 f1 ff ff       	call   80107c7f <v2p>
80108b07:	83 c4 10             	add    $0x10,%esp
80108b0a:	89 c2                	mov    %eax,%edx
80108b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b0f:	83 ec 0c             	sub    $0xc,%esp
80108b12:	53                   	push   %ebx
80108b13:	52                   	push   %edx
80108b14:	68 00 10 00 00       	push   $0x1000
80108b19:	50                   	push   %eax
80108b1a:	ff 75 f0             	pushl  -0x10(%ebp)
80108b1d:	e8 aa f6 ff ff       	call   801081cc <mappages>
80108b22:	83 c4 20             	add    $0x20,%esp
80108b25:	85 c0                	test   %eax,%eax
80108b27:	78 1b                	js     80108b44 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108b29:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b33:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108b36:	0f 82 30 ff ff ff    	jb     80108a6c <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b3f:	eb 17                	jmp    80108b58 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108b41:	90                   	nop
80108b42:	eb 01                	jmp    80108b45 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108b44:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108b45:	83 ec 0c             	sub    $0xc,%esp
80108b48:	ff 75 f0             	pushl  -0x10(%ebp)
80108b4b:	e8 10 fe ff ff       	call   80108960 <freevm>
80108b50:	83 c4 10             	add    $0x10,%esp
  return 0;
80108b53:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108b5b:	c9                   	leave  
80108b5c:	c3                   	ret    

80108b5d <copyuvm_cow>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm_cow(pde_t *pgdir, uint sz)
{
80108b5d:	55                   	push   %ebp
80108b5e:	89 e5                	mov    %esp,%ebp
80108b60:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108b63:	e8 f4 f6 ff ff       	call   8010825c <setupkvm>
80108b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108b6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b6f:	75 0a                	jne    80108b7b <copyuvm_cow+0x1e>
    return 0;
80108b71:	b8 00 00 00 00       	mov    $0x0,%eax
80108b76:	e9 6b 01 00 00       	jmp    80108ce6 <copyuvm_cow+0x189>
  for(i = 0; i < sz; i += PGSIZE){
80108b7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b82:	e9 0d 01 00 00       	jmp    80108c94 <copyuvm_cow+0x137>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b8a:	83 ec 04             	sub    $0x4,%esp
80108b8d:	6a 00                	push   $0x0
80108b8f:	50                   	push   %eax
80108b90:	ff 75 08             	pushl  0x8(%ebp)
80108b93:	e8 94 f5 ff ff       	call   8010812c <walkpgdir>
80108b98:	83 c4 10             	add    $0x10,%esp
80108b9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108b9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108ba2:	75 0d                	jne    80108bb1 <copyuvm_cow+0x54>
      panic("copyuvm: pte should exist");
80108ba4:	83 ec 0c             	sub    $0xc,%esp
80108ba7:	68 d1 95 10 80       	push   $0x801095d1
80108bac:	e8 b5 79 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bb4:	8b 00                	mov    (%eax),%eax
80108bb6:	83 e0 01             	and    $0x1,%eax
80108bb9:	85 c0                	test   %eax,%eax
80108bbb:	75 0d                	jne    80108bca <copyuvm_cow+0x6d>
      panic("copyuvm: page not present");
80108bbd:	83 ec 0c             	sub    $0xc,%esp
80108bc0:	68 eb 95 10 80       	push   $0x801095eb
80108bc5:	e8 9c 79 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bcd:	8b 00                	mov    (%eax),%eax
80108bcf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bd4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bda:	8b 00                	mov    (%eax),%eax
80108bdc:	25 ff 0f 00 00       	and    $0xfff,%eax
80108be1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108be4:	e8 dc 9f ff ff       	call   80102bc5 <kalloc>
80108be9:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108bec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108bf0:	0f 84 c9 00 00 00    	je     80108cbf <copyuvm_cow+0x162>
      goto bad;
    acquire(&pte_lookup_table.lock);
80108bf6:	83 ec 0c             	sub    $0xc,%esp
80108bf9:	68 20 65 21 80       	push   $0x80216520
80108bfe:	e8 d3 c6 ff ff       	call   801052d6 <acquire>
80108c03:	83 c4 10             	add    $0x10,%esp
      if(pte_lookup_table.pte_array[pa/PGSIZE] == 0) { //page fault
80108c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c09:	c1 e8 0c             	shr    $0xc,%eax
80108c0c:	0f b6 80 20 65 11 80 	movzbl -0x7fee9ae0(%eax),%eax
80108c13:	84 c0                	test   %al,%al
80108c15:	75 1f                	jne    80108c36 <copyuvm_cow+0xd9>
        cprintf("ITS TWO!\n");
80108c17:	83 ec 0c             	sub    $0xc,%esp
80108c1a:	68 05 96 10 80       	push   $0x80109605
80108c1f:	e8 a2 77 ff ff       	call   801003c6 <cprintf>
80108c24:	83 c4 10             	add    $0x10,%esp
        pte_lookup_table.pte_array[pa/PGSIZE] = 2; //now child + father fork are pointing at it
80108c27:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c2a:	c1 e8 0c             	shr    $0xc,%eax
80108c2d:	c6 80 20 65 11 80 02 	movb   $0x2,-0x7fee9ae0(%eax)
80108c34:	eb 16                	jmp    80108c4c <copyuvm_cow+0xef>
      } else {
        pte_lookup_table.pte_array[pa/PGSIZE] += 1;
80108c36:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c39:	c1 e8 0c             	shr    $0xc,%eax
80108c3c:	0f b6 90 20 65 11 80 	movzbl -0x7fee9ae0(%eax),%edx
80108c43:	83 c2 01             	add    $0x1,%edx
80108c46:	88 90 20 65 11 80    	mov    %dl,-0x7fee9ae0(%eax)

      }
    release(&pte_lookup_table.lock);
80108c4c:	83 ec 0c             	sub    $0xc,%esp
80108c4f:	68 20 65 21 80       	push   $0x80216520
80108c54:	e8 e4 c6 ff ff       	call   8010533d <release>
80108c59:	83 c4 10             	add    $0x10,%esp

    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) //dont make new pages
80108c5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c62:	83 ec 0c             	sub    $0xc,%esp
80108c65:	52                   	push   %edx
80108c66:	ff 75 e8             	pushl  -0x18(%ebp)
80108c69:	68 00 10 00 00       	push   $0x1000
80108c6e:	50                   	push   %eax
80108c6f:	ff 75 f0             	pushl  -0x10(%ebp)
80108c72:	e8 55 f5 ff ff       	call   801081cc <mappages>
80108c77:	83 c4 20             	add    $0x20,%esp
80108c7a:	85 c0                	test   %eax,%eax
80108c7c:	78 44                	js     80108cc2 <copyuvm_cow+0x165>
      goto bad;
    //make it write only
    // cprintf("ABOUT TO MPROTECT\n");
    // mprotect(&pte,PGSIZE,PROT_READ);
    *pte &= ~PTE_W;
80108c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c81:	8b 00                	mov    (%eax),%eax
80108c83:	83 e0 fd             	and    $0xfffffffd,%eax
80108c86:	89 c2                	mov    %eax,%edx
80108c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c8b:	89 10                	mov    %edx,(%eax)
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108c8d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c97:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108c9a:	0f 82 e7 fe ff ff    	jb     80108b87 <copyuvm_cow+0x2a>
    // mprotect(&pte,PGSIZE,PROT_READ);
    *pte &= ~PTE_W;

  }
  //flush tlb?
  lcr3(v2p(pgdir));
80108ca0:	83 ec 0c             	sub    $0xc,%esp
80108ca3:	ff 75 08             	pushl  0x8(%ebp)
80108ca6:	e8 d4 ef ff ff       	call   80107c7f <v2p>
80108cab:	83 c4 10             	add    $0x10,%esp
80108cae:	83 ec 0c             	sub    $0xc,%esp
80108cb1:	50                   	push   %eax
80108cb2:	e8 bc ef ff ff       	call   80107c73 <lcr3>
80108cb7:	83 c4 10             	add    $0x10,%esp
  return d;
80108cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cbd:	eb 27                	jmp    80108ce6 <copyuvm_cow+0x189>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108cbf:	90                   	nop
80108cc0:	eb 01                	jmp    80108cc3 <copyuvm_cow+0x166>

      }
    release(&pte_lookup_table.lock);

    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) //dont make new pages
      goto bad;
80108cc2:	90                   	nop
  //flush tlb?
  lcr3(v2p(pgdir));
  return d;

bad:
  cprintf("BAD MEMORY!\n");
80108cc3:	83 ec 0c             	sub    $0xc,%esp
80108cc6:	68 0f 96 10 80       	push   $0x8010960f
80108ccb:	e8 f6 76 ff ff       	call   801003c6 <cprintf>
80108cd0:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108cd3:	83 ec 0c             	sub    $0xc,%esp
80108cd6:	ff 75 f0             	pushl  -0x10(%ebp)
80108cd9:	e8 82 fc ff ff       	call   80108960 <freevm>
80108cde:	83 c4 10             	add    $0x10,%esp
  return 0;
80108ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108ce6:	c9                   	leave  
80108ce7:	c3                   	ret    

80108ce8 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108ce8:	55                   	push   %ebp
80108ce9:	89 e5                	mov    %esp,%ebp
80108ceb:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108cee:	83 ec 04             	sub    $0x4,%esp
80108cf1:	6a 00                	push   $0x0
80108cf3:	ff 75 0c             	pushl  0xc(%ebp)
80108cf6:	ff 75 08             	pushl  0x8(%ebp)
80108cf9:	e8 2e f4 ff ff       	call   8010812c <walkpgdir>
80108cfe:	83 c4 10             	add    $0x10,%esp
80108d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d07:	8b 00                	mov    (%eax),%eax
80108d09:	83 e0 01             	and    $0x1,%eax
80108d0c:	85 c0                	test   %eax,%eax
80108d0e:	75 07                	jne    80108d17 <uva2ka+0x2f>
    return 0;
80108d10:	b8 00 00 00 00       	mov    $0x0,%eax
80108d15:	eb 29                	jmp    80108d40 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d1a:	8b 00                	mov    (%eax),%eax
80108d1c:	83 e0 04             	and    $0x4,%eax
80108d1f:	85 c0                	test   %eax,%eax
80108d21:	75 07                	jne    80108d2a <uva2ka+0x42>
    return 0;
80108d23:	b8 00 00 00 00       	mov    $0x0,%eax
80108d28:	eb 16                	jmp    80108d40 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d2d:	8b 00                	mov    (%eax),%eax
80108d2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d34:	83 ec 0c             	sub    $0xc,%esp
80108d37:	50                   	push   %eax
80108d38:	e8 4f ef ff ff       	call   80107c8c <p2v>
80108d3d:	83 c4 10             	add    $0x10,%esp
}
80108d40:	c9                   	leave  
80108d41:	c3                   	ret    

80108d42 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108d42:	55                   	push   %ebp
80108d43:	89 e5                	mov    %esp,%ebp
80108d45:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108d48:	8b 45 10             	mov    0x10(%ebp),%eax
80108d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108d4e:	eb 7f                	jmp    80108dcf <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108d50:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d58:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108d5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d5e:	83 ec 08             	sub    $0x8,%esp
80108d61:	50                   	push   %eax
80108d62:	ff 75 08             	pushl  0x8(%ebp)
80108d65:	e8 7e ff ff ff       	call   80108ce8 <uva2ka>
80108d6a:	83 c4 10             	add    $0x10,%esp
80108d6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108d70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108d74:	75 07                	jne    80108d7d <copyout+0x3b>
      return -1;
80108d76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d7b:	eb 61                	jmp    80108dde <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d80:	2b 45 0c             	sub    0xc(%ebp),%eax
80108d83:	05 00 10 00 00       	add    $0x1000,%eax
80108d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d8e:	3b 45 14             	cmp    0x14(%ebp),%eax
80108d91:	76 06                	jbe    80108d99 <copyout+0x57>
      n = len;
80108d93:	8b 45 14             	mov    0x14(%ebp),%eax
80108d96:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108d99:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d9c:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108d9f:	89 c2                	mov    %eax,%edx
80108da1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108da4:	01 d0                	add    %edx,%eax
80108da6:	83 ec 04             	sub    $0x4,%esp
80108da9:	ff 75 f0             	pushl  -0x10(%ebp)
80108dac:	ff 75 f4             	pushl  -0xc(%ebp)
80108daf:	50                   	push   %eax
80108db0:	e8 43 c8 ff ff       	call   801055f8 <memmove>
80108db5:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dbb:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dc1:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dc7:	05 00 10 00 00       	add    $0x1000,%eax
80108dcc:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108dcf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108dd3:	0f 85 77 ff ff ff    	jne    80108d50 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108dde:	c9                   	leave  
80108ddf:	c3                   	ret    
