use ExtUtils::MakeMaker;

my $module = 'lib/Games/Tetris.pm';
WriteMakefile('NAME'      => 'Games::Tetris',
              'VERSION_FROM' => $module,
              'PREREQ_PM' => { 'Test::More' => 0 });

sub MY::postamble {
    return <<EOF
README: $module
\tpod2text $module > README
EOF
}
