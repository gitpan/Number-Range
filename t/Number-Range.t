use Test::More tests => 16;
BEGIN { use_ok('Number::Range') };


ok($range = Number::Range->new("10..100"));
ok($range->inrange(10)   == 1);
ok($range->inrange(1000) == 0);
ok($range = Number::Range->new("10..50,60..100"));
ok($range->inrange(10) == 1);
ok($range->inrange(55) == 0);
ok($range->inrange(75) == 1);
ok($range = Number::Range->new("10..100","150..200"));
ok($range->inrange(10)  == 1);
ok($range->inrange(125) == 0);
ok($range->inrange(155) == 1);
ok($range = Number::Range->new("-10..10"));
ok($range->inrange(10)  == 1);
ok($range->inrange(-10) == 1);
ok($range->inrange(0)   == 1);
