class Question {
  final String question;
  final List<List> options;

  const Question({required this.question, required this.options});
}

const List<Question> QUESTIONS = [
  Question(
    question: "I read about ____ books in a year",
    options: [
      ["1-5", 10],
      ["10 and more", 20],
      ["20 and more", 30],
      ["30 and more", 40],
      ["50 and more", 50],
    ],
  ),
  Question(
    question: "In a week, I read for about",
    options: [
      ["2-4 hours", 10],
      ["5-8 hours", 20],
      ["8-12 hours", 30],
      ["12-14 hours", 40],
      ["14 hours and more", 50],
    ],
  ),
  Question(
    question: "The genre that best sums up my  personality is",
    options: [
      ["Historical Fiction", 10],
      ["Classics", 20],
      ["Literary Fiction ", 30],
      ["Biographies and Autobiographies", 40],
      ["Science Fiction", 50],
    ],
  ),
  Question(
    question: "The best setting I like to read in is",
    options: [
      ["library", 10],
      ["lounge or a cafe", 20],
      ["in a lawn chair in my backyard", 30],
      ["under a tree, in a park", 40],
      ["near a bonfire", 50],
    ],
  ),
  Question(
    question: "I love to talk about what I'm reading with ...",
    options: [
      ["a discussion room, where I can hear different perspectives", 10],
      ["my book club - the discussions are fun!", 20],
      ["a bookish friend or two, people I trust in my circle", 30],
      ["anyone who will listen!", 40],
    ],
  ),
  Question(
    question: "I love to read because",
    options: [
      ["I like the fantasy world", 10],
      ["a great book has the power to connect me to my fellow readers", 20],
      ["books help me make a difference in the world", 30],
      ["I get to learn new ideas", 40],
      [
        "a book is a powerful way to experience the world from someone else’s point of view",
        50
      ],
    ],
  ),
  Question(
    question: "Book clubs",
    options: [
      ["I have never been a part of any book clubs", 10],
      ["I have started multiple book clubs", 20],
      ["I am excited to be part of multiple book clubs", 30],
    ],
  ),
];
