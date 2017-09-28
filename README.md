# Grbl - Mr Beam Edition #

Mr Beam uses grbl for stepper motor and laser control for its portable and affordable laser cutter and engraver kits. It runs on an Arduino Uno and requires a Mr Beam Shield [Mr Beam Shield](http://shop.mr-beam.org/product/mr-beam-shield) for driving motors and the laser.

This is a modified version of the grbl v0.9. The original grbl description follows.



## How to flash Grbl on Mr Beam II ##

### READ hex file: ###
`avrdude -c avrispmkII -p atmega328p -U flash:r:<filename.hex>:i`

### WRITE hex file: ###
`avrdude -c avrispmkII -p atmega328p -U flash:w:grbl_optiboot_22270fa.hex -U efuse:w:0xff:m -U hfuse:w:0xde:m -U lfuse:w:0xff:m -U lock:w:0xff:m`

-D Disable auto erase for flash (not recommended)

#### Write from Raspberry Pi: #### 
`avrdude -c arduino -p atmega328p -U flash:w:grbl_with_optiboot.hex`

Existing Grbl must include bootloaded for this to work.

Flo says: this works only with his patched version of `avrdude`. And it’s also a bit flaky.

More about flashing: https://docs.google.com/document/d/1KYD-67uyJthAYrTPURkSN8l7AVauc4Yw4M08CVyAFd0/edit#
