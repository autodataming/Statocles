package Statocles::Theme;
# ABSTRACT: Templates, headers, footers, and navigation

use Statocles::Class;
use File::Share qw( dist_dir );

=attr source_dir

The source directory for this theme.

If the source_dir begins with ::, will pull one of the Statocles default
themes from the Statocles share directory.

=cut

has source_dir => (
    is => 'ro',
    isa => Path,
    coerce => Path->coercion,
);

=attr templates

The template objects for this theme.

=cut

has templates => (
    is => 'ro',
    isa => HashRef[HashRef[InstanceOf['Statocles::Template']]],
    lazy => 1,
    builder => 'read',
);

=method BUILDARGS

Handle the source_dir :: share theme.

=cut

around BUILDARGS => sub {
    my ( $orig, $self, @args ) = @_;
    my $args = $self->$orig( @args );
    if ( $args->{source_dir} && $args->{source_dir} =~ /^::/ ) {
        my $name = substr $args->{source_dir}, 2;
        $args->{source_dir} = Path::Tiny->new( dist_dir( 'Statocles' ) )->child( 'theme', $name );
    }
    return $args;
};

=method read()

Read the C<source_dir> and create the Statocles::Template objects inside.

=cut

sub read {
    my ( $self ) = @_;
    my %tmpl;
    my $iter = $self->source_dir->iterator({ recurse => 1, follow_symlinks => 1 });
    while ( my $path = $iter->() ) {
        if ( $path =~ /[.]tmpl$/ ) {
            my $name = $path->basename( '.tmpl' ); # remove extension
            my $group = $path->parent->basename;
            $tmpl{ $group }{ $name } = Statocles::Template->new(
                path => $path,
            );
        }
    }
    return \%tmpl;
}

=method template( $section => $name )

Get the template from the given C<section> with the given C<name>.

=cut

sub template {
    my ( $self, $app, $template ) = @_;
    return $self->templates->{ $app }{ $template };
}

1;
__END__

=head1 SYNOPSIS

    # Template directory layout
    /theme/site/layout.tmpl
    /theme/blog/index.tmpl
    /theme/blog/post.tmpl

    my $theme      = Statocles::Theme->new( path => '/theme' );
    my $layout     = $theme->template( site => 'layout' );
    my $blog_index = $theme->template( blog => 'index' );
    my $blog_post  = $theme->template( blog => 'post' );

=head1 DESCRIPTION

A Theme contains all the templates that applications need.

When the C<source_dir> is read, the templates inside are organized based on
their name and their parent directory.

