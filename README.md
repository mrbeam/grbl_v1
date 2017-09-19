# Grbl - Mr Beam Edition #

Mr Beam uses grbl for stepper motor and laser control for its portable and affordable laser cutter and engraver kits. It runs on an Arduino Uno and requires a Mr Beam Shield [Mr Beam Shield](http://shop.mr-beam.org/product/mr-beam-shield) for driving motors and the laser.

This is a modified version of the grbl v0.9. The original grbl description follows.



## How to flash Grbl on Mr Beam II ##

### READ hex file: ###
`avrdude -c avrispmkII -p atmega328p -U flash:r:filename.hex:i`

### WRITE hex file: ###
`avrdude -c avrispmkII -p atmega328p -D -U flash:w:filename.hex`

-D Disable auto erase for flash

More about flashing: https://docs.google.com/document/d/1KYD-67uyJthAYrTPURkSN8l7AVauc4Yw4M08CVyAFd0/edit#
