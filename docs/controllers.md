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
import 'dart:async';

import 'package:dartness/bind/annotation/controller.dart';
import 'package:dartness/bind/annotation/get.dart';

@Controller('cities')
class CitiesController {
  @Get()
  String getCities() async {
    return 'This action returns a list of cities';
  }
}
```

The `@Get()` HTTP request method decorator before the `getCities()` method tells Dartness to create a handler for a
specific
endpoint for HTTP requests. The endpoint corresponds to the HTTP request method (GET in this case) and the route path.
What is the route path? The route path for a handler is determined by concatenating the prefix declared for
the controller, and any path specified in the method's decorator. Since we've declared a prefix for every route (cities)
,
and haven't added any path information in the decorator, Dartness will map `GET /cities` requests to this handler. As
mentioned,
the path includes both the optional controller path prefix and any path string declared in the request method decorator.
For example, a path prefix of customers combined with the decorator `@Get('country')` would produce a route mapping for
requests like `GET /cities/country`.

In our example above, when a `GET` request is made to this endpoint, Dartness routes the request to our user-defined
`getCities()` method. Note that the method name we choose here is completely arbitrary. We obviously must declare a
method to bind the route to, but Dartness doesn't attach any significance to the method name chosen.

This method will return a 200 status code and the associated response, which in this case is just a string. Why does
that happen? To explain, we'll first introduce the concept that Dartness employs two different options for manipulating
responses:

| Option                 | Description                                                                                                                                                                                                                                                                                                                                                                      |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Standard (recommended) | Using this built-in method, when a request handler returns a Dart object or array, it will automatically be serialized to JSON. When it returns a Dart primitive type (e.g., String, num, bool), however, Dartness will send just the value without attempting to serialize it. This makes response handling simple: just return the value, and Dartness takes care of the rest. |
| Library-specific       | We can use the library-specific [Shelf response class](https://pub.dev/documentation/shelf/latest/shelf/Response-class.html). With this approach, you have the ability to use the native response handling methods exposed by that object. For example, with Shelf, you can construct responses using code like Response.ok().                                                   |

## Resources

Earlier, we defined an endpoint to fetch the cities resource (**GET** route). We'll typically also want to provide an
endpoint
that creates new records. For this, let's create the **POST** handler:

```dart
import 'dart:async';

import 'package:dartness/bind/annotation/controller.dart';
import 'package:dartness/bind/annotation/get.dart';

@Controller('cities')
class CitiesController {
  @Get()
  String getCities() async {
    return 'This action returns a list of cities';
  }

  @Post()
  String postCity(@Body CityRequest city) async {
    return 'This action creates a new city';
  }
}
```

It's that simple. Nest provides decorators for all the standard HTTP methods: `@Get()`, `@Post()`, `@Put()`, `@Delete()`
, `@Patch()`, `@Options()`, and `@Head()`.

## Asynchronicity

Future is a class in dart that allow us to write asynchronous code using the async and await keywords. Dartness handles
future objects and returns the value by the standard method (e.g., `Future<Foo> findAll() async`).

> HINT
>
> Learn more about `async / await` feature [here](https://dart.dev/codelabs/async-await)

Every async function has to return a Future. This means that you can return a deferred value that Dartness will be able
to resolve by itself. Let's see an example of this:

```dart
import 'dart:async';

import 'package:dartness/bind/annotation/controller.dart';
import 'package:dartness/bind/annotation/get.dart';

@Controller('cities')
class CitiesController {
  @Get()
  Future<String> getCities() async {
    return 'This action returns a list of cities';
  }
}
```