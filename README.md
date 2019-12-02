# Clear Derived Data

Simple utility to quickly clear your DerivedData directory by typing `cdd` from the Terminal.

## Installation

### Homebrew

To install using Homebrew run the `tap` command to clone the third-party repository containing the formula:

```bash
brew tap rwbutler/tools
``` 

Next install the package:

```bash
brew install cdd
```

### Manual

To install manually, download the Swift script named `main.swift` and copy to a suitable location locally. Rename to `cdd.swift` (or another convenient name) and then to run either type:

```bash
swift cdd.swift 
```

Which should produce the output:

```bash
DerivedData cleared.
```

If you give the script execute permission using:

```bash
chmod 755 cdd.swift
```

This will allow you to conveniently run the script as follows:

```bash
./cdd.swift
```

Additionally you may wish to [create an alias](https://coolestguidesontheplanet.com/make-an-alias-in-bash-shell-in-os-x-terminal/) in Terminal for convenience.

## Usage

In order to run simply type:

```bash
cdd
```

Which should result in the following output:

```bash
DerivedData cleared.
```

Or:

```bash
DerivedData empty.
```

If the directory is already empty. 

By default, Clear Derived Data moves your DerivedData directory to Trash. If you wish to remove the directory permanently use the `-f` switch as follows:

```bash
cdd -f
```

You can print additional information using the verbose switch `-v` as follows:

```bash
cdd -v
```