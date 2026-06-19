## 🐦 Mastodon with modern birdsite-like UI

![Mastodon](https://img.shields.io/badge/mastodon-v4.6.0+-6364FF?style=for-the-badge&logo=mastodon&logoColor=white) ![SCSS](https://img.shields.io/badge/SCSS-CC6699?style=for-the-badge&logo=sass&logoColor=white) [![Build Status](https://img.shields.io/github/actions/workflow/status/ronilaukkarinen/mastodon-bird-ui/styles.yml?style=for-the-badge&logo=github)](https://github.com/ronilaukkarinen/mastodon-bird-ui/actions/workflows/styles.yml) <a href="https://github.com/sponsors/ronilaukkarinen"><img src="https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white" alt="GitHub Sponsor" height="28px"></a> <a href="https://ko-fi.com/rolle"><img src="https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white" alt="Ko-fi" height="28px"></a>

Blasphemy! Yes, I know, but I just had to do this. I wanted to see if it's possible to get <a href="https://github.com/mastodon/mastodon">Mastodon</a> default user interface to resemble Twitter, but be a lot better than it ever was.

**Please note** that this started as a personal experiment _for fun_, but then got more serious.

**See my [original Mastodon post](https://mementomori.social/@rolle/109984108360395822).<br>
Read the blog post: [The day I decided to build my own "Twitter"](https://rolle.design/the-day-i-decided-to-build-my-own-twitter).**

## [Live demo on mementomori.social](https://mementomori.social)

![mbui](https://github.com/ronilaukkarinen/mastodon-bird-ui/assets/1534150/8006e3ba-a902-40f5-9047-048b29f075db)

## Table of contents

1. [Why would anyone want Mastodon to look like Twitter?](#why-would-anyone-want-mastodon-to-look-like-twitter)
2. [Features](#features)
3. [List of instances that use Mastodon Bird UI](#list-of-instances-that-use-mastodon-bird-ui)
4. [Installation for Mastodon instance admins](#installation-for-mastodon-instance-admins)
5. [Make Mastodon Bird UI as optional by integrating it as 'Site theme' in settings for all users](#make-mastodon-bird-ui-as-optional-by-integrating-it-as-site-theme-in-settings-for-all-users)
6. [Installation for regular users, contributing and testing](#installation-for-regular-users-contributing-and-testing)
7. [Development](#development)
8. [Updating instructions](#updating-instructions)
9. [Other tweaks and customizations](#other-tweaks-and-customizations)
    1. [Status bar color on Android PWA](#status-bar-color-on-android-pwa)
    2. [Hide translate link for multiple languages](#hide-translate-link-for-multiple-languages)
    3. [Thread lines](#thread-lines)
    4. [Micro-interactions](#micro-interactions)
10. [FAQ](#faq)
    1. [I want to make changes to the UI, can I do that?](#i-want-to-make-changes-to-the-ui-can-i-do-that)
    2. [Can you implement feature X?](#can-you-implement-feature-x)
    4. [Why don't you just create an app?](#why-dont-you-just-create-an-app)
    5. [Why don't you just run Mastodon Bird UI in a separate URL?](#why-dont-you-just-run-mastodon-bird-ui-in-a-separate-url)
    6. [Is the advanced web interface styled](#is-the-advanced-web-interface-styled)
    7. [Why the admin interface is not styled?](#why-the-admin-interface-is-not-styled)
    8. [Can you add feature x?](#can-you-add-feature-x)
    9. [Can you make it look like this by default?](#can-you-make-it-look-like-this-by-default)
    10. [How to get to settings or faves on mobile?](#how-to-get-to-settings-or-faves-on-mobile)
    11. [Automatic dark/light mode possible?](#automatic-darklight-mode-possible)
    12. [I like it so much, why it can't be the default Mastodon UI](#i-like-it-so-much-why-it-cant-be-the-default-mastodon-ui)
11. [Goals](#goals)
12. [Accessibility](#accessibility)
    1. [ How to install an Accessible version built for people with serious vision impairment](#how-to-install-an-accessible-version-built-for-people-with-serious-vision-impairment)

## Why would anyone want Mastodon to look like Twitter?

Because you can? Let's face it, we're kinda used to it, Mastodon already resembles the birdsite. Twitter UI is not bad, it's just that it's not for everyone. Twitter (in my opinion) made some bad choices with the new UI for example with the typography, so in a sense I wanted to see if I could make Mastodon look **like Twitter, but better**.

This is why I have defaulted Mastodon deep purple colors in this "theme", if you will. If you really want the vanilla birdsite-look, please modify the colors yourself.

![image](https://github.com/ronilaukkarinen/mastodon-bird-ui/assets/1534150/4e405e65-f5b7-4fe2-a172-5a620ba8743a)

![224368120-5f7bddc9-1702-4279-b297-35a4829e8a3b](https://user-images.githubusercontent.com/1534150/227730434-8a649484-d46c-4b5a-8137-930a302e54d8.png)

Here are some of the UI things Mastodon Bird UI is trying to solve (read [the Mastodon post](https://mementomori.social/@rolle/110139191307581764)):

[![image](https://user-images.githubusercontent.com/1534150/233774924-4506cf63-06f2-49e1-9c66-00f145a854b4.png)](https://mementomori.social/@rolle/110139191307581764)

### More screenshots

- [Dark version on mobile](https://user-images.githubusercontent.com/1534150/225091661-004080da-58c6-4f66-8d1a-9510cf656980.png)
- [Light version on mobile](https://user-images.githubusercontent.com/1534150/227730439-f4408917-f92f-4424-a3c6-35169af967bd.jpg)
- [Dark version on Linux desktop](https://user-images.githubusercontent.com/1534150/224481675-fa165053-30a4-4530-a2f4-ecc4ea08af4c.png)
- [Dark version of the profile on Linux desktop](https://user-images.githubusercontent.com/1534150/225982793-89843f18-e2e5-46bc-b265-138f8ed460ca.png)
- [Light version on Linux desktop](https://user-images.githubusercontent.com/1534150/227730450-c1b82e2c-8ab3-4474-84fc-b9d3422cdc8d.png)
- [Dark profile on macOS desktop](https://user-images.githubusercontent.com/1534150/234549643-3551cb2c-34c8-43bd-be27-3a9932f6be1d.png)
- [Light version on macOS desktop](https://user-images.githubusercontent.com/1534150/234549763-dc1f5216-a4bb-4577-b27e-7d84d1b6a82d.png)
- [Twitter colors on desktop (outdated)](https://user-images.githubusercontent.com/1534150/223725571-b7f8ef41-212c-476c-9006-4e7cb2ddc062.png)
- [Advanced web interface with multiple columns](https://github-production-user-asset-6210df.s3.amazonaws.com/1534150/238149036-aba154be-dd2c-43b0-9e41-aaea54908eb8.png)

## Features

As this is CSS-only, they are not really "features" but more like aesthetic changes.

- Respects the profile **Site theme** setting and sets dark/light based on this alone
- Subtle deep purple ribbon in the right corner for private messages
- CSS variables for everything
- Threaded replies (limited, see issue [#4](https://github.com/ronilaukkarinen/mastodon-bird-ui/issues/4#issuecomment-1493274306))
- Avatars on the left in feed view
- Unified transparent backgrounds
- Dark patterns for dropdowns and other pop overs like emoji picker
- Tinted deep purple, subtle beautiness
- Action bar in the bottom on mobile
- Micro-interaction in the like/favourite icon (see more about [this](#micro-interactions))
- Circling boost animation
- Support for RTL languages
- Hide lists by default, show them on hover
- Carefully polished UI with hand picked/designed icons based on open source versions of Iconoir, Ionicons and Feather
- Show added follows in green, indicate unfollow with red
- Show added to list in green, indicate removing with red

## List of instances that use Mastodon Bird UI

The following instances have enabled Mastodon Bird UI for their users, based on [this](https://mementomori.social/@rolle/110677863997761494) inquiry. Do you use this theme? Let me know or send a PR that adds your instance.

| **Instance**                                                             | **Implementation method** | **Theme name**   | **User count** | **Default** |
|--------------------------------------------------------------------------|---------------------------|------------------|----------------|-------------|
| [mementomori.social](https://mementomori.social/explore)                 | Site theme                | Mastodon Bird UI | 100+           | Yes         |
| [dvm.community](https://dmv.community/explore)                           | Custom CSS                | N/A              | 200+           | Yes         |
| [muri.network](https://muri.network/explore)                             | Site theme                | Mastodon Bird UI | 100+           | Yes         |
| [suomi.social](https://suomi.social/explore)                             | Custom CSS                | N/A              | 10+            | Yes         |
| [mstdn.social](https://mstdn.social/explore)                             | Site theme                | Elephant         | 40000+         | No          |
| [bolha.one](https://bolha.one/explore)                                   | Custom CSS                | N/A              | 10+            | Yes         |
| [indieweb.social](https://indieweb.social/explore)                       | Custom CSS                | N/A              | 1900+          | Yes         |
| [egirl.social](https://egirl.social/about)                               | Custom CSS                | N/A              | 1              | Yes         |
| [qdon.space](https://qdon.space/about)                                   | Site theme                | Mastodon Bird UI | 1100+          | No          |
| [bakedbean.xyz](https://bakedbean.xyz/explore)                           | Custom CSS                | N/A              | 100+           | Yes         |
| [wien.rocks](https://wien.rocks/explore)                                 | Site theme                | BirdUI           | 1100+          | No          |
| [climatejustice.global](https://climatejustice.global/explore)           | Site theme                | BirdUI           | 100+           | No          |
| [climatejustice.social](https://climatejustice.social/explore)           | Site theme                | BirdUI           | 1800+          | No          |
| [climatejustice.rocks](https://climatejustice.rocks/explore)             | Site theme                | BirdUI           | 1              | No          |
| [fedi.at](https://fedi.at/explore)                                       | Site theme                | BirdUI           | 160+           | No          |
| [mtg.garden](https://mtg.garden/explore)                                 | Site theme                | BirdUI           | 20+            | No          |
| [social.fairphone.community](https://social.fairphone.community/explore) | Site theme                | BirdUI           | 5              | No          |
| [kawakawa.fun](https://kawakawa.fun/explore)                             | Custom CSS                | N/A              | 1              | Yes         |
| [mastodonsuomi.fi](https://mastodonsuomi.fi/explore)                     | Custom CSS                | N/A              | 20+            | Yes         |
| [mastodon.ktachibana.party](https://mastodon.ktachibana.party/explore)   | Site theme                | Bird UI          | 100+           | No          |
| [techhub.social](https://techhub.social/explore)                         | Site theme                | Elephant         | 14000+         | No          |
| [social.noleron.com](https://social.noleron.com/explore)                 | Site theme                | Elephant         | 10+            | Yes         |
| [masto.es](https://masto.es/explore)                                     | Site theme                | Bird UI          | 5400+          | Yes         |
| [mast.lat](https://mast.lat/explore)                                     | Modified Custom CSS       | N/A              | 1900+          | Yes         |
| [tkz.one](https://tkz.one/explore)                                       | Modified Custom CSS       | N/A              | 3500+          | Yes         |
| [mastodonsweden.se](https://mastodonsweden.se/explore)                   | Custom CSS                | N/A              | 130+           | Yes         |
| [mindly.social](https://mindly.social/explore)                           | Site theme                | Elephant         | 4800+          | No          |
| [vmst.io](https://vmst.io/explore)                                       | Site theme                | Elephant         | 650+           | No          |
| [some.tehy.fi](https://some.tehy.fi/explore)                             | Custom CSS                | N/A              | 3              | Yes         |
| [pug.ninja](https://pug.ninja/explore)                                   | Custom CSS                | N/A              | 1              | Yes         |
| [aus.social](https://aus.social/explore)                                 | Site theme                | Elephant         | 5700+          | No          |
| [tyrol.social](https://tyrol.social/explore)                             | Site theme                | BirdUI           | 40+            | No          |
| [social.ferrocarril.net](https://social.ferrocarril.net/explore)         | Custom CSS                | N/A              | 20+            | Yes         |
| [social.braydmedia.de](https://social.braydmedia.de/explore)             | Custom CSS                | N/A              | 1              | Yes         |
| [mastodon.sg](https://mastodon.sg)                                       | Custom CSS                | N/A              | 100+           | Yes         |
| [krassestegang.social](https://krassestegang.social/explore)             | Site theme                | Elephant         | 3              | Yes         |
| [artsculture.media](https://artsculture.media/explore)                   | Site theme                | Mastodon Bird UI | 60+            | No          |
| [furry.energy](https://furry.energy/explore)                             | Site theme                | Elephant         | 90+            | Yes         |
| [vkl.world](https://vkl.world/explore)                                   | Modified Custom CSS       | N/A              | 2000+          | Yes         |
| [duk.space](https://duk.space/explore)                                   | Site theme                | Bird UI          | 80+            | No          |
| [supebase.com](https://supebase.com)                                     | Site theme                | Bird UI Modified | 1              | Yes         |
| [buddyverse.xyz](https://buddyverse.xyz)                                 | Site theme                | Mastodon Bird UI | 6+             | Yes         |
| [mastodon.bsd.cafe](https://mastodon.bsd.cafe/)                          | Site theme                | Mastodon Bird UI | 70+            | Yes         |
| [jkpg.rocks](https://jkpg.rocks/)                                        | Site theme                | Mastodon Bird UI | 2+             | Yes         |
| [convo.casa](https://convo.casa)                                         | Site theme                | Mastodon Bird UI | 5000+          | No          |
| [social.kryta.app](https://social.kryta.app)                             | Custom CSS                | Mastodon Bird UI | <100           | Yes         |
| [social.vivaldi.net](https://social.vivaldi.net)                         | Site theme                | Mastodon Bird UI | 6700+          | No          |
| [wxw.moe](https://wxw.moe)                                               | Site theme                | Mastodon Bird UI | 3500+          | Yes         |
| [mastodon.com.pl](https://mastodon.com.pl)                               | Site theme                | Mastodon Bird UI | 100+           | No          |
| [mastodon.sg](https://mastodon.sg)                                       | Custom CSS                | Mastodon Bird UI | 100+           | Yes         |
| [FaithTree.social](https://faithtree.social)                             | Site theme                | Mastodon Bird UI | 19+            | Yes         |
| [mustard.blog](https://mustard.blog)                                     | Site theme                | Mastodon Bird UI | 2000+          | Yes         |
| [c.im](https://c.im)                                                     | Site theme                | Mastodon Bird UI | 2000+          | No          |
| [datasci.social](https://datasci.social)                                 | Custom CSS                | Mastodon Bird UI | 80+            | Yes         |
| [billys.mom](https://billys.mom)                                         | Custom CSS                | N/A              | 10+            | Yes         |

## Installation for Mastodon instance admins

1. Copy the contents of `dist/mastodon-bird-ui.css` and paste it to the **Custom CSS** in the Appearance settings in your instance (https://_yourinstance_/admin/settings/appearance). This single file covers both single-column and multiple-columns (advanced web interface) layouts.

   Other prebuilt variants live in `dist/` for Custom CSS users: `mastodon-bird-ui-stars.css` (a yellow Twitter-style **star** favourite instead of the heart), `mastodon-bird-ui-light.css`, `mastodon-bird-ui-accessible.css` and `mastodon-bird-ui-accessible-plus.css`. Use whichever one you prefer. Rebuild a variant with `npx parcel build src/<entry>.scss --dist-dir dist` (for example `src/mastodon-bird-ui-stars.scss`).

![Screen-Shot-2023-03-31-13-25-52](https://user-images.githubusercontent.com/1534150/229111630-c8975708-134b-4887-b259-a87857193387.png)

## Make Mastodon Bird UI as optional by integrating it as 'Site theme' in settings for all users

Mastodon Bird UI can be integrated as a **Site theme** for all instance users as optional.

**Please note**: This requires Mastodon v4.6.0+ and modifies Mastodon's styles directory. Do this at your own risk! I recommend testing in a development environment first.

![image](https://github.com/ronilaukkarinen/mastodon-bird-ui/assets/1534150/b30f19e2-2835-4d92-b40d-cac9922f64b3)

If you'd like a different branding for your instance like "Elephant" without any [mention of birds](https://github.com/ronilaukkarinen/mastodon-bird-ui/issues/30), use [Bird UI Theme Admins](https://github.com/mstdn/Bird-UI-Theme-Admins) by [@stux](https://mstdn.social/@stux).

### Using the install script

Clone this repository and run the install script:

```bash
git clone https://github.com/ronilaukkarinen/mastodon-bird-ui.git
cd mastodon-bird-ui
npm install
sudo bash scripts/install-to-mastodon.sh --path /path/to/mastodon
```

The script will:
- Copy Bird UI source files to `app/javascript/styles/mastodon-bird-ui/`
- Generate theme entry points for all variants (dark, light, contrast, accessible, etc.)
- Update `config/themes.yml` with the new themes

After running the script, rebuild assets and restart services:

```bash
# Production
RAILS_ENV=production bundle exec rails assets:precompile
sudo systemctl restart mastodon-web

# Development
RAILS_ENV=development bundle exec rails assets:precompile
```

Users can now select Bird UI themes in Preferences > Appearance.

## Installation for regular users

1. Install [Live CSS Editor](https://github.com/webextensions/live-css-editor) or [Stylus](https://chrome.google.com/webstore/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne?hl=en) browser extension
2. Copy the contents of `dist/mastodon-bird-ui.css`
3. Paste the CSS into the browser extension
4. Click the pin icon so the styles persist for the domain

## Development and contributing

### Testing on any Mastodon instance (including mastodon.social)

The easiest way to test changes without running a local Mastodon instance:

1. Fork and clone this repository
2. Install [nvm](https://github.com/nvm-sh/nvm) and run `nvm install` to get the correct Node.js version
3. Install dependencies: `npm install`
4. Build CSS: `npm run build`
5. Install [Stylus](https://chrome.google.com/webstore/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne?hl=en) browser extension
6. Navigate to any Mastodon instance (e.g., mastodon.social)
7. Paste the contents of `dist/mastodon-bird-ui.css` into the extension
8. Edit SCSS files in `src/`, run `npm run build`, and refresh to see changes

### Local development with hot-reload

For the best development experience with instant CSS injection, use a local Mastodon instance:

#### Prerequisites

- [nvm](https://github.com/nvm-sh/nvm) installed, then run `nvm install` to get the correct Node.js version
- A running Mastodon instance (default: `mementomori.test`, configure in `bs-config.js`)
- Dependencies: `npm install`

#### Start development

```bash
npm run dev
```

This will:
1. **Parcel** - Watch your CSS files and recompile on changes to `dist/`
2. **Browsersync** - Proxy your Mastodon instance and inject the compiled CSS

Open `http://localhost:3999` instead of your Mastodon instance directly. Any changes you make to SCSS files will be reflected immediately without page reload.

### Available commands

```bash
# Development with hot-reload (watch + browsersync + lint)
npm run dev                      # Default dark theme
npm run dev:stars                # Stars animation variant
npm run dev:accessible           # Accessible variant
npm run dev:accessible-plus      # Accessible plus variant
npm run dev:accessible-hide-finnish  # Accessible + hide Finnish translate

# Individual tools
npm run watch                    # Parcel watch only
npm run sync                     # Browsersync only
npm run lint                     # Run stylelint

# Production
npm run build                    # Build for Custom CSS (minified, with version banner)
npm run clean                    # Remove dist/ and .parcel-cache/
```

### Configuration

- **Parcel configuration**: `.parcelrc` - Controls CSS compilation and optimization
- **Browsersync configuration**: `bs-config.js` - Configure proxy settings, injection rules, and other options

If your Mastodon instance is not at `mementomori.test`, edit `bs-config.js` and change the `proxy` value.

### Contributing

1. Fork this repository
2. Create a feature branch: `git checkout -b my-feature`
3. Make your changes in `src/`
4. Test using one of the methods above
5. Commit your changes
6. Push to your fork and open a Pull Request

## Updating instructions

If you are using **Custom CSS**, just copy and paste the new version of `dist/mastodon-bird-ui.css` to **Custom CSS** textarea in the Appearance settings in your instance (https://_yourinstance_/admin/settings/appearance).

If you are using Mastodon Bird UI as a site theme, update to the latest version:

```bash
cd mastodon-bird-ui
git pull
sudo bash scripts/install-to-mastodon.sh --path /path/to/mastodon
```

Then rebuild assets and restart:

```bash
RAILS_ENV=production bundle exec rails assets:precompile
sudo systemctl restart mastodon-web
```

## Other tweaks and customizations

While Mastodon Bird UI works perfectly fine out of the box, there are some things you might want to modify to make it look even better.

### Status bar color on Android PWA

Edit [this line](https://github.com/mastodon/mastodon/blob/f4f3e2b46e619fcc2eda48c2eb66c517b4f466aa/app/views/layouts/application.html.haml#L24) and recompile assets with `yarn build:production`.

### Hide translate link for multiple languages

If you're a polyglot like me, you can hide the translate link on other languages than default by adding this at the end of the **Custom CSS** (this example is for people who understand Finnish and German):

```css
.status__content__text[lang="de"].translate ~ .status__content__read-more-button,
.status__content__text[lang="fi"].translate ~ .status__content__read-more-button {
  display: none;
}
```

### Thread lines

There is support for threads available for the nightly version since ([see PR #24549](https://github.com/mastodon/mastodon/pull/24549)) and if you want to use the native threaded lines, just use main branch from Mastodon. There's a related [issue](https://github.com/mastodon/mastodon/issues/19570#issuecomment-1493057424) about it that I have commented. You should also see the discussion on a Mastodon Bird UI issue [#4](https://github.com/ronilaukkarinen/mastodon-bird-ui/issues/4#issuecomment-1493274306).

### Micro-interactions

There are two micro-interaction animations in this UI, both are inspired by the Twitter's original UI animation. The star is originally a work of
a Twitter designer [Brian Waddington](https://dribbble.com/shots/1884504-Twitter-Fav). The heart is by Twitter design team. Both animations have been completely re-created by me, frame by frame. The star animation itself contains 100 hand made frames.

<img width="720" height="465" alt="gif-20260613-221105" src="https://github.com/user-attachments/assets/e6056177-6277-4952-ae56-0d7a44d2ba32" />

Bird UI uses the **heart** by default. The **star** variant lives in `src/micro-interactions/_star.scss`; forks can expose a setting to switch to it, and Custom CSS users can swap it in.

**Native favourite animations:** if your Mastodon already ships its own favourite animation as a real SVG component, like the [mementomori.social fork (PR #10)](https://github.com/mementomori-social/mastodon/pull/10) which renders a native star/heart burst (heart by default, star as an opt-in setting), the install script detects it and Bird UI steps aside for the favourite button so the native animation shows. Bird UI keeps styling the navigation and the sidebar/notification favourite icons, so nothing else changes and no configuration is needed.

## FAQ

I get many questions about this UI, so here I'm going to answer to them.

### I want to make changes to the UI, can I do that?

Of course! This is all open source, customizable and extendable. You can fork this repo and make changes to the CSS. You can also use the **Custom CSS** box in {yourinstance.social/admin/settings/appearance} to add your own styles directly.

### Can you implement feature X?

Not everything is possible via CSS only. In fact, some of the tweaks I had to do to the Mastodon core, see my fork [here](https://github.com/mastodon/mastodon/compare/v4.1.2...ronilaukkarinen:mastodon:mementomori-social-mods) and the tweaks above.

However, even if they were possible, I won't implement all requests. My opinionated choices are not the only answer, but I'm not willing to add every possible customization to this UI as default. I want to keep it simple and extendable.

### Why don't you just create an app?

I'm not a software developer. I'm a front end developer (and a bit of a designer) and my expertise is in CSS, UX and HTML. I don't know how to create a Mastodon app for Android, iOS or web and while I know a bit of python, JavaScript, Ruby and other programming languages, I don't have time and patience to create an app from scratch right now.

There are other people who are working on magnificent apps for Mastodon, so I'm not going to reinvent the wheel. I simply like the Twitter-ish UI and Mastodon default web back-end and I want to have these combined on my instance. As CSS is the language I live and breathe daily, it's really easy and fast for me to create a UI like this.

Also, Mastodon web UI works as an app already. See my answer [here](https://mementomori.social/@rolle/110242274361461278).

### Why don't you just run Mastodon Bird UI in a separate URL?

See the previous answer. Mastodon Bird UI is not an app, it's a CSS file that you can use with any Mastodon instance. You don't need to run a separate instance just for this UI and perhaps you shouldn't either.

If you really would want this to run in a separate URL, you could in theory set up another nginx host for a subdomain and just use [ngx_http_sub_module](http://nginx.org/en/docs/http/ngx_http_sub_module.html) to load up a CSS file. I haven't tried this and it might not be even possible, but it's worth a try.

### Is the advanced web interface styled?

Yes! The unified `mastodon-bird-ui.css` covers both single-column and multiple-columns (advanced web interface) layouts automatically.

### Why the admin interface is not styled?

We don't spend much time in the admin interface and it's not a priority for me to style it. It would mean too much work and it's not worth it right now.

### Can you add feature x?

Mastodon Bird UI is CSS only, so I can't add any features. Please send your Mastodon feature ideas [here](https://github.com/mastodon/mastodon/issues).

### Can you make it look like _this_ by default?

Probably yes, but I'm not here to please everyone. Suggestions like [this](https://mementomori.social/@rolle/110658189531503982) are very important and there has been many pull requests and issues already that have helped me to make the UI better. While saying this I'm not going to implement every single suggestion, because there are too many different opinions out there.

If you like, you can always suggest something or create a pull request. You are welcome to create your own fork and modify the UI as you prefer. I hope you have fun with it!

### How to get to settings or faves on mobile?

Use the navigation menu (the bottom navigation / hamburger), where Favourites, Bookmarks, Lists and Settings live. Older Bird UI versions relied on swiping the bottom bar; that no longer applies since Mastodon rebuilt its mobile navigation.

### Automatic dark/light mode possible?

Not at the moment, for following reasons:

1. Original Mastodon themes were built using CSS classes in body level, Mastodon Bird UI merely follows this logic.
2. `@media (prefers-color-scheme: dark/light)` does not support `@import` in SCSS inside them, so it's not currently possible to implement new themes with one file. I'm not going to create separate files for dark and light themes, because it would be too much work to maintain.
3. Many choose to use either dark or light theme.

### I like it so much, why it can't be the default Mastodon UI?

As I have explained [here](https://mementomori.social/@rolle/110775398758308450) and in other threads, I do not want it to be the default UI. There are numerous reasons for this.

1. I would not be responsible for it. I do this as a side hobby and for fun, it would get too professional and time consuming for me to be responsible "alone" for the UI infrastructure of the official Mastodon core. It would need some arrangement so it would not bring extra pressure to me personally. More maintainers, etc. I have a time consuming day job as an entrepreneur and UI in this scale needs more housekeeping than I can provide.
2. The Mastodon core CSS/SCSS needs to be rewritten. It's not practical to have two code bases, I think Mastodon Bird UI cannot be just "added" to the core, it's CSS-only and does not follow the current Mastodon SCSS framework. At very least the SCSS variables should be replaced with CSS variables. It's quite a lot of work to rewrite a complete UI codebase.
3. Hacky micro animations and SVG-CSS icons should be replaced with real things. Right now it's like a stamp on a letter. We need the new letter for this to be official.
4. The idea and looks behind Mastodon Bird UI is hugely inspired by Twitter UI. If the popular attitude is that Mastodon should not resemble Twitter in any way, that needs to change first.

## Goals

- **CSS only output.** The compiled output is pure CSS with no JavaScript runtime. Ready-made CSS works when placed in **Custom CSS** box in {yourinstance.social/admin/settings/appearance}
- **Modular SCSS source.** The source code uses SCSS with a modular architecture for easier maintenance and contributions. The build process compiles everything into single CSS files for distribution.

## Accessibility

Mastodon Bird UI is built with accessibility in mind. Please note that many "features" are 100% the same as in the original Mastodon, because this is not a separate app but merely consists of modifications in styles. There is a High contrast version available just like in the original Mastodon.

![image](https://github.com/ronilaukkarinen/mastodon-bird-ui/assets/1534150/030e7243-5a9d-44ea-8284-4be745b13b83)

Programmatically everything is as accessible as Mastodon, color-wise "Pretty good" (WCAG A-AA). Please open [an issue](https://github.com/ronilaukkarinen/mastodon-bird-ui/issues) or a [Mastodon issue](https://github.com/mastodon/mastodon/issues), if you have accessibility concerns. Thank you.

### How to install an Accessible version built for people with serious vision impairment

My wife has Retinitis Pigmentosa and a form of Achromatopsia so it was her wish to be able to use Mastodon better with some accessibility features. When High contrast theme is not enough, you can use the version with:

* Larger font sizes all around
* Contrast to the max
* More accessible colors
* Different colors for links, mentions and hashtags

![Screenshot of Accessible Mastodon Bird UI theme](https://github.com/ronilaukkarinen/mastodon-bird-ui/assets/1534150/0fbf3300-d0cf-4fe6-9365-f6c323c09e02)


Accessible themes are included in the installation scripts since Mastodon 4.6.0.
