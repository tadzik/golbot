use 5.020;

package Bot::BasicBot::Pluggable::Module::Substitution {
    our $VERSION = '0.01';
    use parent 'Bot::BasicBot::Pluggable::Module';

    sub help {
        "Handles s///"
    }

    sub told {
        my ($self, $msg) = @_;
        my $nick = $msg->{who};
        my $channel = $msg->{channel};
        if ($msg->{body} =~ m{\bs/([^/]+)/([^/]+)/?}) {
            my ($pattern, $replacement) = ($1, $2);
            my $orig = $self->get("sub_$nick$channel");
            if ($orig) {
                if ($msg->{body} =~ \bs/[^/]+/[^/]+/g) { 
                    my $new = $orig =~ s/$pattern/$replacement/gr;
                } else {
                    my $new = $orig =~ s/$pattern/$replacement/r;
                }
                if ($new ne $orig) {
                    $self->set("sub_$nick$channel" => $new);
                    return "$nick meant to say: $new";
                }
            }
        } else {
            $self->set("sub_$nick$channel" => $msg->{body});
        }
        return;
    }
}

1;
