package Games::Tetris;
use strict;
use Games::Tetris::Shape;
use Class::MethodMaker
  new_with_init => 'new',
  new_hash_init => 'hash_init',
  get_set => [ qw( well width depth ) ];

use vars qw($VERSION);
$VERSION = '0.01';

=head1 NAME

Games::Tetris - representation of a tetris game state

=head1 SYNOPSIS

=head1 METHODS

=head2 new

Creates a new gamestate

well # initial well, array of arrays
width # dimensions of new well (if C<well> parameter skipped)
depth # as depth

=cut

sub init {
    my $self = shift;
    $self->hash_init( @_ );

    $self->width or $self->width(15);
    $self->depth or $self->depth(20);
    $self->well  or $self->well( [ map {
        [ (undef) x $self->width ]
    } 1 .. $self->depth ] )
}

=head2 new_shape

delegates to Games::Tetris::Shape->new

=cut

sub new_shape {
    my $self = shift;
    new Games::Tetris::Shape @_;
}

=head2 print

used by the testsuite

=cut

sub print {
    my $self = shift;
    print "# /", ('-') x $self->width, "\\\n";
    print "# |", join( '', map { $_ ? $_ : ' ' } @$_ ), "|\n"
      for @{ $self->well };
    print "# \\", ('-') x $self->width, "/\n";
}

=head2 ->fits( $shape, $x, $y )

returns a true value if the given shape would fit in the well at the
location C<$x, $y>

=cut

sub fits {
    my $self = shift;
    my ($shape, $at_x, $at_y) = @_;

    for ($shape->covers($at_x, $at_y)) {
        my ($x, $y) = @$_;
        return if ($x < 0 ||
                   $y < 0 ||
                   $x >= $self->width ||
                   $y >= $self->depth ||
                   $self->well->[ $y ][ $x ]);
    }
    return 1;
}

=head2 ->drop( $shape, $x, $y )

returns false if the shape will not fit at the location indicated by
C<$x, $y>

if the shape can be dropped it will be advanced to the bottom of the
well and the return value will be the rows removed by the dropping
operation, if any, as an array reference

=cut

sub drop {
    my $self = shift;
    my ($shape, $at_x, $at_y) = @_;

    return unless $self->fits(@_);
    my $max_y = $at_y;
    for (my $y = $at_y; $y <= $self->depth; $y++) {
        last if !$self->fits( $shape, $at_x, $y );
        $max_y = $y;
    }
    for ($shape->covers($at_x, $max_y)) {
        my ($x, $y, $val) = @$_;
        $self->well->[ $y ][ $x ] = $val;
    }

    my @removed;
    for (my $y = 0; $y < $self->depth; $y++) {
        my $inrow = grep { $_ } @{ $self->well->[$y] };
        next if $inrow != $self->width;
        push @removed, $y;
    }

    splice @{ $self->well }, $_, 1
      for reverse @removed;
    unshift @{ $self->well }, [(undef) x $self->width]
      for @removed;
    return \@removed;
}

1;

__END__

=head1 TODO

=over

=item $piece->rotate

=item Tk/Wx interface

=item Network Code

=item Watch all tuits go bye bye

=back

=head1 AUTHOR

Richard Clamp <richardc@unixbeard.net>

=head1 COPYRIGHT

Copyright (C) 2003 Richard Clamp.  All Rights Reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

Games::Tetris::Shape

=cut
