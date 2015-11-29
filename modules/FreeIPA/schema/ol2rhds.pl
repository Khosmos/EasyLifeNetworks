#!/usr/bin/perl -w
#
# This script should convert OpenLDAP schemas to RHDS/FDS
# schema and it will (hopefully) order things according to
# RFC 2252.  Apparently RHDS/FDS is really strict about the
# order folling the RFC, where OpenLDAP isn't.
#
# It should also be useful for formatting schemas that aren't
# formatted or reordering ones that have already been converted
# but may (or may not) have anything out of order.
#
# Thanks to Steven Bonneville of RedHat for pointing out the
# how strict RHDS/FDS is when loading schemas.
#
# I hope it's of some use to everyone.
#
# Nathan Benson <tuxtattoo@gmail.com> 2005-10-25
#
# Licensed under the GPL 
#

use strict;

my $sep	      = '-';	## seperate character (x 69) for between entries
my $indent    = ' ';	## indention variable (1 x \s for FDS)
my $wrapoid   = 1;	## wrap and indent the at/oc oid under the first paren?
my $printone  = 1;	## print a commented out version of the entry on a single
			## line above the formatted version?

my (@at, @oc, @mr, @mru);
my ($at_line, $oc_line, $mr_line, $mru_line, $running);

$running      = '';

##
## RFC2252 objectClasses order
my @oc_order  =
(
	{ 'NAME'	=> { fields => 1 } },
	{ 'DESC' 	=> { fields => 1 } },
	{ 'OBSOLETE' 	=> { fields => 0 } },
	{ 'SUP' 	=> { fields => 1 } },
	{ 'ABSTRACT' 	=> { fields => 0 } },
	{ 'STRUCTURAL' 	=> { fields => 0 } },
	{ 'AUXILIARY' 	=> { fields => 0 } },
	{ 'MUST' 	=> { fields => 1 } },
	{ 'MAY' 	=> { fields => 1 } }
);



##
## RFC2252 attributeTypes order
my @at_order =
(
	{ 'NAME' 		=> { fields => 1 } },
	{ 'DESC' 		=> { fields => 1 } },
	{ 'OBSOLETE' 		=> { fields => 0 } },
	{ 'SUP' 		=> { fields => 1 } },
	{ 'EQUALITY'		=> { fields => 1 } },
	{ 'ORDERING'		=> { fields => 1 } },
	{ 'SUBSTR'		=> { fields => 1 } },
	{ 'SYNTAX'		=> { fields => 1 } },
	{ 'SINGLE-VALUE'	=> { fields => 0 } },
	{ 'COLLECTIVE'		=> { fields => 0 } },
	{ 'NO-USER-MODIFICATION'=> { fields => 0 } },
	{ 'USAGE'		=> { fields => 1 } }
);

##
## RFC2252 matchingRule order
my @mr_order =
(
	{ 'NAME' 	=> { fields => 1 } },
	{ 'DESC' 	=> { fields => 1 } },
	{ 'OBSOLETE'	=> { fields => 0 } },
	{ 'SYNTAX'	=> { fields => 1 } }
);

##
## RFC2252 matchingRuleUse order
my @mru_order =
(
	{ 'NAME' 	=> { fields => 1 } },
	{ 'DESC' 	=> { fields => 1 } },
	{ 'OBSOLETE'	=> { fields => 0 } },
	{ 'APPLIES'  	=> { fields => 1 } }
);


# ===================================================================

