abstract class SplashPresenter {
  Stream<String> get navigateToStream;

  Future<void> loadCurrent({int durationInSeconds});
}