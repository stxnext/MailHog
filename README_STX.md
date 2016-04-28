Building MailHog for usage in the STX Intranet project
======================================================

### Prerequisities

- golang language installed (see: https://golang.org/doc/install)
- installed Baazar version control tool (use: `sudo apt-get install bzr`)

### Building

Execute the set of following commands from the MailHog directory:

    export GOPATH=`pwd`
    export GOBIN=$GOPATH/bin
    make
    
After build process is finished you will find binaries in the directory `bin`

    
 
    
