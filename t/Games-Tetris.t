#!perl -w
use strict;
use Test::More tests => 11;
use Data::Dumper;

use_ok( 'Games::Tetris' );

my $well = Games::Tetris->new( width => 10,
                               depth => 4 );
$well->print;
isa_ok( $well, 'Games::Tetris' );
is( $well->width, 10 );
is( $well->depth, 4 );

my $shape = $well->new_shape('**',
                             '**');

isa_ok( $shape, 'Games::Tetris::Shape' );

ok( !$well->fits( $shape, 0, 0 ), "square doesn't fit at 0, 0" );
ok( !$well->fits( $shape, 0, 1 ), "square doesn't fit at 0, 1" );
ok( !$well->fits( $shape, 1, 0 ), "square doesn't fit at 1, 0" );
ok(  $well->fits( $shape, 1, 1 ), "square fits at 1, 1" );

ok( !$well->fits( $shape, 10, 1 ), "square doesn't fit at 10, 1" );
ok(  $well->fits( $shape, 9, 1 ), "square fits at 9, 1" );

ok( $well->drop( $shape, 1, 1 ), "dropped a shape at 1, 1" );
$well->print;
ok( $well->drop( $shape, 1, 1 ), "dropped a shape at 1, 1" );
$well->print;
ok( !$well->drop( $shape, 1, 1 ), "couldn't drop a shape at 1, 1" );

#die Dumper $shape, $shape->covers(1,1);
