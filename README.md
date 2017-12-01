# Tilex - Today I Learned in Elixir

[![CircleCI](https://circleci.com/gh/hashrocket/tilex.svg?style=svg)](https://circleci.com/gh/hashrocket/tilex)

> Today I Learned is an open-source project by the team at
> [Hashrocket](https://hashrocket.com/) that catalogues the sharing &
> accumulation of knowledge as it happens day-to-day. Posts have a 200-word
> limit, and posting is open to any Rocketeer as well as select friends of the
> team. We hope you enjoy learning along with us.

This site was open-sourced as a window into our development process, as well as
to allow people to experiment with the site on their own and contribute to the
project.

We originally implemented Tilex as
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
$ mix ecto.setup
$ npm install --prefix assets
$ mix phx.server
```

If you'd like to skip the database seeds, run `mix ecto.create && mix
ecto.migrate` in place of `mix ecto.setup`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

To serve the app at a different port, include the `PORT` environment
variable when starting the server:

```
$ PORT=4444 mix phx.server
```

To set environmental variables, copy the example file:

```
$ cp .env{.example,}
```

Set your environmental variables in the new file, and then source them:

```
$ source .env
```

### Authentication

Authentication is managed by Omniauth and Google. See the
[omniauth-google-oauth2 README](https://github.com/zquestz/omniauth-google-oauth2/blob/master/README.md)
and [Google Oauth 2 docs](https://developers.google.com/identity/protocols/OAuth2WebServer) for
setup instructions. To allow users from a domain, set those configurations in
your environment:

```
# .env

export GOOGLE_CLIENT_ID="your-key.apps.googleusercontent.com"
export GOOGLE_CLIENT_SECRET="yoursecret"
export HOSTED_DOMAIN="your-domain.com"
```

Once set, visit [`localhost:4000/admin`](http://localhost:4000/admin) and log
in with an email address from your permitted domain.

Tilex creates a new user on the first authentication, and then finds that same
user on subsequent authentications.

### Testing

Wallaby relies on
[ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/); install
it via your method of choice.

Run the tests with:

```
$ mix test
```

### Deployment

Hashrocket's Tilex is deployed to [Heroku](https://www.heroku.com/). These are
Hashrocket's deployed instances:

- Staging: https://tilex-staging.herokuapp.com
- Production: https://til.hashrocket.com

Database migrations require telling Heroku how many pools to use. Here's an
example:

```
$ heroku run "POOL_SIZE=2 mix ecto.migrate"
```

### Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) for more information.

### Code of Conduct

This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the [Contributor
Covenant](http://contributor-covenant.org) code of conduct. Please see [CODE OF
CONDUCT](CODE_OF_CONDUCT.md) for more information.

### Usage

We love seeing forks of Today I Learned in production! Please consult
[USAGE](USAGE.md) for guidelines on appropriate styling and attribution.

### License

Tilex is released under the [MIT License](http://www.opensource.org/licenses/MIT). Please
see [LICENSE](LICENSE.md) for more information.

---

### About

[![Hashrocket logo](https://hashrocket.com/hashrocket_logo.svg)](https://hashrocket.com)

Tilex is supported by the team at [Hashrocket, a multidisciplinary design and
development consultancy](https://hashrocket.com). If you'd like to [work with
us](https://hashrocket.com/contact-us/hire-us) or [join our
team](https://hashrocket.com/contact-us/jobs), don't hesitate to get in touch.
