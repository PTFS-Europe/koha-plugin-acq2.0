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

sub add_patron_data {
    my ( $self, $args ) = @_;

    my $data = _get_unblessed( $args->{data} );
    my $field = $args->{field};
    my $key = $args->{key};

    my $patron = Koha::Patrons->find( { borrowernumber => $data->{$key} } );
    $data->{$field} = $patron->unblessed;

    return $data;
}

sub add_lib_group_data {
    my ( $self, $args ) = @_;

    my $data = _get_unblessed( $args->{data} );

    my @ids = split( /\|/, $data->{visible_to} );
    my @lib_groups;

    foreach my $id (@ids) {
        my $lib_group = Koha::Library::Groups->find( { id => $id } );
        push( @lib_groups, $lib_group->unblessed );
    }

    $data->{lib_groups} = \@lib_groups;
    return $data;
}


1;
