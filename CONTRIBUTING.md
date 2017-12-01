# CONTRIBUTING

Bug reports and pull requests are welcome on GitHub at
https://github.com/hashrocket/tilex.

### Issues

To open a new issue, visit our [Github Issues
page](https://github.com/hashrocket/tilex/issues).

### Pull Requests

To open a pull request, please follow these steps:

1. [Fork](https://help.github.com/articles/fork-a-repo/) it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make some changes with accompanying tests
4. Ensure the entire test suite passes (`mix test`)
5. Stage the relevant changes (`git add --patch`)
6. Commit your changes (`git commit -m 'Add some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create new Pull Request

All pull requests are evaluated for style using
[Credo](https://github.com/rrrene/credo). Run it to check your code, or leave
us a note if the recommendation doesn't make sense:

```
$ mix credo
```

Adding a database migration? Ensure it can be rolled back with this command:

```
$ mix ecto.twiki
```
