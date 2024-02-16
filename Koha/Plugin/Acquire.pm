package Koha::Plugin::Acquire;

use Modern::Perl;

use base qw(Koha::Plugins::Base);

use Mojo::JSON qw(decode_json);
use JSON       qw ( encode_json );

use Template;

our $VERSION = "0.0";

our $metadata = {
    name            => 'Acquisitions 2.0',
    author          => 'PTFS Europe Ltd',
    date_authored   => '2023-12-08',
    date_updated    => '2023-12-08',
    minimum_version => '22.11.00.000',
    maximum_version => undef,
    version         => $VERSION,
    description     => 'A re-imagined acquisitions module for Koha',
};

sub new {
    my ( $class, $args ) = @_;

    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    my $self = $class->SUPER::new($args);
    $self->{cgi} = CGI->new();

    return $self;
}

=head3 install

Do all is required to properly install the plugin

=cut

sub install {
    my ( $self, $args ) = @_;

    return 1;
}

1;