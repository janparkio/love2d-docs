## Beginner friendly LÖVE 2D documentation
Welcome to the beginner friendly love2d documentation. Here you'll find a group of examples and neat implementation of this beautiful game framework. Follow me in this exciting journey to becoming a game developer, put on your seatbelt and enojoy the ride. (Seriusly, please put on that seatbelt the road is a little rough).

### What is LÖVE?
LÖVE is an *awesome* framework you can use to make 2D games in Lua. It's free, open-source, and works on Windows, Mac OS X, Linux, Android and iOS. Source: [love2d.org](https://love2d.org/)

> If you really want to know more details about this *wonderful framework* go to "[Is LÖVE good for me?](http://#)."

### Getting started
Let us begin with the very basics, downloading **love2d** to your desktop from [the download site](https://love2d.org/#download).

<img alt-text="Mouse clicking the download site" src="site/img/love2d-download-page.gif">

Choose the appropiate link for your current desired operating system. In my case it would be macOS, but don't worry there are no perticular differences between the two other than the way of opening the files. I'll go throw the process of using both Windows and macOs versions on this quick [installation process](####installation-process) below.

#### Installation Process

```lua
    function love.draw()
        love.graphics.rectangle(10, 10, 100, 100)
    end
```
