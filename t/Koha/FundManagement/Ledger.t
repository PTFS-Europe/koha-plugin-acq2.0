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

use Test::More tests => 2;

use t::lib::TestBuilder;
use t::lib::Mocks;

use Koha::Database;
use Koha::Acquire::Funds::Ledgers;

my $schema  = Koha::Database->new->schema;
my $builder = t::lib::TestBuilder->new;

subtest 'cascade_to_funds' => sub {

    plan tests => 5;

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

    $fiscal_period->status(0);
    $fiscal_period->store();

    my $updated_ledger = Koha::Acquire::Funds::Ledgers->find( $ledger->ledger_id );
    my $updated_fund   = Koha::Acquire::Funds::Funds->find( $fund->fund_id );

    is( $fiscal_period->status, $updated_ledger->status, 'Ledger has updated' );
    is( $fiscal_period->status, $updated_fund->status,   'Fund has updated' );

    $ledger->visible_to('1');
    $ledger->currency('USD');
    $ledger->owner_id('2');
    $ledger->store();

    $updated_fund = Koha::Acquire::Funds::Funds->find( $fund->fund_id );

    is( $ledger->visible_to, $updated_fund->visible_to, 'Fund has updated' );
    is( $ledger->currency,   $updated_fund->currency,   'Fund has updated' );
    is( $ledger->owner_id,   $updated_fund->owner_id,   'Fund has updated' );

    $schema->storage->txn_rollback;
};

subtest 'update_ledger_total' => sub {

    plan tests => 1;

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

    my $updated_ledger = Koha::Acquire::Funds::Ledgers->find( $ledger->ledger_id );

    is( $updated_ledger->ledger_value + 0, 100, 'Ledger value is 100' );

    $schema->storage->txn_rollback;
};
