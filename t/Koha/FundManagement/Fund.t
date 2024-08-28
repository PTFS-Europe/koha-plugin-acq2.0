#!/usr/bin/perl

# This file is part of Koha
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

use Test::More tests => 4;

use t::lib::TestBuilder;
use t::lib::Mocks;

use Koha::Database;
use Koha::Acquire::Funds::Funds;

my $schema  = Koha::Database->new->schema;
my $builder = t::lib::TestBuilder->new;

subtest 'has_sub_funds' => sub {

    plan tests => 2;

    $schema->storage->txn_begin;

    my $fiscal_period = $builder->build_object(
        { class => 'Koha::Acquire::Funds::FiscalPeriods', value => { status => 1, visible_to => '1|2' } } );
    my $ledger = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::Ledgers',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                visible_to       => $fiscal_period->visible_to,
                status           => $fiscal_period->status,
                currency         => 'GBP',
                owner_id         => '1'
            }
        }
    );
    my $fund = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::Funds',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                ledger_id        => $ledger->ledger_id,
                visible_to       => $fiscal_period->visible_to,
                status           => $fiscal_period->status,
                currency         => $ledger->currency,
                owner_id         => $ledger->owner_id
            }
        }
    );

    my $sub_fund = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::SubFunds',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                ledger_id        => $ledger->ledger_id,

                fund_id    => $fund->fund_id,
                visible_to => '1|2',
                status     => 1,
                currency   => 'GBP',
                owner_id   => '1'
            }
        }
    );

    is( $fund->has_sub_funds, 1, 'Sub funds found' );

    my $fund_2 = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::Funds',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                ledger_id        => $ledger->ledger_id,

                visible_to => '1|2',
                status     => 1,
                currency   => 'GBP',
                owner_id   => '1'
            }
        }
    );

    is( $fund_2->has_sub_funds, 0, 'No sub funds found' );

    $schema->storage->txn_rollback;
};

subtest 'cascade_to_fund_allocations' => sub {

    plan tests => 3;

    $schema->storage->txn_begin;

    my $fiscal_period = $builder->build_object(
        { class => 'Koha::Acquire::Funds::FiscalPeriods', value => { status => 1, visible_to => '1|2' } } );
    my $ledger = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::Ledgers',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                visible_to       => $fiscal_period->visible_to,
                status           => $fiscal_period->status,
                currency         => 'GBP',
                owner_id         => '1'
            }
        }
    );
    my $fund = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::Funds',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                ledger_id        => $ledger->ledger_id,
                visible_to       => $fiscal_period->visible_to,
                status           => $fiscal_period->status,
                currency         => $ledger->currency,
                owner_id         => $ledger->owner_id
            }
        }
    );
    my $fund_allocation = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::FundAllocations',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                ledger_id        => $ledger->ledger_id,
                fund_id          => $fund->fund_id,
                sub_fund_id      => undef,
                visible_to       => $fiscal_period->visible_to,
                currency         => $ledger->currency,
                owner_id         => $ledger->owner_id
            }
        }
    );

    $fiscal_period->visible_to('1');
    $fiscal_period->store();

    my $updated_fund_allocation = Koha::Acquire::Funds::FundAllocations->find( $fund_allocation->fund_allocation_id );

    is( $fiscal_period->visible_to, $updated_fund_allocation->visible_to, 'Fund allocation has updated' );

    $fund->currency('USD');
    $fund->owner_id('2');
    $fund->store();

    $updated_fund_allocation = Koha::Acquire::Funds::FundAllocations->find( $fund_allocation->fund_allocation_id );

    is( $fund->currency, $updated_fund_allocation->currency, 'Fund allocation has updated' );
    is( $fund->owner_id, $updated_fund_allocation->owner_id, 'Fund allocation has updated' );

    $schema->storage->txn_rollback;
};

