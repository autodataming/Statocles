---
title: Managing Content
layout: layout/full-width.html
---

# Documents

The most common unit of content in Statocles is the Document. A document
is a text file consisting of an optional header of document attributes,
made of YAML, followed by the document's content, written in Markdown.

A Statocles site is made up of applications that read their documents
and produce HTML pages which can then be rendered. Statocles also allows
images, CSS, and JavaScript files to be placed anywhere.

## Header

The header is where document attributes are set. These attributes include:

* The title of the document
* The author of the document
* Tags, which are used to categorize the document
* Links to related documents
* What template the document should use
* What layout the document should use
* Additional CSS and JavaScript files this content needs
* Arbitrary data you might want to use in your theme
* Anything that isn't the document's content

These attributes are defined using YAML, which is a simple language for
organizing data into structures like lists (sequences of elements) and
dictionaries (named values). At its very basic, YAML is just a set of
`field: value` dictionary items, like so:

    ---
    title: My First Post
    author: Doug Bell
    ---

YAML always starts with `---` on a line by itself. Statocles also uses
`---` on a line by itself to denote the end of the YAML header. There is
only one YAML header per document, though some applications may use
additional YAML sections for their own purposes.

Since YAML is meant to create data structures, we can define, for
example, lists of tags. In a list, each item in the list is indented,
and begins with a "-" followed by a space.

    ---
    title: My Tagged Post
    tags:
        - post
        - tagged
        - first
    ---

And we can get more complex. For example, to define additional CSS
files, we need to create a dictionary of lists:

    ---
    title: My Styled Post
    links:
        stylesheet:
            - http://cdn.example.com/bootstrap.css
            - http://cdn.example.com/jquery-ui.css
    ---

Thankfully, this is about as complex as Statocles requires, but YAML allows
these data structures to be nested as deeply as necessary.

### Basic Attributes

Every Statocles document has some basic attributes:

<dl>
    <dt>title</dt>
    <dd>
        <p>The <code>title</code> attribute sets the document's title. This
        title will appear in the <code>&lt;title&gt;</code> tag and may
        appear automatically in the content itself (such as in the blog
        application).</p>

        <pre>---
title: What I had for lunch today
---</pre>

        <p>This is an important attribute, and should be defined in
        every document.</p>
    </dd>
    <dt>author</dt>
    <dd>
        <p>The <code>author</code> attribute defines the name of the
        author of the document. This will appear in the blog application
        as a simple byline. This attribute is optional.</p>

        <pre>---
author: Doug Bell (preaction)
---</pre>

    </dd>
    <dt>date</dt>
    <dd>
        <p>The <code>date</code> attribute lets you set the last
        modified date/time of the document in <code>YYYY-MM-DD</code> or
        <code>YYYY-MM-DD HH:MM:SS</code> format. This metadata is used
        to inform search engines of when the document last changed, for
        indexing purposes.</p>

        <pre>---
date: 2016-05-04
date: 2016-05-04 12:43:51
---</pre>

        <p><b>Note: </b> The blog application does not use this date to
        control the post order. Only the date in the post's path
        matters.</p>
    </dd>
    <!-- Document the status attribute when we start using it
    <dt>status</dt>
    <dd>
    </dd>
    -->
</dl>

### Tags

Every document can have one or more tags for categorization purposes. In
the blog app, posts are collected under tags for easy viewing. For
example, a food blog could tag recipes with their primary ingredients,
or a personal blog could be divided into sections based on different
subjects.

Tags can be added to a document with the `tags` attribute. The value
should be either a comma-separated list, or a YAML array, like so:

    ---
    title: Chicken Alfredo
    tags: chicken, cheese, pasta
    ---

    ---
    title: Chicken Alfredo
    tags:
        - chicken
        - cheese
        - pasta
    ---

Then, in the blog app, this post will appear in each of the three tags'
list view and feeds.

### Links

Links declare relationships from other URLs to this document. Using the
`links` attribute, we can add custom stylesheets and scripts to this
document, or we can define the canonical source (in case we're
aggregating or duplicating content available elsewhere on the web).

The `links` attribute contains one or more keys, which are how the links
are related, and an array of URLs or link attributes (such as `href` and
`text`). These are turned in to [Statocles link
objects](/pod/Statocles/Link), and have all the attributes that link
objects have.

For example, to declare some external stylesheets, we can use the
`stylesheet` key. In this key, we can simply define the URLs we want,
like this:

    ---
    links:
        stylesheet:
            - http://bootstrapcdn.com/3.2.1/css/bootstrap.min.css
            - http://bootstrapcdn.com/3.2.1/css/bootstrap-theme.min.css

Or we can explicitly define the link attributes:

    ---
    links:
        stylesheet:
            - href: http://bootstrapcdn.com/3.2.1/css/bootstrap.min.css
              type: text/css
              rel: stylesheet
            - href: http://bootstrapcdn.com/3.2.1/css/bootstrap-theme.min.css
              type: text/css
              rel: stylesheet

The `type` and `rel` attributes are optional here, but are shown for
demonstration.

