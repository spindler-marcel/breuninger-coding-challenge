sealed class FeedFailure {}

final class NetworkFeedFailure extends FeedFailure {}

final class TimeoutFeedFailure extends FeedFailure {}

final class ParseFeedFailure extends FeedFailure {}

final class UnknownFeedFailure extends FeedFailure {}
