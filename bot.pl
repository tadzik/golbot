use 5.018;
use lib 'local/lib/perl5';
use warnings;

use FindBin qw($Bin);
$ENV{PYTHONPATH} = "$Bin/python";
say $ENV{PYTHONPATH};

use Bot::BasicBot::Pluggable;

my $bot = Bot::BasicBot::Pluggable->new(
    server => "irc.freenode.net",
    channels => ["#gamingonlinux"],
    nick => 'GolBot',
);

$bot->load('Seen');
$bot->load('Tell');
$bot->load('GOL::Steam');
$bot->load('GOL::SteamSearch');
$bot->load('WebTitle');
$bot->load('Log');
$bot->load('Substitution');
$bot->load('GOL::RSS');

$bot->run;
