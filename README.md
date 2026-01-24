## Mastodon with modern birdsite-like UI

[![Build Status for CSS](https://github.com/ronilaukkarinen/mastodon-bird-ui/actions/workflows/styles.yml/badge.svg)](https://github.com/ronilaukkarinen/mastodon-bird-ui/actions/workflows/styles.yml) [![Supported Mastodon version](https://img.shields.io/badge/mastodon-v4.5.0-595aff)](https://github.com/mastodon/mastodon) <a href="https://github.com/sponsors/ronilaukkarinen"><img src="https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white" alt="GitHub Sponsor" height="20px"></a> <a href="https://ko-fi.com/rolle"><img src="https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white" alt="Ko-fi" height="20px"></a> <a href="https://www.buymeacoffee.com/Fd140aV"><img src="https://cdn.buymeacoffee.com/buttons/v2/arial-orange.png" height="20px"></a>

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
7. [Updating instructions](#updating-instructions)
8. [Other tweaks and customizations](#other-tweaks-and-customizations)
    1. [Status bar color on Android PWA](#status-bar-color-on-android-pwa)
    2. [Hide translate link for multiple languages](#hide-translate-link-for-multiple-languages)
    3. [Thread lines](#thread-lines)
    4. [Micro-interactions](#micro-interactions)
9. [FAQ](#faq)
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
10. [Goals](#goals)
11. [Accessibility](#accessibility)
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
| [everythingbagel.social](https://everythingbagel.social)                 | Site theme                | Bagel UI         | 5              | Yes         |
| [social.vivaldi.net](https://social.vivaldi.net)                         | Site theme                | Mastodon Bird UI | 6700+          | No          |
| [wxw.moe](https://wxw.moe)                                               | Site theme                | Mastodon Bird UI | 3500+          | Yes         |
| [mastodon.com.pl](https://mastodon.com.pl)                               | Site theme                | Mastodon Bird UI | 100+           | No          |
| [mastodon.sg](https://mastodon.sg)                                       | Custom CSS                | Mastodon Bird UI | 100+           | Yes         |
| [FaithTree.social](https://faithtree.social)                             | Site theme                | Mastodon Bird UI | 19+            | Yes         |
| [mustard.blog](https://mustard.blog)                                     | Site theme                | Mastodon Bird UI | 2000+          | Yes         |
| [c.im](https://c.im)                                                     | Site theme                | Mastodon Bird UI | 2000+          | No          |
| [datasci.social](https://datasci.social)                                 | Custom CSS                | Mastodon Bird UI | 80+            | Yes         |

## Installation for Mastodon instance admins

1. Copy the contents of layout-single-column.css and layout-multiple-columns.css and paste them (or one of them) to the **Custom CSS** in the Appearance settings in your instance (https://_yourinstance_/admin/settings/appearance). It might be recommended using the single layout CSS as "base" and use the advanced view CSS with browser extension (as it's desktop only anyway).

![Screen-Shot-2023-03-31-13-25-52](https://user-images.githubusercontent.com/1534150/229111630-c8975708-134b-4887-b259-a87857193387.png)

## Make Mastodon Bird UI as optional by integrating it as 'Site theme' in settings for all users

Mastodon Bird UI can be integrated as a **Site theme** for all instance users as optional.

**Please note**: These include modifications to the Mastodon core so do it only at your own risk! I highly recommend you to make the modifications in local development envinronment, push them to your fork, then git pull that fork to live after confirmed working.

![image](https://github.com/ronilaukkarinen/mastodon-bird-ui/assets/1534150/b30f19e2-2835-4d92-b40d-cac9922f64b3)

If you'd like a different branding for your instance like "Elephant" without any [mention of birds](https://github.com/ronilaukkarinen/mastodon-bird-ui/issues/30), use [Bird UI Theme Admins](https://github.com/mstdn/Bird-UI-Theme-Admins) by [@stux](https://mstdn.social/@stux). If you want Mastodon Bird UI to be as default, read along.

Cd to your Mastodon directory (usually $HOME/live) you can run these bash commands (**Please note:** These add Mastodon Bird UI as name "Mastodon Bird UI (Dark)" + variants as default, while retaining the original themes as secondary themes) and run below.

**Mastodon main/nightly:** `nightly`<br>
**Mastodon stable:** `main`

```bash
export MASTODON_VERSION_FOR_BIRD_UI="main"

# Create a new folder for the theme
mkdir -p app/javascript/styles/mastodon-bird-ui

# Download the CSS file for single column layout
wget -N --no-check-certificate --no-cache --no-cookies --no-http-keep-alive https://raw.githubusercontent.com/ronilaukkarinen/mastodon-bird-ui/$MASTODON_VERSION_FOR_BIRD_UI/layout-single-column.css -O app/javascript/styles/mastodon-bird-ui/layout-single-column.scss

# Download the CSS file for multiple column layout
wget -N --no-check-certificate --no-cache --no-cookies --no-http-keep-alive https://raw.githubusercontent.com/ronilaukkarinen/mastodon-bird-ui/$MASTODON_VERSION_FOR_BIRD_UI/layout-multiple-columns.css -O app/javascript/styles/mastodon-bird-ui/layout-multiple-columns.scss

# Replace theme-contrast with theme-mastodon-bird-ui-contrast and theme-mastodon-light with theme-mastodon-bird-ui-light
sed -i -e 's/theme-contrast/theme-mastodon-bird-ui-contrast/g' -e 's/theme-mastodon-light/theme-mastodon-bird-ui-light/g' app/javascript/styles/mastodon-bird-ui/layout-single-column.scss app/javascript/styles/mastodon-bird-ui/layout-multiple-columns.scss

# Create high contrast theme file
echo -e "@use 'contrast/variables';\n@use 'application';\n@use 'contrast/diff';\n@use 'mastodon-bird-ui/layout-single-column.scss';\n@use 'mastodon-bird-ui/layout-multiple-columns.scss';" > app/javascript/styles/mastodon-bird-ui-contrast.scss

# Create light theme file
echo -e "@use 'mastodon-light/variables';\n@use 'application';\n@use 'mastodon-light/diff';\n@use 'mastodon-bird-ui/layout-single-column.scss';\n@use 'mastodon-bird-ui/layout-multiple-columns.scss';" > app/javascript/styles/mastodon-bird-ui-light.scss

# Create dark theme file
echo -e "@use 'application';\n@use 'mastodon-bird-ui/layout-single-column.scss';\n@use 'mastodon-bird-ui/layout-multiple-columns.scss';" > app/javascript/styles/mastodon-bird-ui-dark.scss

# Overwrite config/themes.yml with new settings, Mastodon Bird UI dark as default
echo -e "default: styles/mastodon-bird-ui-dark.scss\nmastodon-bird-ui-light: styles/mastodon-bird-ui-light.scss\nmastodon-bird-ui-contrast: styles/mastodon-bird-ui-contrast.scss\nmastodon-dark: styles/application.scss\nmastodon-light: styles/mastodon-light.scss\ncontrast: styles/contrast.scss" > config/themes.yml
```

After this you need to edit localisations in `config/locales/en.yml` (`nano config/locales/en.yml`) and add these lines:

```yml
  themes:
     contrast: Mastodon (High contrast)
     default: Mastodon Bird UI (Dark)
     mastodon-bird-ui-light: Mastodon Bird UI (Light)
     mastodon-bird-ui-contrast: Mastodon Bird UI (High contrast)
     mastodon-light: Mastodon (Light)
     mastodon-dark: Mastodon (Dark)
```

Same for the localizations of your choice, for example `config/locales/fi.yml` (`nano config/locales/fi.yml`):


```yml
  themes:
     contrast: Mastodon (Korkea kontrasti)
     default: Mastodon Bird UI (Tumma)
     mastodon-bird-ui-light: Mastodon Bird UI (Vaalea)
     mastodon-bird-ui-contrast: Mastodon Bird UI (Korkea kontrasti)
     mastodon-light: Mastodon (Vaalea)
     mastodon-dark: Mastodon (Tumma)
```

Make sure everything is set in place, then rebuild all the assets and restart all the services:

```bash
bundle install
rm -rfv public/packs
yarn install
RAILS_ENV=production bundle exec rails assets:precompile
sudo systemctl restart mastodon-web mastodon-sidekiq mastodon-streaming
sudo systemctl restart postgresql
```

And you're done!

## Installation for regular users, contributing and testing

1. Install [Live CSS Editor](https://github.com/webextensions/live-css-editor) (or any other extension like [Stylus](https://chrome.google.com/webstore/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne?hl=en) that allows you to inject CSS into web pages) or use [Unite for macOS](https://www.bzgapps.com/unite) or use the [user.js by eg](https://ieji.de/@eg/110174544387143309)
2. Copy the contents of layout-single-column.css and layout-multiple-columns.css
3. Open extension and paste the contents of both CSS files into the editor
4. If you use Live CSS Editor, click 📌-icon so the styles will be remembered for the domain or if you want just to use it as needed, activate styles from the extension's popup

## Updating instructions

If you are using **Custom CSS**, just copy and paste the new version to **Custom CSS** textarea in the Appearance settings in your instance (https://_yourinstance_/admin/settings/appearance).

If you are using Mastodon Bird UI as option, get the latest changes to your instance, first cding to live folder (or to wherever your Mastodon root is), then run below.

**Mastodon main/nightly:** `nightly`<br>
**Mastodon stable:** `main`

```bash
export MASTODON_VERSION_FOR_BIRD_UI="main"

# Download the CSS file for single column layout
wget -N --no-check-certificate --no-cache --no-cookies --no-http-keep-alive https://raw.githubusercontent.com/ronilaukkarinen/mastodon-bird-ui/$MASTODON_VERSION_FOR_BIRD_UI/layout-single-column.css -O app/javascript/styles/mastodon-bird-ui/layout-single-column.scss

# Download the CSS file for multiple column layout
wget -N --no-check-certificate --no-cache --no-cookies --no-http-keep-alive https://raw.githubusercontent.com/ronilaukkarinen/mastodon-bird-ui/$MASTODON_VERSION_FOR_BIRD_UI/layout-multiple-columns.css -O app/javascript/styles/mastodon-bird-ui/layout-multiple-columns.scss

# Replace theme-contrast with theme-mastodon-bird-ui-contrast and theme-mastodon-light with theme-mastodon-bird-ui-light
sed -i -e 's/theme-contrast/theme-mastodon-bird-ui-contrast/g' -e 's/theme-mastodon-light/theme-mastodon-bird-ui-light/g' app/javascript/styles/mastodon-bird-ui/layout-single-column.scss app/javascript/styles/mastodon-bird-ui/layout-multiple-columns.scss
```

After this commit changes to your Mastodon fork if you have one, then:

```
RAILS_ENV=production bundle exec rails assets:precompile
sudo service mastodon-web reload
```

That's it!

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

| Twitter likes | Twitter fave star (2015) | Boost animation |
| ------------- | ------------- |------------ |
| <img width="70%" src="https://user-images.githubusercontent.com/1534150/230135110-6391e061-10c9-4819-af8b-7144b31dac93.gif" alt="heart" /> | <img src="https://user-images.githubusercontent.com/1534150/230135096-4d1ac9b2-290b-41da-a136-985e908868fa.gif" alt="star"> | <img src="https://github.com/ronilaukkarinen/mastodon-bird-ui/assets/1534150/ef02d2b8-14bc-4dbc-9b48-112c723c71cb" alt="boost"> |

If you like the heart, just remove everything between `Star animation micro-interactions start (depends on the heart icon above)` and `Star animation micro-interactions end`.

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

Yes! From version 1.5.4 multiple columns are supported. Apply layout-multiple-columns.css to your Custom CSS or style extension to enable.

### Why the admin interface is not styled?

We don't spend much time in the admin interface and it's not a priority for me to style it. It would mean too much work and it's not worth it right now.

### Can you add feature x?

Mastodon Bird UI is CSS only, so I can't add any features. Please send your Mastodon feature ideas [here](https://github.com/mastodon/mastodon/issues).

### Can you make it look like _this_ by default?

Probably yes, but I'm not here to please everyone. Suggestions like [this](https://mementomori.social/@rolle/110658189531503982) are very important and there has been many pull requests and issues already that have helped me to make the UI better. While saying this I'm not going to implement every single suggestion, because there are too many different opinions out there.

If you like, you can always suggest something or create a pull request. You are welcome to create your own fork and modify the UI as you prefer. I hope you have fun with it!

### How to get to settings or faves on mobile?

You can swipe the bottom bar. I know this is not the most obvious feature.

![ezgif com-video-to-gif](https://github.com/ronilaukkarinen/mastodon-bird-ui/assets/1534150/18c832c0-2e3b-4bc2-8323-636cd08b107d)

See issues [Many users don't recognize that the bottom menu is scrollable #26](https://github.com/ronilaukkarinen/mastodon-bird-ui/issues/26) and [Swiping bottom bar triggers multi-tasking on some phones #33](https://github.com/ronilaukkarinen/mastodon-bird-ui/issues/33).

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

- **CSS only.** This means some pseudos and modern CSS hacks. The intent is to have the code base as simple and extendable as possible. The styles should be easily modifiable. Ready-made code works when placed in **Custom CSS** box in {yourinstance.social/admin/settings/appearance}
- **Dependency free.** No JavaScript, no build process, no nothing. Just plain CSS. Linting is optional and just here to make sure the code quality is good.

## Accessibility

Mastodon Bird UI is built accessibility in mind. Please note that many "features" are 100% the same than in the original Mastodon, because this is not a separate app but merely consists of modifications in styles. There is a High contrast version available just like in the original Mastodon.

![image](https://github.com/ronilaukkarinen/mastodon-bird-ui/assets/1534150/030e7243-5a9d-44ea-8284-4be745b13b83)

Programmatically everything is as accessible as Mastodon, color-wise "Pretty good" (WCAG A-AA). Please open [an issue](https://github.com/ronilaukkarinen/mastodon-bird-ui/issues) or a [Mastodon issue](https://github.com/mastodon/mastodon/issues), if you have accessibility concerns. Thank you.

### How to install an Accessible version built for people with serious vision impairment

My wife has Retinitis Pigmentosa and a form of Achromatopsia so it was her wish to be able to use Mastodon better with some accessibility features. When High contrast theme is not enough, you can use the version with:

* Larger font sizes all around
* Contrast to the max
* More accessible colors
* Different colors for links, mentions and hashtags

![Screenshot of Accessible Mastodon Bird UI theme](https://github.com/ronilaukkarinen/mastodon-bird-ui/assets/1534150/0fbf3300-d0cf-4fe6-9365-f6c323c09e02)

If you use bash commands in: [Make Mastodon Bird UI as optional by integrating it as 'Site theme' in settings for all users](#make-mastodon-bird-ui-as-optional-by-integrating-it-as-site-theme-in-settings-for-all-users) - do this:

```bash
# Go into your Mastodon base
cd $HOME/live

# Copy contrast theme as base
cp app/javascript/styles/mastodon-bird-ui-contrast.scss app/javascript/styles/mastodon-bird-ui-accessible.scss

# Edit the file and add CSS below right after last @use
nano app/javascript/styles/mastodon-bird-ui-accessible.scss

# Add your new theme to config:
# mastodon-bird-ui-a11y: styles/mastodon-bird-ui-accessible.scss
nano config/themes.yml
```

CSS for `mastodon-bird-ui-accessible` theme (you can also add this to **Custom CSS** or to your browser extension if you are not an admin):

```css
@import 'contrast/variables';
@import 'application';
@import 'contrast/diff';
@import 'mastodon-bird-ui/layout-single-column.scss';
@import 'mastodon-bird-ui/layout-multiple-columns.scss';

body.theme-mastodon-bird-ui-accessible {
  --color-accent: #0a9ff9;
  --color-accent-dark: #1a3ff9;
  --color-brand-mastodon-text-light: #fff;
  --color-brand-mastodon-links: #0a9ff9;
  --color-hashtag: #ff66e3;
  --color-link: #0a9ff9;
  --color-mention: #0af9b5;
  --color-dark: #1a1b36;
  --color-bg: #000;
  --color-bg-90: #000;
  --color-bg-75: #000000bf;
  --color-mud: #333;
  --color-dim: #fff;
  --color-column-link-hover: #ffffff36;
  --color-border: #343638;
  --color-light-purple: #fff;
  --color-thread-line: #979b9f;
  --font-size: 18px;
  --font-size-smaller: 18px;
  --font-size-mid: 18px;
  --font-size-bigger: 18px;
  --font-size-12: 14px;
  --font-size-heading: 20px;
  --line-height: 24px;
  --line-height-mid: 22px;
  --icon-search: url("data:image/svg+xml;charset=utf-8, %3Csvg xmlns='http://www.w3.org/2000/svg' fill='%23fff' aria-hidden='true' viewBox='0 0 24 24'%3E%3Cpath d='M10.25 3.75a6.5 6.5 0 1 0 0 13 6.5 6.5 0 0 0 0-13zm-8.5 6.5a8.5 8.5 0 1 1 15.176 5.262l4.781 4.781-1.414 1.414-4.781-4.781A8.5 8.5 0 0 1 1.75 10.25z'/%3E%3C/svg%3E");
  --logo: url('data:image/svg+xml, %3Csvg class="mastodon-logo" xmlns="http://www.w3.org/2000/svg" width="28px" height="28px" viewBox="0 0 216.4144 232.00976"%3E%3Cdefs xmlns="http://www.w3.org/2000/svg"%3E%3ClinearGradient xmlns="http://www.w3.org/2000/svg" id="gradient" x2="0%25" y2="100%25" gradientUnits="userSpaceOnUse"%3E%3Cstop offset="0%25" stop-color="%231a3ff9"%3E%3C/stop%3E%3Cstop offset="100%25" stop-color="%231a3ff9"%3E%3C/stop%3E%3C/linearGradient%3E%3C/defs%3E%3Cpath xmlns="http://www.w3.org/2000/svg" d="M211.80734 139.0875c-3.18125 16.36625-28.4925 34.2775-57.5625 37.74875-15.15875 1.80875-30.08375 3.47125-45.99875 2.74125-26.0275-1.1925-46.565-6.2125-46.565-6.2125 0 2.53375.15625 4.94625.46875 7.2025 3.38375 25.68625 25.47 27.225 46.39125 27.9425 21.11625.7225 39.91875-5.20625 39.91875-5.20625l.8675 19.09s-14.77 7.93125-41.08125 9.39c-14.50875.7975-32.52375-.365-53.50625-5.91875C9.23234 213.82 1.40609 165.31125.20859 116.09125c-.365-14.61375-.14-28.39375-.14-39.91875 0-50.33 32.97625-65.0825 32.97625-65.0825C49.67234 3.45375 78.20359.2425 107.86484 0h.72875c29.66125.2425 58.21125 3.45375 74.8375 11.09 0 0 32.975 14.7525 32.975 65.0825 0 0 .41375 37.13375-4.59875 62.915" fill="url(%23gradient)"%3E%3C/path%3E%3Cpath d="M177.50984 80.077v60.94125h-24.14375v-59.15c0-12.46875-5.24625-18.7975-15.74-18.7975-11.6025 0-17.4175 7.5075-17.4175 22.3525v32.37625H96.20734V85.42325c0-14.845-5.81625-22.3525-17.41875-22.3525-10.49375 0-15.74 6.32875-15.74 18.7975v59.15H38.90484V80.077c0-12.455 3.17125-22.3525 9.54125-29.675 6.56875-7.3225 15.17125-11.07625 25.85-11.07625 12.355 0 21.71125 4.74875 27.8975 14.2475l6.01375 10.08125 6.015-10.08125c6.185-9.49875 15.54125-14.2475 27.8975-14.2475 10.6775 0 19.28 3.75375 25.85 11.07625 6.36875 7.3225 9.54 17.22 9.54 29.675" fill="%23fff"%3E%3C/path%3E%3C/svg%3E');
  --icon-bookmark: url('data:image/svg+xml, %0A%3Csvg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="%23fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-bookmark"%3E%3Cpath d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"%3E%3C/path%3E%3C/svg%3E');
  --icon-reply: url("data:image/svg+xml, %3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='18' height='18' fill='%23fff' aria-hidden='true'%3E%3Cg%3E%3Cpath d='M1.751 10c0-4.42 3.584-8 8.005-8h4.366c4.49 0 8.129 3.64 8.129 8.13 0 2.96-1.607 5.68-4.196 7.11l-8.054 4.46v-3.69h-.067c-4.49.1-8.183-3.51-8.183-8.01zm8.005-6c-3.317 0-6.005 2.69-6.005 6 0 3.37 2.77 6.08 6.138 6.01l.351-.01h1.761v2.3l5.087-2.81c1.951-1.08 3.163-3.13 3.163-5.36 0-3.39-2.744-6.13-6.129-6.13H9.756z'%3E%3C/path%3E%3C/g%3E%3C/svg%3E");
  --icon-follow-hashtag: url('data:image/svg+xml, %3Csvg version="1.0" xmlns="http://www.w3.org/2000/svg" width="18px" height="auto" viewBox="0 0 462 439"%3E%3Cpath fill="%23ffffff" d="M139 11.7c-3.5 2.5-6.2 5.4-7.7 8.3-2.5 4.8-2.5 5.2-7.8 52.5-1.4 12.6-3.5 31.4-4.7 41.7l-2.1 18.7-48.6.3-48.6.3-5 3.1C7.2 141.1 3 148.4 3 156.7c0 4.4.6 7.6 2 10.2 2.7 5.4 10.1 11.6 15.5 13 2.9.7 19.2 1.1 47.8 1.1 40.9 0 43.5.1 43.1 1.7-.4 1.9-8.4 73.2-8.4 75.2 0 .8-11.4 1.1-41 1.1H20.9l-4.8 2.5C7.5 265.8 3 273 3 282.5s4.5 16.7 13.1 21l4.8 2.5H97.6l-5.3 46.7c-2.9 25.8-5.4 50.3-5.5 54.5-.1 7 .2 8.2 2.8 12.5 1.7 2.7 5.1 6.2 7.8 8 4.5 3.1 5.4 3.3 13 3.3 8.9 0 10.2-.5 16.8-6.8 4.8-4.6 6.3-9.3 8.2-26.7.9-7.7 2.7-23.9 4-36 1.4-12.1 3.3-29.5 4.3-38.8l1.7-16.7H214.7l.5-8.3c.7-9.8 1.4-11.5 8.2-18.5 8.6-9 7-8.7 41.4-9l30.2-.3V259h-9.5c-9.4 0-9.5 0-9.1-2.3.3-1.2 1.5-10.8 2.6-21.2 1.2-10.5 3-26.5 4.1-35.7 1-9.2 1.9-17.2 1.9-17.8 0-.7 12.3-1 38.5-1 23.5 0 40.3-.4 43.4-1.1 6.1-1.3 13.5-7.4 16.2-13.4 5.2-11.4.2-24.9-11.5-30.9l-4.9-2.6H290.4l5.3-46.8c5.3-47.1 6.1-59 4.3-63.6-1.4-3.7-7.9-10.5-12.1-12.7C285.2 8.6 282 8 277.2 8c-6.2 0-7.5.4-11.8 3.2-9.2 6.2-10.1 8.6-12.9 31.8-3.4 28.9-7.2 63.4-8.7 77.7l-1.2 12.3h-77.8l.6-4.3c.3-2.3.8-7.1 1.1-10.7.6-6.1 2.5-23.4 7.6-68 1.2-10.8 1.9-21.1 1.6-23.1-1.1-5.5-6.2-12.6-11.4-15.9-4.2-2.7-5.6-3-12.3-3-7.2 0-8 .2-13 3.7zm97.5 174.5c-.4 2.9-1.5 12.9-2.5 22.3-1.1 9.3-2.7 24.5-3.7 33.7l-1.7 16.8H150.9l.6-6.3c.3-3.4 1.7-15.7 3-27.2 1.3-11.6 2.9-26.3 3.6-32.8l1.2-11.7H237l-.5 5.2z"/%3E%3Cpath fill="%23ffffff" d="M317.2 207c-1.8 1.1-4.1 3.4-5.2 5.2-1.9 3.1-2 5.1-2 38V285h-34.7c-33 0-35 .1-38.1 2-6.7 4.1-7.2 6-7.2 30s.5 25.9 7.2 30c3.1 1.9 5.1 2 38.1 2H310v34.7c0 33 .1 35 2 38.1 4.1 6.7 6 7.2 30 7.2s25.9-.5 30-7.2c1.9-3.1 2-5.1 2-38.1V349h34.8c32.9 0 34.9-.1 38-2 6.7-4.1 7.2-6 7.2-30s-.5-25.9-7.2-30c-3.1-1.9-5.1-2-38-2H374v-34.8c0-32.9-.1-34.9-2-38-4.1-6.7-6-7.2-30-7.2-19.7 0-21.8.2-24.8 2z"/%3E%3Cpath fill="%23ffffff" d="M217.2 359.7c-5 43.2-5.5 50-4.2 54.7 1.5 5.4 7.5 12.7 12.4 15 5.2 2.4 17.1 2.2 21.6-.5 8.9-5.3 12.3-11.7 13.4-25.4.9-10.2 3.5-33.2 4.2-36.6l.5-2.7-15.3-.4c-10.1-.2-16.1-.8-17.8-1.7-1.4-.7-5-3.8-8.1-6.8l-5.6-5.4-1.1 9.8z"/%3E%3C/svg%3E');
  --icon-boost: url("data:image/svg+xml, %3Csvg version='1.0' xmlns='http://www.w3.org/2000/svg' width='21' height='21' viewBox='0 0 136 136'%3E%3Cpath fill='%23ffffff' d='M51 23.8c0 .4 2.4 3.1 5.3 6l5.3 5.2h34.6l3.4 3.4 3.4 3.4v47.4l-6.7-6.1-6.8-6.1-4 4-4 4 13.8 13.7 13.7 13.8L122.5 99c7.4-7.4 13.5-13.7 13.5-14-.1-.3-1.7-2.3-3.6-4.4l-3.5-4-6.8 6.8-6.9 6.9-.4-25.4c-.3-23.8-.4-25.7-2.5-29.4-2.7-5.1-5.7-7.9-11.3-10.4-4.1-1.9-6.5-2.1-27.2-2.1-12.6 0-22.8.4-22.8.8zM13 37.5-.4 51l3.8 3.9 3.9 4 6.6-6.1 6.6-6 .5 24.4c.5 26.3.7 27.2 6.6 33.2 6 5.9 6.8 6.1 33.2 6.4 13.3.2 24.2-.1 24.2-.5 0-.5-2.2-3-4.8-5.6l-4.8-4.7-15.9-.1c-17.7 0-21.7-.9-24.9-5.2-2-2.7-2.1-4.2-2.3-26.5l-.2-23.6 6.7 6.7C42.5 55 46 58 46.6 58c.5 0 2.5-1.6 4.4-3.5l3.4-3.5L41 37.5C33.6 30.1 27.3 24 27 24c-.3 0-6.6 6.1-14 13.5z'/%3E%3C/svg%3E%0A");
  --icon-boost-status: url("data:image/svg+xml, %3Csvg version='1.0' xmlns='http://www.w3.org/2000/svg' width='21' height='21' viewBox='0 0 136 136'%3E%3Cpath fill='%23ffffff' d='M51 23.8c0 .4 2.4 3.1 5.3 6l5.3 5.2h34.6l3.4 3.4 3.4 3.4v47.4l-6.7-6.1-6.8-6.1-4 4-4 4 13.8 13.7 13.7 13.8L122.5 99c7.4-7.4 13.5-13.7 13.5-14-.1-.3-1.7-2.3-3.6-4.4l-3.5-4-6.8 6.8-6.9 6.9-.4-25.4c-.3-23.8-.4-25.7-2.5-29.4-2.7-5.1-5.7-7.9-11.3-10.4-4.1-1.9-6.5-2.1-27.2-2.1-12.6 0-22.8.4-22.8.8zM13 37.5-.4 51l3.8 3.9 3.9 4 6.6-6.1 6.6-6 .5 24.4c.5 26.3.7 27.2 6.6 33.2 6 5.9 6.8 6.1 33.2 6.4 13.3.2 24.2-.1 24.2-.5 0-.5-2.2-3-4.8-5.6l-4.8-4.7-15.9-.1c-17.7 0-21.7-.9-24.9-5.2-2-2.7-2.1-4.2-2.3-26.5l-.2-23.6 6.7 6.7C42.5 55 46 58 46.6 58c.5 0 2.5-1.6 4.4-3.5l3.4-3.5L41 37.5C33.6 30.1 27.3 24 27 24c-.3 0-6.6 6.1-14 13.5z'/%3E%3C/svg%3E%0A");
  --icon-boost-notification-filter-bar: url("data:image/svg+xml, %3Csvg version='1.0' xmlns='http://www.w3.org/2000/svg' width='21' height='21' viewBox='0 0 136 136'%3E%3Cpath fill='%23ffffff' d='M51 23.8c0 .4 2.4 3.1 5.3 6l5.3 5.2h34.6l3.4 3.4 3.4 3.4v47.4l-6.7-6.1-6.8-6.1-4 4-4 4 13.8 13.7 13.7 13.8L122.5 99c7.4-7.4 13.5-13.7 13.5-14-.1-.3-1.7-2.3-3.6-4.4l-3.5-4-6.8 6.8-6.9 6.9-.4-25.4c-.3-23.8-.4-25.7-2.5-29.4-2.7-5.1-5.7-7.9-11.3-10.4-4.1-1.9-6.5-2.1-27.2-2.1-12.6 0-22.8.4-22.8.8zM13 37.5-.4 51l3.8 3.9 3.9 4 6.6-6.1 6.6-6 .5 24.4c.5 26.3.7 27.2 6.6 33.2 6 5.9 6.8 6.1 33.2 6.4 13.3.2 24.2-.1 24.2-.5 0-.5-2.2-3-4.8-5.6l-4.8-4.7-15.9-.1c-17.7 0-21.7-.9-24.9-5.2-2-2.7-2.1-4.2-2.3-26.5l-.2-23.6 6.7 6.7C42.5 55 46 58 46.6 58c.5 0 2.5-1.6 4.4-3.5l3.4-3.5L41 37.5C33.6 30.1 27.3 24 27 24c-.3 0-6.6 6.1-14 13.5z'/%3E%3C/svg%3E%0A");
  --icon-reply: url("data:image/svg+xml, %3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='18' height='18' fill='%23ffffff' aria-hidden='true'%3E%3Cg%3E%3Cpath d='M1.751 10c0-4.42 3.584-8 8.005-8h4.366c4.49 0 8.129 3.64 8.129 8.13 0 2.96-1.607 5.68-4.196 7.11l-8.054 4.46v-3.69h-.067c-4.49.1-8.183-3.51-8.183-8.01zm8.005-6c-3.317 0-6.005 2.69-6.005 6 0 3.37 2.77 6.08 6.138 6.01l.351-.01h1.761v2.3l5.087-2.81c1.951-1.08 3.163-3.13 3.163-5.36 0-3.39-2.744-6.13-6.129-6.13H9.756z'%3E%3C/path%3E%3C/g%3E%3C/svg%3E");
  --icon-reply-detailed-status-action-bar: url("data:image/svg+xml, %3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='18' height='18' fill='%23ffffff' aria-hidden='true'%3E%3Cg%3E%3Cpath d='M1.751 10c0-4.42 3.584-8 8.005-8h4.366c4.49 0 8.129 3.64 8.129 8.13 0 2.96-1.607 5.68-4.196 7.11l-8.054 4.46v-3.69h-.067c-4.49.1-8.183-3.51-8.183-8.01zm8.005-6c-3.317 0-6.005 2.69-6.005 6 0 3.37 2.77 6.08 6.138 6.01l.351-.01h1.761v2.3l5.087-2.81c1.951-1.08 3.163-3.13 3.163-5.36 0-3.39-2.744-6.13-6.129-6.13H9.756z'%3E%3C/path%3E%3C/g%3E%3C/svg%3E");
  --icon-share-detailed-status-action-bar: url("data:image/svg+xml, %3Csvg xmlns='http://www.w3.org/2000/svg' width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='%23ffffff' stroke-width='2' stroke-linecap='round' stroke-linejoin='round' class='feather feather-share'%3E%3Cpath d='M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8'%3E%3C/path%3E%3Cpolyline points='16 6 12 2 8 6'%3E%3C/polyline%3E%3Cline x1='12' y1='2' x2='12' y2='15'%3E%3C/line%3E%3C/svg%3E");
  --icon-bookmark-detailed-status-action-bar: url("data:image/svg+xml, %3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='20' height='20' fill='%23ffffff' aria-hidden='true'%3E%3Cg%3E%3Cpath d='M4 4.5C4 3.12 5.119 2 6.5 2h11C18.881 2 20 3.12 20 4.5v18.44l-8-5.71-8 5.71V4.5zM6.5 4c-.276 0-.5.22-.5.5v14.56l6-4.29 6 4.29V4.5c0-.28-.224-.5-.5-.5h-11z'%3E%3C/path%3E%3C/g%3E%3C/svg%3E");
  --icon-bookmark-detailed-status-action-bar-hover: url("data:image/svg+xml, %3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='20' height='20' fill='%23F91880' aria-hidden='true'%3E%3Cg%3E%3Cpath d='M4 4.5C4 3.12 5.119 2 6.5 2h11C18.881 2 20 3.12 20 4.5v18.44l-8-5.71-8 5.71V4.5zM6.5 4c-.276 0-.5.22-.5.5v14.56l6-4.29 6 4.29V4.5c0-.28-.224-.5-.5-.5h-11z'%3E%3C/path%3E%3C/g%3E%3C/svg%3E");
  --icon-share: url("data:image/svg+xml, %3Csvg xmlns='http://www.w3.org/2000/svg' width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='%23ffffff' stroke-width='2' stroke-linecap='round' stroke-linejoin='round' class='feather feather-share'%3E%3Cpath d='M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8'%3E%3C/path%3E%3Cpolyline points='16 6 12 2 8 6'%3E%3C/polyline%3E%3Cline x1='12' y1='2' x2='12' y2='15'%3E%3C/line%3E%3C/svg%3E");
  --icon-heart: url("data:image/svg+xml, %0A%3Csvg viewBox='0 0 24 24' color='inherit' width='20' height='20' xmlns='http://www.w3.org/2000/svg' %3E%3Cpath fill='%23ffffff' d='M16.5 3C19.538 3 22 5.5 22 9c0 7-7.5 11-10 12.5C9.5 20 2 16 2 9c0-3.5 2.5-6 5.5-6C9.36 3 11 4 12 5c1-1 2.64-2 4.5-2zm-3.566 15.604a26.953 26.953 0 0 0 2.42-1.701C18.335 14.533 20 11.943 20 9c0-2.36-1.537-4-3.5-4c-1.076 0-2.24.57-3.086 1.414L12 7.828l-1.414-1.414C9.74 5.57 8.576 5 7.5 5C5.56 5 4 6.656 4 9c0 2.944 1.666 5.533 4.645 7.903c.745.592 1.54 1.145 2.421 1.7c.299.189.595.37.934.572c.339-.202.635-.383.934-.571z'/%3E%3C/svg%3E");
  --icon-home-notification: url('data:image/svg+xml, %0A%3Csvg xmlns="http://www.w3.org/2000/svg" class="ionicon" viewBox="0 0 512 512"%3E%3Ctitle%3EHome%3C/title%3E%3Cpath d="M80 212v236a16 16 0 0016 16h96V328a24 24 0 0124-24h80a24 24 0 0124 24v136h96a16 16 0 0016-16V212" fill="none" stroke="%23ffffff" stroke-linecap="round" stroke-linejoin="round" stroke-width="38"/%3E%3Cpath d="M480 256L266.89 52c-5-5.28-16.69-5.34-21.78 0L32 256M400 179V64h-48v69" fill="none" stroke="%23ffffff" stroke-linecap="round" stroke-linejoin="round" stroke-width="38"/%3E%3C/svg%3E');
  --icon-star: url('data:image/svg+xml, %3Csvg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" stroke="%23ffffff" stroke-width="5.5" viewBox="0 0 68 68"%3E%3Cpath d="M31.4 3.8c-.7.4-2.5 5-4.1 10.2l-2.9 9.5-9.9.5c-5.5.3-10.6.9-11.3 1.3-.6.5-1.2 1.9-1.2 3.3 0 2 1.5 3.4 8 7.5 4.4 2.8 8 5.5 8 6s-1.3 4.5-3 9.1c-3.6 9.7-3.7 11.4-.9 12.8 2.7 1.5 3.5 1.1 12.4-5.6l7.5-5.6 8.2 6.1c8.4 6.3 11.2 7.1 13.2 3.9.8-1.4.3-3.9-2.2-11-1.8-5.1-3.2-9.6-3.2-9.9 0-.4 3.6-3 8-5.8 6.5-4.1 8-5.5 8-7.5 0-1.4-.6-2.8-1.2-3.3-.7-.4-5.8-1-11.3-1.3l-9.9-.5-2.9-9.5C37.8 4.6 36.9 3 34 3c-.8 0-2 .4-2.6.8z"/%3E%3C/svg%3E%0A');
}

/* Define font sizes for those where missing */
body.theme-mastodon-bird-ui-accessible-plus {
  time,
  span,
  li {
    font-size: var(--font-size);
  }
}

/* Improve alt text readability */
.media-gallery__alt__popover p {
  font-size: var(--font-size);
  line-height: 1.2;
  white-space: pre-line;
  color: var(--color-fg);
}

/* Fix columns in content warnings with bigger fonts */
body .columns-area__panels__pane--compositional .compose-form .spoiler-input__input,
body .content-warning {
  grid-template-columns: minmax(0, 3fr) minmax(90px, 180px) !important;
}

/* Min width fix */
.layout-single-column .column-link > i {
  min-width: 0 !important;
}

/* Define smaller font sizes */
.navigation-bar .account__display-name .display-name__account,
.trends__item__name > span,
.account__header__account-note textarea,
.dropdown-button {
  font-size: var(--font-size-smaller) !important;
}

/* Define mid font sizes */
.notification-group__main__header__label,
.account--minimal .account__display-name .display-name strong,
.account__header__content p,
.status__relative-time * {
  font-size: var(--font-size-mid) !important;
  line-height: var(--line-height-mid) !important;
}

@media (max-width: 700px) {
  body.theme-mastodon-bird-ui-accessible {
    --font-size: 22px;
    --line-height: 30px;
  }
}

.layout-single-column .icon-with-badge__badge {
  font-size: 14px;
  padding: 3px 6px;
  top: -10px;
}

/* Custom for mementomori.social */
.status__content__text[lang="fi"].translate ~ .status__content__read-more-button {
  display: none;
}

.layout-single-column .compose-form .autosuggest-textarea__textarea {
  max-height: 20vh !important;
  height: auto !important;
}

/* Add background color for the compose form */
/* stylelint-disable-next-line no-duplicate-selectors */
.layout-multiple-columns .compose-form .compose-form__autosuggest-wrapper,
.layout-multiple-columns .compose-form .compose-form__buttons-wrapper,
.layout-single-column .compose-form .compose-form__autosuggest-wrapper,
.layout-single-column .compose-form .compose-form__buttons-wrapper {
  background-color: var(--color-mud);
  border-color: var(--color-mud);
  padding-top: 0;
}

/* Fixes to bottom row when there's a background */
.layout-multiple-columns .compose-form .compose-form__buttons-wrapper,
.layout-single-column .compose-form .compose-form__buttons-wrapper {
  padding-bottom: calc(var(--gap-default) / 2);
}

/* Advanced view accessibility improvements based no the feedback by @mustikkasoppa@mementomori.social */
/* Move form back to start */
.layout-multiple-columns .drawer {
  border-right: 1px solid var(--color-border) !important;
  order: 0 !important;
}

/* Show full name */
.status__info .display-name {
  flex-wrap: wrap;
  margin-bottom: 10px;
}

.status__info {
  justify-content: space-between !important;
}

.status__info::before {
  display: none !important;
}

.status__info .display-name .display-name__account {
  opacity: .8;
}

.status .status__info {
  height: auto !important;
}

/* Bigger translate link */
.status__content__read-more-button,
.status__content__translate-button {
  color: var(--color-accent) !important;
  font-size: var(--font-size-mid) !important;
}

/* Better load more link */
.load-more {
  font-size: var(--font-size-mid) !important;
  color: var(--color-light-text) !important;
}

/* Fix unfollow wrapping */
.layout-multiple-columns .notification.notification-follow .account__relationship,
.layout-multiple-columns .notification.notification.notification-admin-sign-up .account__relationship {
  transform: translateY(-34px);
}

/* Improve active tab */
.account__section-headline a.active,
.account__section-headline button.active,
.notification__filter-bar a.active,
.notification__filter-bar button.active {
  background-color: var(--color-mud) !important;
}

/* More visible button borders */
.account .account__relationship > .button,
.account__header__tabs__buttons .button,
.account__header__tabs__buttons .icon-button,
.column-inline-form button,
.explore__suggestions .account-card__actions__button button,
.notification .account__relationship > .button,
.notification__report__actions .button {
  border-color: var(--color-light-text) !important;
}

/* Ensure different colors for links, mentions and hashtags in v4.5-nightly 2025-10 */
.status__content .mention,
.status__content .mention * {
  color: var(--color-mention) !important;
}

.status__content .hashtag,
.status__content .hashtag * {
  color: var(--color-hashtag) !important;
}

.status__content a[href]:not(.mention):not(.hashtag) * {
  color: var(--color-link) !important;
}
```

After this you need to edit localisations in `config/locales/en.yml` (`nano config/locales/en.yml`) and add these lines:

```yml
  themes:
     contrast: Mastodon (High contrast)
     default: Mastodon Bird UI (Dark)
     mastodon-bird-ui-light: Mastodon Bird UI (Light)
     mastodon-bird-ui-contrast: Mastodon Bird UI (High contrast)
     mastodon-light: Mastodon (Light)
     mastodon-dark: Mastodon (Dark)
     mastodon-bird-ui-accessible: Mastodon Bird UI (Ultra accessible)
```

Same for the localizations of your choice, for example `config/locales/fi.yml` (`nano config/locales/fi.yml`):

```yml
  themes:
     contrast: Mastodon (Korkea kontrasti)
     default: Mastodon Bird UI (Tumma)
     mastodon-bird-ui-light: Mastodon Bird UI (Vaalea)
     mastodon-bird-ui-contrast: Mastodon Bird UI (Korkea kontrasti)
     mastodon-light: Mastodon (Vaalea)
     mastodon-dark: Mastodon (Tumma)
     mastodon-bird-ui-accessible: Mastodon Bird UI (Saavutettavuus huomioitu)
```

Now rebuild assets and restart mastodon-web service:

```shell
RAILS_ENV=production bundle exec rails assets:precompile
sudo systemctl restart mastodon-web
```



