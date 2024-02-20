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

sub get_permitted_patrons {
    my $c = shift->openapi->valid_input or return;

    my @permitted_patrons;

    my @patrons_with_flags = Koha::Patrons->search({
        flags => { '!=' => undef }
    })->as_list;

    foreach my $patron ( @patrons_with_flags ) {
        my $userflags = haspermission( $patron->userid );
        if($userflags->{acquisition} || $userflags->{superlibrarian}) {
            my $p = $patron->unblessed;
            $p->{permissions} = $userflags;
            push(@permitted_patrons, $p);
        }
    }

    return $c->render( status => 200, openapi => \@permitted_patrons );
}


1;
