hubot-gif-me
============

Bring your personal gifs into your favourite chat client.

![screen shot 2014-02-19 at 9 35 00 pm](https://f.cloud.github.com/assets/237985/2214636/bfe24b16-99d7-11e3-9f27-afac7e7df842.png)

### Usage

```text
/gif me
/gif me itworks
```

### Installation

These instructions assume you've deployed Hubot to Heroku. Please make the
appropriate adjustments for other hosting solutions.

```bash
$ npm install --save hubot-gif-me
$ hk set HUBOT_GIF_INDEX="http://example.com/gif_index.json"
$ vim external-scripts.json # add "hubot-gif-me" to the array
```

### Creating your Index File

The index file is merely a JSON endpoint which returns an array of objects with
at least the `path` attribute. Check out [my gif index
file](http://gifs.parkermoo.re/index.json). I generated it via [a simple call to
the `jsonify` filter in
Liquid](https://github.com/parkr/gifs/blob/348db6ade6f7946dea09b7b91293ecc17a8c84cf/index.json).

Even though mine is auto-generated, it's totally plausible for you to write you
index by hand. It just might suck a little. Judicious use of Jekyll and Liquid
will make your life way easier!

### Credit

@jglovier had the idea to use GitHub as a gif host.
@parkr had the idea to tie this into hubot.
