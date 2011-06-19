#!/usr/local/bin/perl -w
use strict;
use warnings;

# Set up the serial port
use Capture::Tiny;
use Device::SerialPort qw( :PARAM :STAT :ALL );

my @devices = ( "/dev/tty.usbmodem411", "/dev/tty.usbmodem3b11" );

my $device;
for ( @devices ) {
    $device = $_ if -r;
}


while ( 1 ) {

    eval {

        my $port = Device::SerialPort->new( $device );

        # 19200, 81N on the USB ftdi driver
        $port->baudrate(9600);
        $port->databits(8);
        $port->parity("none");
        $port->stopbits(1);

        #$port->write("Whatever you feel like sending");

        # clear contents of port on startup
        #$port->lookclear;

        while (1) {

            my $char;

            my ( $stdout, $stderr ) = Capture::Tiny::capture {
                # Poll to see if any data is coming in
                $char = $port->lookfor();
            };

            if ( $stderr =~ m|^Error| ) {
                die "STDERR: $stderr\n";
            }

            # if ( OS_Error ) {
            #     die OS_Error;
            # }

            if ( $char ) {

                my ( $source, $type, $value, $units ) = split/\s*,\s*/, $char;
                my $time = time;

                if ( $source && $type && $value ) {

                    my $path = "/Users/wu/logs/$source-$type.log";

                    print scalar localtime( $time );
                    print ", $path, $time, $source, $type, $value\n";

                    open(my $fh, ">>", $path)
                        or die "Couldn't open $path for writing: $!\n";

                    # If we get data, then print it Send a number to the arduino
                    print $fh scalar localtime( $time );
                    print $fh ", $time, $source, $type, $value\n";

                    close $fh;

                } else {
                    warn "Error parsing input: $char\n";

                }

            }

            # Uncomment the following lines, for slower reading, but lower CPU
            # usage, and to avoid buffer overflow due to sleep function.
            sleep (1);
        }

        1;
    } or do {

        print "FATAL: $@";

    };

    sleep 5;
}
