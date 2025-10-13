enum Moods {
  happy('Happy', '😊'),
  joyful('Joyful', '😀'),
  sad('Sad', '😢'),
  angry('Angry', '😡'),
  calm('Calm', '😌'),
  surprised('Surprised', '😲'),
  loved('Loved', '😍'),
  laughing('Laughing', '😂'),
  thoughtful('Thoughtful', '🤔'),
  tired('Tired', '😴'),
  excited('Excited', '🤩'),
  scared('Scared', '😨');

  const Moods(this.label, this.mood);
  final String label;
  final String mood;
}
