use utf8;

package Koha::Schema::Result::KohaPluginAcquireWorkflowTask;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::KohaPluginAcquireWorkflowTask

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<koha_plugin_acquire_workflow_tasks>

=cut

__PACKAGE__->table("koha_plugin_acquire_workflow_tasks");

=head1 ACCESSORS

=head2 task_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 short_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 50

short name for the task

=head2 module

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

module the task relates to

=head2 description

  data_type: 'longtext'
  default_value: ''''
  is_nullable: 1

description for the task

=head2 created_on

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

creation date of the task

=head2 created_by

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

person who created the task

=head2 end_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

target completion date of the task

=head2 status

  data_type: 'enum'
  default_value: 'assigned'
  extra: {list => ["assigned","complete","cancelled","on_hold"]}
  is_nullable: 0

is the task complete

=head2 closed_on

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

date the task was completed

=head2 owner

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

person the task is assigned to

=cut

__PACKAGE__->add_columns(
    "task_id",
    { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
    "short_name",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 50 },
    "module",
    { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
    "description",
    { data_type => "longtext", default_value => "''", is_nullable => 1 },
    "created_on",
    {
        data_type                 => "datetime",
        datetime_undef_if_invalid => 1,
        is_nullable               => 1,
    },
    "created_by",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
    "end_date",
    {
        data_type                 => "datetime",
        datetime_undef_if_invalid => 1,
        is_nullable               => 1,
    },
    "status",
    {
        data_type     => "enum",
        default_value => "assigned",
        extra         => { list => [ "assigned", "complete", "cancelled", "on_hold" ] },
        is_nullable   => 0,
    },
    "closed_on",
    {
        data_type                 => "datetime",
        datetime_undef_if_invalid => 1,
        is_nullable               => 1,
    },
    "owner",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</task_id>

=back

=cut

__PACKAGE__->set_primary_key("task_id");

=head1 RELATIONS

=head2 created_by

Type: belongs_to

Related object: L<Koha::Schema::Result::Borrower>

=cut

__PACKAGE__->belongs_to(
    "created_by",
    "Koha::Schema::Result::Borrower",
    { borrowernumber => "created_by" },
    {
        is_deferrable => 1,
        join_type     => "LEFT",
        on_delete     => "RESTRICT",
        on_update     => "RESTRICT",
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

# Created by DBIx::Class::Schema::Loader v0.07049 @ 2024-02-22 16:39:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:z+Nonp1RbrzdtZL2rO9tkQ


sub koha_object_class {
    'Koha::Acquire::TaskManagement::Task';
}

sub koha_objects_class {
    'Koha::Acquire::TaskManagement::Tasks';
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
