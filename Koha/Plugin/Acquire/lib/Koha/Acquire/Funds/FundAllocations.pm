package Koha::Acquire::Funds::FundAllocations;

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
use base qw(Koha::Objects);

use Mojo::JSON qw(decode_json);
use JSON       qw ( encode_json );

use Koha::Acquire::Funds::FundAllocation;

sub add_totals_to_fund_allocations {
    my ( $self, $args ) = @_;

    my $allocations        = $args->{allocations};
    # my @sorted_allocations = sort { $a->{allocation_amount} <=> $b->{allocation_amount} } @$allocations;

    my $total = 0;
    foreach my $allocation_index ( 1 .. scalar(@$allocations) ) {
        my $allocation = @$allocations[ $allocation_index - 1 ];
        $allocation->{allocation_index} = $allocation_index;
        $total += $allocation->{allocation_amount};
        $allocation->{new_fund_value} = $total;
    }

    return $allocations;
}

=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginAcquireFundAllocation';
}

=head3 object_class

=cut

sub object_class {
    return 'Koha::Acquire::Funds::FundAllocation';
}

1;
