package Netflow::Collector;
$Netflow::Collector::VERSION = '0.01';
{

    package Netflow::Collector::Exception;
    use Moose;
    extends 'Throwable::Error';
    use namespace::autoclean;
    no Moose;
    1;
}

use v5.10;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

use IO::Socket::INET;
use IO::Select;
use Socket qw/
    SOL_SOCKET
    SO_RCVBUF
    /;

=head1 NAME

Netflow::Collector

=head1 VERSION

Version 0.01

=cut

=head1 SYNOPSIS

    use Netflow::Collector;

    my $foo = Netflow::Collector->new(port => 9999, dispatch => sub {..});
    $foo->run();

=head1 PROPERTIES

=cut

subtype "PositiveInt", as "Int",
    where { $_ > 0 },
    message {"$_ is not a positive integer!"};

subtype "PortNum", as "PositiveInt",
    where { $_ <= 65535 },
    message {"$_ invalid port number"};

=head2 dispatch

for a received packets responsible code reference

=cut

has "dispatch",
    is       => "ro",
    isa      => "CodeRef",
    required => 1;

=head2 port

1-65535

=cut

has "port",
    isa      => "PortNum",
    is       => "ro",
    required => 1;

=head2 max_rcv_buf

if defined will be provided to

C<IO::Socket::INET->setsockopt(SOL_SOCKET, SO_RCVBUF, $self->max_rcv_buf)>

=cut

has "max_rcv_buf",
    isa => "PositiveInt",
    is  => "ro";

=head2 max_pkt_size

default 1548

=cut

has "max_pkt_size",
    isa     => "PositiveInt",
    is      => "ro",
    default => sub {1548};

=head2 _socket

IO::Socket::INET object

=cut

has "_socket",
    isa        => "IO::Socket::INET",
    is         => "ro",
    init_arg   => undef,
    lazy_build => 1;

sub _build__socket {
    my ($self) = @_;
    my $sock = IO::Socket::INET->new(
        LocalPort => $self->port,
        Proto     => "udp",
    );

    unless ($sock) {
        M43::Netflow::Dispatcher::Exception->throw(
            sprintf "couldn't open UDP socket at port '%s': $!",
            $self->port);
    }

    # # increase socket buffer
    $self->max_rcv_buf
        && $sock->setsockopt(SOL_SOCKET, SO_RCVBUF, $self->max_rcv_buf);

    my $sel = IO::Select->new($sock);
    unless ($sel->can_read(5)) {
        $sock->close();
        M43::Netflow::Dispatcher::Exception->throw("can't read from socket $!");
    }

    return $sock;
} ## end sub _build__socket

=head1 SUBROUTINES/METHODS

=head2 run()

=cut

sub run {
    my ($self) = shift;
    my $sock = $self->_socket();
    while ($sock->recv(my $packet, $self->max_pkt_size)) {
        $self->dispatch->($packet);
    }
} ## end sub run

no Moose;
__PACKAGE__->meta->make_immutable;
1;    # End of Netflow::Collector

__END__
=head1 AUTHOR

Alexei Pastuchov, C<< <palik at cpan.org> >>

=head1 REPOSITORY

L<https://github.com/p-alik/Netflow-Collector.git>

=head1 BUGS

Please report any bugs or feature requests to C<bug-netflow-collector at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Netflow-Collector>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Netflow::Collector

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Netflow-Collector>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Netflow-Collector>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Netflow-Collector>

=item * Search CPAN

L<http://search.cpan.org/dist/Netflow-Collector/>

=back

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2016 Alexei Pastuchov.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

