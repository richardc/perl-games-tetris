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

my $square = $well->new_shape('**',
                              '**');
isa_ok( $square, 'Games::Tetris::Shape' );

ok( !$well->fits( $square, 0, 0 ), "square doesn't fit at 0, 0" );
ok( !$well->fits( $square, 0, 1 ), "square doesn't fit at 0, 1" );
ok( !$well->fits( $square, 1, 0 ), "square doesn't fit at 1, 0" );
ok(  $well->fits( $square, 1, 1 ), "square fits at 1, 1" );

ok( !$well->fits( $square, 10, 1 ), "square doesn't fit at 10, 1" );
ok(  $well->fits( $square, 9, 1 ), "square fits at 9, 1" );

ok( $well->drop( $square, 1, 1 ), "dropped a square at 1, 1" );
$well->print;
ok( $well->drop( $square, 1, 1 ), "dropped a square at 1, 1" );
$well->print;
ok( !$well->drop( $square, 1, 1 ), "couldn't drop a square at 1, 1" );

is_deeply( $well->drop( $square, 3, 1 ), [] );
$well->print;
is_deeply( $well->drop( $square, 5, 1 ), []);
$well->print;
is_deeply( $well->drop( $square, 7, 1 ), []);
$well->print;
is_deeply( $well->drop( $square, 9, 1 ), [ 2, 3 ], "deleted 2 rows");
$well->print;

my $oneblock = Games::Tetris->new( width => 10,
                                   depth => 4 );

is_deeply( $oneblock->drop($square, 1, 1), [], "create oneblock" );
is_deeply( $well->well, $oneblock->well, "right squares are left" );

my $ess = $well->new_shape(' +',
                           '++',
                           '+ ');

is_deeply( $well->drop( $ess, 0, 0 ), undef, "can't drop ess at 0, 0" );
is_deeply( $well->drop( $ess, 0, 1 ), undef, "can't drop ess at 0, 1" );
is_deeply( $well->drop( $ess, 1, 0 ), undef, "can't drop ess at 1, 0" );
is_deeply( $well->drop( $ess, 1, 1 ), [],    "dropped ess at 1, 1" );
$well->print;

#die Dumper $square, $square->covers(1,1);
