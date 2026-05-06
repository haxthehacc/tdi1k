require 5.004;

package config;

sub parseScalar {
    my $file = shift;
    my $var = shift;

    open(CONFIG, "$file") || die "$0: Can't open file $file\n";

    while (<CONFIG>) {
	if (/^\s*$var:/) {
	    chop;
	    my @fields = split(/: *| /);
	    my $scalar = $fields[1];
	    return $scalar;
	}
    }

    print "Warning: Can't find variable $var in config file $file\n";
    return undef;
}

sub parseList {
    my $file = shift;
    my $var = shift;

    open(CONFIG, "$file") || die "$0: Can't open file $file\n";

    while (<CONFIG>) {
	if (/^\s*$var:\s+(.*)/) {
	    my $items = $1;
	    while ($items =~ /\\\s*$/) {
		my $line = <CONFIG>;
		chop;
		$items .= $line;
	    }
	    $items =~ s/\\//g;
	    my @list = split(' ', $items);
	    return @list;
	}
    }

    die "Warning: Can't find variable $var in config file $file\n";
    return undef;
}

sub parseAssocList {
    my $file = shift;
    my $var = shift;

    my @list = config::parseList($file, $var);

    my %assocList;
    my $i;
    for ($i = 0; $i <= $#list; $i += 2) {
	$assocList{$list[$i]} = $list[$i+1];
    }

    return %assocList;
}

sub parseFlagList {
    my $file = shift;
    my $var = shift;

    my @list = config::parseList($file, $var);

    my %flagList;
    my $item;
    foreach $item (@list) {
	$flagList{$item} = 1;
    }

    return %flagList;
}

1;
