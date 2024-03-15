use utf8;
package Koha::Schema::Result::KohaPluginAcquireFundGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::KohaPluginAcquireFundGroup

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<koha_plugin_acquire_fund_group>

=cut

__PACKAGE__->table("koha_plugin_acquire_fund_group");

=head1 ACCESSORS

=head2 fund_group_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

name for the fund group

=head2 currency

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 10

currency of the fund allocation

=head2 visible_to

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

library groups the fund allocation is visible to

=cut

__PACKAGE__->add_columns(
  "fund_group_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
  "currency",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 10 },
  "visible_to",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</fund_group_id>

=back

=cut

__PACKAGE__->set_primary_key("fund_group_id");

=head1 RELATIONS

=head2 koha_plugin_acquire_funds

Type: has_many

Related object: L<Koha::Schema::Result::KohaPluginAcquireFund>

=cut

__PACKAGE__->has_many(
  "koha_plugin_acquire_funds",
  "Koha::Schema::Result::KohaPluginAcquireFund",
  { "foreign.fund_group_id" => "self.fund_group_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2024-03-15 15:11:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:72UFs0QvOX6bl3oCM4hsJQ

sub koha_object_class {
    'Koha::Acquire::Funds::FundGroup';
}

sub koha_objects_class {
    'Koha::Acquire::Funds::FundGroups';
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
