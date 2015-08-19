use 5.020;
use lib 'local/lib/perl5';
use warnings;

use Bot::BasicBot::Pluggable;

my $bot = Bot::BasicBot::Pluggable->new(
    server => "irc.freenode.net",
    channels => ["#golbottest"],
    nick => 'GolBot',
);

$bot->load('Seen');
$bot->load('Title');
$bot->load('Log');
$bot->load('Substitution');
$bot->load('GOL::RSS');

$bot->run;
