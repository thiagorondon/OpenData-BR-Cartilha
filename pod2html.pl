#!/usr/bin/perl
use strict;
use utf8;
use warnings 'all';

use Data::Dumper;
use File::Find;
use FindBin qw($Bin);
use Pod::Simple::HTML;
use Regexp::Common qw(comment);

my $path = "$Bin/pod";
chdir $path;

my @files;
find(sub { push @files, $File::Find::name if /\.pod$/ && -f $_ } => '.');

my $css = 'http://st.pimg.net/tucs/style.css';

my @docs = qw(.. html);

foreach my $pod (@files) {
    my @path = split m{/}, $pod;
    shift @path;
    my $html_file = pop @path;
    $html_file =~ s/\.pod$//;

    $html_file .= '.html';

    my $link = join('/', @path, $html_file);

    unshift @path, @docs;
    mkdir join('/', @path[0 .. $_]) for 1 .. $#path;

    printf STDERR "%s/%s -> %s\n", $path, $pod, $html_file;

    my $p = new Pod::Simple::HTML;
    my $html = '';
    $p->accept_targets('*');
    $p->html_css($css);
    $p->index(1);
    $p->output_string(\$html);
    $p->parse_file("$path/$pod");

    $html =~ s/$RE{comment}{HTML}\s*//gos;

    open(my $fh, '>:encoding(latin1)', join('/', @path, $html_file));
    print $fh $html;
    close $fh;
}
