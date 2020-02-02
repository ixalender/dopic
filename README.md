# dopic
Command-line app for simple image editing

## Usage
```
This is a multiple-dispatch command.  Top-level --help/--help-syntax
is also available.  Usage is like:
    dopic {SUBCMD} [subcommand-opts & args]
where subcommand syntaxes are as follows:

  resize [required&optional-params] 
    resize an image
  Options(opt-arg sep :|=|spc):
      -h, --help                              print this cligen-erated help
      --help-syntax                           advanced: prepend,plurals,..
      -f=, --file=    string        REQUIRED  source image file
      -o=, --output=  string        REQUIRED  output image file
      --format=       ImageFormats  REQUIRED  image format
      -w=, --width=   int           REQUIRED  desirable image width
      --height=       int           REQUIRED  desirable image height
      -v, --verb      bool          false     set verb

  insert [required&optional-params] 
    insert an image to another image
  Options(opt-arg sep :|=|spc):
      -h, --help                              print this cligen-erated help
      --help-syntax                           advanced: prepend,plurals,..
      -f=, --file=    string        REQUIRED  source image file
      -d=, --dest=    string        REQUIRED  destination image file
      -o=, --output=  string        REQUIRED  output image file
      --format=       ImageFormats  REQUIRED  image format
      -x=, --x=       int           REQUIRED  X location of insertable image
      -y=, --y=       int           REQUIRED  Y location of insertable image
      -v, --verb      bool          false     set verb
```