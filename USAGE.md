# Usage

We love seeing forks of Today I Learned in production! Here's a basic guide
for running and customizing your own version of the site.

### Development setup

Of course before putting in production you probably want to give a try to this project, just follow these
instructions and you will be able to run on Tilex within a few minutes:

1 - [Install Elixir](https://elixir-lang.org/install.html) && [Install Node.js](https://nodejs.org/en/download/)  
2 - [Clone the repository](https://github.com/hashrocket/tilex)  
3 - Run `cp .env{.example,}` on the root directory of the newly cloned project to create a `.env` file.

Now you must create a database for Tilex on PostgreSQL, after this update `DATABASE_URL` in the `.env` file in the root directory.  
**OBS:** By default the expected database name is `tilex_dev`, but you can change it changing the file `config/dev.exs`.

An example: `export DATABASE_URL=postgres://dbuser:secretpass@127.0.0.1:5432/tilex_dev`

4 - Run `make && make setup server`

5 - Go to "http://localhost:4000"

6 - Now, you must obtain some OAuth credentials for allowing people to log in, the current supported login method is OAuth with Google.

So, go to ["Google Developers Console"](https://console.developers.google.com/projectcreate) and create a new project, after this you will have a `client_secret` and a `client_id`, so now you must update the `.env` file and set `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` env vars:

```
export GOOGLE_CLIENT_ID=[someid].apps.googleusercontent.com
export GOOGLE_CLIENT_SECRET=your_google_app_secret
```

OBS: Don't forget to add `http://localhost:4000/auth/google/callback` as a valid redirect URI at your Google Project's configuration.

7 - You must whitelist some emails at this point, so open `.env` and add your email in the env var `GUEST_AUTHOR_WHITELIST`, ex:  
`GUEST_AUTHOR_WHITELIST=user1@gmail.com,user2@gmail.com`

7.1 - Optionally, if your company is using "Google for Bussiness" it's better to set the env var `HOSTED_DOMAIN` with your company domain for `Gmail/Google` accounts. For example, if your company addresses are hosted as `user.surname@myawesomecompany.com` you must set `HOSTED_DOMAIN=myawesomecompany.com` and this will allow **ALL** users with a Google account associated to this domain to login in on the application as an admin.

8 - Access: `http://localhost:4000/admin`, you will be redirect to Google OAuth page. Select the email associated with the configurations at the last step and authorize the login flow. You bill redirect back to `http://localhost:4000/auth/google/callback` and the application will signup you as a valid user.

9 - Access: `http://localhost:4000/posts/new` and start to track your and yours company learnings. Maybe you learned how to setup an Elixir project today, or perharps how to setup a project on Google Developers...

10 - Enjoy it ;)

10.1 - And if you deploy it to production, let us know by adding your TIL instance URL in the section "Forks in Production" of this file.

---

### Deployment

---

### Style

Feel free to get creative! The layout, colors, fonts, assets, and meta tags
we've chosen should only serve as a starting point.

---

### Attribution

Please link to Hashrocket somewhere on the main page! Today I Learned is an
open-source project, and support from the community helps inspire continued
development.

Here's an example of an easy way to link to us:

```elixir
# lib/your_app/templates/layout/app.html.eex

Today I Learned is an open-source project by <a href="https://hashrocket.com">Hashrocket</a>.
Check out the <a href="https://github.com/hashrocket/tilex">source code</a> to make your own!
```

---

### Forks in Production

Have you deployed TIL to production? Please open a pull request or contact
dev@hashrocket.com to be recognized. Here are a few examples:

- https://til.energizedwork.com/
- https://til.brianemory.com/
- https://selleo.com/til

Thank you to everybody who has forked and contributed.
