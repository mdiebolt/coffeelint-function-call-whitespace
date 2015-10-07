argumentNotCorrectlySpaced = (token) ->
  token[0] == "," && !(token.spaced || token.newLine)

checkFunctionArgumentSpacing = (tokenApi) ->
  isLintingError = null

  i = 1
  insideFunctionCall = true
  while insideFunctionCall
    nextToken = tokenApi.peek(i)
    i += 1

    isLintingError = true if argumentNotCorrectlySpaced(nextToken)
    insideFunctionCall = nextToken[0] != "CALL_END"

  return isLintingError

class RuleProcessor
  rule:
    name: "function_call_whitespace"
    level: "ignore"
    message: "Functions may not be invoked with whitespace before the first param or after the last"
    description: """
      This rule forces function calls to have no whitespace between the first and last parens and their arguments.
      <pre>
      <code># Some folks invoke functions like this
      fn( a, b, c )
      # but we prefer they're invoked like this
      myFunction(a, b, c)
      </code>
      </pre>
      Function call whitespace is ignored by default since it's a purely stylistic preference.
      """

  tokens: [ "CALL_START", "CALL_END" ]

  lintToken: (token, tokenApi) ->
    isOuterParenError = argumentSpacingError = null

    currentToken = token[0]
    if currentToken == "CALL_START"
      isOuterParenError = true if token.spaced

      argumentSpacingError = checkFunctionArgumentSpacing(tokenApi)
    else if currentToken == "CALL_END"
      isOuterParenError = true if tokenApi.peek(-1).spaced

    return isOuterParenError || argumentSpacingError

module.exports = RuleProcessor
