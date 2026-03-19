import 'package:coding_challenge/data/repository/feed_repository.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

class MockDio extends Mock implements Dio {}
