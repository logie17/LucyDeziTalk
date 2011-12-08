package DB;

use MyApp::Schema;

our $dsn    = "dbi:SQLite:dbname=db/data.db";
our $schema = MyApp::Schema->connect($dsn);

sub initialize
{
    return $schema;
}

1;

