#! perl

use strict;
use warnings;
use SearchApp;
use Plack::Runner;

my $app = SearchApp->new->app;

my $runner = Plack::Runner->new;
$runner->run($app);

