package Games::Tetris::Shape;
use strict;

use Class::MethodMaker
  new_with_init => 'new',
  get_set => [ qw( shape width depth center ) ];

sub init {
    my $self = shift;
    my @rows = @_;
    $self->shape( [ map { [ map { / / ? undef : $_ } split // ] } @_ ] );
    $self->width( scalar @{ $self->shape->[0] } );
    $self->depth( scalar @{ $self->shape } );
    $self->center([ int($self->width / 2), int($self->depth / 2) ]);
}

sub print {
    my $self = shift;
    print join('', @$_), "\n"
      for @{ $self->shape };
}

sub covers {
    my $self = shift;
    my ($x, $y) = @_;
    my ($cx, $cy) = @{ $self->center };
    my @points;


    for (my $iy = 0; $iy < $self->depth; $iy++) {
        for (my $ix = 0; $ix < $self->width; $ix++) {
            my $point = $self->shape->[ $iy ][ $ix ];
            push @points, [ $x + ($ix - $cx), $y + ($iy - $cy), $point ]
              if $point;
        }
    }
    return @points;
}

1;
