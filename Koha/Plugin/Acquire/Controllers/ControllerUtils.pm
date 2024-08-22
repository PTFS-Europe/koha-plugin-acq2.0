package Koha::Plugin::Acquire::Controllers::ControllerUtils;

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

use Mojo::JSON qw(decode_json);
use Scalar::Util qw( blessed );
use JSON qw ( encode_json );


use C4::Context;

use Koha::Libraries;
use Koha::Library::Groups;

sub filter_data_by_group {
    my ( $self, $args ) = @_;

    my $dataset = $args->{dataset};

    my $logged_in_branch = C4::Context::mybranch();
    return $dataset if !$logged_in_branch;

    my $branch         = Koha::Libraries->find( { branchcode => $logged_in_branch } );
    my $library_groups = $branch->library_groups;
    my @group_ids;
    if ( scalar( @{ $library_groups->as_list } ) == 0 ) {
        push( @group_ids, 1 );
    } else {
        @group_ids = map( $_->parent_id, @{ $library_groups->as_list } );
        foreach my $group_id (@group_ids) {
            my $group = Koha::Library::Groups->find( { id => $group_id } );
            push( @group_ids, $group->parent_id )
                if $group && $group->parent_id && !grep( $_ eq $group->parent_id, @group_ids );
        }
    }

    my @filtered_dataset;
    foreach my $item (@$dataset) {
        my @visible_groups = split( /\|/, $item->{visible_to} );
        my $already_added  = 0;
        foreach my $visible_group (@visible_groups) {
            if ( grep( "$_" eq $visible_group, @group_ids ) && !$already_added ) {
                push( @filtered_dataset, $item );
                $already_added = 1;
            }
        }
    }

    return \@filtered_dataset;
}

sub _get_unblessed {
    my ($data) = @_;

    return blessed $data ? $data->unblessed : $data;
}

sub add_lib_group_data {
    my ( $self, $args ) = @_;

    my $data = _get_unblessed( $args->{data} );

    my @ids = split( /\|/, $data->{visible_to} );
    my @lib_groups;

    foreach my $id (@ids) {
        my $lib_group = Koha::Library::Groups->find( { id => $id } );
        push( @lib_groups, $lib_group->unblessed ) if $lib_group;
    }

    if(scalar(@lib_groups) == 0) {
        my @branches  = Koha::Libraries->search()->as_list;
        my $lib_group = {
            title => 'All branches',
            id    => 1,
        };
        my @libraries;
        foreach my $branch (@branches) {
            push( @libraries, $branch->unblessed );
        }
        $lib_group->{libraries} = \@libraries;
        push( @lib_groups, $lib_group );
    }

    $data->{lib_groups} = \@lib_groups;
    return $data;
}

sub add_accounting_values_to_ledgers_or_fund_groups_or_funds {
    my ( $self, $args ) = @_;

    my $data = $args->{data};

    my @allocations = ();

    if ( defined $data->{koha_plugin_acquire_funds} ) {
        foreach my $fund ( @{ $data->{koha_plugin_acquire_funds} } ) {
            my @fund_allocations = @{ $fund->{koha_plugin_acquire_fund_allocations} };
            push( @allocations, @fund_allocations );
        }
    }
    if ( defined $data->{koha_plugin_acquire_sub_funds} ) {
        foreach my $sub_fund ( @{ $data->{koha_plugin_acquire_sub_funds} } ) {
            if( defined $sub_fund->{koha_plugin_acquire_fund_allocations} ) {
                my @fund_allocations = @{ $sub_fund->{koha_plugin_acquire_fund_allocations} };
                push( @allocations, @fund_allocations );
            }
        }
    }
    if ( defined $data->{koha_plugin_acquire_fund_allocations} ) {
        push( @allocations, @{ $data->{koha_plugin_acquire_fund_allocations} } );
    }

    if ( scalar(@allocations) > 0 ) {
        my $allocation_increase = 0;
        my $allocation_decrease = 0;
        my $net_transfers       = 0;

        foreach my $allocation (@allocations) {
            $allocation_increase += $allocation->{allocation_amount} if $allocation->{allocation_amount} > 0;
            $allocation_decrease += $allocation->{allocation_amount} if $allocation->{allocation_amount} < 0;
            $net_transfers       += $allocation->{allocation_amount} if $allocation->{is_transfer};
        }

        my $total_allocation = $allocation_increase + $allocation_decrease;
        $data->{total_allocation}    = $total_allocation;
        $data->{allocation_decrease} = $allocation_decrease;
        $data->{allocation_increase} = $allocation_increase;
        $data->{net_transfers}       = $net_transfers;
    }
    return $data;
}

sub add_totals_to_fund_allocations {
    my ($self, $args) = @_;

    my $allocations = $args->{allocations};
    my @sorted_allocations = sort { $a->{allocation_amount} <=> $b->{allocation_amount} } @$allocations;

    my $total = 0;
    foreach my $allocation_index ( 1 .. scalar(@sorted_allocations) ) {
        my $allocation = $sorted_allocations[ $allocation_index - 1 ];
        $allocation->{allocation_index} = $allocation_index;
        $total += $allocation->{allocation_amount};
        $allocation->{new_fund_value} = $total;
    }

    return \@sorted_allocations;
}

1;
