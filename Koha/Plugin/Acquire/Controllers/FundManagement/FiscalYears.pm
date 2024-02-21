package Koha::Plugin::Acquire::Controllers::FundManagement::FiscalYears;

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

use Koha::Acquire::Funds::FiscalYear;
use Koha::Acquire::Funds::FiscalYears;

use C4::Context;

=head1 API

=head2 Methods

=head3 list

=cut

sub list {
    my $c = shift->openapi->valid_input or return;

    my $logged_in_branch = C4::Context::mybranch();

    return try {
        my $fiscal_years_set = Koha::Acquire::Funds::FiscalYears->new;
        my $fiscal_years     = $c->objects->search($fiscal_years_set);

        my $branch         = Koha::Libraries->find( { branchcode => $logged_in_branch } );
        my $library_groups = $branch->library_groups;
        my @group_ids;
        if ( scalar( @{ $library_groups->as_list } ) == 0 ) {
            push( @group_ids, 1 );
        } else {
            @group_ids = map( $_->parent_id, @{ $library_groups->as_list } );
            foreach my $group_id (@group_ids) {
                my $group = Koha::Library::Groups->find({ id => $group_id });
                push( @group_ids, $group->parent_id ) if $group && $group->parent_id && !grep( $_ eq $group->parent_id, @group_ids );
            }
        }


        my @filtered_fiscal_years;
        foreach my $fiscal_year (@$fiscal_years) {
            my @visible_groups = split( /\|/, $fiscal_year->{visible_to} );
            my $already_added  = 0;
            foreach my $visible_group (@visible_groups) {
                if ( grep( "$_" eq $visible_group, @group_ids ) && !$already_added ) {
                    push( @filtered_fiscal_years, $fiscal_year );
                    $already_added = 1;
                }
            }
        }
        return $c->render( status => 200, openapi => \@filtered_fiscal_years );
    } catch {
        $c->unhandled_exception($_);
    };

}

=head3 get

=cut

sub get {
    my $c = shift->openapi->valid_input or return;

    return try {
        my $fiscal_year = Koha::Acquire::Funds::FiscalYears->find( $c->param('id') );

        unless ($fiscal_year) {
            return $c->render(
                status  => 404,
                openapi => { error => "Fiscal year not found" }
            );
        }

        return $c->render(
            status  => 200,
            openapi => $fiscal_year
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

                my $fiscal_year = Koha::Acquire::Funds::FiscalYear->new_from_api($body)->store;

                $c->res->headers->location( $c->req->url->to_string . '/' . $fiscal_year->fiscal_yr_id );
                return $c->render(
                    status  => 201,
                    openapi => $fiscal_year->to_api
                );
            }
        );
    } catch {
        return $c->unhandled_exception($_);
    };
}

=head3 update

Controller function that handles updating a Koha::Acquire::Funds::FiscalYear object

=cut

sub update {
    my $c = shift->openapi->valid_input or return;

    my $fiscal_year = Koha::Acquire::Funds::FiscalYears->find( $c->param('id') );

    unless ($fiscal_year) {
        return $c->render(
            status  => 404,
            openapi => { error => "Fiscal year not found" }
        );
    }

    return try {
        Koha::Database->new->schema->txn_do(
            sub {

                my $body = $c->req->json;

                $fiscal_year->set_from_api($body)->store;

                $c->res->headers->location( $c->req->url->to_string . '/' . $fiscal_year->fiscal_yr_id );
                return $c->render(
                    status  => 200,
                    openapi => $fiscal_year->to_api
                );
            }
        );
    } catch {
        my $to_api_mapping = Koha::Acquire::Funds::FiscalYear->new->to_api_mapping;

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

    my $fiscal_year = Koha::Acquire::Funds::FiscalYears->find( $c->param('id') );
    unless ($fiscal_year) {
        return $c->render(
            status  => 404,
            openapi => { error => "Fiscal year not found" }
        );
    }

    return try {
        $fiscal_year->delete;
        return $c->render(
            status  => 204,
            openapi => q{}
        );
    } catch {
        $c->unhandled_exception($_);
    };
}

1;