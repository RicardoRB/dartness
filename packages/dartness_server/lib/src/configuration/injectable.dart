/// A metadata annotation used to mark a class as available to the dependency injection system.
///
/// This annotation can be applied to classes which should be instantiated or managed by the DI framework.
/// Marking a class with `@Injectable` indicates to the DI framework that an instance of the class 
/// can be created and provided to other parts of the application that require it.
///
/// Usage:
/// ```
/// @Injectable()
/// class MyService {
///   MyService();
/// }
/// ```
///
/// The DI framework will then manage the lifecycle of the instantiated `MyService` objects,
/// allowing for dependency management and injection into other classes that depend on `MyService`.
/// 
class Injectable {
  /// Creates a new instance of `Injectable`.
  ///
  /// This constructor is typically not invoked directly, but rather the annotation is placed on the class
  /// definition to be managed by the DI framework.
  const Injectable();
}
