package Dancer::Template::MicroTemplateExtended;
use strict;
use warnings;
use Encode;

use Text::MicroTemplate::Extended;
use Dancer::FileUtils 'path';
use Dancer::Config 'setting';
use File::Spec::Functions qw(abs2rel);

use base 'Dancer::Template::Abstract';

our $VERSION = '0.01';

our $engine;

sub init {
    my $self = shift;

    my $mt_cfg = {
        use_cache    => 0,
        line_start   => '%',
        tag_start    => '[%',
        tag_end      => '%]',
        extension    => '.tt',
        include_path => +[],
        macro        => +{},
        %{ $self->config },
    };

    push @{$mt_cfg->{include_path}}, setting('views');

    unless( exists $mt_cfg->{macro}->{raw} ) {
        $mt_cfg->{macro}{raw}
            = sub { Text::MicroTemplate::EncodedString->new(@_) };
    }

    $engine = Text::MicroTemplate::Extended->new(%$mt_cfg);
}

sub render($$$) {
    my ($self, $template, $tokens) = @_;

    die "'$template' is not a regular file"
      if ref($template) || (!-f $template);

    $template =~ s/\.tt$//;
    my $file = abs2rel($template, setting('views'));
    my $request = delete $tokens->{request};
    my $params  = delete $tokens->{params};
    $engine->template_args({
        args => $tokens,
        request => $request,
        params => $params,
    });
    my $content = $engine->render($file);

    if( $engine->open_layer eq ':utf8' ) {
        $content = Encode::encode( 'utf8', $content);
    }

    return $content;
}

1;
__END__

=head1 NAME

Dancer::Template::MicroTemplateExtended - Text::MicroTemplate::Extended wrapper for Dancer

=head1 DESCRIPTION

This class is an interface between Dancer's template engine abstraction layer and the L<Text::MicroTemplate::Extended> module.

In order to use this engine, set the following setting as the following:

    template: micro_template_extended

This can be done in your config.yml file or directly in your app code with the set keyword.

Note that by default, Dancer configures the different options of Text::MicroTemplate::Extended default options.

=over

=item * use_cache  => 0,

=item * line_start   => '%',

=item * tag_start    => '[%',

=item * tag_end      => '%]',

=item * extension    => '.tt',

=back

This can be changed within your config file - for example:

   template: micro_template_extended
    engines:
        micro_template_extended:
            start_tag: '<?'
            stop_tag: '?>'

=head1 INTERNAL METHODS

=head2 init

=head2 render

=head1 SEE ALSO

L<Dancer>,L<Text::MicroTemplate::Extended>,L<Dancer::Template::MicroTemplate>

=head1 AUTHOR

Eisuke Oishi

=head1 LICENSE

This module is free software and is released under the same terms as Perl itself.

