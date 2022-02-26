class SpeakableString {
  final String displayText;
  final String speechText;

  static const Map<String, String> _natoAlphabet = {
    'a': 'alpha',
    'b': 'bravo',
    'c': 'charlie',
    'd': 'delta',
    'e': 'echo',
    'f': 'foxtrot',
    'g': 'golf',
    'h': 'hotel',
    'i': 'india',
    'j': 'juliet',
    'k': 'kilo',
    'l': 'lima',
    'm': 'mike',
    'n': 'november',
    'o': 'oscar',
    'p': 'papa',
    'q': 'quebec',
    'r': 'romeo',
    's': 'sierra',
    't': 'tango',
    'u': 'uniform',
    'v': 'victor',
    'w': 'whiskey',
    'x': 'x-ray',
    'y': 'yankee',
    'z': 'zulu',
    '1': '1',
    '2': '2',
    '3': 'tree',
    '4': '4',
    '5': '5',
    '6': '6',
    '7': '7',
    '8': '8',
    '9': 'niner',
    '0': '0',
  };

  static String _toNatoString(String input) {
    return input
        .toLowerCase()
        .runes
        .map((e) => _natoAlphabet.containsKey(String.fromCharCode(e))
            ? _natoAlphabet[String.fromCharCode(e)]!
            : String.fromCharCode(e))
        .toList()
        .join(' ');
  }

  static SpeakableString natoizedString({required String displayText}) {
    return SpeakableString(
        displayText: displayText, speechText: _toNatoString(displayText));
  }

  const SpeakableString({required this.displayText, required this.speechText});
}
