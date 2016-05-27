use v5.10;
use strict;
use warnings FATAL => 'all';

use Test::More;
use Test::Moose;
use Test::Exception;

my $cn = "Netflow::Collector";

use_ok($cn);

has_attribute_ok($cn, $_) for qw/
    _socket
    _dispatch
    max_pkt_size
    max_rcv_buf
    port
    timeout
    /;

can_ok($cn, "run");

throws_ok {
    $cn->new(port => 2**16, dispatch => sub { });
}
qr/\d++ invalid port number/, "caught invalid port exception";

foreach my $v (qw/max_rcv_buf max_pkt_size/) {
    throws_ok {
        $cn->new(port => 123, dispatch => sub { }, $v => 0);
    }
    qr/\d++ is not a positive integer/, "caught invalid $v exception";
} ## end foreach my $v (qw/max_rcv_buf max_pkt_size/)

done_testing();
