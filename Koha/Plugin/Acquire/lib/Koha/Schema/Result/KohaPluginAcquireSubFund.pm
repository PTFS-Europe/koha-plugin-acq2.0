use utf8;

package Koha::Schema::Result::KohaPluginAcquireSubFund;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::KohaPluginAcquireSubFund

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<koha_plugin_acquire_sub_funds>

=cut

__PACKAGE__->table("koha_plugin_acquire_sub_funds");

=head1 ACCESSORS

=head2 sub_fund_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 fund_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

parent fund for the sub fund

=head2 ledger_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

ledger the sub_fund applies to

=head2 fiscal_yr_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

fiscal year the sub_fund applies to

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

name for the sub_fund

=head2 description

  data_type: 'longtext'
  default_value: ''''
  is_nullable: 1

description for the sub_fund

=head2 sub_fund_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

type for the sub_fund

=head2 code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

code for the sub_fund

=head2 external_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

external id for the sub_fund for use with external accounting systems

=head2 currency

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 10

currency of the sub_fund

=head2 status

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 1

is the sub_fund currently active

=head2 owner

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

owner of the sub_fund

=head2 sub_fund_value

  data_type: 'decimal'
  default_value: 0.000000
  is_nullable: 1
  size: [28,6]

value of the sub_fund

=head2 last_updated

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 1

time of the last update to the sub_fund

=head2 visible_to

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

library groups the sub_fund is visible to

=cut

__PACKAGE__->add_columns(
    "sub_fund_id",
    { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
    "fund_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
    "ledger_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
    "fiscal_yr_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
    "name",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
    "description",
    { data_type => "longtext", default_value => "''", is_nullable => 1 },
    "sub_fund_type",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
    "code",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
    "external_id",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
    "currency",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 10 },
    "status",
    { data_type => "tinyint", default_value => 1, is_nullable => 1 },
    "owner",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
    "sub_fund_value",
    {
        data_type     => "decimal",
        default_value => "0.000000",
        is_nullable   => 1,
        size          => [ 28, 6 ],
    },
    "last_updated",
    {
        data_type                 => "timestamp",
        datetime_undef_if_invalid => 1,
        default_value             => \"current_timestamp",
        is_nullable               => 1,
    },
    "visible_to",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sub_fund_id>

=back

=cut

__PACKAGE__->set_primary_key("sub_fund_id");

=head1 RELATIONS

=head2 fiscal_yr

Type: belongs_to

Related object: L<Koha::Schema::Result::KohaPluginAcquireFiscalYear>

=cut

__PACKAGE__->belongs_to(
    "fiscal_yr",
    "Koha::Schema::Result::KohaPluginAcquireFiscalYear",
    { fiscal_yr_id => "fiscal_yr_id" },
    {
        is_deferrable => 1,
        join_type     => "LEFT",
        on_delete     => "CASCADE",
        on_update     => "CASCADE",
    },
);

=head2 fund

Type: belongs_to

Related object: L<Koha::Schema::Result::KohaPluginAcquireFund>

=cut

__PACKAGE__->belongs_to(
    "fund",
    "Koha::Schema::Result::KohaPluginAcquireFund",
    { fund_id => "fund_id" },
    {
        is_deferrable => 1,
        join_type     => "LEFT",
        on_delete     => "CASCADE",
        on_update     => "CASCADE",
    },
);

=head2 koha_plugin_acquire_fund_allocations

Type: has_many

Related object: L<Koha::Schema::Result::KohaPluginAcquireFundAllocation>

=cut

__PACKAGE__->has_many(
    "koha_plugin_acquire_fund_allocations",
    "Koha::Schema::Result::KohaPluginAcquireFundAllocation",
    { "foreign.sub_fund_id" => "self.sub_fund_id" },
    { cascade_copy          => 0, cascade_delete => 0 },
);

=head2 ledger

Type: belongs_to

Related object: L<Koha::Schema::Result::KohaPluginAcquireLedger>

=cut

__PACKAGE__->belongs_to(
    "ledger",
    "Koha::Schema::Result::KohaPluginAcquireLedger",
    { ledger_id => "ledger_id" },
    {
        is_deferrable => 1,
        join_type     => "LEFT",
        on_delete     => "CASCADE",
        on_update     => "CASCADE",
    },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:R8dTYY45LSzzzo8zGAuUAw


sub koha_object_class {
    'Koha::Acquire::Funds::SubFund';
}

sub koha_objects_class {
    'Koha::Acquire::Funds::SubFunds';
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
