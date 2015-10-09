(function() {
  var RuleProcessor, checkArgumentSpacing, checkCloseParenSpacing, isArgumentIncorrectlySpaced;

  isArgumentIncorrectlySpaced = function(token) {
    return token[0] === "," && !(token.spaced || token.newLine);
  };

  checkArgumentSpacing = function(tokenApi) {
    var i, insideFunctionCall, isLintingError, nextToken;
    i = 1;
    insideFunctionCall = true;
    while (insideFunctionCall) {
      nextToken = tokenApi.peek(i);
      i += 1;
      if (isArgumentIncorrectlySpaced(nextToken)) {
        isLintingError = true;
      }
      insideFunctionCall = nextToken[0] !== "CALL_END";
    }
    return isLintingError;
  };

  checkCloseParenSpacing = function(token, tokenApi) {
    var isLintingError, previousToken;
    previousToken = tokenApi.peek(-1);
    if (previousToken.spaced) {
      if (token.generated) {
        if (token[2].last_column !== previousToken[2].last_column) {
          isLintingError = true;
        }
      } else {
        isLintingError = true;
      }
    }
    return isLintingError;
  };

  RuleProcessor = (function() {
    function RuleProcessor() {}

    RuleProcessor.prototype.rule = {
      name: "function_call_whitespace",
      level: "ignore",
      message: "Functions must be invoked without whitespace before the first param or after the last and one space between arguments",
      description: "This rule forces function calls to have no whitespace between the first and last parens and their arguments.\n<pre>\n  <code>\n    # Some folks invoke functions like this\n    fn( a, b, c )\n    # but we prefer they're invoked like this\n    myFunction(a, b, c)\n  </code>\n</pre>\nFunction call whitespace is ignored by default since it's a purely stylistic preference."
    };

    RuleProcessor.prototype.tokens = ["CALL_START", "CALL_END"];

    RuleProcessor.prototype.lintToken = function(token, tokenApi) {
      var isArgumentError, isClosingParenError, isOpeningParenError, tokenType;
      tokenType = token[0];
      if (tokenType === "CALL_START") {
        if (token.spaced) {
          isOpeningParenError = true;
        }
        isArgumentError = checkArgumentSpacing(tokenApi);
      } else if (tokenType === "CALL_END") {
        isClosingParenError = checkCloseParenSpacing(token, tokenApi);
      }
      return isOpeningParenError || isArgumentError || isClosingParenError;
    };

    return RuleProcessor;

  })();

  module.exports = RuleProcessor;

}).call(this);
