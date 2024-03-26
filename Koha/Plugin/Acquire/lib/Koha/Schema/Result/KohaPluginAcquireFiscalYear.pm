use utf8;

package Koha::Schema::Result::KohaPluginAcquireFiscalYear;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::KohaPluginAcquireFiscalYear

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<koha_plugin_acquire_fiscal_year>

=cut

__PACKAGE__->table("koha_plugin_acquire_fiscal_year");

=head1 ACCESSORS

=head2 fiscal_yr_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 description

  data_type: 'longtext'
  default_value: ''''
  is_nullable: 1

description for the fiscal year

=head2 code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

code for the fiscal year

=head2 start_date

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

start date of the event

=head2 end_date

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

end date of the event

=head2 status

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 1

is the fiscal year currently active

=head2 last_updated

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 1

time of the last update to the fiscal year

=head2 owner

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

owner of the fiscal year

=head2 visible_to

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

library groups the fiscal year is visible to

=cut

__PACKAGE__->add_columns(
    "fiscal_yr_id",
    { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
    "description",
    { data_type => "longtext", default_value => "''", is_nullable => 1 },
    "code",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
    "start_date",
    { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
    "end_date",
    { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
    "status",
    { data_type => "tinyint", default_value => 1, is_nullable => 1 },
    "last_updated",
    {
        data_type                 => "timestamp",
        datetime_undef_if_invalid => 1,
        default_value             => \"current_timestamp",
        is_nullable               => 1,
    },
    "owner",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
    "visible_to",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</fiscal_yr_id>

=back

=cut

__PACKAGE__->set_primary_key("fiscal_yr_id");

=head1 RELATIONS

=head2 koha_plugin_acquire_fund_allocations

Type: has_many

Related object: L<Koha::Schema::Result::KohaPluginAcquireFundAllocation>

=cut

__PACKAGE__->has_many(
    "koha_plugin_acquire_fund_allocations",
    "Koha::Schema::Result::KohaPluginAcquireFundAllocation",
    { "foreign.fiscal_yr_id" => "self.fiscal_yr_id" },
    { cascade_copy           => 0, cascade_delete => 0 },
);

=head2 koha_plugin_acquire_funds

Type: has_many

Related object: L<Koha::Schema::Result::KohaPluginAcquireFund>

=cut

__PACKAGE__->has_many(
    "koha_plugin_acquire_funds",
    "Koha::Schema::Result::KohaPluginAcquireFund",
    { "foreign.fiscal_yr_id" => "self.fiscal_yr_id" },
    { cascade_copy           => 0, cascade_delete => 0 },
);

=head2 koha_plugin_acquire_ledgers

Type: has_many

Related object: L<Koha::Schema::Result::KohaPluginAcquireLedger>

=cut

__PACKAGE__->has_many(
    "koha_plugin_acquire_ledgers",
    "Koha::Schema::Result::KohaPluginAcquireLedger",
    { "foreign.fiscal_yr_id" => "self.fiscal_yr_id" },
    { cascade_copy           => 0, cascade_delete => 0 },
);

=head2 koha_plugin_acquire_sub_funds

Type: has_many

Related object: L<Koha::Schema::Result::KohaPluginAcquireSubFund>

=cut

__PACKAGE__->has_many(
    "koha_plugin_acquire_sub_funds",
    "Koha::Schema::Result::KohaPluginAcquireSubFund",
    { "foreign.fiscal_yr_id" => "self.fiscal_yr_id" },
    { cascade_copy           => 0, cascade_delete => 0 },
);

=head2 owner

Type: belongs_to

Related object: L<Koha::Schema::Result::Borrower>

=cut

__PACKAGE__->belongs_to(
    "owner",
    "Koha::Schema::Result::Borrower",
    { borrowernumber => "owner" },
    {
        is_deferrable => 1,
        join_type     => "LEFT",
        on_delete     => "RESTRICT",
        on_update     => "RESTRICT",
    },
);

# Created by DBIx::Class::Schema::Loader v0.07049 @ 2024-03-27 11:18:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DwwXDrs3okPHmPALZRxCng

sub koha_object_class {
    'Koha::Acquire::Fund::FiscalYear';
}

sub koha_objects_class {
    'Koha::Acquire::Fund::FiscalYears';
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
