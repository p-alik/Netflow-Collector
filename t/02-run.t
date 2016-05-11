use v5.10;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Exception;

use_ok('Netflow::Collector');

subtest "run", sub {
    $ENV{AUTHOR_TESTING} || plan skip_all => "without \$ENV{AUTHOR_TESTING}";
    $ENV{NFC_PORT} || plan skip_all => "\$ENV{NFC_PORT} required for the test";

    my $i = 0;
    my $c = new_ok(
        'Netflow::Collector',
        [
            port     => $ENV{NFC_PORT},
            dispatch => sub {
                my ($p) = @_;
                ok(my $v = unpack('n', $p), "unpack header version");
                ++$i == 5 && die sprintf "got %d netflow packets v%d", $i, $v;
                }
        ]
    );

    throws_ok { $c->run() } qr/got 5 netflow packets v\d/, "run";
};

done_testing();
