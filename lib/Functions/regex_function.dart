String normalizInput(String input) {
  input = input.replaceAll(RegExp(r'[ة]'), 'ه');
  input = input.replaceAll(RegExp(r'[أإ]'), 'ا');
  input = input.replaceAll(RegExp(r' '), '');

  return input;
}
