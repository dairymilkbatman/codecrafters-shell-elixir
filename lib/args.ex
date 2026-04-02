defmodule Args do
  def parse(cmd),
    do: parse(cmd, "", [], nil)

  # 1
  # "" - empty string and base case
  # Revense and return.
  def parse("", arg, acc, _quote),
    do: Enum.reverse([arg | acc])

  # 2
  # \\ + character, no quote.
  # Take next char literally(escape)
  def parse(<<?\\, c::utf8, rest::binary>>, arg, acc, nil),
    do: parse(rest, <<arg::binary, c>>, acc, nil)

  # 3
  # ' or "
  # Opens the quoted section, or in other words, enables quote mode(4, 6)
  def parse(<<quote, rest::binary>>, arg, acc, nil) when quote in [?', ?"],
    do: parse(rest, arg, acc, quote)

  # 4
  # Matching quote char.
  # Closes the active quoted section(disables quote mode)
  def parse(<<quote, rest::binary>>, arg, acc, quote),
    do: parse(rest, arg, acc, nil)

  # 5
  # Space, no quote
  # eneds current token and starts a new.
  def parse(<<?\s, rest::binary>>, arg, acc, nil),
    do: parse(String.trim_leading(rest), "", [arg | acc], nil)

  # 6
  # any other character, this is essentially '_' to a case.
  # Appends char to current token.
  def parse(<<c::utf8, rest::binary>>, arg, acc, quote),
    do: parse(rest, <<arg::binary, c>>, acc, quote)
end
