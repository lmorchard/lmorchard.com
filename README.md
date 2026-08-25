# lmorchard.com

This repo holds the hand-maintained content for lmorchard.com. There is no build
step. Edit the files in `site/` directly.

## Publish

Push to `main`. The workflow in `.github/workflows/publish.yml` then rsyncs
`site/` to the server.

To publish by hand, use the helper in the
[aerostat02](https://github.com/lmorchard/aerostat02.lmorchard.com) repo:

```bash
make publish SITE=lmorchard.com     # add DRY_RUN=1 to preview
```

Use the flags `-rltvz --omit-dir-times`. Do not use `-a` or `-p`. The site
directory belongs to root, so those two flags exit 23 after they transfer every
file correctly.

## Excluding paths

`lmorchard/about-me` rebuilds the front page every hour. It writes three paths
into the same directory:

- `index.html`
- `index.json`
- `about-me/`

This repo publishes with `rsync --delete` and excludes those three paths. Do not
add them here. If a file is committed here and generated there, every push
replaces the fresh copy with a stale one.

## Rotate the deploy key

`sshd` forces the `DEPLOY_SSH_KEY` secret through `rrsync` and confines it to
`/srv/www/lmorchard.com`. That limit matters because aerostat02 is a Tailscale
node.

1. Make a new key pair.
2. Put the public half in `deploy_keys` on the `lmorchard.com` entry in the
   aerostat02 repo.
3. Run the playbook.
4. Replace the `DEPLOY_SSH_KEY` secret.
