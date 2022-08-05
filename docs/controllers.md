# Controllers

Controllers are responsible for handling incoming requests and returning responses to the client.

A controller's purpose is to receive specific requests for the application. The routing mechanism controls which
controller receives which requests. Frequently, each controller has more than one route, and different routes can
perform different actions.

In order to create a basic controller, we use classes and annotations. Annotations associate classes with required
metadata and enable Dartness to create a routing map (tie requests to the corresponding controllers).

## Routing

In the following example we'll use the `@Controller()` annotation, which is required to define a basic controller.
We'll
specify an optional route path prefix of `cities`. Using a path prefix in a `@Controller()` annotation
allows us to easily group a set of related routes, and minimize repetitive code. For example, we may choose to group a
set of routes that manage interactions with a customer entity under the route `/customers`. In that case, we could
specify the path prefix customers in the `@Controller()`annotation so that we don't have to repeat that portion of the
path for each route in the file.

```dart
@Controller('cities')
class CitiesController {
  @Get()
  static String getCities() async {
    return 'This action returns a list of cities';
  }
}
```

The `@Get()` HTTP request method annotation before the `getCities()` method tells Dartness to create a handler for a
specific
endpoint for HTTP requests. The endpoint corresponds to the HTTP request method (GET in this case) and the route path.
What is the route path? The route path for a handler is determined by concatenating the prefix declared for
the controller, and any path specified in the method's annotation. Since we've declared a prefix for every route (
cities)
,
and haven't added any path information in the annotation, Dartness will map `GET /cities` requests to this handler. As
mentioned,
the path includes both the optional controller path prefix and any path string declared in the request method
annotation.
For example, a path prefix of customers combined with the annotation `@Get('country')` would produce a route mapping for
requests like `GET /cities/country`.

In our example above, when a `GET` request is made to this endpoint, Dartness routes the request to our user-defined
`getCities()` method. Note that the method name we choose here is completely arbitrary. We obviously must declare a
method to bind the route to, but Dartness doesn't attach any significance to the method name chosen.

This method will return a 200 status code and the associated response, which in this case is just a string. Why does
that happen? To explain, we'll first introduce the concept that Dartness employs two different options for manipulating
responses:

| Option                 | Description                                                                                                                                                                                                                                                                                                                                                                      |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Standard (recommended) | Using this built-in method, when a request handler returns a Dart object or array, it will automatically be serialized to JSON. When it returns a Dart primitive type (e.g., String, num, bool), however, Dartness will send just the value without attempting to serialize it. This makes response handling simple: just return the value, and Dartness takes care of the rest. |
| Library-specific       | We can use the library-specific [Shelf response class](https://pub.dev/documentation/shelf/latest/shelf/Response-class.html). With this approach, you have the ability to use the native response handling methods exposed by that object. For example, with Shelf, you can construct responses using code like Response.ok().                                                   |

## Resources

Earlier, we defined an endpoint to fetch the cities resource (**GET** route). We'll typically also want to provide an
endpoint
that creates new records. For this, let's create the **POST** handler:

```dart
@Controller('cities')
class CitiesController {
  @Get()
  static String getCities() async {
    return 'This action returns a list of cities';
  }

  @Post()
  static String postCity(@Body CityRequest city) async {
    return 'This action creates a new city';
  }
}
```

It's that simple. Nest provides annotations for all the standard HTTP methods: `@Get()`, `@Post()`, `@Put()`
, `@Delete()`
, `@Patch()`, `@Options()`, and `@Head()`.

## Status code

As mentioned, the response status code is always 200 by default, except for POST requests which are 201. We can easily
change this behavior by adding the `@HttpCode(...)` annotation at a handler level.

```dart
@Post()
@HttpCode(202)
String get() {
  return 'This method returns status code 202';
}
```

## Headers

To specify a custom response header, you can either use a `@Header()` annotation or a library-specific response object
(eg. `return Response(200, headers: {'content-type': 'application/json'})`).

```dart
@Get()
@Header('content-type', 'application/json')
String get() {
  return 'This method returns a custom content-type header';
}
```

## Route parameters

`@PathParam()` is used to annotate a method parameter (`id` in the example below), and makes the route parameters
available as property of that annotation method parameter inside the body of the method. As seen in the code below, we
can access the id parameter by referencing `id`. You can also pass in a particular parameter token to the annotation,
and then reference the route parameter directly by name in the method body.

```dart
@Controller('cities')
class CitiesController {
  @Get('/<id>')
  static String findById(@PathParam() id) {
    return 'This action returns a city with id: $id';
  }
}
```

## Query

`@QueryParam()` annotation is used to bind a web request parameter to a method parameter, it makes the query parameters
available
as inside the body of the method. In the example below, we can access the query parameter `name` by referencing `name`.

```dart
@Controller('cities')
class CitiesController {
  @Get()
  static String find(@QueryParam() String name) {
    return 'This action returns a the query parameter name: $name';
  }
}
```

Dartness also support name parameters for query parameters. For example, if our query parameter is optional and in some
cases can be also null, we can use as the follow:

```dart

@Controller('cities')
class CitiesController {
  @Get()
  static String find({
    @QueryParam() String? name,
  }) {
    return 'This action returns a the query parameter name: $name';
  }
}
```

## Asynchronicity

Future is a class in dart that allow us to write asynchronous code using the async and await keywords. Dartness handles
future objects and returns the value by the standard method (e.g., `Future<Foo> findAll() async`).

> HINT
>
> Learn more about `async / await` feature [here](https://dart.dev/codelabs/async-await)

Every async function has to return a Future. This means that you can return a deferred value that Dartness will be able
to resolve by itself. Let's see an example of this:

```dart
@Controller('cities')
class CitiesController {
  @Get()
  static String getCities() {
    return 'This action returns a list of cities';
  }
}
```
