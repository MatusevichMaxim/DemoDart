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

[snt]: <https://medium.com/@pablonicoli21/unveiling-snapshot-tests-a-deep-dive-into-flutters-golden-tests-bf8acc744df8>
