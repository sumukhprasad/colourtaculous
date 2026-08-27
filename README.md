# Colourtaculous!
_Amazingly great stylesheet variable compilation!_


***Colourtaculous!*** provides a neat way to define and compile variables for stylesheets.


## Using _Colourtaculous!_

_Colourtaculous!_ reads configuration from a `colourtaculous.yml` file:

```yaml
variable_prefix: "$"
colour_prefix: "color-"
colour_postfix: ""
comment_prefix: "/* "
comment_newline_prefix: " * "
comment_postfix: " */"
output_file: "_vars.sass"

inputfiles:
  - colours.yml
  - more-colours.yml
  - colours-galore.yml
```

It then reads each of the input files (in order, if there's something that requires ordering):
```yaml
name: gray
version: 0.0.1
prefix: "#"
postfix: ""
swatches:
  "010": "212121"
  "020": "3b3b3b"
```

...and assembles all of them in the output file, as variables.

## Configuration

Configuration options can be specified in `colourtaculous.yml`:

| Option                   | Description                                        | Default      |
| ------------------------ | -------------------------------------------------- | ------------ |
| `variable_prefix`        | Prefix used for generated variables.               | `$`          |
| `colour_prefix`          | Prefix used when generating colour names.          | `color-`     |
| `colour_postfix`         | Postfix used when generating colour names.         | *empty*      |
| `comment_prefix`         | Prefix used for generated comments.                | `/* `        |
| `comment_newline_prefix` | Prefix used for continuation lines in comments.    | `*`          |
| `comment_postfix`        | Postfix used for generated comments.               | ` */`        |
| `output_file`            | File to which the generated stylesheet is written. | `_vars.sass` |
| `inputfiles`             | List of colour files to compile, in order.         | —            |

All of these options are, by nature of being options, optional. If an option is not specified in the input file, its default value is used.

## Command-line options
Configuration options can also be supplied on the command line.

For example:

```bash
colourtaculous \
  --variable-prefix "$" \
  --colour-prefix "colour-" \
  --colour-postfix "" \
  --comment-prefix "/* " \
  --comment-newline-prefix " * " \
  --comment-postfix " */" \
  --output-file "_colours.sass"
```

The input file can be selected with:

```bash
colourtaculous --input my-colourtaculous.yml
```

The short form is also available:

```bash
colourtaculous -i my-colourtaculous.yml
```

### Option names

Command-line options use the following names:

| Configuration            | Command line               |
| ------------------------ | -------------------------- |
| `variable_prefix`        | `--variable-prefix`        |
| `colour_prefix`          | `--colour-prefix`          |
| `colour_postfix`         | `--colour-postfix`         |
| `comment_prefix`         | `--comment-prefix`         |
| `comment_newline_prefix` | `--comment-newline-prefix` |
| `comment_postfix`        | `--comment-postfix`        |
| `output_file`            | `--output-file`            |


## Configuration precedence

Options can be provided in both the input file and on the command line.

When an option is specified in both places, **the command-line option takes precedence** over the value in the input file.


## Input files

Each entry in `inputfiles` specifies a colour group definition file to read.

Input files are processed **in the order in which they appear**. This can be useful when the ordering of generated variables is important.

For example:

```yaml
inputfiles:
  - colours.yml
  - more-colours.yml
  - colours-galore.yml
```

A colour file contains a name, version, prefix, postfix, and a collection of swatches:

```yaml
name: gray
version: 0.0.1
prefix: "#"
postfix: ""
swatches:
  "010": "212121"
  "020": "3b3b3b"
```

The swatches are then compiled into stylesheet variables using the configured prefixes and postfixes.

Prefix and postfix can also be used to make different kinds of colours:
```yaml
prefix: "rgba("
postfix: ")"
swatches:
  "010": "0, 0, 0, 0.1"
  "020": "0, 0, 0, 0.2"
```
... and so on.


## Defaults

If no configuration is provided, *Colourtaculous!* uses the following defaults:

```yaml
variable_prefix: "$"
colour_prefix: "color-"
colour_postfix: ""
comment_prefix: "/* "
comment_newline_prefix: " * "
comment_postfix: " */"
output_file: "_vars.sass"
```

Therefore a minimal `colourtaculous.yml` can simply contain:

```yaml
inputfiles:
  - colours.yml
```

and *Colourtaculous!* will use the defaults above.