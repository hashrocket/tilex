# tilex - Today I Learned in Elixir

[![Build Status](https://travis-ci.org/hashrocket/tilex.svg)](https://travis-ci.org/hashrocket/tilex)

> tilex is an open-source project by the team at
> [Hashrocket](https://hashrocket.com/) that catalogues the sharing &
> accumulation of knowledge as it happens day-to-day. Posts have a 200-word
> limit, and posting is open to any Rocketeer as well as select friends of the
> team. We hope you enjoy learning along with us.

This site was open-sourced as a window into our development process, as well as
to allow people to experiment with the site on their own and contribute to the
project.

We originally implemented _tilex_ as
[_hr-til_](https://github.com/hashrocket/hr-til), a Ruby on Rails app.

### Installation

If you are creating your own version of the site,
[fork](https://help.github.com/articles/fork-a-repo/) the repository.

Then install the [Phoenix
Dependencies](http://www.phoenixframework.org/docs/installation) as well as
PostgreSQL.

Next, follow these setup steps:

```
$ git clone https://github.com/hashrocket/tilex
$ cd tilex
$ mix deps.get
$ mix ecto.create
$ mix ecto.migrate
$ npm install
$ mix phoenix.server
```

Optionally, seed the database with:

```
$ mix run priv/repo/seeds.exs
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Testing

Wallaby relies on PhantomJS, install it:

```
$ npm install -g phantomjs
```

Run the tests with:

```
$ mix text
```

### Contributing

1. [Fork](https://help.github.com/articles/fork-a-repo/) it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make some changes with accompanying tests
4. Ensure the entire test suite passes (`mix test`)
5. Stage the relevant changes (`git add --patch`)
6. Commit your changes (`git commit -m 'Add some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create new Pull Request

Bug reports and pull requests are welcome on GitHub at
https://github.com/hashrocket/tilex. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### License

tilex is released under the [MIT License](http://www.opensource.org/licenses/MIT).

---

### About

[![Hashrocket logo](https://hashrocket.com/hashrocket_logo.svg)](https://hashrocket.com)

tilex is supported by the team at [Hashrocket, a multidisciplinary design and
development consultancy](https://hashrocket.com). If you'd like to [work with
us](https://hashrocket.com/contact-us/hire-us) or [join our
team](https://hashrocket.com/contact-us/jobs), don't hesitate to get in touch.
