package Koha::Plugin::Acquire::Controllers::FundManagement::FundGroups;

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

use Koha::Acquire::Funds::Funds;
use Koha::Acquire::Funds::FundGroup;
use Koha::Acquire::Funds::FundGroups;

use Koha::Plugin::Acquire::Controllers::ControllerUtils;

use C4::Context;

=head1 API

=head2 Methods

=head3 list

=cut

sub list {
    my $c = shift->openapi->valid_input or return;

    return try {
        my $fund_groups_set = Koha::Acquire::Funds::FundGroups->new;
        my $fund_groups     = $c->objects->search($fund_groups_set);

        my $filtered_fund_groups =
            Koha::Plugin::Acquire::Controllers::ControllerUtils->filter_data_by_group(
            { dataset => $fund_groups } );

        return $c->render( status => 200, openapi => $filtered_fund_groups );
    } catch {
        $c->unhandled_exception($_);
    };

}

=head3 get

=cut

sub get {
    my $c = shift->openapi->valid_input or return;

    return try {
        my $fund_groups_set = Koha::Acquire::Funds::FundGroups->new;
        my $fund_group      = $c->objects->find( $fund_groups_set, $c->param('id') );

        unless ($fund_group) {
            return $c->render(
                status  => 404,
                openapi => { error => "Fund group not found" }
            );
        }

        $fund_group = Koha::Plugin::Acquire::Controllers::ControllerUtils->add_lib_group_data( { data => $fund_group } );
        $fund_group =
            Koha::Plugin::Acquire::Controllers::ControllerUtils->add_accounting_values_to_ledgers_or_fund_groups_or_funds(
            { data => $fund_group } );

        return $c->render(
            status  => 200,
            openapi => $fund_group
        );
    } catch {
        $c->unhandled_exception($_);
    };
}

=head3 add

=cut

sub add {
    my $c = shift->openapi->valid_input or return;

    return try {
        Koha::Database->new->schema->txn_do(
            sub {

                my $body = $c->req->json;
                delete $body->{lib_groups} if $body->{lib_groups};

                my $fund_group = Koha::Acquire::Funds::FundGroup->new_from_api($body)->store;

                $c->res->headers->location( $c->req->url->to_string . '/' . $fund_group->fund_group_id );
                return $c->render(
                    status  => 201,
                    openapi => $fund_group->to_api
                );
            }
        );
    } catch {
        return $c->unhandled_exception($_);
    };
}

=head3 update

Controller function that handles updating a Koha::Acquire::Funds::FundGroup object

=cut

sub update {
    my $c = shift->openapi->valid_input or return;

    my $fund_group = Koha::Acquire::Funds::FundGroups->find( $c->param('id') );

    unless ($fund_group) {
        return $c->render(
            status  => 404,
            openapi => { error => "Fund group not found" }
        );
    }

    return try {
        Koha::Database->new->schema->txn_do(
            sub {

                my $body = $c->req->json;
                delete $body->{lib_groups} if $body->{lib_groups};

                $fund_group->set_from_api($body)->store;

                $c->res->headers->location( $c->req->url->to_string . '/' . $fund_group->fund_group_id );
                return $c->render(
                    status  => 200,
                    openapi => $fund_group->to_api
                );
            }
        );
    } catch {
        my $to_api_mapping = Koha::Acquire::Funds::FundGroup->new->to_api_mapping;

        if ( blessed $_ ) {
            if ( $_->isa('Koha::Exceptions::Object::FKConstraint') ) {
                return $c->render(
                    status  => 400,
                    openapi => { error => "Given " . $to_api_mapping->{ $_->broken_fk } . " does not exist" }
                );
            } elsif ( $_->isa('Koha::Exceptions::BadParameter') ) {
                return $c->render(
                    status  => 400,
                    openapi => { error => "Given " . $to_api_mapping->{ $_->parameter } . " does not exist" }
                );
            } elsif ( $_->isa('Koha::Exceptions::PayloadTooLarge') ) {
                return $c->render(
                    status  => 413,
                    openapi => { error => $_->error }
                );
            }
        }

        $c->unhandled_exception($_);
    };
}

=head3 delete

=cut

sub delete {
    my $c = shift->openapi->valid_input or return;

    my $fund_group = Koha::Acquire::Funds::FundGroups->find( $c->param('id') );
    unless ($fund_group) {
        return $c->render(
            status  => 404,
            openapi => { error => "Fund group not found" }
        );
    }

    return try {
        $fund_group->delete;

        return $c->render(
            status  => 204,
            openapi => q{}
        );
    } catch {
        $c->unhandled_exception($_);
    };
}

1;
