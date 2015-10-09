# coffeelint-function-call-whitespace
=====================================

Influenced by built-in Coffeelint rule [no_implicit_parens](https://github.com/clutchski/coffeelint/blob/5d818a5a4b4310cc147614e54d972b23f47cad88/src/rules/no_implicit_parens.coffee)

This is a plugin for Coffeelint. It enforces conventions about whitespace used when invoking functions.

- It requires that function arguments are separated by at least one space.
- If parentheses are used in the invocation, then there may not be whitespace after the openening paren or before the closing one.

```coffee
# both valid
sum(2, 4)
sum 2, 4

# linting errors
sum( 2, 4)
sum(2, 4 )
sum( 2, 4 )
```

## Installation

1. `npm install coffeelint-function-call-whitespace --save-dev`
1. `npm install`

## Configuration

In `coffeelint.json` add

```json
{
  "//": "other lint rules",
  {
    "function_call_whitespace": {
      "module": "coffeelint-function-call-whitespace",
      "level": "error"
    }
  }
}
```

Now future runs of `coffeelint` will check your function invocations for the above whitespace rules.
