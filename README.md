# Step-by-Step TDD Instructions: Creating a Simple Flutter Application
In this example, we'll develop a simple counter application using the Test-Driven Development approach. 
Follow the steps below - each includes:
- 🛠 Define what needs to be done. If necessary, break down complex tasks into smaller ones
- 🔴 Write a "red" test for an elementary task
- ✅ Implement the functionality (the test should become "green")
- ♻️ (optional) Refactoring

PS. For testing navigation, I used functional UI tests, which isn't the best solution. It's better to test the screen type directly, and if necessary, test and document the widget UI itself through [Snapshot tests][snt].



[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [snt]: <https://medium.com/@pablonicoli21/unveiling-snapshot-tests-a-deep-dive-into-flutters-golden-tests-bf8acc744df8>