Some links allow us to define `text` as well, like the `canonical` link,
which tells search engines to send users somewhere else when they search
for this page. In the blog app, this link text will appear and allow
users to click to view the content on the preferred site.

    ---
    links:
        canonical:
            - href: http://example.com/canonical
              text: The canonical source of this content

The default themes allow for the following link keys:

* `stylesheet` - Extra CSS files that should be added to this page
* `script` - Extra JavaScript files that should be added to this page
* `canonical` - The canonical source of this content, for search engines

### Images

Like links, the `images` attribute allows us to define related images,
such as a thumbnail or title image. Like links, images have a key which
describes how the image will be used, and either a URL or set of image
attributes (such as `src` and `title`).

For example, to add a title banner, we can use the `banner` key:

    ---
    images:
        banner:
            src: ./banner.jpg
            alt: A picture of clouds

The default themes allow for the following image keys:

* `icon` - The shortcut icon for this page

### Data Attribute

The `data` attribute is an extra place that allows you to put anything
you want. This is helpful for theme authors to add additional features,
or when using [content templates](#Content-Templates) to generate your
content.

The `data` attribute must be a hash, but you can put anything inside
that hash (arrays and more hashes are fine).

Using the data attribute, you could write a recipe's ingredients in your
data attribute, and have a template generate the right metadata. Or have
a list of people to display on the page. For examples, see the section
on [content templates](#Content-Templates), below.

The default Statocles themes do not use the `data` attribute currently,
allowing you to do as you please.

### Template / Layout

For greater flexibility, every document can declare its own custom
template or layout to override the one it would normally use. This
allows theme authors to provide multiple content templates and layouts
that can be used as needed.

The `template` key changes the content template, which is the template
that displays the content in the document. The `layout` key changes the
layout template, which handles everything surrounding the main content:
The site's header, footer, design, and other parts.

    ---
    template: blog/recipe.html
    layout: layout/full-width.html

The default Statocles themes include these optional templates you can
use:

* layout/full-width.html
    * This layout does not contain a sidebar, taking up the full width
      of the page.

## Content

The main content of the document, after the YAML header, is made of Markdown.
HTML can be painful to write, with opening tags and closing tags and formatting
tags and making tags in order and adding tags for style purposes and other
pain. Worse, it's hard to read the HTML source (and getting worse all the
time), so the only practical use one can get out of HTML is after it is
rendered in the browser.

Markdown is different. Instead of tags, Markdown uses special characters
(like `*`, `_`, `#`, `[`, `]`, `(`, and `)`) to perform formatting
tasks.  These formats include bolding, italicizing, creating headers,
lists, links, preformatted sections, quotes, and images. And, when
Markdown isn't enough, you can go back to using HTML to add `<aside>`,
`<figure>`, `<dl>`, and other tags.

### Emphasized Text

Markdown allows for easy indication of emphasized text. Text between
single asterisks `*` or underscores `_` is *emphasized* with a `<em>`
tag. Double asterisks/underscores is **strong emphasis** with
a `<strong>` tag.

### Code Text

Inline `code text` is surrounded by backticks `` ` `` and results in a `<code>`
tag.  Code text is automatically HTML escaped, so you can write raw HTML
inside backticks and it won't be processed as HTML.

You can also have code blocks which are simply indented by at least
4 spaces or 1 tab. Code blocks are surrounded by `<pre>` and `<code>`
tags.

    This is a code block, indented 4 spaces

### Headers

Headers are preceded by a number of hash `#` characters, one for each
level of heading. So, one `#` is an `<h1>`, two `##` is an `<h2>`,
three `###` is an `<h3>`, and so on up to 6.

    # Heading 1
    ## Heading 2
    ### Heading 3
    #### Heading 4
    ##### Heading 5
    ###### Heading 6

### Blockquotes

Blockquotes are paragraphs preceded by `>` characters and result in
a `<blockquote>` tag. Blockquotes can be nested, and can contain any
other Markdown content.

    > This is a blockquote across multiple lines. Each line can be
    > started with the `>` character, or you can be lazy and only start
    > the first line with a `>`.

    > > This is a nested quote, but it's short.

    > This second paragraph only has the `>` character on the first
    line, not any subsequent lines, because I'm lazy and my editor
    doesn't do it for me.

### Links

XXX

### Lists

XXX

### Images

XXX

### HTML

At any time you can use HTML if you need to have a tag that isn't
supported in Markdown, or if you need to add classes or IDs to your
content.

XXX

By default, content inside the HTML tag is not parsed as Markdown,
making it safe to use characters that would otherwise be processed. To
allow Markdown inside your HTML, use the `markdown=1` attribute:

    <p class="special" markdown=1>
    This paragraph is still parsed as Markdown, so *bold formatting*
    will still work!
    </p>

The Statocles default themes include custom formatting for the following
HTML5 tags:

* aside
* figure / figcaption

XXX

# Simple Content

How to create a new page

XXX

# Application Commands

How to create a blog post

XXX

# Images and Files

XXX

# Content Templates

XXX

# Content Sections

XXX

# See Also

* [The Install guide](../install)
* [The Config guide](../config)
* [The Theme guide](../theme)
* [The Develop guide](../develop)

