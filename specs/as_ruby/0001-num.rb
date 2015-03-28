
it     "returns the original value"
input  5.0
output 5.0

it     "fails w/ArgumentError if not a Numeric"
input  :sym
raises ArgumentError, /Not a Numeric: :sym/
