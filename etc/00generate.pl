use strict;
use ZRJCode ':all';

my $out_dir = '..';

our (%cid_map);
require './cid_map.pl';

sub form_umbralist {
  my ($list) = @_;
  my @list = map { int($_ || 0) } (@$list);
  while ($list[-1] == 0) { pop(@list); }
  my $size = scalar(@list);
  return pack('n12N*',
    37 + $size, 18, 0, 0, 2, 1, 1, 1, 0, 0, 0, 7 + $size,
    0, 0x1000000, (0) x 15, 0x80000000, # designsize=16pt
    0x1000000, (0) x 5,
    0, 0, 0, 0, 0, 0x100000, 0, @list);
}

sub dump_umbralist {
  my ($lbl, $list) = @_;
  print("<<$lbl>>\n");
  foreach (0 .. $#$list) {
    printf("%d->%d\n", $_, $list->[$_]);
  }
}

sub write_whole {
  my ($f, $d) = @_;
  open(my $h, '>', $f) or die "Cannot open '$f'";
  binmode($h); print $h ($d);
  close($h);
}


#-------- unicode-to-internal
use constant BAD => 9999; # invalid int-code
use constant U2IBS => 64;
use constant U2IHS => 1088;  # must be > u2i_index(0xFFFF)
sub u2i_index {
  # \numexpr(\IN+480)/64\relax
  return int(($_[0] + 0x1E0) / U2IBS + 0.5);
}
sub u2i_generate {
  my @ary = (0) x U2IHS;
  my @ary = (@ary, (BAD) x U2IBS); # with first null block
  my @icbs;
  my @ics = map { ucs($_, EJV_PTEXA) } (0 .. 0xFFFF);
  foreach my $uc (0 .. $#ics) {
    my $bi = u2i_index($uc);
    if (!defined $icbs[$bi]) {
      # initialy pointer points to the null block (offset = -$uc)
      $icbs[$bi] = $ary[$bi] = $uc;
    }
    my $ic = $ics[$uc];
    (defined $ic) or next;
    if ($icbs[$bi] == $ary[$bi]) { # block not yet allocated
      $ary[$bi] = $icbs[$bi] - (scalar(@ary) - U2IHS);
      $#ary += U2IBS; $ary[-$_] = BAD for (1 .. U2IBS);
    }
    $ary[$uc - $ary[$bi] + U2IHS] = $ic;
  }
  @ary = @ary[8..$#ary];
  return \@ary;
}
#--------

MAIN: {
  my (@cid, @jis, $fromjis);
  foreach my $gc (keys %cid_map) {
    $cid[$gc] = $cid_map{$gc};
  }
  foreach my $ic (0 .. MAX_INTCODE) {
    my $uc = in_ucs($ic, EJV_PTEX) or next;
    $jis[$ic] = $uc;
  }
  $fromjis = u2i_generate();
  write_whole("$out_dir/bxjatoucs-cid.tfm", form_umbralist(\@cid));
  write_whole("$out_dir/bxjatoucs-jis.tfm", form_umbralist(\@jis));
  write_whole("$out_dir/bxjatoucs-fromjis.tfm", form_umbralist($fromjis));
  dump_umbralist("bxjatoucs-cid", \@cid);
  dump_umbralist("bxjatoucs-jis", \@jis);
  dump_umbralist("bxjatoucs-fromjis", $fromjis);
}
