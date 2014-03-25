#Simple shell script that gets the current playing song in Spotify and returns the lyrics.

# Get information from Spotify via AppleScript and store it in shell variables:
IFS='|' read -r theArtist theName <<<"$(osascript <<<'tell application "Spotify"
        set theTrack to current track
        set theArtist to artist of theTrack
        set theName to name of theTrack
        return theArtist & "|" & theName
    end tell')"

# Create *encoded* versions of the artist and track name for inclusion in a URL:
theArtistEnc=$(perl -MURI::Escape -ne 'print uri_escape($_)' <<<"$theArtist")
theNameEnc=$(perl -MURI::Escape -ne 'print uri_escape($_)' <<<"$theName")

# Retrieve lyrics via `curl`:
lyrics=$(curl -s "http://makeitpersonal.co/lyrics?artist=$theArtistEnc&title=$theNameEnc")

# Output the results result:
echo -e "$theArtist - $theName\n$lyrics"
