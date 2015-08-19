use 5.020;

package Bot::BasicBot::Pluggable::Module::GOL::RSS {
    our $VERSION = '0.01';
    use parent 'Bot::BasicBot::Pluggable::Module';
    use XML::RSS::LibXML;
    use LWP::Simple qw();

    sub init {
        my ($self) = @_;
        $self->{lastcheck} = 0;
        $self->{lastlink} = $self->get("GOL_RSS_lastlink");
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
        my $post = $parsed->items->[0];
        my $datetime = $post->{pubDate};
        $datetime =~ s/ \+\d+$//;
        my $line = sprintf "[NEWS] %s %s - %s",
                           $post->{title}, $post->{link}, $datetime;
        if ($line ne $self->{lastlink}) {
            $self->say({ channel => "#golbottest", body => $line });
            $self->{lastlink} = $line;
            say "Reporting $line";
            $self->set("GOL_RSS_lastlink" => $line);
        } else {
            say "Nothing new";
        }
        $self->{lastcheck} = time;
    }
}

1;
