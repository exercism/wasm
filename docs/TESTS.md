# Tests

Execute the tests with:

```shell
npm run test
```

You can also run Jest in "watch" mode, which will re-run your tests automatically when you save changes to the code or test module:

```shell
npm run watch
```

## Understanding Skip Tests

The skip method instructs the test suite to not run a test, this function could be used also under the aliases: `it.skip(name, fn)` or `xit(name, fn)` or `xtest(name, fn)`

- Why they are skipped ?

To enable users to concentrate on one test at a time and enable one by one as they evolve the solution.

- How to enable them ?

Change `xtest` to `test`.

```javascript
test("title cased phrases", () => {
  expect(Acronyms.parse("Portable Network Graphics")).toEqual("PNG");
});
```
