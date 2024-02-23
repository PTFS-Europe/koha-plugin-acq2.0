package Koha::Plugin::Acquire::Controllers::TaskManagement::Tasks;

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

use Koha::Acquire::TaskManagement::Task;
use Koha::Acquire::TaskManagement::Tasks;
use Koha::DateUtils qw( dt_from_string );

use Koha::Plugin::Acquire::Controllers::ControllerUtils;

use C4::Context;

=head1 API

=head2 Methods

=head3 list

=cut

sub list {
    my $c = shift->openapi->valid_input or return;
    my $user = $c->stash("koha.user");

    return try {
        my $tasks_set = Koha::Acquire::TaskManagement::Tasks->new;
        my $tasks     = $c->objects->search($tasks_set);

        return $c->render( status => 200, openapi => $tasks );
    } catch {
        $c->unhandled_exception($_);
    };

}

=head3 get

=cut

sub get {
    my $c = shift->openapi->valid_input or return;

    return try {
        my $task = Koha::Acquire::TaskManagement::Tasks->find( $c->param('id') );

        unless ($task) {
            return $c->render(
                status  => 404,
                openapi => { error => "Task not found" }
            );
        }

        $task = Koha::Plugin::Acquire::Controllers::ControllerUtils->add_patron_data(
            { data => $task, field => 'owned_by', key => 'owner' } );
        $task = Koha::Plugin::Acquire::Controllers::ControllerUtils->add_patron_data(
            { data => $task, field => 'creator', key => 'created_by' } );
        $task =
            Koha::Plugin::Acquire::Controllers::ControllerUtils->add_lib_group_data( { data => $task } );

        return $c->render(
            status  => 200,
            openapi => $task
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

                my $date = dt_from_string();
                $body->{created_on} = $date;
                $body->{created_by} = $c->stash('koha.user')->borrowernumber;

                $body->{closed_on} = $date if $body->{status} eq 'completed';

                delete $body->{creator} if $body->{creator};
                delete $body->{owned_by} if $body->{owned_by};
                delete $body->{lib_groups} if $body->{lib_groups};

                my $task = Koha::Acquire::TaskManagement::Task->new_from_api($body)->store;

                $c->res->headers->location( $c->req->url->to_string . '/' . $task->task_id );
                return $c->render(
                    status  => 201,
                    openapi => $task->to_api
                );
            }
        );
    } catch {
        return $c->unhandled_exception($_);
    };
}

=head3 update

Controller function that handles updating a Koha::Acquire::TaskManagement::Task object

=cut

sub update {
    my $c = shift->openapi->valid_input or return;

    my $task = Koha::Acquire::TaskManagement::Tasks->find( $c->param('id') );

    unless ($task) {
        return $c->render(
            status  => 404,
            openapi => { error => "Task not found" }
        );
    }

    return try {
        Koha::Database->new->schema->txn_do(
            sub {

                my $body = $c->req->json;

                my $date = dt_from_string();
                $body->{closed_on} = $date if $body->{status} eq 'complete' && $task->{status} ne 'complete';

                delete $body->{creator}  if $body->{creator};
                delete $body->{owned_by} if $body->{owned_by};
                delete $body->{lib_groups} if $body->{lib_groups};

                $task->set_from_api($body)->store;

                $c->res->headers->location( $c->req->url->to_string . '/' . $task->task_id );
                return $c->render(
                    status  => 200,
                    openapi => $task->to_api
                );
            }
        );
    } catch {
        $c->unhandled_exception($_);
    };
}

=head3 delete

=cut

sub delete {
    my $c = shift->openapi->valid_input or return;

    my $task = Koha::Acquire::TaskManagement::Tasks->find( $c->param('id') );
    unless ($task) {
        return $c->render(
            status  => 404,
            openapi => { error => "Task not found" }
        );
    }

    return try {
        $task->delete;
        return $c->render(
            status  => 204,
            openapi => q{}
        );
    } catch {
        $c->unhandled_exception($_);
    };
}

1;
