use v5.10;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Exception;

use_ok('Netflow::Collector');

subtest "run autor subtest", sub {
    $ENV{AUTHOR_TESTING} || plan skip_all => "without \$ENV{AUTHOR_TESTING}";
    $ENV{NFC_PORT} || plan skip_all => "\$ENV{NFC_PORT} required for the test";

    my $i = 0;
    my $c = new_ok(
        'Netflow::Collector',
        [
            # default
            max_pkt_size => 1548,
            # just for coverage
            max_rcv_buf  => 1024**2,
            port         => $ENV{NFC_PORT},
            dispatch     => sub {
                my ($p) = @_;
                ok(my $v = unpack('n', $p), "unpack header version");
                ++$i == 5 && die sprintf "got %d netflow packets v%d", $i, $v;
                }
        ]
    );

    throws_ok { $c->run() } qr/got 5 netflow packets v\d/, "run";

};

subtest "run release subtest", sub {
    ($ENV{AUTHOR_TESTING} || $ENV{RELEASE_TESTING})
        || plan skip_all => "without \$ENV{RELEASE_TESTING}";

    my $p = $ENV{NFC_TO_PORT};
    unless ($p) {
        $p = 12345;
        diag "no env NFC_TO_PORT. $p will be used for the subtest";
    }
    my $c = new_ok(
        'Netflow::Collector',
        [
            port     => $p,
            dispatch => sub {
                my ($p) = @_;
                ok(my $v = unpack('n', $p), "unpack header version");
                }
        ]
    );

    throws_ok { $c->run() } qr/socket connection timed out/, "timed out";
};

done_testing();
