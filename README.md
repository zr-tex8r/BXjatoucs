BXjatoucs Package
=================

LaTeX: To convert Japanese character code to Unicode

This package provides function-like (fully-expandable) macros that
convert a character code value in several Japanese encodings to
a Unicode value. Supported source encodings are: ISO-2022-JP (jis),
EUC-JP (euc), Shift_JIS (sjis) and the Adobe-Japan1 glyph set.

### System requirement

  * TeX format: LaTeX and plain TeX.
  * TeX engine: Anything that has e-TeX extension.
  * Dependent packages:
      - infwarerr
      - ltxcmds

### Installation

  - `*.sty` → $TEXMF/tex/latex/bxjatoucs
  - `*.tfm` → $TEXMF/fonts/tfm/public/bxjatoucs

### License

This package is distributed under the MIT License.


The bxjatoucs Package ― main
-----------------------------

### Package Loading

In plain TeX:

    \input bxjatoucs.sty

In LaTeX:

    \usepackage{bxjatoucs}

### Usage

All the macros take an argument that forms a valid number and represents
the input code value, and expands (in two steps) to the string that
represents the output Unicode scalar value in decimal.

  - `\bxjaJisToUcs{<value>}`: converts from a jis scalar value.
  - `\bxjaEucToUcs{<value>}`: converts from an euc scalar value.
  - `\bxjaSjisToUcs{<value>}`: converts from a sjis scalar value.
  - `\bxjaCidToUcs{<value>}`: converts from an AJ1 CID value.

There are variants that return in hexadecimal (zero-padded to at least
four digits):

  - `\bxjaJisToUcsHex{<value>}`
  - `\bxjaEucToUcsHex{<value>}`
  - `\bxjaSjisToUcsHex{<value>}`
  - `\bxjaCidToUcsHex{<value>}`

Note: These macros return zero (decimal `0` and hexadecimal `0000`)
if the input number is out of the valid range of source encoding.
If the input is malformed, the macros issue an error `Missing number`
and then return zero.

Additional variants:

  - `\bxjaFastCidToUcs{<value>}`: same as `bxjaCidToUcs`, except that
    the argument is assumed to be a valid decimal string.
  - `\bxjaFastCidToUcsHex{<value>}`: same for `\bxjaCidToUcsHex`.

## Example

The following `\message` lines all display `23551:21496`.

    \message{\bxjaJisToUcs{"3C77}:\bxjaJisToUcs{"3B4A}}
    \message{\bxjaEucToUcs{"BCF7}:\bxjaEucToUcs{"BBCA}}
    \message{\bxjaSjisToUcs{"8EF5}:\bxjaSjisToUcs{"8E69}}
    \message{\bxjaCidToUcs{2339}:\bxjaCidToUcs{2200}}

The following `\message` lines all display `5BFF:53F8`.

    \message{\bxjaJisToUcsHex{"3C77}:\bxjaJisToUcsHex{"3B4A}}
    \message{\bxjaEucToUcsHex{"BCF7}:\bxjaEucToUcsHex{"BBCA}}
    \message{\bxjaSjisToUcsHex{"8EF5}:\bxjaSjisToUcsHex{"8E69}}
    \message{\bxjaCidToUcsHex{2339}:\bxjaCidToUcsHex{2200}}


Revision History
----------------

  * Version 0.2  ‹2019/10/20›
      - The first public version.

--------------------
Takayuki YATO (aka. "ZR")  
https://github.com/zr-tex8r
