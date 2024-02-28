package Koha::Acquire::Funds::Fund;

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


=head3 fiscal_yr

Method to embed the fiscal year to a given fund

=cut

sub fiscal_yr {
    my ($self) = @_;
    my $fiscal_year_rs = $self->_result->fiscal_yr;
    return Koha::Acquire::Funds::FiscalYear->_new_from_dbic($fiscal_year_rs);
}

=head3 ledger

Method to embed the ledger to a given fund

=cut

sub ledger {
    my ($self) = @_;
    my $ledger_rs = $self->_result->ledger;
    return Koha::Acquire::Funds::Ledger->_new_from_dbic($ledger_rs);
}


=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginAcquireFund';
}

1;
