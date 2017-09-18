# CONTRIBUTING

Bug reports and pull requests are welcome on GitHub at
https://github.com/hashrocket/tilex.

Here's a list of everybody who has contributed to Tilex (updated 9/15/17):

```
     2	Brian Dunn and Chris Erin and Jake Worth and Vidal Ekechukwu
     5	Brian Dunn and Chris Erin and Vidal Ekechukwu
     1	Brian Dunn and Vidal Ekechukwu
    33	Chris Erin
     2	Chris Erin and Dorian Karter
     1	Chris Erin and Ifu Aniemeka
    24	Chris Erin and Jake Worth
    30	Christopher Erin
     1	Cody Roberts
    19	Dorian Karter
     5	Hashrocket Workstation
   286	Jake Worth
     2	Jake Worth and Taylor Mock
     8	Josh Branchaud and Jake Worth
     1	José Valim
     1	Lexin Gong
    67	Taylor Mock
     1	chriserin
    30	hashrocketeer
    22	jbranchaud
```

To contribute to the project, please follow these steps:

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
