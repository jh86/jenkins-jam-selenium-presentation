#!/usr/bin/perl

use strict;
use warnings;

my $file = "README.md";
my $markdown = do {
    local $/ = undef;
    open(my $fh, "<", $file) or die "could not open $file: $!";
    <$fh>;
};

my $template = <<END_TEMPLATE;
<!DOCTYPE html>
<html>
  <head>
    <title>Selenium testing with Jenkins for great justice!</title>
    <meta charset="utf-8">
    <style>
      \@import url(https://fonts.googleapis.com/css?family=Yanone+Kaffeesatz);
      \@import url(https://fonts.googleapis.com/css?family=Droid+Serif:400,700,400italic);
      \@import url(https://fonts.googleapis.com/css?family=Ubuntu+Mono:400,700,400italic);

      body { font-family: 'Droid Serif'; }
      h1, h2, h3 {
        font-family: 'Yanone Kaffeesatz';
        font-weight: normal;
      }
      .remark-code, .remark-inline-code { font-family: 'Ubuntu Mono'; }
    </style>
  </head>
  <body>
    <textarea id="source">

${markdown}
    </textarea>
    <script src="js/remark-latest.min.js">
    </script>
    <script>
      var slideshow = remark.create();
    </script>
  </body>
</html>
END_TEMPLATE

print($template);
