package Koha::Acquire::Funds::FiscalYear;

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


=head3 delete

=cut

sub delete {
    my ( $self, $args ) = @_;

    my $deleted = $self->_result()->delete;

    return $self;
}

=head3 koha_plugin_acquire_ledgers

Method to embed ledgers to the fiscal year

=cut

sub koha_plugin_acquire_ledgers {
    my ($self) = @_;
    my $ledger_rs = $self->_result->koha_plugin_acquire_ledgers;
    return Koha::Acquire::Funds::Ledgers->_new_from_dbic($ledger_rs);
}


=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginAcquireFiscalYear';
}

1;
