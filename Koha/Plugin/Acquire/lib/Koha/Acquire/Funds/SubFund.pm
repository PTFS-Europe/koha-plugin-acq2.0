package Koha::Acquire::Funds::SubFund;

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

=head3 store

=cut 

sub store {
    my ( $self, $args ) = @_;

    $self->SUPER::store;

    $self->cascade_to_fund_allocations;

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

=head3 cascade_to_fund_allocations

This method cascades changes to the values of the "visible_to" and "status" properties to all fund_allocations attached to this ledger

=cut

sub cascade_to_fund_allocations {
    # TODO: Needs to cascade to sub funds from parent fund and to FAs
    my ( $self, $args ) = @_;

    my @fund_allocations = $self->koha_plugin_acquire_fund_allocations->as_list;
    my $visible_to       = $self->visible_to;
    my $status           = $self->status;

    foreach my $fund_allocation (@fund_allocations) {
        my $visibility_updated = Koha::Acquire::Funds::Utils->cascade_lib_group_visibility(
            {
                parent_visibility => $visible_to,
                child             => $fund_allocation
            }
        );
        my @data_to_cascade = ( 'fiscal_period_id', 'currency', 'owner_id', 'ledger_id' );
        my $data_updated    = Koha::Acquire::Funds::Utils->cascade_data(
            {
                parent     => $self,
                child      => $fund_allocation,
                properties => \@data_to_cascade
            }
        );
        $fund_allocation->store( { block_fund_value_update => 1 } ) if $visibility_updated || $data_updated;
    }
}

=head3 update_sub_fund_total

This method is called whenever a fund allocation is made.
It updates the value of the fund based on the fund allocations and then triggers an update to the ledger value

=cut

sub update_sub_fund_total {
    my ( $self, $args ) = @_;

    my @allocations = $self->koha_plugin_acquire_fund_allocations->as_list;
    my $total       = 0;

    foreach my $allocation (@allocations) {
        $total += $allocation->allocation_amount;
    }
    $self->sub_fund_value($total)->store;

    my $fund = $self->fund;
    $fund->update_fund_total;

    return $total;
}

=head3 fiscal_period

Method to embed the fiscal period to a given sub fund

=cut

sub fiscal_period {
    my ($self) = @_;
    my $fiscal_period_rs = $self->_result->fiscal_period;
    return Koha::Acquire::Funds::FiscalPeriod->_new_from_dbic($fiscal_period_rs);
}

=head3 ledger

Method to embed the ledger to a given sub fund

=cut

sub ledger {
    my ($self) = @_;
    my $ledger_rs = $self->_result->ledger;
    return Koha::Acquire::Funds::Ledger->_new_from_dbic($ledger_rs);
}

=head3 fund

Method to embed the fund to a given sub fund

=cut

sub fund {
    my ($self) = @_;
    my $fund_rs = $self->_result->fund;
    return Koha::Acquire::Funds::Fund->_new_from_dbic($fund_rs);
}

=head3 koha_plugin_acquire_fund_allocations

Method to embed fund allocations to the fund

=cut

sub koha_plugin_acquire_fund_allocations {
    my ($self) = @_;
    my $fund_allocation_rs = $self->_result->koha_plugin_acquire_fund_allocations;
    return Koha::Acquire::Funds::FundAllocations->_new_from_dbic($fund_allocation_rs);
}


=head3 owner

Method to embed the owner to a given sub fund

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
    return 'KohaPluginAcquireSubFund';
}

1;
