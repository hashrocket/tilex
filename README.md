# Tilex - Today I Learned in Elixir

[![CircleCI](https://circleci.com/gh/hashrocket/tilex.svg?style=svg)](https://circleci.com/gh/hashrocket/tilex) [![Coverage Status](https://coveralls.io/repos/github/hashrocket/tilex/badge.svg?branch=master)](https://coveralls.io/github/hashrocket/tilex?branch=master)

> Today I Learned is an open-source project by the team at
> [Hashrocket][hashrocket] that catalogues the sharing & accumulation of
> knowledge as it happens day-to-day. Posts have a 200-word limit, and posting
> is open to any Rocketeer as well as select friends of the team. We hope you
> enjoy learning along with us.

This site was open-sourced in as a window into our development process, as well as
to allow people to experiment with the site on their own and contribute to the
project.

We originally implemented Tilex as [_hr-til_][hr-til], a Ruby on Rails app.

For updates, follow us on [Twitter][twitter] and subscribe to our monthly
[newsletter][newsletter].

### Installation

If you are creating your own version of the site, [fork][fork] the repository
and clone your fork:

```shell
$ git clone https://github.com/<your_github>/tilex
$ cd tilex
```

Then, install [Erlang][erlang], [Elixir][elixir], Node, and PostgreSQL.
[asdf][asdf] can do this in a single command:

```shell
$ asdf install
```

From here, we recommend using `make`:

```shell
$ make
$ make setup server
```

To do everything by hand, source your environment variables, install
dependencies, and start the server:

```shell
$ cp .env{.example,}
$ source .env
$ mix deps.get
$ mix ecto.setup
$ npm install --prefix assets
$ mix phx.server
```

Want to start with an empty database? Skip the seeds by running `mix ecto.create && mix
ecto.migrate` in place of `mix ecto.setup`.

Now you can visit http://localhost:4000 from your browser.

To serve the application at a different port, include the `PORT` environment
variable when starting the server:

```shell
$ PORT=4444 mix phx.server
```

### Authentication

Authentication is managed by Ueberauth and Google. See the [ueberauth_google
README][ueberauth_google] and [Google Oauth 2 docs][oauth_google] for
instructions. To allow users from a domain and/or comma-separated allowlist,
set those configurations in your environment:

```shell
# .env

export GOOGLE_CLIENT_ID="your-key.apps.googleusercontent.com"
export GOOGLE_CLIENT_SECRET="yoursecret"
export HOSTED_DOMAIN="your-domain.com"
export GUEST_AUTHOR_ALLOWLIST="joedeveloper@otherdomain.com, suziedeveloper@freelancer.com"
```

Once set, visit http://localhost:4000/admin and log in with an email address
from your permitted domain.

Tilex creates a new user on the first authentication, and then finds that same
user on subsequent authentications.

### Testing

Wallaby relies on [ChromeDriver][chromedriver]; install it via your method of
choice.  Then, run tests with:

```shell
$ make test
```

or:

```shell
$ mix test
```

### Deployment

Hashrocket's Tilex is deployed to Heroku. These are Hashrocket's deployed
instances:

- Staging: https://tilex-staging.herokuapp.com
- Production: https://til.hashrocket.com

This project contains Mix tasks to deploy our instances; use as follows:

```shell
$ mix deploy <environment>
```

### Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) for more information. Thank you to
all of our [contributors][contrib].

### Code of Conduct

This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the [Contributor Covenant][cc] code of
conduct. Please see [CODE OF CONDUCT](CODE_OF_CONDUCT.md) for more information.

### Usage

We love seeing forks of Today I Learned in production! Please consult
[USAGE](USAGE.md) for guidelines on appropriate styling and attribution.

### License

Tilex is released under the [MIT License][mit].opensource.org/licenses/MIT). Please
see [LICENSE](LICENSE.md) for more information.

---

### About

[![Hashrocket logo](https://hashrocket.com/hashrocket_logo.svg)][hashrocket]

Tilex is supported by the team at [Hashrocket, a multidisciplinary design and
development consultancy][hashrocket] If you'd like to [work with us][hire-us]
or [join our team][join-us], don't hesitate to get in touch.

[asdf]: https://github.com/asdf-vm/asdf
[cc]: http://contributor-covenant.org
[chromedriver]: https://sites.google.com/a/chromium.org/chromedriver/
[contrib]: https://github.com/hashrocket/tilex/graphs/contributors
[elixir]: https://elixir-lang.org/
[erlang]: https://www.erlang.org/
[fork]: https://help.github.com/articles/fork-a-repo/
[hashrocket]: https://hashrocket.com/
[hire-us]: https://hashrocket.com/contact-us/hire-us
[hr-til]: https://github.com/hashrocket/hr-til
[join-us]: https://hashrocket.com/contact-us/jobs
[mit]: http://www.opensource.org/licenses/MIT
[newsletter]: https://www.getrevue.co/profile/til
[oauth_google]: https://developers.google.com/identity/protocols/OAuth2WebServer
[twitter]: https://twitter.com/hashrockettil
[ueberauth_google]: https://github.com/ueberauth/ueberauth_google
