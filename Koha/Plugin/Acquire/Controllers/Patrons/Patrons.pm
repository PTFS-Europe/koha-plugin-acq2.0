package Koha::Plugin::Acquire::Controllers::Patrons::Patrons;

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

use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json);

use Try::Tiny;

use Koha::Patrons;

use C4::Auth qw( haspermission );
use C4::Context;

sub get_permitted_patrons {
    my $c = shift->openapi->valid_input or return;

    my $logged_in_branch = C4::Context::mybranch();

    return try {
        my @permitted_patrons;
        my @patrons_with_flags = Koha::Patrons->search( { flags => { '!=' => undef } } )->as_list;

        foreach my $patron (@patrons_with_flags) {
            my $userflags = haspermission( $patron->userid );
            if ( $userflags->{acquisition} || $userflags->{superlibrarian} ) {
                my $p = $patron->unblessed;
                $p->{permissions} = $userflags;
                push( @permitted_patrons, $p );
            }
        }

        my $acquisitions_library_groups = Koha::Library::Groups->search( { ft_acquisitions => 1 } );
        if ( scalar( @{ $acquisitions_library_groups->as_list } == 0 ) ) {
            return $c->render( status => 200, openapi => \@permitted_patrons );
        } else {
            my @user_branchcodes = _get_lib_group_branchcodes($logged_in_branch);
            my @permitted_patrons_in_group;
            foreach my $patron (@permitted_patrons) {
                push( @permitted_patrons_in_group, $patron ) if grep( $patron->{branchcode} eq $_, @user_branchcodes );
            }
            return $c->render( status => 200, openapi => \@permitted_patrons_in_group );
        }
    } catch {
        $c->unhandled_exception($_);
    }
}

sub _get_lib_group_branchcodes {
    my ($logged_in_branch) = @_;

    my $branch         = Koha::Libraries->find( { branchcode => $logged_in_branch } );
    my $library_groups = $branch->library_groups;

    my @branchcodes;

    foreach my $group ( @{ $library_groups->as_list } ) {
        my @libs_or_sub_groups = Koha::Library::Groups->search( { parent_id => $group->parent_id } )->as_list;
        foreach my $lib (@libs_or_sub_groups) {
            if ( $lib->branchcode ) {
                push( @branchcodes, $lib->branchcode ) unless grep( $_ eq $lib->branchcode, @branchcodes );
            }
        }
    }
    return @branchcodes;
}

1;
