sealed class AppFailure {}

final class ConnectionFailure extends AppFailure {}

final class ServerFailure extends AppFailure {}

final class TimeoutFailure extends AppFailure {}

final class ParseFailure extends AppFailure {}

final class UnknownFailure extends AppFailure {}
