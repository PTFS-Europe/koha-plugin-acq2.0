use utf8;

package Koha::Schema::Result::KohaPluginAcquireLedger;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::KohaPluginAcquireLedger

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<koha_plugin_acquire_ledgers>

=cut

__PACKAGE__->table("koha_plugin_acquire_ledgers");

=head1 ACCESSORS

=head2 ledger_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 fiscal_period_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

fiscal period the ledger applies to

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

name for the ledger

=head2 description

  data_type: 'longtext'
  default_value: ''''
  is_nullable: 1

description for the ledger

=head2 code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

code for the ledger

=head2 external_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

external id for the ledger for use with external accounting systems

=head2 currency

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 10

currency of the ledger

=head2 status

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 1

is the ledger currently active

=head2 last_updated

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 1

time of the last update to the ledger

=head2 owner_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

owner of the ledger

=head2 visible_to

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

library groups the ledger is visible to

=head2 ledger_value

  data_type: 'decimal'
  default_value: 0.000000
  is_nullable: 1
  size: [28,6]

value of the ledger

=head2 over_spend_allowed

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 1

is an overspend allowed on the ledger

=head2 over_encumbrance_allowed

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 1

is an overencumbrance allowed on the ledger

=head2 oe_warning_percent

  data_type: 'decimal'
  default_value: 0.0000
  is_nullable: 1
  size: [5,4]

percentage limit for overencumbrance

=head2 oe_limit_amount

  data_type: 'decimal'
  default_value: 0.000000
  is_nullable: 1
  size: [28,6]

limit for overspend

=head2 os_warning_sum

  data_type: 'decimal'
  default_value: 0.000000
  is_nullable: 1
  size: [28,6]

amount to trigger a warning for overspend

=head2 os_limit_sum

  data_type: 'decimal'
  default_value: 0.000000
  is_nullable: 1
  size: [28,6]

amount to trigger a block on the ledger for overspend

=cut

__PACKAGE__->add_columns(
    "ledger_id",
    { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
    "fiscal_period_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
    "name",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
    "description",
    { data_type => "longtext", default_value => "''", is_nullable => 1 },
    "code",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
    "external_id",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
    "currency",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 10 },
    "status",
    { data_type => "tinyint", default_value => 1, is_nullable => 1 },
    "last_updated",
    {
        data_type                 => "timestamp",
        datetime_undef_if_invalid => 1,
        default_value             => \"current_timestamp",
        is_nullable               => 1,
    },
    "owner_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
    "visible_to",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
    "ledger_value",
    {
        data_type     => "decimal",
        default_value => "0.000000",
        is_nullable   => 1,
        size          => [ 28, 6 ],
    },
    "over_spend_allowed",
    { data_type => "tinyint", default_value => 1, is_nullable => 1 },
    "over_encumbrance_allowed",
    { data_type => "tinyint", default_value => 1, is_nullable => 1 },
    "oe_warning_percent",
    {
        data_type     => "decimal",
        default_value => "0.0000",
        is_nullable   => 1,
        size          => [ 5, 4 ],
    },
    "oe_limit_amount",
    {
        data_type     => "decimal",
        default_value => "0.000000",
        is_nullable   => 1,
        size          => [ 28, 6 ],
    },
    "os_warning_sum",
    {
        data_type     => "decimal",
        default_value => "0.000000",
        is_nullable   => 1,
        size          => [ 28, 6 ],
    },
    "os_limit_sum",
    {
        data_type     => "decimal",
        default_value => "0.000000",
        is_nullable   => 1,
        size          => [ 28, 6 ],
    },
);

=head1 PRIMARY KEY

=over 4

=item * L</ledger_id>

=back

=cut

__PACKAGE__->set_primary_key("ledger_id");

=head1 RELATIONS

=head2 fiscal_period

Type: belongs_to

Related object: L<Koha::Schema::Result::KohaPluginAcquireFiscalPeriod>

=cut

__PACKAGE__->belongs_to(
    "fiscal_period",
    "Koha::Schema::Result::KohaPluginAcquireFiscalPeriod",
    { fiscal_period_id => "fiscal_period_id" },
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
    { "foreign.ledger_id" => "self.ledger_id" },
    { cascade_copy        => 0, cascade_delete => 0 },
);

=head2 koha_plugin_acquire_funds

Type: has_many

Related object: L<Koha::Schema::Result::KohaPluginAcquireFund>

=cut

__PACKAGE__->has_many(
    "koha_plugin_acquire_funds",
    "Koha::Schema::Result::KohaPluginAcquireFund",
    { "foreign.ledger_id" => "self.ledger_id" },
    { cascade_copy        => 0, cascade_delete => 0 },
);

=head2 koha_plugin_acquire_sub_funds

Type: has_many

Related object: L<Koha::Schema::Result::KohaPluginAcquireSubFund>

=cut

__PACKAGE__->has_many(
    "koha_plugin_acquire_sub_funds",
    "Koha::Schema::Result::KohaPluginAcquireSubFund",
    { "foreign.ledger_id" => "self.ledger_id" },
    { cascade_copy        => 0, cascade_delete => 0 },
);

=head2 owner

Type: belongs_to

Related object: L<Koha::Schema::Result::Borrower>

=cut

__PACKAGE__->belongs_to(
    "owner",
    "Koha::Schema::Result::Borrower",
    { borrowernumber => "owner_id" },
    {
        is_deferrable => 1,
        join_type     => "LEFT",
        on_delete     => "RESTRICT",
        on_update     => "RESTRICT",
    },
);

# Created by DBIx::Class::Schema::Loader v0.07049 @ 2024-03-27 11:18:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:shq4M2IHcd931nl0PrekQw


sub koha_object_class {
    'Koha::Acquire::Fund::FiscalPeriod';
}

sub koha_objects_class {
    'Koha::Acquire::Fund::FiscalPeriods';
}


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
