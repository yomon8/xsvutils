package subcmd_mcut;

use strict;
use warnings;
#use Data::Dumper;

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub exec_help {
    exec("$Main::TOOL_DIR/mcut", "--help");
}

sub init_command {
    return {num_field => undef, name_field => undef};
}

sub parse_option {
    my ($self, $a, $argv, $curr_command, $input) = @_;

    if ($a eq "-f") {
        die "option $a needs an argument" unless (@$argv);
        die "duplicated option $a" if defined $curr_command->{num_field};
        $curr_command->{num_field} = shift(@$argv);
        return 1;
    }
    if ($a eq "-F") {
        die "option $a needs an argument" unless (@$argv);
        die "duplicated option $a" if defined $curr_command->{name_field};
        $curr_command->{name_field} = shift(@$argv);
        return 1;
    }
}

sub validate_params {
    my ($self, $curr_command) = @_;
    my $command_name = $curr_command->{command};

    if (!defined($curr_command->{num_field}) && !defined($curr_command->{name_field})) {
        die "subcommand \`$command_name\` needs -f or -F option";
    }
}

sub build_ircode_command {
    my ($self, $curr_command) = @_;

    my $option = "";
    if (defined $curr_command->{num_field}) {
        my $f = Main::escape_for_bash($curr_command->{num_field});
        $option .= " -f $f";
    } elsif (defined $curr_command->{name_field}) {
        my $f = Main::escape_for_bash($curr_command->{name_field});
        $option .= " -F $f";
    }
    return ["cmd", "\$TOOL_DIR/mcut $option"];
}

1;
