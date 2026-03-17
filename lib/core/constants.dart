enum FeedSource {
  source1,
  source2;

  String get url => switch (this) {
        FeedSource.source1 =>
          'https://gist.githubusercontent.com/breunibes/6875e0b96a7081d1875ec1bd16c619f1/raw/e991c5d8f37537d917f07ebfafbba0d1708b134b/mock.json',
        FeedSource.source2 =>
          'https://gist.githubusercontent.com/breunibes/bd5b65cf638fc3f67b1007721ac05205/raw/e7f9a4798d446728ba396b869af6b609a562ea03/gistfile1.txt',
      };
}
