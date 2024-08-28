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

use Test::More tests => 3;
use Test::Mojo;

use t::lib::TestBuilder;
use t::lib::Mocks;

use Koha::Database;

my $schema  = Koha::Database->new->schema;
my $builder = t::lib::TestBuilder->new;

my $t = Test::Mojo->new('Koha::REST::V1');
t::lib::Mocks::mock_preference( 'RESTBasicAuth', 1 );

subtest 'filter_data_by_group' => sub {

    plan tests => 12;

    $schema->storage->txn_begin;

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

    my $library   = $builder->build_object( { class => 'Koha::Libraries' } );
    my $lib_group = Koha::Library::Group->new( { title => "Test root group" } )->store();
    my $group_library =
        Koha::Library::Group->new( { parent_id => $lib_group->id, branchcode => $library->branchcode } )->store();
    my $library2   = $builder->build_object( { class => 'Koha::Libraries' } );
    my $lib_group2 = Koha::Library::Group->new( { title => "Test root group 2" } )->store();
    my $group_library2 =
        Koha::Library::Group->new( { parent_id => $lib_group2->id, branchcode => $library2->branchcode } )->store();


    my $ledger = $builder->build_object(
        { class => 'Koha::Acquire::Funds::Ledgers', value => { visible_to => $lib_group->id } } );
    my $ledger2 = $builder->build_object(
        { class => 'Koha::Acquire::Funds::Ledgers', value => { visible_to => $lib_group2->id } } );

    my $module = Test::MockModule->new('C4::Context');
    $module->mock(
        'mybranch',
        sub {
            return $library->branchcode;
        }
    );

    $t->get_ok("//$userid:$password@/api/v1/contrib/acquire/ledgers")->status_is(200)->json_is( [ $ledger->to_api ] );

    $module->mock(
        'mybranch',
        sub {
            return $library2->branchcode;
        }
    );
    $t->get_ok("//$userid:$password@/api/v1/contrib/acquire/ledgers")->status_is(200)->json_is( [ $ledger2->to_api ] );

    my $ledger3 = $builder->build_object(
        { class => 'Koha::Acquire::Funds::Ledgers', value => { visible_to => $lib_group2->id } } );

    $t->get_ok("//$userid:$password@/api/v1/contrib/acquire/ledgers")->status_is(200)->json_is( [ $ledger2->to_api, $ledger3->to_api ] );

    $module->mock(
        'mybranch',
        sub {
            return $library->branchcode;
        }
    );
    $t->get_ok("//$userid:$password@/api/v1/contrib/acquire/ledgers")->status_is(200)->json_is( [ $ledger->to_api ] );

    $schema->storage->txn_rollback;
};

subtest 'add_lib_group_data' => sub {

    plan tests => 3;

    $schema->storage->txn_begin;

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

    my $library   = $builder->build_object( { class => 'Koha::Libraries' } );
    my $lib_group = $builder->build_object( { class => 'Koha::Library::Groups' } );
    my $group_library =
        Koha::Library::Group->new( { parent_id => $lib_group->id, branchcode => $library->branchcode } )->store();
    my $library2   = $builder->build_object( { class => 'Koha::Libraries' } );
    my $lib_group2 = $builder->build_object( { class => 'Koha::Library::Groups' } );
    my $group_library2 =
        Koha::Library::Group->new( { parent_id => $lib_group2->id, branchcode => $library2->branchcode } )->store();

    my $lib_group_1_id = $lib_group->id;
    my $lib_group_2_id = $lib_group2->id;

    my $ledger = $builder->build_object(
        { class => 'Koha::Acquire::Funds::Ledgers', value => { visible_to => "$lib_group_1_id|$lib_group_2_id" } } );

    my $module = Test::MockModule->new('C4::Context');
    $module->mock(
        'mybranch',
        sub {
            return $library->branchcode;
        }
    );

    my $ledger_id = $ledger->id;
    $t->get_ok("//$userid:$password@/api/v1/contrib/acquire/ledgers/$ledger_id")->status_is(200)->json_is( '/lib_groups' => [ $lib_group->unblessed, $lib_group2->unblessed ] );

    $schema->storage->txn_rollback;
};

subtest 'add_accounting_values_to_ledgers_or_fund_groups_or_funds' => sub {

    plan tests => 4;

    $schema->storage->txn_begin;

    my $test_object = {
        koha_plugin_acquire_funds => [
            {
                koha_plugin_acquire_fund_allocations => [
                    { allocation_amount => 10, is_transfer => 0 },
                    { allocation_amount => 20, is_transfer => 0 },
                    { allocation_amount => 30, is_transfer => 1 },
                ]
            },
            {
                koha_plugin_acquire_fund_allocations => [
                    { allocation_amount => 10,  is_transfer => 0 },
                    { allocation_amount => 50,  is_transfer => 0 },
                    { allocation_amount => -30, is_transfer => 1 },
                ]
            },
        ],
        koha_plugin_acquire_sub_funds => [
            {
                koha_plugin_acquire_fund_allocations => [
                    { allocation_amount => 10, is_transfer => 0 },
                    { allocation_amount => 20, is_transfer => 0 },
                    { allocation_amount => -10, is_transfer => 0 },
                ]
            }
        ],

        koha_plugin_acquire_fund_allocations => [
            { allocation_amount => 40, is_transfer => 0 },
            { allocation_amount => 20, is_transfer => 1 },
            { allocation_amount => -10, is_transfer => 0 },
        ]
    };

    my $data_to_test = Koha::Plugin::Acquire::Controllers::ControllerUtils->add_accounting_values_to_ledgers_or_fund_groups_or_funds({ data => $test_object});
    is($data_to_test->{total_allocation}, 160, 'Total allocation correctly calculated');
    is($data_to_test->{allocation_increase}, 210, 'Total allocation increase correctly calculated');
    is($data_to_test->{allocation_decrease}, -50, 'Total allocation decrease correctly calculated');
    is($data_to_test->{net_transfers}, 20, 'Total transfers correctly calculated');


    $schema->storage->txn_rollback;
};
