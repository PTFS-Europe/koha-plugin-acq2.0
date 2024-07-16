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


=head3 store

=cut 

sub store {
    my ( $self, $args ) = @_;

    $self->SUPER::store;

    $self->cascade_to_fund_allocations;
    $self->cascade_to_sub_funds;

    return $self;
}

=head3 delete

=cut

sub delete {
    my ( $self, $args ) = @_;

    my $deleted = $self->_result()->delete;

    my $ledger = $self->ledger;
    $ledger->update_ledger_total;

    return $self;
}

=head3 has_sub_funds

Checks if a fund has sub funds

=cut

sub has_sub_funds {
    my ( $self, $args ) = @_;

    my $sub_fund_count = $self->koha_plugin_acquire_sub_funds->count;

    return 1 if scalar($sub_fund_count > 0);
    return 0;
}

=head3 cascade_to_fund_allocations

This method cascades changes to the values of the "visible_to" and "status" properties to all fund_allocations attached to this fund

=cut

sub cascade_to_fund_allocations {
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
        my @data_to_cascade = ( 'fiscal_period_id', 'currency', 'owner', 'ledger_id' );
        my $data_updated = Koha::Acquire::Funds::Utils->cascade_data(
            {
                parent     => $self,
                child      => $fund_allocation,
                properties => \@data_to_cascade
            }
        );
        $fund_allocation->store({ block_fund_value_update => 1 }) if $visibility_updated || $data_updated;
    }
}


=head3 cascade_to_sub_funds

This method cascades changes to the values of the "visible_to" and "status" properties to all sub_funds attached to this fund

=cut

sub cascade_to_sub_funds {
    my ( $self, $args ) = @_;

    my @sub_funds  = $self->koha_plugin_acquire_sub_funds->as_list;
    my $visible_to = $self->visible_to;
    my $status     = $self->status;

    foreach my $sub_fund (@sub_funds) {
        my $visibility_updated = Koha::Acquire::Funds::Utils->cascade_lib_group_visibility(
            {
                parent_visibility => $visible_to,
                child             => $sub_fund
            }
        );
        my $status_updated = Koha::Acquire::Funds::Utils->cascade_status(
            {
                parent_status => $status,
                child         => $sub_fund
            }
        );
        my @data_to_cascade = ( 'fiscal_period_id', 'currency', 'owner', 'ledger_id' );
        my $data_updated    = Koha::Acquire::Funds::Utils->cascade_data(
            {
                parent     => $self,
                child      => $sub_fund,
                properties => \@data_to_cascade
            }
        );
        $sub_fund->store( { block_fund_value_update => 1 } ) if $status_updated || $visibility_updated || $data_updated;
    }
}

=head3 update_fund_total

This method is called whenever a fund allocation is made.
It updates the value of the fund based on the fund allocations and then triggers an update to the ledger value

=cut

sub update_fund_total {
    my ( $self, $args ) = @_;

    my @allocations;
    if ( $self->has_sub_funds ) {
        my @sub_funds = $self->koha_plugin_acquire_sub_funds->as_list;
        foreach my $sub_fund (@sub_funds) {
            push( @allocations, $sub_fund->koha_plugin_acquire_fund_allocations->as_list );
        }
    } else {
        push( @allocations, $self->koha_plugin_acquire_fund_allocations->as_list );
    }
    my $total = 0;

    foreach my $allocation (@allocations) {
        $total += $allocation->allocation_amount;
    }
    $self->fund_value($total)->store;

    my $ledger = $self->ledger;
    $ledger->update_ledger_total;

    return $total;
}

=head3 fiscal_period

Method to embed the fiscal period to a given fund

=cut

sub fiscal_period {
    my ($self) = @_;
    my $fiscal_period_rs = $self->_result->fiscal_period;
    return Koha::Acquire::Funds::FiscalPeriod->_new_from_dbic($fiscal_period_rs);
}

=head3 ledger

Method to embed the ledger to a given fund

=cut

sub ledger {
    my ($self) = @_;
    my $ledger_rs = $self->_result->ledger;
    return Koha::Acquire::Funds::Ledger->_new_from_dbic($ledger_rs);
}

=head3 fund_group

Method to embed the fund group to a given fund

=cut

sub fund_group {
    my ($self) = @_;
    my $fund_group_rs = $self->_result->fund_group;
    return unless $fund_group_rs;
    return Koha::Acquire::Funds::FundGroup->_new_from_dbic($fund_group_rs);
}

=head3 koha_plugin_acquire_sub_funds

Method to embed sub funds to the fund

=cut

sub koha_plugin_acquire_sub_funds {
    my ($self) = @_;
    my $sub_fund_rs = $self->_result->koha_plugin_acquire_sub_funds;
    return Koha::Acquire::Funds::SubFunds->_new_from_dbic($sub_fund_rs);
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

Method to embed the owner to a given fund

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
    return 'KohaPluginAcquireFund';
}

1;
