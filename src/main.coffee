class glog
    'use strict'

    @config = {}
    window.glog = @
    gistIds = []

    sortGistsByDate = (gists = gistIds) ->
        # Sort gists by date desc.
        return gists.sort (a, b) ->
            return (new Date(b.time) - new Date(a.time))

    getFiles = (gists = gistIds) ->
        # Parse all gists
        for item in gists
            id = item.id
            gist = github.getGist id
            console.info "Fetching gist ##{id}..."

            gist.read (err, content) ->
                if not err
                    console.info "[OK] Fetched gist ##{id}"

                    html = ''
                    for name, file of content.files
                        if file.language is 'Markdown'
                            html += marked.parse file.content

                    console.info "Appending parsed gist ##{id}"
                    div = document.createElement 'div'

                    if html and html.length
                        div.innerHTML = html
                        div.setAttribute 'class', 'post'
                        # or div.attributes.item("class").nodeValue = 'post'
                        document.body.appendChild div

                else
                    console.info "[!] Couldn't fetch gist ##{gist.id}"

    cbGists = (err, gists) ->
        # Fetch all gists
        if err
            console.error err
        else
            for gist in gists
                console.info "gist ID ->", gist.id
                gistIds.push {id: gist.id, time: gist.updated_at}

        # Sort by date and process
        getFiles sortGistsByDate gistIds

    console.log "Using token #{config.token}"

    github = new Github
        token: config.token
        auth: "oauth"

    user = github.getUser()
    user.userGists config.username, cbGists
    # user.gists cbGists

