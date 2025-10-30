# Tilex - Today I Learned in Elixir

[![CI](https://github.com/hashrocket/tilex/actions/workflows/ci.yml/badge.svg)](https://github.com/hashrocket/tilex/actions/workflows/ci.yml)

> Today I Learned is an open-source project by the team at [Hashrocket][hashrocket] that catalogues the sharing & accumulation of knowledge as it happens day-to-day. Posts have a 200-word limit, and posting is open to any Rocketeer as well as select friends of the team. We hope you enjoy learning along with us.

Today I Learned was open-sourced to:
- provide a window into our development process
- allow people to experiment with the site on their own
- allow folks to contribute back to the project

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

Then, install [Erlang][erlang], [Elixir][elixir], Node, and PostgreSQL. [mise][mise] can do this in a single command:

```shell
$ mise install
```

The first step in the setup is to clone the `.env` file:

```shell
$ cp .env.example .env
```

#### Option 1 - Makefile

From here, we recommend using `make` which will print out the help message with all dev tools we have:

```shell
$ make

Makefile  console    ## Opens the App console.
Makefile  help       ## Shows this help.
Makefile  outdated   ## Shows outdated packages.
Makefile  server     ## Start the App server.
Makefile  setup      ## Setup the App.
Makefile  test       ## Run the test suite.
Makefile  update     ## Update dependencies.
```

To **setup** the project and start the **server** you can:

```shell
$ make setup server
```

Now you can visit http://localhost:4000 from your browser.

#### Option 2 - Manual

All Makefile tasks will **automatically** load the `.env` file, so if you want to run any command manually you may have to load that file first:

```shell
source .env
```

Source your environment variables, install
dependencies, seed the db, and start the server:

```shell
$ mix deps.get
$ mix ecto.setup
$ npm install --prefix assets
$ mix phx.server
```

Now you can visit http://localhost:4000 from your browser.

#### Seeds the local Database

**Optionally**, And if you want to run a seeds task to populate your local database with some fake data you can run:

```shell
$ DATE_DISPLAY_TZ=America/Chicago mix ecto.seeds
```

### AI Tooling

#### Creating TILs: from AI via MCP

If you are an user of TIL and wants to write TIL posts with some help of your AI tooling you can use our MCP servers. Log in into your TIL service, then go to the **profile** page. There's a box there to generate an MCP API Key that's needed to authenticate. We added a few helper code snippets to help you to setup the TIL MCP into your tooling.

<img width="551" height="1065" alt="image" src="https://github.com/user-attachments/assets/3f99129e-0f91-4621-83d1-bae1d250f5f7" />

After the MCP is setup correctly you can start asking your AI to write TILs. The response on each new TIL should be a link where you'd have to review the title, content and channel and publish it.

#### Developing TIL code: Improving AI Context

So in case you want to use your AI tools to improve the TIL code we've added the [usage_rules](https://hexdocs.pm/usage_rules) into the project and we also added [tidewave](https://hexdocs.pm/tidewave) served as a MCP.

```
http://localhost:4000/tidewave/mcp
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
choice. Then, run tests with:

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

<a href="https://hashrocket.com/">
  <p align="center">
    <img src="https://hashrocket.com/hashrocket_logo.svg" />
  </p>
</a>

Tilex is supported by the team at [Hashrocket][hashrocket], a multidisciplinary design and
development consultancy. If you'd like to work with us, don't hesitate to [contact us][hire-us] today!

[mise]: https://github.com/jdx/mise
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
[newsletter]: https://hashrocket.com/#newsletter-subscribe-form
[oauth_google]: https://developers.google.com/identity/protocols/OAuth2WebServer
[twitter]: https://twitter.com/hashrockettil
[ueberauth_google]: https://github.com/ueberauth/ueberauth_google
