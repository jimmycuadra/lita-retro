# lita-retro

[![Build Status](https://travis-ci.org/jimmycuadra/lita-retro.png?branch=master)](https://travis-ci.org/jimmycuadra/lita-retro)
[![Code Climate](https://codeclimate.com/github/jimmycuadra/lita-retro.png)](https://codeclimate.com/github/jimmycuadra/lita-retro)
[![Coverage Status](https://coveralls.io/repos/jimmycuadra/lita-retro/badge.png)](https://coveralls.io/r/jimmycuadra/lita-retro)

**lita-retro** is a [Lita](https://www.lita.io/) handler that helps manage topics for regular team retrospective meetings.

## Installation

Add lita-retro to your Lita instance's Gemfile:

``` ruby
gem "lita-retro"
```

## Usage

Throughout the week, team members may think of things they'd like to discuss at the next team retro. They can store their topic ideas with Lita and Lita will list all the topics when it comes time to meet and discuss them. Topics can be classified as good, bad, or neutral, signified by a happy face, a sad face, or a straight face, respectively.

Now it's possible each team to have the lita retro at your channel/room

```
Carl: Lita retro :) Our new documentation was super useful!
Lita: Good topic added!
Henry: Lita retro :( There were too many interruptions.
Lita: Bad topic added!
Sophie: Lita retro :| What are we supposed to do during downtime?
Lita: Neutral topic added!
```

Alternatively you could use `+`, `-`, and `=` instead of smiles.

When it's time for the retro, ask Lita to list all the topics for you.

```
You: Lita retro list
Lita: Good topic from Carl: Our new documentation was super useful!
      Bad topic from Henry: There were too many interruptions.
      Neutral topic from Sophie: What are we supposed to do during downtime?
```

After the meeting, clear the topics and begin collecting them for the following week. Only users in the `:retro_admins` authorization group can do this.

```
You: Lita retro clear
Lita: Cleared all topics!
You: Lita retro list
Lita: There are no retrospective topics yet.
```

To add users to the `:retro_admins` authorization group, see the documentation at [http://docs.lita.io/getting-started/usage/#authorization-groups](http://docs.lita.io/getting-started/usage/#authorization-groups)

## License

[MIT](http://opensource.org/licenses/MIT)
