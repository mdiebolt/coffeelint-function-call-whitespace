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

  isLintingError

checkCloseParenSpacing = (token, tokenApi) ->
  isLintingError = null

  previousToken = tokenApi.peek(-1)
  if previousToken.spaced
    if token.generated
      unless token[2].last_column == previousToken[2].last_column
        isLintingError = true
    else
      isLintingError = true

  isLintingError

class RuleProcessor
  rule:
    name: "function_call_whitespace"
    level: "ignore"
    message: "Functions may not be invoked with whitespace before the first param or after the last"
    description: """
      This rule forces function calls to have no whitespace between the first and last parens and their arguments.
      <pre>
        <code>
          # Some folks invoke functions like this
          fn( a, b, c )
          # but we prefer they're invoked like this
          myFunction(a, b, c)
        </code>
      </pre>
      Function call whitespace is ignored by default since it's a purely stylistic preference.
      """

  tokens: [ "CALL_START", "CALL_END" ]

  lintToken: (token, tokenApi) ->
    isOpeningParenError = isClosingParenError = isArgumentSpacingError = null

    currentToken = token[0]
    if currentToken == "CALL_START"
      isOpeningParenError = true if token.spaced

      isArgumentSpacingError = checkFunctionArgumentSpacing(tokenApi)
    else if currentToken == "CALL_END"
      isClosingParenError = checkCloseParenSpacing(token, tokenApi)

    return isOpeningParenError || isClosingParenError || isArgumentSpacingError

module.exports = RuleProcessor
