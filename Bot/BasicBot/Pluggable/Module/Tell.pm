use 5.020;

package Bot::BasicBot::Pluggable::Module::Tell {
    our $VERSION = '0.01';
    use parent 'Bot::BasicBot::Pluggable::Module';
    use POSIX 'strftime';

    sub help {
        "Handles «Golbot, tell <nick> to walk the dog» and shit"
    }

    sub archive {
        my ($self, $key, $val) = @_;
        my $stored = $self->get($key);
        if (ref($stored) eq 'ARRAY') {
            push @$stored, $val;
            $self->set($key, $stored);
        } else {
            $self->set($key, [$val]);
        }
    }

    sub told {
        my ($self, $msg) = @_;

        my $nick = $msg->{who};
        my $channel = $msg->{channel};
        my $addressed = $msg->{address};

        my $msgs = $self->get("tell_$nick$channel");
        if ($msgs) {
            #say "I have messages for $nick on $channel!";
            for (@$msgs) {
                $self->say({ channel => $channel, body => $_ });
            }
            $self->unset("tell_$nick$channel");
        }

        if ($msg->{body} =~ m{
            (\! | \.)?    # the way we may have been summoned, $1
            (tell|ask)\s+ # the verb, remembered, $2
            (\w+)\s+      # nickname of the target, $3
            (.+)          # the text to remember, $4
        }ix) {
            if ($addressed or $1) {
                $self->reply($msg, "Ok, I'll pass your message to $3");
                $self->archive("tell_$3$channel" =>
                    "$nick wanted to $2 you \"$4\" "
                    . strftime("(%F %R)", localtime));
                #say "Did shit";
            } else {
                #say "Seems like it was a tell, but not said to me";
            }
        } else {
            #say "This doesn't match my regex: $msg->{body}";
        }

        return;
    }
}

1;
