use utf8;

package Koha::Schema::Result::KohaPluginAcquireSetting;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::KohaPluginAcquireSetting

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<koha_plugin_acquire_settings>

=cut

__PACKAGE__->table("koha_plugin_acquire_settings");

=head1 ACCESSORS

=head2 variable

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

system preference name

=head2 value

  data_type: 'mediumtext'
  is_nullable: 1

system preference values

=head2 options

  data_type: 'longtext'
  is_nullable: 1

options for multiple choice system preferences

=head2 explanation

  data_type: 'mediumtext'
  is_nullable: 1

descriptive text for the system preference

=head2 type

  data_type: 'varchar'
  is_nullable: 1
  size: 20

type of question this preference asks (multiple choice, plain text, yes or no, etc)

=cut

__PACKAGE__->add_columns(
    "variable",
    { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
    "value",
    { data_type => "mediumtext", is_nullable => 1 },
    "options",
    { data_type => "longtext", is_nullable => 1 },
    "explanation",
    { data_type => "mediumtext", is_nullable => 1 },
    "type",
    { data_type => "varchar", is_nullable => 1, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</variable>

=back

=cut

__PACKAGE__->set_primary_key("variable");

# Created by DBIx::Class::Schema::Loader v0.07049 @ 2024-02-19 11:47:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:s895mXULV7VT5nLVVksElQ

# You can replace this text with custom code or comments, and it will be preserved on regeneration

sub koha_object_class {
    'Koha::Acquire::Settings::Setting';
}

sub koha_objects_class {
    'Koha::Acquire::Settings::Settings';
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
