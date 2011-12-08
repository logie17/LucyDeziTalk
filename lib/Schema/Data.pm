package Schema::Data; {
use base 'DBIx::Class';

__PACKAGE__->load_components(qw[
    Indexed
    IndexSearch::Dezi
    PK::Auto
    Core
    TimeStamp
]);

__PACKAGE__->set_indexer('WebService::Dezi', { server => 'http://localhost:6000', content_type => 'application/json' });

__PACKAGE__->table('data');

__PACKAGE__->add_columns(
    id => {
        data_type       => 'id',
        is_nullable     => 0,
    },
    key => {
        data_type       => 'varchar',
        is_nullable     => 0,
        indexed         => 1 
    },
    value => {
        data_type       => 'varchar',
        is_nullable     => 0,
        indexed         => 1 
    },
    misc => {
        data_type       => 'varchar',
        is_nullable     => 1,
    },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->resultset_class('DBIx::Class::IndexSearch::ResultSet::Dezi');
__PACKAGE__->belongs_to_index('Dezi::Client', { server => 'http://localhost:6000', map_to => 'key' });
} 

1;
