package Schema;
use base 'DBIx::Class::Schema';

__PACKAGE__->load_classes(qw[
    Data
]);

1;
