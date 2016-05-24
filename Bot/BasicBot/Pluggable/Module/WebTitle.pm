use 5.020;

package Bot::BasicBot::Pluggable::Module::WebTitle {
    our $VERSION = '0.01';
    use parent 'Bot::BasicBot::Pluggable::Module';
    use Sys::SigAction 'timeout_call';
    use URI::Title qw(title);
    use URI::Find::Simple qw(list_uris);

    sub help {
        "Prints titles in webpages"
    }

    sub told {
        my ($self, $msg) = @_;
        my $nick = $msg->{who};
        my $channel = $msg->{channel};

        my $reply = '';
        for my $cand (list_uris($msg->{body})) {
            my $uri = URI->new($cand);
            next unless $uri;
            my $title;
            if (timeout_call(3, sub { $title = title("$cand") })) {
                next;
            } elsif ($title ne '') {
                $title =~ s/\n/ /g;
                $reply .= "[ $title ] ";
            }
        }

        return $reply;
    }
}

1;
