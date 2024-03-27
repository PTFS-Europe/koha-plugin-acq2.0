package Koha::Acquire::Funds::FundAllocation;

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

use Koha::Acquire::Funds::Fund;

=head3 store

=cut

sub store {
    my ($self, $args) = @_;

    my $block_fund_value_update = $args->{block_fund_value_update};

    $self->SUPER::store;

    if(!$block_fund_value_update) {
        my $fund = $self->fund;
        $fund->update_fund_total if $fund && !$self->sub_fund_id;
        my $sub_fund = $self->sub_fund;
        $sub_fund->update_sub_fund_total if $sub_fund;
    }

    return $self;
}

=head3 delete

=cut

sub delete {
    my ( $self, $args ) = @_;

    my $deleted = $self->_result()->delete;

    my $fund = $self->fund;
    $fund->update_fund_total;

    return $self;
}

=head3 fiscal_yr

Method to embed the fiscal year to a given fund allocation

=cut

sub fiscal_yr {
    my ($self) = @_;
    my $fiscal_year_rs = $self->_result->fiscal_yr;
    return Koha::Acquire::Funds::FiscalYear->_new_from_dbic($fiscal_year_rs);
}


=head3 ledger

Method to embed the ledger to a given fund allocation

=cut

sub ledger {
    my ($self) = @_;
    my $ledger_rs = $self->_result->ledger;
    return Koha::Acquire::Funds::Ledger->_new_from_dbic($ledger_rs);
}

=head3 fund

Method to embed the fund to a given fund allocation

=cut

sub fund {
    my ($self) = @_;
    my $fund_rs = $self->_result->fund;
    return unless $fund_rs;
    return Koha::Acquire::Funds::Fund->_new_from_dbic($fund_rs);
}

=head3 sub_fund

Method to embed the sub_fund to a given fund allocation

=cut

sub sub_fund {
    my ($self) = @_;
    my $sub_fund_rs = $self->_result->sub_fund;
    return unless $sub_fund_rs;
    return Koha::Acquire::Funds::SubFund->_new_from_dbic($sub_fund_rs);
}

=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginAcquireFundAllocation';
}

1;