subtest 'cascade_to_sub_funds' => sub {

    plan tests => 3;

    $schema->storage->txn_begin;

    my $fiscal_period = $builder->build_object(
        { class => 'Koha::Acquire::Funds::FiscalPeriods', value => { status => 1, visible_to => '1|2' } } );
    my $ledger = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::Ledgers',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                visible_to       => $fiscal_period->visible_to,
                status           => $fiscal_period->status,
                currency         => 'GBP',
                owner_id         => '1'
            }
        }
    );
    my $fund = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::Funds',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                ledger_id        => $ledger->ledger_id,
                visible_to       => $fiscal_period->visible_to,
                status           => $fiscal_period->status,
                currency         => $ledger->currency,
                owner_id         => $ledger->owner_id
            }
        }
    );
    my $sub_fund = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::SubFunds',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                ledger_id        => $ledger->ledger_id,

                fund_id    => $fund->fund_id,
                visible_to => '1|2',
                status     => 1,
                currency   => 'GBP',
                owner_id   => '1'
            }
        }
    );

    $fiscal_period->visible_to('1');
    $fiscal_period->store();

    my $updated_sub_fund = Koha::Acquire::Funds::SubFunds->find( $sub_fund->sub_fund_id );

    is( $fiscal_period->visible_to, $updated_sub_fund->visible_to, 'Sub fund has updated' );

    $fund->currency('USD');
    $fund->owner_id('2');
    $fund->store();

    $updated_sub_fund = Koha::Acquire::Funds::Funds->find( $fund->fund_id );

    is( $fund->currency, $updated_sub_fund->currency, 'Sub fund has updated' );
    is( $fund->owner_id, $updated_sub_fund->owner_id, 'Sub fund has updated' );

    $schema->storage->txn_rollback;
};

subtest 'update_fund_total' => sub {

    plan tests => 2;

    $schema->storage->txn_begin;

    my $fiscal_period = $builder->build_object(
        { class => 'Koha::Acquire::Funds::FiscalPeriods', value => { status => 1, visible_to => '1|2' } } );
    my $ledger = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::Ledgers',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                visible_to       => $fiscal_period->visible_to,
                status           => $fiscal_period->status,
                currency         => 'GBP',
                owner_id         => '1',
                ledger_value     => 0
            }
        }
    );
    my $fund = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::Funds',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                ledger_id        => $ledger->ledger_id,
                visible_to       => $fiscal_period->visible_to,
                status           => $fiscal_period->status,
                currency         => $ledger->currency,
                owner_id         => $ledger->owner_id,
                fund_value       => 0
            }
        }
    );

    my $allocation = Koha::Acquire::Funds::FundAllocation->new(
        {
            fund_id           => $fund->fund_id,
            sub_fund_id       => undef,
            ledger_id         => $ledger->ledger_id,
            fiscal_period_id  => $fiscal_period->fiscal_period_id,
            allocation_amount => 100
        }
    )->store();

    my $updated_fund = Koha::Acquire::Funds::Funds->find( $fund->fund_id );

    is( $updated_fund->fund_value + 0, 100, 'Fund value is 100 based on the value of fund allocations' );

    my $fund2 = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::Funds',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                ledger_id        => $ledger->ledger_id,
                visible_to       => $fiscal_period->visible_to,
                status           => $fiscal_period->status,
                currency         => $ledger->currency,
                owner_id         => $ledger->owner_id,
                fund_value       => 0
            }
        }
    );

    my $sub_fund = $builder->build_object(
        {
            class => 'Koha::Acquire::Funds::SubFunds',
            value => {
                fiscal_period_id => $fiscal_period->fiscal_period_id,
                ledger_id        => $ledger->ledger_id,

                fund_id    => $fund2->fund_id,
                visible_to => '1|2',
                status     => 1,
                currency   => 'GBP',
                owner_id   => '1'
            }
        }
    );

    my $allocation2 = Koha::Acquire::Funds::FundAllocation->new(
        {
            fund_id           => undef,
            sub_fund_id       => $sub_fund->sub_fund_id,
            ledger_id         => $ledger->ledger_id,
            fiscal_period_id  => $fiscal_period->fiscal_period_id,
            allocation_amount => 200
        }
    )->store();

    my $updated_fund2 = Koha::Acquire::Funds::Funds->find( $fund2->fund_id );

    is( $updated_fund2->fund_value + 0, 200, 'Fund value is 200 based on the value of all sub funds' );

    $schema->storage->txn_rollback;
};
