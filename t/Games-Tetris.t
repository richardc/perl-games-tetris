#!perl -w
use strict;
use Test::More tests => 20;
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

ok( $well->drop( $shape, 1, 1 ), "dropped a square at 1, 1" );
$well->print;
ok( $well->drop( $shape, 1, 1 ), "dropped a square at 1, 1" );
$well->print;
ok( !$well->drop( $shape, 1, 1 ), "couldn't drop a square at 1, 1" );

is_deeply( $well->drop( $shape, 3, 1 ), [] );
$well->print;
is_deeply( $well->drop( $shape, 5, 1 ), []);
$well->print;
is_deeply( $well->drop( $shape, 7, 1 ), []);
$well->print;
is_deeply( $well->drop( $shape, 9, 1 ), [ 2, 3 ], "deleted 2 rows");
$well->print;

my $oneblock = Games::Tetris->new( width => 10,
                                   depth => 4 );

is_deeply( $oneblock->drop($shape, 1, 1), [], "create oneblock" );
is_deeply( $well->well, $oneblock->well, "right squares are left" );


#die Dumper $shape, $shape->covers(1,1);
