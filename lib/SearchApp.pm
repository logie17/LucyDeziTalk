package SearchApp;

use Moo;
use Plack::Builder;
use Plack::Request;
use Schema;

has schema => (
    is => 'ro',
    builder => '_build_schema'
);

sub _build_schema {
    my $dsn    = "dbi:SQLite:dbname=db/data.db";
    Schema->connect($dsn);
}

sub app {
    my ( $self ) = @_;
    builder {
        mount '/find' => sub {
            my $req = Plack::Request->new(shift);

            if ( $req->method eq 'GET' ) {
                if ( my $q = $req->parameters->{q} ) {
                    my $content = $self->styles . $self->find_results($q);
                    return [ 200, [ 'Content-Type'   => 'text/html', ], [$content] ];
                }
            }

            return [
                404, [ 'Content-Type'   => 'text/html', ], [ 'Not found' ]
            ];
        };
        mount '/' => sub {
            my $req     = Plack::Request->new(shift);
            my $content = '';
            if ( $req->method eq 'POST' ) {
                $content = $self->save($req->parameters);
            }
            return [
                200, [ 'Content-Type'   => 'text/html', ], [ $self->default($content) ],
            ];
        };
    };
}

sub find_results {
    my ( $self, $q) = @_;
    my $resultset   = $self->schema->resultset('Data');
    my $results     = $resultset->search_dezi( { value => $q } );
    my $html;

    if ( $results->count > 0 ) {
        $html           = "<div class='count'>Total Found: " . $results->count .  "</div>";
        $html           .= '<div class="results">';
        while ( my $result = $results->next ) {
            my $value = $result->value =~ s/$q/<span class="hl">$q<\/span>/rg;
            $html .= "<div class='row'>" . $result->id . "</div>";
            $html .= "<div class='row'>" . $result->key . "</div>";
            $html .= "<div class='row'>" . $value . "</div>";
            $html .= "<div class='row'>" . $result->misc . "</div><br/>";
        }
        $html           .= '</div>';
    } else {
        $html =  '<div>No results found</div>';
    }

    return $html;
}

sub save {
    my ( $self, $params ) = @_;

    if ( $params->{key} && $params->{document} ) {
        my $resultset = $self->schema->resultset('Data');
        $resultset->new({
            key         => $params->{key},
            value       => $params->{document},
            misc        => $params->{misc}
        })->insert;
        return "Successfully indexed " . $params->{key};
    }
        
}

sub default {
    my ( $self, $message ) = @_;

    return<<EOF
    <body>
        $message <br/>
        <form method="post">
            <label>Document to Index:</label>
            <br/>
            <input type="text" name="key" value="Create a key" />
            <br/>
            <textarea name="document">Add something to index</textarea>
            <br/>
            <textarea name="misc">Misc non indexed stuff</textarea>
            <br/>
            <input type="submit" />
        </form>
        <br/>
        <form method="get" action="/find/">
            <label>Search:</label>
            <br/>
            <input type="text" name="q" />
            <input type="submit" />
        </form>

    </body>
EOF
}

sub styles {
    return<<EOF
    <style>
        .hl { background-color: red; }
        .row { padding: 2px 0 0 0; background-color: #f1f1f1; }
    </style>
EOF
}

1;
