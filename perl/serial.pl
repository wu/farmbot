#!/usr/local/bin/perl -w
use strict;
use warnings;

# Set up the serial port
use Device::SerialPort;
my $port = Device::SerialPort->new("/dev/tty.usbmodem411");

# 19200, 81N on the USB ftdi driver
$port->baudrate(9600);
$port->databits(8);
$port->parity("none");
$port->stopbits(1);

#$port->write("Whatever you feel like sending");

my $path = "/Users/wu/logs/temp.log";
open(my $fh, ">>", $path)
    or die "Couldn't open $path for writing: $!\n";

# disable buffering
{ my $ofh = select $fh;
  $| = 1;
  select $ofh;
}

# clear contents of port on startup
$port->lookclear;

while (1) {
    # Poll to see if any data is coming in
    my $char = $port->lookfor();

    # If we get data, then print it Send a number to the arduino
    if ($char) {
        my $time = time;
        print $fh scalar localtime( $time );
        print $fh ", $time, $char\n";

        print scalar localtime( $time );
        print ", $time, $char\n";
    }

    # Uncomment the following lines, for slower reading, but lower CPU
    # usage, and to avoid buffer overflow due to sleep function.
    sleep (1);
}

close $fh or die "Error closing file: $!\n";
