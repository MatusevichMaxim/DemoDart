# Step-by-Step TDD Instructions: Creating a Simple Flutter Application
In this example, we'll develop a simple counter application using the Test-Driven Development approach. 
Follow the steps below - each includes:
- 🛠 Define what needs to be done. If necessary, break down complex tasks into smaller ones
- 🔴 Write a "red" test for an elementary task
- ✅ Implement the functionality (the test should become "green")
- ♻️ (optional) Refactoring

PS. For testing navigation, I used functional UI tests, which isn't the best solution. It's better to test the screen type directly, and if necessary, test and document the widget UI itself through [Snapshot tests][snt].

### Demo App Description
Screen 1 - "Home" header, Open Screen button. <br/>
Screen 2 - "Counter" header, 2 buttons -/+, 1 label with counter, back button "<". <br/>
When you press Open Screen, screen 2 with the counter opens. The +/- buttons can increase or decrease the counter by 1. The value cannot go below 0. The "<" button returns to the previous screen.

## Step 1. Creating an entry point. First screen.
So, when creating a project, we have an entry/start point in the main.dart class in the runApp function. 
Besides this, a default widget may already be created through the builder.
```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp();
}
```
Next, we need to create the first screen. <br/>
This will be `home_screen.dart` and its test file `home_test.dart`. Now we need to somehow add the "Open Screen" button to the Home screen and display it all. <br/>
Since we're using the TDD approach, we first need to write a "red" test and make it green.
> For reference: <br/>
> Flutter uses two main types of tests: `testWidgets` and `test`. The choice between them depends on what exactly we want to test. <br/>
> `test()` (Unit Tests) <br/>
> - Used for unit testing individual Dart functions, methods, or classes. <br/>
> - Designed to test business logic and algorithms that don't depend on UI. <br/>
> 
> `testWidgets()` (Widget Tests) <br/>
> - Used for testing widgets. <br/>
> - Designed to test widget UI, their appearance and behavior during interaction. <br/>

Each test contains a description of what is being tested. There are different ways to describe this, but I recommend following this templates: <br/>
1. `What Is Being Tested` __ `Conditions` __ `Expected Result`
2. `Should` __ `Expected Behavior` __ `When` __ `Conditions`

The main goal is to make it possible to understand what's happening in the code without opening the class by looking at the tests.

So, let's write our first test. Let's call it: "Should display Home Screen when MyApp execute"
```dart
void main() {
  testWidgets('Should display Home Screen when MyApp execute', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Open Screen'), findsOneWidget);
  });
}
```
Here we immediately checked if the text Open Screen is present on the screen, as well as the Home title.

To run tests, we type `flutter test` in the console (all tests will run), or click the `Run` button for a specific test/group of tests. <br/>
As expected, the test failed `══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞══`. <br/>
**Great**, now we can add the logic itself in the main.dart file, as well as configure the home_screen.dart screen.
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: HomeScreen());
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Center(
          child: ElevatedButton(
            child: Text('Open Screen'),
          ),
        ),
      );
}
```
Now we restart the tests and they become green, hooray!

> This maneuver allowed us to fix certain elements on the screen, such as the button text and title. Any change that affects the behavior of this element will fail our test and we'll understand that something went wrong.

PS. *as I already mentioned, for testing UI (specifically the placement of elements down to pixels, their color, even animation) is tested using Snapshot tests.
We wrote a UI test that can test the content of UI elements and their behavior. But since we're using MVVM, this testing will happen at the ViewModel level.*

## Step 2. Implementing navigation.
Now we need to make it so that when clicking on `Open Screen`, we go to screen 2. On the second screen, there will be a "<" button that will return us to the first screen. In addition, we can immediately add counter buttons and a label to the second screen to test it right away with a widget test.

Let's create a test for the first case. This is functionality of the Home screen itself, so the test will be inside `home_test.dart`.
```dart
void main() {
  testWidgets('Navigates to CounterScreen when "Open Screen" is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    await tester.tap(find.text('Open Screen'));
    await tester.pumpAndSettle();

    expect(find.text('Counter'), findsOneWidget);
    expect(find.text('+'), findsOneWidget);
    expect(find.text('-'), findsOneWidget);
  });
}
```
> PS. Here we described that when clicking the button, we expect a screen with certain elements to appear. Although for testing navigation, it's better to use type checking.

As expected, the test is red. Now we can add the necessary logic so that the test doesn't fail. <br/>
Let's create `counter_screen.dart` and `counter_test.dart`. We'll add basic UI for the counter and implement navigation logic in `home_screen.dart`
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CounterScreen())),
            child: Text('Open Screen'),
          ),
        ),
      );
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Counter')),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () => {}, child: Text('-')),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('0', style: TextStyle(fontSize: 24)),
              ),
              ElevatedButton(onPressed: () => {}, child: Text('+')),
            ],
          ),
        ),
      );
}
```
The "<" button was added automatically when implementing push navigation. By the way, we can check its presence through a Snapshot test, thereby covering it with tests, or use other strategies.

