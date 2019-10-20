use strict;
use ZRJCode ':all';

my $out_dir = '..';

our (%cid_map);
require 'cid_map.pl';

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

sub write_whole {
  my ($f, $d) = @_;
  open(my $h, '>', $f) or die "Cannot open '$f'";
  binmode($h); print $h ($d);
  close($h);
}

MAIN: {
  my (@cid, @jis);
  foreach my $gc (keys %cid_map) {
    $cid[$gc] = $cid_map{$gc};
  }
  foreach my $ic (0 .. MAX_INTCODE) {
    my $uc = in_ucs($ic, EJV_PTEX) or next;
    $jis[$ic] = $uc;
  }
  write_whole("$out_dir/bxjatoucs-cid.tfm", form_umbralist(\@cid));
  write_whole("$out_dir/bxjatoucs-jis.tfm", form_umbralist(\@jis));
  foreach (0 .. $#cid) {
    printf("%d->%d\n", $_, $cid[$_]);
  }
  foreach (0 .. $#jis) {
    printf("%d->%d\n", $_, $jis[$_]);
  }
}

