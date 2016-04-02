use 5.020;

package Bot::BasicBot::Pluggable::Module::GOL::RSS {
    our $VERSION = '0.01';
    use parent 'Bot::BasicBot::Pluggable::Module';
    use XML::RSS::LibXML;
    use LWP::Simple qw();

    sub init {
        my ($self) = @_;
        $self->{lastcheck} = 0;
        $self->{lastpubdate} = $self->get("GOL_RSS_lastpubdate");
    }

    sub help {
        "Reports GOL articles"
    }

    sub tick {
        my ($self) = @_;
        if (time - $self->{lastcheck} > 5 * 60) {
            $self->check_feed();
        }
    }

    sub check_feed {
        my ($self) = @_;
        say "Checking RSS";
        my $rss = LWP::Simple::get(
            'https://www.gamingonlinux.com/article_rss.php');
        my $parsed = XML::RSS::LibXML->new->parse($rss);
        my @news;
        my $newest;
        for my $post (@{$parsed->items}) {
            my $datetime = $post->{pubDate};
            $datetime =~ s/ \+\d+$//;
            $newest //= $datetime;
            last if $datetime eq $self->{lastpubdate};
            my $line = sprintf "[NEWS] %s %s - %s",
                               $post->{title}, $post->{link}, $datetime;
            push @news, $line;
        }
        if (@news) {
            my $line = join "\n", @news;
            say "Reporting $line";
            $self->say({ channel => "#gamingonlinux", body => $line });
            $self->set("GOL_RSS_lastpubdate" =>
                $self->{lastpubdate} = $newest);
        } else {
            say "Nothing new";
        }
        $self->{lastcheck} = time;
    }
}

1;
