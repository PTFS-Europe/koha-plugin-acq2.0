#!/usr/bin/perl
#
# Copyright 2024 PTFS Europe Ltd
#
# This file is not part of Koha.
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

use C4::Auth qw( get_template_and_user haspermission );
use C4::Context;
use C4::Output    qw( output_html_with_http_headers );

use CGI qw ( -utf8 );

use Koha::Plugin::Acquire;
use Koha::Patrons;
use Koha::Libraries;

my $self  = Koha::Plugin::Acquire->new;
my $query = CGI->new;
my ( $template, $borrowernumber, $cookie ) = get_template_and_user(
    {
        template_name   => $self->bundle_path . '/views/acquisitions-spa.tt',
        query           => $query,
        type            => 'intranet',
        is_plugin       => 1,
    }
);

my $patron = Koha::Patrons->find({ borrowernumber => $borrowernumber });
my $userflags = haspermission($patron->userid);

my $acquisitions_library_groups = Koha::Library::Groups->search({ ft_acquisitions => 1 });
my @user_library_groups;

foreach my $alg ( @{$acquisitions_library_groups->as_list } ) {
    my $lib_group = _map_library_group({ group => $alg });
    push @user_library_groups, $lib_group;
}

$template->param(
    userflags => $userflags,
    library_groups => \@user_library_groups
);

output_html_with_http_headers $query, $cookie, $template->output;

sub _map_library_group {
    my ( $args ) = @_;

    my $group = $args->{group};
    my $lib_group = {
        title => $group->title,
        id    => $group->id,
    };
    my @libs_or_sub_groups = Koha::Library::Groups->search(
        {
            parent_id       => $group->id
        }
    )->as_list;

    my @libraries;
    my @sub_groups;
    foreach my $lib ( @libs_or_sub_groups ) {
        if ($lib->branchcode) {
            push( @libraries, $lib->unblessed );
        } else {
            push( @sub_groups, _map_library_group({ group => $lib }) );
        }
    }
    $lib_group->{libraries} = \@libraries;
    $lib_group->{sub_groups} = \@sub_groups;

    $lib_group = _assign_branches_to_parent({ group => $lib_group });

    return $lib_group;
}

sub _assign_branches_to_parent {
    my ($args) = @_;

    my $group = $args->{group};
    my $libraries = $group->{libraries};
    my $sub_groups = $group->{sub_groups};

    if(!scalar(@$libraries) && scalar(@$sub_groups)) {
        my @sub_group_libraries;
        foreach my $sub_group (@$sub_groups) {
            if(!scalar(@{ $sub_group->{libraries} })) {
                $sub_group = _assign_branches_to_parent({ group => $sub_group });
            }
            push(@sub_group_libraries, @{ $sub_group->{libraries} });
        }
        $group->{libraries} = \@sub_group_libraries;
    }
    return $group;
}
