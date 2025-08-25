# Contributing

Thank you for your interest in contributing to `projectdo`! Contributions
are welcome.

## Adding support for a new tool

Adding support for a new tool is usually fairly straightforward by looking at
how the existing tools are implemented.

At a high level, the steps are:

1. Add a directory in `tests/` and populate it with a minimal setup that should
   be detected.

   ```sh
   mkdir tests/toolname
   touch tests/toolname/mytool.yaml
   ```


2. Add tests in `run-tests.sh`. This is usually just copy-pasting and tweaking
   the tests for an existing tool.

3. Create a `try_toolname` function in the `projectdo` script. Use the existing
   functions for reference.

4. Call the `try_toolname` function in the `detect_and_run` function.

5. Update the documentation.
   - Add the tool to the list in the top of the readme and the table in the
     bottom of the readme.
   - Add the tool to the table in the man page `man/projectdo.1.md` and
     regenerate the man page with `make manpage` (requires Pandoc).

6. Run the test suite with `make test`.

## General coding guidelines

* Stick to POSIX shell scripting features and commands (within reason).
* The script is formatted using [`shfmt`](https://github.com/mvdan/sh). You can
  configure your editor to use this formatter or format manually using `make
  format`.
