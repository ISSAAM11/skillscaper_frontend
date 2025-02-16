part of 'test_request_bloc.dart';

@immutable
sealed class TestRequestState {}

final class TestRequestInitial extends TestRequestState {}

final class TestRequestTokenExpired extends TestRequestState {}

final class TestRequestDataFailed extends TestRequestState {
  final String error;
  TestRequestDataFailed(this.error);
}

final class TestRequestLoadingData extends TestRequestState {}

final class TestRequestRetreved extends TestRequestState {
  final List<TestRequest> testRequest;
  TestRequestRetreved(this.testRequest);
}

// final class TestRequestNotYet extends TestRequestState {
//   final TestRequest testRequest;
//   TestRequestNotYet(this.testRequest);
// }

// final class TestRequestEmpty extends TestRequestState {
//   final TestRequest testRequest;
//   TestRequestEmpty(this.testRequest);
// }
