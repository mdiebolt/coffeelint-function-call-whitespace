isArgumentIncorrectlySpaced = (token) ->
  token[0] == "," && !(token.spaced || token.newLine)

checkArgumentSpacing = (tokenApi) ->
  i = 1
  insideFunctionCall = true
  while insideFunctionCall
    nextToken = tokenApi.peek(i)
    i += 1

    isLintingError = true if isArgumentIncorrectlySpaced(nextToken)
    insideFunctionCall = nextToken[0] != "CALL_END"

  isLintingError

checkCloseParenSpacing = (token, tokenApi) ->
  previousToken = tokenApi.peek(-1)
  if previousToken.spaced
    # In this case, the user is omitting parens
    # It's a linting error if the previous and
    # current tokens aren't in the same position
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
    message: "Functions must be invoked without whitespace before the first param or after the last and one space between arguments"
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

  tokens: ["CALL_START", "CALL_END"]

  lintToken: (token, tokenApi) ->
    tokenType = token[0]
    if tokenType == "CALL_START"
      isOpeningParenError = true if token.spaced

      isArgumentError = checkArgumentSpacing(tokenApi)
    else if tokenType == "CALL_END"
      isClosingParenError = checkCloseParenSpacing(token, tokenApi)

    isOpeningParenError || isArgumentError || isClosingParenError

module.exports = RuleProcessor
