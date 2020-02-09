# dopic
Tiny command-line app for simple image editing

## Usage
```
Usage is like:
    dopic {SUBCMD} [subcommand-opts & args]

where subcommand syntaxes are as follows:

  resize [required&optional-params] 
    To resize an image
  
  Options(opt-arg sep :|=|spc):
      -h, --help                              print this cligen-erated help
      --help-syntax                           advanced: prepend,plurals,..
      -f=, --file=    string        REQUIRED  a source image file
      -o=, --output=  string        REQUIRED  an output image file
      --format=       ImageFormats  REQUIRED  an image format
      -w=, --width=   int           REQUIRED  a desirable image width
      --height=       int           REQUIRED  a desirable image height
      -v, --verb      bool          false     set verb

  paste [required&optional-params] 
    To paste an image to another image
  
  Options(opt-arg sep :|=|spc):
      -h, --help                              print this cligen-erated help
      --help-syntax                           advanced: prepend,plurals,..
      -f=, --file=    string        REQUIRED  a source image file
      -d=, --dest=    string        REQUIRED  a destination image file
      -o=, --output=  string        REQUIRED  an output image file
      --format=       ImageFormats  REQUIRED  the image format
      -x=, --x=       int           REQUIRED  the X location of the image to paste
      -y=, --y=       int           REQUIRED  the Y location of the image to paste
      -v, --verb      bool          false     set verb
```