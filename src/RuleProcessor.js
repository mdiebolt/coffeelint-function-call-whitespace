(function() {
  var RuleProcessor, argumentNotCorrectlySpaced, checkFunctionArgumentSpacing;

  argumentNotCorrectlySpaced = function(token) {
    return token[0] === "," && !(token.spaced || token.newLine);
  };

  checkFunctionArgumentSpacing = function(tokenApi) {
    var i, insideFunctionCall, isLintingError, nextToken;
    isLintingError = null;
    i = 1;
    insideFunctionCall = true;
    while (insideFunctionCall) {
      nextToken = tokenApi.peek(i);
      i += 1;
      if (argumentNotCorrectlySpaced(nextToken)) {
        isLintingError = true;
      }
      insideFunctionCall = nextToken[0] !== "CALL_END";
    }
    return isLintingError;
  };

  RuleProcessor = (function() {
    function RuleProcessor() {}

    RuleProcessor.prototype.rule = {
      name: "function_call_whitespace",
      level: "ignore",
      message: "Functions may not be invoked with whitespace before the first param or after the last",
      description: "This rule forces function calls to have no whitespace between the first and last parens and their arguments.\n<pre>\n<code># Some folks invoke functions like this\nfn( a, b, c )\n# but we prefer they're invoked like this\nmyFunction(a, b, c)\n</code>\n</pre>\nFunction call whitespace is ignored by default since it's a purely stylistic preference."
    };

    RuleProcessor.prototype.tokens = ["CALL_START", "CALL_END"];

    RuleProcessor.prototype.lintToken = function(token, tokenApi) {
      var argumentSpacingError, currentToken, isOuterParenError;
      isOuterParenError = argumentSpacingError = null;
      currentToken = token[0];
      if (currentToken === "CALL_START") {
        if (token.spaced) {
          isOuterParenError = true;
        }
        argumentSpacingError = checkFunctionArgumentSpacing(tokenApi);
      } else if (currentToken === "CALL_END") {
        if (tokenApi.peek(-1).spaced) {
          isOuterParenError = true;
        }
      }
      return isOuterParenError || argumentSpacingError;
    };

    return RuleProcessor;

  })();

  module.exports = RuleProcessor;

}).call(this);
