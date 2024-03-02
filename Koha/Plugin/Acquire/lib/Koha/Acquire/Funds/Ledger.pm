package Koha::Acquire::Funds::Ledger;

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

=head3 update_ledger_total

This method is triggered whenever a fund value is updated and updates the value of the relevant ledger

=cut

sub update_ledger_total {
    my ( $self, $args ) = @_;

    my @funds = $self->koha_plugin_acquire_funds->as_list;
    my $total = 0;

    foreach my $fund (@funds) {
        $total += $fund->fund_value;
    }
    $self->ledger_value($total)->store;
    return $total;
}


=head3 fiscal_yr

Method to embed the fiscal year to a given ledger

=cut

sub fiscal_yr {
    my ($self) = @_;
    my $fiscal_year_rs = $self->_result->fiscal_yr;
    return Koha::Acquire::Funds::FiscalYear->_new_from_dbic($fiscal_year_rs);
}


=head3 koha_plugin_acquire_funds

Method to embed funds to the fiscal year

=cut

sub koha_plugin_acquire_funds {
    my ($self) = @_;
    my $fund_rs = $self->_result->koha_plugin_acquire_funds;
    return Koha::Acquire::Funds::Funds->_new_from_dbic($fund_rs);
}



=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginAcquireLedger';
}

1;
