use strict;
use warnings;
use Benchmark qw(:all) ;


sub lwp{
    require LWP::UserAgent;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    my $response = $ua->get('http://www.cpan.org/');
    return 0;
}

sub lwp_curl {
    use LWP::Curl;
    my $lwpcurl = LWP::Curl->new();
    my $content = $lwpcurl->get('http://www.cpan.org');
    return 0;
}

sub mechanize {
    use WWW::Mechanize;
    my $mech = WWW::Mechanize->new();
    $mech->get( "http://www.cpan.org" );
    return 0;
}

cmpthese(100, {
        'LWP' => &lwp(),
        'WWW::Mechanize' => &mechanize,
        'LWP::Curl' => &lwp_curl
    });
