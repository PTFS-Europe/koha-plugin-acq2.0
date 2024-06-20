package Koha::Acquire::Funds::FiscalPeriod;

# Copyright 2024 PTFS Europe

# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Koha is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Koha; if not, see <http://www.gnu.org/licenses>.

use Modern::Perl;
use base qw(Koha::Object);

use Mojo::JSON qw(decode_json);
use JSON       qw ( encode_json );

use Koha::Acquire::Funds::Utils;

=head3 store

=cut

sub store {
    my ( $self, $args ) = @_;

    $self->SUPER::store;

    $self->cascade_to_ledgers;

    return $self;
}


=head3 delete

=cut

sub delete {
    my ( $self, $args ) = @_;

    my $deleted = $self->_result()->delete;

    return $self;
}


=head3 cascade_to_ledgers

This method cascades changes to the values of the "visible_to" and "status" properties to all ledgers attached to this fiscal period

=cut

sub cascade_to_ledgers {
    my ( $self, $args ) = @_;

    my @ledgers    = $self->koha_plugin_acquire_ledgers->as_list;
    my $visible_to = $self->visible_to;
    my $status     = $self->status;

    foreach my $ledger (@ledgers) {
        my $status_updated = Koha::Acquire::Funds::Utils->cascade_status(
            {
                parent_status => $status,
                child         => $ledger
            }
        );
        my $visibility_updated = Koha::Acquire::Funds::Utils->cascade_lib_group_visibility(
            {
                parent_visibility => $visible_to,
                child             => $ledger
            }
        );
        $ledger->store() if $status_updated || $visibility_updated;
    }
}


=head3 koha_plugin_acquire_ledgers

Method to embed ledgers to the fiscal period

=cut

sub koha_plugin_acquire_ledgers {
    my ($self) = @_;
    my $ledger_rs = $self->_result->koha_plugin_acquire_ledgers;
    return Koha::Acquire::Funds::Ledgers->_new_from_dbic($ledger_rs);
}


=head3 owner

Method to embed the owner to a given fiscal period

=cut

sub owner {
    my ($self) = @_;
    my $owner_rs = $self->_result->owner;
    return Koha::Patron->_new_from_dbic($owner_rs);
}


=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginAcquireFiscalPeriod';
}

1;
