# SafeTrack Web on Vercel

The Git repository contains a production Flutter release in `public/`. Vercel serves that directory as-is. Android, iOS, Flutter source and Arduino firmware stay in Git and are outside the served directory.

## Import on an iPhone

1. Open [New Project on Vercel](https://vercel.com/new) in Safari and sign in.
2. Under **Import Git Repository**, select [berrring/tracker1](https://github.com/berrring/tracker1). Grant the Vercel GitHub integration access to this repository if it is missing from the list.
3. Import with these settings. The committed `vercel.json` supplies the build and routing settings.

| Setting | Value |
| --- | --- |
| Framework Preset | Other |
| Root Directory | Repository root, shown as `./` |
| Install Command | Override enabled, leave empty |
| Build Command | Override enabled, leave empty |
| Output Directory | `public` |
| Production Branch | `main` |
| Environment Variables | None |

4. Tap **Deploy**. Copy the URL from the finished deployment. Keep the GitHub connection enabled so pushes to `main` trigger production deployments.

Support for this import and static output configuration is documented by Vercel. [Configure a build](https://vercel.com/docs/builds/configure-a-build) · [Git deployments](https://vercel.com/docs/git)

## Regenerate the web release

Build on a development machine that has Flutter. Commit updated `public/` with the matching source when publishing app changes.

```sh
flutter pub get
flutter gen-l10n
flutter build web --release --no-web-resources-cdn
python tools/prepare_public.py
python -m http.server 8394 --bind 127.0.0.1 --directory public
```

Visit `http://127.0.0.1:8394/`. To open hardware setup directly, use `/#/hardware`. Flutter keeps this route in the hash so browser reload retains it. Vercel serves existing assets first and rewrites extensionless paths to the app. Requests for missing files with extensions retain normal 404 behavior.

For an authenticated CLI deployment run these commands from the repository root. Use the project's Git import for automatic redeploys.

```sh
npx vercel whoami
npx vercel link
npx vercel deploy --prod
```

If `whoami` reports missing credentials, use the Safari import above or authenticate locally with `npx vercel login`.

## After deployment

Open the Vercel URL and reload the app and `/#/hardware`. Check the four demo tabs on phone and desktop and verify that demo preferences survive reload in the same browser. Device contact details are entered only at runtime and sent to the locally selected serial port. iPhone Safari can run the demo and import the repository into Vercel. The USB workflow requires a compatible desktop browser or the local utility.
