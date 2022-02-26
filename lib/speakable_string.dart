class SpeakableString {
  final String displayText;
  final String speechText;

  /// Translates every alphabet character to its NATO pronounciation
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

  /// Contains a map of callsign prefixes with airline names
  static const Map<String, String> _airlineList = {
    'dlh': 'Lufthansa',
    'tui': 'Tui',
  };

  /// Contains a map of route names with pronounciable names
  static const Map<String, String> _routeList = {
    'akanu': 'uhkahnoo',
    'dkb': 'dinkelsbuhl',
    'ereto': 'ereto',
    'inpud': 'input',
    'ibaga': 'ibaga',
    'rodis': 'rodis',
    'sukad': 'sookad',
    'sulus': 'sulus',
    'erl': 'erlangen',
  };

  /// Contains a map of destinations with pronounciable names
  static const Map<String, String> _destinationList = {
    'eddm': 'Munich',
    'eddf': 'Frankfurt',
    'lszh': 'Zurich',
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

  /// Returns a [SpeakableString] that just reads the input text
  static SpeakableString literal({required String displayText}) {
    return SpeakableString(displayText: displayText, speechText: displayText);
  }

  /// Returns a [SpeakableString] that reads the entire input as NATO alphabet
  static SpeakableString natoizedString({required String displayText}) {
    return SpeakableString(
        displayText: displayText, speechText: _toNatoString(displayText));
  }

  /// Returns a [SpeakableString] for a callsign
  static SpeakableString callsign({required String displayText}) {
    for (final airline in _airlineList.keys) {
      if (displayText.toLowerCase().startsWith(airline)) {
        return SpeakableString(
            displayText: displayText,
            speechText: _airlineList[airline]! +
                ' ' +
                _toNatoString(displayText.substring(airline.length)));
      }
    }

    // if we didn't use a special callsign, just speak the entire callsign
    // in NATO alphabet
    return natoizedString(displayText: displayText);
  }

  /// Returns a [SpeakableString] for a specific departure route
  static SpeakableString route({required String displayText}) {
    for (String route in _routeList.keys) {
      if (displayText.toLowerCase().startsWith(route)) {
        return SpeakableString(
            displayText: displayText,
            speechText: _routeList[route]! +
                _toNatoString(displayText.substring(route.length)));
      }
    }

    // if we didn't find the route in our list, try to speak it like regular text
    return SpeakableString(displayText: displayText, speechText: displayText);
  }

  /// Returns a [SpeakableString] for a squawk code
  static SpeakableString squawk({required String displayText}) {
    // prefix with squawk and pronounce the rest in NATO alphabet
    return SpeakableString(
        displayText: displayText,
        speechText: 'squawk ' + _toNatoString(displayText));
  }

  /// Returns a [SpeakableString] for an airport code
  static SpeakableString airport({required String displayText}) {
    if (_destinationList.keys.contains(displayText.toLowerCase())) {
      return SpeakableString(
          displayText: displayText,
          speechText: _destinationList[displayText.toLowerCase()]!);
    }

    // if we don't have a name for the airport, just pronounce it as NATO
    return natoizedString(displayText: displayText);
  }

  const SpeakableString({this.displayText = '', this.speechText = ''});
}
