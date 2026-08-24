# lmorchard.com

The apex site — hand-maintained static content, no build step.

## Provenance

This repo was created on 2026-08-24 by a **one-time** import of the
`lmorchard.com` S3 bucket, which until then was the only copy of this content.
Unlike [blog.lmorchard.com](https://github.com/lmorchard/blog.lmorchard.com),
there was never a generator repo for the apex site: files were uploaded to S3 by
hand and served from there behind CloudFront.

## Two publishers, and this repo is only one of them

**The front page is not in this repo.** `lmorchard/about-me` generates
`index.html`, `index.css`, `index.json`, `bio.md`, `llms.txt`, `resume.pdf` and
`assets/`, and rsyncs them straight into `/srv/www/lmorchard.com` on a schedule.
That content turns over hourly and nobody wants 24 commits a day of regenerated
JSON, so it is deliberately never committed anywhere.

What lives here is everything else — the hand-maintained remainder: `images/`,
`about-me/` (legacy assets, unrelated to the generator despite the name),
`webfinger/`, `.well-known/`, `browserid/`, the 2017 archive, `resume.html`,
`pubkey.asc`, `subs.opml`, `favicon.ico`. There is no build step; `site/` is
edited directly.

The import commit at the root of this history *does* contain the generated
files, because the S3 bucket it was mirrored from held both and nothing in a
bucket distinguishes build output from an upload. They were removed in the
following commit. That first commit is left intact on purpose: it is the only
record of what the bucket contained before the cutover.

Because two publishers write one directory, each owns a fixed set of paths:

- **about-me** rsyncs its seven paths with **no `--delete`** — it owns seven
  files in a directory of 250-odd and would otherwise erase the rest.
- **this repo** rsyncs with `--delete` but `--exclude`s those same seven, which
  also protects them from deletion. Without that, a push here would remove the
  live front page within minutes.

That duplicated list is a coupling between the two repos. about-me's workflow
fails its own build if its output stops matching, so the breakage surfaces
where the change was made instead of on the live site an hour later. Change the
two lists together.

The import was verified byte-for-byte against the bucket at the time it was
taken: 254 files, 176,688,773 bytes, 0 differences via `rclone check --checksum`.

**After that import, this repo is authoritative and the bucket is not upstream
of anything.** The constraint is about direction, not about S3: if the bucket is
ever brought back into use it is a *publish target* only, downstream of this
repo, the same way aerostat02 is. What is ruled out permanently is syncing S3
back down into the repo — `rclone sync` deletes whatever the destination has and
the source lacks, so a pull run after any edit would silently revert the site to
its 2026-08-24 state. That is why the helper script in the aerostat02 repo
publishes and has no pull counterpart.

## Layout

Content lives in `site/`, not at the repo root, so that repo-level files (this
README, any CI config) sit outside the published tree.

`site/index.html` is the whole page. Everything else is assets it references
(`about-me/`, `images/`, `assets/`) plus standalone files (`resume.pdf`,
`pubkey.asc`, `subs.opml`, `webfinger/`, `.well-known/`).

Subdirectories have no `index.html` of their own — `/about-me/` returned 404 on
S3 and is expected to keep doing so. It is an asset directory, not a page.

## Publishing

Served from `/srv/www/lmorchard.com` on aerostat02 by Caddy.

### From CI

`.github/workflows/publish.yml` rsyncs `site/` on every push to `main`, minus
the paths about-me owns. The
`DEPLOY_SSH_KEY` secret is forced through `rrsync` by an `authorized_keys`
`command=` on the server and scoped to `/srv/www/lmorchard.com` alone, so it can
write one directory and nothing else — which matters because aerostat02 is a
Tailscale node. Rotation is: regenerate the key, update `deploy_key` in the
aerostat02 repo's `caddy_sites` entry, re-run the playbook, replace the secret.

### By hand

With the helper in the
[aerostat02.lmorchard.com](https://github.com/lmorchard/aerostat02.lmorchard.com)
repo:

```bash
make publish SITE=lmorchard.com            # or DRY_RUN=1 to preview
```

which wraps:

```bash
rsync -rltvz --omit-dir-times --delete \
  ./site/ lmorchard@aerostat02.lmorchard.com:/srv/www/lmorchard.com/
```

The flags are not arbitrary — `-p` and `-a` both fail with exit 23 against the
root-owned site directory. See the "Static sites" section of the aerostat02
README.

## Removed content

`2024/08/craig-maloney-octodon-capture-20240804.tgz` (135 MB) was a Mastodon
user archive shared from this site in 2024 and always intended to be temporary.
It was removed on 2026-08-24 and is not part of this repo's history. Nothing in
the site linked to it. A copy remains in the S3 bucket and in a separate backup;
it accounted for 86% of the old site's bytes, which is why the published site is
~35 MB rather than ~170 MB.
