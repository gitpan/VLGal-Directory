use Test;
BEGIN { plan tests => 2 };

use VLGal::Directory;
use VLGal::Size;
use VLGal::Style;

my @size = (
    VLGal::Size->new( {
        max_height => 90,
        max_width => 90,
    } ),
    VLGal::Size->new( {
        max_height => 400,
        max_width => 400,
    } ),
    VLGal::Size->new( {
        max_height => 0,
        max_width => 0,
    } ),
);

#VLGal::Style->instance()->set_table_order_dir('z');
#VLGal::Style->instance()->set_max_columns_dir(6);
#VLGal::Style->instance()->set_verbose(1);
VLGal::Style->instance()->set_size( @size );

ok(1);
my $dir = VLGal::Directory->new_from_fs( {
    dirname => '.',
    basename => 'smpl',
    #dirname => '/home/zoccav/zocca.com/www/fam/foto',
    #basename => '2003',
} );
ok(1);
$dir->generate();
