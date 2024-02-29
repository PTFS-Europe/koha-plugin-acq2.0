package Koha::Plugin::Acquire;

use Modern::Perl;

use base qw(Koha::Plugins::Base);

use Mojo::JSON qw(decode_json);
use JSON       qw ( encode_json );

use Template;

use Koha::Database;
use Koha::Schema;

use Koha::Plugin::Acquire::installer::AcquisitionsInstaller;

BEGIN {
    my $path = Module::Metadata->find_module_by_name(__PACKAGE__);
    $path =~ s{[.]pm$}{/lib}xms;
    unshift @INC, $path;

    require Koha::Acquire::Settings::Settings;
    require Koha::Schema::Result::KohaPluginAcquireSetting;
    Koha::Schema->register_class( KohaPluginAcquireSetting => 'Koha::Schema::Result::KohaPluginAcquireSetting' );

    require Koha::Acquire::TaskManagement::Tasks;
    require Koha::Schema::Result::KohaPluginAcquireWorkflowTask;
    Koha::Schema->register_class( KohaPluginAcquireWorkflowTask => 'Koha::Schema::Result::KohaPluginAcquireWorkflowTask' );

    require Koha::Acquire::Funds::FiscalYears;
    require Koha::Schema::Result::KohaPluginAcquireFiscalYear;
    Koha::Schema->register_class( KohaPluginAcquireFiscalYear => 'Koha::Schema::Result::KohaPluginAcquireFiscalYear' );

    require Koha::Acquire::Funds::Ledgers;
    require Koha::Schema::Result::KohaPluginAcquireLedger;
    Koha::Schema->register_class( KohaPluginAcquireLedger => 'Koha::Schema::Result::KohaPluginAcquireLedger' );

    require Koha::Acquire::Funds::Funds;
    require Koha::Schema::Result::KohaPluginAcquireFund;
    Koha::Schema->register_class( KohaPluginAcquireFund => 'Koha::Schema::Result::KohaPluginAcquireFund' );

    require Koha::Acquire::Funds::FundAllocations;
    require Koha::Schema::Result::KohaPluginAcquireFundAllocation;
    Koha::Schema->register_class( KohaPluginAcquireFundAllocation => 'Koha::Schema::Result::KohaPluginAcquireFundAllocation' );

    Koha::Database->schema( { new => 1 } );
}
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
                    settings        => $self->get_qualified_table_name('settings'),
                    workflow_tasks  => $self->get_qualified_table_name('workflow_tasks'),
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

=head3 api_routes

=cut

sub api_routes {
    my ( $self, $args ) = @_;

    my $spec_str = $self->mbf_read('api/openapi.json');
    my $spec     = decode_json($spec_str);

    return $spec;
}

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