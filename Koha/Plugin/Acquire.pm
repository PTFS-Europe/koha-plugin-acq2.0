package Koha::Plugin::Acquire;

use Modern::Perl;

use base qw(Koha::Plugins::Base);

use Mojo::JSON qw(decode_json);
use JSON       qw ( encode_json );

use Template;

use Koha::Plugin::Acquire::installer::AcquisitionsInstaller;


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

    return try {
        my $file       = __FILE__;
        my $bundle_dir = $file;
        $bundle_dir =~ s/[.]pm$//smx;

        my $bundle_path = $bundle_dir;

        my $installer = Koha::Plugin::Acquire::installer::AcquisitionsInstaller->new(
            {
                table_name_mappings => {
                    fiscal_year     => $self->get_qualified_table_name('fiscal_year'),
                    ledgers         => $self->get_qualified_table_name('ledgers'),
                    funds           => $self->get_qualified_table_name('funds'),
                    fund_allocation => $self->get_qualified_table_name('fund_allocation'),
                },
                bundle_path => $bundle_path,
            }
        );

        my $is_success = $installer->install();
        if ( !$is_success ) {
            warn 'Migration failed';
        }

        return 1;
    }
    catch {
        my $error = $_;
        warn "INSTALL ERROR: $error";

        return 0;
    }

}

# =head3 api_routes

# =cut

# sub api_routes {
#     my ( $self, $args ) = @_;

#     my $spec_str = $self->mbf_read('api/openapi.json');
#     my $spec     = decode_json($spec_str);

#     return $spec;
# }

=head3 api_namespace

=cut

sub api_namespace {
    my ($self) = @_;

    return 'acquire';
}

=head3 static_routes

=cut

sub static_routes {
    my ( $self, $args ) = @_;

    my $spec_str = $self->mbf_read('api/staticapi.json');
    my $spec     = decode_json($spec_str);

    return $spec;
}

1;