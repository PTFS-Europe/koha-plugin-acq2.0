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

$template->param(
    userflags => $userflags
);

output_html_with_http_headers $query, $cookie, $template->output;
