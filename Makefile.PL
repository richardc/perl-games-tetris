use ExtUtils::MakeMaker;

my $module = 'lib/Games/Tetris.pm';
%depends = ('Test::More' => 0,
            'Class::MethodMaker' => 0);
WriteMakefile('NAME'         => 'Games::Tetris',
              'VERSION_FROM' => $module,
              'PREREQ_PM'    => \%depends)
  if $0 =~ m/makefile.pl/i;

sub MY::postamble {
    return <<EOF
README: $module Changes ../makereadme
\t../makereadme $module \$(NAME) \$(VERSION) > README
EOF
}


1;
