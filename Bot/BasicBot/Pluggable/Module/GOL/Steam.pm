use 5.020;

package Bot::BasicBot::Pluggable::Module::GOL::Steam {
    our $VERSION = '0.01';
    use parent 'Bot::BasicBot::Pluggable::Module';

    sub help {
        "Gives useful info on Steam URLs"
    }

    sub told {
        my ($self, $msg) = @_;

        my $reply;

        my @results = ::get_info($msg->{body});

        if (@results) {
            $reply = join "\n", @results;
        }
        
        return $reply;
    }
}

package main {

use Inline Python => <<'END_OF_PYTHON_CODE';
import steam
from steam import get_info
     
END_OF_PYTHON_CODE

}

1;
