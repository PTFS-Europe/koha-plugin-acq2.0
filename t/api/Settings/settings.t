#!/usr/bin/env perl

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

use Test::More tests => 2;
use Test::Mojo;

use t::lib::TestBuilder;
use t::lib::Mocks;

use Koha::Acquire::Settings::Setting;
use Koha::Acquire::Settings::Settings;
use Koha::Database;

my $schema  = Koha::Database->new->schema;
my $builder = t::lib::TestBuilder->new;

my $t = Test::Mojo->new('Koha::REST::V1');
t::lib::Mocks::mock_preference( 'RESTBasicAuth', 1 );

subtest 'get_settings() tests' => sub {

    plan tests => 9;

    $schema->storage->txn_begin;

    Koha::Acquire::Settings::Settings->search->delete;

    my $librarian = $builder->build_object(
        {
            class => 'Koha::Patrons',
            value => { flags => 2**28 }
        }
    );
    my $password = 'thePassword123';
    $librarian->set_password( { password => $password, skip_validation => 1 } );
    my $userid = $librarian->userid;

    my $patron = $builder->build_object(
        {
            class => 'Koha::Patrons',
            value => { flags => 0 }
        }
    );

    $patron->set_password( { password => $password, skip_validation => 1 } );
    my $unauth_userid = $patron->userid;

    ## Authorized user tests
    # No settings, so empty array should be returned
    $t->get_ok("//$userid:$password@/api/v1/contrib/acquire/settings")->status_is(200)->json_is( [] );

    my $setting = $builder->build_object(
        { class => 'Koha::Acquire::Settings::Settings', value => { variable => "settingOne"} });

    $t->get_ok("//$userid:$password@/api/v1/contrib/acquire/settings")->status_is(200)
        ->json_is( [ $setting->to_api ] );

    my $another_setting = $builder->build_object(
        {
            class => 'Koha::Acquire::Settings::Settings',
            value => { variable => "settingTwo" }
        }
    );

    # Two settings created, they should both be returned
    $t->get_ok("//$userid:$password@/api/v1/contrib/acquire/settings")->status_is(200)
        ->json_is( [ $setting->to_api, $another_setting->to_api, ] );

    $schema->storage->txn_rollback;
};

subtest 'store_settings() tests' => sub {

    plan tests => 3;

    $schema->storage->txn_begin;

    Koha::Acquire::Settings::Settings->search->delete;

    my $librarian = $builder->build_object(
        {
            class => 'Koha::Patrons',
            value => { flags => 2**28 }
        }
    );
    my $password = 'thePassword123';
    $librarian->set_password( { password => $password, skip_validation => 1 } );
    my $userid = $librarian->userid;

    my $patron = $builder->build_object(
        {
            class => 'Koha::Patrons',
            value => { flags => 0 }
        }
    );

    $patron->set_password( { password => $password, skip_validation => 1 } );
    my $unauth_userid = $patron->userid;

    my $setting = {
        variable => 'test',
        value => 'test',
        options => undef,
        explanation => 'A test setting',
        type => 'test'
    };
    Koha::Acquire::Settings::Setting->new($setting)->store();

    # Authorized attempt to write
    my $setting_id =
        $t->post_ok( "//$userid:$password@/api/v1/contrib/acquire/settings" => json => { $setting->{variable} => $setting->{value} } )
        ->status_is( 201, 'SWAGGER3.2.1' )->json_is( 'Success' );

    $schema->storage->txn_rollback;
};
