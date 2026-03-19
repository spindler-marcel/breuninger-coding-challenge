import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/core/failures/app_failure.dart';
import 'package:coding_challenge/core/result.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/data/repository/feed_repository_implementation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late MockDio dio;
  late FeedRepositoryImplementation repository;

  setUp(() {
    dio = MockDio();
    repository = FeedRepositoryImplementation(dio: dio);
  });

  Response<dynamic> okResponse(dynamic data) =>
      Response(data: data, statusCode: 200, requestOptions: RequestOptions());

  DioException dioException(DioExceptionType type) =>
      DioException(type: type, requestOptions: RequestOptions());

  group('getFeed', () {
    test('returns Success with parsed items', () async {
      final feedJson = [
        {
          'type': 'teaser',
          'id': 1,
          'attributes': {'url': 'https://example.com'},
        },
        {
          'type': 'slider',
          'id': 2,
          'attributes': {
            'items': [
              {'id': 10, 'url': 'https://example.com/sub'},
            ],
          },
        },
      ];
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => okResponse(feedJson));

      final result = await repository.getFeed(source: FeedSource.source1);

      expect(result, isA<Success<List<FeedItem>>>());
      final items = (result as Success<List<FeedItem>>).value;
      expect(items.length, 2);
      expect(items[0], isA<TeaserModel>());
      expect(items[1], isA<SliderModel>());
    });

    test('parses raw JSON string body', () async {
      const raw =
          '[{"type":"teaser","id":1,"attributes":{"url":"https://example.com"}}]';
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => okResponse(raw));

      final result = await repository.getFeed(source: FeedSource.source1);

      expect(result, isA<Success<List<FeedItem>>>());
      expect((result as Success).value.length, 1);
    });

    test('skips items with unknown type', () async {
      final feedJson = [
        {'type': 'unknown', 'id': 99, 'attributes': <String, dynamic>{}},
        {
          'type': 'teaser',
          'id': 1,
          'attributes': {'url': 'https://example.com'},
        },
      ];
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => okResponse(feedJson));

      final result = await repository.getFeed(source: FeedSource.source1);

      expect((result as Success).value.length, 1);
    });

    test(
      'returns Failure(ParseFailure) when response body is not a list',
      () async {
        when(
          () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
        ).thenAnswer((_) async => okResponse({'key': 'value'}));

        final result = await repository.getFeed(source: FeedSource.source1);

        expect(result, isA<Failure>());
        expect((result as Failure).failure, isA<ParseFailure>());
      },
    );

    test('returns Failure(ConnectionFailure) on connection error', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenThrow(dioException(DioExceptionType.connectionError));

      final result = await repository.getFeed(source: FeedSource.source1);

      expect(result, isA<Failure>());
      expect((result as Failure).failure, isA<ConnectionFailure>());
    });

    test('returns Failure(TimeoutFailure) on connection timeout', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenThrow(dioException(DioExceptionType.connectionTimeout));

      final result = await repository.getFeed(source: FeedSource.source1);

      expect((result as Failure).failure, isA<TimeoutFailure>());
    });

    test('returns Failure(TimeoutFailure) on receive timeout', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenThrow(dioException(DioExceptionType.receiveTimeout));

      final result = await repository.getFeed(source: FeedSource.source1);

      expect((result as Failure).failure, isA<TimeoutFailure>());
    });

    test('returns Failure(ServerFailure) on bad HTTP response', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenThrow(dioException(DioExceptionType.badResponse));

      final result = await repository.getFeed(source: FeedSource.source1);

      expect((result as Failure).failure, isA<ServerFailure>());
    });

    test('returns Failure(UnknownFailure) on unexpected exception', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenThrow(Exception('unexpected'));

      final result = await repository.getFeed(source: FeedSource.source1);

      expect((result as Failure).failure, isA<UnknownFailure>());
    });

    test('returns Cancelled when DioException type is cancel', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenThrow(dioException(DioExceptionType.cancel));

      final result = await repository.getFeed(source: FeedSource.source1);

      expect(result, isA<Cancelled>());
    });

    test('calls correct URL for source1', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => okResponse([]));

      await repository.getFeed(source: FeedSource.source1);

      verify(
        () => dio.get(
          FeedSource.source1.url,
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);
    });

    test('calls correct URL for source2', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => okResponse([]));

      await repository.getFeed(source: FeedSource.source2);

      verify(
        () => dio.get(
          FeedSource.source2.url,
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);
    });
  });

  group('loadBrandItems', () {
    const itemsUrl = 'https://example.com/brands';

    test('returns Success with parsed sub-items', () async {
      final responseJson = {
        'items': [
          {'id': 1, 'url': 'https://example.com/1', 'gender': 'male'},
          {'id': 2, 'url': 'https://example.com/2', 'gender': 'female'},
        ],
      };
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => okResponse(responseJson));

      final result = await repository.loadBrandItems(itemsUrl: itemsUrl);

      expect(result, isA<Success<List<SliderSubItemModel>>>());
      final items = (result as Success<List<SliderSubItemModel>>).value;
      expect(items.length, 2);
      expect(items[0].gender, 'male');
    });

    test('parses raw JSON string body', () async {
      const raw = '{"items":[{"id":1,"url":"https://example.com/1"}]}';
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => okResponse(raw));

      final result = await repository.loadBrandItems(itemsUrl: itemsUrl);

      expect((result as Success).value.length, 1);
    });

    test('returns Failure(ParseFailure) when response is not a map', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => okResponse([1, 2, 3]));

      final result = await repository.loadBrandItems(itemsUrl: itemsUrl);

      expect((result as Failure).failure, isA<ParseFailure>());
    });

    test('returns Failure(ParseFailure) when items key is missing', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => okResponse({'other': 'data'}));

      final result = await repository.loadBrandItems(itemsUrl: itemsUrl);

      expect((result as Failure).failure, isA<ParseFailure>());
    });

    test(
      'returns Failure(ParseFailure) when items value is not a list',
      () async {
        when(
          () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
        ).thenAnswer((_) async => okResponse({'items': 'not_a_list'}));

        final result = await repository.loadBrandItems(itemsUrl: itemsUrl);

        expect((result as Failure).failure, isA<ParseFailure>());
      },
    );

    test('returns Cancelled when request is cancelled', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenThrow(dioException(DioExceptionType.cancel));

      final result = await repository.loadBrandItems(itemsUrl: itemsUrl);

      expect(result, isA<Cancelled>());
    });

    test('returns Failure(TimeoutFailure) on send timeout', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenThrow(dioException(DioExceptionType.sendTimeout));

      final result = await repository.loadBrandItems(itemsUrl: itemsUrl);

      expect((result as Failure).failure, isA<TimeoutFailure>());
    });

    test('calls the provided itemsUrl', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => okResponse({'items': <dynamic>[]}));

      await repository.loadBrandItems(itemsUrl: itemsUrl);

      verify(
        () => dio.get(itemsUrl, cancelToken: any(named: 'cancelToken')),
      ).called(1);
    });
  });

  group('cancel', () {
    test('new requests succeed after cancel() is called', () async {
      when(
        () => dio.get(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => okResponse([]));

      repository.cancel();
      final result = await repository.getFeed(source: FeedSource.source1);

      expect(result, isA<Success>());
    });
  });
}
