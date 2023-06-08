package Koha::Plugin::YourPlugin;

use Modern::Perl;

use base qw(Koha::Plugins::Base);

our $VERSION = "0.0";

our $metadata = {
    name            => 'Your Plugin',
    author          => 'Author',
    date_authored   => 'YYYY-MM-DD',
    date_updated    => 'YYYY-MM-DD',
    minimum_version => '19.05.00.000',
    maximum_version => undef,
    version         => $VERSION,
    description     => 'Description',
};

sub new {
    my ( $class, $args ) = @_;

    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    my $self = $class->SUPER::new($args);
    $self->{cgi} = CGI->new();

    return $self;
}

# Your plugin code here

1;