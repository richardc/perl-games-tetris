package Games::Tetris;
use strict;
use warnings;

use Games::Tetris::Shape;

use Class::MethodMaker
  new_with_init => 'new',
  new_hash_init => 'hash_init',
  get_set => [ qw( well width depth ) ];

our $VERSION = '0.01';

=head2 new

Creates a new gamestate

well # initial well, array of arrays

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

sub new_shape {
    my $self = shift;
    new Games::Tetris::Shape @_;
}

sub print {
    my $self = shift;
    print "# /", ('-') x $self->width, "\\\n";
    print "# |", join( '', map { $_ ? $_ : ' ' } @$_ ), "|\n"
      for @{ $self->well };
    print "# \\", ('-') x $self->width, "/\n";
}

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
        my ($x, $y) = @$_;
        $self->well->[ $y ][ $x ] = '*';
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
