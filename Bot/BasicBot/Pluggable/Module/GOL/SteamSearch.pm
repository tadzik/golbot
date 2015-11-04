use 5.020;

package Bot::BasicBot::Pluggable::Module::GOL::SteamSearch {
    our $VERSION = '0.01';
    use parent 'Bot::BasicBot::Pluggable::Module';

    sub help {
        "Search Steam and print info for closest match"
    }

    sub told {
        my ($self, $msg) = @_;

        my $reply;

        my @results = ::get_results($msg->{body});

        if (@results) {
            $reply = join "\n", @results;
        }
        
        return $reply;
    }
}

package main {

use Inline Python => <<'END_OF_PYTHON_CODE';
import steam_search
from steam_search import get_results
     
END_OF_PYTHON_CODE

}

1;
