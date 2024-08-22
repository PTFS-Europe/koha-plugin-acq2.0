package Koha::Plugin::Acquire::Controllers::Settings::Settings;

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

use Koha::Acquire::Settings::Settings;

sub get_settings {
    my $c = shift->openapi->valid_input or return;

    my $settings_set = Koha::Acquire::Settings::Settings->new;
    my $settings = $c->objects->search( $settings_set );

    return $c->render( status => 200, openapi => $settings );
}

sub store_settings {
    my $c = shift->openapi->valid_input or return;

    my $body = $c->req->body;

    my $settings = decode_json($body);
    my @keys = keys %$settings;
    foreach my $key ( @keys ) {
        my $setting = Koha::Acquire::Settings::Settings->find({ variable => $key });
        $setting->value($settings->{$key})->store();
    }

    return $c->render( status => 201, openapi => 'Success' );

}



1;
