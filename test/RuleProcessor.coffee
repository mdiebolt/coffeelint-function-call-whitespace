require("coffee-script/register")

coffeelint = require "coffeelint"
coffeelint.registerRule require("../src/RuleProcessor")

chai = require "chai"
expect = chai.expect

chai.Assertion.addMethod "lintingError", ->
  obj = @._obj

  expectedMessage = "\nexpected\n\n#{obj}\n\nto be a linting error"
  notExpectedMessage = "\nexpected\n\n#{obj}\n\nnot to be a linting error"

  lint = coffeelint.lint obj,
    function_call_whitespace:
      level: "error"

  assertion = lint[0]?.rule == "function_call_whitespace"

  @assert(assertion, expectedMessage, notExpectedMessage)

describe "FunctionCallWhitespace", ->
  it "errors when arguments aren't spaced out", ->
    expect("difference(4,2)").to.be.a.lintingError()

  it "errors when there is leading whitespace in a function call", ->
    expect("sum( 2, 2)").to.be.a.lintingError()

  it "errors when there is trailing whitespace in a function call", ->
    expect("sum(2, 2 )").to.be.a.lintingError()

  it "errors when there is both leading and trailing whitespace in a function call", ->
    expect("sum( 2, 2 )").to.be.a.lintingError()

  it "doesn't error when no parens are used in the function call", ->
    expect("product 4, 5").not.to.be.a.lintingError()

  describe "object literal variations", ->
    describe "object literal as second argument", ->
      it "doesn't error when parens are used and braces are omitted", ->
        code = """
          quotient("first",
            numerator: 2
            denominator: 4
          )
        """

        expect(code).not.to.be.a.lintingError()

    describe "object literal as only argument", ->
      describe "with surrounding parens", ->
        it "doesn't error when function call is one line", ->
          code = "quotient(numerator: 2, denominator: 4)"
          expect(code).not.to.be.a.lintingError()

        it "doesn't error when function call is one line with braces", ->
          code = "quotient({numerator: 2, denominator: 4})"
          expect(code).not.to.be.a.lintingError()

        it "doesn't error when function call is spread out over multiple lines", ->
          code = """
            quotient(
              numerator: 2
              denominator: 4
            )
          """

          expect(code).not.to.be.a.lintingError()

      describe "without surrounding parens", ->
        it "doesn't error when function call is one line with braces", ->
          code = "quotient {numerator: 2, denominator: 4}"
          expect(code).not.to.be.a.lintingError()

        it "doesn't error when function call is spread out over multiple lines", ->
          code = """
            quotient
              numerator: 2
              denominator: 4
          """

          expect(code).not.to.be.a.lintingError()
