use strict;
use warnings;
use Test::More tests => 3;
use Dancer::FileUtils 'path';
use Dancer::Config;
use File::Basename qw(dirname);
use File::Spec::Functions qw(rel2abs);
use Dancer::Template::MicroTemplateExtended;

my $dir = rel2abs(dirname($0));

Dancer::Config::setting( 'views' =>  $dir );
ok my $engine = Dancer::Template::MicroTemplateExtended->build(
    'template',
    'micro_template_extended',
);

is ref($engine), 'Dancer::Template::MicroTemplateExtended';

my $template = path( $dir, 'index.tt');

my $result = $engine->render(
    $template,
    {   var1 => 1,
        var2 => 2,
        foo  => 'one',
        bar  => 'two',
        baz  => 'three'
    }
);

my $expected =
  'this is var1="1" and var2=2' . "\n\nanother line\n\n one two three\n";
is $result, $expected, "processed a template given as a file name";

