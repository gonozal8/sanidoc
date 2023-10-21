
# SaniDoc - Sanitation Of Suspicious Document Files

## Purpose

Provide a mechanism to sanitize suspicious image/document/office files.

Suppose you receive such file as an email attachment. Is it safe to open?
Does it contain any malicious code, script?
Does it trigger an unpatched vulnerability in the viewer application?
To be on the safe side, one must not simply such files when the origin or
the authenticity of the files is unclear.
A mechanism is need to transform such files into a sanitized version
suitable for opening/viewing.

The mechanism cannot retain all functionality of the original file.
The mechanism does not guarantee to retain all layout.
It is suitable to get an impression of the document and to decide whether to
discard the file/email right away or perform further investigation.

### References

This is inspired by Dangerzone.

This reimplementation is supposed to
* focus on CLI mode and non-interactive use
* get rid of the GUI and fancy UI stuff
* be a bare minimum shell script
* rethink some of the security considerations
* be as safe as possible
* leak as few information as possible between containers and the host

CHP, 2023-10


## Implementation

### Scripts

Script files (stage1/stage2) are designed to be run either normally on the
host system or within a dedicated Docker/Podman container.
Note that for production use, it is heavily suggested to use the container
method. You should only use the native method for Dangerzone development
with safe input documents.

#### "sanidoc"


#### Stage 1 Helper Script

read a single suspicious file (SUSF) from stdin

create tempdir

convert SUSF to PDF

convert PDF to (multiple) image files

create a TAR from image files

send TAR to stdout

remove tempdir

#### Stage 2 Helper Script

read TAR of image files from stdin

unpack image files to tempdir

convert image files to multiple PDF files
optionally performing OCR

merge PDF files into a single PDF file

send PDF file to stdout

remove tempdir