However, the action when pressing the "<" button can still be checked through the good old UI test.
```dart
void main() {
  testWidgets('Navigates back to HomeScreen when back arrow is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    await tester.tap(find.text('Open Screen'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Open Screen'), findsOneWidget);
  });
}
```
In this case, we used the code-first principle, which doesn't quite align with TDD, so it's recommended to implement testing of basic navigations before implementing them in the project (This requires additional research).

We restart the tests and they've turned green. 🎉

## Step 3. Adding counter logic.
First, we need to create a new `CounterModel` that will manage our counter. And we immediately need to ensure that the initial counter value is 0. This is important because this variable is mutable and could be in an unexpected state at initialization. Let's write a test:
```dart
test('Initial counter value should be 0', () {
  final counter = CounterModel();
  expect(counter.value, 0);
});
```
After this, we can add the corresponding code to the model. Even though it won't immediately be red (because the default value of int = 0), **we've documented** this value in the tests.
```dart
class CounterModel {
  int _value = 0;
  int get value => _value;
}
```
Now let's describe in the tests the behavior when pressing the `+` button. We want the counter to increase by 1.
Let's write such a test:
```dart
test('Increment should increase value by 1', () {
  final counter = CounterModel();
  counter.increment();
  expect(counter.value, 1);
});
```
In it, we add a new increment function that's responsible for increasing the value. This will allow us to control the model from outside. Now we can add the corresponding logic to the model to make the test build.
```dart
class CounterModel {
  int _value = 0;
  int get value => _value;

  void increment();
}
```
Now let's add `value++` to make the test green:
```dart
class CounterModel {
  // ... 
  void increment() => value++;
}
```
Next, let's add similar logic for subtraction. First, we write a test:
```dart
test('Decrement should decrease value by 1', () {
  final counter = CounterModel();
  counter.increment();
  counter.decrement();
  expect(counter.value, 0);
});
```
We add the necessary function to the model. We try to run the test - it's red. We modify the logic so that the test becomes green.
```dart
class CounterModel {
  // ... 
  void decrement() => value--;
}
```
Remember, we had a condition that the counter shouldn't go below 0? The first thing to do is write a test describing this condition. Something like this:
```dart
test('Decrement should not allow value below 0', () {
  final counter = CounterModel();
  counter.decrement();
  expect(counter.value, 0);
});
```
To make the test green, we need to add the following logic:
```dart
class CounterModel {
  // ... 
  void decrement() {
    if (_value > 0) _value--;
  }
}
```

### And that's it!
We've written a simple application that we've tried to cover as much as possible with tests. Yes, the approach to UI testing is different and deserves a separate branch and a more complex example. In addition, some of the functionality that we're testing here at the UI layer can be tested at other layers in the MVVM architecture, which can move our UI testing either to Snapshots or to the QA team altogether.

[snt]: <https://medium.com/@pablonicoli21/unveiling-snapshot-tests-a-deep-dive-into-flutters-golden-tests-bf8acc744df8>
