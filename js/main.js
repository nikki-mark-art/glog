(function() {
  var glog;

  glog = (function() {
    'use strict';
    var cbGists, getFiles, gistIds, github, sortGistsByDate, user;

    function glog() {}

    glog.config = {};

    window.glog = glog;

    gistIds = [];

    sortGistsByDate = function(gists) {
      if (gists == null) {
        gists = gistIds;
      }
      return gists.sort(function(a, b) {
        return new Date(b.time) - new Date(a.time);
      });
    };

    getFiles = function(gists) {
      var gist, id, item, _i, _len, _results;
      if (gists == null) {
        gists = gistIds;
      }
      _results = [];
      for (_i = 0, _len = gists.length; _i < _len; _i++) {
        item = gists[_i];
        id = item.id;
        gist = github.getGist(id);
        console.info("Fetching gist #" + id + "...");
        _results.push(gist.read(function(err, content) {
          var div, file, html, name, _ref;
          if (!err) {
            console.info("[OK] Fetched gist #" + id);
            html = '';
            _ref = content.files;
            for (name in _ref) {
              file = _ref[name];
              if (file.language === 'Markdown') {
                html += marked.parse(file.content);
              }
            }
            console.info("Appending parsed gist #" + id);
            div = document.createElement('div');
            if (html && html.length) {
              div.innerHTML = html;
              div.setAttribute('class', 'post');
              return document.body.appendChild(div);
            }
          } else {
            return console.info("[!] Couldn't fetch gist #" + gist.id);
          }
        }));
      }
      return _results;
    };

    cbGists = function(err, gists) {
      var gist, _i, _len;
      if (err) {
        console.error(err);
      } else {
        for (_i = 0, _len = gists.length; _i < _len; _i++) {
          gist = gists[_i];
          console.info("gist ID ->", gist.id);
          gistIds.push({
            id: gist.id,
            time: gist.updated_at
          });
        }
      }
      return getFiles(sortGistsByDate(gistIds));
    };

    console.log("Using token " + config.token);

    github = new Github({
      token: config.token,
      auth: "oauth"
    });

    user = github.getUser();

    user.userGists(config.username, cbGists);

    return glog;

  })();

}).call(this);
