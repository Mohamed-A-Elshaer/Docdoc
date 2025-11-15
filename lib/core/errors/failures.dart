abstract class Failures{
  final String message;
  Failures(this.message);
}

class ServerFailures extends Failures{
  ServerFailures(super.message);

}