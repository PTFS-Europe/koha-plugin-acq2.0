package Koha::Plugin::Acquire::installer::AcquisitionsInstaller;

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

use JSON       qw ( encode_json decode_json);
use Try::Tiny;
use File::Spec;
use Try::Tiny;


=head3 new

=cut

sub new {
    my ( $class, $args ) = @_;

    my $self = $class->SUPER::new;
    $self->{table_name_mappings} = $args->{table_name_mappings};
    $self->{bundle_path}         = $args->{bundle_path};
    $self->{dbh}                 = C4::Context->dbh;

    return bless $self, $class;
}

sub install {
    my ( $self, $args ) = @_;

    my $settings_installed = $self->_handle_sql();

    my $is_success = $self->_handle_sysprefs() if $settings_installed;

    return $is_success;
}

sub _handle_sysprefs {
    my ( $self, $args ) = @_;

    my $sysprefs_dir = File::Spec->catdir( $self->{bundle_path}, 'installer/sysprefs' );
    my @sysprefs_files = glob "$sysprefs_dir/sysprefs.json";
    my $file = $sysprefs_files[0];

    return try {
        open my $fh, '<', $file or die "Can't open $file";
        my $sysprefs_json = do { local $/; <$fh> };
        close $fh or die "Can't close $file";

        my $table = $self->{table_name_mappings}->{settings};
        my $sysprefs = decode_json($sysprefs_json);

        my @modules = keys %$sysprefs;
        foreach my $module ( @modules ) {
            my @prefs = keys %{$sysprefs->{$module}};
            foreach my $pref ( @prefs ) {
                my %pref_data = %{$sysprefs->{$module}->{$pref}};
                my $query = "INSERT IGNORE INTO $table (variable,value,options,explanation,type) VALUES(?,?,?,?,?)";    
                my $sth = $self->{dbh}->prepare($query);
                my ( $value, $options, $explanation, $type ) = @pref_data{"value", "options", "explanation", "type"};
                $sth->execute( $pref, $value, $options, $explanation, $type );
                if ( $sth->err ) {
                    warn "$pref not installed - " . $sth->errstr;
                }
            }
        }
        return 1;
    }
    catch {
        my $error = $_;
        warn "INSTALL ERROR for $file: $error";

        return 0;
    }
}

sub _handle_sql {
    my ( $self, $args ) = @_;

    my $settings_installed;
    my @sql_files = $self->_get_sql_data();

    foreach my $file (@sql_files) {
        $self->{dbh}->begin_work;

        my $is_success = $self->_install_file( { file => $file } );
        if ( !$is_success ) {
            $self->{dbh}->rollback;
            warn "Failed to install from $file. Aborting installation.";
            return 0;
        }

        $self->{dbh}->commit;
        if( $file =~ /settings.sql/ ) {
            $settings_installed = 1;
        }

        warn "Successfully installed data from $file.";
    }
    return $settings_installed;
}

sub _get_sql_data {
    my ( $self, $args ) = @_;

    my $sql_path = File::Spec->catdir( $self->{bundle_path}, 'installer/sql' );

    # List all SQL files in migrations directory
    my @sql_files = glob "$sql_path/*.sql";

    return @sql_files;
}

sub _install_file {
    my ( $self, $args ) = @_;

    my $file = $args->{file};

    return try {
        open my $fh, '<', $file or die "Can't open $file";
        my $sql = do { local $/; <$fh> };
        close $fh or die "Can't close $file";

        for my $table ( keys %{ $self->{table_name_mappings} } ) {
            # Table names are in SQL files enclosed in {} so that we can add the qualified table names
            my $ws         = '\s*';                     # Whitespace character class
            my $ob         = '\{';                      # Opening brace character class
            my $cb         = '\}';                      # Closing brace character class
            my $table_name = '\s*' . $table . '\s*';    # Table name wrapped with optional whitespace

            my $pattern = $ob . $ws . $ob . $table_name . $cb . $ws . $cb;

            my $table_identifier = $self->{table_name_mappings}->{$table};
            $sql =~ s/$pattern/$table_identifier/smxg;
        }

        my $statements = [ split /;\s*\n/smx, $sql ];
        for my $statement ( @{$statements} ) {
            my $sth = $self->{dbh}->prepare($statement);
            warn "Failed to prepare statement: $statement. DBI error: " . $self->{dbh}->errstr if !defined $sth;

            my $rows_affected = $sth->execute;
            warn "Failed to execute statement: $statement. DBI error: " . $sth->errstr if not defined $rows_affected;
        }
        return 1;
    } catch {
        my $error = $_;
        warn "INSTALL ERROR for $file: $error";

        return 0;
    };

}

1;
