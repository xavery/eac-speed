This is a simple script which scans a directory for files that look like Exact
Audio Copy log files and parses them, saving drive and extraction speed
information.

A summary is then printed to standard output, like this :

```
$ ./eac-speed.pl /storage/music/
HL-DT-STDVDRAM GU70N : 3.7 X (90 rips, stddev = 1.0 X)
LITE-ON LTR-52327S : 6.3 X (80 rips, stddev = 1.8 X)
TSSTcorpCDDVDW TS-L632H : 3.3 X (74 rips, stddev = 0.8 X)
TSSTcorpCD/DVDW SH-W162C : 4.2 X (68 rips, stddev = 1.6 X)
Optiarc DVD RW AD-7240S : 3.3 X (59 rips, stddev = 0.4 X)
Optiarc DVD RW AD-7200A : 3.2 X (31 rips, stddev = 0.4 X)
HL-DT-STDVD-RW GCA-4080N : 3.0 X (13 rips, stddev = 0.2 X)
HL-DT-STDVDRAM GH24NSD1 : 5.7 X (13 rips, stddev = 1.4 X)
```

Paths of unrecognised log files are printed to standard error.