##
## orders the schema lines based on the @??_order array
sub order_entry($$)
{
	my ($attr, $pos, $len, $line, @order);

	my $entry = shift; # this is the schema entry on one line
	my $type  = shift; # defines what type of entry we are ordering

	@order    = @oc_order  if lc $type eq 'oc';
	@order    = @at_order  if lc $type eq 'at';
	@order    = @mr_order  if lc $type eq 'mr';
	@order    = @mru_order if lc $type eq 'mru';

	$entry 	  = move_index($entry, '(');

	$entry 	  = parse_entry($entry, 'oc')  if lc $type eq 'oc';
	$entry 	  = parse_entry($entry, 'at')  if lc $type eq 'at';
	$entry 	  = parse_entry($entry, 'mr')  if lc $type eq 'mr';
	$entry 	  = parse_entry($entry, 'mru') if lc $type eq 'mru';

	$line 	  = 'objectClasses: ( ' . $entry->{'OID'}	if lc $type eq 'oc';
	$line 	  = 'attributeTypes: ( ' . $entry->{'OID'}	if lc $type eq 'at';
	$line 	  = 'matchingRule: ( ' . $entry->{'OID'}	if lc $type eq 'mr';
	$line 	  = 'matchingRuleUse: ( ' . $entry->{'OID'}	if lc $type eq 'mru';

	for (my $i = 0; $i <= $#order; $i++)
	{
		foreach my $key (keys %{$order[$i]})
		{
			$line .= ($entry->{$key} eq '') ? " $key " : " $key $entry->{$key} " if exists $entry->{$key};
		}
	}

	$line .=  ')';
	$line  =~ s/\s+/ /g;

	return $line;
}


##
## you guessed it, a line seperator!
sub seperate
{
	print "#\n";
	print "#" . $sep x 69 . "\n#\n";
}


##
## resizes the given line to the position given as the second
## argument
sub move_index
{
	my $line = shift;
	my $str  = shift;
	my $pos  = shift || 0;
	my $idx  = index $line, $str, $pos;
	$line    = substr $line, $idx, length $line;
	$line	 =~ s/^\s+//g;
	
	return $line;
}

#
#     RFC 2252 stuff
#
#     qdstring        = whsp "'" dstring "'" whsp
#     qdstringlist    = [ qdstring *( qdstring ) ]
#     qdstrings       = qdstring / ( whsp "(" qdstringlist ")" whsp )
#
#     oid             = descr / numericoid
#     descr           = keystring
#     numericoid      = numericstring *( "." numericstring )
#     woid            = whsp oid whsp
#     ; set of oids of either form
#     oids            = woid / ( "(" oidlist ")" )
#     oidlist         = woid *( "$" woid )
#     ; object descriptors used as schema element names
#     qdescrs         = qdescr / ( whsp "(" qdescrlist ")" whsp )
#     qdescrlist      = [ qdescr *( qdescr ) ]
#     qdescr          = whsp "'" descr "'" whsp

#      AttributeTypeDescription = "(" whsp
#            numericoid whsp              ; AttributeType identifier
#          [ "NAME" qdescrs ]             ; name used in AttributeType
#          [ "DESC" qdstring ]            ; description
#          [ "OBSOLETE" whsp ]
#          [ "SUP" woid ]                 ; derived from this other
#                                         ; AttributeType
#          [ "EQUALITY" woid              ; Matching Rule name
#          [ "ORDERING" woid              ; Matching Rule name
#          [ "SUBSTR" woid ]              ; Matching Rule name
#          [ "SYNTAX" whsp noidlen whsp ] ; see section 4.3
#          [ "SINGLE-VALUE" whsp ]        ; default multi-valued
#          [ "COLLECTIVE" whsp ]          ; default not collective
#          [ "NO-USER-MODIFICATION" whsp ]; default user modifiable
#          [ "USAGE" whsp AttributeUsage ]; default userApplications
#          whsp ")"

#      ObjectClassDescription = "(" whsp
#          numericoid whsp      ; ObjectClass identifier
#          [ "NAME" qdescrs ]
#          [ "DESC" qdstring ]
#          [ "OBSOLETE" whsp ]
#          [ "SUP" oids ]       ; Superior ObjectClasses
#          [ ( "ABSTRACT" / "STRUCTURAL" / "AUXILIARY" ) whsp ]
#                               ; default structural
#          [ "MUST" oids ]      ; AttributeTypes
#          [ "MAY" oids ]       ; AttributeTypes
#      whsp ")"

#      MatchingRuleDescription = "(" whsp
#          numericoid whsp  ; MatchingRule identifier
#          [ "NAME" qdescrs ]
#          [ "DESC" qdstring ]
#          [ "OBSOLETE" whsp ]
#          "SYNTAX" numericoid
#      whsp ")"
#
#
#      MatchingRuleUseDescription = "(" whsp
#          numericoid whsp  ; MatchingRule identifier
#          [ "NAME" qdescrs ]
#          [ "DESC" qdstring ]
#          [ "OBSOLETE" ]
#         "APPLIES" oids    ; AttributeType identifiers
#      whsp ")"

##
## this does all the real work of finding the entries
## in each line we are working with
sub parse_entry
{
	my ($attr, $pos, $end, $tmp, @order, @sep);
	my $entry = shift;
	my $type  = shift;

	@order    = @oc_order  if lc $type eq 'oc';
	@order    = @at_order  if lc $type eq 'at';
	@order    = @mr_order  if lc $type eq 'mr';
	@order    = @mru_order if lc $type eq 'mru';
	$entry 	  = move_index($entry, ' ');

	## set the oid
	if (!defined $attr->{'OID'})
	{
		$pos 	       = index $entry, ' ';
		$attr->{'OID'} = substr $entry, 0, $pos;
		$entry 	       = move_index($entry, ' ');
	}

	## find each section in this entry
	for (my $i = 0; $i <= $#order; $i++)
	{
		foreach my $key (keys %{$order[$i]})
		{
			my $tmp_entry = $entry;
			$pos 	      = index $entry, $key;


			## this key was found, so start processing
			## the entry.
			if ($pos > -1)
			{
				## move the index to the space after our key
				$tmp_entry = move_index($entry, ' ', $pos);


				## this field has a value following
				if ($order[$i]->{$key}->{'fields'})
				{
					## pull the first char and see what it is
					$tmp = substr $tmp_entry, 0, 1;


					## if it's a single ' we need to find the next
					## ' and pull in all of that for our value
					if ($tmp eq '\'')
					{
						$end  	      = (index($tmp_entry, '\'', 1) + 1);
						$attr->{$key} = substr $tmp_entry, 0, $end;

						next;
					}

					## if it's a ( then pull in all information between
					## it and the closing )
					elsif ($tmp eq '(')
					{
						$end  	      = (index($tmp_entry, ')', 1) + 1);
						$attr->{$key} = substr $tmp_entry, 0, $end;

						next;
					}

					## if it's not ' or ( then it's a single value, just
					## pull in everything up to the next space
					else
					{
						$end  	      = (index($tmp_entry, ' ', 1) + 1);
						$attr->{$key} = substr $tmp_entry, 0, $end;

						next;
					}
				}

				## the key was found, but it has no value
				else
				{
					$attr->{$key} = '';
				}
			}
		}
	}
	return $attr;
}


# ===================================================================


MAIN:
{
	while (<STDIN>)
	{
	
		# skip blank lines, and comments
		next if (/^($|\s*#)/ && (!$running));

		## if we've reached the next comment
		## blank line, or next entry, push
		## the last one to the appropriate
		## array
		if ((/^($|\s*#|attributetype|objectclass|matchingrule|matchingruleuse)/i) && ($running))
		{
			if ($running eq 'at')
			{
				push @at, $at_line;
				$at_line  = '' ;
				$running = '';
			}
			elsif ($running eq 'oc')
			{
				push @oc, $oc_line;
				$oc_line  = '' ;
				$running = '';
			}
			elsif ($running eq 'mr')
			{
				push @mr, $mr_line;
				$mr_line  = '' ;
				$running = '';
			}
			elsif ($running eq 'mru')
			{
				push @mru, $mru_line;
				$mru_line  = '' ;
				$running = '';
			}
		}
		elsif ($running)
		{
			$at_line  .= $_ if ($running eq 'at');
			$oc_line  .= $_ if ($running eq 'oc');
			$mr_line  .= $_ if ($running eq 'mr');
			$mru_line .= $_ if ($running eq 'mru');
		}
	
		##
		## ===============================================
		##

		if (/attributetype/i)
		{
			chomp;
			$running  = 'at';

			s/attributetype/attributeTypes:/i;
			$at_line .= $_;

			next;
		}
	
		elsif (/objectclass/i)
		{
			chomp;
			$running = 'oc';

			s/objectclass/objectClasses:/i;
			$oc_line .= $_;

			next;
		}

		## ===============================================
		##
		## the next two are probably not even
		## needed.  i couldn't find any schemas
		## that actually had these, but it was
		## in the RFC, so i coded for it.  i
		## haven't tested it, so i have no idea
		## if it the matchingrule stuff works
		##
		## ===============================================

		elsif (/matchingrule/i)
		{
			chomp;
			$running = 'mr';

			# i'm not sure if anything needs to be changed
			# it's just here because it was in the RFC
			#s/matchingrule/matchingRule:/i;
			$mr_line .= $_;

			next;
		}

		elsif (/matchingruleuse/i)
		{
			chomp;
			$running = 'mr';

			# i'm not sure if anything needs to be changed
			# it's just here because it was in the RFC
			#s/matchingruleuse/matchingRuleUse:/i;
			$mru_line .= $_;

			next;
		}
	}

	&seperate;
	print "dn: cn=schema\n";

	## objectClasses
	foreach (@oc)
	{
		s/\s+/ /g;

		&seperate;
		$_ = order_entry($_, 'oc');

		print "# $_\n#\n" if $printone;

		s/objectClasses: \(/objectClasses: \(\n/ if $wrapoid;

		for (my $i = 0; $i <= $#oc_order; $i++)
		{
			## reorder the line based on the RFC order
			foreach my $key (keys %{$oc_order[$i]})
			{
				s/$key/\n$indent$key/ if /$key/;
			}
		}
		s/\)$/\n$indent)\n/;
	
		print;
	}

	## attributeTypes
	foreach (@at)
	{
		## make sure we only have 1 space between each field.
		s/\s+/ /g;
	
		&seperate;
		$_ = order_entry($_, 'at');

		print "# $_\n#\n" if $printone;

		s/attributeTypes: \(/attributeTypes: \(\n/ if $wrapoid;

		for (my $i = 0; $i < $#at_order; $i++)
		{
			## reorder the line based on the RFC order
			foreach my $key (keys %{$at_order[$i]})
			{
				s/$key/\n$indent$key/ if /$key/;
			}
		}
		s/\)$/\n$indent)\n/;
	
		print;
	}
	
	##
	## These two are probably not needed, but i coded
	## for them anyway.  They are untested, be warned.
	##

	## matchingRule
	foreach (@mr)
	{
		## make sure we only have 1 space between each field.
		s/\s+/ /g;
	
		&seperate;
		$_ = order_entry($_, 'mr');

		print "# $_\n#\n" if $printone;

		s/matchingRule: \(/matchingRule: \(\n/ if $wrapoid;

		for (my $i = 0; $i < $#mr_order; $i++)
		{
			## reorder the line based on the RFC order
			foreach my $key (keys %{$mr_order[$i]})
			{
				s/$key/\n$indent$key/ if /$key/;
			}
		}
		s/\)$/\n$indent)\n/;
	
		print;
	}

	## matchingRuleUse
	foreach (@mru)
	{
		## make sure we only have 1 space between each field.
		s/\s+/ /g;
	
		&seperate;
		$_ = order_entry($_, 'mru');

		print "# $_\n#\n" if $printone;

		s/matchingRuleUse: \(/matchingRuleUse: \(\n/ if $wrapoid;

		for (my $i = 0; $i < $#mru_order; $i++)
		{
			## reorder the line based on the RFC order
			foreach my $key (keys %{$mru_order[$i]})
			{
				s/$key/\n$indent$key/ if /$key/;
			}
		}
		s/\)$/\n$indent)\n/;
	
		print;
	}
}

# EOF

