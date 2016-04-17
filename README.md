# hubot-line-example

This is an example code for [hubot-line](https://github.com/umakoz/hubot-line).

## Setup on Heroku

Create a business account at the [Business Center](https://business.line.me/).  
Add BOT API Trial on your business account page.  
Clone this repository.

```sh
git clone https://github.com/umakoz/hubot-line-example.git
cd hubot-line-example
```

Create app on Heroku.

```sh
heroku apps:create
```

Check your app web URL by below command. You will get an URL like `Web URL: https://your-app-name.herokuapp.com/`. You should memorize this to register a callback URL on LINE platform.

```sh
heroku apps:info
```

Set environment variables. Please fill in your bot's variables that was provided by LINE Business Center.

```sh
heroku config:add HUBOT_LINE_CHANNEL_ID="your_channel_id"
heroku config:add HUBOT_LINE_CHANNEL_SECRET="your_channel_secret"
heroku config:add HUBOT_LINE_CHANNEL_MID="your_channel_mid"
```

If you want to show debug logs, set a following environment variable.

```sh
heroku config:add HUBOT_LOG_LEVEL="debug"
```

Setup RedisCloud and Fixie addon.

```sh
heroku addons:create rediscloud:30
heroku addons:create fixie:tricycle
```

You should memorize following IP addresses(xxx.xxx.xxx.xxx, yyy.yyy.yyy.yyy) that is provided by Fixie. You need to register IP addresses to server whitelist on LINE platform.

```sh
Your IP addresses are xxx.xxx.xxx.xxx, yyy.yyy.yyy.yyy
```

Please set a callback URL on LINE Business Center like following.

> https://your-app-name.herokuapp.com:443/hubot/line/callback

Please set Fixie IPs to server IP Whitelist on LINE Business Center like following.

> xxx.xxx.xxx.xxx/24  
> yyy.yyy.yyy.yyy/24

Set a contentEndpoint on `./scripts/line.coffee` file.

```coffeescript
contentEndpoint = 'https://your-app-name.herokuapp.com:443/download'
```

Deploy app to Heroku.

```sh
git add .
git commit -m 'set contentEndpoint.'
git push heroku master
```

Be a friend with your bot, and send a sticker in the [sticker list](https://developers.line.me/wp-content/uploads/2016/04/sticker_list.xlsx). You will get a same sticker from your bot.

## License

The MIT License. See `LICENSE` for details.
