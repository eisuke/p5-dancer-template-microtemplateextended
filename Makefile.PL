use inc::Module::Install;

name 'Dancer-Template-MicroTemplateExtended';
perl_version '5.008001';
all_from 'lib/Dancer/Template/MicroTemplateExtended.pm';
license 'perl';

requires 'Dancer' => 1.150;
requires 'Text::MicroTemplate::Extended';

tests "t/*.t";
author_tests 'xt';

auto_include;
auto_install;
WriteAll;
