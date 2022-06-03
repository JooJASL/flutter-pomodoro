class Todo {
  final String title;
  final String description;
  bool done;

  /// Difficulty in a scale of 1 to 5
  final int difficulty;
  Todo({
    this.title = 'Todo',
    this.description = 'No description',
    this.done = false,
    this.difficulty = 3,
  });
}
